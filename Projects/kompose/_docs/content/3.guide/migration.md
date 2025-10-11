---
title: Migration Guide
description: Migrate between kompose versions and configurations
---

# Kompose Migration Guide

This guide consolidates all migration documentation.


## MIGRATION GUIDE


## Overview

This update restructures your Kompose project to be more secure and maintainable by:

1. **Separating sensitive data** - All secrets moved to `secrets.env`
2. **Stack-scoped variables** - Configuration variables prefixed with stack names
3. **Centralized configuration** - All variables defined in top-level `.env`
4. **Automatic secret generation** - Generate cryptographically secure secrets with one command
5. **Traefik control** - Enable/disable Traefik per service with `${STACK}_TRAEFIK_ENABLED`

## Files Created

### 1. `.env` (Updated)
- Contains **NON-SENSITIVE** configuration for all stacks
- Variables are scoped with stack names (e.g., `TRACK_TRAEFIK_HOST`, `AUTH_DB_NAME`)
- Committed to git

### 2. `secrets.env.template`
- Template file for generating secrets
- Contains placeholder values: `CHANGE_ME_GENERATE_WITH_KOMPOSE`
- Committed to git as a reference

### 3. `secrets.env` (Generated)
- Contains **ALL SENSITIVE DATA** (passwords, tokens, keys)
- Auto-generated from template with `./kompose.sh --generate-secrets`
- **NEVER committed to git** (automatically added to `.gitignore`)

### 4. `kompose.sh` (Updated)
- Now loads both `.env` and `secrets.env`
- New `--generate-secrets` command for generating random secrets
- Automatically backs up existing `secrets.env` before regeneration

## Migration Steps

### Step 1: Generate Secrets

```bash
# This will create secrets.env from the template
./kompose.sh --generate-secrets
```

This command will:
- Read `secrets.env.template`
- Generate cryptographically secure random values for all secrets
- Save them to `secrets.env`
- Add `secrets.env` to `.gitignore` if not already present
- Backup existing `secrets.env` if it exists

### Step 2: Update Your Stack Files

Each stack needs to be updated to use the new variable naming pattern:

#### Before (track/.env):
```bash
COMPOSE_PROJECT_NAME=track
DOCKER_IMAGE=ghcr.io/umami-software/umami:postgresql-latest
DB_NAME=umami
TRAEFIK_HOST=umami.pivoine.art
APP_PORT=3000
APP_SECRET=changeme
```

#### After (track/.env):
```bash
COMPOSE_PROJECT_NAME=track
# All other variables are now in root .env and secrets.env
```

#### Before (track/compose.yaml):
```yaml
environment:
  DATABASE_URL: postgresql://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}
  APP_SECRET: ${APP_SECRET}
labels:
  - 'traefik.enable=true'
  - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web.rule=Host(`$TRAEFIK_HOST`)'
```

#### After (track/compose.yaml):
```yaml
environment:
  DATABASE_URL: postgresql://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${TRACK_DB_NAME}
  APP_SECRET: ${TRACK_APP_SECRET}
labels:
  - 'traefik.enable=${TRACK_TRAEFIK_ENABLED}'
  - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web.rule=Host(`${TRACK_TRAEFIK_HOST}`)'
```

### Step 3: Update Root .env

Add configuration for each stack in the root `.env`:

```bash
# -------------------------------------------------------------------
# TRACK Stack (Umami Analytics)
# -------------------------------------------------------------------
TRACK_TRAEFIK_ENABLED=true
TRACK_TRAEFIK_HOST=umami.pivoine.art
TRACK_DB_NAME=umami
TRACK_DOCKER_IMAGE=ghcr.io/umami-software/umami:postgresql-latest
TRACK_APP_PORT=3000
```

### Step 4: Update secrets.env.template

Add secret placeholders for each stack:

```bash
# -------------------------------------------------------------------
# TRACK Stack Secrets (Umami)
# -------------------------------------------------------------------
TRACK_APP_SECRET=CHANGE_ME_GENERATE_WITH_KOMPOSE
```

### Step 5: Regenerate Secrets (if needed)

After updating the template, regenerate secrets:

```bash
./kompose.sh --generate-secrets
```

Your old secrets will be backed up automatically.

## Variable Naming Convention

### Stack Configuration Variables (in root .env)
```
{STACK_NAME}_{VARIABLE_NAME}

Examples:
TRACK_TRAEFIK_HOST=umami.pivoine.art
TRACK_DB_NAME=umami
TRACK_DOCKER_IMAGE=ghcr.io/umami-software/umami:postgresql-latest
AUTH_TRAEFIK_HOST=auth.pivoine.art
AUTH_DB_NAME=keycloak
```

### Stack Secrets (in secrets.env)
```
{STACK_NAME}_{SECRET_NAME}

Examples:
TRACK_APP_SECRET=<generated-64-char-hex>
AUTH_KC_ADMIN_PASSWORD=<generated-32-char-password>
DB_PASSWORD=<generated-32-char-password>
```

