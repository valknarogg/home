#!/bin/bash

# ===================================================================
# Kompose Domain Configuration Migration Script
# ===================================================================
# This script migrates from hardcoded domain configuration to the
# new centralized domain.env system
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
echo -e "${CYAN}║       Kompose Domain Configuration Migration                   ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if we're in the kompose directory
if [ ! -f "kompose.sh" ]; then
    echo -e "${RED}Error: This script must be run from the kompose root directory${NC}"
    exit 1
fi

# Step 1: Detect current domain
echo -e "${BLUE}Step 1: Detecting current domain configuration...${NC}"
echo ""

# Try to extract domain from current .env file
if [ -f ".env" ]; then
    current_domain=$(grep "^TRAEFIK_HOST_PROXY=" .env | head -1 | sed 's/TRAEFIK_HOST_PROXY=proxy\.//' || echo "")
    
    if [ -z "$current_domain" ]; then
        # Try another pattern
        current_domain=$(grep "pivoine.art" .env | head -1 | sed 's/.*@//' | sed 's/.*=//' || echo "pivoine.art")
    fi
else
    current_domain="pivoine.art"
fi

echo -e "  Detected domain: ${GREEN}$current_domain${NC}"
echo ""

# Step 2: Confirm or customize
echo -e "${BLUE}Step 2: Configure your domain${NC}"
echo ""
echo "Current detected domain: $current_domain"
read -p "Is this correct? (yes/no/custom): " domain_choice

case $domain_choice in
    yes)
        new_domain=$current_domain
        ;;
    custom)
        read -p "Enter your domain (e.g., example.com): " new_domain
        if [ -z "$new_domain" ]; then
            echo -e "${RED}Error: Domain cannot be empty${NC}"
            exit 1
        fi
        ;;
    *)
        echo -e "${RED}Migration cancelled${NC}"
        exit 0
        ;;
esac

echo ""
echo -e "  Using domain: ${GREEN}$new_domain${NC}"
echo ""

# Step 3: Backup current configuration
echo -e "${BLUE}Step 3: Creating backup...${NC}"
backup_dir="./backups/migration_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$backup_dir"

# Backup .env and secrets.env if they exist
[ -f ".env" ] && cp .env "$backup_dir/.env.bak"
[ -f "secrets.env" ] && cp secrets.env "$backup_dir/secrets.env.bak"

echo -e "  ${GREEN}✓${NC} Backup created at: $backup_dir"
echo ""

# Step 4: Create domain.env if it doesn't exist
echo -e "${BLUE}Step 4: Creating domain.env...${NC}"

if [ -f "domain.env" ]; then
    echo -e "  ${YELLOW}domain.env already exists${NC}"
    read -p "  Overwrite? (yes/no): " overwrite
    if [[ "$overwrite" != "yes" ]]; then
        echo -e "  ${YELLOW}Skipping domain.env creation${NC}"
    else
        sed "s/ROOT_DOMAIN=.*/ROOT_DOMAIN=$new_domain/" domain.env > domain.env.tmp
        mv domain.env.tmp domain.env
        echo -e "  ${GREEN}✓${NC} Updated domain.env with ROOT_DOMAIN=$new_domain"
    fi
else
    # domain.env doesn't exist, check if there's a template
    if [ -f "domain.env.template" ]; then
        cp domain.env.template domain.env
        sed -i "s/ROOT_DOMAIN=.*/ROOT_DOMAIN=$new_domain/" domain.env
        echo -e "  ${GREEN}✓${NC} Created domain.env from template"
    else
        echo -e "  ${YELLOW}Warning: domain.env template not found${NC}"
        echo -e "  Please create domain.env manually or ensure it exists"
    fi
fi

# Step 5: Update root .env file
echo ""
echo -e "${BLUE}Step 5: Updating root .env file...${NC}"

