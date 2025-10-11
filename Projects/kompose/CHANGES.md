# Kompose System Update - Changes Summary

## 🎉 Major Changes

### 1. Database Management Integrated ✅
Added complete database management subcommands to `kompose.sh`:

```bash
./kompose.sh db backup         # Backup databases
./kompose.sh db restore        # Restore from backup
./kompose.sh db list           # List backups
./kompose.sh db status         # Show database status
./kompose.sh db exec           # Execute SQL
./kompose.sh db shell          # Open psql shell
./kompose.sh db migrate        # Run migrations
./kompose.sh db reset          # Reset database
```

### 2. Gitea Moved to Chain Stack ✅
- Gitea is now part of the `chain` stack (workflow automation)
- Single stack for CI/CD pipeline: n8n + Gitea + Gitea Runner
- Simplified architecture
- `gitea/` directory now contains migration note

### 3. Complete Feature Set
kompose.sh now has **3 main command categories**:

1. **Stack Management** (blue) - Docker Compose operations
2. **Tag Deployment** (magenta) - Git-based deployments
3. **Database** (yellow) - PostgreSQL management

## 📁 Files Changed

### Created/Updated:
- ✅ `kompose.sh` - Main script with all 3 subcommand categories
- ✅ `chain/docker-compose.yml` - Now includes n8n + Gitea + Runner
- ✅ `gitea/docker-compose.yml` - Migration notice
- ✅ `DATABASE-MANAGEMENT.md` - Complete database guide
- ✅ `CHANGES.md` - This file

### Updated Stack Descriptions:
```
home   - Core services (MQTT, Redis, Postgres)
chat   - Gotify notifications
chain  - n8n + Gitea + CI/CD (was only n8n)
```

## 🚀 Quick Start

### Make executable
```bash
chmod +x kompose.sh
```

### Test commands
```bash
# Stack management
./kompose.sh list
./kompose.sh status

# Database
./kompose.sh db status
./kompose.sh db backup --compress

# Tags
./kompose.sh tag list
```

### Start chain stack (includes Gitea now)
```bash
./kompose.sh up chain
```

## 📊 Available Databases

- `kompose` - Main application
- `n8n` - Workflow data
- `gitea` - Git repositories

## 🔄 Migration Notes

### From Old Structure
If you had a separate `gitea` stack running:

1. Stop old gitea stack (if exists):
   ```bash
   cd gitea && docker-compose down
   ```

2. Start chain stack (includes gitea):
   ```bash
   ./kompose.sh up chain
   ```

3. Verify:
   ```bash
   ./kompose.sh status chain
   docker ps | grep gitea
   ```

## ✨ New Features

### Database Backups
- Automatic timestamping
- Compression support
- Auto-detection of database from filename
- Automatic backup before reset

### Database Shell
- Interactive psql access
- Positional or flag arguments
- Easy database switching

### Database Status
- Shows all databases
- Database sizes
- Active connections
- Container health

## 📚 Documentation

- `README.md` - Main documentation (updated)
- `DATABASE-MANAGEMENT.md` - Database guide (new)
- `QUICK-REFERENCE.md` - Command reference
- `MIGRATION-GUIDE.md` - Migration from old scripts

## 🎯 Next Steps

1. Make sure `kompose.sh` is executable: `chmod +x kompose.sh`
2. Start services: `./kompose.sh up home chain`
3. Test database commands: `./kompose.sh db status`
4. Create first backup: `./kompose.sh db backup --compress`
5. Review documentation: `./kompose.sh help`

## 🆘 Troubleshooting

### kompose.sh not executable
```bash
chmod +x kompose.sh
```

### Old gitea stack still running
```bash
docker ps | grep gitea
# Stop if found
docker stop chain-gitea gitea-server
```

### Database commands not working
Make sure home stack is running:
```bash
./kompose.sh up home
./kompose.sh db status
```

## 📝 Notes

- All changes are backward compatible
- Existing Git tags remain valid
- Old backup scripts still work
- Docker volumes are preserved

---

**Date:** 2025-01-15
**Version:** kompose.sh v2.0 with database management
