---
title: Secrets Management
description: Generate, manage, and rotate sensitive credentials securely
---

Learn how to manage secrets and sensitive credentials across your Kompose infrastructure with automated generation, validation, and rotation capabilities.

## Overview

The Kompose secrets management system provides:

- 🔐 **Automated generation** of strong, secure credentials
- 🔄 **Safe rotation** with automatic backups
- ✅ **Validation** to ensure all secrets are configured
- 📋 **Stack mapping** to track secret usage
- 🎯 **Multiple secret types** (passwords, tokens, UUIDs, htpasswd)
- 💾 **Backup and restore** capabilities

## Quick Start

### Initial Setup

After initializing your Kompose project:

```bash
# Generate all secrets automatically
./kompose.sh secrets generate

# Validate configuration
./kompose.sh secrets validate

# List secrets and their status
./kompose.sh secrets list
```

### Typical Workflow

```bash
# 1. Initialize project
./kompose.sh init

# 2. Generate secrets
./kompose.sh secrets generate

# 3. Validate
./kompose.sh secrets validate

# 4. Start stacks
./kompose.sh up
```

## Commands Reference

### Generate Secrets

Generate all missing secrets or specific ones:

```bash
# Generate all missing secrets
./kompose.sh secrets generate

# Generate specific secret
./kompose.sh secrets generate DB_PASSWORD

# Force regenerate (overwrite existing)
./kompose.sh secrets generate --force

# Force regenerate specific secret
./kompose.sh secrets generate DB_PASSWORD --force
```

**Example output:**
```
[INFO] Generating secrets...

[SUCCESS] DB_PASSWORD: Generated successfully
[SUCCESS] REDIS_PASSWORD: Generated successfully  
[SUCCESS] AUTH_KEYCLOAK_ADMIN_PASSWORD: Generated successfully
[SKIP] EMAIL_SMTP_PASSWORD: Manual configuration required
[SKIP] KMPS_CLIENT_SECRET: Manual configuration required

Summary: 33 generated, 2 skipped, 0 errors
[SUCCESS] Secrets generation complete!
```

### Validate Secrets

Check if all required secrets are properly configured:

```bash
# Validate all secrets
./kompose.sh secrets validate
```

**Example output:**
```
[INFO] Validating secrets configuration...

[SUCCESS] DB_PASSWORD: Valid (32 chars)
[SUCCESS] REDIS_PASSWORD: Valid (32 chars)
[ERROR] AUTH_KEYCLOAK_ADMIN_PASSWORD: Missing
[WARNING] KMPS_CLIENT_SECRET: Manual configuration required (empty)
[WARNING] EMAIL_SMTP_PASSWORD: Manual configuration required (empty)

Summary: 25 valid, 1 missing, 0 placeholders, 2 manual
```

### List Secrets

View all secrets grouped by stack:

```bash
# List all secrets
./kompose.sh secrets list

# List for specific stack
./kompose.sh secrets list auth
./kompose.sh secrets list watch
./kompose.sh secrets list shared
```

**Example output:**
```
╔════════════════════════════════════════════════════════════╗
║                    Secrets Overview                        ║
╚════════════════════════════════════════════════════════════╝

━━━ SHARED Secrets ━━━
  DB_PASSWORD                              [OK]  (password:32)
  REDIS_PASSWORD                           [OK]  (password:32)
  EMAIL_SMTP_PASSWORD                      [MANUAL]  (skip)

━━━ AUTH Stack ━━━
  AUTH_KEYCLOAK_ADMIN_PASSWORD             [OK]  (password:24)
  AUTH_OAUTH2_CLIENT_SECRET                [OK]  (password:32)
  AUTH_OAUTH2_COOKIE_SECRET                [OK]  (base64:32)

━━━ CODE Stack ━━━
  CODE_GITEA_SECRET_KEY                    [OK]  (hex:64)
  CODE_GITEA_INTERNAL_TOKEN                [OK]  (hex:105)
  CODE_GITEA_OAUTH2_JWT_SECRET             [OK]  (base64:32)
  CODE_GITEA_METRICS_TOKEN                 [OK]  (uuid)
  CODE_GITEA_RUNNER_TOKEN                  [MANUAL]  (skip)
```

