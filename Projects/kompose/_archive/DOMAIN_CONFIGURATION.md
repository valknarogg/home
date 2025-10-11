# Kompose Domain Configuration Guide

## Overview

Kompose uses a centralized domain configuration system that makes it easy to deploy your entire infrastructure under any domain name. All service hostnames are automatically generated from a single `ROOT_DOMAIN` variable.

## Quick Start

### 1. Set Your Domain

Edit `domain.env`:

```bash
ROOT_DOMAIN=yourdomain.com
```

That's it! All services will automatically be available at:
- `proxy.yourdomain.com`
- `auth.yourdomain.com`
- `chain.yourdomain.com`
- ... and so on

### 2. Configure DNS

You have two options:

**Option A: Wildcard DNS (Recommended)**
```
*.yourdomain.com  →  your-server-ip
```

**Option B: Individual A Records**
```
proxy.yourdomain.com  →  your-server-ip
auth.yourdomain.com   →  your-server-ip
chain.yourdomain.com  →  your-server-ip
... (for each service)
```

### 3. Start Services

```bash
./kompose.sh up
```

SSL certificates will be automatically issued by Let's Encrypt.

## Configuration Files

### domain.env

This is the main configuration file for all domain settings:

```bash
# Root domain for all services
ROOT_DOMAIN=yourdomain.com

# Customize individual subdomains (optional)
SUBDOMAIN_PROXY=proxy
SUBDOMAIN_AUTH=auth
SUBDOMAIN_CHAIN=n8n      # Changed from 'chain'
SUBDOMAIN_CODE=git        # Changed from 'code'
# ... etc
```

### .env (Root Configuration)

The root `.env` file automatically builds service hostnames:

```bash
# Import domain configuration
include domain.env

# Generated hostnames (automatic)
TRAEFIK_HOST_PROXY=${SUBDOMAIN_PROXY}.${ROOT_DOMAIN}
TRAEFIK_HOST_AUTH=${SUBDOMAIN_AUTH}.${ROOT_DOMAIN}
# ... etc
```

**You don't need to edit the hostname variables** - they're automatically generated from `domain.env`.

## Available Services

Each service gets its own subdomain under your `ROOT_DOMAIN`:

| Service | Default Subdomain | Purpose |
|---------|------------------|---------|
| Proxy | `proxy` | Traefik reverse proxy & dashboard |
| Auth | `auth` | Keycloak SSO authentication |
| SSO | `sso` | OAuth2 Proxy for SSO |
| Chain | `chain` | n8n workflow automation |
| Auto | `auto` | Semaphore Ansible automation |
| Code | `code` | Gitea git repository |
| Docs | `docs` | Documentation site |
| Blog | `blog` | Blog platform |
| News | `news` | Newsletter platform |
| Chat | `chat` | Gotify notifications |
| Mail | `mail` | Mailhog email testing |
| Dash | `dash` | Dashboard |
| Data | `data` | Data warehouse |
| Track | `umami` | Umami analytics |
| Trace | `trace` | Tracing/monitoring |
| Home | `home` | Home Assistant |
| Sexy | `sexy` | Directus headless CMS |
| Vault | `vault` | Vaultwarden password manager |
| Link | `link` | Link shortener |
| Dock | `dock` | Docker registry |
| VPN | `vpn` | WireGuard VPN |

## Customizing Subdomains

You can customize any subdomain in `domain.env`:

```bash
# Change subdomain names to match your preference
SUBDOMAIN_CHAIN=workflows    # Instead of 'chain'
SUBDOMAIN_CODE=git           # Instead of 'code'
SUBDOMAIN_SEXY=cms           # Instead of 'sexy'
SUBDOMAIN_TRACK=analytics    # Instead of 'umami'
```

After changing subdomains:
1. Restart services: `./kompose.sh restart`
2. Update DNS records if needed

## Multiple Domains / Environments

You can maintain different configurations for different environments:

```bash
# Production
cp domain.env domain.prod.env
# Edit domain.prod.env: ROOT_DOMAIN=example.com

# Staging
cp domain.env domain.staging.env
# Edit domain.staging.env: ROOT_DOMAIN=staging.example.com

# Development
cp domain.env domain.dev.env
# Edit domain.dev.env: ROOT_DOMAIN=dev.example.local
```

Use environment-specific files:
```bash
# Use staging configuration
ln -sf domain.staging.env domain.env
./kompose.sh up
```

## SSL/TLS Certificates

### Automatic SSL with Let's Encrypt

Traefik automatically obtains SSL certificates from Let's Encrypt for all configured domains.

**Requirements:**
1. Domain must be publicly accessible
2. Ports 80 and 443 must be open
3. DNS must be properly configured
4. Valid email in `domain.env` (`ACME_EMAIL`)

