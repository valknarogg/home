#!/bin/bash

# kompose-setup.sh - Setup and initialization module
# Handles local/production mode switching and initial project setup

# ============================================================================
# SETUP MODE MANAGEMENT
# ============================================================================

# Get current configuration mode
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
        log_success "Backed up .env"
    fi
    
    if [ -f "domain.env" ]; then
        cp "domain.env" "$backup_dir/domain.env"
        log_success "Backed up domain.env"
    fi
    
    if [ -f "secrets.env" ]; then
        cp "secrets.env" "$backup_dir/secrets.env"
        log_success "Backed up secrets.env"
    fi
    
    echo "$backup_dir"
}

# Switch to local mode
switch_to_local() {
    log_info "Switching to Local Development Mode"
    
    # Backup current config
    log_info "Creating backup of current configuration..."
    backup_dir=$(backup_config)
    log_success "Backup created: $backup_dir"
    echo ""
    
    # Check if local configs exist
    if [ ! -f ".env.local" ]; then
        log_error ".env.local not found!"
        echo "Please ensure .env.local exists in the project root."
        exit 1
    fi
    
    if [ ! -f "domain.env.local" ]; then
        log_error "domain.env.local not found!"
        echo "Please ensure domain.env.local exists in the project root."
        exit 1
    fi
    
    # Copy local configs
    log_info "Activating local configuration..."
    cp ".env.local" ".env"
    cp "domain.env.local" "domain.env"
    log_success "Local configuration activated"
    echo ""
    
    # Create local secrets if needed
    if [ ! -f "secrets.env" ]; then
        log_warning "secrets.env not found, creating from template..."
        if [ -f "secrets.env.template" ]; then
            cp "secrets.env.template" "secrets.env"
            log_info "Please edit secrets.env with your local development secrets"
        fi
    fi
    
    echo ""
    log_success "Switched to LOCAL mode"
    echo ""
    show_local_info
}

# Switch to production mode
switch_to_production() {
    log_info "Switching to Production Mode"
    
    # Backup current config
    log_info "Creating backup of current configuration..."
    backup_dir=$(backup_config)
    log_success "Backup created: $backup_dir"
    echo ""
    
    # Check if production configs exist
    if [ ! -f ".env.production" ] && [ ! -f "$backup_dir/.env" ]; then
        log_error "No production configuration found!"
        echo "Please ensure you have either:"
        echo "  1. .env.production file, or"
        echo "  2. A backup of your production .env"
        exit 1
    fi
    
    # Restore from backup or use .env.production
    log_info "Activating production configuration..."
    if [ -f ".env.production" ]; then
        cp ".env.production" ".env"
        log_success "Restored from .env.production"
    else
        log_warning "No .env.production found, keeping current .env"
    fi
    
    if [ -f "domain.env.production" ]; then
        cp "domain.env.production" "domain.env"
        log_success "Restored from domain.env.production"
    else
        log_warning "No domain.env.production found, keeping current domain.env"
    fi
    
    echo ""
    log_success "Switched to PRODUCTION mode"
    echo ""
    show_production_info
}

# Show current status
show_setup_status() {
    local mode=$(get_current_mode)
    
    echo ""
    log_info "═══════════════════════════════════════"
    log_info "      Configuration Status"
    log_info "═══════════════════════════════════════"
    echo ""
    
    case $mode in
        local)
            log_success "Current Mode: LOCAL DEVELOPMENT"
            echo ""
            show_local_info
            ;;
        production)
            log_success "Current Mode: PRODUCTION"
            echo ""
            show_production_info
            ;;
        none)
            log_warning "No configuration detected"
            echo ""
            echo "Run one of:"
            echo "  ./kompose.sh setup local    - Switch to local mode"
            echo "  ./kompose.sh setup prod     - Switch to production mode"
            echo "  ./kompose.sh init           - Initialize project"
            ;;
    esac
}

