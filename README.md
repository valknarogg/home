<div align="center">

<pre>
 _    _____    __    __ __ _   _____    ____ _ _____
| |  / /   |  / /   / //_// | / /   |  / __ ( ) ___/
| | / / /| | / /   / ,<  /  |/ / /| | / /_/ //\__ \
| |/ / ___ |/ /___/ /| |/ /|  / ___ |/ _, _/ ___/ /
|___/_/  |_/_____/_/ |_/_/ |_/_/  |_/_/ |_| /____/

    __________  ____  ____________
   / ____/ __ \/ __ \/ ____/ ____/
  / /_  / / / / /_/ / / __/ __/
 / __/ / /_/ / _, _/ /_/ / /___
/_/    \____/_/ |_|\____/_____/
</pre>

# ⚡🔥 WHERE CODE MEETS CHAOS 🔥⚡

[![Debian](https://img.shields.io/badge/Debian-Trixie-A81D33?style=for-the-badge&logo=debian&logoColor=white)](https://www.debian.org/)
[![Powered by Metal](https://img.shields.io/badge/POWERED%20BY-METAL-FF0000?style=for-the-badge)](https://www.slayer.net/)
[![Built with Blood](https://img.shields.io/badge/BUILT%20WITH-BLOOD%20%26%20SWEAT-8B0000?style=for-the-badge)](/)
[![License: MIT](https://img.shields.io/badge/License-MIT-990000?style=for-the-badge)](LICENSE)

**My Debian home directory - forged in the fires of chaos, tempered with configuration files,**
**and wielded with the fury of a thousand riffs.**

*This is where dotfiles headbang and shell scripts scream.*

</div>

---

## ⚡ THE ARSENAL ⚡

### 🎸 **WEAPONS OF MASS DEVELOPMENT**

```
┌─────────────────────────────────────────────────┐
│  ⚔️  NODE.JS    │  Managed by nvm              │
│  ⚔️  PYTHON     │  Managed by pyenv            │
│  ⚔️  RUBY       │  Managed by rbenv            │
│  ⚔️  RUST       │  Managed by rustup           │
│  ⚔️  GO         │  Managed by gvm              │
│  ⚔️  DOCKER     │  Containerized destruction   │
│  ⚔️  POSTGRES   │  Version 18 database engine  │
└─────────────────────────────────────────────────┘
```

---

## 🔴 INITIALIZATION RITUAL 🔴

### **The `.init/` System - Your Shell's Dark Ceremony**

The `.init/` directory is the beating heart of this environment. When your shell awakens, it performs a sacred ritual through `~/.init/init.sh`, summoning power from these ancient scripts:

#### 🗡️ **THE SEVEN STAGES OF POWER**

```
┌──────────────────────────────────────────────────────────────┐
│ 1. PATH.SH       │ Forges the PATH to all binaries          │
│ 2. EXPORT.SH     │ Exports environment variables            │
│ 3. ALIAS.SH      │ Summons command shortcuts                │
│ 4. SOURCE.SH     │ Sources external power (nvm, cargo, etc) │
│ 5. FUNCTIONS.SH  │ Unleashes custom shell functions         │
│ 6. EVAL.SH       │ Evaluates version managers (rbenv, etc)  │
│ 7. START.SH      │ Executes startup commands (ssh-add)      │
└──────────────────────────────────────────────────────────────┘
```

#### 📜 **DETAILED BREAKDOWN OF EACH SCRIPT**

##### **1️⃣ `path.sh` - The Path of Destruction**
Adds all binary directories to your `$PATH`:
- `~/bin` - Your personal executables
- `~/.local/bin` - Local user binaries
- `~/.rbenv/bin` - Ruby version manager
- `~/.pyenv/bin` - Python version manager
- `~/.cargo/bin` - Rust binaries
- `~/go/bin` - Go binaries
- `~/node_modules/.bin` - Node.js binaries
- `~/.init/bin` - Custom init scripts
- `~/Projects/kompose` - Kompose tooling

##### **2️⃣ `export.sh` - Environmental Warfare**
```bash
export NVM_DIR="$HOME/.nvm"           # Node Version Manager home
export REPOS_DIR="$HOME/repos"        # Repository directory
export CHORE_CHORE="chore: chore"     # Default commit message
```

##### **3️⃣ `alias.sh` - Command Line Sorcery**
```bash
ri    # Reload init: source ~/.init/init.sh
g0    # Git stage all and check if clean
g1    # Git reset to single commit (nuclear option)
g2    # Get last commit message
rs    # Rsync with sudo on remote
ss    # Serve static files on port 8000
yt    # Download YouTube as MP3
```

##### **4️⃣ `source.sh` - External Power Summoning**
Sources critical external scripts:
- **NVM** - Node Version Manager (`$NVM_DIR/nvm.sh`)
- **RVM** - Ruby Version Manager (commented out)
- **Cargo** - Rust environment (`~/.cargo/env`)
- **Bash completion** for NVM

##### **5️⃣ `functions.sh` - The Grimoire of Bash**
Custom functions for deployment and media manipulation:

**Git Warfare:**
- `_home_push` - Commit and push changes
- `_home_pull` - Stash, pull, and pop changes

**Deployment Spells:**
- `_site_deploy_jekyll <site>` - Build & deploy Jekyll site
- `_site_deploy_nuxt <site>` - Build & deploy Nuxt site
- `_site_deploy_static <site>` - Deploy static files

**Media Alchemy:**
- `batch_file_sequence <prefix> <ext>` - Rename files with numbers
- `batch_image_webp` - Convert all images to WebP
- `batch_video_x264` - Convert videos to x264 codec
- `_image_optimize <name>` - Full image optimization pipeline
- `_video_optimize <file>` - Optimize video with ffmpeg

##### **6️⃣ `eval.sh` - Version Manager Invocation**
Initializes version managers through `eval`:
- **oh-my-posh** - Shell prompt theme engine
- **rbenv** - Ruby version manager
- **pyenv** - Python version manager

##### **7️⃣ `start.sh` - The Final Awakening**
Executes startup commands:
- `ssh-add` - Adds SSH keys to the agent silently

#### 🗂️ **Additional Directories**

- **`.init/bin/`** - Custom executable scripts (e.g., `mime_mp4_gif.sh`)
- **`.init/hooks/`** - Reserved for shell hooks (currently empty)

---

## 🩸 QUICK START RITUAL 🩸

### **Summoning the Environment**

```bash
# 1. Clone this unholy repository
git init && git remote add origin git@github.com:valknarogg/home.git
git fetch && git reset --hard origin/main
git branch --set-upstream-to=origin/main main

# 2. Install Ansible (if not already installed)
sudo apt install git ansible

# 3. Configure git
git config --global init.defaultBranch main
git config --global --add safe.directory /home/$USER

# 4. Unleash the Ansible playbook
sudo -u $USER ansible-playbook -K playbook.yml
```

### **Selective Provisioning**

Run specific parts of the setup using tags:

```bash
# Install only Node.js environment
ansible-playbook --tags node -K playbook.yml

# Install Python + Ruby
ansible-playbook --tags python,ruby -K playbook.yml

# Install everything
ansible-playbook -K playbook.yml
```

#### 🏷️ **Available Tags:**
`base` | `node` | `python` | `ruby` | `rust` | `zsh` | `postgres` | `docker` | `fonts` | `flatpak` | `github` | `oh-my-posh`

---

## 🎯 ARTY - REPOSITORY ORCHESTRATION 🎯

### **What is Arty?**

**Arty.sh** is a bash-based dependency and repository manager that orchestrates git subrepositories like a conductor of chaos. It's part of the [butter.sh](https://github.com/butter-sh/butter-sh.github.io) ecosystem - a suite of bash development tools.

### **Installing Arty**

Arty is already installed globally at `/usr/local/bin/arty`. If you need to install/update it:

```bash
# Clone butter.sh ecosystem
git clone https://github.com/butter-sh/butter-sh.github.io.git ~/Projects/butter-sh

# Install arty globally (requires sudo)
cd ~/Projects/butter-sh/projects/arty.sh
sudo ./arty.sh install
```

### **The `arty.yml` Configuration**

The root `~/arty.yml` defines your entire repository ecosystem:

```yaml
name: "Valknar's home"
version: "1.0.0"

envs:
  dev:   # Development environment
  prod:  # Production environment

references:
  # Project repositories
  - url: git@github.com:valknarogg/pivoine.art.git
    into: Projects/pivoine.art
    env: dev

  # Media repositories
  - url: git@github.com:valknarogg/home-pictures.git
    into: Bilder
    env: dev

  # Version managers
  - url: https://github.com/nvm-sh/nvm.git
    into: .nvm

  # ... and many more

scripts:
  debug: echo "$ARTY_BIN_DIR" && echo "$ARTY_LIBS_DIR"
```

### **Using Arty**

```bash
# Sync all dev environment repositories
arty sync --env dev

# Sync production repositories only
arty sync --env prod

# Install dependencies from arty.yml
arty install

# Run custom scripts defined in arty.yml
arty debug

# Show dependency tree
arty deps

# Update a specific reference
arty update pivoine.art
```

### **What Arty Manages:**
- ✅ Project repositories (pivoine.art, sexy.pivoine.art, etc.)
- ✅ Media repositories (Pictures, Videos, Music)
- ✅ Docker compose configurations
- ✅ Version managers (nvm, rbenv, pyenv, gvm)
- ✅ Oh-My-Zsh and plugins
- ✅ Shell scripts and binaries

### **Environment-Based Management**

References can be tagged with `env: dev` or `env: prod` to control which repositories are synced in different environments. This allows you to:
- Keep heavy media files out of production servers
- Separate development projects from system utilities
- Maintain clean, minimal deployments

---

## 🔥 COMMAND LINE BRUTALITY 🔥

### **Git Operations**

```bash
g0                  # Stage all changes and verify clean state
g1                  # Nuclear reset to single commit
g2                  # Show last commit message
git add -A && git commit -m "$(g2)"  # Reuse last commit message
```

### **Media Processing**

```bash
# Convert all images in directory to WebP
batch_image_webp

# Rename files with sequence numbers
batch_file_sequence artwork webp

# Optimize video
_video_optimize input.mov

# Download YouTube video as MP3
yt "https://youtube.com/watch?v=..."
```

### **Development Servers**

```bash
# Serve current directory on port 8000
ss

# Run Jekyll site with livereload
cd ~/Projects/pivoine.art && bundle exec jekyll serve --livereload

# Run Node.js dev server
cd ~/Projects/node.js/awesome && pnpm dev
```

### **Rsync Power**

```bash
# Sync to remote with sudo
rs /local/path/ user@host:/remote/path/
```

---

## 📁 PROJECT STRUCTURE 📁

```
~/Projects/
├── butter-sh/              # Butter.sh ecosystem (arty, judge, myst, etc.)
├── docker-compose/         # Docker orchestration configs
├── pivoine.art/            # Jekyll art portfolio (main site)
├── docs.pivoine.art/       # Documentation site
├── sexy.pivoine.art/       # Rust + web project (includes buttplug package)
└── node.js/
    ├── awesome/            # GitHub Awesome lists browser
    ├── awesome-app/        # Awesome list application
    ├── email-pour-vous/    # Email templating project
    └── webshot/            # Website screenshot tool
```

---

## 🛠️ DOTFILE HIGHLIGHTS 🛠️

### **Shell Configuration**
- **`.zshrc`** - Oh-My-Zsh with Powerlevel10k theme
- **`.p10k.zsh`** - Powerlevel10k configuration
- **`.bashrc`** - Bash configuration (fallback)

### **Version Files**
- **`.nvmrc`** - Node.js version
- **`.ruby-version`** - Ruby version
- **`.python-version`** - Python version

### **Code Quality**
- **`.pre-commit-config.yaml`** - Pre-commit hooks (Python)
- **`.rubocop.yml`** - Ruby style enforcement
- **`eslint.config.mts`** - JavaScript/TypeScript linting
- **`.prettierrc`** - Code formatting rules
- **`biome.json`** - Fast linter/formatter

### **Package Management**
- **`requirements.txt`** - Python packages (pip)
- **`Gemfile`** - Ruby gems (bundler)

### **Git Configuration**
- **`.gitignore`** - INVERTED PATTERN (ignore all, allow specific files)
- **`.gitconfig`** - Git user configuration

### **Orchestration**
- **`arty.yml`** - Repository and dependency management
- **`playbook.yml`** - Ansible system provisioning

---

## ⚙️ GIT SELECTIVE TRACKING ⚙️

This repository uses an **inverted `.gitignore`** pattern:

```gitignore
# Ignore everything
*

# Allow specific files
!CLAUDE.md
!README.md
!.gitignore
!.init/**
!arty.yml
!playbook.yml
...
```

**Why?** To track only essential dotfiles and configurations while ignoring cache, logs, and user data. Your home directory becomes a git repository without the chaos.

---

## 🎸 SHELL PLUGIN POWER 🎸

**Oh-My-Zsh Plugins Loaded:**
```
git pm2 gh sudo ssh ruby rust python node github
rsync nvm rbenv pyenv docker docker-compose qrcode
zsh-autosuggestions zsh-syntax-highlighting
zsh-interactive-cd zsh-navigation-tools
```

---

## 🔗 USEFUL RESOURCES 🔗

### System & Shell
- [Ansible Documentation](https://docs.ansible.com/)
- [Oh-My-Zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)

### Language Managers
- [nvm](https://github.com/nvm-sh/nvm) - Node Version Manager
- [rbenv](https://github.com/rbenv/rbenv) - Ruby Version Manager
- [pyenv](https://github.com/pyenv/pyenv) - Python Version Manager
- [gvm](https://github.com/moovweb/gvm) - Go Version Manager
- [rustup](https://rustup.rs/) - Rust Toolchain Manager

### Orchestration
- [Arty.sh Documentation](https://github.com/butter-sh/butter-sh.github.io)
- [Butter.sh Ecosystem](https://butter.sh)

---

## 🖤 LICENSE 🖤

MIT License - Do whatever the hell you want with it.

---

<div align="center">

<pre>
═════════════════════════════════════════════════════════════════

__________  ____  ______   _________
  / ____/ __ \/ __ \/ ____/  /  _/ ___/
 / /   / / / / / / / __/     / / \__ \
/ /___/ /_/ / /_/ / /___   _/ / ___/ /
\____/\____/_____/_____/  /___//____/

  ______________  _______  ____  ____  ___    ______  __
 /_  __/ ____/  |/  / __ \/ __ \/ __ \/   |  / __ \ \/ /
  / / / __/ / /|_/ / /_/ / / / / /_/ / /| | / /_/ /\  /
 / / / /___/ /  / / ____/ /_/ / _, _/ ___ |/ _, _/ / /
/_/ /_____/_/  /_/_/    \____/_/ |_/_/  |_/_/ |_| /_/

    __  __________________    __       _________
   /  |/  / ____/_  __/   |  / /      /  _/ ___/
  / /|_/ / __/   / / / /| | / /       / / \__ \
 / /  / / /___  / / / ___ |/ /___   _/ / ___/ /
/_/  /_/_____/ /_/ /_/  |_/_____/  /___//____/

    ______________________  _   _____    __
   / ____/_  __/ ____/ __ \/ | / /   |  / /
  / __/   / / / __/ / /_/ /  |/ / /| | / /
 / /___  / / / /___/ _, _/ /|  / ___ |/ /___
/_____/ /_/ /_____/_/ |_/_/ |_/_/  |_/_____/

═════════════════════════════════════════════════════════════════

🔥⚡ FORGED BY VALKNAR ⚡🔥
valknar@pivoine.art
Powered by Debian | Fueled by Metal

🤘 🤘 🤘
</pre>

**[⚔️ BACK TO THE TOP ⚔️](#)**

</div>
