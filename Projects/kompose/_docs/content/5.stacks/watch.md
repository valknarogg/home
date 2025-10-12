---
title: Watch - Observability Command Center
description: "See everything, miss nothing!"
navigation:
  icon: i-lucide-eye
---

> *"See everything, miss nothing!"* - The Watcher's Creed

## What's This All About?

Welcome to the **Watch Stack** - your comprehensive monitoring, observability, and logging headquarters! This is where all your Kompose infrastructure comes into view. From PostgreSQL queries to MQTT messages, from container metrics to application logs - if it's happening in your system, Watch sees it! :icon{name="lucide:search"}

## The All-Seeing Eye :icon{name="lucide:eye"}

The Watch Stack brings together industry-leading open-source tools to create a complete observability platform:

- :icon{name="lucide:trending-up"} **Metrics**: Collect, store, and visualize time-series data
- :icon{name="lucide:file-text"} **Logs**: Aggregate and query logs from all services
- :icon{name="lucide:activity"} **Telemetry**: Process traces, metrics, and logs through OTEL
- :icon{name="lucide:bell"} **Alerts**: Get notified when things go wrong
- :icon{name="lucide:bar-chart"} **Dashboards**: Beautiful visualizations of your infrastructure

## The Monitoring Arsenal

### :icon{name="lucide:database"} Prometheus - Metrics Database

**Container**: `watch_prometheus`  
**Image**: `prom/prometheus:latest`  
**Port**: 9090  
**Home**: https://prometheus.localhost

The heart of your metrics infrastructure:
- :icon{name="lucide:trending-up"} **Time-Series DB**: Optimized for metrics
- :icon{name="lucide:clock"} **30-Day Retention**: Automatic data management
- :icon{name="lucide:zap"} **PromQL**: Powerful query language
- :icon{name="lucide:search"} **Service Discovery**: Auto-discovers targets
- :icon{name="lucide:download"} **Scraping**: Pulls metrics from exporters
- :icon{name="lucide:bell"} **Alerting**: Evaluates alert rules
- :icon{name="lucide:globe"} **Federation**: Can aggregate multiple Prometheus instances

### :icon{name="lucide:bar-chart"} Grafana - Visualization Platform

**Container**: `watch_grafana`  
**Image**: `grafana/grafana:latest`  
**Port**: 3001  
**Home**: https://grafana.localhost

Your window into the metrics universe:
- :icon{name="lucide:layout-dashboard"} **Dashboards**: Create stunning visualizations
- :icon{name="lucide:database"} **Multi-Datasource**: Prometheus, Loki, and more
- :icon{name="lucide:users"} **Teams**: User management and permissions
- :icon{name="lucide:bell"} **Alerting**: Visual alert builder
- :icon{name="lucide:plug"} **Plugins**: Extend functionality
- :icon{name="lucide:palette"} **Themes**: Light/Dark modes
- :icon{name="lucide:link"} **Share**: Public dashboard links
- :icon{name="lucide:download"} **Auto-Provisioning**: Datasources & dashboards

### :icon{name="lucide:file-text"} Loki - Log Aggregation

**Container**: `watch_loki`  
**Image**: `grafana/loki:latest`  
**Port**: 3100  
**Home**: https://loki.localhost

Like Prometheus, but for logs:
- :icon{name="lucide:layers"} **Log Aggregation**: Collect logs from all containers
- :icon{name="lucide:tag"} **Labels**: Index by metadata, not content
- :icon{name="lucide:clock"} **30-Day Retention**: Automatic cleanup
- :icon{name="lucide:zap"} **LogQL**: Powerful log query language
- :icon{name="lucide:database"} **TSDB Storage**: Efficient time-series log storage
- :icon{name="lucide:rocket"} **Fast**: Optimized for grep-like queries
- :icon{name="lucide:palette"} **JSON Support**: Parse structured logs

### :icon{name="lucide:download"} Promtail - Log Collector

**Container**: `watch_promtail`  
**Image**: `grafana/promtail:latest`  
**Port**: 9080

