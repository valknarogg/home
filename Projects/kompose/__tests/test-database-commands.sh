#!/bin/bash

# Test Suite: Database Commands
# Tests database backup/restore/shell/status commands

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/test-helpers.sh"

# ============================================================================
# SETUP
# ============================================================================

log_section "TESTING: Database Commands"
setup_test_env

# ============================================================================
# TEST: Database Command Without Subcommand
# ============================================================================

test_db_no_subcommand() {
    log_test "Testing 'kompose db' without subcommand"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose db 2>&1)
    exit_code=$?
    set -e
    
    # Should exit with error
    assert_exit_code 1 $exit_code \
        "DB command requires subcommand"
    
    assert_contains "$output" "Database subcommand required\|subcommand\|ERROR" \
        "Error message indicates subcommand is required"
    
    # Should show available commands
    assert_contains "$output" "backup\|restore" \
        "Error message shows available database commands"
}

# ============================================================================
# TEST: Invalid Database Subcommand
# ============================================================================

test_db_invalid_subcommand() {
    log_test "Testing invalid database subcommand"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose db invalid_xyz 2>&1)
    exit_code=$?
    set -e
    
    # Should exit with error
    assert_exit_code 1 $exit_code \
        "Invalid database subcommand should fail"
    
    assert_contains "$output" "Unknown database command\|Unknown\|ERROR" \
        "Invalid database subcommand produces error"
}

# ============================================================================
# TEST: Database Backup Syntax
# ============================================================================

test_db_backup_syntax() {
    log_test "Testing 'kompose db backup' command recognition"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose db backup 2>&1)
    exit_code=$?
    set -e
    
    # Command should be recognized (may fail due to missing database)
    assert_not_contains "$output" "Unknown database command" \
        "DB backup command is recognized"
}

# ============================================================================
# TEST: Database Restore Without File
# ============================================================================

test_db_restore_no_file() {
    log_test "Testing 'kompose db restore' without file argument"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose db restore 2>&1)
    exit_code=$?
    set -e
    
    # Should require a file argument
    assert_exit_code 1 $exit_code \
        "DB restore requires file argument"
}

# ============================================================================
# TEST: Database List
# ============================================================================

test_db_list_syntax() {
    log_test "Testing 'kompose db list' command"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose db list 2>&1)
    exit_code=$?
    set -e
    
    # Command should be recognized
    assert_not_contains "$output" "Unknown database command" \
        "DB list command is recognized"
}

# ============================================================================
# TEST: Database Status
# ============================================================================

test_db_status_syntax() {
    log_test "Testing 'kompose db status' command"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose db status 2>&1)
    exit_code=$?
    set -e
    
    # Command should be recognized
    assert_not_contains "$output" "Unknown" \
        "DB status command is recognized"
}

# ============================================================================
# TEST: Database Shell
# ============================================================================

test_db_shell_syntax() {
    log_test "Testing 'kompose db shell' command recognition"
    
    # This test just verifies the command is recognized in kompose.sh
    # We don't actually try to connect since the container may not exist
    # and the command is interactive
    
    TESTS_RUN=$((TESTS_RUN+1))
    
    # Check if 'shell' is a valid db subcommand by checking source code
    if grep -q "shell)" "${KOMPOSE_ROOT}/kompose.sh" || \
       grep -q "shell)" "${KOMPOSE_ROOT}"/kompose-*.sh 2>/dev/null; then
        log_pass "DB shell command is defined"
    else
        log_fail "DB shell command not found in source"
    fi
}

# ============================================================================
# TEST: Database Exec Without Arguments
# ============================================================================

test_db_exec_no_args() {
    log_test "Testing 'kompose db exec' without arguments"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose db exec 2>&1)
    exit_code=$?
    set -e
    
    # Should fail and show usage
    assert_exit_code 1 $exit_code \
        "DB exec requires arguments"
    
    assert_contains "$output" "Required:\|database\|ERROR" \
        "Error message indicates required arguments"
}

# ============================================================================
# TEST: Database Migrate
# ============================================================================

test_db_migrate_syntax() {
    log_test "Testing 'kompose db migrate' command recognition"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose db migrate 2>&1)
    exit_code=$?
    set -e
    
    # Command should be recognized
    assert_not_contains "$output" "Unknown database command" \
        "DB migrate command is recognized"
}

# ============================================================================
# TEST: Database Reset Without Database Name
# ============================================================================

test_db_reset_no_database() {
    log_test "Testing 'kompose db reset' without database name"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose db reset 2>&1)
    exit_code=$?
    set -e
    
    # Should fail without database name
    assert_exit_code 1 $exit_code \
        "DB reset requires database name"
    
    assert_contains "$output" "Required:\|database\|ERROR" \
        "Error message indicates database name is required"
}

# ============================================================================
# TEST: Database Backup with Options
# ============================================================================

test_db_backup_with_database() {
    log_test "Testing 'kompose db backup -d DATABASE' syntax"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose db backup -d testdb 2>&1)
    exit_code=$?
    set -e
    
    # Command should parse options correctly
    # May fail due to missing database, but should recognize command
    assert_not_contains "$output" "Unknown database command\|Unknown option" \
        "DB backup accepts -d option"
}

# ============================================================================
# RUN ALL TESTS
# ============================================================================

test_db_no_subcommand
test_db_invalid_subcommand
test_db_backup_syntax
test_db_restore_no_file
test_db_list_syntax
test_db_status_syntax
test_db_shell_syntax
test_db_exec_no_args
test_db_migrate_syntax
test_db_reset_no_database
test_db_backup_with_database

# ============================================================================
# CLEANUP & REPORT
# ============================================================================

cleanup_test_env

if print_test_summary; then
    exit 0
else
    exit 1
fi
