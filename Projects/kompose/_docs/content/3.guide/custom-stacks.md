---
title: Custom Stacks
description: Create and manage your own Docker Compose stacks in Kompose
---

Learn how to extend Kompose with your own custom Docker Compose stacks while maintaining unified management through the standard command interface.

## Overview

The Kompose platform supports custom Docker Compose stacks through automatic discovery and integration. Custom stacks receive the same operational capabilities as built-in services, including:

- Automatic discovery and registration
- Unified CLI management
- Environment variable inheritance
- Domain configuration integration
- Secrets management
- Database connectivity
- Traefik routing with SSL
- Standardized operations (start, stop, logs, etc.)

## Quick Start

### Creating a Custom Stack

**Option 1: Using the Generator (Recommended)**

```bash
# Generate a complete stack structure
./kompose.sh generate mynewstack
```

This creates:
```
+custom/mynewstack/
├── compose.yaml           # Docker Compose configuration
├── .env                   # Environment variables template
├── .env.local             # Local development config
├── Dockerfile             # Optional custom image
├── hooks.sh               # Optional lifecycle hooks
├── README.md              # Stack documentation
└── tests/                 # Test files
```

**Option 2: Manual Creation**

```bash
# Create directory and basic files
mkdir -p +custom/mynewstack
touch +custom/mynewstack/compose.yaml
touch +custom/mynewstack/.env

# Stack is automatically discovered on next kompose.sh execution
```

### Example Custom Stack

Here's a complete example for a simple blog:

```yaml
# +custom/blog/compose.yaml
services:
  blog:
    image: ghost:latest
    container_name: blog
    environment:
      # Use inherited environment variables
      database__client: postgres
      database__connection__host: ${DB_HOST}
      database__connection__user: ${DB_USER}
      database__connection__password: ${DB_PASSWORD}
      database__connection__database: blog
      url: https://${TRAEFIK_HOST_BLOG}
    volumes:
      - ./content:/var/lib/ghost/content
    networks:
      - kompose_network
    labels:
      # Traefik configuration for SSL and routing
      - "traefik.enable=true"
      - "traefik.http.routers.blog.rule=Host(`${TRAEFIK_HOST_BLOG}`)"
      - "traefik.http.routers.blog.entrypoints=websecure"
      - "traefik.http.routers.blog.tls.certresolver=letsencrypt"
      - "traefik.http.services.blog.loadbalancer.server.port=2368"

networks:
  kompose_network:
    name: kompose
    external: true
```

```bash
# +custom/blog/.env
# Blog Stack - A simple Ghost blog

# Stack configuration
BLOG_COMPOSE_PROJECT_NAME=blog

# Database
BLOG_DB_NAME=blog

# Domain (uses domain.env SUBDOMAIN_BLOG)
BLOG_TRAEFIK_HOST=${SUBDOMAIN_BLOG}.${ROOT_DOMAIN}
```

## Directory Structure

Custom stacks live in the `+custom` directory:

```
kompose/
├── +custom/                   # Custom stacks directory
│   ├── blog/
│   │   ├── compose.yaml       # Required
│   │   ├── .env               # Recommended
│   │   ├── .env.local         # Local development
│   │   ├── Dockerfile         # Optional
│   │   ├── hooks.sh           # Optional
│   │   ├── content/           # Stack-specific data
│   │   └── README.md          # Documentation
│   ├── myapp/
│   │   ├── compose.yaml
│   │   └── .env
│   └── another-service/
│       ├── compose.yaml
│       └── .env
├── core/                      # Built-in stacks
├── auth/
└── ...
```

::alert{type="info"}
The `+custom` prefix ensures the directory sorts to the top and is clearly identified as user-defined content.
::

## Automatic Discovery

### How It Works

When you run any `kompose.sh` command, the system:

1. **Scans** the `+custom` directory for subdirectories
2. **Validates** each subdirectory has a `compose.yaml` file
3. **Extracts** description from `.env` file comments
4. **Registers** valid stacks for management

### Discovery Requirements

For a stack to be discovered automatically:

```
✓ Located in +custom/ directory
✓ Contains compose.yaml file (exact name)
✓ Subdirectory name is the stack name
```

Optional but recommended:
```
• .env file with stack configuration
• .env.local for local development
• README.md for documentation
```

### Stack Descriptions

Add a description to your `.env` file for better visibility:

