---
title: � Home Stack - Your Smart Home Command Center
description: "Home is where the automation is!"
---

# 🏠 Home Stack - Your Smart Home Command Center

> *"Home is where the automation is!"* - Every Home Assistant user

## What's This All About?

This stack transforms your house into a smart home! Home Assistant is the open-source brain that connects and controls everything from lights to locks, thermostats to TVs. It's like having J.A.R.V.I.S. from Iron Man, but you built it yourself!

## The Star of the Show

### 🏠 Home Assistant

**Container**: `home_app`  
**Image**: `ghcr.io/home-assistant/home-assistant:stable`  
**Home**: https://home.localhost  
**Port**: 8123

Home Assistant is your smart home's mission control:
- 🔌 **2000+ Integrations**: Control almost anything
- 🤖 **Powerful Automations**: If this, then that (but better!)
- 🎨 **Beautiful UI**: Customizable dashboards
- 📱 **Mobile Apps**: Control from anywhere (iOS & Android)
- 🗣️ **Voice Control**: Alexa, Google, Siri integration
- 🔐 **Privacy First**: Your data stays home
- 🌙 **Energy Monitoring**: Track usage and costs
- 📊 **History & Analytics**: Visualize your home

## Configuration Breakdown

### Privileged Mode 🔓

Running in privileged mode to access:
- USB devices (Zigbee/Z-Wave sticks)
- Bluetooth adapters
- Network interfaces
- Hardware sensors

### Network Mode: Host

Uses host networking for:
- mDNS device discovery (Chromecast, Sonos, etc.)
- DLNA/UPnP devices
- Better integration with network devices

### Configuration Volume

All settings, automations, and data live in:
```
Host: ./config
Container: /config
```

This makes backups super easy - just copy the config folder!

## Environment Variables Explained

| Variable | What It Does | Cool Factor |
|----------|-------------|-------------|
| `COMPOSE_PROJECT_NAME` | Stack identifier | 📦 Organization |
| `TZ` | Your timezone | ⏰ CRITICAL for automations! |
| `TRAEFIK_HOST` | Domain name | 🌐 Your home's address |
| `APP_PORT` | Web interface port | 🎯 Internal routing |

## Troubleshooting

**Q: Can't access USB devices (Zigbee stick)?**  
A: Verify privileged mode is enabled and device path is correct

**Q: Devices not being discovered?**  
A: Check network mode is set to `host` for mDNS discovery

**Q: Automations not triggering?**  
A: Verify timezone is set correctly - this is crucial!

## Security Notes 🔒

- 🔐 **Strong Password**: Your home security depends on it!
- 🌐 **HTTPS Only**: Traefik provides SSL automatically
- 👁️ **Two-Factor**: Enable in user profile
- 🔑 **API Tokens**: Use long-lived tokens, not passwords

## Resources

- [Home Assistant Documentation](https://www.home-assistant.io/docs/)
- [Community Forum](https://community.home-assistant.io/)
- [YouTube Tutorials](https://www.youtube.com/c/HomeAssistant)

---

*"The smart home isn't about the technology - it's about making life simpler, more comfortable, and maybe a little more magical."* ✨🏠
