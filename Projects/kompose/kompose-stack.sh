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

stack_up() {
    local stack=$1
    local detach=${2:-true}
    
    log_stack "$stack" "Starting..."
    
    cd "${STACKS_ROOT}/${stack}"
    
    if [ "$detach" = true ]; then
        docker-compose up -d
    else
        docker-compose up
    fi
    
    log_success "Stack '$stack' started"
}

stack_down() {
    local stack=$1
    local remove_volumes=${2:-false}
    
    log_stack "$stack" "Stopping..."
    
    cd "${STACKS_ROOT}/${stack}"
    
    if [ "$remove_volumes" = true ]; then
        docker-compose down -v
        log_warning "Stack '$stack' stopped and volumes removed"
    else
        docker-compose down
        log_success "Stack '$stack' stopped"
    fi
}

stack_restart() {
    local stack=$1
    
    log_stack "$stack" "Restarting..."
    
    cd "${STACKS_ROOT}/${stack}"
    docker-compose restart
    
    log_success "Stack '$stack' restarted"
}

stack_status() {
    local stack=$1
    
    cd "${STACKS_ROOT}/${stack}"
    
    echo ""
    log_stack "$stack" "Status:"
    docker-compose ps
    echo ""
}

stack_logs() {
    local stack=$1
    shift
    
    log_stack "$stack" "Logs:"
    
    cd "${STACKS_ROOT}/${stack}"
    docker-compose logs "$@"
}

stack_pull() {
    local stack=$1
    
    log_stack "$stack" "Pulling latest images..."
    
    cd "${STACKS_ROOT}/${stack}"
    docker-compose pull
    
    log_success "Images pulled for stack '$stack'"
}

stack_build() {
    local stack=$1
    local no_cache=${2:-false}
    
    log_stack "$stack" "Building images..."
    
    cd "${STACKS_ROOT}/${stack}"
    
    if [ "$no_cache" = true ]; then
        docker-compose build --no-cache
    else
        docker-compose build
    fi
    
    log_success "Images built for stack '$stack'"
}

stack_deploy() {
    local stack=$1
    local version=$2
    
    log_stack "$stack" "Deploying version $version..."
    
    cd "${STACKS_ROOT}/${stack}"
    
    export VERSION=$version
    export IMAGE_TAG=$version
    
    docker-compose pull
    docker-compose up -d
    
    log_success "Stack '$stack' deployed with version $version"
}

stack_validate() {
    local stack=$1
    
    log_stack "$stack" "Validating compose file..."
    
    cd "${STACKS_ROOT}/${stack}"
    
    if docker-compose config > /dev/null 2>&1; then
        log_success "Compose file for stack '$stack' is valid"
    else
        log_error "Compose file for stack '$stack' is invalid"
        docker-compose config
        return 1
    fi
}

stack_exec() {
    local stack=$1
    shift
    
    cd "${STACKS_ROOT}/${stack}"
    docker-compose exec "$@"
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
            cd "${STACKS_ROOT}/${stack}"
            local running=$(docker-compose ps -q 2>/dev/null | wc -l)
            local total=$(docker-compose config --services 2>/dev/null | wc -l)
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
