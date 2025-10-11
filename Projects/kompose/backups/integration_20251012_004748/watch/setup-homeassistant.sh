#!/bin/bash

# Home Assistant Integration Setup Script
# This script helps configure the Home Assistant integration with Prometheus

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Home Assistant Integration Setup                        ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Change to watch directory
cd "$(dirname "$0")"

echo -e "${YELLOW}This script will help you configure the Home Assistant integration.${NC}"
echo ""
echo "You need to:"
echo "  1. Create a long-lived access token in Home Assistant"
echo "  2. Update the Prometheus configuration with this token"
echo ""

# Check if Home Assistant is reachable
echo -e "${BLUE}Checking Home Assistant availability...${NC}"
if curl -s -f -o /dev/null http://home_homeassistant:8123; then
    echo -e "${GREEN}✓${NC} Home Assistant is reachable"
else
    echo -e "${RED}✗${NC} Home Assistant is not reachable"
    echo "  Make sure the home stack is running: cd ../../../home && docker compose up -d"
    exit 1
fi

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Step 1: Create Long-Lived Access Token${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "1. Open Home Assistant in your browser:"
echo "   http://home_homeassistant:8123"
echo "   or your configured domain (e.g., https://home.localhost)"
echo ""
echo "2. Log in with your credentials"
echo ""
echo "3. Click on your profile picture (bottom left)"
echo ""
echo "4. Scroll down to 'Long-Lived Access Tokens'"
echo ""
echo "5. Click 'Create Token'"
echo ""
echo "6. Name it: 'Prometheus Monitoring'"
echo ""
echo "7. Copy the generated token (it will only be shown once!)"
echo ""

# Prompt for token
read -p "Paste your token here (input will be hidden): " -s TOKEN
echo ""

if [ -z "$TOKEN" ]; then
    echo -e "${RED}✗${NC} No token provided, exiting"
    exit 1
fi

echo -e "${GREEN}✓${NC} Token received"
echo ""

# Verify token works
echo -e "${BLUE}Verifying token...${NC}"
if curl -s -H "Authorization: Bearer $TOKEN" http://home_homeassistant:8123/api/prometheus | grep -q "homeassistant"; then
    echo -e "${GREEN}✓${NC} Token is valid!"
else
    echo -e "${RED}✗${NC} Token verification failed"
    echo "  The token might be invalid or Home Assistant's Prometheus integration is not enabled"
    exit 1
fi

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Step 2: Update Prometheus Configuration${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Backup current config
if [ -f "prometheus/prometheus.yml" ]; then
    cp prometheus/prometheus.yml "prometheus/prometheus.yml.backup.$(date +%Y%m%d_%H%M%S)"
    echo -e "${GREEN}✓${NC} Backed up current configuration"
fi

# Update the configuration
sed -i "s/bearer_token: 'YOUR_LONG_LIVED_ACCESS_TOKEN'/bearer_token: '$TOKEN'/" prometheus/prometheus.yml

if grep -q "$TOKEN" prometheus/prometheus.yml; then
    echo -e "${GREEN}✓${NC} Configuration updated successfully"
else
    echo -e "${RED}✗${NC} Failed to update configuration"
    exit 1
fi

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Step 3: Restart Prometheus${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

read -p "Restart Prometheus now? (y/n): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    docker compose restart prometheus
    echo -e "${GREEN}✓${NC} Prometheus restarted"
    
    # Wait for Prometheus to come back up
    echo "Waiting for Prometheus to be ready..."
    sleep 5
    
    # Verify the target is up
    echo ""
    echo -e "${BLUE}Checking Home Assistant target status...${NC}"
    sleep 10  # Give it time to scrape
    
    if curl -s http://localhost:9090/api/v1/targets | jq -r '.data.activeTargets[] | select(.labels.job == "homeassistant") | .health' | grep -q "up"; then
        echo -e "${GREEN}✓${NC} Home Assistant target is UP!"
    else
        echo -e "${YELLOW}⚠${NC} Home Assistant target might still be initializing"
        echo "  Check status at: http://localhost:9090/targets"
    fi
else
    echo "Skipping restart. Remember to restart Prometheus manually:"
    echo "  docker compose restart prometheus"
fi

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Setup Complete!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${GREEN}✓${NC} Home Assistant integration configured successfully!"
echo ""
echo "You can now:"
echo "  1. View Home Assistant metrics in Prometheus: http://localhost:9090"
echo "  2. Query example: homeassistant_sensor_temperature_celsius"
echo "  3. Import Home Assistant dashboard in Grafana (ID: 13177)"
echo ""
echo "For more information, see INTEGRATION_GUIDE.md"
echo ""
