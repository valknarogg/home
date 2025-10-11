# Home Stack - Complete Overview

## 🎉 Successfully Added to kompose.sh!

The **home** stack has been fully integrated into your kompose.sh project, providing comprehensive smart home automation capabilities with Home Assistant, Matter, and MQTT integration.

---

## 📦 What Was Created

### Directory Structure
```
home/
├── compose.yaml                  # Docker Compose configuration
├── .env                          # Environment variables
├── .gitignore                    # Git ignore rules
├── setup.sh                      # Interactive setup assistant
├── README.md                     # Complete documentation (3800+ lines)
├── MQTT_INTEGRATION.md          # MQTT connectivity guide
├── MATTER_SETUP.md              # Matter device setup guide
├── INSTALLATION_SUMMARY.md      # Installation overview
├── QUICK_REFERENCE.md           # Quick command reference
├── EXAMPLES.md                   # Automation examples
└── HOME_STACK_OVERVIEW.md       # This file
```

### Services Configured

#### Core Services (Always Running)
1. **Home Assistant** (Port 8123)
   - Smart home hub and automation platform
   - 2000+ device integrations
   - Local control and privacy-focused

2. **Matter Server** (Port 5580)
   - Next-generation smart home protocol
   - Cross-platform device support
   - Local, secure communication

#### Optional Services (Docker Profiles)
3. **Zigbee2MQTT** (Port 8080)
   - Profile: `zigbee`
   - Zigbee device support via MQTT
   - Web-based management interface

4. **ESPHome** (Port 6052)
   - Profile: `esphome`
   - ESP8266/ESP32 management
   - OTA firmware updates

---

## 🚀 Quick Start Guide

### Prerequisites Check
```bash
# 1. Ensure core stack is running (for MQTT)
./kompose.sh status core

# If not running, start it:
./kompose.sh up core
```

### Starting the Home Stack

**Method 1: Interactive Setup (Recommended for First Time)**
```bash
cd home
chmod +x setup.sh
./setup.sh
```

**Method 2: Direct Start**
```bash
# Basic setup (Home Assistant + Matter)
./kompose.sh up home

# With Zigbee support
cd home && docker compose --profile zigbee up -d

# With ESPHome support
cd home && docker compose --profile esphome up -d

# With everything
cd home && docker compose --profile zigbee --profile esphome up -d
```

### Access Your Services
- **Home Assistant**: http://localhost:8123
- **Zigbee2MQTT**: http://localhost:8080 (if enabled)
- **ESPHome**: http://localhost:6052 (if enabled)

---

## 🔧 Initial Configuration

### 1. Home Assistant First-Time Setup

1. **Access Home Assistant**: http://localhost:8123
2. **Create Admin Account**: Choose username and secure password
3. **Set Location**: For weather, sunrise/sunset automation
4. **Configure Units**: Metric or Imperial
5. **Complete Onboarding**: Follow the wizard

### 2. Add MQTT Integration

```
Settings → Devices & Services → Add Integration → MQTT
```

Configuration:
```
Broker: core-mqtt
Port: 1883
Username: (leave empty unless configured)
Password: (leave empty unless configured)
Discovery: ✓ Enable
```

### 3. Add Matter Integration

```
Settings → Devices & Services → Add Integration → Matter
```

- Matter Server should **auto-detect**
- URL: `ws://localhost:5580/ws`
- Click **Submit**

### 4. Philips Hue (Auto-Discovery)

If you have a Philips Hue bridge on your network:
1. Go to **Settings → Devices & Services**
2. Hue Bridge appears in **Discovered**
3. Click **Configure**
4. **Press button** on Hue Bridge
5. All devices imported automatically

---

## 🔗 Integration Architecture

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
│  │  │        │  │         │ └─────┬────┘ │                    │
│  │  │        │  │         │       │      │                    │
│  │  │        │◄─┼─────────┼───────┤      │                    │
│  │  │        │  │         │ ┌─────▼────┐ │                    │
│  │  └────────┘  │         │ │  Matter  │ │                    │
│  │              │         │ │  Server  │ │                    │
│  │  ┌────────┐  │         │ └──────────┘ │                    │
│  │  │Postgres│◄─┼─────────┼──(Optional)  │                    │
│  │  │        │  │         │              │                    │
│  │  │ Redis  │◄─┼─────────┼──(Optional)  │                    │
│  │  └────────┘  │         │              │                    │
│  └──────────────┘         └──────────────┘                    │
│                                                                 │
│  ┌──────────────┐         ┌──────────────┐                    │
│  │ Chain Stack  │         │   Messaging  │                    │
│  │              │         │    Stack     │                    │
│  │  ┌────────┐  │         │ ┌──────────┐ │                    │
│  │  │  n8n   │◄─┼─────────┼─┤  Gotify  │ │                    │
│  │  │        │  │  MQTT   │ └──────────┘ │                    │
│  │  │        │◄─┼─────────┼──Webhooks    │                    │
│  │  └────────┘  │         │              │                    │
│  └──────────────┘         └──────────────┘                    │
│                                                                 │
│  External Devices: Matter, Zigbee, Hue, IoT Sensors           │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📚 Documentation Guide

