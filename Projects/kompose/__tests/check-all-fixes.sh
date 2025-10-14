#!/bin/bash
# Pre-flight check - Verifies all test fixes are in place

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KOMPOSE_ROOT="${SCRIPT_DIR}/.."

echo "════════════════════════════════════════"
echo "  Test Fixes Pre-Flight Check"
echo "════════════════════════════════════════"
echo ""

passed=0
failed=0

# Check 1: Setup command
echo "1. Setup command fix..."
if grep -q "Available setup commands" "${KOMPOSE_ROOT}/kompose-setup.sh"; then
    echo -e "${GREEN}✅ PASS${NC}"
    passed=$((passed+1))
else
    echo -e "${RED}❌ FAIL${NC}"
    failed=$((failed+1))
fi

# Check 2: List command
echo "2. List command fix..."
if grep -q "environment not configured" "${KOMPOSE_ROOT}/kompose-stack.sh"; then
    echo -e "${GREEN}✅ PASS${NC}"
    passed=$((passed+1))
else
    echo -e "${RED}❌ FAIL${NC}"
    failed=$((failed+1))
fi

# Check 3: Generate tests
echo "3. Generate tests fix..."
if grep -q "run_kompose generate" "${SCRIPT_DIR}/test-generate-commands.sh"; then
    echo -e "${GREEN}✅ PASS${NC}"
    passed=$((passed+1))
else
    echo -e "${RED}❌ FAIL${NC}"
    failed=$((failed+1))
fi

# Check 4: Test environment (CRITICAL)
echo "4. Test environment fix (CRITICAL)..."
if grep -q 'cat > "${KOMPOSE_ROOT}/.env"' "${SCRIPT_DIR}/test-helpers.sh"; then
    echo -e "${GREEN}✅ PASS${NC}"
    passed=$((passed+1))
else
    echo -e "${RED}❌ FAIL${NC}"
    failed=$((failed+1))
fi

echo ""
echo "════════════════════════════════════════"
if [ $failed -eq 0 ]; then
    echo -e "${GREEN}✅ All fixes verified!${NC}"
    echo "Run: ./kompose.sh test"
    exit 0
else
    echo -e "${RED}❌ $failed fix(es) missing${NC}"
    echo "See: __tests/FIXES_APPLIED_COMPLETE.md"
    exit 1
fi
