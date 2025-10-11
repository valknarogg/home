# Core Stack Setup - Migration Guide

## Changes Made

### ✅ Completed Tasks

1. **Created Core Stack Infrastructure**
   - Created `core/compose.yaml` with PostgreSQL, Redis, Mosquitto, and Redis Commander
   - Created `core/.env` with default configuration
   - Created `core/README.md` with comprehensive documentation
   - Created `core/mosquitto/config/mosquitto.conf` for MQTT broker
   - Created `core/postgres/init/01-init-databases.sh` for automatic database creation

2. **Removed Home Stack**
   - Moved `home/` directory to `backups/removed-stacks/home/`
   - Home Assistant and its mosquitto service are now backed up
   - The "home" stack has been completely removed from active stacks

3. **Core Services Now Include**
   - PostgreSQL 16 (core-postgres) - Central database
   - Redis 7 (core-redis) - Cache and session storage
   - Mosquitto 2 (core-mqtt) - MQTT message broker
   - Redis Commander (core-redis-api) - Redis web UI

## Architecture

### Before
```
home/
├── compose.yaml (Home Assistant + Mosquitto)
└── .env

core/
├── postgres/ (config only, no compose.yaml)
├── mosquitto/ (config only)
└── redis-api/ (config only)
```

### After
```
core/
├── compose.yaml ✨ NEW - Full infrastructure stack
├── .env ✨ NEW - Stack configuration
├── README.md ✨ NEW - Documentation
├── postgres/
│   └── init/
│       └── 01-init-databases.sh ✨ NEW - Auto-create databases
└── mosquitto/
    └── config/
        └── mosquitto.conf ✨ NEW - MQTT configuration

backups/removed-stacks/
└── home/ (Home Assistant - archived)
```

## Quick Start

### 1. Configure Secrets

Edit or create `secrets.env` in the project root:

```bash
# PostgreSQL
DB_USER=kompose
POSTGRES_PASSWORD=<secure_password>

# Redis
REDIS_PASSWORD=<secure_password>

# Redis Commander
REDIS_API_PASSWORD=<secure_password>
```

### 2. Create Network (if not exists)

```bash
docker network create kompose
```

### 3. Start Core Stack

```bash
# Using kompose.sh
./kompose.sh up core

# Or manually
cd core
docker-compose up -d
```

### 4. Verify Services

```bash
# Check status
./kompose.sh status core

# Should show:
# - core-postgres (healthy)
# - core-redis (healthy)
# - core-mqtt (healthy)
# - core-redis-api (healthy)
```

### 5. Verify Databases

The init script automatically creates these databases:
- `kompose` (default)
- `n8n` (for workflow automation)
- `semaphore` (for Ansible UI)
- `gitea` (for git repository)

Check they exist:
```bash
docker exec core-postgres psql -U kompose -l
```

## Service Details

### PostgreSQL (core-postgres)
- **Image**: postgres:16-alpine
- **Port**: Internal only (5432)
- **Volume**: core_postgres_data
- **Users**: kompose (superuser)
- **Databases**: kompose, n8n, semaphore, gitea

**Access:**
```bash
# Shell
docker exec -it core-postgres psql -U kompose

# List databases
docker exec core-postgres psql -U kompose -l
```

### Redis (core-redis)
- **Image**: redis:7-alpine
- **Port**: Internal only (6379)
- **Volume**: core_redis_data
- **Authentication**: Password protected

**Access:**
```bash
# CLI
docker exec -it core-redis redis-cli -a <password>

# Test
docker exec core-redis redis-cli -a <password> PING
```

### Mosquitto (core-mqtt)
- **Image**: eclipse-mosquitto:2
- **Ports**: 1883 (MQTT), 9001 (WebSocket)
- **Volumes**: mosquitto_data, mosquitto_logs
- **Authentication**: Anonymous (change for production)

**Access:**
```bash
# Subscribe
mosquitto_sub -h localhost -t 'test/#'

# Publish
mosquitto_pub -h localhost -t 'test/hello' -m 'Hello'
```

### Redis Commander (core-redis-api)
- **Image**: rediscommander/redis-commander
- **Port**: 8081
- **Access**: http://localhost:8081
- **Authentication**: HTTP Basic Auth

## Integration with Other Stacks

### Chain Stack (n8n + Semaphore)

The chain stack already references `core-postgres`. Ensure it's running before starting chain:

```bash
# Check chain/.env has correct DB_HOST
grep DB_HOST chain/.env
# Should show: DB_HOST=core-postgres

# Start in order
./kompose.sh up core
./kompose.sh up chain
```

### Gitea Stack

If using Gitea, update its configuration to use `core-postgres`:

```yaml
# gitea/compose.yaml
services:
  gitea:
    environment:
      - DB_TYPE=postgres
      - DB_HOST=core-postgres:5432
      - DB_NAME=gitea
      - DB_USER=kompose
      - DB_PASSWD=${DB_PASSWORD}
```

### Other Stacks

Any stack needing database, cache, or MQTT:

```yaml
# In stack's compose.yaml
services:
  your-app:
    environment:
      DATABASE_URL: postgresql://kompose:${DB_PASSWORD}@core-postgres:5432/your_db
      REDIS_URL: redis://:${REDIS_PASSWORD}@core-redis:6379
      MQTT_BROKER: mqtt://core-mqtt:1883
    networks:
      - kompose_network
```

## Migration from Home Stack

If you were using Home Assistant from the old `home` stack:

### Option 1: Standalone Home Assistant

Create a new dedicated stack for Home Assistant:

```bash
mkdir homeassistant
cd homeassistant
# Copy from backups/removed-stacks/home/
cp ../backups/removed-stacks/home/compose.yaml .
cp ../backups/removed-stacks/home/.env .
# Update as needed
docker-compose up -d
```

### Option 2: Use Home Assistant Add-on

Install Home Assistant as a separate service outside Docker.

## Backup & Restore

### Backup All Databases

```bash
# Using kompose.sh
./kompose.sh db backup --compress

# Manual backup
docker exec core-postgres pg_dumpall -U kompose | gzip > backup.sql.gz
```

### Restore Database

```bash
# Using kompose.sh
./kompose.sh db restore -f backup.sql.gz -d n8n

# Manual restore
gunzip -c backup.sql.gz | docker exec -i core-postgres psql -U kompose -d n8n
```

### Backup Volumes

```bash
# PostgreSQL data
docker run --rm -v core_postgres_data:/data -v $(pwd)/backups:/backup alpine \
  tar czf /backup/postgres-$(date +%Y%m%d).tar.gz /data

# Redis data
docker run --rm -v core_redis_data:/data -v $(pwd)/backups:/backup alpine \
  tar czf /backup/redis-$(date +%Y%m%d).tar.gz /data
```

## Security Hardening

### 1. Change Default Passwords

Update in `secrets.env`:
```bash
POSTGRES_PASSWORD=$(openssl rand -base64 32)
REDIS_PASSWORD=$(openssl rand -base64 32)
REDIS_API_PASSWORD=$(openssl rand -base64 32)
```

### 2. Enable MQTT Authentication

```bash
# Create password file
docker exec core-mqtt mosquitto_passwd -c /mosquitto/config/passwd admin

# Update mosquitto.conf
allow_anonymous false
password_file /mosquitto/config/passwd

# Restart
docker restart core-mqtt
```

### 3. Restrict Network Access

In `compose.yaml`, remove port exposures for internal services:
```yaml
# Comment out these lines:
# ports:
#   - "5432:5432"  # PostgreSQL
#   - "6379:6379"  # Redis
```

### 4. Enable PostgreSQL SSL

Add to `core/.env`:
```bash
POSTGRES_SSL_MODE=require
```

## Troubleshooting

### Core Stack Won't Start

```bash
# Check network exists
docker network ls | grep kompose

# Create if missing
docker network create kompose

# Check logs
docker-compose -f core/compose.yaml logs
```

### Database Connection Errors

```bash
# Verify PostgreSQL is ready
docker exec core-postgres pg_isready -U kompose

# Check if databases exist
docker exec core-postgres psql -U kompose -l

# Restart services
./kompose.sh restart core
```

### Chain Stack Can't Connect to Database

```bash
# Verify container names
docker ps | grep core-postgres

# Test connectivity from chain
docker exec chain_n8n ping -c 1 core-postgres

# Check network membership
docker network inspect kompose | grep -A 5 chain
```

### Redis Authentication Issues

```bash
# Test password
docker exec core-redis redis-cli -a <password> PING

# Check password in config
docker exec core-redis redis-cli CONFIG GET requirepass
```

## Monitoring

### Health Checks

```bash
# All services
docker ps | grep core

# Specific service
docker inspect core-postgres | grep -A 10 Health
```

### Resource Usage

```bash
# Stats
docker stats core-postgres core-redis core-mqtt

# Disk usage
docker system df
docker volume ls
```

### Logs

```bash
# All core services
./kompose.sh logs core -f

# Specific service
docker logs core-postgres -f --tail 100
```

## Next Steps

1. **Start Dependent Stacks**
   ```bash
   ./kompose.sh up chain
   ./kompose.sh up gitea
   ```

2. **Configure Applications**
   - Access n8n: http://localhost:5678
   - Access Semaphore: http://localhost:3000
   - Access Redis UI: http://localhost:8081

3. **Create Backups**
   ```bash
   ./kompose.sh db backup --compress
   ```

4. **Review Security**
   - Change default passwords
   - Enable MQTT authentication
   - Configure SSL/TLS

## Files Created

```
core/
├── compose.yaml              # Docker Compose configuration
├── .env                      # Environment variables
├── README.md                 # Service documentation
├── postgres/
│   └── init/
│       └── 01-init-databases.sh  # Database initialization
└── mosquitto/
    └── config/
        └── mosquitto.conf    # MQTT broker configuration
```

## Summary

✅ Core infrastructure stack is now properly configured
✅ PostgreSQL, Redis, and Mosquitto are ready to use
✅ Automatic database creation on first start
✅ Home Assistant stack backed up and removed
✅ Ready for dependent stacks (chain, gitea, etc.)

**Start the core stack:**
```bash
./kompose.sh up core
```

**Check it's working:**
```bash
./kompose.sh status core
```

You're all set! 🚀
