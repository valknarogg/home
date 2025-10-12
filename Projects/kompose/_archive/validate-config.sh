#!/bin/bash

# ===================================================================
# Kompose Configuration Validation Script
# ===================================================================
# This script validates all configuration files and compose files
# to ensure everything is properly configured
# ===================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║           Kompose Configuration Validation                     ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Track validation status
ERRORS=0
WARNINGS=0
PASSED=0

# Function to log results
log_pass() {
    echo -e "  ${GREEN}✓${NC} $1"
    ((PASSED++))
}

log_warn() {
    echo -e "  ${YELLOW}⚠${NC} $1"
    ((WARNINGS++))
}

log_error() {
    echo -e "  ${RED}✗${NC} $1"
    ((ERRORS++))
}

log_info() {
    echo -e "  ${BLUE}ℹ${NC} $1"
}

# Section header
section() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# ===================================================================
# 1. Check Required Files
# ===================================================================
section "Checking Required Files"

# Check for domain.env
if [ -f "domain.env" ]; then
    log_pass "domain.env exists"
    
    # Validate it can be sourced
    if source domain.env 2>/dev/null; then
        log_pass "domain.env is valid shell syntax"
        
        # Check ROOT_DOMAIN is set
        if [ -n "$ROOT_DOMAIN" ]; then
            log_pass "ROOT_DOMAIN is configured: $ROOT_DOMAIN"
        else
            log_error "ROOT_DOMAIN is not set in domain.env"
        fi
    else
        log_error "domain.env has syntax errors"
    fi
else
    log_error "domain.env not found"
    log_info "Run: ./migrate-domain-config.sh to create it"
fi

# Check for .env
if [ -f ".env" ]; then
    log_pass ".env exists"
else
    log_error ".env not found"
fi

# Check for secrets.env or secrets.env.template
if [ -f "secrets.env" ]; then
    log_pass "secrets.env exists"
    
    # Check if it's just the template
    if grep -q "CHANGE_ME" secrets.env; then
        log_warn "secrets.env contains CHANGE_ME placeholders"
        log_info "Run: ./kompose.sh secrets generate"
    else
        log_pass "secrets.env appears to be configured"
    fi
elif [ -f "secrets.env.template" ]; then
    log_warn "secrets.env not found, only template exists"
    log_info "Copy secrets.env.template to secrets.env and configure it"
else
    log_error "No secrets configuration found"
fi

# Check for kompose.sh
if [ -f "kompose.sh" ]; then
    log_pass "kompose.sh exists"
    
    if [ -x "kompose.sh" ]; then
        log_pass "kompose.sh is executable"
    else
        log_warn "kompose.sh is not executable"
        log_info "Run: chmod +x kompose.sh"
    fi
else
    log_error "kompose.sh not found"
fi

# ===================================================================
# 2. Validate Domain Configuration
# ===================================================================
section "Validating Domain Configuration"

if [ -f "domain.env" ] && [ -f ".env" ]; then
    source domain.env 2>/dev/null || true
    
    # Check if subdomains are defined
    required_subdomains=(
        "SUBDOMAIN_PROXY"
        "SUBDOMAIN_AUTH"
        "SUBDOMAIN_CHAIN"
        "SUBDOMAIN_CODE"
    )
    
    for subdomain in "${required_subdomains[@]}"; do
        if [ -n "${!subdomain}" ]; then
            log_pass "$subdomain is configured: ${!subdomain}"
        else
            log_warn "$subdomain is not set"
        fi
    done
    
    # Check if ACME_EMAIL is set
    if [ -n "$ACME_EMAIL" ]; then
        log_pass "ACME_EMAIL is configured: $ACME_EMAIL"
    else
        log_warn "ACME_EMAIL not set (needed for Let's Encrypt)"
    fi
fi

# ===================================================================
# 3. Validate Docker Network
# ===================================================================
section "Validating Docker Network"

if docker network inspect kompose &>/dev/null; then
    log_pass "Docker network 'kompose' exists"
else
    log_warn "Docker network 'kompose' not found"
    log_info "Run: docker network create kompose"
fi

# ===================================================================
# 4. Validate Compose Files
# ===================================================================
section "Validating Compose Files"

# Find all compose.yaml files (excluding docs and backups)
compose_files=$(find . -name "compose.yaml" \
    ! -path "./_docs/*" \
    ! -path "./backups/*" \
    ! -path "./node_modules/*" \
    -type f)

if [ -z "$compose_files" ]; then
    log_error "No compose.yaml files found"
