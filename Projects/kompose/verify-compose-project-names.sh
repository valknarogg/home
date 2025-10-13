#!/bin/bash

# Verification script for COMPOSE_PROJECT_NAME variables
# This script checks that all stacks have their corresponding project name variables

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║    COMPOSE_PROJECT_NAME Variable Verification             ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Define all stacks
STACKS=(
    "core"
    "auth"
    "kmps"
    "home"
    "vpn"
    "messaging"
    "chain"
    "code"
    "proxy"
    "link"
    "track"
    "vault"
    "watch"
    "_docs"
)

# Function to get stack prefix (remove underscore and uppercase)
get_prefix() {
    local stack="$1"
    if [[ "$stack" == _* ]]; then
        stack="${stack:1}"
    fi
    echo "${stack^^}"
}

# Function to check environment file
check_env_file() {
    local file="$1"
    local file_name=$(basename "$file")
    
    echo -e "${BLUE}Checking: ${file_name}${NC}"
    
    if [ ! -f "$file" ]; then
        echo -e "  ${YELLOW}⚠ File not found${NC}"
        return 1
    fi
    
    local all_found=true
    local missing_count=0
    
    for stack in "${STACKS[@]}"; do
        local prefix=$(get_prefix "$stack")
        local var_name="${prefix}_COMPOSE_PROJECT_NAME"
        
        if grep -q "^${var_name}=" "$file"; then
            echo -e "  ${GREEN}✓${NC} ${var_name}"
        else
            echo -e "  ${RED}✗${NC} ${var_name} ${RED}(MISSING)${NC}"
            all_found=false
            ((missing_count++))
        fi
    done
    
    echo ""
    
    if [ "$all_found" = true ]; then
        echo -e "  ${GREEN}✓ All COMPOSE_PROJECT_NAME variables present${NC}"
        return 0
    else
        echo -e "  ${RED}✗ Missing ${missing_count} variable(s)${NC}"
        return 1
    fi
}

# Check all environment files
echo -e "${YELLOW}Checking environment files...${NC}"
echo ""

all_files_ok=true

for env_file in ".env" ".env.local" ".env.production"; do
    if ! check_env_file "${SCRIPT_DIR}/${env_file}"; then
        all_files_ok=false
    fi
    echo ""
done

# Check for custom stacks
if [ -d "${SCRIPT_DIR}/+custom" ]; then
    echo -e "${BLUE}Checking custom stacks...${NC}"
    echo ""
    
    for custom_stack in "${SCRIPT_DIR}/+custom"/*; do
        if [ -d "$custom_stack" ] && [ -f "${custom_stack}/compose.yaml" ]; then
            local stack_name=$(basename "$custom_stack")
            local prefix="${stack_name^^}"
            local var_name="${prefix}_COMPOSE_PROJECT_NAME"
            
            echo "  Custom Stack: ${stack_name}"
            
            if grep -q "^${var_name}=" "${SCRIPT_DIR}/.env" 2>/dev/null; then
                echo -e "    ${GREEN}✓${NC} ${var_name} found in .env"
            else
                echo -e "    ${RED}✗${NC} ${var_name} ${RED}(MISSING in .env)${NC}"
                all_files_ok=false
            fi
        fi
    done
    echo ""
fi

# Final summary
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
if [ "$all_files_ok" = true ]; then
    echo -e "${GREEN}✓ VERIFICATION PASSED${NC}"
    echo -e "  All COMPOSE_PROJECT_NAME variables are properly configured"
else
    echo -e "${RED}✗ VERIFICATION FAILED${NC}"
    echo -e "  Some COMPOSE_PROJECT_NAME variables are missing"
    echo ""
    echo -e "${YELLOW}To fix this, run:${NC}"
    echo -e "  ${BLUE}./kompose.sh init${NC}  (for full initialization)"
    echo -e "  or"
    echo -e "  ${BLUE}bash add-docs-compose-var.sh${NC}  (quick fix for DOCS stack)"
fi
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo ""
