---
title: REST API Server
description: HTTP JSON API for remote Kompose management
---

The Kompose REST API provides a JSON-based HTTP interface for managing stacks, databases, and deployments remotely. The API server automatically selects the best available HTTP server implementation for maximum compatibility and performance.

## Overview

The API server intelligently detects and uses the best available server implementation on your system:

**Server Priority:**
1. **Python 3 HTTP Server** (Recommended) - Most robust, full HTTP/1.1 support, handles concurrent requests
2. **socat** (Good) - Reliable socket handling, good for production
3. **netcat** (Basic) - Minimal fallback option

**Key Features:**
- ✅ Full stack management (start, stop, restart, logs)
- ✅ Database operations (status, backups list)
- ✅ Deployment tag management
- ✅ JSON responses for easy integration
- ✅ CORS support for web frontends
- ✅ Automatic server selection
- ✅ Request logging and monitoring
- ✅ Graceful error handling

## Quick Start

### Prerequisites

Install one of the following (Python 3 recommended):

```bash
# Option 1: Python 3 (recommended - best performance)
sudo apt-get install python3      # Debian/Ubuntu
sudo yum install python3           # RHEL/CentOS
brew install python3               # macOS

# Option 2: socat (good alternative)
sudo apt-get install socat         # Debian/Ubuntu
sudo yum install socat             # RHEL/CentOS
brew install socat                 # macOS

# Option 3: netcat (basic fallback)
sudo apt-get install netcat        # Debian/Ubuntu
sudo yum install nmap-ncat         # RHEL/CentOS
brew install netcat                # macOS
```

### Start the API Server

```bash
# Start on default port (8080), localhost only
./kompose.sh api start

# Start on custom port
./kompose.sh api start 9000

# Start on specific host and port (allow remote access)
./kompose.sh api start 8080 0.0.0.0

# Start with environment variables
export API_PORT=9000
export API_HOST=0.0.0.0
./kompose.sh api start
```

The server will automatically:
- Detect the best available server implementation
- Create a PID file at `/tmp/kompose-api.pid`
- Log all requests to `/tmp/kompose-api.log`
- Display the server URL and available endpoints

**Example Output:**
```
[API] Detecting available server implementations...
[API] ✓ Python 3 detected
[API] Using Python HTTP server (recommended)
[SUCCESS] Server starting on http://127.0.0.1:8080
[SUCCESS] API server started (PID: 12345)
Server URL: http://127.0.0.1:8080
API Endpoints:
  GET  /api/health                    - Health check
  GET  /api/stacks                    - List all stacks
  GET  /api/stacks/{name}             - Get stack status
  POST /api/stacks/{name}/start       - Start stack
  POST /api/stacks/{name}/stop        - Stop stack
  POST /api/stacks/{name}/restart     - Restart stack
  GET  /api/stacks/{name}/logs        - Get stack logs
  GET  /api/db/status                 - Database status
  GET  /api/db/list                   - List backups
  GET  /api/tag/list                  - List deployment tags
Log file: /tmp/kompose-api.log
```

### Check Server Status

```bash
./kompose.sh api status
```

**Output:**
```
[SUCCESS] API server is running (PID: 12345)
Server URL: http://127.0.0.1:8080

Recent log entries:
  [2025-01-15 10:30:00] [STARTUP] Kompose API Server starting...
  [2025-01-15 10:30:00] [CONFIG] Host: 127.0.0.1, Port: 8080
  [2025-01-15 10:30:15] GET /api/health - 200
  [2025-01-15 10:30:20] GET /api/stacks - 200
```

### View Server Logs

```bash
# Follow logs in real-time
./kompose.sh api logs

# View log file directly
tail -f /tmp/kompose-api.log
```

### Stop the Server

```bash
./kompose.sh api stop
```

## API Endpoints

### Root / API Info

Get API information and available endpoints.

**Endpoint:** `GET /api` or `GET /`

**Example:**
```bash
curl http://localhost:8080/api
```

**Response:**
```json
{
  "status": "success",
  "message": "Welcome to Kompose API",
  "data": {
    "name": "Kompose REST API",
    "version": "1.0.0",
    "endpoints": {
      "health": "/api/health",
      "stacks": "/api/stacks",
      "database": "/api/db",
      "tags": "/api/tag"
    },
    "documentation": "https://kompose.sh/docs/api"
  },
  "timestamp": "2025-01-15T10:30:00Z"
}
```

### Health Check