### Rotate Secrets

Generate new values for existing secrets:

```bash
# Rotate a specific secret
./kompose.sh secrets rotate DB_PASSWORD
```

**Interactive process:**
```
[WARNING] Rotating secret: DB_PASSWORD
[WARNING] This will generate a new value and update secrets.env
Continue? (yes/no): yes

[INFO] Backing up old value...
[SUCCESS] Secrets backed up to: ./backups/secrets/secrets.env.before-rotate-DB_PASSWORD
[SUCCESS] DB_PASSWORD: Generated successfully
[SUCCESS] Secret rotated successfully
[WARNING] Remember to restart affected services!

[INFO] This secret is used by:
  - core
  - auth
  - code
  - chain
  - kmps
  - link
  - track
  - watch
```

**After rotation:**
```bash
# Restart affected stacks
./kompose.sh restart core auth code chain kmps link track watch
```

### Set Secret Manually

Set specific secret values:

```bash
# Set a secret
./kompose.sh secrets set EMAIL_SMTP_PASSWORD "your-smtp-password"

# Set Keycloak client secret (from UI)
./kompose.sh secrets set KMPS_CLIENT_SECRET "abc123def456..."

# Set with spaces (use quotes)
./kompose.sh secrets set MY_SECRET "value with spaces"
```

### Backup Secrets

Create timestamped backups:

```bash
# Backup with timestamp
./kompose.sh secrets backup

# Backup with custom suffix
./kompose.sh secrets backup before-upgrade
```

Backups stored in: `./backups/secrets/secrets.env.TIMESTAMP`

### Export Secrets

Export metadata or full secrets:

```bash
# Export structure only (safe)
./kompose.sh secrets export secrets-metadata.json

# Export with values (use with caution!)
./kompose.sh secrets export secrets-full.json --with-values
```

::alert{type="danger"}
**Warning:** Exporting with `--with-values` creates a file containing all your secrets. Protect this file and never commit it to version control!
::

## Secret Types

The system supports multiple generation methods:

### Password (Alphanumeric)

Strong random passwords using letters and numbers:

```bash
# Format: password:LENGTH
# Example: password:32
```

**Used for:**
- Database passwords
- Admin passwords
- API passwords
- General authentication

**Characteristics:**
- Alphanumeric characters (A-Za-z0-9)
- Cryptographically secure (OpenSSL)
- Customizable length
- No special characters (for compatibility)

### Hex String

Hexadecimal strings for tokens:

```bash
# Format: hex:LENGTH
# Example: hex:64
```

**Used for:**
- Gitea secret keys
- Internal tokens
- Signing keys

**Characteristics:**
- Hexadecimal (0-9a-f)
- Suitable for keys and tokens
- URL-safe
- Database-friendly

### Base64 String

Base64-encoded random bytes:

```bash
# Format: base64:BYTES
# Example: base64:32 (generates base64 from 32 bytes)
```

**Used for:**
- OAuth2 cookie secrets
- JWT secrets
- Encryption keys
- NextAuth secrets

**Characteristics:**
- Base64 encoding (A-Za-z0-9+/=)
- High entropy
- Compact representation
- Standard encoding format

### UUID

UUID v4 format:

```bash
# Format: uuid
# Example: 550e8400-e29b-41d4-a716-446655440000
```

**Used for:**
- Runner tokens
- Unique identifiers
- Tracking IDs

**Characteristics:**
- Standard UUID format
- Globally unique
- Sortable
- 128-bit number

### Htpasswd (Basic Auth)

Apache htpasswd format for HTTP basic authentication:

```bash
# Format: htpasswd:USERNAME
# Example: htpasswd:admin
# Output: admin:$apr1$salt$hash
```

