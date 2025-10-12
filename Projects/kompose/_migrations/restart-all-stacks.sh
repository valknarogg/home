#!/bin/bash

# Script to restart all stacks after timezone configuration changes
# This applies the new timezone settings to all running containers

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Restarting Stacks with New Timezone${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Get the root directory
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Find all directories with compose.yaml files
STACK_DIRS=()
for dir in "$ROOT_DIR"/*/; do
    if [ -f "$dir/compose.yaml" ]; then
        STACK_DIRS+=("$dir")
    fi
done

if [ ${#STACK_DIRS[@]} -eq 0 ]; then
    echo -e "${RED}No stacks found!${NC}"
    exit 1
fi

echo -e "Found ${GREEN}${#STACK_DIRS[@]}${NC} stacks"
echo ""

# Ask for confirmation
echo -e "${YELLOW}This will restart all stacks to apply timezone changes.${NC}"
echo -e "${YELLOW}Make sure you have run add-timezone.py first!${NC}"
echo ""
read -p "Continue? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi

echo ""

SUCCESS=0
FAILED=0
SKIPPED=0

for stack_dir in "${STACK_DIRS[@]}"; do
    stack_name=$(basename "$stack_dir")
    
    echo -e "Processing: ${YELLOW}$stack_name${NC}"
    
    cd "$stack_dir"
    
    # Check if containers are running
    if ! docker compose ps --quiet | grep -q .; then
        echo -e "  ${YELLOW}⏭  No running containers, skipping${NC}"
        ((SKIPPED++))
        echo ""
        continue
    fi
    
    # Restart the stack
    if docker compose up -d --quiet-pull 2>&1; then
        echo -e "  ${GREEN}✓ Restarted successfully${NC}"
        ((SUCCESS++))
    else
        echo -e "  ${RED}✗ Failed to restart${NC}"
        ((FAILED++))
    fi
    
    cd "$ROOT_DIR"
    echo ""
done

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Summary${NC}"
echo -e "${BLUE}========================================${NC}"
echo -e "Success:  ${GREEN}$SUCCESS${NC} stacks"
echo -e "Failed:   ${RED}$FAILED${NC} stacks"
echo -e "Skipped:  ${YELLOW}$SKIPPED${NC} stacks"
echo ""

if [ $SUCCESS -gt 0 ]; then
    echo -e "${GREEN}Timezone changes have been applied!${NC}"
    echo ""
    echo "Verify with: docker exec <container_name> date"
fi

if [ $FAILED -gt 0 ]; then
    echo -e "${RED}Some stacks failed to restart. Check the logs above.${NC}"
fi
