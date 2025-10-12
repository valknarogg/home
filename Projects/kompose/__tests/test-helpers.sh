#!/bin/bash

# Test Helpers for Kompose Test Suite
# Provides utilities for snapshot testing, assertions, and test reporting

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KOMPOSE_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
SNAPSHOT_DIR="${SCRIPT_DIR}/snapshots"
TEMP_DIR="${SCRIPT_DIR}/temp"

# Create temp directory
mkdir -p "${TEMP_DIR}"

# ============================================================================
# LOGGING FUNCTIONS
# ============================================================================

log_test() {
    echo -e "${CYAN}[TEST]${NC} $1"
}

log_pass() {
    echo -e "${GREEN}[PASS]${NC} $1"
    ((TESTS_PASSED++))
}

log_fail() {
    echo -e "${RED}[FAIL]${NC} $1"
    ((TESTS_FAILED++))
}

log_skip() {
    echo -e "${YELLOW}[SKIP]${NC} $1"
}

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_section() {
    echo ""
    echo -e "${CYAN}═══════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}  $1${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════${NC}"
    echo ""
}

# ============================================================================
# ASSERTION FUNCTIONS
# ============================================================================

assert_equals() {
    local expected="$1"
    local actual="$2"
    local test_name="$3"
    
    ((TESTS_RUN++))
    
    if [ "$expected" = "$actual" ]; then
        log_pass "$test_name"
        return 0
    else
        log_fail "$test_name"
        echo "  Expected: $expected"
        echo "  Actual:   $actual"
        return 1
    fi
}

assert_contains() {
    local haystack="$1"
    local needle="$2"
    local test_name="$3"
    
    ((TESTS_RUN++))
    
    if echo "$haystack" | grep -q "$needle"; then
        log_pass "$test_name"
        return 0
    else
        log_fail "$test_name"
        echo "  Expected to contain: $needle"
        echo "  Actual output: $haystack"
        return 1
    fi
}

assert_not_contains() {
    local haystack="$1"
    local needle="$2"
    local test_name="$3"
    
    ((TESTS_RUN++))
    
    if ! echo "$haystack" | grep -q "$needle"; then
        log_pass "$test_name"
        return 0
    else
        log_fail "$test_name"
        echo "  Expected NOT to contain: $needle"
        echo "  Actual output: $haystack"
        return 1
    fi
}

assert_exit_code() {
    local expected_code="$1"
    local actual_code="$2"
    local test_name="$3"
    
    ((TESTS_RUN++))
    
    if [ "$expected_code" -eq "$actual_code" ]; then
        log_pass "$test_name"
        return 0
    else
        log_fail "$test_name"
        echo "  Expected exit code: $expected_code"
        echo "  Actual exit code:   $actual_code"
        return 1
    fi
}

assert_file_exists() {
    local file="$1"
    local test_name="$2"
    
    ((TESTS_RUN++))
    
    if [ -f "$file" ]; then
        log_pass "$test_name"
        return 0
    else
        log_fail "$test_name"
        echo "  File not found: $file"
        return 1
    fi
}

assert_directory_exists() {
    local dir="$1"
    local test_name="$2"
    
    ((TESTS_RUN++))
    
    if [ -d "$dir" ]; then
        log_pass "$test_name"
        return 0
    else
        log_fail "$test_name"
        echo "  Directory not found: $dir"
        return 1
    fi
}

# ============================================================================
# SNAPSHOT TESTING
# ============================================================================

create_snapshot() {
    local snapshot_name="$1"
    local content="$2"
    local snapshot_file="${SNAPSHOT_DIR}/${snapshot_name}.snapshot"
    
    echo "$content" > "$snapshot_file"
    log_info "Created snapshot: $snapshot_name"
}

update_snapshot() {
    local snapshot_name="$1"
    local content="$2"
    
    create_snapshot "$snapshot_name" "$content"
    log_info "Updated snapshot: $snapshot_name"
}

compare_snapshot() {
    local snapshot_name="$1"
    local actual_content="$2"
    local test_name="$3"
    local snapshot_file="${SNAPSHOT_DIR}/${snapshot_name}.snapshot"
    
    ((TESTS_RUN++))
    
    if [ ! -f "$snapshot_file" ]; then
        log_fail "$test_name - Snapshot not found"
        echo "  Snapshot file: $snapshot_file"
        echo "  Run with UPDATE_SNAPSHOTS=1 to create snapshots"
        return 1
    fi
    
    local expected_content
    expected_content=$(cat "$snapshot_file")
    
    # Normalize whitespace and line endings
    local normalized_expected
    local normalized_actual
    normalized_expected=$(echo "$expected_content" | sed 's/[[:space:]]*$//' | tr -s '\n')
    normalized_actual=$(echo "$actual_content" | sed 's/[[:space:]]*$//' | tr -s '\n')
    
    if [ "$normalized_expected" = "$normalized_actual" ]; then
        log_pass "$test_name"
        return 0
    else
        log_fail "$test_name - Snapshot mismatch"
        echo "  Snapshot: $snapshot_file"
        echo "  Diff:"
        diff -u <(echo "$expected_content") <(echo "$actual_content") || true
        echo ""
        echo "  Run with UPDATE_SNAPSHOTS=1 to update snapshots"
        return 1
    fi
}