The log collection agent:
- :icon{name="lucide:docker"} **Docker Logs**: Automatic container discovery
- :icon{name="lucide:server"} **System Logs**: Scrapes /var/log
- :icon{name="lucide:tag"} **Label Extraction**: From container metadata
- :icon{name="lucide:code"} **Pipeline Processing**: Parse and transform logs
- :icon{name="lucide:trending-up"} **Metrics**: Exposes collection metrics

### :icon{name="lucide:radio"} OTEL Collector - Telemetry Pipeline

**Container**: `watch_otel`  
**Image**: `otel/opentelemetry-collector-contrib:latest`  
**Ports**: 4317 (gRPC), 4318 (HTTP), 13133 (health)

The telemetry processing powerhouse:
- :icon{name="lucide:activity"} **MQTT Receiver**: Subscribes to MQTT topics
- :icon{name="lucide:trending-up"} **Metrics Export**: Sends to Prometheus
- :icon{name="lucide:file-text"} **Log Processing**: Future log support
- :icon{name="lucide:git-branch"} **Traces**: Distributed tracing (optional)
- :icon{name="lucide:zap"} **Processing**: Transform telemetry data
- :icon{name="lucide:globe"} **Multi-Protocol**: gRPC, HTTP, MQTT

### :icon{name="lucide:bell"} Alertmanager - Alert Routing

**Container**: `watch_alertmanager`  
**Image**: `prom/alertmanager:latest`  
**Port**: 9093  
**Home**: https://alertmanager.localhost

Smart alert delivery:
- :icon{name="lucide:mail"} **Email Notifications**: Alert via email
- :icon{name="lucide:message-square"} **Slack Integration**: Send to channels
- :icon{name="lucide:phone"} **PagerDuty**: On-call alerts
- :icon{name="lucide:webhook"} **Webhooks**: Custom integrations
- :icon{name="lucide:group"} **Grouping**: Batch related alerts
- :icon{name="lucide:clock"} **Silencing**: Temporary muting
- :icon{name="lucide:repeat"} **Deduplication**: Avoid spam

## The Exporter Squad :icon{name="lucide:activity"}

### :icon{name="lucide:database"} PostgreSQL Exporter

**Container**: `watch_postgres_exporter`  
**Port**: 9187

Monitors your PostgreSQL database:
- :icon{name="lucide:activity"} Connections & queries
- :icon{name="lucide:trending-up"} Query performance
- :icon{name="lucide:hard-drive"} Database size
- :icon{name="lucide:copy"} Replication lag
- :icon{name="lucide:lock"} Locks & deadlocks
- :icon{name="lucide:table"} Table statistics

### :icon{name="lucide:zap"} Redis Exporter

**Container**: `watch_redis_exporter`  
**Port**: 9121

Tracks your Redis cache:
- :icon{name="lucide:target"} Hit/miss rates
- :icon{name="lucide:cpu"} Memory usage
- :icon{name="lucide:users"} Connected clients
- :icon{name="lucide:trending-up"} Commands per second
- :icon{name="lucide:key"} Keyspace statistics
- :icon{name="lucide:clock"} Evictions & expirations

### :icon{name="lucide:radio"} MQTT Exporter

**Container**: `watch_mqtt_exporter`  
**Port**: 9000

Monitors MQTT broker:
- :icon{name="lucide:send"} Message rates
- :icon{name="lucide:layers"} Topics & subscriptions
- :icon{name="lucide:users"} Connected clients
- :icon{name="lucide:trending-up"} Bytes transferred
- :icon{name="lucide:activity"} Broker health

### :icon{name="lucide:package"} cAdvisor - Container Metrics

**Container**: `watch_cadvisor`  
**Port**: 8082

Detailed container monitoring:
- :icon{name="lucide:cpu"} CPU usage per container
- :icon{name="lucide:hard-drive"} Memory consumption
- :icon{name="lucide:network"} Network I/O
- :icon{name="lucide:database"} Disk I/O
- :icon{name="lucide:trending-up"} Resource limits

### :icon{name="lucide:server"} Node Exporter - Host Metrics

**Port**: 9100 (host network mode)

