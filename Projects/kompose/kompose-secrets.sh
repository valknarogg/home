#!/bin/bash

# kompose-secrets.sh - Secrets management module
# Handles generation, validation, rotation, and management of sensitive credentials

# ============================================================================
# SECRET DEFINITIONS
# ============================================================================

# Define all required secrets per stack with their generation method
declare -A REQUIRED_SECRETS=(
    # Shared secrets
    ["DB_PASSWORD"]="password:32"
    ["REDIS_PASSWORD"]="password:32"
    ["REDIS_API_PASSWORD"]="password:32"
    ["ADMIN_PASSWORD"]="password:32"
    ["EMAIL_SMTP_PASSWORD"]="manual"
    
    # Auth stack
    ["KC_ADMIN_PASSWORD"]="password:32"
    ["AUTH_KC_ADMIN_PASSWORD"]="alias:KC_ADMIN_PASSWORD"
    ["OAUTH2_CLIENT_SECRET"]="base64:32"
    ["OAUTH2_COOKIE_SECRET"]="base64:32"
    ["AUTH_OAUTH2_CLIENT_SECRET"]="alias:OAUTH2_CLIENT_SECRET"
    ["AUTH_OAUTH2_COOKIE_SECRET"]="alias:OAUTH2_COOKIE_SECRET"
    
    # Code stack (Gitea)
    ["GITEA_SECRET_KEY"]="hex:64"
    ["GITEA_INTERNAL_TOKEN"]="hex:105"
    ["GITEA_OAUTH2_JWT_SECRET"]="base64:32"
    ["GITEA_METRICS_TOKEN"]="hex:32"
    ["CODE_RUNNER_TOKEN"]="manual"
    
    # Chain stack (n8n + Semaphore)
    ["N8N_ENCRYPTION_KEY"]="base64:32"
    ["AUTO_ENCRYPTION_KEY"]="alias:N8N_ENCRYPTION_KEY"
    ["N8N_BASIC_AUTH_PASSWORD"]="password:32"
    ["SEMAPHORE_ADMIN_PASSWORD"]="password:32"
    ["SEMAPHORE_RUNNER_TOKEN"]="base64:32"
    
    # KMPS stack
    ["KMPS_CLIENT_SECRET"]="manual"
    ["KMPS_NEXTAUTH_SECRET"]="base64:32"
    
    # DASH stack
    ["DASH_NEXTAUTH_SECRET"]="base64:32"
    
    # NEWS stack
    ["NEWS_JWT_SECRET"]="base64:32"
    
    # TRACK stack
    ["TRACK_APP_SECRET"]="base64:32"
    
    # VAULT stack
    ["VAULT_ADMIN_TOKEN"]="base64:32"
    
    # PROXY stack
    ["TRAEFIK_DASHBOARD_AUTH"]="htpasswd"
)

# Map secrets to stacks for better organization
declare -A SECRET_STACK_MAP=(
    ["DB_PASSWORD"]="core,auth,chain,code,kmps"
    ["REDIS_PASSWORD"]="core,auth"
    ["REDIS_API_PASSWORD"]="core"
    ["ADMIN_PASSWORD"]="shared"
    ["EMAIL_SMTP_PASSWORD"]="shared"
    
    ["KC_ADMIN_PASSWORD"]="auth"
    ["AUTH_KC_ADMIN_PASSWORD"]="auth"
    ["OAUTH2_CLIENT_SECRET"]="auth"
    ["OAUTH2_COOKIE_SECRET"]="auth"
    ["AUTH_OAUTH2_CLIENT_SECRET"]="auth"
    ["AUTH_OAUTH2_COOKIE_SECRET"]="auth"
    
    ["GITEA_SECRET_KEY"]="code"
    ["GITEA_INTERNAL_TOKEN"]="code"
    ["GITEA_OAUTH2_JWT_SECRET"]="code"
    ["GITEA_METRICS_TOKEN"]="code"
    ["CODE_RUNNER_TOKEN"]="code"
    
    ["N8N_ENCRYPTION_KEY"]="chain"
    ["AUTO_ENCRYPTION_KEY"]="chain"
    ["N8N_BASIC_AUTH_PASSWORD"]="chain"
    ["SEMAPHORE_ADMIN_PASSWORD"]="chain"
    ["SEMAPHORE_RUNNER_TOKEN"]="chain"
    
    ["KMPS_CLIENT_SECRET"]="kmps"
    ["KMPS_NEXTAUTH_SECRET"]="kmps"
    
    ["DASH_NEXTAUTH_SECRET"]="dash"
    ["NEWS_JWT_SECRET"]="news"
    ["TRACK_APP_SECRET"]="track"
    ["VAULT_ADMIN_TOKEN"]="vault"
    ["TRAEFIK_DASHBOARD_AUTH"]="proxy"
)

