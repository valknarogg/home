---
title: � Chat Stack - Your Personal Notification HQ
description: "Ding! You've got... pretty much everything"
---

# 💬 Chat Stack - Your Personal Notification HQ

> *"Ding! You've got... pretty much everything"* - Gotify

## What's This All About?

Gotify is your self-hosted push notification server! Think of it as your personal notification center that's NOT controlled by Google or Apple. Get alerts from your scripts, servers, and automation tools - all in one place, all under your control!

## The Notification Ninja

### 🔔 Gotify Server

**Container**: `chat_app`  
**Image**: `gotify/server:latest`  
**Home**: https://chat.pivoine.art

Gotify is the Swiss Army knife of push notifications:
- 📱 **Mobile Apps**: iOS and Android clients available
- 🌐 **Web Interface**: Check notifications in your browser
- 🔌 **REST API**: Send notifications from anything
- 🔒 **App Tokens**: Separate tokens for different applications
- 📊 **Priority Levels**: From "meh" to "WAKE UP NOW!"
- 🎨 **Markdown Support**: Rich formatted messages
- 📦 **Simple**: Written in Go, single binary, no fuss

## How It Works

```
Your Script/Server
    ↓
HTTP POST Request
    ↓
Gotify Server
    ↓
Push to Mobile Apps + Web Interface
```

## Configuration Breakdown

### Data Persistence
Everything lives in a Docker volume:
```
Volume: gotify_data
Path: /app/data
```

This stores:
- 🗄️ SQLite database (users, apps, messages)
- 🖼️ Application images
- ⚙️ Server configuration

### No Exposed Port
All access goes through Traefik at https://chat.pivoine.art - clean and secure!

## First Time Setup 🚀

1. **Start the stack**:
   ```bash
   docker compose up -d
   ```

2. **Access the web UI**:
   ```
   URL: https://chat.pivoine.art
   Default Username: admin
   Default Password: admin
   ```

3. **IMMEDIATELY change the password**:
   - Click on your username
   - Go to Settings
   - Change that password right now! 🔒

