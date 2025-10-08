# 🚦 Proxy Stack - The Traffic Cop of Your Infrastructure

> *"Beep beep! Make way for HTTPS traffic!"* - Traefik

## What's This All About?

Traefik (pronounced "traffic") is your reverse proxy and load balancer extraordinaire! Think of it as the extremely organized doorman at a fancy hotel - it knows exactly where every guest (request) needs to go, handles their SSL certificates, redirects them when needed, and does it all with style!

## The Traffic Master

### 🎯 Traefik

**Container**: `proxy_app`  
**Image**: `traefik:latest`  
**Ports**: 80 (HTTP), 443 (HTTPS), 8080 (Dashboard)  
**Home**: http://localhost:8080/dashboard/

Traefik is the Swiss Army knife of reverse proxies:
- 🔒 **Auto SSL**: Let's Encrypt certificates automatically
- 🏷️ **Service Discovery**: Finds your containers via Docker labels
- 🔄 **Auto-Config**: No config files to edit (mostly!)
- 📊 **Dashboard**: Beautiful visual overview
- ⚡ **Fast**: Written in Go for max performance
- 🔌 **Middleware**: Compress, auth, rate limit, and more
- 🎯 **Load Balancing**: Distribute traffic intelligently

## How It Works

```
Internet Request (https://yoursite.com)
    ↓
Traefik (Port 443)
    ├─ Checks Docker labels
    ├─ Finds matching service
    ├─ Terminates SSL
    ├─ Applies middleware
    └─ Forwards to container
        ↓
    Your Service (blog, auth, etc.)
```

## Configuration Breakdown

### Command Arguments

Let's decode the Traefik startup commands:

```yaml
--api.dashboard=true              # Enable the fancy dashboard
--api.insecure=true              # Allow dashboard on :8080 (dev mode)
--log.level=DEBUG                # Verbose logging for troubleshooting
--global.sendAnonymousUsage=false # No telemetry (privacy!)
--global.checkNewVersion=true    # Check for updates
--providers.docker=true          # Watch Docker for services
--providers.docker.exposedbydefault=false  # Require explicit labels
--providers.docker.network=kompose         # Use kompose network
--entrypoints.web.address=:80             # HTTP on port 80
--entryPoints.web-secure.address=:443     # HTTPS on port 443
--certificatesresolvers.resolver.acme.tlschallenge=true  # SSL verification
--certificatesresolvers.resolver.acme.email=admin@example.com  # For Let's Encrypt
--certificatesresolvers.resolver.acme.storage=/letsencrypt/acme.json  # Cert storage
```

### Entry Points

**web** (Port 80):
- Receives HTTP traffic
- Usually redirects to HTTPS

**web-secure** (Port 443):
- Handles HTTPS traffic
- Terminates SSL here
- Forwards decrypted traffic to services

### Certificate Resolver

**Let's Encrypt Integration**:
- Automatic SSL certificates
- TLS challenge method
- Stores certs in `/letsencrypt/acme.json`
- Auto-renewal (60 days before expiry)

## Dashboard Access 📊

### Development/Testing
```
URL: http://localhost:8080/dashboard/
```

**Features**:
- 📋 All routers and services
- 🔒 Active certificates
- 🌐 Entry points status
- 📊 Real-time metrics
- 🔍 Request logs

### Production (Secure It!)

Add authentication to dashboard:
```yaml
labels:
  - "traefik.http.routers.dashboard.middlewares=auth"
  - "traefik.http.middlewares.auth.basicauth.users=admin:$$apr1$$password"
```

Generate password hash:
```bash
htpasswd -nb admin your_password
```

## Label-Based Configuration 🏷️

Every service in kompose uses Traefik labels. Here's what they mean:

### Basic Labels
```yaml
labels:
  - 'traefik.enable=true'  # "Hey Traefik, route me!"
  - 'traefik.http.routers.myapp-web.rule=Host(`app.example.com`)'  # Domain routing
  - 'traefik.http.routers.myapp-web.entrypoints=web'  # Use HTTP
  - 'traefik.http.services.myapp.loadbalancer.server.port=8080'  # Internal port
```

### HTTPS Setup
```yaml
- 'traefik.http.routers.myapp-web-secure.rule=Host(`app.example.com`)'
- 'traefik.http.routers.myapp-web-secure.entrypoints=web-secure'  # HTTPS
- 'traefik.http.routers.myapp-web-secure.tls.certresolver=resolver'  # Auto SSL
```

### HTTP → HTTPS Redirect
```yaml
- 'traefik.http.middlewares.myapp-redirect.redirectscheme.scheme=https'
- 'traefik.http.routers.myapp-web.middlewares=myapp-redirect'
```

### Compression
```yaml
- 'traefik.http.middlewares.myapp-compress.compress=true'
- 'traefik.http.routers.myapp-web-secure.middlewares=myapp-compress'
```

## Ports & Networking

| Port | Purpose | Access |
|------|---------|--------|
| 80 | HTTP Traffic | Public |
| 443 | HTTPS Traffic | Public |
| 8080 | Dashboard | Local only (for now) |

**Network**: `kompose` - must be created before starting:
```bash
docker network create kompose
```

## SSL Certificate Management 🔒

### Let's Encrypt Process

1. **Service starts** with Traefik labels
2. **Traefik detects** it needs SSL
3. **Requests certificate** from Let's Encrypt
4. **TLS challenge** runs (Traefik proves domain ownership)
5. **Certificate issued** (valid 90 days)
6. **Auto-renewal** happens at 60 days

