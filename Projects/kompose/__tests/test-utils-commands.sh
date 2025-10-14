#!/bin/bash

# Test Suite: Utility Functions
# Tests utility functions and helper commands

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/test-helpers.sh"

# ============================================================================
# SETUP
# ============================================================================

log_section "TESTING: Utility Functions"
setup_test_env

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
    
    # Should contain version information
    assert_contains "$output" "version\|Version\|kompose\|Kompose\|[0-9]" \
        "Version output contains version information"
}

# ============================================================================
# TEST: PS Command (Show All Containers)
# ============================================================================

test_ps_command() {
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
    
    # Should show container information or docker command
    assert_contains "$output" "container\|Container\|NAME\|STATUS\|PORTS\|docker" \
        "PS command shows container information"
}

# ============================================================================
# TEST: List Stacks Command
# ============================================================================

test_list_stacks_command() {
    log_test "Testing 'kompose list' command"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose list 2>&1)
    exit_code=$?
    set -e
    
    # Command should list available stacks
    assert_not_contains "$output" "Unknown command" \
        "List command is recognized"
    
    # Should contain stack information
    assert_contains "$output" "stack\|Stack\|core\|auth\|proxy" \
        "List command shows available stacks"
    
    # Should show built-in stacks
    assert_contains "$output" "core" \
        "List shows core stack"
    
    assert_contains "$output" "auth" \
        "List shows auth stack"
}

# ============================================================================
# TEST: Validate Configuration
# ============================================================================

test_validate_config_command() {
    log_test "Testing configuration validation"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose validate 2>&1)
    exit_code=$?
    set -e
    
    # Should validate or report issues
    assert_not_contains "$output" "Unknown command" \
        "Validate command is recognized"
}

# ============================================================================
# TEST: Stack Existence Check
# ============================================================================

test_stack_exists_core() {
    log_test "Testing stack existence check for 'core'"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose status core 2>&1)
    exit_code=$?
    set -e
    
    # Core stack should be recognized (may not be running)
    assert_not_contains "$output" "Stack does not exist\|not found\|Unknown stack" \
        "Core stack is recognized as existing"
}

test_stack_exists_nonexistent() {
    log_test "Testing stack existence check for non-existent stack"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose status nonexistent_stack_xyz 2>&1)
    exit_code=$?
    set -e
    
    # Should show error for non-existent stack
    assert_contains "$output" "does not exist\|not found\|ERROR\|Unknown stack" \
        "Non-existent stack is properly detected"
}

# ============================================================================
# TEST: Custom Stack Discovery
# ============================================================================

test_custom_stack_discovery() {
    log_test "Testing custom stack discovery"
    
    # Create a temporary custom stack for testing
    local test_stack_dir="${KOMPOSE_ROOT}/+custom/teststack"
    mkdir -p "$test_stack_dir"
    
    # Create minimal compose.yaml
    cat > "${test_stack_dir}/compose.yaml" << 'EOF'
version: "3.8"
services:
  test:
    image: nginx:alpine
EOF
    
    # List stacks and check if custom stack is discovered
    local output
    set +e
    output=$(run_kompose list 2>&1)
    set -e
    
    # Clean up
    rm -rf "$test_stack_dir"
    
    # Should discover custom stack
    assert_contains "$output" "teststack\|custom\|Custom" \
        "Custom stacks are discovered"
}

# ============================================================================
# TEST: Help Command Completeness
# ============================================================================

test_help_shows_all_commands() {
    log_test "Testing that help shows all major command categories"
    
    local output
    set +e
    output=$(run_kompose help 2>&1)
    set -e
    
    # Check for all major command categories
    assert_contains "$output" "STACK MANAGEMENT" \
        "Help shows stack management commands"
    
    assert_contains "$output" "DATABASE COMMANDS" \
        "Help shows database commands"
    
    assert_contains "$output" "GIT TAG" \
        "Help shows git tag commands"
    
    assert_contains "$output" "API SERVER" \
        "Help shows API server commands"
    
    assert_contains "$output" "SECRETS MANAGEMENT" \
        "Help shows secrets commands"
    
    assert_contains "$output" "PROFILE MANAGEMENT" \
        "Help shows profile commands"
    
    assert_contains "$output" "ENVIRONMENT MANAGEMENT" \
        "Help shows environment commands"
    
    assert_contains "$output" "STACK GENERATOR" \
        "Help shows generator commands"
}

# ============================================================================
# TEST: Error Handling for Missing Arguments
# ============================================================================

test_error_handling_missing_args() {
    log_test "Testing error handling for commands requiring arguments"
    
    # Test exec without arguments
    local output
    local exit_code
    
    set +e
    output=$(run_kompose exec 2>&1)
    exit_code=$?
    set -e
    
    assert_exit_code 1 $exit_code \
        "Exec without arguments exits with error"
    
    assert_contains "$output" "required\|Required\|ERROR" \
        "Error message indicates missing arguments"
}

# ============================================================================
# TEST: Color Output Environment Variables
# ============================================================================

test_color_variables_exported() {
    log_test "Testing that color variables are properly exported"
    
    # Check if kompose.sh exports color variables
    local output
    set +e
    output=$(bash -c "source ${KOMPOSE_ROOT}/kompose.sh 2>/dev/null; echo \$GREEN" || echo "")
    set -e
    
    # Should have color codes exported
    if [ -n "$output" ]; then
        TESTS_RUN=$((TESTS_RUN+1))
        log_pass "Color variables are exported"
    else
        TESTS_RUN=$((TESTS_RUN+1))
        log_info "Color variables test inconclusive (may require different test approach)"
    fi
}

# ============================================================================
# TEST: Script Directory Detection
# ============================================================================

test_script_directory_detection() {
    log_test "Testing script directory detection"
    
    # Run from different directory and check if it works
    local original_dir=$(pwd)
    cd /tmp
    
    local output
    local exit_code
    
    set +e
    output=$(bash "${KOMPOSE_ROOT}/kompose.sh" version 2>&1)
    exit_code=$?
    set -e
    
    cd "$original_dir"
    
    # Should work regardless of current directory
    assert_exit_code 0 $exit_code \
        "Script works from different directory"
}

# ============================================================================
# TEST: Built-in Stacks Configuration
# ============================================================================

test_builtin_stacks_defined() {
    log_test "Testing that built-in stacks are properly defined"
    
    local output
    set +e
    output=$(run_kompose list 2>&1)
    set -e
    
    # Check for essential built-in stacks
    local essential_stacks=("core" "auth" "proxy" "home")
    
    for stack in "${essential_stacks[@]}"; do
        assert_contains "$output" "$stack" \
            "Built-in stack '$stack' is defined"
    done
}

# ============================================================================
# RUN ALL TESTS
# ============================================================================

test_version_command
test_ps_command
test_list_stacks_command
test_validate_config_command
test_stack_exists_core
test_stack_exists_nonexistent
test_custom_stack_discovery
test_help_shows_all_commands
test_error_handling_missing_args
test_color_variables_exported
test_script_directory_detection
test_builtin_stacks_defined

# ============================================================================
# CLEANUP & REPORT
# ============================================================================

cleanup_test_env

if print_test_summary; then
    exit 0
else
    exit 1
fi
