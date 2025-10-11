---
title: Home - Smart Home Command Center
description: "Home is where the automation is!"
navigation:
  icon: i-lucide-home
---

> *"Home is where the automation is!"* - Every Home Assistant user

## What's This All About?

This stack transforms your house into a smart home! Home Assistant is the open-source brain that connects and controls everything from lights to locks, thermostats to TVs. It's like having J.A.R.V.I.S. from Iron Man, but you built it yourself!

## The Star of the Show

### :icon{name="lucide:home"} Home Assistant

**Container**: `home_app`  
**Image**: `ghcr.io/home-assistant/home-assistant:stable`  
**Home**: https://home.localhost  
**Port**: 8123

Home Assistant is your smart home's mission control:
- :icon{name="lucide:plug"} **2000+ Integrations**: Control almost anything
- :icon{name="lucide:bot"} **Powerful Automations**: If this, then that (but better!)
- :icon{name="lucide:palette"} **Beautiful UI**: Customizable dashboards
- :icon{name="lucide:phone"} **Mobile Apps**: Control from anywhere (iOS & Android)
- :icon{name="lucide:megaphone"} **Voice Control**: Alexa, Google, Siri integration
- :icon{name="lucide:lock-keyhole"} **Privacy First**: Your data stays home
- :icon{name="lucide:eclipse"} **Energy Monitoring**: Track usage and costs
- :icon{name="lucide:bar-chart"} **History & Analytics**: Visualize your home

## Configuration Breakdown

### Privileged Mode :icon{name="lucide:lock"}

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
| `COMPOSE_PROJECT_NAME` | Stack identifier | :icon{name="lucide:package"} Organization |
| `TZ` | Your timezone | :icon{name="lucide:clock"} CRITICAL for automations! |
| `TRAEFIK_HOST` | Domain name | :icon{name="lucide:globe"} Your home's address |
| `APP_PORT` | Web interface port | :icon{name="lucide:target"} Internal routing |

## Troubleshooting

**Q: Can't access USB devices (Zigbee stick)?**  
A: Verify privileged mode is enabled and device path is correct

**Q: Devices not being discovered?**  
A: Check network mode is set to `host` for mDNS discovery

**Q: Automations not triggering?**  
A: Verify timezone is set correctly - this is crucial!

## Security Notes :icon{name="lucide:lock"}

- :icon{name="lucide:lock-keyhole"} **Strong Password**: Your home security depends on it!
- :icon{name="lucide:globe"} **HTTPS Only**: Traefik provides SSL automatically
- :icon{name="lucide:eye"} **Two-Factor**: Enable in user profile
- :icon{name="lucide:key"} **API Tokens**: Use long-lived tokens, not passwords

## Resources

- [Home Assistant Documentation](https://www.home-assistant.io/docs/)
- [Community Forum](https://community.home-assistant.io/)
- [YouTube Tutorials](https://www.youtube.com/c/HomeAssistant)

---

*"The smart home isn't about the technology - it's about making life simpler, more comfortable, and maybe a little more magical."* :icon{name="lucide:sparkles"}:icon{name="lucide:home"}
