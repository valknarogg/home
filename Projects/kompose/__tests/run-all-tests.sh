#!/bin/bash

# Kompose Test Suite Runner
# Runs all test suites and generates comprehensive report

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/test-helpers.sh"

# ============================================================================
# CONFIGURATION
# ============================================================================

# Parse command line arguments
UPDATE_SNAPSHOTS=0
RUN_INTEGRATION_TESTS=0
VERBOSE=0
SPECIFIC_TEST=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -u|--update-snapshots)
            UPDATE_SNAPSHOTS=1
            export UPDATE_SNAPSHOTS
            shift
            ;;
        -i|--integration)
            RUN_INTEGRATION_TESTS=1
            export RUN_INTEGRATION_TESTS
            shift
            ;;
        -v|--verbose)
            VERBOSE=1
            export VERBOSE
            shift
            ;;
        -t|--test)
            SPECIFIC_TEST="$2"
            shift 2
            ;;
        -h|--help)
            cat << EOF
Kompose Test Suite Runner

Usage: $0 [OPTIONS]

Options:
    -u, --update-snapshots   Update all test snapshots
    -i, --integration        Run integration tests (requires Docker)
    -v, --verbose           Enable verbose output
    -t, --test TEST         Run specific test file
    -h, --help             Show this help message

Test Files:
    basic-commands        Test basic commands (help, version, list)
    stack-commands        Test stack management commands
    database-commands     Test database commands
    tag-commands         Test git tag commands
    api-commands         Test API server commands
    env-validation       Test environment validation

Examples:
    $0                              Run all tests
    $0 -u                           Update all snapshots
    $0 -i                           Run integration tests
    $0 -t basic-commands            Run only basic commands tests
    $0 -u -t stack-commands         Update snapshots for stack tests

EOF
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

# ============================================================================
# BANNER
# ============================================================================

clear
cat << "EOF"
╔════════════════════════════════════════════════════════════════╗
║                                                                ║
║              KOMPOSE TEST SUITE                                ║
║              Version 1.0.0                                     ║
║                                                                ║
╚════════════════════════════════════════════════════════════════╝

EOF

# ============================================================================
# PRE-FLIGHT CHECKS
# ============================================================================

log_section "PRE-FLIGHT CHECKS"

# Check if kompose.sh exists
if [ ! -f "${KOMPOSE_ROOT}/kompose.sh" ]; then
    log_error "kompose.sh not found at ${KOMPOSE_ROOT}/kompose.sh"
    exit 1
fi
log_pass "kompose.sh found"

# Check if Docker is available
if is_docker_available; then
    log_pass "Docker is available"
    DOCKER_VERSION=$(docker --version)
    log_info "Docker version: $DOCKER_VERSION"
else
    log_warning "Docker not available - integration tests will be skipped"
fi

# Check for test files
TEST_FILES=(
    "test-basic-commands.sh"
    "test-stack-commands.sh"
    "test-database-commands.sh"
    "test-tag-commands.sh"
    "test-api-commands.sh"
)

for test_file in "${TEST_FILES[@]}"; do
    if [ -f "${SCRIPT_DIR}/${test_file}" ]; then
        log_pass "Found ${test_file}"
    else
        log_warning "Missing ${test_file}"
    fi
done

# ============================================================================
# TEST CONFIGURATION INFO
# ============================================================================

log_section "TEST CONFIGURATION"

if [ $UPDATE_SNAPSHOTS -eq 1 ]; then
    log_info "Snapshot mode: UPDATE (will create/update snapshots)"
else
    log_info "Snapshot mode: COMPARE (will compare against existing snapshots)"
fi

if [ $RUN_INTEGRATION_TESTS -eq 1 ]; then
    log_info "Integration tests: ENABLED"
else
    log_info "Integration tests: DISABLED (use -i to enable)"
fi

if [ -n "$SPECIFIC_TEST" ]; then
    log_info "Running specific test: $SPECIFIC_TEST"
else
    log_info "Running all tests"
fi

# ============================================================================
# RUN TESTS
# ============================================================================

TOTAL_TESTS_RUN=0
TOTAL_TESTS_PASSED=0
TOTAL_TESTS_FAILED=0
FAILED_SUITES=()

run_test_suite() {
    local test_file="$1"
    local test_name="$2"
    
    if [ ! -f "${SCRIPT_DIR}/${test_file}" ]; then
        log_skip "Test file not found: ${test_file}"
        return
    fi
    
    # Make executable
    chmod +x "${SCRIPT_DIR}/${test_file}"
    
    # Run test
    log_section "RUNNING: ${test_name}"
    
    set +e
    bash "${SCRIPT_DIR}/${test_file}"
    local exit_code=$?
    set -e
    
    # Capture test results from the test script's global variables
    # This is a simplification - in real implementation, we'd parse output
    
    if [ $exit_code -eq 0 ]; then
        log_success "✓ ${test_name} completed successfully"
    else
        log_error "✗ ${test_name} failed"
        FAILED_SUITES+=("$test_name")
    fi
    
    echo ""
}

# Run specific test or all tests
if [ -n "$SPECIFIC_TEST" ]; then
    case "$SPECIFIC_TEST" in
        basic-commands)
            run_test_suite "test-basic-commands.sh" "Basic Commands"
            ;;
        stack-commands)
            run_test_suite "test-stack-commands.sh" "Stack Management"
            ;;
        database-commands)
            run_test_suite "test-database-commands.sh" "Database Commands"
            ;;
        tag-commands)
            run_test_suite "test-tag-commands.sh" "Tag Commands"
            ;;
        api-commands)
            run_test_suite "test-api-commands.sh" "API Commands"
            ;;
        *)
            log_error "Unknown test: $SPECIFIC_TEST"
            exit 1
            ;;
    esac
else
    # Run all tests
    run_test_suite "test-basic-commands.sh" "Basic Commands"
    run_test_suite "test-stack-commands.sh" "Stack Management"
    run_test_suite "test-database-commands.sh" "Database Commands"
    run_test_suite "test-tag-commands.sh" "Tag Commands"
    run_test_suite "test-api-commands.sh" "API Commands"
fi

# ============================================================================
# FINAL REPORT
# ============================================================================

log_section "FINAL TEST REPORT"

echo ""
echo "Test Execution Summary:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ ${#FAILED_SUITES[@]} -eq 0 ]; then
    echo -e "${GREEN}✓ All test suites passed!${NC}"
    echo ""
    echo "  Test suites run: ${#TEST_FILES[@]}"
    echo ""
else
    echo -e "${RED}✗ Some test suites failed:${NC}"
    echo ""
    for suite in "${FAILED_SUITES[@]}"; do
        echo "  - $suite"
    done
    echo ""
    echo "  Failed suites: ${#FAILED_SUITES[@]}"
    echo ""
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check for snapshot updates
if [ $UPDATE_SNAPSHOTS -eq 1 ]; then
    log_info "Snapshots have been updated"
    log_info "Snapshot directory: ${SNAPSHOT_DIR}"
    echo ""
fi

# Suggestions
if [ $RUN_INTEGRATION_TESTS -eq 0 ]; then
    log_info "Tip: Run with -i flag to include integration tests"
fi

if [ ! $UPDATE_SNAPSHOTS -eq 1 ]; then
    log_info "Tip: Run with -u flag to update snapshots if tests fail"
fi

echo ""

# Exit with appropriate code
if [ ${#FAILED_SUITES[@]} -eq 0 ]; then
    exit 0
else
    exit 1
fi
