# Kompose Quick Reference

Essential commands and quick guides for the Kompose Docker Compose Stack Manager.

## 🚀 Quick Start

### Local Development
```bash
./kompose.sh setup local              # Switch to local mode
./kompose.sh up core auth kmps        # Start services
open http://localhost:3100            # Access KMPS
```

### Production Deployment
```bash
./kompose.sh setup prod               # Switch to production
./kompose.sh up proxy core auth kmps  # Start services
open https://manage.yourdomain.com    # Access KMPS
```

## 📋 Essential Commands

### Stack Management
```bash
./kompose.sh up <stack>           # Start a stack
./kompose.sh down <stack>         # Stop a stack
./kompose.sh restart <stack>      # Restart a stack
./kompose.sh status               # Check all services
./kompose.sh logs <stack> -f      # Follow logs
./kompose.sh list                 # List available stacks
```

### Setup & Configuration
```bash
./kompose.sh init                 # Interactive initialization
./kompose.sh setup local          # Switch to local mode
./kompose.sh setup prod           # Switch to production
./kompose.sh setup status         # Check current mode
./kompose.sh setup backup         # Backup configuration
```

### Database Operations
```bash
./kompose.sh db backup            # Backup all databases
./kompose.sh db restore -f FILE   # Restore from backup
./kompose.sh db list              # List backups
./kompose.sh db status            # Database health check
./kompose.sh db shell -d kompose  # Open database shell
```

### Testing
```bash
cd __tests && ./run-all-tests.sh  # Run all tests
./run-all-tests.sh -i             # Run integration tests
./run-all-tests.sh -u             # Update snapshots
./run-all-tests.sh -v             # Verbose output
```

## 🌐 Service URLs

### Local Mode
| Service | URL |
|---------|-----|
| Keycloak | `http://localhost:8180` |
| KMPS | `http://localhost:3100` |
| PostgreSQL | `localhost:5432` |
| Redis | `localhost:6379` |
| Gitea | `http://localhost:3001` |
| n8n | `http://localhost:5678` |
| Home Assistant | `http://localhost:8123` |

### Production Mode
| Service | URL |
|---------|-----|
| Keycloak | `https://auth.yourdomain.com` |
| KMPS | `https://manage.yourdomain.com` |
| Gitea | `https://code.yourdomain.com` |
| n8n | `https://chain.yourdomain.com` |
| Home Assistant | `https://home.yourdomain.com` |

## 🔧 Available Stacks

| Stack | Description | Key Services |
|-------|-------------|--------------|
| **core** | Essential services | PostgreSQL, Redis, MQTT, Directus |
| **auth** | SSO & Authentication | Keycloak, OAuth2 Proxy |
| **kmps** | Management Portal | Next.js admin portal |
| **proxy** | Reverse Proxy | Traefik with SSL/TLS |
| **chain** | Automation | n8n workflows, Semaphore/Ansible |
| **code** | Git & CI/CD | Gitea with Actions runner |
| **home** | Smart Home | Home Assistant, Matter, Zigbee |
| **vpn** | Remote Access | WireGuard (wg-easy) |
| **messaging** | Notifications | Gotify, Mailhog |
| **watch** | Monitoring | Uptime Kuma, Grafana |
| **vault** | Passwords | Vaultwarden |
| **link** | Bookmarks | Linkwarden |
| **track** | Analytics | Umami |
| **news** | Newsletter | Letterspace |

## 🔐 Common Secrets

### Generate Secrets
```bash
# NextAuth secret (32 bytes)
openssl rand -base64 32

# Hex secret (64 chars)
openssl rand -hex 32

# Strong password (32 chars)
openssl rand -base64 32 | tr -d "=+/" | cut -c1-32
```

### Required Secrets (secrets.env)
```bash
# Database
DB_PASSWORD=<your-password>

# Auth
KC_ADMIN_PASSWORD=<keycloak-admin-password>
OAUTH2_CLIENT_SECRET=<oauth2-secret>
OAUTH2_COOKIE_SECRET=$(openssl rand -base64 32)

# KMPS
KMPS_CLIENT_SECRET=<from-keycloak-credentials>
KMPS_NEXTAUTH_SECRET=$(openssl rand -base64 32)
```

## 🎯 Common Workflows

### First Time Setup
```bash
# 1. Clone and initialize
git clone <repository-url>
cd kompose
./kompose.sh init

# 2. Choose environment (follow prompts)
# 3. Start services
./kompose.sh up core auth

# 4. Configure Keycloak
open http://localhost:8180  # or your domain

# 5. Start KMPS
./kompose.sh up kmps
```

