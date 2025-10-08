---
title: Hooks System
description: Extend Kompose with custom hooks
---

Extend Kompose functionality with custom hooks for each stack.

### Available Hooks

| Hook | Timing | Arguments | Use Case |
|------|--------|-----------|----------|
| `hook_pre_db_export` | Before DB export | None | Prepare data, export schemas |
| `hook_post_db_export` | After DB export | `$1` = dump file path | Cleanup, notifications |
| `hook_pre_db_import` | Before DB import | `$1` = dump file path | Prepare environment, schema setup |
| `hook_post_db_import` | After DB import | `$1` = dump file path | Restart services, clear caches |

### Creating Hooks

Create `<stack>/hooks.sh`:

```bash
#!/usr/bin/env bash

# Export schema before database export
hook_pre_db_export() {
    echo "  Exporting application schema..."
    docker exec sexy_api npx directus schema snapshot --yes ./schema.yaml
    return 0  # 0 = success, 1 = failure
}

# Apply schema before database import
hook_pre_db_import() {
    local dump_file="$1"
    echo "  Applying schema snapshot..."
    docker exec sexy_api npx directus schema apply --yes ./schema.yaml
    return 0
}

# Restart service after import
hook_post_db_import() {
    local dump_file="$1"
    echo "  Restarting application..."
    docker restart sexy_api
    return 0
}
```

### Real-World Example: Directus (sexy stack)

The `sexy` stack uses hooks for Directus schema management:

**Export Flow:**
1. `pre_db_export`: Export Directus schema snapshot
2. Database export creates SQL dump
3. Result: Both database dump + schema snapshot

**Import Flow:**
1. `pre_db_import`: Apply Directus schema from snapshot
2. Database import loads SQL dump
3. `post_db_import`: Restart Directus container
4. Result: Fully synchronized schema + data

### Testing Hooks

```bash
# Preview hook execution
./kompose.sh sexy db:export --dry-run

# Execute with hooks
./kompose.sh sexy db:export

# Import with hooks
./kompose.sh sexy db:import
```

### Hook Best Practices

✅ **DO:**
- Return 0 for success, 1 for failure
- Use indented output: `echo "  Message"`
- Make non-critical operations return 0
- Check container status before `docker exec`
- Test in dry-run mode first

❌ **DON'T:**
- Assume containers are running
- Use blocking operations without timeouts
- Forget error handling
- Hardcode paths or credentials
