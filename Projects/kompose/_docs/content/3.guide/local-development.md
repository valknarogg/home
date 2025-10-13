# Local Development Guide

Complete guide for running Kompose stacks locally without domain names or SSL certificates.

## 🎯 Overview

Local development mode allows you to:
- Run all services on `localhost` with specific ports
- No domain names or DNS configuration needed
- No SSL/TLS certificates required
- Direct database and service connections
- Faster iteration and debugging
- No Traefik reverse proxy needed (optional)

## 🚀 Quick Start

### Automated Setup (Recommended)

```bash
# Switch to local development mode
./kompose.sh setup local

# Start core services
./kompose.sh up core

# Start auth services
./kompose.sh up auth

# Start KMPS
./kompose.sh up kmps

# Access services
open http://localhost:8180  # Keycloak
open http://localhost:3100  # KMPS
```

## 📋 Prerequisites

- Docker and Docker Compose
- Node.js 20+ (for local development)
- Git
- At least 4GB free RAM
- Ports available: 3100, 5432, 6379, 8180, etc.

## 🌐 Local Service URLs

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

### Communication & Tools
- **Gotify**: `http://localhost:8085`
- **Mailhog**: `http://localhost:8025`
- **Uptime Kuma**: `http://localhost:3001`

## 🔐 Local Secrets Configuration

### Generate Local Secrets

```bash
# Generate all secrets at once
cat > secrets.env << 'EOF'
# Database
DB_PASSWORD=local_dev_password

# Redis
REDIS_PASSWORD=local_redis_pass
REDIS_API_PASSWORD=local_redis_api

# Admin
ADMIN_PASSWORD=local_admin_pass

# Auth Stack
KC_ADMIN_PASSWORD=admin
AUTH_KEYCLOAK_ADMIN_PASSWORD=admin
OAUTH2_CLIENT_SECRET=local_oauth2_secret
OAUTH2_COOKIE_SECRET=$(openssl rand -base64 32)
AUTH_OAUTH2_CLIENT_SECRET=local_oauth2_secret
AUTH_OAUTH2_COOKIE_SECRET=$(openssl rand -base64 32)

# KMPS
KMPS_CLIENT_SECRET=change_after_keycloak_setup
KMPS_NEXTAUTH_SECRET=$(openssl rand -base64 32)

# Other services (as needed)
N8N_ENCRYPTION_KEY=local_n8n_key
GITEA_SECRET_KEY=$(openssl rand -hex 32)
EOF
```

### Security Notes for Local Development

⚠️ **Important**: These are LOCAL DEVELOPMENT secrets only!
- Use simple passwords for convenience
- Never use these in production
- Keep `secrets.env` in `.gitignore`
- Production secrets should be strong and unique

## 📦 Starting Services

### Start Order (Recommended)

```bash
# 1. Core services first (database, redis, mqtt)
./kompose.sh up core

# 2. Authentication services
./kompose.sh up auth

# 3. Application services (as needed)
./kompose.sh up kmps
./kompose.sh up code
./kompose.sh up chain
./kompose.sh up home
```

### Start All Services

```bash
# Start all stacks at once
./kompose.sh up core auth kmps code chain home
```

## 🛠️ Development Workflow

### KMPS Local Development

```bash
# Option A: Direct Node.js (hot reload)
cd kmps
npm install
export NODE_ENV=development
export KEYCLOAK_URL=http://localhost:8180
export KEYCLOAK_REALM=kompose
export KEYCLOAK_CLIENT_ID=kmps-admin
export KEYCLOAK_CLIENT_SECRET="your-secret"
export NEXTAUTH_URL=http://localhost:3100
export NEXTAUTH_SECRET="your-secret"
npm run dev

# Option B: Docker (matches deployment)
./kompose.sh up kmps
docker logs -f kmps_app
```

### Database Access

```bash
# Connect to PostgreSQL
docker exec -it core_postgres psql -U kompose -d kompose

# Connect to Redis
docker exec -it core_redis redis-cli
AUTH local_redis_pass

# View logs
docker logs core_postgres
docker logs core_redis
```

### Checking Service Health

```bash
# Check all services
./kompose.sh status

# Check specific stack
./kompose.sh status core
./kompose.sh status auth
./kompose.sh status kmps

# View logs
./kompose.sh logs kmps -f
./kompose.sh logs auth -f
```

## 🔍 Keycloak Setup (Local)

### Access Keycloak

1. Start auth stack: `./kompose.sh up auth`
2. Wait for startup (check logs: `docker logs auth_keycloak`)
3. Access: `http://localhost:8180`
4. Login: admin / admin (from secrets.env)

### Create KMPS Client (Local)

```bash
# Access Keycloak admin
open http://localhost:8180

# Create client:
# - Client ID: kmps-admin
# - Client auth: ON
# - Service accounts: ON
# - Redirect URIs: http://localhost:3100/*

# Get client secret and add to secrets.env:
KMPS_CLIENT_SECRET=<from-keycloak-credentials>

# Assign roles:
# - realm-admin
# - manage-users
# - view-users
# - query-users
```

### Testing Authentication

```bash
# Test Keycloak
curl http://localhost:8180/realms/kompose

# Test KMPS login
open http://localhost:3100
# Should redirect to Keycloak, login, then back to KMPS
```

## 🐛 Troubleshooting

### Port Conflicts

