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

# Ensure directories exist
mkdir -p "${SNAPSHOT_DIR}"
mkdir -p "${TEMP_DIR}"

# ============================================================================
# LOGGING FUNCTIONS
# ============================================================================

log_test() {
    echo -e "${CYAN}[TEST]${NC} $1"
}

log_pass() {
    echo -e "${GREEN}[PASS]${NC} $1"
    TESTS_PASSED=$((TESTS_PASSED+1))
}

log_fail() {
    echo -e "${RED}[FAIL]${NC} $1"
    TESTS_FAILED=$((TESTS_FAILED+1))
}

log_skip() {
    echo -e "${YELLOW}[SKIP]${NC} $1"
}

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[✓]${NC} $1"
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
    
    TESTS_RUN=$((TESTS_RUN+1))
    
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
    
    TESTS_RUN=$((TESTS_RUN+1))
    
    if echo "$haystack" | grep -qi "$needle"; then
        log_pass "$test_name"
        return 0
    else
        log_fail "$test_name"
        echo "  Expected to contain: $needle"
        if [ "${VERBOSE:-0}" = "1" ]; then
            echo "  Actual output:"
            echo "$haystack" | head -20
        fi
        return 1
    fi
}

assert_not_contains() {
    local haystack="$1"
    local needle="$2"
    local test_name="$3"
    
    TESTS_RUN=$((TESTS_RUN+1))
    
    if ! echo "$haystack" | grep -qi "$needle"; then
        log_pass "$test_name"
        return 0
    else
        log_fail "$test_name"
        echo "  Expected NOT to contain: $needle"
        if [ "${VERBOSE:-0}" = "1" ]; then
            echo "  Actual output:"
            echo "$haystack" | head -20
        fi
        return 1
    fi
}

assert_exit_code() {
    local expected_code="$1"
    local actual_code="$2"
    local test_name="$3"
    
    TESTS_RUN=$((TESTS_RUN+1))
    
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
    
    TESTS_RUN=$((TESTS_RUN+1))
    
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
    
    TESTS_RUN=$((TESTS_RUN+1))
    
    if [ -d "$dir" ]; then
        log_pass "$test_name"
        return 0
    else
        log_fail "$test_name"
        echo "  Directory not found: $dir"
        return 1
    fi
}

assert_true() {
    local command="$1"
    local test_name="$2"
    
    TESTS_RUN=$((TESTS_RUN+1))
    
    set +e
    eval "$command"
    local result=$?
    set -e
    
    if [ $result -eq 0 ]; then
        log_pass "$test_name"
        return 0
    else
        log_fail "$test_name"
        echo "  Command failed: $command"
        echo "  Exit code: $result"
        return 1
    fi
}

assert_false() {
    local command="$1"
    local test_name="$2"
    
    TESTS_RUN=$((TESTS_RUN+1))
    
    set +e
    eval "$command"
    local result=$?
    set -e
    
    if [ $result -ne 0 ]; then
        log_pass "$test_name"
        return 0
    else
        log_fail "$test_name"
        echo "  Command should have failed: $command"
        return 1
    fi
}

# ============================================================================
# SNAPSHOT TESTING
# ============================================================================

normalize_output() {
    local content="$1"
    # Remove trailing whitespace, normalize line endings, remove ANSI color codes
    echo "$content" | sed 's/[[:space:]]*$//' | tr -s '\n' | sed 's/\x1b\[[0-9;]*m//g'
}

