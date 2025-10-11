# Docker Compose Command Hooks - Quick Reference

## Overview

Kompose now supports hooks for all Docker Compose commands, similar to the existing database import/export hooks. This allows you to run custom logic before and after any `docker compose` command.

## What Changed

### Core Script (`kompose.sh`)
- Enhanced `execute_stack_command()` to support pre/post hooks
- Hooks automatically execute for supported Docker Compose commands
- Post-hooks only run if the command succeeds

### Documentation
- Completely rewritten hooks guide with comprehensive examples
- Added template file `hooks.sh.template` for easy setup
- Updated help text with complete hook reference

## Available Hooks

### Format
```bash
hook_pre_<command>    # Before docker compose <command>
hook_post_<command>   # After docker compose <command> (only on success)
```

### Supported Commands
- **Lifecycle**: `up`, `down`, `start`, `stop`, `restart`
- **Build**: `build`, `pull`, `create`
- **Monitoring**: `logs`, `ps`, `top`, `port`
- **Execution**: `exec`, `run`
- **Control**: `kill`, `pause`, `unpause`

## Quick Examples

### Example 1: Health Check After Startup

```bash
# In your stack's hooks.sh
hook_post_up() {
    echo "  Verifying services are healthy..."
    sleep 5
    docker compose ps --format json | jq '.[] | select(.Health == "healthy")'
    return 0
}
```

### Example 2: Backup Before Shutdown

```bash
hook_pre_down() {
    echo "  Creating backup before shutdown..."
    ./backup.sh
    return 0
}
```

### Example 3: Clear Cache Before Restart

```bash
hook_pre_restart() {
    echo "  Clearing application caches..."
    docker exec ${COMPOSE_PROJECT_NAME}_redis redis-cli FLUSHALL
    return 0
}
```

### Example 4: Tag Images After Build

```bash
hook_post_build() {
    local tag="$(date +%Y%m%d-%H%M%S)"
    echo "  Tagging image with: $tag"
    docker tag ${COMPOSE_PROJECT_NAME}_app:latest ${COMPOSE_PROJECT_NAME}_app:$tag
    return 0
}
```

## Getting Started

### 1. Copy Template
```bash
cp hooks.sh.template your-stack/hooks.sh
chmod +x your-stack/hooks.sh
```

### 2. Uncomment Hooks You Need
Edit `your-stack/hooks.sh` and uncomment the hooks you want to use.

### 3. Test in Dry-Run Mode
```bash
./kompose.sh your-stack up -d --dry-run
```

### 4. Execute
```bash
./kompose.sh your-stack up -d
```

## Accessing Command Arguments

Hooks receive the full command and arguments:

```bash
hook_pre_up() {
    local -a args=("$@")
    echo "  Command: ${args[0]}"        # "up"
    echo "  Arguments: ${args[*]}"      # "up -d --build"
    
    # Check for specific flags
    if [[ " ${args[*]} " =~ " --build " ]]; then
        echo "  Build flag detected!"
    fi
    
    return 0
}
```

## Environment Variables

Hooks have access to:
- `$SCRIPT_DIR` - Root kompose directory
- `$stack` - Current stack name  
- All variables from root and stack `.env` files
- CLI overrides from `-e` flags

## Best Practices

✅ **DO:**
- Return `0` for success, `1` for failure
- Use indented output: `echo "  Message"`
- Check container status before `docker exec`
- Test with `--dry-run` first
- Make non-critical operations return `0`

❌ **DON'T:**
- Assume containers are running
- Use blocking operations without timeouts
- Hardcode paths or credentials
- Make hooks too complex

## Testing

```bash
# Preview what would happen
./kompose.sh news up -d --dry-run

# Check syntax
bash -n your-stack/hooks.sh

# Debug mode (add to top of hook function)
hook_pre_up() {
    set -x  # Enable debug output
    # your code here
    set +x  # Disable debug output
    return 0
}
```

## Real-World Use Cases

1. **Automated Backups** - Before stopping/rebuilding
2. **Health Monitoring** - After starting services
3. **Cache Management** - Before/after restarts
4. **Image Management** - Tag and push after builds
5. **Notifications** - Alert on lifecycle events
6. **Data Migration** - Run migrations after deployment
7. **Log Rotation** - Before starting new logs
8. **Secret Management** - Pull secrets before startup

## Migration from Old Version

If you already have `hooks.sh` with database hooks:
1. ✅ No changes required - database hooks still work
2. ✅ Just add new command hooks as needed
3. ✅ All hooks can coexist in the same file

## Resources

- **Full Documentation**: `docs/content/3.guide/hooks.md`
- **Template**: `hooks.sh.template`
- **Example**: `sexy/hooks.sh` (Directus schema management)
- **Help**: `./kompose.sh --help`

## Troubleshooting

### Hook not executing?
1. Check file permissions: `chmod +x hooks.sh`
2. Verify function names: `hook_pre_<command>` or `hook_post_<command>`
3. Test with dry-run: `./kompose.sh stack command --dry-run`

### Hook failing?
1. Check return codes: `return 0` for success
2. Add debug output: `set -x` at start of function
3. Verify container names and status
4. Check environment variables are loaded

## Support

For issues or questions:
1. Check the documentation: `docs/content/3.guide/hooks.md`
2. Review the template: `hooks.sh.template`
3. Look at examples: `sexy/hooks.sh`
