# Chain Stack Template

This template provides a complete, production-ready workflow automation and infrastructure orchestration solution using n8n and Semaphore.

## Overview

The Chain stack consists of:
- **n8n**: Visual workflow automation platform with 200+ integrations
- **Semaphore**: Modern Ansible UI and task runner
- **Semaphore Runner**: Task execution worker

## Quick Start

Generate this stack using kompose-generate.sh:

```bash
./kompose-generate.sh chain
```

This will:
1. Create the chain stack directory if it doesn't exist
2. Copy all template files
3. Generate environment variables from kompose.yml
4. Generate secrets
5. Prepare the stack for deployment

## Files in this Template

- `kompose.yml` - Complete stack configuration with all variables and secrets defined
- `compose.yaml` - Docker Compose configuration
- `.env.example` - Example environment file (will be generated from kompose.yml)
- `README.md` - This file

## Requirements

Before deploying this stack, ensure these stacks are running:
- **core** - Provides PostgreSQL for data storage
- **proxy** - Provides Traefik for routing

## Configuration

All configuration is defined in `kompose.yml`. Key settings:

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| CHAIN_COMPOSE_PROJECT_NAME | chain | Stack project name |
| CHAIN_N8N_IMAGE | n8nio/n8n:latest | n8n Docker image |
| CHAIN_N8N_DB_NAME | n8n | n8n database name |
| CHAIN_N8N_BASIC_AUTH_USER | admin | n8n login username |
| CHAIN_SEMAPHORE_IMAGE | semaphoreui/semaphore:latest | Semaphore image |
| CHAIN_SEMAPHORE_DB_NAME | semaphore | Semaphore database name |
| CHAIN_SEMAPHORE_ADMIN_USERNAME | admin | Semaphore login username |
| SUBDOMAIN_CHAIN | workflow | n8n subdomain |
| SUBDOMAIN_AUTO | auto | Semaphore subdomain |

### Secrets

| Secret | Description | Generation |
|--------|-------------|------------|
| DB_PASSWORD | Database password (shared) | Auto-generated |
| CHAIN_N8N_ENCRYPTION_KEY | n8n credential encryption | Auto-generated |
| CHAIN_N8N_BASIC_AUTH_PASSWORD | n8n web UI password | Auto-generated |
| CHAIN_SEMAPHORE_ADMIN_PASSWORD | Semaphore admin password | Auto-generated |
| CHAIN_SEMAPHORE_RUNNER_TOKEN | Runner registration token | Manual (from Semaphore UI) |
| EMAIL_SMTP_PASSWORD | Email notifications | Manual |

## Deployment Steps

### 1. Generate the Stack

```bash
./kompose-generate.sh chain
```

### 2. Review Configuration

Edit the generated files in the `chain/` directory:
- `.env` - Environment variables
- Add your domain configuration

### 3. Start Dependencies

```bash
docker compose -f core/compose.yaml up -d
docker compose -f proxy/compose.yaml up -d
```

### 4. Start Chain Stack

```bash
docker compose -f chain/compose.yaml up -d
```

### 5. Access n8n

Access the n8n interface:
- URL: https://workflow.yourdomain.com
- Username: admin (from CHAIN_N8N_BASIC_AUTH_USER)
- Password: [from CHAIN_N8N_BASIC_AUTH_PASSWORD in secrets.env]

### 6. Access Semaphore

Access the Semaphore interface:
- URL: https://auto.yourdomain.com
- Username: admin (from CHAIN_SEMAPHORE_ADMIN_USERNAME)
- Password: [from CHAIN_SEMAPHORE_ADMIN_PASSWORD in secrets.env]

### 7. Configure Semaphore Runner

After accessing Semaphore:
1. Go to Settings → Runner Registration
2. Copy the registration token
3. Add it to `secrets.env` as `CHAIN_SEMAPHORE_RUNNER_TOKEN`
4. Restart the runner:
   ```bash
   docker compose -f chain/compose.yaml restart semaphore-runner
   ```

