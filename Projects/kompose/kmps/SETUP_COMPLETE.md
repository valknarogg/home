# KMPS Stack - Setup Complete! ✅

All fixes have been applied to get the KMPS (Kompose Management Portal) stack up and running properly.

## What Was Fixed

### 1. Domain Configuration ✅
**File:** `domain.env`
- Added `SUBDOMAIN_MANAGE=manage` for the KMPS management portal
- Creates URL: `https://manage.pivoine.art`

### 2. Environment Configuration ✅
**File:** `.env`
- Added `TRAEFIK_HOST_MANAGE` variable
- Expanded KMPS section with proper configuration:
  - `KMPS_TRAEFIK_HOST` - Traefik routing
  - `KMPS_APP_PORT=3100` - Application port
  - `KMPS_API_PORT=8080` - API server port
  - `KMPS_CLIENT_ID=kmps-admin` - Keycloak client ID
  - `KMPS_REALM=kompose` - Keycloak realm

### 3. Secrets Template ✅
**File:** `secrets.env.template`
- Added KMPS secrets section:
  - `KMPS_CLIENT_SECRET` - Keycloak client credential
  - `KMPS_NEXTAUTH_SECRET` - Session encryption key

### 4. Secrets File ✅
**File:** `secrets.env` (created)
- Created initial secrets.env with placeholders
- Includes all necessary secrets for KMPS and other stacks
- **ACTION REQUIRED:** You need to:
  1. Generate `KMPS_NEXTAUTH_SECRET`: `openssl rand -base64 32`
  2. Get `KMPS_CLIENT_SECRET` from Keycloak after client setup

### 5. Docker Compose Configuration ✅
**File:** `kmps/compose.yaml`

