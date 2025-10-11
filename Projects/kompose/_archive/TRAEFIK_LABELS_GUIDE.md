# Traefik Labels - Best Practices & Standards

## Overview

All Kompose stacks use standardized Traefik labels for consistent routing, SSL, and middleware configuration.

## Standard Label Set

Every stack should include these labels:

```yaml
labels:
  # Enable Traefik
  - 'traefik.enable=${TRAEFIK_ENABLED:-true}'
  
  # HTTP to HTTPS redirect
  - 'traefik.http.middlewares.${COMPOSE_PROJECT_NAME}-redirect-web-secure.redirectscheme.scheme=https'
  - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web.middlewares=${COMPOSE_PROJECT_NAME}-redirect-web-secure'
  - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web.rule=Host(`${TRAEFIK_HOST}`)'
  - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web.entrypoints=web'
  
  # HTTPS configuration
  - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.rule=Host(`${TRAEFIK_HOST}`)'
  - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.tls=true'
  - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.tls.certresolver=resolver'
  - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.entrypoints=web-secure'
  
  # Compression
  - 'traefik.http.middlewares.${COMPOSE_PROJECT_NAME}-compress.compress=true'
  - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.middlewares=${COMPOSE_PROJECT_NAME}-compress'
  
  # Service port
  - 'traefik.http.services.${COMPOSE_PROJECT_NAME}-web-secure.loadbalancer.server.port=${APP_PORT}'
  
  # Network
  - 'traefik.docker.network=${NETWORK_NAME:-kompose}'
```

## Label Breakdown

### 1. Enable Traefik

```yaml
- 'traefik.enable=${TRAEFIK_ENABLED:-true}'
```

**Purpose**: Enable Traefik routing for this container  
**Variable**: `TRAEFIK_ENABLED` from stack .env (defaults to true)  
**When to disable**: Set `TRAEFIK_ENABLED=false` in stack .env for internal-only services

### 2. HTTP Router (Port 80)

```yaml
- 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web.rule=Host(`${TRAEFIK_HOST}`)'
- 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web.entrypoints=web'
```

**Purpose**: Route HTTP traffic (port 80)  
**Naming**: `${COMPOSE_PROJECT_NAME}-web` ensures unique router name  
**Entrypoint**: `web` = port 80

### 3. HTTP to HTTPS Redirect

```yaml
- 'traefik.http.middlewares.${COMPOSE_PROJECT_NAME}-redirect-web-secure.redirectscheme.scheme=https'
- 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web.middlewares=${COMPOSE_PROJECT_NAME}-redirect-web-secure'
```

**Purpose**: Automatically redirect HTTP to HTTPS  
**Middleware**: Creates a redirect middleware  
**Applied to**: HTTP router only

### 4. HTTPS Router (Port 443)

```yaml
- 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.rule=Host(`${TRAEFIK_HOST}`)'
- 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.entrypoints=web-secure'
```

**Purpose**: Route HTTPS traffic (port 443)  
**Naming**: `${COMPOSE_PROJECT_NAME}-web-secure` for HTTPS router  
**Entrypoint**: `web-secure` = port 443

### 5. TLS/SSL Configuration

```yaml
- 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.tls=true'
- 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.tls.certresolver=resolver'
```

**Purpose**: Enable TLS and automatic certificate generation  
**Certificate resolver**: `resolver` is configured in Traefik for Let's Encrypt  
**Automatic**: Certificates are automatically obtained and renewed

### 6. Compression Middleware

```yaml
- 'traefik.http.middlewares.${COMPOSE_PROJECT_NAME}-compress.compress=true'
- 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.middlewares=${COMPOSE_PROJECT_NAME}-compress'
```

**Purpose**: Enable gzip compression for faster response times  
**Applied to**: HTTPS router only  
**Benefit**: Reduces bandwidth usage

### 7. Service Port

