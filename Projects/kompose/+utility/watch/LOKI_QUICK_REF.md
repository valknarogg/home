# Loki Logging - Quick Reference

## 🚀 Quick Start

```bash
# Start the watch stack (includes Loki + Promtail)
cd +utility/watch
docker compose up -d

# Access logs in Grafana
open https://grafana.localhost
# Navigate: Explore → Select "Loki" datasource
```

## 📊 Access Points

| Service | URL | Purpose |
|---------|-----|---------|
| Grafana | https://grafana.localhost | Query and visualize logs |
| Loki API | https://loki.localhost | Direct API access |
| Promtail | http://localhost:9080 | Log collection agent stats |

## 🔍 Common LogQL Queries

### By Stack/Service
```logql
# All logs from core stack
{compose_project="core"}

# All logs from PostgreSQL
{compose_service="postgres"}

# Specific container
{container="core-postgres"}

# Multiple stacks
{compose_project=~"core|auth|proxy"}
```

### By Log Level
```logql
# All errors
{level="error"}

# Errors from specific stack
{compose_project="auth", level="error"}

# Warnings and errors
{level=~"warn|error"}

# Critical errors from database
{compose_service=~"postgres|mysql", level=~"error|fatal"}
```

### Full-Text Search
```logql
# Search for text
{compose_project="auth"} |= "authentication"

# Case-insensitive search
{compose_project="auth"} |~ `(?i)authentication`

# Exclude lines
{compose_project="core"} != "health check"

# Regex search
{compose_service="traefik"} |~ "status=[45][0-9]{2}"
```

### JSON Log Parsing
```logql
# Parse JSON logs
{compose_project="auth"} | json

# Extract specific field
{compose_project="auth"} | json | level="error"

# Filter by JSON field
{compose_project="traefik"} | json | status >= 400
```

### Time-Based Queries
```logql
# Logs from last hour
{compose_project="core"}[1h]

# Logs from specific time range
{compose_project="auth"}[2024-01-15T10:00:00Z:2024-01-15T11:00:00Z]

# Rate of logs
rate({compose_project="core"}[5m])
```

### Aggregations
```logql
# Count logs per stack
sum by (compose_project) (count_over_time({job="docker"}[1h]))

# Error count by service
sum by (compose_service) (count_over_time({level="error"}[1h]))

# Top 10 error-producing services
topk(10, sum by (compose_service) (count_over_time({level="error"}[24h])))

# Average log rate
avg(rate({compose_project="core"}[5m]))
```

## 📋 All Available Labels

```logql
# View all label values
{job="docker"}

# Common labels:
container          # e.g., core-postgres
container_id       # e.g., a1b2c3d4e5f6
compose_project    # e.g., core, auth, watch
compose_service    # e.g., postgres, redis, traefik
stack              # Stack identifier
image              # e.g., postgres:16-alpine
network            # e.g., kompose
host               # e.g., kompose-host
level              # e.g., error, warn, info
job                # e.g., docker
```

## 🎯 Stack-Specific Queries

### Core Stack
```logql
# PostgreSQL connection errors
{compose_service="postgres"} |= "connection"

# Redis cache operations
{compose_service="redis"} | json | cmd="get"

# MQTT messages
{compose_service="mosquitto"} | json | topic
```

### Auth Stack
```logql
# Failed login attempts
{compose_project="auth"} |~ "authentication failed|login failed"

# User creation
{compose_project="auth"} |= "user created"

# Session events
{compose_project="auth"} |~ "session (created|expired)"
```

### Proxy Stack
```logql
# HTTP errors (4xx, 5xx)
{compose_service="traefik"} | json | status >= 400

# Slow requests
{compose_service="traefik"} | json | duration > 1000

# SSL errors
{compose_service="traefik"} |= "TLS"
```

### Chain Stack
```logql
# Langfuse operations
{compose_project="chain"} | json | event

# Worker errors
{compose_project="chain", compose_service="worker"} | level="error"
```

## 📈 Building Dashboards

### Panel Queries

**Error Rate Panel:**
```logql
sum(rate({level="error"}[5m])) by (compose_project)
```

**Log Volume Panel:**
```logql
sum(count_over_time({job="docker"}[1m])) by (compose_project)
```

**Top Error Services:**
```logql
topk(5, sum(rate({level="error"}[5m])) by (compose_service))
```

**Recent Critical Logs (Table):**
```logql
{level=~"error|fatal"} | json
```

## 🔧 Troubleshooting

