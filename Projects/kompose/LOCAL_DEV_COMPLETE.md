# 🎉 Local Development Mode - Complete!

## ✅ What's Been Added

I've successfully added complete local development support to the Kompose project! Here's everything that's new:

### 📁 New Files Created

1. **`.env.local`** - Local development environment configuration
   - Uses `localhost` instead of domain names
   - Direct port access (no Traefik needed)
   - Simplified settings for development

2. **`domain.env.local`** - Local domain/port configuration
   - Maps services to localhost:PORT
   - No SSL/TLS needed
   - Easy port management

3. **`kompose-local.sh`** - Configuration mode manager
   - Switch between local and production modes
   - Automatic backups
   - Status checking
   - Easy mode management

4. **`kmps/compose.local.yaml`** - Local Docker Compose for KMPS
   - Direct port exposure (3100)
   - No Traefik labels
   - Local-friendly environment variables

5. **`LOCAL_DEVELOPMENT.md`** - Comprehensive local dev guide
   - Quick start instructions
   - Service URLs reference
   - Troubleshooting guide
   - Best practices

## 🚀 Quick Start

### Automated Setup (Easiest)

```bash
# 1. Switch to local development mode
./kompose-local.sh local

# 2. Start services
./kompose.sh up core      # PostgreSQL, Redis, MQTT
./kompose.sh up auth      # Keycloak
./kompose.sh up kmps      # Management Portal

# 3. Access services
open http://localhost:8180  # Keycloak
open http://localhost:3100  # KMPS
```

### Manual Setup

```bash
# Copy local configs
cp .env.local .env
cp domain.env.local domain.env

# Start services
./kompose.sh up core auth kmps
```

## 🌐 Local Service URLs

All services are accessible via localhost with specific ports:

### Core Services
- **PostgreSQL**: `localhost:5432`
- **Redis**: `localhost:6379`
- **MQTT**: `localhost:1883`
- **Redis Commander**: `http://localhost:8081`

### Main Applications
- **Keycloak**: `http://localhost:8180`
- **KMPS**: `http://localhost:3100`
- **Gitea**: `http://localhost:3001`
- **n8n**: `http://localhost:5678`
- **Semaphore**: `http://localhost:3000`
- **Home Assistant**: `http://localhost:8123`
- **Directus**: `http://localhost:8055`
- **Vaultwarden**: `http://localhost:8081`

### Communication
- **Gotify**: `http://localhost:8085`
- **Mailhog**: `http://localhost:8025`

## 🔧 Mode Management

Use the `kompose-local.sh` script to manage configuration modes:

```bash
# Check current mode
./kompose-local.sh status

# Switch to local development
./kompose-local.sh local

# Switch to production
./kompose-local.sh prod

# Save current config as production default
./kompose-local.sh save-prod

# Create backup
./kompose-local.sh backup

# Show help
./kompose-local.sh help
```

## 📋 Configuration Differences

### Local Mode
- ✅ Services on `localhost` with ports
- ✅ No domain names needed
- ✅ No SSL/TLS certificates
- ✅ No DNS configuration
- ✅ Direct database connections
- ✅ Traefik optional (disabled by default)
- ✅ Simple authentication
- ✅ Fast iteration

### Production Mode
- ✅ Services on subdomains (`service.domain.com`)
- ✅ Automatic SSL with Let's Encrypt
- ✅ Traefik reverse proxy
- ✅ OAuth2 SSO authentication
- ✅ Production-grade security
- ✅ Multi-tenant capable

## 🎯 Key Features

### 1. Easy Mode Switching
```bash
./kompose-local.sh local  # Switch to local
./kompose-local.sh prod   # Switch to production
```

### 2. Automatic Backups
The script automatically backs up your configuration before switching modes:
```
backups/config_backup_20250101_120000/
├── .env
├── domain.env
└── secrets.env
```

### 3. Local-Friendly Defaults
- Simple passwords for development
- Direct port access
- No SSL complexity
- Fast startup times

### 4. Production Preservation
Your production configuration is safe:
- Automatic backups before switches
- `.env.production` and `domain.env.production` saved
- Easy restoration

## 🛠️ Development Workflow

### KMPS Development Example

```bash
# 1. Switch to local mode
./kompose-local.sh local

# 2. Start required services
./kompose.sh up core auth

# 3. Develop KMPS
cd kmps
npm install
npm run dev

# 4. Access at http://localhost:3100
# 5. Make changes (hot reload enabled)
# 6. Test locally
```

### Testing Locally

```bash
# Start services
./kompose.sh up core auth kmps

# Check health
curl http://localhost:3100/api/health
curl http://localhost:8180/realms/kompose

# View logs
./kompose.sh logs kmps -f

# Access services
open http://localhost:3100
```

## 🔐 Local Secrets

For local development, use simple secrets:

```bash
# secrets.env (local development)
DB_PASSWORD=local_dev_pass
REDIS_PASSWORD=local_redis_pass
KC_ADMIN_PASSWORD=admin
KMPS_CLIENT_SECRET=<from-keycloak>
KMPS_NEXTAUTH_SECRET=$(openssl rand -base64 32)
```

⚠️ **Note**: These are for LOCAL DEVELOPMENT only! Never use in production.

## 📚 Documentation

Complete documentation available:

1. **`LOCAL_DEVELOPMENT.md`** - Comprehensive local dev guide
   - Quick start
   - Service URLs
   - Troubleshooting
   - Best practices

