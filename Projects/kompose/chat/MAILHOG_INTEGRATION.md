# Connecting Kompose Services to Mailhog

## Quick Reference

All kompose services should use **Mailhog** as their SMTP server for email functionality during development and testing.

## Standard Configuration

```yaml
services:
  your_service:
    environment:
      SMTP_HOST: mailhog
      SMTP_PORT: 1025
      SMTP_FROM: ${EMAIL_FROM}
    depends_on:
      - mailhog  # If in same compose file
    networks:
      - kompose_network
```

## Stack-Specific Examples

### AUTH Stack (Keycloak)

**File**: `auth/compose.yaml`

```yaml
services:
  keycloak:
    environment:
      KC_SMTP_HOST: mailhog
      KC_SMTP_PORT: 1025
      KC_SMTP_FROM: ${EMAIL_FROM}
      KC_SMTP_FROM_DISPLAY_NAME: "Kompose Auth"
      KC_SMTP_SSL: false
      KC_SMTP_STARTTLS: false
      KC_SMTP_AUTH: false
```

### AUTO Stack (n8n)

**File**: `auto/compose.yaml` or `chain/compose.yaml`

```yaml
services:
  n8n:
    environment:
      N8N_SMTP_HOST: mailhog
      N8N_SMTP_PORT: 1025
      N8N_SMTP_SENDER: ${EMAIL_FROM}
      N8N_SMTP_SSL: false
      N8N_SMTP_USER: ""
      N8N_SMTP_PASSWORD: ""
```

### BLOG Stack (Ghost)

**File**: `blog/compose.yaml`

```yaml
services:
  ghost:
    environment:
      mail__transport: SMTP
      mail__from: ${EMAIL_FROM}
      mail__options__host: mailhog
      mail__options__port: 1025
      mail__options__secure: false
      mail__options__requireTLS: false
```

### DASH Stack (NextJS/NextAuth)

**File**: `dash/.env`

```bash
EMAIL_SERVER_HOST=mailhog
EMAIL_SERVER_PORT=1025
EMAIL_FROM=${EMAIL_FROM}
```

### NEWS Stack (Letterspace)

**File**: `news/compose.yaml`

```yaml
services:
  letterspace:
    environment:
      SMTP_HOST: mailhog
      SMTP_PORT: 1025
      SMTP_FROM: ${EMAIL_FROM}
      SMTP_SECURE: false
```

### SEXY Stack (Directus)

**File**: `sexy/compose.yaml`

```yaml
services:
  directus:
    environment:
      EMAIL_TRANSPORT: smtp
      EMAIL_FROM: ${EMAIL_FROM}
      EMAIL_SMTP_HOST: mailhog
      EMAIL_SMTP_PORT: 1025
      EMAIL_SMTP_SECURE: false
      EMAIL_SMTP_IGNORE_TLS: true
```

### VAULT Stack (Vaultwarden)

**File**: `vault/compose.yaml`

```yaml
services:
  vaultwarden:
    environment:
      SMTP_HOST: mailhog
      SMTP_FROM: ${EMAIL_FROM}
      SMTP_PORT: 1025
      SMTP_SECURITY: "off"
      SMTP_SSL: false
      SMTP_EXPLICIT_TLS: false
```

### CODE Stack (Gitea)

**File**: `code/compose.yaml`

Gitea uses app.ini configuration:

```ini
[mailer]
ENABLED = true
PROTOCOL = smtp
SMTP_ADDR = mailhog
SMTP_PORT = 1025
FROM = ${EMAIL_FROM}
IS_TLS_ENABLED = false
```

### TRACE Stack (Signoz/Uptrace)

**File**: `trace/compose.yaml`

```yaml
services:
  uptrace:
    environment:
      UPTRACE_SMTP_HOST: mailhog
      UPTRACE_SMTP_PORT: 1025
      UPTRACE_SMTP_FROM: ${EMAIL_FROM}
      UPTRACE_SMTP_SECURE: false
```

## External Services (Cross-Stack)

If a service in one stack needs to send email but Mailhog is in the messaging stack:

```yaml
# Example: A service in 'blog' stack
services:
  my_service:
    environment:
      SMTP_HOST: mailhog  # DNS name works across kompose network
      SMTP_PORT: 1025
    networks:
      - kompose_network  # Must be on same network
```

