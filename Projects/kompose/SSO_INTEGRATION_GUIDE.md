# Kompose SSO Integration Guide

## 🔐 Single Sign-On (SSO) System Overview

Kompose.sh now includes a comprehensive SSO solution powered by **Keycloak** and **OAuth2 Proxy**, providing centralized authentication for all stacks.

### Architecture

```
┌──────────────────────────────────────────────────────────────┐
│                     Traefik Reverse Proxy                    │
│                   (SSL/TLS Termination)                      │
└────────────────┬─────────────────────────────────────────────┘
                 │
     ┌───────────┴───────────┐
     │                       │
┌────▼─────┐         ┌──────▼──────┐
│  OAuth2  │────────▶│  Keycloak   │
│  Proxy   │         │  (Auth)     │
│  (SSO)   │◀────────│             │
└────┬─────┘         └─────────────┘
     │
     │ Forward Auth
     │ Middleware
     │
┌────▼───────────────────────────────────────────────┐
│         Protected Application Stacks               │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐        │
│  │   n8n    │  │Linkwarden│  │   KMPS   │  ...   │
│  └──────────┘  └──────────┘  └──────────┘        │
└────────────────────────────────────────────────────┘
```

## 📋 Components

### 1. **Keycloak** (Identity Provider)
- Central user management
- OIDC/OAuth2 authentication
- Realm: `kompose`
- Admin UI: `https://auth.yourdomain.com`

### 2. **OAuth2 Proxy** (Forward Authentication)
- Traefik forward-auth middleware
- Session management via Redis
- Cookie-based SSO across all subdomains
- URL: `https://sso.yourdomain.com`

### 3. **KMPS** (Kompose Management Portal)
- Web-based user and client management
- Keycloak administration interface
- Stack management dashboard
- URL: `https://manage.yourdomain.com`

### 4. **Traefik Middlewares**
- `kompose-sso`: Base SSO middleware
- `sso-secure`: SSO + security headers + compression
- `sso-secure-limited`: SSO + rate limiting
- `sso-internal-only`: SSO + IP restriction

## 🚀 Quick Start

### Step 1: Configure Environment Variables

Update your root `secrets.env` file:

```bash
# Keycloak Admin Password
AUTH_KC_ADMIN_PASSWORD=<generate-strong-password>

# OAuth2 Proxy Configuration
AUTH_OAUTH2_CLIENT_SECRET=<generate-strong-password>
AUTH_OAUTH2_COOKIE_SECRET=$(openssl rand -base64 32)

# KMPS Management Portal
KMPS_CLIENT_SECRET=<generate-strong-password>
KMPS_NEXTAUTH_SECRET=$(openssl rand -base64 32)
```

Update your root `.env` file:

```bash
# Base domain for cookie sharing
BASE_DOMAIN=yourdomain.com

# Keycloak hostname
TRAEFIK_HOST_AUTH=auth.yourdomain.com

# OAuth2 Proxy hostname  
TRAEFIK_HOST_OAUTH2=sso.yourdomain.com

# KMPS Management Portal hostname
TRAEFIK_HOST_KMPS=manage.yourdomain.com
```

### Step 2: Deploy the Auth Stack

```bash
# Start the auth stack with Keycloak and OAuth2 Proxy
./kompose.sh up auth

# Wait for services to be healthy
./kompose.sh status auth
```

### Step 3: Configure Keycloak

1. **Access Keycloak Admin Console**
   ```
   URL: https://auth.yourdomain.com
   Username: admin
   Password: <AUTH_KC_ADMIN_PASSWORD from secrets.env>
   ```

2. **Create the Kompose Realm**
   - Click "Create Realm"
   - Name: `kompose`
   - Enabled: ON
   - Click "Create"

3. **Create OAuth2 Proxy Client**
   
   a. Navigate to: Clients → Create Client
   
   b. General Settings:
      - Client type: `OpenID Connect`
      - Client ID: `kompose-sso`
      - Name: `Kompose SSO`
      - Click "Next"
   
   c. Capability config:
      - Client authentication: ON
      - Authorization: OFF
      - Standard flow: ON
      - Direct access grants: OFF
      - Click "Next"
   
   d. Login settings:
      - Root URL: `https://sso.yourdomain.com`
      - Valid redirect URIs: 
        - `https://sso.yourdomain.com/oauth2/callback`
        - `https://*.yourdomain.com/*` (for wildcard subdomain support)
      - Web origins: `https://*.yourdomain.com`
      - Click "Save"
   
   e. Get Client Secret:
      - Go to "Credentials" tab
      - Copy the "Client secret"
      - Update `AUTH_OAUTH2_CLIENT_SECRET` in `secrets.env`

4. **Create KMPS Admin Client** (for management portal)
   
   Repeat the same process with:
   - Client ID: `kmps-admin`
   - Valid redirect URIs: `https://manage.yourdomain.com/*`
   - **Important**: Enable these additional capabilities:
     - Service accounts roles: ON (for admin API access)
   - Save the client secret to `KMPS_CLIENT_SECRET` in `secrets.env`

