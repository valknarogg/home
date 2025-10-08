---
title: Data Stack - The Memory Palace of Your Infrastructure
description: "In data we trust... and backup, and replicate, and backup again"
---

# 🗄️ Data Stack - The Memory Palace of Your Infrastructure

> *"In data we trust... and backup, and replicate, and backup again"* - Every DBA Ever

## What's This All About?

This is the beating heart of your infrastructure - where all the data lives, breathes, and occasionally takes a nap (cache). Think of it as the library, post office, and filing cabinet all rolled into one extremely organized digital space!

## The Data Dream Team

### 🐘 PostgreSQL

**Container**: `data_postgres`  
**Image**: `postgres:latest`  
**Port**: 5432  
**Volume**: `pgdata`

The elephant in the room (literally, look at the logo!). PostgreSQL is your rock-solid relational database:
- 💪 **ACID Compliance**: Your data stays consistent, always
- 🔒 **Rock Solid**: Banks trust it, you should too
- 📊 **Advanced Features**: JSON, full-text search, geospatial data
- 🚀 **Performance**: Handles millions of rows like a champ
- 🔄 **Extensible**: PostGIS, TimescaleDB, and more

**Who Uses It**:
- `auth` → Keycloak database
- `news` → Newsletter/Letterspace database  
- `auto` → Semaphore database
- `sexy` → Directus CMS database
- `track` → Umami analytics database
- Basically, everyone! 🎉

### ⚡ Redis

**Container**: `data_redis`  
**Image**: `redis:latest`  
**Port**: 6379

The speed demon of data storage! Redis is your in-memory cache:
- 🏎️ **Lightning Fast**: Sub-millisecond response times
- 💾 **In-Memory**: Data lives in RAM for max speed
- 🔑 **Key-Value Store**: Simple and effective
- 📦 **Pub/Sub**: Real-time messaging support
- ⏰ **Expiration**: Auto-delete old data

**Who Uses It**:
- `sexy` → Directus cache for faster API responses
- Perfect for session storage, rate limiting, queues

### 🎛️ pgAdmin 4

**Container**: `pgadmin4_container`  
**Image**: `dpage/pgadmin4`  
**Port**: 8088  
**Home**: http://localhost:8088

Your graphical database management interface:
- 🖱️ **Visual Interface**: No SQL required (but you can if you want!)
- 📊 **Query Tool**: Run queries and see pretty results
- 🔍 **Database Explorer**: Browse tables, views, functions
- 📈 **Monitoring**: Check performance and connections
- 🛠️ **Management**: Create, modify, backup databases

## Architecture Overview

```
Your Applications
    ├── PostgreSQL (Persistent Data)
    │   ├── auth/keycloak DB
    │   ├── news/letterspace DB
    │   ├── auto/semaphore DB
    │   ├── sexy/directus DB
    │   └── track/umami DB
    │
    └── Redis (Cache & Speed)
        └── sexy/directus cache

pgAdmin 4 (You) → PostgreSQL (Manage everything)
```

## Configuration Breakdown

### PostgreSQL Setup

**User & Password**: Configured in root `.env` file
```bash
DB_USER=your_db_user
DB_PASSWORD=super_secret_password
```

**Health Check**:
```bash
pg_isready -d postgres
```
Runs every 30 seconds to ensure the database is accepting connections.

### Redis Setup

**Health Check**:
```bash
redis-cli ping
# Response: PONG (if healthy)
```

Checks every 10 seconds because Redis is speedy like that!

### pgAdmin Setup

**Credentials**: From root `.env`
```bash
ADMIN_EMAIL=your@email.com
ADMIN_PASSWORD=your_password
```

**Data Persistence**: `pgadmin-data` volume stores your server configurations

## First Time Setup 🚀

### Postgres

1. **Create a new database**:
   ```bash
   docker exec -it data_postgres psql -U your_db_user
   ```
   ```sql
   CREATE DATABASE myapp;
   \q
   ```

2. **Or use pgAdmin** (easier for beginners):
   - Access http://localhost:8088
   - Login with admin credentials
   - Right-click "Databases" → Create → Database

### Redis cache

Redis works out of the box! No setup needed. Just start using it:
```bash
docker exec -it data_redis redis-cli
> SET mykey "Hello Redis!"
> GET mykey
"Hello Redis!"
> EXIT
```

### pgAdmin

1. **First Login**:
   ```
   URL: http://localhost:8088
   Email: Your ADMIN_EMAIL
   Password: Your ADMIN_PASSWORD
   ```

2. **Add PostgreSQL Server**:
   - Right-click "Servers" → Register → Server
   - **General Tab**:
     - Name: "Kompose PostgreSQL"
   - **Connection Tab**:
     - Host: `postgres` (container name)
     - Port: `5432`
     - Database: `postgres`
     - Username: Your DB_USER
     - Password: Your DB_PASSWORD
   - Save!

## Common Database Tasks

### Create a New Database

**Via pgAdmin**:
1. Right-click "Databases"
2. Create → Database
3. Name it, set owner, click Save

**Via Command Line**:
```bash
docker exec data_postgres createdb -U your_db_user myapp
```

### Backup a Database

