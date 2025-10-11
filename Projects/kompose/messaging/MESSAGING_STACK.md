# Messaging Stack Documentation

## Overview

The **messaging** stack (formerly "chat") combines two complementary services:

1. **Gotify** - Real-time push notification server
2. **Mailhog** - Email testing tool and SMTP relay

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                   Messaging Stack                        │
├─────────────────────────────────────────────────────────┤
│                                                           │
│  ┌──────────────┐              ┌──────────────┐         │
│  │   Gotify     │──────────────▶│   Mailhog    │         │
│  │              │   SMTP:1025   │              │         │
│  │  Notifications│              │  Email Test  │         │
│  └──────────────┘              └──────────────┘         │
│         │                              │                 │
│         │ chat.pivoine.art             │ mail.pivoine.art│
│         ▼                              ▼                 │
└─────────────────────────────────────────────────────────┘
               │                         │
               ▼                         ▼
        ┌──────────────────────────────────┐
        │         Traefik Proxy             │
        └──────────────────────────────────┘
                      │
                      ▼
              External SMTP (optional)
           smtp.ionos.de:465
```

## Services

### Gotify (Notifications)
- **URL**: https://chat.pivoine.art
- **Purpose**: Push notification server for apps and scripts
- **SMTP**: Connects to Mailhog for sending email notifications
- **Default Credentials**: admin/admin (change after first login!)

### Mailhog (Email Testing)
- **URL**: https://mail.pivoine.art
- **Purpose**: 
  - Catch all emails from kompose services during development
  - Relay emails externally when configured
- **Ports**:
  - `1025`: SMTP server (internal network)
  - `8025`: Web UI
- **SMTP Relay**: Controlled by `MAILHOG_OUTGOING_SMTP_ENABLED`

## Configuration

### Stack Environment Variables (.env)

```bash
# Stack identification
COMPOSE_PROJECT_NAME=messaging

# Gotify
GOTIFY_IMAGE=gotify/server:latest
GOTIFY_PORT=80
GOTIFY_DEFAULTUSER_NAME=admin
GOTIFY_DEFAULTUSER_PASS=admin

# Mailhog
MAILHOG_IMAGE=mailhog/mailhog:latest
MAILHOG_PORT=8025
MAILHOG_OUTGOING_SMTP_ENABLED=false  # Set to 'true' to relay externally
```

### Root Configuration (.env)

```bash
# Traefik hostnames
TRAEFIK_HOST_CHAT=chat.pivoine.art
TRAEFIK_HOST_MAIL=mail.pivoine.art

# Shared SMTP settings (used by Mailhog when relay is enabled)
EMAIL_SMTP_HOST=smtp.ionos.de
EMAIL_SMTP_PORT=465
EMAIL_SMTP_USER=hi@pivoine.art
EMAIL_FROM=hi@pivoine.art
```

### Secrets (secrets.env)

```bash
# Only required when MAILHOG_OUTGOING_SMTP_ENABLED=true
EMAIL_SMTP_PASSWORD=your_smtp_password_here
```

## Connecting Other Services to Mailhog

All kompose services that need to send email should be configured to use Mailhog as their SMTP server:

```yaml
services:
  your_service:
    environment:
      SMTP_HOST: mailhog
      SMTP_PORT: 1025
      SMTP_FROM: ${EMAIL_FROM}
      # No authentication needed for internal Mailhog
