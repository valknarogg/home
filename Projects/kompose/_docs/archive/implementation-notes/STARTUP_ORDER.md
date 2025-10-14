# Stack Startup Order Documentation

## Overview

The Kompose platform implements an intelligent startup ordering system to ensure proper dependency resolution and service initialization. When executing operations that affect multiple stacks simultaneously, the system follows a carefully designed sequence that initializes foundational services before dependent components, ensuring reliable startup and graceful shutdown across the entire service ecosystem.

## Startup Order Specification

The system enforces the following startup sequence when the `up` command is executed without specifying a particular stack:

### Phase 1: Core Infrastructure (Foundational Services)

**Core Stack** - The core stack initializes first as it provides essential infrastructure services required by nearly all other platform components. This stack includes PostgreSQL for persistent data storage, Redis for caching and session management, and MQTT (Mosquitto) for event messaging. All subsequent services depend on one or more of these foundational components, making core stack initialization the critical first step in the startup sequence.

### Phase 2: Platform Services (Application Layer)

The platform services initialize in a specific order designed to establish the application layer while respecting inter-service dependencies:

**Chain Stack** - The automation platform initializes second, providing workflow orchestration through n8n and infrastructure automation through Semaphore. Other services may utilize chain stack capabilities for automated operations, deployment workflows, and operational automation, making early initialization beneficial for the broader platform ecosystem.

**Watch Stack** - The monitoring and observability platform initializes early in the sequence to begin capturing metrics, logs, and operational data from services as they start. This ensures comprehensive monitoring coverage from the earliest possible moment, providing visibility into the startup process and ongoing operations.

**Messaging Stack** - Communication services including notification delivery through Gotify and email testing capabilities through Mailhog initialize at this stage. These services provide essential communication infrastructure for user notifications, system alerts, and development workflow support.

**Code Stack** - The Git repository and continuous integration platform provided by Gitea initializes to establish version control and automated build capabilities. This stack supports development workflows, deployment automation, and configuration management across the platform.

**Home Stack** - The smart home automation platform featuring Home Assistant, Matter server, and related components initializes to provide IoT device management and home automation capabilities. This stack operates independently of most other services but benefits from core infrastructure availability.

**KMPS Stack** - The Kompose Management Portal provides centralized administration interfaces for user management, SSO configuration, and system oversight. This stack initializes after foundational services are available to ensure proper integration capabilities.

**Track Stack** - The analytics and activity tracking platform powered by Umami initializes to begin capturing user interaction data and system usage metrics. Early initialization ensures comprehensive tracking coverage across subsequently initialized services.

**Vault Stack** - The password management platform provided by Vaultwarden initializes to offer secure credential storage and management capabilities. This stack operates largely independently but requires database connectivity from the core stack.

**Link Stack** - The bookmark and link management platform through Linkwarden initializes to provide organizational capabilities for web resource management. This service depends primarily on database connectivity and operates independently of most other platform components.

### Phase 3: Network Services (Connectivity Layer)

**Proxy Stack** - The Traefik reverse proxy initializes after application services to provide HTTP routing, SSL termination, and load balancing capabilities. While many services configure Traefik integration through labels, the proxy itself can initialize relatively late in the sequence as services will connect to it once it becomes available.

**VPN Stack** - The WireGuard VPN access platform provided by wg-easy initializes to establish secure remote connectivity capabilities. This stack operates at the network layer and initializes after application services are established.

### Phase 4: Custom Extensions

**Custom Stacks** - All user-defined services located in the `+custom` directory initialize after built-in platform services. Custom stacks are sorted alphabetically and initialize in that order, providing predictable and consistent startup behavior for user extensions. This sequencing ensures that custom services can depend on the availability of core platform capabilities while maintaining flexibility in their own implementation.

### Phase 5: Documentation Services

