# Kompose SSO Quick Reference

## 🚀 Quick Commands

```bash
# Start auth stack (Keycloak + OAuth2 Proxy)
./kompose.sh up auth

# Start management portal
./kompose.sh up kmps

# Check auth stack status
./kompose.sh status auth

# View OAuth2 Proxy logs
./kompose.sh logs auth -f | grep oauth2

# Restart auth services
./kompose.sh restart auth

# Backup Keycloak database
./kompose.sh db backup -d keycloak
```

## 🔑 Default URLs

| Service | URL | Purpose |
|---------|-----|---------|
| Keycloak Admin | `https://auth.yourdomain.com` | Identity provider admin console |
| OAuth2 Proxy | `https://sso.yourdomain.com` | SSO authentication endpoint |
| KMPS Portal | `https://manage.yourdomain.com` | User & client management |

## 📝 Adding SSO to a Stack

### Quick Method (Single Line)

Add this label to your service's `labels:` section:

```yaml
- 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.middlewares=sso-secure'
```

### Full Example

```yaml
services:
  myapp:
    # ... your configuration ...
    labels:
      - 'traefik.enable=true'
      - 'traefik.http.routers.myapp-web-secure.middlewares=sso-secure'  # ← ADD THIS
      - 'traefik.http.routers.myapp-web-secure.rule=Host(`app.yourdomain.com`)'
      - 'traefik.http.routers.myapp-web-secure.entrypoints=web-secure'
      - 'traefik.http.routers.myapp-web-secure.tls.certresolver=resolver'
      - 'traefik.http.services.myapp.loadbalancer.server.port=8080'
```

Then restart: `./kompose.sh restart myapp`

## 🎯 Middleware Options

| Middleware | Use Case | Features |
|------------|----------|----------|
| `sso-secure` | Standard SSO protection | SSO + security headers + compression |
| `sso-secure-limited` | Public SSO apps | SSO + rate limiting + security |
| `sso-internal-only` | Admin interfaces | SSO + IP whitelist + security |

## 👤 User Management

### Create User in Keycloak

1. Open `https://auth.yourdomain.com`
2. Login as admin
3. Select "kompose" realm
4. Users → Create user
5. Fill details & click Create
6. Set password in Credentials tab

### Via KMPS Portal

1. Open `https://manage.yourdomain.com`
2. Navigate to Users
3. Click "Add User"
4. Fill form & submit

## 🔧 Common Configurations

### Environment Variables (.env)

```bash
# In root .env
BASE_DOMAIN=yourdomain.com
TRAEFIK_HOST_AUTH=auth.yourdomain.com
TRAEFIK_HOST_OAUTH2=sso.yourdomain.com
TRAEFIK_HOST_KMPS=manage.yourdomain.com
```

### Secrets (secrets.env)

```bash
# Generate with: openssl rand -base64 32
AUTH_KC_ADMIN_PASSWORD=<keycloak-admin-password>
AUTH_OAUTH2_CLIENT_SECRET=<oauth2-client-secret>
AUTH_OAUTH2_COOKIE_SECRET=<32-byte-base64-string>
KMPS_CLIENT_SECRET=<kmps-client-secret>
KMPS_NEXTAUTH_SECRET=<32-byte-base64-string>
```

## 🔍 Troubleshooting

### Issue: "Cannot reach Keycloak"
```bash
# Check if auth stack is running
./kompose.sh status auth

# Restart auth stack
./kompose.sh restart auth

# Check logs
./kompose.sh logs auth
```

### Issue: "Authentication loop"
```bash
# Clear browser cookies for *.yourdomain.com
# Verify BASE_DOMAIN in .env
# Check OAuth2 Proxy logs
./kompose.sh logs auth | grep oauth2
```

### Issue: "Invalid redirect URI"
```bash
# 1. Check Keycloak client configuration
# 2. Ensure redirect URIs match:
#    https://sso.yourdomain.com/oauth2/callback
#    https://*.yourdomain.com/*
```

### Issue: "Session not persisting"
```bash
# Ensure Redis is running (core stack)
./kompose.sh up core

# Check Redis connection in OAuth2 Proxy
./kompose.sh logs auth | grep redis
```

## 📊 Testing SSO

```bash
# Test OAuth2 Proxy health
curl https://sso.yourdomain.com/ping

# Test auth endpoint (should return 401 if not logged in)
curl -I https://sso.yourdomain.com/oauth2/auth

# Check Keycloak realm config
curl https://auth.yourdomain.com/realms/kompose/.well-known/openid-configuration
```

## 🔐 Security Checklist

- [ ] Generated strong random secrets
- [ ] Updated all passwords in `secrets.env`
- [ ] Configured BASE_DOMAIN correctly
- [ ] Set up Keycloak realm "kompose"
- [ ] Created OAuth2 Proxy client in Keycloak
- [ ] Created KMPS admin client in Keycloak
- [ ] Assigned realm-admin role to KMPS client
- [ ] Created initial admin user
- [ ] Tested SSO login flow
- [ ] Backed up Keycloak database

## 🎓 Learning Resources

### Keycloak
- Realms: Isolated authentication spaces
- Clients: Applications that use Keycloak for auth
- Users: People who can authenticate
- Groups: Collections of users for access control
- Roles: Permissions assigned to users/groups

### OAuth2 Proxy
- Forward Auth: Validates requests before they reach apps
- OIDC: OpenID Connect protocol for authentication
- Cookie: Stores session information
- Redis: Session storage backend

### Traefik Middleware
- Forward Auth: Delegates authentication to external service
- Chains: Combine multiple middlewares
- Labels: Configure routing and middleware in docker-compose

## 📞 Quick Reference Commands

```bash
# Generate secrets
openssl rand -base64 32

# View all running containers
./kompose.sh ps

# Check specific stack logs
./kompose.sh logs auth -f --tail=50
./kompose.sh logs kmps -f --tail=50

# Database operations
./kompose.sh db backup -d keycloak
./kompose.sh db status

# Stack operations
./kompose.sh up auth
./kompose.sh up kmps
./kompose.sh restart auth
./kompose.sh down auth
```

## 🔗 Integration Examples

### Protect n8n
```yaml
# In chain/compose.yaml
environment:
  N8N_BASIC_AUTH_ACTIVE: false  # Disable basic auth
labels:
  - 'traefik.http.routers.chain-n8n-web-secure.middlewares=sso-secure'
```

### Protect Linkwarden
```yaml
# In +utilitiy/link/compose.yaml
labels:
  - 'traefik.http.routers.link-web-secure.middlewares=sso-secure'
```

### Protect Custom App
```yaml
labels:
  - 'traefik.http.routers.myapp-web-secure.middlewares=sso-secure'
```

---

**Need more help?** See [SSO_INTEGRATION_GUIDE.md](./SSO_INTEGRATION_GUIDE.md) for detailed setup instructions.