```bash
# +custom/myapp/.env
# MyApp Stack - A custom application for...
# Description appears in stack listings

MYAPP_COMPOSE_PROJECT_NAME=myapp
```

The first comment line containing "Stack" will be used as the description in `./kompose.sh list`.

## Managing Custom Stacks

### All Standard Commands Work

Custom stacks support all standard management commands:

**Lifecycle Operations:**
```bash
# Start stack
./kompose.sh up blog

# Stop stack
./kompose.sh down blog

# Restart stack
./kompose.sh restart blog

# Pull latest images
./kompose.sh pull blog

# Rebuild images
./kompose.sh build blog
```

**Monitoring:**
```bash
# Check status
./kompose.sh status blog

# Follow logs
./kompose.sh logs blog -f

# View recent logs
./kompose.sh logs blog --tail 100
```

**Container Operations:**
```bash
# Execute commands in container
./kompose.sh exec blog sh

# Run specific command
./kompose.sh exec blog ghost --help
```

**Version Control:**
```bash
# Deploy specific version
./kompose.sh tag deploy -s blog -e prod -v 2.1.0

# List deployed versions
./kompose.sh tag list blog

# Rollback to previous version
./kompose.sh tag rollback -s blog -e prod -v 2.0.5
```

### Listing Stacks

View all stacks including custom ones:

```bash
./kompose.sh list
```

Output example:
```
╔════════════════════════════════════════════════════════════╗
║                    Available Stacks                        ║
╚════════════════════════════════════════════════════════════╝

━━━ Built-in Stacks ━━━ (14)
  core                     Core services: PostgreSQL, Redis, MQTT
  auth                     Authentication and SSO with Keycloak
  proxy                    Traefik reverse proxy with SSL
  ...

━━━ Custom Stacks ━━━ (3)
  blog                     Ghost blog platform
  myapp                    My custom application
  store                    E-commerce platform
```

## Integration Features

### Environment Variables

Custom stacks inherit environment variables from root configuration files:

**From `.env`:**
- `NETWORK_NAME` - Docker network
- `TIMEZONE` - Container timezone
- `DB_HOST`, `DB_PORT`, `DB_USER` - Database connection
- `REDIS_HOST`, `REDIS_PORT` - Redis connection
- `ADMIN_EMAIL` - Administrator email

**From `domain.env`:**
- `ROOT_DOMAIN` - Base domain
- `TRAEFIK_HOST_*` - Subdomain configurations

**From `secrets.env`:**
- `DB_PASSWORD` - Database password
- `REDIS_PASSWORD` - Redis password
- Stack-specific secrets

### Domain Configuration

Add your stack's subdomain to `domain.env`:

```bash
# domain.env
SUBDOMAIN_BLOG=blog

# Automatically generates:
# TRAEFIK_HOST_BLOG=blog.yourdomain.com
```

Use in your compose file:
```yaml
environment:
  URL: https://${TRAEFIK_HOST_BLOG}
labels:
  - "traefik.http.routers.blog.rule=Host(`${TRAEFIK_HOST_BLOG}`)"
```

### Secrets Management

Add stack-specific secrets to `secrets.env`:

```bash
# secrets.env
BLOG_API_KEY=your-secret-key
BLOG_ADMIN_PASSWORD=secure-password
```

Reference in compose file:
```yaml
environment:
  ADMIN_PASSWORD: ${BLOG_ADMIN_PASSWORD}
  API_KEY: ${BLOG_API_KEY}
```

::alert{type="warning"}
Never commit `secrets.env` to version control!
::

### Database Integration

Custom stacks can easily connect to the core PostgreSQL:

**1. Create database:**
```bash
./kompose.sh db exec -d postgres "CREATE DATABASE myapp;"
```

**2. Use in compose file:**
```yaml
environment:
  DB_HOST: ${DB_HOST}           # core-postgres
  DB_PORT: ${DB_PORT}           # 5432
  DB_USER: ${DB_USER}           # kompose
  DB_PASSWORD: ${DB_PASSWORD}   # from secrets.env
  DB_NAME: myapp
```

**3. Backup and restore:**
```bash
# Backup
./kompose.sh db backup -d myapp

# Restore
./kompose.sh db restore -f backups/database/myapp_20251014_120000.sql
```

### Traefik Integration

Enable automatic HTTPS and routing:

```yaml
services:
  myapp:
    labels:
      # Enable Traefik
      - "traefik.enable=true"
      
      # HTTP Router
      - "traefik.http.routers.myapp.rule=Host(`${TRAEFIK_HOST_MYAPP}`)"
      - "traefik.http.routers.myapp.entrypoints=websecure"
      - "traefik.http.routers.myapp.tls.certresolver=letsencrypt"
      
      # Service configuration
      - "traefik.http.services.myapp.loadbalancer.server.port=3000"
      
      # Optional: Middlewares
      - "traefik.http.routers.myapp.middlewares=compression@docker"
```

This automatically provides:
- ✅ HTTPS with Let's Encrypt SSL
- ✅ HTTP to HTTPS redirection
- ✅ Compression middleware
- ✅ Health checks
- ✅ Load balancing

### OAuth2 SSO Integration

Protect your stack with Keycloak SSO:

```yaml
services:
  myapp:
    labels:
      # OAuth2 Proxy middleware
      - "traefik.http.routers.myapp.middlewares=oauth2@docker"
      - "traefik.http.middlewares.oauth2.forwardauth.address=http://oauth2-proxy:4180"
      - "traefik.http.middlewares.oauth2.forwardauth.trustForwardHeader=true"
```

## Advanced Patterns

### Multi-Container Stack

```yaml
# +custom/myapp/compose.yaml
services:
  frontend:
    build: ./frontend
    environment:
      API_URL: http://backend:3000
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.myapp-frontend.rule=Host(`${TRAEFIK_HOST_MYAPP}`)"
    networks:
      - kompose_network

  backend:
    build: ./backend
    environment:
      DB_HOST: ${DB_HOST}
      DB_PASSWORD: ${DB_PASSWORD}
      REDIS_HOST: ${REDIS_HOST}
    networks:
      - kompose_network

  worker:
    build: ./backend
    command: npm run worker
    environment:
      REDIS_HOST: ${REDIS_HOST}
    networks:
      - kompose_network

networks:
  kompose_network:
    external: true
```

### Using Lifecycle Hooks

Create a `hooks.sh` file for custom logic:

```bash
#!/bin/bash
# +custom/myapp/hooks.sh

on_pre_up() {
    echo "Running pre-start checks..."
    # Create required directories
    mkdir -p ./data ./logs
    
    # Run database migrations
    docker-compose run --rm backend npm run migrate
}

on_post_up() {
    echo "Stack started successfully"
    # Send notification
    curl -X POST https://notifications.example.com/api
}

on_pre_down() {
    echo "Backing up data before shutdown..."
    ./backup-script.sh
}
```

Make it executable:
```bash
chmod +x +custom/myapp/hooks.sh
```

### Development vs Production

Use separate environment files:

```bash
# +custom/myapp/.env.local
MYAPP_DEBUG=true
MYAPP_LOG_LEVEL=debug
MYAPP_API_URL=http://localhost:3000

# +custom/myapp/.env
MYAPP_DEBUG=false
MYAPP_LOG_LEVEL=info  
MYAPP_API_URL=https://${TRAEFIK_HOST_MYAPP}
```

Switch modes:
```bash
# Local development
./kompose.sh setup local
./kompose.sh up myapp

# Production
./kompose.sh setup prod
./kompose.sh up myapp
```

## Best Practices

### Project Structure

```
+custom/mystack/
├── compose.yaml              # Main compose file
├── .env                      # Production environment
├── .env.local                # Local development
├── .dockerignore             # Docker build exclusions
├── Dockerfile                # Custom image build
├── hooks.sh                  # Lifecycle hooks
├── README.md                 # Stack documentation
├── src/                      # Source code
├── data/                     # Persistent data (gitignored)
├── logs/                     # Logs (gitignored)
├── backups/                  # Backups (gitignored)
└── tests/                    # Test files
    ├── integration/
    └── unit/
```

### .gitignore

```gitignore
# +custom/mystack/.gitignore
.env.local
data/
logs/
backups/
*.log
node_modules/
*.secret
```

### Documentation

Create a comprehensive README:

```markdown
# MyStack

Brief description of what this stack does.

## Prerequisites

- Core stack running
- Database initialized
- Domain configured

## Setup

\```bash
./kompose.sh generate-env mystack
./kompose.sh up mystack
\```

## Configuration

### Environment Variables

- `MYSTACK_API_KEY` - API key for service X
- `MYSTACK_DEBUG` - Enable debug mode

### Secrets

Add to secrets.env:
\```bash
MYSTACK_API_KEY=your-key-here
\```

## Usage

### Starting
\```bash
./kompose.sh up mystack
\```

### Accessing
- Web UI: https://mystack.yourdomain.com
- API: https://mystack.yourdomain.com/api

## Troubleshooting

Common issues and solutions...
```