# Secret descriptions for documentation
declare -A SECRET_DESCRIPTIONS=(
    ["DB_PASSWORD"]="PostgreSQL password for all database connections"
    ["REDIS_PASSWORD"]="Redis password for cache and session storage"
    ["REDIS_API_PASSWORD"]="Redis password for API access"
    ["ADMIN_PASSWORD"]="Default admin password for services"
    ["EMAIL_SMTP_PASSWORD"]="SMTP password for sending emails"
    
    ["KC_ADMIN_PASSWORD"]="Keycloak admin console password"
    ["OAUTH2_CLIENT_SECRET"]="OAuth2 Proxy client secret"
    ["OAUTH2_COOKIE_SECRET"]="OAuth2 Proxy cookie encryption key"
    
    ["GITEA_SECRET_KEY"]="Gitea secret key for encryption"
    ["GITEA_INTERNAL_TOKEN"]="Gitea internal API token"
    ["GITEA_OAUTH2_JWT_SECRET"]="Gitea OAuth2 JWT signing key"
    ["GITEA_METRICS_TOKEN"]="Gitea metrics API token"
    ["CODE_RUNNER_TOKEN"]="Gitea Actions runner registration token"
    
    ["N8N_ENCRYPTION_KEY"]="n8n workflow credentials encryption key"
    ["N8N_BASIC_AUTH_PASSWORD"]="n8n basic auth password"
    ["SEMAPHORE_ADMIN_PASSWORD"]="Semaphore admin password"
    ["SEMAPHORE_RUNNER_TOKEN"]="Semaphore runner token"
    
    ["KMPS_CLIENT_SECRET"]="KMPS Keycloak client secret"
    ["KMPS_NEXTAUTH_SECRET"]="KMPS NextAuth session encryption key"
    
    ["DASH_NEXTAUTH_SECRET"]="Dashboard NextAuth session encryption key"
    ["NEWS_JWT_SECRET"]="Newsletter JWT signing key"
    ["TRACK_APP_SECRET"]="Umami application secret"
    ["VAULT_ADMIN_TOKEN"]="Vaultwarden admin panel token (optional)"
    ["TRAEFIK_DASHBOARD_AUTH"]="Traefik dashboard basic auth credentials"
)

# ============================================================================
# SECRET GENERATION FUNCTIONS
# ============================================================================

generate_password() {
    local length=${1:-32}
    openssl rand -base64 48 | tr -d "=+/" | cut -c1-${length}
}

generate_hex() {
    local length=${1:-32}
    openssl rand -hex $((length / 2))
}

generate_base64() {
    local length=${1:-32}
    openssl rand -base64 ${length}
}

generate_uuid() {
    if command -v uuidgen &> /dev/null; then
        uuidgen | tr '[:upper:]' '[:lower:]'
    else
        # Fallback UUID generation
        cat /proc/sys/kernel/random/uuid
    fi
}

