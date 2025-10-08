# ⛓️ Chain Stack - Workflow Automation Powerhouse

> *"If you can dream it, you can automate it!"* - n8n philosophy

## What's This All About?

This stack is your automation Swiss Army knife! n8n lets you connect different apps and services to create powerful workflows without writing code (though you can if you want!). Think Zapier or IFTTT, but open-source, self-hosted, and infinitely more powerful.

## The Star of the Show

### ⚡ n8n

**Container**: `chain_app`  
**Image**: `n8nio/n8n:latest`  
**Home**: https://chain.localhost  
**Port**: 5678

n8n is workflow automation done right:
- 🔌 **400+ Integrations**: Connect virtually anything
- 🎨 **Visual Builder**: Drag-and-drop workflow creation
- 💻 **Code Nodes**: Write JavaScript when you need it
- 🪝 **Webhooks**: Trigger workflows from anywhere
- ⏰ **Scheduling**: Cron-style automation
- 📊 **Data Transformation**: Powerful data manipulation
- 🔄 **Error Handling**: Retry logic and fallbacks
- 📝 **Version Control**: Export workflows as JSON

## Configuration Breakdown

### Database Connection
All workflows and credentials stored in PostgreSQL:
```
Database: n8n
Host: Shared data stack (postgres)
```

### Basic Auth 🔒
**Default Credentials**:
- Username: `admin`
- Password: `changeme`

**⚠️ CRITICAL**: Change these immediately after first login!

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

3. **⚠️ IMMEDIATELY Change Password**:
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

## Security Notes 🔒

- 🔑 **Encryption Key**: Store securely
- 🔐 **Change Default Auth**: ASAP!
- 🌐 **HTTPS Only**: Via Traefik
- 🔒 **OAuth**: Use for sensitive integrations

## Resources

- [n8n Documentation](https://docs.n8n.io/)
- [Workflow Templates](https://n8n.io/workflows)
- [Community Forum](https://community.n8n.io/)

---

*"Automation isn't about replacing humans - it's about freeing them to do what they do best: think creatively and solve complex problems."* ⚡🔗
