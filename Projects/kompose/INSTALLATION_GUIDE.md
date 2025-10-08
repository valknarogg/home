# 🎉 Installation Guide - 4 New Kompose Stacks

Complete step-by-step guide to install and configure the new stacks.

## 📋 Prerequisites

Before starting, ensure you have:

- ✅ Kompose base infrastructure running:
  - `data` stack (PostgreSQL + Redis)
  - `proxy` stack (Traefik)
  - `kompose` Docker network created
  
- ✅ Root `.env` file configured with:
  - Database credentials (`DB_USER`, `DB_PASSWORD`, `DB_HOST`)
  - Email settings (optional but recommended)
  - Admin email

- ✅ Sufficient resources:
  - CPU: 4+ cores
  - RAM: 8+ GB
  - Disk: 50+ GB free

## 🚀 Step-by-Step Installation

### Step 1: Make Scripts Executable

```bash
cd /home/valknar/Projects/kompose

# Make all scripts executable
chmod +x setup-new-stacks.sh
chmod +x add-readmes.sh
chmod +x make-executable.sh
```

### Step 2: Run Main Setup Script

This creates all directories, compose files, .env files, and databases:

```bash
./setup-new-stacks.sh
```

**What this does:**
- Creates `home/`, `chain/`, `git/`, `link/` directories
- Generates all `compose.yaml` files
- Creates `.env` files with generated secrets
- Creates PostgreSQL databases (n8n, gitea, linkwarden)
- Displays generated secrets for your records

**Expected output:**
```
========================================
  Kompose New Stacks Setup
========================================

Generating secrets...
✓ Secrets generated

Creating home stack...
✓ Home stack created

Creating chain stack...
✓ Chain stack created

Creating git stack...
✓ Git stack created

Creating link stack...
✓ Link stack created

...
```

### Step 3: Add README Files

```bash
./add-readmes.sh
```

This creates README placeholders in each stack directory.

**Note:** The complete, detailed READMEs (300-400 lines each) are available as artifacts in the Claude conversation. Copy them manually for full documentation.

### Step 4: Review Configuration

Check and customize the `.env` files:

```bash
# Review each stack's configuration
cat home/.env
cat chain/.env
cat git/.env
cat link/.env
```

**Important settings to review:**
- `TRAEFIK_HOST` - Change from `*.localhost` to your actual domain
- `TZ` - Verify timezone is correct
- Email settings are inherited from root `.env`

### Step 5: Start the Stacks

Start each stack individually:

```bash
# Start Home Assistant
cd home
docker compose up -d
cd ..

# Start n8n
cd chain
docker compose up -d
cd ..

# Start Gitea
cd git
docker compose up -d
cd ..

# Start Linkwarden
cd link
docker compose up -d
cd ..
```

**Or start all at once:**
```bash
for stack in home chain git link; do 
  cd $stack && docker compose up -d && cd ..; 
done
```

### Step 6: Verify Installation

Check that all containers are running:

```bash
docker ps | grep -E "home|chain|git|link"
```

**Expected output:**
```
CONTAINER ID   IMAGE                              STATUS
abc123def456   ghcr.io/home-assistant/...        Up (healthy)
def456abc789   n8nio/n8n:latest                  Up (healthy)
ghi789jkl012   gitea/gitea:latest                Up (healthy)
jkl012mno345   ghcr.io/linkwarden/...            Up (healthy)
```

Check logs for any errors:

```bash
docker logs home_app --tail 20
docker logs chain_app --tail 20
docker logs git_app --tail 20
docker logs link_app --tail 20
```

### Step 7: Initial Configuration

Access each service and complete setup:

#### 🏠 Home Assistant (https://home.localhost)

1. **First Visit**: Setup wizard appears
2. **Create Owner Account**:
   - Name: Your name
   - Username: Choose username
   - Password: Strong password
3. **Set Location**: For automations and weather
4. **Choose Units**: Metric or Imperial
5. **Share Analytics**: Your choice
6. **Done!** Home Assistant starts discovering devices

#### ⛓️ n8n (https://chain.localhost)

1. **Basic Auth**: Login with `admin` / `changeme`
2. **⚠️ IMMEDIATELY**: Go to Settings → Change password!
3. **Create First Workflow**: Click "New Workflow"
4. **Explore Templates**: Browse 1000+ pre-built workflows

#### 🦊 Gitea (https://git.localhost)

1. **First Visit**: Setup wizard appears
2. **Database Settings**: Pre-filled from environment
3. **General Settings**:
   - Site Title: "My Git Server"
   - SSH Port: 2222
   - Base URL: https://git.localhost
4. **Create Administrator Account**:
   - Username: admin
   - Password: Strong password
   - Email: your@email.com
5. **Install Gitea**

#### 🔗 Linkwarden (https://link.localhost)

1. **First Visit**: Sign Up page
2. **Create Account**:
   - Name: Your name
   - Email: your@email.com
   - Username: Choose username
   - Password: Strong password
3. **Done!** Start saving bookmarks

### Step 8: Update Dashboard

The dashboard has been automatically updated! Restart it:

```bash
cd dash
docker compose restart
```

Visit your dashboard to see the new stacks: https://dash.localhost

## 🔐 Security Checklist

