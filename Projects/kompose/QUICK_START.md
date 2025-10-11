# Kompose Quick Start Guide

Get your complete self-hosted infrastructure running in under 15 minutes!

## Prerequisites

- **Linux Server** (Ubuntu 20.04+, Debian 11+, or similar)
- **Docker** & **Docker Compose** installed
- **Domain Name** with access to DNS configuration
- **Root/sudo access** to the server
- **Minimum 4GB RAM**, 20GB disk space

## Installation Steps

### 1. Install Docker (if not already installed)

```bash
# Install Docker
curl -fsSL https://get.docker.com | sh

# Add your user to docker group
sudo usermod -aG docker $USER

# Start Docker
sudo systemctl enable docker
sudo systemctl start docker

# Re-login for group changes to take effect
# or run: newgrp docker
```

### 2. Clone Kompose Repository

```bash
# Clone the repository
git clone https://github.com/yourusername/kompose.git
cd kompose

# Make scripts executable
chmod +x kompose.sh
chmod +x cleanup-project.sh
chmod +x migrate-domain-config.sh
```

### 3. Configure Your Domain

Edit `domain.env`:

```bash
# Change this to your domain
ROOT_DOMAIN=example.com

# Optionally customize subdomains
# SUBDOMAIN_PROXY=proxy
# SUBDOMAIN_AUTH=auth
# ... etc
```

**Important:** Update the email for Let's Encrypt:

```bash
ACME_EMAIL=admin@example.com
```

### 4. Configure DNS

**Option A: Wildcard DNS (Easiest)**

Add a wildcard DNS A record pointing to your server:

```
*.example.com  →  your-server-ip
```

**Option B: Individual Subdomains**

Add A records for each service:

```
proxy.example.com  →  your-server-ip
auth.example.com   →  your-server-ip
chain.example.com  →  your-server-ip
code.example.com   →  your-server-ip
# ... etc
```

### 5. Generate Secrets

```bash
# Generate all required secrets automatically
./kompose.sh secrets generate

# This creates a secrets.env file with secure random passwords
```

**Manual alternative:**

```bash
# Copy template
cp secrets.env.template secrets.env

# Edit and replace all CHANGE_ME values
nano secrets.env
```

### 6. Create Docker Network

```bash
# Create the shared network for all services
docker network create kompose
```

### 7. Start Core Services

```bash
# Start core infrastructure (database, cache, messaging)
./kompose.sh up core

# Wait for services to be healthy (~30 seconds)
./kompose.sh status core
```

### 8. Start Proxy (Traefik)

```bash
# Start reverse proxy and SSL
./kompose.sh up proxy

# Check Traefik dashboard (local access only)
# http://localhost:8080/dashboard/
```

**Wait for SSL certificates** to be issued (~1-2 minutes). Check logs:

```bash
./kompose.sh logs proxy
```

Look for messages like:
```
Certificate obtained for domain [proxy.example.com]
```

### 9. Start Authentication (Optional but Recommended)

```bash
# Start Keycloak SSO
./kompose.sh up auth

# Access at: https://auth.example.com
# Default admin: admin / <check secrets.env for KC_ADMIN_PASSWORD>
```

### 10. Start Additional Services

```bash
# Start workflow automation
./kompose.sh up chain

# Start code repository
./kompose.sh up code

# Start all services
./kompose.sh up
```

## First-Time Access

### Traefik Dashboard
- **URL**: `http://localhost:8080/dashboard/`
- **Note**: Only accessible from localhost for security
- **Auth**: Set in `secrets.env` as `TRAEFIK_DASHBOARD_AUTH`

### Keycloak (SSO)
- **URL**: `https://auth.example.com`
- **Username**: `admin`
- **Password**: Check `secrets.env` → `KC_ADMIN_PASSWORD`

### n8n (Workflow Automation)
- **URL**: `https://chain.example.com`
- **Username**: Set in `chain/.env` → `N8N_BASIC_AUTH_USER`
- **Password**: Check `secrets.env` → `N8N_BASIC_AUTH_PASSWORD`

### Gitea (Code Repository)
- **URL**: `https://code.example.com`
- **First-time setup**: Create admin account on first visit

## Verification

### Check all services are running:

```bash
./kompose.sh status
```

### Check SSL certificates:

```bash
# Should show valid certificate
curl -v https://proxy.example.com 2>&1 | grep "SSL certificate verify ok"
```

### Test a service:

```bash
# Check if service is accessible
curl -I https://chain.example.com
```

## Common Issues

### Issue: Services not accessible

**Solution:** Check DNS propagation:
```bash
# Test DNS resolution
dig proxy.example.com
nslookup auth.example.com
```

Wait for DNS propagation (can take up to 24 hours, usually much faster).

### Issue: SSL certificate errors

**Solution 1:** Check Let's Encrypt logs:
```bash
./kompose.sh logs proxy | grep -i acme
```

**Solution 2:** Use staging certificates for testing:

Edit `proxy/compose.yaml` and uncomment the staging server line, then restart:
```bash
./kompose.sh restart proxy
```

