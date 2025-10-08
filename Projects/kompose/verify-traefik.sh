#!/usr/bin/env bash

echo "=== KOMPOSE TRAEFIK VERIFICATION ==="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check 1: Network exists
echo "1. Checking if 'kompose' network exists..."
if docker network ls | grep -q "kompose"; then
    echo -e "${GREEN}✓${NC} Network 'kompose' exists"
else
    echo -e "${RED}✗${NC} Network 'kompose' not found"
    echo "Creating network..."
    docker network create kompose
fi
echo ""

# Check 2: Traefik is running
echo "2. Checking Traefik container..."
if docker ps | grep -q "proxy_app"; then
    echo -e "${GREEN}✓${NC} Traefik is running"
    docker ps --filter "name=proxy_app" --format "   Status: {{.Status}}"
else
    echo -e "${RED}✗${NC} Traefik is not running"
fi
echo ""

# Check 3: Blog container is running
echo "3. Checking blog container..."
if docker ps | grep -q "blog_app"; then
    echo -e "${GREEN}✓${NC} Blog is running"
    docker ps --filter "name=blog_app" --format "   Status: {{.Status}}"
else
    echo -e "${YELLOW}!${NC} Blog is not running"
fi
echo ""

# Check 4: Containers on network
echo "4. Containers on 'kompose' network:"
docker network inspect kompose --format '{{range $k, $v := .Containers}}  - {{$v.Name}} ({{$v.IPv4Address}}){{"\n"}}{{end}}' 2>/dev/null
echo ""

# Check 5: Traefik configuration
echo "5. Traefik provider configuration:"
docker exec proxy_app cat /etc/traefik/traefik.yml 2>/dev/null || echo "   Using command-line args"
echo ""

# Check 6: Check routers
echo "6. Active Traefik routers:"
curl -s http://localhost:8080/api/http/routers | jq -r '.[] | "   - \(.name): \(.rule) -> \(.status)"' 2>/dev/null || echo "   Cannot access Traefik API"
echo ""

# Check 7: Check services
echo "7. Active Traefik services:"
curl -s http://localhost:8080/api/http/services | jq -r '.[] | "   - \(.name): \(.status)"' 2>/dev/null || echo "   Cannot access Traefik API"
echo ""

# Check 8: Blog labels
echo "8. Blog container Traefik labels:"
docker inspect blog_app 2>/dev/null | jq -r '.[] | .Config.Labels | to_entries[] | select(.key | startswith("traefik")) | "   \(.key)=\(.value)"' || echo "   Blog container not found"
echo ""

# Check 9: Test HTTP request
echo "9. Testing HTTP request to blog via Traefik:"
echo "   Requesting pivoine.art..."
curl -s -H "Host: pivoine.art" http://localhost/ | head -c 100
echo ""
echo ""

echo "=== TROUBLESHOOTING TIPS ==="
echo "- Traefik dashboard: http://localhost:8080"
echo "- View Traefik logs: docker logs proxy_app"
echo "- Restart stack: ./kompose.sh proxy down && ./kompose.sh proxy up -d"
echo ""
