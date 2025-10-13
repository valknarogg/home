#!/bin/bash

# ===================================================================
# Kompose Local Development Mode Manager
# ===================================================================
# This script helps you switch between local and production configs
# ===================================================================

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_ROOT"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_header() {
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Check current mode
get_current_mode() {
    if [ -f ".env" ] && grep -q "localhost" ".env" 2>/dev/null; then
        echo "local"
    elif [ -f ".env" ]; then
        echo "production"
    else
        echo "none"
    fi
}

# Backup current configuration
backup_config() {
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_dir="backups/config_backup_${timestamp}"
    
    mkdir -p "$backup_dir"
    
    if [ -f ".env" ]; then
        cp ".env" "$backup_dir/.env"
        print_success "Backed up .env"
    fi
    
    if [ -f "domain.env" ]; then
        cp "domain.env" "$backup_dir/domain.env"
        print_success "Backed up domain.env"
    fi
    
    if [ -f "secrets.env" ]; then
        cp "secrets.env" "$backup_dir/secrets.env"
        print_success "Backed up secrets.env"
    fi
    
    echo "$backup_dir"
}

# Switch to local mode
switch_to_local() {
    print_header "Switching to Local Development Mode"
    
    # Backup current config
    print_info "Creating backup of current configuration..."
    backup_dir=$(backup_config)
    print_success "Backup created: $backup_dir"
    echo ""
    
    # Check if local configs exist
    if [ ! -f ".env.local" ]; then
        print_error ".env.local not found!"
        echo "Please ensure .env.local exists in the project root."
        exit 1
    fi
    
    if [ ! -f "domain.env.local" ]; then
        print_error "domain.env.local not found!"
        echo "Please ensure domain.env.local exists in the project root."
        exit 1
    fi
    
    # Copy local configs
    print_info "Activating local configuration..."
    cp ".env.local" ".env"
    cp "domain.env.local" "domain.env"
    print_success "Local configuration activated"
    echo ""
    
    # Create local secrets if needed
    if [ ! -f "secrets.env" ]; then
        print_warning "secrets.env not found, creating from template..."
        if [ -f "secrets.env.template" ]; then
            cp "secrets.env.template" "secrets.env"
            print_info "Please edit secrets.env with your local development secrets"
        fi
    fi
    
    echo ""
    print_success "Switched to LOCAL mode"
    echo ""
    show_local_info
}

# Switch to production mode
switch_to_production() {
    print_header "Switching to Production Mode"
    
    # Backup current config
    print_info "Creating backup of current configuration..."
    backup_dir=$(backup_config)
    print_success "Backup created: $backup_dir"
    echo ""
    
    # Check if production configs exist
    if [ ! -f ".env.production" ] && [ ! -f "$backup_dir/.env" ]; then
        print_error "No production configuration found!"
        echo "Please ensure you have either:"
        echo "  1. .env.production file, or"
        echo "  2. A backup of your production .env"
        exit 1
    fi
    
    # Restore from backup or use .env.production
    print_info "Activating production configuration..."
    if [ -f ".env.production" ]; then
        cp ".env.production" ".env"
        print_success "Restored from .env.production"
    else
        print_warning "No .env.production found, keeping current .env"
    fi
    
    if [ -f "domain.env.production" ]; then
        cp "domain.env.production" "domain.env"
        print_success "Restored from domain.env.production"
    else
        print_warning "No domain.env.production found, keeping current domain.env"
    fi
    
    echo ""
    print_success "Switched to PRODUCTION mode"
    echo ""
    show_production_info
}

# Show current mode
show_status() {
    local mode=$(get_current_mode)
    
    print_header "Configuration Status"
    echo ""
    
    case $mode in
        local)
            print_success "Current Mode: LOCAL DEVELOPMENT"
            echo ""
            show_local_info
            ;;
        production)
            print_success "Current Mode: PRODUCTION"
            echo ""
            show_production_info
            ;;
        none)
            print_warning "No configuration detected"
            echo ""
            echo "Run one of:"
            echo "  ./kompose-local.sh local    - Switch to local mode"
            echo "  ./kompose-local.sh prod     - Switch to production mode"
            ;;
    esac
}

