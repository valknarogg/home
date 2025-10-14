# Kompose Secrets Management

## Overview

The Kompose secrets management system provides a secure, automated way to generate, manage, and rotate sensitive credentials across all stacks in your Kompose infrastructure.

## Table of Contents

- [Quick Start](#quick-start)
- [Commands](#commands)
- [Secret Types](#secret-types)
- [Stack-to-Secrets Mapping](#stack-to-secrets-mapping)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

## Quick Start

### Initial Setup

After initializing your Kompose project, generate all secrets:

```bash
# Generate all secrets automatically
./kompose.sh secrets generate

# Validate the configuration
./kompose.sh secrets validate

# List all secrets and their status
./kompose.sh secrets list
```

### Typical Workflow

```bash
# 1. Initialize project
./kompose.sh init

# 2. Generate secrets
./kompose.sh secrets generate

# 3. Validate secrets
./kompose.sh secrets validate

# 4. Start your stacks
./kompose.sh up
```

## Commands

### Generate Secrets

Generate all secrets or a specific secret:

```bash
# Generate all missing secrets
./kompose.sh secrets generate

# Generate specific secret
./kompose.sh secrets generate DB_PASSWORD

# Force regenerate all secrets (overwrite existing)
./kompose.sh secrets generate --force

# Force regenerate specific secret
./kompose.sh secrets generate DB_PASSWORD --force
```

### Validate Secrets

Check if all required secrets are configured:

```bash
# Validate all secrets
./kompose.sh secrets validate
```

Output example:
```
[INFO] Validating secrets configuration...

[SUCCESS] DB_PASSWORD: Valid
[SUCCESS] REDIS_PASSWORD: Valid
[ERROR] AUTH_KEYCLOAK_ADMIN_PASSWORD: Missing
[WARNING] KMPS_CLIENT_SECRET: Manual configuration required (empty)

Summary: 25 valid, 1 missing, 0 with placeholders, 2 manual
```

### List Secrets

View secrets and their configuration status:

```bash
# List all secrets grouped by stack
./kompose.sh secrets list

# List secrets for specific stack
./kompose.sh secrets list auth
./kompose.sh secrets list watch
./kompose.sh secrets list shared
```

Output example:
```
╔════════════════════════════════════════════════════════════════╗
║                       Secrets Overview                         ║
╚════════════════════════════════════════════════════════════════╝

━━━ AUTH Stack ━━━
  DB_PASSWORD                              [OK]       (password:32)
  AUTH_KEYCLOAK_ADMIN_PASSWORD             [OK]       (password:24)
  AUTH_OAUTH2_CLIENT_SECRET                [OK]       (password:32)
  AUTH_OAUTH2_COOKIE_SECRET                [OK]       (base64:32)
  REDIS_PASSWORD                           [OK]       (password:32)
```

### Rotate Secrets

Generate a new value for a specific secret:

```bash
# Rotate a secret
./kompose.sh secrets rotate DB_PASSWORD

# The command will:
# 1. Warn you about the rotation
# 2. Backup the old value
# 3. Generate a new value
# 4. Show which stacks use this secret
# 5. Remind you to restart affected services
```

Example:
```bash
$ ./kompose.sh secrets rotate REDIS_PASSWORD

[WARNING] Rotating secret: REDIS_PASSWORD
[WARNING] This will generate a new value and update secrets.env
Continue? (yes/no): yes

[INFO] Backing up old value...
[SUCCESS] Secrets backed up to: ./backups/secrets/secrets.env.before-rotate-REDIS_PASSWORD
[SUCCESS] REDIS_PASSWORD: Generated successfully
[SUCCESS] Secret rotated successfully
[WARNING] Remember to restart affected services!

[INFO] This secret is used by:
  - core
  - auth
  - code
  - link
  - track
```

After rotating a secret, restart affected stacks:
```bash
./kompose.sh restart core
./kompose.sh restart auth
# ... restart other affected stacks
```

### Set Secret Manually

Set a specific secret value manually:

```bash
# Set a secret value
./kompose.sh secrets set EMAIL_SMTP_PASSWORD "your-smtp-password"

# Set a Keycloak client secret (from UI)
./kompose.sh secrets set KMPS_CLIENT_SECRET "abc123def456..."
```

### Backup Secrets

Create a backup of your secrets.env file:

```bash
# Backup with timestamp
./kompose.sh secrets backup

# Backup with custom suffix
./kompose.sh secrets backup before-upgrade
```

Backups are stored in: `./backups/secrets/`

### Export Secrets

Export secrets metadata to JSON:

```bash
# Export structure only (no values)
./kompose.sh secrets export secrets-metadata.json

# Export with values (use with caution!)
./kompose.sh secrets export secrets-full.json --with-values
```

⚠️ **Warning**: Exporting with values creates a file containing all your secrets. Protect this file!

## Secret Types

The secrets system supports multiple generation methods:

### Password (Alphanumeric)

Strong random passwords using alphanumeric characters:

```bash
# Format: password:LENGTH
# Example: password:32 generates 32-character password
```

Used for:
- Database passwords
- Admin passwords
- API passwords
- General authentication

### Hex String

Hexadecimal strings for tokens and keys:

```bash
# Format: hex:LENGTH
# Example: hex:64 generates 64-character hex string
```

Used for:
- Gitea secret keys
- Gitea internal tokens
- Metrics tokens

### Base64 String

Base64-encoded random bytes:

```bash
# Format: base64:BYTES
# Example: base64:32 generates base64 from 32 bytes
```

Used for:
- OAuth2 cookie secrets
- JWT secrets
- Encryption keys

### UUID

UUID v4 format:

```bash
# Format: uuid
# Example: 550e8400-e29b-41d4-a716-446655440000
```

Used for:
- Runner tokens
- Unique identifiers

### Htpasswd (Basic Auth)

Apache htpasswd format for basic authentication:

```bash
# Format: htpasswd:USERNAME
# Example: htpasswd:admin
# Output: admin:$apr1$salt$hash
```

Used for:
- Traefik dashboard authentication
- Prometheus authentication
- Grafana external authentication
- Loki authentication
- Alertmanager authentication

### Manual (Skip)

Some secrets require manual configuration:

```bash
# Format: skip
```

Used for:
- KMPS_CLIENT_SECRET (generated in Keycloak UI)
- EMAIL_SMTP_PASSWORD (user-provided or empty for local dev)
- CODE_GITEA_RUNNER_TOKEN (generated in Gitea UI)

## Stack-to-Secrets Mapping

### Shared Secrets (Used Across Multiple Stacks)

#### DB_PASSWORD
**Type**: password:32  
**Used by**: core, auth, code, chain, kmps, link, track, watch  
**Purpose**: PostgreSQL database password

#### REDIS_PASSWORD
**Type**: password:32  
**Used by**: core, auth, code, link, track  
**Purpose**: Redis cache password

#### EMAIL_SMTP_PASSWORD
**Type**: skip (manual)  
**Used by**: code, chain, messaging, vault  
**Purpose**: SMTP server password for sending emails

### Stack-Specific Secrets

#### AUTH Stack
- `AUTH_KEYCLOAK_ADMIN_PASSWORD` - Keycloak admin interface password
- `AUTH_OAUTH2_CLIENT_SECRET` - OAuth2 proxy client secret
- `AUTH_OAUTH2_COOKIE_SECRET` - OAuth2 proxy session encryption

#### CODE Stack (Gitea)
- `CODE_GITEA_SECRET_KEY` - Internal encryption key (64 hex)
- `CODE_GITEA_INTERNAL_TOKEN` - Internal API token (105 hex)
- `CODE_GITEA_OAUTH2_JWT_SECRET` - JWT signing key
- `CODE_GITEA_METRICS_TOKEN` - Prometheus metrics auth
- `CODE_GITEA_RUNNER_TOKEN` - Actions runner token (manual)

#### CHAIN Stack (n8n + Semaphore)
- `CHAIN_N8N_ENCRYPTION_KEY` - Workflow credentials encryption
- `CHAIN_N8N_BASIC_AUTH_PASSWORD` - Web interface password
- `CHAIN_SEMAPHORE_ADMIN_PASSWORD` - Semaphore admin password
- `CHAIN_SEMAPHORE_RUNNER_TOKEN` - Runner authentication

#### KMPS Stack (Management Portal)
- `KMPS_CLIENT_SECRET` - Keycloak client secret (manual)
- `KMPS_NEXTAUTH_SECRET` - Session encryption

#### MESSAGING Stack
- `MESSAGING_GOTIFY_DEFAULTUSER_PASS` - Gotify default user

#### TRACK Stack (Umami)
- `TRACK_APP_SECRET` - Application session secret

#### VPN Stack (WireGuard)
- `VPN_PASSWORD` - Web interface password

#### VAULT Stack (Vaultwarden)
- `VAULT_ADMIN_TOKEN` - Admin panel access token

#### LINK Stack (Linkwarden)
- `LINK_NEXTAUTH_SECRET` - Session encryption

#### PROXY Stack (Traefik)
- `PROXY_DASHBOARD_AUTH` - Dashboard basic auth (htpasswd)

#### WATCH Stack (Monitoring)
- `WATCH_GRAFANA_ADMIN_PASSWORD` - Grafana admin password
- `WATCH_GRAFANA_DB_PASSWORD` - Grafana database password
- `WATCH_POSTGRES_EXPORTER_PASSWORD` - Postgres exporter auth
- `WATCH_REDIS_EXPORTER_PASSWORD` - Redis exporter auth
- `WATCH_PROMETHEUS_AUTH` - Prometheus basic auth (htpasswd)
- `WATCH_LOKI_AUTH` - Loki basic auth (htpasswd)
- `WATCH_ALERTMANAGER_AUTH` - Alertmanager basic auth (htpasswd)

#### CORE Stack
- `CORE_REDIS_API_PASSWORD` - Redis Commander web interface

## Best Practices

### Security

1. **Never commit secrets to version control**
   ```bash
   # Ensure secrets.env is in .gitignore
   echo "secrets.env" >> .gitignore
   ```

2. **Use file permissions**
   ```bash
   # Restrict access to secrets file
   chmod 600 secrets.env
   ```

3. **Regular rotation**
   ```bash
   # Rotate secrets periodically (quarterly recommended)
   ./kompose.sh secrets rotate DB_PASSWORD
   ```

4. **Backup before changes**
   ```bash
   # Always backup before major changes
   ./kompose.sh secrets backup before-upgrade
   ```

5. **Validate after changes**
   ```bash
   # Ensure all secrets are valid
   ./kompose.sh secrets validate
   ```

### Development vs Production

**Development**:
- Generate once and commit to documentation (not version control)
- Share through secure channels with team
- Can use simpler passwords for convenience

**Production**:
- Always use generated secrets
- Never reuse development secrets
- Store backups in enterprise password manager
- Rotate after any personnel changes

### Team Collaboration

1. **Initial setup** (one team member):
   ```bash
   ./kompose.sh secrets generate
   ./kompose.sh secrets backup team-initial
   ```

2. **Share with team**:
   - Use secure channel (encrypted file transfer, password manager)
   - Don't send via email or chat
   - Consider using `secrets export` for structured sharing

3. **Each team member**:
   ```bash
   # Place received secrets.env in project root
   chmod 600 secrets.env
   ./kompose.sh secrets validate
   ```

### Rotation Strategy

**When to rotate**:
- Quarterly for high-security environments
- After team member departure
- After suspected compromise
- During major version upgrades
- As part of security audits

**How to rotate safely**:
```bash
# 1. Backup current secrets
./kompose.sh secrets backup before-rotation-$(date +%Y%m%d)

# 2. Rotate specific secret
./kompose.sh secrets rotate SECRET_NAME

# 3. Restart affected services (listed by rotate command)
./kompose.sh restart stack1 stack2

# 4. Validate
./kompose.sh secrets validate

# 5. Test services
./kompose.sh status
```

## Troubleshooting

### Problem: "secrets.env not found"

**Solution**:
```bash
# Generate from template
./kompose.sh secrets generate
```

### Problem: "Contains CHANGE_ME placeholders"

**Solution**:
```bash
# Generate missing secrets
./kompose.sh secrets generate
```

### Problem: "Manual configuration required"

Some secrets need manual setup:

1. **KMPS_CLIENT_SECRET**:
   - Log into Keycloak admin console
   - Go to Clients > kmps-admin
   - Copy client secret from Credentials tab
   - Set: `./kompose.sh secrets set KMPS_CLIENT_SECRET "value"`

2. **EMAIL_SMTP_PASSWORD**:
   - Obtain from your email provider
   - Set: `./kompose.sh secrets set EMAIL_SMTP_PASSWORD "value"`
   - Or leave empty for local development with Mailhog

3. **CODE_GITEA_RUNNER_TOKEN**:
   - Start Gitea first
   - Go to Settings > Actions > Runners
   - Create new runner and copy token
   - Set: `./kompose.sh secrets set CODE_GITEA_RUNNER_TOKEN "value"`

### Problem: "Permission denied accessing secrets.env"

**Solution**:
```bash
# Fix permissions
chmod 600 secrets.env
chown $USER secrets.env
```

### Problem: Service fails after secret rotation

**Solution**:
```bash
# Check which stacks use the secret
./kompose.sh secrets list

# Restart all affected stacks
./kompose.sh restart stack1
./kompose.sh restart stack2

# Check logs
./kompose.sh logs stack1
```

### Problem: Lost secrets.env file

**Solution**:
```bash
# Check for backups
ls -la backups/secrets/

# Restore from backup
cp backups/secrets/secrets.env.TIMESTAMP secrets.env
chmod 600 secrets.env

# Validate
./kompose.sh secrets validate
```

If no backup exists, you'll need to:
1. Regenerate all secrets: `./kompose.sh secrets generate --force`
2. Restart all stacks
3. Reconfigure manual secrets (Keycloak clients, etc.)

### Problem: Want to use custom password for specific secret

**Solution**:
```bash
# Set manually
./kompose.sh secrets set SECRET_NAME "your-custom-password"

# Or edit secrets.env directly
nano secrets.env
# Find SECRET_NAME and update value

# Validate
./kompose.sh secrets validate
```

## Advanced Usage

### Scripted Setup

```bash
#!/bin/bash
# setup-kompose-secrets.sh

# Generate secrets
./kompose.sh secrets generate

# Set manual secrets from environment
./kompose.sh secrets set EMAIL_SMTP_PASSWORD "$SMTP_PASSWORD"
./kompose.sh secrets set KMPS_CLIENT_SECRET "$KEYCLOAK_CLIENT_SECRET"

# Validate
./kompose.sh secrets validate

# Start services
./kompose.sh up
```

### CI/CD Integration

```yaml
# .github/workflows/deploy.yml
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

### Monitoring Secret Age

```bash
#!/bin/bash
# check-secret-age.sh

SECRET_FILE="secrets.env"
AGE_LIMIT_DAYS=90

if [ -f "$SECRET_FILE" ]; then
    AGE=$(( ($(date +%s) - $(stat -f %m "$SECRET_FILE")) / 86400 ))
    
    if [ $AGE -gt $AGE_LIMIT_DAYS ]; then
        echo "WARNING: Secrets are $AGE days old (limit: $AGE_LIMIT_DAYS)"
        echo "Consider rotating secrets: ./kompose.sh secrets rotate"
    fi
fi
```

## Files and Directories

```
kompose/
├── secrets.env                      # Active secrets (NEVER commit!)
├── secrets.env.template             # Template with documentation
├── kompose-secrets.sh               # Secrets management module
├── backups/
│   └── secrets/
│       ├── secrets.env.20241014_120000
│       ├── secrets.env.before-rotate-DB_PASSWORD
│       └── secrets.env.before-upgrade
└── .gitignore                       # Must include secrets.env
```

## See Also

- [Kompose Main Documentation](README.md)
- [Environment Configuration](ENV_REFERENCE.md)
- [Stack Management](STACK_MANAGEMENT.md)
- [Security Best Practices](SECURITY.md)