## Using n8n

### Creating Your First Workflow

1. Access n8n UI at https://workflow.yourdomain.com
2. Click "Add workflow"
3. Click "+" to add nodes
4. Connect nodes by dragging between them
5. Configure each node's settings
6. Test with "Execute Workflow"
7. Activate the workflow

### Common Workflow Patterns

**Schedule-based automation:**
- Schedule Trigger → HTTP Request → Email

**Webhook automation:**
- Webhook Trigger → Process Data → Database Insert

**API integration:**
- HTTP Request → Transform Data → Multiple Actions

### Webhook URLs

Your webhooks are accessible at:
- Production: `https://workflow.yourdomain.com/webhook/your-path`
- Test: `https://workflow.yourdomain.com/webhook-test/your-path`

## Using Semaphore

### Creating Your First Project

1. Access Semaphore UI at https://auto.yourdomain.com
2. Click "New Project"
3. Configure Git repository (optional)
4. Add SSH keys or access tokens if using Git
5. Create an environment
6. Define task templates with your Ansible playbooks

### Running Tasks

1. Select your project
2. Choose a task template
3. Select the environment
4. Review variables and inventory
5. Click "Run"

### Scheduling Tasks

1. Create a task template
2. Click "Schedule"
3. Enter cron expression (e.g., `0 2 * * *` for 2 AM daily)
4. Configure email notifications
5. Save the schedule

## Access URLs

- n8n: `https://workflow.yourdomain.com`
- Semaphore: `https://auto.yourdomain.com`

## Health Checks

Check service health:

```bash
# n8n
curl http://localhost:5678/healthz

# Semaphore
curl http://localhost:3000/api/ping
```

## Troubleshooting

### n8n Won't Start

**Symptoms**: Container exits or restarts repeatedly

**Solutions**:
1. Verify database connection:
   ```bash
   docker compose -f core/compose.yaml ps
   ```
2. Check database password in secrets.env
3. Ensure CHAIN_N8N_ENCRYPTION_KEY is set
4. View logs:
   ```bash
   docker logs chain_n8n
   ```

### n8n Workflows Not Executing

**Symptoms**: Workflows don't run when triggered

**Solutions**:
1. Verify workflow is activated (toggle switch in UI)
2. Check execution history in UI
3. Verify webhook URLs are accessible
4. Check database connectivity
5. Review workflow credentials

### Semaphore Won't Start

**Symptoms**: Container exits or restarts repeatedly

**Solutions**:
1. Verify database connection
2. Check admin credentials are set
3. Verify email configuration
4. View logs:
   ```bash
   docker logs chain_semaphore
   ```

### Semaphore Runner Not Connecting

**Symptoms**: Runner shows as offline in UI

**Solutions**:
1. Generate registration token in Semaphore UI first
2. Verify CHAIN_SEMAPHORE_RUNNER_TOKEN is set correctly
3. Check runner logs:
   ```bash
   docker logs chain_semaphore_runner
   ```
4. Ensure runner can reach semaphore service (same network)

### Email Notifications Not Working

**Symptoms**: No emails being sent

**Solutions**:
1. Verify SMTP credentials in secrets.env
2. Check EMAIL_SMTP_HOST and EMAIL_SMTP_PORT
3. Test SMTP connection manually
4. Review service logs for SMTP errors:
   ```bash
   docker logs chain_n8n | grep -i smtp
   docker logs chain_semaphore | grep -i email
   ```

## Security Best Practices

1. **Use HTTPS in Production**
   - Set `PROTOCOL=https` in .env
   - Ensure valid SSL certificates via Traefik

2. **Secure Secrets**
   - Never commit secrets.env to git
   - Use strong, unique passwords
   - Keep CHAIN_N8N_ENCRYPTION_KEY secure and never change it
   - Rotate other secrets regularly

