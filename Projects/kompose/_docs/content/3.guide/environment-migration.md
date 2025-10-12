# Environment Configuration Migration Guide

## Overview

Kompose now uses a **centralized environment configuration system** where all stack configurations are managed from a single root `.env` file. This replaces the previous system where each stack had its own `.env` file.

## Benefits

### ✅ Centralized Management
- **Single source of truth**: All configuration in one place
- **Easier to maintain**: No need to update multiple files
- **Better overview**: See all settings at a glance
- **Consistent values**: Shared settings are truly shared

### ✅ Stack Scoping
- **Organized**: Variables prefixed by stack name (e.g., `CORE_`, `AUTH_`)
- **Isolated**: Each stack's config is clearly separated
- **Flexible**: Easy to override per-stack settings
- **Scalable**: Simple to add new stacks

### ✅ Better Testing
- **Environment switching**: Easy to test different configurations
- **Clear dependencies**: See which stacks use which variables
- **Validation**: Built-in environment validation per stack

## Migration Process

### 1. Backup Current Configuration

The migration script automatically backs up all existing `.env` files:

```bash
./migrate-to-centralized-env.sh
```

This creates a backup directory: `backups/env-migration-YYYYMMDD-HHMMSS/`

### 2. New File Structure

**Before** (Old system):
```
kompose/
├── .env                    # Root settings
├── core/.env              # Core stack settings  
├── auth/.env              # Auth stack settings
├── home/.env              # Home stack settings
└── ...
```

**After** (New system):
```
kompose/
├── .env                    # ALL settings (centralized)
├── domain.env             # Domain configuration
├── secrets.env            # Sensitive values
├── kompose-env.sh         # Environment management module
├── core/.env.generated    # Auto-generated (gitignored)
├── auth/.env.generated    # Auto-generated (gitignored)
└── ...
```

### 3. Variable Naming Convention

All stack-specific variables use the format: `STACKNAME_VARIABLE`

**Examples:**
```bash
# Core stack
CORE_POSTGRES_IMAGE=postgres:16-alpine
CORE_DB_USER=kompose
CORE_REDIS_IMAGE=redis:7-alpine

# Auth stack
AUTH_DOCKER_IMAGE=quay.io/keycloak/keycloak:latest
AUTH_KC_ADMIN_USERNAME=admin
AUTH_DB_NAME=keycloak

# Home stack
HOME_HOMEASSISTANT_IMAGE=ghcr.io/home-assistant/home-assistant:stable
HOME_ZIGBEE2MQTT_IMAGE=koenkk/zigbee2mqtt:latest
```

### 4. Shared Variables

Some variables are shared across all stacks and don't have prefixes:

```bash
# Shared configuration
NETWORK_NAME=kompose
TIMEZONE=Europe/Amsterdam
ADMIN_EMAIL=admin@example.com
DB_USER=kompose
DB_HOST=core-postgres
DB_PORT=5432
```

### 5. How It Works

When you run a stack, Kompose:

1. **Loads** the root `.env` file
2. **Filters** variables for the specific stack
3. **Maps** stack-scoped variables to generic names
4. **Generates** a temporary `.env.generated` file
5. **Passes** it to docker-compose

**Example for `core` stack:**
```bash
# In root .env:
CORE_POSTGRES_IMAGE=postgres:16-alpine

# When running core stack, becomes:
POSTGRES_IMAGE=postgres:16-alpine

# In compose file, reference as:
services:
  postgres:
    image: ${POSTGRES_IMAGE}
```

## Usage

### Running Stacks

No changes needed! Use the same commands:

```bash
# Start a stack
./kompose.sh up core

# Stop a stack
./kompose.sh down auth

# View logs
./kompose.sh logs home -f

# Check status
./kompose.sh status
```

### Viewing Stack Configuration

```bash
# Show environment for a specific stack
./kompose.sh env show core

# List all stack variables
./kompose.sh env list

# Validate stack environment
./kompose.sh env validate auth
```

### Editing Configuration

1. Edit the root `.env` file
2. Update the stack-scoped variables
3. Restart the stack:

```bash
vim .env
# Change CORE_POSTGRES_MAX_CONNECTIONS=100 to 200
./kompose.sh restart core
```

## Configuration Files

### `.env` - Main Configuration

Contains all stack configurations with scoped variables.

**Structure:**
```bash
# ===================================================================
# KOMPOSE - Root Configuration (Centralized)
# ===================================================================

# Global settings
NETWORK_NAME=kompose
TIMEZONE=Europe/Amsterdam

# ===================================================================
# CORE STACK CONFIGURATION
# ===================================================================
CORE_COMPOSE_PROJECT_NAME=core
CORE_POSTGRES_IMAGE=postgres:16-alpine
CORE_DB_USER=kompose
# ... more core variables

# ===================================================================
# AUTH STACK CONFIGURATION
# ===================================================================
AUTH_COMPOSE_PROJECT_NAME=auth
AUTH_DOCKER_IMAGE=quay.io/keycloak/keycloak:latest
# ... more auth variables

# ... more stacks
```

### `secrets.env` - Sensitive Data

Contains passwords, tokens, and other secrets.

