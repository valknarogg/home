#!/bin/bash
# =================================================================
# Apply Integration Script - Kompose Service Integration
# =================================================================
# This script applies the integration enhancements to a specific service
# =================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
INTEGRATION_DIR="$PROJECT_ROOT/INTEGRATION"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[i]${NC} $1"
}

# Function to show usage
usage() {
    cat << EOF
Usage: $0 <service> [--dry-run]

Apply integration enhancements to a Kompose service.

Services:
  link      - Linkwarden (bookmark manager)
  news      - Letterpress (news/newsletter)
  track     - Umami (analytics)
  vault     - Vaultwarden (password manager)
  watch     - Monitoring stack
  all       - Apply to all services

Options:
  --dry-run     Show what would be done without making changes
  --backup      Create backup before applying (default)
  --no-backup   Skip backup creation
  -h, --help    Show this help message

Examples:
  $0 link                    # Apply integration to Linkwarden
  $0 all                     # Apply to all services
  $0 link --dry-run          # Preview changes for Linkwarden
  $0 vault --no-backup       # Apply without backup

EOF
    exit 1
}

# Function to backup current configuration
backup_config() {
    local service=$1
    local service_dir="$PROJECT_ROOT/+utility/$service"
    local backup_dir="$PROJECT_ROOT/+utility/$service/backup_$(date +%Y%m%d_%H%M%S)"
    
    if [ -d "$service_dir" ]; then
        print_info "Creating backup of $service configuration..."
        mkdir -p "$backup_dir"
        
        if [ -f "$service_dir/compose.yaml" ]; then
            cp "$service_dir/compose.yaml" "$backup_dir/"
        fi
        
        if [ -f "$service_dir/.env" ]; then
            cp "$service_dir/.env" "$backup_dir/"
        fi
        
        print_status "Backup created at: $backup_dir"
    fi
}

# Function to apply integration to a service
apply_integration() {
    local service=$1
    local dry_run=$2
    local service_dir="$PROJECT_ROOT/+utility/$service"
    local enhanced_compose="$INTEGRATION_DIR/compose/${service}-enhanced.yaml"
    
    print_info "Applying integration to $service..."
    
    # Check if enhanced compose exists
    if [ ! -f "$enhanced_compose" ]; then
        print_error "Enhanced compose file not found: $enhanced_compose"
        return 1
    fi
    
    # Check if service directory exists
    if [ ! -d "$service_dir" ]; then
        print_error "Service directory not found: $service_dir"
        return 1
    fi
    
    if [ "$dry_run" = true ]; then
        print_info "DRY RUN: Would copy $enhanced_compose to $service_dir/compose.yaml"
        print_info "DRY RUN: Would update environment variables"
        return 0
    fi
    
    # Copy enhanced compose file
    cp "$enhanced_compose" "$service_dir/compose.yaml"
    print_status "Updated compose.yaml for $service"
    
    # Update .env file with integration variables
    update_env_file "$service" "$service_dir/.env"
    
    # Create metrics directory if needed
    if [ ! -d "$service_dir/metrics" ]; then
        mkdir -p "$service_dir/metrics"
        print_status "Created metrics directory for $service"
    fi
    
    print_status "Integration applied to $service"
}

# Function to update environment file
update_env_file() {
    local service=$1
    local env_file=$2
    
    if [ ! -f "$env_file" ]; then
        print_warning ".env file not found for $service"
        return 0
    fi
    
    # Add integration-specific variables if not present
    if ! grep -q "MQTT_ENABLED" "$env_file"; then
        cat >> "$env_file" << 'EOF'

# =================================================================
# Integration Settings (Added by apply-integration.sh)
# =================================================================

# MQTT Event Publishing
MQTT_ENABLED=true

# Redis Integration (if applicable)
# REDIS_CACHE_ENABLED=true

EOF
        print_status "Added integration variables to .env for $service"
    fi
}

# Function to apply monitoring configuration
apply_monitoring() {
    local dry_run=$1
    local watch_dir="$PROJECT_ROOT/+utility/watch"
    
    print_info "Applying monitoring configuration..."
    
    if [ "$dry_run" = true ]; then
        print_info "DRY RUN: Would update Prometheus configuration"
        print_info "DRY RUN: Would update Alertmanager configuration"
        print_info "DRY RUN: Would import Grafana dashboards"
        return 0
    fi
    
    # Copy Prometheus config
    if [ -d "$watch_dir/prometheus" ]; then
        cp "$INTEGRATION_DIR/monitoring/prometheus.yml" "$watch_dir/prometheus/"
        cp "$INTEGRATION_DIR/monitoring/alerts.yml" "$watch_dir/prometheus/alerts/"
        print_status "Updated Prometheus configuration"
    fi
    
    # Copy Alertmanager config
    if [ -d "$watch_dir/alertmanager" ]; then
        cp "$INTEGRATION_DIR/monitoring/alertmanager.yml" "$watch_dir/alertmanager/"
        print_status "Updated Alertmanager configuration"
    fi
    
    # Copy Grafana dashboards
    if [ -d "$watch_dir/grafana/dashboards" ]; then
        cp "$INTEGRATION_DIR/monitoring/grafana-"*.json "$watch_dir/grafana/dashboards/"
        print_status "Imported Grafana dashboards"
    fi
}

# Main script logic
main() {
    local service=""
    local dry_run=false
    local do_backup=true
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            link|news|track|vault|watch|all)
                service="$1"
                shift
                ;;
            --dry-run)
                dry_run=true
                shift
                ;;
            --backup)
                do_backup=true
                shift
                ;;
            --no-backup)
                do_backup=false
                shift
                ;;
            -h|--help)
                usage
                ;;
            *)
                print_error "Unknown option: $1"
                usage
                ;;
        esac
    done
    
    # Check if service was specified
    if [ -z "$service" ]; then
        print_error "No service specified"
        usage
    fi
    
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    echo "  Kompose Service Integration - Apply Script"
    echo "═══════════════════════════════════════════════════════════════"
    echo ""
    
    if [ "$dry_run" = true ]; then
        print_warning "DRY RUN MODE - No changes will be made"
        echo ""
    fi
    
    # Apply to all services or specific service
    if [ "$service" = "all" ]; then
        print_info "Applying integration to all services..."
        echo ""
        
        for svc in link news track vault; do
            if [ "$do_backup" = true ] && [ "$dry_run" = false ]; then
                backup_config "$svc"
            fi
            apply_integration "$svc" $dry_run
            echo ""
        done
        
        apply_monitoring $dry_run
    else
        if [ "$do_backup" = true ] && [ "$dry_run" = false ]; then
            backup_config "$service"
        fi
        
        apply_integration "$service" $dry_run
        
        if [ "$service" = "watch" ]; then
            apply_monitoring $dry_run
        fi
    fi
    
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    
    if [ "$dry_run" = false ]; then
        print_status "Integration applied successfully!"
        echo ""
        print_info "Next steps:"
        echo "  1. Review the changes in your service directories"
        echo "  2. Update secrets.env with any required credentials"
        echo "  3. Restart the services: ./kompose.sh restart $service"
        echo "  4. Verify integration: ./scripts/verify-integration.sh $service"
    else
        print_info "This was a dry run. Use without --dry-run to apply changes."
    fi
    
    echo ""
}

main "$@"
