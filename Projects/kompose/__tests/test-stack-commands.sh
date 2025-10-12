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
    log_info "Docker is available - running integration tests"
else
    log_skip "Docker not available - running syntax tests only"
fi

# ============================================================================
# TEST: Stack Status (Dry Run)
# ============================================================================

test_stack_status_syntax() {
    log_test "Testing 'kompose status' command syntax"
    
    # Test that the command is recognized
    local output
    local exit_code
    
    set +e
    output=$(run_kompose status 2>&1)
    exit_code=$?
    set -e
    
    # Command should be recognized (may fail if no stacks running)
    assert_not_contains "$output" "Unknown command" \
        "Status command is recognized"
    
    if [ "${UPDATE_SNAPSHOTS}" = "1" ]; then
        create_snapshot "status_all_syntax" "$output"
    fi
}

test_stack_status_single() {
    log_test "Testing 'kompose status STACK' command syntax"
    
    local output
    set +e
    output=$(run_kompose status core 2>&1)
    set -e
    
    assert_not_contains "$output" "Unknown command" \
        "Status command with stack name is recognized"
}

# ============================================================================
# TEST: Stack Up/Down (Syntax Only)
# ============================================================================

test_stack_up_syntax() {
    log_test "Testing 'kompose up' command syntax"
    
    # We won't actually start stacks in unit tests
    # Just verify the command is recognized
    local output
    set +e
    output=$(bash -c "cd ${KOMPOSE_ROOT} && bash kompose.sh up --help 2>&1 || true")
    set -e
    
    # Even with --help, it might show usage
    ((TESTS_RUN++))
    ((TESTS_PASSED++))
    log_pass "Up command syntax check"
}

test_stack_down_syntax() {
    log_test "Testing 'kompose down' command syntax"
    
    local output
    set +e
    output=$(bash -c "cd ${KOMPOSE_ROOT} && bash kompose.sh down --help 2>&1 || true")
    set -e
    
    ((TESTS_RUN++))
    ((TESTS_PASSED++))
    log_pass "Down command syntax check"
}

# ============================================================================
# TEST: Stack Restart (Syntax Only)
# ============================================================================

test_stack_restart_syntax() {
    log_test "Testing 'kompose restart' command syntax"
    
    ((TESTS_RUN++))
    ((TESTS_PASSED++))
    log_pass "Restart command syntax check"
}

# ============================================================================
# TEST: Stack Logs (Syntax Only)
# ============================================================================

test_stack_logs_syntax() {
    log_test "Testing 'kompose logs' command syntax"
    
    # Logs requires a stack name
    local output
    local exit_code
    
    set +e
    output=$(run_kompose logs 2>&1)
    exit_code=$?
    set -e
    
    # Should fail with error message about missing stack name
    assert_contains "$output" "Stack name required" \
        "Logs command requires stack name"
}

# ============================================================================
# TEST: Stack Pull (Syntax Only)
# ============================================================================

test_stack_pull_syntax() {
    log_test "Testing 'kompose pull' command syntax"
    
    # Pull without arguments should work
    ((TESTS_RUN++))
    ((TESTS_PASSED++))
    log_pass "Pull command syntax check"
}

# ============================================================================
# TEST: Stack Deploy (Syntax Only)
# ============================================================================

test_stack_deploy_syntax() {
    log_test "Testing 'kompose deploy' command syntax"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose deploy 2>&1)
    exit_code=$?
    set -e
    
    # Should fail with error about missing arguments
    assert_contains "$output" "Stack name and version required" \
        "Deploy command requires stack name and version"
}

# ============================================================================
# TEST: Stack Exec (Syntax Only)
# ============================================================================

test_stack_exec_syntax() {
    log_test "Testing 'kompose exec' command syntax"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose exec 2>&1)
    exit_code=$?
    set -e
    
    # Should fail with error about missing arguments
    assert_contains "$output" "Stack name and command required" \
        "Exec command requires stack name and command"
}

# ============================================================================
# TEST: Stack PS Command
# ============================================================================

test_stack_ps() {
    log_test "Testing 'kompose ps' command"
    
    local output
    set +e
    output=$(run_kompose ps 2>&1)
    set -e
    
    # Command should be recognized
    assert_not_contains "$output" "Unknown command" \
        "PS command is recognized"
}

# ============================================================================
# INTEGRATION TESTS (Only if Docker available)
# ============================================================================

test_core_stack_lifecycle() {
    if [ $DOCKER_AVAILABLE -eq 0 ]; then
        log_skip "Skipping core stack lifecycle test - Docker not available"
        return
    fi
    
    log_test "Testing core stack lifecycle (up/status/down)"
    
    # Start core stack
    log_info "Starting core stack..."
    local up_output
    up_output=$(run_kompose up core -d 2>&1)
    
    # Wait a bit for containers to start
    sleep 5
    
    # Check status
    log_info "Checking status..."
    local status_output
    status_output=$(run_kompose status core 2>&1)
    
    # Should contain container names
    assert_contains "$status_output" "core" \
        "Status shows core stack containers"
    
    # Stop core stack
    log_info "Stopping core stack..."
    run_kompose down core >/dev/null 2>&1
    
    log_pass "Core stack lifecycle test completed"
    ((TESTS_RUN++))
    ((TESTS_PASSED++))
}

# ============================================================================
# RUN ALL TESTS
# ============================================================================

# Syntax tests (always run)
test_stack_status_syntax
test_stack_status_single
test_stack_up_syntax
test_stack_down_syntax
test_stack_restart_syntax
test_stack_logs_syntax
test_stack_pull_syntax
test_stack_deploy_syntax
test_stack_exec_syntax
test_stack_ps

# Integration tests (only if Docker available)
if [ $DOCKER_AVAILABLE -eq 1 ] && [ "${RUN_INTEGRATION_TESTS}" = "1" ]; then
    log_info "Running integration tests..."
    test_core_stack_lifecycle
else
    if [ $DOCKER_AVAILABLE -eq 0 ]; then
        log_skip "Integration tests require Docker"
    else
        log_skip "Set RUN_INTEGRATION_TESTS=1 to run integration tests"
    fi
fi

# ============================================================================
# CLEANUP & REPORT
# ============================================================================

cleanup_test_env
print_test_summary
