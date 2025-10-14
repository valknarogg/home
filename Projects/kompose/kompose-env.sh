#!/bin/bash

# kompose-env.sh - Environment Variable Management Module
# Manages environment variables across all stacks

# ============================================================================
# ENVIRONMENT VARIABLE DEFINITIONS
# ============================================================================

# Define all non-secret environment variables by stack
# Format: VAR_NAME|default_value|description|required

declare -A ENV_VARS

# Global/Common Variables
ENV_VARS[global]="
TIMEZONE|Europe/Amsterdam|System timezone for all containers|yes
NETWORK_NAME|kompose|Docker network name for inter-service communication|yes
BASE_DOMAIN||Base domain for all services (e.g., example.com)|yes
ADMIN_EMAIL||Administrator email address for notifications|yes
NODE_ENV|production|Node.js environment mode|no
EMAIL_FROM|noreply@example.com|Default sender email address|yes
EMAIL_TRANSPORT|smtp|Email transport protocol|no
"

# Core Stack
ENV_VARS[core]="
CORE_COMPOSE_PROJECT_NAME|core|Core stack project name|yes
CORE_POSTGRES_IMAGE|postgres:16-alpine|PostgreSQL Docker image|no
CORE_DB_HOST|core_postgres|PostgreSQL host (container name)|yes
CORE_DB_PORT|5432|PostgreSQL port|yes
CORE_DB_NAME|kompose|Main database name|yes
CORE_POSTGRES_MAX_CONNECTIONS|100|Maximum PostgreSQL connections|no
CORE_POSTGRES_SHARED_BUFFERS|256MB|PostgreSQL shared memory buffers|no
CORE_REDIS_IMAGE|redis:7-alpine|Redis Docker image|no
CORE_REDIS_HOST|core_redis|Redis host (container name)|yes
CORE_REDIS_PORT|6379|Redis port|yes
CORE_MOSQUITTO_IMAGE|eclipse-mosquitto:2|MQTT broker Docker image|no
CORE_MQTT_PORT|1883|MQTT broker port|yes
CORE_MQTT_WS_PORT|9001|MQTT WebSocket port|no
CORE_REDIS_COMMANDER_IMAGE|rediscommander/redis-commander:latest|Redis Commander Docker image|no
CORE_REDIS_API_PORT|8081|Redis Commander web UI port|no
CORE_REDIS_API_TRAEFIK_HOST||Redis web UI hostname (e.g., redis.example.com)|no
"

# Proxy Stack
ENV_VARS[proxy]="
PROXY_COMPOSE_PROJECT_NAME|proxy|Proxy stack project name|yes
PROXY_DOCKER_IMAGE|traefik:latest|Traefik Docker image|no
PROXY_LOG_LEVEL|INFO|Traefik log level (DEBUG, INFO, WARN, ERROR)|no
PROXY_PORT_HTTP|80|HTTP port|yes
PROXY_PORT_HTTPS|443|HTTPS port|yes
PROXY_PORT_DASHBOARD|8080|Traefik dashboard port (localhost only)|no
TRAEFIK_HOST_PROXY||Traefik dashboard hostname (e.g., proxy.example.com)|no
"

# Auth Stack
ENV_VARS[auth]="
AUTH_COMPOSE_PROJECT_NAME|auth|Auth stack project name|yes
AUTH_DOCKER_IMAGE|quay.io/keycloak/keycloak:latest|Keycloak Docker image|no
AUTH_DB_NAME|keycloak|Keycloak database name|yes
TRAEFIK_HOST_AUTH||Keycloak hostname (e.g., auth.example.com)|yes
AUTH_OAUTH2_CLIENT_ID|kompose-sso|OAuth2 client ID for SSO|yes
TRAEFIK_HOST_OAUTH2||OAuth2 proxy hostname (e.g., sso.example.com)|yes
"

