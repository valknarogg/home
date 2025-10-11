---
title: Deployment Checklist
description: Complete checklist for deploying kompose
---


## Pre-Flight Checks

Before running the migration scripts, ensure:

- [ ] You have a backup of your entire kompose directory
- [ ] You have read `COMPLETE_UPDATE_SUMMARY.md`
- [ ] All stacks are currently stopped OR you're ready to stop them
- [ ] You have terminal access and can run bash scripts
- [ ] You understand the changes (rename home→core, integrate auto→chain)

## Step-by-Step Execution

### Phase 1: Preparation (5 minutes)

```bash
# 1. Navigate to kompose directory
cd /home/valknar/Projects/kompose

# 2. Create a full backup
tar czf ~/kompose-backup-$(date +%Y%m%d).tar.gz .
echo "Backup created: ~/kompose-backup-$(date +%Y%m%d).tar.gz"

# 3. Check current status
./kompose.sh status
docker ps

# 4. Make scripts executable
chmod +x kompose.sh rename-home-to-core.sh migrate-auto-to-chain.sh
```

**Checkpoint**: ✅ Backup created, scripts are executable

---

### Phase 2: Rename home → core (10 minutes)

```bash
# 1. Run the rename script
./rename-home-to-core.sh

# The script will:
# - Stop home stack if running
# - Backup home directory
# - Update all config files
# - Rename directories
# - Start core stack (if you choose)

# 2. Verify rename success
./kompose.sh status core
docker ps | grep core

# 3. Test PostgreSQL
docker exec core-postgres psql -U kompose -l
```

**Expected Results**:
- ✅ Directory `./core` exists (was `./home`)
- ✅ Container `core-postgres` is running (was `home-postgres`)
- ✅ `./kompose.sh status core` shows services
- ✅ PostgreSQL responds to commands

**If something went wrong**: See rollback section at bottom

---

### Phase 3: Integrate Semaphore into chain (15 minutes)

```bash
# 1. Ensure core stack is running
./kompose.sh status core

# 2. Create databases (if they don't exist)
docker exec core-postgres psql -U kompose -c "CREATE DATABASE n8n;"
docker exec core-postgres psql -U kompose -c "CREATE DATABASE semaphore;"

# 3. Configure secrets.env
nano secrets.env  # Add required secrets (see below)

# 4. Run integration script
./migrate-auto-to-chain.sh

# The script will:
# - Backup Semaphore database
# - Stop auto stack
# - Prepare chain stack
# - Start chain stack (if you choose)

# 5. Verify integration
./kompose.sh status chain
docker ps | grep chain
```

**Expected Results**:
- ✅ Container `chain_n8n` is running
- ✅ Container `chain_semaphore` is running
- ✅ Container `chain_semaphore_runner` is running
- ✅ Auto stack is stopped

**Test endpoints**:
```bash
curl http://localhost:5678/healthz    # n8n
curl http://localhost:3000/api/ping   # Semaphore
```

---

### Phase 4: Verification (5 minutes)

```bash
# 1. Check all stacks
./kompose.sh status

# 2. Verify databases
./kompose.sh db status

# 3. Check logs for errors
./kompose.sh logs core | tail -20
./kompose.sh logs chain | tail -20

# 4. Test database connections
docker exec chain_n8n nc -zv core-postgres 5432
docker exec chain_semaphore nc -zv core-postgres 5432

# 5. List all containers
docker ps --format "table {{.Names}}\t{{.Status}}"
```

**Expected Output**:
```
NAMES                           STATUS
chain_semaphore_runner          Up X minutes
chain_semaphore                 Up X minutes (healthy)
chain_n8n                       Up X minutes (healthy)
core-postgres                   Up X minutes
core_mqtt                       Up X minutes
core_app                        Up X minutes
```

---

### Phase 5: Clean Up (5 minutes)

