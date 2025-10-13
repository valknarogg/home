# Custom Stacks

Documentation for custom Docker Compose stacks in the Kompose platform.

## Overview

Custom stacks represent user-defined services that extend the core Kompose infrastructure. The platform provides comprehensive management capabilities for these stacks, ensuring they receive the same level of integration, tooling support, and operational consistency as built-in Kompose services.

Each custom stack benefits from the following platform capabilities:

- Full integration with the `kompose.sh` management interface, providing unified control across all services
- Automated lifecycle management through standard commands including deployment, scaling, and monitoring operations
- Centralized environment configuration with inheritance from global settings
- Secrets management integration with secure credential storage
- Domain and SSL certificate automation through Traefik reverse proxy integration
- Database connectivity and backup automation where applicable
- Comprehensive logging and monitoring through standard Kompose observability tools

Custom stacks may be either hand-crafted configurations tailored to specific requirements or generated from standardized templates using the Kompose generator utility.

## Available Custom Stacks

The following custom stacks are currently deployed in your Kompose installation:

### Blog Stack
Static content delivery platform utilizing high-performance web server technology for serving pre-built websites, documentation, and web applications.

**Key Characteristics:**
- Lightweight static file serving with minimal resource overhead
- Automatic HTTPS termination and compression through Traefik integration
- Direct filesystem mounting for simplified content deployment
- Optimized for static site generators, portfolios, and documentation sites

[View Blog Stack Documentation](./blog)

### Sexy Stack
Comprehensive headless CMS platform combining Directus backend with custom frontend application, providing decoupled content management with flexible presentation capabilities.

**Key Characteristics:**
- Complete content management system with REST and GraphQL API exposure
- Custom Node.js frontend consuming Directus APIs
- PostgreSQL database integration with automated schema management
- Redis caching layer for performance optimization
- WebSocket support for real-time data synchronization
- Custom extension framework for business logic implementation

[View Sexy Stack Documentation](./sexy)

### MyApp Stack (Template)
Foundational template configuration demonstrating standard patterns for custom stack implementation. This serves as a reference architecture for developing new custom services.

[View MyApp Stack Documentation](./myapp)

## Stack Management Operations

All custom stacks are fully manageable through the standard Kompose command interface. The following operations are available for each stack:

### Lifecycle Management

```bash
# Start a custom stack
./kompose.sh up <stack-name>

# Stop a custom stack
./kompose.sh down <stack-name>

# Restart a custom stack
./kompose.sh restart <stack-name>
```

### Monitoring and Diagnostics

```bash
# Check stack status
./kompose.sh status <stack-name>

# View real-time logs
./kompose.sh logs <stack-name> -f

# Display recent log entries
./kompose.sh logs <stack-name> --tail 100
```

### Image Management

```bash
# Update to latest images
./kompose.sh pull <stack-name>

# Rebuild custom images
./kompose.sh build <stack-name>

# Deploy specific version
./kompose.sh deploy <stack-name> <version>
```

### Container Operations

```bash
# Execute command in container
./kompose.sh exec <stack-name> <command>

# Open interactive shell
./kompose.sh exec <stack-name> sh

# View container details
docker ps | grep <stack-name>
```

## Creating Custom Stacks

The Kompose platform provides two approaches for creating custom stacks, depending on your specific requirements and architectural preferences.

### Generator-Based Stack Creation

The generator utility provides a streamlined approach for creating standardized custom stacks with comprehensive template scaffolding:

```bash
# Generate new custom stack with templates
./kompose.sh generate <stack-name>
```

This command initiates an interactive configuration process and generates the following artifacts:

- Stack directory structure in `+custom/<stack-name>/`
- Docker Compose configuration file with Traefik integration
- Environment variable templates with standard patterns
- Documentation file in this directory
- Automated test suite for validation

The generated stack includes production-ready configurations for common patterns including:
- Traefik reverse proxy integration with automatic SSL
- Environment variable management with secrets separation
- Docker networking configuration
- Health check implementations
- Logging and monitoring integration