5. **Assign Admin Roles to KMPS Client**
   
   a. Navigate to: Clients → kmps-admin → Service accounts roles
   
   b. Click "Assign role"
   
   c. Filter by clients and assign:
      - `realm-admin` (from realm-management)
      - `manage-users`
      - `manage-clients`
      - `view-users`
      - `view-clients`

6. **Create Users**
   
   a. Navigate to: Users → Create user
   
   b. Fill in:
      - Username: (required)
      - Email: (required)
      - First name: (optional)
      - Last name: (optional)
      - Email verified: ON
      - Enabled: ON
   
   c. Click "Create"
   
   d. Set Password:
      - Go to "Credentials" tab
      - Click "Set password"
      - Enter password (twice)
      - Temporary: OFF (unless you want them to change it)
      - Click "Save"

7. **Create Groups** (Optional - for role-based access)
   
   a. Navigate to: Groups → Create group
   
   b. Create useful groups:
      - `admins` - Full access to all services
      - `users` - Standard user access
      - `developers` - Access to development tools (n8n, Semaphore)
   
   c. Assign users to groups via: Users → [user] → Groups

### Step 4: Restart OAuth2 Proxy

After configuring Keycloak, restart the OAuth2 Proxy to apply changes:

```bash
./kompose.sh restart auth
```

### Step 5: Deploy KMPS Management Portal

```bash
# Start the management portal
./kompose.sh up kmps

# Check status
./kompose.sh status kmps
```

Access the portal at: `https://manage.yourdomain.com`

## 🔧 Integrating SSO with Existing Stacks

### Method 1: Using Traefik Labels (Recommended)

Update your stack's `compose.yaml` to use the SSO middleware:

```yaml
services:
  your-app:
    # ... existing configuration ...
    labels:
      - 'traefik.enable=true'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.middlewares=sso-secure'
      # ... other labels ...
```

**Available SSO middleware chains:**

- `sso-secure`: Basic SSO protection + security headers + compression
- `sso-secure-limited`: SSO + rate limiting for public services
- `sso-internal-only`: SSO + internal IP restriction (extra secure)

### Method 2: Updating Existing Stacks

#### Example: Protect Linkwarden with SSO

Edit `/home/valknar/Projects/kompose/+utilitiy/link/compose.yaml`:

```yaml
labels:
  # ... existing labels ...
  # Change this line:
  - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.middlewares=${COMPOSE_PROJECT_NAME}-web-secure-compress'
  
  # To this:
  - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.middlewares=sso-secure'
```

Restart the stack:
```bash
./kompose.sh restart link
```

#### Example: Protect n8n with SSO

Edit `/home/valknar/Projects/kompose/chain/compose.yaml`:

```yaml
services:
  n8n:
    environment:
      # Disable n8n's basic auth since we're using SSO
      N8N_BASIC_AUTH_ACTIVE: false
    labels:
      # ... existing labels ...
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-n8n-web-secure.middlewares=sso-secure'
```

Restart:
```bash
./kompose.sh restart chain
```

#### Example: Protect Vaultwarden with SSO

Edit `/home/valknar/Projects/kompose/+utilitiy/vault/compose.yaml`:

```yaml
labels:
  # ... existing labels ...
  - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.middlewares=sso-secure'
```

**Note**: Vaultwarden has its own authentication, so SSO will add an additional layer. Users will:
1. Authenticate via Keycloak (SSO)
2. Then log into Vaultwarden with their master password

Restart:
```bash
./kompose.sh restart vault
```

### Method 3: Creating New SSO-Protected Stacks

When creating a new stack, include SSO middleware from the start:

```yaml
name: myapp

services:
  app:
    image: myimage:latest
    container_name: ${COMPOSE_PROJECT_NAME}_app
    # ... configuration ...
    networks:
      - kompose_network
    labels:
      - 'traefik.enable=true'
      - 'traefik.http.middlewares.${COMPOSE_PROJECT_NAME}-redirect.redirectscheme.scheme=https'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web.middlewares=${COMPOSE_PROJECT_NAME}-redirect'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web.rule=Host(`${TRAEFIK_HOST}`)'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web.entrypoints=web'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.rule=Host(`${TRAEFIK_HOST}`)'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.tls.certresolver=resolver'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.entrypoints=web-secure'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.middlewares=sso-secure'
      - 'traefik.http.services.${COMPOSE_PROJECT_NAME}-web-secure.loadbalancer.server.port=8080'
      - 'traefik.docker.network=${NETWORK_NAME}'

networks:
  kompose_network:
    name: ${NETWORK_NAME:-kompose}
    external: true
```

## 🎯 Advanced Configuration

### Custom Middleware Chains

Create custom middleware chains in `/home/valknar/Projects/kompose/proxy/dynamic/middlewares.yml`:

```yaml
http:
  middlewares:
    # Custom SSO + specific headers for your app
    my-app-sso:
      chain:
        middlewares:
          - kompose-sso
          - my-app-headers
          - compression
    
    my-app-headers:
      headers:
        customResponseHeaders:
          X-Custom-Header: "my-value"
```