3. **Webhook Security**
   - Use authentication for webhooks when possible
   - Consider using webhook tokens
   - Monitor webhook usage

4. **Ansible Security**
   - Use Ansible Vault for sensitive playbook variables
   - Secure inventory files
   - Review playbook permissions
   - Limit SSH key access

## Advanced Configuration

### n8n Custom Nodes

To add custom n8n nodes:

1. Create custom node directory
2. Add to compose.yaml:
   ```yaml
   volumes:
     - n8n_data:/home/node/.n8n
     - ./custom-nodes:/home/node/.n8n/custom
   ```
3. Restart n8n

### Semaphore Git Integration

Configure Git repository integration:

1. In project settings, add repository URL
2. Add SSH key or access token
3. Configure branch/tag to track
4. Enable auto-sync for automatic updates

### Email Templates

Customize email notifications:
- **n8n**: Configure in Email node settings
- **Semaphore**: Configure in task template settings

### Integration with Auth Stack

To enable SSO (requires auth stack):

For n8n:
```yaml
labels:
  - 'traefik.http.routers.chain-n8n-web-secure.middlewares=kompose-sso'
```

For Semaphore:
```yaml
labels:
  - 'traefik.http.routers.chain-semaphore-web-secure.middlewares=kompose-sso'
```

## Monitoring

### View Logs

```bash
# n8n logs
docker logs -f chain_n8n

# Semaphore logs
docker logs -f chain_semaphore

# Runner logs
docker logs -f chain_semaphore_runner
```

### Execution History

- **n8n**: View in UI → Executions tab
- **Semaphore**: View in UI → Task History

### Health Endpoints

Monitor service health:
- n8n: http://localhost:5678/healthz
- Semaphore: http://localhost:3000/api/ping

## Backup and Recovery

### Backup

Both n8n and Semaphore store data in PostgreSQL:

```bash
# Backup n8n database
docker exec core_postgres pg_dump -U kompose n8n > backups/n8n-$(date +%Y%m%d).sql

# Backup Semaphore database
docker exec core_postgres pg_dump -U kompose semaphore > backups/semaphore-$(date +%Y%m%d).sql

# Backup Semaphore volumes
docker run --rm -v chain_semaphore_data:/data -v $(pwd)/backups:/backup \
  alpine tar czf /backup/semaphore-data-$(date +%Y%m%d).tar.gz -C /data .
```

### Restore

```bash
# Restore n8n database
docker exec -i core_postgres psql -U kompose n8n < backups/n8n-YYYYMMDD.sql

# Restore Semaphore database
docker exec -i core_postgres psql -U kompose semaphore < backups/semaphore-YYYYMMDD.sql

# Restore Semaphore volumes
docker run --rm -v chain_semaphore_data:/data -v $(pwd)/backups:/backup \
  alpine tar xzf /backup/semaphore-data-YYYYMMDD.tar.gz -C /data
```

### Export/Import Workflows

**n8n workflows:**
- Export: Use "Download" in workflow menu
- Import: Use "Import from File" in n8n UI

**Semaphore projects:**
- Export: Use project backup in UI
- Import: Use project restore in UI

## Performance Tuning

### n8n Performance

- Configure execution timeout limits
- Adjust execution data retention
- Use queue mode for high-volume workflows
- Monitor database size

### Semaphore Performance

- Add more runners for parallel execution
- Configure task timeout limits
- Use task queuing for large deployments
- Optimize Ansible playbooks

## Related Documentation

- [n8n Documentation](https://docs.n8n.io/)
- [Semaphore Documentation](https://docs.semaphoreui.com/)
- [Ansible Documentation](https://docs.ansible.com/)
- [Traefik Documentation](https://doc.traefik.io/traefik/)

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Review logs: `docker logs chain_n8n` or `docker logs chain_semaphore`
3. Consult the official documentation
4. Check kompose repository issues

## Template Version

- Version: 1.0.0
- Last Updated: 2025-10-14
- Compatible with: Kompose 1.x