**Important:** 
- Never commit to git
- Use `secrets.env.template` as reference
- Generate with: `./kompose.sh secrets generate`

```bash
# Database passwords
DB_PASSWORD=xxx
CORE_REDIS_PASSWORD=xxx

# Auth secrets
AUTH_KC_ADMIN_PASSWORD=xxx
AUTH_OAUTH2_CLIENT_SECRET=xxx

# ... more secrets
```

### `domain.env` - Domain Configuration

Contains domain and subdomain settings:

```bash
ROOT_DOMAIN=example.com
SUBDOMAIN_PROXY=proxy
SUBDOMAIN_AUTH=auth
# ... more subdomains
```

## Adding New Stacks

To add a new stack called `newstack`:

1. **Add configuration to `.env`:**
```bash
# ===================================================================
# NEWSTACK CONFIGURATION
# ===================================================================
NEWSTACK_COMPOSE_PROJECT_NAME=newstack
NEWSTACK_IMAGE=someimage:latest
NEWSTACK_PORT=8080
NEWSTACK_DB_NAME=newstack_db
```

2. **Add secrets to `secrets.env`:**
```bash
NEWSTACK_SECRET_KEY=xxx
NEWSTACK_ADMIN_PASSWORD=xxx
```

3. **Create stack directory and compose file:**
```bash
mkdir newstack
cd newstack
# Create compose.yaml referencing ${IMAGE}, ${PORT}, etc.
```

4. **Test the stack:**
```bash
./kompose.sh validate newstack
./kompose.sh up newstack
```

## Troubleshooting

### Stack Won't Start

**Check environment loading:**
```bash
./kompose.sh env show stackname
```

**Validate configuration:**
```bash
./kompose.sh env validate stackname
```

**View generated .env file:**
```bash
cat stackname/.env.generated
```

### Missing Variables

If a variable is missing:

1. Check if it's defined in root `.env`
2. Verify the correct prefix (e.g., `CORE_` not `core_`)
3. Ensure `.env` is being loaded
4. Check for typos in variable names

### Secrets Not Loading

If secrets aren't working:

1. Verify `secrets.env` exists in root directory
2. Check file permissions: `chmod 600 secrets.env`
3. Ensure secrets have correct variable names
4. Test loading: `source secrets.env && echo $SECRET_VAR`

### Docker Compose Can't Find Variables

If docker-compose complains about missing variables:

1. Check that `.env.generated` was created
2. Verify environment mapping in `kompose-env.sh`
3. Look for errors in stack startup logs
4. Try running: `docker-compose config` in stack directory

## Best Practices

### 1. Keep Secrets Separate
✅ **Do:** Store sensitive data in `secrets.env`
❌ **Don't:** Put passwords in `.env`

### 2. Use Descriptive Names
✅ **Do:** `CORE_POSTGRES_MAX_CONNECTIONS`
❌ **Don't:** `CORE_MAX_CONN`

### 3. Document Your Changes
✅ **Do:** Add comments explaining non-obvious settings
❌ **Don't:** Leave cryptic configuration without explanation

### 4. Test Before Committing
✅ **Do:** Validate and test after changes
❌ **Don't:** Commit untested configuration

### 5. Back Up Regularly
✅ **Do:** Keep backups of working configurations
❌ **Don't:** Rely solely on git history

## Reference

### Environment Commands

```bash
# Show stack environment
kompose env show <stack>

# List all stacks' variables  
kompose env list

# Validate stack environment
kompose env validate <stack>

# Generate .env file for stack
kompose env generate <stack>

# Show all configurations
kompose env show-all
```

### File Locations

- **Root .env:** `/home/valknar/Projects/kompose/.env`
- **Secrets:** `/home/valknar/Projects/kompose/secrets.env`
- **Domain:** `/home/valknar/Projects/kompose/domain.env`
- **Backups:** `/home/valknar/Projects/kompose/backups/env-migration-*/`

### Important Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `STACKNAME_COMPOSE_PROJECT_NAME` | Docker compose project name | `core` |
| `STACKNAME_DB_NAME` | Database name for stack | `keycloak` |
| `NETWORK_NAME` | Docker network name | `kompose` |
| `TIMEZONE` | Container timezone | `Europe/Amsterdam` |
| `DB_HOST` | PostgreSQL host | `core-postgres` |
| `DB_PORT` | PostgreSQL port | `5432` |

## Rollback

If you need to rollback to the old system:

```bash
# 1. Stop all stacks
./kompose.sh down

# 2. Restore backups
cp backups/env-migration-*/core.env core/.env
cp backups/env-migration-*/auth.env auth/.env
# ... restore others

# 3. Restore old root .env
cp backups/env-migration-*/root.env .env

# 4. Start stacks
./kompose.sh up
```

## Getting Help

If you encounter issues:

1. **Check the docs:** `/home/valknar/Projects/kompose/_docs/`
2. **View examples:** Look at the root `.env` file
3. **Validate config:** Run `./kompose.sh validate`
4. **Check logs:** `./kompose.sh logs <stack>`

---

**Last Updated:** October 2025  
**Version:** 2.0.0