# Show local development info
show_local_info() {
    print_info "Local Development Services:"
    echo ""
    echo "  Core Services:"
    echo "    PostgreSQL:      localhost:5432"
    echo "    Redis:           localhost:6379"
    echo "    MQTT:            localhost:1883"
    echo ""
    echo "  Main Applications:"
    echo "    Keycloak:        http://localhost:8180"
    echo "    KMPS:            http://localhost:3100"
    echo "    Gitea:           http://localhost:3001"
    echo "    n8n:             http://localhost:5678"
    echo "    Home Assistant:  http://localhost:8123"
    echo "    Directus:        http://localhost:8055"
    echo ""
    echo "  Start services:"
    echo "    ./kompose.sh up core      # Start core services"
    echo "    ./kompose.sh up auth      # Start Keycloak"
    echo "    ./kompose.sh up kmps      # Start KMPS"
    echo ""
}

# Show production info
show_production_info() {
    # Try to get domain from domain.env
    local domain="yourdomain.com"
    if [ -f "domain.env" ]; then
        domain=$(grep "^ROOT_DOMAIN=" domain.env | cut -d'=' -f2)
    fi
    
    print_info "Production Services (${domain}):"
    echo ""
    echo "  Main Applications:"
    echo "    Keycloak:        https://auth.${domain}"
    echo "    KMPS:            https://manage.${domain}"
    echo "    Gitea:           https://code.${domain}"
    echo "    n8n:             https://chain.${domain}"
    echo "    Home Assistant:  https://home.${domain}"
    echo ""
    echo "  Start services:"
    echo "    ./kompose.sh up core      # Start core services"
    echo "    ./kompose.sh up proxy     # Start Traefik"
    echo "    ./kompose.sh up auth      # Start Keycloak"
    echo "    ./kompose.sh up kmps      # Start KMPS"
    echo ""
}

# Save current config as production
save_as_production() {
    print_header "Saving Current Configuration as Production"
    echo ""
    
    if [ -f ".env" ]; then
        cp ".env" ".env.production"
        print_success "Saved .env as .env.production"
    fi
    
    if [ -f "domain.env" ]; then
        cp "domain.env" "domain.env.production"
        print_success "Saved domain.env as domain.env.production"
    fi
    
    echo ""
    print_success "Production configuration saved"
}

# Generate environment files for a specific stack
generate_stack_env() {
    local stack=$1
    print_info "Generating environment for stack: $stack"
    
    if [ -f "${stack}/.env.generated" ]; then
        rm "${stack}/.env.generated"
    fi
    
    # This will be handled by kompose.sh
    ./kompose.sh env "$stack"
}

# Show help
show_help() {
    cat << EOF
Kompose Local Development Mode Manager

Usage:
  ./kompose-local.sh <command>

Commands:
  local          Switch to local development mode
  prod           Switch to production mode
  status         Show current configuration mode
  save-prod      Save current config as production default
  backup         Create backup of current configuration
  help           Show this help message

Examples:
  # Switch to local development
  ./kompose-local.sh local

  # Check current mode
  ./kompose-local.sh status

  # Switch back to production
  ./kompose-local.sh prod

  # Save current config as production default
  ./kompose-local.sh save-prod

Local Mode:
  - Services accessible via localhost:PORT
  - No domain names or SSL needed
  - Direct database connections
  - Simplified configuration

Production Mode:
  - Services accessible via subdomains
  - SSL/TLS with Let's Encrypt
  - Traefik reverse proxy
  - OAuth2 SSO authentication

For more information, see:
  - docs/LOCAL_DEVELOPMENT.md
  - kmps/DEVELOPMENT.md

EOF
}

# Main script
main() {
    local command=${1:-status}
    
    case $command in
        local|dev)
            switch_to_local
            ;;
        prod|production)
            switch_to_production
            ;;
        status|show)
            show_status
            ;;
        save-prod|save)
            save_as_production
            ;;
        backup)
            print_header "Creating Backup"
            backup_dir=$(backup_config)
            print_success "Backup created: $backup_dir"
            ;;
        help|-h|--help)
            show_help
            ;;
        *)
            print_error "Unknown command: $command"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

# Run main
main "$@"
