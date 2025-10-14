#!/bin/bash

# Verification script for artifact location changes
# This script tests that artifacts are created in __tests/temp

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/test-helpers.sh"

log_section "VERIFICATION: Test Artifact Locations"

# Setup test environment
setup_test_env

log_info "TEST_ARTIFACT_DIR is set to: ${TEST_ARTIFACT_DIR}"
log_info "ENV_VARS_JSON_OUTPUT is set to: ${ENV_VARS_JSON_OUTPUT}"
log_info "SECRETS_JSON_OUTPUT is set to: ${SECRETS_JSON_OUTPUT}"
log_info "CONFIG_JSON_OUTPUT is set to: ${CONFIG_JSON_OUTPUT}"

echo ""
log_test "Creating test artifacts..."

# Test 1: Env export with default filename
log_info "Test 1: Exporting env vars with default filename"
cd "${KOMPOSE_ROOT}"
bash kompose.sh env export all >/dev/null 2>&1 || true

if [ -f "${TEMP_DIR}/env-vars.json" ]; then
    log_success "✓ env-vars.json created in temp directory"
else
    log_error "✗ env-vars.json not found in temp directory"
fi

# Test 2: Env export with custom filename
log_info "Test 2: Exporting env vars with custom filename (config.json)"
cd "${KOMPOSE_ROOT}"
bash kompose.sh env export all config.json >/dev/null 2>&1 || true

if [ -f "${TEMP_DIR}/config.json" ]; then
    log_success "✓ config.json created in temp directory"
else
    log_error "✗ config.json not found in temp directory"
fi

# Test 3: Check that root directory is clean
log_info "Test 3: Verifying root directory is clean"
FOUND_ARTIFACTS=0

for artifact in config.json env-vars.json secrets.json; do
    if [ -f "${KOMPOSE_ROOT}/${artifact}" ]; then
        # Check if it was created in the last minute (might be a test artifact)
        if [ $(find "${KOMPOSE_ROOT}/${artifact}" -mmin -1 2>/dev/null | wc -l) -gt 0 ]; then
            log_warning "✗ Found recent artifact in root: ${artifact}"
            FOUND_ARTIFACTS=$((FOUND_ARTIFACTS + 1))
        fi
    fi
done

if [ $FOUND_ARTIFACTS -eq 0 ]; then
    log_success "✓ No test artifacts found in root directory"
else
    log_warning "Found $FOUND_ARTIFACTS recent artifacts in root (may need cleanup)"
fi

# Test 4: List all files in temp directory
echo ""
log_info "Contents of temp directory:"
ls -lah "${TEMP_DIR}" 2>/dev/null || log_warning "Temp directory is empty or doesn't exist"

echo ""
log_section "CLEANUP"

# Cleanup
cleanup_test_env

# Verify cleanup
echo ""
log_info "Verifying cleanup..."
if [ ! -d "${TEMP_DIR}" ]; then
    log_success "✓ Temp directory removed"
else
    log_error "✗ Temp directory still exists"
fi

echo ""
log_success "Verification complete!"
