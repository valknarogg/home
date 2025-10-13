# Troubleshooting Guide

This guide helps you diagnose and fix common issues with kompose.sh.

## Quick Diagnostics

Run these commands to check your setup:

```bash
# Check kompose version
./kompose.sh version

# Validate configuration
./kompose.sh validate

# Check Docker
docker --version
docker ps

# Check environment
./kompose.sh setup status
```

## Common Issues

### Console Colors Not Displaying

**Symptoms:**
- Log messages appear without colors
- Escape codes visible as literal text
- Output is hard to read

**Causes:**
1. Terminal doesn't support ANSI colors
2. Color variables not exported (fixed in v2.0.0)
3. Using older version of kompose

**Solutions:**

**1. Update to latest version:**
```bash
git pull origin main
```

**2. Verify color support:**
```bash
# Test if terminal supports colors
echo -e "\033[0;31mRed\033[0m \033[0;32mGreen\033[0m \033[0;34mBlue\033[0m"
```

**3. Check kompose version:**
```bash
./kompose.sh version
```

Should show version 2.0.0 or higher with color fix.

**4. Force enable colors:**
```bash
export FORCE_COLOR=1
./kompose.sh list
```

**5. Check bash version:**
```bash
bash --version  # Should be 4.0+
```

### Stack Won't Start

**Symptoms:**
- `kompose up <stack>` fails
- Container exits immediately
- Error messages about configuration

**Diagnosis:**

**1. Check if Docker is running:**
```bash
docker ps
# If fails: sudo systemctl start docker
```

**2. Validate stack configuration:**
```bash
./kompose.sh validate <stack>
```

**3. Check stack exists:**
```bash
./kompose.sh list
```

**4. View detailed errors:**
```bash
./kompose.sh up <stack> 2>&1 | tee error.log
```

**5. Check compose file:**
```bash
cd <stack-dir>
docker compose config
```

**Common Solutions:**

**Missing network:**
```bash
docker network create kompose
```

**Environment variables not set:**
```bash
./kompose.sh init  # Re-run initialization
source .env        # Reload environment
```

**Port already in use:**
```bash
# Check what's using the port
sudo lsof -i :PORT

# Change port in .env or stop conflicting service
```

**Image pull fails:**
```bash
# Check internet connection
ping -c 3 8.8.8.8

# Login to registry if needed
docker login

# Pull manually
docker pull IMAGE:TAG
```

### Database Connection Fails

**Symptoms:**
- Services can't connect to PostgreSQL/Redis
- "Connection refused" errors
- Timeouts

**Diagnosis:**

**1. Check core services running:**
```bash
./kompose.sh status core
```

**2. Test database connectivity:**
```bash
# PostgreSQL
docker exec -it core-postgres psql -U kompose -d kompose

# Redis
docker exec -it core-redis redis-cli ping
```

**3. Check environment variables:**
```bash
grep DB_ .env
grep REDIS .env
```

**4. Verify network:**
```bash
docker network inspect kompose
```

**Solutions:**

**Start core stack first:**
```bash
./kompose.sh up core
sleep 10  # Wait for services to be ready
./kompose.sh up <other-stack>
```

**Check database credentials:**
```bash
# Verify secrets.env matches .env
diff <(grep DB .env) <(grep DB secrets.env)
```

**Reset database (if safe):**
```bash
./kompose.sh db reset -d kompose
./kompose.sh db migrate
```

**Check container logs:**
```bash
./kompose.sh logs core -f
```

### API Server Won't Start

**Symptoms:**
- `kompose api start` fails
- Port already in use
- API server immediately stops

**Diagnosis:**

**1. Check if already running:**
```bash
./kompose.sh api status
```

**2. Check port availability:**
```bash
# Default port is 8080
sudo lsof -i :8080
```

**3. Check API server logs:**
```bash
./kompose.sh api logs
# Or directly:
cat /tmp/kompose-api.log
```

**4. Verify Python installation:**
```bash
python3 --version  # Should be 3.7+
```

**Solutions:**

**Stop conflicting process:**
```bash
# Kill process on port 8080
sudo kill $(sudo lsof -t -i:8080)
```

**Use different port:**
```bash
./kompose.sh api start 9000
```

**Install Python if missing:**
```bash
# Ubuntu/Debian
sudo apt install python3

# macOS
brew install python3
```

**Check file permissions:**
```bash
ls -la kompose-api-server.sh
chmod +x kompose-api-server.sh
```