```bash
# 1. Remove auto stack directory (optional, after verifying everything works)
# rm -rf ./auto  # Keep for reference or remove

# 2. Remove old core directory if renamed (check first!)
# ls -la core-services  # This should be old service configs
# mv core-services old-core-configs  # Keep as backup

# 3. Check for unused containers
docker ps -a | grep -E "home_|auto_"

# 4. Remove old containers if they exist
# docker rm -f <container_name>

# 5. Check for unused volumes
docker volume ls | grep -E "home|auto"
```

---

## 🔍 Detailed Verification Tests

### Test 1: Core Stack (PostgreSQL)

```bash
# Connect to PostgreSQL
docker exec -it core-postgres psql -U kompose

# Run in psql:
\l                          # List databases
\c n8n                      # Connect to n8n
\dt                         # List tables
\c semaphore                # Connect to semaphore
\dt                         # List tables
\q                          # Quit
```

**Expected**: Both n8n and semaphore databases exist with tables

### Test 2: n8n Service

```bash
# Check health
curl -v http://localhost:5678/healthz

# Check UI (if enabled)
open http://localhost:5678   # or visit in browser
```

**Expected**: HTTP 200, n8n login page appears

### Test 3: Semaphore Service

```bash
# Check health
curl -v http://localhost:3000/api/ping

# Check UI
open http://localhost:3000   # or visit in browser
```

**Expected**: HTTP 200, Semaphore login page appears

### Test 4: Service Communication

```bash
# Test n8n can reach Semaphore
docker exec chain_n8n wget -O- http://semaphore:3000/api/ping

# Test Semaphore can reach PostgreSQL
docker exec chain_semaphore nc -zv core-postgres 5432
```

**Expected**: Both commands succeed

---

## 🔑 Required Secrets Configuration

Before Phase 3, ensure `secrets.env` contains:

```bash
# Database (core stack)
DB_HOST=core-postgres
DB_USER=kompose
DB_PASSWORD=<your_secure_password>

# n8n
N8N_ENCRYPTION_KEY=<generate_with: openssl rand -hex 32>
N8N_BASIC_AUTH_PASSWORD=<your_n8n_password>

# Semaphore
SEMAPHORE_ADMIN_PASSWORD=<your_semaphore_password>
SEMAPHORE_RUNNER_TOKEN=<generate_with: openssl rand -hex 32>

# Email (shared by both)
ADMIN_EMAIL=admin@example.com
EMAIL_FROM=noreply@example.com
EMAIL_SMTP_HOST=smtp.gmail.com
EMAIL_SMTP_PORT=587
EMAIL_SMTP_USER=<your_email>
EMAIL_SMTP_PASSWORD=<your_app_password>

# Traefik (if using)
TRAEFIK_HOST_CHAIN=n8n.yourdomain.com
TRAEFIK_HOST_AUTO=semaphore.yourdomain.com
```

Generate encryption keys:
```bash
openssl rand -hex 32   # For N8N_ENCRYPTION_KEY
openssl rand -hex 32   # For SEMAPHORE_RUNNER_TOKEN
```

---

## 🆘 Troubleshooting

### Issue: Rename script fails

**Solution**:
```bash
# Check if home stack is stopped
docker ps | grep home

# Stop manually if needed
cd home && docker-compose down && cd ..

# Try rename again
./rename-home-to-core.sh
```

### Issue: Container name conflicts

**Solution**:
```bash
# Remove old containers
docker rm -f $(docker ps -aq --filter name=home_)
docker rm -f $(docker ps -aq --filter name=auto_)

# Start fresh
./kompose.sh up core
./kompose.sh up chain
```

### Issue: Database connection errors

**Solution**:
```bash
# Verify PostgreSQL is running
docker ps | grep postgres

# Check container name
docker ps --format "{{.Names}}" | grep postgres
# Should show: core-postgres

# Restart if needed
docker restart core-postgres

# Wait 10 seconds, then restart dependent services
sleep 10
./kompose.sh restart chain
```

### Issue: Services can't find each other

**Solution**:
```bash
# Check network
docker network inspect kompose

# Reconnect services to network
docker network connect kompose chain_n8n
docker network connect kompose chain_semaphore

# Restart services
./kompose.sh restart chain
```

