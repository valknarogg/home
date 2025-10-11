#!/bin/bash

# =================================================================
# Rename "home" stack to "core" stack
# =================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║           Rename 'home' stack to 'core' stack                  ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if home directory exists
if [[ ! -d "./home" ]]; then
    log_error "home directory not found"
    exit 1
fi

# Check if core directory already exists with stack files
if [[ -f "./core/compose.yaml" ]]; then
    log_error "core/compose.yaml already exists. Manual intervention required."
    log_info "The core directory contains service configs. Please rename manually."
    exit 1
fi

# Step 1: Check if home stack is running
log_info "Step 1: Checking if home stack is running"
if docker ps | grep -q "home_app\|home-postgres\|home_mqtt"; then
    log_warning "Home stack is currently running"
    read -p "Stop the home stack now? (yes/no): " stop
    if [[ "$stop" == "yes" ]]; then
        log_info "Stopping home stack..."
        ./kompose.sh down home || log_warning "Could not stop with kompose, trying docker-compose"
        cd home && docker-compose down && cd .. || true
        log_success "Home stack stopped"
    else
        log_error "Cannot rename while stack is running. Exiting."
        exit 1
    fi
else
    log_info "Home stack is not running"
fi

# Step 2: Create backup
BACKUP_DIR="./backups/rename-home-to-core"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

log_info "Step 2: Creating backup"
mkdir -p "$BACKUP_DIR"
tar czf "${BACKUP_DIR}/home-stack-backup-${TIMESTAMP}.tar.gz" ./home
log_success "Backup created: ${BACKUP_DIR}/home-stack-backup-${TIMESTAMP}.tar.gz"

# Step 3: Update files in home directory
log_info "Step 3: Updating configuration files"

# Update compose.yaml
if [[ -f "./home/compose.yaml" ]]; then
    sed -i.bak 's/^name: home$/name: core/' ./home/compose.yaml
    sed -i.bak 's/home-postgres/core-postgres/g' ./home/compose.yaml
    sed -i.bak 's/home_/core_/g' ./home/compose.yaml
    log_success "Updated home/compose.yaml"
fi

# Update .env
if [[ -f "./home/.env" ]]; then
    sed -i.bak 's/^COMPOSE_PROJECT_NAME=home$/COMPOSE_PROJECT_NAME=core/' ./home/.env
    sed -i.bak 's/^# HOME Stack/# CORE Stack/' ./home/.env
    log_success "Updated home/.env"
fi

# Update docker-compose.yml if exists
if [[ -f "./home/docker-compose.yml" ]]; then
    sed -i.bak 's/home-postgres/core-postgres/g' ./home/docker-compose.yml
    sed -i.bak 's/home_/core_/g' ./home/docker-compose.yml
    log_success "Updated home/docker-compose.yml"
fi

# Step 4: Handle directory rename
log_info "Step 4: Renaming directory"

# Since we can't rename directly due to existing core dir, we need a workaround
if [[ -d "./core" ]]; then
    log_info "Moving existing core directory to core-services"
    mv ./core ./core-services
    log_success "Moved core → core-services (service configs)"
fi

# Now rename home to core
mv ./home ./core-stack-temp
mv ./core-stack-temp ./core
log_success "Renamed home → core"

# Restore core-services if it exists
if [[ -d "./core-services" ]]; then
    log_info "Note: Service configs are now in ./core-services directory"
fi

# Step 5: Update secrets.env if it references home
if [[ -f "./secrets.env" ]]; then
    if grep -q "home-postgres" ./secrets.env; then
        log_info "Updating references in secrets.env"
        sed -i.bak 's/home-postgres/core-postgres/g' ./secrets.env
        log_success "Updated secrets.env"
    fi
fi

# Step 6: Verify the changes
log_info "Step 5: Verifying changes"
echo ""
log_info "Updated files:"
if [[ -f "./core/compose.yaml" ]]; then
    echo "  ✓ core/compose.yaml (was home/compose.yaml)"
fi
if [[ -f "./core/.env" ]]; then
    echo "  ✓ core/.env (was home/.env)"
fi
echo ""

# Step 7: Summary and next steps
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                    Rename Complete!                            ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""
log_success "The 'home' stack has been renamed to 'core'"
echo ""
log_info "Next steps:"
echo "  1. Review the changes in ./core/ directory"
echo "  2. Update any custom scripts that reference 'home' stack"
echo "  3. Start the core stack: ./kompose.sh up core"
echo "  4. Verify: ./kompose.sh status core"
echo ""
log_info "Backup location: ${BACKUP_DIR}/home-stack-backup-${TIMESTAMP}.tar.gz"
echo ""
log_warning "Important notes:"
echo "  - The old 'core' directory (service configs) → 'core-services'"
echo "  - All container names changed from home_* → core_*"
echo "  - PostgreSQL container: home-postgres → core-postgres"
echo "  - Update any external references to these container names"
echo ""

read -p "Start the core stack now? (yes/no): " start
if [[ "$start" == "yes" ]]; then
    log_info "Starting core stack..."
    ./kompose.sh up core
    echo ""
    log_success "Core stack started!"
    echo ""
    log_info "Verify with: ./kompose.sh status core"
else
    log_info "Start manually when ready: ./kompose.sh up core"
fi

echo ""
