#!/bin/bash

# test-api.sh - Test script for Kompose REST API
# Usage: ./test-api.sh [API_URL]

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

API_URL="${1:-http://localhost:8080/api}"

echo "==========================================="
echo "Kompose REST API Test Suite"
echo "==========================================="
echo "API URL: $API_URL"
echo ""

# Test counter
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Test function
test_endpoint() {
    local name="$1"
    local method="$2"
    local endpoint="$3"
    local expected_status="$4"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    echo -n "Test $TESTS_RUN: $name ... "
    
    if [ "$method" = "GET" ]; then
        response=$(curl -s -w "\n%{http_code}" "$API_URL$endpoint")
    else
        response=$(curl -s -w "\n%{http_code}" -X "$method" "$API_URL$endpoint")
    fi
    
    http_code=$(echo "$response" | tail -n 1)
    body=$(echo "$response" | sed '$ d')
    
    # Check if response contains expected status
    if echo "$body" | grep -q "\"status\":\"$expected_status\""; then
        echo -e "${GREEN}✓ PASS${NC}"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        echo -e "${RED}✗ FAIL${NC}"
        echo "  Expected status: $expected_status"
        echo "  Response: $body"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

echo "Running API Tests..."
echo ""

# Test 1: Health Check
test_endpoint "Health Check" "GET" "/health" "success"

# Test 2: List Stacks
test_endpoint "List Stacks" "GET" "/stacks" "success"

# Test 3: Database Status
test_endpoint "Database Status" "GET" "/db/status" "success"

# Test 4: Database List
test_endpoint "Database Backups List" "GET" "/db/list" "success"

# Test 5: Tag List
test_endpoint "Tag List" "GET" "/tag/list" "success"

# Test 6: Invalid Endpoint (should fail)
echo -n "Test $((TESTS_RUN + 1)): Invalid Endpoint ... "
TESTS_RUN=$((TESTS_RUN + 1))
response=$(curl -s "$API_URL/invalid" || echo '{"status":"error"}')
if echo "$response" | grep -q "\"status\":\"error\""; then
    echo -e "${GREEN}✓ PASS${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}✗ FAIL${NC}"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

# Summary
echo ""
echo "==========================================="
echo "Test Summary"
echo "==========================================="
echo "Total Tests:  $TESTS_RUN"
echo -e "Passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Failed: ${RED}$TESTS_FAILED${NC}"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}All tests passed! ✓${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed! ✗${NC}"
    exit 1
fi