else
    compose_count=0
    valid_count=0
    invalid_count=0
    
    while IFS= read -r compose_file; do
        ((compose_count++))
        stack_dir=$(dirname "$compose_file")
        stack_name=$(basename "$stack_dir")
        
        # Validate compose file syntax
        cd "$stack_dir"
        if docker-compose config > /dev/null 2>&1; then
            log_pass "$stack_name/compose.yaml is valid"
            ((valid_count++))
        else
            log_error "$stack_name/compose.yaml has errors"
            ((invalid_count++))
        fi
        cd - > /dev/null
    done <<< "$compose_files"
    
    log_info "Validated $compose_count compose files: $valid_count valid, $invalid_count invalid"
fi

# ===================================================================
# 5. Check for Legacy Files
# ===================================================================
section "Checking for Legacy Files"

# Check for .bak files
bak_count=$(find . -name "*.bak" ! -path "./_docs/*" ! -path "./backups/*" 2>/dev/null | wc -l)
if [ "$bak_count" -eq 0 ]; then
    log_pass "No .bak files found"
else
    log_warn "Found $bak_count .bak files"
    log_info "Run: ./cleanup-project.sh to remove them"
fi

# Check for .new files
new_count=$(find . -name "*.new" ! -path "./_docs/*" ! -path "./backups/*" 2>/dev/null | wc -l)
if [ "$new_count" -eq 0 ]; then
    log_pass "No .new files found"
else
    log_warn "Found $new_count .new files"
    log_info "Run: ./cleanup-project.sh to remove them"
fi

# Check for docker-compose.yml duplicates
yml_count=$(find . -name "docker-compose.yml" ! -path "./_docs/*" ! -path "./backups/*" 2>/dev/null | wc -l)
if [ "$yml_count" -eq 0 ]; then
    log_pass "No docker-compose.yml duplicates found"
else
    log_warn "Found $yml_count docker-compose.yml files (should use compose.yaml)"
    log_info "Run: ./cleanup-project.sh to remove them"
fi

# ===================================================================
# 6. Check Docker Installation
# ===================================================================
section "Checking Docker Installation"

if command -v docker &> /dev/null; then
    log_pass "Docker is installed"
    docker_version=$(docker --version | awk '{print $3}' | tr -d ',')
    log_info "Docker version: $docker_version"
else
    log_error "Docker is not installed"
    log_info "Install with: curl -fsSL https://get.docker.com | sh"
fi

if command -v docker-compose &> /dev/null; then
    log_pass "Docker Compose is installed"
    compose_version=$(docker-compose --version | awk '{print $4}' | tr -d ',')
    log_info "Docker Compose version: $compose_version"
else
    log_error "Docker Compose is not installed"
fi

# Check if Docker daemon is running
if docker info &> /dev/null; then
    log_pass "Docker daemon is running"
else
    log_error "Docker daemon is not running"
    log_info "Start with: sudo systemctl start docker"
fi

# ===================================================================
# 7. Security Checks
# ===================================================================
section "Security Checks"

# Check if secrets.env is in .gitignore
if [ -f ".gitignore" ]; then
    if grep -q "secrets.env" .gitignore; then
        log_pass "secrets.env is in .gitignore"
    else
        log_warn "secrets.env is not in .gitignore"
        log_info "Add it to prevent committing secrets"
    fi
else
    log_warn ".gitignore not found"
fi

# Check file permissions on secrets.env
if [ -f "secrets.env" ]; then
    perms=$(stat -c %a secrets.env 2>/dev/null || stat -f %A secrets.env 2>/dev/null)
    if [ "$perms" = "600" ] || [ "$perms" = "400" ]; then
        log_pass "secrets.env has secure permissions ($perms)"
    else
        log_warn "secrets.env has insecure permissions ($perms)"
        log_info "Run: chmod 600 secrets.env"
    fi
fi

# ===================================================================
# Summary
# ===================================================================
echo ""
echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                  Validation Summary                            ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${GREEN}Passed:${NC}   $PASSED"
echo -e "${YELLOW}Warnings:${NC} $WARNINGS"
echo -e "${RED}Errors:${NC}   $ERRORS"
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✓ Configuration is valid and ready to use!${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Start services: ./kompose.sh up"
    echo "  2. Check status:   ./kompose.sh status"
    echo "  3. View logs:      ./kompose.sh logs"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠ Configuration has warnings but should work${NC}"
    echo ""
    echo "Consider addressing the warnings above for optimal setup."
    exit 0
else
    echo -e "${RED}✗ Configuration has errors that must be fixed${NC}"
    echo ""
    echo "Please address the errors above before starting services."
    exit 1
fi
