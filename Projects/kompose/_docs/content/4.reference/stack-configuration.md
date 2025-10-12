---
title: Stack Configuration Overview
description: Understanding the centralized environment configuration system
navigation:
  icon: i-lucide-settings
---

# Stack Configuration Overview

## 🎯 What Changed?

Kompose now uses a **centralized environment configuration** system. All stack configurations are managed from a single root `.env` file instead of individual `.env` files in each stack directory.

## 🏗️ Architecture

### Configuration Files

```
kompose/
├── .env                    # 📋 Main configuration (all stacks)
├── domain.env             # 🌐 Domain settings  
├── secrets.env            # 🔐 Sensitive data (not in git)
├── kompose-env.sh         # ⚙️ Environment management module
│
├── core/
│   ├── compose.yaml       # 🐳 Docker Compose file
│   └── .env.generated     # 🔄 Auto-generated (temporary)
│
├── auth/
│   ├── compose.yaml
│   └── .env.generated
│
└── ... (other stacks)
```

### How It Works

1. **Centralized Storage**: All configurations in root `.env`
2. **Stack Scoping**: Variables prefixed by stack name
3. **Automatic Mapping**: System maps scoped → generic names
4. **Generated Files**: Temporary `.env.generated` for docker-compose
5. **Gitignored**: Generated files never committed

## 📝 Variable Naming Convention

### Stack-Scoped Variables

Format: `STACKNAME_VARIABLE_NAME`

```bash
# Core stack variables
CORE_POSTGRES_IMAGE=postgres:16-alpine
CORE_DB_USER=kompose
CORE_REDIS_PASSWORD=${REDIS_PASSWORD}

# Auth stack variables  
AUTH_DOCKER_IMAGE=quay.io/keycloak/keycloak:latest
AUTH_KC_ADMIN_USERNAME=admin
AUTH_DB_NAME=keycloak

# Home stack variables
HOME_HOMEASSISTANT_IMAGE=ghcr.io/home-assistant/home-assistant:stable
HOME_HOMEASSISTANT_PORT=8123
```

### Shared Variables

No prefix - used by all stacks:

```bash
# Network & Infrastructure
NETWORK_NAME=kompose
TIMEZONE=Europe/Amsterdam

# Database Connection (shared)
DB_HOST=core-postgres
DB_PORT=5432
DB_USER=kompose

# Email Settings (shared)
EMAIL_FROM=hi@example.com
EMAIL_SMTP_HOST=smtp.example.com
```

### Secret Variables

Stored in `secrets.env` (never committed):

```bash
# Shared secrets
DB_PASSWORD=xxx
REDIS_PASSWORD=xxx

# Stack-specific secrets
AUTH_KC_ADMIN_PASSWORD=xxx
CHAIN_N8N_ENCRYPTION_KEY=xxx
CODE_GITEA_SECRET_KEY=xxx
```

## 🎨 Usage Examples

### Viewing Configuration

```bash
# Show environment for a specific stack
kompose env show core

# List all stack variables
kompose env list

# Validate configuration
kompose env validate auth
```

### Editing Configuration

```bash
# 1. Edit root .env
vim .env

# 2. Find your stack section
# Example: Change PostgreSQL max connections
CORE_POSTGRES_MAX_CONNECTIONS=200

# 3. Restart the stack
kompose restart core
```

### Running Stacks

No changes needed - same commands:

```bash
# Start stack
kompose up core

# Stop stack
kompose down auth

# View logs
kompose logs home -f

# Check status
kompose status
```

## 🔧 Configuration Sections

Each stack has its own section in the root `.env`:

```bash
# ===================================================================
# CORE STACK CONFIGURATION
# ===================================================================
CORE_COMPOSE_PROJECT_NAME=core

# PostgreSQL
CORE_POSTGRES_IMAGE=postgres:16-alpine
CORE_DB_USER=kompose
CORE_DB_NAME=kompose
CORE_POSTGRES_MAX_CONNECTIONS=100

# Redis
CORE_REDIS_IMAGE=redis:7-alpine

# MQTT
CORE_MOSQUITTO_IMAGE=eclipse-mosquitto:2
CORE_MQTT_PORT=1883

# ===================================================================
# AUTH STACK CONFIGURATION
# ===================================================================
AUTH_COMPOSE_PROJECT_NAME=auth

# Keycloak
AUTH_DOCKER_IMAGE=quay.io/keycloak/keycloak:latest
AUTH_DB_NAME=keycloak
AUTH_KC_ADMIN_USERNAME=admin

# OAuth2 Proxy
AUTH_OAUTH2_CLIENT_ID=kompose-sso
AUTH_OAUTH2_PROXY_HOST=${TRAEFIK_HOST_OAUTH2}

# ... and so on for each stack
```

