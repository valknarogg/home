# Auth Stack Template

This template provides a complete, production-ready authentication and Single Sign-On (SSO) solution using Keycloak and OAuth2 Proxy.

## Overview

The Auth stack consists of:
- **Keycloak**: Enterprise identity and access management
- **OAuth2 Proxy**: Forward authentication middleware for SSO

## Quick Start

Generate this stack using kompose-generate.sh:

```bash
./kompose-generate.sh auth
```

This will:
1. Create the auth stack directory if it doesn't exist
2. Copy all template files
3. Generate environment variables from kompose.yml
4. Generate secrets
5. Prepare the stack for deployment

## Files in this Template

- `kompose.yml` - Complete stack configuration with all variables and secrets defined
- `compose.yaml` - Docker Compose configuration
- `.env.example` - Example environment file (will be generated from kompose.yml)
- `oauth2-proxy.yaml` - Legacy reference file (OAuth2 is now integrated in compose.yaml)
- `README.md` - This file

## Requirements

Before deploying this stack, ensure these stacks are running:
- **core** - Provides PostgreSQL and Redis
- **proxy** - Provides Traefik for routing

## Configuration

All configuration is defined in `kompose.yml`. Key settings:

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| AUTH_COMPOSE_PROJECT_NAME | auth | Stack project name |
| AUTH_DOCKER_IMAGE | quay.io/keycloak/keycloak:latest | Keycloak image |
| AUTH_DB_NAME | keycloak | Database name |
| AUTH_OAUTH2_CLIENT_ID | kompose-sso | OAuth2 client ID |
| SUBDOMAIN_AUTH | auth | Keycloak subdomain |
| SUBDOMAIN_OAUTH2 | sso | OAuth2 Proxy subdomain |

### Secrets

| Secret | Description | Generation |
|--------|-------------|------------|
| DB_PASSWORD | Database password (shared) | Auto-generated |
| AUTH_KEYCLOAK_ADMIN_PASSWORD | Keycloak admin password | Auto-generated |
| AUTH_OAUTH2_CLIENT_SECRET | OAuth2 client secret | Manual (from Keycloak UI) |
| AUTH_OAUTH2_COOKIE_SECRET | Session cookie encryption | `openssl rand -base64 32` |

## Deployment Steps

### 1. Generate the Stack

```bash
./kompose-generate.sh auth
```

### 2. Review Configuration

Edit the generated files in the `auth/` directory:
- `.env` - Environment variables
- Add your domain configuration

### 3. Start Dependencies

```bash
docker compose -f core/compose.yaml up -d
docker compose -f proxy/compose.yaml up -d
```

### 4. Start Auth Stack

```bash
docker compose -f auth/compose.yaml up -d
```

### 5. Configure Keycloak

Access the Keycloak admin console:
- URL: https://auth.yourdomain.com
- Username: admin
- Password: [from AUTH_KEYCLOAK_ADMIN_PASSWORD in secrets.env]

Create the SSO client:
1. Create new realm: `kompose`
2. Go to Clients → Create Client
3. Client ID: `kompose-sso`
4. Client Type: OpenID Connect
5. Next → Save
6. Settings:
   - Access Type: Confidential
   - Valid Redirect URIs: `https://sso.yourdomain.com/oauth2/callback`
   - Web Origins: `*`
7. Save
8. Go to Credentials tab
9. Copy the Client Secret
10. Add it to `secrets.env` as `AUTH_OAUTH2_CLIENT_SECRET`

### 6. Restart OAuth2 Proxy

After setting the client secret:

```bash
docker compose -f auth/compose.yaml restart oauth2-proxy
```

## Using SSO in Other Services

To protect any service with SSO, add this label to the service in its compose.yaml:

```yaml
services:
  myservice:
    # ... other configuration ...
    labels:
      - 'traefik.http.routers.myservice-web-secure.middlewares=kompose-sso'
```

The `kompose-sso` middleware is automatically created by the OAuth2 Proxy service.

## Access URLs

- Keycloak Admin: `https://auth.yourdomain.com`
- OAuth2 Proxy: `https://sso.yourdomain.com`
- OAuth2 Login: `https://sso.yourdomain.com/oauth2/start`

## Health Checks

Check service health:

```bash
# Keycloak
curl http://localhost:8080/health

# OAuth2 Proxy
curl http://localhost:4180/ping
```

## Troubleshooting

### Keycloak Won't Start

**Symptoms**: Container exits or restarts repeatedly

