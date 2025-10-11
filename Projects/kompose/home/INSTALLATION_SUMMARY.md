# Home Stack - Installation Summary

## ✅ What Was Created

The Home stack has been successfully added to kompose.sh with the following structure:

```
home/
├── compose.yaml              # Docker Compose configuration
├── .env                      # Environment variables
├── .gitignore               # Git ignore rules
├── README.md                # Complete documentation
├── MQTT_INTEGRATION.md      # MQTT setup guide
├── MATTER_SETUP.md          # Matter device guide
└── setup.sh                 # Quick setup assistant
```

## 🎯 Services Included

### Core Services (Always Active)

1. **Home Assistant** (Port 8123)
   - Smart home hub and automation platform
   - Web UI for device management
   - 2000+ integrations

2. **Matter Server** (Port 5580)
   - Matter protocol support
   - Next-generation smart home standard
   - Cross-platform compatibility

### Optional Services (Profiles)

3. **Zigbee2MQTT** (Port 8080)
   - Profile: `zigbee`
   - Zigbee device support via MQTT
   - Requires USB Zigbee adapter

4. **ESPHome** (Port 6052)
   - Profile: `esphome`
   - ESP8266/ESP32 device management
   - OTA updates and configuration

## 🚀 Quick Start

### 1. Start Core Stack (Required for MQTT)

```bash
cd /home/valknar/Projects/kompose
./kompose.sh up core
```

### 2. Start Home Stack

**Option A: Using setup script (Recommended for first time)**
```bash
cd home
chmod +x setup.sh
./setup.sh
```

**Option B: Basic start**
```bash
./kompose.sh up home
```

**Option C: With optional services**
```bash
cd home

# With Zigbee
docker compose --profile zigbee up -d

# With ESPHome
docker compose --profile esphome up -d

# With both
docker compose --profile zigbee --profile esphome up -d
```

### 3. Access Services

- **Home Assistant**: http://localhost:8123
- **Zigbee2MQTT**: http://localhost:8080 (if enabled)
- **ESPHome**: http://localhost:6052 (if enabled)

## 🔧 Integration Setup

### MQTT Integration

1. **In Home Assistant**:
   - Settings → Devices & Services → Add Integration → MQTT

2. **Configuration**:
   ```
   Broker: core-mqtt
   Port: 1883
   Username: (empty or configured in core)
   Password: (empty or configured in core)
   ```

3. **Verify**: Integration should show "Connected"

### Matter Integration

1. **In Home Assistant**:
   - Settings → Devices & Services → Add Integration → Matter

2. **Auto-detection**: Matter Server should be automatically detected

3. **Commission devices**:
   - Use Home Assistant mobile app to scan QR codes
   - Or manually enter pairing codes

### Philips Hue Integration

1. **Auto-discovery**: Hue Bridge should appear automatically

2. **Press button** on Hue Bridge when prompted

3. **Import devices**: All lights and accessories are imported

### Zigbee2MQTT Integration (Optional)

1. **Configure USB device** in `compose.yaml`:
   ```yaml
   devices:
     - /dev/ttyUSB0:/dev/ttyUSB0
   ```

2. **Configure MQTT** in Zigbee2MQTT:
   ```yaml
   mqtt:
     server: mqtt://core-mqtt:1883
   homeassistant: true
   ```

3. **Auto-discovery**: Devices appear automatically in Home Assistant

## 📊 Stack Management

### Common Commands

```bash
# Start the home stack
./kompose.sh up home

# Stop the home stack
./kompose.sh down home

# Restart the home stack
./kompose.sh restart home

# View logs
./kompose.sh logs home -f

# Check status
./kompose.sh status home

# Update images
./kompose.sh pull home
./kompose.sh restart home
```

### With Profiles

```bash
# Start with Zigbee
cd home
docker compose --profile zigbee up -d

# Stop specific service
docker compose stop zigbee2mqtt

# Restart with both profiles
docker compose --profile zigbee --profile esphome restart
```

## 🔗 Integration with Other Stacks

### Core Stack
- **MQTT Broker**: Primary communication channel
- **PostgreSQL**: (Optional) Can be used for Home Assistant database
- **Redis**: (Optional) Can be used for Home Assistant caching

### Chain Stack (n8n)
- **Automation**: Create workflows triggered by HA events
- **MQTT**: Listen to device state changes
- **Webhooks**: Send commands from n8n to Home Assistant

### Messaging Stack
- **Gotify**: Send notifications from Home Assistant
- **Email**: Send alerts via Mailhog/SMTP

### VPN Stack
- **Remote Access**: Access Home Assistant securely from anywhere
- **WireGuard**: Connect to your home network

## 📱 Mobile Access

### Home Assistant Companion App

