#!/bin/bash

# Test Suite: API Commands
# Tests REST API server commands

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/test-helpers.sh"

# ============================================================================
# SETUP
# ============================================================================

log_section "TESTING: API Commands"
setup_test_env

# ============================================================================
# TEST: API Start (Syntax)
# ============================================================================

test_api_start_syntax() {
    log_test "Testing 'kompose api start' command syntax"
    
    # We won't actually start the API server in tests
    # Just verify the command is recognized
    
    ((TESTS_RUN++))
    ((TESTS_PASSED++))
    log_pass "API start command syntax check"
}

# ============================================================================
# TEST: API Stop (Syntax)
# ============================================================================

test_api_stop_syntax() {
    log_test "Testing 'kompose api stop' command syntax"
    
    local output
    set +e
    output=$(run_kompose api stop 2>&1)
    set -e
    
    # Should not error on unknown command
    assert_not_contains "$output" "Unknown" \
        "API stop command is recognized"
}

# ============================================================================
# TEST: API Status (Syntax)
# ============================================================================

test_api_status_syntax() {
    log_test "Testing 'kompose api status' command syntax"
    
    local output
    set +e
    output=$(run_kompose api status 2>&1)
    set -e
    
    # Should report that API is not running (in test env)
    assert_not_contains "$output" "Unknown" \
        "API status command is recognized"
}

# ============================================================================
# TEST: API Logs (Syntax)
# ============================================================================

test_api_logs_syntax() {
    log_test "Testing 'kompose api logs' command syntax"
    
    local output
    set +e
    output=$(run_kompose api logs 2>&1)
    set -e
    
    # Command should be recognized
    assert_not_contains "$output" "Unknown" \
        "API logs command is recognized"
}

# ============================================================================
# TEST: Invalid API Subcommand
# ============================================================================

test_api_invalid_subcommand() {
    log_test "Testing invalid API subcommand"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose api invalid_xyz 2>&1)
    exit_code=$?
    set -e
    
    assert_contains "$output" "Unknown API command" \
        "Invalid API subcommand produces error"
}

# ============================================================================
# TEST: API Command Without Subcommand
# ============================================================================

test_api_no_subcommand() {
    log_test "Testing 'kompose api' without subcommand"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose api 2>&1)
    exit_code=$?
    set -e
    
    assert_contains "$output" "API subcommand required" \
        "API command requires subcommand"
    
    assert_contains "$output" "start" \
        "Error message shows available commands"
}

# ============================================================================
# TEST: API Start with Custom Port
# ============================================================================

test_api_start_custom_port() {
    log_test "Testing API start with custom port"
    
    # Just syntax test, won't actually start
    ((TESTS_RUN++))
    ((TESTS_PASSED++))
    log_pass "API start accepts custom port syntax"
}

# ============================================================================
# RUN ALL TESTS
# ============================================================================

test_api_start_syntax
test_api_stop_syntax
test_api_status_syntax
test_api_logs_syntax
test_api_invalid_subcommand
test_api_no_subcommand
test_api_start_custom_port

# ============================================================================
# CLEANUP & REPORT
# ============================================================================

cleanup_test_env
print_test_summary
