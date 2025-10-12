#!/bin/bash
# =================================================================
# Complete Integration Deployment Script
# =================================================================
# This script performs a full deployment of the Kompose integration
# =================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
INTEGRATION_DIR="$PROJECT_ROOT/INTEGRATION"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Functions
print_header() {
    echo -e "${CYAN}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║  $1${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_step() {
    echo -e "${BLUE}▶ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}! $1${NC}"
}

# Check prerequisites
check_prerequisites() {
    print_step "Checking prerequisites..."
    
    local missing=0
    
    # Check Docker
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed"
        ((missing++))
    else
        print_success "Docker found"
    fi
    
    # Check Docker Compose
    if ! command -v docker compose &> /dev/null; then
        print_error "Docker Compose is not installed"
        ((missing++))
    else
        print_success "Docker Compose found"
    fi
    
    # Check if core services are running
    if ! docker ps | grep -q "core-postgres"; then
        print_warning "PostgreSQL (core-postgres) is not running"
    else
        print_success "PostgreSQL is running"
    fi
    
    if ! docker ps | grep -q "core-redis"; then
        print_warning "Redis (core-redis) is not running"
    else
        print_success "Redis is running"
    fi
    
    if ! docker ps | grep -q "core-mqtt"; then
        print_warning "MQTT (core-mqtt) is not running"
    else
        print_success "MQTT broker is running"
    fi
    
    if [ $missing -gt 0 ]; then
        print_error "Missing required prerequisites. Please install them first."
        exit 1
    fi
    
    echo ""
}

# Create backups
create_backups() {
    print_step "Creating backups of current configurations..."
    
    local backup_dir="$PROJECT_ROOT/backups/integration_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    
    for service in link news track vault watch; do
        local service_dir="$PROJECT_ROOT/+utility/$service"
        if [ -d "$service_dir" ]; then
            print_step "  Backing up $service..."
            cp -r "$service_dir" "$backup_dir/"
            print_success "  $service backed up"
        fi
    done
    
    # Backup proxy config
    if [ -d "$PROJECT_ROOT/proxy/dynamic" ]; then
        print_step "  Backing up Traefik middleware..."
        cp -r "$PROJECT_ROOT/proxy/dynamic" "$backup_dir/proxy_dynamic"
        print_success "  Traefik middleware backed up"
    fi
    
    print_success "Backups created at: $backup_dir"
    echo "$backup_dir" > "$INTEGRATION_DIR/.last_backup"
    echo ""
}

# Apply middleware configuration
apply_middleware() {
    print_step "Applying Traefik middleware configuration..."
    
    local proxy_dynamic="$PROJECT_ROOT/proxy/dynamic"
    mkdir -p "$proxy_dynamic"
    
    cp "$INTEGRATION_DIR/middleware/middlewares.yml" "$proxy_dynamic/"
    print_success "Middleware configuration applied"
    
    # Restart Traefik to load new config
    print_step "  Restarting Traefik..."
    docker restart proxy_app 2>/dev/null || print_warning "  Could not restart Traefik (may not be running)"
    
    echo ""
}

# Apply monitoring configuration
apply_monitoring() {
    print_step "Applying monitoring configuration..."
    
    local watch_dir="$PROJECT_ROOT/+utility/watch"
    
    if [ ! -d "$watch_dir" ]; then
        print_warning "Watch stack directory not found, skipping monitoring config"
        return
    fi
    
    # Prometheus
    if [ -d "$watch_dir/prometheus" ]; then
        mkdir -p "$watch_dir/prometheus/alerts"
        cp "$INTEGRATION_DIR/monitoring/prometheus.yml" "$watch_dir/prometheus/"
        cp "$INTEGRATION_DIR/monitoring/alerts.yml" "$watch_dir/prometheus/alerts/"
        print_success "  Prometheus configuration applied"
    fi
    
    # Alertmanager
    if [ -d "$watch_dir/alertmanager" ]; then
        cp "$INTEGRATION_DIR/monitoring/alertmanager.yml" "$watch_dir/alertmanager/"
        print_success "  Alertmanager configuration applied"
    fi
    
    # Grafana dashboards
    if [ -d "$watch_dir/grafana/dashboards" ]; then
        cp "$INTEGRATION_DIR/monitoring/grafana-"*.json "$watch_dir/grafana/dashboards/"
        print_success "  Grafana dashboards imported"
    fi
    
    echo ""
}

# Apply service integrations
apply_service_integration() {
    local service=$1
    local service_dir="$PROJECT_ROOT/+utility/$service"
    local enhanced_compose="$INTEGRATION_DIR/compose/${service}-enhanced.yaml"
    
    if [ ! -f "$enhanced_compose" ]; then
        print_warning "Enhanced compose file not found for $service"
        return 1
    fi
    
    if [ ! -d "$service_dir" ]; then
        print_warning "Service directory not found for $service"
        return 1
    fi
    
    print_step "  Applying integration to $service..."
    
    # Copy enhanced compose
    cp "$enhanced_compose" "$service_dir/compose.yaml"
    
    # Update .env if needed
    if [ -f "$service_dir/.env" ]; then
        if ! grep -q "MQTT_ENABLED" "$service_dir/.env"; then
            cat >> "$service_dir/.env" << 'EOF'

# Integration Settings
MQTT_ENABLED=true

EOF
        fi
    fi
    
    # Create metrics directory
    mkdir -p "$service_dir/metrics"
    
    print_success "  $service integration applied"
}

