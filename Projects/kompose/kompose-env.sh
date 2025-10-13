#!/bin/bash

# kompose-env.sh - Environment Variable Management
# Part of kompose.sh - Docker Compose Stack Manager
#
# This module handles stack-scoped environment variables
# It filters and maps variables from the root .env to each stack

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

# ============================================================================
# SHARED/COMMON VARIABLES (Used across multiple stacks)
# ============================================================================
# These variables are used by multiple stacks and don't need prefixes
#
# TIMEZONE                    - System timezone (default: Europe/Amsterdam)
# NETWORK_NAME                - Docker network name (default: kompose)
# COMPOSE_PROJECT_NAME        - Project name prefix for containers
# DB_USER                     - PostgreSQL username (default: kompose)
# DB_HOST                     - Database host (default: core-postgres)
# DB_PORT                     - Database port (default: 5432)
# ADMIN_EMAIL                 - Administrator email address
# EMAIL_TRANSPORT             - Email transport method (default: smtp)
# EMAIL_FROM                  - Email sender address
# EMAIL_SMTP_HOST             - SMTP server hostname
# EMAIL_SMTP_PORT             - SMTP server port (default: 1025 for Mailhog)
# EMAIL_SMTP_USER             - SMTP authentication username
# BASE_DOMAIN                 - Base domain for services
# ROOT_DOMAIN                 - Root domain for SSL certificates
# REDIS_HOST                  - Redis host (default: core-redis)
# MQTT_ENABLED                - Enable MQTT integration (default: true)
# ============================================================================

# ============================================================================
# CORE STACK VARIABLES
# ============================================================================
# PostgreSQL Database
#   CORE_POSTGRES_IMAGE              - PostgreSQL Docker image (default: postgres:16-alpine)
#   CORE_DB_NAME                     - Main database name (default: kompose)
#   CORE_POSTGRES_MAX_CONNECTIONS    - Max database connections (default: 100)
#   CORE_POSTGRES_SHARED_BUFFERS     - Shared buffer size (default: 256MB)
#   CORE_DB_HOST                     - Database container name (default: core-postgres)
#   CORE_DB_PORT                     - Database port (default: 5432)
#
# Redis Cache
#   CORE_REDIS_IMAGE                 - Redis Docker image (default: redis:7-alpine)
#   CORE_REDIS_HOST                  - Redis container name (default: core-redis)
#   CORE_REDIS_PORT                  - Redis port (default: 6379)
#
# MQTT Broker
#   CORE_MOSQUITTO_IMAGE             - Mosquitto Docker image (default: eclipse-mosquitto:2)
#   CORE_MQTT_PORT                   - MQTT broker port (default: 1883)
#   CORE_MQTT_WS_PORT                - MQTT WebSocket port (default: 9001)
#
# Redis Commander (Web UI)
#   CORE_REDIS_COMMANDER_IMAGE       - Redis Commander image
#   CORE_REDIS_API_USER              - Web UI username (default: admin)
#   CORE_REDIS_API_PORT              - Web UI port (default: 8081)
#   CORE_REDIS_API_TRAEFIK_HOST      - Traefik hostname for Redis UI
# ============================================================================

# ============================================================================
# AUTH STACK VARIABLES
# ============================================================================
# Keycloak SSO
#   AUTH_DOCKER_IMAGE                - Keycloak Docker image
#   AUTH_DB_NAME                     - Keycloak database name
#   AUTH_KEYCLOAK_ADMIN_USERNAME     - Keycloak admin username (default: admin)
#   TRAEFIK_HOST_AUTH                - Traefik hostname for Keycloak
#
# OAuth2 Proxy
#   AUTH_OAUTH2_CLIENT_ID            - OAuth2 client ID (default: kompose-sso)
#   AUTH_OAUTH2_PROXY_HOST           - OAuth2 proxy hostname
# ============================================================================

# ============================================================================
# CHAIN STACK VARIABLES  
# ============================================================================
# n8n Workflow Automation
#   CHAIN_N8N_IMAGE                  - n8n Docker image (default: n8nio/n8n:latest)
#   CHAIN_N8N_DB_NAME                - n8n database name (default: n8n)
#   CHAIN_N8N_PORT                   - n8n web port (default: 5678)
#   CHAIN_N8N_BASIC_AUTH_ACTIVE      - Enable basic auth (default: true)
#   CHAIN_N8N_BASIC_AUTH_USER        - Basic auth username (default: admin)
#
# Semaphore Ansible UI
#   CHAIN_SEMAPHORE_IMAGE            - Semaphore Docker image
#   CHAIN_SEMAPHORE_DB_NAME          - Semaphore database name (default: semaphore)
#   CHAIN_SEMAPHORE_PORT             - Semaphore web port (default: 3000)
#   CHAIN_SEMAPHORE_ADMIN_USERNAME   - Admin username (default: admin)
#   CHAIN_SEMAPHORE_ADMIN_NAME       - Admin display name (default: Admin)
#   CHAIN_SEMAPHORE_RUNNER_IMAGE     - Runner image
# ============================================================================

