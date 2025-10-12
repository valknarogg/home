#!/bin/bash

# Test script for Kompose API Server
# Tests all major endpoints and verifies functionality

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
API_HOST="${API_HOST:-127.0.0.1}"
API_PORT="${API_PORT:-8080}"
API_URL="http://${API_HOST}:${API_PORT}/api"

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Helper functions
log_test() {
    echo -e "${BLUE}[TEST]${NC} $1"
}

log_pass() {
    echo -e "${GREEN}[PASS]${NC} $1"
    TESTS_PASSED=$((TESTS_PASSED + 1))
}

log_fail() {
    echo -e "${RED}[FAIL]${NC} $1"
    TESTS_FAILED=$((TESTS_FAILED + 1))
}

# Test function
run_test() {
    local test_name="$1"
    local endpoint="$2"
    local method="${3:-GET}"
    local expected_status="${4:-success}"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    log_test "$test_name"
    
    if [ "$method" = "GET" ]; then
        response=$(curl -s -w "\n%{http_code}" "$API_URL$endpoint" 2>/dev/null || echo "000")
    else
        response=$(curl -s -w "\n%{http_code}" -X "$method" "$API_URL$endpoint" 2>/dev/null || echo "000")
    fi
    
    # Split response and status code
    http_code=$(echo "$response" | tail -n 1)
    json_body=$(echo "$response" | sed '$d')
    
    # Check HTTP status
    if [ "$http_code" = "000" ]; then
        log_fail "$test_name - Connection failed"
        echo "  Error: Could not connect to API server"
        return 1
    fi
    
    if [ "$http_code" != "200" ] && [ "$http_code" != "204" ]; then
        log_fail "$test_name - HTTP $http_code"
        echo "  Response: $json_body"
        return 1
    fi
    
    # Check JSON status field (skip for 204 No Content)
    if [ "$http_code" != "204" ]; then
        status=$(echo "$json_body" | jq -r '.status' 2>/dev/null || echo "unknown")
        
        if [ "$status" = "$expected_status" ]; then
            log_pass "$test_name"
            return 0
        else
            log_fail "$test_name - Expected status '$expected_status', got '$status'"
            echo "  Response: $json_body"
            return 1
        fi
    else
        log_pass "$test_name (No Content)"
        return 0
    fi
}

# Main test suite
main() {
    echo ""
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║              Kompose API Server Test Suite                    ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo ""
    echo "Testing API at: $API_URL"
    echo ""
    
    # Check if API server is running
    log_test "Checking if API server is running..."
    if ! curl -s -f "$API_URL/health" >/dev/null 2>&1; then
        echo -e "${RED}ERROR:${NC} API server is not running at $API_URL"
        echo ""
        echo "Start the server with:"
        echo "  ./kompose.sh api start"
        echo ""
        exit 1
    fi
    log_pass "API server is running"
    echo ""
    
    # Run tests
    echo "Running endpoint tests..."
    echo ""
    
    # Core endpoints
    run_test "Health check" "/health"
    run_test "Root/API info" "/"
    run_test "CORS preflight" "/health" "OPTIONS"
    
    # Stack endpoints
    run_test "List all stacks" "/stacks"
    run_test "Get core stack status" "/stacks/core"
    run_test "Get nonexistent stack" "/stacks/invalid-stack-xyz" "GET" "error"
    
    # Database endpoints
    run_test "Database status" "/db/status"
    run_test "List database backups" "/db/list"
    
    # Tag endpoints
    run_test "List deployment tags" "/tag/list"
    
    # Test invalid endpoints
    run_test "Invalid endpoint (404)" "/invalid/endpoint" "GET" "error"
    
    # Summary
    echo ""
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║                         Test Summary                           ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo ""
    echo "Total tests run:    $TESTS_RUN"
    echo -e "Tests passed:       ${GREEN}$TESTS_PASSED${NC}"
    
    if [ $TESTS_FAILED -gt 0 ]; then
        echo -e "Tests failed:       ${RED}$TESTS_FAILED${NC}"
        echo ""
        echo -e "${RED}Some tests failed!${NC}"
        exit 1
    else
        echo -e "Tests failed:       ${GREEN}0${NC}"
        echo ""
        echo -e "${GREEN}All tests passed! ✓${NC}"
        exit 0
    fi
}

# Check dependencies
if ! command -v curl &> /dev/null; then
    echo "ERROR: curl is required for testing"
    echo "Install with: apt-get install curl"
    exit 1
fi

if ! command -v jq &> /dev/null; then
    echo "WARNING: jq not found, some tests may not work correctly"
    echo "Install with: apt-get install jq"
fi

# Run main test suite
main