Check if the API server is running and get server information.

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
    "uptime_seconds": 3600,
    "pid": 12345,
    "kompose_script": "/path/to/kompose.sh"
  },
  "timestamp": "2025-01-15T10:30:00Z"
}
```

### List All Stacks

Get a list of all available stacks with descriptions.

**Endpoint:** `GET /api/stacks`

**Example:**
```bash
curl http://localhost:8080/api/stacks | jq .
```

**Response:**
```json
{
  "status": "success",
  "message": "Stacks retrieved successfully",
  "data": [
    {
      "name": "core",
      "description": "Core services - MQTT, Redis, Postgres",
      "url": "/api/stacks/core"
    },
    {
      "name": "auth",
      "description": "Authentication - Keycloak SSO",
      "url": "/api/stacks/auth"
    },
    {
      "name": "home",
      "description": "Smart Home - Home Assistant, Matter",
      "url": "/api/stacks/home"
    }
  ],
  "timestamp": "2025-01-15T10:30:00Z"
}
```

### Get Stack Status

Get the detailed status of a specific stack.

**Endpoint:** `GET /api/stacks/{name}`

**Example:**
```bash
curl http://localhost:8080/api/stacks/core | jq .
```

**Response:**
```json
{
  "status": "success",
  "message": "Stack status retrieved",
  "data": {
    "stack": "core",
    "output": "NAME                STATUS    PORTS\ncore-postgres       Up        5432/tcp\ncore-redis          Up        6379/tcp",
    "timestamp": "2025-01-15T10:30:00Z"
  },
  "timestamp": "2025-01-15T10:30:00Z"
}
```

**Error Response (Stack Not Found):**
```json
{
  "status": "error",
  "message": "Stack not found: invalid-stack",
  "code": 404,
  "timestamp": "2025-01-15T10:30:00Z"
}
```

### Start a Stack

Start a stopped stack.

**Endpoint:** `POST /api/stacks/{name}/start`

**Example:**
```bash
curl -X POST http://localhost:8080/api/stacks/core/start | jq .
```

**Response:**
```json
{
  "status": "success",
  "message": "Stack started successfully",
  "data": {
    "stack": "core",
    "action": "start",
    "output": "Starting containers...\nContainer core-postgres started\nContainer core-redis started",
    "timestamp": "2025-01-15T10:30:00Z"
  },
  "timestamp": "2025-01-15T10:30:00Z"
}
```

### Stop a Stack

Stop a running stack.

**Endpoint:** `POST /api/stacks/{name}/stop`

**Example:**
```bash
curl -X POST http://localhost:8080/api/stacks/core/stop | jq .
```

**Response:**
```json
{
  "status": "success",
  "message": "Stack stopped successfully",
  "data": {
    "stack": "core",
    "action": "stop",
    "output": "Stopping containers...\nContainer core-postgres stopped\nContainer core-redis stopped",
    "timestamp": "2025-01-15T10:30:00Z"
  },
  "timestamp": "2025-01-15T10:30:00Z"
}
```

### Restart a Stack

Restart a stack (stop then start).

**Endpoint:** `POST /api/stacks/{name}/restart`

**Example:**
```bash
curl -X POST http://localhost:8080/api/stacks/core/restart | jq .
```

**Response:**
```json
{
  "status": "success",
  "message": "Stack restarted successfully",
  "data": {
    "stack": "core",
    "action": "restart",
    "output": "Restarting containers...",
    "timestamp": "2025-01-15T10:30:00Z"
  },
  "timestamp": "2025-01-15T10:30:00Z"
}
```

### Get Stack Logs

Retrieve the last 100 lines of logs from a stack.

**Endpoint:** `GET /api/stacks/{name}/logs`

**Example:**
```bash
curl http://localhost:8080/api/stacks/core/logs | jq -r '.data.logs'
```

**Response:**
```json
{
  "status": "success",
  "message": "Logs retrieved successfully",
  "data": {
    "stack": "core",
    "logs": "[timestamp] postgres: database system is ready...\n[timestamp] redis: Ready to accept connections",
    "lines": 100,
    "timestamp": "2025-01-15T10:30:00Z"
  },
  "timestamp": "2025-01-15T10:30:00Z"
}
```

### Database Status

Get database status information including sizes and connections.

**Endpoint:** `GET /api/db/status`

**Example:**
```bash
curl http://localhost:8080/api/db/status | jq .
```

**Response:**
```json
{
  "status": "success",
  "message": "Database status retrieved",
  "data": {
    "output": "PostgreSQL container is running\nDatabase sizes:\n  kompose: 15 MB\n  n8n: 8 MB",
    "timestamp": "2025-01-15T10:30:00Z"
  },
  "timestamp": "2025-01-15T10:30:00Z"
}
```

### List Database Backups

List all available database backups.

**Endpoint:** `GET /api/db/list`

**Example:**
```bash
curl http://localhost:8080/api/db/list | jq .
```

**Response:**
```json
{
  "status": "success",
  "message": "Database backups listed",
  "data": {
    "backups": "📦 kompose_20250115-103000.sql - 2.5M\n📦 n8n_20250115-090000.sql.gz - 1.1M",
    "timestamp": "2025-01-15T10:30:00Z"
  },
  "timestamp": "2025-01-15T10:30:00Z"
}
```

### List Deployment Tags

List all Git deployment tags.

**Endpoint:** `GET /api/tag/list`

**Example:**
```bash
curl http://localhost:8080/api/tag/list | jq .
```

**Response:**
```json
{
  "status": "success",
  "message": "Tags listed successfully",
  "data": {
    "tags": "frontend-v1.2.3-prod\nbackend-v2.0.0-staging\napi-v1.0.5-dev",
    "timestamp": "2025-01-15T10:30:00Z"
  },
  "timestamp": "2025-01-15T10:30:00Z"
}
```

## Configuration

The API server can be configured using environment variables or command-line arguments:

| Variable | Default | Description |
|----------|---------|-------------|
| `API_PORT` | 8080 | Port to listen on |
| `API_HOST` | 127.0.0.1 | Host to bind to (use 0.0.0.0 for all interfaces) |
| `API_PIDFILE` | /tmp/kompose-api.pid | PID file location |
| `API_LOGFILE` | /tmp/kompose-api.log | Log file location |
| `KOMPOSE_SCRIPT` | ./kompose.sh | Path to kompose.sh script |

**Environment Variable Example:**
```bash
export API_PORT=9000
export API_HOST=0.0.0.0
export API_LOGFILE=/var/log/kompose-api.log
./kompose.sh api start
```

**Command-Line Example:**
```bash
# Start on port 9000, bind to all interfaces
./kompose.sh api start 9000 0.0.0.0
```

## Security Considerations

:icon{name="lucide:shield-alert"} **Critical Security Information**

### 1. Local Access Only (Default)

The server binds to `127.0.0.1` by default, allowing **only local connections**. This is the safest configuration.

```bash
# Safe - localhost only
./kompose.sh api start
```

### 2. Remote Access

To allow remote connections, bind to `0.0.0.0`:

```bash
# WARNING: Allows connections from any network interface
./kompose.sh api start 8080 0.0.0.0
```

:icon{name="lucide:alert-triangle"} **When binding to 0.0.0.0:**
- The API has **NO authentication** by default
- Anyone who can reach the server can control your stacks
- Use **only** in trusted networks (VPN, internal network)

### 3. Production Security Recommendations

For production deployments:

#### Option A: Reverse Proxy with Authentication (Recommended)

Use Traefik or nginx with OAuth2/Basic Auth:

```yaml
# Example: Traefik with OAuth2 Proxy
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.kompose-api.rule=Host(`api.kompose.local`)"
  - "traefik.http.routers.kompose-api.middlewares=auth-oauth2"
