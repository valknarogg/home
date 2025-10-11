---
title: Stack Standards
description: Standards and conventions for kompose stacks
---


## Overview

This document defines the standards for configuring stacks in the Kompose project to ensure consistency, maintainability, and ease of use.

## Directory Structure

```
kompose/
├── core/                    # Core infrastructure (required)
├── proxy/                   # Reverse proxy (required)
├── auth/                    # Authentication (recommended)
├── <stack-name>/           # Main application stacks
├── +utility/               # Optional utility stacks
│   ├── vault/
│   ├── link/
│   └── ...
├── +custom/                # User custom stacks
│   ├── blog/
│   └── ...
└── stack-template/         # Template for new stacks
```

### Naming Conventions

**Stack directories**:
- Lowercase only
- Single word preferred
- Hyphen for multi-word (e.g., `api-gateway`)
- No underscores or special characters

**Categories**:
- Core stacks: Root level, essential services
- Main stacks: Root level, commonly used
- Utility stacks: `+utility/` prefix, optional enhancements
- Custom stacks: `+custom/` prefix, user additions

## Required Files Per Stack

Each stack must contain:

```
<stack-name>/
├── compose.yaml         # Docker Compose configuration (required)
├── .env                # Stack environment variables (required)
├── .gitignore          # Git ignore patterns (recommended)
└── README.md           # Stack documentation (recommended)
```

### compose.yaml

**Must include**:
```yaml
name: <stack-name>           # Stack name (lowercase)

services:
  <service-name>:            # Primary service
    image: ${DOCKER_IMAGE}
    container_name: ${COMPOSE_PROJECT_NAME}_<service>
    restart: unless-stopped
    environment:
      TZ: ${TIMEZONE:-Europe/Amsterdam}
      # Service-specific vars
    volumes:
      - <service>_data:/data
    healthcheck:
      test: ["CMD", "wget", "--spider", "-q", "http://localhost:${APP_PORT}/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 30s
    networks:
      - kompose_network
    labels:
      # Standard Traefik labels (see TRAEFIK_LABELS_GUIDE.md)

volumes:
  <service>_data:
    name: ${COMPOSE_PROJECT_NAME}_<service>_data

networks:
  kompose_network:
    name: ${NETWORK_NAME:-kompose}
    external: true
```

### .env File Structure

```bash
# =================================================================
# <STACK-NAME> Stack Configuration
# =================================================================

# Stack identification
COMPOSE_PROJECT_NAME=<stack-name>

# Docker image
DOCKER_IMAGE=<image>:<tag>

# Application port (internal)
APP_PORT=<port>

# Network configuration
NETWORK_NAME=kompose
TIMEZONE=Europe/Amsterdam

# Traefik configuration
TRAEFIK_ENABLED=true
TRAEFIK_HOST=${TRAEFIK_HOST_<STACKNAME>}

# =================================================================
# Service-Specific Configuration
# =================================================================
# Add service-specific variables here

# =================================================================
# Notes
# =================================================================
# Secrets should be in root secrets.env
# Required secrets for this stack:
#   - <STACK>_SECRET=CHANGE_ME
```

### README.md Template

```markdown
# <Stack Name> - <Brief Description>

## Overview

Brief description of what this stack does.

## Services

- **<service-1>**: Description
- **<service-2>**: Description (if applicable)

## Access

- **URL**: https://<subdomain>.pivoine.art
- **Default credentials**: See secrets.env

## Configuration

Key configuration options in `.env`:

- `APP_PORT`: Internal port (default: <port>)
- `TRAEFIK_HOST`: Public hostname
- `<FEATURE>_ENABLED`: Enable/disable feature

## First-Time Setup

1. Configure secrets in `secrets.env`
2. Start stack: `./kompose.sh up <stack-name>`
3. Access at: https://<subdomain>.pivoine.art
4. Complete initial setup wizard

## Integration

### Database
Connects to: `core-postgres` database: `<stackname>`

### Email
Uses: Shared SMTP configuration from root .env

### SSO
Protected by: OAuth2 Proxy (optional)

## Troubleshooting

### Common issues and solutions

## Backup & Restore

```bash
# Backup
./kompose.sh db backup -d <stackname>

# Restore
./kompose.sh db restore -f backup.sql -d <stackname>
```

## Additional Resources

- [Official Documentation](<url>)
- [GitHub Repository](<url>)
```

## Environment Variable Standards

### Naming Conventions

**Format**: `<CATEGORY>_<NAME>`