### Validation

Create validation tests:

```bash
# +custom/mystack/tests/validate.sh
#!/bin/bash

echo "Validating mystack configuration..."

# Check required environment variables
required_vars=("MYSTACK_API_KEY" "MYSTACK_DB_NAME")
for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        echo "ERROR: $var is not set"
        exit 1
    fi
done

# Check database exists
if ! ./kompose.sh db list | grep -q "mystack"; then
    echo "ERROR: Database 'mystack' not found"
    exit 1
fi

# Check network connectivity
if ! docker network inspect kompose &>/dev/null; then
    echo "ERROR: Docker network 'kompose' not found"
    exit 1
fi

echo "✓ Validation passed"
```

## Troubleshooting

### Stack Not Appearing

**Problem:** Custom stack doesn't show in `./kompose.sh list`

**Solutions:**
```bash
# 1. Check directory structure
ls -la +custom/mystack/

# 2. Verify compose.yaml exists
test -f +custom/mystack/compose.yaml && echo "✓ Found" || echo "✗ Missing"

# 3. Validate compose file
cd +custom/mystack && docker compose config

# 4. Check for errors
./kompose.sh validate mystack
```

### Environment Variables Not Working

**Problem:** Stack can't access environment variables

**Solutions:**
```bash
# 1. Check variable is defined in root .env
grep "MYVAR" .env

# 2. Verify environment generation
./kompose.sh env mystack

# 3. Check generated file
cat +custom/mystack/.env.generated

# 4. Test variable substitution
cd +custom/mystack && docker compose config | grep "MYVAR"
```

### Database Connection Failures

**Problem:** Can't connect to PostgreSQL

**Solutions:**
```bash
# 1. Verify DB_HOST is correct
./kompose.sh env mystack | grep DB_HOST
# Should show: DB_HOST=core-postgres

# 2. Check database exists
./kompose.sh db list | grep mystack

# 3. Test connectivity
./kompose.sh exec mystack nc -zv core-postgres 5432

# 4. Check network
docker network inspect kompose | grep mystack
```

### Traefik Routing Issues

**Problem:** Can't access stack via domain

**Solutions:**
```bash
# 1. Check Traefik labels
cd +custom/mystack && docker compose config | grep traefik

# 2. Verify domain configuration
grep "SUBDOMAIN_MYSTACK" domain.env
grep "TRAEFIK_HOST_MYSTACK" domain.env

# 3. Check Traefik logs
./kompose.sh logs proxy | grep mystack

# 4. Verify container is in network
docker inspect mystack-container | grep kompose
```

## Migration from Standalone

If you have an existing Docker Compose setup:

**1. Copy files to +custom:**
```bash
mkdir -p +custom/mystack
cp /path/to/old/docker-compose.yml +custom/mystack/compose.yaml
cp /path/to/old/.env +custom/mystack/
```

**2. Update network configuration:**
```yaml
# Change from:
networks:
  mynetwork:

# To:
networks:
  kompose_network:
    name: kompose
    external: true
```

**3. Update environment variables:**
```yaml
# Use inherited variables:
environment:
  DB_HOST: ${DB_HOST}           # Instead of hardcoded
  DB_PASSWORD: ${DB_PASSWORD}   # From secrets.env
```

**4. Add Traefik labels if needed:**
```yaml
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.mystack.rule=Host(`${TRAEFIK_HOST_MYSTACK}`)"
```

**5. Test:**
```bash
./kompose.sh validate mystack
./kompose.sh up mystack
```

## Examples Repository

For more examples, check:
- `+custom/blog/` - Ghost blog setup
- `+custom/sexy/` - Directus CMS configuration
- Example patterns in the documentation

## Next Steps

- [Stack Management Guide](./stack-management.md)
- [Environment Configuration](./environment-setup.md)
- [Secrets Management](./secrets.md)
- [Database Operations](./database.md)
- [Traefik Configuration](./traefik.md)

---

**Version:** 2.0.0  
**Last Updated:** October 2025  
**Related:** CUSTOM_STACK_MANAGEMENT.md (archived)
