#!/bin/bash

# Home Stack Setup Script
# Helps initialize the home stack with proper configuration

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║         Kompose Home Stack - Setup Assistant                  ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if core stack is running
echo -e "${YELLOW}[1/5]${NC} Checking prerequisites..."

if ! docker ps | grep -q "core-mqtt"; then
    echo -e "${YELLOW}⚠️  Warning: MQTT broker (core stack) is not running.${NC}"
    echo -e "   The core stack is required for MQTT integration."
    echo -e "   Would you like to start it now? (y/n)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        cd ..
        ./kompose.sh up core
        cd home
        echo -e "${GREEN}✓ Core stack started${NC}"
    else
        echo -e "${YELLOW}⚠️  Continuing without MQTT. You can start it later with: ./kompose.sh up core${NC}"
    fi
else
    echo -e "${GREEN}✓ Core stack (MQTT) is running${NC}"
fi

# Check for USB devices
echo ""
echo -e "${YELLOW}[2/5]${NC} Checking for USB devices..."
if ls /dev/ttyUSB* 2>/dev/null || ls /dev/ttyACM* 2>/dev/null; then
    echo -e "${GREEN}✓ USB devices found:${NC}"
    ls -la /dev/ttyUSB* /dev/ttyACM* 2>/dev/null || true
    echo ""
    echo -e "   Do you want to configure these devices for Zigbee/Z-Wave? (y/n)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        echo -e "   Please edit compose.yaml to uncomment the device mappings."
        echo -e "   Example: /dev/ttyUSB0:/dev/ttyUSB0"
    fi
else
    echo -e "${YELLOW}⚠️  No USB devices detected${NC}"
    echo -e "   If you plan to use Zigbee/Z-Wave, connect your USB adapter first."
fi

# Configure optional services
echo ""
echo -e "${YELLOW}[3/5]${NC} Optional services configuration..."
echo -e "   Do you want to enable Zigbee2MQTT? (y/n)"
read -r response
ENABLE_ZIGBEE=false
if [[ "$response" =~ ^[Yy]$ ]]; then
    ENABLE_ZIGBEE=true
    echo -e "${GREEN}✓ Zigbee2MQTT will be enabled${NC}"
fi

echo -e "   Do you want to enable ESPHome? (y/n)"
read -r response
ENABLE_ESPHOME=false
if [[ "$response" =~ ^[Yy]$ ]]; then
    ENABLE_ESPHOME=true
    echo -e "${GREEN}✓ ESPHome will be enabled${NC}"
fi

# Start the stack
echo ""
echo -e "${YELLOW}[4/5]${NC} Starting Home Assistant stack..."

if [ "$ENABLE_ZIGBEE" = true ] && [ "$ENABLE_ESPHOME" = true ]; then
    docker compose --profile zigbee --profile esphome up -d
elif [ "$ENABLE_ZIGBEE" = true ]; then
    docker compose --profile zigbee up -d
elif [ "$ENABLE_ESPHOME" = true ]; then
    docker compose --profile esphome up -d
else
    docker compose up -d
fi

echo -e "${GREEN}✓ Stack started successfully${NC}"

# Wait for services to be ready
echo ""
echo -e "${YELLOW}[5/5]${NC} Waiting for services to be ready..."
echo -e "   This may take 30-60 seconds..."

sleep 10

# Check if Home Assistant is responding
for i in {1..12}; do
    if curl -s -f http://localhost:8123 > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Home Assistant is ready!${NC}"
        break
    fi
    if [ $i -eq 12 ]; then
        echo -e "${YELLOW}⚠️  Home Assistant is taking longer than expected to start.${NC}"
        echo -e "   You can check the logs with: ./kompose.sh logs home -f"
    else
        sleep 5
        echo -n "."
    fi
done

# Display access information
echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                    Setup Complete!                             ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}🏠 Home Assistant:${NC} http://localhost:8123"
echo -e "   First-time setup: Create your admin account"
echo ""

if [ "$ENABLE_ZIGBEE" = true ]; then
    echo -e "${GREEN}📡 Zigbee2MQTT:${NC} http://localhost:8080"
    echo ""
fi

if [ "$ENABLE_ESPHOME" = true ]; then
    echo -e "${GREEN}🔌 ESPHome:${NC} http://localhost:6052"
    echo ""
fi

echo -e "${YELLOW}Next Steps:${NC}"
echo -e "1. Complete Home Assistant onboarding wizard"
echo -e "2. Add MQTT integration:"
echo -e "   Settings → Devices & Services → Add Integration → MQTT"
echo -e "   Broker: core-mqtt, Port: 1883"
echo ""
echo -e "3. Add Matter integration:"
echo -e "   Settings → Devices & Services → Add Integration → Matter"
echo -e "   (Should auto-detect the Matter Server)"
echo ""
echo -e "4. Configure Philips Hue (if available):"
echo -e "   Should auto-discover on the network"
echo ""
echo -e "${BLUE}📖 Documentation:${NC}"
echo -e "   • README.md - Full stack documentation"
echo -e "   • MQTT_INTEGRATION.md - MQTT setup guide"
echo -e "   • MATTER_SETUP.md - Matter device guide"
echo ""
echo -e "${GREEN}✓ Setup complete! Enjoy your smart home! 🎉${NC}"
echo ""
