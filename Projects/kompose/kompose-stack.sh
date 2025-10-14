#!/bin/bash

# kompose-stack.sh - Stack Management Functions
# Part of kompose.sh - Docker Compose Stack Manager

# ============================================================================
# STACK MANAGEMENT FUNCTIONS
# ============================================================================

stack_exists() {
    local stack=$1
    local stack_dir="${STACKS_ROOT}/${stack}"
    
    # Check built-in stack location
    if [ -d "$stack_dir" ] && [ -f "${stack_dir}/${COMPOSE_FILE}" ]; then
        return 0
    fi
    
    # Check custom stack location
    local custom_stack_dir="${STACKS_ROOT}/+custom/${stack}"
    if [ -d "$custom_stack_dir" ] && [ -f "${custom_stack_dir}/${COMPOSE_FILE}" ]; then
        return 0
    fi
    
    log_error "Stack not found: $stack"
    log_info "Searched locations:"
    log_info "  - ${stack_dir}"
    log_info "  - ${custom_stack_dir}"
    return 1
}

get_all_stacks() {
    local stacks=()
    
    # Get built-in stacks
    for dir in "${STACKS_ROOT}"/*; do
        if [ -d "$dir" ] && [ -f "${dir}/${COMPOSE_FILE}" ]; then
            # Skip special directories
            local dirname=$(basename "$dir")
            if [[ ! "$dirname" =~ ^\+|^_|^backups|^INTEGRATION|^stack-template ]]; then
                stacks+=($(basename "$dir"))
            fi
        fi
    done
    
    # Get custom stacks from +custom directory
    local custom_dir="${STACKS_ROOT}/+custom"
    if [ -d "$custom_dir" ]; then
        for dir in "${custom_dir}"/*; do
            if [ -d "$dir" ] && [ -f "${dir}/${COMPOSE_FILE}" ]; then
                local dirname=$(basename "$dir")
                # Skip README and other non-stack files
                if [ "$dirname" != "README.md" ] && [ "$dirname" != ".gitkeep" ]; then
                    stacks+=("$dirname")
                fi
            fi
        done
    fi
    
    echo "${stacks[@]}"
}

# Helper function to run docker compose with proper environment
# All environment variables are loaded from root .env files and exported to shell
# Docker Compose automatically uses exported environment variables
run_compose() {
    local stack=$1
    shift
    
    # Check if required configuration files exist
    if [ ! -f "${STACKS_ROOT}/.env" ]; then
        log_error "Configuration file not found: .env"
        echo ""
        log_info "You need to set up your environment first. Choose one:"
        echo ""
        echo -e "  ${CYAN}Option 1: Run the init wizard (recommended)${NC}"
        echo -e "    ./kompose.sh init"
        echo ""
        echo -e "  ${CYAN}Option 2: Copy local development template${NC}"
        echo -e "    cp .env.local .env"
        echo -e "    cp domain.env.local domain.env"
        echo ""
        echo -e "  ${CYAN}Option 3: Use setup command${NC}"
        echo -e "    ./kompose.sh setup local    # For local development"
        echo -e "    ./kompose.sh setup prod     # For production"
        echo ""
        return 1
    fi
    
    # Determine stack directory (check built-in first, then custom)
    local stack_dir="${STACKS_ROOT}/${stack}"
    if [ ! -d "$stack_dir" ] || [ ! -f "${stack_dir}/${COMPOSE_FILE}" ]; then
        stack_dir="${STACKS_ROOT}/+custom/${stack}"
    fi
    
    # Export environment for this stack
    # This loads variables from root .env, domain.env, and secrets.env
    # and exports them to the shell environment
    export_stack_env "$stack"
    
    # Change to stack directory
    cd "${stack_dir}"
    
    # Run docker compose
    # Docker Compose will automatically use environment variables from the shell
    docker compose "$@"
}

stack_up() {
    local stack=$1
    local detach=${2:-true}
    
    log_stack "$stack" "Starting..."
    
    if [ "$detach" = true ]; then
        run_compose "$stack" up -d
    else
        run_compose "$stack" up
    fi
    
    log_success "Stack '$stack' started"
}

stack_down() {
    local stack=$1
    local remove_volumes=${2:-false}
    
    log_stack "$stack" "Stopping..."
    
    if [ "$remove_volumes" = true ]; then
        run_compose "$stack" down -v
        log_warning "Stack '$stack' stopped and volumes removed"
    else
        run_compose "$stack" down
        log_success "Stack '$stack' stopped"
    fi
}

stack_restart() {
    local stack=$1
    
    log_stack "$stack" "Restarting..."
    
    run_compose "$stack" restart
    
    log_success "Stack '$stack' restarted"
}

stack_status() {
    local stack=$1
    
    echo ""
    log_stack "$stack" "Status:"
    run_compose "$stack" ps
    echo ""
}

stack_logs() {
    local stack=$1
    shift
    
    log_stack "$stack" "Logs:"
    
    run_compose "$stack" logs "$@"
}

stack_pull() {
    local stack=$1
    
    log_stack "$stack" "Pulling latest images..."
    
    run_compose "$stack" pull
    
    log_success "Images pulled for stack '$stack'"
}

stack_build() {
    local stack=$1
    local no_cache=${2:-false}
    
    log_stack "$stack" "Building images..."
    
    if [ "$no_cache" = true ]; then
        run_compose "$stack" build --no-cache
    else
        run_compose "$stack" build
    fi
    
    log_success "Images built for stack '$stack'"
}

stack_deploy() {
    local stack=$1
    local version=$2
    
    log_stack "$stack" "Deploying version $version..."
    
    export VERSION=$version
    export IMAGE_TAG=$version
    
    run_compose "$stack" pull
    run_compose "$stack" up -d
    
    log_success "Stack '$stack' deployed with version $version"
}

stack_validate() {
    local stack=$1
    
    log_stack "$stack" "Validating configuration..."
    
    # Validate environment
    validate_stack_env "$stack"
    
    # Validate compose file
    if run_compose "$stack" config > /dev/null 2>&1; then
        log_success "Configuration for stack '$stack' is valid"
    else
        log_error "Configuration for stack '$stack' is invalid"
        run_compose "$stack" config
        return 1
    fi
}

stack_exec() {
    local stack=$1
    shift
    
    run_compose "$stack" exec "$@"
}

list_stacks() {
    echo ""
    log_info "Available stacks:"
    echo ""
    
    # List built-in stacks
    echo -e "${BLUE}Built-in Stacks:${NC}"
    for stack in $(echo "${!STACKS[@]}" | tr ' ' '\n' | sort); do
        if stack_exists "$stack" 2>/dev/null; then
            echo -e "  ${CYAN}${stack}${NC} - ${STACKS[$stack]}"
            
            # Get stack directory
            local stack_dir="${STACKS_ROOT}/${stack}"
            
            export_stack_env "$stack" > /dev/null 2>&1
            cd "${stack_dir}"
            local running=$(docker compose ps -q 2>/dev/null | wc -l)
            local total=$(docker compose config --services 2>/dev/null | wc -l)
            echo -e "    Status: ${running}/${total} containers running"
            echo ""
        fi
    done
    
    # List custom stacks if any exist
    if [ ${#CUSTOM_STACKS[@]} -gt 0 ]; then
        echo -e "${MAGENTA}Custom Stacks:${NC}"
        for stack in $(echo "${!CUSTOM_STACKS[@]}" | tr ' ' '\n' | sort); do
            if stack_exists "$stack" 2>/dev/null; then
                echo -e "  ${CYAN}${stack}${NC} - ${CUSTOM_STACKS[$stack]}"
                
                # Get custom stack directory
                local stack_dir="${STACKS_ROOT}/+custom/${stack}"
                
                export_stack_env "$stack" > /dev/null 2>&1
                cd "${stack_dir}"
                local running=$(docker compose ps -q 2>/dev/null | wc -l)
                local total=$(docker compose config --services 2>/dev/null | wc -l)
                echo -e "    Status: ${running}/${total} containers running"
                echo ""
            fi
        done
    fi
}

show_all_containers() {
    echo ""
    log_info "All running containers:"
    echo ""
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    echo ""
}

# Get ordered list of stacks for startup/shutdown
# This ensures proper dependency order
get_ordered_stacks() {
    local order_type="${1:-startup}"
    local ordered_stacks=()
    
    if [ "$order_type" = "startup" ]; then
        # Startup order: dependencies first, custom stacks after built-in, docs last
        local startup_order=(
            "core"        # Database, Redis, MQTT - foundational services
            "chain"       # Automation platform - may be used by other services
            "watch"       # Monitoring - should start early to capture metrics
            "messaging"   # Communication services
            "code"        # Git repository and CI/CD
            "home"        # Smart home platform
            "kmps"        # Management portal
            "track"       # Analytics tracking
            "vault"       # Password manager
            "link"        # Link management
            "proxy"       # Reverse proxy - should be available for all services
            "vpn"         # VPN access
            "auth"        # Authentication - after proxy for proper routing
            "news"        # Newsletter service
        )
        
        # Add built-in stacks in specified order if they exist
        for stack in "${startup_order[@]}"; do
            if stack_exists "$stack" 2>/dev/null; then
                ordered_stacks+=("$stack")
            fi
        done
        
        # Add any other built-in stacks not in the explicit order
        for stack in "${!STACKS[@]}"; do
            if ! [[ " ${startup_order[*]} " =~ " ${stack} " ]]; then
                if stack_exists "$stack" 2>/dev/null; then
                    ordered_stacks+=("$stack")
                fi
            fi
        done
        
        # Add custom stacks (sorted alphabetically)
        for stack in $(echo "${!CUSTOM_STACKS[@]}" | tr ' ' '\n' | sort); do
            if stack_exists "$stack" 2>/dev/null; then
                ordered_stacks+=("$stack")
            fi
        done
        
        # Add _docs stack last if it exists
        if [ -d "${STACKS_ROOT}/_docs" ] && [ -f "${STACKS_ROOT}/_docs/${COMPOSE_FILE}" ]; then
            ordered_stacks+=("_docs")
        fi
    else
        # Shutdown order: reverse of startup order
        local shutdown_stacks=($(get_ordered_stacks "startup"))
        for ((i=${#shutdown_stacks[@]}-1; i>=0; i--)); do
            ordered_stacks+=("${shutdown_stacks[i]}")
        done
    fi
    
    echo "${ordered_stacks[@]}"
}

process_all_stacks() {
    local command=$1
    shift
    
    # Get appropriately ordered stack list
    local stacks
    if [ "$command" = "up" ] || [ "$command" = "restart" ]; then
        stacks=$(get_ordered_stacks "startup")
    elif [ "$command" = "down" ]; then
        stacks=$(get_ordered_stacks "shutdown")
    else
        # For status, pull, validate - use startup order
        stacks=$(get_ordered_stacks "startup")
    fi
    
    for stack in $stacks; do
        if stack_exists "$stack" 2>/dev/null; then
            case $command in
                up)
                    stack_up "$stack" true "$@"
                    ;;
                down)
                    stack_down "$stack" false "$@"
                    ;;
                restart)
                    stack_restart "$stack" "$@"
                    ;;
                status)
                    stack_status "$stack" "$@"
                    ;;
                pull)
                    stack_pull "$stack" "$@"
                    ;;
                validate)
                    stack_validate "$stack" "$@"
                    ;;
            esac
        fi
    done
}

# Show environment configuration for a stack
stack_env() {
    local stack=$1
    
    if ! stack_exists "$stack"; then
        return 1
    fi
    
    show_stack_env "$stack"
}