create_snapshot() {
    local snapshot_name="$1"
    local content="$2"
    local snapshot_file="${SNAPSHOT_DIR}/${snapshot_name}.snapshot"
    
    # Normalize and save
    normalize_output "$content" > "$snapshot_file"
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
    
    TESTS_RUN=$((TESTS_RUN+1))
    
    if [ ! -f "$snapshot_file" ]; then
        log_warning "$test_name - Snapshot not found, creating..."
        create_snapshot "$snapshot_name" "$actual_content"
        log_pass "$test_name (snapshot created)"
        return 0
    fi
    
    local expected_content
    expected_content=$(cat "$snapshot_file")
    
    # Normalize both for comparison
    local normalized_expected
    local normalized_actual
    normalized_expected=$(normalize_output "$expected_content")
    normalized_actual=$(normalize_output "$actual_content")
    
    if [ "$normalized_expected" = "$normalized_actual" ]; then
        log_pass "$test_name"
        return 0
    else
        log_fail "$test_name - Snapshot mismatch"
        echo "  Snapshot: $snapshot_file"
        if [ "${VERBOSE:-0}" = "1" ]; then
            echo "  Diff:"
            diff -u <(echo "$normalized_expected") <(echo "$normalized_actual") | head -50 || true
        else
            echo "  Use -v flag to see diff"
        fi
        echo "  Run with UPDATE_SNAPSHOTS=1 to update snapshots"
        return 1
    fi
}

# ============================================================================
# COMMAND EXECUTION
# ============================================================================

run_kompose() {
    local output
    local exit_code
    
    # Run command and capture output
    cd "${KOMPOSE_ROOT}" || exit 1
    
    set +e
    output=$(bash kompose.sh "$@" 2>&1)
    exit_code=$?
    set -e
    
    # Return output
    echo "$output"
    return $exit_code
}

run_kompose_quiet() {
    cd "${KOMPOSE_ROOT}" || exit 1
    bash kompose.sh "$@" >/dev/null 2>&1
    return $?
}

capture_output() {
    local cmd="$*"
    local output
    
    set +e
    output=$(eval "$cmd" 2>&1)
    set -e
    
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
    mkdir -p "${TEMP_DIR}"
    
    # Create minimal .env file if it doesn't exist (needed by some commands)
    if [ ! -f "${KOMPOSE_ROOT}/.env" ]; then
        log_info "Creating minimal .env for testing..."
        cat > "${KOMPOSE_ROOT}/.env" << 'EOF'
# Minimal test environment configuration
TIMEZONE=Europe/Amsterdam
NETWORK_NAME=kompose
NODE_ENV=test
ENVIRONMENT=test
EOF
    fi
    
    log_info "Test environment ready"
}

cleanup_test_env() {
    log_info "Cleaning up test environment..."
    
    # Remove temp files
    rm -rf "${TEMP_DIR}"/*
    
    # Don't remove .env as it might be needed for other tests
    # Tests should handle their own state
    
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
    
    if [ $TESTS_RUN -gt 0 ]; then
        local pass_rate=$((TESTS_PASSED * 100 / TESTS_RUN))
        echo "  Pass Rate:    ${pass_rate}%"
    fi
    
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
# DOCKER HELPERS
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
        elapsed=$((elapsed+1))
    done
    
    return 1
}

is_docker_available() {
    if command -v docker &> /dev/null && docker ps &> /dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

container_is_healthy() {
    local container="$1"
    local health_status
    
    health_status=$(docker inspect --format='{{.State.Health.Status}}' "$container" 2>/dev/null || echo "none")
    
    if [ "$health_status" = "healthy" ]; then
        return 0
    elif [ "$health_status" = "none" ]; then
        # No health check defined, check if running
        if docker ps --filter "name=$container" --filter "status=running" | grep -q "$container"; then
            return 0
        fi
    fi
    
    return 1
}

# Export functions for use in test scripts
export -f log_test log_pass log_fail log_skip log_info log_warning log_error log_success log_section
export -f assert_equals assert_contains assert_not_contains assert_exit_code
export -f assert_file_exists assert_directory_exists
export -f assert_true assert_false
export -f normalize_output create_snapshot update_snapshot compare_snapshot
export -f run_kompose run_kompose_quiet capture_output
export -f setup_test_env cleanup_test_env print_test_summary
export -f wait_for_container is_docker_available container_is_healthy