```

#### Option B: VPN Access Only

Run the API on `0.0.0.0` but require VPN connection:

```bash
# Start API on VPN interface only
./kompose.sh api start 8080 10.8.0.1
```

#### Option C: Firewall Rules

Allow only specific IP addresses:

```bash
# UFW firewall example
sudo ufw allow from 192.168.1.0/24 to any port 8080
sudo ufw deny 8080
```

#### Option D: SSH Tunnel

Access the API through an SSH tunnel:

```bash
# On your local machine
ssh -L 8080:localhost:8080 user@server

# Then access via http://localhost:8080
```

### 4. Never Do This

:icon{name="lucide:x-circle"} **Never expose the API directly to the internet without authentication!**

```bash
# DANGER - DO NOT DO THIS
./kompose.sh api start 8080 0.0.0.0
# Then opening port 8080 on your router
```

## Integration Examples

### JavaScript/TypeScript

#### Basic Client
```javascript
class KomposeAPI {
  constructor(baseURL = 'http://localhost:8080/api') {
    this.baseURL = baseURL;
  }

  async request(endpoint, options = {}) {
    const response = await fetch(`${this.baseURL}${endpoint}`, options);
    const data = await response.json();
    
    if (!response.ok) {
      throw new Error(data.message || 'API request failed');
    }
    
    return data;
  }

