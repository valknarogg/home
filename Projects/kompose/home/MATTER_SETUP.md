# Matter Setup Guide

This guide covers the setup and configuration of Matter devices with Home Assistant in the kompose.sh home stack.

## What is Matter?

Matter is a unified, open-source connectivity standard for smart home devices, backed by the Connectivity Standards Alliance (CSA). It enables seamless communication between devices from different manufacturers.

### Key Benefits

- **Interoperability**: Works across different ecosystems (Apple Home, Google Home, Amazon Alexa, Home Assistant)
- **Local Control**: Operates on your local network without cloud dependency
- **Security**: Built-in end-to-end encryption
- **Reliability**: Standardized communication protocol
- **Future-proof**: Industry-wide adoption and support

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Home Network (Host)                      │
│                                                             │
│  ┌────────────────┐         ┌─────────────────┐           │
│  │ Home Assistant │◄────────┤  Matter Server  │           │
│  │   (Port 8123)  │         │   (Port 5580)   │           │
│  └────────────────┘         └─────────────────┘           │
│         ▲                            ▲                      │
│         │                            │                      │
│         │ Auto-                      │ mDNS                │
│         │ discovery                  │ Discovery           │
│         │                            │                      │
│  ┌──────┴──────────────────────────┴─────────┐            │
│  │         Matter-compatible Devices          │            │
│  │  • Lights  • Sensors  • Controllers        │            │
│  └────────────────────────────────────────────┘            │
│                                                             │
│  Note: network_mode: host required for mDNS                │
└─────────────────────────────────────────────────────────────┘
```

## Prerequisites

### System Requirements

1. **Docker with host networking support**
2. **IPv6 support** (recommended for Thread devices)
3. **mDNS/Avahi** enabled on host system
4. **Matter-compatible devices**

### Verify Prerequisites

```bash
# Check Docker version
docker --version

# Check if IPv6 is enabled
ip -6 addr show

# Check if mDNS service is running (Linux)
systemctl status avahi-daemon

# For macOS
dns-sd -B _matter._tcp
```

## Initial Setup

### 1. Start the Home Stack

```bash
# Start Home Assistant and Matter Server
./kompose.sh up home

# Verify services are running
docker ps | grep -E "homeassistant|matter"
```

### 2. Verify Matter Server

```bash
# Check Matter Server logs
docker logs home_matter -f

# You should see:
# "Starting Matter Server"
# "Matter Server started on port 5580"
```

### 3. Add Matter Integration in Home Assistant

1. **Open Home Assistant**: http://localhost:8123

2. **Navigate to Integrations**:
   - Settings → Devices & Services → Add Integration

3. **Search for "Matter"** and click on it

4. **Configure Matter Server**:
   - The Matter Server should be **auto-detected**
   - URL: `ws://localhost:5580/ws`
   - Click **Submit**

5. **Integration Added**:
   - You should see "Matter (BETA)" in your integrations
   - Status: Connected

## Commissioning Matter Devices

### Method 1: QR Code (Recommended)

1. **Prepare Your Device**:
   - Put your Matter device in pairing mode
   - Locate the QR code (on device, box, or manual)

2. **Commission via Home Assistant Mobile App**:
   - Open **Home Assistant Companion App** on your phone
   - Tap **Settings → Companion App → Matter**
   - Tap **Commission Matter Device**
   - Scan the QR code on your device
   - Follow the on-screen instructions

3. **Device Appears in Home Assistant**:
   - The device will automatically appear in Home Assistant
   - Configure via **Settings → Devices & Services → Matter**

### Method 2: Manual Code Entry

1. **Get the Manual Pairing Code**:
   - Usually an 11-digit code on the device label

2. **Commission in Home Assistant**:
   - Settings → Devices & Services → Matter
   - Click **Add Device**
   - Click **Commission with Code**
   - Enter the manual pairing code
   - Follow the prompts

### Method 3: Thread Devices (via Border Router)

For Thread-based Matter devices, you need a Thread Border Router:

**Compatible Thread Border Routers**:
- Apple HomePod mini
- Apple TV 4K (2021+)
- Google Nest Hub (2nd gen)
- Google Nest WiFi Pro

**Setup**:
1. Set up your Thread Border Router
2. Commission Matter device via the border router's app
3. Share device to Home Assistant using Matter multi-admin

## Multi-Admin (Multi-Fabric)

Matter supports sharing devices across multiple platforms simultaneously.

### Share Device to Home Assistant

If you've already commissioned a device to Apple Home, Google Home, or Alexa:

1. **In Original Platform** (e.g., Apple Home):
   - Open the device settings
   - Find "Share Device" or "Multi-Admin"
   - Generate a new pairing code

