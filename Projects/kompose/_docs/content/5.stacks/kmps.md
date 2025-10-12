# KMPS Stack

Kompose Management Portal - Web-based management interface for SSO and user administration.

## Overview

KMPS (Kompose Management Portal) provides a modern web interface for managing Keycloak users, clients, groups, and Kompose stacks. It offers:

- **Stack Monitoring** - Real-time monitoring and control of Kompose stacks
- **User Management** - Create, edit, delete users
- **Password Management** - Reset user passwords
- **Account Control** - Enable/disable accounts, verify emails
- **Dashboard** - Statistics and quick actions
- **API Integration** - RESTful API for automation
- **SSO Protected** - Secured with Keycloak authentication

## Architecture

```
┌─────────────────────────────────────────┐
│          KMPS Web Interface             │
│        (Next.js 14 + React)             │
└──────────┬──────────────────┬───────────┘
           │                  │
    ┌──────▼──────┐    ┌─────▼──────────┐
    │  NextAuth   │    │  Kompose API   │
    │ (Auth Layer)│    │   (REST API)   │
    └──────┬──────┘    └─────┬──────────┘
           │                  │
    ┌──────▼──────────┐       │
    │  Keycloak API   │       │
    │ (Admin Client)  │       │
    └──────┬──────────┘       │
           │                  │
    ┌──────▼──────────┐  ┌───▼──────────┐
    │    Keycloak     │  │ Docker Daemon│
    │  (Identity DB)  │  │   (Stacks)   │
    └─────────────────┘  └──────────────┘
```

## Services

### Kompose API Server
- **Runtime:** Python 3.11
- **Container:** `kmps_api`
- **Port:** 8080 (internal)
- **Purpose:** REST API for Kompose stack management
- **Features:** Start, stop, restart stacks, view logs
- **Access:** Internal only (not exposed externally)

### KMPS Application
- **Framework:** Next.js 14 with App Router
- **Container:** `kmps_app`
- **Port:** 3000 (internal)
- **Access:** `https://manage.yourdomain.com`
- **Authentication:** NextAuth with Keycloak provider
- **Database:** Uses Keycloak's PostgreSQL

## Quick Start

### 1. Deploy Auth Stack First

KMPS requires the auth stack to be running:

```bash
./kompose.sh up auth
```

### 2. Configure Keycloak Client

Access Keycloak admin: `https://auth.yourdomain.com`

**Create KMPS Admin Client:**

1. Navigate: **Clients → Create Client**
2. **General Settings:**
   - Client type: `OpenID Connect`
   - Client ID: `kmps-admin`
3. **Capability config:**
   - Client authentication: **ON**
   - Authorization: OFF
   - Authentication flow: Standard flow, Direct access grants
   - Service accounts roles: **ON** (Critical!)
4. **Login settings:**
   - Valid redirect URIs: `https://manage.yourdomain.com/*`
   - Valid post logout redirect URIs: `https://manage.yourdomain.com`
   - Web origins: `https://manage.yourdomain.com`
5. Save

**Copy Client Secret:**
1. Go to **Credentials** tab
2. Copy the **Client Secret**
3. Add to `secrets.env`:
   ```bash
   KMPS_CLIENT_SECRET=<client-secret-from-keycloak>
   ```

### 3. Assign Admin Roles

**Critical Step:** The KMPS client needs admin permissions to manage users.

1. Navigate: **Clients → kmps-admin → Service accounts roles**
2. Click **Assign role**
3. Filter by clients
4. Assign these roles:
   - `realm-admin` (full realm administration)
   - `manage-users` (user management)
   - `manage-clients` (client management)
   - `view-users` (view user list)
   - `view-clients` (view clients)
   - `query-users` (search users)
   - `query-groups` (search groups)

Without these roles, KMPS cannot manage users!

### 4. Configure KMPS Environment

Edit `kmps/.env`:

```bash
# Keycloak Configuration
KEYCLOAK_URL=https://auth.yourdomain.com
KEYCLOAK_REALM=kompose
KEYCLOAK_CLIENT_ID=kmps-admin
KEYCLOAK_CLIENT_SECRET=${KMPS_CLIENT_SECRET}

# NextAuth Configuration
NEXTAUTH_URL=https://manage.yourdomain.com
NEXTAUTH_SECRET=${KMPS_NEXTAUTH_SECRET}

# Application
NODE_ENV=production
APP_PORT=3000
```

Add to `secrets.env`:

```bash
KMPS_CLIENT_SECRET=<from-keycloak>
KMPS_NEXTAUTH_SECRET=$(openssl rand -base64 32)
```

### 5. Start KMPS

