# Home Stack Template

This template provides a complete, production-ready smart home automation solution using Home Assistant with support for Matter, Zigbee, and ESPHome devices.

## Overview

The Home stack consists of:
- **Home Assistant**: Open-source smart home hub with 2000+ integrations
- **Matter Server**: Next-generation smart home protocol support
- **Zigbee2MQTT**: Zigbee device integration (optional profile)
- **ESPHome**: Custom firmware for ESP8266/ESP32 devices (optional profile)

## Quick Start

Generate this stack using kompose-generate.sh:

```bash
./kompose-generate.sh home
```

This will:
1. Create the home stack directory if it doesn't exist
2. Copy all template files
3. Generate environment variables from kompose.yml
4. Prepare the stack for deployment

## Files in this Template

- `kompose.yml` - Complete stack configuration with all variables defined
- `compose.yaml` - Docker Compose configuration
- `.env.example` - Example environment file (will be generated from kompose.yml)
- `README.md` - This file

## Requirements

Before deploying this stack, ensure these stacks are running:
- **core** - Provides MQTT (Mosquitto)
- **proxy** - Provides Traefik for routing (optional, for SSL/domain access)

## Configuration

All configuration is defined in `kompose.yml`. Key settings:

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| HOME_COMPOSE_PROJECT_NAME | home | Stack project name |
| HOME_HOMEASSISTANT_IMAGE | ghcr.io/home-assistant/home-assistant:stable | Home Assistant image |
| HOME_HOMEASSISTANT_PORT | 8123 | Home Assistant web port |
| HOME_MATTER_SERVER_IMAGE | ghcr.io/home-assistant-libs/python-matter-server:stable | Matter server image |
| HOME_ZIGBEE2MQTT_IMAGE | koenkk/zigbee2mqtt:latest | Zigbee2MQTT image |
| HOME_ZIGBEE2MQTT_PORT | 8080 | Zigbee2MQTT web port |
| SUBDOMAIN_HOME | home | Home Assistant subdomain |
| SUBDOMAIN_ZIGBEE | zigbee | Zigbee2MQTT subdomain |

### Secrets

This stack does not require any secrets in the configuration. Home Assistant manages its own authentication internally.

## Deployment Steps

### 1. Generate the Stack

```bash
./kompose-generate.sh home
```

### 2. Review Configuration

Edit the generated files in the `home/` directory:
- `.env` - Environment variables
- Add your domain configuration if using Traefik

### 3. Configure USB Devices (if using Zigbee/Z-Wave)

Edit `compose.yaml` and uncomment the appropriate device mappings:

```yaml
devices:
  - /dev/ttyUSB0:/dev/ttyUSB0  # Zigbee coordinator
  - /dev/ttyACM0:/dev/ttyACM0  # Z-Wave stick
```

Find your devices:
```bash
ls -la /dev/tty*
# or
dmesg | grep tty
```

### 4. Start Dependencies

```bash
docker compose -f core/compose.yaml up -d
docker compose -f proxy/compose.yaml up -d  # Optional, for domain access
```

### 5. Start Home Stack

**Basic (Home Assistant + Matter):**
```bash
docker compose -f home/compose.yaml up -d
```

**With Zigbee2MQTT:**
```bash
docker compose -f home/compose.yaml --profile zigbee up -d
```

**With ESPHome:**
```bash
docker compose -f home/compose.yaml --profile esphome up -d
```

**With All Optional Services:**
```bash
docker compose -f home/compose.yaml --profile zigbee --profile esphome up -d
```

### 6. Access Home Assistant

- **Local**: http://localhost:8123
- **Domain** (if using Traefik): https://home.yourdomain.com

Follow the onboarding wizard to create your first user account.

### 7. Configure MQTT Integration (Optional)

If you want to integrate with MQTT devices:

1. Home Assistant → Settings → Devices & Services
2. Add Integration → Search "MQTT"
3. Configure:
   - Broker: `core_mqtt`
   - Port: `1883`
   - Username/Password: (from core stack configuration)

## Access URLs

- **Home Assistant**: http://localhost:8123 or https://home.yourdomain.com
- **Zigbee2MQTT** (if enabled): http://localhost:8080 or https://zigbee.yourdomain.com
- **ESPHome** (if enabled): http://localhost:6052

