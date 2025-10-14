#!/bin/bash

# Diagnostic script to check test command setup

echo "=== Kompose Test Command Diagnostics ==="
echo ""

SCRIPT_DIR="/home/valknar/Projects/kompose"
TEST_DIR="${SCRIPT_DIR}/__tests"

# Check 1: kompose.sh exists and is executable
echo "1. Checking kompose.sh..."
if [ -f "${SCRIPT_DIR}/kompose.sh" ]; then
    echo "   ✅ kompose.sh exists"
    if [ -x "${SCRIPT_DIR}/kompose.sh" ]; then
        echo "   ✅ kompose.sh is executable"
    else
        echo "   ⚠️  kompose.sh is not executable"
        echo "      Fix: chmod +x ${SCRIPT_DIR}/kompose.sh"
    fi
else
    echo "   ❌ kompose.sh not found"
    exit 1
fi
echo ""

# Check 2: Test directory exists
echo "2. Checking test directory..."
if [ -d "$TEST_DIR" ]; then
    echo "   ✅ __tests directory exists"
else
    echo "   ❌ __tests directory not found"
    exit 1
fi
echo ""

# Check 3: run-all-tests.sh exists
echo "3. Checking test runner..."
if [ -f "${TEST_DIR}/run-all-tests.sh" ]; then
    echo "   ✅ run-all-tests.sh exists"
    if [ -x "${TEST_DIR}/run-all-tests.sh" ]; then
        echo "   ✅ run-all-tests.sh is executable"
    else
        echo "   ⚠️  run-all-tests.sh is not executable"
        echo "      Attempting to fix..."
        chmod +x "${TEST_DIR}/run-all-tests.sh"
        echo "      ✅ Fixed"
    fi
else
    echo "   ❌ run-all-tests.sh not found"
    exit 1
fi
echo ""

# Check 4: Test the command
echo "4. Testing 'kompose test --help'..."
cd "$SCRIPT_DIR"
./kompose.sh test --help 2>&1 | head -10
echo ""

# Check 5: Test runner can be run directly
echo "5. Testing run-all-tests.sh directly..."
cd "$TEST_DIR"
bash run-all-tests.sh --help 2>&1 | head -10
echo ""

echo "=== Diagnostics Complete ==="
echo ""
echo "Try running: cd ${SCRIPT_DIR} && ./kompose.sh test"
