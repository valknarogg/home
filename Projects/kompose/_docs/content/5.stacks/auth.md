---
title: Auth - Authentication & SSO
description: "Keycloak + OAuth2 Proxy for centralized authentication"
navigation:
  icon: i-lucide-lock-keyhole
---

# Auth Stack - Authentication & SSO

> *"You shall not pass... without proper credentials!"*

## Overview

The **auth** stack provides centralized authentication and Single Sign-On (SSO) for all Kompose services using Keycloak and OAuth2 Proxy.

**Components:**
- :icon{name="lucide:lock"} **Keycloak** - Identity and Access Management
- :icon{name="lucide:shield"} **OAuth2 Proxy** - SSO Forward Authentication

## Configuration

> **New in v2.0**: Auth stack configuration is centralized in the root `.env` file with `AUTH_` prefix.

### Environment Variables

All auth stack variables are in `/home/valknar/Projects/kompose/.env`:

```bash
# ===================================================================
# AUTH STACK CONFIGURATION
# ===================================================================
AUTH_COMPOSE_PROJECT_NAME=auth

# Keycloak Configuration
AUTH_DOCKER_IMAGE=quay.io/keycloak/keycloak:latest
AUTH_DB_NAME=keycloak
AUTH_KC_ADMIN_USERNAME=admin

# OAuth2 Proxy Configuration
AUTH_OAUTH2_PROXY_HOST=${TRAEFIK_HOST_OAUTH2}
AUTH_OAUTH2_CLIENT_ID=kompose-sso
```

### Secrets

Sensitive values in `/home/valknar/Projects/kompose/secrets.env`:

```bash
# Auth stack secrets
AUTH_KC_ADMIN_PASSWORD=xxx
AUTH_OAUTH2_CLIENT_SECRET=xxx
AUTH_OAUTH2_COOKIE_SECRET=xxx  # Generate with: openssl rand -base64 32
```

### Viewing Configuration

```bash
# Show all auth stack variables
./kompose.sh env show auth

# Validate auth configuration
./kompose.sh env validate auth
```

## Services

### Keycloak

**Container**: `auth_keycloak`  
**Image**: `quay.io/keycloak/keycloak:latest`  
**URL**: https://auth.pivoine.art  
**Port**: 8080 (internal)

Identity and Access Management platform with:
- :icon{name="lucide:user"} **Single Sign-On (SSO)**: Log in once, access everything
- :icon{name="lucide:ticket"} **Identity Brokering**: Connect with Google, GitHub, OAuth providers
- :icon{name="lucide:users"} **User Management**: Centralized user directory
- :icon{name="lucide:lock"} **OAuth 2.0 & OpenID Connect**: Industry-standard protocols
- :icon{name="lucide:shield"} **Authorization Services**: Fine-grained access control

**Configuration:**
```bash
AUTH_DOCKER_IMAGE=quay.io/keycloak/keycloak:latest
AUTH_DB_NAME=keycloak
AUTH_KC_ADMIN_USERNAME=admin
AUTH_KC_ADMIN_PASSWORD=${AUTH_KC_ADMIN_PASSWORD}  # from secrets.env
```

**Database Connection:**
- Uses PostgreSQL from core stack
- Database: `keycloak`
- Host: `core-postgres`
- Port: `5432`

### OAuth2 Proxy

**Container**: `auth_oauth2_proxy`  
**Image**: `quay.io/oauth2-proxy/oauth2-proxy:latest`  
**URL**: https://sso.pivoine.art  
**Port**: 4180

Forward authentication proxy for protecting services:
- :icon{name="lucide:link"} **Forward Auth**: Integrates with Traefik
- :icon{name="lucide:cookie"} **Cookie Management**: Session handling
- :icon{name="lucide:database"} **Redis Sessions**: Stores sessions in Redis
- :icon{name="lucide:shield-check"} **Access Control**: Protects backend services

**Configuration:**
```bash
AUTH_OAUTH2_PROXY_HOST=${TRAEFIK_HOST_OAUTH2}
AUTH_OAUTH2_CLIENT_ID=kompose-sso
AUTH_OAUTH2_CLIENT_SECRET=${AUTH_OAUTH2_CLIENT_SECRET}
AUTH_OAUTH2_COOKIE_SECRET=${AUTH_OAUTH2_COOKIE_SECRET}
```

## Quick Start

### 1. Configure Environment

Review auth stack settings in root `.env`:

```bash
vim .env
# Scroll to AUTH STACK CONFIGURATION section
# Verify settings are correct
```

### 2. Configure Secrets

Add passwords to `secrets.env`:

```bash
vim secrets.env

# Add or verify:
AUTH_KC_ADMIN_PASSWORD=<strong-password>
AUTH_OAUTH2_CLIENT_SECRET=<strong-secret>
AUTH_OAUTH2_COOKIE_SECRET=$(openssl rand -base64 32)
```

Or generate:
```bash
./kompose.sh secrets generate
```

### 3. Ensure Core Stack is Running

Auth depends on core stack (PostgreSQL):

```bash
# Start core if not running
./kompose.sh up core

# Verify core is healthy
./kompose.sh status core
```

### 4. Start Auth Stack

```bash
# Start services
./kompose.sh up auth

# Verify
./kompose.sh status auth
```

Expected output:
```
✓ auth_keycloak (running)
✓ auth_oauth2_proxy (running)
```

### 5. Access Keycloak Admin Console

```
URL: https://auth.pivoine.art
Username: admin
Password: <from secrets.env AUTH_KC_ADMIN_PASSWORD>
```

## Customizing Configuration

### Change Admin Username

```bash
vim .env

# Find and modify:
AUTH_KC_ADMIN_USERNAME=myadmin

# Update password in secrets.env
vim secrets.env
AUTH_KC_ADMIN_PASSWORD=new-password

# Restart
./kompose.sh restart auth
```

### Change OAuth2 Cookie Domain

```bash
vim .env

# Find and modify in domain.env:
BASE_DOMAIN=yourdomain.com

# Restart
./kompose.sh restart auth
```

### Configure Session Storage

OAuth2 Proxy uses Redis from core stack by default:

```bash
# Already configured in compose.yaml:
OAUTH2_PROXY_SESSION_STORE_TYPE=redis
OAUTH2_PROXY_REDIS_CONNECTION_URL=redis://core-redis:6379
```

## Keycloak Setup

### Initial Configuration

1. **Access Admin Console:**
   - URL: https://auth.pivoine.art
   - Login with admin credentials

2. **Create a Realm:**
   - Hover over "Master" in top-left
   - Click "Create Realm"
   - Name: `kompose`
   - Save

3. **Create OAuth2 Client:**
   - Go to Clients → Create
   - Client ID: `kompose-sso`
   - Client Protocol: `openid-connect`
   - Access Type: `confidential`
   - Valid Redirect URIs: `https://sso.pivoine.art/oauth2/callback`
   - Save

4. **Get Client Secret:**
   - Go to Credentials tab
   - Copy the Secret
   - Add to `secrets.env`:
     ```bash
     AUTH_OAUTH2_CLIENT_SECRET=<copied-secret>
     ```
   - Restart: `./kompose.sh restart auth`

### User Management

**Create Users:**
```
Keycloak Admin → Users → Add User
- Username: user@example.com
- Email: user@example.com
- First/Last Name
- Email Verified: ON
Save → Credentials → Set Password
```

**Create Groups:**
```
Keycloak Admin → Groups → New
- Name: admins
- Save
Add users to group
```

### Identity Providers

**Add Google Login:**
```
Identity Providers → Google
- Client ID: <from Google Cloud Console>
- Client Secret: <from Google Cloud Console>
- Save
```

**Add GitHub Login:**
```
Identity Providers → GitHub
- Client ID: <from GitHub OAuth App>
- Client Secret: <from GitHub OAuth App>
- Save
```

## OAuth2 Proxy Configuration

### Protecting Services with SSO

Add to your service's labels in compose.yaml:

```yaml
labels:
  - 'traefik.http.routers.myservice.middlewares=kompose-sso'
```

The `kompose-sso` middleware is defined in auth stack:

```yaml
- 'traefik.http.middlewares.kompose-sso.forwardAuth.address=http://auth_oauth2_proxy:4180/oauth2/auth'
- 'traefik.http.middlewares.kompose-sso.forwardAuth.trustForwardHeader=true'
```

### Whitelisting Public Paths

Configure paths that don't require auth:

```bash
# In auth compose.yaml, modify:
OAUTH2_PROXY_SKIP_AUTH_ROUTES: "^/health$,^/ping$,^/api/public"
```

## Monitoring

### Health Checks

```bash
# Keycloak
curl https://auth.pivoine.art/health

# OAuth2 Proxy
curl http://localhost:4180/ping
```

### Logs

```bash
# All auth services
./kompose.sh logs auth -f

# Keycloak only
docker logs auth_keycloak -f

# OAuth2 Proxy only
docker logs auth_oauth2_proxy -f
```

### Session Debugging

```bash
# Check Redis for sessions
docker exec -it core-redis redis-cli -a <password>
KEYS "oauth2*"
```

## Troubleshooting

### Keycloak Won't Start