```bash
./kompose.sh up kmps

# Verify
./kompose.sh status kmps

# Check logs
./kompose.sh logs kmps -f
```

### 6. Access KMPS

Visit: `https://manage.yourdomain.com`

You'll be redirected to Keycloak for authentication. Use your Keycloak admin credentials or any user in the realm.

## Features

### Stack Monitoring

**Overview Dashboard:**
- Total stacks count
- Running stacks count
- Stopped stacks count
- System uptime ratio

**Stack Management:**
- **Start Stack** - Launch stopped services
- **Stop Stack** - Gracefully shutdown services
- **Restart Stack** - Restart all services in a stack
- **View Logs** - Real-time log streaming with download option

**Stack Cards:**
- Visual status indicators (running/stopped)
- Quick action buttons for each stack
- Stack descriptions and metadata
- Color-coded status badges

**Supported Stacks:**
- Core (Database, Redis, MQTT)
- Auth (Keycloak SSO)
- Code (Gitea, CI/CD)
- Home (Home Assistant)
- Chain (n8n, Automation)
- Messaging (Communication tools)
- Proxy (Traefik)
- VPN (WireGuard)
- And more...

### Dashboard

**Overview Statistics:**
- Total users count
- Active users count
- Total clients count
- Total groups count

**Recent Activity:**
- Recently created users
- Recent password resets
- User status changes

**Quick Actions:**
- Create new user
- View all users
- Manage clients
- Configure groups

### User Management

**List Users:**
- Searchable user list
- Filter by status (enabled/disabled)
- Pagination support
- Click user to view details

**Create User:**
1. Click **Create User** button
2. Fill in required fields:
   - Username (required)
   - Email (required)
   - First Name
   - Last Name
3. Optional settings:
   - Email verified
   - Enabled status
4. Submit

**Edit User:**
1. Click user in list
2. Click **Edit** button
3. Modify fields
4. Save changes

**Delete User:**
1. Click user in list
2. Click **Delete** button
3. Confirm deletion
4. User is permanently removed

**Reset Password:**
1. Click user in list
2. Click **Reset Password**
3. Enter new password
4. Choose if temporary (user must change on next login)
5. Submit

**Enable/Disable User:**
1. Edit user
2. Toggle **Enabled** switch
3. Save

**Verify Email:**
1. Edit user
2. Toggle **Email Verified** switch
3. Save

### Client Management (API Ready)

The Keycloak API integration supports client management:

```javascript
// List clients
GET /api/clients

// Get client
GET /api/clients/{id}

// Create client
POST /api/clients

// Update client
PUT /api/clients/{id}

// Delete client
DELETE /api/clients/{id}

// Regenerate secret
POST /api/clients/{id}/secret
```

**Note:** UI for client management is planned for future release.

### Group Management (API Ready)

The Keycloak API integration supports group management:

```javascript
// List groups
GET /api/groups

// Get group
GET /api/groups/{id}

// Create group
POST /api/groups

// Update group
PUT /api/groups/{id}

// Delete group
DELETE /api/groups/{id}

// Add user to group
POST /api/groups/{id}/members

// Remove user from group
DELETE /api/groups/{id}/members/{userId}
```

**Note:** UI for group management is planned for future release.

## API Endpoints

### Users API

**List Users:**
```bash
GET /api/users?search=john&max=100
```

Response:
```json
{
  "users": [
    {
      "id": "user-id",
      "username": "john.doe",
      "email": "john@example.com",
      "firstName": "John",
      "lastName": "Doe",
      "enabled": true,
      "emailVerified": true,
      "createdTimestamp": 1704067200000
    }
  ],
  "total": 1
}
```

**Get User:**
```bash
GET /api/users/{userId}
```

**Create User:**
```bash
POST /api/users
Content-Type: application/json

{
  "username": "jane.doe",
  "email": "jane@example.com",
  "firstName": "Jane",
  "lastName": "Doe",
  "enabled": true,
  "emailVerified": false
}
```

**Update User:**
```bash
PUT /api/users/{userId}
Content-Type: application/json

{
  "firstName": "Jane",
  "lastName": "Smith",
  "email": "jane.smith@example.com"
}
```

**Delete User:**
```bash
DELETE /api/users/{userId}
```

**Reset Password:**
```bash
POST /api/users/{userId}/reset-password
Content-Type: application/json

{
  "password": "newpassword123",
  "temporary": false
}
```

### Dashboard API

**Get Statistics:**
```bash
GET /api/dashboard/stats
```

Response:
```json
{
  "users": {
    "total": 42,
    "enabled": 38,
    "disabled": 4
  },
  "clients": {
    "total": 12
  },
  "groups": {
    "total": 5
  }
}
```

**Get Recent Users:**
```bash
GET /api/dashboard/recent-users
```

