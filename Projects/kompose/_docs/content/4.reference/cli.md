---
title: CLI Reference
description: Complete command-line interface reference
---

Complete reference for all Kompose CLI commands and options.

## Synopsis

```bash
./kompose.sh [OPTIONS] <PATTERN> <COMMAND> [ARGS...]
```

## Options

### Global Options

| Option | Short | Description |
|--------|-------|-------------|
| `--help` | `-h` | Show help message |
| `--list` | `-l` | List all available stacks |
| `--dry-run` | `-n` | Preview actions without executing |
| `--network <n>` | | Override network name |
| `-e <KEY=VALUE>` | | Set environment variable |

### Examples

```bash
# Show help
./kompose.sh --help

# List all stacks
./kompose.sh --list

# Dry run mode
./kompose.sh --dry-run "*" up -d

# Override network
./kompose.sh --network staging "*" up -d

# Set environment variable
./kompose.sh -e DB_HOST=localhost news up -d
```

## Stack Patterns

### Pattern Syntax

- `*` - All stacks
- `stack1,stack2,stack3` - Specific stacks (comma-separated)
- `stack` - Single stack

### Examples

```bash
# All stacks
./kompose.sh "*" up -d

# Multiple specific stacks
./kompose.sh "auth,blog,news" logs -f

# Single stack
./kompose.sh proxy restart
```

## Docker Compose Commands

Any Docker Compose command can be passed through:

```bash
# Start services
./kompose.sh <pattern> up -d

# Stop services
./kompose.sh <pattern> down

# View logs
./kompose.sh <pattern> logs -f

# Restart services
./kompose.sh <pattern> restart

# Pull images
./kompose.sh <pattern> pull

# Check status
./kompose.sh <pattern> ps

# Execute commands
./kompose.sh <pattern> exec <service> <command>
```

## Database Commands

### db:export

Export PostgreSQL database to SQL dump file.

```bash
./kompose.sh <pattern> db:export
```

**Output:** `<stack-dir>/<db-name>_YYYYMMDD_HHMMSS.sql`

### db:import

Import PostgreSQL database from SQL dump file.

```bash
# Import latest dump (auto-detected)
./kompose.sh <stack> db:import

# Import specific dump file
./kompose.sh <stack> db:import path/to/dump.sql
```

**:icon{name="lucide:alert-triangle"} WARNING:** Drops and recreates the database!

### db:cleanup

Remove old database dump files (keeps only the latest).

```bash
./kompose.sh <pattern> db:cleanup
```

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | General error |
| 2 | Missing required arguments |
| 3 | No matching stacks |

## Environment Variables

Environment variables can be set via:

1. Root `.env` file
2. Stack `.env` file
3. CLI `-e` flag (highest priority)

### Precedence

```
CLI (-e flag) > Stack .env > Root .env > Compose defaults
```

## API Server Commands

### api start

Start the REST API server.

```bash
./kompose.sh api start [PORT] [HOST]
```

**Parameters:**
- `PORT` - Port number (default: 8080)
- `HOST` - Host to bind to (default: 127.0.0.1)

**Examples:**
```bash
# Start on default port
./kompose.sh api start

# Start on custom port
./kompose.sh api start 9000

# Start on all interfaces
./kompose.sh api start 8080 0.0.0.0
```

### api stop

Stop the running API server.

```bash
./kompose.sh api stop
```

### api status

Check API server status and show recent log entries.

```bash
./kompose.sh api status
```

### api logs

View API server logs in real-time.

```bash
./kompose.sh api logs
```

## Examples

### Daily Workflow

```bash
# Morning: Start everything
./kompose.sh "*" up -d

# Check status
./kompose.sh "*" ps

# View logs
./kompose.sh "*" logs --tail=50

# Evening: Backup databases
./kompose.sh "*" db:export
./kompose.sh "*" db:cleanup
```

### Deployment

```bash
# Pull latest images
./kompose.sh "*" pull

# Backup before update
./kompose.sh "*" db:export

# Restart with new images
./kompose.sh "*" down
./kompose.sh "*" up -d

# Verify health
./kompose.sh "*" ps
```

### Development

```bash
# Start dev environment
./kompose.sh "data,proxy,news" up -d

# Override for testing
./kompose.sh -e DB_NAME=test_db news up -d

# Watch logs
./kompose.sh news logs -f

# Clean up
./kompose.sh news down
```
