# Core Stack

The core infrastructure stack provides essential services for the entire Kompose system.

## Overview

The core stack is the foundation of Kompose, providing:
- **Database** - PostgreSQL for persistent data storage
- **Caching** - Redis for performance optimization
- **Messaging** - MQTT for real-time event communication
- **Management** - Redis Commander for cache visualization

All other Kompose services depend on the core stack.

## Services

### PostgreSQL
- **Image:** `postgres:16-alpine`
- **Container:** `core-postgres`
- **Port:** 5432 (internal only)
- **Purpose:** Relational database for all services
- **Auto-initialization:** Creates databases on first start
- **Health checks:** Built-in readiness probes

**Databases Created:**
- `kompose` - Main application database
- `n8n` - Workflow automation data
- `semaphore` - Ansible automation data
- `gitea` - Git repositories and CI/CD data

### Redis
- **Image:** `redis:7-alpine`
- **Container:** `core-redis`
- **Port:** 6379 (internal only)
- **Purpose:** Caching and session storage
- **Features:**
  - Password protected
  - AOF persistence enabled
  - Health monitoring
  - Used by multiple services for caching

### Mosquitto MQTT
- **Image:** `eclipse-mosquitto:latest`
- **Container:** `core-mqtt`
- **Ports:** 
  - 1883 - MQTT Protocol
  - 9001 - WebSocket
- **Purpose:** Event message broker for service communication
- **Features:**
  - Real-time event publishing
  - Persistent messages
  - Anonymous access (configurable)
  - WebSocket support for web clients

### Redis Commander
- **Image:** `ghcr.io/joeferner/redis-commander:latest`
- **Container:** `core-redis-api`
- **Port:** 8081 (HTTP)
- **Purpose:** Web-based Redis management UI
- **Access:** `http://localhost:8081` or `https://redis.yourdomain.com`
- **Features:**
  - View all Redis keys
  - Inspect values
  - Real-time monitoring
  - HTTP authentication

## Quick Start

### 1. Configure Secrets

Add to `secrets.env`:

```bash
# PostgreSQL
POSTGRES_PASSWORD=$(openssl rand -base64 32)

# Redis
REDIS_PASSWORD=$(openssl rand -base64 32)
REDIS_API_PASSWORD=$(openssl rand -base64 32)
```

### 2. Start Core Stack

```bash
# Create network (if not exists)
docker network create kompose

# Start services
./kompose.sh up core

# Verify
./kompose.sh status core
```

Expected output:
```
✓ core-postgres (healthy)
✓ core-redis (healthy)
✓ core-mqtt (healthy)
✓ core-redis-api (healthy)
```

### 3. Verify Databases

```bash
# List databases
docker exec core-postgres psql -U kompose -l

# Should show:
# - kompose
# - n8n
# - semaphore
# - gitea
```

## Configuration

Located in `core/.env`:

```bash
# Compose Settings
COMPOSE_PROJECT_NAME=core
NETWORK_NAME=kompose

# PostgreSQL
POSTGRES_USER=kompose
POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
POSTGRES_DB=kompose

# Redis
REDIS_PASSWORD=${REDIS_PASSWORD}

# Redis Commander
REDIS_API_PASSWORD=${REDIS_API_PASSWORD}

# MQTT (optional authentication)
# MQTT_USERNAME=kompose
# MQTT_PASSWORD=${MQTT_PASSWORD}
```

## Database Management

### Backup

```bash
# Backup all databases
./kompose.sh db backup

# Backup specific database
./kompose.sh db backup -d n8n

# Backup with compression
./kompose.sh db backup --compress
```

Backups stored in: `./backups/database/`

### Restore

```bash
# Restore from backup
./kompose.sh db restore -f backups/database/n8n_20250112-120000.sql

# Restore compressed backup
./kompose.sh db restore -f backups/database/gitea_20250112-120000.sql.gz
```

### Database Shell

```bash
# Interactive PostgreSQL shell
./kompose.sh db shell

# Shell for specific database
./kompose.sh db shell -d n8n

# Execute SQL command
./kompose.sh db exec -d kompose "SELECT version();"
```

### Database Status

```bash
./kompose.sh db status
```

Shows:
- Container status
- Available databases
- Database sizes
- Active connections

## Redis Management

### CLI Access

```bash
# Redis CLI
docker exec -it core-redis redis-cli -a <REDIS_PASSWORD>

# Get all keys
KEYS "*"

# Monitor real-time commands
MONITOR

# Get info
INFO

# Check memory usage
INFO MEMORY
```

### Web UI (Redis Commander)

Access: `http://localhost:8081`

**Features:**
- Browse keys by pattern
- View key values (string, hash, list, set, zset)
- Delete keys
- Rename keys
- Set TTL
- Monitor memory usage
- Execute commands

**Authentication:**
- Username: From `core/.env` → `REDIS_API_USER`
- Password: From `secrets.env` → `REDIS_API_PASSWORD`

## MQTT Management

### Subscribe to Events

```bash
# Subscribe to all events
mosquitto_sub -h localhost -t "#" -v

# Subscribe to Kompose events only
mosquitto_sub -h localhost -t "kompose/#" -v

# Subscribe to specific service
mosquitto_sub -h localhost -t "kompose/linkwarden/#" -v
```

### Publish Events

```bash
# Publish test message
mosquitto_pub -h localhost -t "kompose/test" -m "Hello World"

# Publish JSON event
mosquitto_pub -h localhost -t "kompose/test/event" \
  -m '{"event":"test","timestamp":"'$(date -Iseconds)'"}'
```

### Monitor Broker