generate_htpasswd() {
    local username="${1:-admin}"
    local password="${2:-}"
    
    if [ -z "$password" ]; then
        password=$(generate_password 16)
        # log_info "Generated password for htpasswd: $password"
    fi
    
    if command -v htpasswd &> /dev/null; then
        htpasswd -nb "$username" "$password" 2>/dev/null | tr -d '\n'
    else
        # Fallback using openssl
        local hash=$(echo -n "${password}" | openssl dgst -binary -md5 | openssl base64)
        echo "${username}:${hash}"
    fi
}

generate_secret_value() {
    local method=$1
    local param=$2
    
    case $method in
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
            generate_htpasswd "admin"
            ;;
        manual)
            echo "CHANGE_ME_MANUALLY"
            ;;
        alias)
            echo "\${$param}"
            ;;
        *)
            log_error "Unknown generation method: $method"
            return 1
            ;;
    esac
}

# ============================================================================
# SECRETS FILE MANAGEMENT
# ============================================================================

secrets_file_path() {
    echo "${STACKS_ROOT}/secrets.env"
}

secrets_template_path() {
    echo "${STACKS_ROOT}/secrets.env.template"
}

secrets_backup_path() {
    local timestamp=$(date +%Y%m%d_%H%M%S)
    echo "${STACKS_ROOT}/backups/secrets_${timestamp}.env"
}

ensure_secrets_file() {
    local secrets_file=$(secrets_file_path)
    
    if [ ! -f "$secrets_file" ]; then
        log_warning "secrets.env not found, creating from template..."
        
        local template=$(secrets_template_path)
        if [ -f "$template" ]; then
            cp "$template" "$secrets_file"
            log_success "Created secrets.env from template"
            return 0
        else
            log_error "secrets.env.template not found!"
            log_info "Cannot create secrets.env without template"
            return 1
        fi
    fi
    
    return 0
}

backup_secrets_file() {
    local secrets_file=$(secrets_file_path)
    
    if [ ! -f "$secrets_file" ]; then
        log_error "secrets.env not found, nothing to backup"
        return 1
    fi
    
    local backup_path=$(secrets_backup_path)
    mkdir -p "$(dirname "$backup_path")"
    
    cp "$secrets_file" "$backup_path"
    log_success "Backed up secrets to: $backup_path"
    
    echo "$backup_path"
}

# ============================================================================
# SECRET GENERATION COMMANDS
# ============================================================================