System-level monitoring:
- :icon{name="lucide:cpu"} CPU usage & load
- :icon{name="lucide:hard-drive"} Memory & swap
- :icon{name="lucide:database"} Disk usage & I/O
- :icon{name="lucide:network"} Network traffic
- :icon{name="lucide:thermometer"} System temperature
- :icon{name="lucide:clock"} Uptime & boot time

### :icon{name="lucide:search"} Blackbox Exporter - Endpoint Probing

**Container**: `watch_blackbox_exporter`  
**Port**: 9115

HTTP/HTTPS monitoring:
- :icon{name="lucide:globe"} Endpoint availability
- :icon{name="lucide:clock"} Response times
- :icon{name="lucide:shield"} SSL certificate expiry
- :icon{name="lucide:activity"} DNS resolution
- :icon{name="lucide:check"} HTTP status codes

## What Gets Monitored :icon{name="lucide:target"}

### Core Stack (Layer 0)
- :icon{name="lucide:database"} **PostgreSQL**: All database metrics
- :icon{name="lucide:zap"} **Redis**: Cache performance
- :icon{name="lucide:radio"} **MQTT**: Message broker stats

### Auth Stack
- :icon{name="lucide:shield"} **Authentik**: Via container metrics
- :icon{name="lucide:users"} **Login patterns**: Via logs

### Proxy Stack
- :icon{name="lucide:globe"} **Traefik**: HTTP metrics
- :icon{name="lucide:shield"} **SSL/TLS**: Certificate monitoring

### Utility Stacks
- :icon{name="lucide:bar-chart"} **Umami**: Availability monitoring
- :icon{name="lucide:link"} **LinkWarden**: Dashboard included
- :icon{name="lucide:newspaper"} **Miniflux**: Via container metrics

### Home Stack
- :icon{name="lucide:home"} **Home Assistant**: Full integration
- :icon{name="lucide:thermometer"} **Sensors**: Temperature, humidity, etc.
- :icon{name="lucide:lightbulb"} **Devices**: States & availability

### All Stacks
- :icon{name="lucide:package"} **All Containers**: Resource usage
- :icon{name="lucide:file-text"} **All Logs**: Centralized collection
- :icon{name="lucide:network"} **Network**: Traffic & connectivity

## Quick Start :icon{name="lucide:rocket"}

### 1. Prerequisites

Ensure these stacks are running:
```bash
# Core stack (required)
cd /home/valknar/Projects/kompose/core
docker compose up -d

# Optional integrations
cd /home/valknar/Projects/kompose/home
docker compose up -d

cd /home/valknar/Projects/kompose/+utility/track
docker compose up -d
```

### 2. Start Watch Stack

```bash
cd /home/valknar/Projects/kompose/+utility/watch
docker compose up -d
```

### 3. Verify Integration

```bash
# Make script executable
chmod +x verify-integration.sh

# Run verification
./verify-integration.sh
```

This checks:
- ✅ All containers running
- ✅ Service endpoints reachable
- ✅ Network connectivity
- ✅ Prometheus targets up
- ✅ Configuration issues

### 4. Configure Home Assistant (Optional)

```bash
# Interactive setup
chmod +x setup-homeassistant.sh
./setup-homeassistant.sh
```

This guides you through:
1. Creating a long-lived access token
2. Updating Prometheus configuration
3. Verifying the integration

### 5. Access Services

| Service | URL | Default Login |
|---------|-----|---------------|
| **Grafana** | https://grafana.localhost | admin / (from .env) |
| **Prometheus** | https://prometheus.localhost | Basic auth (from .env) |
| **Alertmanager** | https://alertmanager.localhost | Basic auth (from .env) |
| **Loki** | https://loki.localhost | Basic auth (from .env) |

## Grafana Setup :icon{name="lucide:layout-dashboard"}

### First Login

1. Open https://grafana.localhost
2. Login: `admin` / `GRAFANA_ADMIN_PASSWORD` (from .env)
3. **Change password immediately!**

### Add Data Sources

Data sources are **auto-provisioned** on first start:
- ✅ Prometheus at `http://watch_prometheus:9090`
- ✅ Loki at `http://watch_loki:3100`

### Import Dashboards

**Recommended Dashboard IDs:**

