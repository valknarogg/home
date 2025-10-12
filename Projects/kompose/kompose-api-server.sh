#!/bin/bash

# kompose-api-server.sh - REST API Server for Kompose
# Provides a JSON REST API interface for all kompose.sh commands

set -e

# Configuration
API_PORT="${API_PORT:-8080}"
API_HOST="${API_HOST:-127.0.0.1}"
API_PIDFILE="${API_PIDFILE:-/tmp/kompose-api.pid}"
API_LOGFILE="${API_LOGFILE:-/tmp/kompose-api.log}"
KOMPOSE_SCRIPT="${KOMPOSE_SCRIPT:-$(dirname "$0")/kompose.sh}"
MAX_WORKERS="${MAX_WORKERS:-4}"

# Colors
NC='\033[0m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
MAGENTA='\033[0;35m'
BLUE='\033[0;34m'

log_api() {
    local msg="$1"
    echo -e "${MAGENTA}[API]${NC} $msg"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [API] $msg" >> "$API_LOGFILE"
}

log_success() {
    local msg="$1"
    echo -e "${GREEN}[SUCCESS]${NC} $msg"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [SUCCESS] $msg" >> "$API_LOGFILE"
}

log_error() {
    local msg="$1"
    echo -e "${RED}[ERROR]${NC} $msg"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $msg" >> "$API_LOGFILE"
}

log_warning() {
    local msg="$1"
    echo -e "${YELLOW}[WARNING]${NC} $msg"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [WARNING] $msg" >> "$API_LOGFILE"
}

