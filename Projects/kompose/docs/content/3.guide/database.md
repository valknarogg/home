---
title: Database Operations
description: Export, import, and manage PostgreSQL databases
---

- **Automated backups**: Export PostgreSQL databases with timestamped dumps
- **Smart imports**: Auto-detect latest dumps or specify exact files
- **Drop & recreate**: Safe database import with connection termination
- **Cleanup utilities**: Keep only the latest dumps, remove old backups
- **Hook integration**: Custom pre/post operations for each database action

### :icon{name="lucide:git-branch"} Extensibility
- **Custom hooks**: Define `pre_db_export`, `post_db_export`, `pre_db_import`, `post_db_import`
- **Stack-specific logic**: Each stack can have unique operational requirements
- **Environment access**: Hooks inherit all environment variables
- **Dry-run aware**: Test hook execution without side effects

### :icon{name="lucide:globe"} Network Management
- **Unified network**: All stacks communicate on a single Docker network
- **CLI overrides**: Change network on-the-fly without editing configs
- **Traefik integration**: Seamless reverse proxy setup with proper network awareness
- **Multi-network support**: Special stacks can have additional internal networks

### :icon{name="lucide:wrench"} Environment Control
- **Global overrides**: Set environment variables via CLI flags
- **Layered configs**: Root `.env` + stack `.env` + CLI overrides
- **Precedence rules**: CLI > Stack > Root configuration hierarchy
- **Real-time changes**: No need to edit files for temporary overrides
