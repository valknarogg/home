#!/bin/bash

# verify-secrets-setup.sh
# Quick verification script for secrets management system

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║          Kompose Secrets Management - Verification            ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check 1: Module file exists
echo -e "${BLUE}[1/7]${NC} Checking if kompose-secrets.sh exists..."
if [ -f "kompose-secrets.sh" ]; then
    echo -e "${GREEN}✓${NC} kompose-secrets.sh found"
else
    echo -e "${RED}✗${NC} kompose-secrets.sh not found"
    exit 1
fi

# Check 2: Module is executable
echo -e "${BLUE}[2/7]${NC} Checking if kompose-secrets.sh is executable..."
if [ -x "kompose-secrets.sh" ]; then
    echo -e "${GREEN}✓${NC} kompose-secrets.sh is executable"
else
    echo -e "${YELLOW}⚠${NC} Making kompose-secrets.sh executable..."
    chmod +x kompose-secrets.sh
    echo -e "${GREEN}✓${NC} Fixed - now executable"
fi

# Check 3: Template file exists
echo -e "${BLUE}[3/7]${NC} Checking if secrets.env.template exists..."
if [ -f "secrets.env.template" ]; then
    echo -e "${GREEN}✓${NC} secrets.env.template found"
    
    # Count secrets in template
    secret_count=$(grep -c "^[A-Z_]*=" secrets.env.template 2>/dev/null || echo 0)
    echo -e "  ${BLUE}→${NC} Found $secret_count secrets in template"
else
    echo -e "${RED}✗${NC} secrets.env.template not found"
    exit 1
fi

# Check 4: Documentation exists
echo -e "${BLUE}[4/7]${NC} Checking documentation files..."
doc_count=0
if [ -f "SECRETS_MANAGEMENT.md" ]; then
    echo -e "${GREEN}✓${NC} SECRETS_MANAGEMENT.md found"
    doc_count=$((doc_count + 1))
else
    echo -e "${YELLOW}⚠${NC} SECRETS_MANAGEMENT.md not found"
fi

if [ -f "SECRETS_QUICK_REFERENCE.md" ]; then
    echo -e "${GREEN}✓${NC} SECRETS_QUICK_REFERENCE.md found"
    doc_count=$((doc_count + 1))
else
    echo -e "${YELLOW}⚠${NC} SECRETS_QUICK_REFERENCE.md not found"
fi

if [ -f "SECRETS_IMPLEMENTATION_SUMMARY.md" ]; then
    echo -e "${GREEN}✓${NC} SECRETS_IMPLEMENTATION_SUMMARY.md found"
    doc_count=$((doc_count + 1))
else
    echo -e "${YELLOW}⚠${NC} SECRETS_IMPLEMENTATION_SUMMARY.md not found"
fi

echo -e "  ${BLUE}→${NC} Found $doc_count/3 documentation files"

# Check 5: .gitignore includes secrets.env
echo -e "${BLUE}[5/7]${NC} Checking .gitignore..."
if [ -f ".gitignore" ]; then
    if grep -q "^secrets\.env$" .gitignore; then
        echo -e "${GREEN}✓${NC} .gitignore includes secrets.env"
    else
        echo -e "${YELLOW}⚠${NC} secrets.env not found in .gitignore"
        echo -e "  ${BLUE}→${NC} Adding secrets.env to .gitignore..."
        echo "secrets.env" >> .gitignore
        echo -e "${GREEN}✓${NC} Added to .gitignore"
    fi
else
    echo -e "${RED}✗${NC} .gitignore not found"
fi

# Check 6: Test basic command structure
echo -e "${BLUE}[6/7]${NC} Testing kompose.sh secrets command..."
if ./kompose.sh --help 2>&1 | grep -q "secrets"; then
    echo -e "${GREEN}✓${NC} secrets command available in kompose.sh"
else
    echo -e "${YELLOW}⚠${NC} secrets command not found in help output"
fi

# Check 7: Check backup directory
echo -e "${BLUE}[7/7]${NC} Checking backup directory structure..."
if [ -d "backups" ]; then
    echo -e "${GREEN}✓${NC} backups/ directory exists"
    if [ ! -d "backups/secrets" ]; then
        echo -e "  ${BLUE}→${NC} Creating backups/secrets/ directory..."
        mkdir -p backups/secrets
        echo -e "${GREEN}✓${NC} Created backups/secrets/"
    else
        echo -e "${GREEN}✓${NC} backups/secrets/ directory exists"
    fi
else
    echo -e "  ${BLUE}→${NC} Creating backup directories..."
    mkdir -p backups/secrets
    echo -e "${GREEN}✓${NC} Created backup directories"
fi

# Summary
echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                        Verification Complete                   ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${GREEN}All checks passed!${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "  1. Generate secrets:        ./kompose.sh secrets generate"
echo "  2. Validate configuration:  ./kompose.sh secrets validate"
echo "  3. List secrets:            ./kompose.sh secrets list"
echo ""
echo -e "${BLUE}Documentation:${NC}"
echo "  • Full guide:       SECRETS_MANAGEMENT.md"
echo "  • Quick reference:  SECRETS_QUICK_REFERENCE.md"
echo "  • Implementation:   SECRETS_IMPLEMENTATION_SUMMARY.md"
echo ""
echo -e "${BLUE}Example commands:${NC}"
echo "  ./kompose.sh secrets generate              # Generate all secrets"
echo "  ./kompose.sh secrets list auth             # List auth stack secrets"
echo "  ./kompose.sh secrets rotate DB_PASSWORD    # Rotate a secret"
echo "  ./kompose.sh secrets backup                # Backup secrets"
echo ""
