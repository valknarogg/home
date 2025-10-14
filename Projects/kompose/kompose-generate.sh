#!/bin/bash

# kompose-generate.sh - Stack Generator Functions
# Part of kompose.sh - Docker Compose Stack Manager
#
# This module handles generation of custom stacks with templated files

# ============================================================================
# GENERATOR CONFIGURATION
# ============================================================================

GENERATOR_CUSTOM_DIR="${STACKS_ROOT}/+custom"
GENERATOR_DOCS_DIR="${STACKS_ROOT}/_docs/content/5.stacks/+custom"
GENERATOR_TESTS_DIR="${STACKS_ROOT}/__tests/generated"

# ============================================================================
# TEMPLATE FUNCTIONS
# ============================================================================

# Generate Docker Compose template
generate_compose_template() {
    local stack_name=$1
    local stack_upper=$(echo "$stack_name" | tr '[:lower:]' '[:upper:]')
    
    cat << EOF
name: ${stack_name}

services:
  ${stack_name}:
    image: \${DOCKER_IMAGE}
    container_name: \${COMPOSE_PROJECT_NAME}_app
    restart: unless-stopped
    environment:
      TZ: \${TIMEZONE:-Europe/Amsterdam}
      # Add your environment variables here
    # Uncomment and configure volumes as needed
    # volumes:
    #   - ${stack_name}_data:/data
    healthcheck:
      test: ["CMD-SHELL", "wget --spider -q http://localhost:\${APP_PORT:-80}/health || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 30s
    networks:
      - kompose_network
    # Uncomment to expose ports directly
    # ports:
    #   - "\${APP_PORT}:80"
    labels:
      - 'traefik.enable=true'
      - 'traefik.http.middlewares.\${COMPOSE_PROJECT_NAME}-redirect-web-secure.redirectscheme.scheme=https'
      - 'traefik.http.routers.\${COMPOSE_PROJECT_NAME}-web.middlewares=\${COMPOSE_PROJECT_NAME}-redirect-web-secure'
      - 'traefik.http.routers.\${COMPOSE_PROJECT_NAME}-web.rule=Host(\`\${TRAEFIK_HOST}\`)'
      - 'traefik.http.routers.\${COMPOSE_PROJECT_NAME}-web.entrypoints=web'
      - 'traefik.http.routers.\${COMPOSE_PROJECT_NAME}-web-secure.rule=Host(\`\${TRAEFIK_HOST}\`)'
      - 'traefik.http.routers.\${COMPOSE_PROJECT_NAME}-web-secure.tls.certresolver=resolver'
      - 'traefik.http.routers.\${COMPOSE_PROJECT_NAME}-web-secure.entrypoints=web-secure'
      - 'traefik.http.middlewares.\${COMPOSE_PROJECT_NAME}-web-secure-compress.compress=true'
      - 'traefik.http.routers.\${COMPOSE_PROJECT_NAME}-web-secure.middlewares=\${COMPOSE_PROJECT_NAME}-web-secure-compress'
      - 'traefik.http.services.\${COMPOSE_PROJECT_NAME}-web-secure.loadbalancer.server.port=\${APP_PORT:-80}'
      - 'traefik.docker.network=\${NETWORK_NAME:-kompose}'

# Uncomment and configure volumes as needed
# volumes:
#   ${stack_name}_data:
#     name: \${COMPOSE_PROJECT_NAME}_data

networks:
  kompose_network:
    name: \${NETWORK_NAME:-kompose}
    external: true
EOF
}

# Generate .env template
generate_env_template() {
    local stack_name=$1
    local stack_upper=$(echo "$stack_name" | tr '[:lower:]' '[:upper:]')
    
    cat << EOF
# =================================================================
# ${stack_upper} Stack Configuration
# =================================================================

# Stack identification
COMPOSE_PROJECT_NAME=${stack_name}

# Docker image
DOCKER_IMAGE=your-image:latest

# Network configuration
NETWORK_NAME=kompose

# Traefik configuration
TRAEFIK_ENABLED=true
TRAEFIK_HOST=\${TRAEFIK_HOST_${stack_upper}}

# Application configuration
APP_PORT=80

# Timezone
TIMEZONE=Europe/Amsterdam

# Add your custom environment variables below
# -----------------------------------------------

# NOTE: Secrets should be stored in root secrets.env file
# Available secrets for this stack:
# - Add secret names here as comments for documentation
EOF
}

# Generate README template
generate_readme_template() {
    local stack_name=$1
    local stack_title=$(echo "$stack_name" | sed 's/\b\(.\)/\u\1/g')
    
    cat << 'EOF'
# {{STACK_TITLE}} Stack

Custom Docker Compose stack for {{STACK_NAME}}.

## Overview

The {{STACK_NAME}} stack provides:
- **Description** - Add description here
- **Features** - List key features

## Configuration

### Environment Variables

All {{STACK_NAME}} stack variables are defined in `+custom/{{STACK_NAME}}/.env`:

```bash
# Stack identification
COMPOSE_PROJECT_NAME={{STACK_NAME}}

# Docker image
DOCKER_IMAGE=your-image:latest

# Traefik configuration
TRAEFIK_ENABLED=true
TRAEFIK_HOST=${TRAEFIK_HOST_{{STACK_UPPER}}}

# Application port
APP_PORT=80
```

### Domain Configuration

Add your subdomain to the root `domain.env` file:

```bash
# {{STACK_TITLE}} subdomain
SUBDOMAIN_{{STACK_UPPER}}={{STACK_NAME}}
```

This will generate `TRAEFIK_HOST_{{STACK_UPPER}}` automatically.

### Secrets

If your stack requires secrets, add them to the root `secrets.env` file:

```bash
# {{STACK_TITLE}} stack secrets
{{STACK_UPPER}}_SECRET=your-secret-here
{{STACK_UPPER}}_API_KEY=your-api-key
```

Generate random secrets with:
```bash
./kompose.sh secrets generate
```

## Services

### {{STACK_TITLE}} Application
- **Image:** `your-image:latest`
- **Container:** `{{STACK_NAME}}_app`
- **Port:** 80 (internal only, proxied via Traefik)
- **Purpose:** Main application service
- **Access:** `https://{{STACK_NAME}}.yourdomain.com`

## Quick Start

### 1. Configure Domain

Add subdomain to `domain.env`:

```bash
echo "SUBDOMAIN_{{STACK_UPPER}}={{STACK_NAME}}" >> domain.env
```

### 2. Configure Environment

Edit `+custom/{{STACK_NAME}}/.env`:

```bash
vim +custom/{{STACK_NAME}}/.env

# Update:
DOCKER_IMAGE=your-actual-image:version
APP_PORT=80  # or your application port
```

### 3. Configure Secrets (if needed)

Add secrets to `secrets.env`:

```bash
vim secrets.env

# Add:
{{STACK_UPPER}}_SECRET=$(openssl rand -base64 32)
{{STACK_UPPER}}_API_KEY=your-api-key
```

### 4. Start Stack

```bash
# Ensure kompose network exists
docker network create kompose

# Start the stack
./kompose.sh up {{STACK_NAME}}

# Verify status
./kompose.sh status {{STACK_NAME}}
```

### 5. Access Application

- **Local:** `http://localhost:${APP_PORT}` (if ports exposed)
- **Production:** `https://{{STACK_NAME}}.yourdomain.com`

## Customization

### Add Volumes

Edit `compose.yaml` to add persistent storage:

```yaml
services:
  {{STACK_NAME}}:
    volumes:
      - {{STACK_NAME}}_data:/app/data

volumes:
  {{STACK_NAME}}_data:
    name: ${COMPOSE_PROJECT_NAME}_data
```

### Add Database Connection

If your service needs database access:

```yaml
services:
  {{STACK_NAME}}:
    environment:
      DB_HOST: ${DB_HOST}
      DB_PORT: ${DB_PORT}
      DB_NAME: {{STACK_NAME}}
      DB_USER: ${DB_USER}
      DB_PASSWORD: ${DB_PASSWORD}
    depends_on:
      - core-postgres
```

Don't forget to create the database:
```bash
./kompose.sh db exec -d postgres "CREATE DATABASE {{STACK_NAME}};"
```

### Configure Additional Services

Add more services to `compose.yaml`:

```yaml
services:
  {{STACK_NAME}}-worker:
    image: ${DOCKER_IMAGE}
    container_name: ${COMPOSE_PROJECT_NAME}_worker
    command: worker
    environment:
      REDIS_URL: redis://core-redis:6379
    networks:
      - kompose_network
```

## Management

### View Logs

```bash
# Follow logs
./kompose.sh logs {{STACK_NAME}} -f

# Last 100 lines
./kompose.sh logs {{STACK_NAME}} --tail 100
```

### Restart Service

```bash
./kompose.sh restart {{STACK_NAME}}
```

### Update Image

```bash
# Pull latest image
./kompose.sh pull {{STACK_NAME}}

# Restart with new image
./kompose.sh up {{STACK_NAME}}
```

### Execute Commands

```bash
# Open shell
./kompose.sh exec {{STACK_NAME}} sh

# Run command
./kompose.sh exec {{STACK_NAME}} your-command
```

## Troubleshooting

### Container Won't Start

```bash
# Check logs
docker logs {{STACK_NAME}}_app

# Validate compose file
./kompose.sh validate {{STACK_NAME}}

# Check environment
cd +custom/{{STACK_NAME}}
docker compose config
```

### Traefik Not Routing

```bash
# Verify Traefik labels
docker inspect {{STACK_NAME}}_app | grep traefik

# Check Traefik logs
docker logs proxy-traefik

# Verify domain resolution
nslookup {{STACK_NAME}}.yourdomain.com
```

### Health Check Failing

Adjust health check in `compose.yaml`:

```yaml
healthcheck:
  test: ["CMD-SHELL", "your-health-check-command"]
  interval: 30s
  timeout: 10s
  retries: 3
  start_period: 30s
```

## See Also

- [Stack Configuration Overview](/reference/stack-configuration)
- [Custom Stacks Guide](/guide/custom-stacks)
- [Traefik Configuration](/reference/traefik)
- [Database Management](/guide/database)

---

**Configuration Location:** `+custom/{{STACK_NAME}}/.env`  
**Domain Configuration:** `domain.env` (SUBDOMAIN_{{STACK_UPPER}})  
**Secrets Location:** `secrets.env`  
**Docker Network:** `kompose`
EOF
    # Replace template variables
    sed -e "s/{{STACK_NAME}}/${stack_name}/g" \
        -e "s/{{STACK_TITLE}}/${stack_title}/g" \
        -e "s/{{STACK_UPPER}}/${stack_upper}/g"
}

# Generate test template
generate_test_template() {
    local stack_name=$1
    
    cat << 'EOF'
#!/bin/bash

# Test generated custom stack: {{STACK_NAME}}

source "$(dirname "$0")/test-helpers.sh"

test_{{STACK_NAME}}_compose_valid() {
    cd "+custom/{{STACK_NAME}}"
    assert_true "docker compose config > /dev/null 2>&1" \
        "{{STACK_NAME}} compose.yaml should be valid"
}

test_{{STACK_NAME}}_env_exists() {
    assert_file_exists "+custom/{{STACK_NAME}}/.env" \
        "{{STACK_NAME}} .env file should exist"
}

test_{{STACK_NAME}}_readme_exists() {
    assert_file_exists "_docs/content/5.stacks/+custom/{{STACK_NAME}}.md" \
        "{{STACK_NAME}} README.md should exist in docs"
}

test_{{STACK_NAME}}_network_configured() {
    cd "+custom/{{STACK_NAME}}"
    assert_contains "$(docker compose config)" "kompose" \
        "{{STACK_NAME}} should use kompose network"
}

test_{{STACK_NAME}}_traefik_labels() {
    cd "+custom/{{STACK_NAME}}"
    assert_contains "$(docker compose config)" "traefik.enable" \
        "{{STACK_NAME}} should have Traefik labels"
}

# Run tests
run_tests
EOF
    sed "s/{{STACK_NAME}}/${stack_name}/g"
}

# ============================================================================
# GENERATOR COMMANDS
# ============================================================================

# Generate a new custom stack
generate_stack() {
    local stack_name=$1
    
    # Validate stack name
    if [ -z "$stack_name" ]; then
        log_error "Stack name is required"
        echo ""
        echo "Usage: kompose generate <stack-name> [options]"
        echo ""
        echo "Example: kompose generate myapp"
        return 1
    fi
    
    # Validate stack name format (alphanumeric and hyphens only)
    if ! [[ "$stack_name" =~ ^[a-z0-9-]+$ ]]; then
        log_error "Invalid stack name. Use only lowercase letters, numbers, and hyphens."
        return 1
    fi
    
    local stack_dir="${GENERATOR_CUSTOM_DIR}/${stack_name}"
    local docs_file="${GENERATOR_DOCS_DIR}/${stack_name}.md"
    local test_file="${GENERATOR_TESTS_DIR}/test-${stack_name}.sh"
    
    # Check if stack already exists
    if [ -d "$stack_dir" ]; then
        log_error "Stack already exists: $stack_name"
        log_info "Location: $stack_dir"
        echo ""
        read -p "Overwrite existing stack? [y/N]: " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Generation cancelled"
            return 0
        fi
        log_warning "Overwriting existing stack..."
    fi
    
    log_info "Generating custom stack: $stack_name"
    echo ""
    
    # Create directories
    log_info "Creating directories..."
    mkdir -p "$stack_dir"
    mkdir -p "$GENERATOR_DOCS_DIR"
    mkdir -p "$GENERATOR_TESTS_DIR"
    
    # Generate files
    log_info "Generating compose.yaml..."
    generate_compose_template "$stack_name" > "${stack_dir}/compose.yaml"
    
    log_info "Generating .env..."
    generate_env_template "$stack_name" > "${stack_dir}/.env"
    
    log_info "Generating README.md..."
    generate_readme_template "$stack_name" > "$docs_file"
    
    log_info "Generating test file..."
    generate_test_template "$stack_name" > "$test_file"
    chmod +x "$test_file"
    
    # Create .gitignore
    cat > "${stack_dir}/.gitignore" << EOF
.env.generated
*.log
*.pid
EOF
    
    # Add to domain.env if not exists
    local stack_upper=$(echo "$stack_name" | tr '[:lower:]' '[:upper:]')
    if [ -f "${STACKS_ROOT}/domain.env" ]; then
        if ! grep -q "SUBDOMAIN_${stack_upper}" "${STACKS_ROOT}/domain.env"; then
            log_info "Adding subdomain to domain.env..."
            echo "" >> "${STACKS_ROOT}/domain.env"
            echo "# ${stack_name} subdomain" >> "${STACKS_ROOT}/domain.env"
            echo "SUBDOMAIN_${stack_upper}=${stack_name}" >> "${STACKS_ROOT}/domain.env"
        fi
    fi
    
    echo ""
    log_success "Stack '${stack_name}' generated successfully!"
    echo ""
    log_info "Generated files:"
    echo "  📄 ${stack_dir}/compose.yaml"
    echo "  📄 ${stack_dir}/.env"
    echo "  📝 ${docs_file}"
    echo "  🧪 ${test_file}"
    echo ""
    log_info "Next steps:"
    echo "  1. Edit ${stack_dir}/.env and configure your stack"
    echo "  2. Edit ${stack_dir}/compose.yaml and customize services"
    echo "  3. Edit ${docs_file} and update documentation"
    echo "  4. Start your stack: ./kompose.sh up ${stack_name}"
    echo ""
    log_info "To customize further:"
    echo "  - Add secrets to secrets.env if needed"
    echo "  - Configure subdomain in domain.env (already added)"
    echo "  - Test your stack: ./kompose.sh test -t ${stack_name}"
    echo ""
}

# List generated custom stacks
list_custom_stacks() {
    echo ""
    log_info "Custom stacks:"
    echo ""
    
    if [ ! -d "$GENERATOR_CUSTOM_DIR" ]; then
        log_warning "No custom stacks directory found"
        echo ""
        log_info "Generate your first custom stack:"
        echo "  ./kompose.sh generate myapp"
        echo ""
        return 0
    fi
    
    local count=0
    for dir in "${GENERATOR_CUSTOM_DIR}"/*; do
        if [ -d "$dir" ] && [ -f "${dir}/compose.yaml" ]; then
            local stack_name=$(basename "$dir")
            count=$((count+1))
            
            echo -e "  ${CYAN}${stack_name}${NC}"
            
            # Show if running
            cd "$dir"
            if docker compose ps -q 2>/dev/null | grep -q .; then
                local running=$(docker compose ps -q 2>/dev/null | wc -l)
                echo -e "    Status: ${GREEN}${running} containers running${NC}"
            else
                echo -e "    Status: ${YELLOW}stopped${NC}"
            fi
            
            # Show location
            echo "    Location: ${dir}"
            
            # Show docs if exists
            local docs_file="${GENERATOR_DOCS_DIR}/${stack_name}.md"
            if [ -f "$docs_file" ]; then
                echo "    Docs: ${docs_file}"
            fi
            
            echo ""
        fi
    done
    
    if [ $count -eq 0 ]; then
        log_info "No custom stacks found"
        echo ""
        log_info "Generate your first custom stack:"
        echo "  ./kompose.sh generate myapp"
        echo ""
    else
        log_info "Total: $count custom stack(s)"
        echo ""
    fi
}

# Delete a custom stack
delete_custom_stack() {
    local stack_name=$1
    
    if [ -z "$stack_name" ]; then
        log_error "Stack name is required"
        echo ""
        echo "Usage: kompose generate delete <stack-name>"
        return 1
    fi
    
    local stack_dir="${GENERATOR_CUSTOM_DIR}/${stack_name}"
    local docs_file="${GENERATOR_DOCS_DIR}/${stack_name}.md"
    local test_file="${GENERATOR_TESTS_DIR}/test-${stack_name}.sh"
    
    if [ ! -d "$stack_dir" ]; then
        log_error "Stack not found: $stack_name"
        return 1
    fi
    
    echo ""
    log_warning "This will delete the following:"
    echo "  - Stack directory: $stack_dir"
    [ -f "$docs_file" ] && echo "  - Documentation: $docs_file"
    [ -f "$test_file" ] && echo "  - Test file: $test_file"
    echo ""
    
    read -p "Are you sure you want to delete stack '${stack_name}'? [y/N]: " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Deletion cancelled"
        return 0
    fi
    
    # Stop stack if running
    if docker compose -f "${stack_dir}/compose.yaml" ps -q 2>/dev/null | grep -q .; then
        log_warning "Stopping running stack..."
        cd "$stack_dir"
        docker compose down
    fi
    
    # Delete files
    log_info "Deleting files..."
    rm -rf "$stack_dir"
    [ -f "$docs_file" ] && rm "$docs_file"
    [ -f "$test_file" ] && rm "$test_file"
    
    log_success "Stack '${stack_name}' deleted successfully"
    echo ""
}

# Show information about a custom stack
show_custom_stack() {
    local stack_name=$1
    
    if [ -z "$stack_name" ]; then
        log_error "Stack name is required"
        echo ""
        echo "Usage: kompose generate show <stack-name>"
        return 1
    fi
    
    local stack_dir="${GENERATOR_CUSTOM_DIR}/${stack_name}"
    local docs_file="${GENERATOR_DOCS_DIR}/${stack_name}.md"
    local test_file="${GENERATOR_TESTS_DIR}/test-${stack_name}.sh"
    
    if [ ! -d "$stack_dir" ]; then
        log_error "Stack not found: $stack_name"
        return 1
    fi
    
    echo ""
    log_info "Custom stack: $stack_name"
    echo ""
    
    # Show files
    echo -e "${CYAN}Files:${NC}"
    echo "  compose.yaml: ${stack_dir}/compose.yaml"
    echo "  .env: ${stack_dir}/.env"
    [ -f "$docs_file" ] && echo "  README.md: ${docs_file}"
    [ -f "$test_file" ] && echo "  Test: ${test_file}"
    echo ""
    
    # Show status
    echo -e "${CYAN}Status:${NC}"
    cd "$stack_dir"
    if docker compose ps -q 2>/dev/null | grep -q .; then
        docker compose ps
    else
        echo "  Stack is not running"
    fi
    echo ""
    
    # Show configuration
    echo -e "${CYAN}Configuration:${NC}"
    if [ -f "${stack_dir}/.env" ]; then
        cat "${stack_dir}/.env" | grep -v "^#" | grep -v "^$"
    fi
    echo ""
}

# Handle generate subcommands
handle_generate_command() {
    if [ $# -eq 0 ]; then
        log_error "Generate subcommand required"
        echo ""
        echo "Available generate commands:"
        echo "  <stack-name>     Generate a new custom stack"
        echo "  list             List all custom stacks"
        echo "  show <name>      Show stack information"
        echo "  delete <name>    Delete a custom stack"
        echo ""
        echo "Examples:"
        echo "  kompose generate myapp         # Create new stack"
        echo "  kompose generate list           # List custom stacks"
        echo "  kompose generate show myapp     # Show stack info"
        echo "  kompose generate delete myapp   # Delete stack"
        return 1
    fi
    
    local subcmd=$1
    shift
    
    case $subcmd in
        list)
            list_custom_stacks
            ;;
        show)
            show_custom_stack "$@"
            ;;
        delete|remove|rm)
            delete_custom_stack "$@"
            ;;
        help|--help|-h)
            handle_generate_command
            ;;
        *)
            # Default: generate new stack
            generate_stack "$subcmd" "$@"
            ;;
    esac
}
