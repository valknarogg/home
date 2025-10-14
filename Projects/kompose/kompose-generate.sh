#!/bin/bash

# kompose-generate.sh - Stack Generator Functions
# Part of kompose.sh - Docker Compose Stack Manager
#
# This module handles generation of stacks from templates

# ============================================================================
# GENERATOR CONFIGURATION
# ============================================================================

GENERATOR_TEMPLATES_DIR="${STACKS_ROOT}/_templates"
GENERATOR_STACKS_DIR="${STACKS_ROOT}/+stacks"

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
# LISTING FUNCTIONS
# ============================================================================

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

${BLUE}COMMANDS:${NC}
  <template-name>      Generate stack from template (_templates → +stacks)
  templates            List available templates
  show <template>      Show template details
  list                 List generated stacks
  delete <stack>       Delete a generated stack

${BLUE}EXAMPLES:${NC}
  ${GREEN}# Generate auth stack from template${NC}
  kompose generate auth

  ${GREEN}# List available templates${NC}
  kompose generate templates

  ${GREEN}# Show template details${NC}
  kompose generate show auth

  ${GREEN}# List all generated stacks${NC}
  kompose generate list

  ${GREEN}# Delete generated stack (template preserved)${NC}
  kompose generate delete auth

${BLUE}WORKFLOW:${NC}
  1. Templates live in: ${CYAN}_templates/${NC}
  2. Generated stacks → ${CYAN}+stacks/${NC}
  3. Templates are version controlled
  4. Generated stacks are environment-specific

${BLUE}CREATING NEW TEMPLATES:${NC}
  1. Create directory: ${CYAN}_templates/mystack/${NC}
  2. Add ${CYAN}kompose.yml${NC} with configuration
  3. Add ${CYAN}compose.yaml${NC} with Docker Compose config
  4. Add ${CYAN}README.md${NC} with documentation
  5. Commit to version control

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