1. **System Monitoring**
   - **1860**: Node Exporter Full (comprehensive host metrics)
   - **893**: Docker Monitoring (container metrics)

2. **Databases**
   - **7362**: PostgreSQL Database
   - **763**: Redis Dashboard
   - **11074**: Redis Cluster

3. **Application Monitoring**
   - **13177**: Home Assistant
   - **13032**: MQTT Monitoring
   - **3662**: Prometheus 2.0 Overview

4. **Pre-installed Custom Dashboards**
   - **Kompose Overview**: All stacks at a glance
   - **System Dashboard**: Host system metrics
   - **PostgreSQL Dashboard**: Database performance
   - **LinkWarden Dashboard**: Bookmark stats

### Import Process

1. **Dashboards** → **Import**
2. Enter Dashboard ID (e.g., `1860`)
3. Select **Prometheus** data source
4. Click **Import**

## Querying Logs with LogQL :icon{name="lucide:search"}

### Access Logs in Grafana

1. Navigate to **Explore** (left sidebar)
2. Select **Loki** as data source
3. Use the query builder or write LogQL

### Common Log Queries

**View all logs from core stack:**
```logql
{compose_project="core"}
```

**View PostgreSQL logs:**
```logql
{compose_service="postgres"}
```

**Find errors across all services:**
```logql
{level="error"}
```

**Search for specific text:**
```logql
{compose_project="auth"} |= "authentication"
```

**Errors from core stack:**
```logql
{compose_project="core", level=~"error|fatal"}
```

**Count errors by service (last hour):**
```logql
sum by (compose_service) (count_over_time({level="error"}[1h]))
```

**Live tail (real-time logs):**
```logql
{container="core-postgres"} # Enable "Live tail" button
```

### Available Log Labels

Every log entry includes:
- `container` - Container name (e.g., `core-postgres`)
- `compose_project` - Stack name (e.g., `core`, `auth`)
- `compose_service` - Service name (e.g., `postgres`, `redis`)
- `image` - Docker image
- `level` - Log level (error, warn, info, debug)
- `host` - Hostname
- `job` - Collection job (usually "docker")

## Querying Metrics with PromQL :icon{name="lucide:trending-up"}

### Access Metrics in Grafana

1. **Explore** → Select **Prometheus**
2. Use query builder or write PromQL

### System Metrics

**CPU usage:**
```promql
100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
```

**Memory usage percentage:**
```promql
(node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100
```

**Disk usage:**
```promql
(node_filesystem_size_bytes - node_filesystem_free_bytes) / node_filesystem_size_bytes * 100
```

### Database Metrics

**PostgreSQL active connections:**
```promql
pg_stat_database_numbackends
```

**Redis cache hit rate:**
```promql
rate(redis_keyspace_hits_total[5m]) / (rate(redis_keyspace_hits_total[5m]) + rate(redis_keyspace_misses_total[5m]))
```

### MQTT Metrics

**Message rate:**
```promql
rate(mqtt_message_count[5m])
```

**Topic message counts:**
```promql
mqtt_topic_messages_total
```

### Container Metrics

**Container CPU usage:**
```promql
rate(container_cpu_usage_seconds_total[5m]) * 100
```

**Container memory:**
```promql
container_memory_usage_bytes
```

## Home Assistant Integration :icon{name="lucide:home"}

### Setup Process

1. **Run the setup script:**
```bash
./setup-homeassistant.sh
```

2. **Create token in Home Assistant:**
   - Profile → Long-Lived Access Tokens
   - Create Token → Name: "Prometheus Monitoring"
   - Copy the token

3. **Paste token** when prompted by script

4. **Verify integration:**
   - Prometheus → Status → Targets
   - Find `homeassistant` job
   - Status should be **UP**

### Query Home Assistant Data

**Temperature sensors:**
```promql
homeassistant_sensor_temperature_celsius
```

**Entity availability:**
```promql
homeassistant_entity_available == 1
```

**Sensor states:**
```promql
homeassistant_sensor_state
```

## MQTT Integration :icon{name="lucide:radio"}

### OTEL Collector

