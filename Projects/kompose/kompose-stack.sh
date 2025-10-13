#!/bin/bash

# kompose-stack.sh - Stack Management Functions
# Part of kompose.sh - Docker Compose Stack Manager

# ============================================================================
# STACK MANAGEMENT FUNCTIONS
# ============================================================================

stack_exists() {
    local stack=$1
    local stack_dir="${STACKS_ROOT}/${stack}"
    
    if [ ! -d "$stack_dir" ]; then
        log_error "Stack directory not found: $stack_dir"
        return 1
    fi
    
    if [ ! -f "${stack_dir}/${COMPOSE_FILE}" ]; then
        log_error "Compose file not found: ${stack_dir}/${COMPOSE_FILE}"
        return 1
    fi
    
    return 0
}

get_all_stacks() {
    local stacks=()
    for dir in "${STACKS_ROOT}"/*; do
        if [ -d "$dir" ] && [ -f "${dir}/${COMPOSE_FILE}" ]; then
            # Skip special directories
            local dirname=$(basename "$dir")
            if [[ ! "$dirname" =~ ^\+|^_|^backups|^INTEGRATION|^stack-template ]]; then
                stacks+=($(basename "$dir"))
            fi
        fi
    done
    echo "${stacks[@]}"
}

# Helper function to run docker compose with proper environment
run_compose() {
    local stack=$1
    shift
    
    # Export environment for this stack
    export_stack_env "$stack"
    
    # Change to stack directory
    cd "${STACKS_ROOT}/${stack}"
    
    # Run docker compose with the generated env file
    if [ -f ".env.generated" ]; then
        docker compose --env-file .env.generated "$@"
    else
        log_error "Failed to generate environment file for stack: $stack"
        return 1
    fi
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
    
    for stack in $(get_all_stacks | tr ' ' '\n' | sort); do
        if [ -v "STACKS[$stack]" ]; then
            echo -e "  ${CYAN}${stack}${NC} - ${STACKS[$stack]}"
        else
            echo -e "  ${CYAN}${stack}${NC}"
        fi
        
        if stack_exists "$stack" 2>/dev/null; then
            export_stack_env "$stack" > /dev/null 2>&1
            cd "${STACKS_ROOT}/${stack}"
            local running=$(docker compose --env-file .env.generated ps -q 2>/dev/null | wc -l)
            local total=$(docker compose --env-file .env.generated config --services 2>/dev/null | wc -l)
            echo -e "    Status: ${running}/${total} containers running"
        fi
        echo ""
    done
}

show_all_containers() {
    echo ""
    log_info "All running containers:"
    echo ""
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    echo ""
}

process_all_stacks() {
    local command=$1
    shift
    
    local stacks=$(get_all_stacks)
    
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

# Generate .env file for a stack (for debugging/inspection)
stack_generate_env() {
    local stack=$1
    
    if ! stack_exists "$stack"; then
        return 1
    fi
    
    generate_stack_env_file "$stack"
    log_success "Generated .env file for stack '$stack'"
    log_info "Location: ${STACKS_ROOT}/${stack}/.env.generated"
}
