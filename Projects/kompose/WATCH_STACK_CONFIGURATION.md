# Watch Stack Environment Configuration

## Overview

The watch stack provides comprehensive monitoring and observability capabilities for the Kompose platform through an integrated suite of open-source tools. This stack implements a complete observability solution encompassing metrics collection and visualization, log aggregation and analysis, distributed tracing capabilities, and alert management and notification systems. The environment configuration for this stack has been comprehensively defined in the root environment files with appropriate WATCH_ prefixes to ensure proper variable scoping and management.

## Stack Components

The watch stack comprises multiple specialized services that work together to provide complete platform observability. Each component serves a specific purpose within the monitoring ecosystem and requires dedicated environment configuration to function correctly.

### Prometheus - Metrics Collection and Storage

Prometheus serves as the primary metrics collection and storage system, implementing a pull-based model to gather time-series data from instrumented services and exporters throughout the platform. The service maintains a local time-series database with configurable retention periods to balance storage requirements against historical data availability.

The Prometheus configuration defines the Docker image to use for the service, specifying the official Prometheus image from the prom organization. The retention period determines how long metrics data persists in the database, with a default configuration of thirty days providing a balance between historical analysis capabilities and storage consumption. The service exposes its web interface and API on port 9090, enabling access to the query interface and integration with visualization tools.

Basic authentication protects the Prometheus interface in production deployments, with credentials configured through htpasswd-formatted authentication strings stored in the secrets configuration. Traefik routing enables secure external access to Prometheus through the configured subdomain with automatic SSL certificate management.

### Grafana - Metrics Visualization and Dashboarding

Grafana provides sophisticated visualization capabilities for metrics collected by Prometheus, offering interactive dashboards, flexible querying interfaces, and comprehensive alerting features. The service connects to Prometheus as its primary data source while supporting additional data sources for comprehensive observability.

The Grafana configuration specifies the Docker image, administrative credentials, and plugin installations. The default plugin set includes clock panels for time display, simple JSON data source support, pie chart visualizations, and world map geographic displays. These plugins extend Grafana's native visualization capabilities to support diverse dashboard requirements.

Database persistence for Grafana configuration, dashboards, and user data utilizes the PostgreSQL database provided by the core stack. This database integration ensures that Grafana configuration persists across container restarts and enables consistent dashboard availability for all platform operators. The database connection parameters reference the dedicated Grafana database and user account with appropriate credentials stored in the secrets configuration.

The Grafana web interface exposes on port 3010 to avoid conflicts with other services using standard ports. Traefik routing provides secure external access through the configured subdomain with automatic SSL termination, enabling dashboard access from any location while maintaining security through HTTPS encryption.

### OpenTelemetry Collector - Telemetry Pipeline

The OpenTelemetry Collector implements a vendor-agnostic telemetry data pipeline capable of receiving, processing, and exporting metrics, traces, and logs. This service provides flexible data routing capabilities that enable sophisticated telemetry workflows and integration with multiple observability backends.

The collector configuration specifies the community-contributed OpenTelemetry image that includes extensive receiver, processor, and exporter support. The service exposes multiple ports for different protocols including OTLP gRPC on port 4317, OTLP HTTP on port 4318, health check endpoints on port 13133, and zPages debugging interface on port 55679. This multi-protocol support enables integration with diverse application instrumentation approaches.

Configuration for the OpenTelemetry Collector resides in a YAML file mounted into the container, defining the specific receivers, processors, and exporters appropriate for the Kompose platform observability requirements. This file-based configuration approach enables sophisticated pipeline customization without requiring environment variable proliferation.

### Database and Service Exporters

The watch stack includes specialized exporters that extract metrics from core platform services and expose them in Prometheus-compatible formats. These exporters enable comprehensive monitoring of infrastructure components that do not natively expose Prometheus metrics.

#### PostgreSQL Exporter

