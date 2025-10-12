---
title: Code - Git Repository & CI/CD Platform
description: "Gitea: Self-hosted Git service with CI/CD automation"
navigation:
  icon: i-lucide-git-branch
---

> *"Version control and automation, all in one place"* - Code stack philosophy

## What's This All About?

The **code** stack provides a complete self-hosted Git repository management solution with integrated CI/CD capabilities through **Gitea** and **Gitea Actions**. Think of it as your private GitHub alternative that integrates seamlessly with the entire Kompose ecosystem.

## The Stack

### :icon{name="lucide:git-branch"} Gitea

**Container**: `code_gitea`  
**Image**: `gitea/gitea:latest`  
**URL**: https://code.pivoine.art  
**SSH Port**: 2222  
**HTTP Port**: 3000 (internal)

Self-hosted Git service with rich features:
- :icon{name="lucide:folder-git"} **Git Repositories**: Full Git server functionality
- :icon{name="lucide:git-pull-request"} **Pull Requests**: Code review workflow
- :icon{name="lucide:bug"} **Issue Tracking**: Built-in bug tracking
- :icon{name="lucide:book-open"} **Wiki**: Repository documentation
- :icon{name="lucide:zap"} **Gitea Actions**: Native CI/CD pipelines
- :icon{name="lucide:webhook"} **Webhooks**: Integration with external services
- :icon{name="lucide:key"} **OAuth2 Provider**: SSO for other applications
- :icon{name="lucide:users"} **Organizations**: Team management
- :icon{name="lucide:package"} **Package Registry**: Container & package hosting

### :icon{name="lucide:play-circle"} Gitea Actions Runner

**Container**: `code_gitea_runner`  
**Image**: `gitea/act_runner:latest`

CI/CD workflow executor:
- :icon{name="lucide:cpu"} **Docker-based**: Runs workflows in containers
- :icon{name="lucide:terminal"} **Multiple Labels**: Support different runner types
- :icon{name="lucide:refresh-cw"} **Auto-registration**: Connects to Gitea automatically
- :icon{name="lucide:shield"} **Isolated**: Secure workflow execution

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Code Stack                              │
│                                                             │
│  ┌──────────────┐         ┌──────────────────┐            │
│  │    Gitea     │────────▶│ Gitea Actions    │            │
│  │  Git Server  │ Trigger │     Runner       │            │
│  └──────┬───────┘         └──────────────────┘            │
│         │                                                   │
│         │ Webhooks                                         │
│         ├──────────────────────────────────────┐          │
│         │                                       │          │
│         ▼                                       ▼          │
│  ┌──────────────┐                      ┌──────────────┐  │
│  │     n8n      │                      │   Gotify     │  │
│  │  (Workflow)  │                      │(Notifications)│  │
│  └──────────────┘                      └──────────────┘  │
│         │                                                 │
│         │ Trigger                                         │
│         ▼                                                 │
│  ┌──────────────┐                                        │
│  │  Semaphore   │                                        │
│  │  (Ansible)   │                                        │
│  └──────────────┘                                        │
│                                                           │
│  Dependencies:                                            │
│  ┌─────────────┬─────────────┬─────────────┐            │
│  │ PostgreSQL  │    Redis    │   Mailhog   │            │
│  │   (core)    │   (core)    │ (messaging) │            │
│  └─────────────┴─────────────┴─────────────┘            │
└─────────────────────────────────────────────────────────────┘
```

## Tight Stack Integration

### Core Stack Integration
The code stack heavily leverages the core infrastructure:

**PostgreSQL**:
- Dedicated `gitea` database
- Stores repositories, issues, users, and settings
- Automatic initialization on first startup

**Redis**:
- Three separate Redis databases:
  - DB 1: General cache
  - DB 2: Session storage
  - DB 3: Queue management
- Improves performance significantly

**MQTT** (Optional):
- Can publish events for repository changes
- Integration with home automation triggers

### Messaging Stack Integration

**Mailhog (Development)**:
- All Gitea emails caught locally
- Test registration, password resets, notifications
- View at: https://mail.pivoine.art

**SMTP (Production)**:
- Email notifications for:
  - New issues and pull requests
  - Mentions in comments
  - Repository access changes
  - Password resets

**Gotify**:
- Real-time push notifications
- Triggered via Gitea Actions workflows
- Mobile and desktop alerts

### Chain Stack Integration

**n8n Workflows**:
Gitea webhooks trigger n8n workflows for:
- Automated deployments
- Database migrations
- Backup creation
- Notification routing
- Custom automation chains

**Semaphore/Ansible**:
- Infrastructure-as-Code deployments
- Triggered from Gitea Actions workflows
- Ansible playbook execution
- Server configuration management

**Integration Flow**:
```
Git Push → Gitea Webhook → n8n Workflow → Semaphore Task → Infrastructure Update
```

### Proxy Stack Integration

**Traefik**:
- Automatic HTTPS via Let's Encrypt
- Compression middleware
- HTTP to HTTPS redirect
- Accessible at: https://code.pivoine.art

## Configuration

### Environment Variables

Located in `code/.env`:

```bash
# Stack basics
COMPOSE_PROJECT_NAME=code
NETWORK_NAME=kompose
TIMEZONE=Europe/Paris

