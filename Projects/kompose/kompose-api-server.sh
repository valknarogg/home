#!/bin/bash

# kompose-api-server.sh - REST API Server for Kompose
# Provides a JSON REST API interface for all kompose.sh commands using netcat

set -e

# Configuration
API_PORT="${API_PORT:-8080}"
API_HOST="${API_HOST:-127.0.0.1}"
API_PIDFILE="${API_PIDFILE:-/tmp/kompose-api.pid}"
API_LOGFILE="${API_LOGFILE:-/tmp/kompose-api.log}"
KOMPOSE_SCRIPT="${KOMPOSE_SCRIPT:-./kompose.sh}"

# Colors
NC='\033[0m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
MAGENTA='\033[0;35m'

log_api() {
    echo -e "${MAGENTA}[API]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# JSON output helpers
json_escape() {
    local str="$1"
    str="${str//\\/\\\\}"
    str="${str//\"/\\\"}"
    str="${str//$'\n'/\\n}"
    str="${str//$'\r'/\\r}"
    str="${str//$'\t'/\\t}"
    echo "$str"
}

json_success() {
    local message="$1"
    local data="${2:-null}"
    cat <<EOF
{
  "status": "success",
  "message": "$(json_escape "$message")",
  "data": $data,
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
}

json_error() {
    local message="$1"
    local code="${2:-500}"
    cat <<EOF
{
  "status": "error",
  "message": "$(json_escape "$message")",
  "code": $code,
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
}

# HTTP response helpers
http_response() {
    local status_code="$1"
    local status_message="$2"
    local content_type="${3:-application/json}"
    local body="$4"
    
    echo "HTTP/1.1 $status_code $status_message"
    echo "Content-Type: $content_type"
    echo "Content-Length: ${#body}"
    echo "Connection: close"
    echo "Access-Control-Allow-Origin: *"
    echo "Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS"
    echo "Access-Control-Allow-Headers: Content-Type"
    echo ""
    echo "$body"
}

# Parse URL query string
parse_query_string() {
    local query="$1"
    echo "$query" | tr '&' '\n' | while IFS='=' read -r key value; do
        echo "$key=$(echo "$value" | sed 's/%20/ /g')"
    done
}

# Route handler
handle_request() {
    local method="$1"
    local path="$2"
    local body="$3"
    
    # Log request
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $method $path" >> "$API_LOGFILE"
    
    # Remove query string for routing
    local clean_path=$(echo "$path" | cut -d'?' -f1)
    local query_string=$(echo "$path" | cut -d'?' -s -f2)
    
    # Handle OPTIONS for CORS
    if [ "$method" = "OPTIONS" ]; then
        http_response 200 "OK" "text/plain" ""
        return
    fi
    
    # Route requests
    case "$clean_path" in
        /api/health)
            handle_health
            ;;
        /api/stacks)
            handle_stacks_list
            ;;
        /api/stacks/*)
            local stack_path="${clean_path#/api/stacks/}"
            local stack_name=$(echo "$stack_path" | cut -d'/' -f1)
            local action=$(echo "$stack_path" | cut -d'/' -s -f2)
            
            if [ -z "$action" ]; then
                handle_stack_status "$stack_name"
            else
                handle_stack_action "$stack_name" "$action" "$method"
            fi
            ;;
        /api/db/*)
            local db_path="${clean_path#/api/db/}"
            handle_database_action "$db_path" "$method"
            ;;
        /api/tag/*)
            local tag_path="${clean_path#/api/tag/}"
            handle_tag_action "$tag_path" "$method" "$query_string"
            ;;
        *)
            local error_body=$(json_error "Endpoint not found: $clean_path" 404)
            http_response 404 "Not Found" "application/json" "$error_body"
            ;;
    esac
}

# Health check endpoint
handle_health() {
    local health_data='{
  "version": "1.0.0",
  "server": "kompose-api",
  "uptime": "'$(cat /proc/uptime | awk '{print $1}')' seconds"
}'
    local body=$(json_success "API is healthy" "$health_data")
    http_response 200 "OK" "application/json" "$body"
}

# List all stacks
handle_stacks_list() {
    local output=$($KOMPOSE_SCRIPT list 2>&1 | grep -v '\[INFO\]' || echo "")
    local stacks_json='['
    local first=true
    
    # Get all stacks from output
    while IFS= read -r line; do
        if [[ "$line" =~ ^[[:space:]]*([a-zA-Z0-9_-]+)[[:space:]]*-[[:space:]]*(.*) ]]; then
            local name="${BASH_REMATCH[1]}"
            local desc="${BASH_REMATCH[2]}"
            
            if [ "$first" = false ]; then
                stacks_json+=','
            fi
            first=false
            
            stacks_json+='{
  "name": "'$name'",
  "description": "'"$(json_escape "$desc")"'",
  "path": "/api/stacks/'$name'"
}'
        fi
    done <<< "$output"
    
    stacks_json+=']'
    
    local body=$(json_success "Stacks retrieved" "$stacks_json")
    http_response 200 "OK" "application/json" "$body"
}

# Get stack status
handle_stack_status() {
    local stack="$1"
    
    local output=$($KOMPOSE_SCRIPT status "$stack" 2>&1 || echo "error")
    
    if [[ "$output" == *"error"* ]] || [[ "$output" == *"not found"* ]]; then
        local error_body=$(json_error "Stack not found or error: $stack" 404)
        http_response 404 "Not Found" "application/json" "$error_body"
        return
    fi
    
    local status_data='{
  "stack": "'$stack'",
  "output": "'"$(json_escape "$output")"'"
}'
    
    local body=$(json_success "Stack status retrieved" "$status_data")
    http_response 200 "OK" "application/json" "$body"
}

# Handle stack actions (start, stop, restart, etc.)
handle_stack_action() {
    local stack="$1"
    local action="$2"
    local method="$3"
    
    case "$action" in
        start)
            if [ "$method" != "POST" ]; then
                local error_body=$(json_error "Method not allowed. Use POST" 405)
                http_response 405 "Method Not Allowed" "application/json" "$error_body"
                return
            fi
            
            local output=$($KOMPOSE_SCRIPT up "$stack" 2>&1 || echo "error")
            if [[ "$output" == *"error"* ]]; then
                local error_body=$(json_error "Failed to start stack: $output" 500)
                http_response 500 "Internal Server Error" "application/json" "$error_body"
            else
                local result_data='{"stack": "'$stack'", "action": "start", "output": "'"$(json_escape "$output")"'"}'
                local body=$(json_success "Stack started successfully" "$result_data")
                http_response 200 "OK" "application/json" "$body"
            fi
            ;;
            
        stop)
            if [ "$method" != "POST" ]; then
                local error_body=$(json_error "Method not allowed. Use POST" 405)
                http_response 405 "Method Not Allowed" "application/json" "$error_body"
                return
            fi
            
            local output=$($KOMPOSE_SCRIPT down "$stack" 2>&1 || echo "error")
            if [[ "$output" == *"error"* ]]; then
                local error_body=$(json_error "Failed to stop stack: $output" 500)
                http_response 500 "Internal Server Error" "application/json" "$error_body"
            else
                local result_data='{"stack": "'$stack'", "action": "stop", "output": "'"$(json_escape "$output")"'"}'
                local body=$(json_success "Stack stopped successfully" "$result_data")
                http_response 200 "OK" "application/json" "$body"
            fi
            ;;
            
        restart)
            if [ "$method" != "POST" ]; then
                local error_body=$(json_error "Method not allowed. Use POST" 405)
                http_response 405 "Method Not Allowed" "application/json" "$error_body"
                return
            fi
            
            local output=$($KOMPOSE_SCRIPT restart "$stack" 2>&1 || echo "error")
            if [[ "$output" == *"error"* ]]; then
                local error_body=$(json_error "Failed to restart stack: $output" 500)
                http_response 500 "Internal Server Error" "application/json" "$error_body"
            else
                local result_data='{"stack": "'$stack'", "action": "restart", "output": "'"$(json_escape "$output")"'"}'
                local body=$(json_success "Stack restarted successfully" "$result_data")
                http_response 200 "OK" "application/json" "$body"
            fi
            ;;
            
        logs)
            local output=$($KOMPOSE_SCRIPT logs "$stack" --tail=100 2>&1 || echo "error")
            if [[ "$output" == *"error"* ]]; then
                local error_body=$(json_error "Failed to get logs: $output" 500)
                http_response 500 "Internal Server Error" "application/json" "$error_body"
            else
                local result_data='{"stack": "'$stack'", "logs": "'"$(json_escape "$output")"'"}'
                local body=$(json_success "Logs retrieved" "$result_data")
                http_response 200 "OK" "application/json" "$body"
            fi
            ;;
            
        *)
            local error_body=$(json_error "Unknown action: $action" 400)
            http_response 400 "Bad Request" "application/json" "$error_body"
            ;;
    esac
}

# Handle database actions
handle_database_action() {
    local action="$1"
    local method="$2"
    
    case "$action" in
        status)
            local output=$($KOMPOSE_SCRIPT db status 2>&1 || echo "error")
            local result_data='{"output": "'"$(json_escape "$output")"'"}'
            local body=$(json_success "Database status retrieved" "$result_data")
            http_response 200 "OK" "application/json" "$body"
            ;;
            
        list)
            local output=$($KOMPOSE_SCRIPT db list 2>&1 || echo "error")
            local result_data='{"backups": "'"$(json_escape "$output")"'"}'
            local body=$(json_success "Database backups listed" "$result_data")
            http_response 200 "OK" "application/json" "$body"
            ;;
            
        *)
            local error_body=$(json_error "Unknown database action: $action" 400)
            http_response 400 "Bad Request" "application/json" "$error_body"
            ;;
    esac
}

# Handle tag deployment actions
handle_tag_action() {
    local action="$1"
    local method="$2"
    local query="$3"
    
    case "$action" in
        list)
            local output=$($KOMPOSE_SCRIPT tag list 2>&1 || echo "error")
            local result_data='{"tags": "'"$(json_escape "$output")"'"}'
            local body=$(json_success "Tags listed" "$result_data")
            http_response 200 "OK" "application/json" "$body"
            ;;
            
        *)
            local error_body=$(json_error "Unknown tag action: $action" 400)
            http_response 400 "Bad Request" "application/json" "$error_body"
            ;;
    esac
}

# Main server loop using netcat
start_server() {
    local port="${1:-$API_PORT}"
    local host="${2:-$API_HOST}"
    
    log_api "Starting REST API server on http://${host}:${port}"
    log_api "PID file: $API_PIDFILE"
    log_api "Log file: $API_LOGFILE"
    
    # Store PID
    echo $$ > "$API_PIDFILE"
    
    # Clear log file
    > "$API_LOGFILE"
    
    # Main server loop
    while true; do
        # Use netcat to listen for requests
        # Read the incoming request
        request=$(mktemp)
        response=$(mktemp)
        
        # Listen on port and capture request
        nc -l "$host" "$port" > "$request" 2>/dev/null || continue
        
        # Parse HTTP request
        method=$(head -n 1 "$request" | awk '{print $1}')
        path=$(head -n 1 "$request" | awk '{print $2}')
        
        # Handle the request and generate response
        handle_request "$method" "$path" "" > "$response"
        
        # Send response back using netcat
        cat "$response" | nc -l "$host" "$port" >/dev/null 2>&1 &
        
        # Cleanup temp files
        rm -f "$request" "$response"
        
        # Small delay to prevent CPU spinning
        sleep 0.1
    done
}

# Check if server is already running
if [ -f "$API_PIDFILE" ]; then
    pid=$(cat "$API_PIDFILE")
    if ps -p "$pid" > /dev/null 2>&1; then
        log_error "API server already running (PID: $pid)"
        log_api "URL: http://${API_HOST}:${API_PORT}"
        exit 1
    else
        log_warning "Stale PID file found, removing..."
        rm -f "$API_PIDFILE"
    fi
fi

# Check if nc (netcat) is available
if ! command -v nc &> /dev/null; then
    log_error "netcat (nc) is not installed"
    echo "Install with:"
    echo "  apt-get install netcat          # Debian/Ubuntu"
    echo "  yum install nmap-ncat           # RHEL/CentOS"
    echo "  brew install netcat             # macOS"
    exit 1
fi

# Start the server
start_server "$@"