Subscribes to MQTT topics:
- `homeassistant/#` - All Home Assistant topics
- `sensor/#` - Sensor data
- `device/#` - Device telemetry
- `telemetry/#` - General telemetry

Converts MQTT messages to metrics and sends to Prometheus.

### MQTT Exporter

Monitors broker-level statistics:
- Message counts
- Topic statistics
- Broker health
- Connection counts

### Query MQTT Metrics

```promql
# Message rate
rate(mqtt_message_count[5m])

# Topics
mqtt_topic_messages_total
```

## Alerting :icon{name="lucide:bell"}

### Alert Rules

Located in `prometheus/rules/`:
- `core_alerts.yml` - Core service alerts
- `application_alerts.yml` - Application alerts

### Example Alerts

**High CPU usage:**
```yaml
- alert: HostHighCpuLoad
  expr: 100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[2m])) * 100) > 80
  for: 5m
  labels:
    severity: warning
  annotations:
    summary: "CPU load is high"
```

**Database down:**
```yaml
- alert: PostgresDown
  expr: pg_up == 0
  for: 1m
  labels:
    severity: critical
  annotations:
    summary: "PostgreSQL is down"
```

### Configure Alertmanager

Edit `alertmanager/alertmanager.yml`:

```yaml
receivers:
  - name: 'email'
    email_configs:
      - to: 'alerts@example.com'
        from: 'alertmanager@example.com'
        smarthost: 'smtp.example.com:587'
        auth_username: 'user'
        auth_password: 'pass'
  
  - name: 'slack'
    slack_configs:
      - api_url: 'https://hooks.slack.com/services/XXX'
        channel: '#alerts'
```

## Architecture Overview :icon{name="lucide:network"}

```
┌─────────────────────────────────────────────┐
│          Kompose Network                    │
├─────────────────────────────────────────────┤
│                                             │
│  ┌──────────┐     ┌───────────┐           │
│  │   CORE   │────▶│   WATCH   │           │
│  │ Layer 0  │     │ Layer 1b  │           │
│  └──────────┘     └───────────┘           │
│       │                  │                  │
│   PostgreSQL        Prometheus              │
│   Redis             Grafana                 │
│   MQTT              OTEL                    │
│       │                  │                  │
│       └──────┬───────────┘                 │
│              │                               │
│       All containers ────▶ Promtail         │
│       /var/log ──────────▶ Promtail         │
│              │                               │
│              └────────────▶ Loki            │
│                                             │
└─────────────────────────────────────────────┘
```

## Data Flow

1. **Metrics Collection**
   - Exporters connect to services
   - Prometheus scrapes exporters
   - Metrics stored in Prometheus

2. **Log Collection**
   - Promtail discovers containers
   - Promtail scrapes logs
   - Logs sent to Loki

3. **Visualization**
   - Grafana queries Prometheus
   - Grafana queries Loki
   - Dashboards display data

4. **Alerting**
   - Prometheus evaluates rules
   - Alerts sent to Alertmanager
   - Notifications delivered

## Ports & Networking :icon{name="lucide:network"}

### Exposed Ports

| Service | Internal | External | Protocol |
|---------|----------|----------|----------|
| Prometheus | 9090 | 9090 | HTTP |
| Grafana | 3000 | 3001 | HTTP |
| OTEL (gRPC) | 4317 | 4317 | gRPC |
| OTEL (HTTP) | 4318 | 4318 | HTTP |
| Loki | 3100 | 3100 | HTTP |
| Promtail | 9080 | 9080 | HTTP |
| Alertmanager | 9093 | 9093 | HTTP |
| PostgreSQL Exporter | 9187 | 9187 | HTTP |
| Redis Exporter | 9121 | 9121 | HTTP |
| MQTT Exporter | 9000 | 9000 | HTTP |
| cAdvisor | 8080 | 8082 | HTTP |
| Node Exporter | 9100 | 9100 | HTTP (host) |
| Blackbox Exporter | 9115 | 9115 | HTTP |

### Network Configuration

All services run on the `kompose` network (external bridge):
```yaml
networks:
  kompose_network:
    name: kompose
    external: true
```

