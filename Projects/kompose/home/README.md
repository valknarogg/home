# Home Stack - Smart Home Services

The Home stack provides comprehensive smart home automation capabilities with Home Assistant as the central hub, integrated with Matter protocol support, MQTT messaging, and support for popular smart home ecosystems like Philips Hue.

## 📦 Services

### Core Services

1. **Home Assistant** (Port 8123)
   - Central smart home hub and automation platform
   - Web-based UI for managing all smart home devices
   - Supports 2000+ integrations including Philips Hue, MQTT, Matter, and more
   - Built-in automation engine

2. **Matter Server**
   - Matter protocol support for next-generation smart home devices
   - Enables Matter device commissioning and control
   - Uses host networking for mDNS discovery
   - API available on port 5580

### Optional Services (Profiles)

3. **Zigbee2MQTT** (Port 8080) - Profile: `zigbee`
   - Zigbee device support via MQTT
   - Web-based management interface
   - Requires USB Zigbee adapter (e.g., ConBee II, CC2531)

4. **ESPHome** - Profile: `esphome`
   - Management and configuration for ESP8266/ESP32 devices
   - OTA updates for IoT devices
   - Uses host networking for device discovery

## 🚀 Quick Start

### 1. Prerequisites

Ensure the core stack is running (for MQTT support):
```bash
cd /path/to/kompose
./kompose.sh up core
```

### 2. Start Home Stack

Basic setup (Home Assistant + Matter):
```bash
./kompose.sh up home
```

With Zigbee support:
```bash
cd home
docker compose --profile zigbee up -d
```

With all optional services:
```bash
cd home
docker compose --profile zigbee --profile esphome up -d
```

### 3. Access Home Assistant

- URL: http://localhost:8123 or https://home.localhost (via Traefik)
- First-time setup: Create your user account
- Follow the onboarding wizard

## 🔧 Configuration

### MQTT Integration

Home Assistant connects to the MQTT broker in the core stack.

**Setup in Home Assistant:**

1. Go to **Settings** → **Devices & Services**
2. Click **Add Integration** → Search for "MQTT"
3. Configure:
   - **Broker:** `core-mqtt`
   - **Port:** `1883`
   - **Username:** (if configured in core stack)
   - **Password:** (if configured in core stack)
4. Click **Submit**

**Verify Connection:**
```bash
# From Home Assistant container
docker exec home_homeassistant mosquitto_pub -h core-mqtt -t "homeassistant/test" -m "Hello"
```

### Matter Device Setup

1. In Home Assistant: **Settings** → **Devices & Services** → **Add Integration** → **Matter**
2. The Matter Server should be automatically detected
3. Follow the commissioning process for your Matter devices
4. Use the Home Assistant Companion app for QR code scanning

### Philips Hue Integration

Philips Hue is automatically discovered by Home Assistant:

1. **Settings** → **Devices & Services**
2. Hue Bridge should appear in **Discovered**
3. Click **Configure** and press the button on your Hue Bridge
4. All lights and accessories will be imported

### Zigbee2MQTT Setup

If using the Zigbee profile:

1. Edit `compose.yaml` and uncomment your Zigbee adapter device:
   ```yaml
   devices:
     - /dev/ttyUSB0:/dev/ttyUSB0
   ```

2. Start with profile:
   ```bash
   docker compose --profile zigbee up -d
   ```

3. Access Zigbee2MQTT UI: http://localhost:8080

4. Configure MQTT connection in Zigbee2MQTT:
   - Create/edit `/app/data/configuration.yaml`:
   ```yaml
   mqtt:
     server: mqtt://core-mqtt:1883
   homeassistant: true
   ```

5. Devices will auto-discover in Home Assistant

### ESPHome Setup

If using the ESPHome profile:

1. Start with profile:
   ```bash
   docker compose --profile esphome up -d
   ```

2. Access ESPHome dashboard: http://localhost:6052

3. Add and configure your ESP devices

4. Devices will auto-discover in Home Assistant

## 🌐 Network Configuration

### Ports

