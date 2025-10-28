# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal home directory repository managed as a git repository with selective tracking via `.gitignore`. The repository tracks dotfiles and configuration for a Debian development environment supporting Node.js, Python, Ruby, Rust, and Go development.

## Key Architecture

### Initialization System
Shell initialization is managed through `.init/init.sh`, which sources modular configuration:
- `.init/path.sh` - PATH environment setup for all language toolchains
- `.init/alias.sh` - Custom shell aliases
- `.init/functions.sh` - Custom shell functions for deployment and media processing
- `.init/export.sh`, `.init/source.sh`, `.init/eval.sh` - Additional environment setup

### Arty Configuration
`arty.yml` defines the repository structure using Arty (artifact/repository manager):
- **references**: Git subrepositories to clone into specific paths
- **envs**: Environment profiles (dev/prod) for selective repository management
- Manages both development projects and language version managers (nvm, rbenv, pyenv, gvm)

### Ansible Provisioning
`playbook.yml` is an Ansible playbook for system setup:
- Installs and configures language runtimes (Node, Python, Ruby, Rust, Go)
- Sets up Docker, PostgreSQL 18, and development tools
- Configures Zsh with Oh-My-Zsh and Powerlevel10k theme
- Manages system packages via apt

### Git Selective Tracking
The `.gitignore` uses an inverted pattern (ignore everything, then selectively allow):
- Tracks only specific dotfiles and configuration files
- Allows `.github/`, `.init/`, `.vscode/` directories
- Excludes logs, databases, and temporary files

## Development Environment

### Language Version Management
- **Node.js**: Managed by nvm, version specified in `.nvmrc`
- **Ruby**: Managed by rbenv, version in `.ruby-version`
- **Python**: Managed by pyenv, version in `.python-version`
- **Rust**: Via rustup (`.cargo/`, `.rustup/`)
- **Go**: Via gvm (`.gvm/`)

### Shell Environment
- **Shell**: Zsh with Oh-My-Zsh framework
- **Theme**: Powerlevel10k (`.p10k.zsh`)
- **Plugins**: git, pm2, gh, docker, language-specific plugins, zsh-autosuggestions, zsh-syntax-highlighting

## Common Commands

### Environment Setup
```bash
# Reinitialize shell environment
ri  # alias for: source ~/.init/init.sh

# Bootstrap system (run as user, prompts for sudo)
sudo -u $USER ansible-playbook -K playbook.yml

# Run specific Ansible tags
ansible-playbook --tags node,python,ruby -K playbook.yml
```

### Arty Repository Management
```bash
# Debug Arty configuration
pnpm arty debug

# Clone/update repositories based on environment
pnpm arty sync --env dev
```

### Git Workflow
```bash
# Stage all changes and check if clean
g0  # alias for: git add . && git diff --quiet && git diff --cached --quiet

# Reset to single commit
g1  # alias for: git reset $(git commit-tree "HEAD^{tree}" -m "A new start")

# Get last commit message
g2  # alias for: git log --format=%B -n 1 HEAD | head -n 1
```

### Code Quality
```bash
# Python pre-commit hooks (configured in .pre-commit-config.yaml)
pre-commit run --all-files

# Ruby style checking
rubocop

# Node.js linting
pnpm eslint
```

### Utility Functions
Available shell functions from `.init/functions.sh`:
- `batch_file_sequence <prefix> <extension>` - Rename files with sequence numbers
- `batch_image_webp` - Convert images to WebP format
- `batch_video_x264` - Convert videos to x264 codec
- `rs` - Rsync with sudo on remote (alias for complex rsync command)
- `ss` - Serve current directory on port 8000
- `yt <url>` - Download YouTube video as MP3

## Projects Structure

The `Projects/` directory contains development projects:
- `butter-sh/` - Butter shell projects
- `docker-compose/` - Docker compose configurations
- `pivoine.art/` - Jekyll-based art portfolio site
- `docs.pivoine.art/` - Documentation site
- `sexy.pivoine.art/` - Includes Rust package (`packages/buttplug/`)
- `node.js/` - Node.js applications (awesome, awesome-app, email-pour-vous, webshot)

## Package Management

### Node.js
- **Package manager**: pnpm (enabled via corepack)
- **Global packages**: Installed to `~/node_modules/`
- **PM2**: Configured via `ecosystem.config.js` for GitHub Copilot language server

### Python
- **Installer**: pip
- **Dependencies**: Listed in `requirements.txt` (currently: pre-commit)

### Ruby
- **Bundler**: Gemfile specifies Jekyll 4.3 and rubocop

## Important Notes

- This repository uses selective git tracking - most files are ignored by default
- Shell must source `.init/init.sh` for full environment setup (automatically done in `.zshrc`)
- Language runtimes are version-managed and installed via Ansible
- Docker requires user to be in `docker` group (managed by Ansible)
- The `.last_pwd` file tracks the last working directory for shell navigation
