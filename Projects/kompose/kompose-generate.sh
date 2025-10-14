#!/bin/bash

# kompose-generate.sh - Stack Generator Functions
# Part of kompose.sh - Docker Compose Stack Manager
#
# This module handles generation of stacks from templates and custom stacks

# ============================================================================
# GENERATOR CONFIGURATION
# ============================================================================

GENERATOR_TEMPLATES_DIR="${STACKS_ROOT}/_templates"
GENERATOR_STACKS_DIR="${STACKS_ROOT}/+stacks"
GENERATOR_CUSTOM_DIR="${STACKS_ROOT}/+custom"
GENERATOR_DOCS_DIR="${STACKS_ROOT}/_docs/content/5.stacks/+custom"
GENERATOR_TESTS_DIR="${STACKS_ROOT}/__tests/generated"

# ============================================================================
# TEMPLATE PARSING FUNCTIONS
# ============================================================================

# Parse kompose.yml file using basic shell parsing
parse_kompose_yml() {
    local yml_file="$1"
    local section="$2"  # environment, secrets, dependencies, etc.
    
    if [ ! -f "$yml_file" ]; then
        log_error "kompose.yml not found: $yml_file"
        return 1
    fi
    
    # This is a simple parser - for production use, consider yq or python
    case "$section" in
        name)
            grep "^name:" "$yml_file" | head -1 | sed 's/name: *//' | tr -d '"'
            ;;
        description)
            grep "^description:" "$yml_file" | head -1 | sed 's/description: *//' | tr -d '"'
            ;;
        version)
            grep "^version:" "$yml_file" | head -1 | sed 's/version: *//' | tr -d '"'
            ;;
        *)
            log_error "Unknown section: $section"
            return 1
            ;;
    esac
}