**Used for:**
- Traefik dashboard
- Prometheus
- Grafana external auth
- Loki
- Alertmanager

**Characteristics:**
- Industry standard format
- BCrypt or APR1 hashing
- Username:hash format
- Compatible with most web servers

### Manual (Skip)

Some secrets require manual configuration:

```bash
# Format: skip
```

**Used for:**
- `KMPS_CLIENT_SECRET` - From Keycloak UI
- `EMAIL_SMTP_PASSWORD` - From email provider
- `CODE_GITEA_RUNNER_TOKEN` - From Gitea UI

**Why manual:**
- Generated by external systems
- User-specific credentials
- Optional for local development

## Secrets Inventory

### Shared Secrets (Cross-Stack)

#### DB_PASSWORD
- **Type:** password:32
- **Used by:** core, auth, code, chain, kmps, link, track, watch (8 stacks)
- **Purpose:** PostgreSQL database password for all services

#### REDIS_PASSWORD
- **Type:** password:32
- **Used by:** core, auth, code, link, track (5 stacks)
- **Purpose:** Redis cache password

#### EMAIL_SMTP_PASSWORD
- **Type:** skip (manual)
- **Used by:** code, chain, messaging, vault (4 stacks)
- **Purpose:** SMTP server authentication

### By Stack

#### Core Stack (1 secret)
- `CORE_REDIS_API_PASSWORD` - Redis Commander web interface

#### Auth Stack (3 secrets)
- `AUTH_KEYCLOAK_ADMIN_PASSWORD` - Keycloak admin console
- `AUTH_OAUTH2_CLIENT_SECRET` - OAuth2 Proxy client
- `AUTH_OAUTH2_COOKIE_SECRET` - OAuth2 Proxy sessions

#### Code Stack (5 secrets)
- `CODE_GITEA_SECRET_KEY` - Internal encryption (64 hex)
- `CODE_GITEA_INTERNAL_TOKEN` - Internal API (105 hex)
- `CODE_GITEA_OAUTH2_JWT_SECRET` - JWT signing
- `CODE_GITEA_METRICS_TOKEN` - Prometheus metrics
- `CODE_GITEA_RUNNER_TOKEN` - Actions runner (manual)

#### Chain Stack (4 secrets)
- `CHAIN_N8N_ENCRYPTION_KEY` - Workflow credentials
- `CHAIN_N8N_BASIC_AUTH_PASSWORD` - n8n web interface
- `CHAIN_SEMAPHORE_ADMIN_PASSWORD` - Semaphore admin
- `CHAIN_SEMAPHORE_RUNNER_TOKEN` - Runner auth (UUID)

#### KMPS Stack (2 secrets)
- `KMPS_CLIENT_SECRET` - Keycloak client (manual)
- `KMPS_NEXTAUTH_SECRET` - NextAuth sessions

#### Messaging Stack (1 secret)
- `MESSAGING_GOTIFY_DEFAULTUSER_PASS` - Gotify default user

#### Track Stack (1 secret)
- `TRACK_APP_SECRET` - Umami application secret

#### VPN Stack (1 secret)
- `VPN_PASSWORD` - WireGuard web interface

#### Vault Stack (1 secret)
- `VAULT_ADMIN_TOKEN` - Vaultwarden admin panel

#### Link Stack (1 secret)
- `LINK_NEXTAUTH_SECRET` - Linkwarden sessions

#### Proxy Stack (1 secret)
- `PROXY_DASHBOARD_AUTH` - Traefik dashboard (htpasswd)

#### Watch Stack (7 secrets)
- `WATCH_GRAFANA_ADMIN_PASSWORD` - Grafana admin
- `WATCH_GRAFANA_DB_PASSWORD` - Grafana database
- `WATCH_POSTGRES_EXPORTER_PASSWORD` - Postgres exporter
- `WATCH_REDIS_EXPORTER_PASSWORD` - Redis exporter
- `WATCH_PROMETHEUS_AUTH` - Prometheus (htpasswd)
- `WATCH_LOKI_AUTH` - Loki (htpasswd)
- `WATCH_ALERTMANAGER_AUTH` - Alertmanager (htpasswd)

