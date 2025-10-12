# Migration Scripts Archive

This directory contains one-time migration scripts that were used to transition between different versions of kompose.

## Scripts

### Domain Configuration Migration
- `migrate-domain-config.sh` - Migrates from hardcoded domains to centralized domain.env
- `migrate-stack-env.sh` - Updates stack .env files to new format

### Stack Migrations
- `migrate-auto-to-chain.sh` - Migrates Semaphore from auto stack to chain stack
- `rename-home-to-core.sh` - Renames home stack to core

### Legacy Scripts
- `restart-all-stacks.sh` - Restarts all stacks (now: `kompose restart`)

## Usage

These scripts are kept for reference and emergency rollback purposes. They should not be needed for new installations.

For new deployments, use:
```bash
kompose init
kompose validate
```

## Note

Most functionality from these migration scripts has been integrated into the main kompose CLI:
- Stack restarts: `kompose restart`
- Validation: `kompose validate`
- Configuration: `kompose init`