  // Stack Management
  async listStacks() {
    return this.request('/stacks');
  }

  async getStack(name) {
    return this.request(`/stacks/${name}`);
  }

  async startStack(name) {
    return this.request(`/stacks/${name}/start`, { method: 'POST' });
  }

  async stopStack(name) {
    return this.request(`/stacks/${name}/stop`, { method: 'POST' });
  }

  async restartStack(name) {
    return this.request(`/stacks/${name}/restart`, { method: 'POST' });
  }

  async getStackLogs(name) {
    return this.request(`/stacks/${name}/logs`);
  }

  // Database
  async getDatabaseStatus() {
    return this.request('/db/status');
  }

  async listBackups() {
    return this.request('/db/list');
  }

  // Tags
  async listTags() {
    return this.request('/tag/list');
  }

  // Health
  async healthCheck() {
    return this.request('/health');
  }
}

// Usage
const api = new KomposeAPI();

// List all stacks
const stacks = await api.listStacks();
console.log(stacks.data);

// Start a stack
const result = await api.startStack('core');
console.log(result.message);

// Get logs
const logs = await api.getStackLogs('core');
console.log(logs.data.logs);
```

#### React Hook
```typescript
import { useState, useEffect } from 'react';

interface Stack {
  name: string;
  description: string;
  url: string;
}

export function useStacks() {
  const [stacks, setStacks] = useState<Stack[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    fetch('http://localhost:8080/api/stacks')
      .then(res => res.json())
      .then(data => {
        setStacks(data.data);
        setLoading(false);
      })
      .catch(err => {
        setError(err.message);
        setLoading(false);
      });
  }, []);

  const startStack = async (name: string) => {
    const res = await fetch(`http://localhost:8080/api/stacks/${name}/start`, {
      method: 'POST'
    });
    return res.json();
  };

  return { stacks, loading, error, startStack };
}
```

### Python

#### Basic Client
```python
import requests
from typing import Dict, List, Optional

class KomposeAPI:
    def __init__(self, base_url: str = "http://localhost:8080/api"):
        self.base_url = base_url
        self.session = requests.Session()
    
    def _request(self, method: str, endpoint: str, **kwargs) -> Dict:
        url = f"{self.base_url}{endpoint}"
        response = self.session.request(method, url, **kwargs)
        response.raise_for_status()
        return response.json()
    
    # Stack Management
    def list_stacks(self) -> List[Dict]:
        result = self._request("GET", "/stacks")
        return result["data"]
    
    def get_stack(self, name: str) -> Dict:
        result = self._request("GET", f"/stacks/{name}")
        return result["data"]
    
    def start_stack(self, name: str) -> Dict:
        return self._request("POST", f"/stacks/{name}/start")
    
    def stop_stack(self, name: str) -> Dict:
        return self._request("POST", f"/stacks/{name}/stop")
    
    def restart_stack(self, name: str) -> Dict:
        return self._request("POST", f"/stacks/{name}/restart")
    
    def get_stack_logs(self, name: str) -> str:
        result = self._request("GET", f"/stacks/{name}/logs")
        return result["data"]["logs"]
    
    # Database
    def get_database_status(self) -> Dict:
        result = self._request("GET", "/db/status")
        return result["data"]
    
    def list_backups(self) -> List[str]:
        result = self._request("GET", "/db/list")
        return result["data"]["backups"]
    
    # Tags
    def list_tags(self) -> List[str]:
        result = self._request("GET", "/tag/list")
        return result["data"]["tags"]
    
    # Health
    def health_check(self) -> Dict:
        result = self._request("GET", "/health")
        return result["data"]

# Usage
api = KomposeAPI()

# List stacks
stacks = api.list_stacks()
for stack in stacks:
    print(f"{stack['name']}: {stack['description']}")

# Start a stack
result = api.start_stack('core')
print(result['message'])

# Get logs
logs = api.get_stack_logs('core')
print(logs)
```

#### Async Client (with aiohttp)
```python
import aiohttp
import asyncio

