#!/bin/bash

# kompose-secrets.sh - Secrets Management Module
# Part of kompose.sh - Docker Compose Stack Manager
# Handles generation, validation, rotation, and management of secrets

# ============================================================================
# SECRETS CONFIGURATION
# ============================================================================

SECRETS_ENV_FILE="${SECRETS_ENV_FILE:-${SCRIPT_DIR}/secrets.env}"
SECRETS_TEMPLATE_FILE="${SECRETS_TEMPLATE_FILE:-${SCRIPT_DIR}/secrets.env.template}"
SECRETS_BACKUP_DIR="${SECRETS_BACKUP_DIR:-${SCRIPT_DIR}/backups/secrets}"

# Define all secrets and their generation methods
declare -A SECRET_DEFINITIONS=(
    # Shared Database Secrets
    ["DB_PASSWORD"]="password:32"
    ["REDIS_PASSWORD"]="password:32"
    ["CORE_REDIS_API_PASSWORD"]="password:24"
    
    # Shared Email Secrets
    ["EMAIL_SMTP_PASSWORD"]="skip" # User-provided or empty for local development
    
    # Auth Stack Secrets
    ["AUTH_KEYCLOAK_ADMIN_PASSWORD"]="password:24"
    ["AUTH_OAUTH2_CLIENT_SECRET"]="password:32"
    ["AUTH_OAUTH2_COOKIE_SECRET"]="base64:32"
    
    # Code Stack Secrets (Gitea)
    ["CODE_GITEA_SECRET_KEY"]="hex:64"
    ["CODE_GITEA_INTERNAL_TOKEN"]="hex:105"
    ["CODE_GITEA_OAUTH2_JWT_SECRET"]="base64:32"
    ["CODE_GITEA_METRICS_TOKEN"]="hex:32"
    ["CODE_GITEA_RUNNER_TOKEN"]="uuid"
    
    # Chain Stack Secrets
    ["CHAIN_N8N_ENCRYPTION_KEY"]="password:32"
    ["CHAIN_N8N_BASIC_AUTH_PASSWORD"]="password:24"
    ["CHAIN_SEMAPHORE_ADMIN_PASSWORD"]="password:24"
    ["CHAIN_SEMAPHORE_RUNNER_TOKEN"]="uuid"
    
    # KMPS Stack Secrets
    ["KMPS_CLIENT_SECRET"]="skip" # Generated in Keycloak UI
    ["KMPS_NEXTAUTH_SECRET"]="password:32"
    
    # Messaging Stack Secrets
    ["MESSAGING_GOTIFY_DEFAULTUSER_PASS"]="password:24"
    
    # Track Stack Secrets
    ["TRACK_APP_SECRET"]="password:32"
    
    # VPN Stack Secrets
    ["VPN_PASSWORD"]="password:24"
    
    # Vault Stack Secrets
    ["VAULT_ADMIN_TOKEN"]="password:32"
    
    # Link Stack Secrets
    ["LINK_NEXTAUTH_SECRET"]="password:32"
    
    # Proxy Stack Secrets
    ["PROXY_DASHBOARD_AUTH"]="htpasswd:admin"
    
    # Watch Stack Secrets
    ["WATCH_GRAFANA_ADMIN_PASSWORD"]="password:24"
    ["WATCH_GRAFANA_DB_PASSWORD"]="password:32"
    ["WATCH_POSTGRES_EXPORTER_PASSWORD"]="password:32"
    ["WATCH_REDIS_EXPORTER_PASSWORD"]="password:32"
    ["WATCH_PROMETHEUS_AUTH"]="htpasswd:admin"
    ["WATCH_LOKI_AUTH"]="htpasswd:admin"
    ["WATCH_ALERTMANAGER_AUTH"]="htpasswd:admin"
)

