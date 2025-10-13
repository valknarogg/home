---
title: CLI Reference
description: Complete command-line interface reference for all Kompose commands
---

Complete reference for all Kompose CLI commands, options, and examples.

## Synopsis

```bash
./kompose.sh [COMMAND] [OPTIONS] [ARGS...]
```

## Global Options

| Option | Description |
|--------|-------------|
| `-h, --help` | Show help message and exit |
| `-d, --detach` | Run in detached mode (for up command) |
| `-f, --force` | Force operation (remove volumes, force tag operations) |
| `--no-cache` | Build without cache |
| `--scale SERVICE=N` | Scale service to N replicas |
| `-v, --verbose` | Verbose output |

## Setup & Initialization Commands

### init

Interactive project initialization wizard.

**Syntax:**
```bash
./kompose.sh init
```

**What it does:**
1. Checks system dependencies (Docker, Git, Node.js, pnpm, Python 3)
2. Guides you to choose local development, production, or both
3. Creates and configures environment files (.env, domain.env, secrets.env)
4. Installs project dependencies (_docs and kmps using pnpm)
5. Creates Docker network
6. Sets up directory structure

**Examples:**
```bash
# First time setup
./kompose.sh init

# Re-initialize after updates
./kompose.sh init
```

**Output:**
```
═══════════════════════════════════════════════════════════
       Kompose Project Initialization
═══════════════════════════════════════════════════════════

Step 1: Checking system dependencies
✓ Docker: 24.0.6
✓ Docker Compose: 2.23.0
✓ Git: 2.42.0
✓ Node.js: 20.10.0
✓ pnpm: 8.15.0
✓ Python 3: 3.11.6

Step 2: Choose your environment
  1) Local Development (recommended)
  2) Production
  3) Both

Choose (1/2/3) [1]:
```

### setup

Manage local and production configurations.

**Syntax:**
```bash
./kompose.sh setup <command>
```

**Commands:**
- `local` - Switch to local development mode
- `prod` - Switch to production mode
- `status` - Show current configuration mode
- `save-prod` - Save current config as production default
- `backup` - Backup current configuration

#### setup local

Switch to local development mode.

**Syntax:**
```bash
./kompose.sh setup local
```

**What it does:**
1. Backs up current configuration
2. Activates `.env.local` and `domain.env.local`
3. Configures services for localhost access
4. Disables Traefik (direct port access)

**Examples:**
```bash
# Switch to local development
./kompose.sh setup local

# Check it worked
./kompose.sh setup status
```

#### setup prod

Switch to production mode.

**Syntax:**
```bash
./kompose.sh setup prod
```

**What it does:**
1. Backs up current configuration
2. Activates `.env.production` and `domain.env.production`
3. Configures services for domain-based access
4. Enables Traefik with SSL

**Examples:**
```bash
# Switch to production
./kompose.sh setup prod

# Verify configuration
./kompose.sh setup status
./kompose.sh validate
```

#### setup status

Show current configuration mode.

**Syntax:**
```bash
./kompose.sh setup status
```

**Output (local mode):**
```
═══════════════════════════════════════
      Configuration Status
═══════════════════════════════════════

✓ Current Mode: LOCAL DEVELOPMENT

Local Development Services:
  Core Services:
    PostgreSQL:      localhost:5432
    Redis:           localhost:6379
    MQTT:            localhost:1883

  Main Applications:
    Keycloak:        http://localhost:8180
    KMPS:            http://localhost:3100
    Gitea:           http://localhost:3001
    n8n:             http://localhost:5678
```

**Output (production mode):**
```
✓ Current Mode: PRODUCTION

Production Services (example.com):
  Main Applications:
    Keycloak:        https://auth.example.com
    KMPS:            https://manage.example.com
    Gitea:           https://code.example.com
    n8n:             https://chain.example.com
```

#### setup save-prod

Save current configuration as production default.

**Syntax:**
```bash
./kompose.sh setup save-prod
```

**What it does:**
- Copies `.env` to `.env.production`
- Copies `domain.env` to `domain.env.production`

**Examples:**
```bash
# After manually configuring production settings
./kompose.sh setup save-prod

# Now you can switch back and forth
./kompose.sh setup local
./kompose.sh setup prod
```

#### setup backup

Create backup of current configuration.

**Syntax:**
```bash
./kompose.sh setup backup
```

**What it does:**
Creates timestamped backup in `backups/config_backup_YYYYMMDD_HHMMSS/` containing:
- `.env`
- `domain.env`
- `secrets.env`

