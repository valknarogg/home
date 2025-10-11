# Kompose Complete Integration Guide

## 🎯 Overview

This integration implementation connects all Kompose utility services with the core infrastructure, creating a unified, monitored, and secure service ecosystem.

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                     INTEGRATION LAYER                           │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐            │
│  │    MQTT     │  │   Redis     │  │     SSO     │            │
│  │  Events     │  │   Cache     │  │  Keycloak   │            │
│  └─────────────┘  └─────────────┘  └─────────────┘            │
└─────────────────────────────────────────────────────────────────┘
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
┌───────▼────────┐  ┌──────▼──────┐  ┌──────▼──────┐
│   Linkwarden   │  │ Letterpress │  │    Umami    │
│   +Metrics     │  │  +Metrics   │  │  +Metrics   │
│   +MQTT Pub    │  │  +MQTT Pub  │  │  +MQTT Pub  │
│   +Redis       │  │  +Redis     │  │  +Redis     │
│   +SSO Auth    │  │  +SSO Auth  │  │  +SSO Auth  │
└────────────────┘  └─────────────┘  └─────────────┘
        │                  │                  │
        └──────────────────┼──────────────────┘
                           │
                    ┌──────▼──────┐
                    │  Prometheus │
                    │   Grafana   │
                    │   Alerts    │
                    └─────────────┘
```

## 🚀 Quick Start

### Step 1: Preparation

```bash
# Navigate to integration directory
cd /home/valknar/Projects/kompose/INTEGRATION

