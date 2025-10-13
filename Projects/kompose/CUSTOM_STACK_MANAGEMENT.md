# Custom Stack Management System

## Overview

The Kompose platform has been enhanced with automatic discovery and management capabilities for custom Docker Compose stacks. This system enables seamless integration of user-defined services while maintaining the unified management interface provided by the core `kompose.sh` command-line utility.

## Architecture

### Automatic Discovery Mechanism

The platform implements a dynamic discovery system that scans the `+custom` directory during initialization to identify and register all available custom stacks. This discovery process executes automatically when the `kompose.sh` script loads, ensuring that custom stacks receive the same operational capabilities as built-in platform services.

### Dual Stack Registry

The system maintains two separate stack registries to differentiate between platform-provided services and user-defined extensions:

**Built-in Stacks Registry** - The `STACKS` associative array contains all core platform services including authentication, database management, automation tooling, and infrastructure components. These stacks represent the foundational Kompose platform capabilities and include comprehensive descriptions of their functionality.

**Custom Stacks Registry** - The `CUSTOM_STACKS` associative array dynamically populates with user-defined services discovered in the `+custom` directory. Each custom stack entry includes an automatically extracted description from the stack's configuration files, providing context about the service's purpose and capabilities.

### Directory Structure

Custom stacks reside in the `+custom` directory at the project root, maintaining clear separation from built-in platform components while enabling unified management through the standard command interface:

```
kompose/
├── +custom/
│   ├── blog/
│   │   ├── compose.yaml
│   │   ├── .env
│   │   └── .env.local
│   ├── sexy/
│   │   ├── compose.yaml
│   │   ├── .env
│   │   ├── .env.local
│   │   ├── Dockerfile
│   │   ├── hooks.sh
│   │   └── uploads/
│   └── myapp/
│       ├── compose.yaml
│       └── .env
├── core/
├── auth/
├── proxy/
└── ... (other built-in stacks)
```

## Implementation Details

### Stack Discovery Function

The `discover_custom_stacks()` function executes during script initialization to identify and register custom services. This function performs the following operations:

**Directory Scanning** - Iterates through all subdirectories within the `+custom` directory to identify potential stack locations.

**Validation** - Verifies that each subdirectory contains a valid `compose.yaml` file, the essential component for Docker Compose stack operation.

**Description Extraction** - Attempts to extract descriptive information from the stack's `.env` file by searching for comment lines containing "Stack" keywords. This provides contextual information about the stack's purpose when displayed in listings.

**Registry Population** - Adds validated stacks to the `CUSTOM_STACKS` associative array with their discovered descriptions, making them available for all management operations.

### Stack Existence Verification

The enhanced `stack_exists()` function implements a fallback mechanism to locate stacks across both registry types:

**Primary Location Check** - First attempts to locate the stack in the built-in stacks directory at the project root.

**Custom Location Check** - If the primary check fails, searches for the stack within the `+custom` directory.

**Error Reporting** - Provides comprehensive feedback indicating which locations were searched when a stack cannot be located, facilitating troubleshooting.

### Stack Enumeration

The updated `get_all_stacks()` function aggregates stacks from both registries to provide comprehensive stack listings:

**Built-in Stack Discovery** - Scans the project root for directories containing valid compose files, excluding special directories like backups and templates.

**Custom Stack Discovery** - Separately scans the `+custom` directory for additional stacks, excluding non-stack files such as README documentation.

**Unified Results** - Returns a complete list of all available stacks regardless of their location, enabling operations that target all services.

### Environment Configuration

The environment management subsystem has been enhanced to correctly resolve stack locations for custom services:

**Dynamic Path Resolution** - The `load_stack_env()` function now determines the correct stack directory by checking both built-in and custom locations before loading environment configuration.

**Environment File Generation** - The `generate_stack_env_file()` function creates `.env.generated` files in the appropriate stack directory, whether built-in or custom.

**Compose Integration** - The `export_stack_env()` function correctly sets the `COMPOSE_ENV_FILE` variable to reference the generated environment file in the stack's actual location.

### Stack Listing Display

The enhanced `list_stacks()` function provides visual differentiation between stack types in command output:

**Built-in Stacks Section** - Displays core platform services under a "Built-in Stacks" header with blue coloring to indicate their foundational nature.

**Custom Stacks Section** - Shows user-defined services under a "Custom Stacks" header with magenta coloring to distinguish them from platform services.

**Status Information** - Both sections include container status information showing the ratio of running containers to total services defined in each stack.

## Usage Patterns

### Listing Available Stacks

The `list` command provides comprehensive visibility into all available services:

```bash
./kompose.sh list
```

This command produces output organized by stack type, clearly distinguishing between platform-provided and user-defined services. Each stack entry includes a description and current operational status.

### Managing Custom Stacks

All standard management commands operate identically on custom stacks as they do on built-in services:

**Stack Lifecycle Operations:**
```bash
# Start a custom stack
./kompose.sh up blog

# Stop a custom stack
./kompose.sh down sexy

# Restart a custom stack
./kompose.sh restart myapp
```

**Monitoring and Diagnostics:**
```bash
# Check stack status
./kompose.sh status blog

# View logs in real-time
./kompose.sh logs sexy -f

# Display recent log entries
./kompose.sh logs myapp --tail 100
```

**Image Management:**
```bash
# Pull latest images
./kompose.sh pull blog

# Rebuild custom images
./kompose.sh build sexy

# Deploy specific version
./kompose.sh deploy myapp 1.2.0
```

