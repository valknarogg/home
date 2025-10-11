# Integration Setup Summary

## What Was Done

This document summarizes the integration setup between the **watch** monitoring stack and related Kompose services (Umami tracking, MQTT broker, and Home Assistant).

## 📋 Files Created

### 1. **INTEGRATION_GUIDE.md**
Comprehensive guide covering:
- Architecture overview with visual diagram
- Detailed integration status for each service
- Step-by-step setup instructions
- Configuration examples
- Troubleshooting section
- Security considerations

### 2. **INTEGRATION_QUICK_REF.md**
Quick reference document with:
- Integration map
- Action item checklist
- Service endpoints table
- Quick test commands
- Common operations
- Grafana setup guide

### 3. **verify-integration.sh**
Automated verification script that checks:
- All container health status
- Service endpoint availability
- Network connectivity
- Prometheus target status
- MQTT metrics
- Configuration issues

### 4. **setup-homeassistant.sh**
Interactive setup script for:
- Home Assistant token creation
- Prometheus configuration update
- Token verification
- Automatic Prometheus restart

## 🔗 Current Integration Status

### ✅ Fully Configured

1. **Core Services → Watch Stack**
   - PostgreSQL exporter: `watch_postgres_exporter:9187`
   - Redis exporter: `watch_redis_exporter:9121`
   - MQTT exporter: `watch_mqtt_exporter:9000`
   - All connected via `kompose_network`

2. **MQTT Integration**
   - OTEL Collector subscribes to MQTT topics:
     - `homeassistant/#`
     - `sensor/#`
     - `device/#`
     - `telemetry/#`
   - MQTT Exporter monitors all topics (`#`)
   - Connection: `core-mqtt:1883`

3. **Umami Monitoring**
   - Blackbox exporter monitors availability
   - HTTP health checks configured
   - Target: `http://track_app:3000`

### ⚠️ Requires Configuration

1. **Home Assistant Integration**
   - Prometheus scrape config present
   - **Action needed**: Create long-lived access token
   - **Tool**: Run `./setup-homeassistant.sh`

## 🚀 Quick Start

### Step 1: Make Scripts Executable
```bash
cd /home/valknar/Projects/kompose/+utilitiy/watch
chmod +x verify-integration.sh setup-homeassistant.sh
```

### Step 2: Verify Integration
```bash
./verify-integration.sh
```

This will check:
- All containers are running
- Services are reachable
- Network connectivity
- Prometheus targets
- Configuration issues

### Step 3: Setup Home Assistant (if needed)
```bash
./setup-homeassistant.sh
```

This interactive script will:
- Guide you through token creation
- Update Prometheus configuration
- Verify the token
- Restart Prometheus

### Step 4: Access Services

| Service | URL | Credentials |
|---------|-----|-------------|
| Prometheus | http://localhost:9090 | Basic auth (from .env) |
| Grafana | http://localhost:3001 | admin / (from .env) |
| Alertmanager | http://localhost:9093 | Basic auth (from .env) |

## 📊 Architecture Overview

```
Kompose Network (Bridge)
│
├─ Layer 0: CORE (Foundation Services)
│  ├─ core-postgres:5432     ──→ PostgreSQL Exporter (9187)
│  ├─ core-redis:6379        ──→ Redis Exporter (9121)
│  └─ core-mqtt:1883         ──→ MQTT Exporter (9000)
│                                 ↓
├─ Layer 1: HOME (Smart Home)     ↓
│  └─ home_homeassistant:8123 ────┴→ OTEL Collector (MQTT)
│                                     ↓
├─ Layer 1b: UTILITY (System Services)
│  ├─ track_app:3000 ────────────→ Blackbox Exporter
│  └─ WATCH Stack:
│     ├─ Prometheus:9090      ← Scrapes all exporters
│     ├─ Grafana:3000         ← Visualizes metrics
│     ├─ OTEL Collector       ← Processes telemetry
│     ├─ Alertmanager:9093    ← Routes alerts
│     └─ Various Exporters    ← Export metrics
│
└─ All services share kompose_network
```

## 🎯 What Each Service Monitors

### PostgreSQL Exporter
- Database health and performance
- Connection pool stats
- Query performance
- Replication status
- Database size and growth

### Redis Exporter
- Cache hit/miss rates
- Memory usage
- Connected clients
- Command statistics
- Keyspace information

### MQTT Exporter
- Published message counts
- Topic-level statistics
- Broker health
- Message rates

### OTEL Collector
- MQTT message telemetry
- Host metrics (CPU, memory, disk)
- Docker container stats
- Application traces (if configured)

### Blackbox Exporter
- HTTP/HTTPS endpoint availability
- Response times
- SSL certificate expiry
- DNS resolution