**Categories**:
- `DB_*` - Database configuration
- `SMTP_*` / `EMAIL_*` - Email configuration
- `TRAEFIK_*` - Traefik/routing configuration
- `<STACK>_*` - Stack-specific variables

**Examples**:
```bash
# Good
DB_HOST=core-postgres
EMAIL_SMTP_PORT=587
TRAEFIK_HOST=${TRAEFIK_HOST_CHAIN}
N8N_ENCRYPTION_KEY=${N8N_ENCRYPTION_KEY}

# Avoid
database_host=...
smtp-port=...
host=...
```

### Variable Inheritance

**Order of precedence** (highest to lowest):
1. Stack `.env` file
2. Root `.env` file  
3. `domain.env` file
4. Docker Compose default values

**Example**:
```bash
# domain.env
ROOT_DOMAIN=pivoine.art
SUBDOMAIN_CHAIN=chain

# Root .env
TIMEZONE=Europe/Amsterdam
TRAEFIK_HOST_CHAIN=${SUBDOMAIN_CHAIN}.${ROOT_DOMAIN}

# stack/chain/.env
COMPOSE_PROJECT_NAME=chain
TRAEFIK_HOST=${TRAEFIK_HOST_CHAIN}  # Inherits from root
TIMEZONE=Europe/Paris               # Overrides root
```

### Required Variables

Every stack .env must define:
```bash
COMPOSE_PROJECT_NAME=<stackname>
NETWORK_NAME=kompose
TIMEZONE=Europe/Amsterdam
TRAEFIK_HOST=${TRAEFIK_HOST_<STACKNAME>}
```

### Optional but Recommended

```bash
DOCKER_IMAGE=<image>:<tag>
APP_PORT=<port>
TRAEFIK_ENABLED=true
```

## Docker Compose Standards

### Service Naming

**Container names**: `${COMPOSE_PROJECT_NAME}_<service>`

```yaml
container_name: ${COMPOSE_PROJECT_NAME}_app
container_name: ${COMPOSE_PROJECT_NAME}_postgres
container_name: ${COMPOSE_PROJECT_NAME}_redis
```

**Benefit**: Easy identification and stack association

### Volume Naming

**Named volumes**: `${COMPOSE_PROJECT_NAME}_<service>_<purpose>`

```yaml
volumes:
  app_data:
    name: ${COMPOSE_PROJECT_NAME}_app_data
  postgres_data:
    name: ${COMPOSE_PROJECT_NAME}_postgres_data
```

**Benefit**: Prevents collisions, clear ownership

### Health Checks

**Every service should have a health check**:

```yaml
healthcheck:
  test: ["CMD", "wget", "--spider", "-q", "http://localhost:${APP_PORT}/health"]
  interval: 30s
  timeout: 10s
  retries: 3
  start_period: 30s
```

**Adjust for service type**:
- Web apps: `wget` or `curl` HTTP endpoint
- Databases: Client command (e.g., `pg_isready`)
- Message queues: Client ping (e.g., `redis-cli ping`)

### Restart Policies

**Standard**: `restart: unless-stopped`

**When to use others**:
- `no`: One-off tasks, migrations
- `always`: System-critical services only
- `on-failure`: Services that should stop on success

### Dependencies

**Use `depends_on` with health checks**:

```yaml
depends_on:
  postgres:
    condition: service_healthy
  redis:
    condition: service_healthy
```

**Note**: Requires health checks on dependent services

## Network Configuration

**All services use the shared `kompose` network**:

```yaml
networks:
  kompose_network:
    name: ${NETWORK_NAME:-kompose}
    external: true
```

**Create once** (in core stack):
```bash
docker network create kompose
```

**Benefit**: Inter-stack communication without exposing ports

## Security Standards

### Secrets Management

**Never hardcode secrets**:
```yaml
# ✗ Bad
environment:
  DB_PASSWORD: hardcoded_password

# ✓ Good
environment:
  DB_PASSWORD: ${DB_PASSWORD}
```

**All secrets in root `secrets.env`**:
```bash
# secrets.env
DB_PASSWORD=generated_secure_password
<STACK>_API_KEY=generated_api_key
```

### Port Exposure

**Minimize exposed ports**:
```yaml
# Internal-only service (no ports exposed)
services:
  postgres:
    # No ports: section

# Development only (comment in production)
services:
  app:
    # ports:
    #   - "${APP_PORT}:${APP_PORT}"
```

**Use Traefik for external access** instead of port mapping

### File Permissions

