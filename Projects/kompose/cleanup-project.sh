#!/bin/bash

# ===================================================================
# Kompose Project Cleanup Script
# ===================================================================
# This script cleans up the project by:
# 1. Removing backup files (.bak, .new)
# 2. Removing duplicate docker-compose.yml files (keeping compose.yaml)
# 3. Consolidating documentation
# ===================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║           Kompose Project Cleanup Script                      ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Confirm before proceeding
echo -e "${YELLOW}This script will:${NC}"
echo "  • Remove all .bak and .new backup files"
echo "  • Remove duplicate docker-compose.yml files"
echo "  • Clean up old backup directories"
echo ""
echo -e "${YELLOW}WARNING: This action cannot be undone!${NC}"
echo ""
read -p "Do you want to continue? (yes/no): " confirm

if [[ "$confirm" != "yes" ]]; then
    echo -e "${RED}Cleanup cancelled${NC}"
    exit 0
fi

echo ""
echo -e "${GREEN}Starting cleanup...${NC}"
echo ""

# Function to log actions
log_action() {
    echo -e "${BLUE}[CLEANUP]${NC} $1"
}

# Function to count files
count_files() {
    local pattern=$1
    find . -type f -name "$pattern" ! -path "./_docs/*" ! -path "./node_modules/*" 2>/dev/null | wc -l
}

# 1. Remove .bak files
log_action "Removing .bak backup files..."
bak_count=$(count_files "*.bak")
if [ "$bak_count" -gt 0 ]; then
    find . -type f -name "*.bak" ! -path "./_docs/*" ! -path "./node_modules/*" -delete
    echo -e "  ${GREEN}✓${NC} Removed $bak_count .bak files"
else
    echo -e "  ${YELLOW}No .bak files found${NC}"
fi

# 2. Remove .new files
log_action "Removing .new temporary files..."
new_count=$(count_files "*.new")
if [ "$new_count" -gt 0 ]; then
    find . -type f -name "*.new" ! -path "./_docs/*" ! -path "./node_modules/*" -delete
    echo -e "  ${GREEN}✓${NC} Removed $new_count .new files"
else
    echo -e "  ${YELLOW}No .new files found${NC}"
fi

# 3. Remove docker-compose.yml duplicates (keep compose.yaml)
log_action "Removing duplicate docker-compose.yml files..."
duplicate_count=$(count_files "docker-compose.yml")
if [ "$duplicate_count" -gt 0 ]; then
    find . -type f -name "docker-compose.yml" ! -path "./_docs/*" ! -path "./node_modules/*" -delete
    echo -e "  ${GREEN}✓${NC} Removed $duplicate_count docker-compose.yml files"
else
    echo -e "  ${YELLOW}No docker-compose.yml files found${NC}"
fi

# 4. Clean up old backup directories
log_action "Checking for old backup directories..."
if [ -d "./backups/integration_20251012_004748" ]; then
    echo -e "  ${YELLOW}Found old integration backup directory${NC}"
    read -p "  Remove ./backups/integration_20251012_004748? (yes/no): " remove_backup
    if [[ "$remove_backup" == "yes" ]]; then
        rm -rf "./backups/integration_20251012_004748"
        echo -e "  ${GREEN}✓${NC} Removed old backup directory"
    else
        echo -e "  ${YELLOW}Skipped backup directory removal${NC}"
    fi
else
    echo -e "  ${YELLOW}No old backup directories found${NC}"
fi

# 5. Remove SQL backup files from stack directories
log_action "Checking for misplaced SQL files in stack directories..."
sql_count=$(find . -maxdepth 2 -type f -name "*.sql" ! -path "./backups/*" ! -path "./_docs/*" 2>/dev/null | wc -l)
if [ "$sql_count" -gt 0 ]; then
    echo -e "  ${YELLOW}Found $sql_count SQL files in stack directories${NC}"
    find . -maxdepth 2 -type f -name "*.sql" ! -path "./backups/*" ! -path "./_docs/*" 2>/dev/null
    read -p "  Move these to ./backups/database/? (yes/no): " move_sql
    if [[ "$move_sql" == "yes" ]]; then
        mkdir -p ./backups/database/
        find . -maxdepth 2 -type f -name "*.sql" ! -path "./backups/*" ! -path "./_docs/*" -exec mv {} ./backups/database/ \;
        echo -e "  ${GREEN}✓${NC} Moved SQL files to backups directory"
    else
        echo -e "  ${YELLOW}Skipped SQL file cleanup${NC}"
    fi
else
    echo -e "  ${YELLOW}No misplaced SQL files found${NC}"
fi

# 6. Summary
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                    Cleanup Complete                            ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Report
echo -e "${BLUE}Cleanup Summary:${NC}"
echo "  • Removed $bak_count .bak files"
echo "  • Removed $new_count .new files"
echo "  • Removed $duplicate_count docker-compose.yml duplicates"
echo ""

# Recommendations
echo -e "${YELLOW}Next Steps:${NC}"
echo "  1. Review the changes with: git status"
echo "  2. Validate all compose files: ./kompose.sh validate"
echo "  3. Test a stack: ./kompose.sh up core"
echo "  4. Commit the cleaned project: git add . && git commit -m 'Clean up project structure'"
echo ""

exit 0