# ============================================================================
# CODE STACK VARIABLES
# ============================================================================
# Gitea Git Service
#   CODE_GITEA_IMAGE                 - Gitea Docker image (default: gitea/gitea:latest)
#   CODE_GITEA_UID                   - Gitea user ID (default: 1000)
#   CODE_GITEA_GID                   - Gitea group ID (default: 1000)
#   CODE_GITEA_TRAEFIK_HOST          - Traefik hostname for Gitea
#   CODE_GITEA_DB_NAME               - Gitea database name (default: gitea)
#   CODE_GITEA_PORT_SSH              - SSH port (default: 2222)
#   CODE_GITEA_PORT_HTTP             - HTTP port (default: 3001)
#   CODE_GITEA_DISABLE_REGISTRATION  - Disable new registrations (default: false)
#   CODE_GITEA_REQUIRE_SIGNIN        - Require sign in to view (default: false)
#   CODE_GITEA_EMAIL_CONFIRM         - Require email confirmation (default: false)
#   CODE_GITEA_WEBHOOK_ALLOWED_HOSTS - Allowed webhook hosts (default: *)
#   CODE_GITEA_WEBHOOK_SKIP_TLS      - Skip TLS for webhooks (default: false)
#   CODE_GITEA_LOG_LEVEL             - Log level (default: Info)
#
# Gitea Actions Runner
#   CODE_GITEA_RUNNER_IMAGE          - Runner Docker image
#   CODE_GITEA_RUNNER_NAME           - Runner name (default: kompose-runner-1)
#   CODE_GITEA_RUNNER_LABELS         - Runner labels
# ============================================================================

# ============================================================================
# HOME STACK VARIABLES
# ============================================================================
# Home Assistant
#   HOMEASSISTANT_IMAGE              - Home Assistant image
#   HOMEASSISTANT_PORT               - Web UI port (default: 8123)
#
# Matter Server
#   MATTER_SERVER_IMAGE              - Matter server image
#
# Zigbee2MQTT
#   ZIGBEE2MQTT_IMAGE                - Zigbee2MQTT image
#   ZIGBEE2MQTT_PORT                 - Web UI port (default: 8080)
#
# ESPHome
#   ESPHOME_IMAGE                    - ESPHome image
# ============================================================================

# ============================================================================
# KMPS STACK VARIABLES
# ============================================================================
# Kompose Management Portal
#   KMPS_API_PORT                    - API server port (default: 8080)
#   KMPS_API_HOST                    - API server host (default: 0.0.0.0)
#   KMPS_REALM                       - Keycloak realm (default: kompose)
#   KMPS_CLIENT_ID                   - Keycloak client ID (default: kmps-admin)
#   KMPS_TRAEFIK_HOST                - Traefik hostname for KMPS
#   KMPS_APP_PORT                    - App server port (default: 3100)
#   NODE_ENV                         - Node environment (default: production)
#   KOMPOSE_ROOT                     - Kompose installation path
# ============================================================================

# ============================================================================
# LINK STACK VARIABLES
# ============================================================================
# Linkwarden Bookmark Manager
#   LINK_DOCKER_IMAGE                - Linkwarden Docker image
#   LINK_DB_NAME                     - Database name
#   LINK_APP_PORT                    - Application port
#   LINK_DISABLE_SCREENSHOT          - Disable screenshots
#   LINK_DISABLE_ARCHIVE             - Disable archiving
#   LINK_DISABLE_REGISTRATION        - Disable new registrations
# ============================================================================

# ============================================================================
# MESSAGING STACK VARIABLES
# ============================================================================
# Gotify Notifications
#   MESSAGING_GOTIFY_IMAGE           - Gotify Docker image
#   MESSAGING_GOTIFY_DEFAULTUSER_NAME - Default username
#   MESSAGING_GOTIFY_PORT            - Gotify port
#
# Mailhog Email Testing
#   MESSAGING_MAILHOG_IMAGE          - Mailhog Docker image
#   MESSAGING_MAILHOG_PORT           - Mailhog web UI port (default: 8025)
#   MESSAGING_MAILHOG_OUTGOING_SMTP_ENABLED - Enable SMTP relay (default: false)
# ============================================================================

