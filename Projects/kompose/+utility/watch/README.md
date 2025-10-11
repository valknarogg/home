# Watch Stack - Monitoring & Observability

> Comprehensive monitoring and observability solution for Kompose.sh

## 📋 Table of Contents

1. [Overview](#overview)
2. [Quick Start](#quick-start)
3. [Integration Status](#integration-status)
4. [Documentation](#documentation)
5. [Architecture](#architecture)
6. [Services](#services)
7. [Setup](#setup)
8. [Verification](#verification)
9. [Troubleshooting](#troubleshooting)
10. [Security](#security)

## Overview

The **Watch Stack** provides complete monitoring and observability for all Kompose services. It integrates with:

- **Core Services** (Layer 0): PostgreSQL, Redis, MQTT
- **Utility Services** (Layer 1b): Umami web analytics
- **Home Services** (Layer 1): Home Assistant smart home platform

### What's Monitored

```
✓ System Resources      (CPU, Memory, Disk, Network)
✓ Docker Containers     (Resource usage, Health)
✓ PostgreSQL            (Connections, Queries, Performance)
✓ Redis                 (Cache stats, Memory, Commands)
✓ MQTT Broker           (Messages, Topics, Connections)
✓ Home Assistant        (Sensors, States, Events)
✓ Umami Analytics       (Availability, Response time)
✓ Service Endpoints     (HTTP/HTTPS health checks)
✓ Centralized Logs      (All container logs via Loki)
```

## Quick Start

### 1. Start the Watch Stack

```bash
cd /home/valknar/Projects/kompose/+utilitiy/watch
docker compose up -d
```

### 2. Verify Integration

```bash
# Make script executable
chmod +x verify-integration.sh

# Run verification
./verify-integration.sh
```

### 3. Configure Home Assistant (Required)

```bash
# Make script executable
chmod +x setup-homeassistant.sh

# Run interactive setup
./setup-homeassistant.sh
```

### 4. Access Services

| Service | URL | Credentials |
|---------|-----|-------------|
| **Prometheus** | http://localhost:9090 | Basic Auth (see .env) |
| **Grafana** | http://localhost:3001 | admin / (see .env) |
| **Alertmanager** | http://localhost:9093 | Basic Auth (see .env) |
| **Loki** | http://localhost:3100 | Basic Auth (see .env) |

## Integration Status

### ✅ Fully Integrated

- [x] PostgreSQL monitoring via exporter
- [x] Redis monitoring via exporter
- [x] MQTT monitoring via exporter
- [x] MQTT telemetry via OTEL Collector
- [x] Umami availability monitoring
- [x] Container monitoring (cAdvisor)
- [x] System monitoring (Node Exporter)
- [x] Network connectivity (shared kompose_network)

### ⚠️ Configuration Required

- [ ] **Home Assistant access token** (use `./setup-homeassistant.sh`)
- [ ] Grafana dashboard imports
- [ ] Alert notification configuration
- [ ] Default password changes

## Documentation

### Primary Guides

1. **[INTEGRATION_GUIDE.md](./INTEGRATION_GUIDE.md)**
   - Complete setup instructions
   - Detailed configuration examples
   - Troubleshooting guide
   - Security considerations

2. **[INTEGRATION_QUICK_REF.md](./INTEGRATION_QUICK_REF.md)**
   - Quick command reference
   - Action item checklist
   - Common operations
   - Grafana setup

3. **[ARCHITECTURE.md](./ARCHITECTURE.md)**
   - Visual architecture diagrams
   - Data flow diagrams
   - Network topology
   - Port mappings

4. **[SETUP_SUMMARY.md](./SETUP_SUMMARY.md)**
   - What was configured
   - Files created
   - Next steps
   - Useful queries

5. **[LOGGING_GUIDE.md](./LOGGING_GUIDE.md)**
   - Unified logging with Loki
   - LogQL query examples
   - Log collection architecture
   - Troubleshooting logs

6. **[LOKI_SETUP_COMPLETE.md](./LOKI_SETUP_COMPLETE.md)**
   - Loki integration summary
   - Quick start guide
   - Configuration details

### Scripts

1. **`verify-integration.sh`** - Automated verification of all integrations
2. **`setup-homeassistant.sh`** - Interactive Home Assistant token setup

## Architecture

### High-Level Overview

```
┌─────────────────────────────────────────────────────┐
│              Kompose Network                        │
├─────────────────────────────────────────────────────┤
│                                                     │
│  ┌──────────┐     ┌───────────┐     ┌──────────┐ │
│  │   CORE   │────▶│   WATCH   │◀────│   HOME   │ │
│  │ Layer 0  │     │ Layer 1b  │     │ Layer 1  │ │
│  └──────────┘     └───────────┘     └──────────┘ │
│       │                  │                 │       │
│   PostgreSQL        Prometheus      Home Assistant│
│   Redis             Grafana                        │
│   MQTT              OTEL                           │
│                     Exporters                      │
│                                                     │
│  ┌──────────┐                                     │
│  │  TRACK   │─────▶ Blackbox Exporter            │
│  │ (Umami)  │       (Availability)                │
│  └──────────┘                                     │
│                                                     │
└─────────────────────────────────────────────────────┘
```

See [ARCHITECTURE.md](./ARCHITECTURE.md) for detailed diagrams.

## Services

### Core Monitoring Stack

| Service | Port | Purpose |
|---------|------|---------|
| **Loki** | 3100 | Log aggregation and storage |
| **Promtail** | 9080 | Log collection agent |
| **Prometheus** | 9090 | Metrics collection and storage |
| **Grafana** | 3001 | Metrics visualization |
| **OTEL Collector** | 4317/4318 | Telemetry pipeline (traces, metrics, logs) |
| **Alertmanager** | 9093 | Alert routing and notification |

### Exporters

| Exporter | Port | Monitors |
|----------|------|----------|
| **PostgreSQL** | 9187 | Core PostgreSQL database |
| **Redis** | 9121 | Core Redis cache |
| **MQTT** | 9000 | Core Mosquitto broker |
| **cAdvisor** | 8082 | Docker containers |
| **Node Exporter** | 9100 | Host system metrics |
| **Blackbox** | 9115 | HTTP/HTTPS endpoints |

### Integration Targets

| Target | Port | Connection |
|--------|------|------------|
| **PostgreSQL** | 5432 | core-postgres (via exporter) |
| **Redis** | 6379 | core-redis (via exporter) |
| **MQTT** | 1883 | core-mqtt (via exporter + OTEL) |
| **Home Assistant** | 8123 | home_homeassistant (via API) |
| **Umami** | 3000 | track_app (via blackbox) |

## Setup

### Prerequisites

- Docker and Docker Compose installed
- Core stack running (`core` directory)
- Kompose network created (`docker network create kompose`)
- (Optional) Home Assistant running for HA integration
- (Optional) Umami running for analytics monitoring

### Initial Configuration

1. **Environment Variables**

   Edit `.env` file and update:
   ```bash
   # Change these passwords!
   GRAFANA_ADMIN_PASSWORD=your_secure_password
   GRAFANA_DB_PASSWORD=your_secure_password
   POSTGRES_EXPORTER_PASSWORD=your_secure_password
   REDIS_EXPORTER_PASSWORD=your_secure_password
   
   # Update authentication (generate with htpasswd)
   PROMETHEUS_AUTH=admin:$$apr1$$...
   ALERTMANAGER_AUTH=admin:$$apr1$$...
   ```

2. **Home Assistant Integration**

   Run the setup script:
   ```bash
   ./setup-homeassistant.sh
   ```
   
   Or manually:
   - Create long-lived token in Home Assistant
   - Update `prometheus/prometheus.yml`:
     ```yaml
     bearer_token: 'YOUR_TOKEN_HERE'
     ```
   - Restart Prometheus

3. **Start Services**

   ```bash
   docker compose up -d
   ```

4. **Verify Setup**

   ```bash
   ./verify-integration.sh
   ```

### Grafana Configuration

1. **Access Grafana**: http://localhost:3001
2. **Login**: admin / (password from .env)
3. **Add Data Source**:
   - Configuration → Data Sources → Add
   - Select: Prometheus
   - URL: `http://watch_prometheus:9090`
   - Save & Test

4. **Import Dashboards**:
   - Dashboards → Import
   - Enter Dashboard ID (see below)
   - Select Prometheus data source

   **Recommended Dashboards:**
   - 1860: Node Exporter Full
   - 3662: Prometheus 2.0 Overview
   - 7362: PostgreSQL Database
   - 763: Redis Dashboard
   - 13177: Home Assistant
   - 13032: MQTT Monitoring
   - 893: Docker Monitoring

## Verification

### Quick Health Check

```bash
# All services running
docker compose ps

# Prometheus targets
curl http://localhost:9090/api/v1/targets | jq '.data.activeTargets[].health'

# PostgreSQL metrics
curl http://localhost:9187/metrics | grep pg_up

# Redis metrics
curl http://localhost:9121/metrics | grep redis_up

# MQTT metrics
curl http://localhost:9000/metrics | grep mqtt_
```

### Automated Verification

```bash
./verify-integration.sh
```

This checks:
- Container health status
- Service endpoints
- Network connectivity
- Prometheus targets
- Configuration issues

## Troubleshooting

### Common Issues

#### 1. Prometheus Targets Down

**Symptom**: Targets show as "DOWN" in Prometheus UI

**Solutions**:
```bash
# Check if target container is running
docker compose ps

# Check target logs
docker logs [container_name]

# Test connectivity
docker exec watch_prometheus ping -c 3 [target_container]

# Check Prometheus config
docker exec watch_prometheus cat /etc/prometheus/prometheus.yml
```

#### 2. Grafana Can't Connect to Prometheus

**Symptom**: "Bad Gateway" or connection errors

**Solutions**:
```bash
# Verify Prometheus is running
docker compose ps prometheus

# Check Prometheus health
curl http://localhost:9090/-/healthy

# Restart Grafana
docker compose restart grafana
```

#### 3. MQTT Metrics Missing

**Symptom**: No MQTT metrics in Prometheus

**Solutions**:
```bash
# Check MQTT broker
docker exec core-mqtt mosquitto_sub -t '#' -v -C 1

# Check MQTT exporter
docker logs watch_mqtt_exporter

# Test exporter endpoint
curl http://localhost:9000/metrics
```

#### 4. Home Assistant Integration Not Working

**Symptom**: HA target down or no metrics

**Solutions**:
```bash
# Verify token
curl -H "Authorization: Bearer YOUR_TOKEN" \
  http://home_homeassistant:8123/api/prometheus

# Check HA Prometheus integration is enabled
# In HA UI: Settings → Integrations → Search "Prometheus"

# Re-run setup
./setup-homeassistant.sh
```

### View Logs

```bash
# All services
docker compose logs

# Specific service
docker compose logs -f prometheus
docker compose logs -f grafana
docker compose logs -f otel-collector

# Tail logs
docker compose logs -f --tail=100
```

## Security

### Default Passwords

**⚠️ IMPORTANT**: Change all default passwords in `.env`:

- `GRAFANA_ADMIN_PASSWORD`
- `GRAFANA_DB_PASSWORD`
- `POSTGRES_EXPORTER_PASSWORD`
- `REDIS_EXPORTER_PASSWORD`
- `PROMETHEUS_AUTH` (htpasswd format)
- `ALERTMANAGER_AUTH` (htpasswd format)

### Generate htpasswd Authentication

```bash
# Install htpasswd
sudo apt install apache2-utils

# Generate password (replace admin and your_password)
echo $(htpasswd -nb admin your_password) | sed -e s/\\$/\\$\\$/g
```

### Best Practices

1. **Use strong passwords** for all services
2. **Secure Home Assistant token** - treat as secret
3. **Enable MQTT authentication** for production
4. **Use Traefik with SSL** for external access
5. **Review firewall rules** for exposed ports
6. **Regular backup** of Prometheus data
7. **Monitor alert configurations** for sensitive data

### Network Security

All services communicate via the internal `kompose_network`. Only the following ports are exposed to the host:

- Prometheus: 9090
- Grafana: 3001
- OTEL Collector: 4317, 4318
- Alertmanager: 9093
- Various exporters: 9000, 9121, 9187, etc.

Configure Traefik for external access with SSL/TLS.

## Useful Commands

### Service Management

```bash
# Start all services
docker compose up -d

# Stop all services
docker compose down

# Restart specific service
docker compose restart prometheus

# View status
docker compose ps

# Scale service (if applicable)
docker compose up -d --scale cadvisor=2
```

### Configuration Reload

```bash
# Reload Prometheus config (without restart)
curl -X POST http://localhost:9090/-/reload

# Restart for other config changes
docker compose restart [service]
```

### Data Management

```bash
# Backup Prometheus data
docker run --rm -v watch_prometheus_data:/data \
  -v $(pwd):/backup alpine \
  tar czf /backup/prometheus-backup.tar.gz /data

# Backup Grafana data
docker run --rm -v watch_grafana_data:/data \
  -v $(pwd):/backup alpine \
  tar czf /backup/grafana-backup.tar.gz /data
```

### Cleanup

```bash
# Remove containers (keeps volumes)
docker compose down

# Remove containers and volumes
docker compose down -v

# Prune old data
docker system prune -a
```

## Prometheus Queries

### System Metrics

```promql
# CPU usage
100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Memory usage percentage
(node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100

# Disk usage
(node_filesystem_size_bytes - node_filesystem_free_bytes) / node_filesystem_size_bytes * 100
```

### Database Metrics

```promql
# PostgreSQL active connections
pg_stat_database_numbackends

# Redis cache hit rate
rate(redis_keyspace_hits_total[5m]) / (rate(redis_keyspace_hits_total[5m]) + rate(redis_keyspace_misses_total[5m]))
```

### MQTT Metrics

```promql
# Message rate
rate(mqtt_message_count[5m])

# Topic message count
mqtt_topic_messages_total
```

### Home Assistant

```promql
# Temperature sensors
homeassistant_sensor_temperature_celsius

# Entity availability
homeassistant_entity_available == 1
```

## Support & Resources

### Documentation

- [Integration Guide](./INTEGRATION_GUIDE.md) - Complete setup guide
- [Quick Reference](./INTEGRATION_QUICK_REF.md) - Commands and checklists
- [Architecture](./ARCHITECTURE.md) - Visual diagrams
- [Setup Summary](./SETUP_SUMMARY.md) - What's configured

### External Resources

- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)
- [OTEL Collector Docs](https://opentelemetry.io/docs/collector/)
- [Home Assistant Prometheus](https://www.home-assistant.io/integrations/prometheus/)

### Community

- Main Kompose documentation: `/home/valknar/Projects/kompose/README.md`
- Core stack README: `/home/valknar/Projects/kompose/core/README.md`
- Home stack README: `/home/valknar/Projects/kompose/home/README.md`

---

## Summary

The Watch Stack provides comprehensive monitoring for all Kompose services through:

✅ **Metrics Collection**: Prometheus scrapes metrics from all services  
✅ **Visualization**: Grafana displays metrics through customizable dashboards  
✅ **Telemetry**: OTEL Collector processes traces, metrics, and logs  
✅ **Alerting**: Alertmanager routes and manages alerts  
✅ **Integration**: Connects to Core, Home, and Utility services  

**Status**: Fully configured | Home Assistant token required | Ready for production

For any issues, run `./verify-integration.sh` to diagnose problems.
