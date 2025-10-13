#!/bin/bash

# kompose-env.sh - Environment Variable Management
# Part of kompose.sh - Docker Compose Stack Manager
#
# This module handles stack-scoped environment variables
# It filters and maps variables from the root .env to each stack

# ============================================================================
# DOMAIN CONFIGURATION
# ============================================================================

# Generate TRAEFIK_HOST variables from domain.env subdomains
# This creates consistent host variables for all services
generate_traefik_hosts() {
    # Only generate if ROOT_DOMAIN is set
    if [ -z "${ROOT_DOMAIN}" ]; then
        log_warning "ROOT_DOMAIN not set, skipping TRAEFIK_HOST generation"
        return 0
    fi
    
    # Check if we're in local mode (localhost)
    if [[ "${BASE_DOMAIN}" == "localhost" ]] || [[ "${ROOT_DOMAIN}" == "localhost" ]]; then
        # Local mode: use subdomain directly (e.g., localhost:8080)
        export TRAEFIK_HOST_PROXY="${SUBDOMAIN_PROXY:-localhost:8080}"
        export TRAEFIK_HOST_AUTH="${SUBDOMAIN_AUTH:-localhost:8180}"
        export TRAEFIK_HOST_CODE="${SUBDOMAIN_CODE:-localhost:3001}"
        export TRAEFIK_HOST_CHAIN="${SUBDOMAIN_CHAIN:-localhost:5678}"
        export TRAEFIK_HOST_AUTO="${SUBDOMAIN_AUTO:-localhost:3000}"
        export TRAEFIK_HOST_BLOG="${SUBDOMAIN_BLOG:-localhost:3002}"
        export TRAEFIK_HOST_DOCS="${SUBDOMAIN_DOCS:-localhost:3003}"
        export TRAEFIK_HOST_NEWS="${SUBDOMAIN_NEWS:-localhost:3004}"
        export TRAEFIK_HOST_CHAT="${SUBDOMAIN_CHAT:-localhost:8085}"
        export TRAEFIK_HOST_MAIL="${SUBDOMAIN_MAIL:-localhost:8025}"
        export TRAEFIK_HOST_DATA="${SUBDOMAIN_DATA:-localhost:3005}"
        export TRAEFIK_HOST_DASH="${SUBDOMAIN_DASH:-localhost:3006}"
        export TRAEFIK_HOST_TRACK="${SUBDOMAIN_TRACK:-localhost:3007}"
        export TRAEFIK_HOST_TRACE="${SUBDOMAIN_TRACE:-localhost:3008}"
        export TRAEFIK_HOST_HOME="${SUBDOMAIN_HOME:-localhost:8123}"
        export TRAEFIK_HOST_SEXY="${SUBDOMAIN_SEXY:-localhost:8055}"
        export TRAEFIK_HOST_VAULT="${SUBDOMAIN_VAULT:-localhost:8081}"
        export TRAEFIK_HOST_LINK="${SUBDOMAIN_LINK:-localhost:3009}"
        export TRAEFIK_HOST_DOCK="${SUBDOMAIN_DOCK:-localhost:5000}"
        export TRAEFIK_HOST_MANAGE="${SUBDOMAIN_MANAGE:-localhost:3100}"
        export TRAEFIK_HOST_VPN="${SUBDOMAIN_VPN:-localhost:51821}"
        export TRAEFIK_HOST_OAUTH2="${SUBDOMAIN_OAUTH2:-localhost:4180}"
        export TRAEFIK_HOST_ZIGBEE="${SUBDOMAIN_ZIGBEE:-localhost:8080}"
        
        # Watch Stack Services
        export TRAEFIK_HOST_PROMETHEUS="${SUBDOMAIN_PROMETHEUS:-localhost:9090}"
        export TRAEFIK_HOST_GRAFANA="${SUBDOMAIN_GRAFANA:-localhost:3010}"
        export TRAEFIK_HOST_LOKI="${SUBDOMAIN_LOKI:-localhost:3100}"
        export TRAEFIK_HOST_ALERTMANAGER="${SUBDOMAIN_ALERTMANAGER:-localhost:9093}"
    else
        # Production mode: combine subdomain with root domain
        export TRAEFIK_HOST_PROXY="${SUBDOMAIN_PROXY}.${ROOT_DOMAIN}"
        export TRAEFIK_HOST_AUTH="${SUBDOMAIN_AUTH}.${ROOT_DOMAIN}"
        export TRAEFIK_HOST_CODE="${SUBDOMAIN_CODE}.${ROOT_DOMAIN}"
        export TRAEFIK_HOST_CHAIN="${SUBDOMAIN_CHAIN}.${ROOT_DOMAIN}"
        export TRAEFIK_HOST_AUTO="${SUBDOMAIN_AUTO}.${ROOT_DOMAIN}"
        export TRAEFIK_HOST_BLOG="${SUBDOMAIN_BLOG}.${ROOT_DOMAIN}"
        export TRAEFIK_HOST_DOCS="${SUBDOMAIN_DOCS}.${ROOT_DOMAIN}"
        export TRAEFIK_HOST_NEWS="${SUBDOMAIN_NEWS}.${ROOT_DOMAIN}"
        export TRAEFIK_HOST_CHAT="${SUBDOMAIN_CHAT}.${ROOT_DOMAIN}"
        export TRAEFIK_HOST_MAIL="${SUBDOMAIN_MAIL}.${ROOT_DOMAIN}"
        export TRAEFIK_HOST_DATA="${SUBDOMAIN_DATA}.${ROOT_DOMAIN}"
        export TRAEFIK_HOST_DASH="${SUBDOMAIN_DASH}.${ROOT_DOMAIN}"
        export TRAEFIK_HOST_TRACK="${SUBDOMAIN_TRACK}.${ROOT_DOMAIN}"
        export TRAEFIK_HOST_TRACE="${SUBDOMAIN_TRACE}.${ROOT_DOMAIN}"
        export TRAEFIK_HOST_HOME="${SUBDOMAIN_HOME}.${ROOT_DOMAIN}"
        export TRAEFIK_HOST_SEXY="${SUBDOMAIN_SEXY}.${ROOT_DOMAIN}"
        export TRAEFIK_HOST_VAULT="${SUBDOMAIN_VAULT}.${ROOT_DOMAIN}"
        export TRAEFIK_HOST_LINK="${SUBDOMAIN_LINK}.${ROOT_DOMAIN}"
        export TRAEFIK_HOST_DOCK="${SUBDOMAIN_DOCK}.${ROOT_DOMAIN}"
        export TRAEFIK_HOST_MANAGE="${SUBDOMAIN_MANAGE}.${ROOT_DOMAIN}"
        export TRAEFIK_HOST_VPN="${SUBDOMAIN_VPN}.${ROOT_DOMAIN}"
        export TRAEFIK_HOST_OAUTH2="${SUBDOMAIN_OAUTH2}.${ROOT_DOMAIN}"
        export TRAEFIK_HOST_ZIGBEE="${SUBDOMAIN_ZIGBEE}.${ROOT_DOMAIN}"
        
        # Watch Stack Services
        export TRAEFIK_HOST_PROMETHEUS="${SUBDOMAIN_PROMETHEUS}.${ROOT_DOMAIN}"
        export TRAEFIK_HOST_GRAFANA="${SUBDOMAIN_GRAFANA}.${ROOT_DOMAIN}"
        export TRAEFIK_HOST_LOKI="${SUBDOMAIN_LOKI}.${ROOT_DOMAIN}"
        export TRAEFIK_HOST_ALERTMANAGER="${SUBDOMAIN_ALERTMANAGER}.${ROOT_DOMAIN}"
    fi
    
    # Service-specific aliases for backwards compatibility and clarity
    export N8N_TRAEFIK_HOST="${TRAEFIK_HOST_CHAIN}"
    export SEMAPHORE_TRAEFIK_HOST="${TRAEFIK_HOST_AUTO}"
    export GITEA_TRAEFIK_HOST="${TRAEFIK_HOST_CODE}"
    export KMPS_TRAEFIK_HOST="${TRAEFIK_HOST_MANAGE}"
    export OAUTH2_PROXY_HOST="${TRAEFIK_HOST_OAUTH2}"
    export TRAEFIK_HOST="${TRAEFIK_HOST_AUTH}"  # Used by auth stack
}

