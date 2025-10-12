#!/bin/bash

# kompose.sh - Docker Compose Stack Manager with Integrated Deployment Tags
# Manages multiple docker-compose stacks in subdirectories with Git-based deployments

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# Configuration
STACKS_ROOT="${STACKS_ROOT:-$(pwd)}"
COMPOSE_FILE="${COMPOSE_FILE:-compose.yaml}"
REPO_URL="${REPO_URL:-$(git config --get remote.origin.url 2>/dev/null || echo '')}"
GITEA_URL="${GITEA_URL:-http://localhost:3001}"
N8N_WEBHOOK_BASE="${N8N_WEBHOOK_BASE:-http://localhost:5678/webhook}"

# API Server Configuration
API_PORT="${API_PORT:-8080}"
API_HOST="${API_HOST:-127.0.0.1}"
API_PIDFILE="${API_PIDFILE:-/tmp/kompose-api.pid}"
API_LOGFILE="${API_LOGFILE:-/tmp/kompose-api.log}"
API_SERVER_SCRIPT="$(dirname "$0")/kompose-api-server.sh"

# Available stacks
declare -A STACKS=(
    ["core"]="Core services - MQTT, Redis, Postgres"
    ["auth"]="Authentication - Keycloak SSO, OAuth2 Proxy"
    ["kmps"]="Management Portal - User & SSO Administration"
    ["home"]="Smart Home - Home Assistant, Matter, Zigbee, ESPHome"
    ["vpn"]="VPN - WireGuard remote access (wg-easy)"
    ["chat"]="Communication - Gotify notifications"
    ["chain"]="Automation Platform - n8n workflows, Semaphore/Ansible tasks"
    ["vault"]="Password Manager - Vaultwarden"
    ["registry"]="Container registry"
    ["monitoring"]="Metrics - Prometheus, Grafana"
    ["frontend"]="Frontend application"
    ["backend"]="Backend application"
    ["api"]="API service"
    ["worker"]="Background workers"
)

# Service definitions for tagging
declare -A TAG_SERVICES=(
    ["frontend"]="frontend-v"
    ["backend"]="backend-v"
    ["api"]="api-v"
    ["worker"]="worker-v"
)

# Environment stages
declare -A ENVIRONMENTS=(
    ["dev"]="development"
    ["staging"]="staging"
    ["prod"]="production"
)

# Database configuration
POSTGRES_CONTAINER="core-postgres"
BACKUP_DIR="${BACKUP_DIR:-./backups/database}"
DB_USER="${POSTGRES_USER:-kompose}"
DB_PASS="${POSTGRES_PASSWORD:-postgres_password}"

# Available databases
declare -A DATABASES=(
    ["kompose"]="Main application database"
    ["n8n"]="n8n workflow database"
    ["semaphore"]="Semaphore Ansible automation database"
    ["gitea"]="Gitea git database"
)

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_stack() {
    echo -e "${CYAN}[STACK: $1]${NC} $2"
}

log_tag() {
    echo -e "${MAGENTA}[TAG]${NC} $1"
}

log_db() {
    echo -e "${YELLOW}[DB]${NC} $1"
}

log_api() {
    echo -e "${MAGENTA}[API]${NC} $1"
}