The PostgreSQL Exporter connects to the core PostgreSQL database and extracts detailed database metrics including connection statistics, query performance data, table and index sizes, transaction rates, and replication status. The exporter uses a dedicated database user with appropriate read permissions to gather metrics without impacting database performance.

Configuration specifies the exporter image, database connection parameters including the dedicated exporter user and password, and the port for metrics exposure. Custom query definitions in a YAML file enable collection of platform-specific metrics beyond the standard exporter capabilities, providing insights into application-specific database usage patterns.

#### Redis Exporter

The Redis Exporter extracts metrics from the core Redis cache including memory usage statistics, command execution rates, key space information, and replication status. The exporter authenticates using the Redis password configured for the core stack, ensuring secure metric collection without requiring additional credential management.

The exporter configuration defines the image to use and the port for metrics exposure. Connection parameters reference the core Redis container through Docker networking, maintaining consistent service discovery without hardcoded IP addresses.

#### MQTT Exporter

The MQTT Exporter subscribes to topics on the core MQTT broker and converts received messages into Prometheus metrics. This capability enables monitoring of event-driven workflows and IoT device communications passing through the platform message bus.

Configuration specifies the MQTT broker connection parameters, topic subscription patterns, protocol version settings, and metrics exposure port. The flexible topic subscription supports comprehensive message monitoring while avoiding excessive metric proliferation through thoughtful topic pattern design.

### Container and Host Monitoring

Comprehensive platform observability requires monitoring both containerized applications and the underlying host infrastructure. The watch stack includes specialized tools for these monitoring requirements.

#### cAdvisor - Container Metrics

cAdvisor provides detailed metrics about running containers including CPU usage statistics, memory consumption patterns, network traffic volumes, filesystem I/O operations, and process information. This container-level visibility enables identification of resource constraints, performance bottlenecks, and capacity planning requirements.

The cAdvisor configuration requires privileged container execution to access host system information necessary for comprehensive container monitoring. Volume mounts provide access to Docker socket, system filesystems, and kernel information required for metric collection. The service exposes its metrics and web interface on port 8082.

#### Node Exporter - Host System Metrics

Node Exporter collects metrics from the underlying host system including CPU utilization, memory usage, disk I/O statistics, network interface statistics, and filesystem capacity information. This host-level monitoring complements container metrics to provide complete infrastructure visibility.

The exporter runs in host network mode to access system information directly without network namespace isolation. Volume mounts provide read-only access to proc, sys, and root filesystems required for comprehensive metric collection. The configuration specifies mount point exclusion patterns to focus metrics on relevant filesystems while avoiding temporary or virtual filesystem noise.

### Endpoint Monitoring

The Blackbox Exporter enables active monitoring of HTTP, HTTPS, TCP, ICMP, and DNS endpoints through probing operations. This capability supports uptime monitoring, SSL certificate expiration tracking, response time measurement, and endpoint availability verification.

Configuration defines the exporter image and metrics exposure port. Probe definitions in a YAML configuration file specify the endpoints to monitor, probe types to execute, and success criteria for each check. This file-based configuration enables flexible endpoint monitoring without environment variable proliferation.

### Log Aggregation

The watch stack implements centralized log collection and analysis through Loki and Promtail, providing capabilities similar to Elasticsearch but with lower resource requirements and tighter Prometheus integration.

#### Loki - Log Storage and Query

Loki provides efficient log storage and powerful query capabilities using a label-based indexing approach similar to Prometheus. This architecture enables fast log queries across large data volumes while maintaining reasonable storage requirements through intelligent compression and indexing strategies.

The Loki configuration specifies the Docker image and service port for API access. Configuration file mounts define storage backends, retention policies, and query limits appropriate for the Kompose platform log volumes. Basic authentication protects the Loki interface in production deployments, with credentials configured through the secrets system.

Traefik routing provides secure external access to the Loki query interface, enabling log analysis from any location while maintaining security through HTTPS encryption and authentication requirements.