**Documentation Stack** - The documentation service in the `_docs` directory initializes last in the startup sequence. Documentation services typically have minimal dependencies and serve as reference material rather than operational components, making late initialization appropriate. This stack provides the documentation website and reference materials for the platform.

## Shutdown Order Specification

When executing the `down` command to stop all stacks, the system applies the reverse of the startup order. This ensures graceful shutdown with dependent services stopping before the services they depend upon. The shutdown sequence proceeds from documentation services through custom stacks, networking components, application services, and finally core infrastructure.

The reverse ordering prevents service failures during shutdown that might occur if foundational services were terminated while dependent services were still operating. For example, stopping the database before stopping services that actively use it could result in connection errors, incomplete transactions, or data consistency issues.

## Implementation Architecture

### Ordered Stack Discovery

The `get_ordered_stacks()` function generates appropriately sequenced stack lists based on the requested operation type. For startup operations, this function returns stacks in dependency order. For shutdown operations, it returns the same list in reverse order. For informational operations such as status checking and validation, the function uses startup order to maintain consistent output formatting.

The function implements several key behaviors to ensure robust operation across diverse deployment scenarios. When a stack specified in the ordering list does not exist in the current installation, the function silently skips that stack rather than generating errors. This allows the ordering specification to include all possible stacks while gracefully handling partial installations.

The function includes any built-in stacks not explicitly listed in the ordering specification after the explicitly ordered stacks but before custom stacks. This ensures that additions to the platform's built-in stack catalog receive appropriate positioning without requiring immediate updates to the ordering specification.

### Custom Stack Integration

Custom stacks receive special handling to ensure predictable behavior while maintaining flexibility. The system discovers all custom stacks from the `+custom` directory and sorts them alphabetically. This alphabetic ordering provides predictable startup sequences for user-defined services while avoiding the need for manual ordering configuration.

Custom stacks initialize after all built-in platform services, ensuring that user extensions can depend on the availability of core platform capabilities. This positioning reflects the architectural principle that custom stacks extend the platform rather than providing foundational capabilities.

### Process Integration

The `process_all_stacks()` function determines the appropriate ordering strategy based on the command being executed. For the `up` and `restart` commands, the function requests startup ordering to ensure proper dependency resolution. For the `down` command, the function requests shutdown ordering to enable graceful termination. For informational commands such as `status`, `pull`, and `validate`, the function uses startup ordering to maintain consistent output presentation.

## Operational Implications

### Dependency Resolution

The ordered startup system automatically resolves inter-service dependencies without requiring explicit dependency declaration in compose files. Services that depend on database connectivity receive that connectivity by the time they initialize because the core stack containing the database initializes first. Services that depend on reverse proxy routing function correctly because they initialize before the proxy stack, allowing the proxy to discover them through service discovery mechanisms.

This automatic dependency resolution simplifies stack configuration and reduces the potential for startup failures caused by initialization order issues. Stack developers can focus on service functionality rather than complex dependency management.

### Startup Performance

The ordered startup system executes sequentially, initializing each stack completely before proceeding to the next stack in the sequence. This sequential approach ensures that each service reaches operational status before dependent services attempt to connect, reducing connection failures and retry overhead.

While sequential startup takes longer than parallel startup would require, it provides greater reliability and eliminates race conditions that can occur when multiple interdependent services initialize simultaneously. The reliability benefits typically outweigh the performance impact for most deployment scenarios.

### Troubleshooting Support

The consistent startup order simplifies troubleshooting by providing predictable service initialization sequences. When investigating startup failures, operators can focus on the specific point in the sequence where failures occur, knowing which services should have initialized successfully before that point.

The ordered shutdown sequence similarly aids troubleshooting by ensuring that dependent services stop cleanly before their dependencies become unavailable. This reduces spurious error messages and makes genuine issues more visible in logs.

## Usage Examples

### Full Platform Startup

To start all stacks in the proper dependency order:

```bash
./kompose.sh up
```

