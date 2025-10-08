---
title: Introduction to Kompose
description: Learn about Kompose, your Docker Compose Symphony Conductor for managing multiple stacks with style and grace.
---

# Introduction to Kompose

**Kompose** is a powerful Bash orchestration tool for managing multiple Docker Compose stacks with style and grace. Think of it as a conductor for your Docker symphony - each stack plays its part, and Kompose makes sure they're all in harmony.

## Why Kompose?

🎯 **One Command to Rule Them All** - Manage dozens of stacks with a single command

🔄 **Database Wizardry** - Export, import, and clean up PostgreSQL databases like a boss

🎪 **Hook System** - Extend functionality with custom pre/post operation hooks

🌐 **Network Maestro** - Smart network management with CLI overrides

🔐 **Environment Juggler** - Override any environment variable on the fly

🎨 **Beautiful Output** - Color-coded logs and status indicators

🧪 **Dry-Run Mode** - Test changes before applying them

## Quick Example

```bash
# Start all stacks
./kompose.sh "*" up -d

# View logs from specific stacks
./kompose.sh "blog,news" logs -f

# Export all databases
./kompose.sh "*" db:export

# Override network for staging
./kompose.sh --network staging "*" up -d
```

## Key Features

### Stack Management

Pattern-based selection allows you to target stacks with globs, comma-separated lists, or wildcards. Execute commands across multiple stacks simultaneously with visual feedback and color-coded success/failure indicators.

### Database Operations

Automated backups with timestamped dumps, smart imports that auto-detect latest dumps, and safe database operations with connection termination. Keep your storage clean with cleanup utilities.

### Hooks System

Extend Kompose with custom hooks for each stack. Define `pre_db_export`, `post_db_export`, `pre_db_import`, and `post_db_import` hooks to add stack-specific logic.

### Network Management

All stacks communicate through a unified Docker network. Override the network on-the-fly via CLI without editing configs, with seamless Traefik integration.

## Next Steps

- [Installation Guide](/docs/installation)
- [Quick Start Tutorial](/docs/quick-start)
- [Stack Management](/docs/guide/stack-management)
- [Database Operations](/docs/guide/database)
