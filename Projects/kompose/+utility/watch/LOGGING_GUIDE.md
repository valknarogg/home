# Unified Logging with Loki - Complete Guide

## Overview

The Kompose project now has **unified, centralized logging** using Grafana Loki. All container logs across the entire stack hierarchy are automatically collected, indexed, and made searchable through a single interface.

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Grafana Dashboard                         │
│              (Visualize & Query All Logs)                    │
└───────────────────────────┬─────────────────────────────────┘
                            │
┌───────────────────────────▼─────────────────────────────────┐
│                         Loki                                 │
│              (Log Aggregation & Storage)                     │
│                  - 30 day retention                          │
│                  - Automatic indexing                        │
│                  - Label-based querying                      │
└───────────────────────────▲─────────────────────────────────┘
                            │
┌───────────────────────────┴─────────────────────────────────┐
│                       Promtail                               │
│              (Log Collection Agent)                          │
│         - Docker container log scraping                      │
│         - Automatic label extraction                         │
│         - JSON & structured log parsing                      │
└───────────────────────────▲─────────────────────────────────┘
                            │
        ┌───────────────────┴───────────────────┐
        │                                       │
┌───────▼─────────┐                  ┌──────────▼────────┐
│  Core Stack     │                  │  +utility Stack   │
│  - postgres     │                  │  - watch services │
│  - redis        │                  │  - link           │
│  - mosquitto    │                  │  - news           │
└─────────────────┘                  │  - track          │
        │                            │  - vault          │
┌───────▼─────────┐                  └───────────────────┘
│  Auth Stack     │                           │
│  - authentik    │                  ┌────────▼──────────┐
└─────────────────┘                  │  +custom Stack    │
        │                            │  - blog           │
┌───────▼─────────┐                  │  - sexy           │
│  Proxy Stack    │                  └───────────────────┘
│  - traefik      │                           │
└─────────────────┘                  ┌────────▼──────────┐
        │                            │  Other Stacks     │
┌───────▼─────────┐                  │  - messaging      │
│  Other Stacks   │                  │  - vpn            │
│  - chain        │                  │  - home           │
│  - kmps         │                  │  - _docs          │
└─────────────────┘                  └───────────────────┘
```

## Features

### ✅ Comprehensive Coverage
- **All stacks**: Every service in core, auth, proxy, chain, kmps, messaging, vpn, home, _docs
- **All utility stacks**: watch, link, news, track, vault
- **All custom stacks**: blog, sexy, and any future additions
- **System logs**: Host system logs from /var/log

### ✅ Intelligent Log Processing
- **Automatic label extraction**: container name, compose project, service name, stack, image
- **JSON log parsing**: Structured logs automatically parsed
- **Log level detection**: DEBUG, INFO, WARN, ERROR, FATAL levels extracted
- **Timestamp handling**: Multiple timestamp formats supported

### ✅ Optimal Configuration
- **30-day retention**: Automatic log rotation and cleanup
- **Efficient storage**: TSDB schema with filesystem storage
- **Performance tuned**: Optimized for high-volume ingestion
- **Resource limits**: Configured limits prevent resource exhaustion

### ✅ Easy Querying
- **LogQL**: Powerful query language for filtering and searching
- **Label-based filtering**: Filter by stack, service, container, log level
- **Full-text search**: Search through all log content
- **Grafana integration**: Beautiful dashboards and log exploration

## Installation

The logging infrastructure is already set up in the `watch` stack:

```bash
cd /home/valknar/Projects/kompose/+utility/watch
docker compose up -d
```

## Accessing Logs

### Via Grafana
1. Open Grafana: https://grafana.localhost (or your configured domain)
2. Navigate to "Explore" in the left menu
3. Select "Loki" as the data source
4. Use the query builder or write LogQL queries

### Example Queries

**View all logs from core stack:**
```logql
{compose_project="core"}
```

**View PostgreSQL logs:**
```logql
{compose_service="postgres"}
```

**View ERROR level logs from all stacks:**
```logql
{level="error"}
```

**View logs from a specific container:**
```logql
{container="core-postgres"}
```

**Combine filters:**
```logql
{compose_project="auth", level=~"error|fatal"}
```

**Search for specific text:**
```logql
{compose_project="core"} |= "connection"
```

**Count errors by service:**
```logql
sum by (compose_service) (count_over_time({level="error"}[1h]))
```

## Log Labels

Every log entry includes these labels for easy filtering:

| Label | Description | Example |
|-------|-------------|---------|
| `container` | Container name | `core-postgres` |
| `container_id` | Short container ID | `a1b2c3d4e5f6` |
| `compose_project` | Docker Compose project | `core` |
| `compose_service` | Service name from compose | `postgres` |
| `stack` | Stack identifier | `core` |
| `image` | Docker image name | `postgres:16-alpine` |
| `network` | Network mode | `kompose` |
| `host` | Host identifier | `kompose-host` |
| `level` | Log level (if detected) | `error` |
| `job` | Log collection job | `docker` |

## Configuration Files

### Loki Configuration
Location: `+utility/watch/loki/loki-config.yaml`
- Storage: Filesystem (TSDB)
- Retention: 30 days (720h)
- Ingestion rate: 16 MB/s
- Max query parallelism: 32

### Promtail Configuration
Location: `+utility/watch/promtail/promtail-config.yaml`
- Docker socket scraping: Automatic discovery
- System log collection: /var/log/*
- Pipeline stages: JSON parsing, level extraction, timestamp handling

### Grafana Datasource
Location: `+utility/watch/grafana/provisioning/datasources/loki.yml`
- Auto-provisioned on Grafana startup
- Accessible at: http://watch_loki:3100

## Automatic Log Collection

Promtail automatically discovers and collects logs from:

1. **All Docker containers** on the `kompose` network
2. **All containers** with Docker Compose labels
3. **System logs** from /var/log

No additional configuration needed per stack - Promtail uses Docker service discovery!

## Environment Variables

In `+utility/watch/.env`:

```bash
# Loki Configuration
LOKI_IMAGE=grafana/loki:latest
LOKI_PORT=3100
TRAEFIK_HOST_LOKI=loki.localhost
LOKI_AUTH=admin:$$apr1$$xyz