# Show local development info
show_local_info() {
    log_info "Local Development Services:"
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
    
    log_info "Production Services (${domain}):"
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
    log_info "Saving Current Configuration as Production"
    echo ""
    
    if [ -f ".env" ]; then
        cp ".env" ".env.production"
        log_success "Saved .env as .env.production"
    fi
    
    if [ -f "domain.env" ]; then
        cp "domain.env" "domain.env.production"
        log_success "Saved domain.env as domain.env.production"
    fi
    
    echo ""
    log_success "Production configuration saved"
}

# ============================================================================
# DEPENDENCY CHECKING
# ============================================================================

check_dependency() {
    local dep=$1
    local name=$2
    local install_hint=$3
    
    if command -v "$dep" &> /dev/null; then
        local version=$($dep --version 2>&1 | head -n1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n1)
        log_success "$name: $version"
        return 0
    else
        log_error "$name: NOT FOUND"
        if [ -n "$install_hint" ]; then
            echo "  Install with: $install_hint"
        fi
        return 1
    fi
}

check_all_dependencies() {
    local all_ok=true
    
    log_info "Checking dependencies..."
    echo ""
    
    # Required dependencies
    if ! check_dependency "docker" "Docker" "https://docs.docker.com/get-docker/"; then
        all_ok=false
    fi
    
    if ! check_dependency "docker-compose" "Docker Compose" "Included with Docker Desktop"; then
        # Try docker compose (newer version)
        if docker compose version &> /dev/null; then
            log_success "Docker Compose: $(docker compose version --short)"
        else
            all_ok=false
        fi
    fi
    
    if ! check_dependency "git" "Git" "https://git-scm.com/downloads"; then
        all_ok=false
    fi
    
    # Optional but recommended
    echo ""
    log_info "Optional development dependencies:"
    check_dependency "node" "Node.js" "https://nodejs.org/" || true
    check_dependency "pnpm" "pnpm" "npm install -g pnpm" || true
    check_dependency "python3" "Python 3" "https://www.python.org/downloads/" || true
    
    echo ""
    
    if [ "$all_ok" = false ]; then
        log_error "Some required dependencies are missing!"
        return 1
    else
        log_success "All required dependencies are installed!"
        return 0
    fi
}

# ============================================================================
# PROJECT INITIALIZATION
# ============================================================================

init_project() {
    log_info "═══════════════════════════════════════════════════════════"
    log_info "       Kompose Project Initialization"
    log_info "═══════════════════════════════════════════════════════════"
    echo ""
    
    # Check dependencies
    if ! check_all_dependencies; then
        log_error "Please install missing dependencies before continuing"
        exit 1
    fi
    
    echo ""
    log_info "═══════════════════════════════════════════════════════════"
    
    # Ask about setup mode
    echo ""
    log_info "Which environment would you like to set up?"
    echo ""
    echo "  1) Local Development (recommended for first-time setup)"
    echo "     - No domain names needed"
    echo "     - Services on localhost:PORT"
    echo "     - Fast setup (5 minutes)"
    echo ""
    echo "  2) Production"
    echo "     - Requires domain and DNS"
    echo "     - SSL certificates"
    echo "     - Full featured (30 minutes)"
    echo ""
    echo "  3) Both (local for development, production for deployment)"
    echo ""
    
    read -p "Choose (1/2/3): " -r setup_choice
    
    case $setup_choice in
        1)
            setup_local_environment
            ;;
        2)
            setup_production_environment
            ;;
        3)
            setup_local_environment
            echo ""
            log_info "Now setting up production environment..."
            echo ""
            setup_production_environment
            ;;
        *)
            log_error "Invalid choice"
            exit 1
            ;;
    esac
    
    # Install project dependencies
    echo ""
    install_project_dependencies
    
    # Create Docker network
    echo ""
    log_info "Setting up Docker network..."
    if ! docker network inspect kompose &>/dev/null; then
        docker network create kompose
        log_success "Created Docker network 'kompose'"
    else
        log_info "Docker network 'kompose' already exists"
    fi
    
    # Final summary
    echo ""
    log_success "═══════════════════════════════════════════════════════════"
    log_success "       Initialization Complete!"
    log_success "═══════════════════════════════════════════════════════════"
    echo ""
    log_info "Next steps:"
    echo ""
    
    local mode=$(get_current_mode)
    if [ "$mode" = "local" ]; then
        echo "  1. Review and update secrets.env with your credentials"
        echo "  2. Start core services:     ./kompose.sh up core"
        echo "  3. Start auth services:     ./kompose.sh up auth"
        echo "  4. Configure Keycloak at:   http://localhost:8180"
        echo "  5. Start KMPS:              ./kompose.sh up kmps"
        echo "  6. Access KMPS at:          http://localhost:3100"
    else
        echo "  1. Configure DNS for your domain"
        echo "  2. Review and update secrets.env with strong passwords"
        echo "  3. Start Traefik:           ./kompose.sh up proxy"
        echo "  4. Start core services:     ./kompose.sh up core"
        echo "  5. Start auth services:     ./kompose.sh up auth"
        echo "  6. Configure Keycloak"
        echo "  7. Start KMPS:              ./kompose.sh up kmps"
    fi
    
    echo ""
    log_info "Documentation:"
    echo "  - Quick Reference:    QUICK_REFERENCE.md"
    echo "  - Local Development:  LOCAL_DEVELOPMENT.md"
    echo "  - KMPS Guide:         kmps/QUICK_START.md"
    echo ""
}

