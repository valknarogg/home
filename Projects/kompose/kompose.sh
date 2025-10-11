#!/usr/bin/env bash

set -euo pipefail

# Color codes for console output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly MAGENTA='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly RESET='\033[0m'

# Script directory
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly ROOT_ENV_FILE="${SCRIPT_DIR}/.env"

# Global flags
DRY_RUN=false
NETWORK_OVERRIDE=""

# Associative array for environment variable overrides
declare -A ENV_OVERRIDES=()

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${RESET} $*"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${RESET} $*"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${RESET} $*"
}

log_error() {
    echo -e "${RED}[ERROR]${RESET} $*"
}

log_stack() {
    echo -e "${MAGENTA}[STACK: $1]${RESET} ${2}"
}

log_dry_run() {
    echo -e "${YELLOW}[DRY-RUN]${RESET} $*"
}

# Load environment variables from .env file
load_env() {
    if [[ ! -f "${ROOT_ENV_FILE}" ]]; then
        log_warning "Root .env file not found at ${ROOT_ENV_FILE}"
        return
    fi

    log_info "Loading environment from ${ROOT_ENV_FILE}"
    
    # Export variables from .env file (ignore comments and empty lines)
    set -a
    # shellcheck disable=SC1090
    source <(grep -v '^#' "${ROOT_ENV_FILE}" | grep -v '^$' | sed 's/^\([^=]*\)=\(.*\)$/export \1="\2"/')
    set +a
    
    # Override network name if specified
    if [[ -n "${NETWORK_OVERRIDE}" ]]; then
        export NETWORK_NAME="${NETWORK_OVERRIDE}"
        log_info "Network override: ${NETWORK_NAME}"
    fi
    
    # Apply CLI environment overrides
    if [[ ${#ENV_OVERRIDES[@]} -gt 0 ]]; then
        log_info "Applying ${#ENV_OVERRIDES[@]} environment override(s)"
        for key in "${!ENV_OVERRIDES[@]}"; do
            export "${key}=${ENV_OVERRIDES[$key]}"
            log_info "  ${CYAN}${key}${RESET}=${ENV_OVERRIDES[$key]}"
        done
    fi
    
    log_success "Environment variables loaded"
}

# Load stack-specific environment variables
load_stack_env() {
    local stack_dir="$1"
    local env_file="${stack_dir}/.env"
    
    if [[ ! -f "${env_file}" ]]; then
        return
    fi
    
    # Export stack-specific variables
    set -a
    # shellcheck disable=SC1090
    source <(grep -v '^#' "${env_file}" | grep -v '^$' | sed 's/^\([^=]*\)=\(.*\)$/export \1="\2"/')
    set +a
    
    # Apply CLI environment overrides again to ensure they take precedence
    if [[ ${#ENV_OVERRIDES[@]} -gt 0 ]]; then
        for key in "${!ENV_OVERRIDES[@]}"; do
            export "${key}=${ENV_OVERRIDES[$key]}"
        done
    fi
}

# Execute stack hook if exists
execute_hook() {
    local stack="$1"
    local hook_name="$2"
    shift 2
    local -a args=("$@")
    
    local stack_dir="${SCRIPT_DIR}/${stack}"
    local hook_file="${stack_dir}/hooks.sh"
    
    if [[ ! -f "${hook_file}" ]]; then
        return 0
    fi
    
    load_stack_env "$stack_dir"

    # Source the hook file and call the function if it exists
    # shellcheck disable=SC1090
    source "${hook_file}"
    
    local hook_function="hook_${hook_name}"
    if declare -f "${hook_function}" > /dev/null; then
        log_stack "${stack}" "${CYAN}[HOOK]${RESET} Executing ${hook_name}"
        
        if [[ "${DRY_RUN}" == true ]]; then
            log_dry_run "${hook_function} ${args[*]}"
            return 0
        fi
        
        if "${hook_function}" "${args[@]}"; then
            log_stack "${stack}" "${GREEN}✓${RESET} Hook ${hook_name} completed"
        else
            log_stack "${stack}" "${RED}✗${RESET} Hook ${hook_name} failed"
            return 1
        fi
    fi
    
    return 0
}

# Get latest dump file for a stack
get_latest_dump() {
    local stack="$1"
    local stack_dir="${SCRIPT_DIR}/${stack}"
    
    # Load stack environment to get DB_NAME
    load_stack_env "${stack_dir}"
    
    if [[ -z "${DB_NAME:-}" ]]; then
        return 1
    fi
    
    # Find most recent dump file matching pattern
    local latest=$(ls -t "${stack_dir}/${DB_NAME}_"*.sql 2>/dev/null | head -1)
    
    if [[ -n "${latest}" ]]; then
        echo "${latest}"
        return 0
    fi
    
    return 1
}

# Clean up old dump files, keeping only the latest
cleanup_old_dumps() {
    local stack="$1"
    local stack_dir="${SCRIPT_DIR}/${stack}"
    
    # Check if stack uses postgres
    if ! stack_uses_postgres "${stack_dir}"; then
        log_stack "${stack}" "${YELLOW}⊘${RESET} No PostgreSQL database detected, skipping"
        return 0
    fi
    
    # Load stack environment
    load_stack_env "${stack_dir}"
    
    if [[ -z "${DB_NAME:-}" ]]; then
        log_stack "${stack}" "${RED}✗${RESET} DB_NAME not set in .env, skipping"
        return 1
    fi
    
    log_stack "${stack}" "Cleaning up old dumps for: ${DB_NAME}"
    
    # Get all dump files sorted by timestamp (newest first)
    local -a dumps=($(ls -t "${stack_dir}/${DB_NAME}_"*.sql 2>/dev/null))
    
    if [[ ${#dumps[@]} -eq 0 ]]; then
        log_stack "${stack}" "No dump files found"
        return 0
    fi
    
    if [[ ${#dumps[@]} -eq 1 ]]; then
        log_stack "${stack}" "Only one dump file, nothing to clean"
        return 0
    fi
    
    local latest="${dumps[0]}"
    local removed=0
    
    if [[ "${DRY_RUN}" == true ]]; then
        log_stack "${stack}" "${CYAN}[DRY-RUN]${RESET} Would keep: ${latest##*/}"
        for ((i=1; i<${#dumps[@]}; i++)); do
            log_dry_run "rm ${dumps[i]}"
            ((removed++))
        done
        log_stack "${stack}" "${CYAN}[DRY-RUN]${RESET} Would remove ${removed} old dump(s)"
        return 0
    fi
    
    # Remove all except the latest
    for ((i=1; i<${#dumps[@]}; i++)); do
        rm -f "${dumps[i]}"
        ((removed++))
    done
    
    log_stack "${stack}" "${GREEN}✓${RESET} Kept: ${latest##*/}, removed ${removed} old dump(s)"
}

# Check if stack uses PostgreSQL
stack_uses_postgres() {
    local stack_dir="$1"
    local compose_file=""
    
    if [[ -f "${stack_dir}/compose.yaml" ]]; then
        compose_file="${stack_dir}/compose.yaml"
    elif [[ -f "${stack_dir}/docker-compose.yaml" ]]; then
        compose_file="${stack_dir}/docker-compose.yaml"
    else
        return 1
    fi
    
    # Check if compose file references postgres or if stack has DB_NAME in .env
    if grep -q "postgres" "${compose_file}" 2>/dev/null || \
       grep -q "^DB_NAME=" "${stack_dir}/.env" 2>/dev/null; then
        return 0
    fi
    
    return 1
}

# Export database for a stack
export_database() {
    local stack="$1"
    local stack_dir="${SCRIPT_DIR}/${stack}"
    
    # Execute pre-export hook
    execute_hook "${stack}" "pre_db_export" || return 1
    
    # Check if stack uses postgres
    if ! stack_uses_postgres "${stack_dir}"; then
        log_stack "${stack}" "${YELLOW}⊘${RESET} No PostgreSQL database detected, skipping"
        return 0
    fi
    
    # Load stack environment
    load_stack_env "${stack_dir}"
    
    # Verify required variables
    if [[ -z "${DB_NAME:-}" ]]; then
        log_stack "${stack}" "${RED}✗${RESET} DB_NAME not set in .env, skipping"
        return 1
    fi
    
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local dump_file="${stack_dir}/${DB_NAME}_${timestamp}.sql"
    
    log_stack "${stack}" "Exporting database: ${DB_NAME}"
    
    if [[ "${DRY_RUN}" == true ]]; then
        log_dry_run "PGPASSWORD=*** pg_dump -h ${DB_HOST} -p ${DB_PORT} -U ${DB_USER} -d ${DB_NAME} > ${dump_file}"
        log_stack "${stack}" "${CYAN}[DRY-RUN]${RESET} Would export to: ${dump_file}"
        return 0
    fi
    
    # Execute export
    if PGPASSWORD="${DB_PASSWORD}" pg_dump -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -d "${DB_NAME}" > "${dump_file}"; then
        local size=$(du -h "${dump_file}" | cut -f1)
        log_stack "${stack}" "${GREEN}✓${RESET} Database exported to: ${dump_file} (${size})"
        
        # Execute post-export hook
        execute_hook "${stack}" "post_db_export" "${dump_file}" || return 1
    else
        log_stack "${stack}" "${RED}✗${RESET} Export failed"
        return 1
    fi
}

# Import database for a stack
import_database() {
    local stack="$1"
    local dump_file="${2:-}"
    local stack_dir="${SCRIPT_DIR}/${stack}"
    
    # If no dump file specified, use latest
    if [[ -z "${dump_file}" ]]; then
        dump_file=$(get_latest_dump "${stack}")
        if [[ -z "${dump_file}" ]]; then
            log_stack "${stack}" "${RED}✗${RESET} No dump files found"
            return 1
        fi
        log_stack "${stack}" "Using latest dump: ${dump_file##*/}"
    fi
    
    # Execute pre-import hook
    execute_hook "${stack}" "pre_db_import" "${dump_file}" || return 1
    
    # Check if dump file exists
    if [[ ! -f "${dump_file}" ]]; then
        log_stack "${stack}" "${RED}✗${RESET} Dump file not found: ${dump_file}"
        return 1
    fi
    
    # Check if stack uses postgres
    if ! stack_uses_postgres "${stack_dir}"; then
        log_stack "${stack}" "${YELLOW}⊘${RESET} No PostgreSQL database detected, skipping"
        return 0
    fi
    
    # Load stack environment
    load_stack_env "${stack_dir}"
    
    # Verify required variables
    if [[ -z "${DB_NAME:-}" ]]; then
        log_stack "${stack}" "${RED}✗${RESET} DB_NAME not set in .env, skipping"
        return 1
    fi
    
    log_stack "${stack}" "Preparing to import database: ${DB_NAME} from ${dump_file}"
    
    if [[ "${DRY_RUN}" == true ]]; then
        log_dry_run "DROP DATABASE IF EXISTS ${DB_NAME}"
        log_dry_run "CREATE DATABASE ${DB_NAME}"
        log_dry_run "PGPASSWORD=*** psql -h ${DB_HOST} -p ${DB_PORT} -U ${DB_USER} -d ${DB_NAME} -f ${dump_file}"
        log_stack "${stack}" "${CYAN}[DRY-RUN]${RESET} Would drop, recreate, and import from: ${dump_file}"
        return 0
    fi
    
    # Terminate existing connections to the database
    log_stack "${stack}" "Terminating existing connections"
    PGPASSWORD="${DB_PASSWORD}" psql -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -d postgres -c \
        "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '${DB_NAME}' AND pid <> pg_backend_pid();" > /dev/null 2>&1 || true
    
    # Drop existing database
    log_stack "${stack}" "Dropping database: ${DB_NAME}"
    if ! PGPASSWORD="${DB_PASSWORD}" psql -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -d postgres -c "DROP DATABASE IF EXISTS ${DB_NAME};" > /dev/null 2>&1; then
        log_stack "${stack}" "${RED}✗${RESET} Failed to drop database"
        return 1
    fi
    
    # Recreate database
    log_stack "${stack}" "Creating database: ${DB_NAME}"
    if ! PGPASSWORD="${DB_PASSWORD}" psql -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -d postgres -c "CREATE DATABASE ${DB_NAME};" > /dev/null 2>&1; then
        log_stack "${stack}" "${RED}✗${RESET} Failed to create database"
        return 1
    fi
    
    # Execute import
    log_stack "${stack}" "Importing data from dump file"
    if PGPASSWORD="${DB_PASSWORD}" psql -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -d "${DB_NAME}" -f "${dump_file}" > /dev/null 2>&1; then
        log_stack "${stack}" "${GREEN}✓${RESET} Database imported successfully"
        
        # Execute post-import hook
        execute_hook "${stack}" "post_db_import" "${dump_file}" || return 1
    else
        log_stack "${stack}" "${RED}✗${RESET} Import failed"
        return 1
    fi
}

# Get all stack directories
get_all_stacks() {
    local stacks=()
    
    for dir in "${SCRIPT_DIR}"/*; do
        if [[ -d "${dir}" ]]; then
            local stack_name=$(basename "${dir}")
            
            # Check if directory contains compose.yaml or docker-compose.yaml
            if [[ -f "${dir}/compose.yaml" ]] || [[ -f "${dir}/docker-compose.yaml" ]]; then
                stacks+=("${stack_name}")
            fi
        fi
    done
    
    echo "${stacks[@]}"
}

# Filter stacks based on pattern
filter_stacks() {
    local pattern="$1"
    local -a all_stacks=($2)
    local -a filtered_stacks=()
    
    # If pattern is "*", return all stacks
    if [[ "${pattern}" == "*" ]]; then
        echo "${all_stacks[@]}"
        return
    fi
    
    # Split pattern by comma for multiple patterns
    IFS=',' read -ra patterns <<< "${pattern}"
    
    for stack in "${all_stacks[@]}"; do
        for pat in "${patterns[@]}"; do
            # Trim whitespace from pattern
            pat=$(echo "${pat}" | xargs)
            
            # Support glob patterns
            if [[ "${stack}" == ${pat} ]]; then
                filtered_stacks+=("${stack}")
                break
            fi
        done
    done
    
    echo "${filtered_stacks[@]}"
}

# Build environment variable arguments for docker compose
build_env_args() {
    local -a env_args=()
    
    for key in "${!ENV_OVERRIDES[@]}"; do
        env_args+=("-e" "${key}=${ENV_OVERRIDES[$key]}")
    done
    
    echo "${env_args[@]}"
}

# Execute docker compose command for a stack
execute_stack_command() {
    local stack="$1"
    shift
    local cmd=("$@")
    
    local stack_dir="${SCRIPT_DIR}/${stack}"
    local compose_file=""
    
    # Determine which compose file exists
    if [[ -f "${stack_dir}/compose.yaml" ]]; then
        compose_file="compose.yaml"
    elif [[ -f "${stack_dir}/docker-compose.yaml" ]]; then
        compose_file="docker-compose.yaml"
    else
        log_error "No compose file found in ${stack}"
        return 1
    fi
    
    # Extract the main command (e.g., "up" from "up -d")
    local main_command="${cmd[0]}"
    local hook_name=""
    
    # Map docker compose commands to hook names
    case "${main_command}" in
        up|down|start|stop|restart|pull|build|ps|logs|exec|run|create|kill|pause|unpause|port|top)
            hook_name="${main_command}"
            ;;
    esac
    
    # Execute pre-command hook if hook name is determined
    if [[ -n "${hook_name}" ]]; then
        execute_hook "${stack}" "pre_${hook_name}" "${cmd[@]}" || return 1
    fi
    
    log_stack "${stack}" "Executing: docker compose ${cmd[*]}"
    
    # Build environment args
    local -a env_args=($(build_env_args))
    
    if [[ "${DRY_RUN}" == true ]]; then
        local env_str=""
        if [[ ${#env_args[@]} -gt 0 ]]; then
            env_str=" ${env_args[*]}"
        fi
        log_dry_run "cd ${stack_dir} && docker compose${env_str} -f ${compose_file} ${cmd[*]}"
        log_stack "${stack}" "${CYAN}[DRY-RUN]${RESET} Command would be executed"
        
        # Execute post-command hook in dry-run mode
        if [[ -n "${hook_name}" ]]; then
            execute_hook "${stack}" "post_${hook_name}" "${cmd[@]}" || return 1
        fi
        
        return 0
    fi
    
    # Change to stack directory and execute command
    local exit_code=0
    (
        cd "${stack_dir}"
        if [[ ${#env_args[@]} -gt 0 ]]; then
            if docker compose "${env_args[@]}" -f "${compose_file}" "${cmd[@]}"; then
                log_stack "${stack}" "${GREEN}✓${RESET} Command completed successfully"
            else
                log_stack "${stack}" "${RED}✗${RESET} Command failed"
                exit 1
            fi
        else
            if docker compose -f "${compose_file}" "${cmd[@]}"; then
                log_stack "${stack}" "${GREEN}✓${RESET} Command completed successfully"
            else
                log_stack "${stack}" "${RED}✗${RESET} Command failed"
                exit 1
            fi
        fi
    )
    exit_code=$?
    
    # Execute post-command hook if command succeeded and hook name is determined
    if [[ ${exit_code} -eq 0 ]] && [[ -n "${hook_name}" ]]; then
        execute_hook "${stack}" "post_${hook_name}" "${cmd[@]}" || return 1
    fi
    
    return ${exit_code}
}

# Display help message
show_help() {
    cat << 'EOF'
kompose.sh - Docker Compose Stack Manager

USAGE:
    ./kompose.sh [OPTIONS] <PATTERN> <COMMAND> [ARGS...]

DESCRIPTION:
    Manage multiple docker compose stacks in subdirectories. The script loads
    credentials from the root .env file and executes docker compose commands
    on stacks matching the specified pattern.

ARGUMENTS:
    <PATTERN>       Stack name pattern. Use glob-style patterns or comma-separated
                    list. Use "*" to select all stacks.
                    
    <COMMAND>       Command to execute:
                    - Docker compose commands: up, down, logs, ps, restart, etc.
                    - db:export     Export PostgreSQL database dump
                    - db:import     Import PostgreSQL database dump (drops & recreates DB)
                    - db:cleanup    Remove old dumps, keep only latest
    
    [ARGS...]       Additional arguments (e.g., dump file for db:import)

OPTIONS:
    -h, --help          Show this help message and exit
    -l, --list          List all available stacks and exit
    -n, --dry-run       Show what would be done without executing
    --network <n>    Override the network name (default: pvnet from root .env)
    -e, --env KEY=VALUE Override environment variable (can be used multiple times)

ENVIRONMENT OVERRIDES:
    Use -e or --env to override environment variables from the CLI:
        ./kompose.sh -e DB_HOST=postgres.local -e DB_PORT=5433 news up -d
        
    These overrides take precedence over values in both root and stack .env files.
    Multiple -e flags can be specified to override multiple variables.

DATABASE OPERATIONS:
    Export database dumps for stacks using PostgreSQL:
        ./kompose.sh <pattern> db:export [--dry-run]
        
    Import database dumps (drops and recreates the database):
        ./kompose.sh <pattern> db:import [<dump-file>] [--dry-run]
        Note: If no dump file specified, uses the latest dump
        WARNING: This will DROP the existing database and recreate it!
    
    Clean up old dumps (keeps only latest):
        ./kompose.sh <pattern> db:cleanup [--dry-run]
    
    Exports are saved as: <stack-dir>/<db-name>_<timestamp>.sql

HOOKS:
    Stacks can define custom hooks in hooks.sh for lifecycle management.
    
    Database Hooks:
    - hook_pre_db_export    - Before database export
    - hook_post_db_export   - After database export (receives dump file path)
    - hook_pre_db_import    - Before database import (receives dump file path)
    - hook_post_db_import   - After database import (receives dump file path)
    
    Docker Compose Command Hooks:
    - hook_pre_up           - Before 'docker compose up' (receives command args)
    - hook_post_up          - After 'docker compose up' (receives command args)
    - hook_pre_down         - Before 'docker compose down'
    - hook_post_down        - After 'docker compose down'
    - hook_pre_start        - Before 'docker compose start'
    - hook_post_start       - After 'docker compose start'
    - hook_pre_stop         - Before 'docker compose stop'
    - hook_post_stop        - After 'docker compose stop'
    - hook_pre_restart      - Before 'docker compose restart'
    - hook_post_restart     - After 'docker compose restart'
    - hook_pre_logs         - Before 'docker compose logs'
    - hook_post_logs        - After 'docker compose logs'
    - hook_pre_build        - Before 'docker compose build'
    - hook_post_build       - After 'docker compose build'
    - hook_pre_pull         - Before 'docker compose pull'
    - hook_post_pull        - After 'docker compose pull'
    
    And also: ps, exec, run, create, kill, pause, unpause, port, top
    
    Hook functions receive the full command arguments as parameters.
    Post-command hooks only execute if the command succeeds.
    
    Example: sexy stack uses hooks for Directus schema snapshots

EXAMPLES:
    # Start all stacks
    ./kompose.sh "*" up -d

    # Stop a specific stack
    ./kompose.sh auth down

    # View logs for multiple stacks
    ./kompose.sh "auth,blog,data" logs -f

    # Override environment variables
    ./kompose.sh -e DB_HOST=localhost -e DB_PORT=5433 news up -d

    # Export all databases
    ./kompose.sh "*" db:export

    # Export specific stack database (dry-run)
    ./kompose.sh news db:export --dry-run

    # Import latest dump automatically (WARNING: drops & recreates DB)
    ./kompose.sh news db:import

    # Import specific dump
    ./kompose.sh news db:import news/letterspace_20251007_080554.sql

    # Clean up old dumps, keep latest
    ./kompose.sh "*" db:cleanup

    # Dry-run docker compose command
    ./kompose.sh "*" up -d --dry-run

    # List all available stacks
    ./kompose.sh --list

AVAILABLE STACKS:
EOF
    
    local -a stacks=($(get_all_stacks))
    if [[ ${#stacks[@]} -eq 0 ]]; then
        echo "    No stacks found"
    else
        for stack in "${stacks[@]}"; do
            local stack_dir="${SCRIPT_DIR}/${stack}"
            local db_indicator=""
            if stack_uses_postgres "${stack_dir}"; then
                db_indicator=" ${GREEN}[postgres]${RESET}"
            fi
            echo -e "    - ${stack}${db_indicator}"
        done
    fi
    
    echo ""
}

# List all stacks
list_stacks() {
    local -a stacks=($(get_all_stacks))
    
    if [[ ${#stacks[@]} -eq 0 ]]; then
        log_warning "No stacks found in ${SCRIPT_DIR}"
        return
    fi
    
    log_info "Available stacks:"
    for stack in "${stacks[@]}"; do
        local stack_dir="${SCRIPT_DIR}/${stack}"
        local compose_file=""
        
        if [[ -f "${stack_dir}/compose.yaml" ]]; then
            compose_file="compose.yaml"
        elif [[ -f "${stack_dir}/docker-compose.yaml" ]]; then
            compose_file="docker-compose.yaml"
        fi
        
        local extras=""
        [[ -f "${stack_dir}/.env" ]] && extras="${extras}.env "
        
        # Check for SQL files
        local sql_files=("${stack_dir}"/*.sql)
        if [[ -f "${sql_files[0]}" ]]; then
            local count=$(ls -1 "${stack_dir}"/*.sql 2>/dev/null | wc -l)
            extras="${extras}${count} sql "
        fi
        
        # Check if uses postgres
        if stack_uses_postgres "${stack_dir}"; then
            extras="${extras}postgres "
        fi
        
        # Check for hooks
        if [[ -f "${stack_dir}/hooks.sh" ]]; then
            extras="${extras}hooks "
        fi
        
        if [[ -n "${extras}" ]]; then
            echo -e "  ${GREEN}●${RESET} ${stack} ${CYAN}(${compose_file})${RESET} ${YELLOW}[${extras}]${RESET}"
        else
            echo -e "  ${GREEN}●${RESET} ${stack} ${CYAN}(${compose_file})${RESET}"
        fi
    done
}

# Main function
main() {
    # Parse global options
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                show_help
                exit 0
                ;;
            -l|--list)
                list_stacks
                exit 0
                ;;
            -n|--dry-run)
                DRY_RUN=true
                shift
                ;;
            --network)
                NETWORK_OVERRIDE="$2"
                shift 2
                ;;
            -e|--env)
                if [[ -z "${2:-}" ]]; then
                    log_error "Missing value for -e/--env flag"
                    exit 1
                fi
                # Parse KEY=VALUE
                if [[ "$2" =~ ^([^=]+)=(.*)$ ]]; then
                    ENV_OVERRIDES["${BASH_REMATCH[1]}"]="${BASH_REMATCH[2]}"
                else
                    log_error "Invalid environment variable format: $2 (expected KEY=VALUE)"
                    exit 1
                fi
                shift 2
                ;;
            *)
                break
                ;;
        esac
    done
    
    # Check for required arguments
    if [[ $# -lt 2 ]]; then
        log_error "Missing required arguments"
        echo ""
        show_help
        exit 1
    fi
    
    local pattern="$1"
    local command="$2"
    shift 2
    
    # Parse remaining arguments
    local -a args=()
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --dry-run|-n)
                DRY_RUN=true
                ;;
            *)
                args+=("$1")
                ;;
        esac
        shift
    done
    
    # Load root environment variables
    load_env
    
    # Get all stacks
    local -a all_stacks=($(get_all_stacks))
    
    if [[ ${#all_stacks[@]} -eq 0 ]]; then
        log_error "No stacks found in ${SCRIPT_DIR}"
        exit 1
    fi
    
    # Filter stacks based on pattern
    local -a filtered_stacks=($(filter_stacks "${pattern}" "${all_stacks[*]}"))
    
    if [[ ${#filtered_stacks[@]} -eq 0 ]]; then
        log_error "No stacks match pattern: ${pattern}"
        log_info "Available stacks: ${all_stacks[*]}"
        exit 1
    fi
    
    if [[ "${DRY_RUN}" == true ]]; then
        log_warning "DRY-RUN MODE: No changes will be made"
    fi
    
    log_info "Selected stacks (${#filtered_stacks[@]}): ${filtered_stacks[*]}"
    
    # Handle database operations
    case "${command}" in
        db:export)
            log_info "Command: Export databases"
            echo ""
            
            local failed=0
            for stack in "${filtered_stacks[@]}"; do
                if ! export_database "${stack}"; then
                    ((failed++))
                fi
                echo ""
            done
            ;;
            
        db:import)
            local dump_file="${args[0]:-}"
            log_info "Command: Import database${dump_file:+ from ${dump_file}}"
            echo ""
            
            local failed=0
            for stack in "${filtered_stacks[@]}"; do
                if ! import_database "${stack}" "${dump_file}"; then
                    ((failed++))
                fi
                echo ""
            done
            ;;
            
        db:cleanup)
            log_info "Command: Clean up old database dumps"
            echo ""
            
            local failed=0
            for stack in "${filtered_stacks[@]}"; do
                if ! cleanup_old_dumps "${stack}"; then
                    ((failed++))
                fi
                echo ""
            done
            ;;
            
        *)
            # Regular docker compose command
            local -a cmd=("${command}" "${args[@]}")
            log_info "Command: docker compose ${cmd[*]}"
            echo ""
            
            local failed=0
            for stack in "${filtered_stacks[@]}"; do
                if ! execute_stack_command "${stack}" "${cmd[@]}"; then
                    ((failed++))
                fi
                echo ""
            done
            ;;
    esac
    
    # Summary
    local total=${#filtered_stacks[@]}
    local success=$((total - failed))
    
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    if [[ "${DRY_RUN}" == true ]]; then
        log_info "DRY-RUN Summary: ${total} stacks would be affected"
    else
        log_info "Summary: ${GREEN}${success}${RESET} succeeded, ${RED}${failed}${RESET} failed out of ${total} stacks"
    fi
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    
    # Exit with error if any stack failed (but not in dry-run mode)
    if [[ "${DRY_RUN}" == false ]] && [[ ${failed} -gt 0 ]]; then
        exit 1
    fi
    exit 0
}

# Run main function
main "$@"
