# Core Stack - Quick Reference

## 🚀 Quick Start

```bash
# 1. Create network
docker network create kompose

# 2. Configure secrets (required!)
echo "POSTGRES_PASSWORD=$(openssl rand -base64 32)" >> secrets.env
echo "REDIS_PASSWORD=$(openssl rand -base64 32)" >> secrets.env
echo "REDIS_API_PASSWORD=$(openssl rand -base64 32)" >> secrets.env

# 3. Start core stack
./kompose.sh up core

# 4. Verify
./kompose.sh status core
docker exec core-postgres psql -U kompose -l
```

## 📦 Services

| Service | Container | Port | Access |
|---------|-----------|------|--------|
| PostgreSQL | core-postgres | Internal | `docker exec -it core-postgres psql -U kompose` |
| Redis | core-redis | Internal | `docker exec -it core-redis redis-cli -a <password>` |
| Mosquitto | core-mqtt | 1883, 9001 | `mosquitto_sub -h localhost -t 'test/#'` |
| Redis UI | core-redis-api | 8081 | http://localhost:8081 |

## 🗄️ Database Commands

```bash
# List databases
docker exec core-postgres psql -U kompose -l

# Connect to database
docker exec -it core-postgres psql -U kompose -d n8n

# Create database
docker exec core-postgres psql -U kompose -c "CREATE DATABASE myapp;"

# Backup
./kompose.sh db backup -d n8n --compress

# Restore
./kompose.sh db restore -f backup.sql.gz -d n8n

# Status
./kompose.sh db status
```

## 🔴 Redis Commands

```bash
# Connect
docker exec -it core-redis redis-cli -a <password>

# Test
docker exec core-redis redis-cli -a <password> PING

# Get all keys
docker exec core-redis redis-cli -a <password> KEYS '*'

# Monitor
docker exec core-redis redis-cli -a <password> MONITOR

# Info
docker exec core-redis redis-cli -a <password> INFO
```

## 📡 MQTT Commands

```bash
# Subscribe to topic
mosquitto_sub -h localhost -t 'test/#' -v

# Publish message
mosquitto_pub -h localhost -t 'test/hello' -m 'Hello World'

# Test from container
docker exec core-mqtt mosquitto_pub -t test -m "hello"
docker exec core-mqtt mosquitto_sub -t test -C 1
```

## 🔧 Stack Management

```bash
# Start
./kompose.sh up core

# Stop
./kompose.sh down core

# Restart
./kompose.sh restart core

# Logs
./kompose.sh logs core -f

# Status
./kompose.sh status core

# Update images
./kompose.sh pull core
```

## 🏥 Health Checks

```bash
# PostgreSQL
docker exec core-postgres pg_isready -U kompose

# Redis
docker exec core-redis redis-cli -a <password> PING

# Mosquitto
docker exec core-mqtt mosquitto_sub -t '$SYS/#' -C 1

# All services
docker ps | grep core
```

## 🔒 Security

```bash
# Generate passwords
openssl rand -base64 32

# Enable MQTT auth
docker exec core-mqtt mosquitto_passwd -c /mosquitto/config/passwd admin
# Edit core/mosquitto/config/mosquitto.conf:
#   allow_anonymous false
#   password_file /mosquitto/config/passwd
docker restart core-mqtt

# Change PostgreSQL password
docker exec core-postgres psql -U kompose -c "ALTER USER kompose WITH PASSWORD 'new_password';"
```

## 📊 Monitoring

```bash
# Resource usage
docker stats core-postgres core-redis core-mqtt core-redis-api

# Disk usage
docker system df
docker volume ls | grep core

# Logs
docker logs core-postgres --tail 100 -f
docker logs core-redis --tail 100 -f
docker logs core-mqtt --tail 100 -f
```

## 💾 Backup & Restore

```bash
# Backup all databases
./kompose.sh db backup --compress

# Backup specific database
./kompose.sh db backup -d n8n --compress

# List backups
./kompose.sh db list

# Restore database
./kompose.sh db restore -f backups/database/n8n_20241011.sql.gz -d n8n

# Backup volumes
docker run --rm -v core_postgres_data:/data -v $(pwd)/backups:/backup \
  alpine tar czf /backup/postgres-$(date +%Y%m%d).tar.gz /data
```

## 🔗 Integration

```bash
# From other stacks - use these environment variables:
DATABASE_URL=postgresql://kompose:${DB_PASSWORD}@core-postgres:5432/myapp
REDIS_URL=redis://:${REDIS_PASSWORD}@core-redis:6379
MQTT_BROKER=mqtt://core-mqtt:1883

# Ensure services are on kompose network
networks:
  - kompose_network
```

## 🐛 Troubleshooting

```bash
# Container not starting
docker-compose -f core/compose.yaml logs SERVICE_NAME

# Database connection issues
docker exec core-postgres pg_isready -U kompose
docker network inspect kompose | grep core

# Redis connection issues
docker exec core-redis redis-cli -a <password> PING

# Reset PostgreSQL (WARNING: deletes data!)
./kompose.sh down core -f
docker volume rm core_postgres_data
./kompose.sh up core
```

## 🎯 Common Tasks

### Initial Setup
```bash
docker network create kompose
echo "POSTGRES_PASSWORD=$(openssl rand -base64 32)" >> secrets.env
echo "REDIS_PASSWORD=$(openssl rand -base64 32)" >> secrets.env
./kompose.sh up core
```

### Daily Operations
```bash
./kompose.sh status core                    # Check status
./kompose.sh logs core -f | grep ERROR      # Check for errors
docker stats core-postgres core-redis       # Monitor resources
```

### Weekly Maintenance
```bash
./kompose.sh db backup --compress           # Backup databases
docker exec core-postgres psql -U kompose -d n8n -c "VACUUM ANALYZE;"  # Optimize
```

### Updates
```bash
./kompose.sh pull core                      # Pull new images
./kompose.sh down core                      # Stop stack
./kompose.sh up core                        # Start with new images
```

## 📞 Quick Help

**Core won't start?**
- Check network: `docker network create kompose`
- Check secrets: `grep PASSWORD secrets.env`
- Check logs: `./kompose.sh logs core`

**Can't connect to database?**
- Verify container: `docker ps | grep core-postgres`
- Test connection: `docker exec core-postgres pg_isready -U kompose`
- Check network: `docker network inspect kompose`

**Need to reset?**
```bash
./kompose.sh down core -f
docker volume rm core_postgres_data core_redis_data
./kompose.sh up core
```

## 📚 Documentation

- Full docs: `core/README.md`
- Migration guide: `CORE_STACK_MIGRATION.md`
- Summary: `CORE_STACK_SUMMARY.md`
- Main help: `./kompose.sh help`

## 🎓 Examples

### Create new database for app
```bash
docker exec core-postgres psql -U kompose -c "CREATE DATABASE myapp;"
docker exec core-postgres psql -U kompose -c "GRANT ALL PRIVILEGES ON DATABASE myapp TO kompose;"
```

### Use Redis in your app
```python
import redis
r = redis.Redis(host='core-redis', port=6379, password='<your_password>', decode_responses=True)
r.set('key', 'value')
print(r.get('key'))
```

### Use MQTT in your app
```python
import paho.mqtt.client as mqtt
client = mqtt.Client()
client.connect('core-mqtt', 1883)
client.publish('test/topic', 'Hello')
```

---

**🚀 Ready to start?** Run: `./kompose.sh up core`
