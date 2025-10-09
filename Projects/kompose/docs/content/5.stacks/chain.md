---
title: Chain - Workflow Automation Powerhouse
description: "If you can dream it, you can automate it!"
navigation:
  icon: i-lucide-link-2
---

> *"If you can dream it, you can automate it!"* - n8n philosophy

## What's This All About?

This stack is your automation Swiss Army knife! n8n lets you connect different apps and services to create powerful workflows without writing code (though you can if you want!). Think Zapier or IFTTT, but open-source, self-hosted, and infinitely more powerful.

## The Star of the Show

### :icon{name="lucide:zap"} n8n

**Container**: `chain_app`  
**Image**: `n8nio/n8n:latest`  
**Home**: https://chain.localhost  
**Port**: 5678

n8n is workflow automation done right:
- :icon{name="lucide:plug"} **400+ Integrations**: Connect virtually anything
- :icon{name="lucide:palette"} **Visual Builder**: Drag-and-drop workflow creation
- :icon{name="lucide:laptop"} **Code Nodes**: Write JavaScript when you need it
- :icon{name="lucide:git-branch"} **Webhooks**: Trigger workflows from anywhere
- :icon{name="lucide:clock"} **Scheduling**: Cron-style automation
- :icon{name="lucide:bar-chart"} **Data Transformation**: Powerful data manipulation
- :icon{name="lucide:refresh-cw"} **Error Handling**: Retry logic and fallbacks
- :icon{name="lucide:file-text"} **Version Control**: Export workflows as JSON

## Configuration Breakdown

### Database Connection
All workflows and credentials stored in PostgreSQL:
```
Database: n8n
Host: Shared data stack (postgres)
```

### Basic Auth :icon{name="lucide:lock"}
**Default Credentials**:
- Username: `admin`
- Password: `changeme`

**:icon{name="lucide:alert-triangle"} CRITICAL**: Change these immediately after first login!

### Encryption Key
Credentials are encrypted using `N8N_ENCRYPTION_KEY`. This is auto-generated during setup. Never lose this key or you'll lose access to saved credentials!

## Getting Started

### First Login

1. **Start the stack**:
   ```bash
   docker compose up -d
   ```

2. **Access n8n**:
   ```
   URL: https://chain.localhost
   Username: admin
   Password: changeme
   ```

3. **:icon{name="lucide:alert-triangle"} IMMEDIATELY Change Password**:
   - Click user icon (top right)
   - Settings → Personal
   - Change password

### Creating Your First Workflow

1. **Click "New Workflow"** button
2. **Add trigger node**: Webhook, Schedule, or Manual
3. **Add action nodes**: Drag from left panel
4. **Connect with arrows**
5. **Test**: Execute manually
6. **Activate**: Toggle switch (top right)

## Common Integrations

- **Slack/Discord**: Send messages
- **Gmail**: Email operations
- **Google Sheets**: Read/write data
- **GitHub**: Issues, PRs, releases
- **Home Assistant**: Control devices
- **Webhooks**: Trigger anything

## Troubleshooting

**Q: Forgot password?**  
A: Update `N8N_BASIC_AUTH_PASSWORD` in `.env` and restart

**Q: Credentials not working?**  
A: Check `N8N_ENCRYPTION_KEY` hasn't changed

**Q: Workflow not triggering?**  
A: Verify it's activated and check execution logs

## Security Notes :icon{name="lucide:lock"}

- :icon{name="lucide:key"} **Encryption Key**: Store securely
- :icon{name="lucide:lock-keyhole"} **Change Default Auth**: ASAP!
- :icon{name="lucide:globe"} **HTTPS Only**: Via Traefik
- :icon{name="lucide:lock"} **OAuth**: Use for sensitive integrations

## Resources

- [n8n Documentation](https://docs.n8n.io/)
- [Workflow Templates](https://n8n.io/workflows)
- [Community Forum](https://community.n8n.io/)

---

*"Automation isn't about replacing humans - it's about freeing them to do what they do best: think creatively and solve complex problems."* :icon{name="lucide:zap"}:icon{name="lucide:link"}
