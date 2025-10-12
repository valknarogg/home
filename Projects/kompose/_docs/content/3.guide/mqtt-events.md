# MQTT Events Guide

Complete guide for MQTT event publishing and automation in Kompose.

## Overview

Kompose services publish real-time events to an MQTT broker, enabling:
- **Service Integration** - Services communicate via events
- **Automation** - Trigger actions based on events
- **Monitoring** - Real-time activity tracking
- **Analytics** - Event-driven data collection

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                   MQTT Event Flow                        │
│                                                          │
│  ┌──────────┐     ┌──────────┐     ┌──────────┐        │
│  │Linkwarden│────>│          │<────│Letterpress│        │
│  └──────────┘     │   MQTT   │     └──────────┘        │
│                   │  Broker  │                          │
│  ┌──────────┐     │ (Mosquitto)     ┌──────────┐        │
│  │  Umami   │────>│          │<────│Vaultwarden│        │
│  └──────────┘     └─────┬────┘     └──────────┘        │
│                         │                               │
│                   ┌─────▼─────┐                         │
│                   │Subscribers│                         │
│                   │ - n8n     │                         │
│                   │ - Scripts │                         │
│                   │ - Monitor │                         │
│                   └───────────┘                         │
└─────────────────────────────────────────────────────────┘
```

## MQTT Broker

### Access Information

**Container:** `core-mqtt` (Mosquitto)
**Ports:**
- 1883 - MQTT Protocol
- 9001 - WebSocket
- 9000 - Metrics (Prometheus)

**Connection:**
```bash
# Internal (from Docker containers)
mqtt://core-mqtt:1883

# External (if ports exposed)
mqtt://localhost:1883
```

## Event Topics

All events follow the pattern: `kompose/<service>/<category>/<action>`

### Topic Structure

```
kompose/
├── linkwarden/
│   ├── bookmark/
│   │   ├── added
│   │   ├── updated
│   │   └── deleted
│   └── stats/
│       └── daily
├── news/
│   ├── article/
│   │   ├── published
│   │   └── updated
│   └── newsletter/
│       └── sent
├── analytics/
│   ├── pageview
│   ├── event
│   └── stats/
│       └── realtime
├── vault/
│   ├── security/
│   │   ├── login
│   │   ├── failed
│   │   └── unlock
│   └── item/
│       ├── created
│       └── accessed
└── system/
    ├── health/
    │   └── check
    ├── backup/
    │   └── completed
    └── alert/
        └── triggered
