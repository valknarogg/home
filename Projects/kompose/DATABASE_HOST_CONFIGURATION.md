# Database Host Configuration

## Overview

The Kompose platform requires precise configuration of database connection parameters to enable reliable inter-container communication within the Docker networking environment. The database host variable plays a critical role in ensuring that application containers can successfully connect to the PostgreSQL database service provided by the core stack.

## Container Name Configuration

The database host variable is explicitly configured to reference the PostgreSQL container by its Docker container name rather than using localhost or IP address references. This configuration approach leverages Docker's internal DNS resolution capabilities to enable seamless service discovery and connection establishment.

### DB_HOST Variable Setting

The DB_HOST environment variable is set to "core-postgres" across all stack configurations and environment generation processes. This value corresponds to the container name defined in the core stack's Docker Compose configuration, ensuring consistent and reliable container-to-container communication.

The implementation enforces this configuration at multiple levels within the system architecture. The root environment files (.env and .env.production) explicitly define CORE_DB_HOST as "core-postgres" with inline documentation explaining the rationale. The environment mapping function in the kompose-env.sh module exports DB_HOST directly as "core-postgres" without fallback logic that might introduce alternative values. The generated environment files created for each stack include explicit DB_HOST declarations hardcoded to "core-postgres" to guarantee correct configuration regardless of variable inheritance patterns.

## Technical Rationale

Docker networking provides internal DNS resolution that maps container names to their current IP addresses within the Docker network. When containers communicate using container names rather than IP addresses or localhost references, they benefit from several important capabilities. Docker automatically resolves the container name to the current IP address of the target container, enabling reliable connections even when container IP addresses change due to recreation or network reconfiguration. The Docker network infrastructure provides isolation and security by limiting connectivity to containers that share the same Docker network. Container name resolution works consistently across different Docker host environments without requiring environment-specific IP address configuration.

The use of "localhost" as a database host would only function correctly for connections initiated from the Docker host machine itself, not for connections between containers. Containers attempting to connect to "localhost" would resolve that reference to their own internal loopback interface rather than the PostgreSQL container, resulting in connection failures. Similarly, hardcoded IP addresses would be fragile and prone to breaking when containers are recreated with new IP addresses assigned by Docker's DHCP mechanism.

## Implementation Details

### Environment File Configuration

Both development and production environment files include explicit CORE_DB_HOST configuration with documentation explaining its purpose. The configuration uses inline comments to clarify that the container name enables inter-container communication rather than host machine access.

The configuration appears in the core stack configuration section as follows:

```bash
# PostgreSQL Configuration
CORE_POSTGRES_IMAGE=postgres:16-alpine
DB_USER=kompose
CORE_DB_NAME=kompose
CORE_DB_PORT=5432
CORE_DB_HOST=core-postgres  # Container name for inter-container communication
CORE_POSTGRES_MAX_CONNECTIONS=100
CORE_POSTGRES_SHARED_BUFFERS="256MB"
```

This explicit configuration in the root environment files establishes the foundation for all subsequent variable resolution and environment generation processes.

### Environment Mapping Function

The map_stack_variables function in the kompose-env.sh module has been enhanced to explicitly set DB_HOST without relying on variable substitution that might introduce incorrect values. The implementation includes critical inline documentation explaining the importance of this configuration.

```bash
# Export database connection variables for easy access
# CRITICAL: DB_HOST must always be set to the container name for inter-container communication
export DB_HOST="core-postgres"  # Container name from core stack
export DB_PORT="${CORE_DB_PORT:-5432}"
export DB_USER="${DB_USER:-kompose}"
export DB_PASSWORD="${CORE_DB_PASSWORD:-${DB_PASSWORD}}"
```

This direct assignment ensures that regardless of how CORE_DB_HOST might be configured in various environment files, the actual DB_HOST variable exported to containers always resolves to the correct container name.

### Generated Environment Files

The generate_stack_env_file function produces .env.generated files for each stack that include explicit DB_HOST configuration with documentation. These generated files serve as the authoritative environment source for Docker Compose operations, making the correct database host configuration immediately visible during troubleshooting activities.

The generated files include the following database connection section:

```bash
# Database connection (container-to-container)
# CRITICAL: DB_HOST must be the container name for inter-container communication
DB_HOST=core-postgres
DB_PORT=5432
DB_USER=kompose
DB_PASSWORD=<from-secrets>
```

This explicit inclusion in generated environment files ensures that stack maintainers can quickly verify correct configuration and understand the rationale for the specific host value.

## Container Name Verification

The PostgreSQL container name "core-postgres" is defined in the core stack's Docker Compose configuration through the container_name directive. This directive ensures that Docker creates the container with a predictable, stable name that other services can reference reliably.

The core stack compose file specifies the container name as follows:

```yaml
services:
  postgres:
    image: ${CORE_POSTGRES_IMAGE}
    container_name: core-postgres
    # Additional configuration...
```

This explicit container naming prevents Docker from generating random or project-prefixed container names, ensuring that the "core-postgres" reference remains valid across stack restarts and redeployments.

## Network Configuration Requirements

For container-to-container communication using container names to function correctly, all participating containers must be connected to the same Docker network. The Kompose platform establishes a shared network named "kompose" that provides connectivity across all stacks.

