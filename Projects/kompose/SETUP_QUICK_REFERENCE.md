# Kompose Setup Commands - Quick Reference

## First Time Setup

```bash
# Clone repository
git clone https://code.pivoine.art/valknar/kompose.git
cd kompose

# Run interactive initialization
./kompose.sh init

# Follow wizard prompts:
# 1. Dependency check
# 2. Choose environment (local/prod/both)
# 3. Automatic configuration
# 4. Start using!
```

## Setup Commands

### Initialize/Re-initialize Project
```bash
./kompose.sh init
```
✓ Checks dependencies (Docker, Git, Node.js, pnpm, Python 3)  
✓ Interactive environment setup  
✓ Installs project dependencies  
✓ Creates Docker network  
✓ Ready to use!

### Switch to Local Development
```bash
./kompose.sh setup local
```
✓ Backs up current config  
✓ Activates localhost mode  
✓ No domain needed  
✓ Direct port access

### Switch to Production
```bash
./kompose.sh setup prod
```
✓ Backs up current config  
✓ Activates domain mode  
✓ Enables Traefik + SSL  
✓ Production ready

### Show Current Mode
```bash
./kompose.sh setup status
```
Shows:
- Current environment (local/production)
- Service URLs
- Quick start commands

### Backup Configuration
```bash
./kompose.sh setup backup
```
Creates timestamped backup:
`backups/config_backup_YYYYMMDD_HHMMSS/`

### Save as Production Default
```bash
./kompose.sh setup save-prod
```
Saves current config as `.env.production` and `domain.env.production`

## Utility Commands

### Validate Everything
```bash
./kompose.sh validate
```
Checks:
- Configuration files exist
- Domain settings valid
- Docker network exists
- All compose files valid
- Security settings

### Clean Up Project
```bash
./kompose.sh cleanup
```
Removes:
- .bak files
- .new files
- Old duplicates

### Show Version
```bash
./kompose.sh version
```
Displays Kompose version and components

## Stack Management

### Start Stacks
```bash
./kompose.sh up core           # Core services
./kompose.sh up auth           # Authentication
./kompose.sh up kmps           # Management portal
./kompose.sh up                # All stacks
```

### Stop Stacks
```bash
./kompose.sh down core         