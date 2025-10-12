# KMPS Quick Start Guide

This guide will help you get KMPS up and running quickly with proper SSO configuration.

## 📋 Prerequisites

Before starting, ensure you have:

- ✅ Docker and Docker Compose installed
- ✅ Kompose project cloned
- ✅ Domain or subdomain configured (e.g., `manage.yourdomain.com`)
- ✅ SSL certificates (handled by Traefik)

## 🚀 Step-by-Step Setup

### Step 1: Start Required Stacks

KMPS depends on several other stacks. Start them in order:

```bash
cd /home/valknar/Projects/kompose

# 1. Start proxy (Traefik) for routing and SSL
./kompose.sh up proxy

# 2. Start core services (PostgreSQL, Redis, MQTT)
./kompose.sh up core

# 3. Start auth stack (Keycloak + OAuth2 Proxy)
./kompose.sh up auth
```

Wait for all services to be healthy (check with `./kompose.sh status`).

### Step 2: Configure Environment Variables

**Edit `/home/valknar/Projects/kompose/.env`:**

```bash
# Base domain for all services
BASE_DOMAIN=yourdomain.com

# KMPS specific
TRAEFIK_HOST_KMPS=manage.${BASE_DOMAIN}

# Keycloak (if not already set)
TRAEFIK_HOST_AUTH=auth.${BASE_DOMAIN}
```

**Edit `/home/valknar/Projects/kompose/secrets.env`:**

```bash
# Generate secrets
KMPS_CLIENT_SECRET=$(openssl rand -base64 32)
NEXTAUTH_SECRET=$(openssl rand -base64 32)

# Keycloak admin credentials (if not already set)
KC_ADMIN_USERNAME=admin
KC_ADMIN_PASSWORD=<your-secure-password>
```

### Step 3: Configure Keycloak Client

1. **Access Keycloak Admin Console:**
   - URL: `https://auth.yourdomain.com`
   - Login with `KC_ADMIN_USERNAME` and `KC_ADMIN_PASSWORD`

