#!/bin/bash

# =================================================================
# Migrate Semaphore from auto stack to chain stack
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

BACKUP_DIR="./backups/migration"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     Migrate Semaphore: auto stack → chain stack               ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if auto stack is running
if ! docker ps | grep -q "auto_app"; then
    log_warning "Auto stack is not running"
    read -p "Continue anyway? (yes/no): " continue
    if [[ "$continue" != "yes" ]]; then
        log_info "Migration cancelled"
        exit 0
    fi
fi

# Step 1: Create backup directory
log_info "Step 1: Creating backup directory"
mkdir -p "$BACKUP_DIR"
log_success "Backup directory created: $BACKUP_DIR"

# Step 2: Backup Semaphore database
log_info "Step 2: Backing up Semaphore database"
if docker ps | grep -q "core-postgres"; then
    BACKUP_FILE="${BACKUP_DIR}/semaphore_${TIMESTAMP}.sql.gz"
    docker exec core-postgres pg_dump -U kompose semaphore | gzip > "$BACKUP_FILE"
    
    if [[ -f "$BACKUP_FILE" ]]; then
        BACKUP_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
        log_success "Database backed up: $BACKUP_FILE ($BACKUP_SIZE)"
    else
        log_error "Backup failed"
        exit 1
    fi
else
    log_error "PostgreSQL container not running. Start with: ./kompose.sh up core"
    exit 1
fi

# Step 3: Export Semaphore configuration files
log_info "Step 3: Backing up configuration files"
if [[ -d "./auto" ]]; then
    tar czf "${BACKUP_DIR}/auto_config_${TIMESTAMP}.tar.gz" ./auto/.env ./auto/kompose.yml 2>/dev/null || true
    log_success "Configuration files backed up"
else
    log_warning "Auto directory not found, skipping config backup"
fi

# Step 4: Stop auto stack
log_warning "Step 4: Stopping auto stack"
read -p "Stop the auto stack now? (yes/no): " stop
if [[ "$stop" == "yes" ]]; then
    if docker ps | grep -q "auto_app"; then
        ./kompose.sh down auto
        log_success "Auto stack stopped"
    else
        log_info "Auto stack already stopped"
    fi
else
    log_warning "Skipping auto stack shutdown"
fi

# Step 5: Prepare chain stack environment
log_info "Step 5: Updating chain stack configuration"

# Check if chain/.env exists
if [[ ! -f "./chain/.env" ]]; then
    log_error "Chain .env file not found. Please ensure chain stack is properly configured."
    exit 1
fi

# Merge auto secrets into secrets.env if needed
if [[ -f "./auto/.env" ]]; then
    log_info "Extracting Semaphore configuration from auto stack..."
    
    # Read values from auto/.env
    AUTO_ADMIN=$(grep "^SEMAPHORE_ADMIN=" ./auto/.env | cut -d'=' -f2)
    AUTO_ADMIN_NAME=$(grep "^SEMAPHORE_ADMIN_NAME=" ./auto/.env | cut -d'=' -f2)
    
    log_info "Found: SEMAPHORE_ADMIN=${AUTO_ADMIN}"
    log_info "Found: SEMAPHORE_ADMIN_NAME=${AUTO_ADMIN_NAME}"
    
    # Check secrets.env for required values
    if [[ ! -f "./secrets.env" ]]; then
        log_warning "secrets.env not found"
        log_info "Please ensure the following are set:"
        echo "  - SEMAPHORE_ADMIN_PASSWORD"
        echo "  - SEMAPHORE_RUNNER_TOKEN"
        echo "  - TRAEFIK_HOST_AUTO"
    else
        log_success "secrets.env found"
        
        # Verify required secrets exist
        MISSING_SECRETS=()
        
        if ! grep -q "^SEMAPHORE_ADMIN_PASSWORD=" ./secrets.env; then
            MISSING_SECRETS+=("SEMAPHORE_ADMIN_PASSWORD")
        fi
        
        if ! grep -q "^SEMAPHORE_RUNNER_TOKEN=" ./secrets.env; then
            MISSING_SECRETS+=("SEMAPHORE_RUNNER_TOKEN")
        fi
        
        if ! grep -q "^TRAEFIK_HOST_AUTO=" ./secrets.env; then
            MISSING_SECRETS+=("TRAEFIK_HOST_AUTO")
        fi
        
        if [[ ${#MISSING_SECRETS[@]} -gt 0 ]]; then
            log_warning "Missing secrets in secrets.env:"
            for secret in "${MISSING_SECRETS[@]}"; do
                echo "  - $secret"
            done
            log_info "Add these to secrets.env before starting chain stack"
        else
            log_success "All required secrets found"
        fi
    fi
fi

# Step 6: Create databases in chain context
log_info "Step 6: Ensuring databases exist"

# Check if databases already exist
N8N_EXISTS=$(docker exec core-postgres psql -U kompose -lqt 2>/dev/null | cut -d \| -f 1 | grep -w n8n | wc -l)
SEMAPHORE_EXISTS=$(docker exec core-postgres psql -U kompose -lqt 2>/dev/null | cut -d \| -f 1 | grep -w semaphore | wc -l)

if [[ $N8N_EXISTS -eq 0 ]]; then
    log_info "Creating n8n database..."
    docker exec core-postgres psql -U kompose -c "CREATE DATABASE n8n;"
    log_success "n8n database created"
else
    log_info "n8n database already exists"
fi

if [[ $SEMAPHORE_EXISTS -eq 0 ]]; then
    log_info "Creating semaphore database..."
    docker exec core-postgres psql -U kompose -c "CREATE DATABASE semaphore;"
    log_success "Semaphore database created"
else
    log_info "Semaphore database already exists (migration may have preserved data)"
fi

# Step 7: Start chain stack
log_warning "Step 7: Start chain stack"
echo ""
log_info "Migration preparation complete!"
echo ""
log_info "Next steps:"
echo "  1. Review the backup: $BACKUP_FILE"
echo "  2. Verify secrets.env has all required values"
echo "  3. Start the chain stack: ./kompose.sh up chain"
echo "  4. Verify services: ./kompose.sh status chain"
echo "  5. Check logs: ./kompose.sh logs chain"
echo ""

read -p "Start chain stack now? (yes/no): " start
if [[ "$start" == "yes" ]]; then
    log_info "Starting chain stack..."
    ./kompose.sh up chain
    
    echo ""
    log_success "Migration complete!"
    echo ""
    log_info "Access your services:"
    echo "  - n8n: Check chain/.env for N8N_TRAEFIK_HOST"
    echo "  - Semaphore: Check chain/.env for SEMAPHORE_TRAEFIK_HOST"
    echo ""
    log_info "Verify everything is working:"
    echo "  ./kompose.sh status chain"
    echo "  ./kompose.sh logs chain -f"
    echo ""
else
    log_info "Chain stack not started"
    log_info "Start manually when ready: ./kompose.sh up chain"
fi

# Step 8: Summary
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                    Migration Summary                           ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "Backup Location: $BACKUP_DIR"
echo "Database Backup: $BACKUP_FILE"
echo ""
echo "The auto stack directory can be kept for reference or removed."
echo "To remove: rm -rf ./auto"
echo ""
log_info "If you encounter issues, restore from backup:"
echo "  ./kompose.sh db restore -f $BACKUP_FILE -d semaphore"
echo ""