**Stop and restart:**
```bash
./kompose.sh api stop
sleep 2
./kompose.sh api start
```

### Tests Failing

**Symptoms:**
- Test suite reports failures
- Snapshot mismatches
- Integration tests skip/fail

**Diagnosis:**

**1. Check test prerequisites:**
```bash
cd __tests
bash --version  # 4.0+
docker ps       # Docker running
```

**2. Run with verbose output:**
```bash
./run-all-tests.sh -v
```

**3. Check specific test:**
```bash
./test-basic-commands.sh
```

**4. Review test logs:**
```bash
cat temp/test-*.log
```

**Solutions:**

**Update snapshots (if output intentionally changed):**
```bash
./run-all-tests.sh -u
```

**Fix Docker access:**
```bash
sudo usermod -aG docker $USER
newgrp docker
```

**Clean test environment:**
```bash
rm -rf temp/*
rm -rf snapshots/*.new
```

**Skip integration tests:**
```bash
# Don't use -i flag if Docker issues
./run-all-tests.sh
```

**Make scripts executable:**
```bash
cd __tests
chmod +x *.sh
```

### Authentication Issues

**Symptoms:**
- Can't login to Keycloak
- OAuth2 errors
- SSO not working

**Diagnosis:**

**1. Check auth stack:**
```bash
./kompose.sh status auth
```

**2. Verify Keycloak admin credentials:**
```bash
grep KC_ADMIN secrets.env
```

**3. Check OAuth2 configuration:**
```bash
grep OAUTH2 .env secrets.env
```

**4. View Keycloak logs:**
```bash
./kompose.sh logs auth -f
```

**Solutions:**

**Reset Keycloak admin password:**
```bash
# Stop stack
./kompose.sh down auth

# Update secrets.env
nano secrets.env
# Change AUTH_KEYCLOAK_ADMIN_PASSWORD

# Start again
./kompose.sh up auth
```

**Clear browser cache:**
```bash
# Clear cookies for your domain
# Try incognito/private mode
```

**Regenerate OAuth2 secrets:**
```bash
# In secrets.env, generate new:
AUTH_OAUTH2_CLIENT_SECRET=$(openssl rand -base64 32)
AUTH_OAUTH2_COOKIE_SECRET=$(openssl rand -base64 32)

# Restart auth stack
./kompose.sh restart auth
```

**Check realm configuration:**
```bash
# Access Keycloak admin: http://localhost:8180
# Verify realm "kmps" exists
# Check client "oauth2-proxy" settings
```

### Git Tag Deployment Fails

**Symptoms:**
- `kompose tag deploy` fails
- Tags not pushing to remote
- Webhook not triggering

**Diagnosis:**

**1. Check Git configuration:**
```bash
git config --get remote.origin.url
git remote -v
```

**2. Verify tag format:**
```bash
# Tags should match: SERVICE-v1.2.3-ENV
git tag -l "*-v*-*"
```

**3. Test Git credentials:**
```bash
git fetch --tags
```

**4. Check webhook configuration:**
```bash
grep WEBHOOK .env
```

**Solutions:**

**Configure Git remote:**
```bash
git remote add origin YOUR_REPO_URL
```

**Set up Git credentials:**
```bash
# SSH
ssh-keygen -t ed25519
# Add key to Gitea

# Or use HTTPS with credentials
git config credential.helper store
```

**Create tag manually:**
```bash
git tag -a frontend-v1.0.0-dev -m "Deploy frontend 1.0.0 to dev"
git push origin frontend-v1.0.0-dev
```

**Verify webhook:**
```bash
# Test n8n webhook
curl -X POST ${N8N_WEBHOOK_BASE}/deploy-test
```

### Permission Denied Errors

**Symptoms:**
- "Permission denied" when running commands
- Can't execute scripts
- Docker socket access denied

**Solutions:**

**Make scripts executable:**
```bash
chmod +x kompose.sh
chmod +x kompose-*.sh
# Or use helper:
./kompose.sh setup make-executable
```

**Fix Docker permissions:**
```bash
sudo usermod -aG docker $USER
newgrp docker
# Or restart system
```

**Fix file ownership:**
```bash
sudo chown -R $USER:$USER .
```

**Check SELinux/AppArmor:**
```bash
# Temporarily disable to test
sudo setenforce 0  # SELinux
sudo aa-status     # AppArmor
```

### Environment Configuration Issues

**Symptoms:**
- Services use wrong configuration
- Can't switch between local/prod
- Variables not loading

**Diagnosis:**