**Container Operations:**
```bash
# Execute commands in containers
./kompose.sh exec blog sh

# Run specific commands
./kompose.sh exec sexy npx directus --help
```

### Creating New Custom Stacks

The platform provides two approaches for creating custom stacks:

**Generator-Based Creation:**
```bash
./kompose.sh generate mynewstack
```

This approach creates a complete stack structure including compose configuration, environment templates, documentation, and test files.

**Manual Creation:**
```bash
# Create directory structure
mkdir -p +custom/mynewstack

# Create compose file
touch +custom/mynewstack/compose.yaml

# Create environment configuration
touch +custom/mynewstack/.env

# Stack is automatically discovered on next kompose.sh execution
```

## Integration Features

### Domain Configuration

Custom stacks integrate seamlessly with the centralized domain management system. Subdomain definitions in the root `domain.env` file automatically generate Traefik host variables for custom services:

```bash
# In domain.env
SUBDOMAIN_MYSTACK=mystack

# Automatically generates:
# TRAEFIK_HOST_MYSTACK=mystack.yourdomain.com
```

### Secrets Management

Custom stacks access the centralized secrets management system through the root `secrets.env` file. Stack-specific secrets follow the naming convention `STACKNAME_SECRET_NAME` for consistent organization:

```bash
# In secrets.env
BLOG_API_KEY=secret-key-here
SEXY_SECRET=directus-secret
SEXY_ADMIN_PASSWORD=admin-password
```

### Database Integration

Custom stacks requiring database connectivity inherit connection parameters from the core stack configuration:

```bash
DB_HOST=core-postgres
DB_PORT=5432
DB_USER=valknar
DB_PASSWORD=${CORE_DB_PASSWORD}
```

Database management operations work identically for custom stack databases:

```bash
# Create database for custom stack
./kompose.sh db exec -d postgres "CREATE DATABASE mystack;"

# Backup custom stack database
./kompose.sh db backup -d mystack

# Restore from backup
./kompose.sh db restore -f backups/database/mystack_timestamp.sql
```

### Traefik Integration

Custom stacks achieve automatic HTTPS and routing capabilities through standardized Traefik label configuration in their compose files. The system handles SSL certificate acquisition, HTTP to HTTPS redirection, and compression middleware automatically.

## Technical Benefits

### Unified Management Interface

Custom stacks receive identical operational capabilities to built-in services, eliminating the need for separate management procedures or custom scripts. All functionality available for platform services applies equally to custom additions.

### Automatic Discovery

The discovery mechanism eliminates manual registration requirements. Simply placing a valid compose stack in the `+custom` directory makes it immediately available for management operations.

### Environment Consistency

Custom stacks benefit from the same environment variable inheritance, domain configuration, and secrets management as platform services, ensuring consistent configuration patterns across all deployments.

### Operational Transparency

The differentiated stack listing clearly identifies which services are platform components and which are custom extensions, providing operational clarity while maintaining unified management capabilities.

## Migration Considerations

### Existing Custom Stacks

Custom stacks created prior to this enhancement require no modifications to function with the automatic discovery system. The system detects and manages them automatically, maintaining backward compatibility.

### Documentation Updates

Custom stack documentation in the `_docs/content/5.stacks/+custom/` directory continues to function as before, providing comprehensive reference material for each service.

### Testing and Validation

All existing test suites and validation procedures apply to custom stacks through the standard testing framework. No separate testing infrastructure is required for custom services.

## Support and Troubleshooting

### Verifying Stack Discovery

Confirm that custom stacks have been discovered correctly:

```bash
./kompose.sh list
```

The output should include a "Custom Stacks" section listing all stacks from the `+custom` directory.

### Stack Not Appearing

If a custom stack does not appear in the listing:

**Verify Directory Structure** - Ensure the stack directory exists within `+custom` and contains a `compose.yaml` file.

**Check File Naming** - Confirm the compose file is named exactly `compose.yaml` (not `docker-compose.yaml` or other variations).

**Validate Compose File** - Test the compose file syntax using `docker compose config` in the stack directory.

**Review Error Messages** - Check for any error output during kompose.sh initialization that might indicate discovery issues.

### Operation Failures

If operations fail on custom stacks:

**Stack Existence Check** - Verify the stack passes validation with `./kompose.sh validate stackname`.

**Environment Configuration** - Review the generated `.env.generated` file in the stack directory for correct variable values.

**Compose Validation** - Test the compose configuration directly with `cd +custom/stackname && docker compose config`.

**Container Logs** - Examine container logs for service-specific errors with `./kompose.sh logs stackname`.

## Future Enhancements

The custom stack management system provides a foundation for additional capabilities including automated testing frameworks for custom stacks, template library expansion with additional stack patterns, enhanced metadata extraction from stack configurations, and integration with continuous deployment pipelines.

## Conclusion

The enhanced custom stack management system provides a robust framework for extending the Kompose platform while maintaining operational consistency. The automatic discovery mechanism, unified management interface, and comprehensive integration features enable seamless addition of custom services without compromising the platform's management capabilities or operational clarity.

---

**Implementation Date:** October 2025  
**Version:** 2.0.0  
**Affected Modules:** kompose.sh, kompose-stack.sh, kompose-env.sh  
**Documentation:** CUSTOM_STACK_MANAGEMENT.md
