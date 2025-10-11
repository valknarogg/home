# Messaging Stack Migration Summary

## What Changed

The **chat** stack has been enhanced and renamed to **messaging** to better reflect its expanded capabilities.

### Previous State (Chat Stack)
- ✅ Single service: Gotify (notifications)
- ✅ URL: https://chat.pivoine.art
- ✅ Container: `chat_app`

### Current State (Messaging Stack)
- ✅ Two services: Gotify + Mailhog
- ✅ URLs:
  - Gotify: https://chat.pivoine.art
  - Mailhog: https://mail.pivoine.art
- ✅ Containers:
  - `messaging_gotify`
  - `messaging_mailhog`

## Changes Made

### 1. Stack Renamed
- **Name**: `chat` → `messaging`
- **Compose Project**: `chat` → `messaging`
- **Directory**: Still located in `chat/` folder (no directory rename needed)

### 2. New Service Added: Mailhog
- **Image**: `mailhog/mailhog:latest`
- **Internal SMTP Port**: 1025
- **Web UI Port**: 8025
- **URL**: https://mail.pivoine.art
- **Purpose**: Email testing and optional SMTP relay

### 3. Gotify Connected to Mailhog
- Gotify now uses Mailhog for sending email notifications
- SMTP configuration automatically points to Mailhog
- No external SMTP needed for Gotify

### 4. Configuration Files Updated

#### compose.yaml
- Stack name changed to `messaging`
- Mailhog service added
- Gotify connected to Mailhog via SMTP
- Container names updated with `messaging_` prefix
- Traefik labels updated

#### .env
- Stack renamed to `messaging`
- Gotify configuration preserved
- Mailhog configuration added
- `MAILHOG_OUTGOING_SMTP_ENABLED` flag added (default: false)

#### Root .env
- Added: `TRAEFIK_HOST_MAIL=mail.pivoine.art`

#### secrets.env.template
- Updated comments for messaging stack
- Noted that `EMAIL_SMTP_PASSWORD` is used by Mailhog

### 5. Documentation Added
- `README.md` - Quick start guide
- `MESSAGING_STACK.md` - Complete documentation
- `MAILHOG_INTEGRATION.md` - Integration guide for all stacks

## File Changes Summary

```
Modified Files:
├── chat/compose.yaml          (Updated)
├── chat/.env                  (Updated)
├── .env                       (Added TRAEFIK_HOST_MAIL)
└── secrets.env.template       (Updated comments)

New Files:
├── chat/README.md
├── chat/MESSAGING_STACK.md
└── chat/MAILHOG_INTEGRATION.md

Preserved:
├── chat/.env.bak
└── chat/compose.yaml.bak
```

## Migration Checklist

Follow these steps to apply the changes:

### Step 1: Stop the Current Stack
```bash
cd ~/Projects/kompose/chat
docker compose down
```

### Step 2: Update DNS (if needed)
Add DNS record for Mailhog:
```
mail.pivoine.art → [your server IP]
```

### Step 3: Start the New Stack
```bash
docker compose up -d
```

### Step 4: Verify Services
```bash
# Check status
docker compose ps

# View logs
docker compose logs -f

# Test URLs
curl https://chat.pivoine.art
curl https://mail.pivoine.art
```

### Step 5: Test Email Flow
```bash
# Send test email
docker exec -it messaging_mailhog sh
echo "Subject: Test\n\nTest email" | /usr/bin/sendmail test@example.com

# View in UI: https://mail.pivoine.art
```

### Step 6: Update Other Stacks (Recommended)
Connect other kompose services to use Mailhog for email:

See `chat/MAILHOG_INTEGRATION.md` for specific examples.

Example for most services:
```yaml
services:
  your_service:
    environment:
      SMTP_HOST: mailhog
      SMTP_PORT: 1025
      SMTP_FROM: ${EMAIL_FROM}
```

### Step 7: Security
```bash
# Change Gotify password
# 1. Visit https://chat.pivoine.art
# 2. Login with admin/admin
# 3. Go to Settings → Change Password
```