**Examples:**
```bash
# Before making changes
./kompose.sh setup backup

# List backups
ls backups/config_backup_*/

# Restore if needed
cp backups/config_backup_20250115_103000/.env .env
```

## Stack Management Commands

### up

Start one or all stacks.

**Syntax:**
```bash
./kompose.sh up [STACK] [-d|--detach]
```

**Examples:**
```bash
# Start all stacks
./kompose.sh up

# Start specific stack
./kompose.sh up core

# Start in detached mode
./kompose.sh up home -d
```

### down

Stop one or all stacks.

**Syntax:**
```bash
./kompose.sh down [STACK] [-f|--force]
```

**Examples:**
```bash
# Stop all stacks
./kompose.sh down

# Stop specific stack
./kompose.sh down auth

# Stop and remove volumes
./kompose.sh down core -f
```

### restart

Restart one or all stacks.

**Syntax:**
```bash
./kompose.sh restart [STACK]
```

**Examples:**
```bash
# Restart all stacks
./kompose.sh restart

# Restart specific stack
./kompose.sh restart chain
```

### status

Show status of one or all stacks.

**Syntax:**
```bash
./kompose.sh status [STACK]
```

**Examples:**
```bash
# Show all stack statuses
./kompose.sh status

# Show specific stack status
./kompose.sh status home
```

### logs

Show logs for a stack.

**Syntax:**
```bash
./kompose.sh logs STACK [OPTIONS]
```

**Options:**
- `-f` - Follow log output
- `--tail=N` - Show last N lines
- `--since=TIME` - Show logs since timestamp

**Examples:**
```bash
# Follow logs
./kompose.sh logs chain -f

# Last 100 lines
./kompose.sh logs core --tail=100

# Logs since 10 minutes ago
./kompose.sh logs auth --since=10m
```

### pull

Pull latest images for one or all stacks.

**Syntax:**
```bash
./kompose.sh pull [STACK]
```

**Examples:**
```bash
# Pull all stacks
./kompose.sh pull

# Pull specific stack
./kompose.sh pull home
```

### build

Build images for a stack.

**Syntax:**
```bash
./kompose.sh build STACK [--no-cache]
```

**Examples:**
```bash
# Build with cache
./kompose.sh build frontend

# Build without cache
./kompose.sh build backend --no-cache
```

### deploy

Deploy a stack with specific version.

**Syntax:**
```bash
./kompose.sh deploy STACK VERSION
```

**Examples:**
```bash
# Deploy version 1.2.3
./kompose.sh deploy api 1.2.3

# Deploy version 2.0.0
./kompose.sh deploy frontend 2.0.0
```

### list

List all available stacks.

**Syntax:**
```bash
./kompose.sh list
```

**Output:**
```
Available stacks:

  core        - Core services - MQTT, Redis, Postgres
  auth        - Authentication - Keycloak SSO
  chain       - Automation Platform - n8n workflows
  home        - Smart Home - Home Assistant
  ...
```

### validate

Validate compose files for one or all stacks.

**Syntax:**
```bash
./kompose.sh validate [STACK]
```

**Examples:**
```bash
# Validate all stacks
./kompose.sh validate

# Validate specific stack
./kompose.sh validate core
```

### exec

Execute command in a stack container.

**Syntax:**
```bash
./kompose.sh exec STACK COMMAND [ARGS...]
```

**Examples:**
```bash
# Execute shell in postgres
./kompose.sh exec core postgres bash

# Run npm command
./kompose.sh exec frontend npm install

# Check n8n version
./kompose.sh exec chain n8n --version
```

### ps

Show all running containers.

**Syntax:**
```bash
./kompose.sh ps
```

## API Server Commands

### api start

Start the REST API server.

**Syntax:**
```bash
./kompose.sh api start [PORT] [HOST]
```

**Parameters:**
- `PORT` - Port number (default: 8080)
- `HOST` - Host to bind to (default: 127.0.0.1)

**Examples:**
```bash
# Start on default port (localhost only)
./kompose.sh api start

# Start on custom port
./kompose.sh api start 9000

# Start on all interfaces
./kompose.sh api start 8080 0.0.0.0

# Start on specific interface
./kompose.sh api start 8080 192.168.1.10
```

**Environment Variables:**
- `API_PORT` - Default port (default: 8080)
- `API_HOST` - Default host (default: 127.0.0.1)
- `API_PIDFILE` - PID file location
- `API_LOGFILE` - Log file location

### api stop

Stop the running API server.

**Syntax:**
```bash
./kompose.sh api stop
```

### api status

Check API server status and view recent logs.

**Syntax:**
```bash
./kompose.sh api status
```

