#!/bin/bash

# migrate-to-centralized-env.sh
# Migrates from per-stack .env files to centralized root .env configuration

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

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

echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║        Kompose Environment Migration Tool                      ║${NC}"
echo -e "${CYAN}║  Migrating to Centralized Environment Configuration           ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Step 1: Backup existing .env files
log_info "Step 1: Backing up existing .env files"
BACKUP_DIR="${SCRIPT_DIR}/backups/env-migration-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

for stack_dir in "${SCRIPT_DIR}"/*; do
    if [ -d "$stack_dir" ] && [ -f "${stack_dir}/.env" ]; then
        stack_name=$(basename "$stack_dir")
        # Skip special directories
        if [[ "$stack_name" =~ ^\+|^_|^backups ]]; then
            continue
        fi
        
        log_info "  Backing up ${stack_name}/.env"
        cp "${stack_dir}/.env" "${BACKUP_DIR}/${stack_name}.env"
    fi
done

log_success "Backed up .env files to: $BACKUP_DIR"
echo ""

# Step 2: Replace root .env with new centralized version
log_info "Step 2: Installing new centralized .env file"

if [ -f "${SCRIPT_DIR}/.env" ]; then
    log_info "  Backing up current root .env"
    cp "${SCRIPT_DIR}/.env" "${BACKUP_DIR}/root.env"
fi

if [ -f "${SCRIPT_DIR}/.env.new" ]; then
    log_info "  Installing new .env file"
    mv "${SCRIPT_DIR}/.env.new" "${SCRIPT_DIR}/.env"
    log_success "New centralized .env file installed"
else
    log_error ".env.new file not found! Please ensure it was created first."
    exit 1
fi

echo ""

# Step 3: Remove or rename stack .env files
log_info "Step 3: Removing individual stack .env files"

for stack_dir in "${SCRIPT_DIR}"/*; do
    if [ -d "$stack_dir" ] && [ -f "${stack_dir}/.env" ]; then
        stack_name=$(basename "$stack_dir")
        # Skip special directories
        if [[ "$stack_name" =~ ^\+|^_|^backups ]]; then
            continue
        fi
        
        log_info "  Removing ${stack_name}/.env (backup exists)"
        rm "${stack_dir}/.env"
    fi
done

log_success "Individual stack .env files removed"
echo ""

# Step 4: Create .gitignore entries for generated files
log_info "Step 4: Updating .gitignore for generated .env files"

if [ -f "${SCRIPT_DIR}/.gitignore" ]; then
    # Add .env.generated to gitignore if not already there
    if ! grep -q "\.env\.generated" "${SCRIPT_DIR}/.gitignore"; then
        echo "" >> "${SCRIPT_DIR}/.gitignore"
        echo "# Auto-generated stack environment files" >> "${SCRIPT_DIR}/.gitignore"
        echo "**/.env.generated" >> "${SCRIPT_DIR}/.gitignore"
        log_success "Updated .gitignore"
    else
        log_info "  .gitignore already configured"
    fi
fi

echo ""

# Step 5: Verify migration
log_info "Step 5: Verifying migration"

if [ -f "${SCRIPT_DIR}/.env" ] && [ -f "${SCRIPT_DIR}/kompose-env.sh" ]; then
    log_success "✓ New .env file exists"
    log_success "✓ Environment management module exists"
    
    # Check if any old .env files remain
    old_env_count=0
    for stack_dir in "${SCRIPT_DIR}"/*; do
        if [ -d "$stack_dir" ] && [ -f "${stack_dir}/.env" ]; then
            stack_name=$(basename "$stack_dir")
            if [[ ! "$stack_name" =~ ^\+|^_|^backups ]]; then
                ((old_env_count++))
            fi
        fi
    done
    
    if [ $old_env_count -eq 0 ]; then
        log_success "✓ All stack .env files removed"
    else
        log_warning "⚠ Found $old_env_count remaining stack .env files"
    fi
else
    log_error "Migration verification failed!"
    exit 1
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                 Migration Completed Successfully!              ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

log_info "Next steps:"
echo "  1. Review the new .env file: ${SCRIPT_DIR}/.env"
echo "  2. Update secrets.env with your actual secrets"
echo "  3. Test each stack: ./kompose.sh up <stack>"
echo "  4. Verify configuration: ./kompose.sh validate"
echo ""
log_info "Backups are located at: $BACKUP_DIR"
echo ""

# Ask if user wants to test a stack
read -p "Would you like to test a stack now? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Available stacks:"
    ls -d ${SCRIPT_DIR}/*/ | grep -v "^\+\|^_\|backups" | xargs -n1 basename
    echo ""
    read -p "Enter stack name to test: " stack_name
    
    if [ -d "${SCRIPT_DIR}/${stack_name}" ]; then
        log_info "Testing stack: $stack_name"
        cd "${SCRIPT_DIR}"
        ./kompose.sh validate "$stack_name"
    else
        log_error "Stack not found: $stack_name"
    fi
fi

echo ""
log_success "Migration complete! Your old .env files are safely backed up."
