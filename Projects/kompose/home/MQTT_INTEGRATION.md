# MQTT Integration Guide

This guide explains how to connect the Home stack with the MQTT broker running in the Core stack.

## Overview

The Home stack uses the MQTT broker (Eclipse Mosquitto) from the Core stack for all MQTT-based communication. This includes:
- Home Assistant MQTT integration
- Zigbee2MQTT communication
- Custom IoT sensors
- Tasmota devices
- ESPHome devices

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                      Kompose Network                            │
│                                                                 │
│  ┌──────────────┐         ┌──────────────┐                    │
│  │  Core Stack  │         │  Home Stack  │                    │
│  │              │         │              │                    │
│  │  ┌────────┐  │         │ ┌──────────┐ │                    │
│  │  │ MQTT   │◄─┼─────────┼─┤   Home   │ │                    │
│  │  │Broker  │  │         │ │Assistant │ │                    │
│  │  │(1883)  │  │         │ └──────────┘ │                    │
│  │  └────────┘  │         │              │                    │
│  │              │         │ ┌──────────┐ │                    │
│  │              │◄────────┼─┤ Zigbee2  │ │                    │
│  │              │         │ │  MQTT    │ │                    │
│  │              │         │ └──────────┘ │                    │
│  └──────────────┘         └──────────────┘                    │
│                                                                 │
│  IoT Devices & Sensors connect via MQTT to core-mqtt          │
└─────────────────────────────────────────────────────────────────┘
```

## Prerequisites

1. **Start the Core stack** (required for MQTT broker):
   ```bash
   ./kompose.sh up core
   ```

2. **Verify MQTT is running**:
   ```bash
   docker ps | grep mqtt
   # Should show: core-mqtt container running
   ```

3. **Test MQTT connectivity**:
   ```bash
   # Subscribe to all topics
   docker exec core-mqtt mosquitto_sub -t "#" -v
   
   # Publish a test message (in another terminal)
   docker exec core-mqtt mosquitto_pub -t "test/topic" -m "Hello MQTT"
   ```

## Home Assistant MQTT Integration

### Method 1: UI Configuration (Recommended)

1. **Access Home Assistant**: http://localhost:8123

2. **Navigate to Integrations**:
   - Settings → Devices & Services → Add Integration

3. **Search for MQTT** and click on it

4. **Configure MQTT Broker**:
   ```
   Broker: core-mqtt
   Port: 1883
   Username: (leave empty or configure in core stack)
   Password: (leave empty or configure in core stack)
   Discovery: Enabled (recommended)
   ```

5. **Click Submit**

6. **Verify Connection**:
   - You should see "MQTT" listed in your integrations
   - Status should show "Connected"

### Method 2: Configuration YAML

Add to Home Assistant's `configuration.yaml`:

```yaml
mqtt:
  broker: core-mqtt
  port: 1883
  # Optional: Add credentials if configured in core stack
  # username: mqtt_user
  # password: mqtt_password
  discovery: true
  discovery_prefix: homeassistant
  birth_message:
    topic: 'homeassistant/status'
    payload: 'online'
  will_message:
    topic: 'homeassistant/status'
    payload: 'offline'
```

Restart Home Assistant:
```bash
./kompose.sh restart home
```

## Zigbee2MQTT Integration

### Configure Zigbee2MQTT

1. **Create Zigbee2MQTT configuration directory** (if not exists):
   ```bash
   mkdir -p /var/lib/docker/volumes/home_zigbee2mqtt_data/_data
   ```

2. **Edit configuration.yaml**:
   ```bash
   docker exec -it home_zigbee2mqtt vi /app/data/configuration.yaml
   ```

3. **Add MQTT configuration**:
   ```yaml
   homeassistant: true
   permit_join: false
   mqtt:
     base_topic: zigbee2mqtt
     server: mqtt://core-mqtt:1883
     # Optional: Add credentials if configured
     # user: mqtt_user
     # password: mqtt_password
   serial:
     port: /dev/ttyUSB0  # Adjust to your adapter
   frontend:
     port: 8080
     host: 0.0.0.0
   advanced:
     log_level: info
     network_key: GENERATE  # Will auto-generate on first start
   ```

4. **Restart Zigbee2MQTT**:
   ```bash
   docker compose --profile zigbee restart zigbee2mqtt
   ```

5. **Verify**:
   - Access Zigbee2MQTT UI: http://localhost:8080
   - Check the logs for MQTT connection status:
     ```bash
     docker logs home_zigbee2mqtt -f
     ```
   - You should see: "MQTT connected"

### Auto-discovery in Home Assistant

Zigbee2MQTT devices will automatically appear in Home Assistant when:
1. Both services are connected to the same MQTT broker
2. Home Assistant MQTT discovery is enabled
3. Zigbee2MQTT has `homeassistant: true` in its config

## ESPHome Integration

ESPHome devices can publish to MQTT automatically.

### Example ESPHome Configuration

```yaml
esphome:
  name: esp-sensor-01