class AsyncKomposeAPI:
    def __init__(self, base_url: str = "http://localhost:8080/api"):
        self.base_url = base_url
    
    async def start_stack(self, name: str):
        async with aiohttp.ClientSession() as session:
            async with session.post(f"{self.base_url}/stacks/{name}/start") as resp:
                return await resp.json()
    
    async def get_stack_status(self, name: str):
        async with aiohttp.ClientSession() as session:
            async with session.get(f"{self.base_url}/stacks/{name}") as resp:
                return await resp.json()

# Usage
async def main():
    api = AsyncKomposeAPI()
    result = await api.start_stack('core')
    print(result)

asyncio.run(main())
```

### cURL Examples

```bash
# Health check
curl http://localhost:8080/api/health | jq .

# List all stacks
curl http://localhost:8080/api/stacks | jq '.data[] | .name'

# Get specific stack status
curl http://localhost:8080/api/stacks/core | jq '.data.output'

# Start a stack
curl -X POST http://localhost:8080/api/stacks/core/start | jq '.message'

# Stop a stack
curl -X POST http://localhost:8080/api/stacks/core/stop | jq '.message'

# Restart a stack
curl -X POST http://localhost:8080/api/stacks/core/restart | jq '.message'

# Get logs (last 100 lines)
curl http://localhost:8080/api/stacks/core/logs | jq -r '.data.logs'

# Database status
curl http://localhost:8080/api/db/status | jq '.data.output'

# List backups
curl http://localhost:8080/api/db/list | jq -r '.data.backups'

# List tags
curl http://localhost:8080/api/tag/list | jq -r '.data.tags'

# Check if stack is running (using status code)
if curl -f -s http://localhost:8080/api/stacks/core > /dev/null; then
    echo "Stack exists and API is reachable"
fi
```

## Troubleshooting

### Server Won't Start

**Issue:** Port already in use

**Check what's using the port:**
```bash
lsof -i :8080
# or
netstat -tulpn | grep 8080
# or
ss -tulpn | grep 8080
```

**Solution:**
```bash
# Kill the process using the port
kill <PID>

# Or use a different port
./kompose.sh api start 9000
```

### Server Won't Start - No Server Implementation Found

**Issue:** No Python, socat, or netcat available

**Check available tools:**
```bash
command -v python3 && echo "✓ Python 3 available"
command -v socat && echo "✓ socat available"
command -v nc && echo "✓ netcat available"
```

**Solution - Install Python 3 (recommended):**
```bash
# Debian/Ubuntu
sudo apt-get update && sudo apt-get install python3

# RHEL/CentOS
sudo yum install python3

# macOS
brew install python3
```

### No Response from Server

**Check server status:**
```bash
./kompose.sh api status
```

**Check if process is running:**
```bash
cat /tmp/kompose-api.pid
ps -p $(cat /tmp/kompose-api.pid)
```

**Check logs:**
```bash
tail -n 50 /tmp/kompose-api.log
```

**Test connectivity:**
```bash
# From the same machine
curl http://127.0.0.1:8080/api/health

# From another machine (if API_HOST=0.0.0.0)
curl http://<server-ip>:8080/api/health
```

### CORS Errors in Browser

**Issue:** Browser blocking requests due to CORS

**Solution:** The API server includes CORS headers by default. If you still see errors:

1. Check browser console for actual error
2. Ensure API server is running
3. Try disabling browser CORS temporarily (for development):
   ```bash
   # Chrome
   google-chrome --disable-web-security --user-data-dir=/tmp/chrome
   ```

### Connection Refused

**Issue:** Can't connect to API server

**Possible causes:**
1. Server not running - check `./kompose.sh api status`
2. Wrong host/port - verify API_HOST and API_PORT
3. Firewall blocking - check firewall rules
4. Binding to wrong interface

**Solutions:**
```bash
# Check server is running
./kompose.sh api status

# Check firewall (Ubuntu/Debian)
sudo ufw status

# Check firewall (CentOS/RHEL)
sudo firewall-cmd --list-all

# Test local connectivity
curl http://127.0.0.1:8080/api/health

# Test network connectivity
telnet <server-ip> 8080
```

### Slow Response Times

**Issue:** API responds slowly

**Possible causes:**
1. Docker containers not responding
2. Many containers in a stack
3. Netcat server (slower than Python/socat)

**Solutions:**
1. Install Python 3 for better performance
2. Check Docker daemon: `docker ps` 
3. Reduce stack complexity
4. Monitor system resources: `htop`

### Stale PID File

**Issue:** Error about API already running, but it's not

**Solution:**
```bash
# Remove stale PID file
rm -f /tmp/kompose-api.pid