```yaml
- 'traefik.http.services.${COMPOSE_PROJECT_NAME}-web-secure.loadbalancer.server.port=${APP_PORT}'
```

**Purpose**: Tell Traefik which internal container port to forward to  
**Variable**: `${APP_PORT}` from stack .env  
**Important**: This is the container's internal port, not the host port

### 8. Network Specification

```yaml
- 'traefik.docker.network=${NETWORK_NAME:-kompose}'
```

**Purpose**: Specify which Docker network Traefik should use  
**Network**: `kompose` (the shared network for all stacks)  
**Required**: When container is on multiple networks

## Optional Middleware

### SSO Authentication

```yaml
- 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.middlewares=${COMPOSE_PROJECT_NAME}-compress,kompose-sso'
```

**Purpose**: Require authentication via OAuth2 Proxy  
**Middleware**: `kompose-sso` is defined in auth stack  
**Use case**: Protect admin interfaces, private applications  
**Note**: Requires auth stack to be running

### Rate Limiting

```yaml
- 'traefik.http.middlewares.${COMPOSE_PROJECT_NAME}-ratelimit.ratelimit.average=100'
- 'traefik.http.middlewares.${COMPOSE_PROJECT_NAME}-ratelimit.ratelimit.burst=50'
- 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.middlewares=${COMPOSE_PROJECT_NAME}-compress,${COMPOSE_PROJECT_NAME}-ratelimit'
```

**Purpose**: Limit requests per second  
**Average**: Sustained rate (requests/second)  
**Burst**: Maximum temporary spike  
**Use case**: Protect against abuse, DDoS

### IP Whitelist

```yaml
- 'traefik.http.middlewares.${COMPOSE_PROJECT_NAME}-ipwhitelist.ipwhitelist.sourcerange=192.168.0.0/16,10.0.0.0/8'
- 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.middlewares=${COMPOSE_PROJECT_NAME}-compress,${COMPOSE_PROJECT_NAME}-ipwhitelist'
```

**Purpose**: Restrict access to specific IP ranges  
**Source range**: Comma-separated CIDR blocks  
**Use case**: Internal-only services, admin panels  
**Common ranges**:
- `127.0.0.1/32` - Localhost only
- `192.168.0.0/16` - Private network
- `10.0.0.0/8` - Private network
- `172.16.0.0/12` - Private network

### Basic Auth

```yaml
- 'traefik.http.middlewares.${COMPOSE_PROJECT_NAME}-auth.basicauth.users=${BASIC_AUTH_USERS}'
- 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.middlewares=${COMPOSE_PROJECT_NAME}-compress,${COMPOSE_PROJECT_NAME}-auth'
```

**Purpose**: Simple username/password authentication  
**Users**: htpasswd format (generate with `htpasswd -nb user password`)  
**Use case**: Quick protection without SSO  
**Note**: Less secure than SSO, use for non-critical services

### Headers Security

```yaml
- 'traefik.http.middlewares.${COMPOSE_PROJECT_NAME}-headers.headers.browserXssFilter=true'
- 'traefik.http.middlewares.${COMPOSE_PROJECT_NAME}-headers.headers.contentTypeNosniff=true'
- 'traefik.http.middlewares.${COMPOSE_PROJECT_NAME}-headers.headers.frameDeny=true'
- 'traefik.http.middlewares.${COMPOSE_PROJECT_NAME}-headers.headers.sslRedirect=true'
- 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.middlewares=${COMPOSE_PROJECT_NAME}-compress,${COMPOSE_PROJECT_NAME}-headers'
```

**Purpose**: Add security headers  
**Headers**:
- XSS filter
- Content type sniffing protection
- Clickjacking protection
- SSL redirect
**Use case**: Enhanced security for public services

## Middleware Chaining

Multiple middleware can be chained together:

```yaml
# Example: Compression + SSO + Rate Limit
- 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.middlewares=${COMPOSE_PROJECT_NAME}-compress,kompose-sso,${COMPOSE_PROJECT_NAME}-ratelimit'
```