# Code Stack
ENV_VARS[code]="
CODE_COMPOSE_PROJECT_NAME|code|Code stack project name|yes
CODE_GITEA_IMAGE|gitea/gitea:latest|Gitea Docker image|no
CODE_GITEA_UID|1000|Gitea user ID|no
CODE_GITEA_GID|1000|Gitea group ID|no
TRAEFIK_HOST_CODE||Gitea hostname (e.g., git.example.com)|yes
CODE_GITEA_DB_NAME|gitea|Gitea database name|yes
CODE_GITEA_PORT_SSH|2222|Gitea SSH port for git operations|yes
CODE_GITEA_PORT_HTTP|3001|Gitea HTTP port (internal)|no
CODE_GITEA_DISABLE_REGISTRATION|false|Disable user registration|no
CODE_GITEA_REQUIRE_SIGNIN|false|Require sign-in to view content|no
CODE_GITEA_EMAIL_CONFIRM|false|Require email confirmation for registration|no
CODE_GITEA_WEBHOOK_ALLOWED_HOSTS|*|Allowed hosts for webhooks|no
CODE_GITEA_WEBHOOK_SKIP_TLS|false|Skip TLS verification for webhooks|no
CODE_GITEA_LOG_LEVEL|Info|Gitea log level (Trace, Debug, Info, Warn, Error)|no
CODE_GITEA_RUNNER_IMAGE|gitea/act_runner:latest|Gitea Actions runner Docker image|no
CODE_GITEA_RUNNER_NAME|kompose-runner-1|Gitea Actions runner name|no
CODE_GITEA_RUNNER_LABELS|ubuntu-latest:docker://node:16-bullseye|Runner labels for Actions|no
"

# Docs Stack
ENV_VARS[_docs]="
COMPOSE_PROJECT_NAME|docs|Docs stack project name|yes
DOCKER_IMAGE|joseluisq/static-web-server:latest|Static web server Docker image|no
TRAEFIK_HOST||Documentation hostname (e.g., docs.example.com)|yes
"

# KMPS Stack (Management Portal)
ENV_VARS[kmps]="
KMPS_COMPOSE_PROJECT_NAME|kmps|KMPS stack project name|yes
KMPS_DOCKER_IMAGE|node:20-alpine|KMPS Docker image|no
KMPS_API_PORT|8080|KMPS API server port|yes
KMPS_API_HOST|0.0.0.0|KMPS API server host|no
KOMPOSE_ROOT|/home/valknar/Projects/kompose|Kompose project root directory|yes
KMPS_REALM|kompose|Keycloak realm name|yes
KMPS_CLIENT_ID|kmps-admin|Keycloak admin client ID|yes
TRAEFIK_HOST_MANAGE||KMPS portal hostname (e.g., manage.example.com)|yes
KMPS_DB_NAME|kmps|KMPS database name|yes
KMPS_APP_PORT|3100|KMPS web application port|no
"

# Messaging Stack
ENV_VARS[messaging]="
MESSAGING_COMPOSE_PROJECT_NAME|messaging|Messaging stack project name|yes
MESSAGING_GOTIFY_IMAGE|gotify/server:latest|Gotify Docker image|no
MESSAGING_GOTIFY_DEFAULTUSER_NAME|admin|Gotify default admin username|yes
MESSAGING_GOTIFY_PORT|8085|Gotify port|no
TRAEFIK_HOST_CHAT||Gotify hostname (e.g., chat.example.com)|yes
MESSAGING_MAILHOG_IMAGE|mailhog/mailhog:latest|Mailhog Docker image|no
MESSAGING_MAILHOG_OUTGOING_SMTP_ENABLED|false|Enable outgoing SMTP relay|no
EMAIL_SMTP_HOST|messaging_mailhog|SMTP host for outgoing email|yes
EMAIL_SMTP_PORT|1025|SMTP port|yes
TRAEFIK_HOST_MAIL||Mailhog hostname (e.g., mail.example.com)|yes
MESSAGING_MAILHOG_PORT|8025|Mailhog web UI port|no
"

# Track Stack (Analytics)
ENV_VARS[track]="
TRACK_COMPOSE_PROJECT_NAME|track|Track stack project name|yes
TRACK_DOCKER_IMAGE|ghcr.io/umami-software/umami:postgresql-latest|Umami Docker image|no
TRACK_DB_NAME|umami|Umami database name|yes
TRAEFIK_HOST_TRACK||Umami hostname (e.g., analytics.example.com)|yes
MQTT_ENABLED|true|Enable MQTT real-time events|no
"

