---
title: Introduction to Kompose
description: Learn about Kompose, your Docker Compose Symphony Conductor for managing multiple stacks with style and grace.
---

# Introduction to Kompose

**Kompose** is a powerful Bash orchestration tool for managing multiple Docker Compose stacks with style and grace. Think of it as a conductor for your Docker symphony - each stack plays its part, and Kompose makes sure they're all in harmony.

**Kompose** is a powerful Bash orchestration tool for managing multiple Docker Compose stacks with style and grace. Think of it as a conductor for your Docker symphony - each stack plays its part, and Kompose makes sure they're all in harmony.

### Why Kompose?

<img src="https://game-icons.net/icons/000000/transparent/1x1/delapouite/archery-target.svg" alt="target" style="display:inline; width:1.2em; height:1.2em; vertical-align:-0.15em;"> **One Command to Rule Them All** - Manage dozens of stacks with a single command
<img src="https://game-icons.net/icons/000000/transparent/1x1/lorc/reload.svg" alt="reload" style="display:inline; width:1.2em; height:1.2em; vertical-align:-0.15em;"> **Database Wizardry** - Export, import, and clean up PostgreSQL databases like a boss
<img src="https://game-icons.net/icons/000000/transparent/1x1/delapouite/circus-tent.svg" alt="tent" style="display:inline; width:1.2em; height:1.2em; vertical-align:-0.15em;"> **Hook System** - Extend functionality with custom pre/post operation hooks
<img src="https://game-icons.net/icons/000000/transparent/1x1/delapouite/globe.svg" alt="network" style="display:inline; width:1.2em; height:1.2em; vertical-align:-0.15em;"> **Network Maestro** - Smart network management with CLI overrides
<img src="https://game-icons.net/icons/000000/transparent/1x1/lorc/padlock.svg" alt="lock" style="display:inline; width:1.2em; height:1.2em; vertical-align:-0.15em;"> **Environment Juggler** - Override any environment variable on the fly
<img src="https://game-icons.net/icons/000000/transparent/1x1/delapouite/paint-brush.svg" alt="colors" style="display:inline; width:1.2em; height:1.2em; vertical-align:-0.15em;"> **Beautiful Output** - Color-coded logs and status indicators
<img src="https://game-icons.net/icons/000000/transparent/1x1/lorc/round-bottom-flask.svg" alt="test" style="display:inline; width:1.2em; height:1.2em; vertical-align:-0.15em;"> **Dry-Run Mode** - Test changes before applying them

### <img src="https://game-icons.net/icons/000000/transparent/1x1/lorc/musical-notes.svg" alt="music" style="display:inline; width:1.2em; height:1.2em; vertical-align:-0.15em;"> Stack Management
- **Pattern-based selection**: Target stacks with globs, comma-separated lists, or wildcards
- **Bulk operations**: Execute commands across multiple stacks simultaneously
- **Status monitoring**: Visual feedback with color-coded success/failure indicators
- **Smart filtering**: Include/exclude stacks with flexible pattern matching

### <img src="https://game-icons.net/icons/000000/transparent/1x1/delapouite/save.svg" alt="database" style="display:inline; width:1.2em; height:1.2em; vertical-align:-0.15em;"> Database Operations
- **Automated backups**: Export PostgreSQL databases with timestamped dumps
- **Smart imports**: Auto-detect latest dumps or specify exact files
- **Drop & recreate**: Safe database import with connection termination
- **Cleanup utilities**: Keep only the latest dumps, remove old backups
- **Hook integration**: Custom pre/post operations for each database action

### <img src="https://game-icons.net/icons/000000/transparent/1x1/lorc/meat-hook.svg" alt="hook" style="display:inline; width:1.2em; height:1.2em; vertical-align:-0.15em;"> Extensibility
- **Custom hooks**: Define `pre_db_export`, `post_db_export`, `pre_db_import`, `post_db_import`
- **Stack-specific logic**: Each stack can have unique operational requirements
- **Environment access**: Hooks inherit all environment variables
- **Dry-run aware**: Test hook execution without side effects

### <img src="https://game-icons.net/icons/000000/transparent/1x1/delapouite/globe.svg" alt="network" style="display:inline; width:1.2em; height:1.2em; vertical-align:-0.15em;"> Network Management
- **Unified network**: All stacks communicate on a single Docker network
- **CLI overrides**: Change network on-the-fly without editing configs
- **Traefik integration**: Seamless reverse proxy setup with proper network awareness
- **Multi-network support**: Special stacks can have additional internal networks

### <img src="https://game-icons.net/icons/000000/transparent/1x1/delapouite/wrench.svg" alt="tools" style="display:inline; width:1.2em; height:1.2em; vertical-align:-0.15em;"> Environment Control
- **Global overrides**: Set environment variables via CLI flags
- **Layered configs**: Root `.env` + stack `.env` + CLI overrides
- **Precedence rules**: CLI > Stack > Root configuration hierarchy
- **Real-time changes**: No need to edit files for temporary overrides

## Quick Start

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

## Documentation Sections

### Getting Started
- [Installation Guide](/docs/installation) - Set up Kompose on your system
- [Quick Start](/docs/guide/quick-start) - Get up and running in minutes

### User Guide
- [Stack Management](/docs/guide/stack-management) - Managing multiple stacks
- [Database Operations](/docs/guide/database) - Backup and restore databases
- [Hooks System](/docs/guide/hooks) - Extend with custom hooks
- [Configuration](/docs/guide/configuration) - Configure Kompose and stacks
- [Network Architecture](/docs/guide/network) - Understanding networking
- [Troubleshooting](/docs/guide/troubleshooting) - Common issues and solutions

### Stack Reference
- [All Stacks](/docs/stacks) - Detailed documentation for each stack

### Reference
- [CLI Reference](/docs/reference/cli) - Complete command reference
- [Environment Variables](/docs/reference/environment) - All configuration options
