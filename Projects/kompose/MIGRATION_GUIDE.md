# Kompose Configuration Update - Migration Guide

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