---

## 🔄 Rollback Procedures

### Rollback Phase 1 (Undo Rename)

```bash
# Stop core stack
./kompose.sh down core

# Restore from backup
cd ~
tar xzf kompose-backup-*.tar.gz -C /tmp/kompose-restore
cp -r /tmp/kompose-restore/* /home/valknar/Projects/kompose/

# Start home stack
cd /home/valknar/Projects/kompose
./kompose.sh up home
```

### Rollback Phase 2 (Undo Integration)

```bash
# Stop chain stack
./kompose.sh down chain

# Restore Semaphore backup
./kompose.sh db restore -f backups/migration/semaphore_*.sql.gz -d semaphore

# Start separate stacks
./kompose.sh up auto   # If you have the old auto directory
./kompose.sh up chain  # This will be n8n only
```

---

## ✅ Final Checklist

After completing all phases:

- [ ] Core stack running: `./kompose.sh status core`
- [ ] Chain stack running: `./kompose.sh status chain`
- [ ] Auto stack stopped: `docker ps | grep auto` (empty)
- [ ] PostgreSQL accessible: `docker exec core-postgres psql -U kompose -l`
- [ ] n8n accessible: http://localhost:5678
- [ ] Semaphore accessible: http://localhost:3000
- [ ] All databases exist: `./kompose.sh db status`
- [ ] No errors in logs: `./kompose.sh logs chain | grep -i error`
- [ ] Backups created and stored safely
- [ ] Documentation reviewed

---

## 📈 Success Criteria

You've successfully completed the update if:

1. ✅ `./kompose.sh list` shows "core" and "chain" stacks
2. ✅ `docker ps` shows core-postgres, chain_n8n, chain_semaphore, chain_semaphore_runner
3. ✅ Both web UIs are accessible (n8n and Semaphore)
4. ✅ Database backups exist in ./backups/
5. ✅ No home_ or auto_ containers running

---

## 🎉 Congratulations!

If all checkboxes are ticked, you've successfully:
- ✅ Renamed home → core
- ✅ Integrated Semaphore into chain
- ✅ Created a unified automation platform

Next steps:
1. Configure Ansible playbooks in Semaphore
2. Create automation workflows in n8n
3. Set up monitoring
4. Read the integration guide for advanced usage

**Documentation**: See `COMPLETE_UPDATE_SUMMARY.md` for full details.

---

## 📝 Execution Log

Keep track of your progress:

```
Date: ____________
Time Started: ____________

Phase 1 (Preparation): ⬜ Started ⬜ Completed
Phase 2 (Rename): ⬜ Started ⬜ Completed
Phase 3 (Integration): ⬜ Started ⬜ Completed
Phase 4 (Verification): ⬜ Started ⬜ Completed
Phase 5 (Clean Up): ⬜ Started ⬜ Completed

Issues Encountered: 
_________________________________________________
_________________________________________________

Resolution:
_________________________________________________
_________________________________________________

Time Completed: ____________
Total Duration: ____________
```

## SSO DEPLOYMENT CHECKLIST


## 🎉 What's Been Created

Your Kompose.sh infrastructure now includes a comprehensive Single Sign-On (SSO) system!

### New Components

1. **OAuth2 Proxy** (in auth stack)
   - Forward authentication service
   - Integrates Keycloak with Traefik
   - Manages SSO sessions via Redis
   - File: `/home/valknar/Projects/kompose/auth/compose.yaml`

2. **Traefik SSO Middlewares** (in proxy stack)
   - `sso-secure`: Standard SSO protection
   - `sso-secure-limited`: SSO + rate limiting
   - `sso-internal-only`: SSO + IP whitelist
   - File: `/home/valknar/Projects/kompose/proxy/dynamic/middlewares.yml`

3. **KMPS Management Portal** (new stack)
   - Web-based user management
   - Client/application management
   - Group and role administration
   - Location: `/home/valknar/Projects/kompose/kmps/`