DNS resolution: Container names resolve automatically
- `core-postgres` → PostgreSQL
- `core-redis` → Redis
- `core-mqtt` → MQTT
- `watch_prometheus` → Prometheus
- etc.

## Security :icon{name="lucide:shield"}

### Authentication

**Grafana:**
- Username: `admin`
- Password: Set in `GRAFANA_ADMIN_PASSWORD` (.env)

**Prometheus, Loki, Alertmanager:**
- Basic Auth via Traefik
- Credentials in `.env` (htpasswd format)

### Generate htpasswd

```bash
# Install htpasswd
sudo apt install apache2-utils

# Generate credentials
echo $(htpasswd -nb admin your_password) | sed -e s/\\$/\\$\\$/g
```

Add to `.env`:
```bash
PROMETHEUS_AUTH=admin:$$apr1$$xyz...
```

### Change Default Passwords

**Critical:** Update these in `.env`:
```bash
GRAFANA_ADMIN_PASSWORD=your_secure_password
GRAFANA_DB_PASSWORD=your_secure_password
POSTGRES_EXPORTER_PASSWORD=your_secure_password
REDIS_EXPORTER_PASSWORD=your_secure_password
```

### SSL/TLS

All web services integrate with Traefik for SSL:
- Auto HTTPS redirection
- Let's Encrypt certificates
- Secure by default

### Internal Services

Most services don't expose ports externally:
- Communication via Docker network
- Only Grafana typically exposed
- Traefik handles external access

## Maintenance :icon{name="lucide:wrench"}

### Data Retention

**Metrics** (Prometheus):
- Retention: 30 days
- Auto-cleanup via TSDB
- Configurable in compose.yaml

**Logs** (Loki):
- Retention: 30 days (720h)
- Auto-cleanup via compactor
- Configure in `loki/loki-config.yaml`

### Backup

**Prometheus Data:**
```bash
docker run --rm \
  -v watch_prometheus_data:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/prometheus-backup.tar.gz /data
```

**Grafana Data:**
```bash
docker run --rm \
  -v watch_grafana_data:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/grafana-backup.tar.gz /data
```

**Loki Data:**
```bash
docker run --rm \
  -v watch_loki_data:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/loki-backup.tar.gz /data
```

### Restore

```bash
# Restore Prometheus
docker run --rm \
  -v watch_prometheus_data:/data \
  -v $(pwd):/backup \
  alpine sh -c "rm -rf /data/* && tar xzf /backup/prometheus-backup.tar.gz -C /"
```

### Update Services

```bash
# Pull latest images
docker compose pull

# Restart with new images
docker compose up -d
```

### Health Checks

All services have health checks:
```bash
# View health status
docker compose ps

# Check specific service
docker inspect watch_prometheus --format='{{.State.Health.Status}}'
```

## Troubleshooting :icon{name="lucide:life-buoy"}

### Prometheus Targets Down

**Problem:** Targets show as DOWN

**Solutions:**
```bash
# Check target container
docker ps | grep [target]

# Check connectivity
docker exec watch_prometheus ping -c 3 [target_container]

# View Prometheus logs
docker logs watch_prometheus

# Reload Prometheus config
curl -X POST http://localhost:9090/-/reload
```

### No Logs in Loki

**Problem:** Logs not appearing

**Solutions:**
```bash
# Check Promtail
docker logs watch_promtail

# Verify Loki is up
curl http://localhost:3100/ready

# Check Docker socket mount
docker inspect watch_promtail | grep -A 10 Mounts

# Restart Promtail
docker compose restart promtail
```

### Grafana Can't Connect

**Problem:** Data source connection fails

**Solutions:**
```bash
# Verify Prometheus is running
docker ps | grep prometheus

# Test Prometheus endpoint
curl http://localhost:9090/-/healthy

# Check network connectivity
docker exec watch_grafana ping -c 3 watch_prometheus

# Restart Grafana
docker compose restart grafana
```

### High Memory Usage

**Problem:** Containers using too much memory

**Solutions:**
- Reduce retention period
- Limit scrape frequency
- Optimize queries
- Increase host memory
- Add resource limits to compose.yaml

### MQTT Metrics Missing

