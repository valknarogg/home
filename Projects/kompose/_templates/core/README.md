# Core Stack Template

Core infrastructure services providing the foundation for all other kompose stacks.

## Components

- **PostgreSQL 16** - Central relational database with auto-initialization
- **Redis 7** - In-memory cache and session store
- **Eclipse Mosquitto 2** - MQTT broker for IoT messaging
- **Redis Commander** - Web-based Redis management UI (optional)

## Quick Start

### Generate from template:
```bash
./kompose-generate.sh core
```

### Start the stack:
```bash
docker compose -f core/compose.yaml up -d
```

## Key Features

### PostgreSQL
- Automatic database creation for all kompose stacks
- Health monitoring with pg_isready
- Persistent storage with named volumes
- Performance tuning via environment variables

### Redis
- Session storage for OAuth2 Proxy
- Caching layer for applications
- Persistence enabled for data durability
- Health checks with redis-cli

### MQTT Broker
- Standard MQTT protocol (port 1883)
- WebSocket support (port 9001)
- Configurable security settings
- Ideal for IoT and home automation

### Redis Commander
- Web UI for Redis management
- Optional Traefik integration
- Basic auth protection
- Real-time key monitoring

## Dependencies

**Required by:**
- auth (Keycloak database)
- chain (n8n, Semaphore databases)
- code (Gitea database)
- news (Letterspace database)
- home (MQTT for IoT devices)

**Requires:** None (foundational stack)

## Configuration

### Environment Variables

See `kompose.yml` for full configuration options. Key variables:

- `CORE_COMPOSE_PROJECT_NAME` - Project name (default: core)
- `DB_USER` - PostgreSQL username (default: kompose)
- `DB_PASSWORD` - PostgreSQL password (from secrets)
- `CORE_DB_NAME` - Main database name (default: kompose)
- `NETWORK_NAME` - Docker network (default: kompose)

### Secrets

- `DB_PASSWORD` - Shared database password (32 chars)
- `CORE_REDIS_API_PASSWORD` - Redis Commander password (24 chars)
- `REDIS_PASSWORD` - Redis auth password (optional)

## Ports

- `5432` - PostgreSQL (internal only)
- `6379` - Redis (internal only)
- `1883` - MQTT broker (exposed)
- `9001` - MQTT WebSocket (exposed)
- `8081` - Redis Commander UI (exposed)

## Volumes

- `postgres_data` - Database files (backup recommended)
- `redis_data` - Redis persistence (backup recommended)
- `mosquitto_data` - MQTT persistent storage
- `mosquitto_logs` - MQTT log files

## Management

### Database Operations
```bash
# List databases
docker exec core_postgres psql -U kompose -c "\l"

# Access database shell
docker exec -it core_postgres psql -U kompose -d keycloak

# Backup all databases
./kompose.sh db backup -d all --timestamp

# Restore database
./kompose.sh db restore -f backup.sql
```

### Redis Operations
```bash
# Access Redis CLI
docker exec -it core_redis redis-cli

# View all keys
docker exec core_redis redis-cli KEYS "*"

# Access web UI
http://localhost:8081
# or via Traefik: https://redis.yourdomain.com
```

### MQTT Operations
```bash
# Subscribe to topic
docker exec core_mqtt mosquitto_sub -t "test/#" -v

# Publish message
docker exec core_mqtt mosquitto_pub -t "test/msg" -m "Hello"

# Monitor all topics
docker exec core_mqtt mosquitto_sub -t "#" -v

# View broker stats
docker exec core_mqtt mosquitto_sub -t '$SYS/#' -v
```

## Initialization

On first start, PostgreSQL automatically creates these databases:
- `kompose` - Main application
- `keycloak` - Authentication
- `gitea` - Git repository
- `n8n` - Workflow automation
- `semaphore` - Ansible tasks
- `letterspace` - Newsletter

See `postgres/init/01-init-databases.sh` to add more databases.

## Security

