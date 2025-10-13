---
title: Chain - Workflow & Infrastructure Automation
description: "n8n + Semaphore: Automate everything!"
navigation:
  icon: i-lucide-link-2
---

> *"If you can dream it, you can automate it!"* - Chain stack philosophy

## What's This All About?

The **chain** stack combines two powerful automation platforms to create a comprehensive automation ecosystem: **n8n** for workflow automation and **Semaphore** for infrastructure automation via Ansible. Together, they can automate virtually any task, from simple data transformations to complex infrastructure deployments.

## The Stack

### :icon{name="lucide:zap"} n8n

**Container**: `chain_n8n`  
**Image**: `n8nio/n8n:latest`  
**URL**: Configured via `SUBDOMAIN_CHAIN` in `domain.env`
- Local: http://localhost:5678
- Production: https://chain.pivoine.art  
**Port**: 5678

Visual workflow automation platform:
- :icon{name="lucide:plug"} **400+ Integrations**: Connect virtually anything
- :icon{name="lucide:palette"} **Visual Builder**: Drag-and-drop workflows
- :icon{name="lucide:code"} **Code Nodes**: JavaScript when needed
- :icon{name="lucide:webhook"} **Webhooks**: Trigger from anywhere
- :icon{name="lucide:clock"} **Scheduling**: Cron-style automation
- :icon{name="lucide:git-branch"} **Branching Logic**: Complex workflows
- :icon{name="lucide:refresh-cw"} **Error Handling**: Retry and fallback
- :icon{name="lucide:database"} **PostgreSQL**: Reliable storage

### :icon{name="lucide:server"} Semaphore

**Container**: `chain_semaphore`  
**Image**: `semaphoreui/semaphore:v2.16.18`  
**URL**: Configured via `SUBDOMAIN_AUTO` in `domain.env`
- Local: http://localhost:3000
- Production: https://auto.pivoine.art  
**Port**: 3000

Ansible automation UI and task runner:
- :icon{name="lucide:play"} **Ansible Playbooks**: Web-based execution
- :icon{name="lucide:folder"} **Project Management**: Organize playbooks
- :icon{name="lucide:users"} **Team Collaboration**: User management
- :icon{name="lucide:history"} **Task History**: Track all executions
- :icon{name="lucide:bell"} **Email Alerts**: Task notifications
- :icon{name="lucide:lock"} **Credential Vault**: Secure secrets
- :icon{name="lucide:database"} **PostgreSQL**: Persistent storage

### :icon{name="lucide:play-circle"} Semaphore Runner

**Container**: `chain_semaphore_runner`  
**Image**: `public.ecr.aws/semaphore/pro/runner:v2.16.18`

Background task executor:
- :icon{name="lucide:cpu"} **Task Execution**: Runs Ansible playbooks
- :icon{name="lucide:refresh-cw"} **Auto-Registration**: Connects to Semaphore
- :icon{name="lucide:shield"} **Isolated**: Runs tasks separately
- :icon{name="lucide:zap"} **Fast**: Dedicated executor

## Architecture

```
┌──────────────────────────────────────────────────────┐
│                   Chain Stack                         │
│                                                        │
│  ┌────────────┐          ┌──────────────────┐        │
│  │    n8n     │──────────▶│   Semaphore     │        │
│  │ Workflows  │   API     │   Ansible UI    │        │
│  └─────┬──────┘          └────────┬─────────┘        │
│        │                           │                  │
│        │                           │ JWT Auth         │
│        │                           ▼                  │
│        │                  ┌────────────────┐         │
│        │                  │   Semaphore    │         │
│        │                  │     Runner     │         │
│        │                  └────────────────┘         │
│        │                                              │
│        ▼                                              │
│  ┌──────────────┐                                    │
│  │  PostgreSQL  │◀───(from core stack)               │
│  │   Databases  │                                    │
│  │  - n8n       │                                    │
│  │  - semaphore │                                    │
│  └──────────────┘                                    │
└──────────────────────────────────────────────────────┘
```

## Configuration

### n8n Setup

**Default Credentials**:
- Username: `admin`
- Password: Set in `.env` (`N8N_BASIC_AUTH_PASSWORD`)

**:icon{name="lucide:alert-triangle"} CRITICAL**: Change default password immediately!

**Database**: Stores workflows and credentials in `n8n` database

**Encryption**: All credentials encrypted with `N8N_ENCRYPTION_KEY`

### Semaphore Setup

**Default Admin**:
- Username: Set in `.env` (`SEMAPHORE_ADMIN`)
- Password: Set in `.env` (`SEMAPHORE_ADMIN_PASSWORD`)
- Email: Set in `.env` (`ADMIN_EMAIL`)

**Database**: Stores projects and tasks in `semaphore` database

**Runner**: Auto-registers using `SEMAPHORE_RUNNER_TOKEN`

## Getting Started

### First Login - n8n

1. **Access n8n**: Check your domain configuration
   - Local: http://localhost:5678
   - Production: https://chain.pivoine.art
2. **Login**: Use admin credentials
3. **Change Password**: User icon → Settings
4. **Create Workflow**: Click "New Workflow"

### First Login - Semaphore

1. **Access Semaphore**: Check your domain configuration
   - Local: http://localhost:3000
   - Production: https://auto.pivoine.art
2. **Login**: Use admin credentials
3. **Create Project**: Projects → New Project
4. **Add Playbooks**: Upload Ansible playbooks
5. **Add Inventory**: Configure target hosts

## Integration: n8n ↔ Semaphore

