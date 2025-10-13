# Sexy Stack

Custom Docker Compose stack for headless CMS with Directus backend and custom frontend application.

## Overview

The Sexy stack provides a complete content management platform combining Directus headless CMS with a custom Node.js frontend application. This dual-service architecture enables decoupled content management with flexible frontend presentation.

The stack delivers the following capabilities:

- **Headless CMS** - Directus provides a complete data platform with REST and GraphQL APIs, real-time capabilities, and comprehensive content modeling
- **Custom Frontend** - Node.js-based presentation layer consuming Directus APIs, enabling tailored user experiences
- **Database Integration** - PostgreSQL backend with automatic schema management and versioning
- **Redis Caching** - Performance optimization through distributed caching layer
- **Email Integration** - SMTP configuration for transactional emails and user notifications
- **WebSocket Support** - Real-time data synchronization between services
- **Custom Extensions** - Support for Directus extensions through volume mounts

This architecture is particularly well-suited for content-driven applications, digital experiences, and headless commerce implementations.

## Configuration

### Environment Variables

All Sexy stack variables are defined in `+custom/sexy/.env`:

```bash
# Stack identification
COMPOSE_PROJECT_NAME=sexy

# Docker images
DOCKER_IMAGE=directus/directus:11.12.0
FRONTEND_IMAGE=node:22

# Database configuration
DB_NAME=directus

# Traefik configuration
TRAEFIK_ENABLED=true
TRAEFIK_HOST=${TRAEFIK_HOST_SEXY}

# Service ports
APP_PORT=8055
FRONTEND_PORT=3000

# Caching configuration
CACHE_ENABLED=true
CACHE_AUTO_PURGE=true

# WebSocket configuration
WEBSOCKETS_ENABLED=true

# Public URLs
PUBLIC_URL=https://sexy.pivoine.art/api
CORS_ORIGIN=https://sexy.pivoine.art

# Session security
SESSION_COOKIE_SECURE=true
SESSION_COOKIE_SAME_SITE=strict
SESSION_COOKIE_DOMAIN=sexy.pivoine.art

# Extensions
EXTENSIONS_PATH=./extensions
EXTENSIONS_AUTO_RELOAD=true
DIRECTUS_BUNDLE=/var/www/sexy.pivoine.art/packages/bundle

# Security policies
CONTENT_SECURITY_POLICY_DIRECTIVES__FRAME_SRC=https://sexy.pivoine.art

# User management
USER_REGISTER_URL_ALLOW_LIST=https://sexy.pivoine.art/signup/verify
PASSWORD_RESET_URL_ALLOW_LIST=https://sexy.pivoine.art/password/reset
```

### Domain Configuration

Add your subdomain to the root `domain.env` file:

```bash
# Sexy subdomain
SUBDOMAIN_SEXY=sexy
```

This automatically generates `TRAEFIK_HOST_SEXY` from the root domain configuration.

### Secrets

Sensitive values are stored in the root `secrets.env` file:

```bash
# Sexy stack secrets
SEXY_SECRET=<random-secret-key>
SEXY_ADMIN_PASSWORD=<secure-admin-password>
```

Generate secrets with:
```bash
./kompose.sh secrets generate
```

### Database Configuration

The stack requires a dedicated PostgreSQL database. Database credentials are inherited from the core stack configuration:

```bash
DB_HOST=core-postgres
DB_PORT=5432
DB_USER=valknar
DB_PASSWORD=${CORE_DB_PASSWORD}
DB_NAME=directus
```

The `directus` database is automatically created during core stack initialization.

### Email Configuration

Configure SMTP settings in the environment file for transactional emails:

```bash
EMAIL_TRANSPORT=smtp
EMAIL_FROM=noreply@yourdomain.com
EMAIL_SMTP_HOST=smtp.your-provider.com
EMAIL_SMTP_PORT=587
EMAIL_SMTP_USER=your-smtp-username
EMAIL_SMTP_PASSWORD=your-smtp-password
```

## Services

### Directus API
- **Image:** `directus/directus:11.12.0`
- **Container:** `sexy_api`
- **Port:** 8055 (internal, proxied via Traefik)
- **Purpose:** Headless CMS backend providing REST and GraphQL APIs
- **Access:** `https://sexy.yourdomain.com/api`
- **Admin Interface:** `https://sexy.yourdomain.com/api/admin`

**Key Features:**

Directus provides a comprehensive data platform with the following capabilities:

- Complete REST and GraphQL API endpoints for all collections
- Real-time WebSocket subscriptions for data changes
- Media asset management with transformation capabilities
- User authentication and role-based access control
- Custom extensions support through volume-mounted bundles
- Database schema versioning and snapshot management