# ============================================================================
# PROXY STACK VARIABLES
# ============================================================================
# Traefik Reverse Proxy
#   PROXY_DOCKER_IMAGE               - Traefik Docker image
#   PROXY_LOG_LEVEL                  - Log level (default: INFO)
#   TRAEFIK_HOST_PROXY               - Traefik dashboard hostname
# ============================================================================

# ============================================================================
# TRACK STACK VARIABLES
# ============================================================================
# Umami Analytics
#   TRACK_DOCKER_IMAGE               - Umami Docker image
#   TRACK_DB_NAME                    - Database name
#   TRAEFIK_HOST_TRACK               - Traefik hostname for Umami
# ============================================================================

# ============================================================================
# VAULT STACK VARIABLES
# ============================================================================
# Vaultwarden Password Manager
#   VAULT_DOCKER_IMAGE               - Vaultwarden Docker image
#   VAULT_WEBSOCKET_ENABLED          - Enable WebSocket support
#   VAULT_SIGNUPS_ALLOWED            - Allow new signups
#   VAULT_TRAEFIK_HOST               - Traefik hostname
#   VAULT_MQTT_ENABLED               - Enable MQTT events (default: true)
#   VAULT_APP_PORT                   - Application port
# ============================================================================

# ============================================================================
# VPN STACK VARIABLES
# ============================================================================
# WireGuard VPN (wg-easy)
#   VPN_DOCKER_IMAGE                 - wg-easy Docker image
#   VPN_WG_PORT                      - WireGuard port (default: 51820)
#   VPN_APP_PORT                     - Web UI port (default: 51821)
#   VPN_WG_HOST                      - WireGuard public hostname/IP
#   VPN_LANG                         - UI language (default: en)
#   VPN_UI_TRAFFIC_STATS             - Show traffic stats (default: true)
#   VPN_UI_CHART_TYPE                - Chart type (default: 0)
#   VPN_TRAEFIK_HOST                 - Traefik hostname
# ============================================================================

# ============================================================================
# WATCH STACK VARIABLES
# ============================================================================
# Prometheus Metrics
#   WATCH_PROMETHEUS_IMAGE           - Prometheus image
#   WATCH_PROMETHEUS_RETENTION       - Data retention period (default: 30d)
#   WATCH_PROMETHEUS_PORT            - Prometheus port (default: 9090)
#   WATCH_TRAEFIK_HOST_PROMETHEUS    - Traefik hostname for Prometheus
#
# Grafana Visualization
#   WATCH_GRAFANA_IMAGE              - Grafana image
#   WATCH_GRAFANA_ADMIN_USER         - Admin username (default: admin)
#   WATCH_GRAFANA_PLUGINS            - Grafana plugins to install
#   WATCH_GRAFANA_DB_NAME            - Grafana database name (default: grafana)
#   WATCH_GRAFANA_DB_USER            - Grafana database user (default: grafana)
#   WATCH_GRAFANA_PORT               - Grafana port (default: 3010)
#   WATCH_TRAEFIK_HOST_GRAFANA       - Traefik hostname for Grafana
#
# OpenTelemetry Collector
#   WATCH_OTEL_IMAGE                 - OTel Collector image
#   WATCH_OTEL_GRPC_PORT             - OTLP gRPC port (default: 4317)
#   WATCH_OTEL_HTTP_PORT             - OTLP HTTP port (default: 4318)
#   WATCH_OTEL_HEALTH_PORT           - Health check port (default: 13133)
#   WATCH_OTEL_ZPAGES_PORT           - zPages port (default: 55679)
#
# Exporters
#   WATCH_POSTGRES_EXPORTER_IMAGE    - PostgreSQL exporter image
#   WATCH_POSTGRES_EXPORTER_USER     - DB user for metrics (default: kompose)
#   WATCH_POSTGRES_EXPORTER_DB       - Database to monitor (default: kompose)
#   WATCH_POSTGRES_EXPORTER_PORT     - Exporter port (default: 9187)
#   WATCH_REDIS_EXPORTER_IMAGE       - Redis exporter image
#   WATCH_REDIS_EXPORTER_PORT        - Exporter port (default: 9121)
#   WATCH_MQTT_EXPORTER_IMAGE        - MQTT exporter image
#   WATCH_MQTT_EXPORTER_TOPIC        - MQTT topic to monitor (default: #)
#   WATCH_MQTT_V5_PROTOCOL           - Use MQTT v5 (default: False)
#   WATCH_MQTT_EXPORTER_PORT         - Exporter port (default: 9000)
#   WATCH_CADVISOR_IMAGE             - cAdvisor image
#   WATCH_CADVISOR_PORT              - cAdvisor port (default: 8082)
#   WATCH_NODE_EXPORTER_IMAGE        - Node exporter image
#   WATCH_BLACKBOX_EXPORTER_IMAGE    - Blackbox exporter image
#   WATCH_BLACKBOX_EXPORTER_PORT     - Exporter port (default: 9115)
#
# Loki Log Aggregation
#   WATCH_LOKI_IMAGE                 - Loki image
#   WATCH_LOKI_PORT                  - Loki port (default: 3100)
#   WATCH_TRAEFIK_HOST_LOKI          - Traefik hostname for Loki
#   WATCH_PROMTAIL_IMAGE             - Promtail image
#   WATCH_PROMTAIL_PORT              - Promtail port (default: 9080)
#
# Alertmanager
#   WATCH_ALERTMANAGER_IMAGE         - Alertmanager image
#   WATCH_ALERTMANAGER_PORT          - Alertmanager port (default: 9093)
#   WATCH_TRAEFIK_HOST_ALERTMANAGER  - Traefik hostname for Alertmanager
# ============================================================================