**Check database connection:**
```bash
# Verify core stack is running
./kompose.sh status core

# Check Keycloak logs
docker logs auth_keycloak -f

# Validate configuration
./kompose.sh env validate auth
```

**Database connection refused:**
```bash
# Test connection from Keycloak container
docker exec auth_keycloak ping core-postgres

# Check database exists
docker exec core-postgres psql -U valknar -l | grep keycloak
```

### Can't Login to Admin Console

**Verify credentials:**
```bash
# Check configured username
./kompose.sh env show auth | grep KC_ADMIN_USERNAME

# Check password is set
grep AUTH_KC_ADMIN_PASSWORD secrets.env

# Reset admin password
# Edit secrets.env, then:
./kompose.sh restart auth
```

### OAuth2 Proxy Issues

**Authentication fails:**
```bash
# Check OAuth2 Proxy logs
docker logs auth_oauth2_proxy -f

# Verify client secret matches
# In Keycloak: Clients → kompose-sso → Credentials
# Should match AUTH_OAUTH2_CLIENT_SECRET in secrets.env
```

**Cookie not set:**
```bash
# Verify cookie settings
./kompose.sh env show auth | grep COOKIE

# Check BASE_DOMAIN is correct
grep BASE_DOMAIN .env

# Ensure cookie secret is set (32 bytes base64)
grep AUTH_OAUTH2_COOKIE_SECRET secrets.env
```

**Redirect loop:**
```bash
# Check redirect URL in Keycloak client settings
# Should be: https://sso.pivoine.art/oauth2/callback

# Verify OIDC issuer URL is accessible
curl https://auth.pivoine.art/realms/kompose/.well-known/openid-configuration
```

### SSL/TLS Issues

**Getting SSL errors:**
```bash
# Ensure Traefik is running with SSL
./kompose.sh status proxy

# Check Keycloak hostname config
./kompose.sh env show auth | grep KC_HOSTNAME

# Should be: https://auth.pivoine.art (not http://)
```

## Security Best Practices

### ✅ Do

- Use strong admin passwords (generate with `./kompose.sh secrets generate`)
- Enable 2FA for admin accounts
- Regularly update Keycloak image
- Use HTTPS for all access (via Traefik)
- Rotate OAuth2 client secrets periodically
- Monitor authentication logs
- Limit admin access to specific IPs (via Traefik)

### ❌ Don't

- Use default passwords
- Expose Keycloak admin console publicly without protection
- Share OAuth2 client secrets
- Disable HTTPS
- Use weak cookie secrets
- Grant admin access unnecessarily

## Integration Examples

### Protect n8n with SSO

```yaml
# In chain/compose.yaml
services:
  n8n:
    labels:
      - 'traefik.http.routers.n8n-web-secure.middlewares=kompose-sso'
```

### Protect Gitea with SSO

```yaml
# In code/compose.yaml  
services:
  gitea:
    labels:
      - 'traefik.http.routers.gitea-web-secure.middlewares=kompose-sso'
```

### Custom Application

```yaml
services:
  myapp:
    labels:
      - 'traefik.http.routers.myapp.middlewares=kompose-sso'
      - 'traefik.http.routers.myapp.rule=Host(`app.pivoine.art`)'
```

## Advanced Configuration

### Custom Realm

Create a separate realm for a specific application:

1. Create realm in Keycloak UI
2. Create client in that realm
3. Update OAuth2 Proxy environment:
   ```bash
   OAUTH2_PROXY_OIDC_ISSUER_URL: https://auth.pivoine.art/realms/myapp
   ```

### Group-Based Access

Configure OAuth2 Proxy to require specific groups:

```bash
# Add to OAuth2 Proxy environment:
OAUTH2_PROXY_ALLOWED_GROUPS=admins,developers
```

### Email Verification

Enable email verification in Keycloak:
```
Realm Settings → Login → Verify Email: ON
```

Configure SMTP in Keycloak:
```
Realm Settings → Email
- From: noreply@pivoine.art
- Host: smtp.ionos.de
- Port: 465
- Enable SSL: ON
- Username: <email>
- Password: <password>
```

## See Also

- [Stack Configuration Overview](/reference/stack-configuration)
- [Keycloak Documentation](https://www.keycloak.org/documentation)
- [OAuth2 Proxy Documentation](https://oauth2-proxy.github.io/oauth2-proxy/)
- [SSO Integration Guide](/guide/sso-integration)

---

**Configuration Location:** `/home/valknar/Projects/kompose/.env` (AUTH section)  
**Secrets Location:** `/home/valknar/Projects/kompose/secrets.env`  
**Default URL:** `https://auth.pivoine.art`  
**Depends On:** Core stack (PostgreSQL)
