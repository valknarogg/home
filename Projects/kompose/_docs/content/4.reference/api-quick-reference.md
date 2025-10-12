# API Quick Reference

Quick reference for the Kompose REST API.

## Server Management

```bash
# Start API server
./kompose.sh api start [PORT] [HOST]

# Stop API server
./kompose.sh api stop

# Check API status
./kompose.sh api status

# View API logs
./kompose.sh api logs
```

## Endpoint Reference

### Stacks
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/stacks` | List all stacks |
| GET | `/api/stacks/{name}` | Get stack status |
| POST | `/api/stacks/{name}/start` | Start stack |
| POST | `/api/stacks/{name}/stop` | Stop stack |
| POST | `/api/stacks/{name}/restart` | Restart stack |
| GET | `/api/stacks/{name}/logs` | Get stack logs |

### Database
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/db/status` | Database status |
| GET | `/api/db/list` | List backups |

### Deployment
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/tag/list` | List deployment tags |

### System
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/health` | Health check |

## Quick Examples

### cURL
```bash
# List stacks
curl http://localhost:8080/api/stacks | jq .

# Start a stack
curl -X POST http://localhost:8080/api/stacks/core/start

# Get logs
curl http://localhost:8080/api/stacks/core/logs | jq -r .data.logs
```

### JavaScript
```javascript
const API = 'http://localhost:8080/api';

// List stacks
const stacks = await fetch(`${API}/stacks`).then(r => r.json());

// Start a stack
await fetch(`${API}/stacks/core/start`, { method: 'POST' });
```

### Python
```python
import requests

API = 'http://localhost:8080/api'

# List stacks
stacks = requests.get(f'{API}/stacks').json()

# Start a stack
requests.post(f'{API}/stacks/core/start')
```

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

## Configuration

```bash
# Set custom port and host
export API_PORT=9000
export API_HOST=0.0.0.0
./kompose.sh api start
```

## See Also

- [Complete API Guide](/guide/api-server)
- [CLI Reference](/reference/cli)