**Fixed volume mount:**
- ❌ Before: `./app:/app` (directory didn't exist)
- ✅ After: `.:/app` (mounts entire kmps directory)

**Fixed environment variables:**
- Changed all `${TRAEFIK_HOST}` to `${KMPS_TRAEFIK_HOST}`
- Changed `${NEXTAUTH_SECRET}` to `${KMPS_NEXTAUTH_SECRET}`
- Changed `${APP_PORT}` to `${KMPS_APP_PORT:-3100}`
- Added `KMPS_REALM` variable usage
- Added `APP_PORT` environment variable for the container

**Result:** The app will now mount correctly and use proper scoped variables.

### 6. Documentation ✅
**File:** `_docs/content/5.stacks/kmps.md`
- Updated setup instructions with correct configuration approach
- Fixed environment variable documentation
- Updated development section
- Added references to centralized configuration

### 7. Development Guide ✅
**File:** `kmps/DEVELOPMENT.md` (created)
- Comprehensive development setup guide
- Step-by-step Keycloak client configuration
- Troubleshooting section
- Both local and Docker development workflows
- Complete environment variables reference

## Next Steps

### 1. Generate Secrets

Generate the NextAuth secret:

```bash
# Generate and add to secrets.env
echo "KMPS_NEXTAUTH_SECRET=$(openssl rand -base64 32)" >> secrets.env
```

### 2. Start Required Stacks

```bash
# Start core services (PostgreSQL, Redis, MQTT)
./kompose.sh up core

# Start auth services (Keycloak, OAuth2 Proxy)
./kompose.sh up auth

# Wait for services to be healthy
./kompose.sh status core
./kompose.sh status auth
```

### 3. Configure Keycloak Client

Follow the detailed instructions in `kmps/DEVELOPMENT.md` or the main documentation:

1. Access Keycloak admin at `https://auth.pivoine.art`
2. Create client `kmps-admin` with:
   - Client authentication: **ON**
   - Service accounts roles: **ON**
   - Valid redirect URIs: `https://manage.pivoine.art/*` and `http://localhost:3100/*`
3. Copy the client secret from Credentials tab
4. Add to secrets.env: `KMPS_CLIENT_SECRET=<your-secret>`
5. Assign admin roles to service account:
   - realm-admin
   - manage-users
   - view-users
   - query-users
   - And other management roles

### 4. Start KMPS

#### Option A: Docker (Production-like)
```bash
./kompose.sh up kmps
./kompose.sh logs kmps -f
```

Access at: `https://manage.pivoine.art`

#### Option B: Local Development
```bash
cd /home/valknar/Projects/kompose/kmps

# Install dependencies
npm install

# Set environment variables (or source from secrets.env)
export NODE_ENV=development
export KEYCLOAK_URL=https://auth.pivoine.art
export KEYCLOAK_REALM=kompose
export KEYCLOAK_CLIENT_ID=kmps-admin
export KEYCLOAK_CLIENT_SECRET="<from-secrets.env>"
export NEXTAUTH_URL=http://localhost:3100
export NEXTAUTH_SECRET="<from-secrets.env>"
export KOMPOSE_API_URL=http://localhost:8080

# Run development server
npm run dev
```

Access at: `http://localhost:3100`

## Verification Checklist

- [ ] Core stack is running (`./kompose.sh status core`)
- [ ] Auth stack is running (`./kompose.sh status auth`)
- [ ] Keycloak is accessible at `https://auth.pivoine.art`
- [ ] KMPS client created in Keycloak with ID `kmps-admin`
- [ ] Client authentication is enabled
- [ ] Service accounts roles are enabled
- [ ] Admin roles assigned to service account
- [ ] Client secret copied to `secrets.env`
- [ ] NextAuth secret generated and added to `secrets.env`
- [ ] KMPS stack started successfully
- [ ] Can access KMPS UI at `https://manage.pivoine.art` or `http://localhost:3100`
- [ ] Can login through Keycloak SSO
- [ ] Dashboard loads and shows statistics
- [ ] Can view users list
- [ ] Can manage stacks

## Architecture Overview

```
┌─────────────────────────────────────────┐
│    KMPS Web UI (Next.js 14)             │
│    Port: 3100                           │
│    URL: https://manage.pivoine.art      │
└──────────┬──────────────────┬───────────┘
           │                  │
    ┌──────▼──────┐    ┌─────▼──────────┐
    │  NextAuth   │    │  Kompose API   │
    │  (Keycloak) │    │  Port: 8080    │
    └──────┬──────┘    └─────┬──────────┘
           │                  │
    ┌──────▼──────────┐       │
    │    Keycloak     │       │
    │ Admin REST API  │       │
    └──────┬──────────┘       │
           │                  │
    ┌──────▼──────────┐  ┌───▼──────────┐
    │  PostgreSQL DB  │  │ Docker Daemon│
    │  (user data)    │  │   (stacks)   │
    └─────────────────┘  └──────────────┘
```

## File Structure

```
kompose/
├── .env                          # ✅ KMPS config added
├── domain.env                    # ✅ SUBDOMAIN_MANAGE added
├── secrets.env                   # ✅ Created with placeholders
├── secrets.env.template          # ✅ KMPS secrets added
├── _docs/
│   └── content/
│       └── 5.stacks/
│           └── kmps.md          # ✅ Updated documentation
└── kmps/
    ├── compose.yaml             # ✅ Fixed volume mount & env vars
    ├── package.json             # ✓ Already correct (port 3100)
    ├── DEVELOPMENT.md           # ✅ Created comprehensive guide
    ├── src/
    │   ├── app/                 # ✓ Next.js app routes
    │   ├── components/          # ✓ React components
    │   └── lib/                 # ✓ Keycloak integration
    └── .env.generated           # ✓ Auto-generated from root .env
```

## Common Issues & Solutions

### "Module not found" errors
```bash
cd /home/valknar/Projects/kompose/kmps
rm -rf node_modules package-lock.json
npm install
```

### Authentication loop
1. Clear browser cookies for localhost:3100
2. Verify NEXTAUTH_URL matches exactly
3. Check Keycloak redirect URIs include localhost:3100/*

### "Failed to fetch users"
1. Verify service account roles in Keycloak
2. Check KMPS_CLIENT_SECRET matches
3. Ensure client authentication is ON
4. Review logs: `docker logs kmps_app`

### Port 3100 already in use
```bash
# Find what's using it
lsof -i :3100

# Or change port in package.json
"dev": "next dev -p 3101"
```

## Resources

- **Main Documentation:** `_docs/content/5.stacks/kmps.md`
- **Development Guide:** `kmps/DEVELOPMENT.md`
- **Quick Reference:** `kmps/QUICK_REFERENCE.md`
- **Stack Monitoring:** `kmps/STACK_MONITORING_README.md`

## Support

If you encounter any issues:

1. Check the logs: `./kompose.sh logs kmps -f`
2. Verify environment: `./kompose.sh env kmps`
3. Review the development guide: `kmps/DEVELOPMENT.md`
4. Check Keycloak configuration
5. Verify secrets.env has all required values

---

**Status:** ✅ All configuration fixes applied!
**Next Action:** Follow "Next Steps" above to configure Keycloak and start KMPS
**Estimated Setup Time:** 15-20 minutes
