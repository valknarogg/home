# Environment Variable Configuration - Correct Solution

## Overview

The Kompose stack management system has been updated to ensure all compose.yaml files in subdirectories properly access environment variables defined in the root .env file. This document outlines the correct implementation approach.

## Design Principle

All environment variables are defined once in the root configuration files during initialization. These variables are loaded from the root directory and exported to the shell environment when running stack operations. Docker Compose then automatically uses these exported environment variables without requiring per-stack configuration files.

## Implementation

The solution operates through a straightforward two-step process that maintains centralized configuration management while providing stack-specific variable access.

### Step 1: Environment Loading

When any stack operation is initiated, the `export_stack_env()` function loads environment variables from three source files located in the root directory. The primary configuration file is `.env`, which contains all non-secret environment variables organized by stack prefix. The domain configuration is loaded from `domain.env`, providing subdomain mappings and Traefik host definitions. Sensitive information such as passwords, tokens, and API keys is loaded from `secrets.env`.

All variables from these files are exported to the shell environment using the bash `set -a` option, which automatically exports all subsequently defined variables. This ensures that every variable becomes available to child processes, including Docker Compose.

### Step 2: Variable Mapping

The `map_stack_variables()` function processes the loaded environment variables to create convenient aliases. For each stack, variables with stack-specific prefixes are mapped to generic names. For example, when running the core stack, the variable `CORE_POSTGRES_IMAGE` is exported both as itself and as `POSTGRES_IMAGE`, allowing compose files to reference either the specific or generic form.

Common shared variables such as `NETWORK_NAME`, `TIMEZONE`, `DB_HOST`, and `DB_USER` are exported with consistent names across all stacks, ensuring that services can communicate using standardized configuration.

### Step 3: Docker Compose Execution

Once the environment is prepared, Docker Compose commands are executed in the appropriate stack directory. The `run_compose()` function changes to the stack directory and runs `docker compose` without any `--env-file` flag. Docker Compose automatically uses environment variables that are exported in the shell, eliminating the need for per-stack configuration files.

This approach ensures that all compose.yaml files can reference variables defined in the root configuration using standard Docker Compose syntax such as `${VARIABLE_NAME}` or `${VARIABLE_NAME:-default}`.

## Files Modified

Two core system files were updated to implement this solution.

The file `kompose-stack.sh` was modified to remove references to `.env.generated` files. The `run_compose()` function now simply exports the stack environment and runs Docker Compose commands, relying on the shell environment for variable substitution. The `list_stacks()` function was also updated to remove dependencies on per-stack environment files.

The file `kompose-env.sh` was simplified significantly. The `generate_stack_env_file()` function was completely removed as it is no longer needed. The `export_stack_env()` function now only loads variables from root configuration files and exports them to the shell environment. The `map_stack_variables()` function was updated to use cleaner project naming by removing redundant prefixes.

## Stack-Specific Variable Access

Each of the fourteen stacks in your Kompose installation receives environment variables through this centralized system. The variable naming convention follows a consistent pattern that makes stack ownership clear while allowing flexible access patterns.

Variables intended for a specific stack are prefixed with the stack name in uppercase. For instance, the core stack uses `CORE_POSTGRES_IMAGE`, `CORE_REDIS_IMAGE`, and `CORE_MQTT_PORT`. When the core stack is active, these variables are also available without the prefix as `POSTGRES_IMAGE`, `REDIS_IMAGE`, and `MQTT_PORT`, making compose files more readable.

Variables that are shared across multiple stacks have no prefix and are always available with the same name. These include `NETWORK_NAME` for the Docker network, `TIMEZONE` for container timezone settings, `DB_HOST` and `DB_PORT` for database connections, and all `TRAEFIK_HOST_*` variables for routing configuration.

This design allows each compose.yaml file to be written cleanly without worrying about variable prefixes, while maintaining clear ownership in the central configuration files.

## Verification

To verify that the solution works correctly, you should perform a series of tests in the following sequence.

Begin by checking environment variable loading for a single stack. Run the command `./kompose.sh core env` to display the environment variables that would be used when running the core stack. This output should show both prefixed variables such as `CORE_POSTGRES_IMAGE` and their unprefixed equivalents such as `POSTGRES_IMAGE`.

Next, validate the Docker Compose configuration. Navigate to any stack directory and run `docker compose config` without any additional flags. This command will show the fully interpolated configuration with all environment variables replaced by their actual values. Verify that no variables appear as empty strings or unsubstituted placeholders.

Finally, test actual stack operations. Start the core stack using `./kompose.sh core up`, which provides foundational services including PostgreSQL, Redis, and MQTT. Monitor the container logs to ensure services start successfully and can connect to each other using the configured environment variables. Once the core stack is operational, test other stacks that depend on these foundational services.

## Security Considerations

The centralized environment configuration provides several security advantages over distributed configuration files.

All sensitive information remains in a single location at the root directory. The `secrets.env` file contains all passwords, tokens, and API keys, making it straightforward to protect through file system permissions and backup procedures. This file should have restricted permissions such as 600 or 640 to prevent unauthorized access.

The `show_stack_env()` function has been updated to redact sensitive variables when displaying environment configuration. Any variable name containing PASSWORD, SECRET, TOKEN, KEY, or PRIVATE will be displayed as REDACTED rather than showing the actual value, preventing accidental exposure during debugging or documentation.

Since no per-stack files are generated, there is no risk of stale configuration data or inconsistency between the root configuration and stack-specific files. Every stack operation reads the current state of the root configuration files, ensuring that changes are immediately reflected across all stacks.

## Advantages of This Approach

The centralized configuration approach provides significant operational benefits compared to distributed per-stack configuration files.

Configuration management is simplified through a single source of truth. All environment variables are defined in one location, making it easy to understand the complete system configuration and identify where specific settings are defined. Changes to shared variables such as database credentials or domain names only need to be made once and automatically propagate to all affected stacks.

Version control and backup procedures are streamlined since only the root configuration files need to be tracked and protected. The `.gitignore` file can be configured to exclude `secrets.env` while including `.env` and `domain.env`, providing a clear separation between public configuration and sensitive credentials.

Stack initialization is faster and more reliable because there are no intermediate files to generate or synchronize. Each stack operation directly reads the current configuration state, eliminating potential issues with outdated or corrupted generated files.

The system scales naturally as you add new stacks. Each new service simply defines its variables in the root `.env` file with an appropriate prefix, and those variables become immediately available to the corresponding compose file without any additional configuration steps.

## Conclusion

The Kompose environment variable system now operates according to its original design intent. All environment variables are defined once in root configuration files, loaded into the shell environment when needed, and automatically available to Docker Compose for variable substitution in compose files. This approach eliminates the need for per-stack configuration files while ensuring that all fourteen stacks have consistent and reliable access to both shared and stack-specific configuration.

The implementation maintains security by centralizing sensitive information, improves maintainability by providing a single source of truth for configuration, and enhances reliability by eliminating intermediate configuration artifacts that could become stale or inconsistent.