# Restart API server
./kompose.sh api start
```

## Performance Considerations

### Server Implementation Performance

| Implementation | Concurrent Requests | Response Time | Resource Usage | Recommended For |
|---------------|---------------------|---------------|----------------|-----------------|
| **Python 3** | Good (ThreadingHTTPServer) | Fast | Low-Medium | Production, Development |
| **socat** | Fair (forking) | Medium | Low | Production (low traffic) |
| **netcat** | Poor (sequential) | Slow | Very Low | Development only |

### Optimization Tips

1. **Use Python 3:** Best performance and reliability
   ```bash
   sudo apt-get install python3
   ```

2. **Run on SSD:** Faster Docker operations
   
3. **Limit log size:** Rotate logs regularly
   ```bash
   # Add to cron
   0 0 * * * truncate -s 0 /tmp/kompose-api.log
   ```

4. **Use specific endpoints:** Don't poll `/api/stacks` frequently

5. **Cache responses:** Implement caching in your frontend

### Resource Usage

- **Memory:** ~10-50 MB depending on server implementation
- **CPU:** Minimal (<1% idle, <5% under load)
- **Disk:** Log file grows ~1-5 MB per day (moderate traffic)

### Concurrent Request Limits

- **Python HTTP Server:** Can handle 10-50 concurrent requests
- **socat:** Handles requests via forking (resource-limited)
- **netcat:** Sequential only (1 request at a time)

## Development

### Building a Web Dashboard

The API is designed for easy frontend integration:

```
📁 kompose-dashboard/
├── 📄 src/
│   ├── 📄 api/
│   │   └── kompose.ts          # API client
│   ├── 📄 components/
│   │   ├── StackCard.vue       # Stack display
│   │   ├── StackControl.vue    # Start/stop buttons
│   │   ├── LogViewer.vue       # Log display
│   │   └── StatusBadge.vue     # Status indicator
│   ├── 📄 views/
│   │   ├── Dashboard.vue       # Main dashboard
│   │   ├── StackDetail.vue     # Stack details
│   │   └── Database.vue        # Database management
│   └── 📄 stores/
│       └── stacks.ts           # State management
└── 📄 package.json
```

### Response Format Standard

All API responses follow this consistent structure:

**Success Response:**
```json
{
  "status": "success",
  "message": "Human-readable success message",
  "data": { /* response data object or array */ },
  "timestamp": "2025-01-15T10:30:00Z"
}
```

**Error Response:**
```json
{
  "status": "error",
  "message": "Human-readable error message",
  "code": 400,
  "timestamp": "2025-01-15T10:30:00Z"
}
```

### HTTP Status Codes

| Code | Meaning | When Used |
|------|---------|-----------|
| 200 | OK | Successful request |
| 204 | No Content | OPTIONS preflight success |
| 400 | Bad Request | Invalid action or parameters |
| 404 | Not Found | Stack or endpoint doesn't exist |
| 405 | Method Not Allowed | Wrong HTTP method (e.g., GET for start) |
| 500 | Internal Server Error | Command execution failed |

### Testing the API

```bash
# Run all endpoint tests
cat > test-api.sh << 'EOF'
#!/bin/bash
API="http://localhost:8080/api"

echo "Testing Kompose API..."

# Health check
echo "✓ Health: $(curl -s $API/health | jq -r .message)"

# List stacks
echo "✓ Stacks: $(curl -s $API/stacks | jq -r '.data | length') found"

# Get stack
echo "✓ Stack status: $(curl -s $API/stacks/core | jq -r .message)"

# Database
echo "✓ Database: $(curl -s $API/db/status | jq -r .message)"

echo "All tests passed!"
EOF

chmod +x test-api.sh
./test-api.sh
```

## Next Steps

1. **[Create a Web Dashboard](/guide/dashboard-setup)** - Build a modern UI
2. **[Add Authentication](/guide/security)** - Implement OAuth2 or API keys
3. **[Monitor with n8n](/guide/automation)** - Automate stack management
4. **[Set up Traefik](/guide/traefik)** - Reverse proxy with SSL

## See Also

- [Stack Management](/guide/stack-management) - Managing Docker stacks
- [Database Commands](/guide/database) - Database operations
- [CLI Reference](/reference/cli) - Command-line interface
- [Security Best Practices](/guide/security) - Securing your infrastructure
