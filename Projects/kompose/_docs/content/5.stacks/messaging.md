---
title: Messaging - Notifications & Email Testing
description: "Gotify + Mailhog: Complete messaging infrastructure"
navigation:
  icon: i-lucide-mail
---

> *"Stay connected, stay informed, stay in control"* - Messaging stack

## What's This All About?

The **messaging** stack provides essential communication infrastructure for the entire Kompose platform, combining **Gotify** for real-time push notifications and **Mailhog** for email testing and SMTP relay. This dual-purpose stack ensures you never miss important alerts while providing a safe environment for testing email functionality.

## The Stack

### :icon{name="lucide:bell"} Gotify

**Container**: `messaging_gotify`  
**Image**: `gotify/server:latest`  
**URL**: https://chat.pivoine.art  
**Port**: 80 (internal)

Self-hosted push notification server:
- :icon{name="lucide:phone"} **Mobile Apps**: iOS and Android clients
- :icon{name="lucide:globe"} **Web Interface**: Browser notifications
- :icon{name="lucide:plug"} **REST API**: Send from anywhere
- :icon{name="lucide:key"} **App Tokens**: Separate tokens per app
- :icon{name="lucide:target"} **Priority Levels**: 0-10 urgency scale
- :icon{name="lucide:palette"} **Markdown**: Rich formatted messages
- :icon{name="lucide:mail"} **Email**: Via Mailhog integration

### :icon{name="lucide:mail"} Mailhog

**Container**: `messaging_mailhog`  
**Image**: `mailhog/mailhog:latest`  
**URL**: https://mail.pivoine.art  
**Ports**: 
  - **1025** - SMTP (internal)
  - **8025** - Web UI

Email testing and SMTP relay:
- :icon{name="lucide:inbox"} **Catch All Emails**: Test without sending
- :icon{name="lucide:globe"} **Web Interface**: View all emails
- :icon{name="lucide:send"} **SMTP Relay**: Optional external delivery
- :icon{name="lucide:shield"} **Safe Testing**: No risk of spam
- :icon{name="lucide:bug"} **Debugging**: See exactly what's sent

## Architecture

```
┌─────────────────────────────────────────────────────┐
│                Messaging Stack                       │
│                                                       │
│  ┌──────────────┐         ┌──────────────┐          │
│  │   Gotify     │────────▶│   Mailhog    │          │
│  │(Notifications)│ SMTP    │(Email Test)  │          │
│  └──────────────┘ 1025    └──────┬───────┘          │
│                                   │                  │
│                         Optional  │                  │
│                         Relay     ▼                  │
│                            ┌──────────────┐         │
│                            │ External     │         │
│                            │ SMTP Server  │         │
│                            │ (smtp.ionos) │         │
│                            └──────────────┘         │
└─────────────────────────────────────────────────────┘
              ▲
              │ SMTP: 1025
              │
    All Kompose Services
    (auth, chain, home, vault, etc.)
```

## Configuration

### Gotify Setup

**Default Credentials**:
- Username: `admin`
- Password: `admin` (set in `.env`)

**:icon{name="lucide:alert-triangle"} CRITICAL**: Change password on first login!

**Email Integration**:
Gotify automatically uses Mailhog for sending email notifications:
```yaml
GOTIFY_SERVER_SMTP_HOST: mailhog
GOTIFY_SERVER_SMTP_PORT: 1025
```

### Mailhog Modes

**Development Mode** (Default):
```bash
# messaging/.env
MAILHOG_OUTGOING_SMTP_ENABLED=false
```
- All emails caught locally
- No external delivery
- Perfect for testing

**Relay Mode** (Production-like):
```bash
# messaging/.env
MAILHOG_OUTGOING_SMTP_ENABLED=true
```
- Emails relayed to real recipients
- Requires SMTP credentials in `secrets.env`
- Still visible in Mailhog UI for debugging

## Getting Started

### First Time - Gotify

1. **Access**: https://chat.pivoine.art
2. **Login**: admin/admin
3. **Change Password**: Click user icon → Settings
4. **Create App**: Apps → New Application
5. **Copy Token**: Use for sending notifications

### Sending Notifications

**Using curl**:
```bash
curl -X POST "https://chat.pivoine.art/message" \
  -H "X-Gotify-Key: YOUR_APP_TOKEN" \
  -F "title=Hello World" \
  -F "message=Your first notification!" \
  -F "priority=5"
```

**From Python**:
```python
import requests

url = "https://chat.pivoine.art/message"
headers = {"X-Gotify-Key": "YOUR_APP_TOKEN"}
data = {
    "title": "Deploy Complete",
    "message": "Your app is live!",
    "priority": 8
}
requests.post(url, headers=headers, data=data)
```

### Mobile Apps

**Download**:
- **Android**: F-Droid or Google Play
- **iOS**: App Store

**Setup**:
1. Install app
2. Server: `https://chat.pivoine.art`
3. Enter client token (create in web UI)
4. Enable notifications

## Mailhog Integration

### For Other Kompose Services

**All services should use Mailhog as SMTP**:

```yaml
environment:
  SMTP_HOST: mailhog
  SMTP_PORT: 1025
  SMTP_FROM: ${EMAIL_FROM}
  SMTP_SSL: false
```

**Service-Specific Examples**:

**n8n** (Chain Stack):
```yaml
N8N_SMTP_HOST: mailhog
N8N_SMTP_PORT: 1025
N8N_SMTP_SENDER: ${EMAIL_FROM}
```

**Keycloak** (Auth Stack):
```yaml
KC_SMTP_HOST: mailhog
KC_SMTP_PORT: 1025
KC_SMTP_FROM: ${EMAIL_FROM}
```

