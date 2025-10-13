---
title: Home - Smart Home Automation
description: "Home Assistant + Matter + Zigbee + ESPHome"
navigation:
  icon: i-lucide-home
---

# Home Stack - Smart Home Automation

> *"Your home, truly smart. Your data, truly yours."*

## Overview

The **home** stack provides a complete smart home automation platform with local control and privacy-first design.

**Components:**
- :icon{name="lucide:home"} **Home Assistant** - Smart home hub
- :icon{name="lucide:radio"} **Matter Server** - Next-gen protocol support
- :icon{name="lucide:activity"} **Zigbee2MQTT** - Zigbee device support (optional)
- :icon{name="lucide:cpu"} **ESPHome** - ESP device management (optional)

## Configuration

> **New in v2.0**: Home stack configuration is centralized in the root `.env` file with `HOME_` prefix.

### Environment Variables

All home stack variables in `/home/valknar/Projects/kompose/.env`:

```bash
# ===================================================================
# HOME STACK CONFIGURATION
# ===================================================================
HOME_COMPOSE_PROJECT_NAME=home

# Home Assistant Configuration
HOME_HOMEASSISTANT_IMAGE=ghcr.io/home-assistant/home-assistant:stable
HOME_HOMEASSISTANT_PORT=8123

# Matter Server Configuration
HOME_MATTER_SERVER_IMAGE=ghcr.io/home-assistant-libs/python-matter-server:stable

# Zigbee2MQTT Configuration (Optional)
HOME_ZIGBEE2MQTT_IMAGE=koenkk/zigbee2mqtt:latest
HOME_ZIGBEE2MQTT_PORT=8080
# HOME_ZIGBEE_DEVICE=/dev/ttyUSB0

# ESPHome Configuration (Optional)
HOME_ESPHOME_IMAGE=ghcr.io/esphome/esphome:stable

# Traefik Configuration
# Auto-generated from domain.env:
# TRAEFIK_HOST_HOME=${SUBDOMAIN_HOME}.${ROOT_DOMAIN}  
# TRAEFIK_HOST_ZIGBEE=${SUBDOMAIN_ZIGBEE}.${ROOT_DOMAIN}
```

### Viewing Configuration

```bash
# Show all home stack variables
./kompose.sh env show home

# Validate configuration
./kompose.sh env validate home
```

## Services

### Home Assistant

**Container**: `home_homeassistant`  
**Image**: `ghcr.io/home-assistant/home-assistant:stable`  
**URL**: https://home.pivoine.art  
**Port**: 8123

Your smart home command center:
- :icon{name="lucide:plug"} **2000+ Integrations**: Works with virtually everything
- :icon{name="lucide:bot"} **Powerful Automations**: Create complex workflows
- :icon{name="lucide:palette"} **Beautiful Dashboards**: Customizable UI
- :icon{name="lucide:phone"} **Mobile Apps**: iOS & Android
- :icon{name="lucide:megaphone"} **Voice Control**: Alexa, Google, Siri
- :icon{name="lucide:lock-keyhole"} **Privacy First**: Your data stays local

**Configuration:**
```bash
HOME_HOMEASSISTANT_IMAGE=ghcr.io/home-assistant/home-assistant:stable
HOME_HOMEASSISTANT_PORT=8123
# Domain automatically configured from domain.env:
# TRAEFIK_HOST_HOME=${SUBDOMAIN_HOME}.${ROOT_DOMAIN}
```

### Matter Server

**Container**: `home_matter`  
**Image**: `ghcr.io/home-assistant-libs/python-matter-server:stable`  
**Port**: 5580 (API)  
**Network**: Host mode (required for mDNS)

Next-generation smart home protocol:
- :icon{name="lucide:link"} **Universal Standard**: Works across all platforms
- :icon{name="lucide:shield"} **Secure**: End-to-end encryption
- :icon{name="lucide:home"} **Local Control**: No cloud required
- :icon{name="lucide:smartphone"} **Multi-Admin**: Share devices across platforms
- :icon{name="lucide:zap"} **Fast Setup**: QR code commissioning