usage() {
    cat << EOF
${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}
${CYAN}║              KOMPOSE - Docker Compose Stack Manager            ║${NC}
${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}

${BLUE}STACK MANAGEMENT COMMANDS:${NC}
    up [STACK]           Start a stack (or all if no stack specified)
    down [STACK]         Stop a stack (or all if no stack specified)
    restart [STACK]      Restart a stack
    status [STACK]       Show status of stack(s)
    logs [STACK]         Show logs for a stack
    pull [STACK]         Pull latest images for a stack
    build [STACK]        Build images for a stack
    deploy [STACK] [VER] Deploy specific version (pull + up)
    list                 List all available stacks
    validate [STACK]     Validate compose file(s)
    exec [STACK] [CMD]   Execute command in stack container
    ps                   Show all running containers

${MAGENTA}REST API SERVER COMMANDS:${NC}
    api start            Start REST API server (default: http://127.0.0.1:8080)
    api stop             Stop REST API server
    api status           Check API server status
    api logs             View API server logs

${MAGENTA}GIT TAG DEPLOYMENT COMMANDS:${NC}
    tag create           Create and push a new deployment tag
    tag move             Move an existing tag to a new commit
    tag delete           Delete a tag (local and remote)
    tag list             List all deployment tags
    tag deploy           Create tag and trigger deployment
    tag rollback         Rollback to a previous tag
    tag status           Show deployment status

${YELLOW}DATABASE COMMANDS:${NC}
    db backup            Create database backup
    db restore           Restore database from backup
    db list              List available backups
    db status            Show database status
    db exec              Execute SQL command
    db shell             Open database shell
    db migrate           Run database migrations
    db reset             Reset database (WARNING: deletes all data)

${BLUE}STACK OPTIONS:${NC}
    -d, --detach        Run in detached mode
    -f, --force         Force operation (remove volumes, etc.)
    --no-cache          Build without cache
    --scale SERVICE=N   Scale service to N replicas
    -v, --verbose       Verbose output

${MAGENTA}TAG OPTIONS:${NC}
    -s, --service SERVICE       Service name (frontend|backend|api|worker)
    -e, --env ENV              Environment (dev|staging|prod)
    -v, --version VERSION      Version number (e.g., 1.2.3)
    -c, --commit COMMIT        Git commit hash (default: HEAD)
    -m, --message MESSAGE      Tag message
    -f, --force               Force operation
    -d, --dry-run             Show what would be done

${YELLOW}DATABASE OPTIONS:${NC}
    -d, --database NAME         Database name (default: all)
    -f, --file FILE            Backup file path
    -t, --timestamp            Add timestamp to backup
    --compress                 Compress backup with gzip

${BLUE}AVAILABLE STACKS:${NC}
$(for stack in "${!STACKS[@]}"; do
    printf "    ${CYAN}%-15s${NC} - %s\n" "$stack" "${STACKS[$stack]}"
done | sort)

${BLUE}EXAMPLES:${NC}
    ${GREEN}# Stack Management${NC}
    kompose up home                    # Start home stack
    kompose up                          # Start all stacks
    kompose down frontend              # Stop frontend stack
    kompose logs chain -f              # Follow logs for chain stack
    kompose deploy backend 1.2.3       # Deploy backend version 1.2.3
    kompose restart api                # Restart api stack
    kompose status                     # Show status of all stacks
    kompose exec chain n8n --version   # Execute command in chain

    ${MAGENTA}# Git Tag Deployments${NC}
    kompose tag create -s frontend -e dev -v 1.2.3
    kompose tag deploy -s backend -e staging -v 2.0.0
    kompose tag rollback -s api -e prod -v 1.0.5
    kompose tag list -s frontend
    kompose tag status frontend 1.2.3 dev

    ${YELLOW}# Database Management${NC}
    kompose db backup -d postgres      # Backup PostgreSQL
    kompose db backup --compress       # Backup all with compression
    kompose db restore -f backup.sql   # Restore from file
    kompose db list                    # List backups
    kompose db shell -d gitea          # Open gitea database shell
    kompose db status                  # Show database status

    ${MAGENTA}# REST API Server${NC}
    kompose api start                  # Start API server on default port
    kompose api start 9000             # Start API server on custom port
    kompose api status                 # Check API server status
    kompose api logs                   # View API server logs
    kompose api stop                   # Stop API server

EOF
    exit 1
}

# ============================================================================
# JSON OUTPUT FORMATTING FUNCTIONS
# ============================================================================

json_escape() {
    local str="$1"
    str="${str//\\/\\\\}"
    str="${str//\"/\\\"}"
    str="${str//

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
            stacks+=($(basename "$dir"))
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
    
    if [ "$JSON_OUTPUT" = "true" ]; then
        echo "HTTP/1.1 200 OK"
        echo "Content-Type: application/json"
        echo ""
        json_stack_status "$stack"
        return 0
    fi
    
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
    if [ "$JSON_OUTPUT" = "true" ]; then
        echo "HTTP/1.1 200 OK"
        echo "Content-Type: application/json"
        echo ""
        local stacks_json=$(json_list_stacks)
        json_success "Stacks retrieved" "$stacks_json"
        return 0
    fi
    
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

# ============================================================================
# GIT TAG DEPLOYMENT FUNCTIONS
# ============================================================================

validate_tag_inputs() {
    if [[ -n "$TAG_SERVICE" && ! -v "TAG_SERVICES[$TAG_SERVICE]" ]]; then
        log_error "Invalid service: $TAG_SERVICE"
        log_info "Available services: ${!TAG_SERVICES[@]}"
        exit 1
    fi

    if [[ -n "$TAG_ENV" && ! -v "ENVIRONMENTS[$TAG_ENV]" ]]; then
        log_error "Invalid environment: $TAG_ENV"
        log_info "Available environments: ${!ENVIRONMENTS[@]}"
        exit 1
    fi

    if [[ -n "$TAG_VERSION" && ! "$TAG_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9]+)?$ ]]; then
        log_error "Invalid version format: $TAG_VERSION (expected: X.Y.Z)"
        exit 1
    fi
}

generate_tag_name() {
    local service=$1
    local env=$2
    local version=$3
    
    echo "${TAG_SERVICES[$service]}${version}-${env}"
}

tag_create() {
    local service=$1
    local env=$2
    local version=$3
    local commit=${4:-HEAD}
    local message=${5:-"Deploy $service v$version to $env"}
    
    local tag_name=$(generate_tag_name "$service" "$env" "$version")
    
    log_tag "Creating tag: $tag_name at commit $commit"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_warning "DRY RUN: Would create tag $tag_name"
        return 0
    fi
    
    if git rev-parse "$tag_name" >/dev/null 2>&1; then
        if [[ "$FORCE" == "true" ]]; then
            log_warning "Tag $tag_name already exists. Deleting..."
            git tag -d "$tag_name"
        else
            log_error "Tag $tag_name already exists. Use -f to force."
            exit 1
        fi
    fi
    
    git tag -a "$tag_name" "$commit" -m "$message"
    log_success "Tag created: $tag_name"
}

tag_push() {
    local tag_name=$1
    
    log_tag "Pushing tag: $tag_name to remote"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_warning "DRY RUN: Would push tag $tag_name"
        return 0
    fi
    
    if [[ "$FORCE" == "true" ]]; then
        git push origin "$tag_name" --force
    else
        git push origin "$tag_name"
    fi
    
    log_success "Tag pushed: $tag_name"
}

tag_delete() {
    local service=$1
    local env=$2
    local version=$3
    
    local tag_name=$(generate_tag_name "$service" "$env" "$version")
    
    log_warning "Deleting tag: $tag_name"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_warning "DRY RUN: Would delete tag $tag_name"
        return 0
    fi
    
    if [[ "$env" == "prod" && "$FORCE" != "true" ]]; then
        read -p "Are you sure you want to delete production tag $tag_name? (yes/no): " confirm
        if [[ "$confirm" != "yes" ]]; then
            log_info "Deletion cancelled"
            exit 0
        fi
    fi
    
    git tag -d "$tag_name" 2>/dev/null || log_warning "Local tag not found"
    git push origin ":refs/tags/$tag_name" 2>/dev/null || log_warning "Remote tag not found"
    
    log_success "Tag deleted: $tag_name"
}

tag_move() {
    local service=$1
    local env=$2
    local version=$3
    local new_commit=$4
    
    local tag_name=$(generate_tag_name "$service" "$env" "$version")
    
    log_tag "Moving tag $tag_name to commit $new_commit"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_warning "DRY RUN: Would move tag $tag_name to $new_commit"
        return 0
    fi
    
    git tag -d "$tag_name" 2>/dev/null || true
    git push origin ":refs/tags/$tag_name" 2>/dev/null || true
    
    tag_create "$service" "$env" "$version" "$new_commit" "Moved tag to $new_commit"
    tag_push "$tag_name"
}

tag_list() {
    local service=${1:-}
    
    echo ""
    if [[ -z "$service" ]]; then
        log_tag "All deployment tags:"
        git tag -l "*-v*-*" --sort=-version:refname 2>/dev/null || echo "No tags found"
    else
        if [[ ! -v "TAG_SERVICES[$service]" ]]; then
            log_error "Invalid service: $service"
            log_info "Available services: ${!TAG_SERVICES[@]}"
            exit 1
        fi
        local prefix="${TAG_SERVICES[$service]}"
        log_tag "Tags for $service:"
        git tag -l "${prefix}*" --sort=-version:refname 2>/dev/null || echo "No tags found"
    fi
    echo ""
}

trigger_n8n_deployment() {
    local service=$1
    local env=$2
    local version=$3
    local tag_name=$4
    
    local webhook_url="${N8N_WEBHOOK_BASE}/deploy-${service}"
    
    log_info "Triggering n8n workflow for $service deployment"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_warning "DRY RUN: Would trigger webhook $webhook_url"
        return 0
    fi
    
    local payload=$(cat <<EOF
{
    "service": "$service",
    "environment": "$env",
    "version": "$version",
    "tag": "$tag_name",
    "commit": "$(git rev-parse HEAD 2>/dev/null || echo 'unknown')",
    "author": "$(git config user.name 2>/dev/null || echo 'unknown')",
    "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "registry": "${REGISTRY:-localhost:5000}"
}
EOF
)
    
    if command -v curl &> /dev/null; then
        response=$(curl -s -X POST \
            -H "Content-Type: application/json" \
            -d "$payload" \
            "$webhook_url" 2>&1 || echo "ERROR")
        
        if [[ "$response" == "ERROR" ]] || [[ "$response" == *"Connection refused"* ]]; then
            log_warning "Failed to trigger n8n webhook (is n8n running?)"
        else
            log_success "n8n webhook triggered successfully"
        fi
    else
        log_warning "curl not found, skipping webhook trigger"
    fi
}

tag_deploy() {
    local service=$1
    local env=$2
    local version=$3
    local commit=${4:-HEAD}
    local message=${5:-"Deploy $service v$version to $env"}
    
    local tag_name=$(generate_tag_name "$service" "$env" "$version")
    
    log_tag "Starting deployment workflow for $service v$version to $env"
    
    # Create and push tag
    tag_create "$service" "$env" "$version" "$commit" "$message"
    tag_push "$tag_name"
    
    # Trigger n8n workflow
    trigger_n8n_deployment "$service" "$env" "$version" "$tag_name"
    
    log_success "Deployment initiated for $service v$version to $env"
    log_info "Tag: $tag_name"
    if [[ -n "$REPO_URL" ]]; then
        log_info "Monitor deployment: ${GITEA_URL}/$(echo $REPO_URL | sed 's/.*://;s/.git$//')/actions"
    fi
}

tag_rollback() {
    local service=$1
    local env=$2
    local version=$3
    
    local tag_name=$(generate_tag_name "$service" "$env" "$version")
    
    if ! git rev-parse "$tag_name" >/dev/null 2>&1; then
        log_error "Tag $tag_name does not exist"
        exit 1
    fi
    
    local commit=$(git rev-parse "$tag_name")
    
    log_warning "Rolling back $service in $env to version $version (commit: $commit)"
    
    if [[ "$env" == "prod" && "$FORCE" != "true" ]]; then
        read -p "Are you sure you want to rollback production? (yes/no): " confirm
        if [[ "$confirm" != "yes" ]]; then
            log_info "Rollback cancelled"
            exit 0
        fi
    fi
    
    trigger_n8n_deployment "$service" "$env" "$version" "$tag_name"
    
    log_success "Rollback initiated for $service to version $version in $env"
}

tag_status() {
    local service=$1
    local version=$2
    local env=$3
    
    log_tag "Checking deployment status for $service v$version in $env"
    
    if command -v curl &> /dev/null; then
        local status_url="${N8N_WEBHOOK_BASE}/deployment-status?service=${service}&version=${version}&env=${env}"
        local response=$(curl -s "$status_url" 2>/dev/null || echo "{}")
        
        if [[ "$response" == "{}" ]] || [[ "$response" == *"Connection refused"* ]]; then
            log_warning "Could not connect to n8n (is it running?)"
            log_info "Check manually: $status_url"
        else
            echo "$response" | jq '.' 2>/dev/null || echo "$response"
        fi
    else
        log_warning "curl not found, cannot check status"
    fi
}

# ============================================================================
# API SERVER FUNCTIONS
# ============================================================================

api_start() {
    local port="${1:-$API_PORT}"
    local host="${2:-$API_HOST}"
    
    # Check if server is already running
    if [ -f "$API_PIDFILE" ]; then
        local pid=$(cat "$API_PIDFILE")
        if ps -p "$pid" > /dev/null 2>&1; then
            log_warning "API server already running (PID: $pid)"
            log_info "URL: http://${host}:${port}"
            return 0
        else
            log_warning "Stale PID file found, removing..."
            rm -f "$API_PIDFILE"
        fi
    fi
    
    # Check if nc (netcat) is available
    if ! command -v nc &> /dev/null; then
        log_error "netcat (nc) is not installed"
        log_info "Install with: apt-get install netcat (Debian/Ubuntu) or yum install nc (RHEL/CentOS)"
        exit 1
    fi
    
    log_api "Starting REST API server on http://${host}:${port}"
    log_info "Press Ctrl+C to stop or run: kompose api stop"
    
    # Start server in background
    nohup bash -c '
        KOMPOSE_SCRIPT="$0"
        PORT="'$port'"
        HOST="'$host'"
        PIDFILE="'$API_PIDFILE'"
        LOGFILE="'$API_LOGFILE'"
        
        echo $ > "$PIDFILE"
        
        api_handle_request() {
            local request="$1"
            
            # Parse HTTP request
            local method=$(echo "$request" | head -n 1 | awk '''{print $1}''')
            local path=$(echo "$request" | head -n 1 | awk '''{print $2}''')
            local body=$(echo "$request" | sed -n '''$ p''')
            
            # Remove query string for routing
            local clean_path=$(echo "$path" | cut -d"?" -f1)
            
            # Log request
            echo "[$(date +'''%Y-%m-%d %H:%M:%S''')] $method $path" >> "$LOGFILE"
            
            # Route to appropriate handler
            case "$clean_path" in
                "/api/stacks")
                    if [ "$method" = "GET" ]; then
                        JSON_OUTPUT=true '$STACKS_ROOT'/kompose.sh list
                    else
                        echo '''HTTP/1.1 405 Method Not Allowed'''
                        echo '''Content-Type: application/json'''
                        echo ''''
                        echo '''{"status":"error","message":"Method not allowed"}'''
                    fi
                    ;;
                "/api/stacks/"*)
                    local stack=$(echo "$clean_path" | sed '''s|/api/stacks/||''' | cut -d'''/''' -f1)
                    local action=$(echo "$clean_path" | sed '''s|/api/stacks/[^/]*/||''')
                    
                    case "$action" in
                        "status")
                            [ "$method" = "GET" ] && JSON_OUTPUT=true '$STACKS_ROOT'/kompose.sh status "$stack"
                            ;;
                        "start")
                            [ "$method" = "POST" ] && JSON_OUTPUT=true '$STACKS_ROOT'/kompose.sh up "$stack"
                            ;;
                        "stop")
                            [ "$method" = "POST" ] && JSON_OUTPUT=true '$STACKS_ROOT'/kompose.sh down "$stack"
                            ;;
                        "restart")
                            [ "$method" = "POST" ] && JSON_OUTPUT=true '$STACKS_ROOT'/kompose.sh restart "$stack"
                            ;;
                        "logs")
                            [ "$method" = "GET" ] && JSON_OUTPUT=true '$STACKS_ROOT'/kompose.sh logs "$stack" --tail=100
                            ;;
                        *)
                            echo '''HTTP/1.1 404 Not Found'''
                            echo '''Content-Type: application/json'''
                            echo ''''
                            echo '''{"status":"error","message":"Endpoint not found"}'''
                            ;;
                    esac
                    ;;
                "/api/health")
                    echo '''HTTP/1.1 200 OK'''
                    echo '''Content-Type: application/json'''
                    echo ''''
                    echo '''{"status":"ok","version":"1.0.0","timestamp":"'''$(date -u +%Y-%m-%dT%H:%M:%SZ)''\''}}'''
                    ;;
                *)
                    echo '''HTTP/1.1 404 Not Found'''
                    echo '''Content-Type: application/json'''
                    echo ''''
                    echo '''{"status":"error","message":"Endpoint not found"}'''
                    ;;
            esac
        }
        
        # Main server loop
        while true; do
            request=$(echo -e "HTTP/1.1 200 OK\r\n\r\n" | nc -l "$HOST" "$PORT")
            if [ $? -eq 0 ]; then
                response=$(api_handle_request "$request")
                echo -e "$response\r\n" | nc -l "$HOST" "$PORT" &
            fi
        done
    ' > "$API_LOGFILE" 2>&1 &
    
    local server_pid=$!
    sleep 1
    
    if ps -p "$server_pid" > /dev/null 2>&1; then
        log_success "API server started (PID: $server_pid)"
        log_info "Server URL: http://${host}:${port}"
        log_info "API Endpoints:"
        echo "  GET  /api/health                    - Health check"
        echo "  GET  /api/stacks                    - List all stacks"
        echo "  GET  /api/stacks/{name}/status      - Get stack status"
        echo "  POST /api/stacks/{name}/start       - Start stack"
        echo "  POST /api/stacks/{name}/stop        - Stop stack"
        echo "  POST /api/stacks/{name}/restart     - Restart stack"
        echo "  GET  /api/stacks/{name}/logs        - Get stack logs"
        log_info "Log file: $API_LOGFILE"
    else
        log_error "Failed to start API server"
        rm -f "$API_PIDFILE"
        exit 1
    fi
}

api_stop() {
    if [ ! -f "$API_PIDFILE" ]; then
        log_error "API server is not running"
        return 1
    fi
    
    local pid=$(cat "$API_PIDFILE")
    
    if ! ps -p "$pid" > /dev/null 2>&1; then
        log_warning "API server not running (stale PID file)"
        rm -f "$API_PIDFILE"
        return 0
    fi
    
    log_api "Stopping API server (PID: $pid)"
    
    kill "$pid" 2>/dev/null
    
    # Wait for process to stop
    local count=0
    while ps -p "$pid" > /dev/null 2>&1 && [ $count -lt 10 ]; do
        sleep 0.5
        count=$((count + 1))
    done
    
    if ps -p "$pid" > /dev/null 2>&1; then
        log_warning "Force killing server..."
        kill -9 "$pid" 2>/dev/null
    fi
    
    rm -f "$API_PIDFILE"
    log_success "API server stopped"
}

api_status() {
    if [ ! -f "$API_PIDFILE" ]; then
        log_info "API server is not running"
        return 1
    fi
    
    local pid=$(cat "$API_PIDFILE")
    
    if ps -p "$pid" > /dev/null 2>&1; then
        log_success "API server is running (PID: $pid)"
        log_info "Server URL: http://${API_HOST}:${API_PORT}"
        
        if [ -f "$API_LOGFILE" ]; then
            echo ""
            log_info "Recent log entries:"
            tail -n 10 "$API_LOGFILE" | sed 's/^/  /'
        fi
    else
        log_warning "API server not running (stale PID file)"
        rm -f "$API_PIDFILE"
        return 1
    fi
}

api_logs() {
    if [ ! -f "$API_LOGFILE" ]; then
        log_warning "No log file found"
        return 0
    fi
    
    log_api "API server logs:"
    echo ""
    tail -f "$API_LOGFILE"
}

# ============================================================================
# API SERVER MANAGEMENT FUNCTIONS
# ============================================================================

api_start() {
    local port="${1:-$API_PORT}"
    local host="${2:-$API_HOST}"
    
    # Check if server script exists
    if [ ! -f "$API_SERVER_SCRIPT" ]; then
        log_error "API server script not found: $API_SERVER_SCRIPT"
        return 1
    fi
    
    # Check if server is already running
    if [ -f "$API_PIDFILE" ]; then
        local pid=$(cat "$API_PIDFILE")
        if ps -p "$pid" > /dev/null 2>&1; then
            log_warning "API server already running (PID: $pid)"
            log_info "URL: http://${host}:${port}"
            return 0
        else
            log_warning "Stale PID file found, removing..."
            rm -f "$API_PIDFILE"
        fi
    fi
    
    # Start server in background
    log_api "Starting REST API server..."
    
    chmod +x "$API_SERVER_SCRIPT"
    API_PORT="$port" API_HOST="$host" KOMPOSE_SCRIPT="$0" nohup "$API_SERVER_SCRIPT" > /dev/null 2>&1 &
    local server_pid=$!
    
    # Wait a bit and check if it started
    sleep 1
    
    if ps -p "$server_pid" > /dev/null 2>&1; then
        log_success "API server started (PID: $server_pid)"
        log_info "Server URL: http://${host}:${port}"
        log_info "API Endpoints:"
        echo "  GET  /api/health                    - Health check"
        echo "  GET  /api/stacks                    - List all stacks"
        echo "  GET  /api/stacks/{name}             - Get stack status"
        echo "  POST /api/stacks/{name}/start       - Start stack"
        echo "  POST /api/stacks/{name}/stop        - Stop stack"
        echo "  POST /api/stacks/{name}/restart     - Restart stack"
        echo "  GET  /api/stacks/{name}/logs        - Get stack logs"
        echo "  GET  /api/db/status                 - Database status"
        echo "  GET  /api/db/list                   - List backups"
        echo "  GET  /api/tag/list                  - List deployment tags"
        log_info "Log file: $API_LOGFILE"
    else
        log_error "Failed to start API server"
        return 1
    fi
}

api_stop() {
    if [ ! -f "$API_PIDFILE" ]; then
        log_error "API server is not running"
        return 1
    fi
    
    local pid=$(cat "$API_PIDFILE")
    
    if ! ps -p "$pid" > /dev/null 2>&1; then
        log_warning "API server not running (stale PID file)"
        rm -f "$API_PIDFILE"
        return 0
    fi
    
    log_api "Stopping API server (PID: $pid)"
    
    kill "$pid" 2>/dev/null
    
    # Wait for process to stop
    local count=0
    while ps -p "$pid" > /dev/null 2>&1 && [ $count -lt 10 ]; do
        sleep 0.5
        count=$((count + 1))
    done
    
    if ps -p "$pid" > /dev/null 2>&1; then
        log_warning "Force killing server..."
        kill -9 "$pid" 2>/dev/null
    fi
    
    rm -f "$API_PIDFILE"
    log_success "API server stopped"
}

api_status() {
    if [ ! -f "$API_PIDFILE" ]; then
        log_info "API server is not running"
        return 1
    fi
    
    local pid=$(cat "$API_PIDFILE")
    
    if ps -p "$pid" > /dev/null 2>&1; then
        log_success "API server is running (PID: $pid)"
        log_info "Server URL: http://${API_HOST}:${API_PORT}"
        
        if [ -f "$API_LOGFILE" ]; then
            echo ""
            log_info "Recent log entries:"
            tail -n 10 "$API_LOGFILE" | sed 's/^/  /'
        fi
    else
        log_warning "API server not running (stale PID file)"
        rm -f "$API_PIDFILE"
        return 1
    fi
}

api_logs() {
    if [ ! -f "$API_LOGFILE" ]; then
        log_warning "No log file found"
        return 0
    fi
    
    log_api "API server logs:"
    echo ""
    tail -f "$API_LOGFILE"
}

# ============================================================================
# DATABASE MANAGEMENT FUNCTIONS
# ============================================================================

db_backup() {
    local db_name=${1:-"all"}
    local backup_file=$2
    local compress=${3:-false}
    local timestamp=$(date +%Y%m%d-%H%M%S)
    
    mkdir -p "$BACKUP_DIR"
    
    if [[ "$db_name" == "all" ]]; then
        log_db "Backing up all databases..."
        for db in "${!DATABASES[@]}"; do
            db_backup "$db" "" "$compress"
        done
        log_success "All databases backed up to $BACKUP_DIR"
        return 0
    fi
    
    if [[ ! -v "DATABASES[$db_name]" ]]; then
        log_error "Unknown database: $db_name"
        log_info "Available databases: ${!DATABASES[@]}"
        exit 1
    fi
    
    if [[ -z "$backup_file" ]]; then
        backup_file="${BACKUP_DIR}/${db_name}_${timestamp}.sql"
        if [[ "$compress" == "true" ]]; then
            backup_file="${backup_file}.gz"
        fi
    fi
    
    log_db "Backing up database: $db_name"
    log_info "Backup file: $backup_file"
    
    if [[ "$compress" == "true" ]]; then
        docker exec "$POSTGRES_CONTAINER" pg_dump -U "$DB_USER" "$db_name" | gzip > "$backup_file"
    else
        docker exec "$POSTGRES_CONTAINER" pg_dump -U "$DB_USER" "$db_name" > "$backup_file"
    fi
    
    if [[ $? -eq 0 ]]; then
        local size=$(du -h "$backup_file" | cut -f1)
        log_success "Database $db_name backed up successfully ($size)"
    else
        log_error "Backup failed for database: $db_name"
        exit 1
    fi
}

db_restore() {
    local backup_file=$1
    local db_name=$2
    
    if [[ -z "$backup_file" ]]; then
        log_error "Backup file required"
        log_info "Usage: kompose db restore -f BACKUP_FILE [-d DATABASE]"
        exit 1
    fi
    
    if [[ ! -f "$backup_file" ]]; then
        log_error "Backup file not found: $backup_file"
        exit 1
    fi
    
    # Auto-detect database name from filename if not provided
    if [[ -z "$db_name" ]]; then
        db_name=$(basename "$backup_file" | sed -E 's/^([^_]+)_.*/\1/')
        log_info "Auto-detected database: $db_name"
    fi
    
    if [[ ! -v "DATABASES[$db_name]" ]]; then
        log_error "Unknown database: $db_name"
        log_info "Available databases: ${!DATABASES[@]}"
        exit 1
    fi
    
    log_warning "Restoring database: $db_name from $backup_file"
    read -p "This will overwrite the existing database. Continue? (yes/no): " confirm
    
    if [[ "$confirm" != "yes" ]]; then
        log_info "Restore cancelled"
        exit 0
    fi
    
    log_db "Dropping existing database..."
    docker exec "$POSTGRES_CONTAINER" psql -U "$DB_USER" -c "DROP DATABASE IF EXISTS $db_name;"
    docker exec "$POSTGRES_CONTAINER" psql -U "$DB_USER" -c "CREATE DATABASE $db_name;"
    
    log_db "Restoring from backup..."
    if [[ "$backup_file" == *.gz ]]; then
        gunzip -c "$backup_file" | docker exec -i "$POSTGRES_CONTAINER" psql -U "$DB_USER" "$db_name"
    else
        docker exec -i "$POSTGRES_CONTAINER" psql -U "$DB_USER" "$db_name" < "$backup_file"
    fi
    
    if [[ $? -eq 0 ]]; then
        log_success "Database $db_name restored successfully"
    else
        log_error "Restore failed"
        exit 1
    fi
}

db_list() {
    echo ""
    log_db "Available database backups:"
    echo ""
    
    if [[ ! -d "$BACKUP_DIR" ]]; then
        log_warning "No backup directory found: $BACKUP_DIR"
        return 0
    fi
    
    find "$BACKUP_DIR" -name "*.sql" -o -name "*.sql.gz" | sort -r | while read -r file; do
        local size=$(du -h "$file" | cut -f1)
        local date=$(stat -c %y "$file" 2>/dev/null || stat -f %Sm "$file" 2>/dev/null || echo "unknown")
        echo -e "  📦 $(basename $file) - $size - $date"
    done
    
    echo ""
}

db_status() {
    log_db "Database status:"
    echo ""
    
    if ! docker ps | grep -q "$POSTGRES_CONTAINER"; then
        log_error "PostgreSQL container is not running"
        log_info "Start with: kompose up home"
        exit 1
    fi
    
    log_success "PostgreSQL container is running"
    echo ""
    
    log_info "Available databases:"
    docker exec "$POSTGRES_CONTAINER" psql -U "$DB_USER" -c "\l" | grep -E "^\s*(kompose|n8n|gitea)" || echo "No databases found"
    echo ""
    
    log_info "Database sizes:"
    for db in "${!DATABASES[@]}"; do
        local size=$(docker exec "$POSTGRES_CONTAINER" psql -U "$DB_USER" -d "$db" -c "SELECT pg_size_pretty(pg_database_size('$db'));" -t 2>/dev/null | xargs)
        if [[ -n "$size" ]]; then
            echo -e "  ${CYAN}$db${NC}: $size - ${DATABASES[$db]}"
        fi
    done
    echo ""
    
    log_info "Active connections:"
    docker exec "$POSTGRES_CONTAINER" psql -U "$DB_USER" -c "SELECT datname, count(*) FROM pg_stat_activity GROUP BY datname;"
    echo ""
}

db_exec() {
    local db_name=$1
    local sql_command=$2
    
    if [[ -z "$db_name" || -z "$sql_command" ]]; then
        log_error "Database name and SQL command required"
        log_info "Usage: kompose db exec -d DATABASE \"SQL COMMAND\""
        exit 1
    fi
    
    if [[ ! -v "DATABASES[$db_name]" ]]; then
        log_error "Unknown database: $db_name"
        log_info "Available databases: ${!DATABASES[@]}"
        exit 1
    fi
    
    log_db "Executing SQL on database: $db_name"
    docker exec "$POSTGRES_CONTAINER" psql -U "$DB_USER" -d "$db_name" -c "$sql_command"
}

db_shell() {
    local db_name=${1:-kompose}
    
    if [[ ! -v "DATABASES[$db_name]" ]]; then
        log_error "Unknown database: $db_name"
        log_info "Available databases: ${!DATABASES[@]}"
        exit 1
    fi
    
    log_db "Opening shell for database: $db_name"
    log_info "Type \\q to exit"
    echo ""
    
    docker exec -it "$POSTGRES_CONTAINER" psql -U "$DB_USER" -d "$db_name"
}

db_migrate() {
    local db_name=${1:-kompose}
    
    if [[ ! -v "DATABASES[$db_name]" ]]; then
        log_error "Unknown database: $db_name"
        log_info "Available databases: ${!DATABASES[@]}"
        exit 1
    fi
    
    log_db "Running migrations for database: $db_name"
    
    case $db_name in
        n8n)
            log_info "n8n handles migrations automatically on startup"
            log_info "Restart n8n: kompose restart chain"
            ;;
        gitea)
            log_info "Gitea handles migrations automatically on startup"
            log_info "Restart gitea: kompose restart chain"
            ;;
        kompose)
            local migrations_dir="./migrations"
            if [[ ! -d "$migrations_dir" ]]; then
                log_warning "No migrations directory found: $migrations_dir"
                return 0
            fi
            
            log_info "Applying migrations from $migrations_dir"
            for migration in "$migrations_dir"/*.sql; do
                if [[ -f "$migration" ]]; then
                    log_info "Applying: $(basename $migration)"
                    docker exec -i "$POSTGRES_CONTAINER" psql -U "$DB_USER" -d "$db_name" < "$migration"
                fi
            done
            log_success "Migrations completed"
            ;;
    esac
}

db_reset() {
    local db_name=$1
    
    if [[ -z "$db_name" ]]; then
        log_error "Database name required"
        log_info "Usage: kompose db reset -d DATABASE"
        exit 1
    fi
    
    if [[ ! -v "DATABASES[$db_name]" ]]; then
        log_error "Unknown database: $db_name"
        log_info "Available databases: ${!DATABASES[@]}"
        exit 1
    fi
    
    log_warning "⚠️  WARNING: This will DELETE ALL DATA in database: $db_name"
    read -p "Type the database name to confirm: " confirm
    
    if [[ "$confirm" != "$db_name" ]]; then
        log_info "Reset cancelled"
        exit 0
    fi
    
    log_db "Resetting database: $db_name"
    
    # Create backup first
    log_info "Creating backup before reset..."
    db_backup "$db_name" "" false
    
    # Drop and recreate
    docker exec "$POSTGRES_CONTAINER" psql -U "$DB_USER" -c "DROP DATABASE IF EXISTS $db_name;"
    docker exec "$POSTGRES_CONTAINER" psql -U "$DB_USER" -c "CREATE DATABASE $db_name;"
    
    log_success "Database $db_name has been reset"
    log_info "Backup saved to: $BACKUP_DIR"
}

# ============================================================================
# MAIN COMMAND ROUTER
# ============================================================================

main() {
    if [ $# -eq 0 ]; then
        usage
    fi
    
    local command=$1
    shift
    
    # Handle API subcommands
    if [ "$command" = "api" ]; then
        if [ $# -eq 0 ]; then
            log_error "API subcommand required"
            echo ""
            echo "Available API commands:"
            echo "  start [PORT] [HOST]  - Start REST API server"
            echo "  stop                 - Stop REST API server"
            echo "  status               - Check server status"
            echo "  logs                 - View server logs"
            echo ""
            echo "Example: kompose api start 9000"
            exit 1
        fi
        
        local api_cmd=$1
        shift
        
        case $api_cmd in
            start)
                local port="${1:-$API_PORT}"
                local host="${2:-$API_HOST}"
                api_start "$port" "$host"
                ;;
            stop)
                api_stop
                ;;
            status)
                api_status
                ;;
            logs)
                api_logs
                ;;
            *)
                log_error "Unknown API command: $api_cmd"
                echo "Available: start, stop, status, logs"
                exit 1
                ;;
        esac
        
        return 0
    fi
    
    # Handle tag subcommands
    if [ "$command" = "tag" ]; then
        if [ $# -eq 0 ]; then
            log_error "Tag subcommand required"
            echo ""
            echo "Available tag commands:"
            echo "  create, deploy, move, delete, list, rollback, status"
            echo ""
            echo "Example: kompose tag deploy -s frontend -e dev -v 1.0.0"
            exit 1
        fi
        
        local tag_cmd=$1
        shift
        
        # Parse tag options
        TAG_SERVICE=""
        TAG_ENV=""
        TAG_VERSION=""
        TAG_COMMIT=""
        TAG_MESSAGE=""
        FORCE=false
        DRY_RUN=false
        
        while [ $# -gt 0 ]; do
            case $1 in
                -s|--service)
                    TAG_SERVICE="$2"
                    shift 2
                    ;;
                -e|--env)
                    TAG_ENV="$2"
                    shift 2
                    ;;
                -v|--version)
                    TAG_VERSION="$2"
                    shift 2
                    ;;
                -c|--commit)
                    TAG_COMMIT="$2"
                    shift 2
                    ;;
                -m|--message)
                    TAG_MESSAGE="$2"
                    shift 2
                    ;;
                -f|--force)
                    FORCE=true
                    shift
                    ;;
                -d|--dry-run)
                    DRY_RUN=true
                    shift
                    ;;
                *)
                    # Positional arguments for tag status
                    if [ "$tag_cmd" = "status" ]; then
                        if [ -z "$TAG_SERVICE" ]; then
                            TAG_SERVICE="$1"
                        elif [ -z "$TAG_VERSION" ]; then
                            TAG_VERSION="$1"
                        elif [ -z "$TAG_ENV" ]; then
                            TAG_ENV="$1"
                        fi
                        shift
                    else
                        log_error "Unknown option: $1"
                        exit 1
                    fi
                    ;;
            esac
        done
        
        validate_tag_inputs
        
        case $tag_cmd in
            create)
                [[ -z "$TAG_SERVICE" || -z "$TAG_ENV" || -z "$TAG_VERSION" ]] && \
                    { log_error "Required: -s SERVICE -e ENV -v VERSION"; exit 1; }
                tag_create "$TAG_SERVICE" "$TAG_ENV" "$TAG_VERSION" "${TAG_COMMIT:-HEAD}" "$TAG_MESSAGE"
                ;;
            deploy)
                [[ -z "$TAG_SERVICE" || -z "$TAG_ENV" || -z "$TAG_VERSION" ]] && \
                    { log_error "Required: -s SERVICE -e ENV -v VERSION"; exit 1; }
                tag_deploy "$TAG_SERVICE" "$TAG_ENV" "$TAG_VERSION" "${TAG_COMMIT:-HEAD}" "$TAG_MESSAGE"
                ;;
            move)
                [[ -z "$TAG_SERVICE" || -z "$TAG_ENV" || -z "$TAG_VERSION" || -z "$TAG_COMMIT" ]] && \
                    { log_error "Required: -s SERVICE -e ENV -v VERSION -c COMMIT"; exit 1; }
                tag_move "$TAG_SERVICE" "$TAG_ENV" "$TAG_VERSION" "$TAG_COMMIT"
                ;;
            delete)
                [[ -z "$TAG_SERVICE" || -z "$TAG_ENV" || -z "$TAG_VERSION" ]] && \
                    { log_error "Required: -s SERVICE -e ENV -v VERSION"; exit 1; }
                tag_delete "$TAG_SERVICE" "$TAG_ENV" "$TAG_VERSION"
                ;;
            list)
                tag_list "$TAG_SERVICE"
                ;;
            rollback)
                [[ -z "$TAG_SERVICE" || -z "$TAG_ENV" || -z "$TAG_VERSION" ]] && \
                    { log_error "Required: -s SERVICE -e ENV -v VERSION"; exit 1; }
                tag_rollback "$TAG_SERVICE" "$TAG_ENV" "$TAG_VERSION"
                ;;
            status)
                [[ -z "$TAG_SERVICE" || -z "$TAG_VERSION" || -z "$TAG_ENV" ]] && \
                    { log_error "Required: SERVICE VERSION ENV or -s -v -e"; exit 1; }
                tag_status "$TAG_SERVICE" "$TAG_VERSION" "$TAG_ENV"
                ;;
            *)
                log_error "Unknown tag command: $tag_cmd"
                echo "Available: create, deploy, move, delete, list, rollback, status"
                exit 1
                ;;
        esac
        
        return 0
    fi
    
    # Handle database subcommands
    if [ "$command" = "db" ]; then
        if [ $# -eq 0 ]; then
            log_error "Database subcommand required"
            echo ""
            echo "Available database commands:"
            echo "  backup, restore, list, status, exec, shell, migrate, reset"
            echo ""
            echo "Example: kompose db backup -d postgres"
            exit 1
        fi
        
        local db_cmd=$1
        shift
        
        # Parse database options
        DB_NAME=""
        DB_FILE=""
        DB_COMPRESS=false
        DB_TIMESTAMP=false
        DB_SQL=""
        
        while [ $# -gt 0 ]; do
            case $1 in
                -d|--database)
                    DB_NAME="$2"
                    shift 2
                    ;;
                -f|--file)
                    DB_FILE="$2"
                    shift 2
                    ;;
                --compress)
                    DB_COMPRESS=true
                    shift
                    ;;
                --timestamp|-t)
                    DB_TIMESTAMP=true
                    shift
                    ;;
                *)
                    # Positional argument (SQL command for exec)
                    if [ "$db_cmd" = "exec" ]; then
                        DB_SQL="$1"
                        shift
                    elif [ "$db_cmd" = "shell" ] || [ "$db_cmd" = "migrate" ] || [ "$db_cmd" = "reset" ]; then
                        if [ -z "$DB_NAME" ]; then
                            DB_NAME="$1"
                        fi
                        shift
                    else
                        log_error "Unknown option: $1"
                        exit 1
                    fi
                    ;;
            esac
        done
        
        case $db_cmd in
            backup)
                db_backup "${DB_NAME:-all}" "$DB_FILE" "$DB_COMPRESS"
                ;;
            restore)
                db_restore "$DB_FILE" "$DB_NAME"
                ;;
            list)
                db_list
                ;;
            status)
                db_status
                ;;
            exec)
                [[ -z "$DB_NAME" || -z "$DB_SQL" ]] && \
                    { log_error "Required: -d DATABASE \"SQL COMMAND\""; exit 1; }
                db_exec "$DB_NAME" "$DB_SQL"
                ;;
            shell)
                db_shell "${DB_NAME:-kompose}"
                ;;
            migrate)
                db_migrate "${DB_NAME:-kompose}"
                ;;
            reset)
                [[ -z "$DB_NAME" ]] && \
                    { log_error "Required: -d DATABASE"; exit 1; }
                db_reset "$DB_NAME"
                ;;
            *)
                log_error "Unknown database command: $db_cmd"
                echo "Available: backup, restore, list, status, exec, shell, migrate, reset"
                exit 1
                ;;
        esac
        
        return 0
    fi
    
    # Handle stack management commands
    case $command in
        up)
            if [ $# -eq 0 ]; then
                process_all_stacks "up" "$@"
            else
                local stack=$1
                shift
                if stack_exists "$stack"; then
                    stack_up "$stack" true "$@"
                fi
            fi
            ;;
        down)
            if [ $# -eq 0 ]; then
                process_all_stacks "down" "$@"
            else
                local stack=$1
                shift
                local force=false
                if [ "$1" = "-f" ] || [ "$1" = "--force" ]; then
                    force=true
                fi
                if stack_exists "$stack"; then
                    stack_down "$stack" "$force"
                fi
            fi
            ;;
        restart)
            if [ $# -eq 0 ]; then
                process_all_stacks "restart" "$@"
            else
                local stack=$1
                shift
                if stack_exists "$stack"; then
                    stack_restart "$stack" "$@"
                fi
            fi
            ;;
        status)
            if [ $# -eq 0 ]; then
                process_all_stacks "status" "$@"
            else
                local stack=$1
                if stack_exists "$stack"; then
                    stack_status "$stack"
                fi
            fi
            ;;
        logs)
            if [ $# -eq 0 ]; then
                log_error "Stack name required for logs"
                exit 1
            fi
            local stack=$1
            shift
            if stack_exists "$stack"; then
                stack_logs "$stack" "$@"
            fi
            ;;
        pull)
            if [ $# -eq 0 ]; then
                process_all_stacks "pull" "$@"
            else
                local stack=$1
                shift
                if stack_exists "$stack"; then
                    stack_pull "$stack" "$@"
                fi
            fi
            ;;
        build)
            if [ $# -eq 0 ]; then
                log_error "Stack name required for build"
                exit 1
            fi
            local stack=$1
            shift
            local no_cache=false
            if [ "$1" = "--no-cache" ]; then
                no_cache=true
            fi
            if stack_exists "$stack"; then
                stack_build "$stack" "$no_cache"
            fi
            ;;
        deploy)
            if [ $# -lt 2 ]; then
                log_error "Stack name and version required for deploy"
                log_info "Usage: kompose deploy STACK VERSION"
                exit 1
            fi
            local stack=$1
            local version=$2
            if stack_exists "$stack"; then
                stack_deploy "$stack" "$version"
            fi
            ;;
        list)
            list_stacks
            ;;
        validate)
            if [ $# -eq 0 ]; then
                process_all_stacks "validate" "$@"
            else
                local stack=$1
                if stack_exists "$stack"; then
                    stack_validate "$stack"
                fi
            fi
            ;;
        exec)
            if [ $# -lt 2 ]; then
                log_error "Stack name and command required for exec"
                exit 1
            fi
            local stack=$1
            shift
            if stack_exists "$stack"; then
                stack_exec "$stack" "$@"
            fi
            ;;
        ps)
            show_all_containers
            ;;
        help|--help|-h)
            usage
            ;;
        *)
            log_error "Unknown command: $command"
            usage
            ;;
    esac
}

main "$@"
\n'/\\n}"
    str="${str//

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
            stacks+=($(basename "$dir"))
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

# ============================================================================
# GIT TAG DEPLOYMENT FUNCTIONS
# ============================================================================

validate_tag_inputs() {
    if [[ -n "$TAG_SERVICE" && ! -v "TAG_SERVICES[$TAG_SERVICE]" ]]; then
        log_error "Invalid service: $TAG_SERVICE"
        log_info "Available services: ${!TAG_SERVICES[@]}"
        exit 1
    fi

    if [[ -n "$TAG_ENV" && ! -v "ENVIRONMENTS[$TAG_ENV]" ]]; then
        log_error "Invalid environment: $TAG_ENV"
        log_info "Available environments: ${!ENVIRONMENTS[@]}"
        exit 1
    fi

    if [[ -n "$TAG_VERSION" && ! "$TAG_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9]+)?$ ]]; then
        log_error "Invalid version format: $TAG_VERSION (expected: X.Y.Z)"
        exit 1
    fi
}

generate_tag_name() {
    local service=$1
    local env=$2
    local version=$3
    
    echo "${TAG_SERVICES[$service]}${version}-${env}"
}

tag_create() {
    local service=$1
    local env=$2
    local version=$3
    local commit=${4:-HEAD}
    local message=${5:-"Deploy $service v$version to $env"}
    
    local tag_name=$(generate_tag_name "$service" "$env" "$version")
    
    log_tag "Creating tag: $tag_name at commit $commit"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_warning "DRY RUN: Would create tag $tag_name"
        return 0
    fi
    
    if git rev-parse "$tag_name" >/dev/null 2>&1; then
        if [[ "$FORCE" == "true" ]]; then
            log_warning "Tag $tag_name already exists. Deleting..."
            git tag -d "$tag_name"
        else
            log_error "Tag $tag_name already exists. Use -f to force."
            exit 1
        fi
    fi
    
    git tag -a "$tag_name" "$commit" -m "$message"
    log_success "Tag created: $tag_name"
}

tag_push() {
    local tag_name=$1
    
    log_tag "Pushing tag: $tag_name to remote"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_warning "DRY RUN: Would push tag $tag_name"
        return 0
    fi
    
    if [[ "$FORCE" == "true" ]]; then
        git push origin "$tag_name" --force
    else
        git push origin "$tag_name"
    fi
    
    log_success "Tag pushed: $tag_name"
}

tag_delete() {
    local service=$1
    local env=$2
    local version=$3
    
    local tag_name=$(generate_tag_name "$service" "$env" "$version")
    
    log_warning "Deleting tag: $tag_name"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_warning "DRY RUN: Would delete tag $tag_name"
        return 0
    fi
    
    if [[ "$env" == "prod" && "$FORCE" != "true" ]]; then
        read -p "Are you sure you want to delete production tag $tag_name? (yes/no): " confirm
        if [[ "$confirm" != "yes" ]]; then
            log_info "Deletion cancelled"
            exit 0
        fi
    fi
    
    git tag -d "$tag_name" 2>/dev/null || log_warning "Local tag not found"
    git push origin ":refs/tags/$tag_name" 2>/dev/null || log_warning "Remote tag not found"
    
    log_success "Tag deleted: $tag_name"
}

tag_move() {
    local service=$1
    local env=$2
    local version=$3
    local new_commit=$4
    
    local tag_name=$(generate_tag_name "$service" "$env" "$version")
    
    log_tag "Moving tag $tag_name to commit $new_commit"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_warning "DRY RUN: Would move tag $tag_name to $new_commit"
        return 0
    fi
    
    git tag -d "$tag_name" 2>/dev/null || true
    git push origin ":refs/tags/$tag_name" 2>/dev/null || true
    
    tag_create "$service" "$env" "$version" "$new_commit" "Moved tag to $new_commit"
    tag_push "$tag_name"
}

tag_list() {
    local service=${1:-}
    
    echo ""
    if [[ -z "$service" ]]; then
        log_tag "All deployment tags:"
        git tag -l "*-v*-*" --sort=-version:refname 2>/dev/null || echo "No tags found"
    else
        if [[ ! -v "TAG_SERVICES[$service]" ]]; then
            log_error "Invalid service: $service"
            log_info "Available services: ${!TAG_SERVICES[@]}"
            exit 1
        fi
        local prefix="${TAG_SERVICES[$service]}"
        log_tag "Tags for $service:"
        git tag -l "${prefix}*" --sort=-version:refname 2>/dev/null || echo "No tags found"
    fi
    echo ""
}

trigger_n8n_deployment() {
    local service=$1
    local env=$2
    local version=$3
    local tag_name=$4
    
    local webhook_url="${N8N_WEBHOOK_BASE}/deploy-${service}"
    
    log_info "Triggering n8n workflow for $service deployment"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_warning "DRY RUN: Would trigger webhook $webhook_url"
        return 0
    fi
    
    local payload=$(cat <<EOF
{
    "service": "$service",
    "environment": "$env",
    "version": "$version",
    "tag": "$tag_name",
    "commit": "$(git rev-parse HEAD 2>/dev/null || echo 'unknown')",
    "author": "$(git config user.name 2>/dev/null || echo 'unknown')",
    "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "registry": "${REGISTRY:-localhost:5000}"
}
EOF
)
    
    if command -v curl &> /dev/null; then
        response=$(curl -s -X POST \
            -H "Content-Type: application/json" \
            -d "$payload" \
            "$webhook_url" 2>&1 || echo "ERROR")
        
        if [[ "$response" == "ERROR" ]] || [[ "$response" == *"Connection refused"* ]]; then
            log_warning "Failed to trigger n8n webhook (is n8n running?)"
        else
            log_success "n8n webhook triggered successfully"
        fi
    else
        log_warning "curl not found, skipping webhook trigger"
    fi
}

tag_deploy() {
    local service=$1
    local env=$2
    local version=$3
    local commit=${4:-HEAD}
    local message=${5:-"Deploy $service v$version to $env"}
    
    local tag_name=$(generate_tag_name "$service" "$env" "$version")
    
    log_tag "Starting deployment workflow for $service v$version to $env"
    
    # Create and push tag
    tag_create "$service" "$env" "$version" "$commit" "$message"
    tag_push "$tag_name"
    
    # Trigger n8n workflow
    trigger_n8n_deployment "$service" "$env" "$version" "$tag_name"
    
    log_success "Deployment initiated for $service v$version to $env"
    log_info "Tag: $tag_name"
    if [[ -n "$REPO_URL" ]]; then
        log_info "Monitor deployment: ${GITEA_URL}/$(echo $REPO_URL | sed 's/.*://;s/.git$//')/actions"
    fi
}

tag_rollback() {
    local service=$1
    local env=$2
    local version=$3
    
    local tag_name=$(generate_tag_name "$service" "$env" "$version")
    
    if ! git rev-parse "$tag_name" >/dev/null 2>&1; then
        log_error "Tag $tag_name does not exist"
        exit 1
    fi
    
    local commit=$(git rev-parse "$tag_name")
    
    log_warning "Rolling back $service in $env to version $version (commit: $commit)"
    
    if [[ "$env" == "prod" && "$FORCE" != "true" ]]; then
        read -p "Are you sure you want to rollback production? (yes/no): " confirm
        if [[ "$confirm" != "yes" ]]; then
            log_info "Rollback cancelled"
            exit 0
        fi
    fi
    
    trigger_n8n_deployment "$service" "$env" "$version" "$tag_name"
    
    log_success "Rollback initiated for $service to version $version in $env"
}

tag_status() {
    local service=$1
    local version=$2
    local env=$3
    
    log_tag "Checking deployment status for $service v$version in $env"
    
    if command -v curl &> /dev/null; then
        local status_url="${N8N_WEBHOOK_BASE}/deployment-status?service=${service}&version=${version}&env=${env}"
        local response=$(curl -s "$status_url" 2>/dev/null || echo "{}")
        
        if [[ "$response" == "{}" ]] || [[ "$response" == *"Connection refused"* ]]; then
            log_warning "Could not connect to n8n (is it running?)"
            log_info "Check manually: $status_url"
        else
            echo "$response" | jq '.' 2>/dev/null || echo "$response"
        fi
    else
        log_warning "curl not found, cannot check status"
    fi
}

# ============================================================================
# DATABASE MANAGEMENT FUNCTIONS
# ============================================================================

db_backup() {
    local db_name=${1:-"all"}
    local backup_file=$2
    local compress=${3:-false}
    local timestamp=$(date +%Y%m%d-%H%M%S)
    
    mkdir -p "$BACKUP_DIR"
    
    if [[ "$db_name" == "all" ]]; then
        log_db "Backing up all databases..."
        for db in "${!DATABASES[@]}"; do
            db_backup "$db" "" "$compress"
        done
        log_success "All databases backed up to $BACKUP_DIR"
        return 0
    fi
    
    if [[ ! -v "DATABASES[$db_name]" ]]; then
        log_error "Unknown database: $db_name"
        log_info "Available databases: ${!DATABASES[@]}"
        exit 1
    fi
    
    if [[ -z "$backup_file" ]]; then
        backup_file="${BACKUP_DIR}/${db_name}_${timestamp}.sql"
        if [[ "$compress" == "true" ]]; then
            backup_file="${backup_file}.gz"
        fi
    fi
    
    log_db "Backing up database: $db_name"
    log_info "Backup file: $backup_file"
    
    if [[ "$compress" == "true" ]]; then
        docker exec "$POSTGRES_CONTAINER" pg_dump -U "$DB_USER" "$db_name" | gzip > "$backup_file"
    else
        docker exec "$POSTGRES_CONTAINER" pg_dump -U "$DB_USER" "$db_name" > "$backup_file"
    fi
    
    if [[ $? -eq 0 ]]; then
        local size=$(du -h "$backup_file" | cut -f1)
        log_success "Database $db_name backed up successfully ($size)"
    else
        log_error "Backup failed for database: $db_name"
        exit 1
    fi
}

db_restore() {
    local backup_file=$1
    local db_name=$2
    
    if [[ -z "$backup_file" ]]; then
        log_error "Backup file required"
        log_info "Usage: kompose db restore -f BACKUP_FILE [-d DATABASE]"
        exit 1
    fi
    
    if [[ ! -f "$backup_file" ]]; then
        log_error "Backup file not found: $backup_file"
        exit 1
    fi
    
    # Auto-detect database name from filename if not provided
    if [[ -z "$db_name" ]]; then
        db_name=$(basename "$backup_file" | sed -E 's/^([^_]+)_.*/\1/')
        log_info "Auto-detected database: $db_name"
    fi
    
    if [[ ! -v "DATABASES[$db_name]" ]]; then
        log_error "Unknown database: $db_name"
        log_info "Available databases: ${!DATABASES[@]}"
        exit 1
    fi
    
    log_warning "Restoring database: $db_name from $backup_file"
    read -p "This will overwrite the existing database. Continue? (yes/no): " confirm
    
    if [[ "$confirm" != "yes" ]]; then
        log_info "Restore cancelled"
        exit 0
    fi
    
    log_db "Dropping existing database..."
    docker exec "$POSTGRES_CONTAINER" psql -U "$DB_USER" -c "DROP DATABASE IF EXISTS $db_name;"
    docker exec "$POSTGRES_CONTAINER" psql -U "$DB_USER" -c "CREATE DATABASE $db_name;"
    
    log_db "Restoring from backup..."
    if [[ "$backup_file" == *.gz ]]; then
        gunzip -c "$backup_file" | docker exec -i "$POSTGRES_CONTAINER" psql -U "$DB_USER" "$db_name"
    else
        docker exec -i "$POSTGRES_CONTAINER" psql -U "$DB_USER" "$db_name" < "$backup_file"
    fi
    
    if [[ $? -eq 0 ]]; then
        log_success "Database $db_name restored successfully"
    else
        log_error "Restore failed"
        exit 1
    fi
}

db_list() {
    echo ""
    log_db "Available database backups:"
    echo ""
    
    if [[ ! -d "$BACKUP_DIR" ]]; then
        log_warning "No backup directory found: $BACKUP_DIR"
        return 0
    fi
    
    find "$BACKUP_DIR" -name "*.sql" -o -name "*.sql.gz" | sort -r | while read -r file; do
        local size=$(du -h "$file" | cut -f1)
        local date=$(stat -c %y "$file" 2>/dev/null || stat -f %Sm "$file" 2>/dev/null || echo "unknown")
        echo -e "  📦 $(basename $file) - $size - $date"
    done
    
    echo ""
}

db_status() {
    log_db "Database status:"
    echo ""
    
    if ! docker ps | grep -q "$POSTGRES_CONTAINER"; then
        log_error "PostgreSQL container is not running"
        log_info "Start with: kompose up home"
        exit 1
    fi
    
    log_success "PostgreSQL container is running"
    echo ""
    
    log_info "Available databases:"
    docker exec "$POSTGRES_CONTAINER" psql -U "$DB_USER" -c "\l" | grep -E "^\s*(kompose|n8n|gitea)" || echo "No databases found"
    echo ""
    
    log_info "Database sizes:"
    for db in "${!DATABASES[@]}"; do
        local size=$(docker exec "$POSTGRES_CONTAINER" psql -U "$DB_USER" -d "$db" -c "SELECT pg_size_pretty(pg_database_size('$db'));" -t 2>/dev/null | xargs)
        if [[ -n "$size" ]]; then
            echo -e "  ${CYAN}$db${NC}: $size - ${DATABASES[$db]}"
        fi
    done
    echo ""
    
    log_info "Active connections:"
    docker exec "$POSTGRES_CONTAINER" psql -U "$DB_USER" -c "SELECT datname, count(*) FROM pg_stat_activity GROUP BY datname;"
    echo ""
}

db_exec() {
    local db_name=$1
    local sql_command=$2
    
    if [[ -z "$db_name" || -z "$sql_command" ]]; then
        log_error "Database name and SQL command required"
        log_info "Usage: kompose db exec -d DATABASE \"SQL COMMAND\""
        exit 1
    fi
    
    if [[ ! -v "DATABASES[$db_name]" ]]; then
        log_error "Unknown database: $db_name"
        log_info "Available databases: ${!DATABASES[@]}"
        exit 1
    fi
    
    log_db "Executing SQL on database: $db_name"
    docker exec "$POSTGRES_CONTAINER" psql -U "$DB_USER" -d "$db_name" -c "$sql_command"
}

db_shell() {
    local db_name=${1:-kompose}
    
    if [[ ! -v "DATABASES[$db_name]" ]]; then
        log_error "Unknown database: $db_name"
        log_info "Available databases: ${!DATABASES[@]}"
        exit 1
    fi
    
    log_db "Opening shell for database: $db_name"
    log_info "Type \\q to exit"
    echo ""
    
    docker exec -it "$POSTGRES_CONTAINER" psql -U "$DB_USER" -d "$db_name"
}

db_migrate() {
    local db_name=${1:-kompose}
    
    if [[ ! -v "DATABASES[$db_name]" ]]; then
        log_error "Unknown database: $db_name"
        log_info "Available databases: ${!DATABASES[@]}"
        exit 1
    fi
    
    log_db "Running migrations for database: $db_name"
    
    case $db_name in
        n8n)
            log_info "n8n handles migrations automatically on startup"
            log_info "Restart n8n: kompose restart chain"
            ;;
        gitea)
            log_info "Gitea handles migrations automatically on startup"
            log_info "Restart gitea: kompose restart chain"
            ;;
        kompose)
            local migrations_dir="./migrations"
            if [[ ! -d "$migrations_dir" ]]; then
                log_warning "No migrations directory found: $migrations_dir"
                return 0
            fi
            
            log_info "Applying migrations from $migrations_dir"
            for migration in "$migrations_dir"/*.sql; do
                if [[ -f "$migration" ]]; then
                    log_info "Applying: $(basename $migration)"
                    docker exec -i "$POSTGRES_CONTAINER" psql -U "$DB_USER" -d "$db_name" < "$migration"
                fi
            done
            log_success "Migrations completed"
            ;;
    esac
}

db_reset() {
    local db_name=$1
    
    if [[ -z "$db_name" ]]; then
        log_error "Database name required"
        log_info "Usage: kompose db reset -d DATABASE"
        exit 1
    fi
    
    if [[ ! -v "DATABASES[$db_name]" ]]; then
        log_error "Unknown database: $db_name"
        log_info "Available databases: ${!DATABASES[@]}"
        exit 1
    fi
    
    log_warning "⚠️  WARNING: This will DELETE ALL DATA in database: $db_name"
    read -p "Type the database name to confirm: " confirm
    
    if [[ "$confirm" != "$db_name" ]]; then
        log_info "Reset cancelled"
        exit 0
    fi
    
    log_db "Resetting database: $db_name"
    
    # Create backup first
    log_info "Creating backup before reset..."
    db_backup "$db_name" "" false
    
    # Drop and recreate
    docker exec "$POSTGRES_CONTAINER" psql -U "$DB_USER" -c "DROP DATABASE IF EXISTS $db_name;"
    docker exec "$POSTGRES_CONTAINER" psql -U "$DB_USER" -c "CREATE DATABASE $db_name;"
    
    log_success "Database $db_name has been reset"
    log_info "Backup saved to: $BACKUP_DIR"
}

# ============================================================================
# MAIN COMMAND ROUTER
# ============================================================================

main() {
    if [ $# -eq 0 ]; then
        usage
    fi
    
    local command=$1
    shift
    
    # Handle API subcommands
    if [ "$command" = "api" ]; then
        if [ $# -eq 0 ]; then
            log_error "API subcommand required"
            echo ""
            echo "Available API commands:"
            echo "  start [PORT] [HOST]  - Start REST API server"
            echo "  stop                 - Stop REST API server"
            echo "  status               - Check server status"
            echo "  logs                 - View server logs"
            echo ""
            echo "Example: kompose api start 9000"
            exit 1
        fi
        
        local api_cmd=$1
        shift
        
        case $api_cmd in
            start)
                local port="${1:-$API_PORT}"
                local host="${2:-$API_HOST}"
                api_start "$port" "$host"
                ;;
            stop)
                api_stop
                ;;
            status)
                api_status
                ;;
            logs)
                api_logs
                ;;
            *)
                log_error "Unknown API command: $api_cmd"
                echo "Available: start, stop, status, logs"
                exit 1
                ;;
        esac
        
        return 0
    fi
    
    # Handle tag subcommands
    if [ "$command" = "tag" ]; then
        if [ $# -eq 0 ]; then
            log_error "Tag subcommand required"
            echo ""
            echo "Available tag commands:"
            echo "  create, deploy, move, delete, list, rollback, status"
            echo ""
            echo "Example: kompose tag deploy -s frontend -e dev -v 1.0.0"
            exit 1
        fi
        
        local tag_cmd=$1
        shift
        
        # Parse tag options
        TAG_SERVICE=""
        TAG_ENV=""
        TAG_VERSION=""
        TAG_COMMIT=""
        TAG_MESSAGE=""
        FORCE=false
        DRY_RUN=false
        
        while [ $# -gt 0 ]; do
            case $1 in
                -s|--service)
                    TAG_SERVICE="$2"
                    shift 2
                    ;;
                -e|--env)
                    TAG_ENV="$2"
                    shift 2
                    ;;
                -v|--version)
                    TAG_VERSION="$2"
                    shift 2
                    ;;
                -c|--commit)
                    TAG_COMMIT="$2"
                    shift 2
                    ;;
                -m|--message)
                    TAG_MESSAGE="$2"
                    shift 2
                    ;;
                -f|--force)
                    FORCE=true
                    shift
                    ;;
                -d|--dry-run)
                    DRY_RUN=true
                    shift
                    ;;
                *)
                    # Positional arguments for tag status
                    if [ "$tag_cmd" = "status" ]; then
                        if [ -z "$TAG_SERVICE" ]; then
                            TAG_SERVICE="$1"
                        elif [ -z "$TAG_VERSION" ]; then
                            TAG_VERSION="$1"
                        elif [ -z "$TAG_ENV" ]; then
                            TAG_ENV="$1"
                        fi
                        shift
                    else
                        log_error "Unknown option: $1"
                        exit 1
                    fi
                    ;;
            esac
        done
        
        validate_tag_inputs
        
        case $tag_cmd in
            create)
                [[ -z "$TAG_SERVICE" || -z "$TAG_ENV" || -z "$TAG_VERSION" ]] && \
                    { log_error "Required: -s SERVICE -e ENV -v VERSION"; exit 1; }
                tag_create "$TAG_SERVICE" "$TAG_ENV" "$TAG_VERSION" "${TAG_COMMIT:-HEAD}" "$TAG_MESSAGE"
                ;;
            deploy)
                [[ -z "$TAG_SERVICE" || -z "$TAG_ENV" || -z "$TAG_VERSION" ]] && \
                    { log_error "Required: -s SERVICE -e ENV -v VERSION"; exit 1; }
                tag_deploy "$TAG_SERVICE" "$TAG_ENV" "$TAG_VERSION" "${TAG_COMMIT:-HEAD}" "$TAG_MESSAGE"
                ;;
            move)
                [[ -z "$TAG_SERVICE" || -z "$TAG_ENV" || -z "$TAG_VERSION" || -z "$TAG_COMMIT" ]] && \
                    { log_error "Required: -s SERVICE -e ENV -v VERSION -c COMMIT"; exit 1; }
                tag_move "$TAG_SERVICE" "$TAG_ENV" "$TAG_VERSION" "$TAG_COMMIT"
                ;;
            delete)
                [[ -z "$TAG_SERVICE" || -z "$TAG_ENV" || -z "$TAG_VERSION" ]] && \
                    { log_error "Required: -s SERVICE -e ENV -v VERSION"; exit 1; }
                tag_delete "$TAG_SERVICE" "$TAG_ENV" "$TAG_VERSION"
                ;;
            list)
                tag_list "$TAG_SERVICE"
                ;;
            rollback)
                [[ -z "$TAG_SERVICE" || -z "$TAG_ENV" || -z "$TAG_VERSION" ]] && \
                    { log_error "Required: -s SERVICE -e ENV -v VERSION"; exit 1; }
                tag_rollback "$TAG_SERVICE" "$TAG_ENV" "$TAG_VERSION"
                ;;
            status)
                [[ -z "$TAG_SERVICE" || -z "$TAG_VERSION" || -z "$TAG_ENV" ]] && \
                    { log_error "Required: SERVICE VERSION ENV or -s -v -e"; exit 1; }
                tag_status "$TAG_SERVICE" "$TAG_VERSION" "$TAG_ENV"
                ;;
            *)
                log_error "Unknown tag command: $tag_cmd"
                echo "Available: create, deploy, move, delete, list, rollback, status"
                exit 1
                ;;
        esac
        
        return 0
    fi
    
    # Handle database subcommands
    if [ "$command" = "db" ]; then
        if [ $# -eq 0 ]; then
            log_error "Database subcommand required"
            echo ""
            echo "Available database commands:"
            echo "  backup, restore, list, status, exec, shell, migrate, reset"
            echo ""
            echo "Example: kompose db backup -d postgres"
            exit 1
        fi
        
        local db_cmd=$1
        shift
        
        # Parse database options
        DB_NAME=""
        DB_FILE=""
        DB_COMPRESS=false
        DB_TIMESTAMP=false
        DB_SQL=""
        
        while [ $# -gt 0 ]; do
            case $1 in
                -d|--database)
                    DB_NAME="$2"
                    shift 2
                    ;;
                -f|--file)
                    DB_FILE="$2"
                    shift 2
                    ;;
                --compress)
                    DB_COMPRESS=true
                    shift
                    ;;
                --timestamp|-t)
                    DB_TIMESTAMP=true
                    shift
                    ;;
                *)
                    # Positional argument (SQL command for exec)
                    if [ "$db_cmd" = "exec" ]; then
                        DB_SQL="$1"
                        shift
                    elif [ "$db_cmd" = "shell" ] || [ "$db_cmd" = "migrate" ] || [ "$db_cmd" = "reset" ]; then
                        if [ -z "$DB_NAME" ]; then
                            DB_NAME="$1"
                        fi
                        shift
                    else
                        log_error "Unknown option: $1"
                        exit 1
                    fi
                    ;;
            esac
        done
        
        case $db_cmd in
            backup)
                db_backup "${DB_NAME:-all}" "$DB_FILE" "$DB_COMPRESS"
                ;;
            restore)
                db_restore "$DB_FILE" "$DB_NAME"
                ;;
            list)
                db_list
                ;;
            status)
                db_status
                ;;
            exec)
                [[ -z "$DB_NAME" || -z "$DB_SQL" ]] && \
                    { log_error "Required: -d DATABASE \"SQL COMMAND\""; exit 1; }
                db_exec "$DB_NAME" "$DB_SQL"
                ;;
            shell)
                db_shell "${DB_NAME:-kompose}"
                ;;
            migrate)
                db_migrate "${DB_NAME:-kompose}"
                ;;
            reset)
                [[ -z "$DB_NAME" ]] && \
                    { log_error "Required: -d DATABASE"; exit 1; }
                db_reset "$DB_NAME"
                ;;
            *)
                log_error "Unknown database command: $db_cmd"
                echo "Available: backup, restore, list, status, exec, shell, migrate, reset"
                exit 1
                ;;
        esac
        
        return 0
    fi
    
    # Handle stack management commands
    case $command in
        up)
            if [ $# -eq 0 ]; then
                process_all_stacks "up" "$@"
            else
                local stack=$1
                shift
                if stack_exists "$stack"; then
                    stack_up "$stack" true "$@"
                fi
            fi
            ;;
        down)
            if [ $# -eq 0 ]; then
                process_all_stacks "down" "$@"
            else
                local stack=$1
                shift
                local force=false
                if [ "$1" = "-f" ] || [ "$1" = "--force" ]; then
                    force=true
                fi
                if stack_exists "$stack"; then
                    stack_down "$stack" "$force"
                fi
            fi
            ;;
        restart)
            if [ $# -eq 0 ]; then
                process_all_stacks "restart" "$@"
            else
                local stack=$1
                shift
                if stack_exists "$stack"; then
                    stack_restart "$stack" "$@"
                fi
            fi
            ;;
        status)
            if [ $# -eq 0 ]; then
                process_all_stacks "status" "$@"
            else
                local stack=$1
                if stack_exists "$stack"; then
                    stack_status "$stack"
                fi
            fi
            ;;
        logs)
            if [ $# -eq 0 ]; then
                log_error "Stack name required for logs"
                exit 1
            fi
            local stack=$1
            shift
            if stack_exists "$stack"; then
                stack_logs "$stack" "$@"
            fi
            ;;
        pull)
            if [ $# -eq 0 ]; then
                process_all_stacks "pull" "$@"
            else
                local stack=$1
                shift
                if stack_exists "$stack"; then
                    stack_pull "$stack" "$@"
                fi
            fi
            ;;
        build)
            if [ $# -eq 0 ]; then
                log_error "Stack name required for build"
                exit 1
            fi
            local stack=$1
            shift
            local no_cache=false
            if [ "$1" = "--no-cache" ]; then
                no_cache=true
            fi
            if stack_exists "$stack"; then
                stack_build "$stack" "$no_cache"
            fi
            ;;
        deploy)
            if [ $# -lt 2 ]; then
                log_error "Stack name and version required for deploy"
                log_info "Usage: kompose deploy STACK VERSION"
                exit 1
            fi
            local stack=$1
            local version=$2
            if stack_exists "$stack"; then
                stack_deploy "$stack" "$version"
            fi
            ;;
        list)
            list_stacks
            ;;
        validate)
            if [ $# -eq 0 ]; then
                process_all_stacks "validate" "$@"
            else
                local stack=$1
                if stack_exists "$stack"; then
                    stack_validate "$stack"
                fi
            fi
            ;;
        exec)
            if [ $# -lt 2 ]; then
                log_error "Stack name and command required for exec"
                exit 1
            fi
            local stack=$1
            shift
            if stack_exists "$stack"; then
                stack_exec "$stack" "$@"
            fi
            ;;
        ps)
            show_all_containers
            ;;
        help|--help|-h)
            usage
            ;;
        *)
            log_error "Unknown command: $command"
            usage
            ;;
    esac
}

main "$@"
\r'/\\r}"
    str="${str//

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
            stacks+=($(basename "$dir"))
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

# ============================================================================
# GIT TAG DEPLOYMENT FUNCTIONS
# ============================================================================

validate_tag_inputs() {
    if [[ -n "$TAG_SERVICE" && ! -v "TAG_SERVICES[$TAG_SERVICE]" ]]; then
        log_error "Invalid service: $TAG_SERVICE"
        log_info "Available services: ${!TAG_SERVICES[@]}"
        exit 1
    fi

    if [[ -n "$TAG_ENV" && ! -v "ENVIRONMENTS[$TAG_ENV]" ]]; then
        log_error "Invalid environment: $TAG_ENV"
        log_info "Available environments: ${!ENVIRONMENTS[@]}"
        exit 1
    fi

    if [[ -n "$TAG_VERSION" && ! "$TAG_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9]+)?$ ]]; then
        log_error "Invalid version format: $TAG_VERSION (expected: X.Y.Z)"
        exit 1
    fi
}

generate_tag_name() {
    local service=$1
    local env=$2
    local version=$3
    
    echo "${TAG_SERVICES[$service]}${version}-${env}"
}

tag_create() {
    local service=$1
    local env=$2
    local version=$3
    local commit=${4:-HEAD}
    local message=${5:-"Deploy $service v$version to $env"}
    
    local tag_name=$(generate_tag_name "$service" "$env" "$version")
    
    log_tag "Creating tag: $tag_name at commit $commit"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_warning "DRY RUN: Would create tag $tag_name"
        return 0
    fi
    
    if git rev-parse "$tag_name" >/dev/null 2>&1; then
        if [[ "$FORCE" == "true" ]]; then
            log_warning "Tag $tag_name already exists. Deleting..."
            git tag -d "$tag_name"
        else
            log_error "Tag $tag_name already exists. Use -f to force."
            exit 1
        fi
    fi
    
    git tag -a "$tag_name" "$commit" -m "$message"
    log_success "Tag created: $tag_name"
}

tag_push() {
    local tag_name=$1
    
    log_tag "Pushing tag: $tag_name to remote"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_warning "DRY RUN: Would push tag $tag_name"
        return 0
    fi
    
    if [[ "$FORCE" == "true" ]]; then
        git push origin "$tag_name" --force
    else
        git push origin "$tag_name"
    fi
    
    log_success "Tag pushed: $tag_name"
}

tag_delete() {
    local service=$1
    local env=$2
    local version=$3
    
    local tag_name=$(generate_tag_name "$service" "$env" "$version")
    
    log_warning "Deleting tag: $tag_name"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_warning "DRY RUN: Would delete tag $tag_name"
        return 0
    fi
    
    if [[ "$env" == "prod" && "$FORCE" != "true" ]]; then
        read -p "Are you sure you want to delete production tag $tag_name? (yes/no): " confirm
        if [[ "$confirm" != "yes" ]]; then
            log_info "Deletion cancelled"
            exit 0
        fi
    fi
    
    git tag -d "$tag_name" 2>/dev/null || log_warning "Local tag not found"
    git push origin ":refs/tags/$tag_name" 2>/dev/null || log_warning "Remote tag not found"
    
    log_success "Tag deleted: $tag_name"
}

tag_move() {
    local service=$1
    local env=$2
    local version=$3
    local new_commit=$4
    
    local tag_name=$(generate_tag_name "$service" "$env" "$version")
    
    log_tag "Moving tag $tag_name to commit $new_commit"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_warning "DRY RUN: Would move tag $tag_name to $new_commit"
        return 0
    fi
    
    git tag -d "$tag_name" 2>/dev/null || true
    git push origin ":refs/tags/$tag_name" 2>/dev/null || true
    
    tag_create "$service" "$env" "$version" "$new_commit" "Moved tag to $new_commit"
    tag_push "$tag_name"
}

tag_list() {
    local service=${1:-}
    
    echo ""
    if [[ -z "$service" ]]; then
        log_tag "All deployment tags:"
        git tag -l "*-v*-*" --sort=-version:refname 2>/dev/null || echo "No tags found"
    else
        if [[ ! -v "TAG_SERVICES[$service]" ]]; then
            log_error "Invalid service: $service"
            log_info "Available services: ${!TAG_SERVICES[@]}"
            exit 1
        fi
        local prefix="${TAG_SERVICES[$service]}"
        log_tag "Tags for $service:"
        git tag -l "${prefix}*" --sort=-version:refname 2>/dev/null || echo "No tags found"
    fi
    echo ""
}

trigger_n8n_deployment() {
    local service=$1
    local env=$2
    local version=$3
    local tag_name=$4
    
    local webhook_url="${N8N_WEBHOOK_BASE}/deploy-${service}"
    
    log_info "Triggering n8n workflow for $service deployment"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_warning "DRY RUN: Would trigger webhook $webhook_url"
        return 0
    fi
    
    local payload=$(cat <<EOF
{
    "service": "$service",
    "environment": "$env",
    "version": "$version",
    "tag": "$tag_name",
    "commit": "$(git rev-parse HEAD 2>/dev/null || echo 'unknown')",
    "author": "$(git config user.name 2>/dev/null || echo 'unknown')",
    "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "registry": "${REGISTRY:-localhost:5000}"
}
EOF
)
    
    if command -v curl &> /dev/null; then
        response=$(curl -s -X POST \
            -H "Content-Type: application/json" \
            -d "$payload" \
            "$webhook_url" 2>&1 || echo "ERROR")
        
        if [[ "$response" == "ERROR" ]] || [[ "$response" == *"Connection refused"* ]]; then
            log_warning "Failed to trigger n8n webhook (is n8n running?)"
        else
            log_success "n8n webhook triggered successfully"
        fi
    else
        log_warning "curl not found, skipping webhook trigger"
    fi
}

tag_deploy() {
    local service=$1
    local env=$2
    local version=$3
    local commit=${4:-HEAD}
    local message=${5:-"Deploy $service v$version to $env"}
    
    local tag_name=$(generate_tag_name "$service" "$env" "$version")
    
    log_tag "Starting deployment workflow for $service v$version to $env"
    
    # Create and push tag
    tag_create "$service" "$env" "$version" "$commit" "$message"
    tag_push "$tag_name"
    
    # Trigger n8n workflow
    trigger_n8n_deployment "$service" "$env" "$version" "$tag_name"
    
    log_success "Deployment initiated for $service v$version to $env"
    log_info "Tag: $tag_name"
    if [[ -n "$REPO_URL" ]]; then
        log_info "Monitor deployment: ${GITEA_URL}/$(echo $REPO_URL | sed 's/.*://;s/.git$//')/actions"
    fi
}

tag_rollback() {
    local service=$1
    local env=$2
    local version=$3
    
    local tag_name=$(generate_tag_name "$service" "$env" "$version")
    
    if ! git rev-parse "$tag_name" >/dev/null 2>&1; then
        log_error "Tag $tag_name does not exist"
        exit 1
    fi
    
    local commit=$(git rev-parse "$tag_name")
    
    log_warning "Rolling back $service in $env to version $version (commit: $commit)"
    
    if [[ "$env" == "prod" && "$FORCE" != "true" ]]; then
        read -p "Are you sure you want to rollback production? (yes/no): " confirm
        if [[ "$confirm" != "yes" ]]; then
            log_info "Rollback cancelled"
            exit 0
        fi
    fi
    
    trigger_n8n_deployment "$service" "$env" "$version" "$tag_name"
    
    log_success "Rollback initiated for $service to version $version in $env"
}

tag_status() {
    local service=$1
    local version=$2
    local env=$3
    
    log_tag "Checking deployment status for $service v$version in $env"
    
    if command -v curl &> /dev/null; then
        local status_url="${N8N_WEBHOOK_BASE}/deployment-status?service=${service}&version=${version}&env=${env}"
        local response=$(curl -s "$status_url" 2>/dev/null || echo "{}")
        
        if [[ "$response" == "{}" ]] || [[ "$response" == *"Connection refused"* ]]; then
            log_warning "Could not connect to n8n (is it running?)"
            log_info "Check manually: $status_url"
        else
            echo "$response" | jq '.' 2>/dev/null || echo "$response"
        fi
    else
        log_warning "curl not found, cannot check status"
    fi
}

# ============================================================================
# DATABASE MANAGEMENT FUNCTIONS
# ============================================================================

db_backup() {
    local db_name=${1:-"all"}
    local backup_file=$2
    local compress=${3:-false}
    local timestamp=$(date +%Y%m%d-%H%M%S)
    
    mkdir -p "$BACKUP_DIR"
    
    if [[ "$db_name" == "all" ]]; then
        log_db "Backing up all databases..."
        for db in "${!DATABASES[@]}"; do
            db_backup "$db" "" "$compress"
        done
        log_success "All databases backed up to $BACKUP_DIR"
        return 0
    fi
    
    if [[ ! -v "DATABASES[$db_name]" ]]; then
        log_error "Unknown database: $db_name"
        log_info "Available databases: ${!DATABASES[@]}"
        exit 1
    fi
    
    if [[ -z "$backup_file" ]]; then
        backup_file="${BACKUP_DIR}/${db_name}_${timestamp}.sql"
        if [[ "$compress" == "true" ]]; then
            backup_file="${backup_file}.gz"
        fi
    fi
    
    log_db "Backing up database: $db_name"
    log_info "Backup file: $backup_file"
    
    if [[ "$compress" == "true" ]]; then
        docker exec "$POSTGRES_CONTAINER" pg_dump -U "$DB_USER" "$db_name" | gzip > "$backup_file"
    else
        docker exec "$POSTGRES_CONTAINER" pg_dump -U "$DB_USER" "$db_name" > "$backup_file"
    fi
    
    if [[ $? -eq 0 ]]; then
        local size=$(du -h "$backup_file" | cut -f1)
        log_success "Database $db_name backed up successfully ($size)"
    else
        log_error "Backup failed for database: $db_name"
        exit 1
    fi
}

db_restore() {
    local backup_file=$1
    local db_name=$2
    
    if [[ -z "$backup_file" ]]; then
        log_error "Backup file required"
        log_info "Usage: kompose db restore -f BACKUP_FILE [-d DATABASE]"
        exit 1
    fi
    
    if [[ ! -f "$backup_file" ]]; then
        log_error "Backup file not found: $backup_file"
        exit 1
    fi
    
    # Auto-detect database name from filename if not provided
    if [[ -z "$db_name" ]]; then
        db_name=$(basename "$backup_file" | sed -E 's/^([^_]+)_.*/\1/')
        log_info "Auto-detected database: $db_name"
    fi
    
    if [[ ! -v "DATABASES[$db_name]" ]]; then
        log_error "Unknown database: $db_name"
        log_info "Available databases: ${!DATABASES[@]}"
        exit 1
    fi
    
    log_warning "Restoring database: $db_name from $backup_file"
    read -p "This will overwrite the existing database. Continue? (yes/no): " confirm
    
    if [[ "$confirm" != "yes" ]]; then
        log_info "Restore cancelled"
        exit 0
    fi
    
    log_db "Dropping existing database..."
    docker exec "$POSTGRES_CONTAINER" psql -U "$DB_USER" -c "DROP DATABASE IF EXISTS $db_name;"
    docker exec "$POSTGRES_CONTAINER" psql -U "$DB_USER" -c "CREATE DATABASE $db_name;"
    
    log_db "Restoring from backup..."
    if [[ "$backup_file" == *.gz ]]; then
        gunzip -c "$backup_file" | docker exec -i "$POSTGRES_CONTAINER" psql -U "$DB_USER" "$db_name"
    else
        docker exec -i "$POSTGRES_CONTAINER" psql -U "$DB_USER" "$db_name" < "$backup_file"
    fi
    
    if [[ $? -eq 0 ]]; then
        log_success "Database $db_name restored successfully"
    else
        log_error "Restore failed"
        exit 1
    fi
}

db_list() {
    echo ""
    log_db "Available database backups:"
    echo ""
    
    if [[ ! -d "$BACKUP_DIR" ]]; then
        log_warning "No backup directory found: $BACKUP_DIR"
        return 0
    fi
    
    find "$BACKUP_DIR" -name "*.sql" -o -name "*.sql.gz" | sort -r | while read -r file; do
        local size=$(du -h "$file" | cut -f1)
        local date=$(stat -c %y "$file" 2>/dev/null || stat -f %Sm "$file" 2>/dev/null || echo "unknown")
        echo -e "  📦 $(basename $file) - $size - $date"
    done
    
    echo ""
}

db_status() {
    log_db "Database status:"
    echo ""
    
    if ! docker ps | grep -q "$POSTGRES_CONTAINER"; then
        log_error "PostgreSQL container is not running"
        log_info "Start with: kompose up home"
        exit 1
    fi
    
    log_success "PostgreSQL container is running"
    echo ""
    
    log_info "Available databases:"
    docker exec "$POSTGRES_CONTAINER" psql -U "$DB_USER" -c "\l" | grep -E "^\s*(kompose|n8n|gitea)" || echo "No databases found"
    echo ""
    
    log_info "Database sizes:"
    for db in "${!DATABASES[@]}"; do
        local size=$(docker exec "$POSTGRES_CONTAINER" psql -U "$DB_USER" -d "$db" -c "SELECT pg_size_pretty(pg_database_size('$db'));" -t 2>/dev/null | xargs)
        if [[ -n "$size" ]]; then
            echo -e "  ${CYAN}$db${NC}: $size - ${DATABASES[$db]}"
        fi
    done
    echo ""
    
    log_info "Active connections:"
    docker exec "$POSTGRES_CONTAINER" psql -U "$DB_USER" -c "SELECT datname, count(*) FROM pg_stat_activity GROUP BY datname;"
    echo ""
}

db_exec() {
    local db_name=$1
    local sql_command=$2
    
    if [[ -z "$db_name" || -z "$sql_command" ]]; then
        log_error "Database name and SQL command required"
        log_info "Usage: kompose db exec -d DATABASE \"SQL COMMAND\""
        exit 1
    fi
    
    if [[ ! -v "DATABASES[$db_name]" ]]; then
        log_error "Unknown database: $db_name"
        log_info "Available databases: ${!DATABASES[@]}"
        exit 1
    fi
    
    log_db "Executing SQL on database: $db_name"
    docker exec "$POSTGRES_CONTAINER" psql -U "$DB_USER" -d "$db_name" -c "$sql_command"
}

db_shell() {
    local db_name=${1:-kompose}
    
    if [[ ! -v "DATABASES[$db_name]" ]]; then
        log_error "Unknown database: $db_name"
        log_info "Available databases: ${!DATABASES[@]}"
        exit 1
    fi
    
    log_db "Opening shell for database: $db_name"
    log_info "Type \\q to exit"
    echo ""
    
    docker exec -it "$POSTGRES_CONTAINER" psql -U "$DB_USER" -d "$db_name"
}

db_migrate() {
    local db_name=${1:-kompose}
    
    if [[ ! -v "DATABASES[$db_name]" ]]; then
        log_error "Unknown database: $db_name"
        log_info "Available databases: ${!DATABASES[@]}"
        exit 1
    fi
    
    log_db "Running migrations for database: $db_name"
    
    case $db_name in
        n8n)
            log_info "n8n handles migrations automatically on startup"
            log_info "Restart n8n: kompose restart chain"
            ;;
        gitea)
            log_info "Gitea handles migrations automatically on startup"
            log_info "Restart gitea: kompose restart chain"
            ;;
        kompose)
            local migrations_dir="./migrations"
            if [[ ! -d "$migrations_dir" ]]; then
                log_warning "No migrations directory found: $migrations_dir"
                return 0
            fi
            
            log_info "Applying migrations from $migrations_dir"
            for migration in "$migrations_dir"/*.sql; do
                if [[ -f "$migration" ]]; then
                    log_info "Applying: $(basename $migration)"
                    docker exec -i "$POSTGRES_CONTAINER" psql -U "$DB_USER" -d "$db_name" < "$migration"
                fi
            done
            log_success "Migrations completed"
            ;;
    esac
}

db_reset() {
    local db_name=$1
    
    if [[ -z "$db_name" ]]; then
        log_error "Database name required"
        log_info "Usage: kompose db reset -d DATABASE"
        exit 1
    fi
    
    if [[ ! -v "DATABASES[$db_name]" ]]; then
        log_error "Unknown database: $db_name"
        log_info "Available databases: ${!DATABASES[@]}"
        exit 1
    fi
    
    log_warning "⚠️  WARNING: This will DELETE ALL DATA in database: $db_name"
    read -p "Type the database name to confirm: " confirm
    
    if [[ "$confirm" != "$db_name" ]]; then
        log_info "Reset cancelled"
        exit 0
    fi
    
    log_db "Resetting database: $db_name"
    
    # Create backup first
    log_info "Creating backup before reset..."
    db_backup "$db_name" "" false
    
    # Drop and recreate
    docker exec "$POSTGRES_CONTAINER" psql -U "$DB_USER" -c "DROP DATABASE IF EXISTS $db_name;"
    docker exec "$POSTGRES_CONTAINER" psql -U "$DB_USER" -c "CREATE DATABASE $db_name;"
    
    log_success "Database $db_name has been reset"
    log_info "Backup saved to: $BACKUP_DIR"
}

# ============================================================================
# MAIN COMMAND ROUTER
# ============================================================================

main() {
    if [ $# -eq 0 ]; then
        usage
    fi
    
    local command=$1
    shift
    
    # Handle tag subcommands
    if [ "$command" = "tag" ]; then
        if [ $# -eq 0 ]; then
            log_error "Tag subcommand required"
            echo ""
            echo "Available tag commands:"
            echo "  create, deploy, move, delete, list, rollback, status"
            echo ""
            echo "Example: kompose tag deploy -s frontend -e dev -v 1.0.0"
            exit 1
        fi
        
        local tag_cmd=$1
        shift
        
        # Parse tag options
        TAG_SERVICE=""
        TAG_ENV=""
        TAG_VERSION=""
        TAG_COMMIT=""
        TAG_MESSAGE=""
        FORCE=false
        DRY_RUN=false
        
        while [ $# -gt 0 ]; do
            case $1 in
                -s|--service)
                    TAG_SERVICE="$2"
                    shift 2
                    ;;
                -e|--env)
                    TAG_ENV="$2"
                    shift 2
                    ;;
                -v|--version)
                    TAG_VERSION="$2"
                    shift 2
                    ;;
                -c|--commit)
                    TAG_COMMIT="$2"
                    shift 2
                    ;;
                -m|--message)
                    TAG_MESSAGE="$2"
                    shift 2
                    ;;
                -f|--force)
                    FORCE=true
                    shift
                    ;;
                -d|--dry-run)
                    DRY_RUN=true
                    shift
                    ;;
                *)
                    # Positional arguments for tag status
                    if [ "$tag_cmd" = "status" ]; then
                        if [ -z "$TAG_SERVICE" ]; then
                            TAG_SERVICE="$1"
                        elif [ -z "$TAG_VERSION" ]; then
                            TAG_VERSION="$1"
                        elif [ -z "$TAG_ENV" ]; then
                            TAG_ENV="$1"
                        fi
                        shift
                    else
                        log_error "Unknown option: $1"
                        exit 1
                    fi
                    ;;
            esac
        done
        
        validate_tag_inputs
        
        case $tag_cmd in
            create)
                [[ -z "$TAG_SERVICE" || -z "$TAG_ENV" || -z "$TAG_VERSION" ]] && \
                    { log_error "Required: -s SERVICE -e ENV -v VERSION"; exit 1; }
                tag_create "$TAG_SERVICE" "$TAG_ENV" "$TAG_VERSION" "${TAG_COMMIT:-HEAD}" "$TAG_MESSAGE"
                ;;
            deploy)
                [[ -z "$TAG_SERVICE" || -z "$TAG_ENV" || -z "$TAG_VERSION" ]] && \
                    { log_error "Required: -s SERVICE -e ENV -v VERSION"; exit 1; }
                tag_deploy "$TAG_SERVICE" "$TAG_ENV" "$TAG_VERSION" "${TAG_COMMIT:-HEAD}" "$TAG_MESSAGE"
                ;;
            move)
                [[ -z "$TAG_SERVICE" || -z "$TAG_ENV" || -z "$TAG_VERSION" || -z "$TAG_COMMIT" ]] && \
                    { log_error "Required: -s SERVICE -e ENV -v VERSION -c COMMIT"; exit 1; }
                tag_move "$TAG_SERVICE" "$TAG_ENV" "$TAG_VERSION" "$TAG_COMMIT"
                ;;
            delete)
                [[ -z "$TAG_SERVICE" || -z "$TAG_ENV" || -z "$TAG_VERSION" ]] && \
                    { log_error "Required: -s SERVICE -e ENV -v VERSION"; exit 1; }
                tag_delete "$TAG_SERVICE" "$TAG_ENV" "$TAG_VERSION"
                ;;
            list)
                tag_list "$TAG_SERVICE"
                ;;
            rollback)
                [[ -z "$TAG_SERVICE" || -z "$TAG_ENV" || -z "$TAG_VERSION" ]] && \
                    { log_error "Required: -s SERVICE -e ENV -v VERSION"; exit 1; }
                tag_rollback "$TAG_SERVICE" "$TAG_ENV" "$TAG_VERSION"
                ;;
            status)
                [[ -z "$TAG_SERVICE" || -z "$TAG_VERSION" || -z "$TAG_ENV" ]] && \
                    { log_error "Required: SERVICE VERSION ENV or -s -v -e"; exit 1; }
                tag_status "$TAG_SERVICE" "$TAG_VERSION" "$TAG_ENV"
                ;;
            *)
                log_error "Unknown tag command: $tag_cmd"
                echo "Available: create, deploy, move, delete, list, rollback, status"
                exit 1
                ;;
        esac
        
        return 0
    fi
    
    # Handle database subcommands
    if [ "$command" = "db" ]; then
        if [ $# -eq 0 ]; then
            log_error "Database subcommand required"
            echo ""
            echo "Available database commands:"
            echo "  backup, restore, list, status, exec, shell, migrate, reset"
            echo ""
            echo "Example: kompose db backup -d postgres"
            exit 1
        fi
        
        local db_cmd=$1
        shift
        
        # Parse database options
        DB_NAME=""
        DB_FILE=""
        DB_COMPRESS=false
        DB_TIMESTAMP=false
        DB_SQL=""
        
        while [ $# -gt 0 ]; do
            case $1 in
                -d|--database)
                    DB_NAME="$2"
                    shift 2
                    ;;
                -f|--file)
                    DB_FILE="$2"
                    shift 2
                    ;;
                --compress)
                    DB_COMPRESS=true
                    shift
                    ;;
                --timestamp|-t)
                    DB_TIMESTAMP=true
                    shift
                    ;;
                *)
                    # Positional argument (SQL command for exec)
                    if [ "$db_cmd" = "exec" ]; then
                        DB_SQL="$1"
                        shift
                    elif [ "$db_cmd" = "shell" ] || [ "$db_cmd" = "migrate" ] || [ "$db_cmd" = "reset" ]; then
                        if [ -z "$DB_NAME" ]; then
                            DB_NAME="$1"
                        fi
                        shift
                    else
                        log_error "Unknown option: $1"
                        exit 1
                    fi
                    ;;
            esac
        done
        
        case $db_cmd in
            backup)
                db_backup "${DB_NAME:-all}" "$DB_FILE" "$DB_COMPRESS"
                ;;
            restore)
                db_restore "$DB_FILE" "$DB_NAME"
                ;;
            list)
                db_list
                ;;
            status)
                db_status
                ;;
            exec)
                [[ -z "$DB_NAME" || -z "$DB_SQL" ]] && \
                    { log_error "Required: -d DATABASE \"SQL COMMAND\""; exit 1; }
                db_exec "$DB_NAME" "$DB_SQL"
                ;;
            shell)
                db_shell "${DB_NAME:-kompose}"
                ;;
            migrate)
                db_migrate "${DB_NAME:-kompose}"
                ;;
            reset)
                [[ -z "$DB_NAME" ]] && \
                    { log_error "Required: -d DATABASE"; exit 1; }
                db_reset "$DB_NAME"
                ;;
            *)
                log_error "Unknown database command: $db_cmd"
                echo "Available: backup, restore, list, status, exec, shell, migrate, reset"
                exit 1
                ;;
        esac
        
        return 0
    fi
    
    # Handle stack management commands
    case $command in
        up)
            if [ $# -eq 0 ]; then
                process_all_stacks "up" "$@"
            else
                local stack=$1
                shift
                if stack_exists "$stack"; then
                    stack_up "$stack" true "$@"
                fi
            fi
            ;;
        down)
            if [ $# -eq 0 ]; then
                process_all_stacks "down" "$@"
            else
                local stack=$1
                shift
                local force=false
                if [ "$1" = "-f" ] || [ "$1" = "--force" ]; then
                    force=true
                fi
                if stack_exists "$stack"; then
                    stack_down "$stack" "$force"
                fi
            fi
            ;;
        restart)
            if [ $# -eq 0 ]; then
                process_all_stacks "restart" "$@"
            else
                local stack=$1
                shift
                if stack_exists "$stack"; then
                    stack_restart "$stack" "$@"
                fi
            fi
            ;;
        status)
            if [ $# -eq 0 ]; then
                process_all_stacks "status" "$@"
            else
                local stack=$1
                if stack_exists "$stack"; then
                    stack_status "$stack"
                fi
            fi
            ;;
        logs)
            if [ $# -eq 0 ]; then
                log_error "Stack name required for logs"
                exit 1
            fi
            local stack=$1
            shift
            if stack_exists "$stack"; then
                stack_logs "$stack" "$@"
            fi
            ;;
        pull)
            if [ $# -eq 0 ]; then
                process_all_stacks "pull" "$@"
            else
                local stack=$1
                shift
                if stack_exists "$stack"; then
                    stack_pull "$stack" "$@"
                fi
            fi
            ;;
        build)
            if [ $# -eq 0 ]; then
                log_error "Stack name required for build"
                exit 1
            fi
            local stack=$1
            shift
            local no_cache=false
            if [ "$1" = "--no-cache" ]; then
                no_cache=true
            fi
            if stack_exists "$stack"; then
                stack_build "$stack" "$no_cache"
            fi
            ;;
        deploy)
            if [ $# -lt 2 ]; then
                log_error "Stack name and version required for deploy"
                log_info "Usage: kompose deploy STACK VERSION"
                exit 1
            fi
            local stack=$1
            local version=$2
            if stack_exists "$stack"; then
                stack_deploy "$stack" "$version"
            fi
            ;;
        list)
            list_stacks
            ;;
        validate)
            if [ $# -eq 0 ]; then
                process_all_stacks "validate" "$@"
            else
                local stack=$1
                if stack_exists "$stack"; then
                    stack_validate "$stack"
                fi
            fi
            ;;
        exec)
            if [ $# -lt 2 ]; then
                log_error "Stack name and command required for exec"
                exit 1
            fi
            local stack=$1
            shift
            if stack_exists "$stack"; then
                stack_exec "$stack" "$@"
            fi
            ;;
        ps)
            show_all_containers
            ;;
        help|--help|-h)
            usage
            ;;
        *)
            log_error "Unknown command: $command"
            usage
            ;;
    esac
}

main "$@"
\t'/\\t}"
    echo "$str"
}

json_success() {
    local message="$1"
    local data="${2:-}"
    
    if [ -n "$data" ]; then
        echo "{\"status\":\"success\",\"message\":\"$(json_escape "$message")\",\"data\":$data}"
    else
        echo "{\"status\":\"success\",\"message\":\"$(json_escape "$message")\"}"
    fi
}

json_error() {
    local message="$1"
    local code="${2:-1}"
    
    echo "{\"status\":\"error\",\"message\":\"$(json_escape "$message")\",\"code\":$code}"
}

json_list_stacks() {
    local stacks=$(get_all_stacks)
    local json="{"
    local first=true
    
    for stack in $stacks; do
        if [ "$first" = true ]; then
            first=false
        else
            json="$json,"
        fi
        
        local description="${STACKS[$stack]:-}"
        local running=0
        local total=0
        
        if stack_exists "$stack" 2>/dev/null; then
            cd "${STACKS_ROOT}/${stack}"
            running=$(docker-compose ps -q 2>/dev/null | wc -l)
            total=$(docker-compose config --services 2>/dev/null | wc -l)
        fi
        
        json="$json\"$stack\":{\"description\":\"$(json_escape "$description")\",\"running\":$running,\"total\":$total}"
    done
    
    json="$json}"
    echo "$json"
}

json_stack_status() {
    local stack="$1"
    
    if ! stack_exists "$stack" 2>/dev/null; then
        json_error "Stack not found: $stack" 404
        return 1
    fi
    
    cd "${STACKS_ROOT}/${stack}"
    
    local containers="["
    local first=true
    
    while IFS= read -r line; do
        if [ "$first" = true ]; then
            first=false
        else
            containers="$containers,"
        fi
        
        local name=$(echo "$line" | awk '{print $1}')
        local state=$(echo "$line" | awk '{print $2}')
        local status=$(echo "$line" | awk '{$1=$2=""; print $0}' | xargs)
        
        containers="$containers{\"name\":\"$name\",\"state\":\"$state\",\"status\":\"$(json_escape "$status")\"}"
    done < <(docker-compose ps --format "{{.Name}} {{.State}} {{.Status}}" 2>/dev/null)
    
    containers="$containers]"
    
    json_success "Stack status retrieved" "$containers"
}

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
            stacks+=($(basename "$dir"))
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

# ============================================================================
# GIT TAG DEPLOYMENT FUNCTIONS
# ============================================================================

validate_tag_inputs() {
    if [[ -n "$TAG_SERVICE" && ! -v "TAG_SERVICES[$TAG_SERVICE]" ]]; then
        log_error "Invalid service: $TAG_SERVICE"
        log_info "Available services: ${!TAG_SERVICES[@]}"
        exit 1
    fi

    if [[ -n "$TAG_ENV" && ! -v "ENVIRONMENTS[$TAG_ENV]" ]]; then
        log_error "Invalid environment: $TAG_ENV"
        log_info "Available environments: ${!ENVIRONMENTS[@]}"
        exit 1
    fi

    if [[ -n "$TAG_VERSION" && ! "$TAG_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9]+)?$ ]]; then
        log_error "Invalid version format: $TAG_VERSION (expected: X.Y.Z)"
        exit 1
    fi
}

generate_tag_name() {
    local service=$1
    local env=$2
    local version=$3
    
    echo "${TAG_SERVICES[$service]}${version}-${env}"
}

tag_create() {
    local service=$1
    local env=$2
    local version=$3
    local commit=${4:-HEAD}
    local message=${5:-"Deploy $service v$version to $env"}
    
    local tag_name=$(generate_tag_name "$service" "$env" "$version")
    
    log_tag "Creating tag: $tag_name at commit $commit"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_warning "DRY RUN: Would create tag $tag_name"
        return 0
    fi
    
    if git rev-parse "$tag_name" >/dev/null 2>&1; then
        if [[ "$FORCE" == "true" ]]; then
            log_warning "Tag $tag_name already exists. Deleting..."
            git tag -d "$tag_name"
        else
            log_error "Tag $tag_name already exists. Use -f to force."
            exit 1
        fi
    fi
    
    git tag -a "$tag_name" "$commit" -m "$message"
    log_success "Tag created: $tag_name"
}

tag_push() {
    local tag_name=$1
    
    log_tag "Pushing tag: $tag_name to remote"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_warning "DRY RUN: Would push tag $tag_name"
        return 0
    fi
    
    if [[ "$FORCE" == "true" ]]; then
        git push origin "$tag_name" --force
    else
        git push origin "$tag_name"
    fi
    
    log_success "Tag pushed: $tag_name"
}

tag_delete() {
    local service=$1
    local env=$2
    local version=$3
    
    local tag_name=$(generate_tag_name "$service" "$env" "$version")
    
    log_warning "Deleting tag: $tag_name"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_warning "DRY RUN: Would delete tag $tag_name"
        return 0
    fi
    
    if [[ "$env" == "prod" && "$FORCE" != "true" ]]; then
        read -p "Are you sure you want to delete production tag $tag_name? (yes/no): " confirm
        if [[ "$confirm" != "yes" ]]; then
            log_info "Deletion cancelled"
            exit 0
        fi
    fi
    
    git tag -d "$tag_name" 2>/dev/null || log_warning "Local tag not found"
    git push origin ":refs/tags/$tag_name" 2>/dev/null || log_warning "Remote tag not found"
    
    log_success "Tag deleted: $tag_name"
}

tag_move() {
    local service=$1
    local env=$2
    local version=$3
    local new_commit=$4
    
    local tag_name=$(generate_tag_name "$service" "$env" "$version")
    
    log_tag "Moving tag $tag_name to commit $new_commit"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_warning "DRY RUN: Would move tag $tag_name to $new_commit"
        return 0
    fi
    
    git tag -d "$tag_name" 2>/dev/null || true
    git push origin ":refs/tags/$tag_name" 2>/dev/null || true
    
    tag_create "$service" "$env" "$version" "$new_commit" "Moved tag to $new_commit"
    tag_push "$tag_name"
}

tag_list() {
    local service=${1:-}
    
    echo ""
    if [[ -z "$service" ]]; then
        log_tag "All deployment tags:"
        git tag -l "*-v*-*" --sort=-version:refname 2>/dev/null || echo "No tags found"
    else
        if [[ ! -v "TAG_SERVICES[$service]" ]]; then
            log_error "Invalid service: $service"
            log_info "Available services: ${!TAG_SERVICES[@]}"
            exit 1
        fi
        local prefix="${TAG_SERVICES[$service]}"
        log_tag "Tags for $service:"
        git tag -l "${prefix}*" --sort=-version:refname 2>/dev/null || echo "No tags found"
    fi
    echo ""
}

trigger_n8n_deployment() {
    local service=$1
    local env=$2
    local version=$3
    local tag_name=$4
    
    local webhook_url="${N8N_WEBHOOK_BASE}/deploy-${service}"
    
    log_info "Triggering n8n workflow for $service deployment"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_warning "DRY RUN: Would trigger webhook $webhook_url"
        return 0
    fi
    
    local payload=$(cat <<EOF
{
    "service": "$service",
    "environment": "$env",
    "version": "$version",
    "tag": "$tag_name",
    "commit": "$(git rev-parse HEAD 2>/dev/null || echo 'unknown')",
    "author": "$(git config user.name 2>/dev/null || echo 'unknown')",
    "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "registry": "${REGISTRY:-localhost:5000}"
}
EOF
)
    
    if command -v curl &> /dev/null; then
        response=$(curl -s -X POST \
            -H "Content-Type: application/json" \
            -d "$payload" \
            "$webhook_url" 2>&1 || echo "ERROR")
        
        if [[ "$response" == "ERROR" ]] || [[ "$response" == *"Connection refused"* ]]; then
            log_warning "Failed to trigger n8n webhook (is n8n running?)"
        else
            log_success "n8n webhook triggered successfully"
        fi
    else
        log_warning "curl not found, skipping webhook trigger"
    fi
}

tag_deploy() {
    local service=$1
    local env=$2
    local version=$3
    local commit=${4:-HEAD}
    local message=${5:-"Deploy $service v$version to $env"}
    
    local tag_name=$(generate_tag_name "$service" "$env" "$version")
    
    log_tag "Starting deployment workflow for $service v$version to $env"
    
    # Create and push tag
    tag_create "$service" "$env" "$version" "$commit" "$message"
    tag_push "$tag_name"
    
    # Trigger n8n workflow
    trigger_n8n_deployment "$service" "$env" "$version" "$tag_name"
    
    log_success "Deployment initiated for $service v$version to $env"
    log_info "Tag: $tag_name"
    if [[ -n "$REPO_URL" ]]; then
        log_info "Monitor deployment: ${GITEA_URL}/$(echo $REPO_URL | sed 's/.*://;s/.git$//')/actions"
    fi
}

tag_rollback() {
    local service=$1
    local env=$2
    local version=$3
    
    local tag_name=$(generate_tag_name "$service" "$env" "$version")
    
    if ! git rev-parse "$tag_name" >/dev/null 2>&1; then
        log_error "Tag $tag_name does not exist"
        exit 1
    fi
    
    local commit=$(git rev-parse "$tag_name")
    
    log_warning "Rolling back $service in $env to version $version (commit: $commit)"
    
    if [[ "$env" == "prod" && "$FORCE" != "true" ]]; then
        read -p "Are you sure you want to rollback production? (yes/no): " confirm
        if [[ "$confirm" != "yes" ]]; then
            log_info "Rollback cancelled"
            exit 0
        fi
    fi
    
    trigger_n8n_deployment "$service" "$env" "$version" "$tag_name"
    
    log_success "Rollback initiated for $service to version $version in $env"
}

tag_status() {
    local service=$1
    local version=$2
    local env=$3
    
    log_tag "Checking deployment status for $service v$version in $env"
    
    if command -v curl &> /dev/null; then
        local status_url="${N8N_WEBHOOK_BASE}/deployment-status?service=${service}&version=${version}&env=${env}"
        local response=$(curl -s "$status_url" 2>/dev/null || echo "{}")
        
        if [[ "$response" == "{}" ]] || [[ "$response" == *"Connection refused"* ]]; then
            log_warning "Could not connect to n8n (is it running?)"
            log_info "Check manually: $status_url"
        else
            echo "$response" | jq '.' 2>/dev/null || echo "$response"
        fi
    else
        log_warning "curl not found, cannot check status"
    fi
}

# ============================================================================
# DATABASE MANAGEMENT FUNCTIONS
# ============================================================================

db_backup() {
    local db_name=${1:-"all"}
    local backup_file=$2
    local compress=${3:-false}
    local timestamp=$(date +%Y%m%d-%H%M%S)
    
    mkdir -p "$BACKUP_DIR"
    
    if [[ "$db_name" == "all" ]]; then
        log_db "Backing up all databases..."
        for db in "${!DATABASES[@]}"; do
            db_backup "$db" "" "$compress"
        done
        log_success "All databases backed up to $BACKUP_DIR"
        return 0
    fi
    
    if [[ ! -v "DATABASES[$db_name]" ]]; then
        log_error "Unknown database: $db_name"
        log_info "Available databases: ${!DATABASES[@]}"
        exit 1
    fi
    
    if [[ -z "$backup_file" ]]; then
        backup_file="${BACKUP_DIR}/${db_name}_${timestamp}.sql"
        if [[ "$compress" == "true" ]]; then
            backup_file="${backup_file}.gz"
        fi
    fi
    
    log_db "Backing up database: $db_name"
    log_info "Backup file: $backup_file"
    
    if [[ "$compress" == "true" ]]; then
        docker exec "$POSTGRES_CONTAINER" pg_dump -U "$DB_USER" "$db_name" | gzip > "$backup_file"
    else
        docker exec "$POSTGRES_CONTAINER" pg_dump -U "$DB_USER" "$db_name" > "$backup_file"
    fi
    
    if [[ $? -eq 0 ]]; then
        local size=$(du -h "$backup_file" | cut -f1)
        log_success "Database $db_name backed up successfully ($size)"
    else
        log_error "Backup failed for database: $db_name"
        exit 1
    fi
}

db_restore() {
    local backup_file=$1
    local db_name=$2
    
    if [[ -z "$backup_file" ]]; then
        log_error "Backup file required"
        log_info "Usage: kompose db restore -f BACKUP_FILE [-d DATABASE]"
        exit 1
    fi
    
    if [[ ! -f "$backup_file" ]]; then
        log_error "Backup file not found: $backup_file"
        exit 1
    fi
    
    # Auto-detect database name from filename if not provided
    if [[ -z "$db_name" ]]; then
        db_name=$(basename "$backup_file" | sed -E 's/^([^_]+)_.*/\1/')
        log_info "Auto-detected database: $db_name"
    fi
    
    if [[ ! -v "DATABASES[$db_name]" ]]; then
        log_error "Unknown database: $db_name"
        log_info "Available databases: ${!DATABASES[@]}"
        exit 1
    fi
    
    log_warning "Restoring database: $db_name from $backup_file"
    read -p "This will overwrite the existing database. Continue? (yes/no): " confirm
    
    if [[ "$confirm" != "yes" ]]; then
        log_info "Restore cancelled"
        exit 0
    fi
    
    log_db "Dropping existing database..."
    docker exec "$POSTGRES_CONTAINER" psql -U "$DB_USER" -c "DROP DATABASE IF EXISTS $db_name;"
    docker exec "$POSTGRES_CONTAINER" psql -U "$DB_USER" -c "CREATE DATABASE $db_name;"
    
    log_db "Restoring from backup..."
    if [[ "$backup_file" == *.gz ]]; then
        gunzip -c "$backup_file" | docker exec -i "$POSTGRES_CONTAINER" psql -U "$DB_USER" "$db_name"
    else
        docker exec -i "$POSTGRES_CONTAINER" psql -U "$DB_USER" "$db_name" < "$backup_file"
    fi
    
    if [[ $? -eq 0 ]]; then
        log_success "Database $db_name restored successfully"
    else
        log_error "Restore failed"
        exit 1
    fi
}

db_list() {
    echo ""
    log_db "Available database backups:"
    echo ""
    
    if [[ ! -d "$BACKUP_DIR" ]]; then
        log_warning "No backup directory found: $BACKUP_DIR"
        return 0
    fi
    
    find "$BACKUP_DIR" -name "*.sql" -o -name "*.sql.gz" | sort -r | while read -r file; do
        local size=$(du -h "$file" | cut -f1)
        local date=$(stat -c %y "$file" 2>/dev/null || stat -f %Sm "$file" 2>/dev/null || echo "unknown")
        echo -e "  📦 $(basename $file) - $size - $date"
    done
    
    echo ""
}

db_status() {
    log_db "Database status:"
    echo ""
    
    if ! docker ps | grep -q "$POSTGRES_CONTAINER"; then
        log_error "PostgreSQL container is not running"
        log_info "Start with: kompose up home"
        exit 1
    fi
    
    log_success "PostgreSQL container is running"
    echo ""
    
    log_info "Available databases:"
    docker exec "$POSTGRES_CONTAINER" psql -U "$DB_USER" -c "\l" | grep -E "^\s*(kompose|n8n|gitea)" || echo "No databases found"
    echo ""
    
    log_info "Database sizes:"
    for db in "${!DATABASES[@]}"; do
        local size=$(docker exec "$POSTGRES_CONTAINER" psql -U "$DB_USER" -d "$db" -c "SELECT pg_size_pretty(pg_database_size('$db'));" -t 2>/dev/null | xargs)
        if [[ -n "$size" ]]; then
            echo -e "  ${CYAN}$db${NC}: $size - ${DATABASES[$db]}"
        fi
    done
    echo ""
    
    log_info "Active connections:"
    docker exec "$POSTGRES_CONTAINER" psql -U "$DB_USER" -c "SELECT datname, count(*) FROM pg_stat_activity GROUP BY datname;"
    echo ""
}

db_exec() {
    local db_name=$1
    local sql_command=$2
    
    if [[ -z "$db_name" || -z "$sql_command" ]]; then
        log_error "Database name and SQL command required"
        log_info "Usage: kompose db exec -d DATABASE \"SQL COMMAND\""
        exit 1
    fi
    
    if [[ ! -v "DATABASES[$db_name]" ]]; then
        log_error "Unknown database: $db_name"
        log_info "Available databases: ${!DATABASES[@]}"
        exit 1
    fi
    
    log_db "Executing SQL on database: $db_name"
    docker exec "$POSTGRES_CONTAINER" psql -U "$DB_USER" -d "$db_name" -c "$sql_command"
}

db_shell() {
    local db_name=${1:-kompose}
    
    if [[ ! -v "DATABASES[$db_name]" ]]; then
        log_error "Unknown database: $db_name"
        log_info "Available databases: ${!DATABASES[@]}"
        exit 1
    fi
    
    log_db "Opening shell for database: $db_name"
    log_info "Type \\q to exit"
    echo ""
    
    docker exec -it "$POSTGRES_CONTAINER" psql -U "$DB_USER" -d "$db_name"
}

db_migrate() {
    local db_name=${1:-kompose}
    
    if [[ ! -v "DATABASES[$db_name]" ]]; then
        log_error "Unknown database: $db_name"
        log_info "Available databases: ${!DATABASES[@]}"
        exit 1
    fi
    
    log_db "Running migrations for database: $db_name"
    
    case $db_name in
        n8n)
            log_info "n8n handles migrations automatically on startup"
            log_info "Restart n8n: kompose restart chain"
            ;;
        gitea)
            log_info "Gitea handles migrations automatically on startup"
            log_info "Restart gitea: kompose restart chain"
            ;;
        kompose)
            local migrations_dir="./migrations"
            if [[ ! -d "$migrations_dir" ]]; then
                log_warning "No migrations directory found: $migrations_dir"
                return 0
            fi
            
            log_info "Applying migrations from $migrations_dir"
            for migration in "$migrations_dir"/*.sql; do
                if [[ -f "$migration" ]]; then
                    log_info "Applying: $(basename $migration)"
                    docker exec -i "$POSTGRES_CONTAINER" psql -U "$DB_USER" -d "$db_name" < "$migration"
                fi
            done
            log_success "Migrations completed"
            ;;
    esac
}

db_reset() {
    local db_name=$1
    
    if [[ -z "$db_name" ]]; then
        log_error "Database name required"
        log_info "Usage: kompose db reset -d DATABASE"
        exit 1
    fi
    
    if [[ ! -v "DATABASES[$db_name]" ]]; then
        log_error "Unknown database: $db_name"
        log_info "Available databases: ${!DATABASES[@]}"
        exit 1
    fi
    
    log_warning "⚠️  WARNING: This will DELETE ALL DATA in database: $db_name"
    read -p "Type the database name to confirm: " confirm
    
    if [[ "$confirm" != "$db_name" ]]; then
        log_info "Reset cancelled"
        exit 0
    fi
    
    log_db "Resetting database: $db_name"
    
    # Create backup first
    log_info "Creating backup before reset..."
    db_backup "$db_name" "" false
    
    # Drop and recreate
    docker exec "$POSTGRES_CONTAINER" psql -U "$DB_USER" -c "DROP DATABASE IF EXISTS $db_name;"
    docker exec "$POSTGRES_CONTAINER" psql -U "$DB_USER" -c "CREATE DATABASE $db_name;"
    
    log_success "Database $db_name has been reset"
    log_info "Backup saved to: $BACKUP_DIR"
}

# ============================================================================
# MAIN COMMAND ROUTER
# ============================================================================

main() {
    if [ $# -eq 0 ]; then
        usage
    fi
    
    local command=$1
    shift
    
    # Handle tag subcommands
    if [ "$command" = "tag" ]; then
        if [ $# -eq 0 ]; then
            log_error "Tag subcommand required"
            echo ""
            echo "Available tag commands:"
            echo "  create, deploy, move, delete, list, rollback, status"
            echo ""
            echo "Example: kompose tag deploy -s frontend -e dev -v 1.0.0"
            exit 1
        fi
        
        local tag_cmd=$1
        shift
        
        # Parse tag options
        TAG_SERVICE=""
        TAG_ENV=""
        TAG_VERSION=""
        TAG_COMMIT=""
        TAG_MESSAGE=""
        FORCE=false
        DRY_RUN=false
        
        while [ $# -gt 0 ]; do
            case $1 in
                -s|--service)
                    TAG_SERVICE="$2"
                    shift 2
                    ;;
                -e|--env)
                    TAG_ENV="$2"
                    shift 2
                    ;;
                -v|--version)
                    TAG_VERSION="$2"
                    shift 2
                    ;;
                -c|--commit)
                    TAG_COMMIT="$2"
                    shift 2
                    ;;
                -m|--message)
                    TAG_MESSAGE="$2"
                    shift 2
                    ;;
                -f|--force)
                    FORCE=true
                    shift
                    ;;
                -d|--dry-run)
                    DRY_RUN=true
                    shift
                    ;;
                *)
                    # Positional arguments for tag status
                    if [ "$tag_cmd" = "status" ]; then
                        if [ -z "$TAG_SERVICE" ]; then
                            TAG_SERVICE="$1"
                        elif [ -z "$TAG_VERSION" ]; then
                            TAG_VERSION="$1"
                        elif [ -z "$TAG_ENV" ]; then
                            TAG_ENV="$1"
                        fi
                        shift
                    else
                        log_error "Unknown option: $1"
                        exit 1
                    fi
                    ;;
            esac
        done
        
        validate_tag_inputs
        
        case $tag_cmd in
            create)
                [[ -z "$TAG_SERVICE" || -z "$TAG_ENV" || -z "$TAG_VERSION" ]] && \
                    { log_error "Required: -s SERVICE -e ENV -v VERSION"; exit 1; }
                tag_create "$TAG_SERVICE" "$TAG_ENV" "$TAG_VERSION" "${TAG_COMMIT:-HEAD}" "$TAG_MESSAGE"
                ;;
            deploy)
                [[ -z "$TAG_SERVICE" || -z "$TAG_ENV" || -z "$TAG_VERSION" ]] && \
                    { log_error "Required: -s SERVICE -e ENV -v VERSION"; exit 1; }
                tag_deploy "$TAG_SERVICE" "$TAG_ENV" "$TAG_VERSION" "${TAG_COMMIT:-HEAD}" "$TAG_MESSAGE"
                ;;
            move)
                [[ -z "$TAG_SERVICE" || -z "$TAG_ENV" || -z "$TAG_VERSION" || -z "$TAG_COMMIT" ]] && \
                    { log_error "Required: -s SERVICE -e ENV -v VERSION -c COMMIT"; exit 1; }
                tag_move "$TAG_SERVICE" "$TAG_ENV" "$TAG_VERSION" "$TAG_COMMIT"
                ;;
            delete)
                [[ -z "$TAG_SERVICE" || -z "$TAG_ENV" || -z "$TAG_VERSION" ]] && \
                    { log_error "Required: -s SERVICE -e ENV -v VERSION"; exit 1; }
                tag_delete "$TAG_SERVICE" "$TAG_ENV" "$TAG_VERSION"
                ;;
            list)
                tag_list "$TAG_SERVICE"
                ;;
            rollback)
                [[ -z "$TAG_SERVICE" || -z "$TAG_ENV" || -z "$TAG_VERSION" ]] && \
                    { log_error "Required: -s SERVICE -e ENV -v VERSION"; exit 1; }
                tag_rollback "$TAG_SERVICE" "$TAG_ENV" "$TAG_VERSION"
                ;;
            status)
                [[ -z "$TAG_SERVICE" || -z "$TAG_VERSION" || -z "$TAG_ENV" ]] && \
                    { log_error "Required: SERVICE VERSION ENV or -s -v -e"; exit 1; }
                tag_status "$TAG_SERVICE" "$TAG_VERSION" "$TAG_ENV"
                ;;
            *)
                log_error "Unknown tag command: $tag_cmd"
                echo "Available: create, deploy, move, delete, list, rollback, status"
                exit 1
                ;;
        esac
        
        return 0
    fi
    
    # Handle database subcommands
    if [ "$command" = "db" ]; then
        if [ $# -eq 0 ]; then
            log_error "Database subcommand required"
            echo ""
            echo "Available database commands:"
            echo "  backup, restore, list, status, exec, shell, migrate, reset"
            echo ""
            echo "Example: kompose db backup -d postgres"
            exit 1
        fi
        
        local db_cmd=$1
        shift
        
        # Parse database options
        DB_NAME=""
        DB_FILE=""
        DB_COMPRESS=false
        DB_TIMESTAMP=false
        DB_SQL=""
        
        while [ $# -gt 0 ]; do
            case $1 in
                -d|--database)
                    DB_NAME="$2"
                    shift 2
                    ;;
                -f|--file)
                    DB_FILE="$2"
                    shift 2
                    ;;
                --compress)
                    DB_COMPRESS=true
                    shift
                    ;;
                --timestamp|-t)
                    DB_TIMESTAMP=true
                    shift
                    ;;
                *)
                    # Positional argument (SQL command for exec)
                    if [ "$db_cmd" = "exec" ]; then
                        DB_SQL="$1"
                        shift
                    elif [ "$db_cmd" = "shell" ] || [ "$db_cmd" = "migrate" ] || [ "$db_cmd" = "reset" ]; then
                        if [ -z "$DB_NAME" ]; then
                            DB_NAME="$1"
                        fi
                        shift
                    else
                        log_error "Unknown option: $1"
                        exit 1
                    fi
                    ;;
            esac
        done
        
        case $db_cmd in
            backup)
                db_backup "${DB_NAME:-all}" "$DB_FILE" "$DB_COMPRESS"
                ;;
            restore)
                db_restore "$DB_FILE" "$DB_NAME"
                ;;
            list)
                db_list
                ;;
            status)
                db_status
                ;;
            exec)
                [[ -z "$DB_NAME" || -z "$DB_SQL" ]] && \
                    { log_error "Required: -d DATABASE \"SQL COMMAND\""; exit 1; }
                db_exec "$DB_NAME" "$DB_SQL"
                ;;
            shell)
                db_shell "${DB_NAME:-kompose}"
                ;;
            migrate)
                db_migrate "${DB_NAME:-kompose}"
                ;;
            reset)
                [[ -z "$DB_NAME" ]] && \
                    { log_error "Required: -d DATABASE"; exit 1; }
                db_reset "$DB_NAME"
                ;;
            *)
                log_error "Unknown database command: $db_cmd"
                echo "Available: backup, restore, list, status, exec, shell, migrate, reset"
                exit 1
                ;;
        esac
        
        return 0
    fi
    
    # Handle stack management commands
    case $command in
        up)
            if [ $# -eq 0 ]; then
                process_all_stacks "up" "$@"
            else
                local stack=$1
                shift
                if stack_exists "$stack"; then
                    stack_up "$stack" true "$@"
                fi
            fi
            ;;
        down)
            if [ $# -eq 0 ]; then
                process_all_stacks "down" "$@"
            else
                local stack=$1
                shift
                local force=false
                if [ "$1" = "-f" ] || [ "$1" = "--force" ]; then
                    force=true
                fi
                if stack_exists "$stack"; then
                    stack_down "$stack" "$force"
                fi
            fi
            ;;
        restart)
            if [ $# -eq 0 ]; then
                process_all_stacks "restart" "$@"
            else
                local stack=$1
                shift
                if stack_exists "$stack"; then
                    stack_restart "$stack" "$@"
                fi
            fi
            ;;
        status)
            if [ $# -eq 0 ]; then
                process_all_stacks "status" "$@"
            else
                local stack=$1
                if stack_exists "$stack"; then
                    stack_status "$stack"
                fi
            fi
            ;;
        logs)
            if [ $# -eq 0 ]; then
                log_error "Stack name required for logs"
                exit 1
            fi
            local stack=$1
            shift
            if stack_exists "$stack"; then
                stack_logs "$stack" "$@"
            fi
            ;;
        pull)
            if [ $# -eq 0 ]; then
                process_all_stacks "pull" "$@"
            else
                local stack=$1
                shift
                if stack_exists "$stack"; then
                    stack_pull "$stack" "$@"
                fi
            fi
            ;;
        build)
            if [ $# -eq 0 ]; then
                log_error "Stack name required for build"
                exit 1
            fi
            local stack=$1
            shift
            local no_cache=false
            if [ "$1" = "--no-cache" ]; then
                no_cache=true
            fi
            if stack_exists "$stack"; then
                stack_build "$stack" "$no_cache"
            fi
            ;;
        deploy)
            if [ $# -lt 2 ]; then
                log_error "Stack name and version required for deploy"
                log_info "Usage: kompose deploy STACK VERSION"
                exit 1
            fi
            local stack=$1
            local version=$2
            if stack_exists "$stack"; then
                stack_deploy "$stack" "$version"
            fi
            ;;
        list)
            list_stacks
            ;;
        validate)
            if [ $# -eq 0 ]; then
                process_all_stacks "validate" "$@"
            else
                local stack=$1
                if stack_exists "$stack"; then
                    stack_validate "$stack"
                fi
            fi
            ;;
        exec)
            if [ $# -lt 2 ]; then
                log_error "Stack name and command required for exec"
                exit 1
            fi
            local stack=$1
            shift
            if stack_exists "$stack"; then
                stack_exec "$stack" "$@"
            fi
            ;;
        ps)
            show_all_containers
            ;;
        help|--help|-h)
            usage
            ;;
        *)
            log_error "Unknown command: $command"
            usage
            ;;
    esac
}

main "$@"