### Kompose Stack API

**List All Stacks:**
```bash
GET /api/kompose/stacks
```

Response:
```json
{
  "status": "success",
  "data": [
    {
      "name": "core",
      "description": "Core infrastructure services",
      "url": "/api/stacks/core"
    }
  ]
}
```

**Get Stack Status:**
```bash
GET /api/kompose/stacks/{name}
```

**Start Stack:**
```bash
POST /api/kompose/stacks/{name}/start
```

**Stop Stack:**
```bash
POST /api/kompose/stacks/{name}/stop
```

**Restart Stack:**
```bash
POST /api/kompose/stacks/{name}/restart
```

**Get Stack Logs:**
```bash
GET /api/kompose/stacks/{name}/logs
```

Response:
```json
{
  "status": "success",
  "data": {
    "stack": "core",
    "logs": "[logs content here]",
    "lines": 100
  }
}
```

## Development

### Local Development

```bash
cd kmps/app

# Install dependencies
npm install

# Run development server
npm run dev

# Access at http://localhost:3000
```

### Environment Variables

```bash
# Development
NODE_ENV=development
KEYCLOAK_URL=http://localhost:8080
NEXTAUTH_URL=http://localhost:3000

# Production
NODE_ENV=production
KEYCLOAK_URL=https://auth.yourdomain.com
NEXTAUTH_URL=https://manage.yourdomain.com
```

### Build for Production

```bash
cd kmps/app

# Build
npm run build

# Start production server
npm start

# Or use Docker
docker-compose up --build
```

## Technology Stack

**Frontend:**
- Next.js 14 (App Router)
- React 18
- TypeScript
- Tailwind CSS
- Lucide React (icons)

**Authentication:**
- NextAuth.js
- Keycloak provider

**API Integration:**
- Keycloak Admin API
- REST endpoints

## Troubleshooting

### Can't Login to KMPS

**Check auth stack is running:**
```bash
./kompose.sh status auth
docker logs auth_keycloak
```

**Verify client configuration:**
1. Client ID matches: `kmps-admin`
2. Client secret matches in both Keycloak and `secrets.env`
3. Redirect URIs are correct
4. Client authentication is enabled

**Check NextAuth configuration:**
```bash
docker logs kmps_app | grep -i nextauth
```

### Users API Returns Errors

**Verify KMPS client has admin roles:**
```bash
# In Keycloak admin
# Clients → kmps-admin → Service accounts roles
# Must have: realm-admin, manage-users, view-users
```

**Check client secret:**
```bash
# In kmps/.env
echo $KMPS_CLIENT_SECRET

# Should match Keycloak client secret
```

**Review logs:**
```bash
docker logs kmps_app | grep -i error
```

### Page Won't Load

**Check container status:**
```bash
docker ps | grep kmps_app
```

**Verify Traefik routing:**
```bash
docker logs proxy_app | grep kmps
```

**Check browser console:**
- Open browser DevTools
- Check Console tab for errors
- Check Network tab for failed requests

### Authentication Loop

**Clear cookies:**
```bash
# In browser:
# DevTools → Application → Cookies
# Delete all cookies for your domain
```

**Verify NEXTAUTH_URL:**
```bash
# Must match the public URL exactly
NEXTAUTH_URL=https://manage.yourdomain.com  # Not http://
```

## Security

### Best Practices

1. **Strong Client Secret:** Use `openssl rand -base64 32`
2. **HTTPS Only:** Never use HTTP in production
3. **Restrict Access:** Use SSO middleware
4. **Audit Logs:** Monitor user management actions
5. **Role-Based Access:** Limit admin roles to necessary users
6. **Regular Updates:** Keep Next.js and dependencies updated

### Access Control

**Restrict KMPS Access:**

Edit `kmps/compose.yaml`:

```yaml
labels:
  # Change from sso-secure to sso-internal-only
  - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.middlewares=sso-internal-only'
```

This adds IP whitelisting on top of SSO.

### Audit Actions

All user management actions are logged:

```bash
# View Keycloak admin events
# Keycloak Admin → Events → Admin events

# View KMPS logs
docker logs kmps_app | grep -i "user|client|group"
```

## Future Enhancements

**Planned Features:**
- Client management UI
- Group management UI
- Role assignment interface
- Bulk user operations (import/export)
- User activity dashboard
- 2FA management interface
- Custom email templates
- Advanced search and filters
- User federation configuration
- Identity provider management

## See Also

- [SSO Integration Guide](/guide/sso-integration)
- [SSO Quick Reference](/reference/sso-quick-reference)
- [Auth Stack](/stacks/auth)
- [Keycloak Documentation](https://www.keycloak.org/documentation)
