# Home Stack - Quick Reference

## 🚀 Essential Commands

### Stack Management
```bash
# Start home stack
./kompose.sh up home

# Stop home stack
./kompose.sh down home

# Restart home stack
./kompose.sh restart home

# View logs
./kompose.sh logs home -f

# Check status
./kompose.sh status home
```

### With Optional Services
```bash
# Start with Zigbee
cd home && docker compose --profile zigbee up -d

# Start with ESPHome
cd home && docker compose --profile esphome up -d

# Start with both
cd home && docker compose --profile zigbee --profile esphome up -d
```

## 🌐 Service URLs

| Service | URL | Notes |
|---------|-----|-------|
| Home Assistant | http://localhost:8123 | Main smart home interface |
| Matter Server | Port 5580 | API only, no web UI |
| Zigbee2MQTT | http://localhost:8080 | If zigbee profile enabled |
| ESPHome | http://localhost:6052 | If esphome profile enabled |

## 🔧 Quick Setup

### 1. MQTT Integration in Home Assistant
```
Settings → Devices & Services → Add Integration → MQTT
Broker: core-mqtt
Port: 1883
```

### 2. Matter Integration in Home Assistant
```
Settings → Devices & Services → Add Integration → Matter
(Auto-detected at ws://localhost:5580/ws)
```

### 3. Philips Hue
```
(Auto-discovered)
Press button on Hue Bridge when prompted
```

## 📡 MQTT Testing

```bash
# Subscribe to all topics
docker exec core-mqtt mosquitto_sub -t "#" -v

# Publish test message
docker exec core-mqtt mosquitto_pub -t "test/topic" -m "Hello"

# Test from Home Assistant
docker exec home_homeassistant mosquitto_pub -h core-mqtt -t "ha/test" -m "Hi"
```

## 🔍 Troubleshooting

### Check Logs
```bash
# All home stack logs
./kompose.sh logs home -f

# Specific service
docker logs home_homeassistant -f
docker logs home_matter -f
docker logs home_zigbee2mqtt -f
```

### Verify Connectivity
```bash
# MQTT connectivity
docker exec home_homeassistant ping core-mqtt

# Check MQTT is running
docker ps | grep mqtt

# List all containers
docker ps -a | grep home_
```

### Restart Services
```bash
# Restart specific service
docker restart home_homeassistant
docker restart home_matter

# Restart entire stack
./kompose.sh restart home
```

## 📦 Container Names

| Service | Container Name |
|---------|----------------|
| Home Assistant | home_homeassistant |
| Matter Server | home_matter |
| Zigbee2MQTT | home_zigbee2mqtt |
| ESPHome | home_esphome |

## 🔄 Update Process

```bash
# Pull latest images
./kompose.sh pull home

# Restart with new images
./kompose.sh restart home
```

## 💾 Backup

```bash
# Backup Home Assistant config
docker cp home_homeassistant:/config ./backup-ha-$(date +%Y%m%d)

# Backup Matter data
docker cp home_matter:/data ./backup-matter-$(date +%Y%m%d)
```

## 🔗 Integration Points

### With Core Stack
- **MQTT**: core-mqtt container (port 1883)
- **PostgreSQL**: core-postgres (if using for HA database)
- **Redis**: core-redis (if using for HA)

### With Chain Stack
- **n8n webhooks**: Create automations
- **MQTT triggers**: Use MQTT node in n8n

### With Messaging Stack
- **Gotify**: Send notifications from HA
- **Email**: Alert via Mailhog/SMTP

## 📱 Mobile App

1. Install Home Assistant Companion
2. Add server: http://your-ip:8123
3. Login with HA credentials
4. Enable notifications

## 🔐 Security Quick Tips

```bash
# Enable MQTT authentication (in core stack)
docker exec core-mqtt mosquitto_passwd -c /mosquitto/config/passwd username

# Edit mosquitto.conf to disable anonymous
allow_anonymous false
password_file /mosquitto/config/passwd
```

## 📚 Documentation Files

- `README.md` - Complete documentation
- `MQTT_INTEGRATION.md` - MQTT setup guide  
- `MATTER_SETUP.md` - Matter device guide
- `INSTALLATION_SUMMARY.md` - What was installed
- This file - Quick reference

## 🐛 Common Issues

### Home Assistant won't start
```bash
./kompose.sh logs home -f
# Look for config errors
```

### MQTT not connecting
```bash
# Ensure core stack is running
./kompose.sh status core
# Check MQTT container
docker ps | grep mqtt
```

### Matter commissioning fails
```bash
# Check Matter Server logs
docker logs home_matter -f
# Verify host networking
docker inspect home_matter | grep NetworkMode
```

### USB device not accessible
```bash
# List devices
ls -la /dev/ttyUSB* /dev/ttyACM*
# Fix permissions
sudo chmod 666 /dev/ttyUSB0
```

## ⚡ Advanced

### Execute command in container
```bash
docker exec -it home_homeassistant bash
```

### Check resource usage
```bash
docker stats home_homeassistant home_matter
```

### Network inspection
```bash
docker network inspect kompose
```

### Volume inspection
```bash
docker volume ls | grep home_
docker volume inspect home_homeassistant_config
```

## 🎯 First Time Setup Checklist

- [ ] Start core stack: `./kompose.sh up core`
- [ ] Start home stack: `./kompose.sh up home` or `./setup.sh`
- [ ] Access Home Assistant: http://localhost:8123
- [ ] Complete onboarding wizard
- [ ] Add MQTT integration (broker: core-mqtt)
- [ ] Add Matter integration (auto-detected)
- [ ] Configure Philips Hue (if available)
- [ ] Install mobile app
- [ ] Create first automation

## 📞 Support

- Home Assistant Community: https://community.home-assistant.io/
- kompose.sh Issues: Check main repo
- Matter: https://github.com/home-assistant-libs/python-matter-server
- Zigbee2MQTT: https://www.zigbee2mqtt.io/

---
**Last Updated**: $(date +%Y-%m-%d)
