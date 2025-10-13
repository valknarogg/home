#!/bin/bash

# kompose-utils.sh - Utility Functions
# Part of kompose.sh - Docker Compose Stack Manager

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

make_executable() {
    local target=${1:-"all"}
    
    case $target in
        all)
            log_info "Making all kompose scripts executable..."
            chmod +x kompose.sh
            chmod +x kompose-*.sh
            chmod +x test-api.sh
            log_success "All scripts are now executable"
            ;;
        core)
            log_info "Making core kompose scripts executable..."
            chmod +x kompose.sh
            chmod +x kompose-*.sh
            log_success "Core scripts are now executable"
            ;;
        api)
            log_info "Making API server scripts executable..."
            chmod +x kompose-api-server.sh
            chmod +x test-api.sh
            log_success "API scripts are now executable"
            ;;
        *)
            log_error "Unknown target: $target"
            log_info "Available targets: all, core, api"
            exit 1
            ;;
    esac
}

validate_configuration() {
    log_info "Validating kompose configuration..."
    echo ""
    
    local errors=0
    local warnings=0
    
    # Check required files
    if [ -f "domain.env" ]; then
        log_success "domain.env exists"
        
        # Validate it can be sourced
        if source domain.env 2>/dev/null; then
            log_success "domain.env is valid"
            
            # Check ROOT_DOMAIN is set
            if [ -n "$ROOT_DOMAIN" ]; then
                log_success "ROOT_DOMAIN is configured: $ROOT_DOMAIN"
            else
                log_error "ROOT_DOMAIN is not set in domain.env"
                errors=$((errors+1))
            fi
        else
            log_error "domain.env has syntax errors"
            errors=$((errors+1))
        fi
    else
        log_error "domain.env not found"
        errors=$((errors+1))
    fi
    
    # Check for .env
    if [ -f ".env" ]; then
        log_success ".env exists"
    else
        log_error ".env not found"
        errors=$((errors+1))
    fi
    
    # Check for secrets
    if [ -f "secrets.env" ]; then
        log_success "secrets.env exists"
        
        if grep -q "CHANGE_ME" secrets.env 2>/dev/null; then
            log_warning "secrets.env contains CHANGE_ME placeholders"
            warnings=$((warnings+1))
        fi
    else
        log_warning "secrets.env not found (using template)"
        warnings=$((warnings+1))
    fi
    
    # Check Docker network
    if docker network inspect kompose &>/dev/null; then
        log_success "Docker network 'kompose' exists"
    else
        log_warning "Docker network 'kompose' not found"
        log_info "Create with: docker network create kompose"
        warnings=$((warnings+1))
    fi
    
    # Validate all compose files
    log_info "Validating compose files..."
    local stacks=$(get_all_stacks)
    local valid=0
    local invalid=0
    
    for stack in $stacks; do
        if stack_exists "$stack" 2>/dev/null; then
            cd "${STACKS_ROOT}/${stack}"
            if docker-compose config > /dev/null 2>&1; then
                valid=$((valid+1))
            else
                log_error "Invalid compose file: $stack"
                invalid=$((invalid+1))
                errors=$((errors+1))
            fi
            cd "${STACKS_ROOT}"
        fi
    done
    
    log_info "Compose files: $valid valid, $invalid invalid"
    
    # Summary
    echo ""
    if [ $errors -eq 0 ] && [ $warnings -eq 0 ]; then
        log_success "Configuration is valid!"
        return 0
    elif [ $errors -eq 0 ]; then
        log_warning "Configuration has $warnings warning(s)"
        return 0
    else
        log_error "Configuration has $errors error(s) and $warnings warning(s)"
        return 1
    fi
}

cleanup_project() {
    log_warning "This will remove backup files (.bak, .new) and legacy files"
    read -p "Continue? (yes/no): " confirm
    
    if [[ "$confirm" != "yes" ]]; then
        log_info "Cleanup cancelled"
        return 0
    fi
    
    log_info "Cleaning up project..."
    
    # Remove .bak files
    local bak_count=$(find . -name "*.bak" ! -path "./_docs/*" ! -path "./backups/*" ! -path "./node_modules/*" 2>/dev/null | wc -l)
    if [ "$bak_count" -gt 0 ]; then
        find . -name "*.bak" ! -path "./_docs/*" ! -path "./backups/*" ! -path "./node_modules/*" -delete 2>/dev/null
        log_success "Removed $bak_count .bak files"
    fi
    
    # Remove .new files
    local new_count=$(find . -name "*.new" ! -path "./_docs/*" ! -path "./backups/*" ! -path "./node_modules/*" 2>/dev/null | wc -l)
    if [ "$new_count" -gt 0 ]; then
        find . -name "*.new" ! -path "./_docs/*" ! -path "./backups/*" ! -path "./node_modules/*" -delete 2>/dev/null
        log_success "Removed $new_count .new files"
    fi
    
    # Remove docker-compose.yml duplicates
    local yml_count=$(find . -name "docker-compose.yml" ! -path "./_docs/*" ! -path "./backups/*" ! -path "./node_modules/*" 2>/dev/null | wc -l)
    if [ "$yml_count" -gt 0 ]; then
        find . -name "docker-compose.yml" ! -path "./_docs/*" ! -path "./backups/*" ! -path "./node_modules/*" -delete 2>/dev/null
        log_success "Removed $yml_count docker-compose.yml duplicates"
    fi
    
    log_success "Cleanup complete"
}

show_version() {
    cat << EOF
${CYAN}kompose.sh${NC} - Docker Compose Stack Manager
Version: 2.0.0 (Modular)
Built: $(date +%Y-%m-%d)

Components:
  • kompose-stack.sh  - Stack management
  • kompose-db.sh     - Database operations
  • kompose-tag.sh    - Git tag deployments
  • kompose-api.sh    - REST API server
  • kompose-utils.sh  - Utility functions

EOF
}