**Solutions**:
1. Verify database connection:
   ```bash
   docker compose -f core/compose.yaml ps
   ```
2. Check database password in secrets.env
3. View logs:
   ```bash
   docker logs auth_keycloak
   ```

### OAuth2 Authentication Fails

**Symptoms**: Redirect loops, 401/403 errors

**Solutions**:
1. Verify AUTH_OAUTH2_CLIENT_SECRET matches Keycloak
2. Check redirect URLs in Keycloak client config
3. Ensure Redis is running:
   ```bash
   docker compose -f core/compose.yaml ps redis
   ```
4. Check OAuth2 Proxy logs:
   ```bash
   docker logs auth_oauth2_proxy
   ```

### SSL/TLS Issues

**Symptoms**: Certificate errors, redirect to HTTP

**Solutions**:
1. Verify PROTOCOL=https in .env
2. Check Traefik certificates:
   ```bash
   docker logs proxy_traefik
   ```
3. Ensure domain DNS is correct
4. Verify KC_HOSTNAME matches actual domain

### Session Issues

**Symptoms**: Frequent logouts, session not persisting

**Solutions**:
1. Check Redis connection
2. Verify AUTH_OAUTH2_COOKIE_SECRET is set
3. Ensure cookies are not blocked by browser
4. Check session timeouts in OAuth2 Proxy config

## Security Best Practices

1. **Use HTTPS in Production**
   - Set `PROTOCOL=https` in .env
   - Ensure valid SSL certificates

2. **Secure Secrets**
   - Never commit secrets.env to git
   - Use strong, unique passwords
   - Rotate secrets regularly

3. **Configure Session Timeouts**
   - Default: 7 days (168h)
   - Adjust in compose.yaml: `OAUTH2_PROXY_COOKIE_EXPIRE`

4. **Enable MFA**
   - Configure in Keycloak for admin accounts
   - Enforce for sensitive services

5. **Review Permissions**
   - Use realm roles for access control
   - Create groups for team management
   - Audit client permissions regularly

## Advanced Configuration

### Custom Realms

To use a custom realm instead of 'kompose':

1. Edit `OAUTH2_PROXY_OIDC_ISSUER_URL` in compose.yaml
2. Update to: `https://auth.yourdomain.com/realms/YOUR_REALM`
3. Restart services

### Email Configuration

To enable Keycloak email notifications:

1. In Keycloak Admin → Realm Settings → Email
2. Configure SMTP settings
3. Use values from global EMAIL_* variables

### LDAP/AD Integration

1. Keycloak Admin → User Federation
2. Add LDAP provider
3. Configure connection settings
4. Map attributes

### Custom Themes

1. Create theme directory
2. Mount as volume in compose.yaml:
   ```yaml
   volumes:
     - ./themes:/opt/keycloak/themes:ro
   ```
3. Select theme in Keycloak Admin

## Monitoring

### Metrics

Keycloak exposes Prometheus metrics:
- Endpoint: `/metrics`
- Configure in watch stack

OAuth2 Proxy logs all authentication events:
- View with: `docker logs -f auth_oauth2_proxy`

### Health Checks

Both services have built-in health checks:
- Keycloak: http://localhost:8080/health
- OAuth2 Proxy: http://localhost:4180/ping

## Backup and Recovery

### Backup

Export Keycloak configuration:

```bash
docker exec auth_keycloak \
  /opt/keycloak/bin/kc.sh export \
  --file /tmp/keycloak-export.json \
  --realm kompose

docker cp auth_keycloak:/tmp/keycloak-export.json \
  ./backups/keycloak-$(date +%Y%m%d).json
```

### Restore

Import configuration:

```bash
docker cp ./backups/keycloak-YYYYMMDD.json \
  auth_keycloak:/tmp/import.json

docker exec auth_keycloak \
  /opt/keycloak/bin/kc.sh import \
  --file /tmp/import.json
```

## Related Documentation

- [Keycloak Documentation](https://www.keycloak.org/documentation)
- [OAuth2 Proxy Documentation](https://oauth2-proxy.github.io/oauth2-proxy/)
- [Traefik Forward Auth](https://doc.traefik.io/traefik/middlewares/http/forwardauth/)

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Review logs: `docker logs auth_keycloak` or `docker logs auth_oauth2_proxy`
3. Consult the official documentation
4. Check kompose repository issues

## Template Version

- Version: 1.0.0
- Last Updated: 2025-10-14
- Compatible with: Kompose 1.x
