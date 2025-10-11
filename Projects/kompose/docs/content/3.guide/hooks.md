---
title: Hooks System
description: Extend Kompose with custom hooks
---

Extend Kompose functionality with custom hooks for each stack. Hooks allow you to run custom logic before and after Docker Compose commands and database operations.

## Hook Types

### Database Hooks

| Hook | Timing | Arguments | Use Case |
|------|--------|-----------|----------|
| `hook_pre_db_export` | Before DB export | None | Prepare data, export schemas |
| `hook_post_db_export` | After DB export | `$1` = dump file path | Cleanup, notifications |
| `hook_pre_db_import` | Before DB import | `$1` = dump file path | Prepare environment, schema setup |
| `hook_post_db_import` | After DB import | `$1` = dump file path | Restart services, clear caches |

### Docker Compose Command Hooks

All Docker Compose commands support pre and post hooks. The hooks receive the full command arguments.

| Hook | Timing | Arguments | Use Case |
|------|--------|-----------|----------|
| `hook_pre_up` | Before `docker compose up` | `$@` = command args | Pre-flight checks, setup |
| `hook_post_up` | After `docker compose up` | `$@` = command args | Health checks, initialization |
| `hook_pre_down` | Before `docker compose down` | `$@` = command args | Graceful shutdown, backups |
| `hook_post_down` | After `docker compose down` | `$@` = command args | Cleanup, notifications |
| `hook_pre_start` | Before `docker compose start` | `$@` = command args | Validate state |
| `hook_post_start` | After `docker compose start` | `$@` = command args | Verify services |
| `hook_pre_stop` | Before `docker compose stop` | `$@` = command args | Save state |
| `hook_post_stop` | After `docker compose stop` | `$@` = command args | Cleanup |
| `hook_pre_restart` | Before `docker compose restart` | `$@` = command args | Prepare for restart |
| `hook_post_restart` | After `docker compose restart` | `$@` = command args | Verify restart |
| `hook_pre_build` | Before `docker compose build` | `$@` = command args | Code generation |
| `hook_post_build` | After `docker compose build` | `$@` = command args | Tag images, push to registry |
| `hook_pre_pull` | Before `docker compose pull` | `$@` = command args | Check registry availability |
| `hook_post_pull` | After `docker compose pull` | `$@` = command args | Verify images |
| `hook_pre_logs` | Before `docker compose logs` | `$@` = command args | Setup log filters |
| `hook_post_logs` | After `docker compose logs` | `$@` = command args | Process logs |

**Also supported:** `ps`, `exec`, `run`, `create`, `kill`, `pause`, `unpause`, `port`, `top`

::alert{type="info"}
**Note:** Post-command hooks only execute if the Docker Compose command succeeds (exit code 0).
::

## Creating Hooks

Create `<stack>/hooks.sh` in your stack directory:

```bash
#!/usr/bin/env bash

# Hook naming convention:
# - hook_pre_<command>  - runs before the command
# - hook_post_<command> - runs after the command (only on success)

# Example: Setup before starting containers
hook_pre_up() {
    local -a args=("$@")
    echo "  Running pre-flight checks..."
    
    # Check if required directories exist
    if [[ ! -d "./uploads" ]]; then
        echo "  Creating uploads directory..."
        mkdir -p ./uploads
    fi
    
    return 0  # 0 = success, 1 = failure
}

# Example: Verify services after startup
hook_post_up() {
    local -a args=("$@")
    echo "  Waiting for services to be healthy..."
    
    # Wait for health check
    sleep 5
    
    if docker compose ps | grep -q "healthy"; then
        echo "  ✓ Services are healthy"
        return 0
    else
        echo "  ⚠ Warning: Some services may not be healthy"
        return 0  # Non-critical, don't fail
    fi
}

# Example: Backup before shutdown
hook_pre_down() {
    echo "  Creating backup before shutdown..."
    ./backup.sh
    return 0
}

# Example: Restart dependent services
hook_post_restart() {
    echo "  Restarting dependent services..."
    # Restart a related service that depends on this stack
    return 0
}
```

## Real-World Examples

### Example 1: Directus Schema Management (sexy stack)

The `sexy` stack uses hooks for Directus schema synchronization:

```bash
#!/usr/bin/env bash

# Export Directus schema before database export
hook_pre_db_export() {
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local snapshot_file="directus_schema_${timestamp}.yaml"
    
    echo "  Exporting Directus schema snapshot..."
    
    if docker exec sexy_api npx directus schema snapshot "$snapshot_file" > /dev/null 2>&1; then
        echo "  Schema snapshot saved: $snapshot_file"
        return 0
    else
        echo "  Warning: Could not export schema snapshot"
        return 0  # Don't fail the entire export
    fi
}

# Import Directus schema before database import
hook_pre_db_import() {
    local dump_file="$1"
    
    # Find most recent schema snapshot
    local snapshot_file=$(ls -t directus_schema_*.yaml 2>/dev/null | head -1)
    
    if [[ -z "$snapshot_file" ]]; then
        echo "  No schema snapshot found, skipping"
        return 0
    fi
    
    echo "  Applying Directus schema from: $snapshot_file"
    
    if docker exec sexy_api npx directus schema apply "$snapshot_file" > /dev/null 2>&1; then
        echo "  Schema applied successfully"
        return 0
    else
        echo "  Warning: Could not apply schema snapshot"
        return 0
    fi
}

# Reload Directus after import
hook_post_db_import() {
    echo "  Restarting Directus to apply changes..."
    docker restart sexy_api > /dev/null 2>&1
    return 0
}
```

### Example 2: Health Monitoring

```bash
#!/usr/bin/env bash

# Send notification when services start
hook_post_up() {
    local -a args=("$@")
    
    echo "  Notifying monitoring system..."
    
    # Example: Send webhook
    curl -X POST https://monitoring.example.com/webhook \
        -H "Content-Type: application/json" \
        -d "{\"stack\": \"${stack}\", \"status\": \"up\"}" \
        2>/dev/null
    
    return 0
}

# Alert on shutdown
hook_post_down() {
    echo "  Sending shutdown notification..."
    
    curl -X POST https://monitoring.example.com/webhook \
        -H "Content-Type: application/json" \
        -d "{\"stack\": \"${stack}\", \"status\": \"down\"}" \
        2>/dev/null
    
    return 0
}
```

### Example 3: Automated Backups

```bash
#!/usr/bin/env bash

# Backup volumes before rebuild
hook_pre_build() {
    echo "  Backing up volumes before rebuild..."
    
    local backup_dir="./backups/$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    
    # Backup volumes
    docker run --rm \
        -v app_data:/data \
        -v "$backup_dir:/backup" \
        alpine tar czf /backup/data.tar.gz -C /data .
    
    echo "  Backup saved to: $backup_dir"
    return 0
}

# Tag and push after successful build
hook_post_build() {
    echo "  Tagging and pushing image..."
    
    local image="${COMPOSE_PROJECT_NAME}_app"
    local tag="$(date +%Y%m%d-%H%M%S)"
    
    docker tag "$image:latest" "$image:$tag"
    docker push "$image:$tag"
    
    return 0
}
```

### Example 4: Cache Warming

```bash
#!/usr/bin/env bash

# Warm caches after starting
hook_post_up() {
    echo "  Warming application caches..."
    
    # Wait for app to be ready
    sleep 10
    
    # Hit cache endpoints
    curl -s http://localhost:3000/api/cache/warm > /dev/null
    
    return 0
}

# Clear caches before restart
hook_pre_restart() {
    echo "  Clearing application caches..."
    
    docker exec app_container redis-cli FLUSHALL
    
    return 0
}
```

## Hook Execution Flow

### Database Export Flow
```
1. hook_pre_db_export
2. pg_dump (database export)
3. hook_post_db_export (receives dump file path)
```

### Database Import Flow
```
1. hook_pre_db_import (receives dump file path)
2. Database drop & recreate
3. psql (database import)
4. hook_post_db_import (receives dump file path)
```

### Docker Compose Command Flow
```
1. hook_pre_<command> (receives command args)
2. docker compose <command>
3. hook_post_<command> (only if command succeeds, receives command args)
```

## Testing Hooks

