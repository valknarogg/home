# Database Management Guide

Complete guide for managing PostgreSQL databases in the Kompose system.

## 📦 Available Databases

| Database | Purpose | Service |
|----------|---------|---------|
| `kompose` | Main application database | Application services |
| `n8n` | Workflow automation data | n8n (chain stack) |
| `gitea` | Git repositories & CI/CD | Gitea (chain stack) |

## 🔧 Database Commands

### Backup

```bash
# Backup all databases
./kompose.sh db backup

# Backup specific database
./kompose.sh db backup -d n8n

# Backup with compression
./kompose.sh db backup -d gitea --compress

# Backup to specific file
./kompose.sh db backup -d kompose -f /path/to/backup.sql
```

**Default backup location:** `./backups/database/`

### Restore

```bash
# Restore from backup (auto-detects database name)
./kompose.sh db restore -f backups/database/n8n_20250115-120000.sql

# Restore to specific database
./kompose.sh db restore -f backup.sql -d kompose

# Restore compressed backup
./kompose.sh db restore -f backups/database/gitea_20250115-120000.sql.gz
```

⚠️ **Warning:** Restore will overwrite the existing database after confirmation.

### List Backups

```bash
# List all available backups
./kompose.sh db list
```

Output shows:
- Filename
- Size
- Creation date

### Status

```bash
# Show database status, sizes, and connections
./kompose.sh db status
```

Shows:
- Container status
- Available databases
- Database sizes
- Active connections

### Execute SQL

```bash
# Execute SQL command
./kompose.sh db exec -d kompose "SELECT * FROM users LIMIT 5;"

# Create table
./kompose.sh db exec -d kompose "CREATE TABLE test (id SERIAL, name VARCHAR(100));"

# Check database version
./kompose.sh db exec -d n8n "SELECT version();"
```

### Interactive Shell

```bash
# Open psql shell for kompose database
./kompose.sh db shell

# Open shell for specific database
./kompose.sh db shell -d n8n
./kompose.sh db shell -d gitea

# Or positional argument
./kompose.sh db shell n8n
```

**Commands in shell:**
- `\l` - List databases
- `\dt` - List tables
- `\d table_name` - Describe table
- `\q` - Quit

### Migrations

```bash
# Run migrations for kompose database
./kompose.sh db migrate

# Run migrations for specific database
./kompose.sh db migrate -d kompose
./kompose.sh db migrate kompose
```

**Note:** n8n and Gitea handle migrations automatically on startup.

### Reset Database

```bash
# Reset database (WARNING: deletes all data)
./kompose.sh db reset -d kompose

# Will prompt for confirmation and create backup first
```

⚠️ **Danger:** This command:
1. Creates automatic backup
2. Drops the database
3. Recreates empty database

## 📋 Common Workflows

### Daily Backup Routine

```bash
#!/bin/bash
# daily-backup.sh

# Backup all databases with compression
./kompose.sh db backup --compress

# Keep only last 30 days
find ./backups/database -name "*.sql.gz" -mtime +30 -delete

echo "Backup completed: $(date)"
```

Add to cron:
```bash
# Daily at 2 AM
0 2 * * * /path/to/daily-backup.sh
```

### Restore After Update

```bash
# 1. Stop services
./kompose.sh down chain

# 2. Backup current state
./kompose.sh db backup

# 3. Restore from known good backup
./kompose.sh db restore -f backups/database/n8n_20250114-020000.sql.gz

# 4. Start services
./kompose.sh up chain

# 5. Check status
./kompose.sh db status
```

### Database Migration

```bash
# 1. Backup before migration
./kompose.sh db backup -d kompose

# 2. Run migration scripts
./kompose.sh db migrate -d kompose

# 3. Verify
./kompose.sh db shell -d kompose
# In shell: \dt to check tables
```

### Check Database Health

```bash
# 1. Container status
./kompose.sh status home

# 2. Database status
./kompose.sh db status

# 3. Check connections
./kompose.sh db exec -d kompose "SELECT * FROM pg_stat_activity;"

# 4. Check database size
./kompose.sh db exec -d kompose "SELECT pg_size_pretty(pg_database_size('kompose'));"
```

---

**See also:** [README.md](README.md), [QUICK-REFERENCE.md](QUICK-REFERENCE.md)
