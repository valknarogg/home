#!/bin/bash

# KMPS SSO Setup Verification Script
# This script verifies that the SSO configuration is correct for KMPS

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     KMPS SSO Configuration Verification Script         ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

# Load environment variables
if [ -f ../.env ]; then
    source ../.env
fi

if [ -f ../secrets.env ]; then
    source ../secrets.env
fi

# Check counter
CHECKS_PASSED=0
CHECKS_FAILED=0

check_pass() {
    echo -e "${GREEN}✓${NC} $1"
    CHECKS_PASSED=$((CHECKS_PASSED+1))
}

check_fail() {
    echo -e "${RED}✗${NC} $1"
    CHECKS_FAILED=$((CHECKS_FAILED+1))
}

check_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
}

echo -e "${BLUE}=== Environment Variables ===${NC}"

# Check BASE_DOMAIN
if [ -n "$BASE_DOMAIN" ]; then
    check_pass "BASE_DOMAIN is set: $BASE_DOMAIN"
else
    check_fail "BASE_DOMAIN is not set in .env"
fi

# Check TRAEFIK_HOST_KMPS
if [ -n "$TRAEFIK_HOST_KMPS" ]; then
    check_pass "TRAEFIK_HOST_KMPS is set: $TRAEFIK_HOST_KMPS"
else
    check_fail "TRAEFIK_HOST_KMPS is not set"
fi

# Check TRAEFIK_HOST_AUTH
if [ -n "$TRAEFIK_HOST_AUTH" ]; then
    check_pass "TRAEFIK_HOST_AUTH is set: $TRAEFIK_HOST_AUTH"
else
    check_fail "TRAEFIK_HOST_AUTH is not set (needed for Keycloak)"
fi

# Check KMPS_CLIENT_SECRET
if [ -n "$KMPS_CLIENT_SECRET" ]; then
    check_pass "KMPS_CLIENT_SECRET is set"
else
    check_fail "KMPS_CLIENT_SECRET is not set in secrets.env"
    echo -e "   ${YELLOW}Generate with: openssl rand -base64 32${NC}"
fi

# Check KMPS_NEXTAUTH_SECRET (now it's NEXTAUTH_SECRET)
if [ -n "$NEXTAUTH_SECRET" ]; then
    check_pass "NEXTAUTH_SECRET is set"
else
    check_fail "NEXTAUTH_SECRET is not set in secrets.env"
    echo -e "   ${YELLOW}Generate with: openssl rand -base64 32${NC}"
fi

echo ""
echo -e "${BLUE}=== Docker Services ===${NC}"

# Check if auth stack is running
if docker ps | grep -q "auth_keycloak"; then
    check_pass "Keycloak (auth stack) is running"
    
    # Check Keycloak health
    if [ -n "$TRAEFIK_HOST_AUTH" ]; then
        if curl -sSf "https://${TRAEFIK_HOST_AUTH}/health" > /dev/null 2>&1; then
            check_pass "Keycloak is accessible at https://${TRAEFIK_HOST_AUTH}"
        else
            check_warn "Keycloak may not be fully initialized yet"
        fi
    fi
else
    check_fail "Keycloak (auth stack) is not running"
    echo -e "   ${YELLOW}Start with: ./kompose.sh up auth${NC}"
fi

# Check if OAuth2 Proxy is running
if docker ps | grep -q "auth_oauth2_proxy"; then
    check_pass "OAuth2 Proxy is running"
else
    check_fail "OAuth2 Proxy is not running (part of auth stack)"
fi

# Check if Redis is running (required for sessions)
if docker ps | grep -q "core_redis"; then
    check_pass "Redis (core stack) is running"
else
    check_warn "Redis (core stack) is not running - required for OAuth2 Proxy sessions"
    echo -e "   ${YELLOW}Start with: ./kompose.sh up core${NC}"
fi

# Check if Postgres is running
if docker ps | grep -q "core_postgres"; then
    check_pass "PostgreSQL (core stack) is running"
else
    check_warn "PostgreSQL (core stack) is not running"
fi

# Check if Traefik is running
if docker ps | grep -q "proxy_app"; then
    check_pass "Traefik (proxy stack) is running"
else
    check_fail "Traefik (proxy stack) is not running"
    echo -e "   ${YELLOW}Start with: ./kompose.sh up proxy${NC}"
fi

echo ""
echo -e "${BLUE}=== Keycloak Configuration ===${NC}"

echo -e "${YELLOW}Manual verification required:${NC}"
echo ""
echo -e "1. ${BLUE}Login to Keycloak:${NC}"
echo -e "   URL: https://${TRAEFIK_HOST_AUTH}"
echo -e "   Username: \$KC_ADMIN_USERNAME (from secrets.env)"
echo -e "   Password: \$KC_ADMIN_PASSWORD (from secrets.env)"
echo ""
echo -e "2. ${BLUE}Verify KMPS Client exists:${NC}"
echo -e "   - Go to: Clients → kmps-admin"
echo -e "   - Client authentication: ${GREEN}ON${NC}"
echo -e "   - Service accounts roles: ${GREEN}ON${NC}"
echo -e "   - Valid redirect URIs: ${GREEN}https://${TRAEFIK_HOST_KMPS}/*${NC}"
echo ""
echo -e "3. ${BLUE}Verify Service Account Roles:${NC}"
echo -e "   - Go to: Clients → kmps-admin → Service accounts roles"
echo -e "   - Required roles:"
echo -e "     ${GREEN}✓${NC} realm-admin"
echo -e "     ${GREEN}✓${NC} manage-users"
echo -e "     ${GREEN}✓${NC} manage-clients"
echo -e "     ${GREEN}✓${NC} view-users"
echo -e "     ${GREEN}✓${NC} query-users"
echo ""
echo -e "4. ${BLUE}Copy Client Secret:${NC}"
echo -e "   - Go to: Clients → kmps-admin → Credentials"
echo -e "   - Copy the Client Secret"
echo -e "   - Add to secrets.env: ${GREEN}KMPS_CLIENT_SECRET=<secret>${NC}"
echo ""

echo -e "${BLUE}=== KMPS Application ===${NC}"

# Check if KMPS is running
if docker ps | grep -q "kmps_app"; then
    check_pass "KMPS application is running"
    
    # Check if accessible
    if [ -n "$TRAEFIK_HOST_KMPS" ]; then
        if curl -sSf "https://${TRAEFIK_HOST_KMPS}" > /dev/null 2>&1; then
            check_pass "KMPS is accessible at https://${TRAEFIK_HOST_KMPS}"
        else
            check_warn "KMPS may not be fully initialized yet"
        fi
    fi
else
    echo -e "${YELLOW}KMPS is not running yet${NC}"
    echo -e "   Start with: ${GREEN}./kompose.sh up kmps${NC}"
fi

echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                   Verification Summary                 ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "Checks Passed: ${GREEN}$CHECKS_PASSED${NC}"
echo -e "Checks Failed: ${RED}$CHECKS_FAILED${NC}"
echo ""

if [ $CHECKS_FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All automated checks passed!${NC}"
    echo -e "${YELLOW}⚠ Don't forget to verify Keycloak configuration manually (see above)${NC}"
    echo ""
    echo -e "${BLUE}Next Steps:${NC}"
    echo -e "1. Complete Keycloak client setup (see manual verification above)"
    echo -e "2. Start KMPS: ${GREEN}./kompose.sh up kmps${NC}"
    echo -e "3. Access portal: ${GREEN}https://${TRAEFIK_HOST_KMPS}${NC}"
else
    echo -e "${RED}✗ Some checks failed. Please fix the issues above.${NC}"
    exit 1
fi
