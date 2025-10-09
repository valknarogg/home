---
title: Code - Private GitHub Alternative
description: "Give them Git, make them great!"
navigation:
  icon: i-lucide-git-branch
---

> *"Give them Git, make them great!"* - Some wise developer

## What's This All About?

This stack is your personal GitHub - a lightweight, powerful, self-hosted Git service that gives you complete control over your repositories. Gitea is like having GitHub's best features without the Microsoft strings attached!

## The Star of the Show

### :icon{name="lucide:git-branch"} Gitea

**Container**: `code_app`  
**Image**: `gitea/gitea:latest`  
**Home**: https://git.localhost  
**SSH**: ssh://git@git.localhost:2222

Gitea packs a serious punch for its size:
- :icon{name="lucide:package"} **Git Hosting**: Unlimited private/public repositories
- :icon{name="lucide:shuffle"} **Pull Requests**: Full code review workflow
- :icon{name="lucide:bug"} **Issue Tracking**: Built-in project management
- :icon{name="lucide:users"} **Organizations & Teams**: Multi-user collaboration
- :icon{name="lucide:git-branch"} **Webhooks**: CI/CD integration ready
- :icon{name="lucide:file-text"} **Wiki**: Documentation for your projects
- :icon{name="lucide:tag"} **Releases**: Package and distribute your software
- :icon{name="lucide:lock-keyhole"} **Built-in OAuth**: Use it as an auth provider!

## Configuration Breakdown

### Database Connection
All your Git magic is stored in PostgreSQL:
```
Database: gitea
Host: Shared data stack (postgres)
Connection: Via kompose network
```

### SSH Access
Clone and push repos via SSH on a custom port (2222) to avoid conflicts with the host's SSH:
```bash
# Clone example
git clone ssh://git@git.localhost:2222/username/repo.git

# Add remote
git remote add origin ssh://git@git.localhost:2222/username/repo.git
```

### First-Time Setup
On first access, you'll see the installation wizard. Most settings are pre-configured from environment variables!

## Environment Variables Explained

| Variable | What It Does | Cool Factor |
|----------|-------------|-------------|
| `COMPOSE_PROJECT_NAME` | Stack identifier | :icon{name="lucide:package"} Keeps things organized |
| `DOCKER_IMAGE` | Gitea version to use | :icon{name="lucide:tag"} Stay current or pinned |
| `TRAEFIK_HOST` | Your domain | :icon{name="lucide:globe"} How the world finds you |
| `SSH_PORT` | SSH clone port | :icon{name="lucide:plug"} Non-standard for safety |
| `APP_PORT` | Web interface port | :icon{name="lucide:target"} Internal routing |
| `DB_*` | Database connection | :icon{name="simple-icons:postgresql"} Where memories live |

## Ports & Networking

- **Web Port**: 3000 (internal) → 443 (via Traefik)
- **SSH Port**: 2222 (exposed)
- **External Access**: 
  - Web: https://git.localhost
  - SSH: git@git.localhost:2222
- **Network**: `kompose` (the usual gang)

## Health & Monitoring

Gitea has built-in health checks:
```bash
# Check if Gitea is healthy
docker exec code_app gitea admin check

# View logs
docker logs code_app -f
```

## Getting Started

### Initial Configuration (First Run)

1. **Start the stack**:
   ```bash
   docker compose up -d
   ```

2. **Access the installer**:
   ```
   URL: https://git.localhost
   ```

3. **Database Settings** (pre-filled!):
   - Type: PostgreSQL
   - Host: postgres:5432
   - Database: gitea
   - Username: From root .env
   - Password: From root .env

4. **General Settings**:
   - Site Title: "My Git Server" (or whatever you like!)
   - SSH Server Port: 2222
   - Base URL: https://git.localhost
   - Email Settings: Inherited from root .env

5. **Create Admin Account**:
   - Username: admin (or your preference)
   - Email: your@email.com
   - Password: Strong and unique!

6. **Install!** :icon{name="lucide:party-popper"}

### Creating Your First Repository

1. **Sign in** with your admin account
2. **Click the +** icon in the top right
3. **Select "New Repository"**
4. **Fill in**:
   - Name: my-awesome-project
   - Description: What makes it awesome
   - Visibility: Private or Public
   - Initialize: ✅ Add README, .gitignore, License