# Stack to secrets mapping
declare -A STACK_SECRETS=(
    ["shared"]="DB_PASSWORD REDIS_PASSWORD EMAIL_SMTP_PASSWORD"
    ["core"]="DB_PASSWORD REDIS_PASSWORD CORE_REDIS_API_PASSWORD"
    ["auth"]="DB_PASSWORD AUTH_KEYCLOAK_ADMIN_PASSWORD AUTH_OAUTH2_CLIENT_SECRET AUTH_OAUTH2_COOKIE_SECRET REDIS_PASSWORD"
    ["code"]="DB_PASSWORD REDIS_PASSWORD CODE_GITEA_SECRET_KEY CODE_GITEA_INTERNAL_TOKEN CODE_GITEA_OAUTH2_JWT_SECRET CODE_GITEA_METRICS_TOKEN CODE_GITEA_RUNNER_TOKEN EMAIL_SMTP_PASSWORD"
    ["chain"]="DB_PASSWORD CHAIN_N8N_ENCRYPTION_KEY CHAIN_N8N_BASIC_AUTH_PASSWORD CHAIN_SEMAPHORE_ADMIN_PASSWORD CHAIN_SEMAPHORE_RUNNER_TOKEN EMAIL_SMTP_PASSWORD"
    ["kmps"]="DB_PASSWORD KMPS_CLIENT_SECRET KMPS_NEXTAUTH_SECRET"
    ["messaging"]="MESSAGING_GOTIFY_DEFAULTUSER_PASS EMAIL_SMTP_PASSWORD"
    ["track"]="DB_PASSWORD TRACK_APP_SECRET REDIS_PASSWORD"
    ["vpn"]="VPN_PASSWORD"
    ["vault"]="VAULT_ADMIN_TOKEN EMAIL_SMTP_PASSWORD"
    ["link"]="DB_PASSWORD LINK_NEXTAUTH_SECRET REDIS_PASSWORD"
    ["proxy"]="PROXY_DASHBOARD_AUTH"
    ["watch"]="WATCH_GRAFANA_ADMIN_PASSWORD WATCH_GRAFANA_DB_PASSWORD WATCH_POSTGRES_EXPORTER_PASSWORD WATCH_REDIS_EXPORTER_PASSWORD WATCH_PROMETHEUS_AUTH WATCH_LOKI_AUTH WATCH_ALERTMANAGER_AUTH"
)

# ============================================================================
# SECRET GENERATION FUNCTIONS
# ============================================================================

# Generate a random password
generate_password() {
    local length="${1:-32}"
    openssl rand -base64 48 | tr -d "=+/" | cut -c1-${length}
}

# Generate hex string
generate_hex() {
    local length="${1:-64}"
    local bytes=$((length / 2))
    if [ $((length % 2)) -ne 0 ]; then
        bytes=$((bytes + 1))
    fi
    openssl rand -hex ${bytes} | cut -c1-${length}
}

# Generate base64 secret
generate_base64() {
    local bytes="${1:-32}"
    openssl rand -base64 ${bytes}
}

# Generate UUID
generate_uuid() {
    if command -v uuidgen &> /dev/null; then
        uuidgen | tr '[:upper:]' '[:lower:]'
    else
        # Fallback UUID generation
        cat /proc/sys/kernel/random/uuid 2>/dev/null || \
        printf '%08x-%04x-%04x-%04x-%012x\n' \
            $RANDOM$RANDOM $RANDOM $((RANDOM & 0x0fff | 0x4000)) \
            $((RANDOM & 0x3fff | 0x8000)) $RANDOM$RANDOM$RANDOM
    fi
}

# Generate htpasswd entry
generate_htpasswd() {
    local username="${1:-admin}"
    local password="${2:-$(generate_password 24)}"
    
    if command -v htpasswd &> /dev/null; then
        echo $(htpasswd -nb ${username} ${password})
    else
        # Fallback: use openssl for basic MD5 (not as secure but works)
        # Redirect warning to stderr so it doesn't get captured in the output
        log_warning "htpasswd not found, using openssl fallback" >&2
        local salt=$(openssl rand -base64 8 | tr -d "=")
        local hash=$(echo -n "${password}${salt}" | openssl md5 -binary | openssl base64)
        echo "${username}:\$apr1\${salt}\${hash}"
    fi
}

