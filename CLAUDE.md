# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal home directory repository managed as a git repository with selective tracking via `.gitignore`. The repository tracks dotfiles and configuration for a Debian development environment supporting Node.js, Python, Ruby, Rust, and Go development.

## Key Architecture

### Initialization System
Shell initialization is managed through `.init/init.sh`, which sources modular configuration in this order:
1. `.init/path.sh` - PATH environment setup for all language toolchains (Node, Python, Ruby, Rust, Go, Flatpak)
2. `.init/export.sh` - Environment variable exports
3. `.init/alias.sh` - Custom shell aliases (ri, g0-g2, rs, ss, yt)
4. `.init/source.sh` - Source language version managers (nvm, rbenv, pyenv)
5. `.init/functions.sh` - Custom shell functions for deployment and media processing
6. `.init/links.sh` - Symbolic link setup
7. `.init/eval.sh` - Commands requiring eval (rbenv init, pyenv init)
8. `.init/trap.sh` - Shell trap handlers
9. `.init/start.sh` - Startup commands
10. `.init/bin/` - Custom executable scripts

### Arty Configuration
`arty.yml` defines the repository structure using Arty (artifact/repository manager):
- **references**: Git subrepositories to clone into specific paths
- **envs**: Environment profiles (dev/prod) for selective repository management
- Manages both development projects and language version managers (nvm, rbenv, pyenv, gvm)

### Ansible Provisioning
`playbook.yml` is an Ansible playbook for system setup:
- Installs and configures language runtimes (Node, Python, Ruby, Rust, Go)
- Sets up Docker, PostgreSQL 18, and development tools
- Configures Zsh with Oh-My-Zsh and Powerlevel10k theme for user and root
- Manages system packages via apt

Available Ansible tags:
- `base` - Base packages (make, build-essential, git, curl, wget, rsync, imagemagick, ffmpeg, yt-dlp, fzf)
- `node` - Node.js via nvm, corepack, and pnpm packages
- `python` - Python via pyenv, pip packages, and pre-commit setup
- `ruby` - Ruby via rbenv, bundler, and bundle install
- `rust` - Rust via rustup with required system packages
- `zsh` - Zsh shell configuration for user
- `oh-my-posh` - Oh-My-Posh prompt for root
- `postgres` - PostgreSQL 18 from official PGDG repository
- `docker` - Docker Engine with user group membership
- `flatpak` - Flatpak with Flathub repository
- `github` - GitHub CLI (gh)
- `fonts` - Font cache update

### Git Selective Tracking
The `.gitignore` uses an inverted pattern (ignore everything, then selectively allow):
- Tracks only specific dotfiles and configuration files
- Allows `.github/`, `.vscode/` directories
- Excludes logs, databases, and temporary files
- **Note**: The `.init/` directory is NOT tracked in git - it exists locally only

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

### Utility Functions & Scripts

Shell functions from `.init/functions.sh`:

**Deployment functions** (internal use, deploy to remote server via rsync):
- `_site_deploy_jekyll <site>` - Build Jekyll site and deploy to remote
- `_site_deploy_nuxt <site>` - Build Nuxt site and deploy to remote
- `_site_deploy_static <site>` - Deploy static files to remote
- `_site_run_jekyll <site>` - Run Jekyll dev server with livereload
- `_site_run_nuxt <site>` - Run Nuxt dev server
- `_site_run_static <site>` - Serve static files locally on port 8000

**Media processing functions**:
- `batch_file_sequence <prefix> <extension>` - Rename files with sequence numbers
- `batch_image_webp` - Convert JPG/PNG images to WebP format
- `batch_video_x264` - Convert videos to x264 codec

**Git/home management functions** (internal):
- `_home_push [message]` - Commit and push home repository changes
- `_home_pull` - Pull home repository (stashes/unstashes changes, handles `.last_pwd`)