secrets_generate_all() {
    local force=${1:-false}
    local secrets_file=$(secrets_file_path)
    
    log_info "Generating secrets for Kompose..."
    echo ""
    
    # Backup existing secrets if present
    if [ -f "$secrets_file" ] && [ "$force" != "true" ]; then
        log_warning "secrets.env already exists!"
        read -p "Overwrite existing secrets? This cannot be undone! (y/N): " -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Aborted"
            return 1
        fi
        
        backup_secrets_file
        echo ""
    fi
    
    # Create new secrets file
    log_info "Generating new secrets..."
    
    cat > "$secrets_file" << 'EOF'
# ===================================================================
# KOMPOSE - Secrets Configuration
# ===================================================================
# GENERATED FILE - Keep this secure and do not commit to git!
# Generated: $(date)
# ===================================================================

EOF
    
    # Generate each secret
    local generated_count=0
    local manual_count=0
    
    # Group secrets by category
    log_info "Generating shared secrets..."
    for secret in DB_PASSWORD REDIS_PASSWORD REDIS_API_PASSWORD ADMIN_PASSWORD EMAIL_SMTP_PASSWORD; do
        local method=$(echo "${REQUIRED_SECRETS[$secret]}" | cut -d: -f1)
        local param=$(echo "${REQUIRED_SECRETS[$secret]}" | cut -d: -f2)
        
        if [ "$method" = "manual" ]; then
            echo "${secret}=CHANGE_ME_MANUALLY" >> "$secrets_file"
            manual_count=$((manual_count+1))
        else
            local value=$(generate_secret_value "$method" "$param")
            echo "${secret}=${value}" >> "$secrets_file"
            generated_count=$((generated_count+1))
        fi
    done
    echo "" >> "$secrets_file"
    
    log_info "Generating auth stack secrets..."
    echo "# Auth Stack Secrets" >> "$secrets_file"
    for secret in KC_ADMIN_PASSWORD AUTH_KC_ADMIN_PASSWORD OAUTH2_CLIENT_SECRET OAUTH2_COOKIE_SECRET AUTH_OAUTH2_CLIENT_SECRET AUTH_OAUTH2_COOKIE_SECRET; do
        local method=$(echo "${REQUIRED_SECRETS[$secret]}" | cut -d: -f1)
        local param=$(echo "${REQUIRED_SECRETS[$secret]}" | cut -d: -f2)
        
        local value=$(generate_secret_value "$method" "$param")
        echo "${secret}=${value}" >> "$secrets_file"
        generated_count=$((generated_count+1))
    done
    echo "" >> "$secrets_file"
    
    log_info "Generating code stack secrets..."
    echo "# Code Stack Secrets" >> "$secrets_file"
    for secret in GITEA_SECRET_KEY GITEA_INTERNAL_TOKEN GITEA_OAUTH2_JWT_SECRET GITEA_METRICS_TOKEN CODE_RUNNER_TOKEN; do
        local method=$(echo "${REQUIRED_SECRETS[$secret]}" | cut -d: -f1)
        local param=$(echo "${REQUIRED_SECRETS[$secret]}" | cut -d: -f2)
        
        if [ "$method" = "manual" ]; then
            echo "${secret}=GENERATE_IN_GITEA_UI" >> "$secrets_file"
            manual_count=$((manual_count+1))
        else
            local value=$(generate_secret_value "$method" "$param")
            echo "${secret}=${value}" >> "$secrets_file"
            generated_count=$((generated_count+1))
        fi
    done
    echo "" >> "$secrets_file"
    
    log_info "Generating chain stack secrets..."
    echo "# Chain Stack Secrets" >> "$secrets_file"
    for secret in N8N_ENCRYPTION_KEY AUTO_ENCRYPTION_KEY N8N_BASIC_AUTH_PASSWORD SEMAPHORE_ADMIN_PASSWORD SEMAPHORE_RUNNER_TOKEN; do
        local method=$(echo "${REQUIRED_SECRETS[$secret]}" | cut -d: -f1)
        local param=$(echo "${REQUIRED_SECRETS[$secret]}" | cut -d: -f2)
        
        local value=$(generate_secret_value "$method" "$param")
        echo "${secret}=${value}" >> "$secrets_file"
        generated_count=$((generated_count+1))
    done
    echo "" >> "$secrets_file"
    
    log_info "Generating other stack secrets..."
    echo "# Other Stack Secrets" >> "$secrets_file"
    for secret in KMPS_CLIENT_SECRET KMPS_NEXTAUTH_SECRET DASH_NEXTAUTH_SECRET NEWS_JWT_SECRET TRACK_APP_SECRET VAULT_ADMIN_TOKEN TRAEFIK_DASHBOARD_AUTH; do
        local method=$(echo "${REQUIRED_SECRETS[$secret]}" | cut -d: -f1)
        local param=$(echo "${REQUIRED_SECRETS[$secret]}" | cut -d: -f2)
        
        if [ "$method" = "manual" ]; then
            echo "${secret}=CHANGE_ME_MANUALLY" >> "$secrets_file"
            manual_count=$((manual_count+1))
        else
            local value=$(generate_secret_value "$method" "$param")
            echo "${secret}=${value}" >> "$secrets_file"
            generated_count=$((generated_count+1))
        fi
    done
    
    echo ""
    log_success "Generated ${generated_count} secrets automatically"
    
    if [ $manual_count -gt 0 ]; then
        log_warning "${manual_count} secrets require manual configuration:"
        echo ""
        echo -e "  ${YELLOW}EMAIL_SMTP_PASSWORD${NC} - Your SMTP server password"
        echo -e "  ${YELLOW}CODE_RUNNER_TOKEN${NC} - Generate in Gitea UI after first setup"
        echo -e "  ${YELLOW}KMPS_CLIENT_SECRET${NC} - Generate in Keycloak after client setup"
        echo ""
    fi
    
    log_success "Secrets saved to: $secrets_file"
    log_warning "Keep this file secure! Add to .gitignore if not already."
}