# VPN Stack
ENV_VARS[vpn]="
VPN_COMPOSE_PROJECT_NAME|vpn|VPN stack project name|yes
VPN_DOCKER_IMAGE|ghcr.io/wg-easy/wg-easy:latest|WireGuard Easy Docker image|no
VPN_WG_HOST||WireGuard public hostname or IP|yes
VPN_WG_PORT|51820|WireGuard UDP port|yes
VPN_APP_PORT|51821|WG-Easy web UI port|yes
VPN_LANG|en|WG-Easy UI language|no
VPN_UI_TRAFFIC_STATS|true|Show traffic statistics in UI|no
VPN_UI_CHART_TYPE|0|Chart type for traffic stats (0=Line, 1=Area, 2=Bar)|no
VPN_WG_ALLOWED_IPS|0.0.0.0/0, ::/0|Allowed IPs for VPN clients|no
VPN_WG_DEFAULT_ADDRESS|10.8.0.x|Default client IP address template|no
VPN_WG_DEFAULT_DNS|1.1.1.1|Default DNS server for VPN clients|no
VPN_WG_PERSISTENT_KEEPALIVE|25|WireGuard keepalive interval|no
VPN_WG_MTU|1420|WireGuard MTU size|no
TRAEFIK_HOST_VPN||WG-Easy web UI hostname (e.g., vpn.example.com)|yes
"

# Chain Stack (Automation)
ENV_VARS[chain]="
CHAIN_COMPOSE_PROJECT_NAME|chain|Chain stack project name|yes
CHAIN_N8N_IMAGE|n8nio/n8n:latest|n8n Docker image|no
CHAIN_N8N_DB_NAME|n8n|n8n database name|yes
TRAEFIK_HOST_CHAIN||n8n hostname (e.g., workflow.example.com)|yes
CHAIN_N8N_BASIC_AUTH_ACTIVE|true|Enable n8n basic authentication|no
CHAIN_N8N_BASIC_AUTH_USER|admin|n8n basic auth username|yes
CHAIN_N8N_PORT|5678|n8n web UI port|no
CHAIN_SEMAPHORE_IMAGE|semaphoreui/semaphore:latest|Semaphore Docker image|no
CHAIN_SEMAPHORE_DB_NAME|semaphore|Semaphore database name|yes
CHAIN_SEMAPHORE_ADMIN_USERNAME|admin|Semaphore admin username|yes
CHAIN_SEMAPHORE_ADMIN_NAME|Admin|Semaphore admin display name|no
TRAEFIK_HOST_AUTO||Semaphore hostname (e.g., auto.example.com)|yes
CHAIN_SEMAPHORE_PORT|3000|Semaphore web UI port|no
CHAIN_SEMAPHORE_RUNNER_IMAGE|public.ecr.aws/semaphore/pro/runner:latest|Semaphore runner Docker image|no
"

# Home Stack
ENV_VARS[home]="
HOME_COMPOSE_PROJECT_NAME|home|Home stack project name|yes
HOME_HOMEASSISTANT_IMAGE|ghcr.io/home-assistant/home-assistant:stable|Home Assistant Docker image|no
HOME_HOMEASSISTANT_PORT|8123|Home Assistant web UI port|no
TRAEFIK_HOST_HOME||Home Assistant hostname (e.g., home.example.com)|yes
HOME_MATTER_SERVER_IMAGE|ghcr.io/home-assistant-libs/python-matter-server:stable|Matter server Docker image|no
HOME_ZIGBEE2MQTT_IMAGE|koenkk/zigbee2mqtt:latest|Zigbee2MQTT Docker image|no
HOME_ZIGBEE2MQTT_PORT|8080|Zigbee2MQTT web UI port|no
TRAEFIK_HOST_ZIGBEE||Zigbee2MQTT hostname (e.g., zigbee.example.com)|no
HOME_ESPHOME_IMAGE|ghcr.io/esphome/esphome:stable|ESPHome Docker image|no
"

# Link Stack
ENV_VARS[link]="
LINK_COMPOSE_PROJECT_NAME|link|Link stack project name|yes
LINK_DOCKER_IMAGE|ghcr.io/linkwarden/linkwarden:latest|Linkwarden Docker image|no
LINK_DB_NAME|linkwarden|Linkwarden database name|yes
TRAEFIK_HOST_LINK||Linkwarden hostname (e.g., links.example.com)|yes
LINK_APP_PORT|3000|Linkwarden web UI port|no
LINK_DISABLE_SCREENSHOT|false|Disable automatic screenshots|no
LINK_DISABLE_ARCHIVE|false|Disable automatic archiving|no
LINK_DISABLE_REGISTRATION|false|Disable user registration|no
"

