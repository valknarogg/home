# 🎻 Contributing to Kompose

First off, thank you for considering contributing to Kompose! 🎉

It's people like you that make Kompose such a great tool. Every contribution, no matter how small, helps make Docker orchestration a little less painful and a lot more musical.

## 🎯 Quick Links

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Style Guidelines](#style-guidelines)
- [Commit Messages](#commit-messages)
- [Pull Request Process](#pull-request-process)

## 📜 Code of Conduct

This project and everyone participating in it is governed by common sense and mutual respect. By participating, you are expected to:

- ✨ Be welcoming and friendly
- 🤝 Respect differing viewpoints and experiences
- 🎯 Focus on what is best for the community
- 🙌 Show empathy towards other community members
- ☕ Remember that we're all human (and probably under-caffeinated)

## 🎪 How Can I Contribute?

### 🐛 Reporting Bugs

Before creating bug reports, please check existing issues as you might find out that you don't need to create one.

When you are creating a bug report, please include as many details as possible:

**Great Bug Report Template:**
```markdown
## Description
A clear and concise description of the bug.

## Steps to Reproduce
1. Run `./kompose.sh ...`
2. See error

## Expected Behavior
What you expected to happen.

## Actual Behavior
What actually happened.

## Environment
- OS: [e.g., Ubuntu 22.04]
- Docker Version: [e.g., 24.0.5]
- Bash Version: [e.g., 5.1.16]
- Kompose Version/Commit: [e.g., commit abc123]

## Additional Context
Any other context, logs, or screenshots.
```

### 💡 Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, include:

- **Use a clear and descriptive title**
- **Provide a detailed description of the suggested enhancement**
- **Explain why this enhancement would be useful**
- **List some examples of how it would be used**

### 🎨 Your First Code Contribution

Unsure where to begin? Look for issues labeled:
- `good first issue` - Simple issues perfect for newcomers
- `help wanted` - Issues we'd love help with
- `documentation` - Improvements to docs

### 🔧 Pull Requests

Ready to contribute code? Awesome! Follow these steps:

1. **Fork & Clone**
   ```bash
   git clone https://github.com/YOUR-USERNAME/kompose.git
   cd kompose
   ```

2. **Create a Branch**
   ```bash
   git checkout -b feature/amazing-feature
   # or
   git checkout -b fix/annoying-bug
   ```

3. **Make Your Changes**
   - Write clean, readable code
   - Add comments for complex logic
   - Test thoroughly with `--dry-run`

4. **Test Your Changes**
   ```bash
   # Test basic functionality
   ./kompose.sh --help
   ./kompose.sh --list
   
   # Test dry-run mode
   ./kompose.sh --dry-run "*" up -d
   
   # Test with actual stacks if possible
   ./kompose.sh blog up -d
   ```

5. **Commit Your Changes**
   ```bash
   git add .
   git commit -m "feat: add amazing feature"
   ```

6. **Push to Your Fork**
   ```bash
   git push origin feature/amazing-feature
   ```

7. **Open a Pull Request**
   - Go to the original kompose repository
   - Click "New Pull Request"
   - Select your fork and branch
   - Fill in the PR template

## 🛠️ Development Setup

### Prerequisites

- Bash 4.0+
- Docker & Docker Compose
- Git
- PostgreSQL client tools (for db operations)

### Setting Up

```bash
# Clone your fork
git clone https://github.com/YOUR-USERNAME/kompose.git
cd kompose

# Make script executable
chmod +x kompose.sh

# Create test environment
cp .env.example .env
nano .env

# Create Docker network
docker network create kompose

# Test the script
./kompose.sh --help
```

### Testing

```bash
# Syntax check
bash -n kompose.sh

# ShellCheck (highly recommended)
shellcheck kompose.sh

# Test with dry-run
./kompose.sh --dry-run "*" ps

# Test specific features
./kompose.sh --list
./kompose.sh blog up -d --dry-run
./kompose.sh -e TEST=value blog ps --dry-run
```

## 📝 Style Guidelines

### Shell Script Style

We follow these conventions:

#### Variables
```bash
# Constants in UPPER_CASE
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly ROOT_ENV_FILE="${SCRIPT_DIR}/.env"

# Local variables in lowercase
local stack_dir="$1"
local dump_file="$2"
```

#### Functions
```bash
# Descriptive function names with underscores
function_name() {
    local param="$1"
    
    # Early returns for validation
    if [[ -z "${param}" ]]; then
        return 1
    fi
    
    # Main logic here
    
    return 0
}
```

#### Error Handling
```bash
# Use set -euo pipefail at the top
set -euo pipefail

# Check command success
if ! docker compose up -d; then
    log_error "Failed to start containers"
    return 1
fi
```

#### Logging
```bash
# Use consistent logging functions
log_info "Starting operation..."
log_success "Operation completed!"
log_warning "This might be a problem"
log_error "Something went wrong"
```

### Documentation Style

- Use clear, concise language
- Include code examples
- Add emojis sparingly but meaningfully
- Keep line length reasonable (80-120 chars)
- Use proper markdown formatting

## 💬 Commit Messages

We follow [Conventional Commits](https://www.conventionalcommits.org/):

### Format
```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

### Examples

**Good commits:**
```
feat(db): add automatic dump cleanup command

Added db:cleanup command that removes old database dumps while keeping
the latest one. Helps manage disk space for stacks with frequent backups.

Closes #42
```

```
fix(network): correct Traefik network detection

Fixed issue where Traefik couldn't detect containers due to network name
mismatch. Changed labels from hardcoded 'kompose_network' to use
NETWORK_NAME variable.

Fixes #123
```

**Bad commits:**
```
Fixed stuff
Updated file
Changes
wip
asdasd
```

## 🔄 Pull Request Process

1. **Update Documentation**
   - Update README.md if needed
   - Add/update code comments
   - Update CHANGELOG.md

2. **Test Thoroughly**
   - Test on your own setup
   - Use dry-run mode
   - Check for edge cases

3. **Follow the Template**
   ```markdown
   ## Description
   Brief description of changes
   
   ## Type of Change
   - [ ] Bug fix
   - [ ] New feature
   - [ ] Documentation update
   
   ## Testing
   How you tested the changes
   
   ## Checklist
   - [ ] Code follows style guidelines
   - [ ] Documentation updated
   - [ ] Tested with --dry-run
   - [ ] No breaking changes
   ```

4. **Be Responsive**
   - Respond to review comments
   - Make requested changes
   - Ask questions if unclear

5. **Celebrate** 🎉
   - Once merged, your contribution is part of Kompose!
   - You've made the Docker world a little better!

## 🎁 Recognition

All contributors will be:
- Listed in README.md (if you want)
- Mentioned in release notes
- Forever grateful for their help
- Awarded virtual high-fives 🙌

## 🆘 Getting Help

Stuck? No worries!

- **Discord/Slack:** [Coming soon]
- **GitHub Discussions:** Ask questions
- **GitHub Issues:** Report problems
- **Email:** [maintainer email]

## 📚 Resources

- [Bash Best Practices](https://google.github.io/styleguide/shellguide.html)
- [Docker Compose Docs](https://docs.docker.com/compose/)
- [ShellCheck](https://www.shellcheck.net/)
- [Conventional Commits](https://www.conventionalcommits.org/)

---

<div align="center">

### 🎵 Thank You! 🎵

Your contributions make Kompose better for everyone.

**"In the symphony of open source, every contribution is a note that makes the music complete."**

Made with ❤️ by contributors like you

</div>