2. **Select the "kompose" realm** (create if it doesn't exist)

3. **Create KMPS Client:**
   
   Navigate to: **Clients → Create Client**
   
   **General Settings:**
   - Client type: `OpenID Connect`
   - Client ID: `kmps-admin`
   - Click **Next**
   
   **Capability config:**
   - Client authentication: **ON** ✅
   - Authorization: OFF
   - Authentication flow:
     - ✅ Standard flow
     - ✅ Direct access grants
   - **Service accounts roles: ON** ✅ (Critical!)
   - Click **Next**
   
   **Login settings:**
   - Root URL: `https://manage.yourdomain.com`
   - Valid redirect URIs: `https://manage.yourdomain.com/*`
   - Valid post logout redirect URIs: `https://manage.yourdomain.com`
   - Web origins: `https://manage.yourdomain.com`
   - Click **Save**

4. **Copy Client Secret:**
   - Go to **Credentials** tab
   - Copy the **Client Secret**
   - Update in `/home/valknar/Projects/kompose/secrets.env`:
     ```bash
     KMPS_CLIENT_SECRET=<paste-the-secret-here>
     ```

5. **Assign Service Account Roles:**
   
   ⚠️ **CRITICAL STEP** - Without these roles, KMPS cannot manage users!
   
   - Go to: **Clients → kmps-admin → Service accounts roles** tab
   - Click **Assign role**
   - Click **Filter by clients** dropdown
   - Search for and assign these roles:
     - `realm-management` → `realm-admin` ✅
     - `realm-management` → `manage-users` ✅
     - `realm-management` → `manage-clients` ✅
     - `realm-management` → `view-users` ✅
     - `realm-management` → `query-users` ✅
     - `realm-management` → `query-groups` ✅
   
   Click **Assign** for each role.

### Step 4: Verify Configuration

Run the verification script:

```bash
cd /home/valknar/Projects/kompose/kmps
chmod +x verify-sso-setup.sh
./verify-sso-setup.sh
```

This will check:
- ✅ Environment variables are set
- ✅ Required Docker services are running
- ✅ Keycloak is accessible
- ⚠️ Manual Keycloak configuration checklist

### Step 5: Start KMPS

```bash
cd /home/valknar/Projects/kompose
./kompose.sh up kmps
```

Monitor the startup:

```bash
./kompose.sh logs kmps -f
```

Wait for:
- ✅ Dependencies installed
- ✅ Next.js build complete
- ✅ Server started on port 3100

### Step 6: Access KMPS

1. **Open your browser:**
   - Navigate to: `https://manage.yourdomain.com`

2. **SSO Login:**
   - You'll be redirected to Keycloak login
   - Login with your Keycloak credentials
   - You'll be redirected back to KMPS

3. **First Login:**
   - If you see the dashboard → ✅ Success!
   - If you see errors → Check troubleshooting below

## 🎯 Quick Actions After Setup

Once logged in, you can:

1. **Create your first user:**
   - Dashboard → Quick Actions → Create User
   - Or: Users tab → Add User button

2. **View statistics:**
   - Dashboard shows user count, clients, groups
   - Recent users list

3. **Manage OAuth clients:**
   - Clients tab (UI in development, API ready)

4. **Configure groups:**
   - Groups tab (UI in development, API ready)

## 🔍 Verification Checklist

Use this checklist to ensure everything is working:

- [ ] Can access `https://auth.yourdomain.com` (Keycloak)
- [ ] Can access `https://manage.yourdomain.com` (KMPS)
- [ ] Redirected to Keycloak for login
- [ ] Successfully logged into KMPS
- [ ] Dashboard shows statistics (users, clients, groups)
- [ ] Can view Users page
- [ ] Can create a test user
- [ ] Test user appears in Keycloak admin console

## 🐛 Troubleshooting

### Problem: Cannot access KMPS

**Check services:**
```bash
./kompose.sh status
docker ps | grep -E "(kmps|auth|proxy)"
```

**View logs:**
```bash
./kompose.sh logs kmps
./kompose.sh logs auth
./kompose.sh logs proxy
```

### Problem: "Unauthorized" or API errors

**Verify client secret:**
```bash
# Check secrets.env has KMPS_CLIENT_SECRET
grep KMPS_CLIENT_SECRET /home/valknar/Projects/kompose/secrets.env

# Verify it matches Keycloak
# Go to Keycloak → Clients → kmps-admin → Credentials
```

**Verify service account roles:**
```bash
# In Keycloak:
# Clients → kmps-admin → Service accounts roles
# Should show realm-admin and manage-users
```

### Problem: Redirect loop after login

**Check NextAuth configuration:**
```bash
# Ensure NEXTAUTH_SECRET is set
grep NEXTAUTH_SECRET /home/valknar/Projects/kompose/secrets.env

# Restart KMPS
./kompose.sh restart kmps
```

**Check redirect URIs in Keycloak:**
- Must be: `https://manage.yourdomain.com/*`
- Not: `http://` or `localhost`

### Problem: Dashboard shows no data

**Test Keycloak API connectivity:**
```bash
# From inside the container
docker exec kmps_app wget -O- "https://auth.yourdomain.com/realms/kompose"
```

**Check logs for API errors:**
```bash
./kompose.sh logs kmps | grep -i error
```

### Problem: Cannot create users

**Verify service account roles (most common issue):**
1. Keycloak → Clients → kmps-admin → Service accounts roles
2. Should have: `realm-admin`, `manage-users`
3. If missing, assign them and restart KMPS

## 📚 Next Steps

After KMPS is running:

1. **Configure additional OAuth clients:**
   - For each application that needs SSO
   - Follow the pattern in the auth stack documentation

2. **Set up user groups:**
   - Organize users by department, role, etc.
   - Assign group-level permissions

3. **Integrate applications:**
   - Use Keycloak as SSO provider
   - Configure via OAuth2/OIDC
   - Use OAuth2 Proxy for middleware protection

4. **Monitor and maintain:**
   ```bash
   # Check status regularly
   ./kompose.sh status kmps
   
   # View logs
   ./kompose.sh logs kmps -f
   
   # Backup database
   ./kompose.sh db backup -d kmps
   ```

## 🔗 Related Documentation

- [KMPS Full Documentation](./README.md)
- [Keycloak Stack Documentation](../_docs/content/5.stacks/auth.md)
- [SSO Integration Guide](../_docs/content/3.guide/sso-integration.md)
- [Kompose Architecture](../_docs/content/1.index.md)

## 💡 Tips

- **Use strong passwords:** For both Keycloak admin and client secrets
- **Enable HTTPS:** Never use HTTP in production
- **Regular backups:** Backup Keycloak and KMPS databases
- **Monitor logs:** Watch for unauthorized access attempts
- **Update regularly:** Keep dependencies up to date

---

**Need help?** Check the [troubleshooting section](#troubleshooting) or the full [README](./README.md).

**Version:** 1.0.0  
**Last Updated:** October 2025