**Problem:** No MQTT metrics in Prometheus

**Solutions:**
```bash
# Check MQTT broker
docker exec core-mqtt mosquitto_sub -t '#' -v -C 1

# Check MQTT exporter
docker logs watch_mqtt_exporter

# Test metrics endpoint
curl http://localhost:9000/metrics

# Restart MQTT exporter
docker compose restart mqtt-exporter
```

## Performance Tips :icon{name="lucide:zap"}

### Query Optimization

**Use specific labels:**
```promql
# Good
{compose_project="core", compose_service="postgres"}

# Bad (too broad)
{job="docker"}
```

**Limit time ranges:**
```promql
# Query last hour, not last month
rate(metric[1h])
```

**Use recording rules:**
```yaml
# Precompute expensive queries
groups:
  - name: cpu_usage
    interval: 30s
    rules:
      - record: job:cpu_usage:rate5m
        expr: rate(cpu_seconds_total[5m])
```

### Storage Optimization

**Prometheus:**
- Reduce retention if needed
- Use remote write for long-term storage
- Regular TSDB maintenance

**Loki:**
- Adjust retention period
- Configure compactor settings
- Monitor disk space

### Resource Limits

Add to compose.yaml if needed:
```yaml
services:
  prometheus:
    deploy:
      resources:
        limits:
          memory: 2G
          cpus: '1.0'
```

## Advanced Features :icon{name="lucide:sparkles"}

### Federation

Aggregate multiple Prometheus instances:
```yaml
- job_name: 'federate'
  scrape_interval: 15s
  honor_labels: true
  metrics_path: '/federate'
  params:
    'match[]':
      - '{job="prometheus"}'
  static_configs:
    - targets:
      - 'other-prometheus:9090'
```

### Remote Write

Send metrics to external storage:
```yaml
remote_write:
  - url: "https://metrics.example.com/api/v1/push"
    basic_auth:
      username: user
      password: pass
```

### Service Discovery

Auto-discover services:
```yaml
- job_name: 'docker'
  docker_sd_configs:
    - host: unix:///var/run/docker.sock
```

### Custom Exporters

Create your own exporter:
```python
from prometheus_client import start_http_server, Gauge
import time

# Create metric
temperature = Gauge('room_temperature', 'Room temperature in celsius')

# Update metric
temperature.set(22.5)

# Start server
start_http_server(8000)
```

## Integration Examples

### Custom Application Metrics

**Python:**
```python
from prometheus_client import Counter, Histogram
import time

# Define metrics
requests_total = Counter('app_requests_total', 'Total requests')
request_duration = Histogram('app_request_duration_seconds', 'Request duration')

# Use metrics
@request_duration.time()
def handle_request():
    requests_total.inc()
    # Your code here
```

**Node.js:**
```javascript
const client = require('prom-client');
const register = new client.Registry();

// Define metric
const counter = new client.Counter({
  name: 'app_requests_total',
  help: 'Total requests'
});

register.registerMetric(counter);

// Use metric
app.get('/api', (req, res) => {
  counter.inc();
  res.send('Hello');
});
```

## Resources :icon{name="lucide:book"}

### Official Documentation

- [Prometheus Docs](https://prometheus.io/docs/)
- [Grafana Docs](https://grafana.com/docs/)
- [Loki Docs](https://grafana.com/docs/loki/)
- [OTEL Collector](https://opentelemetry.io/docs/collector/)
- [Alertmanager Docs](https://prometheus.io/docs/alerting/latest/alertmanager/)

### Learning Resources

- [PromQL Tutorial](https://prometheus.io/docs/prometheus/latest/querying/basics/)
- [LogQL Guide](https://grafana.com/docs/loki/latest/logql/)
- [Grafana Tutorials](https://grafana.com/tutorials/)

### Community

- [Prometheus Community](https://prometheus.io/community/)
- [Grafana Community](https://community.grafana.com/)
- [CNCF Slack](https://cloud-native.slack.com/)

---

*"In observability we trust, in metrics we verify!"* - The Watch Stack Motto :icon{name="lucide:eye"}:icon{name="lucide:sparkles"}
