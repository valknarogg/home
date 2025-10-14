#!/bin/bash

# Quick verification script for test fixes
# Tests the three main problem areas

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KOMPOSE_ROOT="${SCRIPT_DIR}/.."

echo "════════════════════════════════════════════════════════════"
echo "  Verifying Test Fixes"
echo "════════════════════════════════════════════════════════════"
echo ""

# Test 1: Setup command shows available subcommands
echo "Test 1: Setup command without arguments..."
cd "$KOMPOSE_ROOT"
output=$(bash kompose.sh setup 2>&1)
if echo "$output" | grep -q "Available setup commands"; then
    echo "✅ PASS: Setup shows available commands"
else
    echo "❌ FAIL: Setup doesn't show available commands"
    echo "Output: $output"
    exit 1
fi
echo ""

# Test 2: List command works (even without full env)
echo "Test 2: List command..."
output=$(bash kompose.sh list 2>&1)
if echo "$output" | grep -q "Available stacks"; then
    echo "✅ PASS: List command works"
    if echo "$output" | grep -q "core"; then
        echo "✅ PASS: List shows core stack"
    else
        echo "⚠️  WARNING: Core stack not found (might not exist in this environment)"
    fi
else
    echo "❌ FAIL: List command doesn't work"
    echo "Output: $output"
    exit 1
fi
echo ""

# Test 3: Generate command requires subcommand
echo "Test 3: Generate command validation..."
output=$(bash kompose.sh generate 2>&1 || true)
if echo "$output" | grep -q "Generate subcommand required"; then
    echo "✅ PASS: Generate command requires subcommand"
else
    echo "❌ FAIL: Generate doesn't validate properly"
    echo "Output: $output"
    exit 1
fi
echo ""

echo "════════════════════════════════════════════════════════════"
echo "  ✅ All quick verification tests passed!"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "Next steps:"
echo "  1. Run full test suite: ./kompose.sh test"
echo "  2. Run specific tests:"
echo "     ./kompose.sh test -t setup-commands"
echo "     ./kompose.sh test -t utils-commands"
echo "     ./kompose.sh test -t generate-commands"
echo ""
