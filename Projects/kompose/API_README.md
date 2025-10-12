# Kompose REST API Server

A lightweight REST API server for managing Kompose stacks remotely using JSON over HTTP.

## Features

- 🚀 **Full Stack Management** - Start, stop, restart, and monitor stacks
- 📊 **Database Operations** - Check status and list backups
- 🏷️ **Deployment Tags** - Manage Git-based deployments
- 🔌 **JSON API** - Easy integration with any HTTP client
- 🌐 **CORS Support** - Ready for web frontends
- ⚡ **Lightweight** - Uses netcat for minimal overhead

## Quick Start

```bash
# Start the API server
./kompose.sh api start

# The server will be available at http://127.0.0.1:8080
```

## API Endpoints

### Stacks
- `GET /api/stacks` - List all stacks
- `GET /api/stacks/{name}` - Get stack status
- `POST /api/stacks/{name}/start` - Start stack
- `POST /api/stacks/{name}/stop` - Stop stack
- `POST /api/stacks/{name}/restart` - Restart stack
- `GET /api/stacks/{name}/logs` - Get stack logs

### Database
- `GET /api/db/status` - Database status
- `GET /api/db/list` - List backups

### Tags
- `GET /api/tag/list` - List deployment tags

### Health
- `GET /api/health` - Server health check

## Examples

### cURL

```bash
# List all stacks
curl http://localhost:8080/api/stacks | jq .

# Start a stack
curl -X POST http://localhost:8080/api/stacks/core/start

# Get stack logs
curl http://localhost:8080/api/stacks/core/logs | jq -r .data.logs
```

### JavaScript

```javascript
// List stacks
const response = await fetch('http://localhost:8080/api/stacks');
const data = await response.json();
console.log(data.data);

// Start a stack
await fetch('http://localhost:8080/api/stacks/core/start', {
  method: 'POST'
});
```

### Python

```python
import requests

# List stacks
response = requests.get('http://localhost:8080/api/stacks')
stacks = response.json()
print(stacks['data'])

# Start a stack
requests.post('http://localhost:8080/api/stacks/core/start')
```

## Configuration

Set these environment variables before starting:

```bash
export API_PORT=9000        # Default: 8080
export API_HOST=0.0.0.0     # Default: 127.0.0.1
./kompose.sh api start
```

## Security

⚠️ **Important:** The API has no built-in authentication. For production:

1. Use a reverse proxy with authentication (Traefik, nginx)
2. Implement firewall rules
3. Use VPN for remote access
4. Never expose directly to the internet

## Requirements

- `netcat` (nc) must be installed
- Bash 4.0 or higher
- Running Kompose installation

## Documentation

For complete documentation, see:
- [API Server Guide](/_docs/content/3.guide/api-server.md)
- [CLI Reference](/_docs/content/4.reference/cli.md)

## Response Format

All responses follow this structure:

```json
{
  "status": "success|error",
  "message": "Human-readable message",
  "data": { },
  "timestamp": "2025-01-15T10:30:00Z"
}
```

## License

Part of the Kompose project.