secrets_generate_single() {
    local secret_name=$1
    local force=${2:-false}
    
    if [ -z "$secret_name" ]; then
        log_error "Secret name required"
        echo "Usage: kompose secrets generate SECRET_NAME"
        return 1
    fi
    
    # Check if secret is defined
    if [ -z "${REQUIRED_SECRETS[$secret_name]}" ]; then
        log_error "Unknown secret: $secret_name"
        log_info "Use 'kompose secrets list' to see available secrets"
        return 1
    fi
    
    local method=$(echo "${REQUIRED_SECRETS[$secret_name]}" | cut -d: -f1)
    local param=$(echo "${REQUIRED_SECRETS[$secret_name]}" | cut -d: -f2)
    
    if [ "$method" = "manual" ]; then
        log_warning "$secret_name requires manual configuration"
        log_info "${SECRET_DESCRIPTIONS[$secret_name]}"
        return 1
    fi
    
    local value=$(generate_secret_value "$method" "$param")
    
    echo ""
    log_info "Generated value for ${CYAN}${secret_name}${NC}:"
    echo ""
    echo -e "  ${GREEN}${value}${NC}"
    echo ""
    log_info "Description: ${SECRET_DESCRIPTIONS[$secret_name]}"
    echo ""
    
    # Ask if user wants to save to secrets.env
    if [ -f "$(secrets_file_path)" ]; then
        read -p "Update secrets.env with this value? (y/N): " -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            secrets_set "$secret_name" "$value"
        fi
    fi
}

# ============================================================================
# SECRET VALIDATION
# ============================================================================

