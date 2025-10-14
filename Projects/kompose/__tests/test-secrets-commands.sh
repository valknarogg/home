#!/bin/bash

# Test Suite: Secrets Commands
# Tests secrets management commands

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/test-helpers.sh"

# ============================================================================
# SETUP
# ============================================================================

log_section "TESTING: Secrets Commands"
setup_test_env

# ============================================================================
# TEST: Secrets Command Without Subcommand
# ============================================================================

test_secrets_no_subcommand() {
    log_test "Testing 'kompose secrets' without subcommand"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose secrets 2>&1)
    exit_code=$?
    set -e
    
    # Should exit with error
    assert_exit_code 1 $exit_code \
        "Secrets command requires subcommand"
    
    assert_contains "$output" "Secrets subcommand required\|subcommand\|ERROR" \
        "Error message indicates subcommand is required"
    
    # Should show available commands
    assert_contains "$output" "generate\|validate\|list\|rotate" \
        "Error message shows available secrets commands"
}

# ============================================================================
# TEST: Invalid Secrets Subcommand
# ============================================================================

test_secrets_invalid_subcommand() {
    log_test "Testing invalid secrets subcommand"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose secrets invalid_xyz 2>&1)
    exit_code=$?
    set -e
    
    # Should exit with error
    assert_exit_code 1 $exit_code \
        "Invalid secrets subcommand should fail"
    
    assert_contains "$output" "Unknown secrets command\|Unknown\|ERROR\|Invalid" \
        "Invalid secrets subcommand produces error"
}

# ============================================================================
# TEST: Secrets Generate Syntax
# ============================================================================

test_secrets_generate_syntax() {
    log_test "Testing 'kompose secrets generate' command recognition"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose secrets generate 2>&1)
    exit_code=$?
    set -e
    
    # Command should be recognized (may fail due to missing secrets.env)
    assert_not_contains "$output" "Unknown secrets command" \
        "Secrets generate command is recognized"
}

# ============================================================================
# TEST: Secrets Validate Syntax
# ============================================================================

test_secrets_validate_syntax() {
    log_test "Testing 'kompose secrets validate' command"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose secrets validate 2>&1)
    exit_code=$?
    set -e
    
    # Command should be recognized
    assert_not_contains "$output" "Unknown secrets command" \
        "Secrets validate command is recognized"
    
    # Should validate or report issues
    assert_contains "$output" "secret\|validation\|valid\|invalid\|checking\|✓\|✗\|ERROR" \
        "Secrets validate shows validation results"
}

# ============================================================================
# TEST: Secrets List Syntax
# ============================================================================

test_secrets_list_syntax() {
    log_test "Testing 'kompose secrets list' command"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose secrets list 2>&1)
    exit_code=$?
    set -e
    
    # Command should be recognized
    assert_not_contains "$output" "Unknown secrets command" \
        "Secrets list command is recognized"
}

# ============================================================================
# TEST: Secrets Rotate Without Arguments
# ============================================================================

test_secrets_rotate_no_args() {
    log_test "Testing 'kompose secrets rotate' without arguments"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose secrets rotate 2>&1)
    exit_code=$?
    set -e
    
    # May require secret name
    # Check if command is recognized
    assert_not_contains "$output" "Unknown secrets command" \
        "Secrets rotate command is recognized"
}

# ============================================================================
# TEST: Secrets Set Without Arguments
# ============================================================================

test_secrets_set_no_args() {
    log_test "Testing 'kompose secrets set' without arguments"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose secrets set 2>&1)
    exit_code=$?
    set -e
    
    # Should require arguments
    # Check if command is recognized and reports missing args
    assert_not_contains "$output" "Unknown secrets command" \
        "Secrets set command is recognized"
    
    if [ $exit_code -ne 0 ]; then
        assert_contains "$output" "Required\|argument\|secret name\|value\|ERROR" \
            "Secrets set indicates missing arguments"
    fi
}

# ============================================================================
# TEST: Secrets Backup Syntax
# ============================================================================

test_secrets_backup_syntax() {
    log_test "Testing 'kompose secrets backup' command"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose secrets backup 2>&1)
    exit_code=$?
    set -e
    
    # Command should be recognized
    assert_not_contains "$output" "Unknown secrets command" \
        "Secrets backup command is recognized"
    
    # Should show backup action or error if secrets.env missing
    assert_contains "$output" "backup\|Backup\|secrets.env\|not found\|created\|ERROR" \
        "Secrets backup shows action or error"
}

# ============================================================================
# TEST: Secrets Export Syntax
# ============================================================================

test_secrets_export_syntax() {
    log_test "Testing 'kompose secrets export' command"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose secrets export 2>&1)
    exit_code=$?
    set -e
    
    # Command should be recognized
    assert_not_contains "$output" "Unknown secrets command" \
        "Secrets export command is recognized"
}

# ============================================================================
# TEST: Secrets List with Stack Filter
# ============================================================================

test_secrets_list_with_stack() {
    log_test "Testing 'kompose secrets list' with stack filter"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose secrets list -s core 2>&1)
    exit_code=$?
    set -e
    
    # Should accept stack filter option
    assert_not_contains "$output" "Unknown option\|Unknown secrets command" \
        "Secrets list accepts -s stack option"
}

# ============================================================================
# TEST: Secrets Generate Specific Secret
# ============================================================================

test_secrets_generate_specific() {
    log_test "Testing 'kompose secrets generate' with specific secret"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose secrets generate JWT_SECRET 2>&1)
    exit_code=$?
    set -e
    
    # Should recognize command with secret name argument
    assert_not_contains "$output" "Unknown secrets command" \
        "Secrets generate accepts secret name argument"
}

# ============================================================================
# RUN ALL TESTS
# ============================================================================

test_secrets_no_subcommand
test_secrets_invalid_subcommand
test_secrets_generate_syntax
test_secrets_validate_syntax
test_secrets_list_syntax
test_secrets_rotate_no_args
test_secrets_set_no_args
test_secrets_backup_syntax
test_secrets_export_syntax
test_secrets_list_with_stack
test_secrets_generate_specific

# ============================================================================
# CLEANUP & REPORT
# ============================================================================

cleanup_test_env

if print_test_summary; then
    exit 0
else
    exit 1
fi