### Check Loki Health
```bash
# Loki ready
curl http://localhost:3100/ready

# Loki health
curl http://localhost:3100/metrics | grep loki_ingester_streams

# View Loki logs
docker logs watch_loki -f
```

### Check Promtail
```bash
# Promtail ready
curl http://localhost:9080/ready

# Promtail metrics
curl http://localhost:9080/metrics | grep promtail_sent_entries

# View Promtail logs
docker logs watch_promtail -f

# Check what Promtail is collecting
docker exec watch_promtail cat /tmp/positions.yaml
```

### No Logs Appearing
```logql
# 1. Check if Promtail is sending
{job="docker"}

# 2. Check specific container logs
{container="watch_promtail"}

# 3. Verify container is on kompose network
docker network inspect kompose

# 4. Restart services
docker compose -f +utility/watch/compose.yaml restart promtail loki
```

### Query Too Slow
```logql
# 1. Add more labels to filter
{compose_project="core", compose_service="postgres"}  # Good
{job="docker"} |= "error"  # Too broad

# 2. Reduce time range
{compose_project="core"}[1h]  # Better than [24h]

# 3. Use metric queries instead of log queries
sum(rate({level="error"}[5m]))  # Faster than counting logs
```

## 🛠️ Common Operations

### View Recent Logs
```bash
# Via Grafana (recommended)
# Explore → Loki → Query → Live Tail

# Via LogCLI (if installed)
logcli query '{compose_project="core"}' --tail -f

# Via Docker logs (individual containers)
docker logs -f core-postgres
```

### Export Logs
```bash
# From Grafana: Query → Inspector → Download CSV/JSON

# Via LogCLI
logcli query '{compose_project="auth"}' \
  --from="2024-01-15T10:00:00Z" \
  --to="2024-01-15T11:00:00Z" \
  --output=jsonl > auth-logs.jsonl
```

### Maintenance
```bash
# Check storage usage
docker exec watch_loki du -sh /loki

# View retention settings
docker exec watch_loki cat /etc/loki/loki-config.yaml | grep retention

# Force compaction (run during low traffic)
docker compose -f +utility/watch/compose.yaml restart loki
```

## 📚 Quick Tips

1. **Always filter by labels first** for faster queries
2. **Use log levels** when available (`level="error"`)
3. **Limit time range** to what you need
4. **Use metric queries** for aggregations
5. **Save frequently used queries** in Grafana
6. **Create alerts** for critical log patterns
7. **Use regex sparingly** (they're slower)
8. **Leverage JSON parsing** for structured logs

## 🎓 Learning LogQL

### Basic Syntax
```logql
{label="value"}                    # Filter by label
{label=~"regex"}                   # Regex match
{label!="value"}                   # Not equal
{label=~"value1|value2"}          # Multiple values
```

### Log Pipeline
```logql
{label="value"} |= "text"         # Contains text
{label="value"} != "text"         # Doesn't contain
{label="value"} |~ "regex"        # Regex match
{label="value"} !~ "regex"        # Regex not match
{label="value"} | json            # Parse JSON
{label="value"} | logfmt          # Parse logfmt
{label="value"} | regexp "(?P<name>...)" # Extract fields
```

### Aggregations
```logql
count_over_time({label="value"}[1h])      # Count
rate({label="value"}[5m])                 # Rate per second
sum by (label) (count_over_time(...))     # Sum by label
avg by (label) (rate(...))                # Average by label
topk(5, sum(...))                         # Top 5
bottomk(5, sum(...))                      # Bottom 5
```

## 🔗 Resources

- **LogQL Documentation**: https://grafana.com/docs/loki/latest/logql/
- **Grafana Explore**: https://grafana.localhost/explore
- **Loki GitHub**: https://github.com/grafana/loki
- **Full Guide**: `+utility/watch/LOGGING_GUIDE.md`
- **Setup Summary**: `+utility/watch/LOKI_SETUP_COMPLETE.md`

## 📝 Example Workflow

```bash
# 1. Start watch stack
cd +utility/watch && docker compose up -d

# 2. Open Grafana
open https://grafana.localhost

# 3. Navigate to Explore

# 4. Select Loki datasource

# 5. Enter query
{compose_project="core", level="error"}

# 6. Click "Run Query" or Enable "Live Tail"

# 7. Analyze results, create dashboard or alert
```

---

**Quick Access**: Grafana → Explore → Loki → Start Querying!

All services automatically send logs. Zero configuration needed! 🎉
