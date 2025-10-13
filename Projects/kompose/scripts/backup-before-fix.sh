#!/bin/bash
# =================================================================
# Backup Script - Save current configuration before fixes
# =================================================================

set -e

# Create backup directory with timestamp
BACKUP_DIR="backups/env-fix-$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "Creating backup in: $BACKUP_DIR"

# Backup all compose.yaml files
echo "Backing up compose.yaml files..."
find . -name "compose.yaml" -not -path "./backups/*" -not -path "./scripts/*" | while read -r file; do
    target="$BACKUP_DIR/$file"
    mkdir -p "$(dirname "$target")"
    cp "$file" "$target"
done

# Backup environment files
echo "Backing up environment files..."
[ -f .env ] && cp .env "$BACKUP_DIR/.env.backup"
[ -f .env.local ] && cp .env.local "$BACKUP_DIR/.env.local.backup"
[ -f .env.production ] && cp .env.production "$BACKUP_DIR/.env.production.backup"
[ -f domain.env ] && cp domain.env "$BACKUP_DIR/domain.env.backup"
[ -f domain.env.local ] && cp domain.env.local "$BACKUP_DIR/domain.env.local.backup"
[ -f domain.env.production ] && cp domain.env.production "$BACKUP_DIR/domain.env.production.backup"
[ -f secrets.env ] && cp secrets.env "$BACKUP_DIR/secrets.env.backup"

# Create backup manifest
cat > "$BACKUP_DIR/BACKUP_MANIFEST.txt" << EOF
Kompose Configuration Backup
Created: $(date)
Purpose: Pre-environment variable fix backup

Files backed up:
- All compose.yaml files from subdirectories
- .env, .env.local, .env.production
- domain.env, domain.env.local, domain.env.production
- secrets.env

To restore:
1. Stop all running containers
2. Copy files from this backup directory back to project root
3. Restart containers

EOF

echo "✓ Backup completed successfully: $BACKUP_DIR"
echo "✓ Backup manifest created: $BACKUP_DIR/BACKUP_MANIFEST.txt"
