---
title: Environment Setup & Switching
description: Manage local and production configurations with the setup command
---

Learn how to seamlessly switch between local development and production environments using Kompose's setup management system.

## Overview

The `kompose.sh setup` command provides tools to:

- Switch between local and production configurations
- Backup configurations before switching
- View current environment status
- Save production configurations for reuse

## Commands

### Setup Status

Check your current environment configuration:

```bash
./kompose.sh setup status
```

**Example output (local mode):**
```
═══════════════════════════════════════
      Configuration Status
═══════════════════════════════════════

✓ Current Mode: LOCAL DEVELOPMENT

Local Development Services:
  Core Services:
    PostgreSQL:      localhost:5432
    Redis:           localhost:6379
    MQTT:            localhost:1883

  Main Applications:
    Keycloak:        http://localhost:8180
    KMPS:            http://localhost:3100
    Gitea:           http://localhost:3001
    n8n:             http://localhost:5678
    Home Assistant:  http://localhost:8123
```

### Switch to Local Development

Activate local development configuration:

```bash
./kompose.sh setup local
```

**What happens:**
1. Current configuration is backed up
2. `.env.local` → `.env`
3. `domain.env.local` → `domain.env`
4. Services configured for localhost access
5. Traefik disabled (direct port access)

**Use when:**
- Developing locally
- Testing without domain
- No SSL needed
- Quick iteration cycles

### Switch to Production

Activate production configuration:

```bash
./kompose.sh setup prod
```

**What happens:**
1. Current configuration is backed up
2. `.env.production` → `.env`
3. `domain.env.production` → `domain.env`
4. Services configured for domain access
5. Traefik enabled with SSL

**Use when:**
- Deploying to production server
- Testing production configuration
- SSL certificates needed
- Domain-based routing required

### Backup Current Configuration

Create a backup without switching:

```bash
./kompose.sh setup backup
```

Backups are stored in:
```
backups/config_backup_YYYYMMDD_HHMMSS/
├── .env
├── domain.env
└── secrets.env
```

### Save Production Configuration

Save current setup as production default:

```bash
./kompose.sh setup save-prod
```

**What happens:**
- `.env` → `.env.production`
- `domain.env` → `domain.env.production`

**Use when:**
- You've manually configured production
- Want to preserve current settings
- Need to revert later

## Environment Modes

### Local Development Mode

**Configuration files:**
```
.env.local          # Main environment (localhost)
domain.env.local    # Local domain config
```

**Characteristics:**
- ✅ No domain required
- ✅ Direct port access
- ✅ Fast setup
- ✅ No SSL configuration
- ✅ Development-friendly defaults
- ⚠️ Not suitable for production

**Service Access:**
| Service | URL | Port |
|---------|-----|------|
| PostgreSQL | localhost:5432 | 5432 |
| Redis | localhost:6379 | 6379 |
| MQTT | localhost:1883 | 1883 |
| Keycloak | http://localhost:8180 | 8180 |
| KMPS | http://localhost:3100 | 3100 |
| Gitea | http://localhost:3001 | 3001 |
| n8n | http://localhost:5678 | 5678 |

### Production Mode

**Configuration files:**
```
.env.production     # Main environment (domain-based)
domain.env.production  # Production domain config
```

**Characteristics:**
- ✅ Domain-based routing
- ✅ SSL/TLS encryption
- ✅ Traefik reverse proxy
- ✅ OAuth2 SSO integration
- ✅ Production-ready security
- ⚠️ Requires DNS configuration

**Service Access:**
| Service | URL |
|---------|-----|
| Keycloak | https://auth.yourdomain.com |
| KMPS | https://manage.yourdomain.com |
| Gitea | https://code.yourdomain.com |
| n8n | https://chain.yourdomain.com |

## Configuration Files

### `.env` - Main Environment

**Local development:**
```bash
# Environment
COMPOSE_PROJECT_NAME=kompose
DOCKER_NETWORK=kompose
ENV=development

# Traefik
TRAEFIK_ENABLED=false

# Service URLs (localhost)
KC_BASE_URL=http://localhost:8180
KMPS_URL=http://localhost:3100
GITEA_URL=http://localhost:3001
N8N_WEBHOOK_BASE=http://localhost:5678/webhook
```

**Production:**
```bash
# Environment
COMPOSE_PROJECT_NAME=kompose
DOCKER_NETWORK=kompose
ENV=production

# Traefik
TRAEFIK_ENABLED=true
TRAEFIK_HOST=${ROOT_DOMAIN}

# Service URLs (domain-based)
KC_BASE_URL=https://auth.${ROOT_DOMAIN}
KMPS_URL=https://manage.${ROOT_DOMAIN}
GITEA_URL=https://code.${ROOT_DOMAIN}
N8N_WEBHOOK_BASE=https://chain.${ROOT_DOMAIN}/webhook
```

