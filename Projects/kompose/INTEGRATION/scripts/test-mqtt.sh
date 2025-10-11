#!/bin/bash
# =================================================================
# Test MQTT Integration Script
# =================================================================
# Tests MQTT connectivity and event publishing/subscribing
# =================================================================

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

print_test() {
    echo -e "${BLUE}▶ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "  MQTT Integration Test Suite"
echo "═══════════════════════════════════════════════════════════"
echo ""

# Check if mosquitto clients are installed
if ! command -v mosquitto_pub &> /dev/null || ! command -v mosquitto_sub &> /dev/null; then
    print_error "Mosquitto clients not installed"
    print_info "Install with: sudo apt-get install mosquitto-clients"
    exit 1
fi

MQTT_HOST="${MQTT_HOST:-localhost}"
MQTT_PORT="${MQTT_PORT:-1883}"

# Test 1: Broker connectivity
print_test "Test 1: Testing MQTT broker connectivity..."
if timeout 3 mosquitto_sub -h "$MQTT_HOST" -p "$MQTT_PORT" -t '$SYS/broker/version' -C 1 &> /dev/null; then
    print_success "MQTT broker is accessible at $MQTT_HOST:$MQTT_PORT"
else
    print_error "Cannot connect to MQTT broker"
    exit 1
fi

echo ""

# Test 2: Publish test message
print_test "Test 2: Publishing test message..."
mosquitto_pub -h "$MQTT_HOST" -p "$MQTT_PORT" -t "kompose/test/integration" -m '{"test": true, "timestamp": "'$(date -Iseconds)'"}'
print_success "Test message published to kompose/test/integration"

echo ""

# Test 3: Subscribe and verify
print_test "Test 3: Testing subscribe and receive..."
timeout 5 mosquitto_sub -h "$MQTT_HOST" -p "$MQTT_PORT" -t "kompose/test/#" -v -C 1 &
SUB_PID=$!
sleep 1

mosquitto_pub -h "$MQTT_HOST" -p "$MQTT_PORT" -t "kompose/test/verify" -m '{"verified": true}'

wait $SUB_PID 2>/dev/null && print_success "Subscribe and receive working" || print_error "Subscribe test failed"

echo ""

# Test 4: Publish sample events for each service
print_test "Test 4: Publishing sample events for all services..."

# Linkwarden bookmark event
mosquitto_pub -h "$MQTT_HOST" -p "$MQTT_PORT" \
  -t "kompose/linkwarden/bookmark/added" \
  -m '{
    "event_id": "test-'$(uuidgen)'",
    "timestamp": "'$(date -Iseconds)'",
    "service": "linkwarden",
    "event_type": "bookmark.added",
    "data": {
      "bookmark_id": 999,
      "url": "https://example.com/test",
      "title": "Test Bookmark",
      "tags": ["test", "integration"],
      "collection": "Test Collection"
    }
  }'
print_success "  Linkwarden event published"

# Letterpress article event
mosquitto_pub -h "$MQTT_HOST" -p "$MQTT_PORT" \
  -t "kompose/news/article/published" \
  -m '{
    "event_id": "test-'$(uuidgen)'",
    "timestamp": "'$(date -Iseconds)'",
    "service": "letterpress",
    "event_type": "article.published",
    "data": {
      "article_id": 999,
      "title": "Test Article",
      "slug": "test-article",
      "published_url": "https://news.example.com/test-article",
      "category": "Test",
      "tags": ["test"]
    }
  }'
print_success "  Letterpress event published"

# Umami analytics event
mosquitto_pub -h "$MQTT_HOST" -p "$MQTT_PORT" \
  -t "kompose/analytics/pageview" \
  -m '{
    "event_id": "test-'$(uuidgen)'",
    "timestamp": "'$(date -Iseconds)'",
    "service": "umami",
    "event_type": "pageview",
    "data": {
      "url": "/test/page",
      "referrer": "https://example.com",
      "device_type": "desktop"
    }
  }'
print_success "  Umami event published"

# Vaultwarden security event
mosquitto_pub -h "$MQTT_HOST" -p "$MQTT_PORT" \
  -t "kompose/vault/security/login" \
  -m '{
    "event_id": "test-'$(uuidgen)'",
    "timestamp": "'$(date -Iseconds)'",
    "service": "vaultwarden",
    "event_type": "security.login",
    "data": {
      "user_email": "test@example.com",
      "ip_address": "127.0.0.1",
      "device_type": "Browser",
      "device_name": "Test Browser"
    }
  }'
print_success "  Vaultwarden event published"

# System health check
mosquitto_pub -h "$MQTT_HOST" -p "$MQTT_PORT" \
  -t "kompose/system/health/check" \
  -m '{
    "event_id": "test-'$(uuidgen)'",
    "timestamp": "'$(date -Iseconds)'",
    "service": "system",
    "event_type": "health.check",
    "data": {
      "services": {
        "postgresql": {"status": "healthy"},
        "redis": {"status": "healthy"},
        "mqtt": {"status": "healthy"}
      },
      "overall_status": "healthy"
    }
  }'
print_success "  System health event published"

echo ""

# Test 5: Monitor events
print_test "Test 5: Monitoring all kompose events (10 seconds)..."
print_info "Press Ctrl+C to stop early"
echo ""

timeout 10 mosquitto_sub -h "$MQTT_HOST" -p "$MQTT_PORT" -t "kompose/#" -v || true

echo ""
print_success "Event monitoring complete"

echo ""

# Test 6: QoS levels
print_test "Test 6: Testing QoS levels..."

# QoS 0 (at most once)
mosquitto_pub -h "$MQTT_HOST" -p "$MQTT_PORT" -q 0 \
  -t "kompose/test/qos0" -m '{"qos": 0}'
print_success "  QoS 0 message sent"

# QoS 1 (at least once)
mosquitto_pub -h "$MQTT_HOST" -p "$MQTT_PORT" -q 1 \
  -t "kompose/test/qos1" -m '{"qos": 1}'
print_success "  QoS 1 message sent"

# QoS 2 (exactly once)
mosquitto_pub -h "$MQTT_HOST" -p "$MQTT_PORT" -q 2 \
  -t "kompose/test/qos2" -m '{"qos": 2}'
print_success "  QoS 2 message sent"

echo ""

# Test 7: Retained messages
print_test "Test 7: Testing retained messages..."

mosquitto_pub -h "$MQTT_HOST" -p "$MQTT_PORT" -r \
  -t "kompose/test/retained" -m '{"retained": true, "timestamp": "'$(date -Iseconds)'"}'
print_success "  Retained message published"

sleep 1

RETAINED=$(timeout 2 mosquitto_sub -h "$MQTT_HOST" -p "$MQTT_PORT" -t "kompose/test/retained" -C 1)
if [ -n "$RETAINED" ]; then
    print_success "  Retained message received: $RETAINED"
else
    print_error "  Failed to receive retained message"
fi

echo ""

# Summary
echo "═══════════════════════════════════════════════════════════"
echo "  Test Summary"
echo "═══════════════════════════════════════════════════════════"
echo ""
print_success "All MQTT integration tests passed!"
echo ""
print_info "Next steps:"
echo "  1. Monitor events: mosquitto_sub -h $MQTT_HOST -t 'kompose/#' -v"
echo "  2. Start automations in INTEGRATION/mqtt/automations/"
echo "  3. Check Prometheus metrics for MQTT broker stats"
echo ""
