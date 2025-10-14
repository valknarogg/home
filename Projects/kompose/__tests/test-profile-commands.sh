#!/bin/bash

# Test Suite: Profile Commands
# Tests profile management commands

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/test-helpers.sh"

# ============================================================================
# SETUP
# ============================================================================

log_section "TESTING: Profile Commands"
setup_test_env

# ============================================================================
# TEST: Profile Command Without Subcommand
# ============================================================================

test_profile_no_subcommand() {
    log_test "Testing 'kompose profile' without subcommand"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose profile 2>&1)
    exit_code=$?
    set -e
    
    # Should exit with error
    assert_exit_code 1 $exit_code \
        "Profile command requires subcommand"
    
    assert_contains "$output" "Profile subcommand required\|subcommand\|ERROR" \
        "Error message indicates subcommand is required"
    
    # Should show available commands
    assert_contains "$output" "list\|create\|use\|show\|edit\|delete" \
        "Error message shows available profile commands"
}

# ============================================================================
# TEST: Invalid Profile Subcommand
# ============================================================================

test_profile_invalid_subcommand() {
    log_test "Testing invalid profile subcommand"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose profile invalid_xyz 2>&1)
    exit_code=$?
    set -e
    
    # Should exit with error
    assert_exit_code 1 $exit_code \
        "Invalid profile subcommand should fail"
    
    assert_contains "$output" "Unknown profile command\|Unknown\|ERROR\|Invalid" \
        "Invalid profile subcommand produces error"
}

# ============================================================================
# TEST: Profile List Syntax
# ============================================================================

test_profile_list_syntax() {
    log_test "Testing 'kompose profile list' command"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose profile list 2>&1)
    exit_code=$?
    set -e
    
    # Command should be recognized
    assert_not_contains "$output" "Unknown profile command" \
        "Profile list command is recognized"
    
    # Should show profiles or "no profiles" message
    assert_contains "$output" "profile\|Profile\|No profiles\|Available" \
        "Profile list shows profile information"
}

# ============================================================================
# TEST: Profile Current Syntax
# ============================================================================

test_profile_current_syntax() {
    log_test "Testing 'kompose profile current' command"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose profile current 2>&1)
    exit_code=$?
    set -e
    
    # Command should be recognized
    assert_not_contains "$output" "Unknown profile command" \
        "Profile current command is recognized"
    
    # Should show current profile or "no profile" message
    assert_contains "$output" "profile\|Profile\|No active\|Current\|None" \
        "Profile current shows current profile status"
}

# ============================================================================
# TEST: Profile Create Without Name
# ============================================================================

test_profile_create_no_name() {
    log_test "Testing 'kompose profile create' without name"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose profile create 2>&1)
    exit_code=$?
    set -e
    
    # May use interactive mode or require name
    # Check if command is recognized
    assert_not_contains "$output" "Unknown profile command" \
        "Profile create command is recognized"
}

# ============================================================================
# TEST: Profile Use Without Name
# ============================================================================

test_profile_use_no_name() {
    log_test "Testing 'kompose profile use' without profile name"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose profile use 2>&1)
    exit_code=$?
    set -e
    
    # Should require profile name
    assert_not_contains "$output" "Unknown profile command" \
        "Profile use command is recognized"
    
    if [ $exit_code -ne 0 ]; then
        assert_contains "$output" "Required\|profile name\|argument\|ERROR" \
            "Profile use indicates missing profile name"
    fi
}

# ============================================================================
# TEST: Profile Show Without Name
# ============================================================================

test_profile_show_no_name() {
    log_test "Testing 'kompose profile show' without profile name"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose profile show 2>&1)
    exit_code=$?
    set -e
    
    # Should require profile name
    assert_not_contains "$output" "Unknown profile command" \
        "Profile show command is recognized"
    
    if [ $exit_code -ne 0 ]; then
        assert_contains "$output" "Required\|profile name\|argument\|ERROR" \
            "Profile show indicates missing profile name"
    fi
}

# ============================================================================
# TEST: Profile Edit Without Name
# ============================================================================