4. **Documentation**
   - SSO Integration Guide: `SSO_INTEGRATION_GUIDE.md`
   - Quick Reference: `SSO_QUICK_REF.md`
   - Integration Examples: `SSO_INTEGRATION_EXAMPLES.md`
   - KMPS README: `kmps/README.md`

### Modified Components

1. **Auth Stack** - Added OAuth2 Proxy service
2. **Proxy Stack** - Added dynamic configuration support
3. **Middlewares** - Added SSO middleware chains

## 📋 Deployment Checklist

### Phase 1: Environment Configuration

- [ ] **Set BASE_DOMAIN** in root `.env`
  ```bash
  BASE_DOMAIN=yourdomain.com
  ```

- [ ] **Configure SSO hostnames** in root `.env`
  ```bash
  TRAEFIK_HOST_AUTH=auth.yourdomain.com
  TRAEFIK_HOST_OAUTH2=sso.yourdomain.com
  TRAEFIK_HOST_KMPS=manage.yourdomain.com
  ```

- [ ] **Generate secrets** in `secrets.env`
  ```bash
  # Keycloak admin password
  AUTH_KC_ADMIN_PASSWORD=$(openssl rand -base64 32)
  
  # OAuth2 Proxy secrets
  AUTH_OAUTH2_CLIENT_SECRET=$(openssl rand -base64 32)
  AUTH_OAUTH2_COOKIE_SECRET=$(openssl rand -base64 32)
  
  # KMPS secrets
  KMPS_CLIENT_SECRET=$(openssl rand -base64 32)
  KMPS_NEXTAUTH_SECRET=$(openssl rand -base64 32)
  ```

### Phase 2: Infrastructure Deployment

- [ ] **Ensure core services are running**
  ```bash
  ./kompose.sh up core
  # Verify Redis is healthy (needed for OAuth2 Proxy sessions)
  ```

- [ ] **Deploy the auth stack**
  ```bash
  ./kompose.sh up auth
  ```

- [ ] **Verify auth stack is healthy**
  ```bash
  ./kompose.sh status auth
  # Should show: keycloak and oauth2-proxy both healthy
  ```

- [ ] **Check OAuth2 Proxy logs**
  ```bash
  ./kompose.sh logs auth | grep oauth2
  # Should see "OAuth2 Proxy ready"
  ```

### Phase 3: Keycloak Configuration

- [ ] **Access Keycloak Admin Console**
  - URL: `https://auth.yourdomain.com`
  - Username: `admin`
  - Password: `<AUTH_KC_ADMIN_PASSWORD from secrets.env>`

- [ ] **Create Kompose Realm**
  1. Click "Create Realm"
  2. Name: `kompose`
  3. Enable: ON
  4. Save

- [ ] **Create OAuth2 Proxy Client**
  1. Clients → Create Client
  2. Client ID: `kompose-sso`
  3. Client type: OpenID Connect
  4. Client authentication: ON
  5. Valid redirect URIs:
     - `https://sso.yourdomain.com/oauth2/callback`
     - `https://*.yourdomain.com/*`
  6. Web origins: `https://*.yourdomain.com`
  7. Save and copy client secret
  8. Update `AUTH_OAUTH2_CLIENT_SECRET` in `secrets.env`

- [ ] **Create KMPS Admin Client**
  1. Clients → Create Client
  2. Client ID: `kmps-admin`
  3. Client authentication: ON
  4. Service accounts roles: ON
  5. Valid redirect URIs: `https://manage.yourdomain.com/*`
  6. Save and copy client secret
  7. Update `KMPS_CLIENT_SECRET` in `secrets.env`

- [ ] **Assign Admin Roles to KMPS**
  1. Clients → kmps-admin → Service accounts roles
  2. Assign role → Filter by clients
  3. Select and assign:
     - `realm-admin` (realm-management)
     - `manage-users`
     - `manage-clients`
     - `view-users`
     - `view-clients`

- [ ] **Create Initial Admin User**
  1. Users → Create user
  2. Fill: username, email, first/last name
  3. Email verified: ON
  4. Enabled: ON
  5. Save
  6. Credentials tab → Set password
  7. Temporary: OFF
  8. Save