```

### Examples for Common Stacks

#### AUTO (n8n)
```yaml
N8N_SMTP_HOST: mailhog
N8N_SMTP_PORT: 1025
N8N_SMTP_SENDER: ${EMAIL_FROM}
```

#### SEXY (Directus)
```yaml
EMAIL_TRANSPORT: smtp
EMAIL_FROM: ${EMAIL_FROM}
EMAIL_SMTP_HOST: mailhog
EMAIL_SMTP_PORT: 1025
```

#### VAULT (Vaultwarden)
```yaml
SMTP_HOST: mailhog
SMTP_PORT: 1025
SMTP_FROM: ${EMAIL_FROM}
SMTP_SSL: false
```

## Usage

### Start the Stack
```bash
cd ~/Projects/kompose/chat
docker compose up -d
```

### View Logs
```bash
docker compose logs -f
docker compose logs -f gotify
docker compose logs -f mailhog
```

### Access Services
- **Gotify UI**: https://chat.pivoine.art
- **Mailhog UI**: https://mail.pivoine.art

### Enable External Email Relay

To make Mailhog relay emails to real recipients:

1. Edit `chat/.env`:
   ```bash
   MAILHOG_OUTGOING_SMTP_ENABLED=true
   ```

2. Ensure SMTP credentials are in `secrets.env`:
   ```bash
   EMAIL_SMTP_PASSWORD=your_password_here
   ```

3. Restart the stack:
   ```bash
   docker compose restart mailhog
   ```

### Disable Relay (Development Mode)

To catch all emails locally without sending:

1. Edit `chat/.env`:
   ```bash
   MAILHOG_OUTGOING_SMTP_ENABLED=false
   ```

2. Restart:
   ```bash
   docker compose restart mailhog
   ```

## Testing Email

### Send Test Email via CLI
```bash
docker exec -it messaging_mailhog sh
# Inside container:
echo "Subject: Test\n\nThis is a test email" | \
  /usr/bin/sendmail test@example.com
```

### Send from Gotify
Configure Gotify to send email notifications:
1. Go to https://chat.pivoine.art
2. Navigate to Settings → SMTP
3. Configure SMTP (uses Mailhog automatically)

### Check Received Emails
Visit https://mail.pivoine.art to see all caught emails in the Mailhog web interface.

## Migration from Chat Stack

The stack has been renamed from "chat" to "messaging" to better reflect its dual purpose:

1. **Old name**: `chat`
2. **New name**: `messaging`
3. **Container names**: Now prefixed with `messaging_`
   - `messaging_gotify` (was `chat_app`)
   - `messaging_mailhog` (new)

### Migration Steps

1. Stop the old stack:
   ```bash
   cd ~/Projects/kompose/chat
   docker compose down
   ```

2. The configuration files have been updated automatically
3. Start the new stack:
   ```bash
   docker compose up -d
   ```

4. Data is preserved in the `gotify_data` volume

## Troubleshooting

### Emails Not Being Sent

1. Check if services are configured to use Mailhog:
   ```bash
   docker compose logs | grep -i smtp
   ```

2. Verify Mailhog is running:
   ```bash
   docker compose ps mailhog
   ```

3. Check Mailhog logs:
   ```bash
   docker compose logs mailhog
   ```

### Gotify Can't Send Emails

1. Ensure `depends_on: mailhog` is in compose.yaml
2. Check Gotify can reach Mailhog:
   ```bash
   docker exec -it messaging_gotify ping mailhog
   ```

### External Relay Not Working

1. Verify SMTP credentials in `secrets.env`
2. Check if `MAILHOG_OUTGOING_SMTP_ENABLED=true`
3. Test SMTP connection:
   ```bash
   docker exec -it messaging_mailhog sh
   # Try manual SMTP test
   ```

## Security Considerations

1. **Mailhog is NOT for production** - It's designed for testing/development
2. **Change default Gotify password** immediately after deployment
3. **Protect Mailhog UI** - Contains all email contents
4. **SMTP Credentials** - Only required when relay is enabled
5. **Network isolation** - Mailhog is only accessible within kompose network

## Best Practices

1. **Development**: Keep `MAILHOG_OUTGOING_SMTP_ENABLED=false`
   - All emails are caught locally
   - No risk of sending test emails to real users

2. **Staging**: Enable relay selectively
   - Test email flows with real SMTP
   - Monitor Mailhog UI for debugging

3. **Production**: Don't use Mailhog
   - Configure services to use production SMTP directly
   - Or deploy a proper mail server

## Related Documentation

- [Gotify Documentation](https://gotify.net/docs/)
- [Mailhog Documentation](https://github.com/mailhog/MailHog)
- [Kompose Email Configuration](../README.md#email-configuration)
