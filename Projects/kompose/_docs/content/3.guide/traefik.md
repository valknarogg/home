---
title: Traefik Configuration
description: Configure reverse proxy and routing with Traefik labels
---

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

### Enable Traefik

```yaml
- 'traefik.enable=${TRAEFIK_ENABLED:-true}'
```

Enable Traefik routing for this container. Set `TRAEFIK_ENABLED=false` in stack .env for internal-only services.

### HTTP Router (Port 80)

```yaml
- 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web.rule=Host(`${TRAEFIK_HOST}`)'
- 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web.entrypoints=web'
```

Routes HTTP traffic (port 80) to the service.

### HTTP to HTTPS Redirect

```yaml
- 'traefik.http.middlewares.${COMPOSE_PROJECT_NAME}-redirect-web-secure.redirectscheme.scheme=https'
- 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web.middlewares=${COMPOSE_PROJECT_NAME}-redirect-web-secure'
```

Automatically redirects HTTP requests to HTTPS.

### HTTPS Router (Port 443)

```yaml
- 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.rule=Host(`${TRAEFIK_HOST}`)'
- 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.entrypoints=web-secure'
```

Routes HTTPS traffic (port 443) to the service.

### TLS/SSL Configuration

```yaml
- 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.tls=true'
- 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.tls.certresolver=resolver'
```

Enables TLS and automatic Let's Encrypt certificate generation.

### Compression Middleware

```yaml
- 'traefik.http.middlewares.${COMPOSE_PROJECT_NAME}-compress.compress=true'
- 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.middlewares=${COMPOSE_PROJECT_NAME}-compress'
```

Enables gzip compression for faster response times.

### Service Port

```yaml
- 'traefik.http.services.${COMPOSE_PROJECT_NAME}-web-secure.loadbalancer.server.port=${APP_PORT}'
```

Specifies which internal container port Traefik should forward to.

### Network Specification

```yaml
- 'traefik.docker.network=${NETWORK_NAME:-kompose}'
```

Specifies which Docker network Traefik should use (required when container is on multiple networks).

## Optional Middleware

### SSO Authentication

```yaml
- 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.middlewares=${COMPOSE_PROJECT_NAME}-compress,kompose-sso'
```

Requires authentication via OAuth2 Proxy. Protects admin interfaces and private applications.

### Rate Limiting

```yaml
- 'traefik.http.middlewares.${COMPOSE_PROJECT_NAME}-ratelimit.ratelimit.average=100'
- 'traefik.http.middlewares.${COMPOSE_PROJECT_NAME}-ratelimit.ratelimit.burst=50'
- 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.middlewares=${COMPOSE_PROJECT_NAME}-compress,${COMPOSE_PROJECT_NAME}-ratelimit'
```

Limits requests to protect against abuse and DDoS attacks.

### IP Whitelist

```yaml
- 'traefik.http.middlewares.${COMPOSE_PROJECT_NAME}-ipwhitelist.ipwhitelist.sourcerange=192.168.0.0/16,10.0.0.0/8'
- 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.middlewares=${COMPOSE_PROJECT_NAME}-compress,${COMPOSE_PROJECT_NAME}-ipwhitelist'
```

Restricts access to specific IP ranges for internal-only services.

### Basic Auth

```yaml
- 'traefik.http.middlewares.${COMPOSE_PROJECT_NAME}-auth.basicauth.users=${BASIC_AUTH_USERS}'
- 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.middlewares=${COMPOSE_PROJECT_NAME}-compress,${COMPOSE_PROJECT_NAME}-auth'
```

Simple username/password authentication (generate with `htpasswd -nb user password`).

## Middleware Chaining

Multiple middleware can be chained together:

```yaml
# Example: Compression + SSO + Rate Limit
- 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.middlewares=${COMPOSE_PROJECT_NAME}-compress,kompose-sso,${COMPOSE_PROJECT_NAME}-ratelimit'
```

**Order matters**: Middleware are applied left to right.

**Recommended chain order:**
1. `compress` - Reduces bandwidth
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
