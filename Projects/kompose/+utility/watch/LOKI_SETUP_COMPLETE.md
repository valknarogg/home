# Loki Logging Integration - Summary

## ✅ Unified Logging System Complete

The watch stack now includes **Grafana Loki** for centralized log aggregation across the entire Kompose infrastructure.

## What Was Added

### Services
1. **Loki** - Log aggregation and storage system
   - Port: 3100
   - Web UI: https://loki.localhost
   - Retention: 30 days
   - Storage: TSDB with filesystem backend

2. **Promtail** - Log collection agent
   - Port: 9080
   - Automatically discovers all Docker containers
   - Scrapes logs via Docker socket
   - Parses JSON and structured logs

3. **Grafana Datasource** - Auto-provisioned Loki datasource
   - Accessible in Grafana Explore
   - Pre-configured for optimal performance

## Key Features

### 🎯 Automatic Log Collection
**No configuration required!** Promtail automatically:
- Discovers all Docker containers on the `kompose` network
- Collects logs from all services across all stacks
- Extracts labels: container, service, project, image, level
- Parses JSON logs and detects log levels (DEBUG, INFO, WARN, ERROR)

### 📊 Comprehensive Coverage
Logs are collected from:
- ✅ **Core stack**: postgres, redis, mosquitto, redis-api
- ✅ **Auth stack**: authentik, worker, server
- ✅ **Proxy stack**: traefik
- ✅ **Chain stack**: langfuse, worker, server
- ✅ **KMPS stack**: app, worker
- ✅ **Messaging stack**: n8n, worker
- ✅ **VPN stack**: wireguard
- ✅ **Home stack**: homeassistant
- ✅ **Docs stack**: nuxt app
- ✅ **+utility stacks**: watch, link, news, track, vault
- ✅ **+custom stacks**: blog, sexy
- ✅ **All future stacks**: Automatic discovery

### 🔍 Powerful Querying
Query logs using LogQL in Grafana:
```logql
# View all PostgreSQL logs
{compose_service="postgres"}

# View all ERROR logs
{level="error"}

# View logs from core stack
{compose_project="core"}

# Search for specific text
{compose_project="auth"} |= "authentication"

# Combine filters
{compose_project="core", level=~"error|fatal"}
```

### 🏷️ Rich Labels
Every log entry includes:
- `container` - Container name (e.g., `core-postgres`)
- `compose_project` - Stack name (e.g., `core`, `auth`)
- `compose_service` - Service name (e.g., `postgres`, `redis`)
- `stack` - Stack identifier
- `image` - Docker image
- `level` - Log level (if detected)
- `host` - Host identifier

## Quick Start

### Start the logging stack:
```bash
cd +utility/watch
docker compose up -d
```

### Access logs in Grafana:
1. Open https://grafana.localhost
2. Navigate to "Explore" → Select "Loki"
3. Start querying with LogQL

### View Loki directly:
https://loki.localhost (requires authentication)

## Configuration Files

```
+utility/watch/
├── loki/
│   └── loki-config.yaml          # Loki configuration
├── promtail/
│   └── promtail-config.yaml      # Log collection config
├── grafana/
│   └── provisioning/
│       └── datasources/
│           └── loki.yml          # Grafana datasource
└── .env                          # Environment variables
```

## Environment Variables

Added to `.env`:
```bash
# Loki Configuration
LOKI_IMAGE=grafana/loki:latest
LOKI_PORT=3100
TRAEFIK_HOST_LOKI=loki.localhost
LOKI_AUTH=admin:$apr1$xyz

# Promtail Configuration
PROMTAIL_IMAGE=grafana/promtail:latest
PROMTAIL_PORT=9080
```

## How It Works

```
All Docker Containers
        ↓
    Promtail (discovers & collects)
        ↓
    Loki (stores & indexes)
        ↓
    Grafana (visualizes & queries)
```

Promtail connects to the Docker socket and automatically discovers all containers. It extracts metadata (labels) and sends logs to Loki. Loki stores and indexes the logs with these labels, making them searchable. Grafana provides a beautiful interface for querying and visualizing logs.

## Optimal Configuration

### Storage & Retention
- **30-day retention**: Automatic cleanup of old logs
- **TSDB schema**: Efficient time-series database for logs
- **Filesystem storage**: Simple, reliable storage backend
- **Automatic compaction**: Background cleanup of old data

### Performance
- **16 MB/s ingestion rate**: Handle high-volume logging
- **32 query parallelism**: Fast query execution
- **10m cache freshness**: Optimized for recent data
- **15m query splitting**: Better resource distribution

### Resource Limits
- **100 MB embedded cache**: Fast query results
- **8 MB stream rate limit**: Prevent single service abuse
- **16 MB burst limit**: Handle traffic spikes

## Monitoring

The logging system itself is monitored:
- Loki metrics: http://localhost:3100/metrics
- Promtail metrics: http://localhost:9080/metrics
- Both scraped by Prometheus in the watch stack

## Benefits

### For Developers
- 🔍 **Single interface** to view all application logs
- 🚀 **Fast full-text search** across all services
- 📊 **Log aggregation** by service, stack, or level
- ⚡ **Real-time log streaming**

### For Operations
- 🎯 **Centralized monitoring** of all stacks
- 🔔 **Alerting on log patterns** (via Alertmanager)
- 📈 **Log-based metrics** for dashboards
- 🔐 **Secure access** via Traefik + basic auth

### For Debugging
- 🐛 **Correlate logs** across services
- ⏱️ **Trace request flow** through the stack
- 📝 **Historical log search** (30 days)
- 🏷️ **Filter by any label** combination

## Zero Configuration Required

**Important**: All existing and future services automatically send logs to Loki with **zero configuration changes needed**. Promtail uses Docker service discovery to automatically find and collect logs from all containers.

Simply start any new service with Docker Compose, and it will automatically appear in Loki!

## Documentation

See [LOGGING_GUIDE.md](./LOGGING_GUIDE.md) for:
- Detailed architecture diagram
- Complete LogQL query examples
- Troubleshooting guide
- Best practices for application logging
- Advanced configuration options
- Alert rule examples

## Next Steps

1. ✅ Start the watch stack: `docker compose up -d`
2. ✅ Open Grafana: https://grafana.localhost
3. ✅ Explore logs in the "Explore" view
4. 📊 Create custom dashboards for your services
5. 🔔 Set up alerting rules for critical errors

## Summary

The Kompose project now has **enterprise-grade, unified logging** that:
- ✅ Automatically collects logs from **all services** across **all stacks**
- ✅ Requires **zero configuration** for existing or new services
- ✅ Provides **powerful querying** with LogQL
- ✅ Includes **30-day retention** with automatic cleanup
- ✅ Integrates seamlessly with **Grafana and Prometheus**
- ✅ Is **optimally configured** for performance and resource usage

**All container logs are now centralized, searchable, and accessible through a beautiful Grafana interface!**
