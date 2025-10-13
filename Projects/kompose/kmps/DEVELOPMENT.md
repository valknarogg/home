# KMPS Development Setup Guide

This guide will help you set up KMPS for local development.

## Prerequisites

- Docker and Docker Compose installed
- Node.js 20+ and npm/pnpm installed
- Auth stack (Keycloak) must be running
- Access to Keycloak admin panel

## Quick Start

### 1. Start Required Services

First, ensure the core and auth stacks are running:

```bash
# From project root
cd /home/valknar/Projects/kompose

# Start core services (PostgreSQL, Redis, MQTT)
./kompose.sh up core

# Start auth services (Keycloak, OAuth2 Proxy)
./kompose.sh up auth

# Wait for services to be healthy
./kompose.sh status core
./kompose.sh status auth
```

### 2. Configure Keycloak Client

Access Keycloak admin panel at `https://auth.pivoine.art` (or your configured auth domain):

**Login:** admin / [your KC_ADMIN_PASSWORD from secrets.env]

#### Create KMPS Client

1. Navigate to **Clients → Create Client**
2. **General Settings:**
   - Client type: `OpenID Connect`
   - Client ID: `kmps-admin`
   - Name: `Kompose Management Portal`
   - Description: `Admin client for KMPS user and stack management`

3. **Capability config:**
   - ✅ Client authentication: **ON** (Critical!)
   - ❌ Authorization: OFF
   - ✅ Standard flow
   - ✅ Direct access grants
   - ✅ Service accounts roles: **ON** (Critical for admin API access!)

4. **Login settings:**
   - Root URL: `https://manage.pivoine.art`
   - Valid redirect URIs: 
     - `https://manage.pivoine.art/*`
     - `http://localhost:3100/*` (for development)
   - Valid post logout redirect URIs: 
     - `https://manage.pivoine.art`
     - `http://localhost:3100`
   - Web origins: 
     - `https://manage.pivoine.art`
     - `http://localhost:3100`

5. Click **Save**

#### Get Client Secret

1. Go to the **Credentials** tab
2. Copy the **Client Secret** value
3. Update `secrets.env`:
   ```bash
   KMPS_CLIENT_SECRET=<paste-the-client-secret-here>
   ```

#### Assign Admin Roles

**Critical Step:** The service account needs admin permissions.

1. Navigate to **Clients → kmps-admin → Service accounts roles** tab
2. Click **Assign role**
3. Click **Filter by clients** dropdown
4. Find and select `realm-management` roles
5. Assign these roles:
   - ✅ `realm-admin` - Full realm administration
   - ✅ `manage-users` - Create, update, delete users
   - ✅ `manage-clients` - Manage OAuth clients
   - ✅ `view-users` - View user list
   - ✅ `view-clients` - View client list
   - ✅ `query-users` - Search users
   - ✅ `query-groups` - Search groups

### 3. Generate NextAuth Secret

Generate a secure secret for NextAuth session encryption:

```bash
# Generate secret
openssl rand -base64 32

# Add to secrets.env
echo "KMPS_NEXTAUTH_SECRET=$(openssl rand -base64 32)" >> secrets.env
```

### 4. Development Mode Options

You have two options for running KMPS in development:

#### Option A: Local Development (Recommended for development)

Run Next.js development server directly on your machine:

```bash
cd /home/valknar/Projects/kompose/kmps

# Install dependencies (first time only)
npm install
# or
pnpm install

# Set development environment variables
export NODE_ENV=development
export KEYCLOAK_URL=https://auth.pivoine.art
export KEYCLOAK_REALM=kompose
export KEYCLOAK_CLIENT_ID=kmps-admin
export KEYCLOAK_CLIENT_SECRET="<your-client-secret>"
export NEXTAUTH_URL=http://localhost:3100
export NEXTAUTH_SECRET="<your-nextauth-secret>"
export KOMPOSE_API_URL=http://localhost:8080

# Start development server
npm run dev

# Access at http://localhost:3100
```

**Advantages:**
- Hot module reloading
- Faster iteration
- Better debugging with source maps
- No Docker overhead

#### Option B: Docker Development

Run through Docker Compose with live reloading:

```bash
# From project root
./kompose.sh up kmps

# View logs
./kompose.sh logs kmps -f
```

The compose.yaml is configured to:
- Mount the entire kmps directory to `/app`
- Run `npm install && npm run dev` automatically
- Use port 3100
- Connect to the kompose network

**Advantages:**
- Matches production environment
- Tests Docker configuration
- Easier for team consistency

