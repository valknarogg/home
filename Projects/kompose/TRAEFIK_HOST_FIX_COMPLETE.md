# TRAEFIK_HOST URL Fix - Complete Summary

## Problem Solved
The `kompose.sh up` command was hanging at the chain stack because compose files were constructing invalid HTTPS URLs for local development like `https://localhost:5678/`.

## Solution Implemented

### 1. Added URL Override Variables to `.env`

Added these variables to support HTTP URLs for local development:

```bash
# Base configuration
BASE_DOMAIN=localhost

# Keycloak (auth stack) - use HTTP not HTTPS
KC_HOSTNAME=http://localhost:8180
OAUTH2_PROXY_OIDC_ISSUER_URL=http://localhost:8180/realms/kompose
OAUTH2_PROXY_REDIRECT_URL=http://localhost:4180/oauth2/callback

# n8n (chain stack) - use HTTP not HTTPS  
WEBHOOK_URL=http://localhost:5678

# Gitea (code stack) - use HTTP not HTTPS
GITEA_ROOT_URL=http://localhost:3001
GITEA_SSH_DOMAIN=localhost
GITEA_INSTANCE_URL=http://localhost:3001
```

### 2. Updated Compose Files

Modified compose files to use the override variables with defaults:

**chain/compose.yaml:**
```yaml
# Before:
WEBHOOK_URL: https://${TRAEFIK_HOST_CHAIN}/

# After:
WEBHOOK_URL: ${WEBHOOK_URL:-https://${TRAEFIK_HOST_CHAIN}/}
```

**auth/compose.yaml:**
```yaml
# Before:
KC_HOSTNAME: https://${TRAEFIK_HOST_AUTH}
OAUTH2_PROXY_OIDC_ISSUER_URL: https://${TRAEFIK_HOST_AUTH}/realms/kompose
OAUTH2_PROXY_REDIRECT_URL: https://${TRAEFIK_HOST_OAUTH2}/oauth2/callback

# After:
KC_HOSTNAME: ${KC_HOSTNAME:-https://${TRAEFIK_HOST_AUTH}}
OAUTH2_PROXY_OIDC_ISSUER_URL: ${OAUTH2_PROXY_OIDC_ISSUER_URL:-https://${TRAEFIK_HOST_AUTH}/realms/kompose}
OAUTH2_PROXY_REDIRECT_URL: ${OAUTH2_PROXY_REDIRECT_URL:-https://${TRAEFIK_HOST_OAUTH2}/oauth2/callback}
```

**code/compose.yaml:**
```yaml
# Before:
GITEA__server__DOMAIN: ${TRAEFIK_HOST_CODE}
GITEA__server__SSH_DOMAIN: ${TRAEFIK_HOST_CODE}
GITEA__server__ROOT_URL: https://${TRAEFIK_HOST_CODE}/
GITEA_INSTANCE_URL: https://${TRAEFIK_HOST_CODE}

# After:
GITEA__server__DOMAIN: ${GITEA_SSH_DOMAIN:-${TRAEFIK_HOST_CODE}}
GITEA__server__SSH_DOMAIN: ${GITEA_SSH_DOMAIN:-${TRAEFIK_HOST_CODE}}
GITEA__server__ROOT_URL: ${GITEA_ROOT_URL:-https://${TRAEFIK_HOST_CODE}/}
GITEA_INSTANCE_URL: ${GITEA_INSTANCE_URL:-https://${TRAEFIK_HOST_CODE}}
```

## How It Works

### For Local Development (Current Setup)
- `.env` contains HTTP URLs: `WEBHOOK_URL=http://localhost:5678`
- Compose files use these: `WEBHOOK_URL: ${WEBHOOK_URL:-https://...}`
- Result: Services use **HTTP** URLs with **localhost**

### For Production (Future)
- `.env` doesn't define these variables (or sets them empty)
- Compose files fall back to default: `${WEBHOOK_URL:-https://${TRAEFIK_HOST_CHAIN}/}`
- Result: Services use **HTTPS** URLs with **domain names**

## Files Modified

1. ✅ `.env` - Added URL override variables
2. ✅ `chain/compose.yaml` - Updated WEBHOOK_URL
3. ✅ `auth/compose.yaml` - Updated KC_HOSTNAME and OAuth2 URLs  
4. ✅ `code/compose.yaml` - Updated Gitea URLs

## Testing

Now you can start all stacks without hanging:

```bash
# Start core services
./kompose.sh up core

# Start authentication (no longer hangs!)
./kompose.sh up auth

# Start chain stack (no longer hangs!)
./kompose.sh up chain

# Start code stack (no longer hangs!)
./kompose.sh up code

# Or start all at once
./kompose.sh up
```

## Services Available After Fix

| Service | URL | Stack |
|---------|-----|-------|
| Keycloak | http://localhost:8180 | auth |
| OAuth2 Proxy | http://localhost:4180 | auth |
| n8n | http://localhost:5678 | chain |
| Semaphore | http://localhost:3000 | chain |
| Gitea | http://localhost:3001 | code |
| PostgreSQL | localhost:5432 | core |
| Redis | localhost:6379 | core |
| MQTT | localhost:1883 | core |

## Verification

Test that the fix works:

```bash
# Check that variables are set
source .env
echo $WEBHOOK_URL
# Should output: http://localhost:5678

echo $KC_HOSTNAME
# Should output: http://localhost:8180

# Start chain stack
./kompose.sh up chain

# Check logs (should start without errors)
./kompose.sh logs chain -f
```

## Production Setup

When deploying to production with Traefik:

1. **Don't set** the URL override variables in `.env`
2. Or **comment them out**:
   ```bash
   # LOCAL DEVELOPMENT URL OVERRIDES - Comment out for production
   # WEBHOOK_URL=http://localhost:5678
   # KC_HOSTNAME=http://localhost:8180
   # etc.
   ```

3. The compose files will automatically use HTTPS with domain names:
   - `WEBHOOK_URL` → `https://chain.yourdomain.com/`
   - `KC_HOSTNAME` → `https://auth.yourdomain.com`
   - `GITEA_ROOT_URL` → `https://code.yourdomain.com/`

## Summary

✅ **Problem**: Services hung trying to use invalid HTTPS URLs in local development  
✅ **Solution**: Added HTTP URL overrides in `.env` with fallback defaults in compose files  
✅ **Result**: All stacks now start correctly in local development  
✅ **Bonus**: Production deployments still work with HTTPS URLs  

The fix is backward compatible and works for both local and production environments!
