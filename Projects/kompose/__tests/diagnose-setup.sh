#!/bin/bash

# Diagnostic script to check setup command output

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KOMPOSE_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "=========================================="
echo "Setup Command Diagnostic"
echo "=========================================="
echo ""

cd "$KOMPOSE_ROOT"

echo "1. Testing setup command without arguments..."
echo "-------------------------------------------"
set +e
output=$(bash kompose.sh setup 2>&1)
exit_code=$?
set -e

echo "Exit code: $exit_code"
echo ""
echo "Output:"
echo "-------------------------------------------"
echo "$output"
echo "-------------------------------------------"
echo ""

echo "2. Checking for expected patterns..."
echo "-------------------------------------------"

# Check each pattern individually
patterns=("local" "prod" "status" "mode" "Mode" "configuration" "Configuration")

for pattern in "${patterns[@]}"; do
    if echo "$output" | grep -q "$pattern"; then
        echo "✓ Found: $pattern"
    else
        echo "✗ Missing: $pattern"
    fi
done

echo ""
echo "3. Checking for errors..."
echo "-------------------------------------------"

if echo "$output" | grep -qi "error\|failed\|not found"; then
    echo "⚠ Errors detected in output"
    echo "$output" | grep -i "error\|failed\|not found"
else
    echo "✓ No obvious errors"
fi

echo ""
echo "4. Environment check..."
echo "-------------------------------------------"
echo "Current directory: $(pwd)"
echo ".env exists: $([ -f .env ] && echo 'Yes' || echo 'No')"
echo ".env.local exists: $([ -f .env.local ] && echo 'Yes' || echo 'No')"
echo "domain.env exists: $([ -f domain.env ] && echo 'Yes' || echo 'No')"

echo ""
echo "=========================================="
echo "Diagnostic Complete"
echo "=========================================="