# Gitea configuration
GITEA_TRAEFIK_HOST=code.pivoine.art
GITEA_SSH_PORT=2222
GITEA_HTTP_PORT=3000

# Core stack connections
DB_HOST=core-postgres
DB_USER=kompose
REDIS_HOST=core-redis

# Messaging stack
EMAIL_SMTP_HOST=mailhog
EMAIL_SMTP_PORT=1025
```

### Secrets Configuration

Add to `secrets.env`:

```bash
# Database and Redis
DB_PASSWORD=your_secure_password
REDIS_PASSWORD=your_secure_password

# Gitea secrets
GITEA_SECRET_KEY=$(openssl rand -hex 64)
GITEA_INTERNAL_TOKEN=$(openssl rand -hex 105)
GITEA_OAUTH2_JWT_SECRET=$(openssl rand -base64 32)
GITEA_METRICS_TOKEN=$(openssl rand -hex 32)

# Actions runner token (generate in UI)
CODE_RUNNER_TOKEN=your_runner_token
```

## Getting Started

### 1. Start Dependencies

```bash
# Required stacks
./kompose.sh up core       # PostgreSQL, Redis
./kompose.sh up proxy      # Traefik
./kompose.sh up messaging  # Email & notifications
```

### 2. Generate Secrets

```bash
# Generate Gitea secrets
openssl rand -hex 64    # GITEA_SECRET_KEY
openssl rand -hex 105   # GITEA_INTERNAL_TOKEN
openssl rand -base64 32 # GITEA_OAUTH2_JWT_SECRET
openssl rand -hex 32    # GITEA_METRICS_TOKEN

# Add to secrets.env
```

### 3. Start Code Stack

```bash
./kompose.sh up code
```

### 4. Initial Setup

1. **Access Gitea**: https://code.pivoine.art
2. **Complete Setup Wizard**:
   - Database type: PostgreSQL (pre-configured)
   - Admin account creation
   - Application settings
3. **Enable Actions**:
   - Settings → Actions → Enable Gitea Actions
4. **Generate Runner Token**:
   - Settings → Actions → Runners → Create Runner
   - Copy registration token
5. **Update secrets.env**:
   ```bash
   CODE_RUNNER_TOKEN=your_copied_token
   ```
6. **Restart Runner**:
   ```bash
   ./kompose.sh restart code
   ```

## Gitea Actions - CI/CD Workflows

### Workflow Structure

Workflows are defined in `.gitea/workflows/` or `.github/workflows/`:

```yaml
name: CI Pipeline
on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run tests
        run: npm test
```

### Integration with Chain Stack

**Trigger n8n Workflow**:
```yaml
- name: Trigger n8n Deployment
  run: |
    curl -X POST \
      "${{ secrets.N8N_WEBHOOK_URL }}/deploy" \
      -H "Content-Type: application/json" \
      -d '{
        "repository": "${{ github.repository }}",
        "commit": "${{ github.sha }}"
      }'
```

**Execute Semaphore Task**:
```yaml
- name: Deploy Infrastructure
  run: |
    # Login to Semaphore
    TOKEN=$(curl -X POST "${{ secrets.SEMAPHORE_URL }}/api/auth/login" \
      -d '{"auth":"${{ secrets.SEMAPHORE_USER }}","password":"${{ secrets.SEMAPHORE_PASSWORD }}"}' \
      | jq -r '.token')
    
    # Trigger deployment
    curl -X POST "${{ secrets.SEMAPHORE_URL }}/api/project/1/tasks" \
      -H "Authorization: Bearer $TOKEN" \
      -d '{"template_id": 1}'
```

**Send Gotify Notification**:
```yaml
- name: Notify Success
  run: |
    curl -X POST \
      "${{ secrets.GOTIFY_URL }}/message" \
      -H "X-Gotify-Key: ${{ secrets.GOTIFY_TOKEN }}" \
      -F "title=Build Success" \
      -F "message=Repository: ${{ github.repository }}" \
      -F "priority=5"
```

### Workflow Examples

Pre-configured workflows in `code/.gitea/workflows/`:

1. **ci-cd.yaml**: Build, test, and deploy pipeline
2. **deploy-infrastructure.yaml**: Ansible deployment via Semaphore

## Git Operations

### HTTPS Clone
```bash
git clone https://code.pivoine.art/username/repo.git
```

### SSH Clone
```bash
git clone ssh://git@code.pivoine.art:2222/username/repo.git
```

### SSH Key Setup
```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "your_email@example.com"

# Add to Gitea: Settings → SSH/GPG Keys
```

## Webhook Configuration

### To n8n
```
Webhook URL: https://chain.pivoine.art/webhook/gitea
Content Type: application/json
Events: Push, Pull Request, Issue
```

### To External Services
```
Settings → Webhooks → Add Webhook
URL: https://external-service.com/webhook
Secret: your_webhook_secret
```

## Database Management

### Backup
```bash
# Backup Gitea database
./kompose.sh db backup -d gitea --compress