```

## Event Schemas

### Linkwarden Events

**Bookmark Added:**
```json
{
  "event": "bookmark.added",
  "timestamp": "2025-10-12T14:30:00Z",
  "data": {
    "id": "clx123456",
    "url": "https://example.com/article",
    "title": "Example Article",
    "description": "Article description",
    "collection": "Tech",
    "tags": ["javascript", "tutorial"],
    "user": {
      "id": "user_123",
      "email": "user@example.com"
    }
  }
}
```

**Topic:** `kompose/linkwarden/bookmark/added`

**Bookmark Updated:**
```json
{
  "event": "bookmark.updated",
  "timestamp": "2025-10-12T14:35:00Z",
  "data": {
    "id": "clx123456",
    "changes": ["title", "tags"],
    "new_values": {
      "title": "Updated Title",
      "tags": ["javascript", "tutorial", "advanced"]
    }
  }
}
```

**Topic:** `kompose/linkwarden/bookmark/updated`

### Letterpress Events

**Article Published:**
```json
{
  "event": "article.published",
  "timestamp": "2025-10-12T15:00:00Z",
  "data": {
    "id": "art_789",
    "title": "New Blog Post",
    "slug": "new-blog-post",
    "author": {
      "id": "author_123",
      "name": "John Doe"
    },
    "categories": ["Technology", "Tutorial"],
    "tags": ["docker", "devops"],
    "published_url": "https://news.example.com/new-blog-post",
    "excerpt": "Post excerpt..."
  }
}
```

**Topic:** `kompose/news/article/published`

**Newsletter Sent:**
```json
{
  "event": "newsletter.sent",
  "timestamp": "2025-10-12T16:00:00Z",
  "data": {
    "campaign_id": "camp_456",
    "subject": "Weekly Newsletter",
    "recipients_count": 1250,
    "articles_included": ["art_789", "art_790"],
    "sent_at": "2025-10-12T16:00:00Z"
  }
}
```

**Topic:** `kompose/news/newsletter/sent`

### Umami Events

**Pageview:**
```json
{
  "event": "pageview",
  "timestamp": "2025-10-12T14:30:00Z",
  "data": {
    "website_id": "web_123",
    "session_id": "sess_456",
    "url": "/blog/article",
    "referrer": "https://google.com",
    "country": "DE",
    "device": "desktop",
    "browser": "Chrome",
    "os": "Linux"
  }
}
```

**Topic:** `kompose/analytics/pageview`

**Custom Event:**
```json
{
  "event": "custom_event",
  "timestamp": "2025-10-12T14:30:00Z",
  "data": {
    "website_id": "web_123",
    "event_name": "button_click",
    "event_data": {
      "button_id": "subscribe",
      "section": "header"
    },
    "url": "/pricing"
  }
}
```

**Topic:** `kompose/analytics/event`

### Vaultwarden Events

**Login Success:**
```json
{
  "event": "security.login",
  "timestamp": "2025-10-12T14:30:00Z",
  "data": {
    "user_id": "user_123",
    "email": "user@example.com",
    "ip_address": "192.168.1.100",
    "device_type": "desktop",
    "success": true
  }
}
```

**Topic:** `kompose/vault/security/login`

**Failed Login:**
```json
{
  "event": "security.failed",
  "timestamp": "2025-10-12T14:30:00Z",
  "data": {
    "email": "user@example.com",
    "ip_address": "192.168.1.100",
    "reason": "invalid_password",
    "attempt_count": 3
  }
}
```

**Topic:** `kompose/vault/security/failed`

## Testing MQTT

### Subscribe to All Events

```bash
# Using mosquitto_sub
mosquitto_sub -h core-mqtt -t "kompose/#" -v

# Or from outside Docker
mosquitto_sub -h localhost -t "kompose/#" -v
```

### Subscribe to Specific Service

```bash
# Linkwarden events only
mosquitto_sub -h core-mqtt -t "kompose/linkwarden/#" -v

# Letterpress articles only
mosquitto_sub -h core-mqtt -t "kompose/news/article/#" -v

# Security events only
mosquitto_sub -h core-mqtt -t "kompose/vault/security/#" -v
```

### Publish Test Event

```bash
# Publish test bookmark event
mosquitto_pub -h core-mqtt \
  -t "kompose/linkwarden/bookmark/added" \
  -m '{
    "event": "bookmark.added",
    "timestamp": "'$(date -Iseconds)'",
    "data": {
      "id": "test_123",
      "url": "https://example.com",
      "title": "Test Bookmark"
    }
  }'
```

### Monitor Broker Statistics

```bash
# System messages
mosquitto_sub -h core-mqtt -t '$SYS/#' -C 10

# Broker stats
mosquitto_sub -h core-mqtt -t '$SYS/broker/clients/total' -C 1
mosquitto_sub -h core-mqtt -t '$SYS/broker/messages/received' -C 1
```

## Automation Examples

### Example 1: Article to Bookmark

Automatically create bookmarks for published articles:

**Script:** `article-to-bookmark.js`
```javascript
const mqtt = require('mqtt');
const axios = require('axios');

// Connect to MQTT broker
const client = mqtt.connect('mqtt://core-mqtt:1883');

// Linkwarden API configuration
const LINKWARDEN_API = 'https://link.example.com/api';
const LINKWARDEN_TOKEN = process.env.LINKWARDEN_API_TOKEN;

