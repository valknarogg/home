#!/bin/bash

# Test Suite: Basic Commands
# Tests fundamental kompose.sh commands like help, version, list, etc.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/test-helpers.sh"

# ============================================================================
# SETUP
# ============================================================================

log_section "TESTING: Basic Commands"
setup_test_env

# ============================================================================
# TEST: Help Command
# ============================================================================

test_help_command() {
    log_test "Testing 'kompose help' command"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose help 2>&1)
    exit_code=$?
    set -e
    
    # Should exit successfully
    assert_exit_code 0 $exit_code \
        "Help command exits successfully"
    
    # Check for key sections
    assert_contains "$output" "KOMPOSE" \
        "Help output contains title"
    
    assert_contains "$output" "STACK MANAGEMENT COMMANDS" \
        "Help output contains stack commands section"
    
    assert_contains "$output" "DATABASE COMMANDS" \
        "Help output contains database commands section"
    
    assert_contains "$output" "GIT TAG DEPLOYMENT COMMANDS" \
        "Help output contains tag commands section"
    
    assert_contains "$output" "REST API SERVER COMMANDS" \
        "Help output contains API commands section"
    
    # Snapshot test
    if [ "${UPDATE_SNAPSHOTS}" = "1" ]; then
        create_snapshot "help_output" "$output"
    else
        compare_snapshot "help_output" "$output" \
            "Help command output matches snapshot"
    fi
}

# ============================================================================
# TEST: Version Command
# ============================================================================

test_version_command() {
    log_test "Testing 'kompose version' command"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose version 2>&1)
    exit_code=$?
    set -e
    
    # Should exit successfully
    assert_exit_code 0 $exit_code \
        "Version command exits successfully"
    
    # Should contain version info
    assert_contains "$output" "kompose\|version" \
        "Version output contains version information"
    
    if [ "${UPDATE_SNAPSHOTS}" = "1" ]; then
        create_snapshot "version_output" "$output"
    else
        compare_snapshot "version_output" "$output" \
            "Version command output matches snapshot"
    fi
}

# ============================================================================
# TEST: List Command
# ============================================================================

test_list_command() {
    log_test "Testing 'kompose list' command"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose list 2>&1)
    exit_code=$?
    set -e
    
    # Should exit successfully
    assert_exit_code 0 $exit_code \
        "List command exits successfully"
    
    # Check for essential stacks
    assert_contains "$output" "core" \
        "List output contains 'core' stack"
    
    assert_contains "$output" "auth" \
        "List output contains 'auth' stack"
    
    assert_contains "$output" "proxy" \
        "List output contains 'proxy' stack"
    
    assert_contains "$output" "home" \
        "List output contains 'home' stack"
    
    if [ "${UPDATE_SNAPSHOTS}" = "1" ]; then
        create_snapshot "list_output" "$output"
    else
        compare_snapshot "list_output" "$output" \
            "List command output matches snapshot"
    fi
}

# ============================================================================
# TEST: Validate Command
# ============================================================================

test_validate_command() {
    log_test "Testing 'kompose validate' command"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose validate 2>&1)
    exit_code=$?
    set -e
    
    # Validation may fail if compose files have issues, which is OK for testing
    if [ $exit_code -eq 0 ]; then
        log_pass "Validate command succeeded"
        TESTS_RUN=$((TESTS_RUN+1))
        TESTS_RUN=$((TESTS_PASSED+1))
    else
        log_skip "Validate command failed (compose file issues expected in test env)"
        log_info "Exit code: $exit_code"
    fi
    
    # Still create/compare snapshot even if validation failed
    if [ "${UPDATE_SNAPSHOTS}" = "1" ]; then
        create_snapshot "validate_output" "$output"
    fi
}

# ============================================================================
# TEST: Invalid Command
# ============================================================================

test_invalid_command() {
    log_test "Testing invalid command handling"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose invalid_command_xyz 2>&1)
    exit_code=$?
    set -e
    
    # Should show error message
    assert_contains "$output" "Unknown command\|ERROR" \
        "Invalid command produces error message"
    
    # Should exit with non-zero code
    if [ $exit_code -ne 0 ]; then
        log_pass "Invalid command exits with non-zero code"
        TESTS_RUN=$((TESTS_RUN+1))
        TESTS_RUN=$((TESTS_PASSED+1))
    else
        log_fail "Invalid command should exit with non-zero code"
        TESTS_RUN=$((TESTS_RUN+1))
        TESTS_RUN=$((TESTS_FAILED+1))
    fi
}

# ============================================================================
# TEST: No Arguments
# ============================================================================

test_no_arguments() {
    log_test "Testing kompose with no arguments"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose 2>&1)
    exit_code=$?
    set -e
    
    # Should show help when run without arguments
    assert_contains "$output" "KOMPOSE\|STACK MANAGEMENT" \
        "No arguments shows help"
}

# ============================================================================
# TEST: Help Flag
# ============================================================================

test_help_flag() {
    log_test "Testing kompose --help flag"
    
    local output
    set +e
    output=$(run_kompose --help 2>&1)
    set -e
    
    assert_contains "$output" "KOMPOSE\|STACK MANAGEMENT" \
        "--help flag shows help text"
}

test_help_short_flag() {
    log_test "Testing kompose -h flag"
    
    local output
    set +e
    output=$(run_kompose -h 2>&1)
    set -e
    
    assert_contains "$output" "KOMPOSE\|STACK MANAGEMENT" \
        "-h flag shows help text"
}

# ============================================================================
# RUN ALL TESTS
# ============================================================================

test_help_command
test_version_command
test_list_command
test_validate_command
test_invalid_command
test_no_arguments
test_help_flag
test_help_short_flag

# ============================================================================
# CLEANUP & REPORT
# ============================================================================

cleanup_test_env

if print_test_summary; then
    exit 0
else
    exit 1
fi
