# Stack Generator

The `kompose generate` command provides a powerful way to scaffold custom Docker Compose stacks with templated files, including compose.yaml, .env, README.md, and test files.

## Overview

The stack generator creates a complete, production-ready stack structure following Kompose conventions:
- **Docker Compose File** - Pre-configured with Traefik labels, health checks, and best practices
- **Environment Configuration** - Stack-specific .env file with common variables
- **Documentation** - README.md with comprehensive usage instructions
- **Tests** - Automated test file for validation

All generated stacks are placed in the `+custom/<name>` directory and are automatically integrated with the Kompose ecosystem.

## Quick Start

### Generate a New Stack

```bash
./kompose.sh generate myapp
```

This creates:
```
+custom/myapp/
├── compose.yaml      # Docker Compose configuration
├── .env              # Environment variables
└── .gitignore        # Git ignore rules

_docs/content/5.stacks/+custom/
└── myapp.md          # Documentation

__tests/generated/
└── test-myapp.sh     # Test suite
```

### Configure Your Stack

1. **Edit Environment Variables**
   ```bash
   vim +custom/myapp/.env
   ```
   Update `DOCKER_IMAGE`, `APP_PORT`, and add custom variables.

2. **Customize Docker Compose**
   ```bash
   vim +custom/myapp/compose.yaml
   ```
   Add volumes, environment variables, or additional services.

3. **Update Documentation**
   ```bash
   vim _docs/content/5.stacks/+custom/myapp.md
   ```
   Document your stack's features and configuration.

### Start Your Stack

```bash
./kompose.sh up myapp
```

## Commands

### Generate a New Stack

```bash
kompose generate <stack-name>
```

**Options:**
- `<stack-name>` - Name for your custom stack (lowercase, alphanumeric, hyphens only)

**Example:**
```bash
# Generate a new application stack
kompose generate webapp

# Generate a monitoring stack
kompose generate monitoring-stack
```

**What It Does:**
1. Creates stack directory in `+custom/<name>/`
2. Generates compose.yaml with Traefik integration
3. Creates .env file with standard variables
4. Generates documentation in `_docs/content/5.stacks/+custom/`
5. Creates test file in `__tests/generated/`
6. Adds subdomain to `domain.env`

### List Custom Stacks

```bash
kompose generate list
```

Shows all custom stacks with:
- Stack name
- Running status
- File locations
- Documentation path

**Example Output:**
```
Custom stacks:

  webapp
    Status: 2 containers running
    Location: +custom/webapp
    Docs: _docs/content/5.stacks/+custom/webapp.md

  api-service
    Status: stopped
    Location: +custom/api-service
    Docs: _docs/content/5.stacks/+custom/api-service.md

Total: 2 custom stack(s)
```

### Show Stack Information

```bash
kompose generate show <stack-name>
```

Displays detailed information about a custom stack:
- File locations
- Current status
- Configuration variables

**Example:**
```bash
kompose generate show webapp
```

### Delete a Custom Stack

```bash
kompose generate delete <stack-name>
```

Removes a custom stack and all associated files:
- Stack directory (`+custom/<name>/`)
- Documentation (`_docs/content/5.stacks/+custom/<name>.md`)
- Test file (`__tests/generated/test-<name>.sh`)

**Interactive confirmation is required.**

**Example:**
```bash
kompose generate delete webapp
```

## Generated File Templates

### compose.yaml

The generated compose.yaml includes:

```yaml
name: myapp

services:
  myapp:
    image: ${DOCKER_IMAGE}
    container_name: ${COMPOSE_PROJECT_NAME}_app
    restart: unless-stopped
    environment:
      TZ: ${TIMEZONE:-Europe/Amsterdam}
    healthcheck:
      test: ["CMD-SHELL", "wget --spider -q http://localhost:${APP_PORT:-80}/health || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 30s
    networks:
      - kompose_network
    labels:
      # Traefik labels for automatic routing and SSL
      - 'traefik.enable=true'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web.rule=Host(`${TRAEFIK_HOST}`)'
      # ... additional Traefik configuration

networks:
  kompose_network:
    name: ${NETWORK_NAME:-kompose}
    external: true
```

