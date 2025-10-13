#!/bin/bash

# kompose-env.sh - Environment Variable Management
# Part of kompose.sh - Docker Compose Stack Manager
#
# This module handles stack-scoped environment variables
# It filters and maps variables from the root .env to each stack

# ============================================================================
# ENVIRONMENT VARIABLE FILTERING
# ============================================================================

# Load root environment and filter for a specific stack
# Usage: load_stack_env "core"
load_stack_env() {
    local stack=$1
    local stack_upper=$(echo "$stack" | tr '[:lower:]' '[:upper:]')
    
    # Export the stack directory for docker-compose
    export KOMPOSE_STACK_DIR="${STACKS_ROOT}/${stack}"
    export KOMPOSE_STACK_NAME="${stack}"
    
    # Load root .env file
    if [ -f "${STACKS_ROOT}/.env" ]; then
        set -a  # automatically export all variables
        source "${STACKS_ROOT}/.env"
        set +a
    else
        log_warning "Root .env file not found at ${STACKS_ROOT}/.env"
    fi
    
    # Load secrets.env if it exists
    if [ -f "${STACKS_ROOT}/secrets.env" ]; then
        set -a
        source "${STACKS_ROOT}/secrets.env"
        set +a
    else
        log_warning "secrets.env file not found. Secrets will not be loaded."
    fi
    
    # Map stack-scoped variables to generic names
    # Example: CORE_POSTGRES_IMAGE -> POSTGRES_IMAGE when running core stack
    map_stack_variables "$stack_upper"
}

# Map stack-specific variables to generic names
# Usage: map_stack_variables "CORE"
map_stack_variables() {
    local prefix=$1
    
    # Get all variables with the stack prefix
    for var in $(compgen -A variable | grep "^${prefix}_"); do
        # Extract the variable name without prefix
        local generic_name="${var#${prefix}_}"
        
        # Export the generic variable with the scoped value
        export "${generic_name}"="${!var}"
        
        # Also keep the scoped variable for reference
        export "${var}"="${!var}"
    done
    
    # Also export common shared variables
    export COMPOSE_PROJECT_NAME="${prefix,,}_${COMPOSE_PROJECT_NAME:-${prefix,,}}"
    export NETWORK_NAME="${NETWORK_NAME:-kompose}"
    export TIMEZONE="${TIMEZONE:-Europe/Amsterdam}"
    
    # Export database connection variables for easy access
    export DB_HOST="${CORE_DB_HOST:-core-postgres}"
    export DB_PORT="${CORE_DB_PORT:-5432}"
    export DB_USER="${CORE_DB_USER:-kompose}"
    export DB_PASSWORD="${CORE_DB_PASSWORD:-${DB_PASSWORD}}"
}

# Show environment variables for a stack (for debugging)
# Usage: show_stack_env "core"
show_stack_env() {
    local stack=$1
    local stack_upper=$(echo "$stack" | tr '[:lower:]' '[:upper:]')
    
    log_info "Environment variables for stack: $stack"
    echo ""
    
    # Show stack-specific variables
    echo -e "${CYAN}Stack-specific variables (${stack_upper}_*):${NC}"
    for var in $(compgen -A variable | grep "^${stack_upper}_" | sort); do
        echo "  $var=${!var}"
    done
    echo ""
    
    # Show common variables
    echo -e "${CYAN}Common variables:${NC}"
    echo "  COMPOSE_PROJECT_NAME=${COMPOSE_PROJECT_NAME}"
    echo "  NETWORK_NAME=${NETWORK_NAME}"
    echo "  TIMEZONE=${TIMEZONE}"
    echo "  DB_HOST=${DB_HOST}"
    echo "  DB_PORT=${DB_PORT}"
    echo "  DB_USER=${DB_USER}"
    echo ""
}