Each stack's compose file includes network configuration that connects services to this shared network:

```yaml
networks:
  kompose_network:
    name: kompose
    external: true
```

The external flag indicates that the network exists independently of any single stack, allowing containers from different compose projects to communicate. The consistent network name across all stacks ensures that DNS resolution for container names functions correctly throughout the platform.

## Connection String Examples

Application containers connect to PostgreSQL using connection strings or configuration parameters that reference the DB_HOST variable. The specific format varies by application framework and database driver, but all approaches utilize the same container name for the host component.

### Standard Connection Parameters

Applications using separate configuration parameters for each connection component would configure as follows:

```
Host: core-postgres
Port: 5432
Database: application_db
User: kompose
Password: <from-secrets>
```

### Connection String Format

Applications using connection string formats would construct strings similar to:

```
postgresql://kompose:<password>@core-postgres:5432/application_db
```

### Docker Compose Environment Variables

Stack compose files reference the DB_HOST variable when configuring application services:

```yaml
services:
  application:
    environment:
      DB_HOST: ${DB_HOST}
      DB_PORT: ${DB_PORT}
      DB_USER: ${DB_USER}
      DB_PASSWORD: ${DB_PASSWORD}
      DB_NAME: application_db
```

The variable substitution ensures that the correct container name propagates to application configuration regardless of how the application consumes database connection parameters.

## Troubleshooting Connection Issues

When database connection failures occur, verification of the DB_HOST configuration should be among the first diagnostic steps. Several verification approaches can confirm correct configuration.

### Environment Variable Verification

Inspect the generated environment file for the affected stack to confirm DB_HOST configuration:

```bash
cat <stack-directory>/.env.generated | grep DB_HOST
```

The output should show "DB_HOST=core-postgres" without any alternative values or variable references.

### Container Environment Inspection

Examine the actual environment variables present within a running container:

```bash
docker exec <container-name> env | grep DB_HOST
```

This command displays the DB_HOST value as it appears within the container's runtime environment, confirming that the configuration has propagated correctly through the environment generation and Docker Compose processes.

### Network Connectivity Testing

Verify that the application container can resolve and reach the PostgreSQL container:

```bash
# Test DNS resolution
docker exec <container-name> nslookup core-postgres

# Test network connectivity
docker exec <container-name> ping -c 3 core-postgres

# Test PostgreSQL port accessibility
docker exec <container-name> nc -zv core-postgres 5432
```

These diagnostic commands confirm that Docker networking provides proper name resolution and connectivity between containers, eliminating network configuration as a potential failure cause.

### Common Configuration Errors

Several configuration mistakes can prevent successful database connections. Setting DB_HOST to "localhost" causes applications to attempt connections to their own container's loopback interface rather than the PostgreSQL container. Using IP addresses instead of container names introduces fragility as IP addresses may change when containers are recreated. Failing to connect containers to the same Docker network prevents DNS resolution and connectivity regardless of host configuration.

## Host Machine Access

While container-to-container communication requires the container name "core-postgres" as the host reference, connections initiated from the Docker host machine use different addressing. The core stack's compose file exposes PostgreSQL's port 5432 on the host machine, enabling direct access from development tools and administrative utilities.

Host machine connections use the following parameters:

```
Host: localhost (or 127.0.0.1)
Port: 5432
Database: application_db
User: kompose
Password: <from-secrets>
```

This dual-addressing approach enables both container applications and host-based tools to access the database appropriately. Containers use the container name for their connections, while host machine processes use localhost for theirs. The PostgreSQL container listens on all interfaces, allowing it to accept connections from both sources simultaneously.

## Security Considerations

The use of Docker networking with container name resolution provides inherent security benefits. Containers outside the "kompose" network cannot resolve or connect to "core-postgres" regardless of knowledge of the container name, providing network-level isolation. The database port exposure on the host machine can be restricted or removed entirely for production deployments that only require container-to-container access. Firewall rules on the host machine can further restrict access to the exposed database port if needed.

Organizations deploying Kompose in production environments should evaluate whether host machine access to the database is required for their operational procedures. If all database access occurs through application containers and the Kompose management interface, removing the port mapping from the core stack's compose file eliminates a potential attack vector.

## Documentation References

This database host configuration integrates with broader Kompose platform capabilities documented elsewhere in the system documentation. The core stack documentation describes the complete PostgreSQL service configuration including networking, volume management, and initialization procedures. The environment management documentation explains the overall variable resolution and inheritance system that supports this configuration. The custom stack documentation provides guidance on configuring database connectivity for user-defined services.

## Conclusion

The explicit configuration of DB_HOST as "core-postgres" establishes reliable inter-container database connectivity throughout the Kompose platform. This configuration leverages Docker's internal DNS resolution capabilities to provide stable, maintainable database connections that function consistently across diverse deployment environments. The multi-level enforcement of this configuration across environment files, mapping functions, and generated configurations ensures that all stacks receive correct database host parameters regardless of the complexity of their individual configurations.

---

**Configuration Value:** DB_HOST=core-postgres  
**Container Name:** core-postgres  
**Network:** kompose  
**Implementation:** kompose-env.sh, .env, .env.production  
**Related Documentation:** Core Stack, Environment Management
