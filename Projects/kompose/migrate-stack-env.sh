#!/usr/bin/env bash

# ===================================================================
# Kompose Stack .env Migration Script
# ===================================================================
# This script updates all stack .env files to:
# 1. Add TRAEFIK_ENABLED=true (if not present)
# 2. Update TRAEFIK_HOST to use root .env variable
# 3. Remove sensitive secrets (move to secrets.env)
# 4. Add standardized comments
# ===================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${RESET} $*"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${RESET} $*"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${RESET} $*"
}

update_stack_env() {
    local stack="$1"
    local env_file="${SCRIPT_DIR}/${stack}/.env"
    
    if [[ ! -f "${env_file}" ]]; then
        log_warning "No .env file in ${stack}, skipping"
        return
    fi
    
    log_info "Updating ${stack}/.env..."
    
    local temp_file="${env_file}.new"
    
    # Read stack name
    local project_name=$(grep "^COMPOSE_PROJECT_NAME=" "${env_file}" | cut -d= -f2)
    local has_traefik_enabled=false
    local has_traefik_host=false
    
    # Check if file already has TRAEFIK_ENABLED
    if grep -q "^TRAEFIK_ENABLED=" "${env_file}"; then
        has_traefik_enabled=true
    fi
    
    # Check if file has TRAEFIK_HOST
    if grep -q "^TRAEFIK_HOST=" "${env_file}"; then
        has_traefik_host=true
    fi
    
    # Start building new file
    {
        echo "# ================================================================="
        echo "# ${stack^^} Stack Configuration"
        echo "# ================================================================="
        echo ""
        echo "# Stack identification"
        
        # Copy COMPOSE_PROJECT_NAME
        grep "^COMPOSE_PROJECT_NAME=" "${env_file}" || echo "COMPOSE_PROJECT_NAME=${stack}"
        
        echo ""
        echo "# Docker image"
        grep "^DOCKER_IMAGE=" "${env_file}" 2>/dev/null || true
        
        # Add database if present
        if grep -q "^DB_NAME=" "${env_file}"; then
            echo ""
            echo "# Database name"
            grep "^DB_NAME=" "${env_file}"
        fi
        
        echo ""
        echo "# Traefik configuration"
        
        # Add TRAEFIK_ENABLED if not present
        if ${has_traefik_enabled}; then
            grep "^TRAEFIK_ENABLED=" "${env_file}"
        else
            echo "TRAEFIK_ENABLED=true"
        fi
        
        # Update TRAEFIK_HOST to reference root variable
        if ${has_traefik_host}; then
            local uppercase_stack=$(echo "${stack}" | tr '[:lower:]' '[:upper:]')
            echo "TRAEFIK_HOST=\${TRAEFIK_HOST_${uppercase_stack}}"
        fi
        
        # Copy APP_PORT if present
        if grep -q "^APP_PORT=" "${env_file}"; then
            echo ""
            echo "# Application port"
            grep "^APP_PORT=" "${env_file}"
        fi
        
        # Copy other non-sensitive variables
        echo ""
        echo "# Additional configuration"
        grep -v "^COMPOSE_PROJECT_NAME=" "${env_file}" | \
        grep -v "^DOCKER_IMAGE=" | \
        grep -v "^DB_NAME=" | \
        grep -v "^TRAEFIK_ENABLED=" | \
        grep -v "^TRAEFIK_HOST=" | \
        grep -v "^APP_PORT=" | \
        grep -v "^#" | \
        grep -v "^$" | \
        grep -v "_SECRET=" | \
        grep -v "_PASSWORD=" | \
        grep -v "_TOKEN=" | \
        grep -v "_KEY=" || true
        
        # Add note about secrets
        echo ""
        echo "# NOTE: Secrets are stored in root secrets.env file"
        echo "# Available secrets for this stack:"
        local uppercase_stack=$(echo "${stack}" | tr '[:lower:]' '[:upper:]')
        
        # List stack-specific secrets from template
        if [[ -f "${SCRIPT_DIR}/secrets.env.template" ]]; then
            grep "^${uppercase_stack}_" "${SCRIPT_DIR}/secrets.env.template" | \
            sed 's/^/#   - /' || true
        fi
        
    } > "${temp_file}"
    
    # Show diff
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Changes for ${stack}/.env:"
    diff -u "${env_file}" "${temp_file}" || true
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    # Ask for confirmation
    read -p "Apply these changes? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        mv "${env_file}" "${env_file}.bak"
        mv "${temp_file}" "${env_file}"
        log_success "Updated ${stack}/.env (backup: ${stack}/.env.bak)"
    else
        rm "${temp_file}"
        log_info "Skipped ${stack}/.env"
    fi
}

# Main migration
main() {
    log_info "Starting stack .env migration..."
    echo ""
    
    # Get all stacks
    local stacks=(auth auto blog chain chat code dash data dock docs home link news proxy sexy trace track vault vpn)
    
    for stack in "${stacks[@]}"; do
        if [[ -d "${SCRIPT_DIR}/${stack}" ]]; then
            update_stack_env "${stack}"
            echo ""
        fi
    done
    
    log_success "Migration complete!"
    log_info "Review the changes and test with: ./kompose.sh --list"
}

main "$@"