# Apply all service integrations
apply_all_services() {
    print_step "Applying service integrations..."
    echo ""
    
    for service in link news track vault; do
        apply_service_integration "$service"
    done
    
    echo ""
}

# Restart services
restart_services() {
    print_step "Restarting services..."
    echo ""
    
    cd "$PROJECT_ROOT"
    
    for service in link news track vault watch; do
        local service_dir="+utility/$service"
        
        if [ -d "$service_dir" ] && [ -f "$service_dir/compose.yaml" ]; then
            print_step "  Restarting $service..."
            cd "$service_dir"
            
            if docker compose down 2>/dev/null; then
                print_success "    Stopped $service"
            fi
            
            if docker compose up -d 2>/dev/null; then
                print_success "    Started $service"
            else
                print_error "    Failed to start $service"
            fi
            
            cd "$PROJECT_ROOT"
        fi
    done
    
    echo ""
}

# Verify deployment
verify_deployment() {
    print_step "Verifying deployment..."
    echo ""
    
    sleep 5  # Give services time to start
    
    local failed=0
    
    # Check core services
    for service in core-postgres core-redis core-mqtt; do
        if docker ps | grep -q "$service"; then
            print_success "  $service is running"
        else
            print_error "  $service is NOT running"
            ((failed++))
        fi
    done
    
    # Check utility services
    for service in link_app news_backend track_app vault_app; do
        if docker ps | grep -q "$service"; then
            print_success "  $service is running"
        else
            print_warning "  $service is not running (may be expected)"
        fi
    done
    
    # Check monitoring stack
    for service in watch_prometheus watch_grafana; do
        if docker ps | grep -q "$service"; then
            print_success "  $service is running"
        else
            print_warning "  $service is not running (may be expected)"
        fi
    done
    
    echo ""
    
    if [ $failed -gt 0 ]; then
        print_error "Some core services are not running. Please check logs."
        return 1
    else
        print_success "All core services are running!"
        return 0
    fi
}

# Print post-deployment instructions
print_instructions() {
    print_header "Deployment Complete!"
    
    cat << 'EOF'
Next Steps:

1. 📝 Configure Secrets
   Edit your secrets.env file and add:
   - MQTT_ENABLED=true
   - MQTT_BROKER=core-mqtt
   - REDIS_PASSWORD=<your-redis-password>
   - GOTIFY_APP_TOKEN=<create-in-gotify-ui>
   
2. 🔐 Configure SSO
   • Access Keycloak: https://auth.yourdomain.com
   • Create service accounts for each utility service
   • Update OAuth2 client secrets in secrets.env

3. 📊 Access Monitoring
   • Prometheus: http://localhost:9090
   • Grafana: http://localhost:3001
     Username: admin
     Password: <from GRAFANA_ADMIN_PASSWORD>
   • Alertmanager: http://localhost:9093

4. 🔍 Verify Integration
   Run: ./INTEGRATION/scripts/verify-integration.sh all

5. 📚 Documentation
   • Integration Guide: INTEGRATION/INTEGRATION_GUIDE.md
   • Network Wiring: INTEGRATION/NETWORK_WIRING.md
   • MQTT Events: INTEGRATION/mqtt/EVENT_SCHEMAS.md

6. 🔄 Rollback (if needed)
   Your backup is at:
EOF

    if [ -f "$INTEGRATION_DIR/.last_backup" ]; then
        cat "$INTEGRATION_DIR/.last_backup"
    else
        echo "   (backup location not found)"
    fi
    
    echo ""
    echo "═══════════════════════════════════════════════════════════"
    echo ""
}

# Main deployment flow
main() {
    clear
    
    print_header "Kompose Complete Integration Deployment"
    
    echo "This script will:"
    echo "  1. Check prerequisites"
    echo "  2. Create backups of current configurations"
    echo "  3. Apply Traefik middleware configuration"
    echo "  4. Apply monitoring configuration (Prometheus, Grafana, Alertmanager)"
    echo "  5. Apply service integrations (Linkwarden, Letterpress, Umami, Vaultwarden)"
    echo "  6. Restart all services"
    echo "  7. Verify deployment"
    echo ""
    
    read -p "Do you want to continue? (y/N) " -n 1 -r
    echo ""
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_warning "Deployment cancelled"
        exit 0
    fi
    
    echo ""
    
    # Execute deployment steps
    check_prerequisites
    create_backups
    apply_middleware
    apply_monitoring
    apply_all_services
    restart_services
    verify_deployment
    
    # Print final instructions
    echo ""
    print_instructions
}

# Run main function
main "$@"