This command initializes the entire platform following the documented sequence, ensuring reliable startup across all services.

### Full Platform Shutdown

To stop all stacks with graceful shutdown ordering:

```bash
./kompose.sh down
```

This command terminates services in reverse dependency order, preventing cascade failures and ensuring clean shutdown.

### Selective Stack Operations

Individual stack operations bypass the ordering system as they target specific services:

```bash
# Start only the proxy stack (order not applied)
./kompose.sh up proxy

# Restart only the core stack (order not applied)
./kompose.sh restart core
```

When operating on individual stacks, dependency management becomes the operator's responsibility. The system does not prevent starting a dependent service before its dependencies, as such operations may be intentional during maintenance or troubleshooting activities.

### Status Checking with Ordered Output

Status checks follow startup order for consistent output presentation:

```bash
./kompose.sh status
```

This command displays stack status information in startup order, providing a logical flow from foundational services through application components to extensions.

## Customization Considerations

### Modifying Startup Order

The startup order specification resides in the `get_ordered_stacks()` function within the `kompose-stack.sh` module. Operators requiring different ordering can modify the `startup_order` array to reflect their specific dependency requirements and operational preferences.

When modifying the startup order, consider the following principles to maintain system reliability. Services providing infrastructure capabilities should initialize before services consuming those capabilities. Monitoring services should initialize early to capture comprehensive operational data from dependent services. Network services such as proxies and VPN can initialize relatively late as services connect to them dynamically.

### Adding New Built-in Stacks

When adding new stacks to the platform's built-in catalog, developers should evaluate appropriate positioning within the startup sequence. Stacks providing foundational capabilities should be positioned early in the sequence, while stacks providing application functionality can be positioned later.

If a new stack does not require specific positioning relative to other stacks, omitting it from the explicit ordering allows it to initialize after explicitly ordered stacks but before custom extensions, providing reasonable default behavior.

### Custom Stack Ordering

The current implementation initializes custom stacks alphabetically without configuration options for custom ordering. Organizations requiring specific ordering among custom stacks can implement that ordering through careful naming conventions or by modifying the custom stack discovery logic to support ordering metadata in stack configuration files.

## Monitoring and Validation

### Startup Monitoring

The system provides visual feedback during startup operations, displaying progress as each stack initializes. Operators can monitor this output to identify slow-starting services or initialization failures. The sequential nature of the startup process makes it clear which service is currently initializing and which services have completed initialization.

### Validation Commands

The validate command processes stacks in startup order, providing logical flow in validation output:

```bash
./kompose.sh validate
```

This command checks configuration validity for all stacks in dependency order, ensuring that foundational services validate before dependent services.

## Best Practices

Organizations deploying the Kompose platform should consider the following best practices for optimal startup and shutdown behavior. Avoid manual intervention during automated startup sequences, allowing the system to complete initialization naturally. Monitor startup output to identify services that consistently exhibit slow initialization times, as these may indicate configuration issues or resource constraints.

When troubleshooting startup failures, examine the service immediately preceding the failure point in the startup sequence, as dependency issues often manifest in the dependent service rather than the dependency itself. Maintain the documented startup order unless specific operational requirements demand alternative sequencing, as the specified order reflects extensive testing and production experience.

Regular validation of the entire platform using the validate command ensures that configuration changes have not introduced issues that might affect startup reliability. Scheduled validation runs can detect configuration drift before it impacts operations.

## Conclusion

The ordered startup system provides reliable, predictable service initialization across the Kompose platform. By automatically managing dependencies through sequential initialization, the system eliminates common startup failures and simplifies operational procedures. The consistent ordering supports troubleshooting activities and provides clear visibility into platform initialization status.

---

**Version:** 2.0.0  
**Implementation:** kompose-stack.sh  
**Function:** get_ordered_stacks(), process_all_stacks()  
**Related Documentation:** CUSTOM_STACK_MANAGEMENT.md