**Configuration:**
```bash
HOME_MATTER_SERVER_IMAGE=ghcr.io/home-assistant-libs/python-matter-server:stable
# Uses host networking for mDNS discovery
```

### Zigbee2MQTT (Optional)

**Container**: `home_zigbee2mqtt`  
**Image**: `koenkk/zigbee2mqtt:latest`  
**URL**: https://zigbee.pivoine.art  
**Port**: 8080  
**Profile**: `zigbee`

Zigbee device support:
- :icon{name="lucide:lightbulb"} **Zigbee Lights**: IKEA, Philips, Aqara
- :icon{name="lucide:thermometer"} **Sensors**: Temperature, motion, contact
- :icon{name="lucide:toggle-left"} **Switches**: Smart plugs and buttons
- :icon{name="lucide:globe"} **Web Interface**: Device management UI
- :icon{name="lucide:usb"} **USB Adapter**: Requires ConBee, CC2652, or similar

**Enable:**
```bash
cd home
docker compose --profile zigbee up -d
```

**Configuration:**
```bash
HOME_ZIGBEE2MQTT_IMAGE=koenkk/zigbee2mqtt:latest
HOME_ZIGBEE2MQTT_PORT=8080
HOME_ZIGBEE_DEVICE=/dev/ttyUSB0  # Uncomment and adjust
```

### ESPHome (Optional)

**Container**: `home_esphome`  
**Image**: `ghcr.io/esphome/esphome:stable`  
**Port**: 6052  
**Profile**: `esphome`  
**Network**: Host mode (for device discovery)

ESP device management:
- :icon{name="lucide:wifi"} **DIY Devices**: Build custom sensors
- :icon{name="lucide:upload"} **OTA Updates**: Wireless firmware updates
- :icon{name="lucide:code"} **YAML Config**: Simple device programming
- :icon{name="lucide:zap"} **Auto-Discovery**: Devices appear in Home Assistant

**Enable:**
```bash
cd home
docker compose --profile esphome up -d
```

**Configuration:**
```bash
HOME_ESPHOME_IMAGE=ghcr.io/esphome/esphome:stable
# Uses host networking for device discovery
```

## Quick Start

### 1. Configure Environment

Review home stack settings:

```bash
vim .env
# Scroll to HOME STACK CONFIGURATION
# Verify image versions and ports
```

### 2. Configure USB Devices (Optional)

If using Zigbee or Z-Wave adapters:

```bash
# Find your USB device
ls -la /dev/ttyUSB* /dev/ttyACM*

# Edit .env
vim .env

# Uncomment and set:
HOME_ZIGBEE_DEVICE=/dev/ttyUSB0

# Or edit compose.yaml directly to add device mapping
```

### 3. Ensure Core Stack Running

Home uses MQTT from core stack:

```bash
# Start core if not running
./kompose.sh up core

# Verify MQTT is running
./kompose.sh status core | grep mqtt
```

### 4. Start Home Stack

```bash
# Start basic services (Home Assistant + Matter)
./kompose.sh up home

# Or start with optional services
cd home
docker compose --profile zigbee --profile esphome up -d
```

### 5. Complete Onboarding

```
1. Access: https://home.pivoine.art
2. Create your user account
3. Set up your location
4. Complete the onboarding wizard
```

## Customizing Configuration

### Change Home Assistant Port

```bash
vim .env

# Find and modify:
HOME_HOMEASSISTANT_PORT=8124

# Update compose.yaml port mapping if needed
# Then restart:
./kompose.sh restart home
```

### Enable Zigbee Support

```bash
# 1. Find your Zigbee adapter
ls -la /dev/ttyUSB* /dev/ttyACM*

# 2. Configure device path
vim .env
HOME_ZIGBEE_DEVICE=/dev/ttyUSB0

# 3. Edit compose.yaml to uncomment device mapping
vim home/compose.yaml

# 4. Start with zigbee profile
cd home
docker compose --profile zigbee up -d
```