# Validate environment configuration for a stack
# Usage: validate_stack_env "core"
validate_stack_env() {
    local stack=$1
    local stack_upper=$(echo "$stack" | tr '[:lower:]' '[:upper:]')
    local errors=0
    
    log_info "Validating environment for stack: $stack"
    
    # Check if root .env exists
    if [ ! -f "${STACKS_ROOT}/.env" ]; then
        log_error "Root .env file not found at ${STACKS_ROOT}/.env"
        errors=$((errors+1))
    fi
    
    # Check if secrets.env exists
    if [ ! -f "${STACKS_ROOT}/secrets.env" ]; then
        log_warning "secrets.env file not found. Using template values."
    fi
    
    # Check required variables based on stack
    case $stack in
        core)
            check_required_vars "CORE" "DB_USER" "POSTGRES_IMAGE" "REDIS_IMAGE" "MOSQUITTO_IMAGE"
            ;;
        auth)
            check_required_vars "AUTH" "DOCKER_IMAGE" "DB_NAME" "KC_ADMIN_USERNAME"
            ;;
        home)
            check_required_vars "HOME" "HOMEASSISTANT_IMAGE" "MATTER_SERVER_IMAGE"
            ;;
        chain)
            check_required_vars "CHAIN" "N8N_IMAGE" "SEMAPHORE_IMAGE"
            ;;
        code)
            check_required_vars "CODE" "GITEA_IMAGE" "RUNNER_IMAGE"
            ;;
        *)
            log_info "No specific validation rules for stack: $stack"
            ;;
    esac
    
    if [ $errors -eq 0 ]; then
        log_success "Environment validation passed for stack: $stack"
        return 0
    else
        log_error "Environment validation failed for stack: $stack ($errors errors)"
        return 1
    fi
}

# Check if required variables are set
# Usage: check_required_vars "CORE" "VAR1" "VAR2" "VAR3"
check_required_vars() {
    local prefix=$1
    shift
    
    for var_suffix in "$@"; do
        local var_name="${prefix}_${var_suffix}"
        if [ -z "${!var_name}" ]; then
            log_error "Required variable not set: $var_name"
            errors=$((errors+1))
        fi
    done
}

# Generate a .env file for a specific stack (for legacy compatibility)
# Usage: generate_stack_env_file "core"
generate_stack_env_file() {
    local stack=$1
    local stack_upper=$(echo "$stack" | tr '[:lower:]' '[:upper:]')
    local env_file="${STACKS_ROOT}/${stack}/.env.generated"
    
    log_info "Generating .env file for stack: $stack"
    
    # Create header
    cat > "$env_file" << EOF
# ===================================================================
# AUTO-GENERATED .env FILE FOR STACK: $stack
# ===================================================================
# Generated from root .env configuration
# DO NOT EDIT - Changes will be overwritten
# Edit ${STACKS_ROOT}/.env instead
# ===================================================================

EOF
    
    # Add stack-specific variables
    for var in $(compgen -A variable | grep "^${stack_upper}_" | sort); do
        local generic_name="${var#${stack_upper}_}"
        echo "${generic_name}=${!var}" >> "$env_file"
    done
    
    # Add common variables
    cat >> "$env_file" << EOF

# Common variables
COMPOSE_PROJECT_NAME=${stack}
NETWORK_NAME=${NETWORK_NAME:-kompose}
TIMEZONE=${TIMEZONE:-Europe/Amsterdam}

# Database connection
DB_HOST=${CORE_DB_HOST:-core-postgres}
DB_PORT=${CORE_DB_PORT:-5432}
DB_USER=${CORE_DB_USER:-kompose}
DB_PASSWORD=${CORE_DB_PASSWORD}

# Traefik configuration
TRAEFIK_ENABLED=${TRAEFIK_ENABLED:-true}
EOF
    
    log_success "Generated .env file at: $env_file"
}

# Export environment for docker-compose
# This is the main function called by stack operations
# Usage: export_stack_env "core"
export_stack_env() {
    local stack=$1
    
    # Load and map environment variables
    load_stack_env "$stack"
    
    # Generate .env.generated file for docker-compose to read
    # This ensures docker-compose can access all variables
    generate_stack_env_file "$stack"
    
    # Set the env file path for docker-compose
    export COMPOSE_ENV_FILE="${STACKS_ROOT}/${stack}/.env.generated"
}