### Certificate Storage
```
/var/local/data/traefik/letsencrypt/acme.json
```

**⚠️ PROTECT THIS FILE!**
- Contains private keys
- Encrypted by Traefik
- Backup regularly
- Permissions: 600

### View Certificates
```bash
# In dashboard
http://localhost:8080/dashboard/#/http/routers

# Or check file
sudo cat /var/local/data/traefik/letsencrypt/acme.json | jq '.resolver.Certificates'
```

## Common Middleware 🔧

### Rate Limiting
```yaml
- "traefik.http.middlewares.ratelimit.ratelimit.average=100"
- "traefik.http.middlewares.ratelimit.ratelimit.burst=50"
```

### IP Whitelist
```yaml
- "traefik.http.middlewares.ipwhitelist.ipwhitelist.sourcerange=192.168.1.0/24"
```

### CORS Headers
```yaml
- "traefik.http.middlewares.cors.headers.accesscontrolallowmethods=GET,POST,PUT"
- "traefik.http.middlewares.cors.headers.accesscontrolalloworigin=*"
```

### Basic Auth
```yaml
- "traefik.http.middlewares.auth.basicauth.users=user:$$apr1$$password"
```

### Strip Prefix
```yaml
- "traefik.http.middlewares.stripprefix.stripprefix.prefixes=/api"
```

## Health Check 🏥

Traefik has a built-in health check:
```bash
traefik healthcheck --ping
```

Runs every 30 seconds. If it fails 3 times, Docker restarts the container.

## Monitoring & Debugging

### Real-Time Logs
```bash
docker logs proxy_app -f
```

### Access Logs (Enable in config)
```yaml
--accesslog=true
--accesslog.filepath=/var/log/traefik/access.log
```

### Metrics (Prometheus)
```yaml
--metrics.prometheus=true
--metrics.prometheus.buckets=0.1,0.3,1.2,5.0
```

## Adding a New Service

1. **Create compose file** with labels:
   ```yaml
   services:
     myapp:
       image: nginx
       networks:
         - kompose
       labels:
         - 'traefik.enable=true'
         - 'traefik.http.routers.myapp.rule=Host(`myapp.example.com`)'
         - 'traefik.http.routers.myapp.entrypoints=web-secure'
         - 'traefik.http.routers.myapp.tls.certresolver=resolver'
   ```

2. **Start the service**:
   ```bash
   docker compose up -d
   ```

3. **Traefik auto-detects** it!

4. **Check dashboard** to confirm routing

## Troubleshooting 🔍

**Q: Service not accessible?**
```bash
# Check if Traefik sees it
docker logs proxy_app | grep your-service

# Verify labels
docker inspect your-container | grep traefik
```

**Q: SSL certificate not working?**
- Check domain DNS points to server
- Verify port 80/443 are open
- Check Let's Encrypt rate limits
- Look for errors in logs

**Q: "Gateway Timeout" errors?**
- Service might be slow to respond
- Check service health
- Increase timeout in labels:
  ```yaml
  - "traefik.http.services.myapp.loadbalancer.healthcheck.timeout=10s"
  ```

**Q: HTTP not redirecting to HTTPS?**
- Verify redirect middleware is applied
- Check router configuration
- Look for middleware typos

**Q: Certificate renewal failing?**
```bash
# Check renewal logs
docker logs proxy_app | grep -i "renew\|certificate"

# Ensure ports are accessible
curl -I http://yourdomain.com/.well-known/acme-challenge/test
```

## Advanced Configuration

### Multiple Domains
```yaml
- 'traefik.http.routers.myapp.rule=Host(`app1.com`) || Host(`app2.com`)'
```

### Path-Based Routing
```yaml
- 'traefik.http.routers.api.rule=Host(`example.com`) && PathPrefix(`/api`)'
- 'traefik.http.routers.web.rule=Host(`example.com`) && PathPrefix(`/`)'
```

### Weighted Load Balancing
```yaml
services:
  app-v1:
    labels:
      - "traefik.http.services.myapp.loadbalancer.server.weight=90"
  app-v2:
    labels:
      - "traefik.http.services.myapp.loadbalancer.server.weight=10"
```

## Security Best Practices 🛡️

1. **Secure Dashboard**:
   - Add authentication
   - Or disable in production: `--api.dashboard=false`

2. **HTTPS Only**:
   - Always redirect HTTP → HTTPS
   - Use HSTS headers

3. **Regular Updates**:
   ```bash
   docker compose pull
   docker compose up -d
   ```

4. **Backup Certificates**:
   ```bash
   cp /var/local/data/traefik/letsencrypt/acme.json ~/backups/
   ```

5. **Monitor Logs**:
   - Watch for unusual patterns
   - Set up alerts for errors

## Performance Tips ⚡

1. **Enable Compression**: Already done for most services!
2. **HTTP/2**: Automatically enabled with HTTPS
3. **Connection Pooling**: Traefik handles it
4. **Caching**: Use middleware or CDN
5. **Keep-Alive**: Enabled by default

## Fun Traefik Facts 🎓

- Written in Go (blazing fast!)
- Powers thousands of production systems
- Open source since 2015
- Cloud-native from the ground up
- Originally created for microservices
- Supports Docker, Kubernetes, Consul, and more

## Resources

- [Traefik Documentation](https://doc.traefik.io/traefik/)
- [Let's Encrypt](https://letsencrypt.org/)
- [Traefik Plugins](https://plugins.traefik.io/)

---

*"Life is like a reverse proxy - it's all about routing requests to the right destination."* - Ancient Traefik Wisdom 🚦✨
