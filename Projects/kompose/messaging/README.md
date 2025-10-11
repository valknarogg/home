# Messaging Stack

> **Formerly known as**: Chat Stack

The messaging stack provides essential communication infrastructure for the Kompose platform:

- **Gotify**: Push notification server (https://chat.pivoine.art)
- **Mailhog**: Email testing and SMTP relay (https://mail.pivoine.art)

## Quick Start

```bash
# Start the stack
docker compose up -d

# View logs
docker compose logs -f

# Stop the stack
docker compose down
```

## Key Features

### Gotify
- 📱 Real-time push notifications
- 🔔 WebSocket connections for instant delivery
- 📊 Message history and priorities
- 🔌 REST API for automation
- 📧 Email notifications via Mailhog

### Mailhog
- 📨 Catches all outgoing emails from kompose services
- 🌐 Web UI for viewing emails (https://mail.pivoine.art)
- 🔄 Optional SMTP relay to external mail servers
- 🧪 Perfect for development and testing
- 🔒 No risk of sending test emails to real users

## Configuration

### Development Mode (Default)
All emails are caught locally in Mailhog. No external emails are sent.

```bash
# messaging/.env
MAILHOG_OUTGOING_SMTP_ENABLED=false
```

### Production-like Testing
Mailhog relays emails to real recipients via configured SMTP server.

```bash
# messaging/.env
MAILHOG_OUTGOING_SMTP_ENABLED=true
```

## Service URLs

| Service | URL | Purpose |
|---------|-----|---------|
| Gotify | https://chat.pivoine.art | Push notifications |
| Mailhog | https://mail.pivoine.art | Email testing |

## Default Credentials

**Gotify**: 
- Username: `admin`
- Password: `admin`
- ⚠️ **Change immediately after first login!**

**Mailhog**: No authentication required

## Connecting Other Services

All kompose services should use Mailhog as their SMTP server:

```yaml
environment:
  SMTP_HOST: mailhog
  SMTP_PORT: 1025
  SMTP_FROM: ${EMAIL_FROM}
```

See [MAILHOG_INTEGRATION.md](./MAILHOG_INTEGRATION.md) for detailed examples for each stack.

## Architecture

```
┌─────────────┐         ┌─────────────┐
│   Gotify    │────────▶│  Mailhog    │
│  (Notify)   │ SMTP    │  (Email)    │
└─────────────┘         └─────────────┘
      │                       │
      │                       │
      ▼                       ▼
  chat.pivoine.art    mail.pivoine.art
```

All kompose services → Mailhog → (optional) External SMTP

## Documentation

- **[MESSAGING_STACK.md](./MESSAGING_STACK.md)** - Complete documentation, architecture, and troubleshooting
- **[MAILHOG_INTEGRATION.md](./MAILHOG_INTEGRATION.md)** - How to connect services to Mailhog

## Common Tasks

### View All Caught Emails
Visit https://mail.pivoine.art

### Send Test Email
```bash
docker exec -it messaging_mailhog sh
echo "Subject: Test\n\nTest email" | /usr/bin/sendmail test@example.com
```

### Enable External Email Relay
```bash
# 1. Edit messaging/.env
MAILHOG_OUTGOING_SMTP_ENABLED=true

# 2. Ensure secrets.env has EMAIL_SMTP_PASSWORD

# 3. Restart
docker compose restart mailhog
```

### Check Service Logs
```bash
docker compose logs -f gotify
docker compose logs -f mailhog
```

## Migration Notes

This stack was renamed from "chat" to "messaging" to better reflect its dual purpose:
- Previous: Single Gotify service for chat/notifications
- Current: Gotify + Mailhog for complete messaging infrastructure

All data has been preserved. Container names have changed:
- `chat_app` → `messaging_gotify`
- (new) → `messaging_mailhog`

## Troubleshooting

### Emails not appearing in Mailhog?

1. Check service is using correct SMTP config:
   ```yaml
   SMTP_HOST: mailhog
   SMTP_PORT: 1025
   ```

2. Verify service is on kompose network:
   ```yaml
   networks:
     - kompose_network
   ```

3. Check Mailhog logs:
   ```bash
   docker compose logs mailhog
   ```

### Can't access Gotify or Mailhog web UI?

1. Ensure Traefik proxy is running:
   ```bash
   cd ../proxy && docker compose ps
   ```

2. Check DNS configuration for:
   - chat.pivoine.art → your server IP
   - mail.pivoine.art → your server IP

3. Verify SSL certificates:
   ```bash
   docker compose logs | grep -i cert
   ```

## Security

- 🔒 Change default Gotify password
- 🔒 Mailhog UI contains all email contents - restrict access
- 🔒 SMTP credentials only needed when relay is enabled
- 🔒 Services communicate on internal network only

## Next Steps

1. Change Gotify admin password
2. Connect your first service to Mailhog (see [MAILHOG_INTEGRATION.md](./MAILHOG_INTEGRATION.md))
3. Test email flow by sending a test email
4. Configure Gotify to send notifications to your devices

## Support

- [Gotify Documentation](https://gotify.net/docs/)
- [Mailhog GitHub](https://github.com/mailhog/MailHog)
- [Kompose Main README](../README.md)
