# Kompose Integration Implementation

This directory contains the complete integration implementation for the kompose.sh service network.

## 📁 Directory Structure

```
INTEGRATION/
├── compose/              # Enhanced compose.yaml files with integrations
│   ├── link/            # Linkwarden integrations
│   ├── news/            # Letterpress integrations
│   ├── track/           # Umami integrations
│   ├── vault/           # Vaultwarden integrations
│   └── watch/           # Enhanced monitoring stack
├── monitoring/          # Prometheus, Grafana, and monitoring configs
│   ├── prometheus/      # Prometheus scrape configs and rules
│   ├── grafana/         # Grafana dashboards
│   └── alertmanager/    # Alert routing and receivers
├── mqtt/                # MQTT topic schemas and integration
├── middleware/          # Traefik middleware configurations
├── scripts/             # Integration helper scripts
└── docs/                # Integration documentation

```

## 🚀 Quick Start

### Step 1: Backup Current Configurations
```bash
./scripts/backup-current.sh
```

### Step 2: Apply Integrations
```bash
# Apply all integrations at once
./scripts/apply-all.sh

# Or apply selectively
./scripts/apply-integration.sh link      # Linkwarden
./scripts/apply-integration.sh news      # Letterpress
./scripts/apply-integration.sh track     # Umami
./scripts/apply-integration.sh vault     # Vaultwarden
./scripts/apply-integration.sh watch     # Monitoring stack
```

### Step 3: Verify Integration
```bash
./scripts/verify-integration.sh
```

## 🔧 Integration Features

### All Services
- ✅ SSO authentication via Keycloak
- ✅ Prometheus metrics endpoints
- ✅ Grafana dashboards
- ✅ Health check monitoring
- ✅ Security headers and compression
- ✅ Rate limiting (where applicable)

### Service-Specific

#### Linkwarden
- Redis caching for performance
- MQTT event publishing (new bookmarks)
- Email notifications via Mailhog
- PostgreSQL monitoring

#### Letterpress/News
- Redis session management
- MQTT article publishing events
- Email campaign tracking
- Content analytics integration

#### Umami
- Redis query caching
- MQTT real-time analytics events
- Cross-service tracking integration
- Custom metrics export

#### Vaultwarden
- Dual authentication (SSO + master password)
- Security event publishing via MQTT
- Email notifications
- Failed login monitoring

#### Watch Stack
- Complete observability platform
- All service monitoring
- MQTT broker metrics
- Cross-stack alerting
- Gotify notification integration

## 📊 Monitoring Dashboards

All Grafana dashboards are pre-configured in `monitoring/grafana/dashboards/`:

1. **System Overview** - All services at a glance
2. **Database Performance** - PostgreSQL metrics
3. **Cache Performance** - Redis metrics
4. **MQTT Broker** - Message broker statistics
5. **Service Health** - Uptime and health checks
6. **Linkwarden Analytics** - Bookmark usage
7. **Umami Analytics** - Web analytics overview
8. **Security Events** - Vaultwarden and auth monitoring

## 🔔 Alerting

Alerts are configured in `monitoring/alertmanager/`:

- Service down alerts
- High resource usage
- Database connection issues
- Failed authentication attempts
- MQTT broker offline
- SSL certificate expiry

All alerts route to **Gotify** for push notifications.

## 📡 MQTT Event Schema

Complete event schemas in `mqtt/schemas/`:

- Linkwarden: bookmark events
- Letterpress: article publishing
- Umami: analytics events
- Vaultwarden: security events
- System: health and status events

## 🔐 Security Enhancements

- SSO middleware on all user-facing services
- Rate limiting on public endpoints
- Security headers (HSTS, CSP, etc.)
- IP restrictions for admin interfaces
- Automated SSL/TLS via Let's Encrypt

## 🔄 Rollback

If you need to rollback:

```bash
./scripts/rollback.sh
```

This restores configurations from the backup created in Step 1.

## 📝 Manual Integration Steps

Some integrations require manual configuration:

1. **Keycloak**: Create service accounts for each utility service
2. **Grafana**: Import dashboards (auto-provisioned)
3. **MQTT**: Subscribe to event topics for automation

See `docs/MANUAL_STEPS.md` for details.

## 🧪 Testing

```bash
# Test SSO on all services
./scripts/test-sso.sh

# Test MQTT event publishing
./scripts/test-mqtt.sh

# Test monitoring endpoints
./scripts/test-monitoring.sh

# Test alerts
./scripts/test-alerts.sh
```

## 📚 Documentation

- `docs/INTEGRATION_GUIDE.md` - Detailed integration guide
- `docs/MQTT_EVENTS.md` - MQTT event documentation
- `docs/MONITORING.md` - Monitoring setup guide
- `docs/TROUBLESHOOTING.md` - Common issues and solutions

---

**Implementation Date**: October 2025
**Status**: Ready for deployment
**Kompose Version**: Latest