**Features:**
- ✅ Traefik reverse proxy integration
- ✅ Automatic HTTPS with Let's Encrypt
- ✅ Health checks
- ✅ Restart policies
- ✅ Network isolation
- ✅ Environment variable support

### .env

The generated .env file includes:

```bash
# Stack identification
COMPOSE_PROJECT_NAME=myapp

# Docker image
DOCKER_IMAGE=your-image:latest

# Network configuration
NETWORK_NAME=kompose

# Traefik configuration
TRAEFIK_ENABLED=true
TRAEFIK_HOST=${TRAEFIK_HOST_MYAPP}

# Application configuration
APP_PORT=80

# Timezone
TIMEZONE=Europe/Amsterdam
```

### README.md

Comprehensive documentation template with:
- Overview and features
- Configuration guide
- Quick start instructions
- Customization examples
- Management commands
- Troubleshooting tips

### Test File

Automated tests for:
- Compose file validation
- Environment variable presence
- Network configuration
- Traefik labels
- Docker Compose compatibility

## Customization Guide

### Adding Volumes

Edit `compose.yaml` to add persistent storage:

```yaml
services:
  myapp:
    volumes:
      - myapp_data:/app/data
      - ./config:/app/config:ro

volumes:
  myapp_data:
    name: ${COMPOSE_PROJECT_NAME}_data
```

### Adding Database Connection

If your service needs database access:

```yaml
services:
  myapp:
    environment:
      DB_HOST: ${DB_HOST}
      DB_PORT: ${DB_PORT}
      DB_NAME: myapp
      DB_USER: ${DB_USER}
      DB_PASSWORD: ${DB_PASSWORD}
    depends_on:
      core-postgres:
        condition: service_healthy
```

Don't forget to create the database:
```bash
./kompose.sh db exec -d postgres "CREATE DATABASE myapp;"
```

### Adding Additional Services

Add companion services like workers or queues:

```yaml
services:
  myapp-worker:
    image: ${DOCKER_IMAGE}
    container_name: ${COMPOSE_PROJECT_NAME}_worker
    command: worker
    environment:
      REDIS_URL: redis://core-redis:6379
    networks:
      - kompose_network
```

### Using Secrets

Add sensitive values to `secrets.env`:

```bash
# In secrets.env
MYAPP_API_KEY=your-secret-key
MYAPP_SECRET_TOKEN=your-token
```

Reference in `compose.yaml`:
```yaml
services:
  myapp:
    environment:
      API_KEY: ${MYAPP_API_KEY}
      SECRET_TOKEN: ${MYAPP_SECRET_TOKEN}
```

### Custom Domain Configuration

Update `domain.env` with your subdomain:

```bash
# In domain.env
SUBDOMAIN_MYAPP=app
```

This generates:
- **Local:** `http://localhost:PORT`
- **Production:** `https://app.yourdomain.com`

## Integration with Kompose

Generated stacks are fully integrated with Kompose:

### Stack Management

```bash
# Start your stack
./kompose.sh up myapp

# View status
./kompose.sh status myapp

# View logs
./kompose.sh logs myapp -f

# Restart
./kompose.sh restart myapp

# Stop
./kompose.sh down myapp
```

### Profile Support

Add custom stacks to profiles:

```bash
# Create profile with custom stack
./kompose.sh profile create production
# Add myapp to the profile stacks list

# Start all stacks in profile (including myapp)
./kompose.sh profile up
```

### Testing

Run automated tests:

```bash
# Test specific stack
./kompose.sh test -t myapp

# Test all stacks
./kompose.sh test
```

### Environment Validation

```bash
# Validate configuration
./kompose.sh validate myapp

# Show environment variables
./kompose.sh env show myapp
```

## Best Practices

### Naming Conventions

- Use lowercase letters, numbers, and hyphens
- Keep names short and descriptive
- Examples: `webapp`, `api-gateway`, `monitoring-stack`

### Directory Structure

```
+custom/myapp/
├── compose.yaml          # Main compose file
├── .env                  # Configuration
├── .env.generated        # Auto-generated (gitignored)
├── .gitignore            # Git ignore rules
├── config/               # Configuration files
│   └── app.conf
├── scripts/              # Helper scripts
│   └── init.sh
└── data/                 # Local data (gitignored)
```

### Configuration Management

