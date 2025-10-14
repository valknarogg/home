#!/bin/bash

# Complete verification script for ALL fixes

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KOMPOSE_ROOT="${SCRIPT_DIR}/.."

echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║        Kompose Test Fixes - Complete Verification         ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

total_checks=0
passed_checks=0
failed_checks=0

check_fix() {
    local name="$1"
    local file="$2"
    local pattern="$3"
    local description="$4"
    
    total_checks=$((total_checks+1))
    echo -n "Checking: $name... "
    
    if grep -q "$pattern" "$file" 2>/dev/null; then
        echo -e "${GREEN}✅ PASS${NC}"
        passed_checks=$((passed_checks+1))
        return 0
    else
        echo -e "${RED}❌ FAIL${NC}"
        echo -e "  ${YELLOW}$description${NC}"
        failed_checks=$((failed_checks+1))
        return 1
    fi
}

echo "Verifying all 5 fixes..."
echo ""

# Fix 1: Setup command shows available commands
check_fix \
    "Fix #1: Setup Command" \
    "${KOMPOSE_ROOT}/kompose-setup.sh" \
    "Available setup commands" \
    "Setup command should show available commands when called without args"

# Fix 2: List command checks for .env
check_fix \
    "Fix #2: List Command" \
    "${KOMPOSE_ROOT}/kompose-stack.sh" \
    "environment not configured" \
    "List command should check for .env before operations"

# Fix 3: Generate tests use run_kompose
check_fix \
    "Fix #3: Generate Tests" \
    "${SCRIPT_DIR}/test-generate-commands.sh" \
    "run_kompose generate" \
    "Generate tests should use run_kompose helper"

# Fix 4: Test helpers create correct .env
check_fix \
    "Fix #4: Test Environment" \
    "${SCRIPT_DIR}/test-helpers.sh" \
    'cat > "${KOMPOSE_ROOT}/.env"' \
    "Test helpers should create .env not .env.test"

# Fix 5: Test command exits properly
check_fix \
    "Fix #5: Test Command Exit" \
    "${KOMPOSE_ROOT}/kompose.sh" \
    'exit \$?' \
    "Test command should exit with proper exit code"

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "  Results"
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "Total checks: $total_checks"
echo -e "${GREEN}Passed: $passed_checks${NC}"
echo -e "${RED}Failed: $failed_checks${NC}"
echo ""

if [ $failed_checks -eq 0 ]; then
    echo -e "${GREEN}✅ All fixes are in place!${NC}"
    echo ""
    echo "You can now run tests:"
    echo ""
    echo "  ${BLUE}# Run diagnostic${NC}"
    echo "  cd ${SCRIPT_DIR}"
    echo "  chmod +x diagnose-test-command.sh"
    echo "  ./diagnose-test-command.sh"
    echo ""
    echo "  ${BLUE}# Run all tests${NC}"
    echo "  cd ${KOMPOSE_ROOT}"
    echo "  ./kompose.sh test"
    echo ""
    echo "  ${BLUE}# Run specific test suite${NC}"
    echo "  ./kompose.sh test -t setup-commands"
    echo "  ./kompose.sh test -t utils-commands"
    echo "  ./kompose.sh test -t generate-commands"
    echo ""
    exit 0
else
    echo -e "${RED}❌ Some fixes are missing!${NC}"
    echo ""
    echo "Please review the documentation:"
    echo "  • Complete fixes: __tests/FIXES_APPLIED_COMPLETE.md"
    echo "  • Test command fix: __tests/TEST_COMMAND_FIX.md"
    echo ""
    exit 1
fi
