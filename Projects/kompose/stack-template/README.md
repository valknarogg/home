# Stack Template - Creating New Services

This template provides a standardized structure for creating new services in Kompose.

## Quick Start

### 1. Copy Template

```bash
# Copy this template to create a new stack
cp -r stack-template my-new-service
cd my-new-service
```

### 2. Configure Domain

Edit `domain.env` (in root directory) to add your service:

```bash
# Add to domain.env
SUBDOMAIN_MYNEWSERVICE=myservice
```

Edit `.env` (in root directory) to add the hostname:

```bash
# Add to root .env
TRAEFIK_HOST_MYNEWSERVICE=${SUBDOMAIN_MYNEWSERVICE}.${ROOT_DOMAIN}
```

### 3. Update Stack Configuration

Edit `compose.yaml`:
- Change `name: mystack` to your stack name
- Update `image: ${DOCKER_IMAGE}` with your Docker image
- Modify environment variables as needed
- Update health check command
- Adjust volumes if needed

Edit `.env`:
- Change `COMPOSE_PROJECT_NAME=mystack` to your stack name
- Update `DOCKER_IMAGE` with your image name
- Set `APP_PORT` to your service's internal port
- Update `TRAEFIK_HOST` reference
- Add service-specific variables

### 4. Add Secrets (if needed)

Edit root `secrets.env`:

```bash
# Add secrets for your stack
MYSTACK_SECRET_KEY=generate_with_openssl_rand_hex_32
MYSTACK_API_TOKEN=generate_with_openssl_rand_base64_32
```

### 5. Start Your Service

```bash
# Validate configuration
./kompose.sh validate my-new-service

# Start the service
./kompose.sh up my-new-service

# Check status
./kompose.sh status my-new-service

# View logs
./kompose.sh logs my-new-service -f
```

## Configuration Options

### Basic Traefik Labels (Included)

The template includes standard Traefik labels for:
- ✅ HTTP to HTTPS redirect
- ✅ SSL/TLS with Let's Encrypt
- ✅ Compression
- ✅ Automatic routing based on hostname

### Optional Features (Commented Out)

#### SSO Authentication

Uncomment this line in `compose.yaml`:

```yaml
- 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.middlewares=${COMPOSE_PROJECT_NAME}-compress,kompose-sso'
```

Requires Keycloak and OAuth2 Proxy to be running.

#### Rate Limiting

Uncomment these lines:

```yaml
- 'traefik.http.middlewares.${COMPOSE_PROJECT_NAME}-ratelimit.ratelimit.average=100'
- 'traefik.http.middlewares.${COMPOSE_PROJECT_NAME}-ratelimit.ratelimit.burst=50'
```

Adjust values as needed for your service.

#### IP Whitelist (Internal Access Only)

Uncomment this line:

```yaml
- 'traefik.http.middlewares.${COMPOSE_PROJECT_NAME}-ipwhitelist.ipwhitelist.sourcerange=127.0.0.1/32,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16'
```

Restricts access to private IP ranges only.

## Common Integration Patterns

### Database Integration

If your service needs a database:

```yaml
environment:
  DB_TYPE: postgres
  DB_HOST: core-postgres
  DB_PORT: 5432
  DB_NAME: mystack
  DB_USER: ${DB_USER}
  DB_PASSWORD: ${DB_PASSWORD}
```

Create database:

```bash
./kompose.sh db exec -d postgres "CREATE DATABASE mystack;"
```

### Email Integration

If your service needs to send emails:

```yaml
environment:
  SMTP_HOST: ${EMAIL_SMTP_HOST}
  SMTP_PORT: ${EMAIL_SMTP_PORT}
  SMTP_USER: ${EMAIL_SMTP_USER}
  SMTP_PASSWORD: ${EMAIL_SMTP_PASSWORD}
  EMAIL_FROM: ${EMAIL_FROM}
```

### MQTT Integration

For IoT or event-driven services:

```yaml
environment:
  MQTT_BROKER: core-mqtt
  MQTT_PORT: 1883
  MQTT_TOPIC_PREFIX: kompose/mystack
```

### Redis Integration

For caching or sessions:

```yaml
environment:
  REDIS_HOST: core-redis
  REDIS_PORT: 6379
  REDIS_PASSWORD: ${REDIS_PASSWORD}
```

## Service Categories

Place your new stack in the appropriate directory:

### Core Stacks
`/core`, `/proxy`, `/auth`, etc.
- Essential infrastructure services
- Required for system operation

### Main Stacks
Root directory: `/chain`, `/code`, `/home`, etc.
- Primary application services
- Commonly used features

### Utility Stacks
`/+utility/`
- Optional utility services
- Enhancements and tools
- Examples: vault, link shortener, analytics

### Custom Stacks
`/+custom/`
- Your custom applications
- User-specific services
- Experimental features

## Example: Creating a Wiki Service

```bash
# 1. Copy template
cp -r stack-template wiki

# 2. Update domain.env (in root)
echo "SUBDOMAIN_WIKI=wiki" >> domain.env

# 3. Update root .env
echo "TRAEFIK_HOST_WIKI=\${SUBDOMAIN_WIKI}.\${ROOT_DOMAIN}" >> .env

# 4. Configure wiki/compose.yaml
cd wiki
# Edit compose.yaml:
# - name: wiki
# - image: ${DOCKER_IMAGE:-ghcr.io/requarks/wiki:2}

# 5. Configure wiki/.env
cat > .env << 'EOF'
COMPOSE_PROJECT_NAME=wiki
DOCKER_IMAGE=ghcr.io/requarks/wiki:2
APP_PORT=3000
TRAEFIK_HOST=${TRAEFIK_HOST_WIKI}

# Wiki.js configuration
DB_TYPE=postgres
DB_HOST=core-postgres
DB_PORT=5432
DB_USER=${DB_USER}
DB_PASS=${DB_PASSWORD}
DB_NAME=wiki
EOF

# 6. Start service
cd ..
./kompose.sh up wiki
```

## Validation Checklist

Before starting your new service:

- [ ] Template copied to new directory
- [ ] `domain.env` updated with subdomain
- [ ] Root `.env` updated with TRAEFIK_HOST
- [ ] `compose.yaml` updated with correct image and config
- [ ] Stack `.env` updated with service settings
- [ ] Secrets added to root `secrets.env` if needed
- [ ] Database created if needed
- [ ] Compose file validates: `./kompose.sh validate mystack`
- [ ] DNS configured (if using real domain)

## Troubleshooting

### Service won't start

```bash
# Check configuration
./kompose.sh validate mystack

# Check logs
./kompose.sh logs mystack

# Check if port is already in use
docker ps | grep ${APP_PORT}
```

### Domain not accessible

```bash
# Check DNS
dig myservice.pivoine.art

# Check Traefik routing
./kompose.sh logs proxy | grep myservice

# Verify TRAEFIK_HOST is set correctly
cd mystack && docker-compose config | grep TRAEFIK_HOST
```

### SSL certificate not issued

```bash
# Check Traefik ACME logs
./kompose.sh logs proxy | grep -i acme

# Verify domain is publicly accessible
curl -v http://myservice.pivoine.art
```

## Best Practices

1. **Use environment variables** for all configuration
2. **Store secrets** in root `secrets.env`, never in stack files
3. **Use health checks** for all services
4. **Document** your configuration in comments
5. **Test locally** before deploying to production
6. **Use consistent naming** (lowercase, hyphens for multi-word)
7. **Add README.md** to your stack directory
8. **Version control** your configuration (except secrets.env)

## Additional Resources

- [Kompose Documentation](../README.md)
- [Domain Configuration Guide](../DOMAIN_CONFIGURATION.md)
- [Traefik Documentation](https://doc.traefik.io/traefik/)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)