secrets_validate() {
    local stack_filter=${1:-"all"}
    local secrets_file=$(secrets_file_path)
    
    if [ ! -f "$secrets_file" ]; then
        log_error "secrets.env not found!"
        log_info "Run: kompose secrets generate"
        return 1
    fi
    
    log_info "Validating secrets configuration..."
    echo ""
    
    # Source the secrets file
    set -a
    source "$secrets_file" 2>/dev/null
    set +a
    
    local total_count=0
    local valid_count=0
    local missing_count=0
    local weak_count=0
    local issues=()
    
    for secret_name in "${!REQUIRED_SECRETS[@]}"; do
        # Filter by stack if requested
        if [ "$stack_filter" != "all" ]; then
            local stacks="${SECRET_STACK_MAP[$secret_name]}"
            if [[ ! ",$stacks," =~ ",$stack_filter," ]]; then
                continue
            fi
        fi
        
        total_count=$((total_count+1))
        
        local value="${!secret_name}"
        local method=$(echo "${REQUIRED_SECRETS[$secret_name]}" | cut -d: -f1)
        
        # Check if secret is set
        if [ -z "$value" ]; then
            log_error "✗ $secret_name - NOT SET"
            issues+=("$secret_name is not set")
            missing_count=$((missing_count+1))
            continue
        fi
        
        # Check for placeholder values
        if [[ "$value" =~ CHANGE_ME|UPDATE_ME|GENERATE|your_|xxx ]]; then
            log_warning "⚠ $secret_name - PLACEHOLDER VALUE"
            issues+=("$secret_name contains placeholder value")
            weak_count=$((weak_count+1))
            continue
        fi
        
        # Validate based on method
        case $method in
            password)
                if [ ${#value} -lt 12 ]; then
                    log_warning "⚠ $secret_name - TOO SHORT (${#value} chars)"
                    issues+=("$secret_name is too short")
                    weak_count=$((weak_count+1))
                else
                    log_success "✓ $secret_name"
                    valid_count=$((valid_count+1))
                fi
                ;;
            hex)
                local expected_length=$(echo "${REQUIRED_SECRETS[$secret_name]}" | cut -d: -f2)
                if [ ${#value} -ne $expected_length ]; then
                    log_warning "⚠ $secret_name - WRONG LENGTH (expected $expected_length, got ${#value})"
                    issues+=("$secret_name has wrong length")
                    weak_count=$((weak_count+1))
                else
                    log_success "✓ $secret_name"
                    valid_count=$((valid_count+1))
                fi
                ;;
            base64|alias)
                log_success "✓ $secret_name"
                valid_count=$((valid_count+1))
                ;;
            manual)
                if [ "$value" = "CHANGE_ME_MANUALLY" ]; then
                    log_warning "⚠ $secret_name - NEEDS MANUAL CONFIGURATION"
                    issues+=("$secret_name needs manual configuration")
                    weak_count=$((weak_count+1))
                else
                    log_success "✓ $secret_name"
                    valid_count=$((valid_count+1))
                fi
                ;;
            htpasswd)
                if [[ ! "$value" =~ : ]]; then
                    log_error "✗ $secret_name - INVALID FORMAT"
                    issues+=("$secret_name has invalid htpasswd format")
                    missing_count=$((missing_count+1))
                else
                    log_success "✓ $secret_name"
                    valid_count=$((valid_count+1))
                fi
                ;;
        esac
    done
    
    echo ""
    echo "═══════════════════════════════════════════════════════"
    echo "  Validation Summary"
    echo "═══════════════════════════════════════════════════════"
    echo ""
    echo "  Total Secrets:    $total_count"
    echo -e "  ${GREEN}Valid:            $valid_count${NC}"
    echo -e "  ${YELLOW}Weak/Placeholder: $weak_count${NC}"
    echo -e "  ${RED}Missing:          $missing_count${NC}"
    echo ""
    
    if [ $missing_count -eq 0 ] && [ $weak_count -eq 0 ]; then
        log_success "✓ All secrets are properly configured!"
        return 0
    else
        if [ $missing_count -gt 0 ]; then
            log_error "Some secrets are missing or invalid"
        fi
        if [ $weak_count -gt 0 ]; then
            log_warning "Some secrets need attention"
        fi
        
        echo ""
        log_info "Issues found:"
        for issue in "${issues[@]}"; do
            echo "  • $issue"
        done
        echo ""
        log_info "Run: kompose secrets generate --force"
        return 1
    fi
}

# ============================================================================
# SECRET LISTING
# ============================================================================

secrets_list() {
    local stack_filter=${1:-"all"}
    local show_values=${2:-false}
    
    local secrets_file=$(secrets_file_path)
    
    if [ -f "$secrets_file" ]; then
        set -a
        source "$secrets_file" 2>/dev/null
        set +a
    fi
    
    echo ""
    log_info "═══════════════════════════════════════════════════════"
    if [ "$stack_filter" = "all" ]; then
        log_info "  All Secrets"
    else
        log_info "  Secrets for Stack: $stack_filter"
    fi
    log_info "═══════════════════════════════════════════════════════"
    echo ""
    
    local current_stack=""
    local count=0
    
    for secret_name in $(echo "${!REQUIRED_SECRETS[@]}" | tr ' ' '\n' | sort); do
        # Filter by stack if requested
        local stacks="${SECRET_STACK_MAP[$secret_name]}"
        if [ "$stack_filter" != "all" ] && [[ ! ",$stacks," =~ ",$stack_filter," ]]; then
            continue
        fi
        
        # Print stack header if changed
        if [ "$stacks" != "$current_stack" ]; then
            if [ -n "$current_stack" ]; then
                echo ""
            fi
            echo "${CYAN}${stacks^^}:${NC}"
            current_stack="$stacks"
        fi
        
        local value="${!secret_name}"
        local method=$(echo "${REQUIRED_SECRETS[$secret_name]}" | cut -d: -f1)
        local status_icon="○"
        local status_color="$NC"
        
        if [ -n "$value" ] && [[ ! "$value" =~ CHANGE_ME|UPDATE_ME|GENERATE|your_|xxx ]]; then
            status_icon="●"
            status_color="$GREEN"
        elif [ -n "$value" ]; then
            status_icon="◐"
            status_color="$YELLOW"
        else
            status_icon="○"
            status_color="$RED"
        fi
        
        printf "  ${status_color}${status_icon}${NC} %-30s %s\n" "$secret_name" "${SECRET_DESCRIPTIONS[$secret_name]}"
        
        if [ "$show_values" = "true" ] && [ -n "$value" ]; then
            echo "    ${CYAN}Value:${NC} ${value:0:20}..."
        fi
        
        count=$((count+1))
    done
    
    echo ""
    echo "${count} secrets listed"
    echo ""
    echo "Legend: ${GREEN}●${NC} Set  ${YELLOW}◐${NC} Placeholder  ${RED}○${NC} Missing"
    echo ""
    
    if [ "$show_values" = "false" ]; then
        log_info "Use --show-values to display secret values"
    fi
}