log_request() {
    local method="$1"
    local path="$2"
    local status="${3:-200}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $method $path - $status" >> "$API_LOGFILE"
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
    
    cat <<EOF
HTTP/1.1 $status_code $status_message
Content-Type: $content_type; charset=utf-8
Content-Length: ${#body}
Connection: close
Server: kompose-api/1.0.0
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
Access-Control-Allow-Headers: Content-Type, Authorization
Cache-Control: no-cache

$body
EOF
}

# Route handler
handle_request() {
    local method="$1"
    local path="$2"
    local body="$3"
    
    # Remove query string for routing
    local clean_path=$(echo "$path" | cut -d'?' -f1)
    local query_string=$(echo "$path" | cut -d'?' -s -f2)
    
    # Handle OPTIONS for CORS preflight
    if [ "$method" = "OPTIONS" ]; then
        http_response 204 "No Content" "text/plain" ""
        log_request "$method" "$path" "204"
        return
    fi
    
    # Route requests
    case "$clean_path" in
        /|/api)
            handle_root
            log_request "$method" "$path" "200"
            ;;
        /api/health)
            handle_health
            log_request "$method" "$path" "200"
            ;;
        /api/stacks)
            handle_stacks_list
            log_request "$method" "$path" "200"
            ;;
        /api/stacks/*)
            local stack_path="${clean_path#/api/stacks/}"
            local stack_name=$(echo "$stack_path" | cut -d'/' -f1)
            local action=$(echo "$stack_path" | cut -d'/' -s -f2)
            
            if [ -z "$action" ]; then
                handle_stack_status "$stack_name"
                log_request "$method" "$path" "200"
            else
                handle_stack_action "$stack_name" "$action" "$method"
                log_request "$method" "$path" "200"
            fi
            ;;
        /api/db/*)
            local db_path="${clean_path#/api/db/}"
            handle_database_action "$db_path" "$method"
            log_request "$method" "$path" "200"
            ;;
        /api/tag/*)
            local tag_path="${clean_path#/api/tag/}"
            handle_tag_action "$tag_path" "$method" "$query_string"
            log_request "$method" "$path" "200"
            ;;
        *)
            local error_body=$(json_error "Endpoint not found: $clean_path" 404)
            http_response 404 "Not Found" "application/json" "$error_body"
            log_request "$method" "$path" "404"
            ;;
    esac
}

# Root endpoint - API information
handle_root() {
    local info_data='{
  "name": "Kompose REST API",
  "version": "1.0.0",
  "endpoints": {
    "health": "/api/health",
    "stacks": "/api/stacks",
    "database": "/api/db",
    "tags": "/api/tag"
  },
  "documentation": "https://kompose.sh/docs/api"
}'
    local body=$(json_success "Welcome to Kompose API" "$info_data")
    http_response 200 "OK" "application/json" "$body"
}

# Health check endpoint
handle_health() {
    local uptime_seconds=$(awk '{print int($1)}' /proc/uptime 2>/dev/null || echo "0")
    local health_data=$(cat <<EOF
{
  "version": "1.0.0",
  "server": "kompose-api",
  "uptime_seconds": $uptime_seconds,
  "pid": $$,
  "kompose_script": "$KOMPOSE_SCRIPT"
}
EOF
)
    local body=$(json_success "API is healthy" "$health_data")
    http_response 200 "OK" "application/json" "$body"
}

# List all stacks
handle_stacks_list() {
    local output=$("$KOMPOSE_SCRIPT" list 2>&1 | grep -E '^\s+[a-zA-Z0-9_-]+\s+-' || echo "")
    local stacks_json='['
    local first=true
    
    while IFS= read -r line; do
        if [[ "$line" =~ ^[[:space:]]*([a-zA-Z0-9_-]+)[[:space:]]*-[[:space:]]*(.*) ]]; then
            local name="${BASH_REMATCH[1]}"
            local desc="${BASH_REMATCH[2]}"
            
            if [ "$first" = false ]; then
                stacks_json+=','
            fi
            first=false
            
            stacks_json+=$(cat <<EOF

  {
    "name": "$name",
    "description": "$(json_escape "$desc")",
    "url": "/api/stacks/$name"
  }
EOF
)
        fi
    done <<< "$output"
    
    stacks_json+=$'\n]'
    
    local body=$(json_success "Stacks retrieved successfully" "$stacks_json")
    http_response 200 "OK" "application/json" "$body"
}

# Get stack status
handle_stack_status() {
    local stack="$1"
    
    local output=$("$KOMPOSE_SCRIPT" status "$stack" 2>&1 || echo "ERROR")
    
    if [[ "$output" == *"ERROR"* ]] || [[ "$output" == *"not found"* ]] || [[ "$output" == *"directory not found"* ]]; then
        local error_body=$(json_error "Stack not found: $stack" 404)
        http_response 404 "Not Found" "application/json" "$error_body"
        return
    fi
    
    local status_data=$(cat <<EOF
{
  "stack": "$stack",
  "output": "$(json_escape "$output")",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
)
    
    local body=$(json_success "Stack status retrieved" "$status_data")
    http_response 200 "OK" "application/json" "$body"
}

# Handle stack actions (start, stop, restart, etc.)
handle_stack_action() {
    local stack="$1"
    local action="$2"
    local method="$3"
    
    # Validate method for write operations
    if [[ "$action" =~ ^(start|stop|restart)$ ]] && [ "$method" != "POST" ]; then
        local error_body=$(json_error "Method not allowed. Use POST for $action" 405)
        http_response 405 "Method Not Allowed" "application/json" "$error_body"
        return
    fi
    
    case "$action" in
        start)
            local output=$("$KOMPOSE_SCRIPT" up "$stack" 2>&1 || echo "ERROR")
            if [[ "$output" == *"ERROR"* ]] || [[ "$output" == *"not found"* ]]; then
                local error_body=$(json_error "Failed to start stack: $(json_escape "$output")" 500)
                http_response 500 "Internal Server Error" "application/json" "$error_body"
            else
                local result_data=$(cat <<EOF
{
  "stack": "$stack",
  "action": "start",
  "output": "$(json_escape "$output")",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
)
                local body=$(json_success "Stack started successfully" "$result_data")
                http_response 200 "OK" "application/json" "$body"
            fi
            ;;
            
        stop)
            local output=$("$KOMPOSE_SCRIPT" down "$stack" 2>&1 || echo "ERROR")
            if [[ "$output" == *"ERROR"* ]] || [[ "$output" == *"not found"* ]]; then
                local error_body=$(json_error "Failed to stop stack: $(json_escape "$output")" 500)
                http_response 500 "Internal Server Error" "application/json" "$error_body"
            else
                local result_data=$(cat <<EOF
{
  "stack": "$stack",
  "action": "stop",
  "output": "$(json_escape "$output")",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
)
                local body=$(json_success "Stack stopped successfully" "$result_data")
                http_response 200 "OK" "application/json" "$body"
            fi
            ;;
            
        restart)
            local output=$("$KOMPOSE_SCRIPT" restart "$stack" 2>&1 || echo "ERROR")
            if [[ "$output" == *"ERROR"* ]] || [[ "$output" == *"not found"* ]]; then
                local error_body=$(json_error "Failed to restart stack: $(json_escape "$output")" 500)
                http_response 500 "Internal Server Error" "application/json" "$error_body"
            else
                local result_data=$(cat <<EOF
{
  "stack": "$stack",
  "action": "restart",
  "output": "$(json_escape "$output")",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
)
                local body=$(json_success "Stack restarted successfully" "$result_data")
                http_response 200 "OK" "application/json" "$body"
            fi
            ;;
            
        logs)
            local output=$("$KOMPOSE_SCRIPT" logs "$stack" --tail=100 2>&1 || echo "ERROR")
            if [[ "$output" == *"ERROR"* ]]; then
                local error_body=$(json_error "Failed to get logs: $(json_escape "$output")" 500)
                http_response 500 "Internal Server Error" "application/json" "$error_body"
            else
                local result_data=$(cat <<EOF
{
  "stack": "$stack",
  "logs": "$(json_escape "$output")",
  "lines": 100,
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
)
                local body=$(json_success "Logs retrieved successfully" "$result_data")
                http_response 200 "OK" "application/json" "$body"
            fi
            ;;
            
        *)
            local error_body=$(json_error "Unknown action: $action. Valid actions: start, stop, restart, logs" 400)
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
            local output=$("$KOMPOSE_SCRIPT" db status 2>&1 || echo "ERROR")
            local result_data=$(cat <<EOF
{
  "output": "$(json_escape "$output")",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
)
            local body=$(json_success "Database status retrieved" "$result_data")
            http_response 200 "OK" "application/json" "$body"
            ;;
            
        list)
            local output=$("$KOMPOSE_SCRIPT" db list 2>&1 || echo "ERROR")
            local result_data=$(cat <<EOF
{
  "backups": "$(json_escape "$output")",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
)
            local body=$(json_success "Database backups listed" "$result_data")
            http_response 200 "OK" "application/json" "$body"
            ;;
            
        *)
            local error_body=$(json_error "Unknown database action: $action. Valid actions: status, list" 400)
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
            local output=$("$KOMPOSE_SCRIPT" tag list 2>&1 || echo "ERROR")
            local result_data=$(cat <<EOF
{
  "tags": "$(json_escape "$output")",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
)
            local body=$(json_success "Tags listed successfully" "$result_data")
            http_response 200 "OK" "application/json" "$body"
            ;;
            
        *)
            local error_body=$(json_error "Unknown tag action: $action. Valid actions: list" 400)
            http_response 400 "Bad Request" "application/json" "$error_body"
            ;;
    esac
}

# ============================================================================
# SERVER IMPLEMENTATIONS
# ============================================================================

# Request handler for all server types
process_request() {
    local request_file="$1"
    
    # Parse HTTP request line
    local request_line=$(head -n 1 "$request_file" 2>/dev/null || echo "")
    if [ -z "$request_line" ]; then
        return
    fi
    
    local method=$(echo "$request_line" | awk '{print $1}')
    local path=$(echo "$request_line" | awk '{print $2}')
    
    # Handle the request
    handle_request "$method" "$path" ""
}

# SOCAT-based server (most robust)
start_socat_server() {
    local host="$1"
    local port="$2"
    
    log_api "Using socat server (recommended)"
    log_success "Server starting on http://${host}:${port}"
    log_api "Press Ctrl+C to stop"
    
    # Create named pipe for handling requests
    local FIFO="/tmp/kompose-api-fifo-$$"
    mkfifo "$FIFO"
    trap "rm -f $FIFO" EXIT
    
    while true; do
        # Use socat to handle HTTP requests
        socat TCP-LISTEN:${port},bind=${host},reuseaddr,fork SYSTEM:"
            read request_line
            method=\$(echo \"\$request_line\" | awk '{print \$1}')
            path=\$(echo \"\$request_line\" | awk '{print \$2}')
            
            # Read and discard headers until empty line
            while read -r header && [ -n \"\$header\" ] && [ \"\$header\" != \$'\\r' ]; do
                :
            done
            
            # Generate response
            exec '$0' --handle-request \"\$method\" \"\$path\"
        " 2>&1 | grep -v "socat\[" || true
        
        sleep 0.1
    done
}

# NC (netcat) based server (fallback)
start_nc_server() {
    local host="$1"
    local port="$2"
    
    log_api "Using netcat server (basic)"
    log_success "Server starting on http://${host}:${port}"
    log_api "Press Ctrl+C to stop"
    
    while true; do
        {
            # Read request
            read -r request_line
            method=$(echo "$request_line" | awk '{print $1}')
            path=$(echo "$request_line" | awk '{print $2}')
            
            # Read and discard headers
            while read -r header && [ -n "$header" ] && [ "$header" != $'\r' ]; do
                :
            done
            
            # Handle request
            handle_request "$method" "$path" ""
            
        } | nc -l -p "$port" 2>/dev/null || nc -l "$port" 2>/dev/null
        
        sleep 0.1
    done
}

# Python HTTP server (best alternative)
start_python_server() {
    local host="$1"
    local port="$2"
    
    log_api "Using Python HTTP server (recommended)"
    log_success "Server starting on http://${host}:${port}"
    
    # Create Python server script
    python3 - "$host" "$port" "$KOMPOSE_SCRIPT" "$API_LOGFILE" <<'PYTHON_EOF'
import sys
import json
import subprocess
from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import urlparse, parse_qs
from datetime import datetime

KOMPOSE_SCRIPT = sys.argv[3]
LOG_FILE = sys.argv[4]

def log_request(method, path, status):
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    with open(LOG_FILE, 'a') as f:
        f.write(f"[{timestamp}] {method} {path} - {status}\n")

def run_kompose(*args):
    try:
        result = subprocess.run(
            [KOMPOSE_SCRIPT] + list(args),
            capture_output=True,
            text=True,
            timeout=30
        )
        return result.stdout + result.stderr
    except subprocess.TimeoutExpired:
        return "ERROR: Command timeout"
    except Exception as e:
        return f"ERROR: {str(e)}"

def json_response(status, message, data=None):
    return {
        "status": status,
        "message": message,
        "data": data,
        "timestamp": datetime.utcnow().isoformat() + "Z"
    }

class KomposeAPIHandler(BaseHTTPRequestHandler):
    def log_message(self, format, *args):
        pass  # Suppress default logging
    
    def send_json_response(self, status_code, data):
        self.send_response(status_code)
        self.send_header('Content-Type', 'application/json; charset=utf-8')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        self.send_header('Server', 'kompose-api/1.0.0')
        self.end_headers()
        self.wfile.write(json.dumps(data, indent=2).encode())
    
    def do_OPTIONS(self):
        self.send_response(204)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        self.end_headers()
        log_request('OPTIONS', self.path, 204)
    
    def do_GET(self):
        parsed_path = urlparse(self.path)
        path = parsed_path.path
        
        try:
            if path == '/api/health':
                data = json_response('success', 'API is healthy', {
                    'version': '1.0.0',
                    'server': 'kompose-api-python'
                })
                self.send_json_response(200, data)
                log_request('GET', path, 200)
            
            elif path == '/api/stacks':
                output = run_kompose('list')
                self.send_json_response(200, json_response('success', 'Stacks retrieved', {'output': output}))
                log_request('GET', path, 200)
            
            elif path.startswith('/api/stacks/'):
                parts = path[12:].split('/')
                stack = parts[0]
                action = parts[1] if len(parts) > 1 else None
                
                if not action:
                    output = run_kompose('status', stack)
                    self.send_json_response(200, json_response('success', 'Stack status', {'stack': stack, 'output': output}))
                elif action == 'logs':
                    output = run_kompose('logs', stack, '--tail=100')
                    self.send_json_response(200, json_response('success', 'Logs retrieved', {'stack': stack, 'logs': output}))
                else:
                    self.send_json_response(400, json_response('error', f'GET not allowed for action: {action}'))
                log_request('GET', path, 200)
            
            elif path.startswith('/api/db/'):
                action = path[8:]
                output = run_kompose('db', action)
                self.send_json_response(200, json_response('success', f'Database {action}', {'output': output}))
                log_request('GET', path, 200)
            
            elif path.startswith('/api/tag/'):
                action = path[9:]
                output = run_kompose('tag', action)
                self.send_json_response(200, json_response('success', f'Tag {action}', {'output': output}))
                log_request('GET', path, 200)
            
            else:
                self.send_json_response(404, json_response('error', f'Endpoint not found: {path}'))
                log_request('GET', path, 404)
        
        except Exception as e:
            self.send_json_response(500, json_response('error', str(e)))
            log_request('GET', path, 500)
    
    def do_POST(self):
        parsed_path = urlparse(self.path)
        path = parsed_path.path
        
        try:
            if path.startswith('/api/stacks/'):
                parts = path[12:].split('/')
                stack = parts[0]
                action = parts[1] if len(parts) > 1 else None
                
                if action == 'start':
                    output = run_kompose('up', stack)
                    self.send_json_response(200, json_response('success', 'Stack started', {'stack': stack, 'output': output}))
                elif action == 'stop':
                    output = run_kompose('down', stack)
                    self.send_json_response(200, json_response('success', 'Stack stopped', {'stack': stack, 'output': output}))
                elif action == 'restart':
                    output = run_kompose('restart', stack)
                    self.send_json_response(200, json_response('success', 'Stack restarted', {'stack': stack, 'output': output}))
                else:
                    self.send_json_response(400, json_response('error', f'Unknown action: {action}'))
                log_request('POST', path, 200)
            else:
                self.send_json_response(404, json_response('error', 'Endpoint not found'))
                log_request('POST', path, 404)
        
        except Exception as e:
            self.send_json_response(500, json_response('error', str(e)))
            log_request('POST', path, 500)

if __name__ == '__main__':
    host = sys.argv[1]
    port = int(sys.argv[2])
    server = HTTPServer((host, port), KomposeAPIHandler)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
    server.server_close()
PYTHON_EOF
}

# ============================================================================
# MAIN SERVER STARTUP
# ============================================================================

start_server() {
    local port="${1:-$API_PORT}"
    local host="${2:-$API_HOST}"
    
    # Store PID
    echo $$ > "$API_PIDFILE"
    
    # Initialize log file
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [STARTUP] Kompose API Server starting..." > "$API_LOGFILE"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [CONFIG] Host: $host, Port: $port" >> "$API_LOGFILE"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [CONFIG] Kompose script: $KOMPOSE_SCRIPT" >> "$API_LOGFILE"
    
    # Verify kompose.sh exists
    if [ ! -f "$KOMPOSE_SCRIPT" ]; then
        log_error "Kompose script not found: $KOMPOSE_SCRIPT"
        exit 1
    fi
    
    # Make kompose.sh executable
    chmod +x "$KOMPOSE_SCRIPT"
    
    # Check for available server implementations
    log_api "Detecting available server implementations..."
    
    if command -v python3 &> /dev/null; then
        log_api "✓ Python 3 detected"
        start_python_server "$host" "$port"
    elif command -v socat &> /dev/null; then
        log_api "✓ socat detected"
        start_socat_server "$host" "$port"
    elif command -v nc &> /dev/null; then
        log_api "✓ netcat detected"
        start_nc_server "$host" "$port"
    else
        log_error "No suitable HTTP server found!"
        echo ""
        echo "Please install one of the following:"
        echo "  - Python 3 (recommended):  apt-get install python3"
        echo "  - socat (good):            apt-get install socat"
        echo "  - netcat (basic):          apt-get install netcat"
        echo ""
        exit 1
    fi
}

# Handle --handle-request internal call
if [ "$1" = "--handle-request" ]; then
    handle_request "$2" "$3" ""
    exit 0
fi

# Check if server is already running
if [ -f "$API_PIDFILE" ]; then
    pid=$(cat "$API_PIDFILE")
    if ps -p "$pid" > /dev/null 2>&1; then
        log_error "API server already running (PID: $pid)"
        log_api "Server URL: http://${API_HOST}:${API_PORT}"
        log_api "To stop: kill $pid"
        exit 1
    else
        log_warning "Stale PID file found, removing..."
        rm -f "$API_PIDFILE"
    fi
fi

# Trap cleanup
cleanup() {
    log_api "Shutting down server..."
    rm -f "$API_PIDFILE"
    exit 0
}

trap cleanup SIGTERM SIGINT

# Start the server
start_server "$@"
