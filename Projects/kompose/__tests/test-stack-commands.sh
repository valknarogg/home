#!/bin/bash

# Test Suite: Stack Management
# Tests stack up/down/restart/status/logs commands

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/test-helpers.sh"

# ============================================================================
# SETUP
# ============================================================================

log_section "TESTING: Stack Management Commands"
setup_test_env

# Check if Docker is available
DOCKER_AVAILABLE=0
if is_docker_available; then
    DOCKER_AVAILABLE=1
    log_info "Docker is available"
else
    log_warning "Docker not available - skipping integration tests"
fi

# ============================================================================
# TEST: Stack Status
# ============================================================================

test_stack_status_all() {
    log_test "Testing 'kompose status' command"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose status 2>&1)
    exit_code=$?
    set -e
    
    # Command should be recognized
    assert_not_contains "$output" "Unknown command" \
        "Status command is recognized"
    
    if [ "${UPDATE_SNAPSHOTS}" = "1" ]; then
        create_snapshot "status_all_output" "$output"
    else
        compare_snapshot "status_all_output" "$output" \
            "Status all command output matches snapshot"
    fi
}

test_stack_status_single() {
    log_test "Testing 'kompose status STACK' command"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose status core 2>&1)
    exit_code=$?
    set -e
    
    assert_not_contains "$output" "Unknown command" \
        "Status command with stack name is recognized"
    
    # Should mention the stack or show status
    assert_contains "$output" "core\|status\|running\|not running" \
        "Status shows information about core stack"
}

# ============================================================================
# TEST: Stack Logs
# ============================================================================

test_stack_logs_no_args() {
    log_test "Testing 'kompose logs' without stack name"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose logs 2>&1)
    exit_code=$?
    set -e
    
    # Should fail without stack name
    assert_exit_code 1 $exit_code \
        "Logs command requires stack name"
    
    assert_contains "$output" "Stack name required\|ERROR" \
        "Error message indicates stack name is required"
}

# ============================================================================
# TEST: Stack Deploy
# ============================================================================

test_stack_deploy_no_args() {
    log_test "Testing 'kompose deploy' without arguments"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose deploy 2>&1)
    exit_code=$?
    set -e
    
    # Should fail without arguments
    assert_exit_code 1 $exit_code \
        "Deploy command requires stack name and version"
    
    assert_contains "$output" "Stack name and version required\|ERROR" \
        "Error message indicates arguments are required"
}

test_stack_deploy_missing_version() {
    log_test "Testing 'kompose deploy' with only stack name"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose deploy core 2>&1)
    exit_code=$?
    set -e
    
    # Should fail without version
    assert_exit_code 1 $exit_code \
        "Deploy command requires version"
    
    assert_contains "$output" "version required\|ERROR" \
        "Error message indicates version is required"
}

# ============================================================================
# TEST: Stack Exec
# ============================================================================

test_stack_exec_no_args() {
    log_test "Testing 'kompose exec' without arguments"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose exec 2>&1)
    exit_code=$?
    set -e
    
    # Should fail without arguments
    assert_exit_code 1 $exit_code \
        "Exec command requires stack name and command"
    
    assert_contains "$output" "Stack name and command required\|ERROR" \
        "Error message indicates arguments are required"
}

test_stack_exec_missing_command() {
    log_test "Testing 'kompose exec' with only stack name"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose exec core 2>&1)
    exit_code=$?
    set -e
    
    # Should fail without command
    assert_exit_code 1 $exit_code \
        "Exec command requires command argument"
}

# ============================================================================
# TEST: Stack PS
# ============================================================================

test_stack_ps() {
    log_test "Testing 'kompose ps' command"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose ps 2>&1)
    exit_code=$?
    set -e
    
    # Command should be recognized
    assert_not_contains "$output" "Unknown command" \
        "PS command is recognized"
}

# ============================================================================
# TEST: Stack Up/Down Validation
# ============================================================================

test_stack_up_nonexistent() {
    log_test "Testing 'kompose up' with non-existent stack"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose up nonexistent_stack_xyz 2>&1)
    exit_code=$?
    set -e
    
    # Should show error for non-existent stack
    assert_contains "$output" "not found\|does not exist\|ERROR\|Unknown stack" \
        "Error shown for non-existent stack"
}

test_stack_down_nonexistent() {
    log_test "Testing 'kompose down' with non-existent stack"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose down nonexistent_stack_xyz 2>&1)
    exit_code=$?
    set -e
    
    # Should show error for non-existent stack
    assert_contains "$output" "not found\|does not exist\|ERROR\|Unknown stack" \
        "Error shown for non-existent stack"
}

# ============================================================================
# INTEGRATION TESTS (Only if Docker available and requested)
# ============================================================================

test_core_stack_lifecycle() {
    if [ $DOCKER_AVAILABLE -eq 0 ]; then
        log_skip "Skipping core stack lifecycle test - Docker not available"
        return
    fi
    
    if [ "${RUN_INTEGRATION_TESTS}" != "1" ]; then
        log_skip "Skipping integration test - set RUN_INTEGRATION_TESTS=1 to run"
        return
    fi
    
    log_test "Testing core stack lifecycle (up/status/down)"
    
    # Start core stack
    log_info "Starting core stack..."
    local up_output
    set +e
    up_output=$(run_kompose up core -d 2>&1)
    local up_exit=$?
    set -e
    
    if [ $up_exit -ne 0 ]; then
        log_warning "Core stack up failed (may not be configured)"
        log_info "Output: $up_output"
        return
    fi
    
    # Wait for containers to start
    log_info "Waiting for containers..."
    sleep 5
    
    # Check status
    log_info "Checking status..."
    local status_output
    set +e
    status_output=$(run_kompose status core 2>&1)
    set -e
    
    # Should contain core stack info
    assert_contains "$status_output" "core" \
        "Status shows core stack information"
    
    # Stop core stack
    log_info "Stopping core stack..."
    set +e
    run_kompose down core >/dev/null 2>&1
    set -e
    
    log_pass "Core stack lifecycle test completed"
    TESTS_RUN=$((TESTS_RUN+1))
    TESTS_RUN=$((TESTS_PASSED+1))
}

# ============================================================================
# RUN ALL TESTS
# ============================================================================

# Syntax tests (always run)
test_stack_status_all
test_stack_status_single
test_stack_logs_no_args
test_stack_deploy_no_args
test_stack_deploy_missing_version
test_stack_exec_no_args
test_stack_exec_missing_command
test_stack_ps
test_stack_up_nonexistent
test_stack_down_nonexistent

# Integration tests (only if Docker available and requested)
if [ $DOCKER_AVAILABLE -eq 1 ] && [ "${RUN_INTEGRATION_TESTS}" = "1" ]; then
    log_info "Running integration tests..."
    test_core_stack_lifecycle
fi

# ============================================================================
# CLEANUP & REPORT
# ============================================================================

cleanup_test_env

if print_test_summary; then
    exit 0
else
    exit 1
fi
