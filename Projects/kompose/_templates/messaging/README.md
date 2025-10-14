# Messaging Stack Template

This template provides push notification and email testing services using Gotify and Mailhog.

## Overview

The Messaging stack consists of:
- **Gotify**: Simple server for sending and receiving push notifications
- **Mailhog**: Email testing tool that captures all outgoing emails

## Quick Start

Generate this stack using kompose-generate.sh:

```bash
./kompose-generate.sh messaging
```

This will:
1. Create the messaging stack directory if it doesn't exist
2. Copy all template files
3. Generate environment variables from kompose.yml
4. Generate secrets
5. Prepare the stack for deployment

## Files in this Template

- `kompose.yml` - Complete stack configuration with all variables and secrets defined
- `compose.yaml` - Docker Compose configuration
- `.env.example` - Example environment file (will be generated from kompose.yml)
- `README.md` - This file

## Requirements

Before deploying this stack, ensure this stack is running:
- **proxy** - Provides Traefik for routing (optional, for web access)

## Configuration

All configuration is defined in `kompose.yml`. Key settings:

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| MESSAGING_COMPOSE_PROJECT_NAME | messaging | Stack project name |
| MESSAGING_GOTIFY_IMAGE | gotify/server:latest | Gotify image |
| MESSAGING_GOTIFY_DEFAULTUSER_NAME | admin | Gotify admin username |
| MESSAGING_GOTIFY_PORT | 8085 | Gotify local port |
| MESSAGING_MAILHOG_IMAGE | mailhog/mailhog:latest | Mailhog image |
| MESSAGING_MAILHOG_PORT | 8025 | Mailhog web UI port |
| SUBDOMAIN_CHAT | chat | Gotify subdomain |
| SUBDOMAIN_MAIL | mail | Mailhog subdomain |

### Secrets

| Secret | Description | Generation |
|--------|-------------|------------|
| MESSAGING_GOTIFY_DEFAULTUSER_PASS | Gotify admin password | Auto-generated |
| EMAIL_SMTP_PASSWORD | External SMTP password (optional) | Manual |

## Deployment Steps

### 1. Generate the Stack

```bash
./kompose-generate.sh messaging
```

### 2. Review Configuration

Edit the generated files in the `messaging/` directory:
- `.env` - Environment variables
- Add your domain configuration (if using Traefik)

### 3. Start Dependencies (Optional)

If you want web access via Traefik:

```bash
docker compose -f proxy/compose.yaml up -d
```

### 4. Start Messaging Stack

```bash
docker compose -f messaging/compose.yaml up -d
```

### 5. Access Services

#### Gotify
- Web UI: https://chat.yourdomain.com (or http://localhost:8085)
- Username: admin
- Password: [from MESSAGING_GOTIFY_DEFAULTUSER_PASS in secrets.env]

#### Mailhog
- Web UI: https://mail.yourdomain.com (or http://localhost:8025)
- No authentication required

## Using Gotify for Notifications

### Create an Application

1. Log into Gotify web UI
2. Click "Apps" in the sidebar
3. Click "Create Application"
4. Enter a name (e.g., "My Service")
5. Copy the application token

### Send a Notification

#### Using curl

```bash
curl -X POST "http://localhost:8085/message" \
  -H "X-Gotify-Key: YOUR_APP_TOKEN" \
  -F "title=Hello" \
  -F "message=This is a test notification" \
  -F "priority=5"
```

#### Using Python

```python
import requests

def send_notification(title, message, priority=5):
    url = "http://messaging_gotify:80/message"
    headers = {"X-Gotify-Key": "YOUR_APP_TOKEN"}
    data = {
        "title": title,
        "message": message,
        "priority": priority
    }
    requests.post(url, headers=headers, data=data)

send_notification("Deployment", "Application deployed successfully")
```

#### Using Node.js

```javascript
const axios = require('axios');

async function sendNotification(title, message, priority = 5) {
  await axios.post('http://messaging_gotify:80/message', {
    title,
    message,
    priority
  }, {
    headers: {
      'X-Gotify-Key': 'YOUR_APP_TOKEN'
    }
  });
}

await sendNotification('Build Complete', 'Build finished successfully');
```

### In Docker Compose Services

Add to your service's environment:

```yaml
environment:
  GOTIFY_URL: http://messaging_gotify:80
  GOTIFY_TOKEN: your_app_token_here
```

## Using Mailhog for Email Testing

### Configure Services to Use Mailhog

Set your service's SMTP configuration:

```yaml
environment:
  SMTP_HOST: messaging_mailhog
  SMTP_PORT: 1025
  SMTP_USER: ""  # No authentication needed
  SMTP_PASSWORD: ""
```