# Vault Stack
ENV_VARS[vault]="
VAULT_COMPOSE_PROJECT_NAME|vault|Vault stack project name|yes
VAULT_DOCKER_IMAGE|vaultwarden/server:latest|Vaultwarden Docker image|no
VAULT_DB_NAME|vaultwarden|Vaultwarden database name (optional)|no
TRAEFIK_HOST_VAULT||Vaultwarden hostname (e.g., vault.example.com)|yes
VAULT_WEBSOCKET_ENABLED|true|Enable WebSocket support|no
VAULT_SIGNUPS_ALLOWED|false|Allow new user registrations|no
VAULT_APP_PORT|80|Vaultwarden web UI port|no
VAULT_MQTT_ENABLED|true|Enable MQTT security event publishing|no
"

# Watch Stack (Monitoring)
ENV_VARS[watch]="
WATCH_COMPOSE_PROJECT_NAME|watch|Watch stack project name|yes
WATCH_PROMETHEUS_IMAGE|prom/prometheus:latest|Prometheus Docker image|no
WATCH_PROMETHEUS_RETENTION|30d|Prometheus data retention period|no
WATCH_PROMETHEUS_PORT|9090|Prometheus web UI port|no
TRAEFIK_HOST_PROMETHEUS||Prometheus hostname (e.g., prometheus.example.com)|yes
WATCH_GRAFANA_IMAGE|grafana/grafana:latest|Grafana Docker image|no
WATCH_GRAFANA_ADMIN_USER|admin|Grafana admin username|yes
WATCH_GRAFANA_PLUGINS|grafana-clock-panel,grafana-simple-json-datasource,grafana-piechart-panel,grafana-worldmap-panel|Grafana plugins to install|no
WATCH_GRAFANA_DB_NAME|grafana|Grafana database name|yes
WATCH_GRAFANA_DB_USER|grafana|Grafana database user|yes
WATCH_GRAFANA_PORT|3010|Grafana web UI port|no
TRAEFIK_HOST_GRAFANA||Grafana hostname (e.g., grafana.example.com)|yes
WATCH_OTEL_IMAGE|otel/opentelemetry-collector-contrib:latest|OpenTelemetry Collector Docker image|no
WATCH_OTEL_GRPC_PORT|4317|OTLP gRPC receiver port|no
WATCH_OTEL_HTTP_PORT|4318|OTLP HTTP receiver port|no
WATCH_OTEL_HEALTH_PORT|13133|OpenTelemetry health check port|no
WATCH_OTEL_ZPAGES_PORT|55679|OpenTelemetry zPages extension port|no
WATCH_POSTGRES_EXPORTER_IMAGE|prometheuscommunity/postgres-exporter:latest|PostgreSQL Exporter Docker image|no
WATCH_POSTGRES_EXPORTER_USER|kompose|PostgreSQL exporter database user|yes
WATCH_POSTGRES_EXPORTER_DB|kompose|PostgreSQL exporter database name|yes
WATCH_POSTGRES_EXPORTER_PORT|9187|PostgreSQL exporter metrics port|no
WATCH_REDIS_EXPORTER_IMAGE|oliver006/redis_exporter:latest|Redis Exporter Docker image|no
WATCH_REDIS_EXPORTER_PORT|9121|Redis exporter metrics port|no
WATCH_MQTT_EXPORTER_IMAGE|kpetrem/mqtt-exporter:latest|MQTT Exporter Docker image|no
WATCH_MQTT_EXPORTER_TOPIC|#|MQTT topics to monitor|no
WATCH_MQTT_V5_PROTOCOL|False|Use MQTT v5 protocol|no
WATCH_MQTT_EXPORTER_PORT|9000|MQTT exporter metrics port|no
WATCH_CADVISOR_IMAGE|gcr.io/cadvisor/cadvisor:latest|cAdvisor Docker image|no
WATCH_CADVISOR_PORT|8082|cAdvisor web UI port|no
WATCH_NODE_EXPORTER_IMAGE|prom/node-exporter:latest|Node Exporter Docker image|no
WATCH_BLACKBOX_EXPORTER_IMAGE|prom/blackbox-exporter:latest|Blackbox Exporter Docker image|no
WATCH_BLACKBOX_EXPORTER_PORT|9115|Blackbox exporter port|no
WATCH_LOKI_IMAGE|grafana/loki:latest|Loki Docker image|no
WATCH_LOKI_PORT|3100|Loki API port|no
TRAEFIK_HOST_LOKI||Loki hostname (e.g., loki.example.com)|no
WATCH_PROMTAIL_IMAGE|grafana/promtail:latest|Promtail Docker image|no
WATCH_PROMTAIL_PORT|9080|Promtail metrics port|no
WATCH_ALERTMANAGER_IMAGE|prom/alertmanager:latest|Alertmanager Docker image|no
WATCH_ALERTMANAGER_PORT|9093|Alertmanager web UI port|no
TRAEFIK_HOST_ALERTMANAGER||Alertmanager hostname (e.g., alerts.example.com)|no
"