### Manual Stack Creation

For specialized requirements or non-standard architectures, stacks may be created manually by establishing the required directory structure and configuration files:

```bash
# Create stack directory
mkdir -p +custom/<stack-name>

# Create compose configuration
touch +custom/<stack-name>/compose.yaml

# Create environment configuration
touch +custom/<stack-name>/.env
```

Manual stack creation provides maximum flexibility for complex service configurations, custom networking requirements, or integration with external systems.

## Stack Configuration Architecture

### Environment Variable Management

Custom stacks utilize a hierarchical environment configuration system that promotes consistency while enabling stack-specific customization:

**Stack-Level Configuration:** `+custom/<stack-name>/.env`
- Stack identification and naming
- Service-specific parameters
- Feature flags and behavior toggles
- Non-sensitive configuration values

**Root-Level Domain Configuration:** `domain.env`
- Subdomain definitions that generate Traefik host routing
- Global domain settings inherited by all stacks

**Root-Level Secrets Configuration:** `secrets.env`
- Sensitive credentials and API keys
- Database passwords and connection strings
- Authentication tokens and private keys
- Email service credentials

This separation ensures sensitive information remains isolated while maintaining centralized management capabilities.

### Domain Configuration Pattern

Custom stacks integrate with the global domain management system through standardized subdomain definitions:

```bash
# In root domain.env
SUBDOMAIN_STACKNAME=stackname

# Automatically generates:
# TRAEFIK_HOST_STACKNAME=stackname.yourdomain.com
```

This pattern ensures consistent DNS routing and SSL certificate management across all custom stacks.

### Secrets Management Integration

Custom stacks access sensitive configuration through the centralized secrets management system:

```bash
# Generate all required secrets
./kompose.sh secrets generate

# Generate specific stack secrets
./kompose.sh secrets generate -s <stack-name>

# Validate secrets configuration
./kompose.sh secrets validate

# Display secrets status
./kompose.sh secrets list -s <stack-name>
```

## Testing and Validation

Custom stacks should be validated before production deployment to ensure proper configuration and integration:

```bash
# Validate compose file syntax
./kompose.sh validate <stack-name>

# Test stack configuration
cd +custom/<stack-name>
docker compose config

# Verify environment variable resolution
docker compose config | grep TRAEFIK_HOST
```

## Database Integration

Custom stacks requiring database connectivity integrate with the core PostgreSQL instance through standard patterns:

### Database Creation

```bash
# Create database for custom stack
./kompose.sh db exec -d postgres "CREATE DATABASE <stack-name>;"

# Verify database creation
./kompose.sh db status
```

### Connection Configuration

Database connection parameters are inherited from core stack configuration:

```bash
# In stack compose.yaml
environment:
  DB_HOST: ${DB_HOST}
  DB_PORT: ${DB_PORT}
  DB_NAME: <stack-name>
  DB_USER: ${DB_USER}
  DB_PASSWORD: ${DB_PASSWORD}
```

### Backup Management

Custom stack databases are included in the automated backup system:

```bash
# Backup specific database
./kompose.sh db backup -d <stack-name>

# Restore from backup
./kompose.sh db restore -f backups/database/<stack-name>_timestamp.sql
```

## Traefik Integration

Custom stacks achieve automatic HTTPS termination and routing through standardized Traefik label configuration:

### Standard Label Pattern

```yaml
labels:
  - 'traefik.enable=true'
  
  # HTTP to HTTPS redirect
  - 'traefik.http.middlewares.${COMPOSE_PROJECT_NAME}-redirect-web-secure.redirectscheme.scheme=https'
  - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web.middlewares=${COMPOSE_PROJECT_NAME}-redirect-web-secure'
  
  # HTTP router
  - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web.rule=Host(`${TRAEFIK_HOST}`)'
  - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web.entrypoints=web'
  
  # HTTPS router with SSL
  - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.rule=Host(`${TRAEFIK_HOST}`)'
  - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.tls.certresolver=resolver'
  - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.entrypoints=web-secure'
  
  # Compression middleware
  - 'traefik.http.middlewares.${COMPOSE_PROJECT_NAME}-web-secure-compress.compress=true'
  - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.middlewares=${COMPOSE_PROJECT_NAME}-web-secure-compress'
  
  # Service port definition
  - 'traefik.http.services.${COMPOSE_PROJECT_NAME}-web-secure.loadbalancer.server.port=<port>'
  
  # Network specification
  - 'traefik.docker.network=${NETWORK_NAME:-kompose}'
```