### Enable ESPHome

```bash
# Start with esphome profile
cd home
docker compose --profile esphome up -d

# Access ESPHome dashboard
# http://localhost:6052
```

## MQTT Integration

Home Assistant connects to MQTT from core stack:

### Configure in Home Assistant

1. Go to **Settings → Devices & Services**
2. Click **Add Integration**
3. Search for **MQTT**
4. Configure:
   - **Broker**: `core-mqtt`
   - **Port**: `1883`
   - **Username**: (leave empty if not configured)
   - **Password**: (leave empty if not configured)
5. Enable **Discovery**
6. Save

### Test MQTT

```bash
# Publish test message
mosquitto_pub -h localhost -t "homeassistant/test" -m "Hello from CLI"

# Subscribe to all home assistant topics
mosquitto_sub -h localhost -t "homeassistant/#" -v
```

## Matter Integration

Matter Server is automatically discovered by Home Assistant:

### Add Matter Devices

1. **In Home Assistant:**
   - Settings → Devices & Services
   - Matter integration should appear
   - Click Configure

2. **Commission Device:**
   - Use Home Assistant mobile app
   - Scan QR code on Matter device
   - Follow commissioning steps

3. **Device Appears:**
   - Automatically added to Home Assistant
   - Configure in Devices & Services

## USB Device Configuration

### Finding Devices

```bash
# List all USB serial devices
ls -la /dev/ttyUSB* /dev/ttyACM*

# Get device info
udevadm info -a /dev/ttyUSB0 | grep '{serial}' | head -n1
```

### Common Devices

| Device | Path | Use Case |
|--------|------|----------|
| ConBee II | `/dev/ttyACM0` | Zigbee |
| CC2531 | `/dev/ttyUSB0` | Zigbee |
| CC2652 | `/dev/ttyUSB0` | Zigbee |
| Aeotec Z-Stick | `/dev/ttyACM0` | Z-Wave |

### Configure in compose.yaml

```yaml
services:
  zigbee2mqtt:
    devices:
      - /dev/ttyUSB0:/dev/ttyUSB0  # Zigbee adapter
```

### Fix Permissions

```bash
# Add user to dialout group
sudo usermod -a -G dialout $USER

# Or set permissions
sudo chmod 666 /dev/ttyUSB0

# Make persistent with udev rule
# See home/README.md for details
```

## Integrations

### Popular Integrations

**Auto-discovered:**
- Philips Hue (via mDNS)
- Google Cast (Chromecast)
- Samsung TV
- DLNA devices

**Manual setup:**
- Google Calendar
- Weather services
- IFTTT
- Spotify
- Ring
- Nest

### Adding Integrations

```
Settings → Devices & Services → Add Integration
Search for your device/service
Follow setup wizard
```

## Automations

### Example: Morning Routine

```yaml
automation:
  - alias: "Morning Routine"
    trigger:
      - platform: time
        at: "07:00:00"
    condition:
      - condition: state
        entity_id: binary_sensor.workday
        state: 'on'
    action:
      - service: light.turn_on
        target:
          entity_id: light.bedroom
        data:
          brightness: 50
      - service: climate.set_temperature
        target:
          entity_id: climate.living_room
        data:
          temperature: 21
```

### Using MQTT for Automation

```yaml
automation:
  - alias: "Respond to MQTT Event"
    trigger:
      - platform: mqtt
        topic: "kompose/home/trigger"
    action:
      - service: light.toggle
        target:
          entity_id: light.living_room
```

## Monitoring

### Health Checks

```bash
# Check Home Assistant
curl -f https://home.pivoine.art

# Check Matter Server
docker exec home_matter python -c "import sys; sys.exit(0)"

# Check MQTT connectivity
mosquitto_pub -h localhost -t "test" -m "ping"
```