### Essential Reading

1. **README.md** - Start here!
   - Complete stack documentation
   - Service details
   - Configuration guides
   - Troubleshooting
   - Best practices

2. **QUICK_REFERENCE.md** - Your command cheat sheet
   - Essential commands
   - Service URLs
   - Quick troubleshooting
   - Common tasks

3. **MQTT_INTEGRATION.md** - MQTT connectivity
   - Architecture overview
   - Configuration steps
   - Testing procedures
   - Security setup
   - Integration examples

4. **MATTER_SETUP.md** - Matter devices
   - What is Matter
   - Device commissioning
   - Multi-admin setup
   - Troubleshooting
   - Device recommendations

5. **EXAMPLES.md** - Automation cookbook
   - Basic automations
   - MQTT automations
   - Matter automations
   - Hue scenes
   - n8n integration
   - Advanced examples

6. **INSTALLATION_SUMMARY.md** - What was installed
   - Complete installation checklist
   - Verification steps
   - Next steps guide

---

## 🎯 Common Use Cases

### 1. Basic Smart Home Control
- **Lights**: On/off, dimming, colors, scenes
- **Sensors**: Motion, temperature, humidity, door/window
- **Switches**: Smart plugs, wall switches
- **Climate**: Thermostats, fans

### 2. Automation & Scenes
- **Time-based**: Morning routine, evening scenes
- **Motion-based**: Auto lights when motion detected
- **Presence-based**: Home/away modes
- **Conditional**: Weather-based, time-of-day adaptive

### 3. Security & Monitoring
- **Alerts**: Door/window sensors
- **Notifications**: Push, Gotify, email
- **Cameras**: (Future Matter 1.2+)
- **Alarms**: Integration with security systems

### 4. Energy Management
- **Monitoring**: Track power consumption
- **Control**: Schedule high-power devices
- **Optimization**: Reduce costs automatically

### 5. Integration with Other Stacks
- **n8n Workflows**: Complex automations
- **Gotify Notifications**: Real-time alerts
- **VPN Access**: Secure remote control
- **Database Logging**: Track all events

---

## 🔐 Security Considerations

### Current Setup (Development)
- ✅ Local network only
- ✅ No cloud dependencies (except integrations you add)
- ⚠️ MQTT: Anonymous access enabled
- ⚠️ No authentication required on MQTT

### Production Recommendations

1. **Enable MQTT Authentication**
   ```bash
   cd core/mosquitto/config
   # Edit mosquitto.conf
   allow_anonymous false
   password_file /mosquitto/config/passwd
   ```

2. **Use Strong Passwords**
   - Home Assistant admin account
   - MQTT credentials
   - All integration credentials

3. **Enable HTTPS** via Traefik
   ```bash
   # In .env
   TRAEFIK_HOST_HOME=home.yourdomain.com
   ```

4. **Consider VPN** for remote access
   ```bash
   ./kompose.sh up vpn
   # Access HA securely via WireGuard
   ```

5. **Regular Updates**
   ```bash
   ./kompose.sh pull home
   ./kompose.sh restart home
   ```

---

## 📱 Mobile Access

### Home Assistant Companion App