# Generate a secret based on its type
generate_secret_value() {
    local secret_name="$1"
    local definition="${SECRET_DEFINITIONS[$secret_name]}"
    
    if [ -z "$definition" ]; then
        log_error "Unknown secret: $secret_name"
        return 1
    fi
    
    if [ "$definition" = "skip" ]; then
        echo ""
        return 0
    fi
    
    local type="${definition%%:*}"
    local param="${definition##*:}"
    
    case $type in
        password)
            generate_password "$param"
            ;;
        hex)
            generate_hex "$param"
            ;;
        base64)
            generate_base64 "$param"
            ;;
        uuid)
            generate_uuid
            ;;
        htpasswd)
            generate_htpasswd "$param"
            ;;
        *)
            log_error "Unknown secret type: $type"
            return 1
            ;;
    esac
}

# ============================================================================
# SECRETS MANAGEMENT FUNCTIONS
# ============================================================================

# Initialize secrets.env if it doesn't exist
init_secrets_file() {
    if [ ! -f "$SECRETS_ENV_FILE" ]; then
        if [ -f "$SECRETS_TEMPLATE_FILE" ]; then
            log_info "Creating secrets.env from template..."
            cp "$SECRETS_TEMPLATE_FILE" "$SECRETS_ENV_FILE"
            chmod 600 "$SECRETS_ENV_FILE"
            log_success "Created $SECRETS_ENV_FILE"
        else
            log_error "Template file not found: $SECRETS_TEMPLATE_FILE"
            return 1
        fi
    fi
}

# Read current secret value from secrets.env
get_secret_value() {
    local secret_name="$1"
    
    if [ ! -f "$SECRETS_ENV_FILE" ]; then
        return 1
    fi
    
    # Extract value, handling commented lines
    grep "^${secret_name}=" "$SECRETS_ENV_FILE" 2>/dev/null | cut -d'=' -f2- | tr -d '"' | tr -d "'"
}

# Set a secret value in secrets.env
set_secret_value() {
    local secret_name="$1"
    local secret_value="$2"
    local update_only="${3:-false}"
    
    init_secrets_file || return 1
    
    # Create a temporary file
    local temp_file="${SECRETS_ENV_FILE}.tmp"
    
    # Check if secret exists
    if grep -q "^${secret_name}=" "$SECRETS_ENV_FILE" 2>/dev/null; then
        # Update existing secret using awk (more reliable than sed for special characters)
        awk -v name="${secret_name}" -v value="${secret_value}" '
            $0 ~ "^" name "=" { print name "=" value; next }
            { print }
        ' "$SECRETS_ENV_FILE" > "$temp_file"
        
        # Move temp file to original
        mv "$temp_file" "$SECRETS_ENV_FILE"
        chmod 600 "$SECRETS_ENV_FILE"
    elif [ "$update_only" = "false" ]; then
        # Add new secret at the end
        echo "${secret_name}=${secret_value}" >> "$SECRETS_ENV_FILE"
    else
        log_warning "Secret $secret_name not found in $SECRETS_ENV_FILE"
        return 1
    fi
}

# Check if secret needs generation
needs_generation() {
    local secret_name="$1"
    local current_value=$(get_secret_value "$secret_name")
    
    # Skip if definition says to skip
    if [ "${SECRET_DEFINITIONS[$secret_name]}" = "skip" ]; then
        return 1
    fi
    
    # Needs generation if empty or contains placeholder
    if [ -z "$current_value" ] || [[ "$current_value" =~ CHANGE_ME ]] || [ "$current_value" = "CHANGE_ME_GENERATE_WITH_KOMPOSE" ]; then
        return 0
    fi
    
    return 1
}

# Generate a single secret
generate_single_secret() {
    local secret_name="$1"
    local force="${2:-false}"
    
    # Check if secret is defined
    if [ -z "${SECRET_DEFINITIONS[$secret_name]}" ]; then
        log_error "Unknown secret: $secret_name"
        log_info "Use 'kompose secrets list' to see available secrets"
        return 1
    fi
    
    # Skip if it's a manual secret
    if [ "${SECRET_DEFINITIONS[$secret_name]}" = "skip" ]; then
        log_warning "$secret_name: Manual configuration required (skipped)"
        return 0
    fi
    
    # Check if already has a value
    local current_value=$(get_secret_value "$secret_name")
    if [ -n "$current_value" ] && [[ ! "$current_value" =~ CHANGE_ME ]] && [ "$force" != "true" ]; then
        log_warning "$secret_name: Already has a value (use --force to overwrite)"
        return 0
    fi
    
    # Generate new value
    local new_value=$(generate_secret_value "$secret_name")
    if [ -z "$new_value" ]; then
        log_error "$secret_name: Failed to generate"
        return 1
    fi
    
    # Set the value
    if set_secret_value "$secret_name" "$new_value"; then
        log_success "$secret_name: Generated successfully"
        return 0
    else
        log_error "$secret_name: Failed to set value"
        return 1
    fi
}

