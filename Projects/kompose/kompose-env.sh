#!/bin/bash

# kompose-env.sh - Environment Variable Management
# Part of kompose.sh - Docker Compose Stack Manager
#
# This module handles stack-scoped environment variables
# It loads variables from root .env files and exports them to the shell
# Docker Compose will automatically use these exported environment variables

# ============================================================================
# ENVIRONMENT VARIABLE DOCUMENTATION
# ============================================================================
# This section documents all environment variables used across all stacks.
# Variables should be defined in the root .env file with stack prefixes.
#
# Format: STACK_VARIABLE_NAME=value
# Example: CORE_POSTGRES_IMAGE=postgres:16-alpine
#
# CRITICAL: Secret variables (passwords, keys, tokens) are managed
# separately by kompose-secrets.sh and should NOT be documented here.
# ============================================================================

# [Previous documentation sections remain the same - omitted for brevity]

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
    
    # Export COMPOSE_PROJECT_NAME using the dedicated stack variable
    # Each stack should have a <STACKNAME>_COMPOSE_PROJECT_NAME variable in root .env
    # Example: CORE_COMPOSE_PROJECT_NAME=core
    local compose_project_var="${prefix}_COMPOSE_PROJECT_NAME"
    export COMPOSE_PROJECT_NAME="${!compose_project_var:-${prefix,,}}"
    
    # Export common shared variables
    export NETWORK_NAME="${NETWORK_NAME:-kompose}"
    export TIMEZONE="${TIMEZONE:-Europe/Amsterdam}"
    
    # Export database connection variables for easy access
    # CRITICAL: DB_HOST must always be set to the container name for inter-container communication
    export DB_HOST="${DB_HOST:-core-postgres}"
    export DB_PORT="${DB_PORT:-5432}"
    export DB_USER="${DB_USER:-kompose}"
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
        # Don't display sensitive variables (passwords, secrets, tokens, keys)
        if [[ ! "$var" =~ (PASSWORD|SECRET|TOKEN|KEY|PRIVATE) ]]; then
            echo "  $var=${!var}"
        else
            echo "  $var=***REDACTED***"
        fi
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
            check_required_vars "CORE" "POSTGRES_IMAGE" "REDIS_IMAGE" "MOSQUITTO_IMAGE"
            ;;
        auth)
            check_required_vars "AUTH" "DOCKER_IMAGE" "DB_NAME" "KEYCLOAK_ADMIN_USERNAME"
            ;;
        home)
            check_required_vars "HOME" "HOMEASSISTANT_IMAGE"
            ;;
        chain)
            check_required_vars "CHAIN" "N8N_IMAGE" "SEMAPHORE_IMAGE"
            ;;
        code)
            check_required_vars "CODE" "GITEA_IMAGE"
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

# Export environment for docker-compose
# This is the main function called by stack operations
# Usage: export_stack_env "core"
#
# All environment variables are loaded from root .env, domain.env, and secrets.env
# and exported to the shell environment. Docker Compose will automatically
# use these exported environment variables without needing per-stack .env files.
export_stack_env() {
    local stack=$1
    
    # Load and map environment variables to shell environment
    load_stack_env "$stack"
    
    log_info "Environment loaded for stack: $stack (${COMPOSE_PROJECT_NAME})"
}

# ============================================================================
# SECRETS MANAGEMENT
# ============================================================================
# NOTE: Secret generation is now handled by kompose-secrets.sh module
# This module only loads secrets from secrets.env file

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

# List all stack-scoped variables
list_stack_variables() {
    log_info "Available stack-scoped variables:"
    echo ""
    
    for stack in core auth kmps home vpn messaging chain code proxy track vault watch link; do
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
