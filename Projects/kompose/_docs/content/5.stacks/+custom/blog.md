# Blog Stack

Custom Docker Compose stack for serving static web content.

## Overview

The blog stack provides a high-performance static web server solution utilizing the `static-web-server` container. This stack is optimized for serving pre-built static websites, blogs, and web applications with minimal resource overhead.

Key capabilities include:
- **Static Content Delivery** - Efficient serving of HTML, CSS, JavaScript, and assets
- **Automatic HTTPS** - SSL termination through Traefik reverse proxy integration
- **Compression** - Built-in gzip compression for optimal transfer speeds
- **Directory Serving** - Direct volume mount from host filesystem

The blog stack is particularly well-suited for static site generators, documentation sites, portfolios, and landing pages.

## Configuration

### Environment Variables

All blog stack variables are defined in `+custom/blog/.env`:

```bash
# Stack identification
COMPOSE_PROJECT_NAME=blog

# Docker image
DOCKER_IMAGE=joseluisq/static-web-server:latest

# Traefik configuration
TRAEFIK_ENABLED=true
TRAEFIK_HOST=${TRAEFIK_HOST_BLOG}

# Application port
APP_PORT=80
```

### Domain Configuration

Add your subdomain to the root `domain.env` file:

```bash
# Blog subdomain
SUBDOMAIN_BLOG=blog
```

This will automatically generate `TRAEFIK_HOST_BLOG` from the root domain configuration.

### Content Volume

The blog stack mounts the host directory `/var/www/pivoine.art` as the web root. This directory should contain your static website files, including:

- `index.html` - Main entry point
- Static assets (CSS, JavaScript, images)
- Any additional HTML pages

## Services

### Static Web Server
- **Image:** `joseluisq/static-web-server:latest`
- **Container:** `blog_app`
- **Port:** 80 (internal only, proxied via Traefik)
- **Purpose:** Serves static web content from mounted volume
- **Access:** `https://blog.yourdomain.com`
- **Volume:** `/var/www/pivoine.art:/public` (read-only serving)

**Technical Details:**

The static-web-server container provides a lightweight, security-hardened web server specifically designed for static content delivery. It includes automatic compression, caching headers, and modern HTTP protocol support.

## Quick Start

### 1. Configure Domain

Add subdomain to `domain.env`:

```bash
echo "SUBDOMAIN_BLOG=blog" >> domain.env
```

### 2. Prepare Content Directory

Create and populate the content directory on your host system:

```bash
# Create directory
sudo mkdir -p /var/www/pivoine.art

# Set appropriate ownership
sudo chown -R $USER:$USER /var/www/pivoine.art

# Add your static website files
cp -r /path/to/your/site/* /var/www/pivoine.art/
```

### 3. Verify Configuration

Review the stack environment configuration:

```bash
vim +custom/blog/.env

# Verify:
DOCKER_IMAGE=joseluisq/static-web-server:latest
APP_PORT=80
TRAEFIK_HOST=${TRAEFIK_HOST_BLOG}
```

### 4. Start Stack

```bash
# Ensure kompose network exists
docker network create kompose

# Start the blog stack
./kompose.sh up blog

# Verify status
./kompose.sh status blog
```

### 5. Access Application

- **Local:** Content is served only through Traefik reverse proxy
- **Production:** `https://blog.yourdomain.com`

## Customization

### Change Content Directory

To serve content from a different location, edit `compose.yaml`:

```yaml
services:
  blog:
    volumes:
      - /your/custom/path:/public
```

### Add Custom Server Configuration

The static-web-server supports configuration through environment variables. Add to `compose.yaml`:

```yaml
services:
  blog:
    environment:
      SERVER_ROOT: /public
      SERVER_LOG_LEVEL: info
      SERVER_CORS_ALLOW_ORIGINS: "*"
      SERVER_CACHE_CONTROL_HEADERS: "public, max-age=3600"
```

### Enable Directory Listing

If you need to enable directory browsing, add to the service environment:

```yaml
environment:
  SERVER_DIRECTORY_LISTING: "true"
  SERVER_DIRECTORY_LISTING_FORMAT: html
```

### Add Security Headers

Enhance security by adding custom headers:

```yaml
labels:
  - 'traefik.http.middlewares.blog-security-headers.headers.customResponseHeaders.X-Frame-Options=SAMEORIGIN'
  - 'traefik.http.middlewares.blog-security-headers.headers.customResponseHeaders.X-Content-Type-Options=nosniff'
  - 'traefik.http.middlewares.blog-security-headers.headers.customResponseHeaders.Referrer-Policy=no-referrer-when-downgrade'
  - 'traefik.http.routers.blog-web-secure.middlewares=blog-web-secure-compress,blog-security-headers'
```