**Total:** 35+ secrets across 14 stacks

## Best Practices

### Security

#### Never Commit Secrets

```bash
# Ensure secrets.env is gitignored
echo "secrets.env" >> .gitignore
echo "secrets.env.*" >> .gitignore

# Verify
git ls-files | grep secrets.env
# Should return nothing
```

#### File Permissions

```bash
# Restrict access to secrets file
chmod 600 secrets.env

# Verify
ls -la secrets.env
# Should show: -rw------- (owner only)
```

#### Regular Rotation

```bash
# Rotate critical secrets quarterly
./kompose.sh secrets backup before-rotation
./kompose.sh secrets rotate DB_PASSWORD
./kompose.sh secrets rotate REDIS_PASSWORD
./kompose.sh restart core auth code chain
```

**Rotation schedule recommendations:**
- **Quarterly:** Database, Redis, admin passwords
- **After personnel changes:** All shared secrets
- **After suspected breach:** All secrets immediately
- **Major upgrades:** All secrets as precaution

#### Backup Before Changes

```bash
# Always backup before major changes
./kompose.sh secrets backup before-upgrade
./kompose.sh secrets backup before-migration
./kompose.sh secrets backup $(date +%Y%m%d)
```

#### Validate After Changes

```bash
# Ensure all secrets are still valid
./kompose.sh secrets validate

# Test services start correctly
./kompose.sh status
```

### Development vs Production

#### Development Setup

**Characteristics:**
- Simple but secure passwords
- Can use generated defaults
- Shared across team (securely)
- Documented in team wiki

**Setup:**
```bash
# Generate once
./kompose.sh secrets generate

# Share securely with team
./kompose.sh secrets export team-secrets.json --with-values
# Encrypt and share via secure channel

# Team members restore
./kompose.sh secrets import team-secrets.json
chmod 600 secrets.env
```

#### Production Setup

**Characteristics:**
- Complex, unique passwords
- Never reuse development secrets
- Stored in enterprise vault
- Access logs maintained

**Setup:**
```bash
# Generate strong secrets
./kompose.sh secrets generate --force

# Backup to secure location
./kompose.sh secrets backup production-initial
# Store backup in enterprise password manager

# Verify
./kompose.sh secrets validate
```

### Team Collaboration

#### Initial Setup (Team Lead)

```bash
# 1. Generate secrets
./kompose.sh secrets generate

# 2. Create backup
./kompose.sh secrets backup team-initial

# 3. Share securely
# - Use encrypted file transfer
# - Enterprise password manager
# - Secure messaging (Signal, Wire)
# - Never via email or Slack
```

#### Each Team Member

```bash
# 1. Receive secrets.env securely
# 2. Place in project root
cp ~/Downloads/secrets.env .

# 3. Set correct permissions
chmod 600 secrets.env

# 4. Validate
./kompose.sh secrets validate

# 5. Test
./kompose.sh up core
```

### Rotation Strategy

#### When to Rotate

**Immediately:**
- After suspected security breach
- After unauthorized access
- When secret is accidentally exposed

**Regularly:**
- Quarterly for high-security environments
- Biannually for standard environments
- Annually minimum

**On Events:**
- Team member departure with access
- Major version upgrades
- Security audit findings
- Compliance requirements

#### Safe Rotation Process

```bash
# 1. Backup current secrets
./kompose.sh secrets backup before-rotation-$(date +%Y%m%d)

# 2. Identify affected stacks
./kompose.sh secrets list | grep SECRET_NAME

# 3. Rotate secret
./kompose.sh secrets rotate SECRET_NAME

# 4. Restart affected services
./kompose.sh restart stack1 stack2 stack3

# 5. Validate all services
./kompose.sh status

# 6. Test functionality
# Check logs, test endpoints

# 7. Document rotation
echo "$(date): Rotated SECRET_NAME" >> rotation-log.txt
```