After installation, ensure:

- [ ] Changed all default passwords
- [ ] Reviewed generated secrets (saved in `.env` files)
- [ ] Disabled public registration on Linkwarden (already done)
- [ ] Changed n8n basic auth password
- [ ] Set up Gitea SSH keys
- [ ] Configured Home Assistant 2FA
- [ ] Reviewed Traefik SSL certificates
- [ ] Set up regular backups

## 🔧 Post-Installation Tasks

### Set Up Backups

Create a backup script:

```bash
#!/bin/bash
BACKUP_DIR="/backups/kompose-$(date +%Y%m%d)"
mkdir -p $BACKUP_DIR

# Databases
docker exec data_postgres pg_dump -U $DB_USER n8n > $BACKUP_DIR/n8n.sql
docker exec data_postgres pg_dump -U $DB_USER gitea > $BACKUP_DIR/gitea.sql
docker exec data_postgres pg_dump -U $DB_USER linkwarden > $BACKUP_DIR/linkwarden.sql

# Home Assistant config
tar -czf $BACKUP_DIR/home-config.tar.gz home/config

# Git repositories
docker run --rm -v git_gitea_data:/data -v $BACKUP_DIR:/backup \
  alpine tar czf /backup/gitea-repos.tar.gz /data

# Linkwarden archives
docker run --rm -v link_linkwarden_data:/data -v $BACKUP_DIR:/backup \
  alpine tar czf /backup/linkwarden-archives.tar.gz /data

echo "Backup completed: $BACKUP_DIR"
```

### Configure Monitoring

Add health checks to your monitoring system:

```bash
# Check all services are healthy
docker ps --format "table {{.Names}}\t{{.Status}}" | grep -E "home|chain|git|link"
```

### Set Up Integrations

**n8n ↔ Gitea**: Automate deployments on git push  
**Home Assistant ↔ n8n**: Complex automations  
**Linkwarden ↔ n8n**: Auto-save RSS feeds to bookmarks

## 📊 Resource Usage

After installation, monitor resource usage:

```bash
docker stats home_app chain_app git_app link_app
```

**Typical usage:**
- Home Assistant: 200-500 MB RAM
- n8n: 200-400 MB RAM
- Gitea: 100-300 MB RAM
- Linkwarden: 200-400 MB RAM

**Total**: ~1-2 GB RAM for all 4 stacks

## 🆘 Troubleshooting

### Containers Not Starting

```bash
# Check logs
docker logs <stack>_app -f

# Common issues:
# 1. Database not accessible
docker exec data_postgres psql -U $DB_USER -l

# 2. Network not found
docker network ls | grep kompose
docker network create kompose  # if missing

# 3. Port conflicts
netstat -tulpn | grep -E "8123|5678|3000|2222"
```

### Can't Access via Browser

```bash
# 1. Check Traefik is running
docker ps | grep proxy

# 2. Check Traefik logs
docker logs proxy_app | grep -E "home|chain|git|link"

# 3. Test direct access (bypass Traefik)
curl http://localhost:8123  # Home Assistant
curl http://localhost:5678  # n8n
curl http://localhost:3000  # Gitea
```

### Database Connection Failed

```bash
# 1. Verify database exists
docker exec data_postgres psql -U $DB_USER -l | grep -E "n8n|gitea|linkwarden"

# 2. Test connection from container
docker exec chain_app ping postgres
docker exec git_app ping postgres
docker exec link_app ping postgres

# 3. Check credentials in .env match root .env
cat .env | grep DB_
cat chain/.env | grep DB_
```

### Secrets Not Working

```bash
# Regenerate secrets
openssl rand -hex 32    # For n8n
openssl rand -base64 32 # For Linkwarden

# Update in .env files
vim chain/.env  # Update N8N_ENCRYPTION_KEY
vim link/.env   # Update NEXTAUTH_SECRET

# Restart containers
docker compose restart
```

## 📚 Next Steps

Now that everything is installed:

1. **Explore Each Service**:
   - Add your first smart home device in Home Assistant
   - Create your first automation in n8n
   - Create your first repository in Gitea
   - Save your first bookmark in Linkwarden

2. **Integrate Services**:
   - Connect n8n to Gitea for CI/CD
   - Link Home Assistant with n8n for complex automations
   - Use Linkwarden to bookmark your documentation

3. **Customize**:
   - Change themes and layouts
   - Set up custom domains
   - Configure external access

4. **Share**:
   - Invite team members
   - Share collections
   - Collaborate on repos

## 🎓 Learning Resources

- **Home Assistant**: https://www.home-assistant.io/docs/
- **n8n**: https://docs.n8n.io/
- **Gitea**: https://docs.gitea.io/
- **Linkwarden**: https://docs.linkwarden.app/

## 🎉 Congratulations!

You now have 4 powerful self-hosted services:
- 🏠 **Smart Home Control**
- ⛓️ **Workflow Automation**
- 🦊 **Git Hosting**
- 🔗 **Bookmark Management**

All running on YOUR infrastructure! 

---

**Need help?** Check the individual README files or the Quick Reference guide.

**Found a bug?** Check the logs and troubleshooting sections.

**Want more?** Explore the extensive features of each service!

Happy self-hosting! 🚀
