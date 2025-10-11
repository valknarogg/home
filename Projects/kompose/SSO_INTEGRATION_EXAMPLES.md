# SSO Integration Examples for Kompose Stacks

This document provides copy-paste ready examples for adding SSO to your Kompose stacks.

## 📋 Table of Contents

1. [n8n (Workflow Automation)](#n8n-workflow-automation)
2. [Semaphore (Ansible Automation)](#semaphore-ansible-automation)
3. [Linkwarden (Bookmark Manager)](#linkwarden-bookmark-manager)
4. [Vaultwarden (Password Manager)](#vaultwarden-password-manager)
5. [Custom Application Stack](#custom-application-stack)
6. [Gitea (Git Server)](#gitea-git-server)

---

## n8n (Workflow Automation)

### Location
`/home/valknar/Projects/kompose/chain/compose.yaml`

### Changes Required

**1. Disable n8n's built-in authentication:**

Find the `environment:` section for n8n service and change:

```yaml
environment:
  # BEFORE:
  N8N_BASIC_AUTH_ACTIVE: ${N8N_BASIC_AUTH_ACTIVE:-true}
  
  # AFTER:
  N8N_BASIC_AUTH_ACTIVE: false  # SSO handles authentication
```

**2. Add SSO middleware to labels:**

Find the labels section and change:

```yaml
labels:
  # ... existing labels ...
  
  # BEFORE:
  - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-n8n-web-secure.middlewares=${COMPOSE_PROJECT_NAME}-n8n-web-secure-compress'
  
  # AFTER:
  - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-n8n-web-secure.middlewares=sso-secure'
```

**3. Restart the stack:**

```bash
./kompose.sh restart chain
```

### Complete n8n Service Example

```yaml
services:
  n8n:
    image: ${N8N_IMAGE:-n8nio/n8n:latest}
    container_name: ${COMPOSE_PROJECT_NAME}_n8n
    restart: unless-stopped
    environment:
      TZ: ${TIMEZONE:-Europe/Amsterdam}
      DB_TYPE: postgresdb
      DB_POSTGRESDB_HOST: ${DB_HOST}
      DB_POSTGRESDB_PORT: 5432
      DB_POSTGRESDB_DATABASE: ${N8N_DB_NAME:-n8n}
      DB_POSTGRESDB_USER: ${DB_USER}
      DB_POSTGRESDB_PASSWORD: ${DB_PASSWORD}
      N8N_ENCRYPTION_KEY: ${N8N_ENCRYPTION_KEY}
      WEBHOOK_URL: https://${N8N_TRAEFIK_HOST}/
      GENERIC_TIMEZONE: ${TZ:-Europe/Amsterdam}
      N8N_BASIC_AUTH_ACTIVE: false  # ← SSO handles auth
      EXECUTIONS_DATA_SAVE_ON_ERROR: all
      EXECUTIONS_DATA_SAVE_ON_SUCCESS: all
      EXECUTIONS_DATA_SAVE_MANUAL_EXECUTIONS: true
    volumes:
      - n8n_data:/home/node/.n8n
    networks:
      - kompose_network
    labels:
      - 'traefik.enable=true'
      - 'traefik.http.middlewares.${COMPOSE_PROJECT_NAME}-n8n-redirect-web-secure.redirectscheme.scheme=https'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-n8n-web.middlewares=${COMPOSE_PROJECT_NAME}-n8n-redirect-web-secure'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-n8n-web.rule=Host(`${N8N_TRAEFIK_HOST}`)'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-n8n-web.entrypoints=web'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-n8n-web-secure.rule=Host(`${N8N_TRAEFIK_HOST}`)'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-n8n-web-secure.tls.certresolver=resolver'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-n8n-web-secure.entrypoints=web-secure'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-n8n-web-secure.middlewares=sso-secure'  # ← SSO middleware
      - 'traefik.http.services.${COMPOSE_PROJECT_NAME}-n8n-web-secure.loadbalancer.server.port=5678'
      - 'traefik.docker.network=${NETWORK_NAME}'
```

---

## Semaphore (Ansible Automation)

### Location
`/home/valknar/Projects/kompose/chain/compose.yaml`

### Changes Required

**Add SSO middleware to Semaphore labels:**

```yaml
labels:
  # ... existing labels ...
  
  # BEFORE:
  - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-semaphore-web-secure.middlewares=${COMPOSE_PROJECT_NAME}-semaphore-web-secure-compress'
  
  # AFTER:
  - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-semaphore-web-secure.middlewares=sso-internal-only'  # Extra secure!
```

**Note**: Using `sso-internal-only` adds both SSO and IP whitelisting for extra security since Semaphore is an admin tool.

**Restart the stack:**

```bash
./kompose.sh restart chain
```

### Complete Semaphore Service Example

```yaml
services:
  semaphore:
    image: ${SEMAPHORE_IMAGE:-semaphoreui/semaphore:v2.16.18}
    container_name: ${COMPOSE_PROJECT_NAME}_semaphore
    restart: unless-stopped
    environment:
      TZ: ${TIMEZONE:-Europe/Amsterdam}
      SEMAPHORE_DB_DIALECT: postgres
      SEMAPHORE_DB_HOST: ${DB_HOST}
      SEMAPHORE_DB_NAME: ${SEMAPHORE_DB_NAME:-semaphore}
      SEMAPHORE_DB_USER: ${DB_USER}
      SEMAPHORE_DB_PASS: ${DB_PASSWORD}
      SEMAPHORE_ADMIN: ${SEMAPHORE_ADMIN:-admin}
      SEMAPHORE_ADMIN_PASSWORD: ${SEMAPHORE_ADMIN_PASSWORD}
      SEMAPHORE_ADMIN_NAME: ${SEMAPHORE_ADMIN_NAME:-Admin}
      SEMAPHORE_ADMIN_EMAIL: ${ADMIN_EMAIL}
    volumes:
      - semaphore_data:/var/lib/semaphore
      - semaphore_config:/etc/semaphore
      - semaphore_tmp:/tmp/semaphore
    networks:
      - kompose_network
    labels:
      - 'traefik.enable=true'
      - 'traefik.http.middlewares.${COMPOSE_PROJECT_NAME}-semaphore-redirect-web-secure.redirectscheme.scheme=https'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-semaphore-web.middlewares=${COMPOSE_PROJECT_NAME}-semaphore-redirect-web-secure'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-semaphore-web.rule=Host(`${SEMAPHORE_TRAEFIK_HOST}`)'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-semaphore-web.entrypoints=web'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-semaphore-web-secure.rule=Host(`${SEMAPHORE_TRAEFIK_HOST}`)'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-semaphore-web-secure.tls.certresolver=resolver'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-semaphore-web-secure.entrypoints=web-secure'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-semaphore-web-secure.middlewares=sso-internal-only'  # ← SSO + IP restriction
      - 'traefik.http.services.${COMPOSE_PROJECT_NAME}-semaphore-web-secure.loadbalancer.server.port=3000'
      - 'traefik.docker.network=${NETWORK_NAME}'
```

---

## Linkwarden (Bookmark Manager)

### Location
`/home/valknar/Projects/kompose/+utilitiy/link/compose.yaml`

### Changes Required

**Add SSO middleware to labels:**

```yaml
labels:
  # ... existing labels ...
  
  # BEFORE:
  - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.middlewares=${COMPOSE_PROJECT_NAME}-web-secure-compress'
  
  # AFTER:
  - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.middlewares=sso-secure'
```

**Restart the stack:**

```bash
./kompose.sh restart link
```

### Complete Linkwarden Service Example

```yaml
services:
  linkwarden:
    image: ${DOCKER_IMAGE}
    container_name: ${COMPOSE_PROJECT_NAME}_app
    restart: unless-stopped
    environment:
      TZ: ${TIMEZONE:-Europe/Amsterdam}
      DATABASE_URL: postgresql://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:5432/${DB_NAME}
      NEXTAUTH_SECRET: ${NEXTAUTH_SECRET}
      NEXTAUTH_URL: https://${TRAEFIK_HOST}
      NEXT_PUBLIC_PAGINATION_TAKE_COUNT: 20
      STORAGE_FOLDER: /data/archives
    volumes:
      - linkwarden_data:/data/archives
    networks:
      - kompose_network
    labels:
      - 'traefik.enable=true'
      - 'traefik.http.middlewares.${COMPOSE_PROJECT_NAME}-redirect-web-secure.redirectscheme.scheme=https'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web.middlewares=${COMPOSE_PROJECT_NAME}-redirect-web-secure'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web.rule=Host(`${TRAEFIK_HOST}`)'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web.entrypoints=web'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.rule=Host(`${TRAEFIK_HOST}`)'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.tls.certresolver=resolver'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.entrypoints=web-secure'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.middlewares=sso-secure'  # ← SSO middleware
      - 'traefik.http.services.${COMPOSE_PROJECT_NAME}-web-secure.loadbalancer.server.port=${APP_PORT}'
      - 'traefik.docker.network=${NETWORK_NAME}'
```

---

## Vaultwarden (Password Manager)

### Location
`/home/valknar/Projects/kompose/+utilitiy/vault/compose.yaml`

### Changes Required

**Add SSO middleware to labels:**

```yaml
labels:
  # ... existing labels ...
  
  # BEFORE:
  - 'traefik.http.routers.$COMPOSE_PROJECT_NAME-web-secure.middlewares=$COMPOSE_PROJECT_NAME-web-secure-compress'
  
  # AFTER:
  - 'traefik.http.routers.$COMPOSE_PROJECT_NAME-web-secure.middlewares=sso-secure'
```

**Important Note**: Vaultwarden has its own master password authentication. SSO adds an extra security layer. Users will:
1. First authenticate via Keycloak (SSO)
2. Then unlock their vault with their master password

**Restart the stack:**

```bash
./kompose.sh restart vault
```

### Complete Vaultwarden Service Example

```yaml
services:
  vaultwarden:
    image: ${DOCKER_IMAGE}
    container_name: ${COMPOSE_PROJECT_NAME}_app
    restart: unless-stopped
    volumes:
      - ./bitwarden:/data:rw
    environment:
      TZ: ${TIMEZONE:-Europe/Amsterdam}
      ADMIN_TOKEN: ${JWT_TOKEN}
      WEBSOCKET_ENABLED: ${WEBSOCKET_ENABLED}
      SIGNUPS_ALLOWED: ${SIGNUPS_ALLOWED}
      DOMAIN: ${DOMAIN}
    networks:
      - kompose_network
    labels:
      - 'traefik.enable=true'
      - 'traefik.http.middlewares.$COMPOSE_PROJECT_NAME-redirect-web-secure.redirectscheme.scheme=https'
      - 'traefik.http.routers.$COMPOSE_PROJECT_NAME-web.middlewares=$COMPOSE_PROJECT_NAME-redirect-web-secure'
      - 'traefik.http.routers.$COMPOSE_PROJECT_NAME-web.rule=Host(`$TRAEFIK_HOST`)'
      - 'traefik.http.routers.$COMPOSE_PROJECT_NAME-web.entrypoints=web'
      - 'traefik.http.routers.$COMPOSE_PROJECT_NAME-web-secure.rule=Host(`$TRAEFIK_HOST`)'
      - 'traefik.http.routers.$COMPOSE_PROJECT_NAME-web-secure.tls.certresolver=resolver'
      - 'traefik.http.routers.$COMPOSE_PROJECT_NAME-web-secure.entrypoints=web-secure'
      - 'traefik.http.routers.$COMPOSE_PROJECT_NAME-web-secure.middlewares=sso-secure'  # ← SSO middleware
      - 'traefik.http.services.$COMPOSE_PROJECT_NAME-web-secure.loadbalancer.server.port=$APP_PORT'
      - 'traefik.docker.network=kompose_network'
```

---

## Custom Application Stack

### Create a new stack with SSO from the start

```yaml
name: myapp

services:
  app:
    image: myregistry/myapp:latest
    container_name: ${COMPOSE_PROJECT_NAME}_app
    restart: unless-stopped
    environment:
      TZ: ${TIMEZONE:-Europe/Amsterdam}
      # Your app environment variables
    networks:
      - kompose_network
    labels:
      # Enable Traefik
      - 'traefik.enable=true'
      
      # HTTP to HTTPS redirect
      - 'traefik.http.middlewares.${COMPOSE_PROJECT_NAME}-redirect.redirectscheme.scheme=https'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web.middlewares=${COMPOSE_PROJECT_NAME}-redirect'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web.rule=Host(`${TRAEFIK_HOST}`)'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web.entrypoints=web'
      
      # HTTPS configuration with SSO
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.rule=Host(`${TRAEFIK_HOST}`)'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.tls.certresolver=resolver'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.entrypoints=web-secure'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.middlewares=sso-secure'  # ← SSO protection
      - 'traefik.http.services.${COMPOSE_PROJECT_NAME}-web-secure.loadbalancer.server.port=8080'
      - 'traefik.docker.network=${NETWORK_NAME}'

networks:
  kompose_network:
    name: ${NETWORK_NAME:-kompose}
    external: true
```

### Accessing User Information in Your App

When using SSO, OAuth2 Proxy forwards authentication information via HTTP headers:

```javascript
// Node.js/Express example
app.use((req, res, next) => {
  const user = {
    username: req.headers['x-auth-request-user'],
    email: req.headers['x-auth-request-email'],
    accessToken: req.headers['x-auth-request-access-token'],
    groups: req.headers['x-auth-request-groups']?.split(',') || []
  };
  
  req.authenticatedUser = user;
  next();
});

// Example route with group-based access control
app.get('/admin', (req, res) => {
  if (req.authenticatedUser.groups.includes('admins')) {
    res.send('Admin panel');
  } else {
    res.status(403).send('Forbidden');
  }
});
```

```python
# Python/Flask example
from flask import Flask, request

app = Flask(__name__)

@app.before_request
def get_user_info():
    g.user = {
        'username': request.headers.get('X-Auth-Request-User'),
        'email': request.headers.get('X-Auth-Request-Email'),
        'groups': request.headers.get('X-Auth-Request-Groups', '').split(',')
    }

@app.route('/admin')
def admin_panel():
    if 'admins' in g.user['groups']:
        return 'Admin panel'
    return 'Forbidden', 403
```

---

## Gitea (Git Server)

If you have a Gitea instance, you can integrate it with SSO using Keycloak as an OAuth2 provider.

### Changes Required

**1. Add SSO middleware to Gitea labels:**

```yaml
labels:
  # ... existing labels ...
  - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.middlewares=sso-secure'
```

**2. Configure Gitea to use Keycloak OAuth2:**

Add to Gitea's `app.ini` or environment variables:

```ini
[oauth2_client]
ENABLE_AUTO_REGISTRATION = true
USERNAME = nickname
UPDATE_AVATAR = true
ACCOUNT_LINKING = login

[openid]
ENABLE_OPENID_SIGNUP = true
ENABLE_OPENID_SIGNIN = true
```

**3. In Gitea admin panel:**
- Go to Site Administration → Authentication Sources
- Add new authentication source
- Type: OAuth2
- Provider: OpenID Connect
- Client ID: `gitea` (create this client in Keycloak)
- Client Secret: (from Keycloak)
- OpenID Connect Auto Discovery URL: `https://auth.yourdomain.com/realms/kompose/.well-known/openid-configuration`

---

## 🔄 Migration Path for Existing Users

If you already have users in your applications, you have several options:

### Option 1: Fresh Start (Recommended for New Deployments)
1. Enable SSO on the stack
2. Create users in Keycloak
3. Users login with Keycloak credentials

### Option 2: Dual Authentication (Transition Period)
1. Keep existing authentication enabled
2. Add SSO as optional
3. Gradually migrate users
4. Eventually disable old authentication

### Option 3: Import Users to Keycloak
1. Export users from your app
2. Create bulk import JSON for Keycloak
3. Import users into Keycloak
4. Enable SSO
5. Notify users to reset passwords

---

## 📊 Testing Your Integration

After adding SSO to a stack:

1. **Restart the stack:**
   ```bash
   ./kompose.sh restart [stack-name]
   ```

2. **Test unauthenticated access:**
   ```bash
   # Should redirect to Keycloak login
   curl -L https://your-app.yourdomain.com
   ```

3. **Check headers (when authenticated):**
   ```bash
   # Login first in browser, then:
   curl -H "Cookie: _kompose_oauth2_proxy=..." https://your-app.yourdomain.com
   ```

4. **Verify logs:**
   ```bash
   ./kompose.sh logs auth | grep oauth2
   ./kompose.sh logs [stack-name]
   ```

---

## 🛡️ Security Considerations

1. **Sensitive Admin Panels**: Use `sso-internal-only` for extra security
2. **Public APIs**: Use `sso-secure-limited` for rate limiting
3. **Webhook Endpoints**: Exclude from SSO using `OAUTH2_PROXY_SKIP_AUTH_ROUTES`
4. **Health Checks**: Always exclude `/health`, `/ping`, `/healthcheck` endpoints

---

## 📚 Next Steps

1. Read the full [SSO Integration Guide](./SSO_INTEGRATION_GUIDE.md)
2. Check the [Quick Reference](./SSO_QUICK_REF.md)
3. Set up [KMPS Management Portal](./kmps/README.md)
4. Configure [user groups and roles in Keycloak](#)

---

**Last Updated**: October 2025  
**Kompose Version**: 1.0+  
**SSO Stack Version**: 1.0
