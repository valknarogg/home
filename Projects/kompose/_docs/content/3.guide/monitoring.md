# Monitoring Guide

Complete guide for monitoring your Kompose infrastructure with Prometheus, Grafana, and Alertmanager.

## Overview

The Kompose monitoring stack provides:
- **Prometheus** - Metrics collection and storage
- **Grafana** - Visualization dashboards
- **Alertmanager** - Alert routing and notifications
- **Exporters** - System and service metrics

## Quick Start

### 1. Deploy Monitoring Stack

```bash
./kompose.sh up watch
```

This starts:
- Prometheus (metrics database)
- Grafana (dashboards)
- Alertmanager (alerts)
- Various exporters (PostgreSQL, Redis, MQTT, Node, cAdvisor)

### 2. Access Dashboards

**Prometheus:**
- URL: `http://localhost:9090` or `https://prometheus.yourdomain.com`
- Features: Metrics browser, query interface, targets status

**Grafana:**
- URL: `http://localhost:3001` or `https://grafana.yourdomain.com`
- Username: `admin`
- Password: Check `+utility/watch/.env` → `GRAFANA_ADMIN_PASSWORD`

**Alertmanager:**
- URL: `http://localhost:9093` or `https://alerts.yourdomain.com`
- Features: Active alerts, silences, alert routing

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Service Metrics                       │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌─────────┐ │
│  │PostgreSQL│  │  Redis   │  │   MQTT   │  │  Node   │ │
│  │ :9187    │  │  :9121   │  │  :9000   │  │  :9100  │ │
│  └──────────┘  └──────────┘  └──────────┘  └─────────┘ │
└─────────────────────┬───────────────────────────────────┘
                      │ Scrape metrics every 15s
              ┌───────▼────────┐
              │   Prometheus   │
              │     :9090      │
              └───────┬────────┘
                      │ Query metrics
         ┌────────────┼────────────┐
         │                         │
    ┌────▼─────┐            ┌─────▼──────┐
    │ Grafana  │            │Alertmanager│
    │  :3001   │            │   :9093    │
    └──────────┘            └─────┬──────┘
                                  │ Send alerts
                            ┌─────▼──────┐
                            │   Gotify   │
                            │ Push Notif │
                            └────────────┘
```

## Monitoring Features

### Service Metrics

All Kompose services expose Prometheus metrics:

| Service | Port | Path | Metrics |
|---------|------|------|---------|
| Linkwarden | 9100 | /metrics | Bookmark counts, user activity |
| Letterpress | 9090 | /metrics | Article stats, campaigns |
| Umami | 3000 | /api/metrics | Pageviews, visitors, events |
| Vaultwarden | 80 | /metrics | Login attempts, vault access |
| PostgreSQL | 9187 | /metrics | DB connections, queries |
| Redis | 9121 | /metrics | Cache hits/misses, memory |
| MQTT | 9000 | /metrics | Messages, clients |
| Node | 9100 | /metrics | CPU, memory, disk, network |
| Containers | 8080 | /metrics | Docker container stats |

### Pre-configured Dashboards

Located in `+utility/watch/grafana/dashboards/`:

1. **System Overview** - All services at a glance
2. **Database Performance** - PostgreSQL metrics
3. **Cache Performance** - Redis statistics
4. **MQTT Broker** - Message broker metrics
5. **Service Health** - Uptime and health checks
6. **Linkwarden Analytics** - Bookmark usage
7. **Security Events** - Authentication monitoring

## Configuration

### Prometheus Scrape Configuration

Edit `+utility/watch/prometheus/prometheus.yml`:

```yaml
scrape_configs:
  # PostgreSQL
  - job_name: 'postgresql'
    static_configs:
      - targets: ['core-postgres-exporter:9187']
    
  # Redis
  - job_name: 'redis'
    static_configs:
      - targets: ['core-redis-exporter:9121']
    
  # MQTT
  - job_name: 'mqtt'
    static_configs:
      - targets: ['core-mqtt-exporter:9000']
    
  # Application Services
  - job_name: 'linkwarden'
    static_configs:
      - targets: ['link_app:9100']
