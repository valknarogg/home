# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Kompose** is a Bash-based orchestration tool for managing multiple Docker Compose stacks from a single repository. Each subdirectory represents a "stack" (a Docker Compose application), and the central `kompose.sh` script provides unified commands for lifecycle management, database operations, and custom hooks.

## Architecture

### Core Components

- **`kompose.sh`**: Main orchestration script (bash) that manages all stacks
- **Stack Directories**: Each directory (`auth/`, `blog/`, `track/`, etc.) represents a self-contained Docker Compose stack
- **Environment Management**: Two-tier configuration system:
  - Root `.env`: Non-sensitive configuration and stack-scoped variables
  - `secrets.env`: Sensitive data (passwords, tokens) - generated from `secrets.env.template`
- **Hooks System**: Per-stack lifecycle hooks in `<stack>/hooks.sh`

### Key Design Patterns

1. **Stack-Scoped Variables**: Configuration uses `{STACK_NAME}_{VARIABLE}` pattern (e.g., `TRACK_TRAEFIK_HOST`, `AUTH_DB_NAME`)
2. **Shared Variables**: Common settings like `DB_USER`, `DB_HOST`, `NETWORK_NAME` shared across all stacks
3. **Hook-Based Extensibility**: Each stack can define custom pre/post hooks for Docker Compose commands and database operations
4. **Centralized Network**: All stacks connect to a shared Docker network (`kompose` by default)

### Stack Structure

Each stack directory contains:
- `compose.yaml` or `docker-compose.yaml`: Docker Compose configuration
- `.env`: Stack-specific variables (typically just `COMPOSE_PROJECT_NAME`)
- `hooks.sh` (optional): Custom lifecycle hooks
- Database dumps: `{DB_NAME}_{timestamp}.sql` files

### Monorepo Stacks

Some stacks are complete applications with their own build systems:
- **`news/`**: Turborepo monorepo with Next.js apps (pnpm workspace)
- **`docs/`**: Nuxt.js documentation site (pnpm)

## Common Commands

### Core Operations

```bash
# Start all stacks
./kompose.sh "*" up -d

# Start specific stack(s)
./kompose.sh auth up -d
./kompose.sh "auth,blog,data" up -d

# Stop stack(s)
./kompose.sh auth down
./kompose.sh "*" down

# View logs
./kompose.sh auth logs -f
./kompose.sh "*" logs --tail=100

# Check status
./kompose.sh --list
./kompose.sh "*" ps

# Restart services
./kompose.sh auth restart

# Dry-run mode (preview without executing)
./kompose.sh --dry-run "*" up -d
```

### Database Operations

```bash
# Export database dump(s)
./kompose.sh auth db:export
./kompose.sh "*" db:export

# Import latest dump (WARNING: drops & recreates database)
./kompose.sh auth db:import

# Import specific dump file
./kompose.sh auth db:import auth/keycloak_20251007_080554.sql

# Clean up old dumps (keeps only latest)
./kompose.sh "*" db:cleanup
```

### Environment Overrides

```bash
# Override variables from CLI
./kompose.sh -e DB_HOST=localhost -e DB_PORT=5433 news up -d

# Override network name
./kompose.sh --network custom_network "*" up -d
```

### Secret Management

```bash
# Generate secrets from template (creates secrets.env)
./kompose.sh --generate-secrets
```

## Development Workflows

### Monorepo Stacks (news, docs)

```bash
# News stack (Turborepo)
cd news
pnpm install
pnpm dev          # Start all apps in dev mode
pnpm build        # Build all apps
pnpm lint         # Lint all apps

# Docs stack (Nuxt)
cd docs
pnpm install
pnpm dev          # Start dev server
pnpm build        # Build for production
pnpm generate     # Generate static site
```

### Testing kompose.sh Changes

```bash
# Check syntax
bash -n kompose.sh

# Use shellcheck for best practices
shellcheck kompose.sh

# Test with dry-run
./kompose.sh --dry-run auth up -d
```

## Hooks System

Stacks can define custom hooks in `<stack>/hooks.sh` for lifecycle management.

### Available Hooks

**Database Hooks:**
- `hook_pre_db_export`: Before database export
- `hook_post_db_export`: After database export (receives dump file path)
- `hook_pre_db_import`: Before database import (receives dump file path)
- `hook_post_db_import`: After database import