# ============================================================================
# COMMAND EXECUTION
# ============================================================================

run_kompose() {
    local cmd="$*"
    local output_file="${TEMP_DIR}/output_$$.txt"
    
    # Run command and capture output
    cd "${KOMPOSE_ROOT}" || exit 1
    bash kompose.sh $cmd > "$output_file" 2>&1
    local exit_code=$?
    
    # Return output and exit code
    cat "$output_file"
    return $exit_code
}

run_kompose_quiet() {
    local cmd="$*"
    
    cd "${KOMPOSE_ROOT}" || exit 1
    bash kompose.sh $cmd >/dev/null 2>&1
    return $?
}

capture_output() {
    local cmd="$*"
    local output
    
    output=$(eval "$cmd" 2>&1)
    echo "$output"
}

# ============================================================================
# TEST UTILITIES
# ============================================================================

setup_test_env() {
    log_info "Setting up test environment..."
    
    # Ensure snapshot directory exists
    mkdir -p "${SNAPSHOT_DIR}"
    
    # Clean temp directory
    rm -rf "${TEMP_DIR}"/*
    
    log_info "Test environment ready"
}

cleanup_test_env() {
    log_info "Cleaning up test environment..."
    
    # Remove temp files
    rm -rf "${TEMP_DIR}"/*
    
    log_info "Cleanup complete"
}

# ============================================================================
# REPORTING
# ============================================================================

print_test_summary() {
    echo ""
    echo -e "${CYAN}═══════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}  TEST SUMMARY${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════${NC}"
    echo ""
    echo "  Total Tests:  $TESTS_RUN"
    echo -e "  ${GREEN}Passed:       $TESTS_PASSED${NC}"
    echo -e "  ${RED}Failed:       $TESTS_FAILED${NC}"
    echo ""
    
    if [ $TESTS_FAILED -eq 0 ]; then
        echo -e "${GREEN}✓ All tests passed!${NC}"
        echo ""
        return 0
    else
        echo -e "${RED}✗ Some tests failed${NC}"
        echo ""
        return 1
    fi
}

# ============================================================================
# MOCK DOCKER COMMANDS (for testing without actual Docker)
# ============================================================================

mock_docker_ps() {
    cat << EOF
CONTAINER ID   IMAGE                    STATUS
abc123         postgres:16-alpine       Up 2 hours
def456         redis:7-alpine          Up 2 hours
ghi789         traefik:latest          Up 2 hours
EOF
}

mock_docker_compose_ps() {
    local stack="$1"
    
    case "$stack" in
        core)
            cat << EOF
NAME                IMAGE                    STATUS
core-postgres       postgres:16-alpine       Up 2 hours (healthy)
core-redis          redis:7-alpine          Up 2 hours (healthy)
core-mqtt           eclipse-mosquitto:2     Up 2 hours (healthy)
EOF
            ;;
        auth)
            cat << EOF
NAME                IMAGE                    STATUS
auth_keycloak       keycloak:latest         Up 1 hour (healthy)
auth_oauth2_proxy   oauth2-proxy:latest     Up 1 hour (healthy)
EOF
            ;;
        *)
            echo "No containers"
            ;;
    esac
}

# ============================================================================
# HELPERS FOR SPECIFIC TEST SCENARIOS
# ============================================================================

wait_for_container() {
    local container="$1"
    local timeout="${2:-30}"
    local elapsed=0
    
    while [ $elapsed -lt $timeout ]; do
        if docker ps --filter "name=$container" --filter "status=running" | grep -q "$container"; then
            return 0
        fi
        sleep 1
        ((elapsed++))
    done
    
    return 1
}

is_docker_available() {
    if command -v docker &> /dev/null && docker ps &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Export functions for use in test scripts
export -f log_test log_pass log_fail log_skip log_info log_section
export -f assert_equals assert_contains assert_not_contains assert_exit_code
export -f assert_file_exists assert_directory_exists
export -f create_snapshot update_snapshot compare_snapshot
export -f run_kompose run_kompose_quiet capture_output
export -f setup_test_env cleanup_test_env print_test_summary
export -f mock_docker_ps mock_docker_compose_ps
export -f wait_for_container is_docker_available
