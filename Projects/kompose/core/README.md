# Core Stack - Infrastructure Services

## Overview

The **core** stack provides essential infrastructure services for the entire kompose ecosystem:

- **PostgreSQL** - Central relational database
- **Redis** - Cache and session storage
- **Mosquitto** - MQTT message broker for IoT
- **Redis Commander** - Web UI for Redis management

## Services

### PostgreSQL (core-postgres)

Central database server used by:
- n8n (workflow automation)
- Semaphore (Ansible UI)
- Gitea (git repository)
- Other application stacks

**Access:**
```bash
# Shell access
docker exec -it core-postgres psql -U kompose

# List databases
docker exec core-postgres psql -U kompose -l

# Backup database
./kompose.sh db backup -d postgres --compress

# Restore database
./kompose.sh db restore -f backup.sql.gz -d postgres
```

### Redis (core-redis)

High-performance key-value store for:
- Session management
- Caching
- Message queuing
- Real-time data

**Access:**
```bash
# Redis CLI
docker exec -it core-redis redis-cli -a <password>

# Get all keys
docker exec core-redis redis-cli -a <password> KEYS '*'

# Monitor commands
docker exec core-redis redis-cli -a <password> MONITOR
```

### Mosquitto MQTT (core-mqtt)

MQTT broker for IoT device communication:
- Home automation
- Sensor data
- Device control
- Real-time messaging

**Ports:**
- `1883` - MQTT protocol
- `9001` - WebSocket protocol

**Test Connection:**
```bash
# Subscribe to topic
mosquitto_sub -h localhost -t 'test/#' -v

# Publish message
mosquitto_pub -h localhost -t 'test/hello' -m 'Hello World'
```

### Redis Commander (core-redis-api)

Web-based Redis management interface.

**Access:** http://localhost:8081

**Features:**
- View all keys and values
- Execute Redis commands
- Monitor performance
- Manage databases

## Quick Start

### 1. Configure Environment

Copy and customize the environment file:
```bash
cp .env .env.local
nano .env.local
```

**Required settings:**
- `DB_PASSWORD` - PostgreSQL password
- `REDIS_PASSWORD` - Redis password
- `REDIS_API_PASSWORD` - Redis Commander password

### 2. Create Network (if not exists)

```bash
docker network create kompose
```

### 3. Start Core Stack

```bash
# Start all services
./kompose.sh up core

# Start specific service
cd core && docker-compose up -d postgres
```

### 4. Initialize Databases

Create databases for other services:
```bash
# Create n8n database
docker exec core-postgres psql -U kompose -c "CREATE DATABASE n8n;"

# Create semaphore database
docker exec core-postgres psql -U kompose -c "CREATE DATABASE semaphore;"

# Create gitea database
docker exec core-postgres psql -U kompose -c "CREATE DATABASE gitea;"
```

### 5. Verify Services

```bash
# Check status
./kompose.sh status core

# View logs
./kompose.sh logs core

# Check health
docker ps | grep core
```

## Configuration

### PostgreSQL Init Scripts

Place SQL scripts in `postgres/init/` to run on first startup:

```bash
# Example: Create additional users
echo "CREATE USER app_user WITH PASSWORD 'password';" > postgres/init/01-users.sql
```

### Mosquitto Security

For production, enable authentication:

1. Create password file:
```bash
docker exec core-mqtt mosquitto_passwd -c /mosquitto/config/passwd username
```

2. Update `mosquitto/config/mosquitto.conf`:
```conf
allow_anonymous false
password_file /mosquitto/config/passwd
```

3. Restart Mosquitto:
```bash
docker restart core-mqtt
```

## Database Management

### Backup All Databases

```bash
# Backup everything
./kompose.sh db backup --compress

# Backup specific database
./kompose.sh db backup -d n8n --compress
```

### Restore Database

```bash
./kompose.sh db restore -f backups/database/n8n_20241011.sql.gz -d n8n
```