```

### Alert Rules

Edit `+utility/watch/prometheus/alerts.yml`:

```yaml
groups:
  - name: service_alerts
    interval: 30s
    rules:
      # Service Down Alert
      - alert: ServiceDown
        expr: up == 0
        for: 2m
        labels:
          severity: critical
        annotations:
          summary: "Service {{ $labels.job }} is down"
          
      # High CPU Usage
      - alert: HighCPUUsage
        expr: 100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: "High CPU usage on {{ $labels.instance }}"
```

### Alert Routing

Edit `+utility/watch/alertmanager/alertmanager.yml`:

```yaml
route:
  receiver: 'gotify'
  group_by: ['alertname', 'severity']
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 4h
  
  routes:
    # Critical alerts - immediate notification
    - match:
        severity: critical
      receiver: 'gotify'
      repeat_interval: 30m
    
    # Warning alerts - less frequent
    - match:
        severity: warning
      receiver: 'gotify'
      repeat_interval: 4h

receivers:
  - name: 'gotify'
    webhook_configs:
      - url: 'http://messaging_gotify/message?token=<GOTIFY_TOKEN>'
        send_resolved: true
```

## Grafana Dashboards

### Import Dashboard

1. **Access Grafana:** `https://grafana.yourdomain.com`
2. **Login** with admin credentials
3. **Navigate:** Dashboards → Import
4. **Upload JSON** from `+utility/watch/grafana/dashboards/`
5. **Select Prometheus data source**
6. **Import**

### Create Custom Dashboard

1. **Click:** Create → Dashboard
2. **Add Panel**
3. **Select Metric:** e.g., `up{job="postgresql"}`
4. **Choose Visualization:** Graph, Gauge, Table, etc.
5. **Configure:** Title, legend, thresholds
6. **Save Dashboard**

### Dashboard Variables

Create dynamic dashboards with variables:

```
Name: service
Type: Query
Query: label_values(up, job)
```

Use in queries:
```
up{job="$service"}
```

## Alerting

### Setting Up Gotify

1. **Access Gotify:** `https://chat.yourdomain.com`
2. **Create Application:** Name: `Kompose Alerts`
3. **Copy Token**
4. **Add to alertmanager.yml:** Replace `<GOTIFY_TOKEN>`

### Test Alerts

**Manual Test Alert:**
```bash
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

**Trigger Real Alert:**
```bash
# Stop a service to trigger ServiceDown alert
./kompose.sh down link

# Wait 2 minutes for alert to fire
# Check Alertmanager: http://localhost:9093