**1. Check current mode:**
```bash
./kompose.sh setup status
```

**2. Verify environment files:**
```bash
ls -la .env* secrets.env* domain.env*
```

**3. Check for syntax errors:**
```bash
bash -n kompose-env.sh
```

**4. Test environment loading:**
```bash
source .env
echo $ROOT_DOMAIN
```

**Solutions:**

**Re-initialize:**
```bash
./kompose.sh init
```

**Switch modes:**
```bash
# For local development
./kompose.sh setup local

# For production
./kompose.sh setup prod
```

**Validate configuration:**
```bash
./kompose.sh validate
```

**Regenerate .env files:**
```bash
cp .env.template .env
cp secrets.env.template secrets.env
nano .env         # Update values
nano secrets.env  # Add secrets
```

## Advanced Troubleshooting

### Enable Debug Mode

```bash
# Add to start of command
bash -x ./kompose.sh command

# Or set globally
set -x
./kompose.sh command
set +x
```

### Inspect Docker Internals

```bash
# Container details
docker inspect <container-name>

# Network details
docker network inspect kompose

# Volume details
docker volume ls
docker volume inspect <volume-name>

# Check logs
docker logs <container-name> --tail 100 --follow
```

### Check System Resources

```bash
# Disk space
df -h

# Memory usage
free -h

# Docker disk usage
docker system df

# Clean up
docker system prune -a --volumes
```

### Collect Diagnostic Info

```bash
# Create diagnostics report
cat > diagnostics.txt << EOF
=== System Info ===
$(uname -a)

=== Docker Version ===
$(docker --version)
$(docker compose version)

=== Kompose Version ===
$(./kompose.sh version)

=== Running Containers ===
$(docker ps -a)

=== Docker Networks ===
$(docker network ls)

=== Kompose Configuration ===
$(./kompose.sh setup status)

=== Environment Variables ===
$(grep -v PASSWORD .env | grep -v SECRET | grep -v TOKEN)

=== Recent Errors ===
$(./kompose.sh logs core --tail 20 2>&1)
EOF

cat diagnostics.txt
```

## Getting Help

### Documentation Resources

- [Installation Guide](/installation)
- [Quick Start Guide](/guide/quick-start)
- [CLI Reference](/reference/cli)
- [Testing Guide](/guide/testing)
- [Known Issues](/guide/known-issues)

### Community Support

- **Issues**: https://code.pivoine.art/valknar/kompose/issues
- **Discussions**: https://code.pivoine.art/valknar/kompose/discussions

### Creating Good Bug Reports

Include:

1. **What you tried to do**
2. **What you expected to happen**
3. **What actually happened**
4. **System information**:
   ```bash
   ./kompose.sh version
   docker --version
   uname -a
   ```
5. **Relevant logs/errors**
6. **Steps to reproduce**

## Prevention Tips

### Regular Maintenance

```bash
# Weekly checks
./kompose.sh status
./kompose.sh db backup
./kompose.sh validate

# Monthly cleanup
docker system prune -a
./kompose.sh cleanup
```

### Best Practices

1. **Always run init first**: `./kompose.sh init`
2. **Keep Docker updated**: `docker --version`
3. **Regular backups**: `./kompose.sh db backup`
4. **Test before deploying**: `./kompose.sh validate`
5. **Monitor logs**: `./kompose.sh logs <stack> -f`
6. **Use version control**: Commit config changes
7. **Document customizations**: Keep notes
8. **Run tests regularly**: `cd __tests && ./run-all-tests.sh`

### Health Checks

Create a health check script:

```bash
#!/bin/bash
# healthcheck.sh

echo "=== Kompose Health Check ==="
echo ""

# Check Docker
if ! docker ps > /dev/null 2>&1; then
    echo "❌ Docker not running"
    exit 1
fi
echo "✅ Docker running"

# Check core services
if docker ps | grep -q "core-postgres"; then
    echo "✅ PostgreSQL running"
else
    echo "❌ PostgreSQL not running"
fi

if docker ps | grep -q "core-redis"; then
    echo "✅ Redis running"
else
    echo "❌ Redis not running"
fi

# Check network
if docker network inspect kompose > /dev/null 2>&1; then
    echo "✅ Network exists"
else
    echo "❌ Network missing"
fi

echo ""
echo "Health check complete!"
```

Run regularly:
```bash
chmod +x healthcheck.sh
./healthcheck.sh
```

---

**Remember**: When in doubt, check the logs!

```bash
./kompose.sh logs <stack> -f
```