# Extract environment variables from kompose.yml
extract_env_vars() {
    local yml_file="$1"
    
    if [ ! -f "$yml_file" ]; then
        return 1
    fi
    
    # Extract environment section
    awk '
        /^environment:/ { in_env=1; next }
        in_env && /^[a-z]/ { in_env=0 }
        in_env && /^  - name:/ { 
            name=$3
            getline; default=$2
            getline; desc=$2
            getline; req=$2
            printf "%s|%s|%s|%s\n", name, default, desc, req
        }
    ' "$yml_file" | sed 's/["]//g'
}

# Extract secrets from kompose.yml
extract_secrets() {
    local yml_file="$1"
    
    if [ ! -f "$yml_file" ]; then
        return 1
    fi
    
    # Extract secrets section
    awk '
        /^secrets:/ { in_sec=1; next }
        in_sec && /^[a-z]/ { in_sec=0 }
        in_sec && /^  - name:/ {
            name=$3
            getline; desc=$2
            getline; req=$2
            getline; type=$2
            printf "%s|%s|%s|%s\n", name, desc, req, type
        }
    ' "$yml_file" | sed 's/["]//g'
}

# ============================================================================
# TEMPLATE-BASED STACK GENERATION
# ============================================================================

# Generate stack from template
generate_from_template() {
    local stack_name="$1"
    local force="${2:-false}"
    
    local template_dir="${GENERATOR_TEMPLATES_DIR}/${stack_name}"
    local output_dir="${GENERATOR_STACKS_DIR}/${stack_name}"
    local kompose_yml="${template_dir}/kompose.yml"
    
    # Check if template exists
    if [ ! -d "$template_dir" ]; then
        log_error "Template not found: $stack_name"
        log_info "Available templates:"
        list_templates
        return 1
    fi
    
    # Check if kompose.yml exists
    if [ ! -f "$kompose_yml" ]; then
        log_error "kompose.yml not found in template: $template_dir"
        return 1
    fi
    
    # Check if output directory exists
    if [ -d "$output_dir" ] && [ "$force" != "true" ]; then
        log_error "Stack already exists: $output_dir"
        echo ""
        read -p "Overwrite existing stack? [y/N]: " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Generation cancelled"
            return 0
        fi
        log_warning "Overwriting existing stack..."
    fi
    
    log_info "Generating stack from template: $stack_name"
    echo ""
    
    # Create output directory
    mkdir -p "$output_dir"
    
    # Copy all files from template
    log_info "Copying template files..."
    cp -r "${template_dir}"/* "${output_dir}/"
    
    # Generate .env from kompose.yml if it doesn't exist or is just an example
    if [ ! -f "${output_dir}/.env" ] || [ -f "${output_dir}/.env.example" ]; then
        log_info "Generating .env file from kompose.yml..."
        generate_env_from_template "$kompose_yml" > "${output_dir}/.env"
    fi
    
    # Display secrets that need to be added
    log_info "Checking required secrets..."
    display_required_secrets "$kompose_yml"
    
    echo ""
    log_success "Stack '${stack_name}' generated successfully!"
    echo ""
    log_info "Generated in: ${output_dir}"
    echo ""
    log_info "Next steps:"
    echo "  1. Review configuration: ${output_dir}/.env"
    echo "  2. Add required secrets to: secrets.env"
    echo "  3. Configure domain in: domain.env"
    echo "  4. Start stack: ./kompose.sh up ${stack_name}"
    echo ""
    
    # Show README if it exists
    if [ -f "${output_dir}/README.md" ]; then
        log_info "📖 Documentation: ${output_dir}/README.md"
        echo ""
    fi
}

# Generate .env file from kompose.yml template
generate_env_from_template() {
    local kompose_yml="$1"
    local stack_name=$(parse_kompose_yml "$kompose_yml" "name")
    local description=$(parse_kompose_yml "$kompose_yml" "description")
    local version=$(parse_kompose_yml "$kompose_yml" "version")
    
    cat << EOF
# ============================================================================
# ${stack_name} Stack Configuration
# ============================================================================
# Generated from template by kompose-generate.sh
# Template version: ${version}
# ${description}
#
# Date: $(date '+%Y-%m-%d %H:%M:%S')
# ============================================================================

EOF
    
    # Extract and output environment variables
    while IFS='|' read -r name default desc required; do
        [ -z "$name" ] && continue
        
        # Add description
        echo "# ${desc}"
        
        # Add required marker
        if [ "$required" = "yes" ]; then
            echo "# [REQUIRED]"
        fi
        
        # Add variable with default value
        echo "${name}=${default}"
        echo ""
    done < <(extract_env_vars "$kompose_yml")
    
    cat << EOF
# ============================================================================
# Notes
# ============================================================================
# - Secrets should be stored in the root secrets.env file
# - Domain configuration should be in the root domain.env file
# - Refer to README.md for detailed configuration instructions
# ============================================================================
EOF
}

# Display required secrets from kompose.yml
display_required_secrets() {
    local kompose_yml="$1"
    local stack_name=$(parse_kompose_yml "$kompose_yml" "name")
    local has_secrets=false
    
    echo ""
    echo -e "${CYAN}Required secrets for ${stack_name}:${NC}"
    echo ""
    
    while IFS='|' read -r name desc required type; do
        [ -z "$name" ] && continue
        has_secrets=true
        
        local req_badge=""
        if [ "$required" = "yes" ]; then
            req_badge="${RED}[REQUIRED]${NC}"
        else
            req_badge="${YELLOW}[OPTIONAL]${NC}"
        fi
        
        echo -e "  ${YELLOW}${name}${NC} ${req_badge}"
        echo -e "    ${desc}"
        
        # Show generation command based on type
        case "$type" in
            password)
                echo -e "    ${CYAN}Generate:${NC} openssl rand -base64 48 | tr -d '=+/' | cut -c1-32"
                ;;
            base64)
                echo -e "    ${CYAN}Generate:${NC} openssl rand -base64 32"
                ;;
            hex)
                echo -e "    ${CYAN}Generate:${NC} openssl rand -hex 32"
                ;;
            uuid)
                echo -e "    ${CYAN}Generate:${NC} uuidgen | tr '[:upper:]' '[:lower:]'"
                ;;
        esac
        echo ""
    done < <(extract_secrets "$kompose_yml")
    
    if [ "$has_secrets" = false ]; then
        echo -e "  ${GREEN}No additional secrets required${NC}"
        echo ""
    else
        echo -e "${YELLOW}⚠ Add these secrets to secrets.env before starting the stack${NC}"
        echo ""
    fi
}

# List available templates
list_templates() {
    if [ ! -d "$GENERATOR_TEMPLATES_DIR" ]; then
        log_warning "No templates directory found: $GENERATOR_TEMPLATES_DIR"
        return 0
    fi
    
    echo ""
    echo -e "${CYAN}Available templates:${NC}"
    echo ""
    
    local count=0
    for template_dir in "${GENERATOR_TEMPLATES_DIR}"/*; do
        if [ -d "$template_dir" ]; then
            local template_name=$(basename "$template_dir")
            local kompose_yml="${template_dir}/kompose.yml"
            
            count=$((count+1))
            
            echo -e "  ${YELLOW}${template_name}${NC}"
            
            if [ -f "$kompose_yml" ]; then
                local description=$(parse_kompose_yml "$kompose_yml" "description")
                local version=$(parse_kompose_yml "$kompose_yml" "version")
                
                [ -n "$description" ] && echo -e "    ${description}"
                [ -n "$version" ] && echo -e "    Version: ${version}"
            fi
            
            # Check if already generated
            if [ -d "${GENERATOR_STACKS_DIR}/${template_name}" ]; then
                echo -e "    ${GREEN}✓ Generated${NC} in +stacks/${template_name}"
            else
                echo -e "    ${CYAN}→ Not generated yet${NC}"
            fi
            
            echo ""
        fi
    done
    
    if [ $count -eq 0 ]; then
        log_warning "No templates found"
    else
        log_info "Total: $count template(s)"
    fi
    echo ""
}

# Show template details
show_template() {
    local template_name="$1"
    
    if [ -z "$template_name" ]; then
        log_error "Template name required"
        return 1
    fi
    
    local template_dir="${GENERATOR_TEMPLATES_DIR}/${template_name}"
    local kompose_yml="${template_dir}/kompose.yml"
    
    if [ ! -d "$template_dir" ]; then
        log_error "Template not found: $template_name"
        return 1
    fi
    
    echo ""
    log_info "Template: $template_name"
    echo ""
    
    if [ -f "$kompose_yml" ]; then
        local description=$(parse_kompose_yml "$kompose_yml" "description")
        local version=$(parse_kompose_yml "$kompose_yml" "version")
        
        echo -e "${CYAN}Description:${NC} ${description}"
        echo -e "${CYAN}Version:${NC} ${version}"
        echo ""
        
        # Show environment variables
        echo -e "${CYAN}Environment Variables:${NC}"
        local env_count=0
        while IFS='|' read -r name default desc required; do
            [ -z "$name" ] && continue
            env_count=$((env_count+1))
            
            local req_badge=""
            [ "$required" = "yes" ] && req_badge="${RED}[REQ]${NC}" || req_badge="${GREEN}[OPT]${NC}"
            
            echo -e "  ${YELLOW}${name}${NC} ${req_badge}"
            echo -e "    ${desc}"
            [ -n "$default" ] && echo -e "    Default: ${default}"
        done < <(extract_env_vars "$kompose_yml")
        echo -e "  Total: ${env_count} variables"
        echo ""
        
        # Show secrets
        echo -e "${CYAN}Secrets:${NC}"
        local sec_count=0
        while IFS='|' read -r name desc required type; do
            [ -z "$name" ] && continue
            sec_count=$((sec_count+1))
            
            local req_badge=""
            [ "$required" = "yes" ] && req_badge="${RED}[REQ]${NC}" || req_badge="${GREEN}[OPT]${NC}"
            
            echo -e "  ${YELLOW}${name}${NC} ${req_badge} (${type})"
            echo -e "    ${desc}"
        done < <(extract_secrets "$kompose_yml")
        echo -e "  Total: ${sec_count} secrets"
        echo ""
    fi
    
    # Show files
    echo -e "${CYAN}Template Files:${NC}"
    ls -lh "$template_dir" | tail -n +2 | awk '{printf "  %s  %s\n", $9, $5}'
    echo ""
    
    # Check generation status
    if [ -d "${GENERATOR_STACKS_DIR}/${template_name}" ]; then
        echo -e "${GREEN}✓ Stack generated${NC} in: ${GENERATOR_STACKS_DIR}/${template_name}"
    else
        echo -e "${CYAN}→ Not generated${NC}"
        echo ""
        log_info "Generate with: ./kompose.sh generate ${template_name}"
    fi
    echo ""
}

# ============================================================================
# CUSTOM STACK GENERATION (Original functionality)
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

# Generate .env template for custom stack
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

# Generate README template for custom stack
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

# Generate a new custom stack (original functionality)
generate_custom_stack() {
    local stack_name=$1
    
    # Validate stack name
    if [ -z "$stack_name" ]; then
        log_error "Stack name is required"
        echo ""
        echo "Usage: kompose generate custom <stack-name>"
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
    log_success "Custom stack '${stack_name}' generated successfully!"
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
}

# ============================================================================
# LISTING FUNCTIONS
# ============================================================================

# List generated custom stacks
list_custom_stacks() {
    echo ""
    log_info "Custom stacks:"
    echo ""
    
    if [ ! -d "$GENERATOR_CUSTOM_DIR" ]; then
        log_warning "No custom stacks directory found"
        echo ""
        log_info "Generate your first custom stack:"
        echo "  ./kompose.sh generate custom myapp"
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
        echo "  ./kompose.sh generate custom myapp"
        echo ""
    else
        log_info "Total: $count custom stack(s)"
        echo ""
    fi
}

# List all generated stacks (from templates)
list_generated_stacks() {
    echo ""
    log_info "Generated stacks (from templates):"
    echo ""
    
    if [ ! -d "$GENERATOR_STACKS_DIR" ]; then
        log_warning "No +stacks directory found"
        echo ""
        return 0
    fi
    
    local count=0
    for dir in "${GENERATOR_STACKS_DIR}"/*; do
        if [ -d "$dir" ] && [ -f "${dir}/compose.yaml" ]; then
            local stack_name=$(basename "$dir")
            count=$((count+1))
            
            echo -e "  ${YELLOW}${stack_name}${NC}"
            
            # Show if running
            cd "$dir"
            if docker compose ps -q 2>/dev/null | grep -q .; then
                local running=$(docker compose ps -q 2>/dev/null | wc -l)
                echo -e "    Status: ${GREEN}${running} containers running${NC}"
            else
                echo -e "    Status: ${YELLOW}stopped${NC}"
            fi
            
            echo "    Location: ${dir}"
            
            # Show kompose.yml if exists
            if [ -f "${dir}/kompose.yml" ]; then
                local version=$(parse_kompose_yml "${dir}/kompose.yml" "version")
                [ -n "$version" ] && echo "    Template version: ${version}"
            fi
            
            echo ""
        fi
    done
    
    if [ $count -eq 0 ]; then
        log_info "No generated stacks found"
        echo ""
        log_info "Generate from template:"
        echo "  ./kompose.sh generate <template-name>"
        echo ""
        log_info "Available templates:"
        list_templates
    else
        log_info "Total: $count generated stack(s)"
        echo ""
    fi
}

# ============================================================================
# DELETE FUNCTIONS
# ============================================================================

# Delete a custom stack
delete_custom_stack() {
    local stack_name=$1
    
    if [ -z "$stack_name" ]; then
        log_error "Stack name is required"
        echo ""
        echo "Usage: kompose generate delete custom <stack-name>"
        return 1
    fi
    
    local stack_dir="${GENERATOR_CUSTOM_DIR}/${stack_name}"
    local docs_file="${GENERATOR_DOCS_DIR}/${stack_name}.md"
    local test_file="${GENERATOR_TESTS_DIR}/test-${stack_name}.sh"
    
    if [ ! -d "$stack_dir" ]; then
        log_error "Custom stack not found: $stack_name"
        return 1
    fi
    
    echo ""
    log_warning "This will delete the following:"
    echo "  - Stack directory: $stack_dir"
    [ -f "$docs_file" ] && echo "  - Documentation: $docs_file"
    [ -f "$test_file" ] && echo "  - Test file: $test_file"
    echo ""
    
    read -p "Are you sure you want to delete custom stack '${stack_name}'? [y/N]: " -n 1 -r
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
    
    log_success "Custom stack '${stack_name}' deleted successfully"
    echo ""
}

# Delete a generated stack
delete_generated_stack() {
    local stack_name=$1
    
    if [ -z "$stack_name" ]; then
        log_error "Stack name is required"
        echo ""
        echo "Usage: kompose generate delete <stack-name>"
        return 1
    fi
    
    local stack_dir="${GENERATOR_STACKS_DIR}/${stack_name}"
    
    if [ ! -d "$stack_dir" ]; then
        log_error "Generated stack not found: $stack_name"
        return 1
    fi
    
    echo ""
    log_warning "This will delete the generated stack:"
    echo "  - Stack directory: $stack_dir"
    echo ""
    log_info "Note: The template in _templates/${stack_name} will NOT be deleted"
    echo ""
    
    read -p "Are you sure you want to delete '${stack_name}'? [y/N]: " -n 1 -r
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
    
    # Delete directory
    log_info "Deleting stack..."
    rm -rf "$stack_dir"
    
    log_success "Generated stack '${stack_name}' deleted successfully"
    log_info "Regenerate with: ./kompose.sh generate ${stack_name}"
    echo ""
}

# ============================================================================
# COMMAND HANDLER
# ============================================================================

# Handle generate subcommands
handle_generate_command() {
    if [ $# -eq 0 ]; then
        cat << EOF

${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}
${CYAN}║                KOMPOSE - Stack Generator                       ║${NC}
${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}

${BLUE}TEMPLATE-BASED GENERATION:${NC}
  <template-name>      Generate stack from template (_templates → +stacks)
  templates            List available templates
  show <template>      Show template details
  list                 List generated stacks (from templates)
  delete <stack>       Delete a generated stack

${BLUE}CUSTOM STACK GENERATION:${NC}
  custom <name>        Generate custom stack from scratch (→ +custom)
  custom list          List custom stacks
  custom delete <n> Delete custom stack

${BLUE}EXAMPLES:${NC}
  ${GREEN}# Generate auth stack from template${NC}
  kompose generate auth

  ${GREEN}# List available templates${NC}
  kompose generate templates

  ${GREEN}# Show template details${NC}
  kompose generate show auth

  ${GREEN}# List all generated stacks${NC}
  kompose generate list

  ${GREEN}# Create custom stack from scratch${NC}
  kompose generate custom myapp

  ${GREEN}# List custom stacks${NC}
  kompose generate custom list

${BLUE}WORKFLOW:${NC}
  1. Templates live in: ${CYAN}_templates/${NC}
  2. Generated stacks → ${CYAN}+stacks/${NC}
  3. Custom stacks    → ${CYAN}+custom/${NC}

EOF
        return 0
    fi
    
    local subcmd=$1
    shift
    
    case $subcmd in
        templates)
            list_templates
            ;;
        list)
            list_generated_stacks
            ;;
        show)
            show_template "$@"
            ;;
        delete|remove|rm)
            delete_generated_stack "$@"
            ;;
        custom)
            local custom_cmd="${1:-list}"
            shift || true
            
            case "$custom_cmd" in
                list)
                    list_custom_stacks
                    ;;
                delete|remove|rm)
                    delete_custom_stack "$@"
                    ;;
                *)
                    # Generate custom stack
                    generate_custom_stack "$custom_cmd" "$@"
                    ;;
            esac
            ;;
        help|--help|-h)
            handle_generate_command
            ;;
        *)
            # Check if it's a template name
            if [ -d "${GENERATOR_TEMPLATES_DIR}/${subcmd}" ]; then
                generate_from_template "$subcmd" "$@"
            else
                log_error "Unknown template or command: $subcmd"
                echo ""
                log_info "Available templates:"
                list_templates
                echo ""
                log_info "Use 'kompose generate help' for more information"
                return 1
            fi
            ;;
    esac
}
