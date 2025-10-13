#!/bin/bash

# kompose.sh - Docker Compose Stack Manager (Modular Edition)
# Version: 2.0.0
# Manages multiple docker-compose stacks with integrated deployment features

set -e

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors - Export for module access
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export BLUE='\033[0;34m'
export CYAN='\033[0;36m'
export MAGENTA='\033[0;35m'
export NC='\033[0m'

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
API_SERVER_SCRIPT="${SCRIPT_DIR}/kompose-api-server.sh"

# Available stacks (can be extended dynamically)
declare -A STACKS=(
    ["core"]="Core services - MQTT, Redis, Postgres"
    ["auth"]="Authentication - Keycloak SSO, OAuth2 Proxy"
    ["kmps"]="Management Portal - User & SSO Administration"
    ["home"]="Smart Home - Home Assistant, Matter, Zigbee, ESPHome"
    ["vpn"]="VPN - WireGuard remote access (wg-easy)"
    ["messaging"]="Communication - Gotify notifications, Mailhog"
    ["chain"]="Automation Platform - n8n workflows, Semaphore/Ansible tasks"
    ["code"]="Git Repository & CI/CD - Gitea with Actions runner"
    ["proxy"]="Reverse Proxy - Traefik with SSL"
    ["link"]="Link Management - Linkwarden bookmark manager"
    ["news"]="Newsletter - Letterspace app"
    ["track"]="Activity Tracking - Umami analytics"
    ["vault"]="Password Manager - Vaultwarden"
    ["watch"]="Monitoring & Observability - Uptime Kuma, Grafana"
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
    ["gitea"]="Gitea git repository database"
    ["keycloak"]="Keycloak auth database"
    ["letterspace"]="Letterspace newsletter database"
)

# ============================================================================
# LOGGING FUNCTIONS
# ============================================================================

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

# Export logging functions for module usage
export -f log_info
export -f log_success
export -f log_warning
export -f log_error
export -f log_stack
export -f log_tag
export -f log_db
export -f log_api

# ============================================================================
# LOAD MODULES
# ============================================================================

# Source modular components
for module in "${SCRIPT_DIR}"/kompose-*.sh; do
    if [ -f "$module" ] && [ "$module" != "${SCRIPT_DIR}/kompose-api-server.sh" ]; then
        source "$module"
    fi
done

# ============================================================================
# TEST COMMAND HANDLERS
# ============================================================================

test_run_suite() {
    local test_dir="${SCRIPT_DIR}/__tests"
    local test_runner="${test_dir}/run-all-tests.sh"
    
    if [ ! -f "$test_runner" ]; then
        log_error "Test runner not found at ${test_runner}"
        log_info "Expected location: __tests/run-all-tests.sh"
        exit 1
    fi
    
    if [ ! -x "$test_runner" ]; then
        log_info "Making test runner executable..."
        chmod +x "$test_runner"
    fi
    
    # Change to test directory and run
    cd "$test_dir"
    bash "./run-all-tests.sh" "$@"
}

# ============================================================================
# USAGE / HELP
# ============================================================================

