# Kompose Streamlining - Implementation Guide

## 🎯 Overview

This guide walks you through implementing the new domain-based configuration system for Kompose.

**Benefits:**
- ✅ Change domain in ONE place for ALL services
- ✅ Clean, maintainable codebase
- ✅ Better documentation
- ✅ Easy multi-environment setup

## 📝 Pre-Implementation Checklist

Before starting, ensure:
- [ ] You have a full backup of your current configuration
- [ ] All services are documented (what's running, what's not)
- [ ] You have root/sudo access to the server
- [ ] Docker and Docker Compose are installed
- [ ] You know your current domain (e.g., pivoine.art)

## 🚀 Implementation Steps

### Step 1: Backup Current Configuration (2 minutes)

```bash
# Create backup directory
mkdir -p backups/pre-streamline-$(date +%Y%m%d_%H%M%S)

# Backup current configuration
cp .env backups/pre-streamline-*/
cp secrets.env backups/pre-streamline-*/ 2>/dev/null || true

# Backup all stack .env files
find . -maxdepth 2 -name ".env" -exec cp --parents {} backups/pre-streamline-*/ \;

echo "✓ Backup complete"
```

### Step 2: Make Scripts Executable (1 minute)

```bash
chmod +x cleanup-project.sh
chmod +x migrate-domain-config.sh
chmod +x validate-config.sh
chmod +x kompose.sh

echo "✓ Scripts are now executable"
```

### Step 3: Run Migration (3-5 minutes)

The migration script will:
- Detect your current domain
- Create `domain.env`
- Backup old configuration
- Update configuration files

```bash
# Run the migration script
./migrate-domain-config.sh
```

**Follow the prompts:**
1. Confirm detected domain or enter custom domain
2. Allow backup creation
3. Confirm file replacements when asked

**Expected output:**
```
╔════════════════════════════════════════════════════════════════╗
║       Kompose Domain Configuration Migration                   ║
╚════════════════════════════════════════════════════════════════╝

Step 1: Detecting current domain configuration...
  Detected domain: pivoine.art

Step 2: Configure your domain
Current detected domain: pivoine.art
Is this correct? (yes/no/custom): yes

  Using domain: pivoine.art

Step 3: Creating backup...
  ✓ Backup created at: ./backups/migration_20251012_123456

[... continues ...]

╔════════════════════════════════════════════════════════════════╗
║                Migration Complete                              ║
╚════════════════════════════════════════════════════════════════╝
```

### Step 4: Run Cleanup (2-3 minutes)

Remove old backup files and duplicates:

```bash
# Run cleanup script
./cleanup-project.sh
```

**Follow the prompts:**
1. Confirm you want to proceed
2. Decide on old backup directories
3. Handle misplaced SQL files

**Expected output:**
```
╔════════════════════════════════════════════════════════════════╗
║           Kompose Project Cleanup Script                       ║
╚════════════════════════════════════════════════════════════════╝

This script will:
  • Remove all .bak and .new backup files
  • Remove duplicate docker-compose.yml files
  • Clean up old backup directories

WARNING: This action cannot be undone!

Do you want to continue? (yes/no): yes

[... cleaning ...]

╔════════════════════════════════════════════════════════════════╗
║                    Cleanup Complete                            ║
╚════════════════════════════════════════════════════════════════╝
```

### Step 5: Validate Configuration (1-2 minutes)

Run validation to ensure everything is correct:

```bash
# Validate all configuration
./validate-config.sh
```

**Expected output:**
```
╔════════════════════════════════════════════════════════════════╗
║           Kompose Configuration Validation                     ║
╚════════════════════════════════════════════════════════════════╝

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Checking Required Files
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✓ domain.env exists
  ✓ domain.env is valid shell syntax
  ✓ ROOT_DOMAIN is configured: pivoine.art
  ✓ .env exists
  ✓ secrets.env exists
  
[... continues ...]

╔════════════════════════════════════════════════════════════════╗
║                  Validation Summary                            ║
╚════════════════════════════════════════════════════════════════╝

Passed:   25
Warnings: 2
Errors:   0

⚠ Configuration has warnings but should work
```

### Step 6: Review Changes (3-5 minutes)

Check what changed:

```bash
# View git status
git status

# Review new files
cat domain.env
head -n 50 .env

# Compare with backup
diff .env backups/pre-streamline-*/.env || true
```

**Key files to review:**
- `domain.env` - Your domain configuration
- `.env` - Root environment (should import domain.env)
- `secrets.env` - Ensure secrets are still present

### Step 7: Test with Core Stack (5 minutes)

Test the new configuration with core services:

```bash
# Start core stack
./kompose.sh up core

# Check status
./kompose.sh status core

# View logs
./kompose.sh logs core -f

# Press Ctrl+C to stop following logs
```

**Expected behavior:**
- Services start normally
- No errors in logs
- Database, Redis, MQTT are healthy

### Step 8: Test with Proxy Stack (5-10 minutes)

Start the reverse proxy:

```bash
# Start proxy
./kompose.sh up proxy

# Check Traefik logs for SSL certificate requests
./kompose.sh logs proxy

# Wait for SSL certificates (~1-2 minutes)
```

**Look for:**
```
[acme] Certificate obtained for domain [proxy.pivoine.art]
```

**Verify:**
```bash
# Check Traefik dashboard (local only)
curl http://localhost:8080/api/version

# Test DNS resolution
dig proxy.pivoine.art

# Test HTTPS (if DNS is configured)
curl -I https://proxy.pivoine.art
```

