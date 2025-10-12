---
title: Home - Smart Home Automation Hub
description: "Home Assistant + Matter + Zigbee + ESPHome = Complete Smart Home"
navigation:
  icon: i-lucide-home
---

> *"Your home, truly smart. Your data, truly yours."*

## What's This All About?

The **home** stack is your complete smart home automation platform, bringing together industry-leading open-source tools to create a powerful, privacy-focused smart home system. With Home Assistant at its core, enhanced by Matter protocol support, optional Zigbee connectivity, and ESPHome integration, you can control virtually any smart device while keeping your data local and secure.

## The Stack

### :icon{name="lucide:home"} Home Assistant (Core)

**Container**: `home_homeassistant`  
**Image**: `ghcr.io/home-assistant/home-assistant:stable`  
**URL**: https://home.localhost  
**Port**: 8123

Your smart home's command center:
- :icon{name="lucide:plug"} **2000+ Integrations**: Works with virtually everything
- :icon{name="lucide:bot"} **Powerful Automations**: Create complex workflows
- :icon{name="lucide:palette"} **Beautiful Dashboards**: Customizable UI
- :icon{name="lucide:phone"} **Mobile Apps**: iOS & Android
- :icon{name="lucide:megaphone"} **Voice Control**: Alexa, Google, Siri
- :icon{name="lucide:lock-keyhole"} **Privacy First**: Your data stays local
- :icon{name="lucide:bar-chart"} **Analytics**: Track everything

### :icon{name="lucide:radio"} Matter Server

**Container**: `home_matter`  
**Image**: `ghcr.io/home-assistant-libs/python-matter-server:stable`  
**Port**: 5580 (API)  
**Network**: Host mode (required for mDNS)

Next-generation smart home protocol:
- :icon{name="lucide:link"} **Universal Standard**: Works across all platforms
- :icon{name="lucide:shield"} **Secure by Design**: End-to-end encryption
- :icon{name="lucide:home"} **Local Control**: No cloud required
- :icon{name="lucide:smartphone"} **Multi-Admin**: Share devices across platforms
- :icon{name="lucide:zap"} **Fast Setup**: QR code commissioning

### :icon{name="lucide:activity"} Zigbee2MQTT (Optional)

**Container**: `home_zigbee2mqtt`  
**Image**: `koenkk/zigbee2mqtt:latest`  
**URL**: https://zigbee.localhost  
**Port**: 8080  
**Profile**: `zigbee`

Zigbee device support via MQTT:
- :icon{name="lucide:lightbulb"} **Zigbee Lights**: IKEA, Philips, Aqara
- :icon{name="lucide:thermometer"} **Sensors**: Temperature, motion, contact
- :icon{name="lucide:toggle-left"} **Switches**: Smart plugs and buttons
- :icon{name="lucide:globe"} **Web Interface**: Device management UI
- :icon{name="lucide:usb"} **USB Adapter**: Requires ConBee, CC2652, or similar

**Enable with**:
```bash
cd home
docker compose --profile zigbee up -d
```

### :icon{name="lucide:cpu"} ESPHome (Optional)

**Container**: `home_esphome`  
**Image**: `ghcr.io/esphome/esphome:stable`  
**Port**: 6052  
**Profile**: `esphome`  
**Network**: Host mode (for device discovery)

ESP8266/ESP32 device management:
- :icon{name="lucide:wifi"} **DIY Devices**: Build custom sensors
- :icon{name="lucide:upload"} **OTA Updates**: Wireless firmware updates
- :icon{name="lucide:code"} **YAML Config**: Simple device programming
- :icon{name="lucide:zap"} **Auto-Discovery**: Devices appear in Home Assistant

**Enable with**:
```bash
cd home
docker compose --profile esphome up -d
```

## Architecture

```
┌─────────────────────────────────────────────────────┐
│                  Home Stack                          │
│                                                       │
│  ┌──────────────┐         ┌──────────────┐          │
│  │     Home     │────────▶│    Matter    │          │
│  │  Assistant   │         │    Server    │          │
│  └──────┬───────┘         └──────────────┘          │
│         │                                             │
│         │ MQTT Integration                           │
│         ▼                                             │
│  ┌──────────────┐                                    │
│  │  Mosquitto   │◀───(from core stack)               │
│  │  MQTT Broker │                                    │
│  └──────┬───────┘                                    │
│         │                                             │
│         ├──────▶ Zigbee2MQTT (optional)              │
│         │                                             │
│         └──────▶ ESPHome (optional)                  │
│                                                       │
└─────────────────────────────────────────────────────┘
         │
         ▼
   Smart Devices
   (Lights, Sensors, etc.)
```

## Configuration

### Basic Setup

**Start the stack**:
```bash
./kompose.sh up home
```

**Access Home Assistant**:
- URL: https://home.localhost
- Complete onboarding wizard
- Create admin account