### Production Checklist
- [ ] Use strong, unique DB_PASSWORD (auto-generated)
- [ ] Don't expose PostgreSQL port externally
- [ ] Configure MQTT authentication (disable allow_anonymous)
- [ ] Enable Redis password authentication
- [ ] Use Traefik with SSL/TLS for Redis Commander
- [ ] Set up MQTT ACLs for access control
- [ ] Regular security updates (docker pull latest images)

### MQTT Security Setup
```bash
# Create password file
docker exec core_mqtt mosquitto_passwd -c /mosquitto/config/passwd username

# Update mosquitto.conf:
# allow_anonymous false
# password_file /mosquitto/config/passwd
```

## Troubleshooting

### PostgreSQL Issues
```bash
# Check logs
docker logs core_postgres

# Verify database creation
docker logs core_postgres | grep "database"

# Test connection
docker exec core_postgres pg_isready -U kompose
```

### Redis Issues
```bash
# Check logs
docker logs core_redis

# Test connection
docker exec core_redis redis-cli ping

# View memory usage
docker exec core_redis redis-cli INFO memory
```

### MQTT Issues
```bash
# Check logs
docker logs core_mqtt

# Test health
docker exec core_mqtt mosquitto_sub -t '$SYS/#' -C 1 -W 3

# Verify configuration
docker exec core_mqtt cat /mosquitto/config/mosquitto.conf
```

## Performance Tuning

### PostgreSQL
```bash
# Adjust in .env:
CORE_POSTGRES_MAX_CONNECTIONS=200
CORE_POSTGRES_SHARED_BUFFERS=512MB

# Monitor performance
docker stats core_postgres
```

### Redis
```bash
# Check memory usage
docker exec core_redis redis-cli INFO memory

# Monitor operations
docker exec core_redis redis-cli MONITOR

# Get stats
docker stats core_redis
```

## Backup Strategy

### Automated Backups
```bash
# Add to crontab:
0 2 * * * cd /path/to/kompose && ./kompose.sh db backup -d all --timestamp --compress
```

### Manual Backup
```bash
# Database
./kompose.sh db backup -d all --timestamp

# Redis
docker exec core_redis redis-cli SAVE
docker cp core_redis:/data/dump.rdb ./backups/redis-backup.rdb

# Volumes
docker run --rm -v core_postgres_data:/data -v $(pwd)/backups:/backup alpine tar czf /backup/postgres-data.tar.gz -C /data .
```

## Monitoring

### Health Checks
All services include health checks:
- PostgreSQL: `pg_isready`
- Redis: `redis-cli ping`
- MQTT: Subscribe test
- Redis Commander: HTTP ping

### Resource Monitoring
```bash
# Real-time stats
docker stats core_postgres core_redis core_mqtt

# Disk usage
docker system df -v | grep core
```

## Integration

### With Other Stacks

**Auth Stack** (Keycloak):
```yaml
environment:
  CORE_DB_HOST: core_postgres
  AUTH_DB_NAME: keycloak
```

**Chain Stack** (n8n):
```yaml
environment:
  CORE_DB_HOST: core_postgres
  CHAIN_DB_NAME: n8n
  CORE_REDIS_HOST: core_redis
```

**Home Stack** (IoT):
```yaml
environment:
  CORE_MQTT_HOST: core_mqtt
  CORE_MQTT_PORT: 1883
```

## Advanced Topics

### Custom PostgreSQL Config
Create `postgres/postgresql.conf` and mount it in compose.yaml

### Custom Redis Config  
Create `redis/redis.conf` and mount it in compose.yaml

### MQTT SSL/TLS
1. Generate certificates
2. Update mosquitto.conf
3. Mount cert volumes in compose.yaml

### Clustering
For high availability, consider:
- PostgreSQL replication
- Redis Sentinel/Cluster
- MQTT bridge configuration

## Support

For issues or questions:
1. Check logs: `docker logs <container>`
2. Review kompose.yml for configuration
3. Consult official documentation:
   - PostgreSQL: https://www.postgresql.org/docs/
   - Redis: https://redis.io/documentation
   - Mosquitto: https://mosquitto.org/documentation/

## Version History

- 1.0.0 - Initial template release
  - PostgreSQL 16 with auto-init
  - Redis 7 with persistence
  - Mosquitto 2 with WebSocket
  - Redis Commander UI