### Daily Development
```bash
# Start dev environment
./kompose.sh setup local
./kompose.sh up core auth kmps

# Make changes and test
cd kmps && npm run dev

# Check logs
./kompose.sh logs kmps -f

# Run tests
cd __tests && ./run-all-tests.sh
```

### Deploying to Production
```bash
# 1. Test locally first
./kompose.sh setup local
./kompose.sh up core auth kmps
# ... test thoroughly ...

# 2. Switch to production
./kompose.sh setup prod

# 3. Update secrets
nano secrets.env  # Use strong passwords!

# 4. Deploy
./kompose.sh up proxy core auth kmps
```

### Troubleshooting
```bash
# Check service status
./kompose.sh status

# View logs
./kompose.sh logs <stack> -f

# Restart a stuck service
./kompose.sh restart <stack>

# Check current mode
./kompose.sh setup status

# Validate configuration
./kompose.sh validate

# Check database
./kompose.sh db status
```

## 🐛 Quick Fixes

### Port Already in Use
```bash
# Find what's using the port
lsof -i :3100

# Kill process or change port
# Edit .env.local or domain.env.local
```

### Database Connection Failed
```bash
# Restart database
./kompose.sh down core
./kompose.sh up core

# Check status
docker logs core_postgres
```

### Authentication Loop
```bash
# Clear browser cookies
# Check environment variables
echo $NEXTAUTH_URL

# Restart KMPS
./kompose.sh restart kmps
```

### Container Won't Start
```bash
# Check logs
docker logs <container_name>

# Remove and recreate
./kompose.sh down <stack> -f
./kompose.sh up <stack>
```

## 📊 Mode Comparison

| Feature | Local | Production |
|---------|-------|------------|
| **URL** | localhost:PORT | subdomain.domain.com |
| **SSL** | No | Yes (automatic) |
| **Setup** | 5 minutes | 30 minutes |
| **DNS** | Not needed | Required |
| **Auth** | Basic | OAuth2 SSO |
| **Traefik** | Optional | Required |
| **Debugging** | Easy | Moderate |

## 💡 Pro Tips

1. **Always backup**: `./kompose.sh setup backup` before major changes
2. **Use local mode**: For development and testing
3. **Follow logs**: `docker logs -f <container>` to debug issues
4. **Test locally**: Before deploying to production
5. **Keep secrets safe**: Never commit secrets.env
6. **Database access**: `docker exec -it core_postgres psql -U kompose`

## 🆘 Need Help?

```bash
# Show help
./kompose.sh help

# Check version
./kompose.sh version

# Validate everything
./kompose.sh validate

# Check test status
cd __tests && ./run-all-tests.sh
```

## 📚 Documentation Links

- **Full Installation Guide**: `2.installation.md`
- **Initialization Guide**: `3.guide/initialization.md`
- **Environment Setup**: `3.guide/environment-setup.md`
- **Stack Management**: `3.guide/stack-management.md`
- **Local Development**: `3.guide/local-development.md`
- **Testing Guide**: `3.guide/testing.md`
- **Troubleshooting**: `3.guide/troubleshooting.md`
- **Stack Documentation**: `5.stacks/`

## ✅ Checklist

### Before Starting
- [ ] Docker installed and running
- [ ] Node.js 20+ installed (for local dev)
- [ ] Git installed
- [ ] 4GB+ RAM available
- [ ] Required ports free

### Local Mode Setup
- [ ] Run `./kompose.sh setup local`
- [ ] Create secrets.env
- [ ] Start core: `./kompose.sh up core`
- [ ] Start auth: `./kompose.sh up auth`
- [ ] Configure Keycloak client
- [ ] Start KMPS: `./kompose.sh up kmps`
- [ ] Verify access: http://localhost:3100

### Production Mode Setup
- [ ] DNS configured
- [ ] Run `./kompose.sh setup prod`
- [ ] Strong secrets in secrets.env
- [ ] Start proxy: `./kompose.sh up proxy`
- [ ] Start services: `./kompose.sh up core auth kmps`
- [ ] Configure Keycloak client
- [ ] Verify access: https://manage.yourdomain.com

## 🎉 You're Ready!

Choose your path:

**🏠 Local Development**
```bash
./kompose.sh setup local
./kompose.sh up core auth kmps
open http://localhost:3100
```

**🌍 Production Deployment**
```bash
./kompose.sh setup prod
./kompose.sh up proxy core auth kmps
open https://manage.yourdomain.com
```

---

**Quick Reference v1.0** | For Kompose v2.0