5. **Create Repository!**

### Clone & Push

```bash
# Clone your new repo
git clone ssh://git@git.localhost:2222/username/my-awesome-project.git
cd my-awesome-project

# Make some changes
echo "# My Awesome Project" >> README.md
git add README.md
git commit -m "Update README"

# Push changes
git push origin main
```

## Common Tasks

### Add SSH Key

1. **Generate key** (if you don't have one):
   ```bash
   ssh-keygen -t ed25519 -C "your@email.com"
   ```

2. **Copy public key**:
   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```

3. **In Gitea**: Settings → SSH / GPG Keys → Add Key

### Create an Organization

1. **Click +** → New Organization
2. **Set name and visibility**
3. **Invite team members**
4. **Create team-owned repositories**

### Set Up Webhooks

1. **Go to** Repository → Settings → Webhooks
2. **Add Webhook** (Discord, Slack, or custom URL)
3. **Configure** events to trigger (push, pull request, etc.)
4. **Test** the webhook

### Enable Actions (CI/CD)

Gitea supports GitHub Actions-compatible workflows!

1. **Enable in** Admin → Site Administration → Actions
2. **Add `.gitea/workflows/`** to your repo
3. **Create** workflow YAML files
4. **Push** and watch them run!

## Integration Tips

### As OAuth Provider

Gitea can authenticate users for other apps:

1. **Create OAuth App**: Settings → Applications → Manage OAuth2 Applications
2. **Get credentials**: Client ID and Secret
3. **Configure** in your app with these endpoints:
   - Authorization: `https://git.localhost/login/oauth/authorize`
   - Token: `https://git.localhost/login/oauth/access_token`
   - User Info: `https://git.localhost/api/v1/user`

### With CI/CD (Semaphore, Jenkins, etc.)

Use webhooks to trigger builds on push:
```json
{
  "url": "https://your-ci-server.com/webhook",
  "content_type": "json",
  "secret": "your-webhook-secret",
  "events": ["push", "pull_request"]
}
```

### Mirror External Repos

Keep a local copy of GitHub/GitLab repos:
1. **Create new migration**
2. **Enter source** URL
3. **Enable periodic sync**

## Troubleshooting

**Q: Can't clone via SSH?**  
A: Verify SSH key is added, and use correct port (2222):
```bash
git clone ssh://git@git.localhost:2222/username/repo.git
```

**Q: Database connection failed?**  
A: Check the `data` stack is running:
```bash
docker ps | grep data_postgres
```

**Q: Can't push due to size?**  
A: Increase `client_max_body_size` in compose.yaml

**Q: Forgot admin password?**  
A: Reset from CLI:
```bash
docker exec code_app gitea admin user change-password --username admin --password newpassword
```

## Security Notes :icon{name="lucide:lock"}

- :icon{name="lucide:key"} **SSH Keys**: Always use SSH keys, not passwords
- :icon{name="lucide:lock-keyhole"} **Database Credentials**: Stored in root `.env`
- :icon{name="lucide:globe"} **HTTPS Only**: Traefik handles SSL automatically
- :icon{name="lucide:users"} **Private Repos**: Default for security
- :icon{name="lucide:lock"} **2FA**: Enable in user settings for extra security
- :icon{name="lucide:file-text"} **Audit Log**: Review in admin panel regularly

## Pro Tips :icon{name="lucide:lightbulb"}

1. **Protected Branches**: Require reviews before merging to main
2. **Git LFS**: Enable for large files (models, assets, etc.)
3. **Repository Templates**: Create templates for consistent project structure
4. **Labels & Milestones**: Organize issues effectively
5. **Project Boards**: Kanban-style project management
6. **Branch Rules**: Enforce naming conventions and workflows
7. **Custom .gitignore**: Add templates for common languages
8. **Release Tags**: Use semver for version management

## Resources

- [Gitea Documentation](https://docs.gitea.io/)
- [Gitea API Reference](https://docs.gitea.io/en-us/api-usage/)
- [Community Forums](https://discourse.gitea.io/)
- [Gitea on GitHub](https://github.com/go-gitea/gitea)

---

*"Why use someone else's Git when you can host your own? Take back control, one commit at a time."* :icon{name="lucide:git-branch"}:icon{name="lucide:sparkles"}
