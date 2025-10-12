---
title: REST API Server
description: HTTP JSON API for remote Kompose management
---

The Kompose REST API provides a JSON-based HTTP interface for managing stacks, databases, and deployments remotely.

## Overview

The API server uses netcat to create a lightweight HTTP server that exposes all Kompose functionality via REST endpoints.

**Key Features:**
- Full stack management (start, stop, restart, logs)
- Database operations (status, backups)
- Deployment tag management
- JSON responses for easy integration
- CORS support for web frontends

## Quick Start

### Start the API Server

```bash
# Start on default port (8080)
./kompose.sh api start

# Start on custom port
./kompose.sh api start 9000

# Start on specific host and port
./kompose.sh api start 9000 0.0.0.0
```

### Check Server Status

```bash
./kompose.sh api status
```

### View Server Logs

```bash
./kompose.sh api logs
```

### Stop the Server

```bash
./kompose.sh api stop
```

## API Endpoints

### Health Check

Check if the API server is running.

**Endpoint:** `GET /api/health`

**Example:**
```bash
curl http://localhost:8080/api/health
```

**Response:**
```json
{
  "status": "success",
  "message": "API is healthy",
  "data": {
    "version": "1.0.0",
    "server": "kompose-api",
    "uptime": "3600 seconds"
  },
  "timestamp": "2025-01-15T10:30:00Z"
}
```

### List All Stacks

Get a list of all available stacks.

**Endpoint:** `GET /api/stacks`

**Example:**
```bash
curl http://localhost:8080/api/stacks
```

**Response:**
```json
{
  "status": "success",
  "message": "Stacks retrieved",
  "data": [
    {
      "name": "core",
      "description": "Core services - MQTT, Redis, Postgres",
      "path": "/api/stacks/core"
    },
    {
      "name": "auth",
      "description": "Authentication - Keycloak SSO",
      "path": "/api/stacks/auth"
    }
  ],
  "timestamp": "2025-01-15T10:30:00Z"
}
```

### Get Stack Status

Get the status of a specific stack.

**Endpoint:** `GET /api/stacks/{name}`

**Example:**
```bash
curl http://localhost:8080/api/stacks/core
```

**Response:**
```json
{
  "status": "success",
  "message": "Stack status retrieved",
  "data": {
    "stack": "core",
    "output": "Container status information..."
  },
  "timestamp": "2025-01-15T10:30:00Z"
}
```

### Start a Stack

Start a stopped stack.

**Endpoint:** `POST /api/stacks/{name}/start`

**Example:**
```bash
curl -X POST http://localhost:8080/api/stacks/core/start
```

**Response:**
```json
{
  "status": "success",
  "message": "Stack started successfully",
  "data": {
    "stack": "core",
    "action": "start",
    "output": "Starting containers..."
  },
  "timestamp": "2025-01-15T10:30:00Z"
}
```

### Stop a Stack

Stop a running stack.

**Endpoint:** `POST /api/stacks/{name}/stop`

**Example:**
```bash
curl -X POST http://localhost:8080/api/stacks/core/stop
```

**Response:**
```json
{
  "status": "success",
  "message": "Stack stopped successfully",
  "data": {
    "stack": "core",
    "action": "stop",
    "output": "Stopping containers..."
  },
  "timestamp": "2025-01-15T10:30:00Z"
}
```

### Restart a Stack

Restart a stack.

**Endpoint:** `POST /api/stacks/{name}/restart`

**Example:**
```bash
curl -X POST http://localhost:8080/api/stacks/core/restart
```

### Get Stack Logs

Retrieve logs from a stack (last 100 lines).

**Endpoint:** `GET /api/stacks/{name}/logs`

**Example:**
```bash
curl http://localhost:8080/api/stacks/core/logs
```

**Response:**
```json
{
  "status": "success",
  "message": "Logs retrieved",
  "data": {
    "stack": "core",
    "logs": "Log output from containers..."
  },
  "timestamp": "2025-01-15T10:30:00Z"
}
```

### Database Status

Get database status information.

**Endpoint:** `GET /api/db/status`

**Example:**
```bash
curl http://localhost:8080/api/db/status
```

### List Database Backups

List all available database backups.

**Endpoint:** `GET /api/db/list`

**Example:**
```bash
curl http://localhost:8080/api/db/list
```

### List Deployment Tags

List all Git deployment tags.

**Endpoint:** `GET /api/tag/list`

**Example:**
```bash
curl http://localhost:8080/api/tag/list
```

## Configuration

The API server can be configured using environment variables:

