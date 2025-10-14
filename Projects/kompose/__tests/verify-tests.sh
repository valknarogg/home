#!/bin/bash

# Quick verification script to check all test files

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║         Kompose Test Suite - Verification Script              ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Check all test files exist
echo "Checking test files..."
test_files=(
    "test-basic-commands.sh"
    "test-stack-commands.sh"
    "test-database-commands.sh"
    "test-tag-commands.sh"
    "test-api-commands.sh"
    "test-secrets-commands.sh"
    "test-profile-commands.sh"
    "test-env-commands.sh"
    "test-setup-commands.sh"
    "test-utils-commands.sh"
    "test-generate-commands.sh"
)

missing_files=()
existing_files=()

for file in "${test_files[@]}"; do
    if [ -f "${SCRIPT_DIR}/${file}" ]; then
        existing_files+=("$file")
        echo "  ✓ $file"
    else
        missing_files+=("$file")
        echo "  ✗ $file (MISSING)"
    fi
done

echo ""
echo "Summary:"
echo "  Total test files: ${#test_files[@]}"
echo "  Existing: ${#existing_files[@]}"
echo "  Missing: ${#missing_files[@]}"
echo ""

# Check helper files
echo "Checking helper files..."
helpers=(
    "test-helpers.sh"
    "run-all-tests.sh"
    "make-executable.sh"
)

for file in "${helpers[@]}"; do
    if [ -f "${SCRIPT_DIR}/${file}" ]; then
        echo "  ✓ $file"
    else
        echo "  ✗ $file (MISSING)"
    fi
done

echo ""

# Check directories
echo "Checking directories..."
dirs=(
    "snapshots"
    "temp"
    "generated"
)

for dir in "${dirs[@]}"; do
    if [ -d "${SCRIPT_DIR}/${dir}" ]; then
        echo "  ✓ $dir/"
    else
        echo "  ⚠ $dir/ (will be created on first run)"
    fi
done

echo ""

# Make files executable
echo "Making test files executable..."
bash "${SCRIPT_DIR}/make-executable.sh"

echo ""

# Check syntax of test files
echo "Checking bash syntax..."
syntax_errors=0

for file in "${existing_files[@]}"; do
    if bash -n "${SCRIPT_DIR}/${file}" 2>/dev/null; then
        echo "  ✓ $file - syntax OK"
    else
        echo "  ✗ $file - SYNTAX ERROR"
        syntax_errors=$((syntax_errors + 1))
    fi
done

echo ""

if [ $syntax_errors -eq 0 ]; then
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║                   ✅ ALL CHECKS PASSED                         ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo ""
    echo "You can now run the test suite:"
    echo "  bash run-all-tests.sh"
    echo ""
    echo "Or run a specific test:"
    echo "  bash run-all-tests.sh -t basic-commands"
    echo ""
    exit 0
else
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║                 ⚠️  SYNTAX ERRORS FOUND                        ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo ""
    echo "Please fix syntax errors before running tests."
    exit 1
fi