# Generate all secrets
generate_all_secrets() {
    local force="${1:-false}"
    
    log_info "Generating secrets..."
    echo ""
    
    init_secrets_file || return 1
    
    local generated=0
    local skipped=0
    local errors=0
    
    for secret_name in "${!SECRET_DEFINITIONS[@]}"; do
        if generate_single_secret "$secret_name" "$force"; then
            if [ "${SECRET_DEFINITIONS[$secret_name]}" != "skip" ]; then
                generated=$((generated + 1))
            else
                skipped=$((skipped + 1))
            fi
        else
            errors=$((errors + 1))
        fi
    done
    
    echo ""
    log_info "Summary: $generated generated, $skipped skipped, $errors errors"
    
    if [ $errors -eq 0 ]; then
        log_success "Secrets generation complete!"
        return 0
    else
        log_warning "Secrets generation completed with errors"
        return 1
    fi
}

# Validate secrets configuration
validate_secrets() {
    log_info "Validating secrets configuration..."
    echo ""
    
    if [ ! -f "$SECRETS_ENV_FILE" ]; then
        log_error "secrets.env not found"
        log_info "Run: kompose secrets generate"
        return 1
    fi
    
    local missing=0
    local placeholders=0
    local manual=0
    local valid=0
    
    for secret_name in "${!SECRET_DEFINITIONS[@]}"; do
        local definition="${SECRET_DEFINITIONS[$secret_name]}"
        local current_value=$(get_secret_value "$secret_name")
        
        if [ "$definition" = "skip" ]; then
            if [ -z "$current_value" ]; then
                log_warning "$secret_name: Manual configuration required (empty)"
                manual=$((manual + 1))
            else
                log_info "$secret_name: Manual configuration (set)"
                valid=$((valid + 1))
            fi
        elif [ -z "$current_value" ]; then
            log_error "$secret_name: Missing"
            missing=$((missing + 1))
        elif [[ "$current_value" =~ CHANGE_ME ]]; then
            log_error "$secret_name: Contains placeholder"
            placeholders=$((placeholders + 1))
        else
            log_success "$secret_name: Valid"
            valid=$((valid + 1))
        fi
    done
    
    echo ""
    log_info "Summary: $valid valid, $missing missing, $placeholders with placeholders, $manual manual"
    
    if [ $missing -eq 0 ] && [ $placeholders -eq 0 ]; then
        log_success "All secrets are configured!"
        return 0
    else
        log_error "Some secrets need attention"
        log_info "Run: kompose secrets generate"
        return 1
    fi
}

