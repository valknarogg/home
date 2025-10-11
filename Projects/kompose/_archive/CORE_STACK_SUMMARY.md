# Core Stack Integration - Summary

## ✅ Completed Tasks

### 1. Created Core Stack Infrastructure

**New Files Created:**

```
core/
├── compose.yaml                          # Full stack definition with 4 services
├── .env                                  # Environment configuration
├── .gitignore                           # Git ignore rules
├── README.md                            # Comprehensive documentation
├── postgres/
│   └── init/
│       └── 01-init-databases.sh         # Auto-creates n8n, semaphore, gitea databases
└── mosquitto/
    ├── config/
    │   └── mosquitto.conf               # MQTT broker configuration
    └── data/
        └── .gitkeep                     # Directory placeholder
```

**Services Defined:**
1. **PostgreSQL 16** (core-postgres)
   - Central database for all stacks
   - Auto-creates databases on first start
   - Health checks enabled
   - Volume: `core_postgres_data`

2. **Redis 7** (core-redis)
   - Cache and session storage
   - Password protected
   - Persistence enabled
   - Volume: `core_redis_data`

3. **Mosquitto 2** (core-mqtt)
   - MQTT message broker
   - Ports: 1883 (MQTT), 9001 (WebSocket)
   - Anonymous access enabled (configurable)
   - Volumes: `mosquitto_data`, `mosquitto_logs`

4. **Redis Commander** (core-redis-api)
   - Web UI for Redis management
   - Port: 8081
   - HTTP Basic Auth
   - Traefik labels included

### 2. Removed Home Stack

**Actions Taken:**
- Moved `home/` directory to `backups/removed-stacks/home/`
- Preserved Home Assistant configuration
- Freed up the "home" name for future use
- No data loss - everything backed up

**What was in Home Stack:**
- Home Assistant (ghcr.io/home-assistant/home-assistant:stable)
- Mosquitto MQTT broker (now integrated into core stack)

### 3. Documentation Created

**Files:**
- `core/README.md` - Detailed service documentation
- `CORE_STACK_MIGRATION.md` - Migration guide and setup instructions

**Documentation Includes:**
- Quick start guide
- Service details and access methods
- Configuration options
- Security hardening steps
- Backup/restore procedures
- Troubleshooting guide
- Integration examples

## 🎯 What This Achieves

### Centralized Infrastructure

**Before:**
```
home/ - Home Assistant + MQTT (separate)
chain/ - n8n + Semaphore → needs PostgreSQL
gitea/ - Git repository → needs PostgreSQL
(PostgreSQL was referenced but not defined anywhere)
```

**After:**
```
core/ - PostgreSQL + Redis + MQTT + Redis UI
  ↓ provides services to ↓
chain/ - n8n + Semaphore
gitea/ - Git repository
dock/ - Docker registry (can use Redis)
[any other stack needing database/cache/mqtt]
```

### Benefits

1. **Single Source of Truth** - All infrastructure in one stack
2. **Proper Dependencies** - Start core first, then other stacks
3. **Better Naming** - "core" clearly indicates infrastructure
4. **Auto-initialization** - Databases created automatically
5. **Professional Setup** - Production-ready configuration
6. **Comprehensive Docs** - Everything documented

## 🚀 Quick Start

### 1. Configure Secrets

Create or update `secrets.env`:
```bash
# Required for core stack
POSTGRES_PASSWORD=<generate_with: openssl rand -base64 32>
REDIS_PASSWORD=<generate_with: openssl rand -base64 32>
REDIS_API_PASSWORD=<generate_with: openssl rand -base64 32>
```

### 2. Create Network (if needed)

```bash
docker network create kompose
```

### 3. Start Core Stack

```bash
./kompose.sh up core
```

### 4. Verify

```bash
# Check all services running
./kompose.sh status core

# Verify databases created
docker exec core-postgres psql -U kompose -l
# Should show: kompose, n8n, semaphore, gitea

# Test services
docker exec core-redis redis-cli -a <password> PING  # Should return: PONG
docker exec core-postgres pg_isready -U kompose       # Should return: accepting connections
```

### 5. Start Dependent Stacks

```bash
./kompose.sh up chain   # n8n + Semaphore
./kompose.sh up gitea   # if configured
```

## 📋 Stack Startup Order

**Correct Order:**
```bash
1. ./kompose.sh up core    # Start infrastructure first
2. ./kompose.sh up chain   # Then automation stack
3. ./kompose.sh up gitea   # Then other dependent stacks
```

**Why Order Matters:**
- Chain stack needs core-postgres for n8n and Semaphore databases
- Gitea needs core-postgres for git repository data
- Other stacks may need Redis for caching

## 🔧 Configuration Details

### Default Ports

**Exposed Externally:**
- MQTT: 1883
- MQTT WebSocket: 9001
- Redis UI: 8081

**Internal Only:**
- PostgreSQL: 5432 (not exposed, only accessible via Docker network)
- Redis: 6379 (not exposed, only accessible via Docker network)

### Volume Names

All volumes are prefixed with the project name:
- `core_postgres_data`
- `core_redis_data`
- `core_mosquitto_data`
- `core_mosquitto_logs`

