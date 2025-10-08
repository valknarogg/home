---
title: Environment Variables
description: Complete reference for all environment variables
---

# Environment Variables

Complete reference for all environment variables used in Kompose.

## Global Variables

These are set in the root `.env` file and available to all stacks.

### Network Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `NETWORK_NAME` | `kompose` | Docker network name |

### Database Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `DB_USER` | - | PostgreSQL username |
| `DB_PASSWORD` | - | PostgreSQL password |
| `DB_PORT` | `5432` | PostgreSQL port |
| `DB_HOST` | `postgres` | PostgreSQL host |

### Admin Settings

| Variable | Default | Description |
|----------|---------|-------------|
| `ADMIN_EMAIL` | - | Administrator email |
| `ADMIN_PASSWORD` | - | Administrator password |

### Email/SMTP Settings

| Variable | Default | Description |
|----------|---------|-------------|
| `EMAIL_TRANSPORT` | `smtp` | Email transport method |
| `EMAIL_FROM` | - | Default sender address |
| `EMAIL_SMTP_HOST` | - | SMTP server hostname |
| `EMAIL_SMTP_PORT` | `465` | SMTP server port |
| `EMAIL_SMTP_USER` | - | SMTP username |
| `EMAIL_SMTP_PASSWORD` | - | SMTP password |

## Stack-Specific Variables

These are set in individual stack `.env` files.

### Common Stack Variables

| Variable | Description |
|----------|-------------|
| `COMPOSE_PROJECT_NAME` | Stack project name |
| `TRAEFIK_HOST` | Domain for Traefik routing |
| `APP_PORT` | Internal application port |

### Auth Stack (Keycloak)

| Variable | Description |
|----------|-------------|
| `KC_ADMIN_USERNAME` | Keycloak admin username |
| `KC_ADMIN_PASSWORD` | Keycloak admin password |
| `KC_DB_NAME` | Keycloak database name |

### News Stack (Letterspace)

| Variable | Description |
|----------|-------------|
| `JWT_SECRET` | JWT signing secret |
| `DB_NAME` | Newsletter database name |
| `NODE_ENV` | Node environment (production/development) |

### Sexy Stack (Directus)

| Variable | Description |
|----------|-------------|
| `KEY` | Directus encryption key |
| `SECRET` | Directus secret key |
| `ADMIN_EMAIL` | Directus admin email |
| `ADMIN_PASSWORD` | Directus admin password |

## Configuration Precedence

Environment variables follow this priority order:

1. **CLI Override** (`-e` flag) - Highest priority
2. **Stack .env** - Stack-specific settings
3. **Root .env** - Global defaults
4. **Compose File** - Docker Compose defaults

### Example

```bash
# Root .env
DB_HOST=postgres

# news/.env
DB_HOST=news-postgres  # Overrides root

# CLI
./kompose.sh -e DB_HOST=localhost news up -d  # Overrides both
```

## Best Practices

### Security

- ✅ Use strong, random passwords
- ✅ Never commit `.env` files to version control
- ✅ Use `.env.example` as template
- ✅ Rotate secrets regularly

### Organization

- ✅ Document custom variables
- ✅ Group related variables
- ✅ Use consistent naming
- ✅ Keep defaults in root `.env`

## Generating Secrets

### Random Passwords

```bash
# OpenSSL
openssl rand -hex 32

# UUID
uuidgen

# Base64
openssl rand -base64 32
```

### JWT Secrets

```bash
openssl rand -hex 64
```

### Encryption Keys

```bash
openssl rand -base64 32
```