# ============================================================================
# CUSTOM STACK VARIABLES
# ============================================================================
# Blog Stack
#   BLOG_DOCKER_IMAGE                - Static web server image
#   BLOG_TRAEFIK_HOST                - Traefik hostname for blog
#
# News Stack (Letterpress)
#   NEWS_DB_NAME                     - Newsletter database name
#   NEWS_APP_PORT                    - Application port
#   TRAEFIK_HOST_NEWS                - Traefik hostname for newsletter
#
# Sexy Stack (Directus CMS)
#   SEXY_DIRECTUS_BUNDLE             - Extensions bundle path
#   SEXY_DB_NAME                     - Directus database name
#   SEXY_CACHE_ENABLED               - Enable caching
#   SEXY_CACHE_AUTO_PURGE            - Auto-purge cache
#   SEXY_WEBSOCKETS_ENABLED          - Enable WebSockets
#   SEXY_PUBLIC_URL                  - Public URL
#   SEXY_CORS_ENABLED                - Enable CORS
#   SEXY_CORS_ORIGIN                 - CORS origin
#   SEXY_SESSION_COOKIE_SECURE       - Secure cookies
#   SEXY_SESSION_COOKIE_SAME_SITE    - SameSite cookie policy
#   SEXY_SESSION_COOKIE_DOMAIN       - Cookie domain
#   SEXY_EXTENSIONS_PATH             - Extensions path
#   SEXY_EXTENSIONS_AUTO_RELOAD      - Auto-reload extensions
#   SEXY_CONTENT_SECURITY_POLICY_DIRECTIVES__FRAME_SRC - CSP frame-src
#   SEXY_USER_REGISTER_URL_ALLOW_LIST - Registration URL allowlist
#   SEXY_PASSWORD_RESET_URL_ALLOW_LIST - Password reset URL allowlist
#   SEXY_TRAEFIK_HOST                - Traefik hostname
#   SEXY_FRONTEND_IMAGE              - Frontend Docker image
#   SEXY_FRONTEND_PORT               - Frontend port
# ============================================================================

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
    export DB_USER="${DB_USER:-kompose}"
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

# DEPRECATED: Per-stack .env file generation has been removed
# All environment variables are now exported directly from the root environment
# and made available to Docker Compose through the shell environment.
# This ensures consistent variable management and eliminates file duplication.
generate_stack_env_file() {
    local stack=$1
    log_info "Environment variables are now managed from root - no per-stack .env files generated"
    return 0
}

# Export environment for docker-compose
# This is the main function called by stack operations
# Usage: export_stack_env "core"
export_stack_env() {
    local stack=$1
    
    # Load and map environment variables
    # All variables are exported to the shell environment and will be
    # automatically available to Docker Compose without needing .env files
    load_stack_env "$stack"
    
    # Note: We no longer generate per-stack .env files
    # Docker Compose will use the exported environment variables directly
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
