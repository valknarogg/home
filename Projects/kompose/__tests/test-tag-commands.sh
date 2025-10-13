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
    
    # Should exit with error
    assert_exit_code 1 $exit_code \
        "Tag command requires subcommand"
    
    assert_contains "$output" "Tag subcommand required\|subcommand\|ERROR" \
        "Error message indicates subcommand is required"
    
    # Should show available commands
    assert_contains "$output" "create\|deploy" \
        "Error message shows available tag commands"
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
    
    # Should exit with error
    assert_exit_code 1 $exit_code \
        "Invalid tag subcommand should fail"
    
    assert_contains "$output" "Unknown tag command\|Unknown\|ERROR" \
        "Invalid tag subcommand produces error"
}

# ============================================================================
# TEST: Tag Create Without Arguments
# ============================================================================

test_tag_create_no_args() {
    log_test "Testing 'kompose tag create' without arguments"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose tag create 2>&1)
    exit_code=$?
    set -e
    
    # Should fail without arguments
    assert_exit_code 1 $exit_code \
        "Tag create requires arguments"
    
    assert_contains "$output" "Required:\|SERVICE\|ENV\|VERSION\|ERROR" \
        "Error message indicates required arguments"
}

# ============================================================================
# TEST: Tag Deploy Without Arguments
# ============================================================================

test_tag_deploy_no_args() {
    log_test "Testing 'kompose tag deploy' without arguments"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose tag deploy 2>&1)
    exit_code=$?
    set -e
    
    # Should fail without arguments
    assert_exit_code 1 $exit_code \
        "Tag deploy requires arguments"
    
    assert_contains "$output" "Required:\|SERVICE\|ENV\|VERSION\|ERROR" \
        "Error message indicates required arguments"
}

# ============================================================================
# TEST: Tag Move Without Arguments
# ============================================================================

test_tag_move_no_args() {
    log_test "Testing 'kompose tag move' without arguments"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose tag move 2>&1)
    exit_code=$?
    set -e
    
    # Should fail without arguments
    assert_exit_code 1 $exit_code \
        "Tag move requires arguments"
    
    assert_contains "$output" "Required:\|SERVICE\|ENV\|VERSION\|COMMIT\|ERROR" \
        "Error message indicates required arguments"
}

# ============================================================================
# TEST: Tag Delete Without Arguments
# ============================================================================

test_tag_delete_no_args() {
    log_test "Testing 'kompose tag delete' without arguments"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose tag delete 2>&1)
    exit_code=$?
    set -e
    
    # Should fail without arguments
    assert_exit_code 1 $exit_code \
        "Tag delete requires arguments"
    
    assert_contains "$output" "Required:\|SERVICE\|ENV\|VERSION\|ERROR" \
        "Error message indicates required arguments"
}

# ============================================================================
# TEST: Tag List
# ============================================================================

test_tag_list_syntax() {
    log_test "Testing 'kompose tag list' command"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose tag list 2>&1)
    exit_code=$?
    set -e
    
    # Should not show error (may show empty list or git error if no repo)
    assert_not_contains "$output" "Unknown tag command" \
        "Tag list command is recognized"
}

# ============================================================================
# TEST: Tag Rollback Without Arguments
# ============================================================================

test_tag_rollback_no_args() {
    log_test "Testing 'kompose tag rollback' without arguments"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose tag rollback 2>&1)
    exit_code=$?
    set -e
    
    # Should fail without arguments
    assert_exit_code 1 $exit_code \
        "Tag rollback requires arguments"
    
    assert_contains "$output" "Required:\|SERVICE\|ENV\|VERSION\|ERROR" \
        "Error message indicates required arguments"
}

# ============================================================================
# TEST: Tag Status Without Arguments
# ============================================================================

test_tag_status_no_args() {
    log_test "Testing 'kompose tag status' without arguments"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose tag status 2>&1)
    exit_code=$?
    set -e
    
    # Should fail without arguments
    assert_exit_code 1 $exit_code \
        "Tag status requires arguments"
    
    assert_contains "$output" "Required:\|SERVICE\|VERSION\|ENV\|ERROR" \
        "Error message indicates required arguments"
}

# ============================================================================
# TEST: Tag Create With Options (Dry Run)
# ============================================================================

test_tag_create_dry_run() {
    log_test "Testing tag create with dry-run option"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose tag create -s frontend -e dev -v 1.0.0 -d 2>&1)
    exit_code=$?
    set -e
    
    # With dry-run, options should be parsed correctly
    # May fail if not in git repo or if validation fails, but should recognize options
    assert_not_contains "$output" "Unknown option" \
        "Tag create accepts dry-run option"
}

# ============================================================================
# TEST: Tag Option Parsing
# ============================================================================

test_tag_options_parsing() {
    log_test "Testing tag command option parsing"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose tag create -s frontend -e dev -v 1.0.0 -c HEAD -m "Test message" -d 2>&1)
    exit_code=$?
    set -e
    
    # Should parse all options without "unknown option" errors
    # Dry run should show what would be done
    assert_not_contains "$output" "Unknown option" \
        "Tag create accepts all documented options"
    
    # Should indicate dry run mode
    if [ $exit_code -eq 0 ]; then
        assert_contains "$output" "DRY RUN\|Would create\|dry" \
            "Dry run mode is working"
    else
        # May fail if not in git repo, but options should still be parsed
        log_info "Tag create failed (likely not in git repo), but option parsing worked"
    fi
}

# ============================================================================
# RUN ALL TESTS
# ============================================================================

test_tag_no_subcommand
test_tag_invalid_subcommand
test_tag_create_no_args
test_tag_deploy_no_args
test_tag_move_no_args
test_tag_delete_no_args
test_tag_list_syntax
test_tag_rollback_no_args
test_tag_status_no_args
test_tag_create_dry_run
test_tag_options_parsing

# ============================================================================
# CLEANUP & REPORT
# ============================================================================

cleanup_test_env

if print_test_summary; then
    exit 0
else
    exit 1
fi