### Testing with Staging Certificates

To avoid Let's Encrypt rate limits during testing, use staging certificates:

Edit `proxy/compose.yaml`:
```yaml
# Uncomment this line:
- '--certificatesresolvers.resolver.acme.caserver=https://acme-staging-v02.api.letsencrypt.org/directory'
```

**Remember to switch back to production certificates** by removing this line.

### Manual Certificates

If you have your own certificates, you can configure Traefik to use them:

1. Place certificates in `proxy/certs/`
2. Update `proxy/dynamic/certificates.yaml`
3. Restart proxy: `./kompose.sh restart proxy`

## Troubleshooting

### Services not accessible

**Check DNS:**
```bash
# Test DNS resolution
dig proxy.yourdomain.com
nslookup auth.yourdomain.com
```

**Check Traefik:**
```bash
# View Traefik logs
./kompose.sh logs proxy

# Check dashboard
https://proxy.yourdomain.com/dashboard/
```

### SSL Certificate Issues

**Certificate not issued:**
```bash
# Check Traefik logs for ACME errors
./kompose.sh logs proxy | grep -i acme

# Verify Let's Encrypt challenge
curl -v http://yourdomain.com/.well-known/acme-challenge/test
```

**Rate limit exceeded:**
- Use staging certificates for testing
- Wait for rate limit to reset (weekly)
- Ensure DNS is correct before requesting certificates

### Domain changes not applying

```bash
# Reload configuration
./kompose.sh down
./kompose.sh up

# Or restart specific stack
./kompose.sh restart proxy
./kompose.sh restart auth
```

## Migration from Old Configuration

If you're upgrading from an older Kompose version with hardcoded domains:

```bash
# Run migration script
./migrate-domain-config.sh
```

This will:
1. Detect your current domain
2. Create `domain.env` with your settings
3. Backup old configuration
4. Update configuration files

## Security Considerations

### Internal Services

Some services should not be publicly accessible. Use Traefik middleware to restrict access:

```yaml
labels:
  - 'traefik.http.routers.myservice.middlewares=internal-only'
```

See `proxy/dynamic/` for middleware configurations.

### Firewall Rules

Ensure your firewall allows:
- Port 80 (HTTP) - for Let's Encrypt validation
- Port 443 (HTTPS) - for all services
- Port 22 (SSH) - for server access

Block direct access to service ports (e.g., 5678, 3000, 8080).

## Advanced Configuration

### Custom Ports

To expose a service on a custom port:

```yaml
labels:
  - 'traefik.http.routers.myservice.entrypoints=customport'
  
# In proxy/compose.yaml, add entrypoint:
command:
  - '--entrypoints.customport.address=:8443'

ports:
  - "8443:8443"
```

### Multiple Domains per Service

To make a service available on multiple domains:

```yaml
labels:
  - 'traefik.http.routers.myservice.rule=Host(`service.domain1.com`) || Host(`service.domain2.com`)'
```

### Path-based Routing

Route different paths to different services:

```yaml
# Service 1
labels:
  - 'traefik.http.routers.api.rule=Host(`yourdomain.com`) && PathPrefix(`/api`)'

# Service 2
labels:
  - 'traefik.http.routers.web.rule=Host(`yourdomain.com`) && PathPrefix(`/`)'
```

## FAQ

**Q: Can I use an IP address instead of a domain?**  
A: Yes, but you won't get SSL certificates from Let's Encrypt. Use self-signed certificates instead.

**Q: Can I use a subdomain as my ROOT_DOMAIN?**  
A: Yes, for example: `ROOT_DOMAIN=services.example.com` will create `proxy.services.example.com`, etc.

**Q: How do I add a new service?**  
A: Add a new `SUBDOMAIN_*` variable in `domain.env`, then add the corresponding `TRAEFIK_HOST_*` in `.env`.

**Q: Can I use different domains for different services?**  
A: Yes, override `TRAEFIK_HOST_*` variables in individual stack `.env` files.

**Q: How do I disable a service?**  
A: Comment out or remove its subdomain configuration, or set `TRAEFIK_ENABLED=false` in its stack `.env`.

## Support

For issues or questions:
1. Check the [Troubleshooting](#troubleshooting) section
2. Review Traefik logs: `./kompose.sh logs proxy`
3. Check service logs: `./kompose.sh logs <stack-name>`
4. Validate configuration: `./kompose.sh validate`

## Related Documentation

- [Quick Start Guide](QUICK_START.md)
- [Secret Management](SECRET_MANAGEMENT.md)
- [Stack Reference](STACK_REFERENCE.md)
- [Traefik Configuration](proxy/README.md)
