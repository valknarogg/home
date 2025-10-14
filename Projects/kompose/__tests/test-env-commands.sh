#!/bin/bash

# Test Suite: Environment Commands
# Tests environment management commands

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/test-helpers.sh"

# ============================================================================
# SETUP
# ============================================================================

log_section "TESTING: Environment Commands"
setup_test_env

# ============================================================================
# TEST: Env Command Without Subcommand
# ============================================================================

test_env_no_subcommand() {
    log_test "Testing 'kompose env' without subcommand"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose env 2>&1)
    exit_code=$?
    set -e
    
    # Should exit with error
    assert_exit_code 1 $exit_code \
        "Env command requires subcommand"
    
    assert_contains "$output" "ENV subcommand required\|subcommand\|ERROR" \
        "Error message indicates subcommand is required"
    
    # Should show available commands
    assert_contains "$output" "list\|generate\|export\|stacks\|help" \
        "Error message shows available env commands"
}

# ============================================================================
# TEST: Invalid Env Subcommand
# ============================================================================

test_env_invalid_subcommand() {
    log_test "Testing invalid env subcommand"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose env invalid_xyz 2>&1)
    exit_code=$?
    set -e
    
    # Should exit with error
    assert_exit_code 1 $exit_code \
        "Invalid env subcommand should fail"
    
    assert_contains "$output" "Unknown env command\|Unknown\|ERROR\|Invalid" \
        "Invalid env subcommand produces error"
}

# ============================================================================
# TEST: Env List All Syntax
# ============================================================================

test_env_list_all_syntax() {
    log_test "Testing 'kompose env list' command"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose env list 2>&1)
    exit_code=$?
    set -e
    
    # Command should be recognized
    assert_not_contains "$output" "Unknown env command" \
        "Env list command is recognized"
    
    # Should show stacks or environment info
    assert_contains "$output" "stack\|Stack\|environment\|Environment\|variable" \
        "Env list shows environment information"
}

# ============================================================================
# TEST: Env List Specific Stack
# ============================================================================

test_env_list_stack() {
    log_test "Testing 'kompose env list STACK' command"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose env list core 2>&1)
    exit_code=$?
    set -e
    
    # Command should be recognized
    assert_not_contains "$output" "Unknown env command" \
        "Env list with stack name is recognized"
    
    # Should show core stack environment info
    assert_contains "$output" "core\|environment\|variable\|.env" \
        "Env list shows stack-specific information"
}

# ============================================================================
# TEST: Env Generate All Syntax
# ============================================================================

test_env_generate_all_syntax() {
    log_test "Testing 'kompose env generate' command"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose env generate 2>&1)
    exit_code=$?
    set -e
    
    # Command should be recognized
    assert_not_contains "$output" "Unknown env command" \
        "Env generate command is recognized"
    
    # May generate files or show status
    assert_contains "$output" "generate\|Generating\|.env\|stack\|variable" \
        "Env generate shows generation status"
}

# ============================================================================
# TEST: Env Generate Specific Stack
# ============================================================================

test_env_generate_stack() {
    log_test "Testing 'kompose env generate STACK' command"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose env generate core 2>&1)
    exit_code=$?
    set -e
    
    # Command should be recognized
    assert_not_contains "$output" "Unknown env command" \
        "Env generate with stack name is recognized"
}

# ============================================================================
# TEST: Env Generate with Force Flag
# ============================================================================

test_env_generate_force() {
    log_test "Testing 'kompose env generate' with --force flag"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose env generate core --force 2>&1)
    exit_code=$?
    set -e
    
    # Should accept --force option
    assert_not_contains "$output" "Unknown option\|Unknown env command" \
        "Env generate accepts --force flag"
}

# ============================================================================
# TEST: Env Export All Syntax
# ============================================================================

test_env_export_all_syntax() {
    log_test "Testing 'kompose env export' command"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose env export 2>&1)
    exit_code=$?
    set -e
    
    # Command should be recognized
    assert_not_contains "$output" "Unknown env command" \
        "Env export command is recognized"
}

# ============================================================================
# TEST: Env Export with File Argument
# ============================================================================

test_env_export_with_file() {
    log_test "Testing 'kompose env export' with file argument"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose env export all config.json 2>&1)
    exit_code=$?
    set -e
    
    # Should accept file argument
    assert_not_contains "$output" "Unknown option\|Unknown env command" \
        "Env export accepts file argument"
}

# ============================================================================
# TEST: Env Stacks Syntax
# ============================================================================

test_env_stacks_syntax() {
    log_test "Testing 'kompose env stacks' command"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose env stacks 2>&1)
    exit_code=$?
    set -e
    
    # Command should be recognized
    assert_not_contains "$output" "Unknown env command" \
        "Env stacks command is recognized"
    
    # Should show list of stacks with environment definitions
    assert_contains "$output" "stack\|Stack\|environment\|variable\|.env" \
        "Env stacks shows stack information"
}

# ============================================================================
# TEST: Env Help Syntax
# ============================================================================

test_env_help_syntax() {
    log_test "Testing 'kompose env help' command"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose env help 2>&1)
    exit_code=$?
    set -e
    
    # Should show help
    assert_exit_code 0 $exit_code \
        "Env help command exits successfully"
    
    assert_contains "$output" "environment\|Environment\|command\|Command\|usage\|Usage" \
        "Env help shows usage information"
}

# ============================================================================
# TEST: Env List with Non-existent Stack
# ============================================================================

test_env_list_nonexistent_stack() {
    log_test "Testing 'kompose env list' with non-existent stack"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose env list nonexistent_stack_xyz 2>&1)
    exit_code=$?
    set -e
    
    # Should show warning or error for non-existent stack
    # The env module uses log_warning for stacks without ENV_VARS defined
    assert_contains "$output" "not found\|does not exist\|ERROR\|Unknown stack\|No environment variables defined" \
        "Error or warning shown for non-existent stack"
}

# ============================================================================
# TEST: Env Generate All Keyword
# ============================================================================

test_env_generate_all_keyword() {
    log_test "Testing 'kompose env generate all' command"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose env generate all 2>&1)
    exit_code=$?
    set -e
    
    # Should generate for all stacks
    assert_not_contains "$output" "Unknown env command\|Unknown stack" \
        "Env generate all is recognized"
}

# ============================================================================
# RUN ALL TESTS
# ============================================================================

test_env_no_subcommand
test_env_invalid_subcommand
test_env_list_all_syntax
test_env_list_stack
test_env_generate_all_syntax
test_env_generate_stack
test_env_generate_force
test_env_export_all_syntax
test_env_export_with_file
test_env_stacks_syntax
test_env_help_syntax
test_env_list_nonexistent_stack
test_env_generate_all_keyword

# ============================================================================
# CLEANUP & REPORT
# ============================================================================

cleanup_test_env

if print_test_summary; then
    exit 0
else
    exit 1
fi