- **8123** - Home Assistant Web UI
- **5580** - Matter Server API (host network)
- **8080** - Zigbee2MQTT Web UI (optional)
- **6052** - ESPHome Dashboard (optional, host network)

### Host Networking

Matter Server and ESPHome use `network_mode: host` because:
- **Matter:** Requires mDNS for device discovery and commissioning
- **ESPHome:** Needs direct network access for device discovery and OTA updates

### Traefik Integration

All services are configured with Traefik labels for HTTPS access:
- Home Assistant: https://home.localhost
- Zigbee2MQTT: https://zigbee.localhost

Configure your hosts in `.env`:
```bash
TRAEFIK_HOST_HOME=home.yourdomain.com
TRAEFIK_HOST_ZIGBEE=zigbee.yourdomain.com
```

## 🔌 USB Device Access

### Finding Your USB Devices

```bash
# List USB devices
ls -la /dev/ttyUSB* /dev/ttyACM*

# Get device information
udevadm info -a -n /dev/ttyUSB0
```

### Configuring USB Devices

Edit `compose.yaml` and uncomment the appropriate device lines:

```yaml
homeassistant:
  devices:
    - /dev/ttyUSB0:/dev/ttyUSB0  # Zigbee adapter
    - /dev/ttyACM0:/dev/ttyACM0  # Z-Wave stick
```

### Common USB Devices

- **ConBee II / RaspBee II:** `/dev/ttyACM0`
- **CC2531 / CC2652:** `/dev/ttyUSB0`
- **Aeotec Z-Stick:** `/dev/ttyACM0`
- **HUSBZB-1:** `/dev/ttyUSB0` (Zigbee), `/dev/ttyUSB1` (Z-Wave)

## 📡 Supported Integrations

### Built-in Support (No Additional Setup)

- **Philips Hue** - Auto-discovery
- **Google Home / Chromecast** - Auto-discovery
- **Apple HomeKit** - Configure in HA
- **SONOS** - Auto-discovery
- **TP-Link Kasa** - Auto-discovery
- **Tuya / Smart Life** - Cloud integration

### Via MQTT (Requires Core Stack)

- Tasmota devices
- ESPHome devices
- Custom IoT sensors
- Node-RED automations

### Via Matter (Next-Gen Devices)

- Matter-certified lights
- Matter-certified sensors
- Matter-certified controllers
- Cross-platform smart home devices

### Via Zigbee (Optional Profile)

- Zigbee lights (Philips, IKEA, etc.)
- Zigbee sensors (temperature, motion, etc.)
- Zigbee switches and buttons

## 🔐 Security

### Initial Setup Security

1. **Create a strong user account** during first-time setup
2. **Enable MFA** in User Profile → Security
3. **Configure trusted networks** in `configuration.yaml`

### MQTT Security

To enable MQTT authentication:

1. In the core stack, configure Mosquitto with password file
2. Update Home Assistant MQTT integration with credentials
3. Update Zigbee2MQTT configuration with credentials

### Exposure Management

Home Assistant should NOT be directly exposed to the internet without:
- Proper authentication (built-in)
- HTTPS via Traefik (configured)
- Rate limiting (configure in Traefik)
- Consider using Home Assistant Cloud for secure remote access

## 🔄 Automation Examples

### MQTT-Based Automation

```yaml
# In Home Assistant configuration.yaml
automation:
  - alias: "Motion detected notification"
    trigger:
      platform: mqtt
      topic: "zigbee2mqtt/motion_sensor/occupancy"
      payload: "true"
    action:
      service: notify.mobile_app
      data:
        message: "Motion detected in living room"
```

### Philips Hue Scene

```yaml
automation:
  - alias: "Evening mood lighting"
    trigger:
      platform: time
      at: "19:00:00"
    action:
      service: hue.activate_scene
      data:
        group_name: "Living Room"
        scene_name: "Evening"
```

### Matter Device Control