### Step 9: Test Additional Stacks (5-10 minutes)

Start and test other critical stacks:

```bash
# Start auth stack
./kompose.sh up auth
./kompose.sh status auth

# Start chain stack
./kompose.sh up chain
./kompose.sh status chain

# Check all running containers
./kompose.sh ps
```

### Step 10: Full System Verification (5 minutes)

```bash
# Start all remaining stacks
./kompose.sh up

# View overall status
./kompose.sh status

# Check for any errors
./kompose.sh logs | grep -i error
```

**Verify each service:**
- [ ] Traefik dashboard: `http://localhost:8080/dashboard/`
- [ ] Auth (Keycloak): `https://auth.pivoine.art`
- [ ] Chain (n8n): `https://chain.pivoine.art`
- [ ] Code (Gitea): `https://code.pivoine.art`
- [ ] Other services as needed

## 🔧 Troubleshooting

### Issue: Services won't start

**Solution:**
```bash
# Check compose file syntax
./kompose.sh validate

# Check Docker daemon
docker info

# Check logs for specific stack
./kompose.sh logs core
```

### Issue: Domain not resolving

**Solution:**
```bash
# Check DNS
dig proxy.pivoine.art
nslookup auth.pivoine.art

# Check domain.env
cat domain.env | grep ROOT_DOMAIN

# Verify Traefik configuration
./kompose.sh logs proxy | grep -i "domain"
```

### Issue: SSL certificates not issued

**Solution:**
```bash
# Check Let's Encrypt logs
./kompose.sh logs proxy | grep -i acme

# Verify domain is publicly accessible
curl -v http://proxy.pivoine.art/.well-known/acme-challenge/test

# Use staging certificates for testing
# Edit proxy/compose.yaml and uncomment staging line
```

### Issue: Migration didn't work

**Solution:**
```bash
# Restore from backup
cp backups/pre-streamline-*/.env .env
cp backups/pre-streamline-*/secrets.env secrets.env

# Restart services
./kompose.sh restart

# Try migration again with more careful review
```

## 📊 Post-Implementation

### Commit Changes

```bash
# Review all changes
git status
git diff

# Stage changes
git add domain.env
git add .env
git add secrets.env.template
git add *.sh
git add *.md

# Commit
git commit -m "Implement centralized domain configuration

- Add domain.env for centralized domain management
- Update .env to import domain configuration
- Add migration and cleanup scripts
- Add comprehensive documentation
- Remove legacy .bak and duplicate files"
```

### Update Documentation

```bash
# Update README.md to reference new guides
cat << 'EOF' >> README.md

## Quick Start

New to Kompose? Check out:
- [Quick Start Guide](QUICK_START.md) - Get running in 15 minutes
- [Domain Configuration](DOMAIN_CONFIGURATION.md) - Configure your domain

## Configuration

All domain configuration is in `domain.env`. Simply change `ROOT_DOMAIN` to your domain.

EOF
```

### Create .gitignore entries

```bash
# Add to .gitignore
cat << 'EOF' >> .gitignore

# Generated files
secrets.env

# Backup and temporary files
*.bak
*.new
*.tmp
.env.backup

# Local backups
backups/*/

EOF
```

## ✅ Completion Checklist

After implementation, verify:

- [ ] `domain.env` exists with your domain
- [ ] `.env` imports domain.env
- [ ] `secrets.env` is configured (not template)
- [ ] All scripts are executable
- [ ] No .bak or .new files remain
- [ ] All compose files are valid
- [ ] Docker network exists
- [ ] Core services start successfully
- [ ] Proxy/Traefik starts and issues SSL certificates
- [ ] Auth services work (if using SSO)
- [ ] All critical services are accessible
- [ ] DNS is properly configured
- [ ] Changes are committed to git
- [ ] Documentation is updated

## 📈 Success Metrics

You'll know the implementation was successful when:

1. **Single Domain Change**: Changing `ROOT_DOMAIN` in `domain.env` updates all services
2. **Clean Repository**: No .bak, .new, or duplicate files
3. **SSL Working**: All services have valid SSL certificates
4. **Services Running**: All required services are up and healthy
5. **DNS Configured**: All subdomains resolve correctly
6. **Documentation**: Clear guides for configuration and usage

## 🎉 You're Done!

Congratulations! Your Kompose installation is now:

- ✅ Centrally configured
- ✅ Clean and maintainable
- ✅ Well documented
- ✅ Production ready

## 📚 Additional Resources

- [QUICK_START.md](QUICK_START.md) - Quick start guide
- [DOMAIN_CONFIGURATION.md](DOMAIN_CONFIGURATION.md) - Domain setup details
- [PROJECT_REVIEW_SUMMARY.md](PROJECT_REVIEW_SUMMARY.md) - Implementation summary
- Stack-specific README files in each directory

## 🆘 Getting Help

If you encounter issues:

1. Check validation: `./validate-config.sh`
2. Review logs: `./kompose.sh logs <stack>`
3. Check status: `./kompose.sh status`
4. Consult documentation in this repo

## 🔄 Changing Your Domain Later

Need to change your domain? It's easy:

```bash
# Edit domain.env
nano domain.env
# Change: ROOT_DOMAIN=newdomain.com

# Restart all services
./kompose.sh down
./kompose.sh up

# Update DNS records
# Wait for SSL certificates to be issued
```

That's it! The entire infrastructure updates to the new domain.