**Output:**
```
[SUCCESS] API server is running (PID: 12345)
Server URL: http://127.0.0.1:8080

Recent log entries:
  [2025-01-15 10:30:00] [STARTUP] Kompose API Server starting...
  [2025-01-15 10:30:15] GET /api/health - 200
  [2025-01-15 10:30:20] GET /api/stacks - 200
```

### api logs

View API server logs in real-time.

**Syntax:**
```bash
./kompose.sh api logs
```

## Database Commands

### db backup

Create database backups.

**Syntax:**
```bash
./kompose.sh db backup [OPTIONS]
```

**Options:**
- `-d, --database NAME` - Database name (default: all)
- `-f, --file FILE` - Backup file path
- `-t, --timestamp` - Add timestamp to backup
- `--compress` - Compress backup with gzip

**Examples:**
```bash
# Backup all databases
./kompose.sh db backup

# Backup specific database
./kompose.sh db backup -d kompose

# Backup with compression
./kompose.sh db backup --compress

# Backup to specific file
./kompose.sh db backup -d n8n -f my-backup.sql
```

### db restore

Restore database from backup.

**Syntax:**
```bash
./kompose.sh db restore [OPTIONS]
```

**Options:**
- `-f, --file FILE` - Backup file path (required)
- `-d, --database NAME` - Database name (auto-detected if not specified)

**Examples:**
```bash
# Restore from file (auto-detect database)
./kompose.sh db restore -f kompose_20250115-103000.sql

# Restore to specific database
./kompose.sh db restore -f backup.sql -d kompose
```

**⚠️ WARNING:** This drops and recreates the database!

### db list

List all available database backups.

**Syntax:**
```bash
./kompose.sh db list
```

**Output:**
```
Available database backups:

  📦 kompose_20250115-103000.sql - 2.5M - 2025-01-15 10:30:00
  📦 n8n_20250115-090000.sql.gz - 1.1M - 2025-01-15 09:00:00
  📦 gitea_20250114-180000.sql - 5.2M - 2025-01-14 18:00:00
```

### db status

Show database status, sizes, and connections.

**Syntax:**
```bash
./kompose.sh db status
```

**Output:**
```
Database status:

[SUCCESS] PostgreSQL container is running

Available databases:
  kompose  | postgres | UTF8 | 15 MB

Database sizes:
  kompose: 15 MB - Main application database
  n8n: 8 MB - n8n workflow database
  gitea: 12 MB - Gitea git database

Active connections:
  datname  | count
-----------+-------
  kompose  |     5
  n8n      |     2
```

### db exec

Execute SQL command on a database.

**Syntax:**
```bash
./kompose.sh db exec -d DATABASE "SQL_COMMAND"
```

**Examples:**
```bash
# Count users
./kompose.sh db exec -d kompose "SELECT COUNT(*) FROM users;"

# Check tables
./kompose.sh db exec -d n8n "\\dt"

# Vacuum database
./kompose.sh db exec -d gitea "VACUUM ANALYZE;"
```

### db shell

Open interactive PostgreSQL shell for a database.

**Syntax:**
```bash
./kompose.sh db shell [-d DATABASE]
```

**Examples:**
```bash
# Open shell for kompose database
./kompose.sh db shell -d kompose

# Default database
./kompose.sh db shell
```

**Commands in shell:**
- `\q` - Quit
- `\l` - List databases
- `\dt` - List tables
- `\d table` - Describe table

### db migrate

Run database migrations.

**Syntax:**
```bash
./kompose.sh db migrate [-d DATABASE]
```

**Examples:**
```bash
# Migrate kompose database
./kompose.sh db migrate -d kompose

# Migrate default database
./kompose.sh db migrate
```

### db reset

Reset a database (WARNING: deletes all data).

**Syntax:**
```bash
./kompose.sh db reset -d DATABASE
```

**Examples:**
```bash
# Reset kompose database
./kompose.sh db reset -d kompose
```

**⚠️ WARNING:** Creates backup before reset, but still destructive!

## Git Tag Deployment Commands

### tag create

Create a new deployment tag.

**Syntax:**
```bash
./kompose.sh tag create [OPTIONS]
```

**Options:**
- `-s, --service SERVICE` - Service name (required)
- `-e, --env ENV` - Environment: dev, staging, prod (required)
- `-v, --version VERSION` - Version number (required)
- `-c, --commit COMMIT` - Git commit hash (default: HEAD)
- `-m, --message MESSAGE` - Tag message
- `-f, --force` - Force tag creation
- `-d, --dry-run` - Show what would be done