This configuration provides automatic SSL certificate acquisition through Let's Encrypt, HTTP to HTTPS redirection, and compression middleware for optimal performance.

## Monitoring and Observability

Custom stacks integrate with the Kompose monitoring infrastructure through standard Docker logging mechanisms:

```bash
# View aggregated logs
./kompose.sh logs <stack-name> -f

# Monitor resource utilization
docker stats <stack-name>_<service>

# View container health status
docker ps | grep <stack-name>
```

For comprehensive monitoring, custom stacks can be integrated with the Watch stack (Uptime Kuma) for uptime monitoring and alerting capabilities.

## Best Practices

When developing and deploying custom stacks, adherence to the following practices ensures optimal integration with the Kompose platform:

### Configuration Management

- Maintain clear separation between environment variables and secrets, utilizing the appropriate configuration files for each category
- Document all environment variables with descriptive comments explaining their purpose and valid value ranges
- Use environment variable references rather than hardcoded values to promote portability and maintainability
- Establish sensible default values for optional configuration parameters

### Security Considerations

- Store all sensitive credentials exclusively in the `secrets.env` file, never in stack-level environment files
- Utilize strong, randomly-generated passwords for all authentication requirements through the secrets generator
- Configure appropriate session security settings including secure cookies and same-site policies
- Implement proper CORS configuration restricting access to known and trusted origins
- Regularly rotate sensitive credentials using the secrets management system

### Docker Best Practices

- Specify explicit image versions rather than using floating tags to ensure deployment consistency
- Implement appropriate health check configurations for container lifecycle management
- Utilize multi-stage builds for custom images to minimize final image size
- Configure proper restart policies to ensure service availability
- Implement resource limits where appropriate to prevent resource exhaustion

### Networking Architecture

- Connect all services to the `kompose` Docker network for inter-service communication
- Avoid exposing internal ports directly to the host when Traefik proxying is available
- Utilize Docker's internal DNS for service discovery within the network
- Implement appropriate network isolation for sensitive services

### Documentation Standards

- Maintain comprehensive documentation for each custom stack following the established template patterns
- Document all environment variables with their purpose, valid values, and default settings
- Provide clear quickstart instructions for initial deployment and configuration
- Include troubleshooting guidance for common operational issues
- Document integration points with other Kompose services and external systems

## Generator Utility

The Kompose generator provides comprehensive stack scaffolding capabilities:

### Available Generator Commands

```bash
# Generate new custom stack
./kompose.sh generate <stack-name>

# List all custom stacks
./kompose.sh generate list

# Display stack information
./kompose.sh generate show <stack-name>

# Remove custom stack
./kompose.sh generate delete <stack-name>
```

### Generated Artifacts

The generator creates a complete stack structure including:

- Docker Compose configuration with Traefik integration
- Environment variable template following Kompose conventions
- Documentation file based on the standard template
- Test suite for validation
- Directory structure following Kompose patterns

Generated stacks require minimal customization to achieve production-ready status, accelerating the deployment of new services.

## See Also

- [Stack Generator Guide](/guide/generator)
- [Stack Configuration Reference](/reference/stack-configuration)
- [Traefik Configuration](/reference/traefik)
- [Database Management Guide](/guide/database)
- [Secrets Management Guide](/guide/secrets)
- [Environment Configuration](/reference/environment)

---

**Generated By:** Kompose Platform  
**Location:** `_docs/content/5.stacks/+custom/`  
**Stack Files:** `+custom/<stack-name>/`  
**Management Interface:** `kompose.sh`
