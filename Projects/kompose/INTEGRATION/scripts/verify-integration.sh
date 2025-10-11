#!/bin/bash
# =================================================================
# Verify Integration Script - Kompose Service Integration
# =================================================================
# This script verifies that integrations are working correctly
# =================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[i]${NC} $1"
}

# Function to check if a service is running
check_service() {
    local service=$1
    local container=$2
    
    if docker ps --format '{{.Names}}' | grep -q "$container"; then
        print_status "$service is running"
        return 0
    else
        print_error "$service is NOT running"
        return 1
    fi
}

# Function to check service health
check_health() {
    local container=$1
    local health=$(docker inspect --format='{{.State.Health.Status}}' "$container" 2>/dev/null || echo "no-health-check")
    
    if [ "$health" = "healthy" ]; then
        print_status "$container is healthy"
        return 0
    elif [ "$health" = "no-health-check" ]; then
        print_warning "$container has no health check configured"
        return 0
    else
        print_error "$container health: $health"
        return 1
    fi
}

# Function to check if a port is accessible
check_endpoint() {
    local name=$1
    local url=$2
    
    if curl -sf "$url" > /dev/null 2>&1; then
        print_status "$name endpoint is accessible: $url"
        return 0
    else
        print_error "$name endpoint is NOT accessible: $url"
        return 1
    fi
}

# Function to check MQTT connectivity
check_mqtt() {
    print_info "Checking MQTT broker..."
    
    if command -v mosquitto_sub &> /dev/null; then
        if timeout 5 mosquitto_sub -h localhost -p 1883 -t '$SYS/broker/version' -C 1 &> /dev/null; then
            print_status "MQTT broker is accessible"
            return 0
        else
            print_error "Cannot connect to MQTT broker"
            return 1
        fi
    else
        print_warning "mosquitto_sub not installed, skipping MQTT check"
        return 0
    fi
}

# Function to check Redis connectivity
check_redis() {
    print_info "Checking Redis cache..."
    
    if docker exec core-redis redis-cli ping &> /dev/null; then
        print_status "Redis is accessible"
        return 0
    else
        print_error "Cannot connect to Redis"
        return 1
    fi
}

# Function to check PostgreSQL connectivity
check_postgres() {
    print_info "Checking PostgreSQL database..."
    
    if docker exec core-postgres pg_isready &> /dev/null; then
        print_status "PostgreSQL is accessible"
        return 0
    else
        print_error "Cannot connect to PostgreSQL"
        return 1
    fi
}

# Function to check Prometheus scraping
check_prometheus_targets() {
    print_info "Checking Prometheus targets..."
    
    local prometheus_url="http://localhost:9090"
    
    if curl -sf "$prometheus_url/api/v1/targets" | jq -e '.data.activeTargets | length > 0' &> /dev/null; then
        local healthy=$(curl -sf "$prometheus_url/api/v1/targets" | jq -r '[.data.activeTargets[] | select(.health=="up")] | length')
        local total=$(curl -sf "$prometheus_url/api/v1/targets" | jq -r '.data.activeTargets | length')
        print_status "Prometheus targets: $healthy/$total healthy"
        return 0
    else
        print_error "Cannot check Prometheus targets"
        return 1
    fi
}

# Function to check Grafana dashboards
check_grafana() {
    print_info "Checking Grafana..."
    
    if check_endpoint "Grafana" "http://localhost:3001/api/health"; then
        return 0
    else
        return 1
    fi
}

# Function to verify SSO integration
check_sso() {
    local service=$1
    local host=$2
    
    print_info "Checking SSO for $service..."
    
    # Try to access the service and check for auth redirect
    local response=$(curl -sI "https://$host" 2>/dev/null || echo "ERROR")
    
    if echo "$response" | grep -q "oauth2"; then
        print_status "$service has SSO enabled"
        return 0
    elif echo "$response" | grep -q "200\|301\|302"; then
        print_warning "$service is accessible but SSO status unclear"
        return 0
    else
        print_error "Cannot verify SSO for $service"
        return 1
    fi
}

# Main verification function
verify_service() {
    local service=$1
    local failed=0
    
    echo ""
    echo "─────────────────────────────────────────────────────────────"
    print_info "Verifying $service integration..."
    echo "─────────────────────────────────────────────────────────────"
    
    case $service in
        link)
            check_service "Linkwarden" "link_app" || ((failed++))
            check_health "link_app" || ((failed++))
            check_service "Linkwarden Metrics" "link_metrics" || ((failed++))
            ;;
        news)
            check_service "Letterpress" "news_backend" || ((failed++))
            check_health "news_backend" || ((failed++))
            ;;
        track)
            check_service "Umami" "track_app" || ((failed++))
            check_health "track_app" || ((failed++))
            ;;
        vault)
            check_service "Vaultwarden" "vault_app" || ((failed++))
            check_health "vault_app" || ((failed++))
            ;;
        watch)
            check_service "Prometheus" "watch_prometheus" || ((failed++))
            check_service "Grafana" "watch_grafana" || ((failed++))
            check_service "OTEL Collector" "watch_otel" || ((failed++))
            check_prometheus_targets || ((failed++))
            check_grafana || ((failed++))
            ;;
    esac
    
    return $failed
}

# Main script
main() {
    local service="${1:-all}"
    local total_failed=0
    
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    echo "  Kompose Service Integration - Verification"
    echo "═══════════════════════════════════════════════════════════════"
    
    # Check core services first
    echo ""
    echo "─────────────────────────────────────────────────────────────"
    print_info "Verifying Core Services..."
    echo "─────────────────────────────────────────────────────────────"
    
    check_service "PostgreSQL" "core-postgres" || ((total_failed++))
    check_postgres || ((total_failed++))
    
    check_service "Redis" "core-redis" || ((total_failed++))
    check_redis || ((total_failed++))
    
    check_service "MQTT Broker" "core-mqtt" || ((total_failed++))
    check_mqtt || ((total_failed++))
    
    check_service "Traefik" "proxy_app" || ((total_failed++))
    
    # Check specific service or all
    if [ "$service" = "all" ]; then
        for svc in link news track vault watch; do
            verify_service "$svc"
            total_failed=$((total_failed + $?))
        done
    else
        verify_service "$service"
        total_failed=$((total_failed + $?))
    fi
    
    # Summary
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    
    if [ $total_failed -eq 0 ]; then
        print_status "All checks passed! Integration is working correctly."
    else
        print_error "$total_failed check(s) failed. Please review the output above."
        echo ""
        print_info "Troubleshooting tips:"
        echo "  • Check service logs: docker compose -f +utility/$service/compose.yaml logs"
        echo "  • Verify environment variables in .env files"
        echo "  • Ensure all core services are running"
        echo "  • Check network connectivity between containers"
    fi
    
    echo "═══════════════════════════════════════════════════════════════"
    echo ""
    
    return $total_failed
}

main "$@"