### Trigger Ansible from n8n

**n8n HTTP Request Node**:
```javascript
{
  "method": "POST",
  "url": "http://semaphore:3000/api/project/{{$json.project_id}}/tasks",
  "authentication": "headerAuth",
  "headerParameters": {
    "parameters": [
      {
        "name": "Authorization",
        "value": "Bearer YOUR_API_TOKEN"
      }
    ]
  },
  "bodyParameters": {
    "parameters": [
      {
        "name": "template_id",
        "value": "={{$json.template_id}}"
      },
      {
        "name": "debug",
        "value": false
      }
    ]
  }
}
```

### Use Cases

**Deployment Automation**:
- n8n detects Git push
- Triggers Semaphore deployment playbook
- Sends notification on completion

**Infrastructure Updates**:
- Scheduled n8n workflow
- Runs Semaphore maintenance tasks
- Logs results to database

**Event-Driven Operations**:
- Webhook triggers n8n
- n8n processes data
- Executes Ansible via Semaphore

## Common n8n Workflows

### Data Integration
- Pull data from APIs
- Transform and clean
- Push to database or services

### Notifications
- Monitor events
- Send alerts (Slack, Email, Gotify)
- Track responses

### Automation Chains
- Trigger on schedule or webhook
- Multi-step processing
- Error handling and retries

## Common Semaphore Tasks

### Infrastructure Deployment
- Deploy applications
- Configure servers
- Update packages

### Maintenance Tasks
- Backup databases
- Clean up resources
- Health checks

### Configuration Management
- Update configs across servers
- Restart services
- Apply security patches

## Database Management

**Both services use PostgreSQL from core stack**:

```bash
# Check databases
./kompose.sh db shell -d n8n
./kompose.sh db shell -d semaphore

# Backup
./kompose.sh db backup -d n8n --compress
./kompose.sh db backup -d semaphore --compress

# Restore
./kompose.sh db restore -f backup.sql.gz -d n8n
```

## Environment Variables

**Domain Configuration** (in `domain.env`):
- `SUBDOMAIN_CHAIN`: n8n subdomain (default: `chain` for production, `localhost:5678` for local)
- `SUBDOMAIN_AUTO`: Semaphore subdomain (default: `auto` for production, `localhost:3000` for local)
- `ROOT_DOMAIN`: Your domain (e.g., `pivoine.art`)
- The system automatically generates `N8N_TRAEFIK_HOST` and `SEMAPHORE_TRAEFIK_HOST` from these values

**n8n** (in `.env` or `secrets.env`):
- `N8N_ENCRYPTION_KEY`: Credential encryption (CRITICAL!)
- `N8N_BASIC_AUTH_USER`: Admin username
- `N8N_BASIC_AUTH_PASSWORD`: Admin password
- `WEBHOOK_URL`: Auto-generated from domain configuration

**Semaphore** (in `.env` or `secrets.env`):
- `SEMAPHORE_ADMIN`: Admin username
- `SEMAPHORE_ADMIN_PASSWORD`: Admin password
- `SEMAPHORE_RUNNER_TOKEN`: Runner registration token
- Email configuration for notifications

## Troubleshooting

**n8n won't start**:
```bash
# Check logs
docker logs chain_n8n -f

# Verify database connection
./kompose.sh db exec -d postgres "\l" | grep n8n
```

**Semaphore runner not connecting**:
```bash
# Check runner logs
docker logs chain_semaphore_runner -f

# Verify token
docker exec chain_semaphore_runner env | grep SEMAPHORE
```

**Forgot n8n password**:
```bash
# Update in .env file
# Restart container
./kompose.sh restart chain
```

## Security

- :icon{name="lucide:lock-keyhole"} **Change Defaults**: Update all passwords
- :icon{name="lucide:key"} **Strong Encryption Key**: Use secure random key
- :icon{name="lucide:globe"} **HTTPS Only**: Via Traefik
- :icon{name="lucide:shield"} **API Tokens**: Use tokens, not passwords
- :icon{name="lucide:database"} **Backup Encryption Keys**: Store securely!

## Documentation

**In stack directory**:
- :icon{name="lucide:book-open"} **INTEGRATION_GUIDE.md**: Complete setup guide

**External Resources**:
- [n8n Documentation](https://docs.n8n.io/)
- [Semaphore Documentation](https://docs.semaphoreui.com/)
- [Ansible Documentation](https://docs.ansible.com/)

## Quick Commands

```bash
# Start stack
./kompose.sh up chain

# Stop stack
./kompose.sh down chain

# View logs
./kompose.sh logs chain -f

# Restart n8n only
docker restart chain_n8n

# Restart Semaphore only
docker restart chain_semaphore
```

## Integration with Other Stacks

### Core Stack
- :icon{name="lucide:database"} **PostgreSQL**: Data storage
- :icon{name="lucide:share-2"} **MQTT**: Pub/sub messaging
- :icon{name="lucide:zap"} **Redis**: Caching

### Home Stack
- :icon{name="lucide:home"} **Home Assistant**: Control automation
- :icon{name="lucide:webhook"} **Webhooks**: Trigger workflows

### Messaging Stack
- :icon{name="lucide:bell"} **Gotify**: Send notifications
- :icon{name="lucide:mail"} **Email**: Task alerts

### Auth Stack
- :icon{name="lucide:key"} **Keycloak**: SSO integration (optional)

---

*"Automation isn't about replacing humans - it's about freeing them to do what they do best: think creatively and solve complex problems."* :icon{name="lucide:zap"}:icon{name="lucide:link"}