- [ ] **Create User Groups (Optional)**
  1. Groups → Create group
  2. Suggested groups:
     - `admins` - Full system access
     - `users` - Standard users
     - `developers` - Access to dev tools
  3. Assign users to groups

### Phase 4: OAuth2 Proxy Restart

- [ ] **Restart auth stack** (to apply new client credentials)
  ```bash
  ./kompose.sh restart auth
  ```

- [ ] **Verify OAuth2 Proxy can connect to Keycloak**
  ```bash
  ./kompose.sh logs auth | grep -i keycloak
  # Should see successful OIDC discovery
  ```

- [ ] **Test OAuth2 Proxy endpoint**
  ```bash
  curl https://sso.yourdomain.com/ping
  # Should return "OK"
  ```

### Phase 5: KMPS Deployment

- [ ] **Deploy KMPS stack**
  ```bash
  ./kompose.sh up kmps
  ```

- [ ] **Check KMPS status**
  ```bash
  ./kompose.sh status kmps
  # Should show healthy
  ```

- [ ] **Access KMPS portal**
  - URL: `https://manage.yourdomain.com`
  - Should redirect to Keycloak login
  - Login with admin user created earlier
  - Should see KMPS dashboard

### Phase 6: Integration Testing

- [ ] **Test SSO Login Flow**
  1. Open `https://manage.yourdomain.com` in private/incognito window
  2. Should redirect to Keycloak
  3. Login with created user
  4. Should redirect back to KMPS
  5. Should see authenticated dashboard

- [ ] **Test Session Persistence**
  1. Close and reopen browser tab
  2. Should remain logged in (cookie valid)
  3. Check Redis for session: `./kompose.sh exec core redis-cli KEYS '*oauth2*'`

- [ ] **Test SSO Middleware**
  ```bash
  # Test unauthenticated access (should redirect)
  curl -I https://manage.yourdomain.com
  # Should see 302 redirect to auth
  ```

### Phase 7: Stack Integration

- [ ] **Protect n8n with SSO** (Optional)
  ```bash
  # Edit chain/compose.yaml
  # Change n8n middleware to: sso-secure
  ./kompose.sh restart chain
  ```

- [ ] **Protect Linkwarden with SSO** (Optional)
  ```bash
  # Edit +utilitiy/link/compose.yaml
  # Change middleware to: sso-secure
  ./kompose.sh restart link
  ```

- [ ] **Test Protected Services**
  1. Access protected service URL
  2. Should redirect to Keycloak if not logged in
  3. After login, should access service
  4. User info should be in request headers

### Phase 8: Security Hardening

- [ ] **Enable 2FA in Keycloak** (Highly Recommended)
  1. Authentication → Required Actions
  2. Add: "Configure OTP"
  3. Set as default

- [ ] **Configure IP Whitelist** (for internal services)
  ```bash
  # Edit proxy/dynamic/middlewares.yml
  # Update sourceRange in internal-only middleware
  # Add your network ranges
  ```

- [ ] **Review Cookie Settings**
  - Check expiry time (default: 7 days)
  - Verify secure flag is ON
  - Confirm HTTPOnly is ON

- [ ] **Backup Keycloak Database**
  ```bash
  ./kompose.sh db backup -d keycloak
  ```

### Phase 9: Documentation & Training

- [ ] **Read Full Documentation**
  - [ ] SSO Integration Guide
  - [ ] Quick Reference
  - [ ] Integration Examples
  - [ ] KMPS README

- [ ] **Document Custom Configuration**
  - Network ranges for IP whitelist
  - Custom middleware chains
  - Group/role structure
  - User onboarding process

- [ ] **Train Admin Users**
  - How to create users in KMPS
  - How to reset passwords
  - How to manage groups
  - How to add new applications

## 🎯 Quick Start Commands