# ============================================================================
# ENV HELPER FUNCTIONS
# ============================================================================

# Parse environment variable definition line
parse_env_line() {
    local line="$1"
    local var_name=$(echo "$line" | cut -d'|' -f1)
    local default_value=$(echo "$line" | cut -d'|' -f2)
    local description=$(echo "$line" | cut -d'|' -f3)
    local required=$(echo "$line" | cut -d'|' -f4)
    
    echo "${var_name}|${default_value}|${description}|${required}"
}

# List all environment variables for a stack
list_stack_env() {
    local stack="$1"
    local show_secrets="${2:-false}"
    
    if [ -z "${ENV_VARS[$stack]}" ]; then
        log_warning "No environment variables defined for stack: $stack"
        return 1
    fi
    
    echo -e "${CYAN}Environment variables for stack: ${MAGENTA}$stack${NC}\n"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    while IFS= read -r line; do
        [ -z "$line" ] && continue
        
        local parsed=$(parse_env_line "$line")
        local var_name=$(echo "$parsed" | cut -d'|' -f1)
        local default_value=$(echo "$parsed" | cut -d'|' -f2)
        local description=$(echo "$parsed" | cut -d'|' -f3)
        local required=$(echo "$parsed" | cut -d'|' -f4)
        
        local req_badge=""
        if [ "$required" = "yes" ]; then
            req_badge="${RED}[REQUIRED]${NC}"
        else
            req_badge="${GREEN}[OPTIONAL]${NC}"
        fi
        
        echo -e "${YELLOW}$var_name${NC} $req_badge"
        echo -e "  ${CYAN}Description:${NC} $description"
        if [ -n "$default_value" ]; then
            echo -e "  ${CYAN}Default:${NC} $default_value"
        else
            echo -e "  ${CYAN}Default:${NC} ${MAGENTA}(none)${NC}"
        fi
        echo ""
    done <<< "${ENV_VARS[$stack]}"
}

# Generate .env file for a stack
generate_stack_env_file() {
    local stack="$1"
    local output_file="${2:-$STACKS_ROOT/$stack/.env.example}"
    local overwrite="${3:-false}"
    
    if [ -z "${ENV_VARS[$stack]}" ]; then
        log_error "No environment variables defined for stack: $stack"
        return 1
    fi
    
    # Check if file exists and overwrite is false
    if [ -f "$output_file" ] && [ "$overwrite" != "true" ]; then
        log_warning "File already exists: $output_file"
        log_info "Use --force to overwrite"
        return 1
    fi
    
    log_info "Generating environment file: $output_file"
    
    # Create directory if it doesn't exist
    mkdir -p "$(dirname "$output_file")"
    
    # Generate file header
    cat > "$output_file" << EOF
# ============================================================================
# Environment Configuration - $stack Stack
# ============================================================================
# Generated by kompose.sh env generate
# Date: $(date '+%Y-%m-%d %H:%M:%S')
#
# Instructions:
# 1. Copy this file to .env in the same directory
# 2. Fill in the required values marked with [REQUIRED]
# 3. Adjust optional values as needed
# 4. DO NOT commit .env to version control (use .env.example instead)
# ============================================================================

EOF
    
    # Generate variables
    while IFS= read -r line; do
        [ -z "$line" ] && continue
        
        local parsed=$(parse_env_line "$line")
        local var_name=$(echo "$parsed" | cut -d'|' -f1)
        local default_value=$(echo "$parsed" | cut -d'|' -f2)
        local description=$(echo "$parsed" | cut -d'|' -f3)
        local required=$(echo "$parsed" | cut -d'|' -f4)
        
        # Add description as comment
        echo "# $description" >> "$output_file"
        
        # Add required badge
        if [ "$required" = "yes" ]; then
            echo "# [REQUIRED]" >> "$output_file"
        fi
        
        # Add variable with default value or placeholder
        if [ -n "$default_value" ]; then
            echo "${var_name}=${default_value}" >> "$output_file"
        else
            echo "${var_name}=" >> "$output_file"
        fi
        
        echo "" >> "$output_file"
    done <<< "${ENV_VARS[$stack]}"
    
    log_success "Generated: $output_file"
}