# ============================================================================
# SECRET ROTATION
# ============================================================================

secrets_rotate() {
    local secret_name=$1
    
    if [ -z "$secret_name" ]; then
        log_error "Secret name required"
        echo "Usage: kompose secrets rotate SECRET_NAME"
        return 1
    fi
    
    if [ -z "${REQUIRED_SECRETS[$secret_name]}" ]; then
        log_error "Unknown secret: $secret_name"
        return 1
    fi
    
    local method=$(echo "${REQUIRED_SECRETS[$secret_name]}" | cut -d: -f1)
    
    if [ "$method" = "manual" ]; then
        log_error "$secret_name requires manual configuration, cannot auto-rotate"
        return 1
    fi
    
    log_warning "Rotating secret: $secret_name"
    echo ""
    log_info "${SECRET_DESCRIPTIONS[$secret_name]}"
    echo ""
    
    # Get affected stacks
    local stacks="${SECRET_STACK_MAP[$secret_name]}"
    log_warning "This will affect stacks: ${YELLOW}${stacks}${NC}"
    echo ""
    
    read -p "Continue with rotation? (y/N): " -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Aborted"
        return 0
    fi
    
    # Backup first
    backup_secrets_file
    echo ""
    
    # Generate new value
    local param=$(echo "${REQUIRED_SECRETS[$secret_name]}" | cut -d: -f2)
    local new_value=$(generate_secret_value "$method" "$param")
    
    # Update secrets.env
    secrets_set "$secret_name" "$new_value"
    
    echo ""
    log_success "Secret rotated successfully"
    echo ""
    log_warning "Remember to restart affected stacks:"
    echo ""
    for stack in $(echo "$stacks" | tr ',' ' '); do
        echo "  ./kompose.sh restart $stack"
    done
    echo ""
}

secrets_set() {
    local secret_name=$1
    local value=$2
    local secrets_file=$(secrets_file_path)
    
    if [ ! -f "$secrets_file" ]; then
        log_error "secrets.env not found"
        return 1
    fi
    
    # Check if secret exists in file
    if grep -q "^${secret_name}=" "$secrets_file"; then
        # Update existing
        sed -i.bak "s|^${secret_name}=.*|${secret_name}=${value}|" "$secrets_file"
        log_success "Updated $secret_name in secrets.env"
    else
        # Add new
        echo "${secret_name}=${value}" >> "$secrets_file"
        log_success "Added $secret_name to secrets.env"
    fi
}

# ============================================================================
# SECRET EXPORT/IMPORT
# ============================================================================