```bash
# Start everything
./kompose.sh up core
./kompose.sh up auth
./kompose.sh up kmps

# Check status
./kompose.sh status

# View logs
./kompose.sh logs auth -f
./kompose.sh logs kmps -f

# Backup databases
./kompose.sh db backup -d keycloak
./kompose.sh db backup -d kmps

# Restart services
./kompose.sh restart auth
./kompose.sh restart kmps
```

## 🔍 Verification Commands

```bash
# Test OAuth2 Proxy
curl https://sso.yourdomain.com/ping
curl -I https://sso.yourdomain.com/oauth2/auth

# Test Keycloak
curl https://auth.yourdomain.com/realms/kompose/.well-known/openid-configuration

# Test KMPS
curl -I https://manage.yourdomain.com

# Check Redis sessions
./kompose.sh exec core redis-cli KEYS '*oauth2*'

# Check container health
docker ps | grep -E 'auth|kmps'
```

## 📊 System URLs

| Service | URL | Purpose |
|---------|-----|---------|
| Keycloak Admin | `https://auth.yourdomain.com` | Identity management |
| OAuth2 Proxy | `https://sso.yourdomain.com` | SSO authentication |
| KMPS Portal | `https://manage.yourdomain.com` | User management |
| Traefik Dashboard | `http://your-server:8080` | Proxy monitoring |

## 🚨 Common Issues & Solutions

### OAuth2 Proxy won't start
```bash
# Check Redis connection
./kompose.sh status core
# Verify environment variables
./kompose.sh exec auth env | grep OAUTH2
```

### Can't login to Keycloak
```bash
# Reset admin password
./kompose.sh down auth
# Update AUTH_KC_ADMIN_PASSWORD in secrets.env
./kompose.sh up auth
```

### SSO redirect loop
```bash
# Clear browser cookies
# Verify BASE_DOMAIN in .env
# Check OAuth2 Proxy logs
./kompose.sh logs auth | grep oauth2
```

### KMPS can't connect to Keycloak
```bash
# Verify Keycloak is accessible
curl https://auth.yourdomain.com
# Check KMPS client secret
# Verify admin roles are assigned
```

## 📈 Next Steps

1. **Integrate More Stacks**
   - Follow examples in `SSO_INTEGRATION_EXAMPLES.md`
   - Start with non-critical services first
   - Test thoroughly before production

2. **Customize KMPS**
   - Add your branding
   - Customize user fields
   - Add audit logging

3. **Set Up Monitoring**
   - Monitor auth stack health
   - Track failed login attempts
   - Set up alerts for issues

4. **Plan User Migration**
   - If you have existing users, plan migration
   - Consider dual-auth during transition
   - Communicate changes to users

5. **Regular Maintenance**
   - Weekly: Review active sessions
   - Monthly: User audit
   - Quarterly: Security review
   - Backup before major changes

## 🔐 Security Reminders

- ✅ Use strong, random passwords for all secrets
- ✅ Enable 2FA for admin accounts
- ✅ Regularly backup Keycloak database
- ✅ Monitor authentication logs
- ✅ Update components regularly
- ✅ Review and remove inactive users
- ✅ Use HTTPS everywhere (enforced by Traefik)
- ✅ Keep BASE_DOMAIN and secrets secure
- ✅ Implement IP restrictions for admin interfaces
- ✅ Regular security audits

## 📚 Documentation Index

1. **SSO_INTEGRATION_GUIDE.md** - Complete setup guide
2. **SSO_QUICK_REF.md** - Quick reference card
3. **SSO_INTEGRATION_EXAMPLES.md** - Stack integration examples
4. **kmps/README.md** - KMPS portal documentation

## 🎊 You're All Set!

Your Kompose infrastructure now has enterprise-grade SSO capabilities. All your applications can now use centralized authentication through Keycloak, providing:

- Single sign-on across all services
- Centralized user management
- Group-based access control
- Session management
- Security headers and protection
- Comprehensive audit trails

**Need help?** Refer to the documentation files or check the logs!

---

**Last Updated**: October 2025  
**Kompose Version**: 1.0+  
**SSO Stack Version**: 1.0.0