```yaml
automation:
  - alias: "Turn on Matter lights"
    trigger:
      platform: state
      entity_id: binary_sensor.front_door
      to: "on"
    action:
      service: light.turn_on
      target:
        entity_id: light.matter_entry_light
```

## 🛠️ Troubleshooting

### Home Assistant not starting

```bash
# Check logs
./kompose.sh logs home -f

# Check container status
docker ps -a | grep homeassistant

# Restart the service
./kompose.sh restart home
```

### MQTT Connection Failed

```bash
# Verify core stack MQTT is running
docker ps | grep mqtt

# Test MQTT connection
docker exec home_homeassistant mosquitto_sub -h core-mqtt -t "#" -v

# Check MQTT logs
./kompose.sh logs core -f | grep mqtt
```

### Matter Devices Not Discovering

1. Ensure Matter Server is running:
   ```bash
   docker ps | grep matter
   ```

2. Matter requires host networking - verify in `compose.yaml`

3. Check Matter Server logs:
   ```bash
   docker logs home_matter -f
   ```

### Zigbee2MQTT Not Connecting

1. Verify USB device permissions:
   ```bash
   ls -la /dev/ttyUSB0
   ```

2. Check Zigbee2MQTT logs:
   ```bash
   docker logs home_zigbee2mqtt -f
   ```

3. Verify MQTT connection in Zigbee2MQTT configuration

### Device Discovery Issues

- Ensure all containers are on the `kompose_network`
- For mDNS-based discovery (Hue, Chromecast), ensure multicast is enabled
- Check firewall rules if running on remote host

## 📚 Additional Resources

- [Home Assistant Documentation](https://www.home-assistant.io/docs/)
- [Matter Documentation](https://home-assistant-libs.github.io/python-matter-server/)
- [Zigbee2MQTT Documentation](https://www.zigbee2mqtt.io/)
- [ESPHome Documentation](https://esphome.io/)
- [MQTT Integration](https://www.home-assistant.io/integrations/mqtt/)
- [Philips Hue Integration](https://www.home-assistant.io/integrations/hue/)

## 🔗 Integration with Other Stacks

### Chain Stack (n8n)

Create n8n workflows that interact with Home Assistant via:
- MQTT messages
- Home Assistant webhooks
- Home Assistant API

### Messaging Stack

Receive notifications via:
- Gotify (push notifications)
- Email via Mailhog (in development)

### VPN Stack

Access Home Assistant securely from anywhere using WireGuard VPN

## 📝 Environment Variables

Key variables in `.env`:

```bash
# Core settings
COMPOSE_PROJECT_NAME=home
NETWORK_NAME=kompose
TIMEZONE=Europe/Amsterdam

# Port mappings
HOMEASSISTANT_PORT=8123
ZIGBEE2MQTT_PORT=8080

# Traefik hosts
TRAEFIK_HOST_HOME=home.localhost
TRAEFIK_HOST_ZIGBEE=zigbee.localhost

# USB devices
# USB_DEVICE_ZIGBEE=/dev/ttyUSB0
```

## 🎯 Best Practices

1. **Regular Backups**: Home Assistant stores config in the volume
   ```bash
   docker cp home_homeassistant:/config ./backups/ha-config-$(date +%Y%m%d)
   ```

2. **Update Regularly**: Keep Home Assistant and integrations updated
   ```bash
   ./kompose.sh pull home
   ./kompose.sh restart home
   ```

3. **Use YAML for Complex Automations**: Store automations in `configuration.yaml` for version control

4. **Monitor Resource Usage**: Home Assistant can be resource-intensive
   ```bash
   docker stats home_homeassistant
   ```

5. **Segment Networks**: Consider VLANs for IoT devices

## 🆘 Support

For issues specific to:
- **kompose.sh**: Check main repository documentation
- **Home Assistant**: [Home Assistant Community](https://community.home-assistant.io/)
- **Matter**: [Matter GitHub Issues](https://github.com/home-assistant-libs/python-matter-server/issues)
- **Zigbee2MQTT**: [Zigbee2MQTT Discussions](https://github.com/Koenkk/zigbee2mqtt/discussions)