### Home Assistant
- Sensor data
- Entity states
- Automation triggers
- System health

### Umami
- Availability monitoring
- Response time
- (Custom metrics if extended)

## 📁 Important Configuration Files

```
+utilitiy/watch/
├── compose.yaml                    # Service definitions
├── .env                           # Environment variables
├── prometheus/
│   ├── prometheus.yml             # Scrape configs
│   └── rules/                     # Alert rules
├── otel-collector/
│   └── config.yaml                # OTEL pipeline
├── grafana/
│   ├── provisioning/              # Auto-provisioning
│   └── dashboards/                # Dashboard JSON
├── alertmanager/
│   └── alertmanager.yml           # Alert routing
├── INTEGRATION_GUIDE.md           # Detailed guide
├── INTEGRATION_QUICK_REF.md       # Quick reference
├── verify-integration.sh          # Verification script
└── setup-homeassistant.sh         # HA setup script
```

## 🔐 Security Checklist

- [ ] Change GRAFANA_ADMIN_PASSWORD in .env
- [ ] Change GRAFANA_DB_PASSWORD in .env
- [ ] Change POSTGRES_EXPORTER_PASSWORD in .env
- [ ] Change REDIS_EXPORTER_PASSWORD in .env
- [ ] Update PROMETHEUS_AUTH (htpasswd format)
- [ ] Update ALERTMANAGER_AUTH (htpasswd format)
- [ ] Secure Home Assistant access token
- [ ] Enable MQTT authentication (optional)
- [ ] Review Traefik SSL configuration

## 🎨 Grafana Dashboard IDs

Import these dashboards for instant visualizations:

| ID | Dashboard | Purpose |
|----|-----------|---------|
| 1860 | Node Exporter Full | System metrics |
| 3662 | Prometheus 2.0 Overview | Prometheus stats |
| 7362 | PostgreSQL Database | Database metrics |
| 763 | Redis Dashboard | Cache metrics |
| 13177 | Home Assistant | Smart home data |
| 13032 | MQTT Monitoring | MQTT broker stats |
| 893 | Docker Monitoring | Container metrics |

## 🔍 Useful Prometheus Queries

### System Health
```promql
# CPU usage
100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Memory usage
(node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100

# Disk usage
(node_filesystem_size_bytes - node_filesystem_free_bytes) / node_filesystem_size_bytes * 100
```

### Database Health
```promql
# PostgreSQL connections
pg_stat_database_numbackends

# Query duration
rate(pg_stat_statements_total_time_seconds[5m])
```

### Redis Metrics
```promql
# Cache hit rate
rate(redis_keyspace_hits_total[5m]) / (rate(redis_keyspace_hits_total[5m]) + rate(redis_keyspace_misses_total[5m]))

# Memory usage
redis_memory_used_bytes / redis_memory_max_bytes * 100
```

### MQTT Metrics
```promql
# Message rate
rate(mqtt_message_count[5m])

# Topics
mqtt_topic_messages_total
```

### Home Assistant
```promql
# Temperature sensors
homeassistant_sensor_temperature_celsius

# Entity states
homeassistant_entity_available
```

## 📞 Support & Documentation

For detailed information, refer to:

1. **INTEGRATION_GUIDE.md** - Comprehensive setup and troubleshooting
2. **INTEGRATION_QUICK_REF.md** - Quick commands and checklists
3. **Main Kompose Documentation** - `/home/valknar/Projects/kompose/README.md`

## 🐛 Common Issues

### Prometheus targets down
```bash
# Check container health
docker compose ps

# Check logs
docker logs watch_prometheus

# Verify network
docker network inspect kompose
```

### MQTT not connecting
```bash
# Test MQTT broker
docker exec core-mqtt mosquitto_sub -t '#' -v -C 1

# Check exporter
docker logs watch_mqtt_exporter
```

### Home Assistant metrics missing
```bash
# Verify token
curl -H "Authorization: Bearer YOUR_TOKEN" http://home_homeassistant:8123/api/prometheus

# Check HA integration
# Go to HA UI → Settings → Integrations → Search "Prometheus"
```

## ✨ Next Steps

1. **Run verification script** to check current status
2. **Configure Home Assistant** token if needed
3. **Import Grafana dashboards** for visualization
4. **Set up alert rules** in Prometheus
5. **Configure Alertmanager** notifications (email, Slack, etc.)
6. **Review and update** default passwords
7. **Enable MQTT authentication** for production

## 📝 Changelog

- **2025-10-11**: Initial integration setup
  - Created integration guide
  - Added verification script
  - Configured Home Assistant setup script
  - Documented all connections
  - Added quick reference guide

---

**Integration Status**: ✅ Connections configured | ⚠️ Home Assistant token required | 🔧 Ready for use