# Backups stored in: ./backups/database/
```

### Restore
```bash
./kompose.sh db restore -f backups/database/gitea_20250112.sql.gz -d gitea
```

### Shell Access
```bash
./kompose.sh db shell -d gitea
```

## Monitoring & Metrics

### Prometheus Metrics
Gitea exports metrics at:
```
http://code_gitea:3000/metrics?token=GITEA_METRICS_TOKEN
```

**Available Metrics**:
- Active repositories
- User count
- API request rate
- Database connections
- Queue lengths

### Health Check
```bash
curl https://code.pivoine.art/api/healthz
```

### Logs
```bash
# All code stack logs
./kompose.sh logs code -f

# Gitea only
docker logs code_gitea -f

# Actions runner
docker logs code_gitea_runner -f
```

## OAuth2 Provider

Gitea can act as OAuth2 provider for other applications:

1. **Create OAuth2 Application**:
   - Settings → Applications → Manage OAuth2 Applications
2. **Get Credentials**:
   - Client ID
   - Client Secret
3. **Configure External App**:
   ```
   Authorization URL: https://code.pivoine.art/login/oauth/authorize
   Token URL: https://code.pivoine.art/login/oauth/access_token
   User API: https://code.pivoine.art/api/v1/user
   ```

## Package Registry

### Container Registry

**Enable in Gitea**:
```ini
[packages]
ENABLED = true
```

**Docker Push**:
```bash
docker login code.pivoine.art
docker tag myimage code.pivoine.art/username/myimage:latest
docker push code.pivoine.art/username/myimage:latest
```

### NPM Registry
```bash
npm config set registry https://code.pivoine.art/api/packages/username/npm/
npm publish
```

## Troubleshooting

**Actions not running**:
```bash
# Check runner status
docker logs code_gitea_runner -f

# Verify runner token
docker exec code_gitea_runner env | grep TOKEN

# Re-register runner
./kompose.sh restart code
```

**Database connection errors**:
```bash
# Check core stack
./kompose.sh status core

# Test database
./kompose.sh db status

# View Gitea logs
docker logs code_gitea -f
```

**Email not sending**:
```bash
# Check messaging stack
./kompose.sh status messaging

# View caught emails
https://mail.pivoine.art

# For production, update SMTP in code/.env
```

**SSH connection refused**:
```bash
# Check SSH port
netstat -tulpn | grep 2222

# Test connection
ssh -T git@code.pivoine.art -p 2222
```

## Advanced Configuration

### Custom Themes
```yaml
# Add to compose.yaml
volumes:
  - ./themes/custom:/data/gitea/public/css/theme-custom.css
```

### LFS Support
```ini
[lfs]
STORAGE_TYPE = local
PATH = /data/git/lfs
```

### Federation
```ini
[federation]
ENABLED = true
SHARE_USER_STATISTICS = true
```

## Security Best Practices

1. **SSH Keys Only**: Disable password auth for Git operations
2. **2FA**: Enable two-factor authentication
3. **Secrets Management**: Use Gitea Actions secrets, never commit
4. **Webhook Secrets**: Always set webhook secrets
5. **Regular Backups**: Automated daily backups
6. **Update Policy**: Keep Gitea updated monthly

## Performance Tuning

### For Large Repositories
```ini
[repository]
MAXIMUM_CREATION_LIMIT = 100
DISABLE_STARS = false

[indexer]
ISSUE_INDEXER_TYPE = elasticsearch
```

### Redis Optimization
```ini
[cache]
ADAPTER = redis
INTERVAL = 60
```

## Integration Patterns

### Full DevOps Pipeline
```
Developer Push
    ↓
Gitea Repository
    ↓
Gitea Actions (Test & Build)
    ↓
n8n Workflow (Orchestration)
    ↓
Semaphore/Ansible (Deploy)
    ↓
Gotify Notification (Success/Failure)
```

### Auto-Documentation
```
Git Push to docs/
    ↓
Webhook to n8n
    ↓
Build Documentation
    ↓
Deploy to _docs stack
    ↓
Notify via Gotify
```

## Quick Commands

```bash
# Start stack
./kompose.sh up code

# Stop stack
./kompose.sh down code

# Restart
./kompose.sh restart code

# Logs
./kompose.sh logs code -f

# Status
./kompose.sh status code

# Database backup
./kompose.sh db backup -d gitea --compress
```

## See Also

- :icon{name="lucide:book-open"} **Stack README**: `code/README.md`
- :icon{name="lucide:link"} **Chain Stack**: Integration with n8n & Semaphore
- :icon{name="lucide:mail"} **Messaging Stack**: Email & notifications
- :icon{name="lucide:database"} **Core Stack**: PostgreSQL & Redis
- :icon{name="lucide:shield"} **Auth Stack**: SSO integration (optional)

## Resources

- [Gitea Documentation](https://docs.gitea.io/)
- [Gitea Actions](https://docs.gitea.io/en-us/usage/actions/overview/)
- [Act Runner](https://gitea.com/gitea/act_runner)

---

*"Code is poetry written in logic"* :icon{name="lucide:git-branch"}:icon{name="lucide:sparkles"}