# Promtail Configuration
PROMTAIL_IMAGE=grafana/promtail:latest
PROMTAIL_PORT=9080
```

## Monitoring the Logging System

### Health Checks
```bash
# Check Loki health
curl http://localhost:3100/ready

# Check Promtail health
curl http://localhost:9080/ready

# Check Grafana datasource
curl http://localhost:3001/api/datasources
```

### Metrics
Loki and Promtail expose Prometheus metrics:
- Loki: http://localhost:3100/metrics
- Promtail: http://localhost:9080/metrics

These are automatically scraped by Prometheus in the watch stack.

## Best Practices

### Application Logging
To get the most out of Loki:

1. **Use JSON logging format** when possible:
   ```json
   {"level":"info","msg":"User login","user":"admin","time":"2025-01-15T10:30:00Z"}
   ```

2. **Include log levels**: DEBUG, INFO, WARN, ERROR, FATAL

3. **Use structured logging** libraries in your applications

4. **Avoid high-cardinality labels**: Don't log unique IDs as labels

### Query Optimization

1. **Always filter by labels first**:
   ```logql
   {compose_project="core"} |= "error"  # Good
   {job="docker"} |= "error"            # Too broad, slower
   ```

2. **Use time ranges**: Limit queries to specific time windows

3. **Use metric queries** for aggregations over log queries

## Maintenance

### Log Retention
Logs are automatically deleted after 30 days. To change:
```yaml
# In loki/loki-config.yaml
limits_config:
  retention_period: 720h  # Change as needed
```

### Storage Management
View storage usage:
```bash
docker exec watch_loki du -sh /loki
```

Clear old data (automatic via compactor, but can force):
```bash
docker compose -f +utility/watch/compose.yaml restart loki
```

## Troubleshooting

### No logs appearing
1. Check Promtail is running: `docker ps | grep promtail`
2. Check Promtail logs: `docker logs watch_promtail`
3. Verify Docker socket is mounted: `docker inspect watch_promtail`
4. Check Loki is accepting logs: `curl http://localhost:3100/ready`

### High memory usage
Adjust retention or ingestion limits in `loki/loki-config.yaml`:
```yaml
limits_config:
  ingestion_rate_mb: 8  # Reduce from 16
  retention_period: 360h  # Reduce from 720h
```

### Slow queries
1. Add more specific labels to your query
2. Reduce the time range
3. Use metric queries instead of log queries for aggregations

## Integration with Alerting

Loki integrates with Alertmanager (already in watch stack):

```yaml
# In loki/loki-config.yaml
ruler:
  alertmanager_url: http://alertmanager:9093
```

Create alerting rules in Loki to notify on specific log patterns.

## Future Enhancements

Potential improvements:
- [ ] Add LogQL alerting rules for common error patterns
- [ ] Create Grafana dashboards for each stack
- [ ] Add log sampling for very high-volume services
- [ ] Integrate with distributed tracing (Tempo)
- [ ] Add log-based metrics generation

## Summary

The Kompose logging infrastructure provides:
- **Unified logging** across all stacks
- **Automatic discovery** of all containers
- **Intelligent parsing** of structured logs
- **30-day retention** with automatic cleanup
- **Fast, label-based querying** via LogQL
- **Beautiful visualization** in Grafana
- **Zero configuration required** for new services

All services across the entire Kompose project hierarchy automatically send their logs to Loki, making it easy to debug, monitor, and analyze your entire infrastructure from a single interface.
