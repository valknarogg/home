# Kompose REST API - Quick Start Guide

Get started with the Kompose REST API in under 5 minutes!

## Step 1: Start the API Server

```bash
cd /path/to/kompose
./kompose.sh api start
```

You should see:
```
[API] Starting REST API server...
[SUCCESS] API server started (PID: 12345)
Server URL: http://127.0.0.1:8080
API Endpoints:
  GET  /api/health                    - Health check
  GET  /api/stacks                    - List all stacks
  ...
```

## Step 2: Test the Connection

```bash
curl http://localhost:8080/api/health
```

Expected response:
```json
{
  "status": "success",
  "message": "API is healthy",
  "data": {
    "version": "1.0.0",
    "server": "kompose-api"
  },
  "timestamp": "2025-01-15T10:30:00Z"
}
```

## Step 3: List Your Stacks

```bash
curl http://localhost:8080/api/stacks | jq .
```

## Step 4: Control a Stack

### Start a stack
```bash
curl -X POST http://localhost:8080/api/stacks/core/start
```

### Stop a stack
```bash
curl -X POST http://localhost:8080/api/stacks/core/stop
```

### View logs
```bash
curl http://localhost:8080/api/stacks/core/logs | jq -r .data.logs
```

## Step 5: Open the Dashboard

Open `dashboard.html` in your browser:

```bash
# macOS
open dashboard.html

# Linux
xdg-open dashboard.html

# Or serve with Python
python3 -m http.server 3000
# Then visit: http://localhost:3000/dashboard.html
```

## Common Commands

### Server Management
```bash
# Check server status
./kompose.sh api status

# View logs
./kompose.sh api logs

# Stop server
./kompose.sh api stop

# Restart with different port
./kompose.sh api start 9000
```

### API Calls
```bash
# List all stacks
curl http://localhost:8080/api/stacks

# Get stack status
curl http://localhost:8080/api/stacks/core

# Start stack
curl -X POST http://localhost:8080/api/stacks/core/start

# Stop stack
curl -X POST http://localhost:8080/api/stacks/core/stop

# Restart stack
curl -X POST http://localhost:8080/api/stacks/core/restart

# Get logs
curl http://localhost:8080/api/stacks/core/logs

# Database status
curl http://localhost:8080/api/db/status

# List backups
curl http://localhost:8080/api/db/list

# List deployment tags
curl http://localhost:8080/api/tag/list
```

## Integration Examples

### JavaScript/Node.js
```javascript
const API = 'http://localhost:8080/api';

// List stacks
const stacks = await fetch(`${API}/stacks`).then(r => r.json());
console.log(stacks.data);

// Start a stack
await fetch(`${API}/stacks/core/start`, { method: 'POST' });
```

### Python
```python
import requests

API = 'http://localhost:8080/api'

# List stacks
stacks = requests.get(f'{API}/stacks').json()
print(stacks['data'])

# Start a stack
requests.post(f'{API}/stacks/core/start')
```

### Shell Script
```bash
#!/bin/bash
API="http://localhost:8080/api"

# Function to start stack
start_stack() {
    curl -X POST "$API/stacks/$1/start"
}

# Function to get status
get_status() {
    curl "$API/stacks/$1" | jq -r .data.output
}

# Usage
start_stack "core"
get_status "core"
```

## Troubleshooting

### Port Already in Use
```bash
# Use a different port
./kompose.sh api start 9000
```

### Cannot Connect
```bash
# Check if server is running
./kompose.sh api status

# Check logs
./kompose.sh api logs

# Ensure netcat is installed
which nc
```

### Install Netcat
```bash
# Debian/Ubuntu
sudo apt-get install netcat

# RHEL/CentOS
sudo yum install nmap-ncat

# macOS
brew install netcat
```

## Security Note

⚠️ By default, the server only accepts connections from localhost (127.0.0.1).

To allow remote access:
```bash
./kompose.sh api start 8080 0.0.0.0
```

**For production:**
- Use a reverse proxy with authentication (Traefik, nginx)
- Implement firewall rules
- Use VPN for remote access
- Never expose directly to the internet without authentication

## Next Steps

1. **Read the full documentation:** `_docs/content/3.guide/api-server.md`
2. **Try the dashboard:** Open `dashboard.html`
3. **Build your own frontend:** Use the API in your applications
4. **Explore all endpoints:** Check `API_README.md`

## Support

- Full Documentation: `_docs/content/3.guide/api-server.md`
- CLI Reference: `_docs/content/4.reference/cli.md`
- API README: `API_README.md`
- Implementation Details: `API_IMPLEMENTATION_SUMMARY.md`

Happy automating! 🚀
