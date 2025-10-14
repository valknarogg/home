#!/bin/bash

# Quick Fix - Apply all test fixes and run tests
# Usage: ./quick-fix-and-test.sh

set -e

cd "$(dirname "$0")"

echo "╔════════════════════════════════════════╗"
echo "║   Kompose Test Suite Quick Fix        ║"
echo "╚════════════════════════════════════════╝"
echo ""

# Make scripts executable
chmod +x apply-all-fixes.sh
chmod +x run-all-tests.sh

# Apply fixes
echo "Applying fixes..."
./apply-all-fixes.sh

echo ""
echo "Fixes applied! Now running tests..."
echo ""
sleep 2

# Run tests
./run-all-tests.sh

echo ""
echo "═══════════════════════════════════════════"
echo "  Test run complete!"
echo "═══════════════════════════════════════════"
echo ""
echo "For more details, see:"
echo "  • FINAL_FIX_SUMMARY.md - Complete fix documentation"
echo "  • FIXES_COMPLETE.md - Test suite guide"
echo ""