### Excluding Specific Paths from SSO

If your app has public endpoints that shouldn't require auth:

```yaml
# In your OAuth2 Proxy configuration (auth/compose.yaml)
environment:
  OAUTH2_PROXY_SKIP_AUTH_ROUTES: "^/health$,^/api/public/.*,^/webhooks/.*"
```

### Group-Based Access Control

Configure Keycloak to pass group membership, then use it in your applications:

1. In Keycloak: Clients → kompose-sso → Client scopes → Add mapper
   - Mapper type: `Group Membership`
   - Name: `groups`
   - Token Claim Name: `groups`
   - Full group path: OFF
   - Add to userinfo: ON

2. OAuth2 Proxy will pass groups via `X-Auth-Request-Groups` header

3. Use in your app:
   ```javascript
   // Example in Node.js/Express
   app.use((req, res, next) => {
     const groups = req.headers['x-auth-request-groups'];
     if (groups && groups.includes('admins')) {
       // Admin access
     }
   });
   ```

### Session Configuration

Adjust session duration in `auth/compose.yaml`:

```yaml
environment:
  # Cookie expires after 7 days
  OAUTH2_PROXY_COOKIE_EXPIRE: "168h"
  # Refresh token every hour
  OAUTH2_PROXY_COOKIE_REFRESH: "60m"
```

## 🔍 Monitoring & Debugging

### Check OAuth2 Proxy Logs

```bash
./kompose.sh logs auth -f --tail=100
```

### Test SSO Authentication

```bash
# Check if OAuth2 Proxy is accessible
curl -I https://sso.yourdomain.com/ping

# Test auth endpoint
curl -I https://sso.yourdomain.com/oauth2/auth
# Should return 401 Unauthorized if not authenticated
```

### Verify Keycloak Configuration

```bash
# Get realm configuration
curl https://auth.yourdomain.com/realms/kompose/.well-known/openid-configuration
```

### Common Issues

1. **"Failed to reach Keycloak"**
   - Ensure `auth` stack is running
   - Check Keycloak logs: `./kompose.sh logs auth`
   - Verify DNS/hostnames are correct

2. **"Invalid redirect URI"**
   - Check Keycloak client configuration
   - Ensure redirect URIs match exactly
   - Verify `BASE_DOMAIN` in `.env`

3. **"Authentication loop"**
   - Clear browser cookies
   - Check OAuth2 Proxy cookie settings
   - Verify `OAUTH2_PROXY_COOKIE_DOMAINS` includes your domain

4. **"Session not persisting"**
   - Ensure Redis (core stack) is running
   - Check Redis connection in OAuth2 Proxy logs
   - Verify `OAUTH2_PROXY_REDIS_CONNECTION_URL`

## 📊 Current Stack Status

### Protected Stacks (with SSO)
After following this guide, these stacks should have SSO:

- ✅ **KMPS** - Management Portal (built-in SSO)
- ⚙️ **n8n** - Workflow automation
- ⚙️ **Semaphore** - Ansible automation  
- ⚙️ **Linkwarden** - Bookmark manager
- ⚙️ **Vaultwarden** - Password manager (dual auth)

### Public Stacks (no SSO required)
- **Keycloak** - Identity provider (has own auth)
- **OAuth2 Proxy** - SSO service itself
- **Traefik Dashboard** - Internal only

## 🔐 Security Best Practices

1. **Use Strong Secrets**
   ```bash
   # Generate strong passwords
   openssl rand -base64 32
   ```

2. **Enable 2FA in Keycloak**
   - Navigate to: Authentication → Required Actions
   - Add "Configure OTP" as default action

3. **Regular User Audits**
   - Review users monthly in KMPS or Keycloak
   - Remove inactive users
   - Check group memberships

4. **IP Restrictions**
   - Use `sso-internal-only` for admin interfaces
   - Configure `internal-only` middleware in `proxy/dynamic/middlewares.yml`

5. **Session Management**
   - Keep cookie expiry reasonable (7 days default)
   - Use secure cookies (enforced in production)
   - Enable cookie refresh for active sessions

6. **Backup Keycloak Database**
   ```bash
   ./kompose.sh db backup -d keycloak
   ```

## 📚 Additional Resources

- [Keycloak Documentation](https://www.keycloak.org/documentation)
- [OAuth2 Proxy Documentation](https://oauth2-proxy.github.io/oauth2-proxy/)
- [Traefik Forward Auth](https://doc.traefik.io/traefik/middlewares/http/forwardauth/)

## 🆘 Support

For issues or questions:

1. Check logs: `./kompose.sh logs [stack]`
2. Verify configuration in Keycloak admin console
3. Review Traefik dashboard at `http://your-server:8080`
4. Check the kompose.sh documentation

---

**Last Updated**: October 2025  
**Version**: 1.0.0  
**Stack**: kompose.sh SSO Integration
