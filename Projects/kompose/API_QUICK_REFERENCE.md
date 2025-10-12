# Kompose API Quick Reference

## Server Management

```bash
# Start server (localhost only, port 8080)
./kompose.sh api start

# Start on custom port
./kompose.sh api start 9000

# Start on all interfaces (remote access)
./kompose.sh api start 8080 0.0.0.0

# Check status
./kompose.sh api status

# View logs
./kompose.sh api logs

# Stop server
./kompose.sh api stop
```

## API Endpoints

### Health & Info
```bash
# API information
GET /api

# Health check
GET /api/health
```

### Stack Management
```bash
# List all stacks
GET /api/stacks

# Get stack status
GET /api/stacks/{name}

# Start stack
POST /api/stacks/{name}/start

# Stop stack
POST /api/stacks/{name}/stop

# Restart stack
POST /api/stacks/{name}/restart

# Get logs (last 100 lines)
GET /api/stacks/{name}/logs
```

### Database
```bash
# Database status
GET /api/db/status

# List backups
GET /api/db/list
```

### Tags
```bash
# List deployment tags
GET /api/tag/list
```

## cURL Examples

```bash
# Health check
curl http://localhost:8080/api/health | jq .

# List stacks
curl http://localhost:8080/api/stacks | jq .

# Get stack status
curl http://localhost:8080/api/stacks/core | jq .

# Start stack
curl -X POST http://localhost:8080/api/stacks/core/start | jq .

# Stop stack
curl -X POST http://localhost:8080/api/stacks/core/stop | jq .

# Restart stack
curl -X POST http://localhost:8080/api/stacks/core/restart | jq .

# Get logs
curl http://localhost:8080/api/stacks/core/logs | jq -r '.data.logs'

# Database status
curl http://localhost:8080/api/db/status | jq .

# List backups
curl http://localhost:8080/api/db/list | jq .

# List tags
curl http://localhost:8080/api/tag/list | jq .
```

## Response Format

### Success
```json
{
  "status": "success",
  "message": "Operation successful",
  "data": { /* response data */ },
  "timestamp": "2025-01-15T10:30:00Z"
}
```

### Error
```json
{
  "status": "error",
  "message": "Error description",
  "code": 404,
  "timestamp": "2025-01-15T10:30:00Z"
}
```

## HTTP Status Codes

- `200` OK - Success
- `204` No Content - OPTIONS success
- `400` Bad Request - Invalid parameters
- `404` Not Found - Resource doesn't exist
- `405` Method Not Allowed - Wrong HTTP method
- `500` Internal Server Error - Command failed

## Environment Variables

```bash
export API_PORT=8080              # Default: 8080
export API_HOST=127.0.0.1         # Default: 127.0.0.1
export API_PIDFILE=/tmp/kompose-api.pid
export API_LOGFILE=/tmp/kompose-api.log
export KOMPOSE_SCRIPT=./kompose.sh
```

## JavaScript/TypeScript

```typescript
// API Client
class KomposeAPI {
  constructor(private baseURL = 'http://localhost:8080/api') {}

  async listStacks() {
    const res = await fetch(`${this.baseURL}/stacks`);
    return res.json();
  }

  async startStack(name: string) {
    const res = await fetch(`${this.baseURL}/stacks/${name}/start`, {
      method: 'POST'
    });
    return res.json();
  }

  async getStackLogs(name: string) {
    const res = await fetch(`${this.baseURL}/stacks/${name}/logs`);
    return res.json();
  }
}

// Usage
const api = new KomposeAPI();
const stacks = await api.listStacks();
await api.startStack('core');
const logs = await api.getStackLogs('core');
```

## Python

```python
import requests

class KomposeAPI:
    def __init__(self, base_url="http://localhost:8080/api"):
        self.base_url = base_url
    
    def list_stacks(self):
        return requests.get(f"{self.base_url}/stacks").json()
    
    def start_stack(self, name):
        return requests.post(f"{self.base_url}/stacks/{name}/start").json()
    
    def get_stack_logs(self, name):
        return requests.get(f"{self.base_url}/stacks/{name}/logs").json()

# Usage
api = KomposeAPI()
stacks = api.list_stacks()
api.start_stack('core')
logs = api.get_stack_logs('core')
```

## Testing

```bash
# Run test suite
./test-api.sh

# Test specific endpoint
curl -f http://localhost:8080/api/health && echo "OK" || echo "FAILED"
```

## Troubleshooting

```bash
# Check if server is running
./kompose.sh api status

# Check logs
tail -f /tmp/kompose-api.log

# Find process using port
lsof -i :8080

# Kill server if stuck
kill $(cat /tmp/kompose-api.pid)

# Remove stale PID file
rm -f /tmp/kompose-api.pid
```

## Security

```bash
# Localhost only (default - SAFE)
./kompose.sh api start

# Remote access via SSH tunnel (RECOMMENDED)
ssh -L 8080:localhost:8080 user@server

# All interfaces (USE WITH CAUTION)
./kompose.sh api start 8080 0.0.0.0

# VPN interface only
./kompose.sh api start 8080 10.8.0.1
```

## Server Implementations

The server auto-selects the best available:

1. **Python 3** ⭐ (Recommended)
   - Install: `apt-get install python3`
   - Best performance and reliability

2. **socat** (Good)
   - Install: `apt-get install socat`
   - Reliable alternative

3. **netcat** (Basic)
   - Install: `apt-get install netcat`
   - Minimal fallback

## Files

```
kompose.sh                  - Main CLI
kompose-api-server.sh       - API server
test-api.sh                 - Test suite
/tmp/kompose-api.pid        - PID file
/tmp/kompose-api.log        - Log file
```

## Documentation

- Complete Guide: `_docs/content/3.guide/api-server.md`
- Dashboard Setup: `_docs/content/3.guide/dashboard-setup.md`
- Implementation Summary: `API_SERVER_IMPROVEMENTS.md`