# ============================================================================
# SECRETS MANAGEMENT
# ============================================================================

# Generate random secrets
generate_secret() {
    local type=${1:-random}
    
    case $type in
        random|password)
            openssl rand -base64 32 | tr -d "=+/" | cut -c1-32
            ;;
        hex64)
            openssl rand -hex 32
            ;;
        hex105)
            openssl rand -hex 52 | cut -c1-105
            ;;
        base64)
            openssl rand -base64 32
            ;;
        uuid)
            if command -v uuidgen &> /dev/null; then
                uuidgen | tr '[:upper:]' '[:lower:]'
            else
                cat /proc/sys/kernel/random/uuid
            fi
            ;;
        htpasswd)
            local user=${2:-admin}
            local pass=${3:-$(generate_secret random)}
            echo "# Generated htpasswd entry for user: $user"
            echo "# Password: $pass"
            htpasswd -nb "$user" "$pass" 2>/dev/null || echo "Error: htpasswd not installed"
            ;;
        *)
            log_error "Unknown secret type: $type"
            return 1
            ;;
    esac
}

# Generate all secrets for secrets.env
generate_all_secrets() {
    log_info "Generating secrets for secrets.env"
    echo ""
    
    cat << EOF
# Generated secrets - Add these to secrets.env

# Shared secrets
DB_PASSWORD=$(generate_secret)
REDIS_PASSWORD=$(generate_secret)
REDIS_API_PASSWORD=$(generate_secret)
ADMIN_PASSWORD=$(generate_secret)
EMAIL_SMTP_PASSWORD=CHANGE_ME_YOUR_SMTP_PASSWORD

# Auth stack
AUTH_KC_ADMIN_PASSWORD=$(generate_secret)
AUTH_OAUTH2_CLIENT_SECRET=$(generate_secret)
AUTH_OAUTH2_COOKIE_SECRET=$(generate_secret base64)

# Code stack
CODE_GITEA_SECRET_KEY=$(generate_secret hex64)
CODE_GITEA_INTERNAL_TOKEN=$(generate_secret hex105)
CODE_GITEA_OAUTH2_JWT_SECRET=$(generate_secret base64)
CODE_GITEA_METRICS_TOKEN=$(generate_secret hex64)
CODE_RUNNER_TOKEN=GENERATE_IN_GITEA_UI

# Chain stack
CHAIN_N8N_ENCRYPTION_KEY=$(generate_secret)
CHAIN_N8N_BASIC_AUTH_PASSWORD=$(generate_secret)
CHAIN_SEMAPHORE_ADMIN_PASSWORD=$(generate_secret)
CHAIN_SEMAPHORE_RUNNER_TOKEN=$(generate_secret)

# Other stacks
SEXY_SECRET=$(generate_secret)
SEXY_ADMIN_PASSWORD=$(generate_secret)
NEWS_JWT_SECRET=$(generate_secret)
TRACK_APP_SECRET=$(generate_secret)
VPN_WG_PASSWORD=$(generate_secret)

# Proxy stack
PROXY_TRAEFIK_DASHBOARD_AUTH=$(generate_secret htpasswd admin $(generate_secret))
EOF
    
    echo ""
    log_success "Secrets generated successfully"
    log_info "Copy the output above to your secrets.env file"
}

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

# List all stack-scoped variables
list_stack_variables() {
    log_info "Available stack-scoped variables:"
    echo ""
    
    for stack in core auth kmps home vpn messaging chain code proxy; do
        local stack_upper=$(echo "$stack" | tr '[:lower:]' '[:upper:]')
        local count=$(compgen -A variable | grep -c "^${stack_upper}_" || true)
        
        if [ "$count" -gt 0 ]; then
            echo -e "${CYAN}$stack${NC} ($count variables)"
        fi
    done
    echo ""
}

# Show configuration for all stacks
show_all_configs() {
    log_info "Showing configuration for all stacks"
    echo ""
    
    for stack in $(get_all_stacks); do
        show_stack_env "$stack"
        echo "---"
    done
}