**Volume Mounts:**

The service maintains two critical volume mounts:

- `./uploads:/directus/uploads` - Persistent storage for uploaded media assets
- `${DIRECTUS_BUNDLE}:/directus/extensions/sexy.pivoine.art` - Custom extensions and business logic

### Frontend Application
- **Image:** `node:22`
- **Container:** `sexy_frontend`
- **Port:** 3000 (internal, proxied via Traefik)
- **Purpose:** Custom presentation layer consuming Directus APIs
- **Access:** `https://sexy.yourdomain.com`
- **Working Directory:** `/home/node/app/packages/frontend`

**Technical Details:**

The frontend service runs a production-built Node.js application that consumes data from the Directus API. The service executes the compiled application located in the `build` directory and communicates with Directus through internal Docker networking.

**Volume Mount:**

- `/var/www/sexy.pivoine.art:/home/node/app` - Application codebase mount

## Quick Start

### 1. Configure Domain

Add subdomain to `domain.env`:

```bash
echo "SUBDOMAIN_SEXY=sexy" >> domain.env
```

### 2. Configure Secrets

Add required secrets to `secrets.env`:

```bash
vim secrets.env

# Add or generate:
SEXY_SECRET=$(openssl rand -base64 32)
SEXY_ADMIN_PASSWORD=$(openssl rand -base64 16)
```

Or use the secrets generator:

```bash
./kompose.sh secrets generate
```

### 3. Configure Environment

Review and adjust configuration in `+custom/sexy/.env`:

```bash
vim +custom/sexy/.env

# Verify critical settings:
PUBLIC_URL=https://sexy.yourdomain.com/api
CORS_ORIGIN=https://sexy.yourdomain.com
SESSION_COOKIE_DOMAIN=sexy.yourdomain.com
```

### 4. Prepare Application Directory

Ensure your application codebase is located in the correct path:

```bash
# Verify directory exists
ls -la /var/www/sexy.pivoine.art/

# Should contain:
# - packages/frontend/build/ (compiled frontend)
# - packages/bundle/ (Directus extensions)
```

### 5. Initialize Database

Ensure the Directus database exists:

```bash
# Check database
./kompose.sh db status

# If needed, create manually
./kompose.sh db exec -d postgres "CREATE DATABASE directus;"
```

### 6. Start Stack

```bash
# Ensure dependencies are running
./kompose.sh up core
./kompose.sh up proxy

# Start the sexy stack
./kompose.sh up sexy

# Verify status
./kompose.sh status sexy
```

### 7. Initialize Directus

On first start, Directus will automatically initialize the database schema and create the admin user using the credentials from your secrets configuration.

Access the admin interface at: `https://sexy.yourdomain.com/api/admin`

Credentials:
- Email: From `ADMIN_EMAIL` in environment
- Password: From `SEXY_ADMIN_PASSWORD` in secrets

### 8. Verify Services

```bash
# Check API health
curl https://sexy.yourdomain.com/api/server/health

# Check frontend
curl -I https://sexy.yourdomain.com/

# View logs
./kompose.sh logs sexy -f
```

## Database Management

### Schema Snapshots

The Sexy stack includes custom hooks for Directus schema management. Schema snapshots are automatically created during database operations.

**Automatic Snapshot Creation:**

When performing database exports, the pre-export hook automatically generates a Directus schema snapshot:

```bash
# Backup with automatic schema snapshot
./kompose.sh db backup -d directus
```

This creates both a SQL dump and a schema YAML file in the stack directory.

**Manual Schema Operations:**

```bash
# Create schema snapshot manually
docker exec sexy_api npx directus schema snapshot /directus/snapshot.yaml

# Apply schema snapshot
docker exec sexy_api npx directus schema apply /directus/snapshot.yaml

# Compare schemas
docker exec sexy_api npx directus schema diff /directus/snapshot.yaml
```

### Database Backup

```bash
# Backup Directus database (includes automatic schema snapshot)
./kompose.sh db backup -d directus

# Backup with compression
./kompose.sh db backup -d directus --compress

# Manual backup
docker exec core-postgres pg_dump -U valknar directus > backup.sql
```

### Database Restore

```bash
# Restore from backup (includes automatic schema application)
./kompose.sh db restore -f backups/database/directus_20250113-120000.sql

# The pre-import hook will automatically apply the most recent schema snapshot
```

## Content Management

### Accessing Admin Interface

The Directus admin interface provides comprehensive content management capabilities:

URL: `https://sexy.yourdomain.com/api/admin`

**Key Administrative Functions:**

- **Content Module** - Manage all collections and items
- **User Directory** - User and role management
- **File Library** - Media asset management with transformations
- **Data Model** - Schema and relationship configuration
- **Settings** - System configuration and preferences
- **Insights** - Analytics and reporting dashboards

### API Endpoints

Directus exposes multiple API interfaces:

**REST API:**
```bash
# Collections
GET https://sexy.yourdomain.com/api/items/collection_name

# Single item
GET https://sexy.yourdomain.com/api/items/collection_name/item_id

# With filters and sorting
GET https://sexy.yourdomain.com/api/items/collection_name?filter[status][_eq]=published&sort=-date_created
```

**GraphQL API:**
```bash
# Endpoint
POST https://sexy.yourdomain.com/api/graphql

# Query
query {
  collection_name {
    id
    title
    content
  }
}
```

### Media Management

Uploaded files are stored in the `./uploads` directory and served through Directus:

```bash
# Access uploaded file
https://sexy.yourdomain.com/api/assets/filename.jpg

# With transformations
https://sexy.yourdomain.com/api/assets/filename.jpg?width=800&quality=80&format=webp
```

## Extensions Management

### Custom Extensions

The stack supports custom Directus extensions through volume mounts. Extensions are loaded from the `DIRECTUS_BUNDLE` path.

**Extension Types:**

- Interfaces - Custom field input components
- Displays - Custom field display formatting
- Layouts - Custom collection layouts
- Modules - Custom application pages
- Panels - Dashboard widgets
- Hooks - Server-side event handlers
- Endpoints - Custom API routes

**Development Workflow:**

```bash
# Extension directory structure
/var/www/sexy.pivoine.art/packages/bundle/
├── interfaces/
├── displays/
├── modules/
└── endpoints/

# Auto-reload is enabled (EXTENSIONS_AUTO_RELOAD=true)
# Changes are detected and loaded automatically
```

### Installing Extensions

```bash
# Navigate to extensions directory
cd /var/www/sexy.pivoine.art/packages/bundle

# Add your extension
# Extensions are automatically loaded on container restart

# Restart to ensure loading
./kompose.sh restart sexy
```

## Management

### View Logs

```bash
# All services
./kompose.sh logs sexy -f

# Specific service
docker logs sexy_api -f
docker logs sexy_frontend -f
```

### Restart Services

```bash
# Restart entire stack
./kompose.sh restart sexy

# Restart individual service
docker restart sexy_api
docker restart sexy_frontend
```

### Update Images

```bash
# Pull latest Directus image
docker pull directus/directus:11.12.0

# Restart with new image
./kompose.sh up sexy
```

### Execute Commands

```bash
# Directus CLI
docker exec sexy_api npx directus --help

# Frontend shell
docker exec -it sexy_frontend /bin/bash

# Run Directus migrations
docker exec sexy_api npx directus database migrate:latest
```

### Cache Management

```bash
# Clear Directus cache
docker exec sexy_api npx directus cache clear

# Restart to flush Redis cache
docker restart core-redis
```

## Troubleshooting

### Directus Container Won't Start

```bash
# Check logs for specific errors
docker logs sexy_api

# Verify database connectivity
docker exec sexy_api npx directus database install --dry-run

# Check environment configuration
cd +custom/sexy
docker compose config

# Verify secrets are loaded
docker exec sexy_api env | grep SECRET
```

### Database Connection Issues

```bash
# Verify PostgreSQL is running
docker ps | grep postgres

# Test database connectivity
docker exec core-postgres psql -U valknar -d directus -c "SELECT version();"

# Check database exists
./kompose.sh db status

# Verify credentials
echo $CORE_DB_PASSWORD
```

### Frontend Not Accessible

```bash
# Check frontend logs
docker logs sexy_frontend

# Verify working directory and files
docker exec sexy_frontend ls -la /home/node/app/packages/frontend/build/

# Check if Node process is running
docker exec sexy_frontend ps aux | grep node

# Verify Traefik routing
docker logs proxy-traefik | grep sexy
```

### API Routes Not Working

```bash
# Verify Traefik labels
docker inspect sexy_api | grep traefik

# Check path prefix configuration
curl -I https://sexy.yourdomain.com/api/server/health

# Verify strip prefix middleware
# Should access /server/health internally after stripping /api
```

### CORS Errors

Verify CORS configuration matches your domain:

```bash
# Check current settings
docker exec sexy_api env | grep CORS

# Update if needed
vim +custom/sexy/.env

# Update CORS_ORIGIN to match your domain
CORS_ORIGIN=https://sexy.yourdomain.com

# Restart
./kompose.sh restart sexy
```

### Extension Not Loading

```bash
# Check extension directory
docker exec sexy_api ls -la /directus/extensions/sexy.pivoine.art/

# Verify extension structure
docker exec sexy_api cat /directus/extensions/sexy.pivoine.art/package.json

# Check Directus logs for extension errors
docker logs sexy_api | grep extension

# Restart with auto-reload
docker restart sexy_api
```

### Upload Issues

```bash
# Check uploads directory permissions
ls -la +custom/sexy/uploads/

# Fix permissions
sudo chown -R 1000:1000 +custom/sexy/uploads/
sudo chmod -R 755 +custom/sexy/uploads/

# Verify mount
docker inspect sexy_api | grep uploads
```

### Schema Migration Failures

```bash
# Check current schema version
docker exec sexy_api npx directus database schema

# View pending migrations
docker exec sexy_api npx directus database migrations:pending

# Run migrations manually
docker exec sexy_api npx directus database migrate:latest

# If needed, rollback
docker exec sexy_api npx directus database migrate:down
```

## Performance Optimization

### Redis Caching

Redis caching is enabled by default. Configure cache behavior through environment variables:

```bash
CACHE_ENABLED=true
CACHE_AUTO_PURGE=true
CACHE_STORE=redis
```

Monitor cache performance:

```bash
# Access Redis Commander
# Navigate to https://redis.yourdomain.com

# Or use Redis CLI
docker exec core-redis redis-cli -a ${CORE_REDIS_PASSWORD} INFO STATS
```

### Database Query Optimization

```bash
# Analyze query performance
docker exec core-postgres psql -U valknar -d directus -c "EXPLAIN ANALYZE SELECT * FROM your_table;"

# View slow queries
docker exec core-postgres psql -U valknar -d directus -c "SELECT * FROM pg_stat_statements ORDER BY mean_time DESC LIMIT 10;"
```

### Asset Optimization

Configure Directus asset transformations for optimal performance:

```bash
# Use transformation presets
# In Directus admin: Settings > Project Settings > Asset Presets

# Enable Sharp for better image processing
# (Already included in Directus container)
```

## Security Considerations

### Authentication and Authorization

Directus provides comprehensive security features:

- **User Authentication** - Email/password with optional 2FA
- **Role-Based Access Control** - Granular permissions per collection
- **API Token Authentication** - Static tokens for service accounts
- **OAuth2/SSO Integration** - External authentication providers

Configure access control through the Directus admin interface.

### Session Security

Session cookies are configured with security best practices:

```bash
SESSION_COOKIE_SECURE=true          # HTTPS only
SESSION_COOKIE_SAME_SITE=strict     # CSRF protection
SESSION_COOKIE_DOMAIN=sexy.pivoine.art  # Domain restriction
```

### Content Security Policy

Frame embedding is restricted through CSP directives:

```bash
CONTENT_SECURITY_POLICY_DIRECTIVES__FRAME_SRC=https://sexy.pivoine.art
```

### API Rate Limiting

Consider implementing rate limiting through Traefik middleware for API endpoints to prevent abuse.

### Secret Management

All sensitive credentials are stored in the root `secrets.env` file, which should be excluded from version control and backed up securely.

## Production Deployment Checklist

Before deploying to production, verify the following configuration items:

1. **Secrets** - Generate strong, unique values for all secrets
2. **Domain Configuration** - Update all URLs to match production domain
3. **CORS Settings** - Configure exact allowed origins (avoid wildcards)
4. **Session Security** - Enable secure cookies and strict same-site policy
5. **Email Configuration** - Configure production SMTP credentials
6. **Database Backups** - Establish automated backup schedule
7. **SSL Certificates** - Verify Traefik SSL configuration
8. **User Registration** - Configure allowed registration and reset URLs
9. **Content Security Policy** - Review and adjust CSP directives
10. **Monitoring** - Enable logging and monitoring for both services

## See Also

- [Stack Configuration Overview](/reference/stack-configuration)
- [Custom Stacks Guide](/guide/custom-stacks)
- [Traefik Configuration](/reference/traefik)
- [Database Management Guide](/guide/database)
- [Directus Documentation](https://docs.directus.io/)

---

**Configuration Location:** `+custom/sexy/.env`  
**Domain Configuration:** `domain.env` (SUBDOMAIN_SEXY)  
**Secrets Location:** `secrets.env`  
**Docker Network:** `kompose`  
**Directus Version:** 11.12.0
