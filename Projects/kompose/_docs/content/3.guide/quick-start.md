---
title: Quick Start Guide
description: Get started with Kompose in minutes and start managing your Docker stacks
---

This guide will get you up and running with Kompose in just a few minutes. By the end, you'll have stacks running and understand the core workflows.

## Prerequisites

Before starting, ensure you have:

- **Docker** installed and running
- **Docker Compose** v2.0+ (comes with Docker Desktop)
- **Bash** shell (Linux, macOS, or WSL on Windows)
- **Git** for cloning the repository

**Optional but recommended:**
- **jq** for JSON parsing (`apt-get install jq`)
- **Python 3** for the API server (`apt-get install python3`)

## Installation

### Step 1: Clone the Repository

```bash
# Clone from your Git server
git clone https://your-git-server.com/kompose.git
cd kompose
```

### Step 2: Make Scripts Executable

```bash
# Make all scripts executable
chmod +x kompose.sh
chmod +x kompose-api-server.sh

# Or use the helper script
chmod +x make-all-executable.sh
./make-all-executable.sh
```

### Step 3: Configure Environment

```bash
# Copy environment template
cp secrets.env.template secrets.env

# Edit with your configuration
nano secrets.env

# Set domain configuration
cp domain.env.template domain.env
nano domain.env
```

**Minimum required settings in `secrets.env`:**
```bash
# PostgreSQL
POSTGRES_PASSWORD=your_secure_password

# Timezone
TZ=Europe/Berlin

# Domain
DOMAIN=localhost
```

## First Steps

### List Available Stacks

```bash
./kompose.sh list
```

You'll see all available stacks:
```
Available stacks:

  core        - Core services - MQTT, Redis, Postgres
  auth        - Authentication - Keycloak SSO, OAuth2 Proxy
  kmps        - Management Portal - User & SSO Administration
  chain       - Automation Platform - n8n workflows, Semaphore
  home        - Smart Home - Home Assistant, Matter, Zigbee
  vpn         - VPN - WireGuard remote access
  ...
```

### Start Core Services

The **core** stack provides essential services needed by other stacks:

```bash
# Start core services
./kompose.sh up core

# Check status
./kompose.sh status core

# View logs
./kompose.sh logs core -f
```

Wait for services to be ready (usually 30-60 seconds):
```
[SUCCESS] Stack 'core' started
```

### Start Additional Stacks

```bash
# Start authentication
./kompose.sh up auth

# Start automation platform
./kompose.sh up chain

# Start smart home (if needed)
./kompose.sh up home

# Or start all at once
./kompose.sh up
```

### Check Everything is Running

```bash
# Show all running containers
./kompose.sh ps

# Check status of all stacks
./kompose.sh status
```

## Using the REST API Server

### Start the API Server

```bash
# Install Python 3 (recommended)
sudo apt-get install python3

# Start API server on default port (8080)
./kompose.sh api start

# Check it's running
./kompose.sh api status
```

You should see:
```
[SUCCESS] API server is running (PID: 12345)
Server URL: http://127.0.0.1:8080
```

### Test the API

```bash
# Health check
curl http://localhost:8080/api/health | jq .

# List all stacks
curl http://localhost:8080/api/stacks | jq .

# Get stack status
curl http://localhost:8080/api/stacks/core | jq .

# Start a stack via API
curl -X POST http://localhost:8080/api/stacks/home/start | jq .
```

### Run the Test Suite

```bash
# Make test script executable
chmod +x test-api.sh

# Run all tests
./test-api.sh
```

Expected output:
```
Testing Kompose API...
[PASS] Health check
[PASS] List all stacks
[PASS] Get core stack status
...
All tests passed! ✓
```

## Common Operations

### Stack Management

```bash
# Start a stack
./kompose.sh up <stack-name>

# Stop a stack
./kompose.sh down <stack-name>

# Restart a stack
./kompose.sh restart <stack-name>

# View logs (follow mode)
./kompose.sh logs <stack-name> -f

# View last 100 lines
./kompose.sh logs <stack-name> --tail=100

# Pull latest images
./kompose.sh pull <stack-name>

# Validate compose file
./kompose.sh validate <stack-name>
```

### Database Operations

```bash
# Backup all databases
./kompose.sh db backup

# Backup specific database
./kompose.sh db backup -d kompose

# List available backups
./kompose.sh db list

# Check database status
./kompose.sh db status

# Open database shell
./kompose.sh db shell -d kompose

# Restore from backup
./kompose.sh db restore -f backup.sql
```

### Git Tag Deployments

```bash
# Create a deployment tag
./kompose.sh tag create -s frontend -e dev -v 1.0.0

# Deploy with automatic tagging
./kompose.sh tag deploy -s backend -e staging -v 1.2.3

# List all deployment tags
./kompose.sh tag list

# List tags for specific service
./kompose.sh tag list -s frontend

# Rollback to previous version
./kompose.sh tag rollback -s api -e prod -v 1.0.5
```

## Example Workflows

### Development Workflow

