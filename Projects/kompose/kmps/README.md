# KMPS - Kompose Management Portal & SSO

**K**ompose **M**anagement **P**ortal & **S**SO Administration

A web-based management interface for Kompose SSO, powered by Keycloak.

## 🎯 Features

- 👥 **User Management**: Create, edit, and delete users
- 🔑 **Client Management**: Manage OAuth2/OIDC clients
- 👪 **Group Management**: Organize users into groups
- 🎭 **Role Management**: Assign roles and permissions
- 📊 **Dashboard**: Overview of users, clients, and sessions
- 🔐 **SSO Protected**: Secured via Keycloak SSO
- 🎨 **Modern UI**: Built with Next.js and Tailwind CSS

## 🚀 Getting Started

### Prerequisites

- Kompose auth stack running (Keycloak + OAuth2 Proxy)
- Redis (core stack) for session storage
- PostgreSQL database for KMPS data

### Installation

1. **Configure environment variables**

   Update `/home/valknar/Projects/kompose/.env`:
   ```bash
   BASE_DOMAIN=yourdomain.com
   TRAEFIK_HOST_KMPS=manage.yourdomain.com
   ```

   Update `/home/valknar/Projects/kompose/secrets.env`:
   ```bash
   KMPS_CLIENT_SECRET=<generate-with-openssl>
   KMPS_NEXTAUTH_SECRET=$(openssl rand -base64 32)
   ```

2. **Create KMPS client in Keycloak**

   a. Login to Keycloak admin console: `https://auth.yourdomain.com`
   
   b. Select "kompose" realm
   
   c. Go to: Clients → Create Client
   
   d. Configure:
      - Client type: OpenID Connect
      - Client ID: `kmps-admin`
      - Client authentication: ON
      - Service accounts roles: ON (for admin API)
      - Valid redirect URIs: `https://manage.yourdomain.com/*`
   
   e. Save the client secret to `secrets.env`
   
   f. Assign admin roles:
      - Go to: Service accounts roles
      - Assign: `realm-admin`, `manage-users`, `manage-clients`

3. **Deploy KMPS stack**

   ```bash
   cd /home/valknar/Projects/kompose
   ./kompose.sh up kmps
   ```

4. **Access the portal**

   Navigate to: `https://manage.yourdomain.com`

## 📖 Usage

### User Management

**Create a User**
1. Navigate to Users → Add User
2. Fill in required fields (username, email)
3. Optionally set password immediately
4. Assign to groups (optional)
5. Click Create

**Edit a User**
1. Navigate to Users
2. Click on username
3. Modify fields
4. Click Save

**Reset User Password**
1. Navigate to Users → [username] → Credentials
2. Click "Reset Password"
3. Enter new password
4. Choose if temporary
5. Save

### Client Management

**Create an OAuth2 Client**
1. Navigate to Clients → Add Client
2. Configure:
   - Client ID
   - Client type (confidential/public)
   - Redirect URIs
   - Capabilities (authentication, authorization, etc.)
3. Save
4. Note the client secret (if confidential)

### Group Management

**Create a Group**
1. Navigate to Groups → Create Group
2. Enter group name
3. Optionally set parent group
4. Save

**Assign Users to Group**
1. Navigate to Users → [username] → Groups
2. Select available groups
3. Click Join

**Assign Roles to Group**
1. Navigate to Groups → [group] → Role Mappings
2. Select roles to assign
3. All group members inherit these roles

## 🔧 Configuration

### Environment Variables

Located in `kmps/.env`:

```bash
# Stack Configuration
COMPOSE_PROJECT_NAME=kmps
DOCKER_IMAGE=node:20-alpine
DB_NAME=kmps
APP_PORT=3100

# Traefik
TRAEFIK_HOST=${TRAEFIK_HOST_KMPS}

# Keycloak Admin API
KMPS_CLIENT_ID=kmps-admin

# From secrets.env:
# - KMPS_CLIENT_SECRET
# - KMPS_NEXTAUTH_SECRET
```

### Keycloak Integration

KMPS uses the Keycloak Admin REST API for all operations:

- Base URL: `https://auth.yourdomain.com`
- Realm: `kompose`
- Authentication: Service Account with admin roles

API documentation: https://www.keycloak.org/docs-api/latest/rest-api/

## 🎨 Development