### Logs

```bash
# All home services
./kompose.sh logs home -f

# Home Assistant only
docker logs home_homeassistant -f

# Matter Server
docker logs home_matter -f

# Zigbee2MQTT (if enabled)
docker logs home_zigbee2mqtt -f
```

### Resource Usage

```bash
# Container stats
docker stats home_homeassistant home_matter

# Home Assistant system info
# Available in HA UI: Settings → System → Info
```

## Troubleshooting

### Home Assistant Won't Start

```bash
# Check configuration
./kompose.sh env validate home

# Check logs
docker logs home_homeassistant -f

# Check configuration.yaml
docker exec home_homeassistant hass --script check_config
```

### Matter Devices Not Discovering

```bash
# Ensure host networking
docker inspect home_matter | grep NetworkMode
# Should show: "NetworkMode": "host"

# Check Matter Server logs
docker logs home_matter -f

# Verify mDNS traffic
sudo tcpdump -i any port 5353
```

### MQTT Connection Failed

```bash
# Verify core stack running
./kompose.sh status core | grep mqtt

# Test MQTT from Home Assistant container
docker exec home_homeassistant ping core-mqtt

# Check Home Assistant MQTT integration
# Settings → Devices & Services → MQTT
```

### USB Device Not Found

```bash
# List devices
ls -la /dev/ttyUSB* /dev/ttyACM*

# Check permissions
ls -la /dev/ttyUSB0

# Fix permissions
sudo chmod 666 /dev/ttyUSB0

# Check if device is passed to container
docker exec home_zigbee2mqtt ls -la /dev/
```

### Zigbee Devices Not Pairing

```bash
# Check Zigbee2MQTT logs
docker logs home_zigbee2mqtt -f

# Verify coordinator recognized
docker logs home_zigbee2mqtt | grep "Coordinator"

# Enable pairing mode
# In Zigbee2MQTT UI: Enable permit join
# Or via MQTT:
mosquitto_pub -h localhost -t "zigbee2mqtt/bridge/request/permit_join" -m '{"value": true}'
```

## Security

### Best Practices

- :icon{name="lucide:lock-keyhole"} **Strong Password**: Create secure admin account
- :icon{name="lucide:shield"} **2FA**: Enable in user profile
- :icon{name="lucide:globe"} **HTTPS**: Traefik provides SSL
- :icon{name="lucide:key"} **Long-Lived Tokens**: For API access
- :icon{name="lucide:network"} **Trusted Networks**: Configure in settings

### Configure Trusted Networks

```yaml
# configuration.yaml
homeassistant:
  auth_providers:
    - type: trusted_networks
      trusted_networks:
        - 192.168.1.0/24
        - 10.8.0.0/24  # VPN
      allow_bypass_login: true
    - type: homeassistant
```

## Backup & Restore

### Manual Backup

```bash
# Backup Home Assistant config
docker exec home_homeassistant tar czf /config/backup.tar.gz /config

# Copy backup
docker cp home_homeassistant:/config/backup.tar.gz ./ha-backup.tar.gz
```

### Automated Backups

Use Home Assistant built-in backup:
```
Settings → System → Backups → Create Backup
```

### Restore

```
Settings → System → Backups → Upload → Select backup → Restore
```

## See Also

- [Stack Configuration Overview](/reference/stack-configuration)
- [Home Assistant Documentation](https://www.home-assistant.io/docs/)
- [Matter Documentation](https://buildwithmatter.com/)
- [Zigbee2MQTT Documentation](https://www.zigbee2mqtt.io/)
- [ESPHome Documentation](https://esphome.io/)

---

**Configuration Location:** `/home/valknar/Projects/kompose/.env` (HOME section)  
**Data Location:** `home/homeassistant/` (mounted as /config)  
**Default URL:** `https://home.pivoine.art`  
**Depends On:** Core stack (MQTT)