```bash
# 1. Start core services
./kompose.sh up core

# 2. Start your development stack
./kompose.sh up chain

# 3. Check logs while developing
./kompose.sh logs chain -f

# 4. Restart after code changes
./kompose.sh restart chain

# 5. Stop when done
./kompose.sh down chain
```

### Daily Backup Routine

```bash
# Create compressed backup of all databases
./kompose.sh db backup --compress

# Keep only latest backups
# (manual cleanup or cron job)
find backups/database -name "*.sql*" -mtime +7 -delete
```

### Production Deployment

```bash
# 1. Create and push deployment tag
./kompose.sh tag deploy -s api -e prod -v 2.0.0

# 2. Monitor deployment (via n8n workflow)
# 3. Check logs
./kompose.sh logs api

# 4. Verify via API
curl http://localhost:8080/api/stacks/api | jq .

# 5. If issues, rollback
./kompose.sh tag rollback -s api -e prod -v 1.9.5
```

### Remote Management via API

```bash
# 1. Start API server (on server)
./kompose.sh api start

# 2. SSH tunnel (on local machine)
ssh -L 8080:localhost:8080 user@server

# 3. Use API locally
curl http://localhost:8080/api/stacks | jq .

# 4. Or build web dashboard
# See /guide/dashboard-setup for examples
```

## What's Next?

Now that you have Kompose running, here are some next steps:

### 1. Explore Stack Features
- Check out individual [stack documentation](/stacks)
- Learn about [Traefik reverse proxy](/guide/traefik)
- Set up [SSO authentication](/stacks/auth)
- Configure [VPN access](/stacks/vpn)

### 2. Build a Web Dashboard
- Follow the [Dashboard Setup Guide](/guide/dashboard-setup)
- Use the provided API client examples
- Create your own monitoring interface

### 3. Set Up Automation
- Configure [n8n workflows](/stacks/chain)
- Automate deployments with Git tags
- Set up scheduled backups
- Create custom hooks

### 4. Advanced Configuration
- Customize [network settings](/guide/network)
- Set up [custom domains](/guide/configuration#domains)
- Configure [environment variables](/reference/environment)
- Add [custom hooks](/guide/hooks)

### 5. Production Hardening
- Review [security best practices](/guide/security)
- Set up regular backups
- Configure monitoring
- Implement disaster recovery

## Troubleshooting

### Stacks won't start

```bash
# Check Docker is running
docker ps

# Check compose file is valid
./kompose.sh validate <stack-name>

# Check logs for errors
./kompose.sh logs <stack-name>

# Try removing and recreating
./kompose.sh down <stack-name> -f
./kompose.sh up <stack-name>
```

### Database connection errors

```bash
# Check PostgreSQL is running
docker ps | grep postgres

# Check database status
./kompose.sh db status

# Restart core services
./kompose.sh restart core
```

### API server won't start

```bash
# Check if port is in use
lsof -i :8080

# Check if Python 3 is installed
python3 --version

# Install if missing
sudo apt-get install python3

# Try different port
./kompose.sh api start 9000

# Check logs
./kompose.sh api logs
```

### Can't access services

```bash
# Check Traefik is running (if using reverse proxy)
docker ps | grep traefik

# Check service is on correct network
docker inspect <container-name> | grep NetworkMode

# Check Traefik dashboard
http://localhost:8080/dashboard/ (if enabled)
```

## Getting Help

If you need help:

1. **Check the documentation**:
   - [Full User Guide](/guide)
   - [CLI Reference](/reference/cli)
   - [Troubleshooting Guide](/guide/troubleshooting)

2. **Check logs**:
   ```bash
   # Stack logs
   ./kompose.sh logs <stack-name>
   
   # API server logs
   ./kompose.sh api logs
   
   # Docker logs
   docker logs <container-name>
   ```

3. **Validate configuration**:
   ```bash
   # Check compose files
   ./kompose.sh validate
   
   # Check environment
   cat .env
   cat domain.env
   ```

4. **Search issues**: Check if others have encountered the same problem

5. **Ask for help**: Create an issue with:
   - What you're trying to do
   - What you expected
   - What actually happened
   - Relevant logs and configuration

## Quick Reference Card

**Most Used Commands:**

```bash
# Stack operations
./kompose.sh up <stack>          # Start stack
./kompose.sh down <stack>        # Stop stack
./kompose.sh restart <stack>     # Restart stack
./kompose.sh logs <stack> -f     # Follow logs
./kompose.sh status              # Show all status

# API server
./kompose.sh api start           # Start API
./kompose.sh api status          # Check API status
./kompose.sh api stop            # Stop API

# Database
./kompose.sh db backup           # Backup all DBs
./kompose.sh db list             # List backups
./kompose.sh db status           # DB status

# Tags
./kompose.sh tag list            # List all tags
./kompose.sh tag deploy ...      # Deploy with tag

# Help
./kompose.sh --help              # Show all commands
./kompose.sh list                # List stacks
```

Save this page for quick reference, or print the [Quick Reference Guide](/reference/quick-reference).

---

**You're all set!** 🎉 

Start managing your stacks with Kompose. For more advanced features, check out the complete [User Guide](/guide).