### Container Names

- `core-postgres` - PostgreSQL database
- `core-redis` - Redis cache
- `core-mqtt` - Mosquitto MQTT broker
- `core-redis-api` - Redis Commander UI

## 🔗 Integration Points

### From Chain Stack

```yaml
# chain/compose.yaml already has:
services:
  n8n:
    environment:
      DB_POSTGRESDB_HOST: core-postgres  # ✅ Correct
      
  semaphore:
    environment:
      SEMAPHORE_DB_HOST: core-postgres   # ✅ Correct
```

### From Other Stacks

Example for any stack needing database:
```yaml
services:
  your-app:
    environment:
      DATABASE_URL: postgresql://kompose:${DB_PASSWORD}@core-postgres:5432/your_db
    networks:
      - kompose_network
    depends_on:
      - core-postgres  # Won't work across stacks, just use proper startup order
```

## 🔒 Security Recommendations

### Immediate Actions

1. **Change Default Passwords**
   ```bash
   # Generate secure passwords
   openssl rand -base64 32  # For PostgreSQL
   openssl rand -base64 32  # For Redis
   openssl rand -base64 32  # For Redis UI
   ```

2. **Enable MQTT Authentication**
   ```bash
   docker exec core-mqtt mosquitto_passwd -c /mosquitto/config/passwd admin
   # Update mosquitto.conf: allow_anonymous false
   docker restart core-mqtt
   ```

### Production Hardening

1. Remove port exposures for internal services
2. Enable PostgreSQL SSL
3. Use secrets management (Docker secrets or external vault)
4. Regular backup schedule
5. Monitor resource usage

## 📊 Maintenance

### Backups

```bash
# All databases
./kompose.sh db backup --compress

# Specific database
./kompose.sh db backup -d n8n --compress

# Volume backups
docker run --rm -v core_postgres_data:/data -v $(pwd)/backups:/backup \
  alpine tar czf /backup/postgres-$(date +%Y%m%d).tar.gz /data
```

### Updates

```bash
# Pull latest images
./kompose.sh pull core

# Restart with new images
./kompose.sh down core
./kompose.sh up core
```

### Monitoring

```bash
# Service status
./kompose.sh status core

# Logs
./kompose.sh logs core -f

# Resource usage
docker stats core-postgres core-redis core-mqtt

# Database status
./kompose.sh db status
```

## 🐛 Troubleshooting

### Services Won't Start

```bash
# Check logs
docker-compose -f core/compose.yaml logs

# Verify network
docker network ls | grep kompose
docker network create kompose  # if missing

# Check secrets
grep -E 'POSTGRES_PASSWORD|REDIS_PASSWORD' secrets.env
```

### Database Connection Issues

```bash
# Verify PostgreSQL
docker exec core-postgres pg_isready -U kompose

# Check databases exist
docker exec core-postgres psql -U kompose -l

# Test from chain stack
docker exec chain_n8n ping core-postgres
```

### Missing Databases

```bash
# Recreate databases manually
docker exec core-postgres psql -U kompose -c "CREATE DATABASE n8n;"
docker exec core-postgres psql -U kompose -c "CREATE DATABASE semaphore;"
docker exec core-postgres psql -U kompose -c "CREATE DATABASE gitea;"
```

## 📚 Additional Resources

- PostgreSQL Documentation: https://www.postgresql.org/docs/
- Redis Documentation: https://redis.io/documentation
- Mosquitto Documentation: https://mosquitto.org/documentation/
- Docker Compose Reference: https://docs.docker.com/compose/

## ✨ Next Steps

1. **Start Core Stack**
   ```bash
   ./kompose.sh up core
   ```

2. **Verify Everything Works**
   ```bash
   ./kompose.sh status core
   docker exec core-postgres psql -U kompose -l
   ```

3. **Start Dependent Stacks**
   ```bash
   ./kompose.sh up chain
   ```

4. **Access Services**
   - n8n: http://localhost:5678
   - Semaphore: http://localhost:3000
   - Redis UI: http://localhost:8081

5. **Review Security**
   - Change default passwords
   - Enable authentication
   - Configure backups

## 📝 Files Reference

| File | Purpose |
|------|---------|
| `core/compose.yaml` | Service definitions |
| `core/.env` | Default configuration |
| `core/README.md` | Service documentation |
| `core/postgres/init/01-init-databases.sh` | Database initialization |
| `core/mosquitto/config/mosquitto.conf` | MQTT configuration |
| `CORE_STACK_MIGRATION.md` | Migration guide |
| `backups/removed-stacks/home/` | Old Home Assistant stack |

## ✅ Completion Checklist

- [x] Created core stack compose.yaml
- [x] Created core stack .env file
- [x] Created PostgreSQL init script
- [x] Created Mosquitto configuration
- [x] Created comprehensive README
- [x] Created migration guide
- [x] Moved home stack to backups
- [x] Created .gitignore for core
- [x] Created directory structure

**Status: ✅ Complete and Ready to Use**

You can now start the core stack with:
```bash
./kompose.sh up core
```