**Problem**: Port already in use

```bash
# Find what's using a port
lsof -i :3100
lsof -i :5432
lsof -i :8180

# Kill process or change port in .env.local
# Example: Change KMPS_APP_PORT from 3100 to 3101
```

### Cannot Connect to Database

**Problem**: Connection refused to localhost:5432

```bash
# Check if PostgreSQL is running
docker ps | grep postgres

# Check logs
docker logs core_postgres

# Restart core services
./kompose.sh down core
./kompose.sh up core

# Test connection
docker exec core_postgres pg_isready -U kompose
```

### Keycloak Not Starting

**Problem**: Keycloak container exits or won't start

```bash
# Check logs
docker logs auth_keycloak

# Common issues:
# 1. Database not ready - wait longer
# 2. Port 8180 in use - change in .env.local
# 3. Memory issues - check Docker resources

# Restart with clean state
./kompose.sh down auth
docker volume rm auth_keycloak_data
./kompose.sh up auth
```

### KMPS Authentication Loop

**Problem**: Keeps redirecting between KMPS and Keycloak

```bash
# 1. Clear browser cookies for localhost
# 2. Verify environment variables:
echo $NEXTAUTH_URL  # Should be http://localhost:3100
echo $KEYCLOAK_URL  # Should be http://localhost:8180

# 3. Check redirect URIs in Keycloak client
# Must include: http://localhost:3100/*

# 4. Restart KMPS
./kompose.sh down kmps
./kompose.sh up kmps
```

### Module Not Found Errors

**Problem**: NPM packages not found

```bash
cd kmps
rm -rf node_modules package-lock.json
npm install

# If using Docker, rebuild:
./kompose.sh down kmps
docker volume rm kmps_node_modules
./kompose.sh up kmps
```

### Network Issues

**Problem**: Containers can't communicate

```bash
# Check network exists
docker network ls | grep kompose

# Create if missing
docker network create kompose

# Restart services
./kompose.sh down
./kompose.sh up core auth kmps
```

## 🔄 Switching Modes

### Local → Production

```bash
# 1. Switch to production
./kompose.sh setup prod

# 2. Restart services
./kompose.sh down
./kompose.sh up proxy  # Start Traefik first
./kompose.sh up core auth kmps
```

### Production → Local

```bash
# 1. Switch to local
./kompose.sh setup local

# 2. Restart services
./kompose.sh down
./kompose.sh up core auth kmps
```

### Verify Current Mode

```bash
./kompose.sh setup status
```

## 📊 Performance Tips

### Docker Resources

Ensure Docker has enough resources:
- **Memory**: 4GB minimum, 8GB recommended
- **CPUs**: 2 cores minimum, 4 cores recommended
- **Disk**: 20GB free space

### Database Optimization (Local)

```bash
# PostgreSQL tuning for local dev
# Edit in .env.local:
CORE_POSTGRES_MAX_CONNECTIONS=50        # Reduced from 100
CORE_POSTGRES_SHARED_BUFFERS="128MB"    # Reduced from 256MB
```

### Selective Services

Only run what you need:

```bash
# Minimal setup (database + auth + KMPS)
./kompose.sh up core auth kmps

# Add code tools
./kompose.sh up code

# Add automation
./kompose.sh up chain
```

## 🧪 Testing

### API Testing

```bash
# Test Keycloak
curl http://localhost:8180/realms/kompose

# Test KMPS API
curl http://localhost:3100/api/health

# Test with authentication
curl http://localhost:3100/api/users \
  -H "Cookie: next-auth.session-token=<token>"
```

### Integration Testing

```bash
# Run integration tests (if available)
cd kmps
npm run test

# Or run specific tests
npm run test:integration
```

## 📝 Best Practices

### Do's ✅

- Use the `kompose.sh setup` command for mode switching
- Keep `secrets.env` in `.gitignore`
- Use simple passwords for local development
- Test features locally before deploying
- Use Docker for consistency
- Check logs frequently: `docker logs -f <container>`

### Don'ts ❌

- Don't commit `secrets.env` to git
- Don't use production secrets locally
- Don't mix local and production configs
- Don't expose local services to the internet
- Don't skip the backup when switching modes

## 🎓 Learning Resources

- **Keycloak Docs**: https://www.keycloak.org/documentation
- **Next.js Docs**: https://nextjs.org/docs
- **Docker Compose**: https://docs.docker.com/compose/
- **PostgreSQL**: https://www.postgresql.org/docs/

## 📚 Additional Documentation

- **KMPS Development**: `kmps/DEVELOPMENT.md`
- **Stack Documentation**: `_docs/content/5.stacks/kmps.md`
- **Quick Reference**: `_docs/content/3.guide/quick-reference.md`
- **Environment Setup**: `_docs/content/3.guide/environment-setup.md`

## 🆘 Getting Help

If you encounter issues:

1. Check logs: `docker logs <container_name>`
2. Verify configuration: `./kompose.sh setup status`
3. Check port availability: `lsof -i :<port>`
4. Review this guide's troubleshooting section
5. Check Docker resources and restart if needed

## 🎉 Summary

Local development mode provides:
- ✅ Fast setup (5 minutes)
- ✅ No domain configuration
- ✅ Direct port access
- ✅ Simple debugging
- ✅ Hot reload support
- ✅ Easy testing

**Ready to develop!** 🚀