if [ -f ".env.new" ]; then
    # Replace old .env with new one
    read -p "  Replace .env with new domain-based configuration? (yes/no): " replace_env
    if [[ "$replace_env" == "yes" ]]; then
        mv .env "$backup_dir/.env.old"
        mv .env.new .env
        echo -e "  ${GREEN}✓${NC} Replaced .env with new configuration"
        echo -e "  ${YELLOW}!${NC} Old .env backed up to: $backup_dir/.env.old"
    else
        echo -e "  ${YELLOW}Skipped .env replacement${NC}"
        echo -e "  ${YELLOW}!${NC} You can manually compare .env and .env.new"
    fi
else
    echo -e "  ${YELLOW}Warning: .env.new not found${NC}"
    echo -e "  Please ensure you have the new .env file"
fi

# Step 6: Update secrets.env.template
echo ""
echo -e "${BLUE}Step 6: Updating secrets.env.template...${NC}"

if [ -f "secrets.env.template.new" ]; then
    read -p "  Replace secrets.env.template? (yes/no): " replace_secrets_template
    if [[ "$replace_secrets_template" == "yes" ]]; then
        mv secrets.env.template "$backup_dir/secrets.env.template.old"
        mv secrets.env.template.new secrets.env.template
        echo -e "  ${GREEN}✓${NC} Replaced secrets.env.template"
    else
        echo -e "  ${YELLOW}Skipped secrets.env.template replacement${NC}"
    fi
else
    echo -e "  ${YELLOW}Warning: secrets.env.template.new not found${NC}"
fi

# Step 7: Update stack .env files
echo ""
echo -e "${BLUE}Step 7: Scanning stack .env files...${NC}"
echo ""

# Find all stack .env files
stack_env_files=$(find . -maxdepth 2 -name ".env" -not -path "./backups/*" -not -path "./_docs/*" | grep -v "^\./.env$")

if [ -z "$stack_env_files" ]; then
    echo -e "  ${YELLOW}No stack .env files found${NC}"
else
    echo "Stack .env files found:"
    echo "$stack_env_files" | while read -r env_file; do
        echo -e "  • ${CYAN}$env_file${NC}"
    done
    echo ""
    echo -e "${YELLOW}Note:${NC} Stack .env files will now inherit from root .env and domain.env"
    echo -e "Most stack-specific domain configuration should be removed."
    echo ""
fi

# Step 8: Validation
echo ""
echo -e "${BLUE}Step 8: Validating configuration...${NC}"
echo ""

# Check if domain.env exists and is readable
if [ -f "domain.env" ] && [ -r "domain.env" ]; then
    # Source it to verify syntax
    if source domain.env 2>/dev/null; then
        echo -e "  ${GREEN}✓${NC} domain.env is valid"
        echo -e "  ROOT_DOMAIN=${ROOT_DOMAIN}"
    else
        echo -e "  ${RED}✗${NC} domain.env has syntax errors"
    fi
else
    echo -e "  ${RED}✗${NC} domain.env not found or not readable"
fi

# Check if .env exists
if [ -f ".env" ]; then
    echo -e "  ${GREEN}✓${NC} .env exists"
else
    echo -e "  ${RED}✗${NC} .env not found"
fi

# Summary
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                Migration Complete                              ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${BLUE}Migration Summary:${NC}"
echo "  • Domain: $new_domain"
echo "  • Backup location: $backup_dir"
echo "  • Configuration files updated"
echo ""

echo -e "${YELLOW}Next Steps:${NC}"
echo "  1. Review domain.env and adjust subdomain names if needed"
echo "  2. Update your secrets.env file if it exists"
echo "  3. Review and update stack .env files as needed"
echo "  4. Update DNS records for: *.$new_domain"
echo "  5. Validate compose files: ./kompose.sh validate"
echo "  6. Test with: ./kompose.sh up proxy"
echo "  7. Check SSL certificate generation"
echo ""

echo -e "${CYAN}Important:${NC}"
echo "  • All services will be at: <subdomain>.$new_domain"
echo "  • Ensure DNS A records or wildcard DNS is configured"
echo "  • SSL certificates will be automatically issued by Let's Encrypt"
echo ""

exit 0