client.on('connect', () => {
  console.log('Connected to MQTT broker');
  
  // Subscribe to article publishing events
  client.subscribe('kompose/news/article/published', (err) => {
    if (err) console.error('Subscribe error:', err);
    else console.log('Subscribed to article events');
  });
});

client.on('message', async (topic, message) => {
  const event = JSON.parse(message.toString());
  const article = event.data;
  
  console.log('New article published:', article.title);
  
  // Create bookmark in Linkwarden
  try {
    await axios.post(`${LINKWARDEN_API}/bookmarks`, {
      url: article.published_url,
      title: article.title,
      description: article.excerpt,
      collection: 'Published Articles',
      tags: article.tags
    }, {
      headers: {
        'Authorization': `Bearer ${LINKWARDEN_TOKEN}`
      }
    });
    
    console.log('✓ Bookmark created for:', article.title);
  } catch (error) {
    console.error('✗ Failed to create bookmark:', error.message);
  }
});
```

**Run:**
```bash
export LINKWARDEN_API_TOKEN="your-token"
node article-to-bookmark.js
```

### Example 2: Security Monitor

Monitor failed login attempts and send alerts:

**Script:** `security-monitor.js`
```javascript
const mqtt = require('mqtt');
const axios = require('axios');

const client = mqtt.connect('mqtt://core-mqtt:1883');
const GOTIFY_URL = process.env.GOTIFY_URL || 'http://messaging_gotify/message';
const GOTIFY_TOKEN = process.env.GOTIFY_TOKEN;

const failedAttempts = new Map();

client.on('connect', () => {
  console.log('Security monitor started');
  client.subscribe('kompose/vault/security/failed');
});

client.on('message', async (topic, message) => {
  const event = JSON.parse(message.toString());
  const { email, ip_address, attempt_count } = event.data;
  
  // Track failed attempts
  const key = `${email}:${ip_address}`;
  const current = failedAttempts.get(key) || 0;
  failedAttempts.set(key, current + 1);
  
  // Alert if multiple failures
  if (failedAttempts.get(key) >= 3) {
    await axios.post(`${GOTIFY_URL}?token=${GOTIFY_TOKEN}`, {
      title: '🔒 Security Alert',
      message: `Multiple failed login attempts for ${email} from ${ip_address}`,
      priority: 8
    });
    
    console.log(`⚠️  Alert sent for ${email}`);
    
    // Reset counter after alert
    failedAttempts.delete(key);
  }
});

// Clear old entries every hour
setInterval(() => {
  failedAttempts.clear();
}, 3600000);
```

**Run:**
```bash
export GOTIFY_TOKEN="your-token"
node security-monitor.js
```

### Example 3: Analytics to n8n

Forward analytics events to n8n workflow:

**Script:** `analytics-to-n8n.js`
```javascript
const mqtt = require('mqtt');
const axios = require('axios');

const client = mqtt.connect('mqtt://core-mqtt:1883');
const N8N_WEBHOOK = 'https://chain.example.com/webhook/analytics';

client.on('connect', () => {
  console.log('Analytics forwarder started');
  client.subscribe('kompose/analytics/#');
});

client.on('message', async (topic, message) => {
  const event = JSON.parse(message.toString());
  
  // Forward to n8n webhook
  try {
    await axios.post(N8N_WEBHOOK, {
      topic,
      event
    });
    
    console.log('✓ Forwarded event:', event.event);
  } catch (error) {
    console.error('✗ Forward failed:', error.message);
  }
});
```

## n8n Integration

### MQTT Trigger Node

1. **Add MQTT Node** to workflow
2. **Configure:**
   - Protocol: MQTT
   - Host: core-mqtt
   - Port: 1883
   - Topic: `kompose/#`
3. **Process Events** in subsequent nodes

### Example Workflow

```
[MQTT Trigger]
    ↓
[Filter Events]
    ↓
[HTTP Request] → Create bookmark
    ↓
[Gotify] → Send notification
```

## Service Implementation

### Adding MQTT to Your Service

**1. Install MQTT Client:**
```bash
# Node.js
npm install mqtt

# Python
pip install paho-mqtt
```