| Variable | Default | Description |
|----------|---------|-------------|
| `API_PORT` | 8080 | Port to listen on |
| `API_HOST` | 127.0.0.1 | Host to bind to |
| `API_PIDFILE` | /tmp/kompose-api.pid | PID file location |
| `API_LOGFILE` | /tmp/kompose-api.log | Log file location |

**Example:**
```bash
export API_PORT=9000
export API_HOST=0.0.0.0
./kompose.sh api start
```

## Security Considerations

:icon{name="lucide:alert-triangle"} **Important Security Notes:**

1. **Local Access Only (Default):** The server binds to `127.0.0.1` by default, allowing only local connections.

2. **Remote Access:** To allow remote connections, bind to `0.0.0.0`:
   ```bash
   ./kompose.sh api start 8080 0.0.0.0
   ```

3. **Authentication:** The current implementation has no built-in authentication. For production use:
   - Use a reverse proxy (Traefik, nginx) with authentication
   - Implement firewall rules
   - Use VPN for remote access

4. **Network Exposure:** Never expose the API directly to the internet without proper authentication and encryption.

## Integration Examples

### JavaScript/Node.js

```javascript
const API_URL = 'http://localhost:8080/api';

// List all stacks
async function listStacks() {
  const response = await fetch(`${API_URL}/stacks`);
  const data = await response.json();
  console.log(data.data);
}

// Start a stack
async function startStack(name) {
  const response = await fetch(`${API_URL}/stacks/${name}/start`, {
    method: 'POST'
  });
  const data = await response.json();
  return data;
}

// Get stack status
async function getStackStatus(name) {
  const response = await fetch(`${API_URL}/stacks/${name}`);
  const data = await response.json();
  return data;
}
```

### Python

```python
import requests

API_URL = 'http://localhost:8080/api'

def list_stacks():
    response = requests.get(f'{API_URL}/stacks')
    return response.json()

def start_stack(name):
    response = requests.post(f'{API_URL}/stacks/{name}/start')
    return response.json()

def get_stack_status(name):
    response = requests.get(f'{API_URL}/stacks/{name}')
    return response.json()

# Example usage
stacks = list_stacks()
print(stacks['data'])

result = start_stack('core')
print(result['message'])
```

### cURL

```bash
# List stacks
curl http://localhost:8080/api/stacks | jq .

# Start stack
curl -X POST http://localhost:8080/api/stacks/core/start | jq .

# Get logs
curl http://localhost:8080/api/stacks/core/logs | jq -r .data.logs

# Database status
curl http://localhost:8080/api/db/status | jq .
```

## Troubleshooting

### Server Won't Start

**Issue:** Port already in use

**Solution:**
```bash
# Check what's using the port
lsof -i :8080

# Use a different port
./kompose.sh api start 9000
```

### No Response from Server

**Check server status:**
```bash
./kompose.sh api status
```

**Check logs:**
```bash
./kompose.sh api logs
```

**Verify netcat is installed:**
```bash
which nc
```

### Netcat Not Installed

**Install netcat:**

```bash
# Debian/Ubuntu
sudo apt-get install netcat

# RHEL/CentOS
sudo yum install nmap-ncat

# macOS
brew install netcat
```

## Development

### Building a Frontend

The API is designed to be consumed by web frontends. Example frontend structure:

```javascript
// Frontend App Structure
- src/
  - api/
    - kompose.js       # API client
  - components/
    - StackList.vue    # Display stacks
    - StackControl.vue # Start/stop buttons
    - Logs.vue         # Log viewer
  - views/
    - Dashboard.vue    # Main dashboard
```

### Response Format

All API responses follow this structure:

**Success:**
```json
{
  "status": "success",
  "message": "Operation description",
  "data": { /* response data */ },
  "timestamp": "ISO 8601 timestamp"
}
```

**Error:**
```json
{
  "status": "error",
  "message": "Error description",
  "code": 400,
  "timestamp": "ISO 8601 timestamp"
}
```

## Performance

The netcat-based server is lightweight but has limitations:

- **Concurrent Requests:** Handles one request at a time
- **Best For:** Low-traffic management interfaces
- **Not Recommended For:** High-load production APIs

For production use with high traffic, consider:
- Implementing a proper HTTP server (Node.js, Python Flask, Go)
- Using the API as inspiration for a more robust implementation

## Next Steps

1. **Create a frontend:** Build a web UI consuming the API
2. **Add authentication:** Implement token-based auth for remote access
3. **Monitoring:** Integrate with monitoring tools via the API
4. **Automation:** Create scripts that use the API for batch operations

## See Also

- [Stack Management](/guide/stack-management)
- [Database Commands](/guide/database)
- [CLI Reference](/reference/cli)