2. **In Home Assistant**:
   - Settings → Devices & Services → Matter
   - Click **Add Device**
   - Use the generated pairing code

3. **Device Now Controlled by Both**:
   - Changes in either platform sync automatically
   - No cloud required - works locally

## Supported Device Types

### Currently Supported (Matter 1.0+)

- ✅ **Lights** (On/Off, Dimmable, Color)
- ✅ **Switches** (On/Off switches, Smart plugs)
- ✅ **Sensors**:
  - Contact sensors (door/window)
  - Motion sensors
  - Temperature sensors
  - Humidity sensors
  - Light sensors
- ✅ **Controllers** (Buttons, remotes)
- ✅ **Locks** (Smart locks)
- ✅ **Thermostats**
- ✅ **Blinds/Shades**
- ✅ **Door Controllers**

### Coming Soon (Future Matter Versions)

- 🔜 **Cameras** (Matter 1.2+)
- 🔜 **Appliances** (Matter 1.3+)
- 🔜 **Energy Management**
- 🔜 **Robot Vacuums**

## Configuration

### Matter Server Configuration

The Matter Server runs with default settings. Advanced configuration:

```bash
# Access Matter Server data directory
docker exec home_matter ls /data

# Configuration files location
/data/matter_server.json
```

### Network Configuration

**Important**: The Matter Server uses `network_mode: host` because:
1. **mDNS Discovery**: Required for device discovery
2. **UDP/Thread**: Matter uses UDP for communication
3. **IPv6**: Needed for Thread devices

**Firewall Rules** (if applicable):

```bash
# Allow mDNS
sudo ufw allow 5353/udp

# Allow Matter commissioning
sudo ufw allow 5540/udp

# Allow Matter Server API
sudo ufw allow 5580/tcp
```

## Automations with Matter Devices

### Example: Motion-Activated Lights

```yaml
# In Home Assistant configuration.yaml or automations.yaml
automation:
  - alias: "Hallway Motion Lights"
    trigger:
      - platform: state
        entity_id: binary_sensor.hallway_motion
        to: "on"
    action:
      - service: light.turn_on
        target:
          entity_id: light.hallway_light
        data:
          brightness_pct: 80
  
  - alias: "Hallway Motion Lights Off"
    trigger:
      - platform: state
        entity_id: binary_sensor.hallway_motion
        to: "off"
        for:
          minutes: 5
    action:
      - service: light.turn_off
        target:
          entity_id: light.hallway_light
```

### Example: Smart Button Actions

```yaml
automation:
  - alias: "Button Single Press - Toggle Light"
    trigger:
      - platform: event
        event_type: matter_event
        event_data:
          device_id: "your_button_device_id"
          command: "Press"
    action:
      - service: light.toggle
        target:
          entity_id: light.living_room
  
  - alias: "Button Double Press - Scene"
    trigger:
      - platform: event
        event_type: matter_event
        event_data:
          device_id: "your_button_device_id"
          command: "MultiPressComplete"
          count: 2
    action:
      - service: scene.turn_on
        target:
          entity_id: scene.movie_time
```

## Integration with n8n (Chain Stack)

Create n8n workflows triggered by Matter devices:

### Example n8n Workflow

**Trigger**: Matter sensor state change
**Action**: Send notification, log to database, etc.

**n8n Webhook Configuration**:
1. In Home Assistant, create automation with webhook
2. Configure n8n webhook node to receive the event
3. Add logic to process and act on sensor data

```yaml
# Home Assistant automation
automation:
  - alias: "Matter Sensor to n8n"
    trigger:
      - platform: state
        entity_id: sensor.front_door
    action:
      - service: rest_command.send_to_n8n
        data:
          sensor: "{{ trigger.entity_id }}"
          state: "{{ trigger.to_state.state }}"
          timestamp: "{{ now() }}"
```

## Troubleshooting

### Matter Server Not Starting

**Symptoms**: Container exits or restarts repeatedly

**Solutions**:

1. **Check logs**:
   ```bash
   docker logs home_matter -f
   ```

2. **Verify host networking**:
   ```bash
   docker inspect home_matter | grep -i network
   # Should show: "NetworkMode": "host"
   ```

3. **Check AppArmor** (if using):
   ```bash
   docker exec home_matter cat /proc/self/attr/current
   # Should show: unconfined
   ```

4. **Restart the service**:
   ```bash
   ./kompose.sh restart home
   ```

### Device Commissioning Fails

**Problem**: Device won't pair or commission

**Solutions**:

1. **Reset the Matter device**:
   - Follow manufacturer's reset instructions
   - Usually hold button for 10+ seconds

2. **Check network connectivity**:
   - Ensure device is on same network as Home Assistant
   - Check Wi-Fi signal strength