setup_local_environment() {
    log_info "Setting up Local Development Environment..."
    echo ""
    
    # Check if configs exist, create if not
    if [ ! -f ".env.local" ]; then
        log_error ".env.local template not found!"
        log_info "Please ensure .env.local exists in the project root"
        exit 1
    fi
    
    if [ ! -f "domain.env.local" ]; then
        log_error "domain.env.local template not found!"
        log_info "Please ensure domain.env.local exists in the project root"
        exit 1
    fi
    
    # Copy configurations
    cp ".env.local" ".env"
    cp "domain.env.local" "domain.env"
    log_success "Local configuration files activated"
    
    # Create secrets.env
    setup_secrets_file "local"
    
    log_success "Local environment configured!"
}

setup_production_environment() {
    log_info "Setting up Production Environment..."
    echo ""
    
    # Get domain
    local domain
    read -p "Enter your root domain (e.g., example.com): " -r domain
    
    if [ -z "$domain" ]; then
        log_error "Domain is required"
        exit 1
    fi
    
    # Get email for SSL
    local email
    read -p "Enter email for SSL certificates: " -r email
    
    if [ -z "$email" ]; then
        log_error "Email is required"
        exit 1
    fi
    
    # Update domain.env
    if [ -f "domain.env" ] && ! [ -f ".env.local" ]; then
        # Already in production mode
        sed -i.bak "s/^ROOT_DOMAIN=.*/ROOT_DOMAIN=${domain}/" domain.env
        sed -i.bak "s/^ACME_EMAIL=.*/ACME_EMAIL=${email}/" domain.env
    else
        # Copy from template or create
        if [ -f "domain.env.production" ]; then
            cp "domain.env.production" "domain.env"
        fi
        sed -i.bak "s/^ROOT_DOMAIN=.*/ROOT_DOMAIN=${domain}/" domain.env
        sed -i.bak "s/^ACME_EMAIL=.*/ACME_EMAIL=${email}/" domain.env
    fi
    
    log_success "Production domain configured: $domain"
    
    # Copy production .env
    if [ -f ".env.production" ]; then
        cp ".env.production" ".env"
    elif [ ! -f ".env" ]; then
        cp ".env.local" ".env"
        # Convert to production settings
        sed -i.bak 's/localhost:[0-9]\+/\${TRAEFIK_HOST}/g' ".env"
        sed -i.bak 's/TRAEFIK_ENABLED=false/TRAEFIK_ENABLED=true/g' ".env"
    fi
    
    # Save as production
    cp ".env" ".env.production"
    cp "domain.env" "domain.env.production"
    
    # Create secrets.env
    setup_secrets_file "production"
    
    log_success "Production environment configured!"
    log_warning "Remember to configure DNS records for *.${domain}"
}