## Rollback Plan

If you need to revert to the old configuration:

```bash
# Stop new stack
docker compose down

# Restore backups
cp .env.bak .env
cp compose.yaml.bak compose.yaml

# Start old stack
docker compose up -d
```

Backup files are automatically preserved as `.bak` files.

## New Capabilities

### 1. Email Testing for All Services
All kompose services can now send emails through Mailhog for testing without risk of sending to real users.

### 2. Development Mode (Default)
```bash
MAILHOG_OUTGOING_SMTP_ENABLED=false
```
All emails are caught locally in Mailhog UI.

### 3. Production-like Testing
```bash
MAILHOG_OUTGOING_SMTP_ENABLED=true
```
Mailhog relays emails to real recipients via configured SMTP server.

### 4. Email Debugging
View all sent emails in real-time at https://mail.pivoine.art

## Integration with Existing Services

Mailhog is designed to be the central SMTP server for all kompose services:

```
┌─────────┐
│  AUTH   │─┐
└─────────┘ │
            │
┌─────────┐ │    ┌──────────┐     ┌────────────┐
│  AUTO   │─┼───▶│ Mailhog  │────▶│ External   │
└─────────┘ │    │          │     │ SMTP       │
            │    └──────────┘     │ (optional) │
┌─────────┐ │         ▲           └────────────┘
│  VAULT  │─┘         │
└─────────┘           │
                      │
              ┌───────┴───────┐
              │   View in UI  │
              │ mail.pivoine  │
              └───────────────┘
```

## Configuration Reference

### Mailhog SMTP Settings (Internal)
```
Host: mailhog
Port: 1025
SSL/TLS: false
Auth: none
```

### Mailhog Web UI
```
URL: https://mail.pivoine.art
Port: 8025 (internal)
```

### External SMTP Relay (Optional)
```
Host: smtp.ionos.de
Port: 465
User: hi@pivoine.art
Password: [from secrets.env]
```

## Testing Scenarios

### Scenario 1: Catch All Emails (Development)
```bash
# messaging/.env
MAILHOG_OUTGOING_SMTP_ENABLED=false

# All emails stay in Mailhog
# View at: https://mail.pivoine.art
```

### Scenario 2: Test Real Email Delivery (Staging)
```bash
# messaging/.env
MAILHOG_OUTGOING_SMTP_ENABLED=true

# Emails are relayed to real recipients
# Still visible in Mailhog UI for debugging
```

### Scenario 3: Production (Future)
```yaml
# Configure services to bypass Mailhog
environment:
  SMTP_HOST: ${EMAIL_SMTP_HOST}
  SMTP_PORT: ${EMAIL_SMTP_PORT}
  SMTP_USER: ${EMAIL_SMTP_USER}
  SMTP_PASSWORD: ${EMAIL_SMTP_PASSWORD}
```

## Next Steps

1. ✅ Migration complete
2. ⬜ Update DNS for mail.pivoine.art
3. ⬜ Start messaging stack
4. ⬜ Verify both services are accessible
5. ⬜ Change Gotify password
6. ⬜ Test email by sending to Mailhog
7. ⬜ Connect other services to Mailhog (see MAILHOG_INTEGRATION.md)
8. ⬜ Decide on relay mode (dev vs staging)

## Support & Documentation

- **Quick Start**: `chat/README.md`
- **Complete Guide**: `chat/MESSAGING_STACK.md`
- **Integration Examples**: `chat/MAILHOG_INTEGRATION.md`
- **Gotify Docs**: https://gotify.net/docs/
- **Mailhog Docs**: https://github.com/mailhog/MailHog

## Questions?

Common questions are answered in `chat/MESSAGING_STACK.md` under the Troubleshooting section.

---

**Status**: ✅ Migration Complete  
**Date**: $(date)  
**Stack**: messaging (formerly chat)  
**Services**: Gotify + Mailhog  
**URLs**: chat.pivoine.art, mail.pivoine.art