**Order matters**: Middleware are applied left to right

**Common chains:**
1. `compress` - Always first (reduces bandwidth)
2. `ratelimit` - Before authentication
3. `sso` or `auth` - Authentication
4. `ipwhitelist` - After authentication
5. `headers` - Security headers

## Path-Based Routing

For services with multiple paths:

```yaml
# Main app
- 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-app.rule=Host(`${TRAEFIK_HOST}`) && PathPrefix(`/app`)'
- 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-app.entrypoints=web-secure'
- 'traefik.http.services.${COMPOSE_PROJECT_NAME}-app.loadbalancer.server.port=8080'

# API
- 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-api.rule=Host(`${TRAEFIK_HOST}`) && PathPrefix(`/api`)'
- 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-api.entrypoints=web-secure'
- 'traefik.http.services.${COMPOSE_PROJECT_NAME}-api.loadbalancer.server.port=8081'
```

## Multiple Domains

Serve same service on multiple domains:

```yaml
- 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.rule=Host(`${TRAEFIK_HOST}`) || Host(`${TRAEFIK_HOST_ALT}`)'
```

## WebSocket Support

For services using WebSockets:

```yaml
# Standard labels, plus:
- 'traefik.http.services.${COMPOSE_PROJECT_NAME}-web-secure.loadbalancer.server.port=${APP_PORT}'
# Traefik automatically handles WebSocket upgrades
```

**No special configuration needed** - Traefik handles WS automatically

## Debugging Labels

### View Applied Labels

```bash
# For a specific container
docker inspect <container_name> | grep -A 50 Labels

# Or with docker-compose
cd <stack-directory>
docker-compose config
```

### Test Routing

```bash
# Check if service is registered
curl http://localhost:8080/api/http/routers

# Check SSL certificate
curl -I https://myservice.pivoine.art

# View Traefik dashboard
open http://localhost:8080/dashboard/
```

## Common Issues

### Issue: 404 Not Found

**Cause**: Router rule doesn't match  
**Fix**: Check `Host()` matches `${TRAEFIK_HOST}`

```bash
# Verify TRAEFIK_HOST
cd stack-directory
docker-compose config | grep TRAEFIK_HOST
```

### Issue: 502 Bad Gateway

**Cause**: Wrong service port  
**Fix**: Verify `APP_PORT` matches container's internal port

```bash
# Check what port service is listening on
docker exec <container> netstat -tlnp
```

### Issue: SSL Certificate Not Issued

**Cause**: Domain not accessible or rate limit  
**Fix**: 
1. Verify domain is publicly accessible
2. Check Traefik logs for ACME errors
3. Use staging certificates for testing

```bash
./kompose.sh logs proxy | grep -i acme
```

### Issue: Middleware Not Applied

**Cause**: Typo in middleware name or incorrect reference  
**Fix**: Check middleware is defined and referenced correctly

```bash
# View Traefik configuration
curl http://localhost:8080/api/http/middlewares
```

## Best Practices

1. **Use variables**: Always use `${COMPOSE_PROJECT_NAME}`, `${TRAEFIK_HOST}`, etc.
2. **Unique names**: Router/middleware names must be unique across all stacks
3. **Compression**: Always enable compression for HTTPS
4. **Security**: Use SSO or IP whitelist for admin interfaces
5. **Rate limiting**: Consider for public APIs
6. **Test**: Validate with `docker-compose config` before deploying
7. **Monitor**: Check Traefik dashboard for issues
8. **Document**: Comment special middleware configurations

## Reference

- [Traefik Docker Provider](https://doc.traefik.io/traefik/providers/docker/)
- [Traefik Routers](https://doc.traefik.io/traefik/routing/routers/)
- [Traefik Middleware](https://doc.traefik.io/traefik/middlewares/overview/)
- [Traefik TLS](https://doc.traefik.io/traefik/https/acme/)