setup_secrets_file() {
    local mode=$1
    
    if [ -f "secrets.env" ]; then
        log_info "secrets.env already exists, skipping..."
        return
    fi
    
    log_info "Creating secrets.env..."
    
    if [ "$mode" = "local" ]; then
        # Create with simple development secrets
        cat > secrets.env << 'EOF'
# Development Secrets (Local Mode)
# WARNING: These are DEVELOPMENT ONLY - use strong passwords in production!

# Database
DB_PASSWORD=dev_password_123

# Redis
REDIS_PASSWORD=dev_redis_123
REDIS_API_PASSWORD=dev_redis_api_123

# Admin
ADMIN_PASSWORD=dev_admin_123

# Auth Stack
KC_ADMIN_PASSWORD=admin
AUTH_KC_ADMIN_PASSWORD=admin
OAUTH2_CLIENT_SECRET=dev_oauth2_secret
EOF
        
        # Generate random secrets for sensitive items
        echo "OAUTH2_COOKIE_SECRET=$(openssl rand -base64 32)" >> secrets.env
        echo "AUTH_OAUTH2_CLIENT_SECRET=dev_oauth2_secret" >> secrets.env
        echo "AUTH_OAUTH2_COOKIE_SECRET=$(openssl rand -base64 32)" >> secrets.env
        echo "" >> secrets.env
        
        echo "# KMPS (update after Keycloak setup)" >> secrets.env
        echo "KMPS_CLIENT_SECRET=UPDATE_AFTER_KEYCLOAK_SETUP" >> secrets.env
        echo "KMPS_NEXTAUTH_SECRET=$(openssl rand -base64 32)" >> secrets.env
        
        log_success "Created secrets.env with development defaults"
        log_warning "Update KMPS_CLIENT_SECRET after creating Keycloak client"
        
    else
        # Create from template for production
        if [ -f "secrets.env.template" ]; then
            cp "secrets.env.template" "secrets.env"
            log_success "Created secrets.env from template"
            log_warning "IMPORTANT: Edit secrets.env and replace all placeholders with strong passwords!"
        else
            log_error "secrets.env.template not found!"
            exit 1
        fi
    fi
}

install_project_dependencies() {
    log_info "Installing project dependencies..."
    echo ""
    
    # Check if pnpm is available
    if ! command -v pnpm &> /dev/null; then
        log_warning "pnpm not found. Install with: npm install -g pnpm"
        log_info "Skipping dependency installation"
        return
    fi
    
    local deps_installed=false
    
    # Install kmps dependencies
    if [ -d "kmps" ]; then
        log_info "Installing KMPS dependencies..."
        cd kmps
        if [ -f "package.json" ]; then
            pnpm install
            log_success "KMPS dependencies installed"
            deps_installed=true
        fi
        cd ..
    fi
    
    # Install _docs dependencies
    if [ -d "_docs" ]; then
        log_info "Installing documentation site dependencies..."
        cd _docs
        if [ -f "package.json" ]; then
            pnpm install
            log_success "Documentation dependencies installed"
            deps_installed=true
        fi
        cd ..
    fi
    
    if [ "$deps_installed" = false ]; then
        log_info "No Node.js projects found to install dependencies"
    fi
    
    echo ""
}

# ============================================================================
# SETUP COMMAND HANDLER
# ============================================================================

handle_setup_command() {
    local subcmd=${1:-status}
    
    case $subcmd in
        local|dev)
            switch_to_local
            ;;
        prod|production)
            switch_to_production
            ;;
        status|show)
            show_setup_status
            ;;
        save-prod|save)
            save_as_production
            ;;
        backup)
            log_info "Creating Backup"
            backup_dir=$(backup_config)
            log_success "Backup created: $backup_dir"
            ;;
        help|-h|--help)
            cat << EOF
Setup Command Usage:

  ./kompose.sh setup <command>

Commands:
  local          Switch to local development mode
  prod           Switch to production mode
  status         Show current configuration mode
  save-prod      Save current config as production default
  backup         Create backup of current configuration
  help           Show this help message

Examples:
  # Switch to local development
  ./kompose.sh setup local

  # Check current mode
  ./kompose.sh setup status

  # Switch back to production
  ./kompose.sh setup prod

EOF
            ;;
        *)
            log_error "Unknown setup command: $subcmd"
            echo ""
            echo "Available commands: local, prod, status, save-prod, backup, help"
            exit 1
            ;;
    esac
}