**Examples:**
```bash
# Create deployment tag
./kompose.sh tag create -s frontend -e dev -v 1.2.3

# Create with custom message
./kompose.sh tag create -s backend -e prod -v 2.0.0 -m "Production release"

# Create at specific commit
./kompose.sh tag create -s api -e staging -v 1.5.0 -c abc123

# Dry run
./kompose.sh tag create -s frontend -e dev -v 1.0.0 -d
```

### tag deploy

Create tag and trigger deployment workflow.

**Syntax:**
```bash
./kompose.sh tag deploy [OPTIONS]
```

**Options:** Same as `tag create`

**Examples:**
```bash
# Deploy to development
./kompose.sh tag deploy -s frontend -e dev -v 1.2.3

# Deploy to production
./kompose.sh tag deploy -s api -e prod -v 2.0.0

# Deploy with message
./kompose.sh tag deploy -s backend -e staging -v 1.5.0 -m "Staging deployment"
```

### tag move

Move an existing tag to a new commit.

**Syntax:**
```bash
./kompose.sh tag move [OPTIONS]
```

**Options:**
- `-s, --service SERVICE` - Service name (required)
- `-e, --env ENV` - Environment (required)
- `-v, --version VERSION` - Version number (required)
- `-c, --commit COMMIT` - New commit hash (required)
- `-d, --dry-run` - Show what would be done

**Examples:**
```bash
# Move tag to new commit
./kompose.sh tag move -s frontend -e dev -v 1.2.3 -c def456

# Dry run
./kompose.sh tag move -s api -e staging -v 1.0.0 -c abc123 -d
```

### tag delete

Delete a deployment tag.

**Syntax:**
```bash
./kompose.sh tag delete [OPTIONS]
```

**Options:**
- `-s, --service SERVICE` - Service name (required)
- `-e, --env ENV` - Environment (required)
- `-v, --version VERSION` - Version number (required)
- `-f, --force` - Skip production confirmation
- `-d, --dry-run` - Show what would be done

**Examples:**
```bash
# Delete tag
./kompose.sh tag delete -s frontend -e dev -v 1.0.0

# Force delete production tag
./kompose.sh tag delete -s api -e prod -v 1.5.0 -f
```

### tag list

List all deployment tags.

**Syntax:**
```bash
./kompose.sh tag list [-s SERVICE]
```

**Examples:**
```bash
# List all tags
./kompose.sh tag list

# List tags for specific service
./kompose.sh tag list -s frontend
```

**Output:**
```
All deployment tags:

frontend-v1.2.3-prod
frontend-v1.2.2-staging
frontend-v1.2.1-dev
backend-v2.0.0-prod
api-v1.5.0-staging
```

### tag rollback

Rollback to a previous deployment tag.

**Syntax:**
```bash
./kompose.sh tag rollback [OPTIONS]
```

**Options:**
- `-s, --service SERVICE` - Service name (required)
- `-e, --env ENV` - Environment (required)
- `-v, --version VERSION` - Version to rollback to (required)
- `-f, --force` - Skip production confirmation

**Examples:**
```bash
# Rollback to previous version
./kompose.sh tag rollback -s api -e prod -v 1.9.5

# Force rollback production
./kompose.sh tag rollback -s frontend -e prod -v 1.0.0 -f
```

### tag status

Show deployment status for a tag.

**Syntax:**
```bash
./kompose.sh tag status SERVICE VERSION ENV
```

**Examples:**
```bash
# Check deployment status
./kompose.sh tag status frontend 1.2.3 prod

# Or with flags
./kompose.sh tag status -s backend -v 2.0.0 -e staging
```

## Utility Commands

### cleanup

Clean up backup and temporary files.

**Syntax:**
```bash
./kompose.sh cleanup
```

**What it does:**
- Removes old backup files (older than 30 days by default)
- Cleans up temporary files
- Shows summary of cleaned files

**Examples:**
```bash
# Run cleanup
./kompose.sh cleanup

# Manual cleanup with custom retention
find backups/ -name "*.sql" -mtime +30 -delete
find backups/ -name "*.sql.gz" -mtime +30 -delete
```

### validate

Validate entire project configuration.

**Syntax:**
```bash
./kompose.sh validate
```

**What it checks:**
- Required files exist (domain.env, .env, secrets.env)
- Domain configuration is valid
- Docker network exists
- All compose files are syntactically correct
- Security settings (file permissions, .gitignore)
- Environment consistency

**Examples:**
```bash
# Validate everything
./kompose.sh validate

# Validate specific stack
./kompose.sh validate core
```

