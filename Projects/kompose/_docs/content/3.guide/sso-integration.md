# SSO Integration Guide

Complete guide for integrating Single Sign-On (SSO) with Kompose stacks using Keycloak and OAuth2 Proxy.

## Overview

Kompose provides enterprise-grade Single Sign-On capabilities through:
- **Keycloak** - Identity and Access Management
- **OAuth2 Proxy** - Forward Authentication
- **Traefik Middleware** - Routing and protection

## Quick Start

### 1. Deploy Auth Stack

```bash
./kompose.sh up auth
```

This starts:
- Keycloak (identity provider)
- OAuth2 Proxy (forward authentication)
- PostgreSQL (Keycloak database)

### 2. Configure Keycloak

Access Keycloak admin console:
- URL: `https://auth.yourdomain.com`
- Username: `admin`
- Password: Check `secrets.env` → `KC_ADMIN_PASSWORD`

Create Kompose realm:
1. Click **Create Realm**
2. Name: `kompose`
3. Enabled: ON
4. Save

### 3. Create OAuth2 Proxy Client

1. Navigate: **Clients → Create Client**
2. Client ID: `kompose-sso`
3. Client type: **OpenID Connect**
4. Client authentication: **ON**
5. Valid redirect URIs: `https://sso.yourdomain.com/oauth2/callback`, `https://*.yourdomain.com/*`
6. Web origins: `https://*.yourdomain.com`
7. Save and copy **Client Secret** to `secrets.env` → `AUTH_OAUTH2_CLIENT_SECRET`

### 4. Protect a Service

Edit the service's `compose.yaml`:

```yaml
labels:
  # Change from:
  - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.middlewares=compression'
  
  # To:
  - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.middlewares=sso-secure'
```

Restart the service:
```bash
./kompose.sh restart [stack-name]
```

## Available Middlewares

### sso-secure
Base SSO with security headers and compression:
```yaml
middlewares=sso-secure
```

### sso-secure-limited
SSO + rate limiting:
```yaml
middlewares=sso-secure-limited
```

### sso-internal-only
SSO + IP restriction:
```yaml
middlewares=sso-internal-only
```

## Service-Specific Integration Examples

### n8n (Workflow Automation)

**Disable n8n's built-in auth:**

Edit `chain/.env`:
```bash
N8N_BASIC_AUTH_ACTIVE=false
```

**Add SSO middleware:**

Edit `chain/compose.yaml`:
```yaml
labels:
  - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-n8n-web-secure.middlewares=sso-secure'
```

**Restart:**
```bash
./kompose.sh restart chain
```

### Semaphore (Ansible Automation)

For extra security with IP restriction:

```yaml
labels:
  - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-semaphore-web-secure.middlewares=sso-internal-only'
```

### Linkwarden (Bookmarks)

Already integrated with SSO:
```yaml
labels:
  - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.middlewares=sso-secure'
```

### Vaultwarden (Password Manager)

Dual authentication - SSO for access, master password for vault:
```yaml
labels:
  - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.middlewares=sso-secure'
```

Users must:
1. Authenticate via Keycloak (SSO)
2. Unlock vault with master password

### Umami (Analytics)

Dual middleware - SSO for admin, public for tracking:
```yaml
labels:
  - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.middlewares=umami-auth-selector'
```

## User Management

### Via Keycloak Admin

Access: `https://auth.yourdomain.com`

**Create User:**
1. Navigate: **Users → Create user**
2. Fill in: Username, Email, First/Last name
3. Save
4. Go to **Credentials** tab
5. Set password

**Enable/Disable User:**
1. Navigate: **Users → [username]**
2. Toggle **Enabled** switch
3. Save

### Via KMPS Portal

Access: `https://manage.yourdomain.com`

Features:
- List all users
- Create new users
- Edit user details
- Reset passwords
- Enable/disable accounts
- Verify emails

## Groups and Roles

### Create Group

1. Navigate: **Groups → Create group**
2. Name: `admins`
3. Save

### Assign Users to Group

1. Navigate: **Groups → [group-name] → Members**
2. Click **Add member**
3. Select users
4. Save

### Role-Based Access Control

Access user information in your application via headers:

```javascript
// Node.js/Express
app.use((req, res, next) => {
  const user = {
    username: req.headers['x-auth-request-user'],
    email: req.headers['x-auth-request-email'],
    groups: req.headers['x-auth-request-groups']?.split(',') || []
  };
  
  if (user.groups.includes('admins')) {
    // Admin access
  }
});
```