# ============================================================================
# ENVIRONMENT VARIABLE FILTERING
# ============================================================================

# Load root environment and filter for a specific stack
# Usage: load_stack_env "core"
load_stack_env() {
    local stack=$1
    local stack_upper=$(echo "$stack" | tr '[:lower:]' '[:upper:]')
    
    # Determine stack directory (check built-in first, then custom)
    local stack_dir="${STACKS_ROOT}/${stack}"
    if [ ! -d "$stack_dir" ] || [ ! -f "${stack_dir}/${COMPOSE_FILE:-compose.yaml}" ]; then
        stack_dir="${STACKS_ROOT}/+custom/${stack}"
    fi
    
    # Export the stack directory for docker-compose
    export KOMPOSE_STACK_DIR="${stack_dir}"
    export KOMPOSE_STACK_NAME="${stack}"
    
    # Load root .env file
    if [ -f "${STACKS_ROOT}/.env" ]; then
        set -a  # automatically export all variables
        source "${STACKS_ROOT}/.env"
        set +a
    else
        log_warning "Root .env file not found at ${STACKS_ROOT}/.env"
    fi
    
    # Load domain.env if it exists
    if [ -f "${STACKS_ROOT}/domain.env" ]; then
        set -a
        source "${STACKS_ROOT}/domain.env"
        set +a
    else
        log_warning "domain.env file not found. Domain configuration will not be loaded."
    fi
    
    # Load secrets.env if it exists
    if [ -f "${STACKS_ROOT}/secrets.env" ]; then
        set -a
        source "${STACKS_ROOT}/secrets.env"
        set +a
    else
        log_warning "secrets.env file not found. Secrets will not be loaded."
    fi
    
    # Generate TRAEFIK_HOST variables from domain configuration
    generate_traefik_hosts
    
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
    # CRITICAL: DB_HOST must always be set to the container name for inter-container communication
    export DB_HOST="core-postgres"  # Container name from core stack
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
    
    # Determine stack directory (check built-in first, then custom)
    local stack_dir="${STACKS_ROOT}/${stack}"
    if [ ! -d "$stack_dir" ] || [ ! -f "${stack_dir}/${COMPOSE_FILE:-compose.yaml}" ]; then
        stack_dir="${STACKS_ROOT}/+custom/${stack}"
    fi
    
    local env_file="${stack_dir}/.env.generated"
    
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

# Database connection (container-to-container)
# CRITICAL: DB_HOST must be the container name for inter-container communication
DB_HOST=core-postgres
DB_PORT=${CORE_DB_PORT:-5432}
DB_USER=${CORE_DB_USER:-kompose}
DB_PASSWORD=${CORE_DB_PASSWORD}

# Traefik configuration
TRAEFIK_ENABLED=${TRAEFIK_ENABLED:-true}

# Domain configuration
ROOT_DOMAIN=${ROOT_DOMAIN}
BASE_DOMAIN=${BASE_DOMAIN}

# Traefik host variables (auto-generated from domain.env)
TRAEFIK_HOST=${TRAEFIK_HOST}
TRAEFIK_HOST_PROXY=${TRAEFIK_HOST_PROXY}
TRAEFIK_HOST_AUTH=${TRAEFIK_HOST_AUTH}
TRAEFIK_HOST_CODE=${TRAEFIK_HOST_CODE}
TRAEFIK_HOST_CHAIN=${TRAEFIK_HOST_CHAIN}
TRAEFIK_HOST_AUTO=${TRAEFIK_HOST_AUTO}
TRAEFIK_HOST_BLOG=${TRAEFIK_HOST_BLOG}
TRAEFIK_HOST_DOCS=${TRAEFIK_HOST_DOCS}
TRAEFIK_HOST_NEWS=${TRAEFIK_HOST_NEWS}
TRAEFIK_HOST_CHAT=${TRAEFIK_HOST_CHAT}
TRAEFIK_HOST_MAIL=${TRAEFIK_HOST_MAIL}
TRAEFIK_HOST_DATA=${TRAEFIK_HOST_DATA}
TRAEFIK_HOST_DASH=${TRAEFIK_HOST_DASH}
TRAEFIK_HOST_TRACK=${TRAEFIK_HOST_TRACK}
TRAEFIK_HOST_TRACE=${TRAEFIK_HOST_TRACE}
TRAEFIK_HOST_HOME=${TRAEFIK_HOST_HOME}
TRAEFIK_HOST_SEXY=${TRAEFIK_HOST_SEXY}
TRAEFIK_HOST_VAULT=${TRAEFIK_HOST_VAULT}
TRAEFIK_HOST_LINK=${TRAEFIK_HOST_LINK}
TRAEFIK_HOST_DOCK=${TRAEFIK_HOST_DOCK}
TRAEFIK_HOST_MANAGE=${TRAEFIK_HOST_MANAGE}
TRAEFIK_HOST_VPN=${TRAEFIK_HOST_VPN}
TRAEFIK_HOST_OAUTH2=${TRAEFIK_HOST_OAUTH2}
TRAEFIK_HOST_ZIGBEE=${TRAEFIK_HOST_ZIGBEE}

# Watch Stack Traefik hosts
TRAEFIK_HOST_PROMETHEUS=${TRAEFIK_HOST_PROMETHEUS}
TRAEFIK_HOST_GRAFANA=${TRAEFIK_HOST_GRAFANA}
TRAEFIK_HOST_LOKI=${TRAEFIK_HOST_LOKI}
TRAEFIK_HOST_ALERTMANAGER=${TRAEFIK_HOST_ALERTMANAGER}

# Service-specific host aliases
N8N_TRAEFIK_HOST=${N8N_TRAEFIK_HOST}
SEMAPHORE_TRAEFIK_HOST=${SEMAPHORE_TRAEFIK_HOST}
GITEA_TRAEFIK_HOST=${GITEA_TRAEFIK_HOST}
KMPS_TRAEFIK_HOST=${KMPS_TRAEFIK_HOST}
OAUTH2_PROXY_HOST=${OAUTH2_PROXY_HOST}
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
    
    # Determine stack directory for COMPOSE_ENV_FILE
    local stack_dir="${STACKS_ROOT}/${stack}"
    if [ ! -d "$stack_dir" ] || [ ! -f "${stack_dir}/${COMPOSE_FILE:-compose.yaml}" ]; then
        stack_dir="${STACKS_ROOT}/+custom/${stack}"
    fi
    
    # Set the env file path for docker-compose
    export COMPOSE_ENV_FILE="${stack_dir}/.env.generated"
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