### 5. Verify Setup

#### Check Services

```bash
# Check if services are running
docker ps | grep kmps

# Check logs
docker logs kmps_app
docker logs kmps_api
```

#### Test API Endpoints

```bash
# Health check
curl http://localhost:3100/api/health

# Test Keycloak connection
curl http://localhost:3100/api/users
```

#### Access the UI

1. Open browser to `http://localhost:3100`
2. You'll be redirected to Keycloak login
3. Login with your Keycloak user credentials
4. You should see the KMPS dashboard

## Troubleshooting

### Authentication Loop

**Problem:** Redirects keep looping between KMPS and Keycloak

**Solutions:**
1. Clear browser cookies for `localhost:3100`
2. Verify `NEXTAUTH_URL` matches exactly (no trailing slash)
3. Check redirect URIs in Keycloak client include `http://localhost:3100/*`
4. Verify `KMPS_NEXTAUTH_SECRET` is set and not empty

### "Failed to fetch users" Error

**Problem:** API returns 403 or empty results

**Solutions:**
1. Verify service account roles are assigned in Keycloak
2. Check `KMPS_CLIENT_SECRET` matches Keycloak
3. Verify client authentication is ON
4. Check service accounts roles are ON
5. Review logs: `docker logs kmps_app | grep -i error`

### Cannot Connect to Keycloak

**Problem:** "Connection refused" or timeout errors

**Solutions:**
1. Verify auth stack is running: `./kompose.sh status auth`
2. Check Keycloak is accessible: `curl https://auth.pivoine.art`
3. Verify `KEYCLOAK_URL` in environment
4. Check Docker network connectivity
5. For local dev, ensure DNS resolves correctly

### Port Already in Use

**Problem:** Port 3100 is already bound

**Solutions:**
```bash
# Find process using port
lsof -i :3100

# Kill process or change port in package.json
npm run dev -- -p 3101
```

### Module Not Found Errors

**Problem:** Import errors for packages

**Solutions:**
```bash
# Clean install
rm -rf node_modules package-lock.json
npm install

# Or with pnpm
rm -rf node_modules pnpm-lock.yaml
pnpm install
```

## Development Workflow

### Making Changes

1. **Edit source files** in `src/` directory
2. **See changes** automatically with hot reload
3. **Check logs** for errors
4. **Test in browser**

### Adding Features

1. **Frontend components** → `src/components/`
2. **API routes** → `src/app/api/`
3. **Pages** → `src/app/`
4. **Utilities** → `src/lib/`

### Testing API Changes

```bash
# Test with curl
curl -X GET http://localhost:3100/api/users

# Test with auth
curl -X GET http://localhost:3100/api/users \
  -H "Cookie: next-auth.session-token=<token>"
```

### Database Access

KMPS uses Keycloak's PostgreSQL database:

```bash
# Connect to database
docker exec -it core_postgres psql -U valknar -d keycloak

# Query users
SELECT id, username, email, enabled FROM user_entity;
```

## Production Deployment

Once development is complete:

1. **Update secrets.env** with production values
2. **Set NODE_ENV=production** in compose.yaml
3. **Build and start:**
   ```bash
   ./kompose.sh up kmps
   ```
4. **Verify:** Access at `https://manage.pivoine.art`

## Environment Variables Reference

### Required in Development

```bash
# Keycloak Configuration
KEYCLOAK_URL=https://auth.pivoine.art
KEYCLOAK_REALM=kompose
KEYCLOAK_CLIENT_ID=kmps-admin
KEYCLOAK_CLIENT_SECRET=<from-keycloak>

# NextAuth Configuration
NEXTAUTH_URL=http://localhost:3100  # or https://manage.pivoine.art
NEXTAUTH_SECRET=<generate-with-openssl>

# Kompose API
KOMPOSE_API_URL=http://localhost:8080
```

### Optional

```bash
# Development settings
NODE_ENV=development
DEBUG=true

# Database (if needed)
DATABASE_URL=postgresql://valknar:password@localhost:5432/kmps
```

## Next Steps

- Review the [KMPS Stack Documentation](_docs/content/5.stacks/kmps.md)
- Check the [API Reference](kmps/QUICK_REFERENCE.md)
- Explore example workflows in the UI
- Set up additional Keycloak clients for testing

## Support

If you encounter issues:

1. Check logs: `docker logs kmps_app -f`
2. Verify configuration: `./kompose.sh env kmps`
3. Test connectivity: `./kompose.sh test kmps`
4. Review documentation: `_docs/content/5.stacks/kmps.md`
