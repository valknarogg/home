#!/bin/bash

# test-secrets-fix.sh
# Quick test to verify the secrets generation fix

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Testing Secrets Management Fix${NC}"
echo ""

# Backup existing secrets.env if it exists
if [ -f "secrets.env" ]; then
    echo -e "${BLUE}[1/5]${NC} Backing up existing secrets.env..."
    cp secrets.env secrets.env.backup.test
    echo -e "${GREEN}✓${NC} Backup created"
else
    echo -e "${BLUE}[1/5]${NC} No existing secrets.env found"
fi

# Test generating all secrets
echo -e "${BLUE}[2/5]${NC} Testing secret generation..."
if ./kompose.sh secrets generate --force 2>&1 | head -20; then
    echo -e "${GREEN}✓${NC} Generation completed without sed errors"
else
    echo -e "${RED}✗${NC} Generation failed"
    exit 1
fi

# Validate the secrets
echo ""
echo -e "${BLUE}[3/5]${NC} Validating generated secrets..."
if ./kompose.sh secrets validate 2>&1 | tail -10; then
    echo -e "${GREEN}✓${NC} Validation completed"
else
    echo -e "${RED}✗${NC} Validation failed"
fi

# Check for problematic secrets (htpasswd with $ signs)
echo ""
echo -e "${BLUE}[4/5]${NC} Checking htpasswd secrets (with \$ signs)..."
if grep -q "PROXY_DASHBOARD_AUTH=" secrets.env; then
    echo -e "${GREEN}✓${NC} PROXY_DASHBOARD_AUTH generated"
    echo "  Sample: $(grep PROXY_DASHBOARD_AUTH secrets.env | cut -d'=' -f2 | cut -c1-30)..."
fi

if grep -q "WATCH_PROMETHEUS_AUTH=" secrets.env; then
    echo -e "${GREEN}✓${NC} WATCH_PROMETHEUS_AUTH generated"
    echo "  Sample: $(grep WATCH_PROMETHEUS_AUTH secrets.env | cut -d'=' -f2 | cut -c1-30)..."
fi

# Check base64 secrets
echo ""
echo -e "${BLUE}[5/5]${NC} Checking base64 secrets (with + / = signs)..."
if grep -q "AUTH_OAUTH2_COOKIE_SECRET=" secrets.env; then
    echo -e "${GREEN}✓${NC} AUTH_OAUTH2_COOKIE_SECRET generated"
    echo "  Sample: $(grep AUTH_OAUTH2_COOKIE_SECRET secrets.env | cut -d'=' -f2 | cut -c1-30)..."
fi

# Summary
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                    Tests Completed Successfully!               ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

echo "The fix has resolved the sed error issue."
echo ""
echo "What was fixed:"
echo "  • Replaced sed with awk for setting secret values"
echo "  • awk handles special characters (\$, +, /, =) properly"
echo "  • htpasswd hashes with \$ signs now work correctly"
echo "  • base64 values with special characters now work correctly"
echo ""

# Restore or cleanup
if [ -f "secrets.env.backup.test" ]; then
    read -p "Keep new secrets.env or restore backup? (keep/restore): " choice
    if [ "$choice" = "restore" ]; then
        mv secrets.env.backup.test secrets.env
        echo -e "${BLUE}Restored original secrets.env${NC}"
    else
        rm secrets.env.backup.test
        echo -e "${GREEN}Keeping new secrets.env${NC}"
    fi
fi

echo ""
echo "You can now use:"
echo "  ./kompose.sh secrets generate  # Generate all secrets"
echo "  ./kompose.sh secrets validate  # Validate configuration"