usage() {
    local exit_code="${1:-1}"
    cat << EOF
${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}
${CYAN}║              KOMPOSE - Docker Compose Stack Manager            ║${NC}
${CYAN}║                      Modular Edition 2.0                       ║${NC}
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
    api start [PORT]     Start REST API server (default: http://127.0.0.1:8080)
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

${MAGENTA}SECRETS MANAGEMENT COMMANDS:${NC}
    secrets generate     Generate all secrets or a specific secret
    secrets validate     Validate secrets configuration
    secrets list         List all secrets and their status
    secrets rotate       Rotate a specific secret (generate new value)
    secrets set          Set a specific secret value
    secrets backup       Create backup of secrets.env
    secrets export       Export secrets to JSON file

${MAGENTA}PROFILE MANAGEMENT COMMANDS:${NC}
    profile list         List all available profiles
    profile create       Create a new profile interactively
    profile use          Switch to a profile
    profile show         Show profile details
    profile edit         Edit a profile
    profile delete       Delete a profile
    profile copy         Copy/clone a profile
    profile export       Export profile to file
    profile import       Import profile from file
    profile up           Start stacks defined in current profile
    profile current      Show current active profile

${CYAN}TEST COMMANDS:${NC}
    test                 Run all tests
    test [SUITE]         Run specific test suite
    test -u              Update snapshots
    test -i              Run integration tests (requires Docker)
    test -t SUITE        Run specific test by name
    test -v              Verbose output
    test -h              Show test help

${BLUE}SETUP & INITIALIZATION:${NC}
    init                 Interactive project initialization (guided setup)
    setup <command>      Manage local/production configuration
        local            Switch to local development mode
        prod             Switch to production mode
        status           Show current configuration mode
        save-prod        Save current config as production
        backup           Backup current configuration

${BLUE}UTILITY COMMANDS:${NC}
    cleanup              Clean up backup and temporary files
    validate             Validate entire configuration
    version              Show version information
    help                 Show this help message

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

    ${MAGENTA}# Git Tag Deployments${NC}
    kompose tag create -s frontend -e dev -v 1.2.3
    kompose tag deploy -s backend -e staging -v 2.0.0
    kompose tag list -s frontend

    ${YELLOW}# Database Management${NC}
    kompose db backup -d postgres      # Backup PostgreSQL
    kompose db restore -f backup.sql   # Restore from file
    kompose db shell -d gitea          # Open gitea database shell

    ${MAGENTA}# Secrets Management${NC}
    kompose secrets generate           # Generate all secrets
    kompose secrets validate           # Check secrets configuration
    kompose secrets list -s auth       # List auth stack secrets
    kompose secrets rotate DB_PASSWORD # Rotate database password

    ${MAGENTA}# Profile Management${NC}
    kompose profile list               # List all profiles
    kompose profile create dev         # Create new profile
    kompose profile use production     # Switch to production profile
    kompose profile up                 # Start all stacks in current profile
    kompose profile current            # Show active profile

    ${MAGENTA}# REST API Server${NC}
    kompose api start                  # Start API server on default port
    kompose api status                 # Check API server status

    ${BLUE}# Setup & Initialization${NC}
    kompose init                       # Interactive guided setup
    kompose setup local                # Switch to local development
    kompose setup prod                 # Switch to production
    kompose setup status               # Check current mode

    ${CYAN}# Testing${NC}
    kompose test                       # Run all tests
    kompose test -t basic-commands     # Run specific test suite
    kompose test -u                    # Update snapshots
    kompose test -i                    # Run integration tests

    ${BLUE}# Utilities${NC}
    kompose validate                   # Validate configuration
    kompose cleanup                    # Clean up project

EOF
    exit $exit_code
}

# ============================================================================
# MAIN COMMAND ROUTER
# ============================================================================

main() {
    if [ $# -eq 0 ]; then
        usage 0
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
    
    # Handle secrets subcommands
    if [ "$command" = "secrets" ]; then
        if [ $# -eq 0 ]; then
            log_error "Secrets subcommand required"
            echo ""
            echo "Available secrets commands:"
            echo "  generate, validate, list, rotate, set, backup, export"
            echo ""
            echo "Example: kompose secrets generate"
            exit 1
        fi
        
        handle_secrets_command "$@"
        return 0
    fi
    
    # Handle profile subcommands
    if [ "$command" = "profile" ]; then
        if [ $# -eq 0 ]; then
            log_error "Profile subcommand required"
            echo ""
            echo "Available profile commands:"
            echo "  list, create, edit, use, show, delete, copy,"
            echo "  export, import, up, current"
            echo ""
            echo "Example: kompose profile list"
            exit 1
        fi
        
        handle_profile_command "$@"
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
    
    # Handle setup command
    if [ "$command" = "setup" ]; then
        shift
        handle_setup_command "$@"
        return 0
    fi
    
    # Handle test command
    if [ "$command" = "test" ]; then
        shift
        test_run_suite "$@"
        return 0
    fi
    
    # Handle utility commands
    case $command in
        init)
            init_project
            ;;
        
        cleanup)
            cleanup_project
            ;;
        
        validate)
            validate_configuration
            ;;
        
        version)
            show_version
            ;;
        
        # Stack management commands
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
            usage 0
            ;;
        *)
            log_error "Unknown command: $command"
            usage
            ;;
    esac
}

main "$@"