# Make scripts executable
chmod +x scripts/*.sh

# Review what will be changed (dry run)
./scripts/apply-integration.sh all --dry-run
```

### Step 2: Backup

```bash
# Create backups of all services (automatic with apply script)
# Manual backup:
for service in link news track vault; do
    cp +utility/$service/compose.yaml +utility/$service/compose.yaml.backup
    cp +utility/$service/.env +utility/$service/.env.backup
done
```

### Step 3: Apply Integration

```bash
# Apply to all services
./scripts/apply-integration.sh all

# Or apply to specific services
./scripts/apply-integration.sh link
./scripts/apply-integration.sh news
./scripts/apply-integration.sh track
./scripts/apply-integration.sh vault
./scripts/apply-integration.sh watch
```

### Step 4: Configure Secrets

Add required secrets to your root `secrets.env`:

```bash
# MQTT (if authentication enabled)
MQTT_USERNAME=kompose
MQTT_PASSWORD=<generate-with-openssl-rand-base64-32>

# Redis
REDIS_PASSWORD=<generate-with-openssl-rand-base64-32>

# Gotify (for alerts)
GOTIFY_APP_TOKEN=<create-in-gotify-ui>

# Service-specific
LINK_NEXTAUTH_SECRET=<generate-with-openssl-rand-base64-32>
NEWS_JWT_SECRET=<generate-with-openssl-rand-base64-32>
TRACK_APP_SECRET=<generate-with-openssl-rand-base64-32>
VAULT_JWT_TOKEN=<generate-with-openssl-rand-base64-32>
```

### Step 5: Deploy Updated Services

```bash
# Using kompose.sh
cd /home/valknar/Projects/kompose
./kompose.sh restart link
./kompose.sh restart news
./kompose.sh restart track
./kompose.sh restart vault
./kompose.sh restart watch

# Or manually with docker compose
cd +utility/link && docker compose up -d
cd +utility/news && docker compose up -d
cd +utility/track && docker compose up -d
cd +utility/vault && docker compose up -d
cd +utility/watch && docker compose up -d
```

### Step 6: Verify Integration

```bash
cd /home/valknar/Projects/kompose/INTEGRATION
./scripts/verify-integration.sh all
```

## 📋 Feature Checklist

### ✅ Linkwarden Integration
- [x] SSO authentication
- [x] Redis caching
- [x] MQTT event publishing
- [x] Prometheus metrics
- [x] Email via Mailhog
- [x] Health checks
- [x] Security headers

### ✅ Letterpress Integration
- [x] SSO authentication
- [x] Redis session management
- [x] MQTT article events
- [x] Prometheus metrics
- [x] Email campaigns
- [x] Health checks

### ✅ Umami Integration
- [x] SSO for admin interface
- [x] Redis query caching
- [x] MQTT analytics events
- [x] Prometheus metrics
- [x] CORS configuration
- [x] Health checks

### ✅ Vaultwarden Integration
- [x] Dual authentication (SSO + master password)
- [x] MQTT security events
- [x] Prometheus metrics
- [x] Email notifications
- [x] Rate limiting
- [x] Health checks
- [x] Security monitoring

### ✅ Watch Stack Integration
- [x] Complete monitoring setup
- [x] Prometheus with all exporters
- [x] Grafana dashboards
- [x] Alertmanager → Gotify
- [x] MQTT broker monitoring
- [x] Database monitoring
- [x] Container metrics

## 🔧 Configuration Details

### MQTT Event Publishing

Each service publishes events to specific topics:

```
kompose/
├── linkwarden/
│   ├── bookmark/added
│   ├── bookmark/updated
│   └── stats/daily
├── news/
│   ├── article/published
│   └── newsletter/sent
├── analytics/
│   ├── pageview
│   └── event
└── vault/
    ├── security/login
    └── security/failed
```

See `mqtt/EVENT_SCHEMAS.md` for complete event documentation.

### Redis Caching

**Linkwarden:**
- Frequently accessed bookmarks
- Tag clouds
- Collection metadata

**Letterpress:**
- Session data
- Article cache
- Template cache

**Umami:**
- Query results
- Aggregated statistics
- Visitor sessions

### Prometheus Metrics

All services expose metrics on specific endpoints:

| Service     | Port | Path       | Metrics                                    |
|-------------|------|------------|--------------------------------------------|
| Linkwarden  | 9100 | /metrics   | Bookmark counts, user activity             |
| Letterpress | 9090 | /metrics   | Article stats, email campaigns             |
| Umami       | 3000 | /api/metrics | Pageviews, visitors, events              |
| Vaultwarden | 80   | /metrics   | Login attempts, vault access               |
| PostgreSQL  | 9187 | /metrics   | DB connections, query performance          |
| Redis       | 9121 | /metrics   | Cache hits/misses, memory usage            |
| MQTT        | 9000 | /metrics   | Messages sent/received, client connections |

### Grafana Dashboards

Pre-configured dashboards:

1. **System Overview** - All services status, resource usage
2. **Database Performance** - PostgreSQL metrics and queries
3. **Cache Analytics** - Redis performance and hit rates
4. **MQTT Statistics** - Message broker activity
5. **Service Health** - Uptime and health checks
6. **Security Events** - Authentication and access logs

Import from: `monitoring/grafana-*.json`

### Alert Rules

Configured alerts (see `monitoring/alerts.yml`):

**Critical Alerts:**
- Service down (2 min)
- PostgreSQL unavailable
- Vaultwarden down
- Disk space < 5%
- SSL certificate expired

**Warning Alerts:**
- High CPU usage (>80% for 10 min)
- High memory usage (>90% for 5 min)
- Database connection pool full
- Redis high eviction rate
- Failed login attempts

**All alerts route to Gotify for push notifications**

## 🔐 SSO Integration

### Enabling SSO

SSO is enabled by default in the enhanced compose files. Users must:

1. Authenticate via Keycloak (SSO layer)
2. Access the service

For Vaultwarden, users also need their master password to unlock vaults.

### Keycloak Configuration

Create service accounts in Keycloak:

```bash
# Access Keycloak admin
https://auth.yourdomain.com

# For each service, create:
# - Client ID: service-name (e.g., linkwarden)
# - Client Type: confidential
# - Valid Redirect URIs: https://service.yourdomain.com/*
# - Scopes: openid, profile, email
```

### Public Endpoints

Some endpoints should remain public (e.g., Umami tracking):

```yaml
# In OAuth2 Proxy configuration
environment:
  OAUTH2_PROXY_SKIP_AUTH_ROUTES: "^/api/collect"  # Umami tracking
```

## 📊 Monitoring Integration

### Accessing Dashboards

```bash
# Prometheus
http://localhost:9090
https://prometheus.yourdomain.com

# Grafana
http://localhost:3001
https://grafana.yourdomain.com
Username: admin
Password: <from GRAFANA_ADMIN_PASSWORD>

# Alertmanager
http://localhost:9093
https://alerts.yourdomain.com
```

### Custom Metrics

Add custom metrics to services:

```javascript
// Example: Node.js with prom-client
const prometheus = require('prom-client');

const bookmarkCounter = new prometheus.Counter({
  name: 'linkwarden_bookmarks_total',
  help: 'Total number of bookmarks created',
  labelNames: ['collection', 'user']
});

// Increment when bookmark created
bookmarkCounter.inc({ collection: 'Tech', user: 'user@example.com' });

// Expose metrics endpoint
app.get('/metrics', async (req, res) => {
  res.set('Content-Type', prometheus.register.contentType);
  res.end(await prometheus.register.metrics());
});
```

### Alert Testing

Test alert delivery:

```bash
# Trigger a test alert
curl -X POST http://localhost:9093/api/v1/alerts \
  -H 'Content-Type: application/json' \
  -d '[{
    "labels": {
      "alertname": "TestAlert",
      "severity": "warning"
    },
    "annotations": {
      "summary": "This is a test alert"
    }
  }]'
```

## 🔄 MQTT Integration

### Testing MQTT Events

```bash
# Subscribe to all events
mosquitto_sub -h core-mqtt -t "kompose/#" -v

# Publish test event
mosquitto_pub -h core-mqtt \
  -t "kompose/test" \
  -m '{"test": true, "timestamp": "'$(date -Iseconds)'"}'
```

### Creating Automations

Example: New article → Create bookmark

```javascript
const mqtt = require('mqtt');
const client = mqtt.connect('mqtt://core-mqtt:1883');

// Subscribe to article publishing events
client.subscribe('kompose/news/article/published');

client.on('message', async (topic, message) => {
  const article = JSON.parse(message.toString());
  
  // Automatically bookmark new articles
  await linkwardenAPI.createBookmark({
    url: article.data.published_url,
    title: article.data.title,
    collection: 'Published Articles',
    tags: article.data.tags
  });
});
```

## 🛠️ Troubleshooting

### Service Won't Start

```bash
# Check logs
docker compose -f +utility/service/compose.yaml logs -f

# Check dependencies
docker ps | grep -E "core-postgres|core-redis|core-mqtt"

# Verify environment variables
docker compose -f +utility/service/compose.yaml config
```

### Metrics Not Appearing

```bash
# Check if Prometheus can reach the target
curl -f http://service_container:port/metrics

# Check Prometheus targets
curl http://localhost:9090/api/v1/targets | jq '.data.activeTargets'

# Verify service labels
docker inspect service_container | grep prometheus
```

### MQTT Events Not Publishing

```bash
# Check MQTT broker
docker exec core-mqtt mosquitto_sub -t '$SYS/#' -C 5

# Test publishing
docker exec core-mqtt mosquitto_pub -t "test" -m "hello"

# Check service MQTT configuration
docker exec service_container env | grep MQTT
```

### Alerts Not Delivered

```bash
# Check Alertmanager status
curl http://localhost:9093/api/v1/status

# Check Gotify connectivity
curl http://messaging_gotify/health

# Test webhook manually
curl -X POST "http://messaging_gotify/message?token=TOKEN" \
  -F "title=Test" \
  -F "message=Test alert"
```

## 📚 Additional Resources

- **MQTT Events**: See `mqtt/EVENT_SCHEMAS.md`
- **Monitoring**: See `monitoring/README.md`
- **Service Configs**: See `compose/*.yaml`
- **Main Integration Analysis**: See `../INTEGRATION_ANALYSIS.md`

## 🔄 Rollback

If you need to revert:

```bash
# Restore from backup
for service in link news track vault; do
    cp +utility/$service/compose.yaml.backup +utility/$service/compose.yaml
    cp +utility/$service/.env.backup +utility/$service/.env
done

# Restart services
./kompose.sh restart all
```

## 📝 Maintenance

### Regular Tasks

**Daily:**
- Review Grafana dashboards
- Check alert notifications

**Weekly:**
- Review MQTT message statistics
- Check database size and growth
- Verify backup completion

**Monthly:**
- Update Grafana dashboards
- Review and tune alert thresholds
- Clean up old metrics data
- Review SSL certificate expiry

### Updates

When updating services:

1. Review integration changes
2. Update enhanced compose files if needed
3. Test in development first
4. Apply with `apply-integration.sh`
5. Verify with `verify-integration.sh`

---

**Last Updated**: October 2025  
**Integration Version**: 1.0.0  
**Status**: Production Ready