**2. Connect to Broker:**
```javascript
const mqtt = require('mqtt');

const client = mqtt.connect('mqtt://core-mqtt:1883', {
  clientId: 'my-service',
  clean: true,
  reconnectPeriod: 1000
});

client.on('connect', () => {
  console.log('Connected to MQTT broker');
});
```

**3. Publish Events:**
```javascript
function publishEvent(topic, data) {
  const event = {
    event: topic.split('/').pop(),
    timestamp: new Date().toISOString(),
    data
  };
  
  client.publish(`kompose/${topic}`, JSON.stringify(event), {
    qos: 1,  // At least once delivery
    retain: false
  });
}

// Usage
publishEvent('myservice/action/completed', {
  id: '123',
  status: 'success'
});
```

## Best Practices

### 1. Use Structured Topics

Good:
```
kompose/service/category/action
kompose/linkwarden/bookmark/added
```

Bad:
```
bookmark_added
new-bookmark
```

### 2. Include Timestamps

Always include ISO 8601 timestamp:
```json
{
  "timestamp": "2025-10-12T14:30:00Z"
}
```

### 3. Keep Payloads Small

- Include IDs, not full objects
- Use references for large data
- Maximum ~1KB per message

### 4. Handle Failures

```javascript
client.on('error', (error) => {
  console.error('MQTT Error:', error);
  // Implement retry logic
});

client.on('close', () => {
  console.log('MQTT connection closed');
  // Reconnect automatically
});
```

### 5. Use QoS Appropriately

- QoS 0: Fire and forget (metrics, logs)
- QoS 1: At least once (important events)
- QoS 2: Exactly once (critical transactions)

## Monitoring MQTT

### Prometheus Metrics

Available at `http://core-mqtt:9000/metrics`:

```
mqtt_messages_received_total
mqtt_messages_sent_total
mqtt_clients_connected
mqtt_subscriptions_count
mqtt_bytes_received_total
mqtt_bytes_sent_total
```

### Grafana Dashboard

Pre-configured dashboard shows:
- Messages per second
- Connected clients
- Subscription count
- Broker health

### Alert on Broker Issues

```yaml
- alert: MQTTBrokerDown
  expr: up{job="mqtt"} == 0
  for: 1m
  labels:
    severity: critical
```

## Troubleshooting

### Events Not Publishing

**Check service MQTT configuration:**
```bash
docker exec service_container env | grep MQTT
```

**Test broker connectivity:**
```bash
docker exec service_container ping -c 1 core-mqtt
```

**Check broker logs:**
```bash
docker logs core-mqtt
```

### Events Not Received

**Verify subscription:**
```bash
mosquitto_sub -h core-mqtt -t "kompose/#" -v
```

**Check topic spelling:**
- Topics are case-sensitive
- Use exact topic structure

**Test with wildcard:**
```bash
mosquitto_sub -h core-mqtt -t "#" -C 5
```

### Broker Overload

**Check message rate:**
```bash
mosquitto_sub -h core-mqtt -t '$SYS/broker/messages/received' -C 10
```

**Reduce publish frequency:**
- Batch events
- Implement rate limiting
- Use QoS 0 for non-critical events

## Advanced Topics

### Retained Messages

Publish with retain flag:
```javascript
client.publish('kompose/status/service', 'online', {
  retain: true  // Last message available to new subscribers
});
```

### Last Will and Testament

Set LWT when connecting:
```javascript
const client = mqtt.connect('mqtt://core-mqtt:1883', {
  will: {
    topic: 'kompose/service/status',
    payload: 'offline',
    qos: 1,
    retain: true
  }
});
```

### Bridge to External MQTT

Forward events to external broker:
```
# In mosquitto.conf
connection bridge-external
address external-broker.com:1883
topic kompose/# out 0
```

## See Also

- [Monitoring Guide](/guide/monitoring)
- [n8n Integration](/stacks/chain)
- [Service Development](/guide/development)
- [MQTT Documentation](https://mosquitto.org/documentation/)