```bash
# System statistics
mosquitto_sub -h localhost -t '$SYS/#' -C 10

# Connected clients
mosquitto_sub -h localhost -t '$SYS/broker/clients/total' -C 1

# Messages per second
mosquitto_sub -h localhost -t '$SYS/broker/messages/received' -C 1
```

### Enable Authentication (Optional)

Edit `core/mosquitto/config/mosquitto.conf`:

```conf
allow_anonymous false
password_file /mosquitto/config/passwd
```

Create password file:

```bash
docker exec core-mqtt mosquitto_passwd -b /mosquitto/config/passwd kompose <password>
docker restart core-mqtt
```

## Monitoring

### Health Checks

```bash
# PostgreSQL
docker exec core-postgres pg_isready -U kompose

# Redis
docker exec core-redis redis-cli -a <password> PING

# MQTT
mosquitto_pub -h localhost -t test -m hello
```

### Logs

```bash
# All core services
./kompose.sh logs core -f

# Specific service
docker logs core-postgres -f
docker logs core-redis -f
docker logs core-mqtt -f
```

### Resource Usage

```bash
# Docker stats
docker stats core-postgres core-redis core-mqtt

# Disk usage
docker system df -v | grep core_
```

### Prometheus Metrics

Core services export metrics for Prometheus:

- **PostgreSQL:** `http://core-postgres-exporter:9187/metrics`
- **Redis:** `http://core-redis-exporter:9121/metrics`
- **MQTT:** `http://core-mqtt-exporter:9000/metrics`

See [Monitoring Guide](/guide/monitoring) for details.

## Troubleshooting

### PostgreSQL Issues

**Container won't start:**
```bash
docker logs core-postgres
docker inspect core-postgres
```

**Connection refused:**
```bash
# Check if running
docker ps | grep core-postgres

# Check network
docker network inspect kompose | grep core-postgres

# Test connection
docker exec core-postgres pg_isready -U kompose
```

**Databases not created:**
```bash
# Check init script logs
docker logs core-postgres | grep "init-databases"

# Manually create
docker exec core-postgres psql -U kompose -c "CREATE DATABASE n8n;"
```

### Redis Issues

**Connection refused:**
```bash
# Check if running
docker ps | grep core-redis

# Check password
docker exec core-redis redis-cli -a <password> PING
```

**Out of memory:**
```bash
# Check memory usage
docker exec core-redis redis-cli -a <password> INFO MEMORY

# Clear database (careful!)
docker exec core-redis redis-cli -a <password> FLUSHALL
```

### MQTT Issues

**Can't connect:**
```bash
# Check if running
docker ps | grep core-mqtt

# Check config
docker exec core-mqtt cat /mosquitto/config/mosquitto.conf

# Test connection
mosquitto_sub -h localhost -t test -C 1
```

**Messages not received:**
```bash
# Check broker stats
mosquitto_sub -h localhost -t '$SYS/broker/messages/#' -C 5

# Test with verbose
mosquitto_sub -h localhost -t "#" -v
```

## Backup and Recovery

### Full Backup

```bash
#!/bin/bash
# Daily backup script

# PostgreSQL
./kompose.sh db backup --compress

# Redis (optional - data is cached)
docker exec core-redis redis-cli -a <password> BGSAVE

# MQTT (if using persistence)
docker exec core-mqtt cp -r /mosquitto/data /mosquitto/backup/

# Volumes
docker run --rm \
  -v core_postgres_data:/data \
  -v $(pwd)/backups:/backup \
  alpine tar czf /backup/postgres-data-$(date +%Y%m%d).tar.gz /data
```

### Disaster Recovery

```bash
# 1. Stop services
./kompose.sh down core

# 2. Remove volumes
docker volume rm core_postgres_data
docker volume rm core_redis_data

# 3. Restore volumes from backup
docker volume create core_postgres_data
docker run --rm \
  -v core_postgres_data:/data \
  -v $(pwd)/backups:/backup \
  alpine tar xzf /backup/postgres-data-20250112.tar.gz -C /

# 4. Start services
./kompose.sh up core

# 5. Verify
./kompose.sh db status
```

## Performance Tuning

### PostgreSQL

Edit `core/postgres/postgresql.conf`:

```conf
# Memory
shared_buffers = 256MB
effective_cache_size = 1GB

# Connections
max_connections = 200

# Performance
work_mem = 4MB
maintenance_work_mem = 64MB
```

### Redis

Edit `core/redis/redis.conf`:

```conf
# Memory
maxmemory 512mb
maxmemory-policy allkeys-lru

# Persistence
save 900 1
save 300 10
appendonly yes
```

## Security

### Best Practices

1. **Strong Passwords:** Use `openssl rand -base64 32`
2. **Internal Network:** Keep ports internal (no external exposure)
3. **Enable Auth:** Enable MQTT authentication
4. **Regular Backups:** Daily automated backups
5. **Monitor Access:** Check connection logs regularly
6. **Update Images:** Regular security updates

### Firewall Rules

```bash
# Only allow from Docker network
# No external access to core services

# If external access needed (not recommended):
sudo ufw allow from 10.0.0.0/8 to any port 5432 proto tcp  # PostgreSQL
sudo ufw allow from 10.0.0.0/8 to any port 6379 proto tcp  # Redis
sudo ufw allow from 10.0.0.0/8 to any port 1883 proto tcp  # MQTT
```

## Volumes

```bash
# List volumes
docker volume ls | grep core_

# Inspect volume
docker volume inspect core_postgres_data

# Backup volume
docker run --rm \
  -v core_postgres_data:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/postgres.tar.gz /data

# Remove unused volumes
docker volume prune
```

## See Also

- [Core Quick Reference](/reference/core-quick-reference)
- [Database Management Guide](/guide/database)
- [MQTT Events Guide](/guide/mqtt-events)
- [Monitoring Guide](/guide/monitoring)