**Sensitive files**:
```bash
chmod 600 secrets.env
chmod 600 stack/.env  # If contains secrets
```

**.gitignore**:
```
secrets.env
.env.local
*.key
*.pem
```

## Integration Patterns

### Database Integration

```yaml
environment:
  DB_TYPE: postgres
  DB_HOST: core-postgres  # or ${DB_HOST}
  DB_PORT: 5432
  DB_NAME: <stackname>
  DB_USER: ${DB_USER}
  DB_PASSWORD: ${DB_PASSWORD}
```

**Database naming**: Use stack name as database name

### Email Integration

```yaml
environment:
  SMTP_HOST: ${EMAIL_SMTP_HOST}
  SMTP_PORT: ${EMAIL_SMTP_PORT}
  SMTP_USER: ${EMAIL_SMTP_USER}
  SMTP_PASSWORD: ${EMAIL_SMTP_PASSWORD}
  EMAIL_FROM: ${EMAIL_FROM}
```

**Use shared SMTP** from root configuration

### MQTT Integration

```yaml
environment:
  MQTT_BROKER: core-mqtt
  MQTT_PORT: 1883
  MQTT_TOPIC: kompose/<stackname>
```

**Topic naming**: `kompose/<stackname>/<subtopic>`

### Redis Integration

```yaml
environment:
  REDIS_HOST: core-redis
  REDIS_PORT: 6379
  REDIS_PASSWORD: ${REDIS_PASSWORD}
```

**Database separation**: Use different Redis databases if needed

## Documentation Standards

### Code Comments

```yaml
services:
  app:
    # Main application service
    # Handles web requests and background jobs
    image: ${DOCKER_IMAGE}
    
    environment:
      # Database connection
      DB_HOST: ${DB_HOST}
      
      # Feature flags
      FEATURE_API: ${API_ENABLED:-true}  # Enable API endpoints
```

### Environment File Comments

```bash
# =================================================================
# Section Header
# =================================================================

# Variable description
VARIABLE_NAME=value

# Multi-line description
# Can span multiple lines
# For complex configuration
COMPLEX_VAR=value
```

### README Sections

Required sections:
1. Overview
2. Services
3. Access
4. Configuration
5. First-Time Setup
6. Troubleshooting

Optional sections:
- Integration
- Backup & Restore
- API Reference
- Additional Resources

## Testing Standards

### Before Committing

```bash
# 1. Validate compose file
./kompose.sh validate <stack>

# 2. Test stack independently
./kompose.sh up <stack>
./kompose.sh status <stack>

# 3. Check logs for errors
./kompose.sh logs <stack> | grep -i error

# 4. Verify external access
curl -I https://<subdomain>.pivoine.art

# 5. Test integrations
# - Database connection
# - Email sending
# - SSO authentication
```

### Health Check

```bash
# Check all health checks pass
docker ps --filter "health=healthy"
docker ps --filter "health=unhealthy"
```

## Migration Guide

### Updating Existing Stacks

1. **Backup current config**:
   ```bash
   cp compose.yaml compose.yaml.bak
   cp .env .env.bak
   ```

2. **Update compose.yaml**:
   - Add health check if missing
   - Standardize labels
   - Update volume naming
   - Add documentation comments

3. **Update .env**:
   - Follow naming conventions
   - Add header comments
   - Move secrets to root secrets.env

4. **Add README.md**:
   - Use template
   - Document configuration
   - Add troubleshooting

5. **Test**:
   ```bash
   ./kompose.sh validate <stack>
   ./kompose.sh restart <stack>
   ```

## Checklist for New Stacks

- [ ] Directory created in correct location
- [ ] compose.yaml follows standards
- [ ] .env follows standards
- [ ] README.md created with all sections
- [ ] Subdomain added to domain.env
- [ ] TRAEFIK_HOST added to root .env
- [ ] Secrets added to root secrets.env
- [ ] Health check configured
- [ ] Traefik labels standardized
- [ ] Network configured correctly
- [ ] Validates: `./kompose.sh validate`
- [ ] Starts successfully: `./kompose.sh up`
- [ ] Accessible via HTTPS
- [ ] SSL certificate issued
- [ ] Integrations tested
- [ ] Documentation complete

## Related Documentation

- [Stack Template](stack-template/README.md)
- [Traefik Labels Guide](TRAEFIK_LABELS_GUIDE.md)
- [Domain Configuration](DOMAIN_CONFIGURATION.md)
- [Quick Start](QUICK_START.md)
