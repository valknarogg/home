# Kompose Environment Configuration - Quick Reference

## 🎯 New Configuration System

### File Structure
```
kompose/
├── .env                     # 📋 All stack configurations
├── secrets.env             # 🔐 Sensitive data (not in git)
├── domain.env              # 🌐 Domain settings
├── kompose-env.sh          # ⚙️ Environment manager (new)
└── <stack>/.env.generated  # 🔄 Auto-generated (temporary)
```

### Variable Naming
```bash
# Stack-scoped variables
STACKNAME_VARIABLE=value

# Examples:
CORE_POSTGRES_IMAGE=postgres:16-alpine
AUTH_KC_ADMIN_USERNAME=admin
HOME_HOMEASSISTANT_PORT=8123

# Shared variables (no prefix)
NETWORK_NAME=kompose
TIMEZONE=Europe/Amsterdam
DB_HOST=core-postgres
```

## 🚀 Quick Start

### 1. Migrate (First Time Only)
```bash
chmod +x migrate-to-centralized-env.sh
./migrate-to-centralized-env.sh
```

### 2. Configure Secrets
```bash
# Generate secrets
./kompose.sh secrets generate

# Edit secrets.env
vim secrets.env
# Add your passwords and tokens
```

### 3. Start Stacks
```bash
# Start individual stack
./kompose.sh up core

# Start all stacks
./kompose.sh up

# Check status
./kompose.sh status
```

## 🔧 Common Commands

### Environment Management
```bash
# Show stack environment
./kompose.sh env show core

# Validate configuration
./kompose.sh env validate auth

# List all stack variables
./kompose.sh env list
```

### Stack Operations
```bash
# Start/stop
./kompose.sh up <stack>
./kompose.sh down <stack>
./kompose.sh restart <stack>

# Monitor
./kompose.sh status <stack>
./kompose.sh logs <stack> -f

# Validate
./kompose.sh validate <stack>
```

### Configuration Changes
```bash
# 1. Edit root .env
vim .env

# 2. Find your stack section
# Example: CORE_POSTGRES_MAX_CONNECTIONS=200

# 3. Restart stack
./kompose.sh restart core
```

## 📝 Configuration Sections

Each stack has its own section in `.env`:

```bash
# Core Infrastructure
CORE_POSTGRES_IMAGE=...
CORE_REDIS_IMAGE=...
CORE_MQTT_PORT=...

# Authentication
AUTH_DOCKER_IMAGE=...
AUTH_KC_ADMIN_USERNAME=...
AUTH_DB_NAME=...

# Home Automation  
HOME_HOMEASSISTANT_IMAGE=...
HOME_MATTER_SERVER_IMAGE=...

# ... and more
```

## 🔐 Secrets Management

### Generate Secrets
```bash
./kompose.sh secrets generate
```

### Edit Secrets
```bash
vim secrets.env

# Required secrets:
CORE_DB_PASSWORD=xxx
CORE_REDIS_PASSWORD=xxx
AUTH_KC_ADMIN_PASSWORD=xxx
# ... and more
```

### Security
```bash
# Set proper permissions
chmod 600 secrets.env

# Never commit
git status | grep secrets.env  # Should be nothing

# Verify ignored
cat .gitignore | grep secrets.env
```

## 🐛 Troubleshooting

### Stack Won't Start
```bash
# 1. Check environment
./kompose.sh env show <stack>

# 2. Validate
./kompose.sh env validate <stack>

# 3. View generated config
cat <stack>/.env.generated

# 4. Check docker-compose config
cd <stack>
docker-compose --env-file .env.generated config
```

### Variable Not Found
```bash
# Search in .env
grep "STACK_VAR" .env

# Show stack environment
./kompose.sh env show <stack>

# Check for typos
grep -i "variable" .env
```

### Secrets Not Loading
```bash
# Check file exists
ls -l secrets.env

# Fix permissions
chmod 600 secrets.env

# Test loading
source secrets.env && echo $SECRET_VAR

# Restart stack
./kompose.sh restart <stack>
```

## 📚 Documentation

- **Migration Guide:** `_docs/content/3.guide/environment-migration.md`
- **Configuration Reference:** `_docs/content/4.reference/stack-configuration.md`
- **Stack Docs:** `_docs/content/5.stacks/`
- **Full Summary:** `MIGRATION_SUMMARY.md`

## 🎓 Examples

### Change PostgreSQL Max Connections
```bash
vim .env
# Find: CORE_POSTGRES_MAX_CONNECTIONS=100
# Change to: CORE_POSTGRES_MAX_CONNECTIONS=200
./kompose.sh restart core
```

### Add New Secret
```bash
vim secrets.env
# Add: NEWSTACK_API_KEY=your-secret-key
./kompose.sh restart newstack
```

### View Current Configuration
```bash
# Show all core variables
./kompose.sh env show core

# Show specific variable
./kompose.sh env show core | grep POSTGRES
```

### Debug Stack Startup
```bash
# Validate first
./kompose.sh env validate core

# Try starting
./kompose.sh up core

# Check logs
./kompose.sh logs core -f

# View generated env
cat core/.env.generated
```

## ✨ Key Features

- ✅ Centralized configuration (one `.env` file)
- ✅ Stack scoping (variables isolated per stack)
- ✅ Auto-generated files (temporary `.env.generated`)
- ✅ Built-in validation
- ✅ Easy testing and switching
- ✅ Clear documentation

## 🎯 Stack Prefixes

| Stack | Prefix | Example |
|-------|--------|---------|
| Core | `CORE_` | `CORE_POSTGRES_IMAGE` |
| Auth | `AUTH_` | `AUTH_KC_ADMIN_USERNAME` |
| Home | `HOME_` | `HOME_HOMEASSISTANT_PORT` |
| Chain | `CHAIN_` | `CHAIN_N8N_PORT` |
| Code | `CODE_` | `CODE_GITEA_PORT_HTTP` |
| Proxy | `PROXY_` | `PROXY_TRAEFIK_PORT_HTTP` |
| VPN | `VPN_` | `VPN_WG_PORT` |
| Messaging | `MESSAGING_` | `MESSAGING_GOTIFY_PORT` |

## 💡 Tips

1. **Always validate** before starting: `./kompose.sh env validate <stack>`
2. **Check generated files** if issues: `cat <stack>/.env.generated`
3. **Use secrets.env** for passwords, never `.env`
4. **Test individually** when making changes
5. **Keep backups** in `backups/env-migration-*/`

---

**Need help?** Read `MIGRATION_SUMMARY.md` or check the docs in `_docs/content/`!