**iOS**: [App Store](https://apps.apple.com/app/home-assistant/id1099568401)
**Android**: [Google Play](https://play.google.com/store/apps/details?id=io.homeassistant.companion.android)

**Features**:
- Full device control
- Dashboard access
- Push notifications
- Matter device commissioning
- Location tracking (for presence)
- Quick actions and widgets

**Setup**:
1. Install app
2. Add server: `http://your-ip:8123`
3. Login with Home Assistant credentials
4. Enable notifications

---

## 🛠️ Management Commands

### Stack Management
```bash
# Start
./kompose.sh up home

# Stop
./kompose.sh down home

# Restart
./kompose.sh restart home

# Logs
./kompose.sh logs home -f

# Status
./kompose.sh status home

# Update
./kompose.sh pull home
./kompose.sh restart home
```

### Profile Management
```bash
cd home

# Enable Zigbee
docker compose --profile zigbee up -d

# Enable ESPHome
docker compose --profile esphome up -d

# Disable profile
docker compose stop zigbee2mqtt
```

### Container Access
```bash
# Home Assistant shell
docker exec -it home_homeassistant bash

# Check configuration
docker exec home_homeassistant ha core check

# Restart HA
docker exec home_homeassistant ha core restart
```

---

## 🔧 Troubleshooting Quick Guide

### Service Won't Start
```bash
# Check logs
./kompose.sh logs home -f

# Check container status
docker ps -a | grep home_

# Restart service
./kompose.sh restart home
```

### MQTT Connection Issues
```bash
# Verify core stack
./kompose.sh status core

# Test connectivity
docker exec home_homeassistant ping core-mqtt

# Check MQTT logs
docker logs core-mqtt -f
```

### Matter Issues
```bash
# Check Matter Server
docker logs home_matter -f

# Verify host networking
docker inspect home_matter | grep NetworkMode
```

### USB Device Not Found
```bash
# List devices
ls -la /dev/ttyUSB* /dev/ttyACM*

# Fix permissions
sudo chmod 666 /dev/ttyUSB0

# Edit compose.yaml to add device
```

---

## 💾 Backup & Recovery

### Manual Backup
```bash
# Backup Home Assistant config
docker cp home_homeassistant:/config ./backup-ha-$(date +%Y%m%d)

# Backup Matter data
docker cp home_matter:/data ./backup-matter-$(date +%Y%m%d)

# Backup Zigbee2MQTT
docker cp home_zigbee2mqtt:/app/data ./backup-z2m-$(date +%Y%m%d)
```

### Automated Backup
Add to crontab:
```bash
# Daily backup at 2 AM
0 2 * * * docker cp home_homeassistant:/config /backups/ha-$(date +\%Y\%m\%d)
```

### Restore
```bash
# Restore Home Assistant config
docker cp ./backup-ha-20240115 home_homeassistant:/config

# Restart
./kompose.sh restart home
```

---

## 🎓 Learning Resources

### Official Documentation
- [Home Assistant](https://www.home-assistant.io/docs/)
- [Matter](https://buildwithmatter.com/)
- [Zigbee2MQTT](https://www.zigbee2mqtt.io/)
- [ESPHome](https://esphome.io/)

### Community
- [Home Assistant Community](https://community.home-assistant.io/)
- [Home Assistant Discord](https://discord.gg/home-assistant)
- [Reddit r/homeassistant](https://reddit.com/r/homeassistant)

### YouTube Channels
- Home Assistant Official
- Everything Smart Home
- Smart Home Junkie
- DigiblurDIY

---

## 🚀 Next Steps

### Immediate (Getting Started)
- [ ] Complete Home Assistant onboarding
- [ ] Add MQTT integration
- [ ] Add Matter integration
- [ ] Install mobile app
- [ ] Create first automation

### Short Term (First Week)
- [ ] Configure Philips Hue (if available)
- [ ] Set up basic automations
- [ ] Configure notifications (Gotify)
- [ ] Add more devices
- [ ] Customize dashboard

### Medium Term (First Month)
- [ ] Enable Zigbee devices (if needed)
- [ ] Set up ESPHome devices (if needed)
- [ ] Create complex automations
- [ ] Integrate with n8n
- [ ] Set up presence detection
- [ ] Configure energy monitoring

### Long Term (Ongoing)
- [ ] Expand device ecosystem
- [ ] Optimize automations
- [ ] Regular backups
- [ ] Security hardening
- [ ] Keep everything updated

---

## 📊 Stack Status

✅ **Installation**: Complete
✅ **Configuration**: Ready to use
✅ **Documentation**: Comprehensive
✅ **Integration**: kompose.sh registered
✅ **MQTT**: Connected to core stack
✅ **Matter**: Enabled and ready
⚠️ **Optional Services**: Enable as needed

---

## 🎉 Success!

Your Home stack is now fully integrated with kompose.sh! You have:

- ✅ Home Assistant with 2000+ integrations
- ✅ Matter protocol support for next-gen devices
- ✅ MQTT integration with the core stack
- ✅ Optional Zigbee and ESPHome support
- ✅ Seamless integration with other kompose stacks
- ✅ Comprehensive documentation
- ✅ Example automations to get started

**Start with**: `./setup.sh` or `./kompose.sh up home`

**Questions?** Check the documentation files or kompose.sh community resources.

**Happy automating! 🏠✨**

---

**Created**: $(date +%Y-%m-%d)
**kompose.sh**: Updated with home stack
**Version**: 1.0.0