secrets_export() {
    local output_file=${1:-"secrets-export.json"}
    local secrets_file=$(secrets_file_path)
    
    if [ ! -f "$secrets_file" ]; then
        log_error "secrets.env not found"
        return 1
    fi
    
    log_warning "Exporting secrets to: $output_file"
    log_warning "This file will contain sensitive data!"
    echo ""
    
    read -p "Continue? (y/N): " -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Aborted"
        return 0
    fi
    
    # Source secrets
    set -a
    source "$secrets_file" 2>/dev/null
    set +a
    
    # Create JSON export
    echo "{" > "$output_file"
    echo "  \"exported_at\": \"$(date -Iseconds)\"," >> "$output_file"
    echo "  \"secrets\": {" >> "$output_file"
    
    local first=true
    for secret_name in $(echo "${!REQUIRED_SECRETS[@]}" | tr ' ' '\n' | sort); do
        local value="${!secret_name}"
        if [ -n "$value" ]; then
            if [ "$first" = false ]; then
                echo "," >> "$output_file"
            fi
            printf "    \"%s\": \"%s\"" "$secret_name" "$value" >> "$output_file"
            first=false
        fi
    done
    
    echo "" >> "$output_file"
    echo "  }" >> "$output_file"
    echo "}" >> "$output_file"
    
    log_success "Secrets exported to: $output_file"
    log_warning "Keep this file secure!"
}

# ============================================================================
# SECRETS COMMAND HANDLER
# ============================================================================

handle_secrets_command() {
    local subcmd=${1:-list}
    shift
    
    # Parse options
    local FORCE=false
    local SHOW_VALUES=false
    local STACK_FILTER="all"
    
    while [ $# -gt 0 ]; do
        case $1 in
            -f|--force)
                FORCE=true
                shift
                ;;
            -s|--stack)
                STACK_FILTER="$2"
                shift 2
                ;;
            --show-values)
                SHOW_VALUES=true
                shift
                ;;
            *)
                break
                ;;
        esac
    done
    
    case $subcmd in
        generate|gen)
            if [ $# -gt 0 ]; then
                secrets_generate_single "$1" "$FORCE"
            else
                secrets_generate_all "$FORCE"
            fi
            ;;
        validate|check)
            secrets_validate "$STACK_FILTER"
            ;;
        list|ls)
            secrets_list "$STACK_FILTER" "$SHOW_VALUES"
            ;;
        rotate)
            if [ $# -eq 0 ]; then
                log_error "Secret name required"
                echo "Usage: kompose secrets rotate SECRET_NAME"
                exit 1
            fi
            secrets_rotate "$1"
            ;;
        set)
            if [ $# -lt 2 ]; then
                log_error "Secret name and value required"
                echo "Usage: kompose secrets set SECRET_NAME VALUE"
                exit 1
            fi
            secrets_set "$1" "$2"
            ;;
        backup)
            backup_secrets_file
            ;;
        export)
            secrets_export "$1"
            ;;
        help|-h|--help)
            cat << EOF
Secrets Management Commands:

  ./kompose.sh secrets <command> [options]

Commands:
  generate [NAME]    Generate all secrets or a specific secret
  validate           Validate secrets configuration
  list              List all secrets and their status
  rotate NAME        Rotate a specific secret (generate new value)
  set NAME VALUE     Set a specific secret value
  backup            Create backup of secrets.env
  export [FILE]      Export secrets to JSON file

Options:
  -f, --force        Force operation without confirmation
  -s, --stack STACK  Filter secrets by stack
  --show-values      Show actual secret values (use with caution)

Examples:
  # Generate all secrets
  kompose secrets generate

  # Generate specific secret
  kompose secrets generate OAUTH2_COOKIE_SECRET

  # Validate secrets
  kompose secrets validate

  # List secrets for a specific stack
  kompose secrets list -s auth

  # Rotate a secret
  kompose secrets rotate DB_PASSWORD

  # Set a secret manually
  kompose secrets set KMPS_CLIENT_SECRET abc123xyz

EOF
            ;;
        *)
            log_error "Unknown secrets command: $subcmd"
            echo ""
            echo "Available commands: generate, validate, list, rotate, set, backup, export, help"
            exit 1
            ;;
    esac
}
