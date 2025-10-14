# {{STACK_TITLE}} Stack

Custom Docker Compose stack for {{STACK_NAME}}.

## Overview

The {{STACK_NAME}} stack provides:
- **Description** - Add description here
- **Features** - List key features

## Configuration

### Environment Variables

All {{STACK_NAME}} stack variables are defined in `+custom/{{STACK_NAME}}/.env`:

```bash
# Stack identification
COMPOSE_PROJECT_NAME={{STACK_NAME}}

# Docker image
DOCKER_IMAGE=your-image:latest

# Traefik configuration
TRAEFIK_ENABLED=true
TRAEFIK_HOST=${TRAEFIK_HOST_{{STACK_UPPER}}}

# Application port
APP_PORT=80
```

### Domain Configuration

Add your subdomain to the root `domain.env` file:

```bash
# {{STACK_TITLE}} subdomain
SUBDOMAIN_{{STACK_UPPER}}={{STACK_NAME}}
```

This will generate `TRAEFIK_HOST_{{STACK_UPPER}}` automatically.

### Secrets

If your stack requires secrets, add them to the root `secrets.env` file:

```bash
# {{STACK_TITLE}} stack secrets
{{STACK_UPPER}}_SECRET=your-secret-here
{{STACK_UPPER}}_API_KEY=your-api-key
```

Generate random secrets with:
```bash
./kompose.sh secrets generate
```

## Services

### {{STACK_TITLE}} Application
- **Image:** `your-image:latest`
- **Container:** `{{STACK_NAME}}_app`
- **Port:** 80 (internal only, proxied via Traefik)
- **Purpose:** Main application service
- **Access:** `https://{{STACK_NAME}}.yourdomain.com`

## Quick Start

### 1. Configure Domain

Add subdomain to `domain.env`:

```bash
echo "SUBDOMAIN_{{STACK_UPPER}}={{STACK_NAME}}" >> domain.env
```

### 2. Configure Environment

Edit `+custom/{{STACK_NAME}}/.env`:

```bash
vim +custom/{{STACK_NAME}}/.env

# Update:
DOCKER_IMAGE=your-actual-image:version
APP_PORT=80  # or your application port
```

### 3. Configure Secrets (if needed)

Add secrets to `secrets.env`:

```bash
vim secrets.env

# Add:
{{STACK_UPPER}}_SECRET=$(openssl rand -base64 32)
{{STACK_UPPER}}_API_KEY=your-api-key
```

### 4. Start Stack

```bash
# Ensure kompose network exists
docker network create kompose

# Start the stack
./kompose.sh up {{STACK_NAME}}

# Verify status
./kompose.sh status {{STACK_NAME}}
```

### 5. Access Application

- **Local:** `http://localhost:${APP_PORT}` (if ports exposed)
- **Production:** `https://{{STACK_NAME}}.yourdomain.com`

## Customization

### Add Volumes

Edit `compose.yaml` to add persistent storage:

```yaml
services:
  {{STACK_NAME}}:
    volumes:
      - {{STACK_NAME}}_data:/app/data

volumes:
  {{STACK_NAME}}_data:
    name: ${COMPOSE_PROJECT_NAME}_data
```

### Add Database Connection

If your service needs database access:

```yaml
services:
  {{STACK_NAME}}:
    environment:
      DB_HOST: ${DB_HOST}
      DB_PORT: ${DB_PORT}
      DB_NAME: {{STACK_NAME}}
      DB_USER: ${DB_USER}
      DB_PASSWORD: ${DB_PASSWORD}
    depends_on:
      - core-postgres
```

Don't forget to create the database:
```bash
./kompose.sh db exec -d postgres "CREATE DATABASE {{STACK_NAME}};"
```

### Configure Additional Services

Add more services to `compose.yaml`:

```yaml
services:
  {{STACK_NAME}}-worker:
    image: ${DOCKER_IMAGE}
    container_name: ${COMPOSE_PROJECT_NAME}_worker
    command: worker
    environment:
      REDIS_URL: redis://core-redis:6379
    networks:
      - kompose_network
```

## Management

### View Logs

```bash
# Follow logs
./kompose.sh logs {{STACK_NAME}} -f

# Last 100 lines
./kompose.sh logs {{STACK_NAME}} --tail 100
```

### Restart Service

```bash
./kompose.sh restart {{STACK_NAME}}
```

### Update Image

```bash
# Pull latest image
./kompose.sh pull {{STACK_NAME}}

# Restart with new image
./kompose.sh up {{STACK_NAME}}
```

### Execute Commands

```bash
# Open shell
./kompose.sh exec {{STACK_NAME}} sh

# Run command
./kompose.sh exec {{STACK_NAME}} your-command
```

## Troubleshooting

### Container Won't Start

```bash
# Check logs
docker logs {{STACK_NAME}}_app

# Validate compose file
./kompose.sh validate {{STACK_NAME}}

# Check environment
cd +custom/{{STACK_NAME}}
docker compose config
```

### Traefik Not Routing

```bash
# Verify Traefik labels
docker inspect {{STACK_NAME}}_app | grep traefik

# Check Traefik logs
docker logs proxy-traefik

# Verify domain resolution
nslookup {{STACK_NAME}}.yourdomain.com
```

### Health Check Failing

Adjust health check in `compose.yaml`:

```yaml
healthcheck:
  test: ["CMD-SHELL", "your-health-check-command"]
  interval: 30s
  timeout: 10s
  retries: 3
  start_period: 30s
```

## See Also

- [Stack Configuration Overview](/reference/stack-configuration)
- [Custom Stacks Guide](/guide/custom-stacks)
- [Traefik Configuration](/reference/traefik)
- [Database Management](/guide/database)

---

**Configuration Location:** `+custom/{{STACK_NAME}}/.env`  
**Domain Configuration:** `domain.env` (SUBDOMAIN_{{STACK_UPPER}})  
**Secrets Location:** `secrets.env`  
**Docker Network:** `kompose`