## Content Deployment Workflows

### Manual Deployment

```bash
# Update content
cp -r /path/to/updated/site/* /var/www/pivoine.art/

# No restart needed - changes are immediately available
```

### Git-based Deployment

```bash
# Clone or pull your site repository
cd /var/www/pivoine.art
git pull origin main

# Or use a deployment script
cd /path/to/your/site
npm run build
rsync -av --delete dist/ /var/www/pivoine.art/
```

### Automated CI/CD Integration

Configure your CI/CD pipeline to deploy directly to the content directory:

```bash
# Example GitHub Actions deployment
- name: Deploy to Blog
  run: |
    rsync -av --delete ./build/ user@server:/var/www/pivoine.art/
    ssh user@server "docker restart blog_app"
```

## Management

### View Logs

```bash
# Follow logs
./kompose.sh logs blog -f

# Last 100 lines
./kompose.sh logs blog --tail 100
```

### Restart Service

```bash
./kompose.sh restart blog
```

### Update Server Image

```bash
# Pull latest image
./kompose.sh pull blog

# Restart with new image
./kompose.sh up blog
```

### Check Container Details

```bash
# Inspect container
docker inspect blog_app

# View resource usage
docker stats blog_app
```

## Troubleshooting

### Container Won't Start

```bash
# Check logs for errors
docker logs blog_app

# Validate compose file
./kompose.sh validate blog

# Check environment variables
cd +custom/blog
docker compose config
```

### Content Not Accessible

```bash
# Verify volume mount
docker inspect blog_app | grep Mounts -A 10

# Check file permissions
ls -la /var/www/pivoine.art/

# Verify content exists
docker exec blog_app ls -la /public
```

### Traefik Not Routing

```bash
# Verify Traefik labels
docker inspect blog_app | grep traefik

# Check Traefik logs
docker logs proxy-traefik | grep blog

# Verify domain resolution
nslookup blog.yourdomain.com

# Test Traefik routing
curl -H "Host: blog.yourdomain.com" http://localhost
```

### Permission Errors

```bash
# Fix ownership
sudo chown -R 1000:1000 /var/www/pivoine.art/

# Fix permissions
sudo chmod -R 755 /var/www/pivoine.art/

# Restart container
./kompose.sh restart blog
```

### Performance Issues

```bash
# Check container resources
docker stats blog_app

# Enable additional compression in Traefik
# (Already enabled via middleware)

# Verify network connectivity
docker exec blog_app ping -c 3 proxy-traefik
```

## Performance Optimization

### Caching Strategy

Add cache control headers through environment variables:

```yaml
environment:
  SERVER_CACHE_CONTROL_HEADERS: "public, max-age=31536000, immutable"
```

### Compression

Compression is enabled by default through Traefik middleware. The following content types are automatically compressed:
- text/html
- text/css
- text/javascript
- application/javascript
- application/json

### CDN Integration

For optimal global performance, consider placing a CDN in front of your blog:

```bash
# Configure your CDN to point to:
# Origin: https://blog.yourdomain.com
# Cache TTL: 1 hour (or as needed)
# SSL: Use CDN-provided certificate or proxy through
```

## Security Considerations

### Content Security

The static-web-server container runs with minimal privileges and only serves content from the mounted volume. Ensure that:

- Content directory has appropriate permissions (755 for directories, 644 for files)
- No sensitive files are present in the served directory
- No executable files are included in the content

### HTTPS Enforcement

HTTPS is enforced through Traefik middleware. All HTTP requests are automatically redirected to HTTPS.

### Access Control

If you need to restrict access to the blog, add authentication through Traefik:

```yaml
labels:
  - 'traefik.http.middlewares.blog-auth.basicauth.users=user:$$apr1$$...'
  - 'traefik.http.routers.blog-web-secure.middlewares=blog-web-secure-compress,blog-auth'
```

## See Also

- [Stack Configuration Overview](/reference/stack-configuration)
- [Custom Stacks Guide](/guide/custom-stacks)
- [Traefik Configuration](/reference/traefik)
- [Content Deployment Strategies](/guide/deployment)

---

**Configuration Location:** `+custom/blog/.env`  
**Domain Configuration:** `domain.env` (SUBDOMAIN_BLOG)  
**Content Directory:** `/var/www/pivoine.art`  
**Docker Network:** `kompose`