2. **`kmps/DEVELOPMENT.md`** - KMPS-specific development
   - Keycloak setup
   - Environment configuration
   - API testing

3. **`kmps/QUICK_START.md`** - Fast setup guide
   - 5-minute setup
   - Common issues
   - Quick commands

## 🐛 Troubleshooting

### Port Already in Use
```bash
# Find what's using the port
lsof -i :3100

# Kill it or change the port in .env.local
KMPS_APP_PORT=3101
```

### Cannot Connect to Keycloak
```bash
# Verify Keycloak is running
docker ps | grep keycloak

# Check logs
docker logs auth_keycloak

# Restart if needed
./kompose.sh down auth
./kompose.sh up auth
```

### Database Connection Failed
```bash
# Check PostgreSQL
docker ps | grep postgres

# Test connection
docker exec core_postgres pg_isready

# Restart core services
./kompose.sh down core
./kompose.sh up core
```

## 🎓 Examples

### Example 1: Fresh Local Setup

```bash
# Clone and setup
cd /home/valknar/Projects/kompose

# Switch to local mode
./kompose-local.sh local

# Create secrets (simple for dev)
cat > secrets.env << 'EOF'
DB_PASSWORD=dev123
REDIS_PASSWORD=dev123
KC_ADMIN_PASSWORD=admin
KMPS_CLIENT_SECRET=change-after-keycloak
KMPS_NEXTAUTH_SECRET=$(openssl rand -base64 32)
EOF

# Start services
./kompose.sh up core
./kompose.sh up auth
./kompose.sh up kmps

# Configure Keycloak (http://localhost:8180)
# - Login: admin / admin
# - Create kmps-admin client
# - Get secret, update secrets.env

# Access KMPS
open http://localhost:3100
```

### Example 2: Switching Modes

```bash
# Currently in production mode
./kompose-local.sh status
# Output: Current Mode: PRODUCTION

# Switch to local for development
./kompose-local.sh local
# (automatically backs up production config)

# Develop and test
./kompose.sh up core auth kmps

# Switch back to production
./kompose-local.sh prod
# (restores production config)
```

### Example 3: Multiple Stacks Locally

```bash
# Start all major stacks
./kompose-local.sh local
./kompose.sh up core auth kmps code chain home

# Access all services:
# - KMPS: http://localhost:3100
# - Gitea: http://localhost:3001
# - n8n: http://localhost:5678
# - Home Assistant: http://localhost:8123
```

## ✨ Benefits of Local Mode

1. **No Domain Setup** - Skip DNS configuration entirely
2. **Fast Iteration** - Instant changes, no SSL delays
3. **Easy Debugging** - Direct port access, clear URLs
4. **Resource Efficient** - No Traefik overhead
5. **Simple Auth** - Optional OAuth2, basic auth works
6. **Port Flexibility** - Easy to change ports
7. **Team Friendly** - Same setup for everyone
8. **Production Preview** - Test before deploying

## 🔄 Migration Path

### From Production to Local

```bash
# 1. Save your production config first
./kompose-local.sh save-prod

# 2. Switch to local
./kompose-local.sh local

# 3. Adjust secrets.env for local (simpler passwords)
nano secrets.env

# 4. Restart services
./kompose.sh down
./kompose.sh up core auth kmps
```

### From Local to Production

```bash
# 1. Test everything locally first
./kompose.sh status
curl http://localhost:3100/api/health

# 2. Switch to production
./kompose-local.sh prod

# 3. Update secrets.env with strong passwords
nano secrets.env

# 4. Deploy
./kompose.sh up proxy  # Start Traefik
./kompose.sh up core auth kmps
```

## 📊 Comparison Table

| Feature | Local Mode | Production Mode |
|---------|------------|-----------------|
| **Access** | `localhost:PORT` | `subdomain.domain.com` |
| **SSL/TLS** | ❌ Not needed | ✅ Automatic (Let's Encrypt) |
| **Traefik** | ❌ Optional | ✅ Required |
| **OAuth2** | ❌ Optional | ✅ Recommended |
| **Setup Time** | ⚡ 5 minutes | ⏰ 30 minutes |
| **DNS Required** | ❌ No | ✅ Yes |
| **Complexity** | 🟢 Low | 🟡 Medium |
| **Security** | 🟡 Basic | 🟢 Production-grade |

## 🎉 You're All Set!

Everything is ready for local development:

- ✅ Local configuration files created
- ✅ Mode switcher script ready
- ✅ Local compose files configured
- ✅ Comprehensive documentation written
- ✅ Example workflows provided
- ✅ Troubleshooting guide included

## 🚀 Next Steps

1. **Switch to local mode**:
   ```bash
   ./kompose-local.sh local
   ```

2. **Start services**:
   ```bash
   ./kompose.sh up core auth kmps
   ```

3. **Configure Keycloak**:
   - Visit: `http://localhost:8180`
   - Login: admin / admin
   - Create kmps-admin client

4. **Access KMPS**:
   - Visit: `http://localhost:3100`
   - Login with Keycloak

5. **Start developing**!

## 📖 Documentation Reference

- **Main Guide**: `LOCAL_DEVELOPMENT.md`
- **KMPS Dev**: `kmps/DEVELOPMENT.md`
- **Quick Start**: `kmps/QUICK_START.md`
- **Mode Switcher**: `./kompose-local.sh help`

---

**Happy Local Development! 🎈**

For questions or issues, check the troubleshooting section in `LOCAL_DEVELOPMENT.md`
