#!/bin/bash

# cleanup-secrets-warnings.sh
# Removes log_warning output from secrets.env file

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SECRETS_FILE="secrets.env"

echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║           Cleanup: Remove Warnings from secrets.env           ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if secrets.env exists
if [ ! -f "$SECRETS_FILE" ]; then
    echo -e "${YELLOW}No secrets.env file found - nothing to clean up${NC}"
    exit 0
fi

# Backup first
echo -e "${BLUE}[1/4]${NC} Creating backup..."
cp "$SECRETS_FILE" "${SECRETS_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
echo -e "${GREEN}✓${NC} Backup created"
echo ""

# Check for warning text in the file
echo -e "${BLUE}[2/4]${NC} Checking for warning messages..."
if grep -q "WARNING" "$SECRETS_FILE" || grep -q "htpasswd not found" "$SECRETS_FILE"; then
    echo -e "${YELLOW}⚠${NC} Found warning messages in secrets.env"
    
    # Show affected lines
    echo ""
    echo -e "${YELLOW}Affected secrets:${NC}"
    grep -n "WARNING\|htpasswd not found" "$SECRETS_FILE" | head -10
    echo ""
else
    echo -e "${GREEN}✓${NC} No warning messages found"
    echo ""
    echo "Your secrets.env file is clean!"
    exit 0
fi

# Ask for confirmation
echo -e "${BLUE}[3/4]${NC} This will:"
echo "  • Remove warning messages from secret values"
echo "  • Regenerate affected secrets"
echo "  • Keep the backup just in case"
echo ""
read -p "Continue? (yes/no): " confirm

if [[ "$confirm" != "yes" ]]; then
    echo -e "${YELLOW}Cleanup cancelled${NC}"
    exit 0
fi

# Clean up the file
echo ""
echo -e "${BLUE}[4/4]${NC} Cleaning up and regenerating..."

# List of secrets that might have warnings (htpasswd type)
HTPASSWD_SECRETS=(
    "PROXY_DASHBOARD_AUTH"
    "WATCH_PROMETHEUS_AUTH"
    "WATCH_LOKI_AUTH"
    "WATCH_ALERTMANAGER_AUTH"
)

# Regenerate each htpasswd secret
for secret in "${HTPASSWD_SECRETS[@]}"; do
    if grep -q "^${secret}=.*WARNING" "$SECRETS_FILE" || \
       grep -q "^${secret}=.*htpasswd not found" "$SECRETS_FILE"; then
        echo -e "  ${YELLOW}→${NC} Regenerating ${secret}..."
        ./kompose.sh secrets generate "${secret}" --force >/dev/null 2>&1
        echo -e "  ${GREEN}✓${NC} ${secret} cleaned"
    fi
done

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                      Cleanup Complete!                         ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Verify the cleanup
echo -e "${BLUE}Verification:${NC}"
if grep -q "WARNING" "$SECRETS_FILE" || grep -q "htpasswd not found" "$SECRETS_FILE"; then
    echo -e "${RED}✗${NC} Some warnings may still remain"
    echo ""
    echo "Remaining issues:"
    grep -n "WARNING\|htpasswd not found" "$SECRETS_FILE"
    echo ""
    echo "You may need to manually edit secrets.env"
else
    echo -e "${GREEN}✓${NC} All warnings removed successfully"
    echo ""
    echo "Your secrets.env is now clean!"
fi

echo ""
echo "Backup saved at: ${SECRETS_FILE}.backup.*"
echo ""
echo "Next steps:"
echo "  1. Validate: ./kompose.sh secrets validate"
echo "  2. Check: cat secrets.env | grep -E '(PROXY|WATCH).*AUTH'"
echo "  3. If all good, you can delete the backup"