### Shared Variables (in root .env)
```
DB_USER=valknar
DB_HOST=postgres
DB_PORT=5432
ADMIN_EMAIL=admin@example.com
NETWORK_NAME=kompose
```

## Example Stack Configurations

### Example 1: Track Stack (Umami)

**Root .env:**
```bash
TRACK_TRAEFIK_ENABLED=true
TRACK_TRAEFIK_HOST=umami.pivoine.art
TRACK_DB_NAME=umami
TRACK_DOCKER_IMAGE=ghcr.io/umami-software/umami:postgresql-latest
```

**secrets.env.template:**
```bash
TRACK_APP_SECRET=CHANGE_ME_GENERATE_WITH_KOMPOSE
```

**track/compose.yaml:**
```yaml
services:
  umami:
    image: ${TRACK_DOCKER_IMAGE}
    environment:
      DATABASE_URL: postgresql://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${TRACK_DB_NAME}
      APP_SECRET: ${TRACK_APP_SECRET}
    labels:
      - 'traefik.enable=${TRACK_TRAEFIK_ENABLED}'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web.rule=Host(`${TRACK_TRAEFIK_HOST}`)'
```

### Example 2: Auth Stack (Keycloak)

**Root .env:**
```bash
AUTH_TRAEFIK_ENABLED=true
AUTH_TRAEFIK_HOST=auth.pivoine.art
AUTH_DB_NAME=keycloak
AUTH_DOCKER_IMAGE=quay.io/keycloak/keycloak:latest
```

**secrets.env.template:**
```bash
AUTH_KC_ADMIN_PASSWORD=CHANGE_ME_GENERATE_WITH_KOMPOSE
```

**auth/compose.yaml:**
```yaml
services:
  keycloak:
    image: ${AUTH_DOCKER_IMAGE}
    environment:
      KC_DB_URL: jdbc:postgresql://${DB_HOST}:${DB_PORT}/${AUTH_DB_NAME}
      KC_BOOTSTRAP_ADMIN_PASSWORD: ${AUTH_KC_ADMIN_PASSWORD}
    labels:
      - 'traefik.enable=${AUTH_TRAEFIK_ENABLED}'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web.rule=Host(`${AUTH_TRAEFIK_HOST}`)'
```

## Traefik Control

Every service now has a `${STACK}_TRAEFIK_ENABLED` variable that controls whether Traefik routes to it:

```yaml
labels:
  - 'traefik.enable=${TRACK_TRAEFIK_ENABLED}'  # true or false
```

To disable Traefik for a stack, simply set it to `false` in the root `.env`:

```bash
TRACK_TRAEFIK_ENABLED=false
```

## Secret Generation Patterns

The `--generate-secrets` command generates different types of secrets based on variable naming:

| Variable Pattern | Generated Secret Type | Length | Example |
|-----------------|----------------------|--------|---------|
| `*_PASSWORD` | Alphanumeric password | 32 chars | `DB_PASSWORD`, `ADMIN_PASSWORD` |
| `*_SECRET`, `*_ENCRYPTION_KEY` | Hex string | 64 chars (32 bytes) | `TRACK_APP_SECRET`, `N8N_ENCRYPTION_KEY` |
| `*_TOKEN` | Alphanumeric token | 40 chars | `GITEA_RUNNER_TOKEN` |
| `*_HASH` | Hex hash | 64 chars (32 bytes) | `PASSWORD_HASH` |
| Default | Alphanumeric | 32 chars | Any other variable |

## Security Best Practices

### ✅ DO:
- Keep `secrets.env` in `.gitignore`
- Use the provided `secrets.env.template` as reference
- Regenerate secrets when setting up new environments
- Use stack-scoped variable names
- Store secrets in `secrets.env` only

### ❌ DON'T:
- Commit `secrets.env` to git
- Hard-code secrets in compose files
- Share secrets in plain text (use password managers)
- Use the same secrets across environments
- Store configuration in stack `.env` files anymore

## Quick Reference

### Generate secrets:
```bash
./kompose.sh --generate-secrets
```

### Start all stacks:
```bash
./kompose.sh "*" up -d
```

### View help:
```bash
./kompose.sh --help
```

### List stacks:
```bash
./kompose.sh --list
```

## Troubleshooting

### "Secrets file not found"
Run: `./kompose.sh --generate-secrets`

### "Variable not set" errors
Make sure you've:
1. Updated root `.env` with stack-scoped variables
2. Generated `secrets.env`
3. Updated compose files to use new variable names

### Need to regenerate a single secret?
Edit `secrets.env` directly and replace the value, or regenerate all secrets (old secrets will be backed up).

## Example Complete Setup

See the `.new` files in `track/` and `auth/` directories for complete examples of the new structure.

To apply them:
```bash
cd track
mv compose.yaml.new compose.yaml
mv .env.new .env

cd ../auth
mv compose.yaml.new compose.yaml
mv .env.new .env
```

Then regenerate your secrets:
```bash
./kompose.sh --generate-secrets
```

## RENAME HOME TO CORE


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

## CORE STACK MIGRATION


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