1. **Public Config** → `.env` file
2. **Secrets** → Root `secrets.env`
3. **Domain/Subdomain** → Root `domain.env`
4. **Stack-Specific** → `compose.yaml` environment section

### Version Control

Generated `.gitignore` includes:
```
.env.generated
*.log
*.pid
```

Add to your `.gitignore` if needed:
```
data/
*.backup
config/*.local
```

### Health Checks

Customize health checks based on your application:

```yaml
# HTTP endpoint
healthcheck:
  test: ["CMD-SHELL", "wget --spider -q http://localhost:80/health || exit 1"]

# TCP port
healthcheck:
  test: ["CMD-SHELL", "nc -z localhost 80 || exit 1"]

# Command execution
healthcheck:
  test: ["CMD", "myapp", "healthcheck"]

# Multiple checks
healthcheck:
  test: ["CMD-SHELL", "curl -f http://localhost:80/health && redis-cli ping"]
```

### Resource Limits

Add resource constraints in `compose.yaml`:

```yaml
services:
  myapp:
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 2G
        reservations:
          cpus: '1'
          memory: 1G
```

## Examples

### Simple Web Application

```bash
# Generate stack
./kompose.sh generate webapp

# Configure
cat > +custom/webapp/.env << EOF
COMPOSE_PROJECT_NAME=webapp
DOCKER_IMAGE=nginx:alpine
APP_PORT=80
TRAEFIK_HOST=\${TRAEFIK_HOST_WEBAPP}
EOF

# Start
./kompose.sh up webapp
```

### API Service with Database

```bash
# Generate stack
./kompose.sh generate api-service

# Edit compose.yaml to add database connection
vim +custom/api-service/compose.yaml

# Create database
./kompose.sh db exec -d postgres "CREATE DATABASE api_service;"

# Start
./kompose.sh up api-service
```

### Monitoring Stack

```bash
# Generate stack
./kompose.sh generate monitoring

# Add multiple services to compose.yaml
vim +custom/monitoring/compose.yaml

# Configure
vim +custom/monitoring/.env

# Start
./kompose.sh up monitoring
```

## Troubleshooting

### Stack Won't Generate

**Issue:** Permission denied or directory not writable

**Solution:**
```bash
# Check permissions
ls -la +custom/

# Fix permissions
chmod -R 755 +custom/
```

### Compose Validation Fails

**Issue:** Invalid compose.yaml syntax

**Solution:**
```bash
# Validate compose file
cd +custom/myapp
docker compose config

# Check for syntax errors
yamllint compose.yaml
```

### Traefik Not Routing

**Issue:** Service not accessible via domain

**Solution:**
```bash
# Check Traefik labels
docker inspect myapp_app | grep traefik

# Verify Traefik is running
./kompose.sh status proxy

# Check domain configuration
echo $TRAEFIK_HOST_MYAPP
```

### Stack Name Already Exists

**Issue:** `Stack already exists` error

**Solution:**
```bash
# List existing stacks
./kompose.sh generate list

# Use different name or delete existing
./kompose.sh generate delete oldstack
./kompose.sh generate newstack
```

## Advanced Usage

### Custom Templates

Create your own templates by modifying `kompose-generate.sh`:

```bash
# Edit generator module
vim kompose-generate.sh

# Modify template functions:
# - generate_compose_template()
# - generate_env_template()
# - generate_readme_template()
```

### Batch Generation

Generate multiple stacks:

```bash
#!/bin/bash
for service in api web worker; do
    ./kompose.sh generate "${service}-service"
done
```

### Template Inheritance

Start from existing custom stack:

```bash
# Copy existing stack
cp -r +custom/webapp +custom/newapp

# Update configuration
sed -i 's/webapp/newapp/g' +custom/newapp/.env
sed -i 's/webapp/newapp/g' +custom/newapp/compose.yaml
```

## See Also

- [Stack Configuration Overview](/reference/stack-configuration)
- [Custom Stacks Guide](/guide/custom-stacks)
- [Environment Management](/guide/environment)
- [Traefik Configuration](/reference/traefik)
- [Testing Guide](/guide/testing)

---

**Generator Script:** `kompose-generate.sh`  
**Custom Stacks Location:** `+custom/<name>/`  
**Documentation:** `_docs/content/5.stacks/+custom/`  
**Tests:** `__tests/generated/`