## Public Endpoints

Some endpoints should remain public (e.g., API webhooks, tracking scripts).

### Skip Authentication for Specific Paths

Configure in `auth/compose.yaml`:

```yaml
environment:
  OAUTH2_PROXY_SKIP_AUTH_ROUTES: "^/api/webhook,^/api/collect,^/health"
```

## Advanced Configuration

### Custom Login Page

Edit `auth/compose.yaml`:
```yaml
environment:
  OAUTH2_PROXY_CUSTOM_SIGN_IN_LOGO: https://yourdomain.com/logo.png
```

### Session Timeout

Edit `auth/compose.yaml`:
```yaml
environment:
  OAUTH2_PROXY_COOKIE_EXPIRE: 12h
```

### Multi-Factor Authentication

In Keycloak:
1. Navigate: **Authentication → Required Actions**
2. Enable **Configure OTP**
3. Users will be prompted to set up 2FA on next login

## Troubleshooting

### Can't Login

**Check Keycloak is running:**
```bash
./kompose.sh status auth
docker logs auth_keycloak
```

**Verify client configuration:**
1. Client ID matches in both Keycloak and `auth/.env`
2. Client secret matches
3. Redirect URIs are correct

### Redirect Loop

**Check OAuth2 Proxy configuration:**
```bash
docker logs auth_oauth2-proxy
```

**Common causes:**
- Cookie domain mismatch
- Missing OAUTH2_PROXY_COOKIE_SECRET
- Incorrect redirect URIs

### User Headers Not Available

**Verify middleware chain:**
```yaml
middlewares=sso-secure  # Not just 'sso'
```

**Check OAuth2 Proxy is forwarding headers:**
```bash
docker exec auth_oauth2-proxy env | grep OAUTH2_PROXY_SET
```

## Security Best Practices

### 1. Use Strong Passwords
```bash
# Generate secure password
openssl rand -base64 32
```

### 2. Enable HTTPS Only
All SSO endpoints enforce HTTPS via Traefik.

### 3. Regular Security Updates
```bash
./kompose.sh pull auth
./kompose.sh restart auth
```

### 4. Monitor Failed Logins
Check Keycloak admin → **Events**

### 5. Use IP Restrictions for Admin Tools
```yaml
middlewares=sso-internal-only
```

### 6. Enable Audit Logging
In Keycloak:
1. Navigate: **Events → Config**
2. Enable **Save Events**
3. Set expiration

## Migration Guide

### From Basic Auth to SSO

1. **Backup user data:**
   ```bash
   ./kompose.sh db backup
   ```

2. **Export users from application**

3. **Import to Keycloak:**
   - Use Keycloak admin API
   - Or create users manually

4. **Enable SSO middleware**

5. **Test with one user first**

6. **Disable old authentication**

7. **Notify all users**

### User Communication Template

```
Subject: New Single Sign-On System

We've upgraded to a centralized authentication system!

What this means:
- One login for all services
- Enhanced security
- Easier password management

Action Required:
1. Visit: https://auth.yourdomain.com
2. Reset your password (first time only)
3. Use this login for all services

Questions? Contact support.
```

## API Integration

### Create Service Account for API Access

1. **Create Client in Keycloak:**
   - Client ID: `my-api-client`
   - Client authentication: ON
   - Service accounts roles: ON

2. **Assign Roles:**
   - Navigate: **Clients → my-api-client → Service accounts roles**
   - Assign appropriate roles

3. **Get Access Token:**
   ```bash
   curl -X POST https://auth.yourdomain.com/realms/kompose/protocol/openid-connect/token \
     -d "client_id=my-api-client" \
     -d "client_secret=<secret>" \
     -d "grant_type=client_credentials"
   ```

4. **Use Token in API Calls:**
   ```bash
   curl -H "Authorization: Bearer <token>" \
     https://api.yourdomain.com/endpoint
   ```

## See Also

- [KMPS Management Portal](/stacks/kmps)
- [Keycloak Documentation](https://www.keycloak.org/documentation)
- [OAuth2 Proxy Documentation](https://oauth2-proxy.github.io/oauth2-proxy/)
- [Quick Reference](/reference/sso-quick-reference)
