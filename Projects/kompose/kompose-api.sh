#!/bin/bash

# kompose-api.sh - API Server Management Functions
# Part of kompose.sh - Docker Compose Stack Manager

# ============================================================================
# API SERVER MANAGEMENT FUNCTIONS
# ============================================================================

api_start() {
    local port="${1:-$API_PORT}"
    local host="${2:-$API_HOST}"
    
    # Check if server script exists
    if [ ! -f "$API_SERVER_SCRIPT" ]; then
        log_error "API server script not found: $API_SERVER_SCRIPT"
        log_info "Expected at: $API_SERVER_SCRIPT"
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