#### Promtail - Log Collection

Promtail acts as the log collection agent, reading log files from the host system and Docker container logs, applying label enrichment based on configuration rules, and forwarding structured log entries to Loki for storage and analysis.

The Promtail configuration specifies the Docker image and service port for status monitoring. Volume mounts provide access to system log directories and Docker socket for comprehensive log collection across all platform components. Configuration file mounts define log sources, parsing rules, label extraction patterns, and Loki forwarding targets.

### Alert Management

Alertmanager receives alerts from Prometheus, implements alert grouping and deduplication logic, routes alerts to appropriate notification channels based on configured rules, and manages alert silencing and inhibition policies.

The Alertmanager configuration specifies the Docker image and service port for API access. Configuration file mounts define alert routing rules, notification channel integrations, grouping policies, and inhibition rules appropriate for platform operational requirements. Basic authentication protects the Alertmanager interface in production, with credentials configured through the secrets system.

Traefik routing enables secure external access to the alert management interface, supporting alert acknowledgment, silencing operations, and status monitoring from any location while maintaining security through HTTPS encryption and authentication.

## Environment Variable Organization

The watch stack environment configuration follows the established Kompose pattern of prefixing all stack-specific variables with the stack identifier. This prefixing approach ensures clear variable scoping, prevents naming conflicts across stacks, and maintains consistent configuration patterns throughout the platform.

All watch stack variables use the WATCH_ prefix, clearly indicating their association with the observability infrastructure. Within this prefixed namespace, variables organize logically by service, with related configuration values grouped together for maintainability. Image specifications define the Docker images to use for each service, enabling version pinning and registry management. Port configurations specify the ports each service exposes, supporting customization to avoid conflicts with other platform services or external systems. Database connection parameters reference the PostgreSQL resources required by services like Grafana that maintain persistent state.

## Secrets Management

Several watch stack services require sensitive credentials for authentication, API access, or service integration. These credentials are managed through the centralized secrets system rather than being included in the public environment configuration.

The Prometheus authentication variable stores htpasswd-formatted credential strings that protect the Prometheus web interface from unauthorized access. The Grafana administrative password controls access to the Grafana installation with full configuration permissions. The Grafana database password enables Grafana to authenticate against its dedicated PostgreSQL database for persistent storage. The PostgreSQL exporter password allows the metrics exporter to authenticate against the database for metrics collection. The Redis exporter password enables the exporter to authenticate against Redis for metrics gathering. The Loki authentication variable protects the log storage interface with htpasswd-formatted credentials. The Alertmanager authentication variable secures the alert management interface similarly.

These sensitive values are stored in the root secrets.env file following the same WATCH_ prefixing convention as public configuration. The secrets generation utility can create secure random values for these credentials, ensuring strong authentication without requiring manual password management.

## Traefik Integration

Services within the watch stack that provide web interfaces integrate with the platform's Traefik reverse proxy for external access, SSL termination, and authentication enforcement. This integration requires subdomain configuration and Traefik host variable generation.

The domain configuration file includes subdomain definitions for Prometheus, Grafana, Loki, and Alertmanager services. These subdomain definitions follow the established pattern used throughout the platform, enabling consistent URL structures for service access. The environment generation system automatically constructs full domain names from these subdomain definitions combined with the root domain, creating the Traefik host variables referenced in service compose files.

In production deployments, services become accessible through URLs constructed from their subdomains and the platform domain. Prometheus metrics interface is available at the prometheus subdomain, providing query access and basic metric exploration. Grafana dashboards are accessible through the grafana subdomain, offering comprehensive visualization and analysis capabilities. Loki log interface is available through the loki subdomain for direct log querying when needed. Alertmanager interface is accessible through the alerts subdomain for alert management operations.

These external access points are protected by HTTPS encryption through Traefik's automatic Let's Encrypt integration and basic authentication configured through the Traefik middleware system.