Shell scripts in `.init/bin/`:
- `artifact_github_download.sh <repo> [-n name] [-o output]` - Download GitHub Actions artifacts
- `mime_mp4_gif.sh [options] <input.mp4> [output.gif]` - Advanced MP4 to animated GIF converter with keyframe extraction and interpolation algorithms
- `doc_bash_generate.sh [options] <executables>` - Auto-generate README.md documentation with animated GIFs:
  - Supports glob patterns for multiple executables
  - Parses `--help` output to extract usage, options, and examples
  - Records asciinema demos and converts to animated GIFs
  - Custom demos via `.demo` files (place next to executable)
  - Output formats: Markdown with collapsible sections, embedded GIFs, table of contents
  - Dependencies: asciinema, agg (for GIF generation, optional with `--no-gif`)
  - Example: `doc_bash_generate.sh -t "My Tools" -o docs/README.md *.sh`

**CSS Color Utilities** (pure bash implementations using only `bc`):
- `css_color_palette.sh <color> [options]` - Generate comprehensive color palettes with multiple harmony types:
  - Palette types: monochromatic, analogous, complementary, split-complementary, triadic, tetradic
  - Complete color scales: 50-950 (11 shades) following yamada-colors format
  - Style variations: shades, tints, tones, all
  - Light/dark mode support
  - Output formats: YAML (default), JSON
  - Interactive mode with colored terminal preview
  - Example: `css_color_palette.sh "#3498db" -p triadic -o palette.json`

- `css_color_filter.sh <color> [options]` - Generate CSS filter values to transform black elements into any target color:
  - Uses SPSA (Simultaneous Perturbation Stochastic Approximation) optimization
  - Generates filter combinations: invert, sepia, saturate, hue-rotate, brightness, contrast
  - Supports hex colors (#FF5733) or RGB (255,87,51)
  - Interactive mode with accuracy metrics
  - Clipboard support for quick copying
  - Note: Takes 2-5 minutes per color due to optimization algorithm
  - Example: `css_color_filter.sh "#FF5733" -c` (copies result to clipboard)

## Projects Structure

Projects are managed by Arty and cloned into `Projects/` or `repos/`:
- **butter-sh/** - Butter shell GitHub pages site
- **docker-compose/** - Docker compose configurations (both dev/prod envs)
- **pivoine.art/** - Jekyll-based art portfolio site
- **sexy.pivoine.art/** - Contains Rust package (`packages/buttplug/`)
- **node.js/** - Node.js applications:
  - `awesome/` - Main Node.js app (dev/prod)
  - `awesome-app/` - Companion app (dev only)

Personal media directories (dev env only):
- **Bilder/** - Pictures (from home-pictures repo)
- **Videos/** - Videos (from home-videos repo)
- **Musik/** - Music (from home-music repo)

## Package Management

### Node.js
- **Package manager**: pnpm (enabled via corepack)
- **Global packages**: Installed to `~/node_modules/`, available via `~/node_modules/.bin/`
- **PM2**: Configured via `ecosystem.config.js` for GitHub Copilot language server
- **Dependencies**: playwright (dev dependency)

### Python
- **Installer**: pip
- **Dependencies**: Listed in `requirements.txt` (currently: pre-commit)

### Ruby
- **Bundler**: Gemfile specifies Jekyll 4.3 and rubocop

## Important Notes

- **Selective Git Tracking**: This repository uses an inverted `.gitignore` pattern - everything is ignored by default (`*`), then specific files/directories are explicitly allowed (`!CLAUDE.md`, `!.zshrc`, etc.). When adding new tracked files, you must explicitly allow them in `.gitignore`. The `.init/` directory is NOT tracked in git - it exists locally only for shell initialization.
- **Shell Initialization**: Shell must source `.init/init.sh` for full environment setup (automatically done in `.zshrc`). Use `ri` alias to reinitialize without restarting shell.
- **Language Runtimes**: All language versions are managed by version managers (nvm, rbenv, pyenv, gvm) and installed via Ansible playbook. Version files (`.nvmrc`, `.ruby-version`, `.python-version`) specify the versions.
- **Docker**: User must be in `docker` group (managed by Ansible). May require logout/login after Ansible provisioning.
- **Working Directory**: `.last_pwd` tracks the last working directory for shell navigation across sessions.
- **Arty Repository Manager**: `arty.yml` manages git subrepositories. Use `pnpm arty sync --env dev` to clone/update all dev repositories, or `--env prod` for production only.