## Troubleshooting

### Problem: secrets.env not found

**Solution:**
```bash
# Generate from template
./kompose.sh secrets generate

# Verify creation
ls -la secrets.env
```

### Problem: Contains CHANGE_ME placeholders

**Cause:** Secrets were not generated

**Solution:**
```bash
# Generate missing secrets
./kompose.sh secrets generate

# Validate
./kompose.sh secrets validate
```

### Problem: Manual configuration required

Some secrets need manual setup:

#### KMPS_CLIENT_SECRET

```bash
# 1. Access Keycloak admin console
# URL: https://auth.yourdomain.com (or http://localhost:8180)

# 2. Login with admin credentials

# 3. Navigate to:
#    Clients → kmps-admin → Credentials tab

# 4. Copy the client secret

# 5. Set in Kompose
./kompose.sh secrets set KMPS_CLIENT_SECRET "paste-secret-here"
```

#### EMAIL_SMTP_PASSWORD

```bash
# For production (real SMTP)
./kompose.sh secrets set EMAIL_SMTP_PASSWORD "your-smtp-password"

# For local development (Mailhog)
# Leave empty - Mailhog doesn't require authentication
```

#### CODE_GITEA_RUNNER_TOKEN

```bash
# 1. Start Gitea
./kompose.sh up code

# 2. Access Gitea admin
# URL: https://code.yourdomain.com/admin (or http://localhost:3001/admin)

# 3. Navigate to:
#    Site Administration → Actions → Runners

# 4. Click "Create new Runner"

# 5. Copy the registration token

# 6. Set in Kompose
./kompose.sh secrets set CODE_GITEA_RUNNER_TOKEN "paste-token-here"
```

### Problem: Permission denied

**Cause:** Incorrect file permissions

**Solution:**
```bash
# Fix permissions
chmod 600 secrets.env
chown $USER secrets.env

# Verify
ls -la secrets.env
# Should show: -rw------- 1 username group
```

### Problem: Service fails after rotation

**Cause:** Service still using old secret

**Solution:**
```bash
# 1. Check which stacks use the secret
./kompose.sh secrets list | grep SECRET_NAME

# 2. Restart all affected stacks
./kompose.sh restart stack1
./kompose.sh restart stack2

# 3. Check logs for errors
./kompose.sh logs stack1
./kompose.sh logs stack2

# 4. Verify connectivity
./kompose.sh status
```

### Problem: Lost secrets.env file

**Cause:** Accidental deletion, no backup

**Solutions:**

**Option 1: Restore from backup**
```bash
# List backups
ls -la backups/secrets/

# Restore latest
cp backups/secrets/secrets.env.TIMESTAMP secrets.env
chmod 600 secrets.env

# Validate
./kompose.sh secrets validate
```

**Option 2: Regenerate (last resort)**
```bash
# ⚠️ This will break existing services!

# 1. Regenerate all secrets
./kompose.sh secrets generate --force

# 2. Stop all services
./kompose.sh down

# 3. Recreate databases if needed
./kompose.sh db backup    # Backup data first!
./kompose.sh up core
# Restore data

# 4. Reconfigure manual secrets
./kompose.sh secrets set KMPS_CLIENT_SECRET "..."
./kompose.sh secrets set CODE_GITEA_RUNNER_TOKEN "..."

# 5. Restart all services
./kompose.sh up
```

### Problem: Want custom password

**Solution:**
```bash
# Set manually
./kompose.sh secrets set SECRET_NAME "your-custom-password"

# Or edit directly
nano secrets.env
# Find SECRET_NAME and update value

# Validate
./kompose.sh secrets validate

# Restart affected services
./kompose.sh restart stack
```

## Advanced Usage

### Scripted Setup

Automate secret setup for CI/CD:

```bash
#!/bin/bash
# setup-secrets.sh

set -e

# Generate secrets
./kompose.sh secrets generate

# Set manual secrets from environment
./kompose.sh secrets set EMAIL_SMTP_PASSWORD "$SMTP_PASSWORD"
./kompose.sh secrets set KMPS_CLIENT_SECRET "$KEYCLOAK_CLIENT_SECRET"

# Validate
./kompose.sh secrets validate

# Start services
./kompose.sh up

echo "✓ Setup complete"
```

### CI/CD Integration

#### GitHub Actions

```yaml
# .github/workflows/deploy.yml
name: Deploy

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Secrets
        env:
          SECRETS_ARCHIVE: ${{ secrets.KOMPOSE_SECRETS }}
        run: |
          echo "$SECRETS_ARCHIVE" | base64 -d > secrets.env
          chmod 600 secrets.env
          ./kompose.sh secrets validate
      
      - name: Deploy
        run: |
          ./kompose.sh up
```

#### GitLab CI

```yaml
# .gitlab-ci.yml
deploy:
  stage: deploy
  script:
    - echo "$SECRETS_BASE64" | base64 -d > secrets.env
    - chmod 600 secrets.env
    - ./kompose.sh secrets validate
    - ./kompose.sh up
  only:
    - main
```

### Monitoring Secret Age

Track when secrets were last rotated:

```bash
#!/bin/bash
# check-secret-age.sh

SECRET_FILE="secrets.env"
AGE_LIMIT_DAYS=90

if [ -f "$SECRET_FILE" ]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        MODIFIED=$(stat -f %m "$SECRET_FILE")
    else
        # Linux
        MODIFIED=$(stat -c %Y "$SECRET_FILE")
    fi
    
    CURRENT=$(date +%s)
    AGE_DAYS=$(( (CURRENT - MODIFIED) / 86400 ))
    
    echo "Secrets file age: $AGE_DAYS days"
    
    if [ $AGE_DAYS -gt $AGE_LIMIT_DAYS ]; then
        echo "⚠️  WARNING: Secrets are $AGE_DAYS days old (limit: $AGE_LIMIT_DAYS)"
        echo "Consider rotating secrets: ./kompose.sh secrets rotate"
    else
        echo "✓ Secrets are within age limit"
    fi
else
    echo "✗ secrets.env not found"
    exit 1
fi
```

### Custom Secret Generation

Add custom secrets to your stack:

```bash
# 1. Add to secrets.env template
cat >> secrets.env.template << EOF

# My Custom Stack
MYSTACK_API_KEY=CHANGE_ME          # Format: password:32
MYSTACK_WEBHOOK_SECRET=CHANGE_ME   # Format: hex:64
EOF

# 2. Register in secrets system
# Edit kompose-secrets.sh and add to SECRET_DEFINITIONS array

# 3. Generate
./kompose.sh secrets generate MYSTACK_API_KEY
./kompose.sh secrets generate MYSTACK_WEBHOOK_SECRET
```

## Files and Directories

```
kompose/
├── secrets.env                      # Active secrets (NEVER commit!)
├── secrets.env.template             # Template with documentation
├── kompose-secrets.sh               # Secrets management module
├── backups/
│   └── secrets/
│       ├── secrets.env.20251014_120000
│       ├── secrets.env.before-rotate-DB_PASSWORD
│       └── secrets.env.before-upgrade
└── .gitignore                       # Must include secrets.env
```

## Security Checklist

- [ ] secrets.env in .gitignore
- [ ] File permissions set to 600
- [ ] All secrets generated (no CHANGE_ME)
- [ ] Manual secrets configured
- [ ] Backups created and stored securely
- [ ] Different secrets for dev/prod
- [ ] Team members have secure access
- [ ] Rotation schedule defined
- [ ] Password manager configured
- [ ] Access logs enabled (if applicable)

## Next Steps

- [Environment Configuration](./environment-setup.md)
- [Stack Management](./stack-management.md)
- [Database Operations](./database.md)
- [Deployment Guide](./deployment.md)

---

**Version:** 1.1  
**Last Updated:** October 2025  
**Related:** SECRETS_MANAGEMENT.md (archived)
