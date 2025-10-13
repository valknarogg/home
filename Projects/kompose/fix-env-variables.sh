#!/bin/bash
# =================================================================
# Kompose Environment Variable Correction - Main Orchestrator
# =================================================================
# This script coordinates the correction of environment variable
# mismatches across all Docker Compose files and configuration files
# =================================================================

set -e  # Exit on error

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Banner
echo "=========================================="
echo "Kompose Environment Variable Fix"
echo "=========================================="
echo ""

# Step 1: Create backup
log_info "Step 1: Creating backup of current configuration..."
if [ -f "./scripts/backup-before-fix.sh" ]; then
    bash ./scripts/backup-before-fix.sh
    log_success "Backup created successfully"
else
    log_warning "Backup script not found, creating backup manually..."
    mkdir -p backups/env-fix-$(date +%Y%m%d_%H%M%S)
    BACKUP_DIR="backups/env-fix-$(date +%Y%m%d_%H%M%S)"
    
    # Backup all compose files
    find . -name "compose.yaml" -not -path "./backups/*" -exec cp --parents {} "$BACKUP_DIR" \;
    
    # Backup env files
    cp .env "$BACKUP_DIR/.env.backup" 2>/dev/null || true
    cp .env.production "$BACKUP_DIR/.env.production.backup" 2>/dev/null || true
    cp domain.env "$BACKUP_DIR/domain.env.backup" 2>/dev/null || true
    cp secrets.env "$BACKUP_DIR/secrets.env.backup" 2>/dev/null || true
    
    log_success "Manual backup created at $BACKUP_DIR"
fi

echo ""

# Step 2: Fix compose.yaml files
log_info "Step 2: Updating compose.yaml files with correct variable names..."
if [ -f "./scripts/fix-compose-files.sh" ]; then
    bash ./scripts/fix-compose-files.sh
    log_success "Compose files updated successfully"
else
    log_error "Fix script not found: ./scripts/fix-compose-files.sh"
    exit 1
fi

echo ""

# Step 3: Add missing variables to .env files
log_info "Step 3: Adding missing variables to .env files..."
if [ -f "./scripts/add-missing-env-vars.sh" ]; then
    bash ./scripts/add-missing-env-vars.sh
    log_success "Environment variables added successfully"
else
    log_error "Fix script not found: ./scripts/add-missing-env-vars.sh"
    exit 1
fi

echo ""

# Step 4: Update domain.env
log_info "Step 4: Updating domain.env with missing Traefik hosts..."
if [ -f "./scripts/fix-domain-env.sh" ]; then
    bash ./scripts/fix-domain-env.sh
    log_success "Domain configuration updated successfully"
else
    log_error "Fix script not found: ./scripts/fix-domain-env.sh"
    exit 1
fi

echo ""

# Step 5: Add missing secrets
log_info "Step 5: Adding missing secrets to secrets.env..."
if [ -f "./scripts/add-missing-secrets.sh" ]; then
    bash ./scripts/add-missing-secrets.sh
    log_success "Secrets added successfully"
else
    log_error "Fix script not found: ./scripts/add-missing-secrets.sh"
    exit 1
fi

echo ""

# Step 6: Verification
log_info "Step 6: Running verification checks..."
if [ -f "./scripts/verify-env-config.sh" ]; then
    bash ./scripts/verify-env-config.sh
    log_success "Verification completed"
else
    log_warning "Verification script not found, skipping verification"
fi

echo ""
echo "=========================================="
log_success "Environment variable correction completed!"
echo "=========================================="
echo ""
log_info "Next steps:"
echo "  1. Review the changes made to your compose files"
echo "  2. Check .env, .env.production, domain.env, and secrets.env"
echo "  3. Test deployment: ./kompose.sh stack:up <stack-name>"
echo "  4. If issues occur, restore from backup: $BACKUP_DIR"
echo ""
log_warning "Important: Review secrets.env and update placeholder values"
echo ""
