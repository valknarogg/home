# Core Stack Quick Reference

Quick reference for the core infrastructure stack.

## Services

| Service | Container | Port | Purpose |
|---------|-----------|------|---------|
| PostgreSQL | core-postgres | 5432 | Database |
| Redis | core-redis | 6379 | Cache & Sessions |
| MQTT | core-mqtt | 1883, 9001 | Message Broker |
| Redis UI | core-redis-api | 8081 | Redis Management |

## Quick Commands

```bash
# Start core stack
./kompose.sh up core

# Stop core stack
./kompose.sh down core

# Restart core stack
./kompose.sh restart core

# Check status
./kompose.sh status core

# View logs
./kompose.sh logs core -f
```

## PostgreSQL

### Access Database
```bash
# Interactive shell
./kompose.sh db shell

# Execute query
./kompose.sh db exec -d kompose "SELECT * FROM users LIMIT 5;"

# Backup database
./kompose.sh db backup

# Restore database
./kompose.sh db restore -f backup.sql
```

### Available Databases
- `kompose` - Main application database
- `n8n` - Workflow automation
- `semaphore` - Ansible automation
- `gitea` - Git repository

## Redis

### Access Redis
```bash
# Redis CLI
docker exec -it core-redis redis-cli -a <password>

# Get keys
redis-cli -a <password> KEYS "*"

# Monitor commands
redis-cli -a <password> MONITOR
```

### Redis UI
Access: `http://localhost:8081`
- View all keys
- Inspect values
- Monitor performance

## MQTT

### Subscribe to Messages
```bash
# All messages
mosquitto_sub -h localhost -t "#" -v

# Service events
mosquitto_sub -h localhost -t "kompose/#" -v
```

### Publish Message
```bash
mosquitto_pub -h localhost -t "test" -m "hello"
```

### Monitor Broker
```bash
# System stats
mosquitto_sub -h localhost -t '$SYS/#' -C 10

# Connected clients
mosquitto_sub -h localhost -t '$SYS/broker/clients/total' -C 1
```

## Health Checks

```bash
# PostgreSQL
docker exec core-postgres pg_isready -U kompose

# Redis
docker exec core-redis redis-cli -a <password> PING

# MQTT
mosquitto_pub -h localhost -t test -m hello
```

## Environment Variables

Located in `core/.env`:

```bash
# PostgreSQL
POSTGRES_USER=kompose
POSTGRES_PASSWORD=<secret>
POSTGRES_DB=kompose

# Redis
REDIS_PASSWORD=<secret>

# MQTT
MQTT_USERNAME=kompose
MQTT_PASSWORD=<secret>
```

## Volumes

```bash
core_postgres_data    # PostgreSQL data
core_redis_data       # Redis data
core_mqtt_data        # MQTT data
core_mqtt_logs        # MQTT logs
```

## Troubleshooting

### PostgreSQL won't start
```bash
docker logs core-postgres
docker exec core-postgres pg_isready -U kompose
```

### Redis connection refused
```bash
docker logs core-redis
docker exec core-redis redis-cli -a <password> PING
```

### MQTT not accessible
```bash
docker logs core-mqtt
docker ps | grep core-mqtt
```

## See Also

- [Core Stack Guide](/stacks/core)
- [Database Management](/guide/database)