### Local Development

1. **Install dependencies**
   ```bash
   cd /home/valknar/Projects/kompose/kmps/app
   npm install
   ```

2. **Run development server**
   ```bash
   npm run dev
   ```

3. **Access locally**
   ```
   http://localhost:3100
   ```

### Building for Production

```bash
cd /home/valknar/Projects/kompose/kmps/app
npm run build
npm run start
```

### Tech Stack

- **Frontend**: Next.js 14, React 18
- **Styling**: Tailwind CSS
- **Authentication**: NextAuth.js with Keycloak provider
- **API Client**: Keycloak Admin Client
- **Icons**: Lucide React
- **State Management**: SWR for data fetching

## 📊 API Routes

KMPS exposes several API routes for frontend consumption:

### Users
- `GET /api/users` - List all users
- `POST /api/users` - Create user
- `GET /api/users/:id` - Get user details
- `PUT /api/users/:id` - Update user
- `DELETE /api/users/:id` - Delete user
- `POST /api/users/:id/reset-password` - Reset password

### Clients
- `GET /api/clients` - List all clients
- `POST /api/clients` - Create client
- `GET /api/clients/:id` - Get client details
- `PUT /api/clients/:id` - Update client
- `DELETE /api/clients/:id` - Delete client

### Groups
- `GET /api/groups` - List all groups
- `POST /api/groups` - Create group
- `GET /api/groups/:id` - Get group details
- `PUT /api/groups/:id` - Update group
- `DELETE /api/groups/:id` - Delete group

### Dashboard
- `GET /api/dashboard/stats` - Get overview statistics
- `GET /api/dashboard/recent-users` - Recent user activity

## 🔐 Security

### Authentication

- All routes protected by NextAuth.js
- SSO via Keycloak required for access
- Session stored in Redis (via OAuth2 Proxy)

### Authorization

- Only users with `realm-admin` role can access
- Service account used for Keycloak Admin API calls
- HTTPS enforced via Traefik

### Best Practices

- Never expose client secrets in frontend
- Use service account for backend API calls
- Validate all inputs server-side
- Implement CSRF protection (built-in with Next.js)
- Rate limiting via Traefik middleware

## 🐛 Troubleshooting

### Issue: Cannot access KMPS

**Check if stack is running:**
```bash
./kompose.sh status kmps
```

**Check logs:**
```bash
./kompose.sh logs kmps -f
```

### Issue: "Unauthorized" when accessing users

**Verify Keycloak client configuration:**
- Check client ID matches `kmps-admin`
- Ensure service account has admin roles
- Verify client secret in secrets.env

### Issue: "Failed to connect to Keycloak"

**Check auth stack:**
```bash
./kompose.sh status auth
```

**Verify Keycloak URL:**
- Ensure `TRAEFIK_HOST_AUTH` is correct
- Check Keycloak is accessible: `curl https://auth.yourdomain.com`

### Issue: Portal loads but API calls fail

**Check browser console for errors**

**Verify environment variables:**
```bash
cd /home/valknar/Projects/kompose/kmps
docker-compose config
```

**Check API connectivity:**
```bash
./kompose.sh exec kmps wget -O- http://localhost:3100/api/health
```

## 📚 Documentation

- [Keycloak Admin REST API](https://www.keycloak.org/docs-api/latest/rest-api/)
- [Next.js Documentation](https://nextjs.org/docs)
- [NextAuth.js Documentation](https://next-auth.js.org/)
- [Traefik Documentation](https://doc.traefik.io/traefik/)

## 🔄 Updates

### Updating the Portal

```bash
cd /home/valknar/Projects/kompose/kmps
./kompose.sh pull kmps
./kompose.sh restart kmps
```

### Database Migrations

KMPS uses PostgreSQL for storing portal-specific data (audit logs, preferences, etc.). Keycloak data remains in its own database.

```bash
# Backup before migration
./kompose.sh db backup -d kmps

# Run migrations (auto-runs on startup)
./kompose.sh restart kmps
```

## 🤝 Contributing

This is part of the Kompose project. See main [CONTRIBUTING.md](../CONTRIBUTING.md).

## 📝 License

MIT License - see [LICENSE](../LICENSE)

---

**Version**: 1.0.0  
**Last Updated**: October 2025  
**Kompose Stack**: SSO Integration