### `domain.env` - Domain Configuration

**Local development:**
```bash
# Local development - no real domain needed
ROOT_DOMAIN=localhost

# Subdomains (not used in local mode)
SUBDOMAIN_AUTH=auth
SUBDOMAIN_KMPS=manage
SUBDOMAIN_CHAIN=chain
SUBDOMAIN_CODE=code
SUBDOMAIN_HOME=home
```

**Production:**
```bash
# Production domain
ROOT_DOMAIN=example.com

# SSL Configuration
ACME_EMAIL=admin@example.com
SSL_PROVIDER=letsencrypt

# Subdomains (automatically combined with ROOT_DOMAIN)
SUBDOMAIN_AUTH=auth        # https://auth.example.com
SUBDOMAIN_KMPS=manage      # https://manage.example.com
SUBDOMAIN_CHAIN=chain      # https://chain.example.com
SUBDOMAIN_CODE=code        # https://code.example.com
SUBDOMAIN_HOME=home        # https://home.example.com
SUBDOMAIN_VPN=vpn          # https://vpn.example.com

# Auto-generated Traefik hosts (from SUBDOMAIN_* + ROOT_DOMAIN)
TRAEFIK_HOST=${SUBDOMAIN_AUTH}.${ROOT_DOMAIN}
N8N_TRAEFIK_HOST=${SUBDOMAIN_CHAIN}.${ROOT_DOMAIN}
SEMAPHORE_TRAEFIK_HOST=${SUBDOMAIN_AUTO}.${ROOT_DOMAIN}
TRAEFIK_HOST_HOME=${SUBDOMAIN_HOME}.${ROOT_DOMAIN}
TRAEFIK_HOST_ZIGBEE=${SUBDOMAIN_ZIGBEE}.${ROOT_DOMAIN}
OAUTH2_PROXY_HOST=${SUBDOMAIN_OAUTH2}.${ROOT_DOMAIN}
```

### `secrets.env` - Credentials

**Same structure for both modes, but values differ:**

```bash
# Database
POSTGRES_PASSWORD=<secure-password>
DB_PASSWORD=<secure-password>

# Redis
REDIS_PASSWORD=<secure-password>

# Keycloak
KC_ADMIN_PASSWORD=<secure-password>

# OAuth2
OAUTH2_CLIENT_SECRET=<secure-secret>
OAUTH2_COOKIE_SECRET=<auto-generated-32-bytes>

# KMPS
KMPS_CLIENT_SECRET=<from-keycloak>
KMPS_NEXTAUTH_SECRET=<auto-generated-32-bytes>
```

::alert{type="danger"}
**Critical:** Use strong, unique passwords in production! Never reuse development passwords.
::

## Workflow Examples

### Development to Production

**Scenario:** You've developed locally and are ready to deploy:

```bash
# 1. Save current local config
./kompose.sh setup backup

# 2. Stop local services
./kompose.sh down

# 3. Switch to production mode
./kompose.sh setup prod

# 4. Update secrets with strong passwords
nano secrets.env

# 5. Update domain configuration
nano domain.env
# Set ROOT_DOMAIN=yourdomain.com

# 6. Save production config
./kompose.sh setup save-prod

# 7. Deploy to production server
git push production main
```

### Production Testing Locally

**Scenario:** Test production config before deploying:

```bash
# 1. Ensure you have production configs
ls .env.production domain.env.production

# 2. Switch to production mode
./kompose.sh setup prod

# 3. Update domain to localhost for testing
nano domain.env
# Change ROOT_DOMAIN=yourdomain.com to ROOT_DOMAIN=localhost

# 4. Test with Traefik disabled
nano .env
# Set TRAEFIK_ENABLED=false

# 5. Start services
./kompose.sh up

# 6. When done, switch back to local
./kompose.sh setup local
```

### Multiple Environment Maintenance

**Scenario:** Maintain separate dev, staging, and prod configs:

```bash
# Create staging configuration
cp .env.production .env.staging
nano .env.staging  # Adjust for staging

# Switch to staging
cp .env.staging .env
./kompose.sh up

# Switch back to local
./kompose.sh setup local

# Deploy to production
./kompose.sh setup prod
```

## Advanced Setup

### Custom Configuration Templates

Create custom templates for different scenarios:

```bash
# Create demo configuration
cp .env.local .env.demo
nano .env.demo
# Add demo-specific settings

# Use demo config
cp .env.demo .env
./kompose.sh restart
```

### Environment-Specific Secrets

Maintain separate secrets for each environment:

```bash
# Create environment-specific secrets
cp secrets.env secrets.env.local
cp secrets.env secrets.env.prod

# When switching environments
cp secrets.env.local secrets.env  # For local
cp secrets.env.prod secrets.env   # For production
```

