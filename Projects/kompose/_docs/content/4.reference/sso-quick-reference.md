# SSO Quick Reference

Quick reference for Single Sign-On integration.

## Middleware Options

```yaml
# Basic SSO
middlewares=sso-secure

# SSO + Rate Limiting
middlewares=sso-secure-limited

# SSO + IP Restriction
middlewares=sso-internal-only
```

## Protect a Service

Edit service `compose.yaml`:

```yaml
labels:
  - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.middlewares=sso-secure'
```

Restart:
```bash
./kompose.sh restart [stack]
```

## Keycloak Access

**URL:** `https://auth.yourdomain.com`  
**Admin User:** `admin`  
**Password:** Check `secrets.env` → `KC_ADMIN_PASSWORD`

## Create User

1. **Keycloak Admin → Users → Create user**
2. Fill in details
3. Save
4. **Credentials tab** → Set password

## Create Client

1. **Clients → Create Client**
2. Client ID: `service-name`
3. Client authentication: **ON**
4. Valid redirect URIs: `https://service.yourdomain.com/*`
5. Save
6. Copy **Client Secret**

## User Headers

Access user info in your application via headers:

```javascript
req.headers['x-auth-request-user']      // Username
req.headers['x-auth-request-email']     // Email
req.headers['x-auth-request-groups']    // Groups (comma-separated)
```

## Skip Auth for Specific Paths

Edit `auth/compose.yaml`:

```yaml
environment:
  OAUTH2_PROXY_SKIP_AUTH_ROUTES: "^/api/webhook,^/health"
```

## Troubleshooting

```bash
# Check auth stack
./kompose.sh status auth

# View Keycloak logs
docker logs auth_keycloak

# View OAuth2 Proxy logs
docker logs auth_oauth2-proxy

# Test OAuth2 endpoints
curl https://sso.yourdomain.com/ping
```

## See Also

- [SSO Integration Guide](/guide/sso-integration)
- [KMPS Portal](/stacks/kmps)