# Restart service
./kompose.sh up link
```

### Alert States

- **Inactive** - Condition not met
- **Pending** - Condition met, waiting for `for` duration
- **Firing** - Alert sent to Alertmanager
- **Resolved** - Condition no longer met

## Metrics Queries

### PromQL Examples

**Service Availability:**
```promql
up{job="linkwarden"}
```

**CPU Usage:**
```promql
100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
```

**Memory Usage:**
```promql
(node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100
```

**Database Connections:**
```promql
pg_stat_database_numbackends{datname="kompose"}
```

**Redis Cache Hit Rate:**
```promql
rate(redis_keyspace_hits_total[5m]) / (rate(redis_keyspace_hits_total[5m]) + rate(redis_keyspace_misses_total[5m])) * 100
```

**MQTT Messages:**
```promql
rate(mqtt_messages_received_total[5m])
```

**Disk Usage:**
```promql
(node_filesystem_size_bytes{mountpoint="/"} - node_filesystem_avail_bytes{mountpoint="/"}) / node_filesystem_size_bytes{mountpoint="/"} * 100
```

## Retention and Storage

### Prometheus Data Retention

Edit `+utility/watch/compose.yaml`:

```yaml
command:
  - '--storage.tsdb.retention.time=30d'  # Keep 30 days
  - '--storage.tsdb.retention.size=10GB'  # Max 10GB
```

### Grafana Data Source

Prometheus is pre-configured as default data source.

**To add manually:**
1. **Configuration → Data Sources → Add**
2. **Type:** Prometheus
3. **URL:** `http://watch_prometheus:9090`
4. **Save & Test**

## Performance Tuning

### Reduce Scrape Frequency

For less critical services:

```yaml
scrape_configs:
  - job_name: 'slow-scrape'
    scrape_interval: 60s  # Default: 15s
    static_configs:
      - targets: ['service:port']
```

### Limit Metric Retention

```yaml
# In prometheus.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s
  
# Retention
command:
  - '--storage.tsdb.retention.time=15d'
```

### Optimize Queries

Use recording rules for expensive queries:

```yaml
# In prometheus.yml
groups:
  - name: recording_rules
    interval: 1m
    rules:
      - record: job:up:avg
        expr: avg(up) by (job)
```

## Monitoring Stack Management

### View Logs

```bash
./kompose.sh logs watch
docker logs watch_prometheus
docker logs watch_grafana
docker logs watch_alertmanager
```

### Restart Services

```bash
./kompose.sh restart watch
```

### Update Configuration

```bash
# Edit configuration files
nano +utility/watch/prometheus/prometheus.yml

# Reload Prometheus (no restart needed)
curl -X POST http://localhost:9090/-/reload

# Grafana auto-detects changes
```

### Backup Dashboards

```bash
# Export from Grafana UI
# Or backup volume
docker run --rm -v watch_grafana_data:/data -v $(pwd):/backup \
  alpine tar czf /backup/grafana-backup.tar.gz /data
```

## Troubleshooting

### Metrics Not Appearing

**Check target status:**
```bash
# Visit Prometheus
http://localhost:9090/targets

# Look for "DOWN" targets
```

**Test endpoint manually:**
```bash
curl http://service_container:port/metrics
```

**Check Prometheus logs:**
```bash
docker logs watch_prometheus | grep -i error
```

### Grafana Dashboard Empty

**Verify data source:**
1. Configuration → Data Sources
2. Test connection to Prometheus

**Check query:**
- Query must return data
- Time range must include data
- Metric name correct

**Inspect panel:**
- Panel → Edit → Query Inspector
- Check raw query and response

### Alerts Not Sending

**Check Alertmanager status:**
```bash
curl http://localhost:9093/api/v1/status
```

**Test Gotify connectivity:**
```bash
curl -X POST "http://messaging_gotify:80/message?token=TOKEN" \
  -F "title=Test" \
  -F "message=Test notification"
```

**Check alertmanager logs:**
```bash
docker logs watch_alertmanager
```

## Best Practices

### 1. Set Meaningful Alert Thresholds

Don't alert on every small spike:
```yaml
- alert: HighMemory
  expr: memory_usage > 90  # Not 70
  for: 10m  # Not 1m
```

### 2. Use Labels Effectively

```yaml
labels:
  severity: critical  # or warning, info
  team: platform
  component: database
```

### 3. Regular Dashboard Review

- Archive unused dashboards
- Update queries for accuracy
- Adjust visualizations

### 4. Monitor Prometheus Itself

```yaml
- alert: PrometheusDown
  expr: up{job="prometheus"} == 0
  for: 1m
```

### 5. Document Custom Metrics

Create a metrics catalog:
```
kompose_service_uptime_seconds - Service uptime
kompose_bookmarks_total - Total bookmarks created
kompose_users_active - Active user count
```

## Advanced Topics

### Service Discovery

Auto-discover Docker services:

```yaml
scrape_configs:
  - job_name: 'docker'
    docker_sd_configs:
      - host: unix:///var/run/docker.sock
    relabel_configs:
      - source_labels: [__meta_docker_container_label_prometheus_scrape]
        action: keep
        regex: true
```

### Remote Write

Send metrics to remote storage:

```yaml
remote_write:
  - url: "https://prometheus-remote.example.com/api/v1/write"
    basic_auth:
      username: user
      password: pass
```

### Grafana Alerting

Create alerts in Grafana (alternative to Alertmanager):

1. **Edit Panel → Alert**
2. **Create Alert Rule**
3. **Configure Conditions**
4. **Add Notification Channel**

## See Also

- [Watch Stack Documentation](/stacks/watch)
- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)
- [Alert Reference](/reference/alerts)