# List all secrets
list_secrets() {
    local stack="${1:-all}"
    
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                       Secrets Overview                         ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    if [ "$stack" = "all" ]; then
        # List all stacks
        for stack_name in "${!STACK_SECRETS[@]}"; do
            echo -e "${BLUE}━━━ ${stack_name^^} Stack ━━━${NC}"
            
            local secrets_list="${STACK_SECRETS[$stack_name]}"
            for secret_name in $secrets_list; do
                local definition="${SECRET_DEFINITIONS[$secret_name]}"
                local current_value=$(get_secret_value "$secret_name")
                local status=""
                
                if [ "$definition" = "skip" ]; then
                    if [ -z "$current_value" ]; then
                        status="${YELLOW}[MANUAL]${NC}"
                    else
                        status="${GREEN}[SET]${NC}"
                    fi
                elif [ -z "$current_value" ]; then
                    status="${RED}[MISSING]${NC}"
                elif [[ "$current_value" =~ CHANGE_ME ]]; then
                    status="${YELLOW}[PLACEHOLDER]${NC}"
                else
                    status="${GREEN}[OK]${NC}"
                fi
                
                printf "  %-40s %s %s\n" "$secret_name" "$status" "(${definition})"
            done
            echo ""
        done
    else
        # List specific stack
        if [ -z "${STACK_SECRETS[$stack]}" ]; then
            log_error "Unknown stack: $stack"
            log_info "Available stacks: ${!STACK_SECRETS[@]}"
            return 1
        fi
        
        echo -e "${BLUE}━━━ ${stack^^} Stack Secrets ━━━${NC}"
        echo ""
        
        local secrets_list="${STACK_SECRETS[$stack]}"
        for secret_name in $secrets_list; do
            local definition="${SECRET_DEFINITIONS[$secret_name]}"
            local current_value=$(get_secret_value "$secret_name")
            local status=""
            
            if [ "$definition" = "skip" ]; then
                if [ -z "$current_value" ]; then
                    status="${YELLOW}[MANUAL]${NC}"
                else
                    status="${GREEN}[SET]${NC}"
                fi
            elif [ -z "$current_value" ]; then
                status="${RED}[MISSING]${NC}"
            elif [[ "$current_value" =~ CHANGE_ME ]]; then
                status="${YELLOW}[PLACEHOLDER]${NC}"
            else
                status="${GREEN}[OK]${NC}"
            fi
            
            printf "  %-40s %s\n" "$secret_name" "$status"
            printf "    Type: %s\n" "${definition}"
            if [ -n "$current_value" ] && [[ ! "$current_value" =~ CHANGE_ME ]]; then
                printf "    Value: %s\n" "${current_value:0:8}..."
            fi
            echo ""
        done
    fi
}

# Rotate a secret
rotate_secret() {
    local secret_name="$1"
    
    if [ -z "$secret_name" ]; then
        log_error "Secret name required"
        log_info "Usage: kompose secrets rotate SECRET_NAME"
        return 1
    fi
    
    log_warning "Rotating secret: $secret_name"
    log_warning "This will generate a new value and update secrets.env"
    
    read -p "Continue? (yes/no): " confirm
    if [[ "$confirm" != "yes" ]]; then
        log_info "Rotation cancelled"
        return 0
    fi
    
    # Backup current value
    local old_value=$(get_secret_value "$secret_name")
    if [ -n "$old_value" ]; then
        log_info "Backing up old value..."
        backup_secrets "before-rotate-${secret_name}"
    fi
    
    # Generate new value
    if generate_single_secret "$secret_name" "true"; then
        log_success "Secret rotated successfully"
        log_warning "Remember to restart affected services!"
        
        # Show which stacks use this secret
        echo ""
        log_info "This secret is used by:"
        for stack_name in "${!STACK_SECRETS[@]}"; do
            if [[ "${STACK_SECRETS[$stack_name]}" =~ $secret_name ]]; then
                echo "  - $stack_name"
            fi
        done
        
        return 0
    else
        log_error "Failed to rotate secret"
        return 1
    fi
}

# Backup secrets.env
backup_secrets() {
    local suffix="${1:-$(date +%Y%m%d_%H%M%S)}"
    
    if [ ! -f "$SECRETS_ENV_FILE" ]; then
        log_error "No secrets.env file to backup"
        return 1
    fi
    
    mkdir -p "$SECRETS_BACKUP_DIR"
    
    local backup_file="${SECRETS_BACKUP_DIR}/secrets.env.${suffix}"
    cp "$SECRETS_ENV_FILE" "$backup_file"
    chmod 600 "$backup_file"
    
    log_success "Secrets backed up to: $backup_file"
    return 0
}

