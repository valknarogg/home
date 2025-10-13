# Core Stack

The core infrastructure stack provides essential services for the entire Kompose system.

## Overview

The core stack is the foundation of Kompose, providing:
- **Database** - PostgreSQL for persistent data storage
- **Caching** - Redis for performance optimization
- **Messaging** - MQTT for real-time event communication
- **Management** - Redis Commander for cache visualization

All other Kompose services depend on the core stack.

## Configuration

> **New in v2.0**: Core stack configuration is now centralized in the root `.env` file with `CORE_` prefix.

### Environment Variables

All core stack variables are defined in `/home/valknar/Projects/kompose/.env`:

```bash
# ===================================================================
# CORE STACK CONFIGURATION
# ===================================================================
CORE_COMPOSE_PROJECT_NAME=core

# PostgreSQL Configuration
CORE_POSTGRES_IMAGE=postgres:16-alpine
CORE_DB_USER=valknar
CORE_DB_NAME=kompose
CORE_DB_PORT=5432
CORE_DB_HOST=core-postgres
CORE_POSTGRES_MAX_CONNECTIONS=100
CORE_POSTGRES_SHARED_BUFFERS=256MB

# Redis Configuration
CORE_REDIS_IMAGE=redis:7-alpine

# Mosquitto MQTT Configuration
CORE_MOSQUITTO_IMAGE=eclipse-mosquitto:2
CORE_MQTT_PORT=1883
CORE_MQTT_WS_PORT=9001

# Redis Commander (Web UI)
CORE_REDIS_COMMANDER_IMAGE=rediscommander/redis-commander:latest
CORE_REDIS_API_USER=admin
CORE_REDIS_API_PORT=8081
CORE_REDIS_API_TRAEFIK_HOST=redis.${ROOT_DOMAIN}
```

### Secrets

Sensitive values are stored in `/home/valknar/Projects/kompose/secrets.env`:

```bash
# Core stack secrets
CORE_DB_PASSWORD=xxx
CORE_REDIS_PASSWORD=xxx
CORE_REDIS_API_PASSWORD=xxx
```

Generate secrets with:
```bash
./kompose.sh secrets generate
```

### Viewing Configuration

```bash
# Show all core stack variables
./kompose.sh env show core

# Validate core configuration
./kompose.sh env validate core
```

## Services

### PostgreSQL
- **Image:** `postgres:16-alpine`
- **Container:** `core-postgres`
- **Port:** 5432 (internal only)
- **Purpose:** Relational database for all services
- **Auto-initialization:** Creates databases on first start
- **Health checks:** Built-in readiness probes

**Configuration:**
```bash
CORE_POSTGRES_IMAGE=postgres:16-alpine
CORE_DB_USER=valknar
CORE_DB_NAME=kompose
CORE_POSTGRES_MAX_CONNECTIONS=100
CORE_POSTGRES_SHARED_BUFFERS=256MB
```

**Databases Created:**
All databases required by Kompose stacks are automatically created on first initialization:
- `kompose` - Main application database
- `n8n` - Workflow automation data (Chain stack)
- `semaphore` - Ansible automation data (Chain stack)
- `gitea` - Git repositories and CI/CD data (Code stack)
- `keycloak` - Authentication and SSO data (Auth stack)
- `letterspace` - Newsletter service data (News stack)

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

**Configuration:**
```bash
CORE_REDIS_IMAGE=redis:7-alpine
CORE_REDIS_PASSWORD=${REDIS_PASSWORD}  # from secrets.env
```

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

**Configuration:**
```bash
CORE_MOSQUITTO_IMAGE=eclipse-mosquitto:2
CORE_MQTT_PORT=1883
CORE_MQTT_WS_PORT=9001
```

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

**Configuration:**
```bash
CORE_REDIS_COMMANDER_IMAGE=rediscommander/redis-commander:latest
CORE_REDIS_API_USER=admin
CORE_REDIS_API_PORT=8081
CORE_REDIS_API_TRAEFIK_HOST=redis.${ROOT_DOMAIN}
CORE_REDIS_API_PASSWORD=${REDIS_API_PASSWORD}  # from secrets.env
```

