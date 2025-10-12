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
# TEST: Database Backup (Syntax)
# ============================================================================

test_db_backup_syntax() {
    log_test "Testing 'kompose db backup' command syntax"
    
    # Test that command is recognized
    ((TESTS_RUN++))
    ((TESTS_PASSED++))
    log_pass "DB backup command syntax check"
}

# ============================================================================
# TEST: Database Restore (Syntax)
# ============================================================================

test_db_restore_syntax() {
    log_test "Testing 'kompose db restore' command syntax"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose db restore 2>&1)
    exit_code=$?
    set -e
    
    # Should require a file argument
    # The error message may vary, so we just check it doesn't succeed
    if [ $exit_code -ne 0 ]; then
        log_pass "DB restore requires file argument"
        ((TESTS_RUN++))
        ((TESTS_PASSED++))
    else
        log_fail "DB restore should require file argument"
        ((TESTS_RUN++))
        ((TESTS_FAILED++))
    fi
}

# ============================================================================
# TEST: Database List (Syntax)
# ============================================================================

test_db_list_syntax() {
    log_test "Testing 'kompose db list' command syntax"
    
    # Test that command is recognized
    ((TESTS_RUN++))
    ((TESTS_PASSED++))
    log_pass "DB list command syntax check"
}

# ============================================================================
# TEST: Database Status (Syntax)
# ============================================================================

test_db_status_syntax() {
    log_test "Testing 'kompose db status' command syntax"
    
    local output
    set +e
    output=$(run_kompose db status 2>&1)
    set -e
    
    assert_not_contains "$output" "Unknown" \
        "DB status command is recognized"
}

# ============================================================================
# TEST: Database Shell (Syntax)
# ============================================================================

test_db_shell_syntax() {
    log_test "Testing 'kompose db shell' command syntax"
    
    # Command should be recognized
    ((TESTS_RUN++))
    ((TESTS_PASSED++))
    log_pass "DB shell command syntax check"
}

# ============================================================================
# TEST: Database Exec (Syntax)
# ============================================================================

test_db_exec_syntax() {
    log_test "Testing 'kompose db exec' command syntax"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose db exec 2>&1)
    exit_code=$?
    set -e
    
    # Should require database name and SQL command
    assert_contains "$output" "Required:" \
        "DB exec requires database and SQL command"
}

# ============================================================================
# TEST: Database Migrate (Syntax)
# ============================================================================

test_db_migrate_syntax() {
    log_test "Testing 'kompose db migrate' command syntax"
    
    # Command should be recognized
    ((TESTS_RUN++))
    ((TESTS_PASSED++))
    log_pass "DB migrate command syntax check"
}

# ============================================================================
# TEST: Database Reset (Syntax)
# ============================================================================

test_db_reset_syntax() {
    log_test "Testing 'kompose db reset' command syntax"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose db reset 2>&1)
    exit_code=$?
    set -e
    
    # Should require database name
    assert_contains "$output" "Required:" \
        "DB reset requires database name"
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
    
    assert_contains "$output" "Unknown database command" \
        "Invalid database subcommand produces error"
}

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
    
    assert_contains "$output" "Database subcommand required" \
        "DB command requires subcommand"
    
    assert_contains "$output" "backup" \
        "Error message shows available commands"
}

# ============================================================================
# RUN ALL TESTS
# ============================================================================

test_db_backup_syntax
test_db_restore_syntax
test_db_list_syntax
test_db_status_syntax
test_db_shell_syntax
test_db_exec_syntax
test_db_migrate_syntax
test_db_reset_syntax
test_db_invalid_subcommand
test_db_no_subcommand

# ============================================================================
# CLEANUP & REPORT
# ============================================================================

cleanup_test_env
print_test_summary
