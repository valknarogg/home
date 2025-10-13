# Kompose Quick Reference Card

## 🚀 Getting Started (Choose One)

### Local Development (Easiest)
```bash
./kompose-local.sh local              # Switch to local mode
./kompose.sh up core auth kmps        # Start services
open http://localhost:3100            # Access KMPS
```

### Production Deployment
```bash
./kompose-local.sh prod               # Switch to production
./kompose.sh up proxy core auth kmps  # Start services
open https://manage.pivoine.art       # Access KMPS
```

## 📁 Important Files

```
kompose/
├── .env                          # Production config
├── .env.local                    # Local development config
├── domain.env                    # Production domains
├── domain.env.local              # Local ports
├── secrets.env                   # Secrets (both modes)
├── kompose.sh                    # Service manager
├── kompose-local.sh              # Mode switcher
├── LOCAL_DEVELOPMENT.md          # Local dev guide
├── LOCAL_DEV_COMPLETE.md         # Feature summary
├── COMPLETE_SUMMARY.md           # This complete summary
└── kmps/
    ├── DEVELOPMENT.md            # KMPS dev guide
    ├── QUICK_START.md            # Quick setup
    └── setup-dev.sh              # Automated setup
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
| Keycloak | `https://auth.pivoine.art` |
| KMPS | `https://manage.pivoine.art` |
| Gitea | `https://code.pivoine.art` |
| n8n | `https://chain.pivoine.art` |
| Home Assistant | `https://home.pivoine.art` |

## 🔧 Essential Commands

### Mode Management
```bash
./kompose-local.sh status         # Check current mode
./kompose-local.sh local          # Switch to local
./kompose-local.sh prod           # Switch to production
./kompose-local.sh backup         # Backup config
./kompose-local.sh help           # Show help
```

### Service Management
```bash
./kompose.sh up <stack>           # Start a stack
./kompose.sh down <stack>         # Stop a stack
./kompose.sh status               # Check all services
./kompose.sh logs <stack> -f      # Follow logs
./kompose.sh restart <stack>      # Restart stack
```

### Common Stacks
```bash
./kompose.sh up core              # PostgreSQL, Redis, MQTT
./kompose.sh up auth              # Keycloak, OAuth2
./kompose.sh up kmps              # Management Portal
./kompose.sh up code              # Gitea
./kompose.sh up chain             # n8n, Semaphore
./kompose.sh up home              # Home Assistant
./kompose.sh up proxy             # Traefik (prod only)
```

## 🔐 Secrets Setup

### Generate Secrets
```bash
# NextAuth secret
openssl rand -base64 32

# Hex secret (64 chars)
openssl rand -hex 32

# Password (32 chars)
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

## 🎯 Setup Workflow

### First Time Setup (Local)
1. Switch to local: `./kompose-local.sh local`
2. Create secrets.env with simple passwords
3. Start services: `./kompose.sh up core auth`
4. Configure Keycloak at http://localhost:8180
5. Create kmps-admin client, get secret
6. Update secrets.env with client secret
7. Start KMPS: `./kompose.sh up kmps`
8. Access at http://localhost:3100

### First Time Setup (Production)
1. Configure DNS for your domain
2. Ensure .env and domain.env have correct domain
3. Create secrets.env with strong passwords
4. Start Traefik: `./kompose.sh up proxy`
5. Start services: `./kompose.sh up core auth`
6. Configure Keycloak at https://auth.yourdomain.com
7. Create kmps-admin client, get secret
8. Update secrets.env with client secret
9. Start KMPS: `./kompose.sh up kmps`
10. Access at https://manage.yourdomain.com

## 🐛 Quick Troubleshooting

| Problem | Solution |
|---------|----------|
| Port in use | `lsof -i :PORT` and kill process or change port |
| Can't connect to DB | `./kompose.sh down core && ./kompose.sh up core` |
| Auth loop | Clear cookies, verify NEXTAUTH_URL |
| Module not found | `cd kmps && rm -rf node_modules && npm install` |
| Service won't start | Check logs: `docker logs <container_name>` |

## 📊 Mode Comparison

| Feature | Local | Production |
|---------|-------|------------|
| **URL** | localhost:PORT | subdomain.domain.com |
| **SSL** | No | Yes (automatic) |
| **Setup** | 5 minutes | 30 minutes |
| **DNS** | Not needed | Required |
| **Auth** | Basic | OAuth2 SSO |
| **Traefik** | Optional | Required |

## 📚 Documentation Links

- **Complete Guide**: `COMPLETE_SUMMARY.md`
- **Local Dev**: `LOCAL_DEVELOPMENT.md`
- **KMPS Setup**: `kmps/QUICK_START.md`
- **KMPS Dev**: `kmps/DEVELOPMENT.md`
- **Full KMPS Docs**: `_docs/content/5.stacks/kmps.md`

## 💡 Pro Tips

1. **Always backup**: `./kompose-local.sh backup` before major changes
2. **Check status**: `./kompose-local.sh status` to see current mode
3. **Use local mode**: For development and testing
4. **Follow logs**: `docker logs -f <container>` to debug issues
5. **Database access**: `docker exec -it core_postgres psql -U kompose`
6. **Redis CLI**: `docker exec -it core_redis redis-cli`

## 🎓 Learning Path

1. Read `COMPLETE_SUMMARY.md` (overview)
2. Follow `kmps/QUICK_START.md` (hands-on)
3. Study `LOCAL_DEVELOPMENT.md` (deep dive)
4. Reference `_docs/content/5.stacks/kmps.md` (complete)

## 🆘 Help

```bash
./kompose-local.sh help           # Mode switcher help
./kompose.sh help                 # Service manager help
docker logs <container>           # View container logs
docker ps                         # List running containers
docker exec -it <container> sh    # Access container shell
```

## ✅ Checklist

### Before Starting
- [ ] Docker installed and running
- [ ] Node.js 20+ installed (for local dev)
- [ ] Git installed
- [ ] 4GB+ RAM available
- [ ] Required ports free

### Local Mode
- [ ] Run `./kompose-local.sh local`
- [ ] Create secrets.env
- [ ] Start core: `./kompose.sh up core`
- [ ] Start auth: `./kompose.sh up auth`
- [ ] Configure Keycloak client
- [ ] Start KMPS: `./kompose.sh up kmps`
- [ ] Verify access: http://localhost:3100

### Production Mode
- [ ] DNS configured
- [ ] Run `./kompose-local.sh prod`
- [ ] Strong secrets in secrets.env
- [ ] Start proxy: `./kompose.sh up proxy`
- [ ] Start services: `./kompose.sh up core auth kmps`
- [ ] Configure Keycloak client
- [ ] Verify access: https://manage.yourdomain.com

---

**Quick Reference v1.0** | Updated: 2025-01-13 | For Kompose v1.0