## Quick Start

### 1. Configure Environment

All configuration is in the root `.env` file. Review and adjust core stack settings:

```bash
vim .env
# Scroll to CORE STACK CONFIGURATION section
# Adjust values as needed
```

### 2. Configure Secrets

Add passwords to `secrets.env`:

```bash
vim secrets.env

# Add or verify:
CORE_DB_PASSWORD=<strong-password>
CORE_REDIS_PASSWORD=<strong-password>
CORE_REDIS_API_PASSWORD=<strong-password>
```

Or generate all secrets:
```bash
./kompose.sh secrets generate
```

### 3. Start Core Stack

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

### 4. Verify Databases

```bash
# List databases
docker exec core-postgres psql -U valknar -l

# Should show all Kompose databases:
# - kompose (Main application)
# - n8n (Workflow automation)
# - semaphore (Ansible automation)
# - gitea (Git repository)
# - keycloak (Authentication)
# - letterspace (Newsletter service)

# Check database status
./kompose.sh db status
```

## Customizing Configuration

### Change PostgreSQL Settings

Edit root `.env`:

```bash
vim .env

# Find and modify:
CORE_POSTGRES_MAX_CONNECTIONS=200
CORE_POSTGRES_SHARED_BUFFERS=512MB

# Restart
./kompose.sh restart core
```

### Change Redis Port

```bash
vim .env

# Modify:
CORE_REDIS_PORT=6380  # if exposing externally

# Update compose.yaml to expose port (uncomment):
# ports:
#   - "${CORE_REDIS_PORT}:6379"

./kompose.sh restart core
```

### Enable MQTT Authentication

```bash
# Edit mosquitto config
vim core/mosquitto/config/mosquitto.conf

# Add:
allow_anonymous false
password_file /mosquitto/config/passwd

# Create password file
docker exec core-mqtt mosquitto_passwd -b /mosquitto/config/passwd kompose <password>

# Restart
docker restart core-mqtt
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
docker exec -it core-redis redis-cli -a <CORE_REDIS_PASSWORD>

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

Access: `http://localhost:8081` or `https://redis.yourdomain.com`

**Features:**
- Browse keys by pattern
- View key values (string, hash, list, set, zset)
- Delete keys
- Rename keys
- Set TTL
- Monitor memory usage
- Execute commands

**Authentication:**
- Username: From `CORE_REDIS_API_USER` (default: `admin`)
- Password: From `secrets.env` → `CORE_REDIS_API_PASSWORD`

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

## Monitoring

### Health Checks

```bash
# PostgreSQL
docker exec core-postgres pg_isready -U valknar

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

## Troubleshooting

### PostgreSQL Issues

**Container won't start:**
```bash
# Check configuration
./kompose.sh env validate core

# View logs
docker logs core-postgres

# Inspect container
docker inspect core-postgres
```

**Connection refused:**
```bash
# Check if running
docker ps | grep core-postgres

# Check network
docker network inspect kompose | grep core-postgres

# Test connection
docker exec core-postgres pg_isready -U valknar
```

**Databases not created:**
```bash
# Check init script logs
docker logs core-postgres | grep "init-databases"

# Manually create
docker exec core-postgres psql -U valknar -c "CREATE DATABASE n8n;"
```

### Redis Issues

**Connection refused:**
```bash
# Check if running
docker ps | grep core-redis

# Check password
docker exec core-redis redis-cli -a <password> PING

# Verify configuration
./kompose.sh env show core | grep REDIS
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

## See Also

- [Stack Configuration Overview](/reference/stack-configuration)
- [Environment Migration Guide](/guide/environment-migration)
- [Database Management Guide](/guide/database)
- [MQTT Events Guide](/guide/mqtt-events)
- [Monitoring Guide](/guide/monitoring)

---

**Configuration Location:** `/home/valknar/Projects/kompose/.env` (CORE section)  
**Secrets Location:** `/home/valknar/Projects/kompose/secrets.env`  
**Docker Network:** `kompose`
