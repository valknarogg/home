# Traefik Host Variable Fix for Local Development

## Problem

The `kompose.sh up` command hangs at the chain stack because:

1. Compose files construct URLs like `https://${TRAEFIK_HOST_CHAIN}/`
2. With `TRAEFIK_HOST_CHAIN=localhost:5678`, this becomes `https://localhost:5678/`
3. This is invalid for local development - should be `http://localhost:5678/`
4. Services hang trying to validate or connect to these HTTPS URLs without SSL certificates

## Files Affected

Compose files that construct HTTPS URLs from TRAEFIK_HOST variables:

- `auth/compose.yaml` - Uses `KC_HOSTNAME: https://${TRAEFIK_HOST_AUTH}`
- `chain/compose.yaml` - Uses `WEBHOOK_URL: https://${TRAEFIK_HOST_CHAIN}/`
- `code/compose.yaml` - Uses `GITEA__server__ROOT_URL: https://${TRAEFIK_HOST_CODE}/`
- `home/compose.yaml` - Uses HTTPS in Traefik labels
- `kmps/compose.yaml` - Likely uses similar patterns
- `messaging/compose.yaml` - Likely uses similar patterns
- `link/compose.yaml` - Likely uses similar patterns
- `track/compose.yaml` - Likely uses similar patterns
- `vault/compose.yaml` - Likely uses similar patterns

## Solution Options

### Option 1: Disable HTTPS URL Validation (Quick Fix)

For local development without Traefik, these services may not need URL validation. You can:

1. Skip problematic stacks initially
2. Start core services first:
   ```bash
   ./kompose.sh up core
   ```

3. Start only stacks that work in local mode:
   ```bash
   # These should work:
   ./kompose.sh up core
   
   # These might need Traefik or URL fixes:
   # ./kompose.sh up chain  # Hangs - n8n needs webhook URL
   # ./kompose.sh up auth   # Might hang - Keycloak needs hostname
   # ./kompose.sh up code   # Might hang - Gitea needs root URL
   ```

### Option 2: Add URL Override Variables (Recommended)

Add these to `.env` file to override the HTTPS URLs for local development:

```bash
# Local development URL overrides (use HTTP, not HTTPS)
KC_HOSTNAME=http://localhost:8180
N8N_WEBHOOK_URL=http://localhost:5678
GITEA_ROOT_URL=http://localhost:3001
```

### Option 3: Create Local-Specific Compose Overrides

Create `docker-compose.override.yaml` files in each stack for local development that override the HTTPS URLs with HTTP.

### Option 4: Update Compose Files

Modify compose files to use conditional URLs based on environment. Change:
```yaml
KC_HOSTNAME: https://${TRAEFIK_HOST_AUTH}
```

To:
```yaml
KC_HOSTNAME: ${KC_HOSTNAME:-https://${TRAEFIK_HOST_AUTH}}
```

Then in `.env` for local dev:
```bash
KC_HOSTNAME=http://localhost:8180
```

## Immediate Workaround

For now, to avoid hanging:

### 1. Start Core Services Only
```bash
# Core works fine - no URL issues
./kompose.sh up core

# Wait for services to be ready
sleep 10
```

### 2. Skip Problematic Stacks

Don't start these until URLs are fixed:
- ❌ `chain` - n8n needs webhook URL fix
- ❌ `auth` - Keycloak needs hostname fix  
- ❌ `code` - Gitea needs root URL fix

### 3. Test Simple Stacks

These should work without URL issues:
- ✅ `core` - No external URLs
- ✅ `proxy` - Traefik (but not needed for local)
- ✅ `messaging` - Gotify/Mailhog should work

## Recommended Fix

Add these URL overrides to your `.env` file after the TRAEFIK_HOST variables:

```bash
# ===================================================================
# LOCAL DEVELOPMENT URL OVERRIDES
# ===================================================================
# Override HTTPS URLs with HTTP for local development
# These are used by services that construct full URLs

# Keycloak (auth stack)
KC_HOSTNAME=http://localhost:8180
OAUTH2_PROXY_OIDC_ISSUER_URL=http://localhost:8180/realms/kompose
OAUTH2_PROXY_REDIRECT_URL=http://localhost:4180/oauth2/callback

# n8n (chain stack)  
N8N_WEBHOOK_URL=http://localhost:5678

# Gitea (code stack)
GITEA_ROOT_URL=http://localhost:3001
GITEA_SSH_DOMAIN=localhost
GITEA_INSTANCE_URL=http://localhost:3001

# Base domain for cookies/OAuth
BASE_DOMAIN=localhost
```

Then update compose files to use these variables with defaults:

```yaml
# Instead of:
KC_HOSTNAME: https://${TRAEFIK_HOST_AUTH}

# Use:
KC_HOSTNAME: ${KC_HOSTNAME:-https://${TRAEFIK_HOST_AUTH}}
```

## Testing After Fix

```bash
# Test core services
./kompose.sh up core
./kompose.sh status core

# Test auth with URL fixes
./kompose.sh up auth
./kompose.sh logs auth -f

# Test chain with URL fixes
./kompose.sh up chain
./kompose.sh logs chain -f
```

## Status

- ⏳ **Pending**: Compose file updates to support local HTTP URLs
- ⏳ **Pending**: URL override variables in .env
- ✅ **Working**: Core stack (no URL dependencies)
- ❌ **Broken**: Chain, auth, code stacks (URL issues)

Would you like me to implement Option 4 (update compose files) or Option 2 (add URL overrides)?
