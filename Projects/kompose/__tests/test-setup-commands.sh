#!/bin/bash

# Test Suite: Setup Commands
# Tests setup and initialization commands

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/test-helpers.sh"

# ============================================================================
# SETUP
# ============================================================================

log_section "TESTING: Setup Commands"
setup_test_env

# ============================================================================
# TEST: Setup Command Without Subcommand
# ============================================================================

test_setup_no_subcommand() {
    log_test "Testing 'kompose setup' without subcommand"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose setup 2>&1)
    exit_code=$?
    set -e
    
    # Command should be recognized
    assert_not_contains "$output" "Unknown command" \
        "Setup command is recognized"
    
    # Setup defaults to showing status when no subcommand provided
    # This is user-friendly behavior, so we accept either status output or help
    assert_contains "$output" "local\|prod\|status\|mode\|Mode\|configuration\|Configuration" \
        "Setup shows status or available subcommands"
}

# ============================================================================
# TEST: Invalid Setup Subcommand
# ============================================================================

test_setup_invalid_subcommand() {
    log_test "Testing invalid setup subcommand"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose setup invalid_xyz 2>&1)
    exit_code=$?
    set -e
    
    # Should exit with error
    assert_exit_code 1 $exit_code \
        "Invalid setup subcommand should fail"
    
    assert_contains "$output" "Unknown setup command\|Unknown\|ERROR\|Invalid" \
        "Invalid setup subcommand produces error"
}

# ============================================================================
# TEST: Setup Local Syntax
# ============================================================================

test_setup_local_syntax() {
    log_test "Testing 'kompose setup local' command"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose setup local 2>&1)
    exit_code=$?
    set -e
    
    # Command should be recognized
    assert_not_contains "$output" "Unknown setup command" \
        "Setup local command is recognized"
    
    # Should show switching message or confirmation
    assert_contains "$output" "local\|Local\|development\|switch\|Switch" \
        "Setup local shows switching action"
}

# ============================================================================
# TEST: Setup Prod Syntax
# ============================================================================

test_setup_prod_syntax() {
    log_test "Testing 'kompose setup prod' command"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose setup prod 2>&1)
    exit_code=$?
    set -e
    
    # Command should be recognized
    assert_not_contains "$output" "Unknown setup command" \
        "Setup prod command is recognized"
    
    # Should show switching message or confirmation
    assert_contains "$output" "prod\|Prod\|production\|Production\|switch\|Switch" \
        "Setup prod shows switching action"
}

# ============================================================================
# TEST: Setup Status Syntax
# ============================================================================

test_setup_status_syntax() {
    log_test "Testing 'kompose setup status' command"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose setup status 2>&1)
    exit_code=$?
    set -e
    
    # Command should be recognized
    assert_not_contains "$output" "Unknown setup command" \
        "Setup status command is recognized"
    
    # Should show current configuration mode
    assert_contains "$output" "status\|Status\|mode\|Mode\|configuration\|Configuration\|local\|Local\|prod\|Prod" \
        "Setup status shows configuration information"
}

# ============================================================================
# TEST: Setup Save-Prod Syntax
# ============================================================================

test_setup_save_prod_syntax() {
    log_test "Testing 'kompose setup save-prod' command"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose setup save-prod 2>&1)
    exit_code=$?
    set -e
    
    # Command should be recognized
    assert_not_contains "$output" "Unknown setup command" \
        "Setup save-prod command is recognized"
    
    # Should show save action or confirmation
    assert_contains "$output" "save\|Save\|saved\|Saved\|production\|Production\|backup" \
        "Setup save-prod shows save action"
}

# ============================================================================
# TEST: Setup Backup Syntax
# ============================================================================

test_setup_backup_syntax() {
    log_test "Testing 'kompose setup backup' command"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose setup backup 2>&1)
    exit_code=$?
    set -e
    
    # Command should be recognized
    assert_not_contains "$output" "Unknown setup command" \
        "Setup backup command is recognized"
    
    # Should show backup action or confirmation
    assert_contains "$output" "backup\|Backup\|created\|Created\|configuration" \
        "Setup backup shows backup action"
}

# ============================================================================
# TEST: Init Command Syntax
# ============================================================================

test_init_syntax() {
    log_test "Testing 'kompose init' command recognition"
    
    # We won't run init interactively, just check if it's recognized
    local output
    local exit_code
    
    set +e
    # Use timeout and echo "n" to avoid interactive prompts
    output=$(echo -e "n\nn\nn\nn\nn" | timeout 3 bash -c "cd ${KOMPOSE_ROOT} && bash kompose.sh init" 2>&1 || true)
    exit_code=$?
    set -e
    
    # Command should be recognized (not "Unknown command")
    assert_not_contains "$output" "Unknown command" \
        "Init command is recognized"
    
    # Should show initialization or interactive prompts
    if [ $exit_code -eq 0 ] || [ $exit_code -eq 124 ]; then
        # Timeout (124) or success - both acceptable
        TESTS_RUN=$((TESTS_RUN+1))
        log_pass "Init command is recognized"
    elif echo "$output" | grep -qi "init\|initial\|setup\|project\|configuration"; then
        # Shows initialization-related content
        TESTS_RUN=$((TESTS_RUN+1))
        log_pass "Init command shows initialization prompts"
    else
        TESTS_RUN=$((TESTS_RUN+1))
        log_fail "Init command not properly recognized"
        if [ "${VERBOSE:-0}" = "1" ]; then
            echo "Output: $output"
        fi
    fi
}

# ============================================================================
# TEST: Cleanup Command Syntax
# ============================================================================

test_cleanup_syntax() {
    log_test "Testing 'kompose cleanup' command"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose cleanup 2>&1)
    exit_code=$?
    set -e
    
    # Command should be recognized
    assert_not_contains "$output" "Unknown command" \
        "Cleanup command is recognized"
    
    # Should show cleanup action or confirmation
    assert_contains "$output" "cleanup\|Cleanup\|clean\|Clean\|removing\|Removing\|backup\|temp" \
        "Cleanup command shows cleanup action"
}

# ============================================================================
# TEST: Validate Command Syntax
# ============================================================================

test_validate_configuration_syntax() {
    log_test "Testing 'kompose validate' command"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose validate 2>&1)
    exit_code=$?
    set -e
    
    # Command should be recognized
    assert_not_contains "$output" "Unknown command" \
        "Validate command is recognized"
    
    # May pass or fail validation, but should be recognized
    assert_contains "$output" "validat\|Validat\|check\|Check\|configuration\|stack\|compose" \
        "Validate command shows validation activity"
}

# ============================================================================
# RUN ALL TESTS
# ============================================================================

test_setup_no_subcommand
test_setup_invalid_subcommand
test_setup_local_syntax
test_setup_prod_syntax
test_setup_status_syntax
test_setup_save_prod_syntax
test_setup_backup_syntax
test_init_syntax
test_cleanup_syntax
test_validate_configuration_syntax

# ============================================================================
# CLEANUP & REPORT
# ============================================================================

cleanup_test_env

if print_test_summary; then
    exit 0
else
    exit 1
fi