4. **Create an application**:
   - Apps → New Application
   - Name it (e.g., "Server Alerts")
   - Copy the token (you'll need this!)

## Sending Your First Notification

### Using curl
```bash
curl -X POST "https://chat.pivoine.art/message" \
  -H "X-Gotify-Key: YOUR_APP_TOKEN" \
  -F "title=Hello World" \
  -F "message=Your first notification!" \
  -F "priority=5"
```

### Using Python
```python
import requests

def send_notification(title, message, priority=5):
    url = "https://chat.pivoine.art/message"
    headers = {"X-Gotify-Key": "YOUR_APP_TOKEN"}
    data = {
        "title": title,
        "message": message,
        "priority": priority
    }
    requests.post(url, headers=headers, data=data)

send_notification("Deploy Complete", "Your app is live! 🚀")
```

### Using Bash Script
```bash
#!/bin/bash
GOTIFY_URL="https://chat.pivoine.art/message"
GOTIFY_TOKEN="YOUR_APP_TOKEN"

notify() {
    curl -X POST "$GOTIFY_URL" \
        -H "X-Gotify-Key: $GOTIFY_TOKEN" \
        -F "title=$1" \
        -F "message=$2" \
        -F "priority=${3:-5}"
}

# Usage
notify "Backup Complete" "All files backed up successfully" 8
```

## Priority Levels 🎯

| Priority | Use Case | Example |
|----------|----------|---------|
| 0 | Very low | Background info |
| 2 | Low | FYI messages |
| 5 | Normal | Standard notifications |
| 8 | High | Important updates |
| 10 | Emergency | WAKE UP! SERVER IS ON FIRE! 🔥 |

## Real-World Use Cases

### Server Monitoring
```bash
# Disk space alert
if [ $(df -h / | tail -1 | awk '{print $5}' | sed 's/%//') -gt 80 ]; then
    notify "Disk Space Alert" "Root partition is 80% full!" 9
fi
```

### Backup Notifications
```bash
# At end of backup script
if backup_successful; then
    notify "Backup Complete" "Database backup finished successfully" 5
else
    notify "Backup Failed" "Database backup encountered errors!" 10
fi
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
        -F "message=Pipeline $CI_PIPELINE_ID completed"
```

### Docker Container Alerts
```bash
# Check if container is running
if ! docker ps | grep -q my_important_container; then
    notify "Container Down" "my_important_container is not running!" 10
fi
```

### Website Uptime Monitoring
```bash
# Simple uptime check
if ! curl -f https://mysite.com &> /dev/null; then
    notify "Site Down" "mysite.com is not responding!" 10
fi
```

## Mobile Apps 📱

### Android
Download from:
- F-Droid (recommended)
- Google Play Store
- GitHub Releases

### iOS
- Available on App Store
- Or build from source (TestFlight)

**Setup**:
1. Install app
2. Add server: `https://chat.pivoine.art`
3. Enter your client token
4. Receive notifications!

## Web Interface Features

- 📱 Desktop notifications (browser permission needed)
- 🔍 Search through message history
- 🗑️ Delete individual or all messages
- 👥 Manage applications and clients
- ⚙️ Configure server settings
- 📊 View message statistics

## Security Best Practices 🔒

1. **Change Default Credentials**: First thing, every time
2. **Use App Tokens**: Different token for each application/script
3. **Revoke Unused Tokens**: Clean up old integrations
4. **HTTPS Only**: Already configured via Traefik ✅
5. **Client Tokens**: Create separate tokens for each device
6. **Rate Limiting**: Gotify has built-in protection

## Advanced: Markdown Messages

Gotify supports Markdown formatting:

```bash
curl -X POST "https://chat.pivoine.art/message" \
  -H "X-Gotify-Key: YOUR_TOKEN" \
  -F "title=Deployment Report" \
  -F "message=## Deploy Status
  
- ✅ Database migration
- ✅ Frontend build  
- ✅ Backend restart
- ⚠️  Cache warmup (slower than expected)

**Next**: Monitor performance metrics" \
  -F "priority=5"
```

## Maintenance Tasks

### View Logs
```bash
docker logs chat_app -f
```

### Backup Database
```bash
docker exec chat_app cp /app/data/gotify.db /app/data/gotify-backup.db
docker cp chat_app:/app/data/gotify-backup.db ./backup/
```

### Check Storage
```bash
docker exec chat_app du -sh /app/data
```

### Clean Old Messages
Use the web UI to delete old messages, or configure auto-deletion in settings

## Troubleshooting

**Q: Not receiving notifications on mobile?**  
A: Check if app has notification permissions and server URL is correct

**Q: "Unauthorized" error when sending?**  
A: Verify your app token is correct and not a client token

**Q: Web UI won't load?**  
A: Check Traefik is running and DNS points to your server

**Q: Messages not persisting?**  
A: Ensure volume is properly mounted and has write permissions

## Integration Examples

### Home Assistant
```yaml
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

### Prometheus Alertmanager
```yaml
receivers:
  - name: 'gotify'
    webhook_configs:
      - url: 'https://chat.pivoine.art/message?token=YOUR_TOKEN'
```

### Node-RED
Use HTTP request node:
- Method: POST
- URL: `https://chat.pivoine.art/message`
- Headers: `X-Gotify-Key: YOUR_TOKEN`
- Body: JSON with title, message, priority

## Why Gotify Rocks 🎸

- ✨ Self-hosted (your data, your server)
- 🆓 Completely free and open source
- 🚀 Super lightweight (Go binary + SQLite)
- 📱 Native mobile apps
- 🔌 Dead simple API
- 🎨 Clean, modern interface
- 🔒 No third-party dependencies
- 💪 Active development

## Resources

- [Gotify Documentation](https://gotify.net/docs/)
- [API Documentation](https://gotify.net/api-docs)
- [GitHub Repository](https://github.com/gotify/server)
- [Mobile Apps](https://gotify.net/docs/index)

---

*"The only notifications worth getting are the ones you control."* - Someone who's tired of their phone buzzing 📵✨
