<div align="center">

```
██╗  ██╗ ██████╗ ███╗   ███╗██████╗  ██████╗ ███████╗███████╗
██║ ██╔╝██╔═══██╗████╗ ████║██╔══██╗██╔═══██╗██╔════╝██╔════╝
█████╔╝ ██║   ██║██╔████╔██║██████╔╝██║   ██║███████╗█████╗  
██╔═██╗ ██║   ██║██║╚██╔╝██║██╔═══╝ ██║   ██║╚════██║██╔══╝  
██║  ██╗╚██████╔╝██║ ╚═╝ ██║██║     ╚██████╔╝███████║███████╗
╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝╚═╝      ╚═════╝ ╚══════╝╚══════╝
```

### 🎼 Your Docker Compose Symphony Conductor 🎻

*Managing multiple compose stacks has never been this elegant*

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Shell](https://img.shields.io/badge/shell-bash-green.svg)](https://www.gnu.org/software/bash/)
[![Docker](https://img.shields.io/badge/docker-compose-2496ED?logo=docker)](https://docs.docker.com/compose/)
[![Powered by Coffee](https://img.shields.io/badge/powered%20by-coffee-brown.svg?logo=buy-me-a-coffee)](https://buymeacoffee.com)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

[Features](#-features) • [Quick Start](#-quick-start) • [Documentation](#-documentation) • [Examples](#-examples) • [Stacks](#-stack-overview)

</div>

---

## 📖 Table of Contents

- [What is Kompose?](#-what-is-kompose)
- [Features](#-features)
- [Quick Start](#-quick-start)
- [Installation](#-installation)
- [Usage](#-usage)
  - [Basic Commands](#basic-commands)
  - [Stack Patterns](#stack-patterns)
  - [Environment Overrides](#environment-overrides)
  - [Database Operations](#-database-operations)
  - [Hooks System](#-hooks-system)
- [Configuration](#-configuration)
- [Stack Overview](#-stack-overview)
- [Network Architecture](#-network-architecture)
- [Advanced Features](#-advanced-features)
- [Troubleshooting](#-troubleshooting)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🎭 What is Kompose?

**Kompose** is a powerful Bash orchestration tool for managing multiple Docker Compose stacks with style and grace. Think of it as a conductor for your Docker symphony - each stack plays its part, and Kompose makes sure they're all in harmony.

### Why Kompose?

🎯 **One Command to Rule Them All** - Manage dozens of stacks with a single command
🔄 **Database Wizardry** - Export, import, and clean up PostgreSQL databases like a boss
🎪 **Hook System** - Extend functionality with custom pre/post operation hooks
🌐 **Network Maestro** - Smart network management with CLI overrides
🔐 **Environment Juggler** - Override any environment variable on the fly
🎨 **Beautiful Output** - Color-coded logs and status indicators
🧪 **Dry-Run Mode** - Test changes before applying them

---

## ✨ Features

### 🎼 Stack Management
- **Pattern-based selection**: Target stacks with globs, comma-separated lists, or wildcards
- **Bulk operations**: Execute commands across multiple stacks simultaneously
- **Status monitoring**: Visual feedback with color-coded success/failure indicators
- **Smart filtering**: Include/exclude stacks with flexible pattern matching

### 💾 Database Operations
- **Automated backups**: Export PostgreSQL databases with timestamped dumps
- **Smart imports**: Auto-detect latest dumps or specify exact files
- **Drop & recreate**: Safe database import with connection termination
- **Cleanup utilities**: Keep only the latest dumps, remove old backups
- **Hook integration**: Custom pre/post operations for each database action

### 🪝 Extensibility
- **Custom hooks**: Define `pre_db_export`, `post_db_export`, `pre_db_import`, `post_db_import`
- **Stack-specific logic**: Each stack can have unique operational requirements
- **Environment access**: Hooks inherit all environment variables
- **Dry-run aware**: Test hook execution without side effects

### 🌐 Network Management
- **Unified network**: All stacks communicate on a single Docker network
- **CLI overrides**: Change network on-the-fly without editing configs
- **Traefik integration**: Seamless reverse proxy setup with proper network awareness
- **Multi-network support**: Special stacks can have additional internal networks

### 🔧 Environment Control
- **Global overrides**: Set environment variables via CLI flags
- **Layered configs**: Root `.env` + stack `.env` + CLI overrides
- **Precedence rules**: CLI > Stack > Root configuration hierarchy
- **Real-time changes**: No need to edit files for temporary overrides

---

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/yourusername/kompose.git
cd kompose

# Make kompose executable
chmod +x kompose.sh

# List all stacks
./kompose.sh --list

# Start everything
./kompose.sh "*" up -d

# View logs from specific stacks
./kompose.sh "blog,news" logs -f

# Export all databases
./kompose.sh "*" db:export

# That's it! 🎉
```

---

## 📦 Installation

### Prerequisites

- **Bash** 4.0+
- **Docker** 20.10+
- **Docker Compose** v2.0+
- **PostgreSQL client tools** (for database operations)
  ```bash
  # Ubuntu/Debian
  sudo apt-get install postgresql-client
  
  # macOS
  brew install postgresql
  ```

### Setup

1. **Clone and configure:**
   ```bash
   git clone https://github.com/yourusername/kompose.git
   cd kompose
   chmod +x kompose.sh
   ```

2. **Create root `.env`:**
   ```bash
   cp .env.example .env
   nano .env
   ```

3. **Create the Docker network:**
   ```bash
   docker network create kompose
   ```

4. **Configure your stacks:**
   Each stack directory should have:
   - `compose.yaml` - Docker Compose configuration
   - `.env` - Stack-specific environment variables
   - `hooks.sh` (optional) - Custom operational hooks

---

## 📚 Usage

### Basic Commands

```bash
# Start stacks
./kompose.sh <pattern> up -d

# Stop stacks
./kompose.sh <pattern> down

# View logs
./kompose.sh <pattern> logs -f

# Restart stacks
./kompose.sh <pattern> restart

# Check status
./kompose.sh <pattern> ps

# Pull latest images
./kompose.sh <pattern> pull
```

### Stack Patterns

```bash
# All stacks
./kompose.sh "*" up -d

# Single stack
./kompose.sh blog up -d

# Multiple specific stacks
./kompose.sh "auth,blog,data" restart

# Pattern matching (coming soon)
./kompose.sh "news*" logs
```

### Environment Overrides

```bash
# Override single variable
./kompose.sh -e DB_HOST=localhost news up -d

# Override multiple variables
./kompose.sh -e DB_HOST=postgres.local -e DB_PORT=5433 news restart

# Network override
./kompose.sh --network staging "*" up -d

# Combine overrides
./kompose.sh -e DEBUG=true --network dev news logs -f
```

### Dry-Run Mode

Test commands without executing them:

```bash
# Test bulk operation
./kompose.sh --dry-run "*" down

# Preview database export
./kompose.sh -n news db:export

# Check import process
./kompose.sh --dry-run news db:import
```

---

## 💾 Database Operations

### Export Databases

Export PostgreSQL databases with timestamped backups:

```bash
# Export all databases
./kompose.sh "*" db:export

# Export specific stack
./kompose.sh news db:export

# Preview export (dry-run)
./kompose.sh news db:export --dry-run
```

**Output format:** `<stack-dir>/<db-name>_YYYYMMDD_HHMMSS.sql`

**Example:** `news/letterspace_20250108_143022.sql`

### Import Databases

**⚠️ WARNING:** Import operations DROP and RECREATE the database!

```bash
# Import latest dump (auto-detected)
./kompose.sh news db:import

# Import specific dump file
./kompose.sh news db:import news/letterspace_20250107_080554.sql

# Import to multiple stacks (uses each stack's latest dump)
./kompose.sh "auth,news,track" db:import

# Preview import
./kompose.sh news db:import --dry-run
```

**Import Process:**
1. Terminate existing database connections
2. Drop existing database
3. Create fresh database
4. Import SQL dump
5. Execute post-import hooks (if any)

### Cleanup Old Dumps

Keep your storage clean by removing old backups:

```bash
# Clean all stacks (keeps only latest dump)
./kompose.sh "*" db:cleanup

# Clean specific stack
./kompose.sh news db:cleanup

# Preview cleanup
./kompose.sh "*" db:cleanup --dry-run
```

### Database Workflow Examples

**Regular backup workflow:**
```bash
# Daily backup
./kompose.sh "*" db:export

# Weekly cleanup
./kompose.sh "*" db:cleanup
```

**Migration workflow:**
```bash
# 1. Export from production
./kompose.sh news db:export

# 2. Copy dump file to staging server
scp news/letterspace_*.sql staging:/path/to/kompose/news/

# 3. Import on staging
./kompose.sh news db:import
```

**Disaster recovery:**
```bash
# Restore from latest backup
./kompose.sh news db:import

# Or restore specific version
./kompose.sh news db:import news/letterspace_20250107_080554.sql
```

### Stacks with PostgreSQL

| Stack | Database | Purpose |
|-------|----------|---------|
| `auth` | keycloak | Authentication & SSO |
| `auto` | semaphore | Automation & CI/CD |
| `news` | letterspace | Newsletter platform |
| `sexy` | directus | Headless CMS |
| `track` | umami | Analytics platform |

---

## 🪝 Hooks System

Extend Kompose functionality with custom hooks for each stack.

### Available Hooks

| Hook | Timing | Arguments | Use Case |
|------|--------|-----------|----------|
| `hook_pre_db_export` | Before DB export | None | Prepare data, export schemas |
| `hook_post_db_export` | After DB export | `$1` = dump file path | Cleanup, notifications |
| `hook_pre_db_import` | Before DB import | `$1` = dump file path | Prepare environment, schema setup |
| `hook_post_db_import` | After DB import | `$1` = dump file path | Restart services, clear caches |

### Creating Hooks

Create `<stack>/hooks.sh`:

```bash
#!/usr/bin/env bash

# Export schema before database export
hook_pre_db_export() {
    echo "  Exporting application schema..."
    docker exec sexy_api npx directus schema snapshot --yes ./schema.yaml
    return 0  # 0 = success, 1 = failure
}

# Apply schema before database import
hook_pre_db_import() {
    local dump_file="$1"
    echo "  Applying schema snapshot..."
    docker exec sexy_api npx directus schema apply --yes ./schema.yaml
    return 0
}

# Restart service after import
hook_post_db_import() {
    local dump_file="$1"
    echo "  Restarting application..."
    docker restart sexy_api
    return 0
}
```

### Real-World Example: Directus (sexy stack)

The `sexy` stack uses hooks for Directus schema management:

**Export Flow:**
1. `pre_db_export`: Export Directus schema snapshot
2. Database export creates SQL dump
3. Result: Both database dump + schema snapshot

**Import Flow:**
1. `pre_db_import`: Apply Directus schema from snapshot
2. Database import loads SQL dump
3. `post_db_import`: Restart Directus container
4. Result: Fully synchronized schema + data

### Testing Hooks

```bash
# Preview hook execution
./kompose.sh sexy db:export --dry-run

# Execute with hooks
./kompose.sh sexy db:export

# Import with hooks
./kompose.sh sexy db:import
```

### Hook Best Practices

✅ **DO:**
- Return 0 for success, 1 for failure
- Use indented output: `echo "  Message"`
- Make non-critical operations return 0
- Check container status before `docker exec`
- Test in dry-run mode first

❌ **DON'T:**
- Assume containers are running
- Use blocking operations without timeouts
- Forget error handling
- Hardcode paths or credentials

---

## ⚙️ Configuration

### Root Configuration (`.env`)

Global settings shared across all stacks:

```bash
# Network Configuration
NETWORK_NAME=kompose

# Database Connection (default values)
DB_USER=dbuser
DB_PASSWORD=secretpassword
DB_PORT=5432
DB_HOST=postgres

# Admin Settings
ADMIN_EMAIL=admin@example.com

# Email/SMTP Settings
EMAIL_TRANSPORT=smtp
EMAIL_FROM=noreply@example.com
EMAIL_SMTP_HOST=smtp.example.com
EMAIL_SMTP_PORT=465
EMAIL_SMTP_USER=smtp@example.com
EMAIL_SMTP_PASSWORD=smtppassword
```

### Stack Configuration (`<stack>/.env`)

Stack-specific settings:

```bash
# Stack Identification
COMPOSE_PROJECT_NAME=blog

# Docker Image
DOCKER_IMAGE=joseluisq/static-web-server:latest

# Traefik Configuration
TRAEFIK_HOST=example.com

# Application Settings
APP_PORT=80
```

### Configuration Precedence

```
CLI Overrides (-e flag) 
    ↓
Stack .env
    ↓
Root .env
    ↓
Compose defaults
```

---

## 🏗️ Stack Overview

### Production Stacks

| Stack | Service | Port | Database | Public URL |
|-------|---------|------|----------|------------|
| **auth** | Keycloak | - | ✅ | auth.example.com |
| **auto** | Semaphore | 3001 | ✅ | auto.example.com |
| **blog** | Static Server | - | ❌ | example.com |
| **chat** | Gotify | - | ❌ | chat.example.com |
| **news** | Newsletter | - | ✅ | news.example.com |
| **sexy** | Directus + Frontend | 8055 | ✅ | sexy.example.com |
| **track** | Umami | - | ✅ | track.example.com |

### Infrastructure Stacks

| Stack | Service | Purpose | Exposed Ports |
|-------|---------|---------|---------------|
| **data** | Postgres + Redis | Shared database | 5432, 6379 |
| **proxy** | Traefik | Reverse proxy + SSL | 80, 443, 8080 |
| **trace** | SigNoz | Observability | - |
| **vault** | Vaultwarden | Password manager | - |
| **vpn** | WireGuard | VPN server | 51820 |
| **dock** | Dockge | Docker UI | - |

### Stack Features Matrix

```
Stack    | Traefik | PostgreSQL | Redis | SMTP | Hooks |
---------|---------|------------|-------|------|-------|
auth     |    ✅   |     ✅     |   -   |  UI  |   -   |
auto     |    ✅   |     ✅     |   -   |  ✅  |   -   |
blog     |    ✅   |     -      |   -   |  -   |   -   |
chat     |    ✅   |     -      |   -   |  -   |   -   |
data     |    -    |  Provider  |  ✅   |  -   |   -   |
dock     |    ✅   |     -      |   -   |  -   |   -   |
news     |    ✅   |     ✅     |   -   |  ✅  |   -   |
proxy    |    -    |     -      |   -   |  -   |   -   |
sexy     |    ✅   |     ✅     |   ✅  |  ✅  |   ✅  |
trace    |    ✅   |     -      |   -   |  -   |   -   |
track    |    ✅   |     ✅     |   -   |  -   |   -   |
vault    |    ✅   |     -      |   -   |  ✅  |   -   |
vpn      |    ✅   |     -      |   -   |  -   |   -   |
```

---

## 🌐 Network Architecture

### Single Network Design

All stacks communicate through a unified Docker network:

```
┌─────────────────────────────────────────────────┐
│          kompose Network (Bridge)               │
│                                                 │
│  ┌───────┐  ┌───────┐  ┌──────┐  ┌──────┐    │
│  │ Blog  │  │ News  │  │ Auth │  │ Data │    │
│  └───────┘  └───────┘  └──────┘  └──────┘    │
│      │          │          │         │         │
│  ┌───────────────────────────────────────┐    │
│  │         Traefik (Reverse Proxy)       │    │
│  └───────────────────────────────────────┘    │
│                    │                            │
└────────────────────┼────────────────────────────┘
                     │
              ┌──────┴──────┐
              │  Internet   │
              └─────────────┘
```

### Network Configuration

**Default network:** `kompose` (defined in root `.env`)

**Override network:**
```bash
# Temporary override
./kompose.sh --network staging "*" up -d

# Permanent override
echo "NETWORK_NAME=production" >> .env
```

### Special Network Cases

**trace stack** - Dual network setup:
- `kompose` - External access via Traefik
- `signoz` - Internal component communication

**vpn stack** - Dual network setup:
- `kompose` - Web UI access
- `wg` - WireGuard tunnel network

---

## 🎯 Advanced Features

### List All Stacks

```bash
./kompose.sh --list
```

Output shows:
- Stack name
- Compose file type
- Features: `.env`, SQL dumps, PostgreSQL, hooks

### Help & Documentation

```bash
./kompose.sh --help
```

### Combining Options

```bash
# Dry-run with environment override
./kompose.sh -n -e DB_HOST=testdb news db:import

# Network override with multiple stacks
./kompose.sh --network staging "auth,blog" restart

# All the flags!
./kompose.sh --dry-run -e DEBUG=true --network dev "*" up -d
```

### Error Handling

Kompose provides detailed error messages:

```bash
# Missing required arguments
./kompose.sh
# Error: Missing required arguments

# No matching stacks
./kompose.sh "nonexistent" up
# Error: No stacks match pattern: nonexistent

# Failed operations show summary
./kompose.sh "*" db:export
# Summary: 4 succeeded, 1 failed out of 5 stacks
```

---

## 🔍 Troubleshooting

### Common Issues

#### 🚫 404 Error from Traefik

**Problem:** Websites return 404 even though containers are running

**Solution:**
```bash
# Check Traefik logs
docker logs proxy_app

# Verify network configuration
docker network inspect kompose

# Restart proxy and affected stacks
./kompose.sh proxy down && ./kompose.sh proxy up -d
./kompose.sh blog restart
```

**Debug:**
```bash
# Check Traefik dashboard
http://your-server:8080

# Verify container labels
docker inspect blog_app | grep traefik
```

#### 💾 Database Import Fails

**Problem:** `db:import` command fails

**Common causes:**
1. **Active connections** - Solved automatically (kompose terminates connections)
2. **Missing dump file** - Check file path
3. **Insufficient permissions** - Check DB_USER permissions
4. **Wrong database** - Verify DB_NAME in stack `.env`

**Solution:**
```bash
# Check database connectivity
docker exec data_postgres psql -U $DB_USER -l

# Verify dump file exists
ls -lh news/*.sql

# Check logs for detailed error
./kompose.sh news db:import 2>&1 | tee import.log
```

#### 🔌 Container Won't Connect to Network

**Problem:** Container fails to join kompose network

**Solution:**
```bash
# Recreate network
docker network rm kompose
docker network create kompose

# Restart all stacks
./kompose.sh "*" down
./kompose.sh "*" up -d
```

#### 🪝 Hooks Not Executing

**Problem:** Custom hooks aren't running

**Checklist:**
- [ ] `hooks.sh` file exists in stack directory
- [ ] `hooks.sh` is executable: `chmod +x <stack>/hooks.sh`
- [ ] Function names match: `hook_pre_db_export`, etc.
- [ ] Functions return 0 (success) or 1 (failure)

**Test:**
```bash
# Dry-run shows hook execution
./kompose.sh sexy db:export --dry-run

# Check if hooks.sh exists
./kompose.sh --list | grep hooks
```

### Debug Mode

Enable verbose logging:

```bash
# View Traefik debug logs
docker logs -f proxy_app

# Check environment variables
./kompose.sh news ps
docker exec news_backend env

# Inspect running containers
docker ps -a
docker inspect <container_name>
```

### Getting Help

1. **Check logs:** `./kompose.sh <stack> logs`
2. **Use dry-run:** `./kompose.sh --dry-run <pattern> <command>`
3. **List stacks:** `./kompose.sh --list`
4. **Read help:** `./kompose.sh --help`
5. **Open an issue:** [GitHub Issues](https://github.com/yourusername/kompose/issues)

---

## 📊 Examples Gallery

### Daily Operations

```bash
# Morning routine - start everything
./kompose.sh "*" up -d

# Check what's running
./kompose.sh --list
docker ps

# View recent logs
./kompose.sh "*" logs --tail=50

# Evening routine - backup databases
./kompose.sh "*" db:export
./kompose.sh "*" db:cleanup
```

### Deployment Workflow

```bash
# 1. Pull latest images
./kompose.sh "*" pull

# 2. Export databases (backup before update)
./kompose.sh "*" db:export

# 3. Restart with new images
./kompose.sh "*" down
./kompose.sh "*" up -d

# 4. Check health
./kompose.sh "*" ps
```

### Development Workflow

```bash
# Start only development stacks
./kompose.sh "data,proxy,news" up -d

# Override database for testing
./kompose.sh -e DB_HOST=localhost -e DB_NAME=test_db news up -d

# Watch logs in real-time
./kompose.sh news logs -f

# Clean up after testing
./kompose.sh news down
```

### Staging Environment

```bash
# Deploy to staging with network override
./kompose.sh --network staging-net "*" up -d

# Use staging database
./kompose.sh -e DB_HOST=staging-db.local "*" restart

# Import production dump to staging
./kompose.sh news db:import /backups/production/news_latest.sql
```

### Maintenance Tasks

```bash
# Update all containers
./kompose.sh "*" pull
./kompose.sh "*" up -d

# Cleanup old images
docker image prune -a

# Backup all databases
./kompose.sh "*" db:export

# Archive old backups (keep only latest)
./kompose.sh "*" db:cleanup

# Check disk usage
docker system df
```

---

## 🎨 Tips & Tricks

### Aliases

Add to your `.bashrc` or `.zshrc`:

```bash
alias kp='./kompose.sh'
alias kup='./kompose.sh "*" up -d'
alias kdown='./kompose.sh "*" down'
alias klogs='./kompose.sh "*" logs -f'
alias kps='./kompose.sh "*" ps'
alias kbackup='./kompose.sh "*" db:export && ./kompose.sh "*" db:cleanup'
```

### Automated Backups

Create a cron job:

```bash
# Daily backup at 2 AM
0 2 * * * cd /path/to/kompose && ./kompose.sh "*" db:export 2>&1 | tee -a backup.log

# Weekly cleanup (Sundays at 3 AM)
0 3 * * 0 cd /path/to/kompose && ./kompose.sh "*" db:cleanup
```

### Quick Health Check

```bash
#!/usr/bin/env bash
# health-check.sh

echo "🏥 Health Check"
echo "==============="

./kompose.sh "*" ps | grep -E "Up|Exit"

echo ""
echo "📊 Database Sizes:"
docker exec data_postgres psql -U $DB_USER -c "
SELECT datname, pg_size_pretty(pg_database_size(datname)) AS size 
FROM pg_database 
WHERE datname NOT IN ('template0', 'template1', 'postgres')
ORDER BY pg_database_size(datname) DESC;"
```

### Environment Template

Create `.env.template` for team members:

```bash
# Network Configuration
NETWORK_NAME=kompose

# Database Connection
DB_USER=changeme
DB_PASSWORD=changeme
DB_PORT=5432
DB_HOST=postgres

# Admin Settings
ADMIN_EMAIL=changeme@example.com

# Email/SMTP Settings
EMAIL_TRANSPORT=smtp
EMAIL_FROM=changeme@example.com
EMAIL_SMTP_HOST=smtp.example.com
EMAIL_SMTP_PORT=465
EMAIL_SMTP_USER=changeme
EMAIL_SMTP_PASSWORD=changeme
```

---

## 🤝 Contributing

We love contributions! 🎉

### How to Contribute

1. **Fork the repository**
2. **Create a feature branch:** `git checkout -b feature/amazing-feature`
3. **Make your changes**
4. **Test thoroughly:** Use dry-run mode
5. **Commit your changes:** `git commit -m 'Add amazing feature'`
6. **Push to the branch:** `git push origin feature/amazing-feature`
7. **Open a Pull Request**

### Development Guidelines

- **Shell script best practices:** Use `shellcheck` for linting
- **Test before commit:** Always use `--dry-run` to test changes
- **Documentation:** Update README for new features
- **Compatibility:** Ensure Bash 4.0+ compatibility

### Adding a New Stack

1. Create stack directory: `mkdir my-stack`
2. Add `compose.yaml` with Traefik labels
3. Add `.env` with stack configuration
4. Test: `./kompose.sh my-stack up -d`
5. (Optional) Add `hooks.sh` for custom operations

### Reporting Issues

Found a bug? [Open an issue](https://github.com/yourusername/kompose/issues) with:
- **Description:** What's wrong?
- **Steps to reproduce:** How to trigger the issue
- **Expected behavior:** What should happen
- **Actual behavior:** What actually happens
- **Environment:** OS, Docker version, Bash version

---

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2025 Kompose Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
```

---

<div align="center">

## 🎵 The Kompose Symphony

```
┌─────────────────────────────────────────┐
│  "Docker Compose, but make it orchestra" │
│           - Some wise DevOps, 2025       │
└─────────────────────────────────────────┘
```

**Made with ❤️ and ☕ by the Kompose Community**

[⭐ Star us on GitHub](https://github.com/yourusername/kompose) • 
[🐛 Report Bug](https://github.com/yourusername/kompose/issues) • 
[💡 Request Feature](https://github.com/yourusername/kompose/issues)

---

### 🎼 Support the Project

If Kompose saved you time (and sanity), consider:
- ⭐ Starring the repo
- 🐛 Reporting bugs
- 💡 Suggesting features
- 📖 Improving documentation
- ☕ [Buying us coffee](https://buymeacoffee.com)

**Remember:** Behind every great infrastructure is a developer who automated it. Be that developer. Use Kompose. 🚀

</div>