# Export secrets to JSON
export_secrets() {
    local output_file="${1:-${SECRETS_JSON_OUTPUT:-secrets.json}}"
    local include_values="${2:-false}"
    
    if [ ! -f "$SECRETS_ENV_FILE" ]; then
        log_error "No secrets.env file to export"
        return 1
    fi
    
    # If TEST_ARTIFACT_DIR is set and output_file is not an absolute path, prepend TEST_ARTIFACT_DIR
    if [ -n "${TEST_ARTIFACT_DIR}" ] && [[ "$output_file" != /* ]]; then
        output_file="${TEST_ARTIFACT_DIR}/${output_file}"
    fi
    
    log_info "Exporting secrets to $output_file..."
    
    echo "{" > "$output_file"
    echo '  "secrets": {' >> "$output_file"
    
    local first=true
    for secret_name in "${!SECRET_DEFINITIONS[@]}"; do
        local definition="${SECRET_DEFINITIONS[$secret_name]}"
        local current_value=$(get_secret_value "$secret_name")
        
        if [ "$first" = true ]; then
            first=false
        else
            echo "," >> "$output_file"
        fi
        
        echo -n "    \"$secret_name\": {" >> "$output_file"
        echo -n " \"type\": \"${definition}\"" >> "$output_file"
        
        if [ "$include_values" = "true" ] && [ -n "$current_value" ]; then
            echo -n ", \"value\": \"$current_value\"" >> "$output_file"
        fi
        
        echo -n " }" >> "$output_file"
    done
    
    echo "" >> "$output_file"
    echo "  }," >> "$output_file"
    echo "  \"generated\": \"$(date -Iseconds)\"," >> "$output_file"
    echo "  \"version\": \"1.0\"" >> "$output_file"
    echo "}" >> "$output_file"
    
    chmod 600 "$output_file"
    log_success "Secrets exported to $output_file"
}

# ============================================================================
# COMMAND HANDLER
# ============================================================================

handle_secrets_command() {
    local subcommand="$1"
    shift
    
    case $subcommand in
        generate)
            local secret_name="${1:-}"
            local force=false
            
            # Parse options
            while [ $# -gt 0 ]; do
                case $1 in
                    -f|--force)
                        force=true
                        shift
                        ;;
                    *)
                        secret_name="$1"
                        shift
                        ;;
                esac
            done
            
            if [ -z "$secret_name" ]; then
                generate_all_secrets "$force"
            else
                generate_single_secret "$secret_name" "$force"
            fi
            ;;
            
        validate)
            validate_secrets
            ;;
            
        list)
            local stack="${1:-all}"
            list_secrets "$stack"
            ;;
            
        rotate)
            local secret_name="$1"
            if [ -z "$secret_name" ]; then
                log_error "Secret name required"
                log_info "Usage: kompose secrets rotate SECRET_NAME"
                exit 1
            fi
            rotate_secret "$secret_name"
            ;;
            
        set)
            local secret_name="$1"
            local secret_value="$2"
            
            if [ -z "$secret_name" ] || [ -z "$secret_value" ]; then
                log_error "Secret name and value required"
                log_info "Usage: kompose secrets set SECRET_NAME VALUE"
                exit 1
            fi
            
            if set_secret_value "$secret_name" "$secret_value"; then
                log_success "Secret $secret_name updated"
            else
                log_error "Failed to update secret"
                exit 1
            fi
            ;;
            
        backup)
            backup_secrets "$1"
            ;;
            
        export)
            local output_file="${1:-secrets.json}"
            local include_values=false
            
            if [ "$2" = "--with-values" ]; then
                log_warning "Exporting with values - keep this file secure!"
                include_values=true
            fi
            
            export_secrets "$output_file" "$include_values"
            ;;
            
        *)
            log_error "Unknown secrets command: $subcommand"
            echo ""
            echo "Available commands:"
            echo "  generate [SECRET]  - Generate all secrets or specific secret"
            echo "  validate           - Validate secrets configuration"
            echo "  list [STACK]       - List all secrets or secrets for a specific stack"
            echo "  rotate SECRET      - Rotate (regenerate) a specific secret"
            echo "  set SECRET VALUE   - Set a specific secret value"
            echo "  backup [SUFFIX]    - Backup secrets.env file"
            echo "  export [FILE]      - Export secrets metadata to JSON"
            echo ""
            echo "Options:"
            echo "  -f, --force        - Force operation (overwrite existing secrets)"
            echo "  --with-values      - Include secret values in export (use with caution)"
            exit 1
            ;;
    esac
}