```bash
# Backup to file
docker exec data_postgres pg_dump -U your_db_user myapp > backup.sql

# Or use pg_dumpall for everything
docker exec data_postgres pg_dumpall -U your_db_user > all_databases.sql
```

### Restore a Database

```bash
# Restore from backup
docker exec -i data_postgres psql -U your_db_user myapp < backup.sql
```

### Connect from Application

```javascript
// Node.js example
const { Pool } = require('pg')
const pool = new Pool({
  host: 'postgres',  // Container name
  port: 5432,
  database: 'myapp',
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD
})
```

### Monitor Active Connections

```sql
SELECT * FROM pg_stat_activity;
```

### Check Database Sizes

```sql
SELECT 
    datname AS database,
    pg_size_pretty(pg_database_size(datname)) AS size
FROM pg_database
ORDER BY pg_database_size(datname) DESC;
```

## Redis Common Tasks

### Check Redis Stats

```bash
docker exec data_redis redis-cli INFO stats
```

### Monitor Commands in Real-Time

```bash
docker exec -it data_redis redis-cli MONITOR
```

### Flush All Data (⚠️ DANGER!)

```bash
docker exec data_redis redis-cli FLUSHALL
# Only do this if you know what you're doing!
```

### Check Memory Usage

```bash
docker exec data_redis redis-cli INFO memory
```

## Ports & Networking

| Service | Internal Port | External Port | Access |
|---------|--------------|---------------|--------|
| PostgreSQL | 5432 | 5432 | Direct + kompose network |
| Redis | 6379 | 6379 | Direct + kompose network |
| pgAdmin | 80 | 8088 | http://localhost:8088 |

## Volumes & Persistence 💾

### pgdata
PostgreSQL database files live here. **DON'T DELETE THIS** unless you enjoy pain!

### pgadmin-data
Your pgAdmin settings and configurations.

## Security Best Practices 🔒

1. **Strong Passwords**: Use long, random passwords
2. **Network Isolation**: Only expose ports you need
3. **Regular Backups**: Automate them!
4. **User Permissions**: Don't use superuser for applications
5. **SSL Connections**: Consider enabling for production
6. **Update Regularly**: Keep images up to date

## Performance Tips 💡

### PostgresSQL Server

1. **Indexes**: Create them on frequently queried columns
   ```sql
   CREATE INDEX idx_user_email ON users(email);
   ```

2. **Analyze Queries**:
   ```sql
   EXPLAIN ANALYZE SELECT * FROM users WHERE email = 'test@example.com';
   ```

3. **Vacuum Regularly**:
   ```sql
   VACUUM ANALYZE;
   ```

### Redis Service

1. **Use Appropriate Data Structures**: Lists, Sets, Hashes, etc.
2. **Set Expiration**: Don't let cache grow forever
   ```bash
   SET key value EX 3600  # Expires in 1 hour
   ```
3. **Monitor Memory**: Keep an eye on RAM usage

## Troubleshooting

**Q: PostgreSQL won't start?**
```bash
# Check logs
docker logs data_postgres

# Check if port is in use
lsof -i :5432
```

**Q: Can't connect to database?**
- Verify credentials in `.env`
- Check if container is healthy: `docker ps`
- Ensure network is correct: `docker network ls`

**Q: Redis out of memory?**
```bash
# Check memory
docker exec data_redis redis-cli INFO memory

# Configure max memory (if needed)
docker exec data_redis redis-cli CONFIG SET maxmemory 256mb
```

**Q: pgAdmin can't connect to PostgreSQL?**
- Use container name `postgres`, not `localhost`
- Check if both containers are on same network
- Verify credentials match

## Advanced: Connection Pooling

For high-traffic apps, use connection pooling:

**PgBouncer** (PostgreSQL):
```yaml
# Could add to this stack
pgbouncer:
  image: pgbouncer/pgbouncer
  environment:
    DATABASES_HOST: postgres
    DATABASES_PORT: 5432
```

## Monitoring & Metrics

### PostgreSQL Server

- **pg_stat_statements**: Track slow queries
- **pg_stat_user_tables**: Table statistics
- **pg_stat_database**: Database-level stats

### Redis System

- **INFO** command: Comprehensive stats
- **SLOWLOG**: Track slow commands
- **CLIENT LIST**: Active connections

## When Things Go Wrong 🚨

### Database Corruption
1. Stop all applications
2. Restore from latest backup
3. Investigate what caused corruption

### Out of Disk Space
1. Check volume sizes: `docker system df -v`
2. Clean old backups
3. Archive old data
4. Consider larger disk

### Connection Pool Exhaustion
1. Check active connections
2. Kill long-running queries
3. Increase max_connections (PostgreSQL)
4. Implement connection pooling

## Fun Database Facts 🎓

- PostgreSQL started in 1986 at UC Berkeley (older than some developers!)
- Redis stands for "REmote DIctionary Server"
- PostgreSQL supports storing emojis (🐘💖)
- Redis can process millions of operations per second
- pgAdmin is used by database admins worldwide

## Resources

- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Redis Documentation](https://redis.io/documentation)
- [pgAdmin Documentation](https://www.pgadmin.org/docs/)
- [PostgreSQL Tutorial](https://www.postgresqltutorial.com/)

---

*"Data is the new oil, but unlike oil, you can actually back it up."* - Modern DevOps Proverb 💾✨