The `mailhog` hostname is resolvable across all services on the `kompose_network`.

## Testing Email Configuration

### 1. Send Test Email

```bash
# From within any container on kompose network
apk add --no-cache mailx  # or apt-get install mailutils
echo "Test email body" | mail -s "Test Subject" test@example.com
```

### 2. Verify in Mailhog UI

Visit https://mail.pivoine.art to see all caught emails.

### 3. Check Service Logs

```bash
# Check if service is attempting to send email
docker compose logs [service_name] | grep -i mail
```

## Common Environment Variables

Different applications use different variable names for SMTP configuration. Here's a mapping:

| Purpose | Common Names |
|---------|-------------|
| **Host** | `SMTP_HOST`, `MAIL_HOST`, `EMAIL_SMTP_HOST`, `mail__options__host` |
| **Port** | `SMTP_PORT`, `MAIL_PORT`, `EMAIL_SMTP_PORT`, `mail__options__port` |
| **From** | `SMTP_FROM`, `EMAIL_FROM`, `MAIL_FROM`, `mail__from` |
| **SSL/TLS** | `SMTP_SSL`, `SMTP_SECURE`, `SMTP_TLS`, `EMAIL_SMTP_SECURE` |
| **Auth** | `SMTP_AUTH`, `SMTP_USER`, `SMTP_PASSWORD` (leave empty for Mailhog) |

## Mailhog Connection Pattern

For **all** services connecting to Mailhog:

✅ **Always use**:
- Host: `mailhog`
- Port: `1025`
- SSL/TLS: `false` or `off`
- Authentication: disabled/empty

❌ **Never use**:
- External SMTP servers directly (use Mailhog as relay)
- Port 25, 465, or 587 (internal Mailhog uses 1025)
- SSL/TLS encryption (not needed for internal network)
- SMTP authentication (Mailhog doesn't require it internally)

## Migration Checklist

When adding Mailhog to an existing stack:

- [ ] Add Mailhog service to `compose.yaml`
- [ ] Update service environment variables to use Mailhog
- [ ] Add `depends_on: mailhog` if in same file
- [ ] Ensure service is on `kompose_network`
- [ ] Remove external SMTP credentials from service config
- [ ] Test email sending
- [ ] Verify emails appear in Mailhog UI

## Switching Between Dev and Production

### Development (Local Email Catching)
```bash
# messaging/.env
MAILHOG_OUTGOING_SMTP_ENABLED=false
```

All emails are caught in Mailhog UI. Perfect for testing without sending real emails.

### Production-like Testing (External Relay)
```bash
# messaging/.env
MAILHOG_OUTGOING_SMTP_ENABLED=true
```

Mailhog relays emails to actual recipients via configured SMTP. Requires `EMAIL_SMTP_PASSWORD` in `secrets.env`.

### True Production
Configure services to use production SMTP directly:

```yaml
environment:
  SMTP_HOST: ${EMAIL_SMTP_HOST}  # smtp.ionos.de
  SMTP_PORT: ${EMAIL_SMTP_PORT}  # 465
  SMTP_USER: ${EMAIL_SMTP_USER}
  SMTP_PASSWORD: ${EMAIL_SMTP_PASSWORD}
```

## Troubleshooting

### Service can't resolve "mailhog" hostname

**Cause**: Service not on kompose network

**Fix**:
```yaml
networks:
  - kompose_network

networks:
  kompose_network:
    external: true
    name: kompose
```

### Emails not appearing in Mailhog UI

**Cause**: Service configured incorrectly or using wrong port

**Fix**: Double-check:
1. `SMTP_HOST: mailhog` (not localhost, not 127.0.0.1)
2. `SMTP_PORT: 1025` (not 25, 465, or 587)
3. Service is running: `docker compose ps`

### Mailhog relay not working

**Cause**: Missing SMTP credentials or wrong configuration

**Fix**:
1. Set `MAILHOG_OUTGOING_SMTP_ENABLED=true`
2. Ensure `EMAIL_SMTP_PASSWORD` exists in `secrets.env`
3. Restart Mailhog: `docker compose restart mailhog`

## Additional Resources

- [Mailhog Documentation](https://github.com/mailhog/MailHog)
- [SMTP Testing Best Practices](https://mailtrap.io/blog/smtp-test/)
- [Kompose Messaging Stack](./MESSAGING_STACK.md)