## Database Configuration

The Grafana service requires a PostgreSQL database for persistent storage of dashboards, data sources, user accounts, and plugin configuration. This database integration follows the standard Kompose pattern for database connectivity.

A dedicated database named grafana is created during core stack initialization, providing isolated storage for Grafana data. A dedicated database user named grafana with appropriate permissions grants Grafana access to its database without providing broader database system access. The database host references the core PostgreSQL container name, enabling reliable container-to-container communication through Docker networking. The database password is stored in the secrets configuration and mapped to the appropriate environment variable during environment generation.

This database integration ensures that Grafana configuration persists across container restarts and enables consistent dashboard availability for platform operators. Database backups created through the Kompose database management commands include the Grafana database, protecting visualization configuration alongside application data.

## Port Allocation

The watch stack services require multiple port allocations to avoid conflicts with other platform services and enable external access where appropriate. Port assignments balance the need for direct access during development with security requirements for production deployments.

Prometheus exposes its web interface and API on port 9090, providing standard Prometheus access patterns. Grafana uses port 3010 rather than its default port 3000 to avoid conflicts with Semaphore and other services. OpenTelemetry Collector exposes multiple ports for different protocol support, with OTLP gRPC on port 4317, OTLP HTTP on port 4318, health checks on port 13133, and zPages on port 55679. Various exporters use service-specific ports including PostgreSQL exporter on port 9187, Redis exporter on port 9121, and MQTT exporter on port 9000. Additional monitoring services use allocated ports including cAdvisor on port 8082, Blackbox exporter on port 9115, Loki on port 3100, Promtail on port 9080, and Alertmanager on port 9093.

These port assignments are documented in the environment configuration and can be customized if conflicts arise with other infrastructure components or organizational port allocation policies.

## Configuration Verification

The comprehensive watch stack environment configuration can be verified through several mechanisms provided by the Kompose platform. Environment file generation creates .env.generated files in the watch stack directory that include all resolved variables, enabling quick verification that expected values are present. The environment validation command checks that required variables are defined and that configuration follows expected patterns. Stack compose file validation confirms that Docker Compose can parse the configuration and that all variable references resolve correctly. Test stack startup in development environments verifies that services start correctly with the configured environment variables and that inter-service connectivity functions as expected.

These verification mechanisms help identify configuration issues before they impact production operations, ensuring reliable observability infrastructure availability.

## Operational Implications

The comprehensive watch stack environment configuration enables several important operational capabilities. Centralized configuration management through root environment files simplifies administration by eliminating the need to edit multiple per-service configuration files. Version control integration captures configuration changes alongside application code, providing audit trails and rollback capabilities. Environment-specific configuration through separate .env and .env.production files enables different settings for development and production while maintaining consistency in variable structure. Secrets isolation through the dedicated secrets.env file prevents accidental exposure of sensitive credentials in version control or logs.

The consistent variable prefixing and organization patterns established for the watch stack apply equally to other platform stacks, ensuring that operators develop familiarity with configuration approaches that transfer across the entire system.

## Conclusion

The watch stack environment configuration provides comprehensive definition of all variables required for monitoring and observability infrastructure operation. The configuration follows established Kompose patterns including variable prefixing, secrets separation, and centralized management through root environment files. This approach ensures that the watch stack benefits from the same configuration management capabilities as other platform components while maintaining the specialized settings required for comprehensive observability functionality.

The detailed variable definitions enable precise control over service behavior, resource allocation, and integration patterns while maintaining clear documentation of configuration requirements and their purposes. This comprehensive configuration foundation supports reliable monitoring infrastructure operation across diverse deployment scenarios.

---

**Configuration Files:** .env, .env.production, domain.env, secrets.env  
**Variable Prefix:** WATCH_  
**Stack Directory:** watch/  
**Documentation:** WATCH_STACK_CONFIGURATION.md