```bash
# Preview hook execution with dry-run
./kompose.sh sexy db:export --dry-run
./kompose.sh sexy up -d --dry-run

# Execute with hooks
./kompose.sh sexy db:export
./kompose.sh sexy up -d

# Test specific commands with hooks
./kompose.sh news restart
./kompose.sh blog build
./kompose.sh "*" down
```

## Accessing Command Arguments

Hooks receive the full command and its arguments:

```bash
hook_pre_up() {
    local -a args=("$@")
    
    # Access specific arguments
    echo "  Command: ${args[0]}"          # "up"
    echo "  All args: ${args[*]}"         # "up -d --build"
    
    # Check for specific flags
    if [[ " ${args[*]} " =~ " --build " ]]; then
        echo "  Build flag detected, running pre-build tasks..."
    fi
    
    return 0
}
```

## Hook Best Practices

### ✅ DO:

- **Return proper exit codes**: `0` for success, `1` for failure
- **Use indented output**: `echo "  Message"` for better readability
- **Make non-critical operations non-blocking**: Return `0` even on minor failures
- **Check container status** before using `docker exec`
- **Test in dry-run mode** first: `./kompose.sh stack command --dry-run`
- **Use environment variables** available from `.env` files
- **Add timeouts** for long-running operations
- **Document your hooks** with comments

### ❌ DON'T:

- **Assume containers are running** before executing commands
- **Use blocking operations** without timeouts
- **Forget error handling** for external commands
- **Hardcode paths, credentials, or hostnames**
- **Perform destructive operations** in `pre_*` hooks without confirmation
- **Make hooks too complex** - consider separate scripts if needed
- **Ignore exit codes** from important operations

## Available Environment Variables

Hooks have access to all environment variables from:
- Root `.env` file
- Stack-specific `.env` file
- CLI overrides (`-e KEY=VALUE`)

Common variables:
```bash
$SCRIPT_DIR          # Root kompose directory
$stack              # Current stack name
$COMPOSE_PROJECT_NAME
$DB_NAME
$DB_HOST
$DB_PORT
$DB_USER
$DB_PASSWORD
# ... all variables from .env files
```

## Troubleshooting

### Hook not executing
1. Verify `hooks.sh` has execute permissions: `chmod +x <stack>/hooks.sh`
2. Check function naming: `hook_pre_<command>` or `hook_post_<command>`
3. Test with dry-run mode to see if hooks are detected
4. Check for bash syntax errors: `bash -n <stack>/hooks.sh`

### Hook failing
1. Add `set -x` at the top of your hook for debugging
2. Check return codes: `return 0` for success
3. Verify container names and states
4. Check environment variables are loaded
5. Look at Kompose output for error messages

### Best debugging approach
```bash
# Enable dry-run to see what would execute
./kompose.sh stack command --dry-run

# Add debug output in your hook
hook_pre_up() {
    echo "  [DEBUG] Stack: $stack"
    echo "  [DEBUG] Args: $*"
    echo "  [DEBUG] Container: $(docker ps --filter name=$stack)"
    # ... your hook logic
    return 0
}
```

## Advanced Patterns

### Conditional Execution
```bash
hook_pre_up() {
    # Only run in production
    if [[ "${ENVIRONMENT}" == "production" ]]; then
        echo "  Running production pre-flight checks..."
        ./production-checks.sh
    fi
    return 0
}
```

### Parallel Hook Execution
```bash
hook_post_up() {
    echo "  Running parallel initialization tasks..."
    
    # Background jobs
    (cache_warm) &
    (index_rebuild) &
    
    # Wait for all background jobs
    wait
    
    return 0
}
```

### Hook Chaining
```bash
hook_post_restart() {
    # Call another stack's command
    echo "  Restarting dependent services..."
    "${SCRIPT_DIR}/kompose.sh" dependent-stack restart
    return 0
}
```

## Security Considerations

- Never log sensitive information (passwords, tokens)
- Validate user input in hooks that accept parameters
- Use quotes around variables to prevent injection
- Restrict file permissions on `hooks.sh`: `chmod 750 hooks.sh`
- Avoid executing user-supplied data without validation
- Use absolute paths or `$SCRIPT_DIR` for file references

## Related

- [Database Operations](/guide/database) - Learn about database import/export
- [Stack Management](/guide/stack-management) - Managing multiple stacks
- [Configuration](/guide/configuration) - Environment variables and settings
