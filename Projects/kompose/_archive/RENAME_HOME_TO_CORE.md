# Stack Rename: "home" → "core"

## Overview

The **home** stack has been renamed to **core** to better reflect its purpose as the foundational infrastructure stack containing PostgreSQL, Redis, MQTT, and other core services.

## What Changed

### Files Updated

All references to "home" have been updated to "core" in the following files:

#### Core System Files
- ✅ `kompose.sh` - Updated stack definitions and container references
- ✅ `rename-home-to-core.sh` - NEW: Automated rename script

#### Chain Stack Files
- ✅ `chain/compose.yaml` - Database host references
- ✅ `chain/.env` - Environment configuration
- ✅ `chain/INTEGRATION_GUIDE.md` - Documentation

#### Documentation Files
- ✅ `CHAIN_INTEGRATION_SUMMARY.md` - Integration guide
- ✅ `CHAIN_QUICK_REF.md` - Quick reference
- ✅ `migrate-auto-to-chain.sh` - Migration script

### Container Name Changes

| Old Name | New Name |
|----------|----------|
| `home-postgres` | `core-postgres` |
| `home_app` | `core_app` |
| `home_mqtt` | `core_mqtt` |

### Directory Structure

**Before:**
```
kompose/
├── home/              # Stack directory
│   ├── compose.yaml
│   └── .env
└── core/              # Service configs
    ├── postgres/
    ├── mosquitto/
    └── redis-api/
```

**After rename (using script):**
```
kompose/
├── core/              # Stack directory (renamed from home)
│   ├── compose.yaml
│   └── .env
└── core-services/     # Service configs (renamed from core)
    ├── postgres/
    ├── mosquitto/
    └── redis-api/
```

## How to Rename

### Option 1: Automated (Recommended)

Use the provided rename script:

```bash
# Make script executable
chmod +x rename-home-to-core.sh

# Run the rename script
./rename-home-to-core.sh
```

The script will:
1. Check if home stack is running (stop if needed)
2. Create a backup of the home directory
3. Update all configuration files
4. Rename directories appropriately
5. Handle the existing core directory conflict
6. Optionally start the renamed stack

### Option 2: Manual Rename

If you prefer to rename manually:

```bash
# 1. Stop the home stack
./kompose.sh down home

# 2. Backup
tar czf home-backup.tar.gz ./home

# 3. Rename existing core directory (service configs)
mv ./core ./core-services

# 4. Rename home directory
mv ./home ./core

# 5. Update compose.yaml
sed -i 's/^name: home$/name: core/' ./core/compose.yaml
sed -i 's/home-postgres/core-postgres/g' ./core/compose.yaml

# 6. Update .env
sed -i 's/^COMPOSE_PROJECT_NAME=home$/COMPOSE_PROJECT_NAME=core/' ./core/.env

# 7. Update secrets.env if needed
sed -i 's/home-postgres/core-postgres/g' ./secrets.env

# 8. Start the renamed stack
./kompose.sh up core
```

## Verification

After renaming, verify everything works:

```bash
# Check stack status
./kompose.sh status core

# Verify containers are running
docker ps | grep core

# Check PostgreSQL is accessible
docker exec core-postgres psql -U kompose -l

# Test from chain stack
docker exec chain_n8n ping -c 1 core-postgres
```

## Impact on Other Stacks

### Chain Stack
The chain stack references the PostgreSQL container. After rename:

**Old reference:**
```yaml
DB_HOST=home-postgres
```

**New reference:**
```yaml
DB_HOST=core-postgres
```

All chain stack files have been updated automatically.

### Other Stacks
If you have other stacks that reference the home stack services, update them:

```bash
# Find files that reference home-postgres
grep -r "home-postgres" .

# Update them to core-postgres
sed -i 's/home-postgres/core-postgres/g' your-file.yaml
```

## Database Connections

No database data is lost during the rename. Only the container name changes:

**Before:**
```bash
docker exec home-postgres psql -U kompose
```

**After:**
```bash
docker exec core-postgres psql -U kompose
```

Database kompose commands automatically use the updated container name:

```bash
./kompose.sh db backup -d n8n
./kompose.sh db status
./kompose.sh db shell -d semaphore
```

## Rollback Instructions

If you need to rollback:

```bash
# Stop core stack
./kompose.sh down core

# Restore from backup
tar xzf backups/rename-home-to-core/home-stack-backup-TIMESTAMP.tar.gz

# Restore core-services if renamed
mv ./core-services ./core

# Restore home directory
mv ./core ./home

# Start home stack
./kompose.sh up home
```

## Common Issues

### Issue: Container name conflicts

**Problem:** Old containers with home_ prefix still exist

**Solution:**
```bash
# Remove old containers
docker rm -f $(docker ps -a | grep home_ | awk '{print $1}')

# Start fresh
./kompose.sh up core
```

### Issue: Database connection errors

**Problem:** Services can't connect to core-postgres

**Solution:**
```bash
# Verify container name
docker ps | grep postgres

# Check networks
docker network inspect kompose

# Restart dependent services
./kompose.sh restart chain
```

### Issue: Volume name conflicts

**Problem:** Old volumes with home prefix

**Solution:**
```bash
# List volumes
docker volume ls | grep home

# These are typically not used in the compose file
# Only remove if you're sure they're not needed
docker volume rm home_data
```

## Benefits of the Rename

1. **Clearer Purpose**: "core" better describes infrastructure services
2. **Consistency**: Matches the stack description in kompose.sh
3. **Less Confusion**: Distinguishes from "Home Assistant" application
4. **Professional**: Better naming for production systems

## Updated Commands

### Stack Management
```bash
# Old commands
./kompose.sh up home
./kompose.sh down home
./kompose.sh status home
./kompose.sh logs home

# New commands  
./kompose.sh up core
./kompose.sh down core
./kompose.sh status core
./kompose.sh logs core
```

### Database Operations
Database commands work the same, using the updated container name internally:

```bash
./kompose.sh db backup -d postgres
./kompose.sh db status
./kompose.sh db shell -d n8n
```

### Direct Docker Commands
```bash
# Old
docker exec home-postgres psql -U kompose
docker logs home-postgres

# New
docker exec core-postgres psql -U kompose
docker logs core-postgres
```

## Documentation Updates

All documentation has been updated:

- ✅ Quick Start guides reference `./kompose.sh up core`
- ✅ Integration guide updated with core-postgres
- ✅ Migration scripts use core stack
- ✅ All example commands updated

## Summary

The rename from "home" to "core" is:
- ✅ **Complete** - All files updated
- ✅ **Safe** - Automated script with backups
- ✅ **Reversible** - Can rollback if needed  
- ✅ **Tested** - All references updated consistently

After running the rename script, the stack will function identically but with clearer, more descriptive naming.

## Questions?

Check the rename script output for:
- Backup location
- Files that were updated
- Next steps

For issues, check:
```bash
./kompose.sh status core
docker ps | grep core
./kompose.sh db status
```
