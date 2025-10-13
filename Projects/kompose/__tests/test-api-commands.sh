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
    
    # Should exit with error
    assert_exit_code 1 $exit_code \
        "API command requires subcommand"
    
    assert_contains "$output" "API subcommand required\|subcommand\|ERROR" \
        "Error message indicates subcommand is required"
    
    # Should show available commands
    assert_contains "$output" "start\|stop\|status" \
        "Error message shows available API commands"
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
    
    # Should exit with error
    assert_exit_code 1 $exit_code \
        "Invalid API subcommand should fail"
    
    assert_contains "$output" "Unknown API command\|Unknown\|ERROR" \
        "Invalid API subcommand produces error"
}

# ============================================================================
# TEST: API Start
# ============================================================================

test_api_start_syntax() {
    log_test "Testing 'kompose api start' command recognition"
    
    # We won't actually start the API server in tests
    # Just verify the command is recognized by checking help/usage
    
    local output
    local exit_code
    
    set +e
    # Try to start on a likely-used port to trigger error, but command should be recognized
    output=$(timeout 2 bash -c "cd ${KOMPOSE_ROOT} && bash kompose.sh api start 99999" 2>&1 || true)
    exit_code=$?
    set -e
    
    # Command should be recognized (may fail for other reasons)
    assert_not_contains "$output" "Unknown API command" \
        "API start command is recognized"
}

# ============================================================================
# TEST: API Stop
# ============================================================================

test_api_stop_syntax() {
    log_test "Testing 'kompose api stop' command"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose api stop 2>&1)
    exit_code=$?
    set -e
    
    # Should not error on unknown command
    assert_not_contains "$output" "Unknown API command" \
        "API stop command is recognized"
    
    # May show message about API not running, which is fine
}

# ============================================================================
# TEST: API Status
# ============================================================================

test_api_status_syntax() {
    log_test "Testing 'kompose api status' command"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose api status 2>&1)
    exit_code=$?
    set -e
    
    # Should report that API is not running (in test env)
    assert_not_contains "$output" "Unknown API command" \
        "API status command is recognized"
    
    # Should show some status information
    assert_contains "$output" "API\|server\|running\|not running\|status" \
        "API status shows server status"
}

# ============================================================================
# TEST: API Logs
# ============================================================================

test_api_logs_syntax() {
    log_test "Testing 'kompose api logs' command"
    
    local output
    local exit_code
    
    set +e
    # Use timeout to prevent hanging if log file doesn't exist
    output=$(timeout 3 bash -c "cd ${KOMPOSE_ROOT} && bash kompose.sh api logs" 2>&1 || true)
    exit_code=$?
    set -e
    
    # Command should be recognized (may timeout or show "not running")
    assert_not_contains "$output" "Unknown API command" \
        "API logs command is recognized"
}

# ============================================================================
# TEST: API Start with Custom Port
# ============================================================================

test_api_start_custom_port() {
    log_test "Testing API start with custom port argument"
    
    local output
    local exit_code
    
    set +e
    # Use timeout to prevent actual server start
    output=$(timeout 2 bash -c "cd ${KOMPOSE_ROOT} && bash kompose.sh api start 9999" 2>&1 || true)
    exit_code=$?
    set -e
    
    # Should accept port argument without "Unknown option" error
    assert_not_contains "$output" "Unknown option\|Unknown API command" \
        "API start accepts custom port"
}

# ============================================================================
# TEST: API Start with Custom Port and Host
# ============================================================================

test_api_start_port_and_host() {
    log_test "Testing API start with port and host arguments"
    
    local output
    local exit_code
    
    set +e
    # Use timeout to prevent actual server start
    output=$(timeout 2 bash -c "cd ${KOMPOSE_ROOT} && bash kompose.sh api start 9999 127.0.0.1" 2>&1 || true)
    exit_code=$?
    set -e
    
    # Should accept both arguments
    assert_not_contains "$output" "Unknown option\|Unknown API command" \
        "API start accepts port and host arguments"
}

# ============================================================================
# RUN ALL TESTS
# ============================================================================

test_api_no_subcommand
test_api_invalid_subcommand
test_api_start_syntax
test_api_stop_syntax
test_api_status_syntax
test_api_logs_syntax
test_api_start_custom_port
test_api_start_port_and_host

# ============================================================================
# CLEANUP & REPORT
# ============================================================================

cleanup_test_env

if print_test_summary; then
    exit 0
else
    exit 1
fi
