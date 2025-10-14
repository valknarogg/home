# Kompose Secrets - Quick Reference

## Essential Commands

```bash
# Generate all secrets
./kompose.sh secrets generate

# Validate secrets
./kompose.sh secrets validate

# List all secrets
./kompose.sh secrets list

# List secrets for a stack
./kompose.sh secrets list auth

# Rotate a secret
./kompose.sh secrets rotate DB_PASSWORD

# Set a secret manually
./kompose.sh secrets set SECRET_NAME "value"

# Backup secrets
./kompose.sh secrets backup

# Force regenerate all
./kompose.sh secrets generate --force
```

## Secret Types Reference

| Type | Format | Example Use |
|------|--------|-------------|
| `password:N` | Random alphanumeric | DB_PASSWORD, Admin passwords |
| `hex:N` | Hexadecimal string | Gitea tokens, API keys |
| `base64:N` | Base64 encoded | OAuth2 secrets, JWT keys |
| `uuid` | UUID v4 | Runner tokens, IDs |
| `htpasswd:user` | Apache htpasswd | Basic auth (Traefik, Prometheus) |
| `skip` | Manual entry | Keycloak client secrets |

## Common Workflows

### Initial Setup
```bash
./kompose.sh init
./kompose.sh secrets generate
./kompose.sh secrets validate
./kompose.sh up
```

### After Adding New Service
```bash
# Edit secrets.env.template with new secrets
./kompose.sh secrets generate
./kompose.sh secrets validate
```

### Rotating Secrets
```bash
./kompose.sh secrets backup
./kompose.sh secrets rotate DB_PASSWORD
./kompose.sh restart core auth code  # Affected stacks
```

### Team Onboarding
```bash
# Team lead generates
./kompose.sh secrets generate
./kompose.sh secrets backup team-$(date +%Y%m%d)

# New team member receives file
chmod 600 secrets.env
./kompose.sh secrets validate
```

## All Secrets by Stack

### Shared (Multiple Stacks)
- `DB_PASSWORD` - PostgreSQL (core, auth, code, chain, kmps, link, track, watch)
- `REDIS_PASSWORD` - Redis cache (core, auth, code, link, track)
- `EMAIL_SMTP_PASSWORD` - Email sending (code, chain, messaging, vault)

### Core Stack
- `CORE_REDIS_API_PASSWORD` - Redis Commander web UI

### Auth Stack (Keycloak + OAuth2)
- `AUTH_KEYCLOAK_ADMIN_PASSWORD` - Keycloak admin console
- `AUTH_OAUTH2_CLIENT_SECRET` - OAuth2 proxy client
- `AUTH_OAUTH2_COOKIE_SECRET` - Session cookies (base64:32)

### Code Stack (Gitea)
- `CODE_GITEA_SECRET_KEY` - Encryption (hex:64)
- `CODE_GITEA_INTERNAL_TOKEN` - Internal API (hex:105)
- `CODE_GITEA_OAUTH2_JWT_SECRET` - JWT signing (base64:32)
- `CODE_GITEA_METRICS_TOKEN` - Prometheus (hex:32)
- `CODE_GITEA_RUNNER_TOKEN` - Actions runner (uuid)

### Chain Stack (n8n + Semaphore)
- `CHAIN_N8N_ENCRYPTION_KEY` - Workflow credentials
- `CHAIN_N8N_BASIC_AUTH_PASSWORD` - n8n web UI
- `CHAIN_SEMAPHORE_ADMIN_PASSWORD` - Semaphore admin
- `CHAIN_SEMAPHORE_RUNNER_TOKEN` - Runner auth (uuid)

### KMPS Stack (Management Portal)
- `KMPS_CLIENT_SECRET` - Keycloak client (manual)
- `KMPS_NEXTAUTH_SECRET` - NextAuth sessions

### Messaging Stack
- `MESSAGING_GOTIFY_DEFAULTUSER_PASS` - Gotify default user

### Track Stack (Umami)
- `TRACK_APP_SECRET` - Session management

### VPN Stack (WireGuard)
- `VPN_PASSWORD` - wg-easy web UI

### Vault Stack (Vaultwarden)
- `VAULT_ADMIN_TOKEN` - Admin panel