### Send Test Email

#### Using Python

```python
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

def send_email(to, subject, body):
    msg = MIMEMultipart()
    msg['Subject'] = subject
    msg['From'] = 'noreply@example.com'
    msg['To'] = to
    msg.attach(MIMEText(body, 'plain'))
    
    with smtplib.SMTP('messaging_mailhog', 1025) as server:
        server.send_message(msg)

send_email('user@example.com', 'Test Email', 'This is a test')
```

#### Using Node.js

```javascript
const nodemailer = require('nodemailer');

const transporter = nodemailer.createTransport({
  host: 'messaging_mailhog',
  port: 1025,
  secure: false,
  ignoreTLS: true
});

await transporter.sendMail({
  from: 'noreply@example.com',
  to: 'user@example.com',
  subject: 'Test Email',
  text: 'This is a test email',
  html: '<p>This is a test email</p>'
});
```

### View Captured Emails

Open Mailhog web UI (http://localhost:8025 or https://mail.yourdomain.com) to see all captured emails.

Perfect for testing:
- Email templates
- Registration/verification emails
- Password reset flows
- Notification emails
- Newsletter layouts

### Enable External SMTP Relay (Optional)

To forward specific emails to real addresses:

1. Set `MESSAGING_MAILHOG_OUTGOING_SMTP_ENABLED=true` in .env
2. Configure external SMTP settings:
   ```
   EMAIL_SMTP_HOST=smtp.gmail.com
   EMAIL_SMTP_PORT=587
   EMAIL_SMTP_USER=your-email@gmail.com
   EMAIL_SMTP_PASSWORD=your-app-password
   ```
3. Restart Mailhog:
   ```bash
   docker compose -f messaging/compose.yaml restart mailhog
   ```

## Access URLs

- Gotify Web UI: `https://chat.yourdomain.com` or `http://localhost:8085`
- Mailhog Web UI: `https://mail.yourdomain.com` or `http://localhost:8025`
- Mailhog SMTP: `messaging_mailhog:1025` (from other services)

## Health Checks

Check service health:

```bash
# Gotify
curl http://localhost:8085/health

# Mailhog
curl http://localhost:8025/
```

## Troubleshooting

### Gotify Won't Start

**Symptoms**: Container exits or restarts repeatedly

**Solutions**:
1. Check if port 8085 is already in use
2. Verify MESSAGING_GOTIFY_DEFAULTUSER_PASS is set in secrets.env
3. View logs:
   ```bash
   docker logs messaging_gotify
   ```

### Can't Send Notifications

**Symptoms**: API returns errors, notifications don't appear

**Solutions**:
1. Verify application token is correct
2. Check network connectivity:
   ```bash
   docker exec YOUR_CONTAINER ping messaging_gotify
   ```
3. Test with curl first
4. Check Gotify logs for errors

### Mailhog Not Receiving Emails

**Symptoms**: Sent emails don't appear in web UI

**Solutions**:
1. Verify SMTP host is `messaging_mailhog` (not localhost)
2. Check port is 1025 (not 25 or 587)
3. Ensure sending service is on kompose network
4. Check Mailhog logs:
   ```bash
   docker logs messaging_mailhog
   ```
5. Test SMTP connection:
   ```bash
   telnet messaging_mailhog 1025
   ```

### External SMTP Relay Not Working

**Symptoms**: Emails not forwarded to external addresses

**Solutions**:
1. Verify SMTP credentials are correct
2. Check firewall rules for outgoing SMTP (port 587/465)
3. Test SMTP connection manually
4. Review Mailhog logs for authentication errors
5. For Gmail, use app-specific password (not account password)

### Web UI Not Accessible

**Symptoms**: Can't access Gotify or Mailhog web interfaces

**Solutions**:
1. Check if Traefik is running:
   ```bash
   docker compose -f proxy/compose.yaml ps
   ```
2. Verify TRAEFIK_ENABLED_CHAT and TRAEFIK_ENABLED_MAIL are true
3. Check domain DNS configuration
4. Try local access (localhost:8085, localhost:8025)
5. Check Traefik logs for routing issues

## Security Considerations

### Gotify
- Keep admin password secure and rotate regularly
- Use application-specific tokens, not admin credentials
- Revoke unused application tokens
- Consider enabling authentication for webhook endpoints

### Mailhog
- **Development/Testing Only** - Not production-safe
- Never expose Mailhog publicly without authentication
- Contains sensitive email content
- Should only be accessible on private network or via VPN

### General
- Keep on private Docker network
- Use Traefik with authentication for public access
- Consider using OAuth2 Proxy for SSO protection
- Regular security updates for both services

## Monitoring

### Health Endpoints

- Gotify: http://localhost:8085/health
- Mailhog: http://localhost:8025/

### Check Service Status

```bash
docker compose -f messaging/compose.yaml ps
docker stats messaging_gotify messaging_mailhog
```

### View Logs

```bash
# All services
docker compose -f messaging/compose.yaml logs -f

# Specific service
docker logs -f messaging_gotify
docker logs -f messaging_mailhog
```

## Backup and Recovery

### Backup Gotify Data

Gotify stores data in a Docker volume. To backup:

```bash
# Create backup directory
mkdir -p ./backups/gotify

# Backup volume
docker run --rm \
  -v messaging_gotify_data:/data \
  -v $(pwd)/backups/gotify:/backup \
  alpine tar czf /backup/gotify-$(date +%Y%m%d).tar.gz -C /data .
```

### Restore Gotify Data

```bash
# Stop Gotify
docker compose -f messaging/compose.yaml stop gotify

# Restore volume
docker run --rm \
  -v messaging_gotify_data:/data \
  -v $(pwd)/backups/gotify:/backup \
  alpine sh -c "cd /data && tar xzf /backup/gotify-YYYYMMDD.tar.gz"

# Start Gotify
docker compose -f messaging/compose.yaml start gotify
```

### Mailhog Data

Mailhog doesn't persist emails - they're stored in memory only. This is by design for testing.

## Integration Examples

### Shell Script with Notifications

```bash
#!/bin/bash
set -e

GOTIFY_URL="http://messaging_gotify:80"
GOTIFY_TOKEN="your_token_here"

notify() {
  local title="$1"
  local message="$2"
  local priority="${3:-5}"
  
  curl -X POST "${GOTIFY_URL}/message" \
    -H "X-Gotify-Key: ${GOTIFY_TOKEN}" \
    -F "title=${title}" \
    -F "message=${message}" \
    -F "priority=${priority}" \
    -s > /dev/null
}

# Your script
notify "Script Started" "Backup process initiated"

# Do work
if backup_database; then
  notify "Success" "Backup completed successfully" 8
else
  notify "Error" "Backup failed!" 10
fi
```

### CI/CD Pipeline Notifications

```yaml
# GitHub Actions example
- name: Notify Deployment
  if: success()
  run: |
    curl -X POST "${{ secrets.GOTIFY_URL }}/message" \
      -H "X-Gotify-Key: ${{ secrets.GOTIFY_TOKEN }}" \
      -F "title=Deployment Complete" \
      -F "message=Application deployed to production" \
      -F "priority=7"
```

### Automated Email Testing

```python
import pytest
import smtplib
from email.mime.text import MIMEText

@pytest.fixture
def smtp():
    return smtplib.SMTP('messaging_mailhog', 1025)

def test_registration_email(smtp):
    """Test registration email is sent correctly"""
    msg = MIMEText('Welcome to our service!')
    msg['Subject'] = 'Registration Successful'
    msg['From'] = 'noreply@example.com'
    msg['To'] = 'user@example.com'
    
    smtp.send_message(msg)
    
    # Check Mailhog API for email
    # (Additional verification code here)
```

## Production Considerations

### Replacing Mailhog for Production

Mailhog is for development/testing only. For production, consider:

- **SendGrid**: Reliable email delivery service
- **Mailgun**: Email API for developers
- **Amazon SES**: AWS email service
- **Postfix**: Self-hosted SMTP server
- **Sendmail**: Traditional SMTP server

### Gotify Alternatives

For production push notifications:

- **Firebase Cloud Messaging**: Mobile push notifications
- **OneSignal**: Multi-platform notifications
- **Pushover**: Simple push notification service
- **ntfy**: Similar to Gotify with more features

### Scaling Considerations

- Gotify can handle thousands of concurrent connections
- Consider load balancing for high-traffic scenarios
- Monitor database/storage growth for Gotify
- Implement message retention policies

## Related Documentation

- [Gotify Documentation](https://gotify.net/docs/)
- [Mailhog Documentation](https://github.com/mailhog/MailHog)
- [SMTP Configuration Guide](https://www.rfc-editor.org/rfc/rfc5321)

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Review logs: `docker logs messaging_gotify` or `docker logs messaging_mailhog`
3. Consult the official documentation
4. Check kompose repository issues

## Template Version

- Version: 1.0.0
- Last Updated: 2025-10-14
- Compatible with: Kompose 1.x
