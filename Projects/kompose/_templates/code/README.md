# Code Stack Template

This template provides a complete, production-ready Git repository management and CI/CD solution using Gitea with integrated Actions runners.

## Overview

The Code stack consists of:
- **Gitea**: Self-hosted Git service with GitHub-like interface
- **Gitea Actions Runner**: Docker-based CI/CD runner for automated workflows

## Quick Start

Generate this stack using kompose-generate.sh:

```bash
./kompose-generate.sh code
```

This will:
1. Create the code stack directory if it doesn't exist
2. Copy all template files including Gitea Actions workflows
3. Generate environment variables from kompose.yml
4. Generate secrets
5. Prepare the stack for deployment

## Files in this Template

- `kompose.yml` - Complete stack configuration with all variables and secrets defined
- `compose.yaml` - Docker Compose configuration
- `.env.example` - Example environment file (will be generated from kompose.yml)
- `.gitea/workflows/` - Example Gitea Actions workflows
  - `ci-cd.yaml` - CI/CD pipeline with testing and deployment
  - `deploy-infrastructure.yaml` - Infrastructure deployment via Semaphore
- `README.md` - This file

## Requirements

Before deploying this stack, ensure these stacks are running:
- **core** - Provides PostgreSQL and Redis
- **proxy** - Provides Traefik for routing

Optional but recommended:
- **messaging** - Provides Mailhog for email notifications

## Configuration

All configuration is defined in `kompose.yml`. Key settings:

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| CODE_COMPOSE_PROJECT_NAME | code | Stack project name |
| CODE_GITEA_IMAGE | gitea/gitea:latest | Gitea image |
| CODE_GITEA_DB_NAME | gitea | Database name |
| CODE_GITEA_PORT_SSH | 2222 | SSH port for git operations |
| CODE_GITEA_PORT_HTTP | 3001 | HTTP port (internal) |
| SUBDOMAIN_CODE | git | Gitea subdomain |
| CODE_GITEA_RUNNER_NAME | kompose-runner-1 | Actions runner name |

### Secrets

| Secret | Description | Generation |
|--------|-------------|------------|
| DB_PASSWORD | Database password (shared) | Auto-generated |
| REDIS_PASSWORD | Redis password (shared) | Auto-generated |
| CODE_GITEA_SECRET_KEY | Gitea security key | Auto-generated |
| CODE_GITEA_INTERNAL_TOKEN | Internal auth token | Auto-generated |
| CODE_GITEA_OAUTH2_JWT_SECRET | OAuth2 JWT secret | Auto-generated |
| CODE_GITEA_METRICS_TOKEN | Metrics access token | Auto-generated |
| CODE_GITEA_RUNNER_TOKEN | Actions runner token | Manual (from Gitea UI) |

## Deployment Steps

### 1. Generate the Stack

```bash
./kompose-generate.sh code
```

### 2. Review Configuration

Edit the generated files in the `code/` directory:
- `.env` - Environment variables
- Add your domain configuration
- Adjust SSH port if needed

### 3. Start Dependencies

```bash
docker compose -f core/compose.yaml up -d
docker compose -f proxy/compose.yaml up -d
```

### 4. Start Code Stack

```bash
docker compose -f code/compose.yaml up -d
```

### 5. Initial Setup

Access Gitea and complete the setup wizard:
- URL: https://git.yourdomain.com
- Database Type: PostgreSQL (pre-configured)
- Create admin account
- Complete installation

### 6. Configure Actions Runner

After Gitea is running:

1. Login to Gitea as admin
2. Navigate to: Site Administration → Actions → Runners
3. Click "Create new Runner"
4. Copy the registration token
5. Add to `secrets.env`:
   ```bash
   CODE_GITEA_RUNNER_TOKEN=your_token_here
   ```
6. Restart the stack:
   ```bash
   docker compose -f code/compose.yaml restart gitea-runner
   ```

### 7. Setup SSH Access

Configure SSH for git operations:

```bash
# Add your SSH key in Gitea user settings
# Test connection
ssh -T -p 2222 git@git.yourdomain.com
```

## Using Gitea Actions

### Basic CI/CD Workflow

Create `.gitea/workflows/ci.yaml` in your repository:

```yaml
name: CI Pipeline
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
      - name: Install dependencies
        run: npm ci
      - name: Run tests
        run: npm test
```

### Example Workflows Included

The template includes two example workflows in `.gitea/workflows/`:

1. **ci-cd.yaml** - Complete CI/CD pipeline with:
   - Build and test job
   - Deployment trigger via n8n webhook
   - Security scanning with npm audit
   - Gotify notifications

2. **deploy-infrastructure.yaml** - Infrastructure deployment with:
   - Ansible playbook validation
   - Semaphore task trigger
   - Deployment monitoring
   - Status updates to n8n

## Access URLs

- Gitea Web UI: `https://git.yourdomain.com`
- SSH (git operations): `ssh://git@git.yourdomain.com:2222`
- Metrics: `https://git.yourdomain.com/metrics` (requires token)

## Health Checks

Check service health:

```bash
# Gitea
curl http://localhost:3000/api/healthz

# Check runner status in Gitea UI
# Site Administration → Actions → Runners
```

## Troubleshooting

### Gitea Won't Start

**Symptoms**: Container exits or restarts repeatedly

**Solutions**:
1. Verify database connection:
   ```bash
   docker compose -f core/compose.yaml ps
   ```
2. Check database password in secrets.env
3. View logs:
   ```bash
   docker logs code_gitea
   ```
4. Verify database was created:
   ```bash
   docker exec -it core_postgres psql -U kompose -l
   ```

### SSH Not Working

**Symptoms**: Cannot clone/push via SSH

**Solutions**:
1. Verify port 2222 is not in use:
   ```bash
   netstat -an | grep 2222
   ```
2. Check firewall rules allow port 2222
3. Ensure SSH key is added in Gitea user settings
4. Test connection:
   ```bash
   ssh -T -p 2222 git@git.yourdomain.com -v
   ```
5. Check Gitea SSH configuration:
   ```bash
   docker logs code_gitea | grep -i ssh
   ```

### Actions Runner Not Registering

**Symptoms**: Runner doesn't appear in Gitea UI

**Solutions**:
1. Verify CODE_GITEA_RUNNER_TOKEN is set correctly
2. Check runner token hasn't expired
3. Ensure Gitea is accessible from runner container:
   ```bash
   docker exec code_gitea_runner curl -I http://gitea:3000
   ```
4. Check runner logs:
   ```bash
   docker logs code_gitea_runner
   ```
5. Regenerate token in Gitea UI if expired

### Webhooks Failing

**Symptoms**: Webhook deliveries fail or timeout

**Solutions**:
1. Verify webhook URL is accessible from Gitea container
2. Check CODE_GITEA_WEBHOOK_ALLOWED_HOSTS setting
3. For self-signed certificates, set:
   ```bash
   CODE_GITEA_WEBHOOK_SKIP_TLS=true
   ```
4. Test webhook delivery in repository settings
5. Check webhook logs in repository settings

### Actions Failing

**Symptoms**: Workflows fail to run or timeout

**Solutions**:
1. Verify runner is online in Gitea UI
2. Check runner has access to Docker socket
3. Ensure runner labels match workflow requirements
4. View workflow logs in Gitea UI
5. Check runner container logs:
   ```bash
   docker logs -f code_gitea_runner
   ```

## Security Considerations

1. **Use HTTPS in Production**
   - Set `PROTOCOL=https` in .env
   - Ensure valid SSL certificates

2. **SSH Port**
   - Change default port 2222 if exposed to internet
   - Use firewall rules to restrict access
   - Consider using SSH key authentication only

3. **User Registration**
   - Set `CODE_GITEA_DISABLE_REGISTRATION=true` in production
   - Manually create user accounts as needed

4. **Content Access**
   - Set `CODE_GITEA_REQUIRE_SIGNIN=true` for private repositories
   - Configure repository visibility settings
   - Use teams and organizations for access control

5. **Secure Secrets**
   - Never commit secrets.env to git
   - Use strong, unique passwords
   - Rotate secrets regularly
   - Store sensitive secrets in Gitea Actions secrets

6. **Runner Security**
   - Isolate runners from production systems
   - Use separate runners for different security zones
   - Regularly update runner images
   - Monitor runner resource usage

7. **Webhook Security**
   - Limit CODE_GITEA_WEBHOOK_ALLOWED_HOSTS in production
   - Use webhook secrets for verification
   - Validate webhook payloads

## Advanced Configuration

### Custom Domain for SSH

If your SSH domain differs from web domain:

```bash
GITEA_SSH_DOMAIN=git-ssh.yourdomain.com
```

### Email Notifications

Configure SMTP settings in compose.yaml or use messaging stack:

```yaml
EMAIL_SMTP_HOST=messaging_mailhog
EMAIL_SMTP_PORT=1025
EMAIL_FROM=gitea@yourdomain.com
```

### LFS (Large File Storage)

Enable Git LFS for large files:

1. Gitea automatically enables LFS
2. Configure in repository settings
3. Use in repositories:
   ```bash
   git lfs install
   git lfs track "*.psd"
   git add .gitattributes
   ```

### Repository Mirroring

Mirror external repositories:

1. Gitea UI → New Repository
2. Select "Migrate from..."
3. Enter source repository URL
4. Enable "This repository will be a mirror"
5. Configure sync interval

### OAuth2 Applications

Use Gitea as OAuth2 provider:

1. Settings → Applications → OAuth2 Applications
2. Create new application
3. Configure redirect URIs
4. Use client credentials in other services

### Custom Runner Labels

Add custom runner labels for specific jobs:

```yaml
CODE_GITEA_RUNNER_LABELS=ubuntu-latest:docker://node:18,python:docker://python:3.11
```

Use in workflows:
```yaml
jobs:
  test:
    runs-on: python
```

## Integration Examples

### Webhook to n8n

Configure in repository settings:
- Webhook URL: `http://chain_n8n:5678/webhook/gitea-push`
- Events: Push, Pull Request
- Secret: Set in n8n workflow

### Deployment via Semaphore

See included workflow: `.gitea/workflows/deploy-infrastructure.yaml`

### Notifications via Gotify

Add to workflow:
```yaml
- name: Send notification
  run: |
    curl -X POST "${{ secrets.GOTIFY_URL }}/message" \
      -H "X-Gotify-Key: ${{ secrets.GOTIFY_TOKEN }}" \
      -F "title=Build Complete" \
      -F "message=Repository: ${{ github.repository }}"
```

## Monitoring

### Metrics

Gitea exposes Prometheus metrics:
- Endpoint: `/metrics`
- Requires CODE_GITEA_METRICS_TOKEN
- Configure in watch stack

### Health Checks

Built-in health endpoints:
- Gitea: http://localhost:3000/api/healthz
- Check via: `docker compose -f code/compose.yaml ps`

### Logging

View logs:
```bash
# Gitea logs
docker logs -f code_gitea

# Runner logs
docker logs -f code_gitea_runner

# All services
docker compose -f code/compose.yaml logs -f
```

## Backup and Recovery

### Backup Repositories

```bash
# Backup all data
docker run --rm \
  -v code_gitea_data:/data \
  -v $(pwd)/backups:/backup \
  alpine tar czf /backup/gitea-data-$(date +%Y%m%d).tar.gz /data

# Backup database
./kompose.sh db backup -d gitea
```

### Restore

```bash
# Restore data
docker run --rm \
  -v code_gitea_data:/data \
  -v $(pwd)/backups:/backup \
  alpine tar xzf /backup/gitea-data-YYYYMMDD.tar.gz -C /

# Restore database
./kompose.sh db restore -f backups/gitea-YYYYMMDD.sql -d gitea
```

### Export/Import Repositories

Using Gitea CLI:
```bash
# Export repository
docker exec code_gitea gitea dump -c /data/gitea/conf/app.ini

# Import (restore from dump file)
docker exec code_gitea gitea restore --from /data/gitea-dump.zip
```

## Performance Tuning

### For High-Traffic Installations

1. **Increase Redis Cache**
   - Adjust CORE_REDIS_MAXMEMORY in core stack

2. **Enable Repository Indexing**
   - Gitea Admin → Configuration → Indexer
   - Enable code search

3. **Configure Object Storage**
   - Use external storage for repositories
   - Reduces local disk I/O

4. **Scale Actions Runners**
   - Deploy multiple runners
   - Use different labels for load distribution

5. **Database Optimization**
   - Increase PostgreSQL connections
   - Enable query caching
   - Regular VACUUM operations

## Related Documentation

- [Gitea Documentation](https://docs.gitea.io/)
- [Gitea Actions Documentation](https://docs.gitea.io/en-us/actions/)
- [Git LFS Documentation](https://git-lfs.github.com/)
- [Docker Socket Security](https://docs.docker.com/engine/security/)

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Review logs: `docker logs code_gitea` or `docker logs code_gitea_runner`
3. Consult the official Gitea documentation
4. Check kompose repository issues

## Template Version

- Version: 1.0.0
- Last Updated: 2025-10-14
- Compatible with: Kompose 1.x
- Gitea Version: Latest