# Generate .env files for all stacks
generate_all_env_files() {
    local overwrite="${1:-false}"
    
    log_info "Generating environment files for all stacks..."
    echo ""
    
    local generated=0
    local skipped=0
    
    for stack in "${!ENV_VARS[@]}"; do
        local output_file="$STACKS_ROOT/$stack/.env.example"
        
        if generate_stack_env_file "$stack" "$output_file" "$overwrite"; then
            ((generated++))
        else
            ((skipped++))
        fi
        echo ""
    done
    
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    log_success "Generated: $generated files"
    if [ $skipped -gt 0 ]; then
        log_warning "Skipped: $skipped files (already exist)"
        log_info "Use --force to overwrite existing files"
    fi
}

# List all available stacks with environment variables
list_env_stacks() {
    echo -e "${CYAN}Stacks with environment variable definitions:${NC}\n"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    for stack in $(printf '%s\n' "${!ENV_VARS[@]}" | sort); do
        local var_count=$(echo "${ENV_VARS[$stack]}" | grep -c '|' || echo 0)
        echo -e "${YELLOW}  $stack${NC} - $var_count variables"
    done
    
    echo ""
    log_info "Use 'kompose env list <stack>' to see variables for a specific stack"
    log_info "Use 'kompose env generate <stack>' to create .env.example file"
}