## 📚 Stack-Specific Documentation

Each stack has detailed documentation in the stacks section:

- :icon{name="lucide:database"} [Core Stack](/stacks/core) - PostgreSQL, Redis, MQTT
- :icon{name="lucide:lock"} [Auth Stack](/stacks/auth) - Keycloak, OAuth2 Proxy
- :icon{name="lucide:home"} [Home Stack](/stacks/home) - Home Assistant, Matter
- :icon{name="lucide:git-branch"} [Code Stack](/stacks/code) - Gitea, CI/CD
- :icon{name="lucide:workflow"} [Chain Stack](/stacks/chain) - n8n, Semaphore
- :icon{name="lucide:shield"} [VPN Stack](/stacks/vpn) - WireGuard
- :icon{name="lucide:bell"} [Messaging Stack](/stacks/messaging) - Gotify

## 🎯 Quick Reference

### Configuration Hierarchy

```
1. Root .env (base configuration)
   ↓
2. secrets.env (sensitive data)
   ↓  
3. Stack-scoped variables (STACKNAME_VAR)
   ↓
4. Environment mapping (STACKNAME_VAR → VAR)
   ↓
5. .env.generated (passed to docker-compose)
```

### Common Tasks

```bash
# Configure a stack
# Edit: .env → Find STACKNAME section → Modify values → Save

# Add a secret
# Edit: secrets.env → Add STACKNAME_SECRET_NAME=value → Save

# Change domain
# Edit: domain.env → Update ROOT_DOMAIN → Restart

# Validate changes
kompose validate stackname

# Apply changes
kompose restart stackname
```

## 🔐 Security Best Practices

### ✅ Do

- Store secrets in `secrets.env`
- Use strong, unique passwords
- Keep `secrets.env` out of git (it's in .gitignore)
- Use `kompose secrets generate` for secure passwords
- Set proper file permissions: `chmod 600 secrets.env`

### ❌ Don't

- Put passwords in `.env`
- Commit `secrets.env` or `.env.generated`
- Share secrets via chat/email
- Use default/weak passwords
- Store API tokens in compose files

## 🐛 Troubleshooting

### Stack Won't Start

```bash
# 1. Check environment loading
kompose env show stackname

# 2. Validate configuration  
kompose env validate stackname

# 3. View generated file
cat stackname/.env.generated

# 4. Test docker-compose config
cd stackname && docker-compose config
```

### Variable Not Found

```bash
# Check if variable is defined
grep "STACKNAME_VARNAME" .env

# Check for typos
grep -i "varname" .env

# Verify it's exported
kompose env show stackname | grep VARNAME
```

### Secrets Not Loading

```bash
# 1. Verify secrets.env exists
ls -l secrets.env

# 2. Check permissions
chmod 600 secrets.env

# 3. Test loading
source secrets.env && echo $SECRET_VAR

# 4. Restart stack
kompose restart stackname
```

## 📖 Additional Resources

- [Environment Migration Guide](/guide/environment-migration) - Detailed migration steps
- [Stack Configuration Examples](/guide/configuration-examples) - Real-world examples
- [Secrets Management](/guide/secrets-management) - Security best practices
- [Troubleshooting Guide](/guide/troubleshooting) - Common issues and solutions

## 🎓 Learning Path

1. **Understand the basics** → Read this overview
2. **See it in action** → Run `kompose env show core`
3. **Make a change** → Edit `.env` and restart a stack
4. **Learn secrets** → Read secrets management guide
5. **Explore stacks** → Check individual stack documentation

---

:icon{name="lucide:lightbulb"} **Tip**: Start with the **Core** stack to understand the basics, then explore other stacks. Each stack's documentation shows exactly which variables it uses.