wifi:
  ssid: "YourWiFi"
  password: "YourPassword"

api:
  encryption:
    key: "your-encryption-key"

mqtt:
  broker: core-mqtt  # Use hostname
  port: 1883
  # Optional: Add credentials
  # username: mqtt_user
  # password: mqtt_password
  
sensor:
  - platform: dht
    pin: GPIO4
    temperature:
      name: "Living Room Temperature"
    humidity:
      name: "Living Room Humidity"
```

## Testing MQTT Communication

### Publish Test Messages

```bash
# From host
docker exec core-mqtt mosquitto_pub -t "homeassistant/test" -m "Hello from host"

# From Home Assistant container
docker exec home_homeassistant mosquitto_pub -h core-mqtt -t "homeassistant/test" -m "Hello from HA"
```

### Subscribe to Topics

```bash
# Subscribe to all Home Assistant topics
docker exec core-mqtt mosquitto_sub -t "homeassistant/#" -v

# Subscribe to Zigbee2MQTT topics
docker exec core-mqtt mosquitto_sub -t "zigbee2mqtt/#" -v

# Subscribe to all topics
docker exec core-mqtt mosquitto_sub -t "#" -v
```

### Debug MQTT in Home Assistant

1. **Enable MQTT logging** in Home Assistant's `configuration.yaml`:
   ```yaml
   logger:
     default: info
     logs:
       homeassistant.components.mqtt: debug
   ```

2. **Restart Home Assistant**:
   ```bash
   ./kompose.sh restart home
   ```

3. **View logs**:
   ```bash
   ./kompose.sh logs home -f
   ```

## Common MQTT Topics

### Home Assistant Discovery

```
homeassistant/[component]/[node_id]/[object_id]/config
```

Example:
```
homeassistant/sensor/living_room/temperature/config
```

### Zigbee2MQTT Topics

```bash
# Device state
zigbee2mqtt/[device_name]

# Bridge info
zigbee2mqtt/bridge/info
zigbee2mqtt/bridge/state

# Device list
zigbee2mqtt/bridge/devices
```

### Custom Sensors

```bash
# Temperature sensor
homeassistant/sensor/outdoor/temperature