### Automated Switching

Create helper scripts for common switches:

```bash
#!/bin/bash
# switch-to-local.sh

./kompose.sh down
./kompose.sh setup local
cp secrets.env.local secrets.env
./kompose.sh up core
```

## Configuration Backup Strategy

### Automatic Backups

The setup command automatically backs up before switching:

```
backups/config_backup_20250113_143022/
├── .env
├── domain.env
└── secrets.env
```

### Manual Backup Routine

Recommended backup schedule:

```bash
# Daily backup script
#!/bin/bash
DATE=$(date +%Y%m%d)
BACKUP_DIR="backups/manual_$DATE"

mkdir -p "$BACKUP_DIR"
cp .env "$BACKUP_DIR/"
cp domain.env "$BACKUP_DIR/"
cp secrets.env "$BACKUP_DIR/"

echo "Backup created: $BACKUP_DIR"
```

### Restoring from Backup

```bash
# List available backups
ls backups/

# Restore specific backup
BACKUP="backups/config_backup_20250113_143022"
cp "$BACKUP/.env" .env
cp "$BACKUP/domain.env" domain.env
cp "$BACKUP/secrets.env" secrets.env

# Verify and restart
./kompose.sh validate
./kompose.sh restart
```

## Troubleshooting

### Wrong Environment Active

**Symptom:** Services not accessible as expected

```bash
# Check current mode
./kompose.sh setup status

# Switch to correct mode
./kompose.sh setup local  # or prod

# Restart affected services
./kompose.sh restart
```

### Configuration File Conflicts

**Symptom:** Settings from old environment persist

```bash
# Stop all services
./kompose.sh down

# Force clean environment switch
rm .env domain.env
./kompose.sh setup local  # Fresh config

# Restart
./kompose.sh up
```

### Lost Production Configuration

**Symptom:** .env.production missing or corrupted

```bash
# Check backups
ls backups/config_backup_*/

# Restore from latest backup
LATEST=$(ls -t backups/config_backup_* | head -n1)
cp "$LATEST/.env" .env.production
cp "$LATEST/domain.env" domain.env.production

# Verify
./kompose.sh setup prod
./kompose.sh validate
```

### Environment Mismatch After Git Pull

**Symptom:** Configuration reset after pulling updates

```bash
# Save your local customizations
cp .env .env.my-local
cp domain.env domain.env.my-local
cp secrets.env secrets.env.my-local

# Pull updates
git pull

# Restore your customizations
cp .env.my-local .env
cp domain.env.my-local domain.env
cp secrets.env.my-local secrets.env
```

## Best Practices

### Development

1. **Always use local mode for development:**
   ```bash
   ./kompose.sh setup local
   ```

2. **Keep secrets simple but unique:**
   - Use memorable but secure passwords
   - Different from production
   - Document in team wiki

3. **Regular backups:**
   ```bash
   ./kompose.sh setup backup
   ```

### Production

1. **Never use development passwords in production**

2. **Save production config before changes:**
   ```bash
   ./kompose.sh setup backup
   ```

3. **Test configuration before deployment:**
   ```bash
   ./kompose.sh validate
   ```

4. **Document your domain setup:**
   - DNS records
   - SSL configuration
   - Subdomain structure

5. **Version control (excluding secrets):**
   ```bash
   git add .env.production domain.env.production
   git commit -m "Update production config"
   ```

### Security

1. **Never commit secrets.env:**
   ```bash
   # Check .gitignore includes:
   secrets.env
   secrets.env.*
   ```

2. **Use strong passwords in production:**
   ```bash
   # Generate secure passwords
   openssl rand -base64 32
   ```

3. **Rotate secrets regularly:**
   - Update every 90 days
   - After team member changes
   - If compromised

4. **Limit access to production configs:**
   ```bash
   chmod 600 secrets.env
   chmod 600 .env.production
   ```

## Migration Guide

### From Legacy Setup

If you have old configuration files:

```bash
# Backup old setup
mkdir backups/legacy
cp .env* domain.env* secrets.env* backups/legacy/

# Create new structure
./kompose.sh init

# Migrate settings manually
# Review backups/legacy/ files
# Update new .env with your custom settings
```

### Between Kompose Versions

```bash
# Before updating Kompose
./kompose.sh setup backup

# Update Kompose
git pull origin main

# Verify configuration
./kompose.sh validate

# Re-initialize if needed
./kompose.sh init
```

## Summary

The setup system provides:
- ✅ Easy switching between environments
- ✅ Automatic configuration backup
- ✅ Clear visibility of current mode
- ✅ Safe configuration management
- ✅ Flexible deployment workflows

Master these commands for smooth environment management! 🎯