### Link Stack (Linkwarden)
- `LINK_NEXTAUTH_SECRET` - NextAuth sessions

### Proxy Stack (Traefik)
- `PROXY_DASHBOARD_AUTH` - Dashboard (htpasswd:admin)

### Watch Stack (Monitoring)
- `WATCH_GRAFANA_ADMIN_PASSWORD` - Grafana admin
- `WATCH_GRAFANA_DB_PASSWORD` - Grafana database
- `WATCH_POSTGRES_EXPORTER_PASSWORD` - PostgreSQL metrics
- `WATCH_REDIS_EXPORTER_PASSWORD` - Redis metrics
- `WATCH_PROMETHEUS_AUTH` - Prometheus UI (htpasswd:admin)
- `WATCH_LOKI_AUTH` - Loki UI (htpasswd:admin)
- `WATCH_ALERTMANAGER_AUTH` - Alertmanager UI (htpasswd:admin)

## Manual Generation Reference

```bash
# Password (32 chars)
openssl rand -base64 48 | tr -d "=+/" | cut -c1-32

# Hex (64 chars)
openssl rand -hex 32

# Hex (105 chars)
openssl rand -hex 52 | cut -c1-105

# Base64 (32 bytes)
openssl rand -base64 32

# UUID
uuidgen | tr '[:upper:]' '[:lower:]'

# Htpasswd
htpasswd -nb admin yourpassword
```

## Status Indicators

When running `./kompose.sh secrets list`:

- `[OK]` - Secret is properly configured
- `[MISSING]` - Secret needs to be generated
- `[PLACEHOLDER]` - Contains CHANGE_ME text
- `[MANUAL]` - Requires manual configuration (empty)
- `[SET]` - Manual secret has been configured

## Troubleshooting Quick Fixes

| Problem | Solution |
|---------|----------|
| Missing secrets.env | `./kompose.sh secrets generate` |
| Placeholders remain | `./kompose.sh secrets generate` |
| Permission denied | `chmod 600 secrets.env` |
| After rotation | `./kompose.sh restart <affected-stacks>` |
| Manual secrets needed | Check Keycloak UI or use `secrets set` |
| Lost file | Restore from `backups/secrets/` |

## Security Checklist

- [ ] secrets.env is in .gitignore
- [ ] File permissions are 600
- [ ] All placeholders replaced
- [ ] Backups stored securely
- [ ] Different secrets for dev/prod
- [ ] Rotation schedule established
- [ ] Team has secure access method

## Important Files

```
secrets.env              # Active secrets (NEVER COMMIT)
secrets.env.template     # Template with docs
kompose-secrets.sh       # Management module
backups/secrets/         # Backup directory
.gitignore               # Must include secrets.env
```

## Common Errors

### "Unknown secret: SECRET_NAME"
The secret is not defined in the system. Check available secrets:
```bash
./kompose.sh secrets list
```

### "Manual configuration required"
Some secrets need manual setup from external systems:
- KMPS_CLIENT_SECRET (from Keycloak UI)
- EMAIL_SMTP_PASSWORD (from email provider)
- CODE_GITEA_RUNNER_TOKEN (from Gitea UI after first start)

### "Secret already has value"
Use `--force` to overwrite:
```bash
./kompose.sh secrets generate SECRET_NAME --force
```

## Quick Start for New Developers

1. Clone repository
2. Get secrets.env from team lead (secure channel)
3. Place in project root
4. Run:
   ```bash
   chmod 600 secrets.env
   ./kompose.sh secrets validate
   ./kompose.sh up
   ```

## Rotation Best Practices

**Rotate immediately if**:
- Team member leaves
- Suspected compromise
- Required by security policy

**Rotate periodically**:
- Quarterly for high-security
- After major upgrades
- During security audits

**Rotation procedure**:
1. Backup: `./kompose.sh secrets backup`
2. Rotate: `./kompose.sh secrets rotate SECRET_NAME`
3. Restart affected services
4. Validate: `./kompose.sh secrets validate`
5. Test services

## Help & Documentation

Full documentation: `SECRETS_MANAGEMENT.md`

Command help: `./kompose.sh secrets --help`

Stack help: `./kompose.sh secrets list <stack>`