### MQTT Integration

**Add in Home Assistant**:
1. Settings → Devices & Services → Add Integration
2. Search for "MQTT"
3. Configure:
   - **Broker**: `core-mqtt`
   - **Port**: `1883`
   - **Discovery**: Enable

### Matter Integration

**Auto-detected**:
- Matter Server is automatically discovered
- Settings → Devices & Services → Matter
- Use mobile app to scan QR codes

### Optional Profiles

**Enable Zigbee**:
```bash
cd home
docker compose --profile zigbee up -d
```

**Enable ESPHome**:
```bash
cd home
docker compose --profile esphome up -d
```

**Enable both**:
```bash
cd home
docker compose --profile zigbee --profile esphome up -d
```

## USB Device Access

### Finding Devices

```bash
ls -la /dev/ttyUSB* /dev/ttyACM*
```

### Configure in compose.yaml

Uncomment and adjust:
```yaml
devices:
  - /dev/ttyUSB0:/dev/ttyUSB0  # Zigbee adapter
  - /dev/ttyACM0:/dev/ttyACM0  # Z-Wave stick
```

**Common Devices**:
- **ConBee II**: `/dev/ttyACM0`
- **CC2531/CC2652**: `/dev/ttyUSB0`
- **Aeotec Z-Stick**: `/dev/ttyACM0`

## Network Configuration

### Host Networking

**Matter Server** and **ESPHome** use `network_mode: host` because:
- **mDNS Discovery**: Required for device discovery
- **UDP Communication**: Matter uses UDP
- **Thread Support**: IPv6 for Thread devices

### Ports

- **8123** - Home Assistant Web UI
- **5580** - Matter Server API (host network)
- **8080** - Zigbee2MQTT Web UI (if enabled)
- **6052** - ESPHome Dashboard (if enabled, host network)

## Integrations with Other Stacks

### Core Stack
- :icon{name="lucide:database"} **MQTT Broker**: Primary communication
- :icon{name="lucide:cylinder"} **PostgreSQL**: Optional database
- :icon{name="lucide:zap"} **Redis**: Optional caching

### Chain Stack (n8n)
- :icon{name="lucide:workflow"} **Automation**: Advanced workflows
- :icon{name="lucide:webhook"} **Webhooks**: Trigger n8n from HA
- :icon{name="lucide:link"} **API**: Control HA from n8n

### Messaging Stack
- :icon{name="lucide:bell"} **Gotify**: Push notifications
- :icon{name="lucide:mail"} **Mailhog**: Email notifications

### VPN Stack
- :icon{name="lucide:shield"} **WireGuard**: Secure remote access
- :icon{name="lucide:globe"} **VPN**: Access from anywhere

## Documentation

**Comprehensive guides in stack directory**:
- :icon{name="lucide:book-open"} **README.md**: Complete documentation
- :icon{name="lucide:zap"} **QUICK_REFERENCE.md**: Command cheatsheet
- :icon{name="lucide:radio"} **MATTER_SETUP.md**: Matter device guide
- :icon{name="lucide:share-2"} **MQTT_INTEGRATION.md**: MQTT configuration

**Quick Reference**:
```bash
# Start
./kompose.sh up home

# Stop
./kompose.sh down home

# Logs
./kompose.sh logs home -f

# Status
./kompose.sh status home
```

## Troubleshooting

**Home Assistant won't start**:
```bash
./kompose.sh logs home -f
```

**MQTT connection failed**:
```bash
# Verify core stack is running
./kompose.sh status core

# Test connectivity
docker exec home_homeassistant ping core-mqtt
```

**Matter devices not discovering**:
```bash
# Check Matter Server
docker logs home_matter -f

# Verify host networking
docker inspect home_matter | grep NetworkMode
```

**USB device not found**:
```bash
# List devices
ls -la /dev/ttyUSB* /dev/ttyACM*

# Fix permissions
sudo chmod 666 /dev/ttyUSB0
```

## Security

- :icon{name="lucide:lock-keyhole"} **Strong Password**: Create secure admin account
- :icon{name="lucide:shield"} **2FA**: Enable in user profile
- :icon{name="lucide:globe"} **HTTPS**: Traefik provides SSL
- :icon{name="lucide:key"} **Long-Lived Tokens**: For API access
- :icon{name="lucide:network"} **Trusted Networks**: Configure in settings

## Resources

- [Home Assistant Documentation](https://www.home-assistant.io/docs/)
- [Matter Documentation](https://buildwithmatter.com/)
- [Zigbee2MQTT Documentation](https://www.zigbee2mqtt.io/)
- [ESPHome Documentation](https://esphome.io/)
- [Community Forum](https://community.home-assistant.io/)

---

*"The smart home isn't about the technology - it's about making life simpler and more magical."* :icon{name="lucide:sparkles"}:icon{name="lucide:home"}