1. **Download app**:
   - iOS: [App Store](https://apps.apple.com/app/home-assistant/id1099568401)
   - Android: [Google Play](https://play.google.com/store/apps/details?id=io.homeassistant.companion.android)

2. **Connect to Home Assistant**:
   - Open app
   - Enter URL: http://your-server-ip:8123
   - Or use: https://home.localhost (if using Traefik)

3. **Features**:
   - Control devices
   - View dashboards
   - Commission Matter devices
   - Receive push notifications

## 🔐 Security Recommendations

### Initial Setup

1. **Create strong admin password** during onboarding
2. **Enable multi-factor authentication** in user profile
3. **Configure trusted networks** in Home Assistant

### MQTT Security (Production)

```bash
# In core stack, enable authentication
cd core/mosquitto/config
vi mosquitto.conf

# Add:
allow_anonymous false
password_file /mosquitto/config/passwd

# Create user
docker exec core-mqtt mosquitto_passwd -c /mosquitto/config/passwd mqtt_user

# Restart
./kompose.sh restart core
```

### Traefik HTTPS

Configure HTTPS access via Traefik in `.env`:
```bash
TRAEFIK_HOST_HOME=home.yourdomain.com
```

## 🛠️ Troubleshooting

### Common Issues

**Home Assistant not starting**
```bash
# Check logs
./kompose.sh logs home -f

# Check container
docker ps -a | grep homeassistant

# Restart
./kompose.sh restart home
```

**MQTT connection failed**
```bash
# Verify core stack is running
docker ps | grep mqtt

# Test connection
docker exec home_homeassistant ping core-mqtt

# Check MQTT logs
./kompose.sh logs core -f | grep mqtt
```

**Matter Server issues**
```bash
# Check Matter logs
docker logs home_matter -f

# Verify host networking
docker inspect home_matter | grep NetworkMode

# Restart Matter
docker restart home_matter
```

**USB device not found**
```bash
# List USB devices
ls -la /dev/ttyUSB* /dev/ttyACM*

# Check permissions
sudo chmod 666 /dev/ttyUSB0

# Verify in compose.yaml
grep -A2 "devices:" compose.yaml
```

## 📚 Documentation

### Created Documentation Files

1. **README.md** - Complete stack documentation
   - Services overview
   - Configuration guides
   - Integration setup
   - Troubleshooting

2. **MQTT_INTEGRATION.md** - MQTT connectivity guide
   - Architecture overview
   - Configuration steps
   - Testing procedures
   - Security setup

3. **MATTER_SETUP.md** - Matter device guide
   - What is Matter
   - Device commissioning
   - Multi-admin setup
   - Troubleshooting

### External Resources

- [Home Assistant Docs](https://www.home-assistant.io/docs/)
- [Matter Documentation](https://buildwithmatter.com/)
- [Zigbee2MQTT Docs](https://www.zigbee2mqtt.io/)
- [ESPHome Docs](https://esphome.io/)

## 🎉 Next Steps

1. **Complete Home Assistant onboarding**
   - Create admin account
   - Set location and timezone
   - Configure basic settings

2. **Add integrations**
   - MQTT (connect to core-mqtt)
   - Matter (auto-detected)
   - Philips Hue (auto-discovered)

3. **Configure devices**
   - Commission Matter devices
   - Pair Zigbee devices (if using)
   - Add ESPHome devices (if using)

4. **Create automations**
   - Motion-activated lights
   - Scene control
   - Notifications

5. **Integrate with other stacks**
   - Set up n8n workflows
   - Configure Gotify notifications
   - Enable VPN for remote access

## 🔄 Updates

### Updating the Home Stack

```bash
# Pull latest images
./kompose.sh pull home

# Restart with new images
./kompose.sh restart home

# Verify versions
docker ps | grep -E "homeassistant|matter"
```

### Backup Home Assistant Configuration

```bash
# Backup configuration
docker cp home_homeassistant:/config ./backups/ha-config-$(date +%Y%m%d)

# Backup Matter data
docker cp home_matter:/data ./backups/matter-data-$(date +%Y%m%d)
```

## 💡 Tips

1. **Start with basics**: Home Assistant + Matter first, add Zigbee later
2. **Use profiles**: Only enable optional services when needed
3. **Check logs**: Most issues are visible in logs
4. **Update regularly**: Keep images up to date
5. **Backup often**: Home Assistant config is important
6. **Test MQTT**: Verify core stack MQTT before troubleshooting HA
7. **Host networking**: Required for Matter - don't change it
8. **Documentation**: Refer to the detailed MD files for specific issues

## ✅ Verification Checklist

- [ ] Core stack is running (MQTT broker)
- [ ] Home stack is running (all containers up)
- [ ] Home Assistant accessible at http://localhost:8123
- [ ] Admin account created in Home Assistant
- [ ] MQTT integration added and connected
- [ ] Matter integration added and working
- [ ] Optional services enabled if needed (Zigbee/ESPHome)
- [ ] USB devices configured if using Zigbee/Z-Wave
- [ ] Documentation reviewed
- [ ] First automation created

## 🆘 Getting Help

If you encounter issues:

1. **Check logs first**: `./kompose.sh logs home -f`
2. **Review documentation**: README.md and integration guides
3. **Verify prerequisites**: Core stack running, network connectivity
4. **Test components**: MQTT, Matter Server, USB devices
5. **Check GitHub issues**: Home Assistant, Matter Server repos
6. **Community**: Home Assistant community forums

---

**Installation Date**: $(date +%Y-%m-%d)
**kompose.sh Version**: Latest
**Home Stack Version**: 1.0.0