### Database Status

```bash
./kompose.sh db status
```

## Monitoring

### View Logs

```bash
# All services
./kompose.sh logs core -f

# Specific service
docker logs core-postgres -f
docker logs core-redis -f
docker logs core-mqtt -f
```

### Check Health

```bash
# PostgreSQL
docker exec core-postgres pg_isready -U kompose

# Redis
docker exec core-redis redis-cli -a <password> PING

# Mosquitto
docker exec core-mqtt mosquitto_sub -t '$SYS/#' -C 1
```

### Container Stats

```bash
docker stats core-postgres core-redis core-mqtt core-redis-api
```

## Troubleshooting

### PostgreSQL Won't Start

```bash
# Check logs
docker logs core-postgres

# Check permissions
docker exec core-postgres ls -la /var/lib/postgresql/data

# Reset (WARNING: deletes data)
docker volume rm core_postgres_data
```

### Redis Connection Issues

```bash
# Test connection
docker exec core-redis redis-cli -a <password> PING

# Check config
docker exec core-redis redis-cli -a <password> CONFIG GET requirepass
```

### MQTT Not Receiving Messages

```bash
# Check config
docker exec core-mqtt cat /mosquitto/config/mosquitto.conf

# Test locally
docker exec core-mqtt mosquitto_pub -t test -m "hello"
docker exec core-mqtt mosquitto_sub -t test -C 1
```

## Security Best Practices

1. **Change Default Passwords** - Update all passwords in `.env`
2. **Restrict Network Access** - Use internal networking only
3. **Enable MQTT Authentication** - Configure password file
4. **Regular Backups** - Schedule automated backups
5. **Update Images** - Keep services up to date

## Dependencies

Other stacks depend on core services:

- **chain** - Uses core-postgres for n8n and Semaphore
- **gitea** - Uses core-postgres
- **dock** - May use core-redis for caching
- **Home Assistant** - May use core-mqtt for IoT devices

**Always start core stack first:**
```bash
./kompose.sh up core
./kompose.sh up chain
./kompose.sh up gitea
```

## Volume Management

### Backup Volumes

```bash
# PostgreSQL data
docker run --rm -v core_postgres_data:/data -v $(pwd)/backups:/backup alpine tar czf /backup/postgres-data.tar.gz /data

# Redis data
docker run --rm -v core_redis_data:/data -v $(pwd)/backups:/backup alpine tar czf /backup/redis-data.tar.gz /data
```

### Inspect Volumes

```bash
docker volume inspect core_postgres_data
docker volume inspect core_redis_data
```

## Upgrading

### Update Images

```bash
# Pull latest
./kompose.sh pull core

# Stop and restart
./kompose.sh down core
./kompose.sh up core
```

### Major Version Upgrades

For PostgreSQL major versions:

1. Backup all databases
2. Stop core stack
3. Update image version in `.env`
4. Use pg_upgrade or restore from backup
5. Start core stack

## Maintenance

### Clean Logs

```bash
# Truncate PostgreSQL logs
docker exec core-postgres sh -c 'echo "" > /var/log/postgresql/postgresql.log'

# Clean Redis logs (if logging enabled)
docker exec core-redis redis-cli -a <password> CONFIG SET save ""
```

### Optimize PostgreSQL

```bash
# Vacuum databases
docker exec core-postgres psql -U kompose -d n8n -c "VACUUM ANALYZE;"

# Reindex
docker exec core-postgres psql -U kompose -d n8n -c "REINDEX DATABASE n8n;"
```

## Resources

- PostgreSQL: https://www.postgresql.org/docs/
- Redis: https://redis.io/documentation
- Mosquitto: https://mosquitto.org/documentation/
- Redis Commander: https://joeferner.github.io/redis-commander/

## Support

For issues:
1. Check logs: `./kompose.sh logs core`
2. Verify config: `./kompose.sh validate core`
3. Check health: `docker ps | grep core`
4. Review this README