**Output:**
```
[INFO] Validating Kompose configuration...

[SUCCESS] Configuration files exist
  ✓ .env found
  ✓ domain.env found
  ✓ secrets.env found

[SUCCESS] Docker network 'kompose' exists

[SUCCESS] All compose files are valid
  ✓ core/compose.yaml
  ✓ auth/compose.yaml
  ✓ kmps/compose.yaml
  ...

[SUCCESS] Security checks passed
  ✓ secrets.env is not world-readable
  ✓ secrets.env in .gitignore

[SUCCESS] All validation checks passed!
```

### version

Show Kompose version information.

**Syntax:**
```bash
./kompose.sh version
```

**Examples:**
```bash
./kompose.sh version
```

**Output:**
```
Kompose Version: 2.0.0
Modular Edition

Components:
  - kompose.sh (main CLI)
  - kompose-setup.sh (setup & initialization)
  - kompose-stack.sh (stack management)
  - kompose-db.sh (database operations)
  - kompose-tag.sh (git tag deployments)
  - kompose-api.sh (REST API management)
  - kompose-api-server.sh (REST API server)
  - kompose-utils.sh (utility functions)

Git: abc123def (main branch)
```

## Available Stacks

| Stack | Description |
|-------|-------------|
| `core` | Core services (MQTT, Redis, PostgreSQL) |
| `auth` | Authentication (Keycloak SSO, OAuth2 Proxy) |
| `kmps` | Kompose Management Portal |
| `chain` | Automation Platform (n8n, Semaphore) |
| `home` | Smart Home (Home Assistant, Matter, Zigbee) |
| `vpn` | VPN Access (WireGuard) |
| `chat` | Notifications (Gotify) |
| `vault` | Password Manager (Vaultwarden) |
| `proxy` | Reverse Proxy (Traefik) |
| `messaging` | Messaging services |
| `+custom` | Custom user stacks |
| `+utility` | System utility services |

## Available Services (for tag commands)

| Service | Description |
|---------|-------------|
| `frontend` | Frontend application |
| `backend` | Backend application |
| `api` | API service |
| `worker` | Background workers |

## Environments (for tag commands)

| Environment | Description |
|-------------|-------------|
| `dev` | Development |
| `staging` | Staging |
| `prod` | Production |

## Available Databases

| Database | Description |
|----------|-------------|
| `kompose` | Main application database |
| `n8n` | n8n workflow database |
| `semaphore` | Semaphore Ansible database |
| `gitea` | Gitea git database |

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | General error |
| 2 | Missing required arguments |
| 3 | Stack not found |
| 4 | Command failed |

## Environment Variables

### Configuration
- `STACKS_ROOT` - Root directory for stacks (default: current directory)
- `COMPOSE_FILE` - Compose file name (default: compose.yaml)
- `REPO_URL` - Git repository URL
- `GITEA_URL` - Gitea server URL
- `N8N_WEBHOOK_BASE` - n8n webhook base URL

### API Server
- `API_PORT` - API server port (default: 8080)
- `API_HOST` - API server host (default: 127.0.0.1)
- `API_PIDFILE` - PID file location
- `API_LOGFILE` - Log file location

### Database
- `POSTGRES_CONTAINER` - PostgreSQL container name
- `BACKUP_DIR` - Backup directory
- `DB_USER` - Database user
- `DB_PASS` - Database password

## Example Workflows

### Daily Operations
```bash
# Morning: Start everything
./kompose.sh up

# Check what's running
./kompose.sh ps

# View logs
./kompose.sh logs chain -f
```

### Deployment Workflow
```bash
# Create and deploy tag
./kompose.sh tag deploy -s api -e prod -v 2.0.0

# Monitor deployment
./kompose.sh logs api -f

# If issues, rollback
./kompose.sh tag rollback -s api -e prod -v 1.9.5
```

### Database Workflow
```bash
# Daily backup
./kompose.sh db backup --compress

# Before major update
./kompose.sh db backup -d kompose

# After update fails
./kompose.sh db restore -f latest-backup.sql
```

### API Server Workflow
```bash
# Start server
./kompose.sh api start

# Use API
curl http://localhost:8080/api/stacks | jq .
curl -X POST http://localhost:8080/api/stacks/home/restart

# Check logs
./kompose.sh api logs

# Stop server
./kompose.sh api stop
```

## See Also

- [Quick Start Guide](/guide/quick-start) - Get started quickly
- [Stack Management](/guide/stack-management) - Detailed stack operations
- [API Server Guide](/guide/api-server) - REST API documentation
- [Database Guide](/guide/database) - Database management
- [Environment Reference](/reference/environment) - All environment variables
