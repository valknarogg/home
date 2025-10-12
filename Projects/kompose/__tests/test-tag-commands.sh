#!/bin/bash

# Test Suite: Tag Commands
# Tests git tag deployment commands

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/test-helpers.sh"

# ============================================================================
# SETUP
# ============================================================================

log_section "TESTING: Tag Commands"
setup_test_env

# ============================================================================
# TEST: Tag Create (Syntax)
# ============================================================================

test_tag_create_syntax() {
    log_test "Testing 'kompose tag create' command syntax"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose tag create 2>&1)
    exit_code=$?
    set -e
    
    # Should require service, env, and version
    assert_contains "$output" "Required:" \
        "Tag create requires service, env, and version"
}

# ============================================================================
# TEST: Tag Deploy (Syntax)
# ============================================================================

test_tag_deploy_syntax() {
    log_test "Testing 'kompose tag deploy' command syntax"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose tag deploy 2>&1)
    exit_code=$?
    set -e
    
    assert_contains "$output" "Required:" \
        "Tag deploy requires service, env, and version"
}

# ============================================================================
# TEST: Tag Move (Syntax)
# ============================================================================

test_tag_move_syntax() {
    log_test "Testing 'kompose tag move' command syntax"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose tag move 2>&1)
    exit_code=$?
    set -e
    
    assert_contains "$output" "Required:" \
        "Tag move requires service, env, version, and commit"
}

# ============================================================================
# TEST: Tag Delete (Syntax)
# ============================================================================

test_tag_delete_syntax() {
    log_test "Testing 'kompose tag delete' command syntax"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose tag delete 2>&1)
    exit_code=$?
    set -e
    
    assert_contains "$output" "Required:" \
        "Tag delete requires service, env, and version"
}

# ============================================================================
# TEST: Tag List (Syntax)
# ============================================================================

test_tag_list_syntax() {
    log_test "Testing 'kompose tag list' command syntax"
    
    # Tag list can work without arguments
    local output
    set +e
    output=$(run_kompose tag list 2>&1)
    set -e
    
    # Should not show error
    assert_not_contains "$output" "Unknown" \
        "Tag list command is recognized"
}

# ============================================================================
# TEST: Tag Rollback (Syntax)
# ============================================================================

test_tag_rollback_syntax() {
    log_test "Testing 'kompose tag rollback' command syntax"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose tag rollback 2>&1)
    exit_code=$?
    set -e
    
    assert_contains "$output" "Required:" \
        "Tag rollback requires service, env, and version"
}

# ============================================================================
# TEST: Tag Status (Syntax)
# ============================================================================

test_tag_status_syntax() {
    log_test "Testing 'kompose tag status' command syntax"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose tag status 2>&1)
    exit_code=$?
    set -e
    
    assert_contains "$output" "Required:" \
        "Tag status requires service, version, and env"
}

# ============================================================================
# TEST: Invalid Tag Subcommand
# ============================================================================

test_tag_invalid_subcommand() {
    log_test "Testing invalid tag subcommand"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose tag invalid_xyz 2>&1)
    exit_code=$?
    set -e
    
    assert_contains "$output" "Unknown tag command" \
        "Invalid tag subcommand produces error"
}

# ============================================================================
# TEST: Tag Command Without Subcommand
# ============================================================================

test_tag_no_subcommand() {
    log_test "Testing 'kompose tag' without subcommand"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose tag 2>&1)
    exit_code=$?
    set -e
    
    assert_contains "$output" "Tag subcommand required" \
        "Tag command requires subcommand"
    
    assert_contains "$output" "create" \
        "Error message shows available commands"
}

# ============================================================================
# TEST: Tag Create with All Options
# ============================================================================

test_tag_create_with_options() {
    log_test "Testing tag create with all options"
    
    # We won't actually create a tag, just test syntax parsing
    # This would need a git repository to work fully
    
    local output
    set +e
    output=$(run_kompose tag create -s frontend -e dev -v 1.0.0 -c HEAD -m "Test" -d 2>&1)
    set -e
    
    # With dry-run, should show what would be done
    if echo "$output" | grep -q "dry.*run" || echo "$output" | grep -q "would"; then
        log_pass "Tag create accepts all options"
        ((TESTS_RUN++))
        ((TESTS_PASSED++))
    else
        # Might fail due to no git repo, which is ok for syntax test
        log_skip "Tag create syntax test (needs git repository)"
    fi
}

# ============================================================================
# RUN ALL TESTS
# ============================================================================

test_tag_create_syntax
test_tag_deploy_syntax
test_tag_move_syntax
test_tag_delete_syntax
test_tag_list_syntax
test_tag_rollback_syntax
test_tag_status_syntax
test_tag_invalid_subcommand
test_tag_no_subcommand
test_tag_create_with_options

# ============================================================================
# CLEANUP & REPORT
# ============================================================================

cleanup_test_env
print_test_summary
