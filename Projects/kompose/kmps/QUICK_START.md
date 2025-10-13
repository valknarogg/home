# KMPS Quick Start Guide

## 🎯 Goal
Get KMPS (Kompose Management Portal) running for development or production.

## ⚡ Super Quick Start (5 minutes)

```bash
# 1. Navigate to project
cd /home/valknar/Projects/kompose

# 2. Make setup script executable
chmod +x kmps/setup-dev.sh

# 3. Run setup script (it will guide you through everything!)
./kmps/setup-dev.sh
```

The script will:
- ✅ Check prerequisites (Docker, Node.js)
- ✅ Start required services (core, auth)
- ✅ Verify secrets.env configuration
- ✅ Generate NextAuth secret if needed
- ✅ Install npm dependencies
- ✅ Start KMPS in your preferred mode

## 📝 Manual Setup (if you prefer)

### Prerequisites
```bash
# 1. Start required stacks
./kompose.sh up core
./kompose.sh up auth

# 2. Verify they're running
./kompose.sh status core
./kompose.sh status auth
```

### Keycloak Configuration
```bash
# 1. Access Keycloak
open https://auth.pivoine.art

# 2. Login as admin (credentials in secrets.env)

# 3. Create client:
#    - Client ID: kmps-admin
#    - Client auth: ON
#    - Service accounts: ON
#    - Redirect URIs: https://manage.pivoine.art/*, http://localhost:3100/*

# 4. Get client secret from Credentials tab

# 5. Add to secrets.env:
echo "KMPS_CLIENT_SECRET=<your-secret-here>" >> secrets.env

# 6. Generate NextAuth secret:
echo "KMPS_NEXTAUTH_SECRET=$(openssl rand -base64 32)" >> secrets.env

# 7. Assign admin roles to service account:
#    - Go to: Clients → kmps-admin → Service accounts roles
#    - Assign: realm-admin, manage-users, view-users, query-users
```

### Start KMPS

**Option A: Local Development (Hot Reload)**
```bash
cd /home/valknar/Projects/kompose/kmps

# Install dependencies
npm install

# Set environment (or create a .env.local)
export NODE_ENV=development
export KEYCLOAK_URL=https://auth.pivoine.art
export KEYCLOAK_REALM=kompose
export KEYCLOAK_CLIENT_ID=kmps-admin
export KEYCLOAK_CLIENT_SECRET="<from-secrets.env>"
export NEXTAUTH_URL=http://localhost:3100
export NEXTAUTH_SECRET="<from-secrets.env>"
export KOMPOSE_API_URL=http://localhost:8080

# Start dev server
npm run dev

# Access at: http://localhost:3100
```

**Option B: Docker (Production-like)**
```bash
cd /home/valknar/Projects/kompose

# Start stack
./kompose.sh up kmps

# View logs
./kompose.sh logs kmps -f

# Access at: https://manage.pivoine.art
```

## 🔧 Configuration Files

All configuration is centralized:

```
/home/valknar/Projects/kompose/
├── .env                    # Main config (KMPS section configured ✅)
├── domain.env              # Domain config (SUBDOMAIN_MANAGE added ✅)
├── secrets.env             # Secrets (needs KMPS secrets)
└── kmps/
    ├── compose.yaml        # Fixed ✅
    ├── package.json        # Correct ✅
    └── src/                # Source code ✅
```

## ✅ Verification Checklist

After setup, verify everything works:

```bash
# 1. Check services
docker ps | grep kmps
# Should see: kmps_app and kmps_api

# 2. Check logs
./kompose.sh logs kmps

# 3. Test API
curl http://localhost:3100/api/health
# Should return: {"status":"ok"}

# 4. Access UI
open http://localhost:3100
# Should redirect to Keycloak login

# 5. Login and check dashboard
# Should see user count, clients, and stack monitoring
```

## 🐛 Common Issues

### "Module not found" errors
```bash
cd /home/valknar/Projects/kompose/kmps
rm -rf node_modules package-lock.json
npm install
```

### "Authentication loop"
```bash
# Clear browser cookies for localhost:3100
# Verify NEXTAUTH_URL matches exactly (no trailing slash)
```

### "Failed to fetch users"
```bash
# Check service account roles in Keycloak
# Verify KMPS_CLIENT_SECRET in secrets.env
# Check logs: docker logs kmps_app
```

### "Port 3100 already in use"
```bash
lsof -i :3100  # Find what's using it
# Or change port in package.json
```

## 📚 Documentation

- **Complete Setup:** `kmps/SETUP_COMPLETE.md`
- **Development Guide:** `kmps/DEVELOPMENT.md`
- **Stack Documentation:** `_docs/content/5.stacks/kmps.md`
- **Quick Reference:** `kmps/QUICK_REFERENCE.md`

## 🎯 What's Been Fixed

All issues have been resolved:
- ✅ Domain configuration (SUBDOMAIN_MANAGE)
- ✅ Environment variables (KMPS section in .env)
- ✅ Secrets template (KMPS secrets added)
- ✅ Docker compose (volume mount fixed)
- ✅ Documentation (updated and comprehensive)
- ✅ Development guide (created)
- ✅ Setup script (automated helper)

## 🚀 Quick Commands

```bash
# Start development
npm run dev

# Start with Docker
./kompose.sh up kmps

# View logs
./kompose.sh logs kmps -f

# Stop
./kompose.sh down kmps

# Check status
./kompose.sh status kmps

# Rebuild
./kompose.sh up kmps --build
```

## 🎉 Next Steps

1. Complete Keycloak setup (if not done)
2. Run `./kmps/setup-dev.sh` or start manually
3. Access KMPS at http://localhost:3100 or https://manage.pivoine.art
4. Login with your Keycloak credentials
5. Start managing users and stacks!

## 💡 Pro Tips

- Use the setup script for automatic configuration
- Keep secrets.env secure (never commit to git)
- Use local development for faster iteration
- Check logs if something doesn't work
- Read DEVELOPMENT.md for detailed troubleshooting

---

**Ready to start?** Run: `./kmps/setup-dev.sh` 🚀
