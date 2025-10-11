#!/bin/bash
# =================================================================
# Rollback Integration Script
# =================================================================
# Rolls back to the previous configuration before integration
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
NC='\033[0m'

print_header() {
    echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║  $1${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
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

# Find backup directory
find_backup() {
    local backup_file="$INTEGRATION_DIR/.last_backup"
    
    if [ -f "$backup_file" ]; then
        cat "$backup_file"
    else
        # Find most recent backup
        local backup_dir=$(find "$PROJECT_ROOT/backups" -type d -name "integration_*" 2>/dev/null | sort -r | head -n 1)
        echo "$backup_dir"
    fi
}

# Restore from backup
restore_from_backup() {
    local backup_dir=$1
    
    if [ ! -d "$backup_dir" ]; then
        print_error "Backup directory not found: $backup_dir"
        return 1
    fi
    
    print_step "Restoring from backup: $backup_dir"
    echo ""
    
    # Stop services first
    print_step "Stopping services..."
    for service in link news track vault watch; do
        local service_dir="$PROJECT_ROOT/+utility/$service"
        if [ -d "$service_dir" ] && [ -f "$service_dir/compose.yaml" ]; then
            cd "$service_dir"
            docker compose down 2>/dev/null || true
            print_success "  Stopped $service"
        fi
    done
    cd "$PROJECT_ROOT"
    echo ""
    
    # Restore service configurations
    print_step "Restoring service configurations..."
    for service in link news track vault watch; do
        local backup_service_dir="$backup_dir/$service"
        local target_service_dir="$PROJECT_ROOT/+utility/$service"
        
        if [ -d "$backup_service_dir" ]; then
            print_step "  Restoring $service..."
            
            # Backup current state before restoring
            if [ -d "$target_service_dir" ]; then
                mv "$target_service_dir" "${target_service_dir}.pre-rollback.$(date +%Y%m%d_%H%M%S)"
            fi
            
            # Copy backup
            cp -r "$backup_service_dir" "$target_service_dir"
            print_success "  $service configuration restored"
        fi
    done
    echo ""
    
    # Restore Traefik middleware
    if [ -d "$backup_dir/proxy_dynamic" ]; then
        print_step "Restoring Traefik middleware..."
        local proxy_dynamic="$PROJECT_ROOT/proxy/dynamic"
        
        if [ -d "$proxy_dynamic" ]; then
            mv "$proxy_dynamic" "${proxy_dynamic}.pre-rollback.$(date +%Y%m%d_%H%M%S)"
        fi
        
        cp -r "$backup_dir/proxy_dynamic" "$proxy_dynamic"
        print_success "Traefik middleware restored"
        
        # Restart Traefik
        docker restart proxy_app 2>/dev/null || print_warning "Could not restart Traefik"
    fi
    echo ""
    
    # Restart services
    print_step "Restarting services..."
    for service in link news track vault watch; do
        local service_dir="$PROJECT_ROOT/+utility/$service"
        if [ -d "$service_dir" ] && [ -f "$service_dir/compose.yaml" ]; then
            cd "$service_dir"
            docker compose up -d 2>/dev/null || print_warning "  Could not start $service"
            print_success "  Started $service"
        fi
    done
    cd "$PROJECT_ROOT"
    echo ""
}

# List available backups
list_backups() {
    print_header "Available Backups"
    
    local backups=$(find "$PROJECT_ROOT/backups" -type d -name "integration_*" 2>/dev/null | sort -r)
    
    if [ -z "$backups" ]; then
        print_warning "No backups found"
        return 1
    fi
    
    local i=1
    while IFS= read -r backup; do
        local backup_name=$(basename "$backup")
        local backup_date=$(echo "$backup_name" | sed 's/integration_//')
        echo "  [$i] $backup_name ($(date -d "${backup_date:0:8} ${backup_date:9}" '+%Y-%m-%d %H:%M:%S' 2>/dev/null || echo $backup_date))"
        ((i++))
    done <<< "$backups"
    
    echo ""
}

# Interactive mode
interactive_rollback() {
    list_backups
    
    local backups=$(find "$PROJECT_ROOT/backups" -type d -name "integration_*" 2>/dev/null | sort -r)
    local backup_count=$(echo "$backups" | wc -l)
    
    if [ $backup_count -eq 0 ]; then
        return 1
    fi
    
    echo -n "Select backup to restore [1-$backup_count] or 'q' to quit: "
    read -r selection
    
    if [ "$selection" = "q" ] || [ "$selection" = "Q" ]; then
        print_warning "Rollback cancelled"
        return 0
    fi
    
    if ! [[ "$selection" =~ ^[0-9]+$ ]] || [ "$selection" -lt 1 ] || [ "$selection" -gt "$backup_count" ]; then
        print_error "Invalid selection"
        return 1
    fi
    
    local selected_backup=$(echo "$backups" | sed -n "${selection}p")
    
    echo ""
    print_warning "This will restore all services to the state from:"
    echo "  $selected_backup"
    echo ""
    echo -n "Are you sure you want to continue? (yes/no): "
    read -r confirmation
    
    if [ "$confirmation" != "yes" ]; then
        print_warning "Rollback cancelled"
        return 0
    fi
    
    echo ""
    restore_from_backup "$selected_backup"
}

# Main function
main() {
    clear
    
    print_header "Kompose Integration Rollback"
    
    if [ "$1" = "--auto" ]; then
        # Automatic rollback using last backup
        local backup_dir=$(find_backup)
        
        if [ -z "$backup_dir" ]; then
            print_error "No backup found"
            exit 1
        fi
        
        print_warning "Automatic rollback using last backup:"
        echo "  $backup_dir"
        echo ""
        
        restore_from_backup "$backup_dir"
    else
        # Interactive mode
        interactive_rollback
    fi
    
    echo ""
    print_header "Rollback Complete"
    
    cat << 'EOF'
Services have been rolled back to the previous configuration.

Next Steps:
  1. Verify services are running: docker ps
  2. Check logs for any errors: docker compose logs -f
  3. Test service functionality

If issues persist:
  • Check service logs in +utility/<service>/
  • Verify environment variables in .env files
  • Ensure core services (PostgreSQL, Redis, MQTT) are running

EOF
}

main "$@"