3. **Verify QR code/pairing code**:
   - Ensure code is not damaged
   - Try manual code if QR scan fails

4. **Check Matter Server status**:
   ```bash
   docker ps | grep matter
   docker logs home_matter -f
   ```

5. **Restart commissioning process**:
   - Close and reopen the app
   - Remove partial device and start fresh

### Device Not Responding

**Problem**: Device commissioned but not responding to commands

**Solutions**:

1. **Check device power**: Ensure device is powered and online

2. **Verify in Matter integration**:
   - Settings → Devices & Services → Matter
   - Check device status

3. **Check Home Assistant logs**:
   ```bash
   ./kompose.sh logs home -f | grep -i matter
   ```

4. **Re-commission device** if necessary:
   - Remove device from Home Assistant
   - Factory reset the device
   - Commission again

### mDNS Discovery Issues

**Problem**: Devices not discoverable

**Solutions**:

1. **Install Avahi** (Linux):
   ```bash
   sudo apt-get install avahi-daemon avahi-utils
   sudo systemctl enable avahi-daemon
   sudo systemctl start avahi-daemon
   ```

2. **Check firewall**:
   ```bash
   sudo ufw allow 5353/udp
   ```

3. **Verify mDNS is working**:
   ```bash
   avahi-browse -a
   # Should list discoverable services
   ```

4. **For Docker on Mac/Windows**:
   - Ensure Docker Desktop has necessary permissions
   - mDNS should work out of the box

### Thread Border Router Issues

**Problem**: Thread devices not connecting

**Solutions**:

1. **Verify border router is active**:
   - Check in respective app (Apple Home, Google Home)
   - Ensure it's on same network

2. **Check Thread network status**:
   - In the border router's app
   - Verify Thread network is operational

3. **Commission device directly**:
   - Commission to border router first
   - Then share to Home Assistant via multi-admin

## Best Practices

### Security

1. **Keep firmware updated**: Regularly update Matter devices
2. **Use strong network security**: WPA3 if supported
3. **Segment IoT network**: Consider VLAN for smart home devices
4. **Monitor access**: Regularly review commissioned devices

### Performance

1. **Wi-Fi optimization**:
   - Ensure strong signal to all Matter devices
   - Use 5GHz when possible for better performance

2. **Thread network**:
   - Place border router centrally
   - Add multiple Thread devices to strengthen mesh

3. **Minimize hops**:
   - Place Home Assistant server close to devices
   - Use wired connection for server

### Maintenance

1. **Regular backups**:
   ```bash
   docker cp home_homeassistant:/config ./backups/ha-config-$(date +%Y%m%d)
   docker cp home_matter:/data ./backups/matter-data-$(date +%Y%m%d)
   ```

2. **Update containers**:
   ```bash
   ./kompose.sh pull home
   ./kompose.sh restart home
   ```

3. **Monitor logs**:
   ```bash
   ./kompose.sh logs home -f
   ```

## Recommended Matter Devices

### Lights
- **Philips Hue** (via Matter-enabled bridge)
- **Nanoleaf** (Thread-based)
- **IKEA DIRIGERA** products

### Sensors
- **Eve Motion** (Thread)
- **Eve Door & Window** (Thread)
- **Aqara sensors** (via Matter bridge)

### Switches & Plugs
- **Eve Energy** (Thread)
- **Meross smart plugs**
- **TP-Link Tapo** (selected models)

### Controllers
- **Philips Hue Dimmer Switch**
- **Eve Button**
- **IKEA DIRIGERA** remotes

## Future Development

Matter is actively evolving. Upcoming features:

1. **Matter 1.2** (2024):
   - Camera support
   - Enhanced energy management
   - Improved commissioning

2. **Matter 1.3** (2025):
   - Appliances support
   - Advanced sensors
   - Robot vacuum support

Home Assistant and the Python Matter Server are updated regularly to support new Matter versions.

## Resources

- [Matter Official Site](https://buildwithmatter.com/)
- [CSA Matter Specification](https://csa-iot.org/all-solutions/matter/)
- [Home Assistant Matter Integration](https://www.home-assistant.io/integrations/matter/)
- [Python Matter Server GitHub](https://github.com/home-assistant-libs/python-matter-server)
- [Matter Device List](https://www.home-assistant.io/integrations/matter/#supported-devices)

## Support

For Matter-specific issues:
- Check Home Assistant Matter integration docs
- Review Matter Server GitHub issues
- Post in Home Assistant Community forums
- Check device manufacturer's Matter support pages

For kompose.sh home stack issues:
- Check container logs: `./kompose.sh logs home -f`
- Verify network configuration
- Ensure host networking is enabled
- Test with basic Matter device first (e.g., smart plug)