## USB Device Configuration

### Find Your Devices

```bash
# List all USB serial devices
ls -la /dev/tty*

# Check kernel messages for device info
dmesg | grep tty

# Check device details
udevadm info -a -n /dev/ttyUSB0
```

### Set Permissions

Add your user to the dialout group:

```bash
sudo usermod -aG dialout $USER
```

Log out and back in for changes to take effect.

### Common Device Paths

| Device Type | Common Path |
|-------------|-------------|
| Zigbee USB Coordinator | /dev/ttyUSB0 or /dev/ttyACM0 |
| Z-Wave USB Stick | /dev/ttyACM0 or /dev/ttyUSB0 |
| ESP32/ESP8266 | /dev/ttyUSB0 or /dev/ttyUSB1 |

## Using Profiles

### Zigbee2MQTT Profile

Enable Zigbee device support:

1. Configure your Zigbee adapter in compose.yaml (device path)
2. Start with profile:
   ```bash
   docker compose -f home/compose.yaml --profile zigbee up -d
   ```
3. Access Zigbee2MQTT UI at http://localhost:8080
4. Configure MQTT connection (connects to core_mqtt automatically)
5. Start pairing devices

### ESPHome Profile

Enable ESPHome for custom ESP devices:

1. Start with profile:
   ```bash
   docker compose -f home/compose.yaml --profile esphome up -d
   ```
2. Access ESPHome dashboard at http://localhost:6052
3. Create and configure your ESP device configs
4. Flash devices over the network

## Health Checks

Check service health:

```bash
# Home Assistant
curl http://localhost:8123/

# Check logs
docker logs home_homeassistant
docker logs home_matter
docker logs home_zigbee2mqtt  # if zigbee profile enabled
```

## Troubleshooting

### Home Assistant Won't Start

**Symptoms**: Container exits or restarts repeatedly

**Solutions**:
1. Check volume permissions
2. View logs:
   ```bash
   docker logs home_homeassistant
   ```
3. Verify network connectivity
4. Check available disk space

### Matter Devices Won't Pair

**Symptoms**: Device commissioning fails

**Solutions**:
1. Ensure Matter server is running:
   ```bash
   docker ps | grep matter
   ```
2. Check network connectivity (Matter requires local network access)
3. Verify Bluetooth is available for BLE commissioning
4. Restart Matter server:
   ```bash
   docker restart home_matter
   ```
5. Check logs:
   ```bash
   docker logs home_matter
   ```

### Zigbee Devices Won't Pair

**Symptoms**: Devices not discovered by Zigbee2MQTT

**Solutions**:
1. Verify USB device mapping is correct
2. Check coordinator firmware is up to date
3. View logs:
   ```bash
   docker logs home_zigbee2mqtt
   ```
4. Ensure coordinator is recognized by the system
5. Check USB permissions (dialout group)

### ESPHome Devices Not Discovered

**Symptoms**: Devices not showing up in Home Assistant

**Solutions**:
1. Ensure devices are on the same network
2. Check mDNS is working
3. Manually add device by IP address
4. View ESPHome logs:
   ```bash
   docker logs home_esphome
   ```

### USB Device Not Accessible

**Symptoms**: Permission denied errors

**Solutions**:
1. Add user to dialout group:
   ```bash
   sudo usermod -aG dialout $USER
   ```
2. Log out and back in
3. Check device permissions:
   ```bash
   ls -la /dev/ttyUSB0
   ```
4. Restart Docker service:
   ```bash
   sudo systemctl restart docker
   ```

## Security Best Practices

1. **Home Assistant Authentication**
   - Enable MFA in user settings
   - Use strong passwords
   - Create separate users for family members

2. **Network Security**
   - Use SSL/TLS (enable Traefik integration)
   - Restrict access to trusted IPs if possible
   - Keep services updated

3. **Device Security**
   - Change default passwords on smart devices
   - Use strong WiFi passwords
   - Segment IoT devices on separate VLAN (recommended)

4. **Backup Regularly**
   - Use Home Assistant's built-in backup
   - Export automation configurations
   - Backup volume data

## Backup and Recovery