**Vaultwarden** (Vault Stack):
```yaml
SMTP_HOST: mailhog
SMTP_PORT: 1025
SMTP_FROM: ${EMAIL_FROM}
SMTP_SECURITY: "off"
```

### Testing Email Flow

1. **Configure service** to use Mailhog
2. **Trigger email** (user signup, password reset, etc.)
3. **View in Mailhog**: https://mail.pivoine.art
4. **Check content**: Verify formatting, links, etc.

### Enable External Relay

**When you're ready to send real emails**:

1. **Edit `messaging/.env`**:
   ```bash
   MAILHOG_OUTGOING_SMTP_ENABLED=true
   ```

2. **Set credentials in `secrets.env`**:
   ```bash
   EMAIL_SMTP_HOST=smtp.ionos.de
   EMAIL_SMTP_PORT=465
   EMAIL_SMTP_USER=hi@pivoine.art
   EMAIL_SMTP_PASSWORD=your_password_here
   ```

3. **Restart Mailhog**:
   ```bash
   ./kompose.sh restart messaging
   ```

## Priority Levels (Gotify)

| Priority | Use Case | Example |
|----------|----------|---------|
| 0 | Very low | Background info |
| 2 | Low | FYI messages |
| 5 | **Normal** | Standard notifications |
| 8 | High | Important updates |
| 10 | Emergency | Server on fire! 🔥 |

## Real-World Use Cases

### Server Monitoring
```bash
# Disk space alert
if [ $(df -h / | tail -1 | awk '{print $5}' | sed 's/%//') -gt 80 ]; then
    curl -X POST "https://chat.pivoine.art/message" \
        -H "X-Gotify-Key: $TOKEN" \
        -F "title=Disk Space Alert" \
        -F "message=Root partition is 80% full!" \
        -F "priority=9"
fi
```

### Backup Notifications
```bash
# At end of backup script
curl -X POST "https://chat.pivoine.art/message" \
    -H "X-Gotify-Key: $TOKEN" \
    -F "title=Backup Complete" \
    -F "message=Database backup finished successfully" \
    -F "priority=5"
```

### CI/CD Pipeline
```yaml
# .gitlab-ci.yml
deploy:
  script:
    - deploy.sh
  after_script:
    - |
      curl -X POST "$GOTIFY_URL/message" \
        -H "X-Gotify-Key: $GOTIFY_TOKEN" \
        -F "title=Deploy $CI_COMMIT_REF_NAME" \
        -F "message=Pipeline completed"
```

### Home Assistant
```yaml
# configuration.yaml
notify:
  - platform: rest
    name: gotify
    resource: https://chat.pivoine.art/message
    method: POST
    headers:
      X-Gotify-Key: YOUR_TOKEN
    message_param_name: message
    title_param_name: title
```

## Markdown Support (Gotify)

**Rich formatted messages**:
```bash
curl -X POST "https://chat.pivoine.art/message" \
    -H "X-Gotify-Key: $TOKEN" \
    -F "title=Deployment Report" \
    -F "message=## Status

- ✅ Database migration
- ✅ Frontend build
- ✅ Backend restart
- ⚠️  Cache warmup slow

**Next**: Monitor performance" \
    -F "priority=5"
```

## Troubleshooting

**Gotify: Not receiving notifications on mobile**:
```bash
# Check app has notification permissions
# Verify server URL is correct
# Check token is app token, not client token
```

**Mailhog: Emails not appearing**:
```bash
# Check service is using correct SMTP config
docker logs messaging_mailhog -f

# Verify service is on kompose network
docker inspect SERVICE_NAME | grep -i network
```

**External relay not working**:
```bash
# Verify credentials in secrets.env
# Check MAILHOG_OUTGOING_SMTP_ENABLED=true
# View Mailhog logs for SMTP errors
docker logs messaging_mailhog -f
```

## Security

- :icon{name="lucide:lock-keyhole"} **Change Gotify Password**: First login!
- :icon{name="lucide:shield"} **Protect Mailhog UI**: Contains all emails
- :icon{name="lucide:key"} **App Tokens**: One per application
- :icon{name="lucide:globe"} **HTTPS**: Via Traefik
- :icon{name="lucide:network"} **Internal Network**: Services communicate securely

## Documentation

**In stack directory**:
- :icon{name="lucide:book-open"} **README.md**: Quick start
- :icon{name="lucide:file-text"} **MESSAGING_STACK.md**: Complete docs
- :icon{name="lucide:plug"} **MAILHOG_INTEGRATION.md**: Integration guide

**External Resources**:
- [Gotify Documentation](https://gotify.net/docs/)
- [Mailhog GitHub](https://github.com/mailhog/MailHog)

## Quick Commands

```bash
# Start stack
./kompose.sh up messaging

# Stop stack
./kompose.sh down messaging

# View logs
./kompose.sh logs messaging -f

# Restart Gotify
docker restart messaging_gotify

# Restart Mailhog
docker restart messaging_mailhog
```

## Integration with Other Stacks

### All Stacks
- :icon{name="lucide:mail"} **SMTP**: Use Mailhog for email

### Home Stack
- :icon{name="lucide:home"} **Home Assistant**: Send notifications
- :icon{name="lucide:bell"} **Alerts**: Security, automation events

### Chain Stack
- :icon{name="lucide:zap"} **n8n**: Workflow notifications
- :icon{name="lucide:server"} **Semaphore**: Deployment alerts

### Auth Stack
- :icon{name="lucide:key"} **Keycloak**: Password reset emails
- :icon{name="lucide:users"} **User Management**: Account emails

---

*"The only notifications worth getting are the ones you control."* :icon{name="lucide:bell"}:icon{name="lucide:sparkles"}
