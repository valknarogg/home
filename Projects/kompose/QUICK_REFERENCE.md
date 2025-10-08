# 🚀 Quick Reference - New Stacks

Fast command reference for managing the 4 new kompose stacks.

## 📦 Stack Directories

```
kompose/
├── home/         # Home Assistant
├── chain/        # n8n  
├── git/          # Gitea
└── link/         # Linkwarden
```

## ⚡ Quick Commands

### Start All New Stacks
```bash
cd /home/valknar/Projects/kompose
for stack in home chain git link; do cd $stack && docker compose up -d && cd ..; done
```

### Stop All New Stacks  
```bash
for stack in home chain git link; do cd $stack && docker compose down && cd ..; done
```

### View All Logs
```bash
docker logs -f home_app &
docker logs -f chain_app &
docker logs -f git_app &
docker logs -f link_app
```

### Check Status
```bash
docker ps | grep -E "home|chain|git|link"
```

## 🔑 Default Access

| Stack | URL | Port | Notes |
|-------|-----|------|-------|
| Home Assistant | https://home.localhost | 8123 | Setup wizard on first start |
| n8n | https://chain.localhost | 5678 | Basic auth: admin/changeme |
| Gitea | https://git.localhost | 3000 | Setup wizard, SSH: 2222 |
| Linkwarden | https://link.localhost | 3000 | Create account on first visit |

## 🗄️ Database Commands

### Create Databases
```bash
docker exec data_postgres createdb -U $DB_USER n8n
docker exec data_postgres createdb -U $DB_USER gitea  
docker exec data_postgres createdb -U $DB_USER linkwarden
```

### Backup Databases
```bash
docker exec data_postgres pg_dump -U $DB_USER n8n > backups/n8n-$(date +%Y%m%d).sql
docker exec data_postgres pg_dump -U $DB_USER gitea > backups/gitea-$(date +%Y%m%d).sql
docker exec data_postgres pg_dump -U $DB_USER linkwarden > backups/linkwarden-$(date +%Y%m%d).sql
```

## 🔐 Generate Secrets

```bash
# For n8n
openssl rand -hex 32

# For Linkwarden
openssl rand -base64 32

# For Gitea SSH
ssh-keygen -t ed25519 -C "your_email@example.com"
```

## 📊 Monitoring

### Resource Usage
```bash
docker stats home_app chain_app git_app link_app
```

### Logs (last 50 lines)
```bash
docker logs --tail 50 home_app
docker logs --tail 50 chain_app
docker logs --tail 50 git_app
docker logs --tail 50 link_app
```

### Health Check
```bash
docker inspect home_app | jq '.[].State.Health'
docker inspect chain_app | jq '.[].State.Health'
docker inspect git_app | jq '.[].State.Health'
docker inspect link_app | jq '.[].State.Health'
```

## 🔧 Maintenance

### Update Stack
```bash
cd <stack> && docker compose pull && docker compose up -d
```

### Restart Stack
```bash
cd <stack> && docker compose restart
```

### Full Backup
```bash
# Databases
docker exec data_postgres pg_dump -U $DB_USER n8n > backups/n8n.sql
docker exec data_postgres pg_dump -U $DB_USER gitea > backups/gitea.sql
docker exec data_postgres pg_dump -U $DB_USER linkwarden > backups/linkwarden.sql

# Home Assistant config
tar -czf backups/home-config.tar.gz home/config

# Git repos (from volume)
docker run --rm -v git_gitea_data:/data -v $(pwd)/backups:/backup \
  alpine tar czf /backup/gitea-repos.tar.gz /data

# Linkwarden archives
docker run --rm -v link_linkwarden_data:/data -v $(pwd)/backups:/backup \
  alpine tar czf /backup/linkwarden-archives.tar.gz /data
```

## 🏷️ Stack-Specific Commands

### Home Assistant
```bash
# Check config
docker exec home_app hass --script check_config

# Restart core
docker exec home_app hass restart
```

### n8n
```bash
# Export workflows
docker exec chain_app n8n export:workflow --backup --output=/backup/

# List workflows
docker exec chain_app n8n list:workflow
```

### Gitea
```bash
# Create admin user
docker exec git_app gitea admin user create \
  --username admin --password secretpass \
  --email admin@example.com --admin

# List users
docker exec git_app gitea admin user list
```

### Linkwarden
```bash
# Run migrations
docker exec link_app npx prisma migrate deploy

# Open Prisma Studio
docker exec link_app npx prisma studio
```

## 🚨 Troubleshooting

### Container Won't Start
```bash
# Check logs
docker logs <stack>_app --tail 100

# Check network
docker network inspect kompose

# Verify database
docker exec data_postgres psql -U $DB_USER -l
```

### Can't Access via Browser
```bash
# Check Traefik
docker logs proxy_app | grep <stack>

# Verify routing
docker exec proxy_app traefik healthcheck
```

### Database Issues
```bash
# Test connection from container
docker exec <stack>_app ping postgres

# Check database exists
docker exec data_postgres psql -U $DB_USER -l | grep <dbname>
```

## 🔄 Update All Stacks
```bash
#!/bin/bash
for stack in home chain git link; do
  echo "Updating $stack..."
  cd $stack
  docker compose pull
  docker compose up -d
  cd ..
done
```

## 🧹 Cleanup Commands

### Remove Unused Images
```bash
docker image prune -a
```

### Remove Unused Volumes (⚠️ BE CAREFUL)
```bash
docker volume prune
```

### Clean Everything (⚠️ NUCLEAR OPTION)
```bash
docker system prune -a --volumes
```

## 📱 Mobile Setup

### Home Assistant App
1. Install from App Store/Play Store
2. Server URL: https://home.localhost
3. Login with credentials

### n8n (PWA)
1. Open in mobile browser
2. Menu → "Add to Home Screen"

### Gitea
Use Git client apps:
- iOS: Working Copy
- Android: MGit

### Linkwarden (PWA)
1. Open in mobile browser  
2. Menu → "Add to Home Screen"

---

**💡 Pro Tip**: Add these commands to your shell aliases for even faster access!

```bash
# Add to ~/.bashrc or ~/.zshrc
alias kompose-start='cd /home/valknar/Projects/kompose && for s in home chain git link; do cd $s && docker compose up -d && cd ..; done'
alias kompose-stop='cd /home/valknar/Projects/kompose && for s in home chain git link; do cd $s && docker compose down && cd ..; done'
alias kompose-logs='docker logs -f home_app &; docker logs -f chain_app &; docker logs -f git_app &; docker logs -f link_app'
alias kompose-status='docker ps | grep -E "home|chain|git|link"'
```