### Home Assistant Built-in Backup

Home Assistant includes comprehensive backup functionality:

1. Settings → System → Backups
2. Create Backup → Full Backup
3. Download or store on network location
4. Schedule automatic backups

### Manual Volume Backup

```bash
# Backup Home Assistant config
docker run --rm \
  -v home_homeassistant_config:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/homeassistant-$(date +%Y%m%d).tar.gz /data

# Backup Zigbee2MQTT data
docker run --rm \
  -v home_zigbee2mqtt_data:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/zigbee2mqtt-$(date +%Y%m%d).tar.gz /data

# Backup ESPHome config
docker run --rm \
  -v home_esphome_config:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/esphome-$(date +%Y%m%d).tar.gz /data
```

### Restore from Backup

```bash
# Restore Home Assistant
docker run --rm \
  -v home_homeassistant_config:/data \
  -v $(pwd):/backup \
  alpine sh -c "cd /data && tar xzf /backup/homeassistant-YYYYMMDD.tar.gz --strip 1"

# Restart container
docker restart home_homeassistant
```

## Performance Optimization

1. **Storage**
   - Use SSD for volumes
   - Enable database purge in recorder settings
   - Consider external database (PostgreSQL/MariaDB) for large installations

2. **Resource Allocation**
   - Allocate at least 2GB RAM
   - Ensure sufficient CPU resources
   - Monitor resource usage

3. **Optimization Settings**
   - Disable unused integrations
   - Optimize automation triggers
   - Configure recorder to exclude unnecessary entities
   - Use template sensors wisely

## Advanced Configuration

### Custom Components (HACS)

Install Home Assistant Community Store:

1. Download HACS
2. Place in custom_components directory
3. Restart Home Assistant
4. Add HACS integration
5. Browse and install community components

### Automation Examples

#### Motion-Activated Lights
```yaml
automation:
  - alias: "Living Room Motion Lights"
    trigger:
      platform: state
      entity_id: binary_sensor.living_room_motion
      to: "on"
    action:
      service: light.turn_on
      target:
        entity_id: light.living_room
```

#### Notification on Door Open
```yaml
automation:
  - alias: "Front Door Alert"
    trigger:
      platform: state
      entity_id: binary_sensor.front_door
      to: "on"
    action:
      service: notify.mobile_app
      data:
        message: "Front door opened"
```

### Themes and Customization

- Install themes via HACS or manual YAML
- Customize in Settings → Themes
- Create custom Lovelace dashboards
- Use custom cards from HACS

## Monitoring

### Home Assistant System Health

- Settings → System → Repairs (for issues)
- Settings → System → Logs (for debugging)
- Developer Tools → Statistics (for performance)

### Container Logs

```bash
# Follow logs in real-time
docker logs -f home_homeassistant
docker logs -f home_matter
docker logs -f home_zigbee2mqtt
docker logs -f home_esphome
```

### Resource Usage

```bash
# Check container stats
docker stats home_homeassistant home_matter home_zigbee2mqtt
```

## Popular Integrations

- **MQTT**: Connect IoT devices
- **Matter**: Modern smart home standard
- **Zigbee**: Via Zigbee2MQTT
- **ESPHome**: Custom ESP devices
- **Google Home/Alexa**: Voice control
- **Mobile App**: iOS and Android
- **Plex/Jellyfin**: Media servers
- **UniFi**: Network monitoring
- **Weather**: Local weather data
- **Solar**: Solar panel monitoring

## Resources

- [Home Assistant Documentation](https://www.home-assistant.io/docs/)
- [Community Forum](https://community.home-assistant.io/)
- [HACS (Custom Components)](https://hacs.xyz/)
- [Matter Documentation](https://buildwithmatter.com/)
- [Zigbee2MQTT Documentation](https://www.zigbee2mqtt.io/)
- [ESPHome Documentation](https://esphome.io/)
- [Awesome Home Assistant](https://www.awesome-ha.com/)

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Review logs: `docker logs home_homeassistant`
3. Consult the official documentation
4. Visit the Home Assistant community forum
5. Check kompose repository issues

## Template Version

- Version: 1.0.0
- Last Updated: 2025-10-14
- Compatible with: Kompose 1.x
