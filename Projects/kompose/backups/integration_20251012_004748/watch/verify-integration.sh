#!/bin/bash

# Watch Stack Integration Verification Script
# This script tests all integration points between watch, core, track, and home services

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Emojis
CHECK="✓"
CROSS="✗"
WARN="⚠"
INFO="ℹ"

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Watch Stack Integration Verification                    ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Function to print status
print_status() {
    local status=$1
    local message=$2
    if [ "$status" = "success" ]; then
        echo -e "${GREEN}${CHECK}${NC} $message"
    elif [ "$status" = "error" ]; then
        echo -e "${RED}${CROSS}${NC} $message"
    elif [ "$status" = "warning" ]; then
        echo -e "${YELLOW}${WARN}${NC} $message"
    else
        echo -e "${BLUE}${INFO}${NC} $message"
    fi
}

# Function to test HTTP endpoint
test_endpoint() {
    local url=$1
    local name=$2
    local expected=${3:-200}
    
    if curl -s -f -o /dev/null -w "%{http_code}" "$url" | grep -q "$expected"; then
        print_status "success" "$name is reachable"
        return 0
    else
        print_status "error" "$name is not reachable"
        return 1
    fi
}

# Function to test container health
test_container() {
    local container=$1
    local name=$2
    
    if docker ps --format '{{.Names}}' | grep -q "^${container}$"; then
        local health=$(docker inspect --format='{{.State.Health.Status}}' "$container" 2>/dev/null || echo "no-health-check")
        if [ "$health" = "healthy" ] || [ "$health" = "no-health-check" ]; then
            print_status "success" "$name container is running"
            return 0
        else
            print_status "warning" "$name container is running but unhealthy: $health"
            return 1
        fi
    else
        print_status "error" "$name container is not running"
        return 1
    fi
}

# Change to watch directory
cd "$(dirname "$0")"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}1. Checking Watch Stack Containers${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

test_container "watch_prometheus" "Prometheus"
test_container "watch_grafana" "Grafana"
test_container "watch_otel" "OTEL Collector"
test_container "watch_postgres_exporter" "PostgreSQL Exporter"
test_container "watch_redis_exporter" "Redis Exporter"
test_container "watch_mqtt_exporter" "MQTT Exporter"
test_container "watch_cadvisor" "cAdvisor"
test_container "watch_blackbox_exporter" "Blackbox Exporter"
test_container "watch_alertmanager" "Alertmanager"

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}2. Checking Core Service Containers${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

test_container "core-postgres" "PostgreSQL"
test_container "core-redis" "Redis"
test_container "core-mqtt" "Mosquitto (MQTT)"

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}3. Checking Additional Service Containers${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

test_container "track_app" "Umami"
test_container "home_homeassistant" "Home Assistant"

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}4. Testing Watch Stack Endpoints${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

test_endpoint "http://localhost:9090/-/healthy" "Prometheus"
test_endpoint "http://localhost:3001/api/health" "Grafana"
test_endpoint "http://localhost:13133/" "OTEL Collector Health"
test_endpoint "http://localhost:9187/metrics" "PostgreSQL Exporter"
test_endpoint "http://localhost:9121/metrics" "Redis Exporter"
test_endpoint "http://localhost:9000/metrics" "MQTT Exporter"
test_endpoint "http://localhost:9093/-/healthy" "Alertmanager"

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}5. Testing Core Service Connectivity${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Test from Prometheus container to core services
if docker exec watch_prometheus wget -q --spider --timeout=5 http://core-postgres:5432 2>/dev/null; then
    print_status "success" "Prometheus → PostgreSQL connection"
else
    print_status "warning" "Prometheus → PostgreSQL connection (port not HTTP)"
fi

if docker exec watch_prometheus wget -q --spider --timeout=5 http://core-redis:6379 2>/dev/null; then
    print_status "success" "Prometheus → Redis connection"
else
    print_status "warning" "Prometheus → Redis connection (port not HTTP)"
fi

if docker exec watch_prometheus nc -zv core-mqtt 1883 2>&1 | grep -q "succeeded"; then
    print_status "success" "Prometheus → MQTT connection"
else
    print_status "error" "Prometheus → MQTT connection"
fi

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}6. Testing Additional Service Connectivity${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Test Umami connectivity
if docker exec watch_prometheus wget -q --spider --timeout=5 http://track_app:3000 2>/dev/null; then
    print_status "success" "Prometheus → Umami connection"
else
    print_status "error" "Prometheus → Umami connection"
fi

# Test Home Assistant connectivity
if docker exec watch_prometheus wget -q --spider --timeout=5 http://home_homeassistant:8123 2>/dev/null; then
    print_status "success" "Prometheus → Home Assistant connection"
else
    print_status "error" "Prometheus → Home Assistant connection"
fi

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}7. Checking Prometheus Targets${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if command -v jq &> /dev/null; then
    targets=$(curl -s http://localhost:9090/api/v1/targets 2>/dev/null)
    if [ -n "$targets" ]; then
        echo "$targets" | jq -r '.data.activeTargets[] | "\(.labels.job): \(.health)"' | while read -r line; do
            job=$(echo "$line" | cut -d: -f1)
            health=$(echo "$line" | cut -d: -f2 | tr -d ' ')
            if [ "$health" = "up" ]; then
                print_status "success" "Target: $job"
            else
                print_status "error" "Target: $job ($health)"
            fi
        done
    else
        print_status "warning" "Could not retrieve Prometheus targets"
    fi
else
    print_status "warning" "jq not installed, skipping target check"
    echo "  Install jq to see detailed target status: sudo apt install jq"
fi

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}8. Testing MQTT Metrics${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

mqtt_metrics=$(curl -s http://localhost:9000/metrics 2>/dev/null | grep -c "^mqtt_" || echo "0")
if [ "$mqtt_metrics" -gt 0 ]; then
    print_status "success" "MQTT Exporter reporting $mqtt_metrics metric types"
else
    print_status "error" "No MQTT metrics found"
fi

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}9. Checking Network Configuration${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Check if kompose network exists
if docker network ls | grep -q kompose; then
    print_status "success" "Kompose network exists"
    
    # Count containers on network
    container_count=$(docker network inspect kompose 2>/dev/null | jq -r '.[0].Containers | length' || echo "0")
    print_status "info" "$container_count containers connected to kompose network"
else
    print_status "error" "Kompose network not found"
fi

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}10. Configuration Recommendations${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Check if Home Assistant token is configured
if grep -q "YOUR_LONG_LIVED_ACCESS_TOKEN" prometheus/prometheus.yml 2>/dev/null; then
    print_status "warning" "Home Assistant access token not configured"
    echo "  → Update prometheus/prometheus.yml with your Home Assistant token"
else
    print_status "success" "Home Assistant access token appears configured"
fi

# Check if default passwords are changed
if grep -q "change_this_password" .env 2>/dev/null; then
    print_status "warning" "Default passwords detected in .env"
    echo "  → Change default passwords in .env file"
else
    print_status "success" "No default passwords found in .env"
fi

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Summary${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

echo ""
echo -e "${GREEN}${CHECK}${NC} Integration verification complete!"
echo ""
echo "Next steps:"
echo "  1. Configure Home Assistant access token (if not done)"
echo "  2. Import Grafana dashboards"
echo "  3. Set up alerting rules"
echo "  4. Review and change default passwords"
echo ""
echo "For detailed instructions, see:"
echo "  - INTEGRATION_GUIDE.md"
echo "  - INTEGRATION_QUICK_REF.md"
echo ""