### Issue: Port 80 or 443 already in use

**Solution:** Stop conflicting services:
```bash
# Find what's using the port
sudo lsof -i :80
sudo lsof -i :443

# Stop Apache (example)
sudo systemctl stop apache2

# Or Nginx
sudo systemctl stop nginx
```

### Issue: Permission denied

**Solution:** Add user to docker group:
```bash
sudo usermod -aG docker $USER
newgrp docker
```

## Next Steps

### 1. Configure Services

Each service has its own `.env` file for configuration:

```bash
# Example: Configure n8n
nano chain/.env

# Restart after changes
./kompose.sh restart chain
```

### 2. Set Up SSO (Single Sign-On)

Configure Keycloak for unified authentication across all services. See [SSO_INTEGRATION_GUIDE.md](SSO_INTEGRATION_GUIDE.md).

### 3. Configure Backups

```bash
# Backup all databases
./kompose.sh db backup

# List backups
./kompose.sh db list
```

### 4. Explore Services

Visit your services and complete their initial setup:

- **n8n**: Create workflows, connect to services
- **Gitea**: Create repositories, set up Actions
- **Keycloak**: Configure realms, users, and clients
- **Home Assistant**: Connect IoT devices

### 5. Add Custom Services

1. Copy an existing stack as template
2. Update `compose.yaml` with your service
3. Add Traefik labels for routing
4. Update `domain.env` with new subdomain
5. Start: `./kompose.sh up myservice`

## Security Checklist

- [ ] Change all default passwords in `secrets.env`
- [ ] Enable UFW firewall:
  ```bash
  sudo ufw allow 22   # SSH
  sudo ufw allow 80   # HTTP
  sudo ufw allow 443  # HTTPS
  sudo ufw enable
  ```
- [ ] Set up fail2ban for SSH protection
- [ ] Enable automatic security updates
- [ ] Regular backups: `./kompose.sh db backup`
- [ ] Monitor logs: `./kompose.sh logs`
- [ ] Use strong passwords (generated by kompose)
- [ ] Restrict Traefik dashboard to localhost
- [ ] Set up VPN for admin access (optional)

## Maintenance

### Update Services

```bash
# Pull latest images
./kompose.sh pull

# Restart with new images
./kompose.sh restart
```

### View Logs

```bash
# All services
./kompose.sh logs

# Specific service
./kompose.sh logs chain

# Follow logs in real-time
./kompose.sh logs chain -f
```

### Restart Services

```bash
# Restart all
./kompose.sh restart

# Restart specific stack
./kompose.sh restart chain
```

### Stop Services

```bash
# Stop all
./kompose.sh down

# Stop specific stack
./kompose.sh down chain
```

## Getting Help

1. **Check Documentation**: [DOMAIN_CONFIGURATION.md](DOMAIN_CONFIGURATION.md)
2. **View Logs**: `./kompose.sh logs <stack>`
3. **Validate Configuration**: `./kompose.sh validate`
4. **Check Status**: `./kompose.sh status`

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                         Internet                             │
└────────────────────────┬────────────────────────────────────┘
                         │
                         │ HTTPS (443)
                         │
               ┌─────────▼──────────┐
               │  Traefik Proxy      │ ← proxy.example.com
               │  (SSL Termination)  │
               └─────────┬──────────┘
                         │
         ┌───────────────┼───────────────┐
         │               │               │
    ┌────▼────┐    ┌────▼────┐    ┌────▼────┐
    │  Auth   │    │ Chain   │    │  Code   │
    │Keycloak │    │   n8n   │    │  Gitea  │
    └────┬────┘    └────┬────┘    └────┬────┘
         │              │              │
         └──────────────┼──────────────┘
                        │
                 ┌──────▼───────┐
                 │   Core Stack  │
                 │  - Postgres   │
                 │  - Redis      │
                 │  - MQTT       │
                 └──────────────┘
```

## Service Stack Overview

| Stack | Services | Purpose |
|-------|----------|---------|
| **core** | Postgres, Redis, MQTT | Database, cache, messaging |
| **proxy** | Traefik | Reverse proxy, SSL, routing |
| **auth** | Keycloak, OAuth2 Proxy | Authentication, SSO |
| **chain** | n8n, Semaphore | Workflow automation, Ansible |
| **code** | Gitea | Git repository, CI/CD |
| **home** | Home Assistant | Smart home automation |
| **vault** | Vaultwarden | Password manager |
| **messaging** | Gotify, Mailhog | Notifications, email testing |
| **+utility** | Various | Optional utility services |
| **+custom** | Various | Your custom services |

## Support & Resources

- **Documentation**: [Full documentation](README.md)
- **Domain Setup**: [DOMAIN_CONFIGURATION.md](DOMAIN_CONFIGURATION.md)
- **SSO Guide**: [SSO_INTEGRATION_GUIDE.md](SSO_INTEGRATION_GUIDE.md)
- **Troubleshooting**: Check stack-specific README files

---

**Congratulations!** 🎉

You now have a complete self-hosted infrastructure running!

Explore each service and customize to your needs. Happy hosting!