test_profile_edit_no_name() {
    log_test "Testing 'kompose profile edit' without profile name"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose profile edit 2>&1)
    exit_code=$?
    set -e
    
    # Should require profile name
    assert_not_contains "$output" "Unknown profile command" \
        "Profile edit command is recognized"
    
    if [ $exit_code -ne 0 ]; then
        assert_contains "$output" "Required\|profile name\|argument\|ERROR" \
            "Profile edit indicates missing profile name"
    fi
}

# ============================================================================
# TEST: Profile Delete Without Name
# ============================================================================

test_profile_delete_no_name() {
    log_test "Testing 'kompose profile delete' without profile name"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose profile delete 2>&1)
    exit_code=$?
    set -e
    
    # Should require profile name
    assert_not_contains "$output" "Unknown profile command" \
        "Profile delete command is recognized"
    
    if [ $exit_code -ne 0 ]; then
        assert_contains "$output" "Required\|profile name\|argument\|ERROR" \
            "Profile delete indicates missing profile name"
    fi
}

# ============================================================================
# TEST: Profile Copy Without Arguments
# ============================================================================

test_profile_copy_no_args() {
    log_test "Testing 'kompose profile copy' without arguments"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose profile copy 2>&1)
    exit_code=$?
    set -e
    
    # Should require source and destination names
    assert_not_contains "$output" "Unknown profile command" \
        "Profile copy command is recognized"
    
    if [ $exit_code -ne 0 ]; then
        assert_contains "$output" "Required\|source\|destination\|argument\|ERROR" \
            "Profile copy indicates missing arguments"
    fi
}

# ============================================================================
# TEST: Profile Export Without Name
# ============================================================================

test_profile_export_no_name() {
    log_test "Testing 'kompose profile export' without profile name"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose profile export 2>&1)
    exit_code=$?
    set -e
    
    # Should require profile name
    assert_not_contains "$output" "Unknown profile command" \
        "Profile export command is recognized"
}

# ============================================================================
# TEST: Profile Import Without File
# ============================================================================

test_profile_import_no_file() {
    log_test "Testing 'kompose profile import' without file"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose profile import 2>&1)
    exit_code=$?
    set -e
    
    # Should require file path
    assert_not_contains "$output" "Unknown profile command" \
        "Profile import command is recognized"
    
    if [ $exit_code -ne 0 ]; then
        assert_contains "$output" "Required\|file\|path\|argument\|ERROR" \
            "Profile import indicates missing file"
    fi
}

# ============================================================================
# TEST: Profile Up Syntax
# ============================================================================

test_profile_up_syntax() {
    log_test "Testing 'kompose profile up' command"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose profile up 2>&1)
    exit_code=$?
    set -e
    
    # Command should be recognized
    assert_not_contains "$output" "Unknown profile command" \
        "Profile up command is recognized"
    
    # May fail if no active profile, but should be recognized
    assert_contains "$output" "profile\|Profile\|stack\|No active\|Starting" \
        "Profile up shows action or status"
}

# ============================================================================
# TEST: Profile Use with Non-existent Profile
# ============================================================================

test_profile_use_nonexistent() {
    log_test "Testing 'kompose profile use' with non-existent profile"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose profile use nonexistent_profile_xyz 2>&1)
    exit_code=$?
    set -e
    
    # Should show error for non-existent profile
    assert_contains "$output" "not found\|does not exist\|ERROR\|Unknown profile" \
        "Error shown for non-existent profile"
}

# ============================================================================
# RUN ALL TESTS
# ============================================================================

test_profile_no_subcommand
test_profile_invalid_subcommand
test_profile_list_syntax
test_profile_current_syntax
test_profile_create_no_name
test_profile_use_no_name
test_profile_show_no_name
test_profile_edit_no_name
test_profile_delete_no_name
test_profile_copy_no_args
test_profile_export_no_name
test_profile_import_no_file
test_profile_up_syntax
test_profile_use_nonexistent

# ============================================================================
# CLEANUP & REPORT
# ============================================================================

cleanup_test_env

if print_test_summary; then
    exit 0
else
    exit 1
fi