# Export environment variables as JSON
export_env_json() {
    local stack="${1:-all}"
    local output_file="${2:-${ENV_VARS_JSON_OUTPUT:-env-vars.json}}"
    
    # If TEST_ARTIFACT_DIR is set and output_file is not an absolute path, prepend TEST_ARTIFACT_DIR
    if [ -n "${TEST_ARTIFACT_DIR}" ] && [[ "$output_file" != /* ]]; then
        output_file="${TEST_ARTIFACT_DIR}/${output_file}"
    fi
    
    log_info "Exporting environment variables to JSON: $output_file"
    
    if [ "$stack" = "all" ]; then
        # Export all stacks
        echo "{" > "$output_file"
        local first=true
        
        for s in $(printf '%s\n' "${!ENV_VARS[@]}" | sort); do
            if [ "$first" = true ]; then
                first=false
            else
                echo "," >> "$output_file"
            fi
            
            echo "  \"$s\": {" >> "$output_file"
            local first_var=true
            
            while IFS= read -r line; do
                [ -z "$line" ] && continue
                
                local parsed=$(parse_env_line "$line")
                local var_name=$(echo "$parsed" | cut -d'|' -f1)
                local default_value=$(echo "$parsed" | cut -d'|' -f2)
                local description=$(echo "$parsed" | cut -d'|' -f3)
                local required=$(echo "$parsed" | cut -d'|' -f4)
                
                if [ "$first_var" = true ]; then
                    first_var=false
                else
                    echo "," >> "$output_file"
                fi
                
                echo "    \"$var_name\": {" >> "$output_file"
                echo "      \"default\": \"$default_value\"," >> "$output_file"
                echo "      \"description\": \"$description\"," >> "$output_file"
                echo "      \"required\": $( [ "$required" = "yes" ] && echo "true" || echo "false" )" >> "$output_file"
                echo -n "    }" >> "$output_file"
            done <<< "${ENV_VARS[$s]}"
            
            echo "" >> "$output_file"
            echo -n "  }" >> "$output_file"
        done
        
        echo "" >> "$output_file"
        echo "}" >> "$output_file"
    else
        # Export single stack
        if [ -z "${ENV_VARS[$stack]}" ]; then
            log_error "Stack not found: $stack"
            return 1
        fi
        
        echo "{" > "$output_file"
        local first=true
        
        while IFS= read -r line; do
            [ -z "$line" ] && continue
            
            local parsed=$(parse_env_line "$line")
            local var_name=$(echo "$parsed" | cut -d'|' -f1)
            local default_value=$(echo "$parsed" | cut -d'|' -f2)
            local description=$(echo "$parsed" | cut -d'|' -f3)
            local required=$(echo "$parsed" | cut -d'|' -f4)
            
            if [ "$first" = true ]; then
                first=false
            else
                echo "," >> "$output_file"
            fi
            
            echo "  \"$var_name\": {" >> "$output_file"
            echo "    \"default\": \"$default_value\"," >> "$output_file"
            echo "    \"description\": \"$description\"," >> "$output_file"
            echo "    \"required\": $( [ "$required" = "yes" ] && echo "true" || echo "false" )" >> "$output_file"
            echo -n "  }" >> "$output_file"
        done <<< "${ENV_VARS[$stack]}"
        
        echo "" >> "$output_file"
        echo "}" >> "$output_file"
    fi
    
    log_success "Exported to: $output_file"
}

# ============================================================================
# ENV COMMAND HANDLER
# ============================================================================

handle_env_command() {
    local subcommand="${1:-list}"
    shift || true
    
    case "$subcommand" in
        list)
            if [ $# -eq 0 ]; then
                list_env_stacks
            else
                local stack="$1"
                list_stack_env "$stack"
            fi
            ;;
        
        generate)
            local stack="${1:-all}"
            local force=false
            
            # Parse options
            shift || true
            while [ $# -gt 0 ]; do
                case "$1" in
                    -f|--force)
                        force=true
                        shift
                        ;;
                    *)
                        log_error "Unknown option: $1"
                        return 1
                        ;;
                esac
            done
            
            if [ "$stack" = "all" ]; then
                generate_all_env_files "$force"
            else
                if [ -z "${ENV_VARS[$stack]}" ]; then
                    log_error "Stack not found: $stack"
                    log_info "Available stacks:"
                    list_env_stacks
                    return 1
                fi
                generate_stack_env_file "$stack" "$STACKS_ROOT/$stack/.env.example" "$force"
            fi
            ;;
        
        export)
            local stack="${1:-all}"
            local output_file="${2:-env-vars.json}"
            export_env_json "$stack" "$output_file"
            ;;
        
        stacks)
            list_env_stacks
            ;;
        
        help|--help|-h)
            cat << EOF
${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}
${CYAN}║           KOMPOSE - Environment Variable Management           ║${NC}
${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}

${BLUE}ENV COMMANDS:${NC}
    list [STACK]         List environment variables (all stacks or specific)
    generate [STACK]     Generate .env.example file (all stacks or specific)
    export [STACK] [FILE] Export variables to JSON file
    stacks               List all stacks with environment variables
    help                 Show this help message

${BLUE}OPTIONS:${NC}
    -f, --force          Force overwrite existing files

${BLUE}EXAMPLES:${NC}
    ${GREEN}# List all stacks with environment variables${NC}
    kompose env list

    ${GREEN}# List variables for a specific stack${NC}
    kompose env list core

    ${GREEN}# Generate .env.example for all stacks${NC}
    kompose env generate all

    ${GREEN}# Generate .env.example for core stack${NC}
    kompose env generate core

    ${GREEN}# Force overwrite existing files${NC}
    kompose env generate all --force

    ${GREEN}# Export all variables to JSON${NC}
    kompose env export all env-config.json

    ${GREEN}# Export specific stack to JSON${NC}
    kompose env export auth auth-env.json

EOF
            ;;
        
        *)
            log_error "Unknown env subcommand: $subcommand"
            echo ""
            echo "Available commands: list, generate, export, stacks, help"
            echo "Use 'kompose env help' for more information"
            return 1
            ;;
    esac
}

# ============================================================================
# STACK UTILITY FUNCTIONS
# ============================================================================
# These functions are used by kompose-stack.sh for internal operations

# Export environment variables for a stack
# This loads .env files and exports variables to the shell
export_stack_env() {
    local stack="$1"
    
    # Load root .env file if it exists
    if [ -f "${STACKS_ROOT}/.env" ]; then
        set -a
        source "${STACKS_ROOT}/.env"
        set +a
    fi
    
    # Load domain.env if it exists
    if [ -f "${STACKS_ROOT}/domain.env" ]; then
        set -a
        source "${STACKS_ROOT}/domain.env"
        set +a
    fi
    
    # Load secrets.env if it exists
    if [ -f "${STACKS_ROOT}/secrets.env" ]; then
        set -a
        source "${STACKS_ROOT}/secrets.env"
        set +a
    fi
    
    # Determine stack directory
    local stack_dir="${STACKS_ROOT}/${stack}"
    if [ ! -d "$stack_dir" ] || [ ! -f "${stack_dir}/${COMPOSE_FILE}" ]; then
        stack_dir="${STACKS_ROOT}/+custom/${stack}"
    fi
    
    # Load stack-specific .env if it exists
    if [ -f "${stack_dir}/.env" ]; then
        set -a
        source "${stack_dir}/.env"
        set +a
    fi
}

# Validate environment variables for a stack
validate_stack_env() {
    local stack="$1"
    local has_errors=false
    
    # Check if stack has defined variables
    if [ -z "${ENV_VARS[$stack]}" ]; then
        # Stack doesn't have predefined variables, skip validation
        return 0
    fi
    
    # Export environment to check variables
    export_stack_env "$stack" > /dev/null 2>&1
    
    # Check required variables
    while IFS= read -r line; do
        [ -z "$line" ] && continue
        
        local parsed=$(parse_env_line "$line")
        local var_name=$(echo "$parsed" | cut -d'|' -f1)
        local required=$(echo "$parsed" | cut -d'|' -f4)
        
        if [ "$required" = "yes" ]; then
            # Check if variable is set and not empty
            if [ -z "${!var_name}" ]; then
                if [ "$has_errors" = false ]; then
                    echo ""
                    log_error "Missing required environment variables for stack: $stack"
                    echo ""
                    has_errors=true
                fi
                echo -e "  ${RED}✗${NC} ${YELLOW}$var_name${NC} - not set"
            fi
        fi
    done <<< "${ENV_VARS[$stack]}"
    
    if [ "$has_errors" = true ]; then
        echo ""
        log_info "Run 'kompose env list $stack' to see all required variables"
        log_info "Run 'kompose env generate $stack' to create .env.example file"
        return 1
    fi
    
    return 0
}

# Show environment variables for a stack
show_stack_env() {
    local stack="$1"
    
    # Export environment to get current values
    export_stack_env "$stack" > /dev/null 2>&1
    
    echo ""
    echo -e "${CYAN}Environment configuration for stack: ${MAGENTA}$stack${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    if [ -z "${ENV_VARS[$stack]}" ]; then
        log_warning "No predefined variables for this stack"
        echo ""
        log_info "Showing all exported variables matching stack name..."
        echo ""
        
        # Show variables that start with the stack name (uppercase)
        local stack_upper=$(echo "$stack" | tr '[:lower:]' '[:upper:]')
        env | grep "^${stack_upper}_" | sort | while IFS='=' read -r var_name var_value; do
            echo -e "  ${YELLOW}$var_name${NC} = $var_value"
        done
        echo ""
        return 0
    fi
    
    # Show defined variables with their current values
    while IFS= read -r line; do
        [ -z "$line" ] && continue
        
        local parsed=$(parse_env_line "$line")
        local var_name=$(echo "$parsed" | cut -d'|' -f1)
        local default_value=$(echo "$parsed" | cut -d'|' -f2)
        local description=$(echo "$parsed" | cut -d'|' -f3)
        local required=$(echo "$parsed" | cut -d'|' -f4)
        
        # Get current value
        local current_value="${!var_name}"
        
        # Determine status
        local status
        if [ -n "$current_value" ]; then
            status="${GREEN}✓ SET${NC}"
        elif [ "$required" = "yes" ]; then
            status="${RED}✗ MISSING${NC}"
        else
            status="${YELLOW}○ UNSET${NC}"
        fi
        
        echo -e "${YELLOW}$var_name${NC} $status"
        
        if [ -n "$current_value" ]; then
            # Mask sensitive values
            if [[ $var_name =~ PASSWORD|SECRET|TOKEN|KEY ]]; then
                echo -e "  ${CYAN}Value:${NC} ${MAGENTA}[MASKED]${NC}"
            else
                echo -e "  ${CYAN}Value:${NC} $current_value"
            fi
        elif [ -n "$default_value" ]; then
            echo -e "  ${CYAN}Default:${NC} $default_value"
        fi
        
        echo ""
    done <<< "${ENV_VARS[$stack]}"
}
