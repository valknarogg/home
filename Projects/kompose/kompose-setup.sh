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
    local required=${4:-true}
    
    if command -v "$dep" &> /dev/null; then
        local version=$($dep --version 2>&1 | head -n1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n1)
        if [ -n "$version" ]; then
            log_success "$name: $version"
        else
            log_success "$name: installed"
        fi
        return 0
    else
        if [ "$required" = "true" ]; then
            log_error "$name: NOT FOUND"
        else
            log_warning "$name: NOT FOUND (optional)"
        fi
        if [ -n "$install_hint" ]; then
            echo "  Install with: $install_hint"
        fi
        return 1
    fi
}

check_all_dependencies() {
    local all_ok=true
    local mode=${1:-"full"}
    
    log_info "Checking dependencies..."
    echo ""
    
    # Required dependencies
    log_info "Required dependencies:"
    if ! check_dependency "docker" "Docker" "https://docs.docker.com/get-docker/" "true"; then
        all_ok=false
    fi
    
    if ! check_dependency "docker-compose" "Docker Compose" "Included with Docker Desktop" "true"; then
        # Try docker compose (newer version)
        if docker compose version &> /dev/null; then
            log_success "Docker Compose: $(docker compose version --short 2>&1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n1 || echo 'installed')"
        else
            all_ok=false
        fi
    fi
    
    if ! check_dependency "git" "Git" "https://git-scm.com/downloads" "true"; then
        all_ok=false
    fi
    
    # Optional but recommended for development
    if [ "$mode" = "full" ]; then
        echo ""
        log_info "Optional development dependencies:"
        
        # Check Node.js
        if ! check_dependency "node" "Node.js" "https://nodejs.org/" "false"; then
            log_warning "Node.js is required for _docs and kmps development"
        fi
        
        # Check pnpm
        if ! check_dependency "pnpm" "pnpm" "npm install -g pnpm" "false"; then
            log_warning "pnpm is required for installing project dependencies"
            echo "  Install: npm install -g pnpm"
        fi
        
        # Check Python 3
        if ! check_dependency "python3" "Python 3" "https://www.python.org/downloads/" "false"; then
            log_warning "Python 3 is required for the REST API server"
        fi
    fi
    
    echo ""
    
    if [ "$all_ok" = false ]; then
        log_error "Some required dependencies are missing!"
        log_info "Please install the missing dependencies and try again"
        return 1
    else
        log_success "All required dependencies are installed!"
        if [ "$mode" = "full" ]; then
            log_info "Optional dependencies can be installed later if needed"
        fi
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
    log_info "Welcome to Kompose! This wizard will guide you through"
    log_info "setting up your local development or production environment."
    echo ""
    
    # Check dependencies
    echo ""
    log_info "Step 1: Checking system dependencies"
    log_info "────────────────────────────────────────────────────────────"
    if ! check_all_dependencies "full"; then
        echo ""
        log_error "Cannot continue without required dependencies"
        log_info "Please install the missing dependencies and run: ./kompose.sh init"
        exit 1
    fi
    
    echo ""
    log_info "═══════════════════════════════════════════════════════════"
    
    # Ask about setup mode
    echo ""
    log_info "Step 2: Choose your environment"
    log_info "────────────────────────────────────────────────────────────"
    echo ""
    echo "  ${GREEN}1) Local Development${NC} ${BLUE}(recommended for first-time setup)${NC}"
    echo "     ✓ No domain names needed"
    echo "     ✓ Services on localhost:PORT"
    echo "     ✓ Fast setup (~5 minutes)"
    echo "     ✓ Perfect for testing and development"
    echo ""
    echo "  ${YELLOW}2) Production${NC}"
    echo "     ✓ Requires domain and DNS configuration"
    echo "     ✓ SSL certificates via Let's Encrypt"
    echo "     ✓ Full featured setup (~30 minutes)"
    echo "     ✓ Ready for public deployment"
    echo ""
    echo "  ${CYAN}3) Both${NC} ${BLUE}(local for development, production for deployment)${NC}"
    echo "     ✓ Best of both worlds"
    echo "     ✓ Easily switch between environments"
    echo ""
    
    read -p "Choose (1/2/3) [1]: " -r setup_choice
    setup_choice=${setup_choice:-1}
    
    echo ""
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
    
    # Make scripts executable
    echo ""
    log_info "Step 3: Setting up project scripts"
    log_info "────────────────────────────────────────────────────────────"
    make_scripts_executable
    
    # Install project dependencies
    echo ""
    log_info "Step 4: Installing project dependencies"
    log_info "────────────────────────────────────────────────────────────"
    install_project_dependencies
    
    # Create Docker network
    echo ""
    log_info "Step 5: Setting up Docker network"
    log_info "────────────────────────────────────────────────────────────"
    if ! docker network inspect kompose &>/dev/null; then
        docker network create kompose
        log_success "Created Docker network 'kompose'"
    else
        log_info "Docker network 'kompose' already exists"
    fi
    
    # Create necessary directories
    echo ""
    log_info "Step 6: Creating project directories"
    log_info "────────────────────────────────────────────────────────────"
    mkdir -p backups/database backups/config
    log_success "Project directories created"
    
    # Final summary
    echo ""
    log_success "═══════════════════════════════════════════════════════════"
    log_success "       🎉 Initialization Complete!"
    log_success "═══════════════════════════════════════════════════════════"
    echo ""
    
    local mode=$(get_current_mode)
    if [ "$mode" = "local" ]; then
        log_info "${GREEN}✓${NC} Local development environment is ready!"
        echo ""
        echo "${BLUE}Next steps:${NC}"
        echo ""
        echo "  ${YELLOW}1.${NC} Generate or review secrets (IMPORTANT!)"
        echo "     ${CYAN}./kompose.sh secrets generate${NC}      # Generate all secrets"
        echo "     ${CYAN}./kompose.sh secrets validate${NC}      # Check configuration"
        echo "     ${CYAN}./kompose.sh secrets list${NC}          # View all secrets"
        echo ""
        echo "  ${YELLOW}2.${NC} Start core services (PostgreSQL, Redis, MQTT)"
        echo "     ${CYAN}./kompose.sh up core${NC}"
        echo ""
        echo "  ${YELLOW}3.${NC} Start authentication services (Keycloak)"
        echo "     ${CYAN}./kompose.sh up auth${NC}"
        echo ""
        echo "  ${YELLOW}4.${NC} Configure Keycloak SSO"
        echo "     ${CYAN}http://localhost:8180${NC}"
        echo "     Login: admin / (check secrets.env)"
        echo ""
        echo "  ${YELLOW}5.${NC} Start KMPS Management Portal"
        echo "     ${CYAN}./kompose.sh up kmps${NC}"
        echo ""
        echo "  ${YELLOW}6.${NC} Access KMPS at"
        echo "     ${CYAN}http://localhost:3100${NC}"
    else
        log_info "${YELLOW}⚠${NC}  Production environment configured"
        echo ""
        echo "${BLUE}Next steps:${NC}"
        echo ""
        echo "  ${YELLOW}1.${NC} Configure DNS for your domain"
        echo "     Create A records pointing to your server IP"
        echo ""
        echo "  ${YELLOW}2.${NC} Review and update secrets.env with ${RED}STRONG${NC} passwords"
        echo "     ${CYAN}nano secrets.env${NC}"
        echo ""
        echo "  ${YELLOW}3.${NC} Start Traefik reverse proxy"
        echo "     ${CYAN}./kompose.sh up proxy${NC}"
        echo ""
        echo "  ${YELLOW}4.${NC} Start core services"
        echo "     ${CYAN}./kompose.sh up core${NC}"
        echo ""
        echo "  ${YELLOW}5.${NC} Start authentication services"
        echo "     ${CYAN}./kompose.sh up auth${NC}"
        echo ""
        echo "  ${YELLOW}6.${NC} Configure Keycloak"
        echo ""
        echo "  ${YELLOW}7.${NC} Start KMPS"
        echo "     ${CYAN}./kompose.sh up kmps${NC}"
    fi
    
    echo ""
    log_info "${BLUE}📚 Documentation:${NC}"
    echo "  • Quick Reference:       ${CYAN}QUICK_REFERENCE.md${NC}"
    echo "  • Local Development:     ${CYAN}LOCAL_DEVELOPMENT.md${NC}"
    echo "  • KMPS Guide:            ${CYAN}kmps/QUICK_START.md${NC}"
    echo "  • Online Documentation:  ${CYAN}http://localhost:3000${NC} (after starting _docs)"
    echo ""
    log_info "${BLUE}💡 Helpful commands:${NC}"
    echo "  • List all stacks:       ${CYAN}./kompose.sh list${NC}"
    echo "  • Check status:          ${CYAN}./kompose.sh status${NC}"
    echo "  • View logs:             ${CYAN}./kompose.sh logs <stack> -f${NC}"
    echo "  • Get help:              ${CYAN}./kompose.sh help${NC}"
    echo ""
    log_success "Happy stacking! 🚀"
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
    
    # Validate secrets
    log_info "Validating secrets..."
    if bash "${SCRIPT_DIR}/kompose.sh" secrets validate >/dev/null 2>&1; then
        log_success "Secrets configured correctly"
    else
        log_warning "Some secrets need attention - run 'kompose secrets validate' for details"
    fi
    
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
    
    # Validate secrets
    log_info "Validating secrets..."
    if bash "${SCRIPT_DIR}/kompose.sh" secrets validate >/dev/null 2>&1; then
        log_success "Secrets configured correctly"
    else
        log_warning "Some secrets need attention - run 'kompose secrets validate' for details"
    fi
    
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
        log_warning "pnpm not found - skipping Node.js dependency installation"
        echo ""
        echo "  To install pnpm later, run:"
        echo "    ${CYAN}npm install -g pnpm${NC}"
        echo ""
        echo "  Then install dependencies with:"
        echo "    ${CYAN}cd _docs && pnpm install${NC}"
        echo "    ${CYAN}cd ../kmps && pnpm install${NC}"
        echo ""
        return
    fi
    
    local deps_installed=false
    local failed_installs=""
    
    # Install _docs dependencies (documentation site)
    if [ -d "_docs" ] && [ -f "_docs/package.json" ]; then
        log_info "Installing documentation site dependencies..."
        cd _docs
        if pnpm install 2>&1 | tee /tmp/pnpm-docs-install.log; then
            log_success "Documentation site dependencies installed"
            deps_installed=true
        else
            log_error "Failed to install documentation dependencies"
            failed_installs="${failed_installs}_docs "
        fi
        cd ..
    fi
    
    # Install kmps dependencies (management portal)
    if [ -d "kmps" ] && [ -f "kmps/package.json" ]; then
        log_info "Installing KMPS management portal dependencies..."
        cd kmps
        if pnpm install 2>&1 | tee /tmp/pnpm-kmps-install.log; then
            log_success "KMPS management portal dependencies installed"
            deps_installed=true
        else
            log_error "Failed to install KMPS dependencies"
            failed_installs="${failed_installs}kmps "
        fi
        cd ..
    fi
    
    # Install _kmps dependencies if exists (legacy location)
    if [ -d "_kmps" ] && [ -f "_kmps/package.json" ]; then
        log_info "Installing _kmps dependencies..."
        cd _kmps
        if pnpm install 2>&1 | tee /tmp/pnpm-kmps-install.log; then
            log_success "_kmps dependencies installed"
            deps_installed=true
        else
            log_error "Failed to install _kmps dependencies"
            failed_installs="${failed_installs}_kmps "
        fi
        cd ..
    fi
    
    echo ""
    
    if [ -n "$failed_installs" ]; then
        log_warning "Some dependencies failed to install: $failed_installs"
        log_info "Check the logs in /tmp/pnpm-*-install.log for details"
        log_info "You can manually install them later by running:"
        for proj in $failed_installs; do
            echo "  ${CYAN}cd $proj && pnpm install${NC}"
        done
        echo ""
    elif [ "$deps_installed" = false ]; then
        log_info "No Node.js projects found to install dependencies"
    else
        log_success "All project dependencies installed successfully!"
    fi
}

# Make all scripts executable
make_scripts_executable() {
    log_info "Making scripts executable..."
    
    local script_count=0
    for script in kompose*.sh; do
        if [ -f "$script" ]; then
            chmod +x "$script"
            ((script_count++))
        fi
    done
    
    log_success "Made $script_count scripts executable"
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