**Docker Compose Command Hooks:**
- `hook_pre_<command>`: Before docker compose command (up, down, start, stop, restart, build, pull, logs, etc.)
- `hook_post_<command>`: After docker compose command (only runs on success)

### Hook Example

The `sexy/` stack uses hooks to manage Directus schema snapshots:

```bash
hook_pre_db_export() {
    # Export Directus schema before database export
    docker exec "${COMPOSE_PROJECT_NAME}_api" npx directus schema snapshot
}

hook_post_db_import() {
    # Restart Directus after database import
    docker restart "${COMPOSE_PROJECT_NAME}_api"
}
```

### Hook Reference

- Hooks receive command arguments as parameters: `$@`
- Return `0` for success, `1` for failure
- Post-hooks only execute if the main command succeeds
- Available environment variables: `$SCRIPT_DIR`, `$stack`, all `.env` variables
- Template available at `hooks.sh.template`

## Environment Variables

### Configuration Structure

1. **Root `.env`**: Stack-scoped configuration (committed to git)
   - Pattern: `{STACK}_{VARIABLE}` (e.g., `AUTH_TRAEFIK_HOST`)
   - Shared variables: `DB_USER`, `DB_HOST`, `NETWORK_NAME`, etc.

2. **`secrets.env`**: Sensitive data (NOT committed to git)
   - Generated from `secrets.env.template` using `--generate-secrets`
   - Pattern: `{STACK}_{SECRET}` (e.g., `AUTH_KC_ADMIN_PASSWORD`)

3. **Stack `.env`**: Minimal stack-specific overrides
   - Typically only contains `COMPOSE_PROJECT_NAME`

### Secret Generation Patterns

The `--generate-secrets` command generates different secret types:
- `*_PASSWORD`: 32-char alphanumeric password
- `*_SECRET`, `*_ENCRYPTION_KEY`: 64-char hex (32 bytes)
- `*_TOKEN`: 40-char alphanumeric token
- `*_HASH`: 64-char hex hash
- Default: 32-char alphanumeric

## Important Notes

### Security
- `secrets.env` is in `.gitignore` and should NEVER be committed
- Use `secrets.env.template` as a reference for required secrets
- Stack-scoped variables prevent conflicts between stacks

### Database Operations
- Database imports are **destructive** - they drop and recreate the database
- Always backup before running `db:import`
- Database dumps are saved as `{DB_NAME}_{timestamp}.sql` in stack directories
- Only PostgreSQL databases are currently supported

### Network Configuration
- All stacks use a shared Docker network (default: `kompose`)
- Network must be created before starting stacks: `docker network create kompose`
- Override network with `--network` flag or `NETWORK_NAME` in `.env`

### Traefik Integration
- Services can be exposed via Traefik reverse proxy
- Control per-stack: `{STACK}_TRAEFIK_ENABLED=true/false`
- Host configuration: `{STACK}_TRAEFIK_HOST=subdomain.example.com`

## Migration Guide

Recent changes introduced stack-scoped variables and centralized secrets management. See `MIGRATION_GUIDE.md` for detailed migration steps from the old configuration format.

## Code Style Guidelines

### Bash Script Conventions (kompose.sh)

- **Constants**: `UPPER_CASE` with `readonly`
- **Local variables**: `lowercase_with_underscores`
- **Functions**: `function_name()` with descriptive names
- **Error handling**: Use `set -euo pipefail`
- **Logging**: Use provided functions (`log_info`, `log_error`, `log_success`, `log_warning`)
- **Indentation**: 4 spaces
- **Return codes**: `0` for success, `1` for failure
- **ShellCheck**: Code should pass `shellcheck` linting

### Hook Development

- Return `0` for success, even for non-critical failures
- Use indented output: `echo "  Message"`
- Check container status before `docker exec` commands
- Test with `--dry-run` before executing
- Add timeouts for long-running operations
- Document hooks with comments

## Documentation Location

Full documentation is available in `docs/` (Nuxt site). Key documents:
- `CONTRIBUTING.md`: Contribution guidelines
- `HOOKS_QUICKREF.md`: Quick reference for hooks system
- `MIGRATION_GUIDE.md`: Configuration migration guide
- `hooks.sh.template`: Template for creating stack hooks