# Motion detector
homeassistant/binary_sensor/hallway/motion
```

## Securing MQTT

### Enable Authentication in Mosquitto

1. **Edit mosquitto.conf** in core stack:
   ```bash
   cd core/mosquitto/config
   vi mosquitto.conf
   ```

2. **Add authentication**:
   ```conf
   allow_anonymous false
   password_file /mosquitto/config/passwd
   ```

3. **Create password file**:
   ```bash
   docker exec core-mqtt mosquitto_passwd -c /mosquitto/config/passwd mqtt_user
   # Enter password when prompted
   ```

4. **Restart MQTT**:
   ```bash
   ./kompose.sh restart core
   ```

5. **Update all clients** (Home Assistant, Zigbee2MQTT, ESPHome) with the new credentials.

### Enable TLS (Optional)

For production environments, enable TLS encryption:

1. **Generate certificates** (or use Let's Encrypt)

2. **Update mosquitto.conf**:
   ```conf
   listener 8883
   protocol mqtt
   cafile /mosquitto/certs/ca.crt
   certfile /mosquitto/certs/server.crt
   keyfile /mosquitto/certs/server.key
   ```

3. **Update clients** to use port 8883 and TLS

## Troubleshooting

### MQTT Connection Failed

**Problem**: Home Assistant cannot connect to MQTT

**Solutions**:
1. Verify core stack is running:
   ```bash
   docker ps | grep mqtt
   ```

2. Check MQTT logs:
   ```bash
   ./kompose.sh logs core -f | grep mqtt
   ```

3. Test connectivity from Home Assistant:
   ```bash
   docker exec home_homeassistant ping core-mqtt
   docker exec home_homeassistant nc -zv core-mqtt 1883
   ```

4. Verify both containers are on the same network:
   ```bash
   docker network inspect kompose
   ```

### Zigbee2MQTT Not Connecting

**Problem**: Zigbee2MQTT shows "MQTT connection failed"

**Solutions**:
1. Check configuration:
   ```bash
   docker exec home_zigbee2mqtt cat /app/data/configuration.yaml
   ```

2. Verify MQTT server hostname:
   - Use `core-mqtt` NOT `localhost` or IP address
   - Docker's internal DNS resolves container names

3. Check logs:
   ```bash
   docker logs home_zigbee2mqtt -f
   ```

### Messages Not Appearing

**Problem**: Published messages don't appear in subscribers

**Solutions**:
1. Verify topic names are correct:
   ```bash
   # Check what topics are active
   docker exec core-mqtt mosquitto_sub -t "#" -v
   ```

2. Check QoS settings - use QoS 0 or 1 for testing

3. Verify no ACL restrictions in mosquitto.conf

### Performance Issues

**Problem**: MQTT broker slow or unresponsive

**Solutions**:
1. Check resource usage:
   ```bash
   docker stats core-mqtt
   ```

2. Review connection count:
   ```bash
   docker exec core-mqtt netstat -an | grep 1883
   ```

3. Increase Mosquitto limits in mosquitto.conf:
   ```conf
   max_connections 1000
   max_queued_messages 10000
   ```

## Integration with Other Stacks

### Chain Stack (n8n)

Create n8n workflows that:
- Listen to MQTT topics
- Trigger on device state changes
- Publish commands to devices

**n8n MQTT Node Configuration**:
```
Protocol: mqtt
Host: core-mqtt
Port: 1883
Topic: homeassistant/#
```

### Messaging Stack (Gotify)

Send notifications based on MQTT events:

**Example Automation in Home Assistant**:
```yaml
automation:
  - alias: "Motion Alert via Gotify"
    trigger:
      platform: mqtt
      topic: "zigbee2mqtt/motion_sensor/occupancy"
      payload: "true"
    action:
      service: notify.gotify
      data:
        message: "Motion detected!"
        title: "Security Alert"
```

## Best Practices

1. **Use Descriptive Topics**: Follow the pattern `domain/location/device/property`
   ```
   homeassistant/living_room/temperature_sensor/temperature
   ```

2. **Enable Discovery**: Let Home Assistant automatically find devices
   ```yaml
   mqtt:
     discovery: true
     discovery_prefix: homeassistant
   ```

3. **Set Birth/Will Messages**: Know when clients connect/disconnect
   ```yaml
   mqtt:
     birth_message:
       topic: 'client/status'
       payload: 'online'
     will_message:
       topic: 'client/status'
       payload: 'offline'
   ```

4. **Use Retained Messages**: For device states that should persist
   ```bash
   mosquitto_pub -t "device/state" -m "ON" -r
   ```

5. **Monitor Broker Performance**: Regularly check logs and metrics
   ```bash
   ./kompose.sh logs core -f | grep mqtt
   docker stats core-mqtt
   ```

6. **Backup Configuration**: Include MQTT configs in your backup strategy
   ```bash
   docker cp core-mqtt:/mosquitto/config ./backups/mqtt-config-$(date +%Y%m%d)
   ```

## Additional Resources

- [Mosquitto Documentation](https://mosquitto.org/documentation/)
- [Home Assistant MQTT](https://www.home-assistant.io/integrations/mqtt/)
- [Zigbee2MQTT Configuration](https://www.zigbee2mqtt.io/guide/configuration/)
- [ESPHome MQTT Component](https://esphome.io/components/mqtt.html)
- [MQTT Specifications](https://mqtt.org/mqtt-specification/)

## Support

For MQTT-specific issues:
- Check core stack logs: `./kompose.sh logs core -f | grep mqtt`
- Test with command-line tools: `mosquitto_pub` and `mosquitto_sub`
- Verify network connectivity between containers
- Ensure all services are on the `kompose` network
