# Home Stack - Example Automations & Use Cases

This document provides practical examples of automations and use cases for your Home Assistant setup integrated with kompose.sh stacks.

## 📋 Table of Contents

1. [Basic Automations](#basic-automations)
2. [MQTT-Based Automations](#mqtt-based-automations)
3. [Matter Device Automations](#matter-device-automations)
4. [Philips Hue Scenes](#philips-hue-scenes)
5. [Integration with n8n](#integration-with-n8n)
6. [Notification Examples](#notification-examples)
7. [Advanced Automations](#advanced-automations)

## Basic Automations

### 1. Motion-Activated Lights

```yaml
# configuration.yaml or automations.yaml
automation:
  - alias: "Hallway Motion Lights"
    description: "Turn on lights when motion detected"
    trigger:
      - platform: state
        entity_id: binary_sensor.hallway_motion
        to: "on"
    condition:
      - condition: sun
        after: sunset
        before: sunrise
    action:
      - service: light.turn_on
        target:
          entity_id: light.hallway
        data:
          brightness_pct: 60
          
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
          entity_id: light.hallway
```

### 2. Time-Based Scene Activation

```yaml
automation:
  - alias: "Morning Routine"
    trigger:
      - platform: time
        at: "07:00:00"
    condition:
      - condition: state
        entity_id: binary_sensor.workday
        state: "on"
    action:
      - service: scene.turn_on
        target:
          entity_id: scene.morning
      - service: notify.mobile_app
        data:
          message: "Good morning! ☀️"

  - alias: "Evening Routine"
    trigger:
      - platform: sun
        event: sunset
        offset: "-00:30:00"
    action:
      - service: scene.turn_on
        target:
          entity_id: scene.evening
      - service: light.turn_on
        target:
          entity_id: light.outdoor_lights
```

### 3. Door/Window Alerts

```yaml
automation:
  - alias: "Door Left Open Alert"
    trigger:
      - platform: state
        entity_id: binary_sensor.front_door
        to: "on"
        for:
          minutes: 10
    action:
      - service: notify.mobile_app
        data:
          message: "⚠️ Front door has been open for 10 minutes"
          title: "Security Alert"
      - service: tts.google_translate_say
        data:
          entity_id: media_player.home_speaker
          message: "The front door has been left open"
```

## MQTT-Based Automations

### 1. Zigbee Device State to MQTT

```yaml
automation:
  - alias: "Temperature Alert via MQTT"
    trigger:
      - platform: mqtt
        topic: "zigbee2mqtt/temperature_sensor/temperature"
    condition:
      - condition: numeric_state
        entity_id: sensor.temperature_sensor
        above: 25
    action:
      - service: mqtt.publish
        data:
          topic: "alerts/temperature"
          payload: >
            {
              "location": "Living Room",
              "temperature": {{ states('sensor.temperature_sensor') }},
              "timestamp": "{{ now() }}"
            }
```

### 2. Custom MQTT Sensor Automation

```yaml
# Listen to custom MQTT sensor
automation:
  - alias: "Custom Sensor Alert"
    trigger:
      - platform: mqtt
        topic: "home/sensors/custom/state"
        payload: "triggered"
    action:
      - service: light.turn_on
        target:
          entity_id: light.alert_light
        data:
          rgb_color: [255, 0, 0]
          brightness: 255
      - service: notify.gotify
        data:
          message: "Custom sensor triggered!"
```

### 3. Publish Device State to n8n

```yaml
automation:
  - alias: "Publish State to n8n"
    trigger:
      - platform: state
        entity_id: 
          - binary_sensor.motion_living_room
          - binary_sensor.door_front
          - sensor.temperature_bedroom
    action:
      - service: mqtt.publish
        data:
          topic: "homeassistant/events/{{ trigger.entity_id | replace('.', '/') }}"
          payload: >
            {
              "entity_id": "{{ trigger.entity_id }}",
              "from_state": "{{ trigger.from_state.state }}",
              "to_state": "{{ trigger.to_state.state }}",
              "timestamp": "{{ now() }}"
            }
          retain: false
```

## Matter Device Automations

### 1. Matter Button Controller

```yaml
automation:
  - alias: "Matter Button - Single Press"
    trigger:
      - platform: event
        event_type: matter_event
        event_data:
          device_id: "YOUR_MATTER_BUTTON_DEVICE_ID"
          command: "Press"
    action:
      - service: light.toggle
        target:
          entity_id: light.living_room

  - alias: "Matter Button - Double Press"
    trigger:
      - platform: event
        event_type: matter_event
        event_data:
          device_id: "YOUR_MATTER_BUTTON_DEVICE_ID"
          command: "MultiPressComplete"
          count: 2
    action:
      - service: scene.turn_on
        target:
          entity_id: scene.movie_time

  - alias: "Matter Button - Long Press"
    trigger:
      - platform: event
        event_type: matter_event
        event_data:
          device_id: "YOUR_MATTER_BUTTON_DEVICE_ID"
          command: "LongPress"
    action:
      - service: light.turn_off
        target:
          entity_id: all
```

### 2. Matter Sensor Automation

```yaml
automation:
  - alias: "Matter Motion - Turn On Lights"
    trigger:
      - platform: state
        entity_id: binary_sensor.matter_motion_hallway
        to: "on"
    action:
      - service: light.turn_on
        target:
          entity_id: light.matter_hallway_light
        data:
          brightness_pct: 80
          transition: 1
```

## Philips Hue Scenes

### 1. Dynamic Hue Scenes

```yaml
automation:
  - alias: "Movie Time Scene"
    trigger:
      - platform: state
        entity_id: media_player.tv
        to: "playing"
    condition:
      - condition: sun
        after: sunset
    action:
      - service: hue.hue_activate_scene
        data:
          group_name: "Living Room"
          scene_name: "Relax"
      - service: light.turn_on
        target:
          entity_id: light.bias_lighting
        data:
          brightness: 50

  - alias: "Concentrate Scene"
    trigger:
      - platform: time
        at: "09:00:00"
    condition:
      - condition: state
        entity_id: binary_sensor.workday
        state: "on"
    action:
      - service: hue.hue_activate_scene
        data:
          group_name: "Office"
          scene_name: "Concentrate"
```

### 2. Adaptive Lighting with Hue

```yaml
automation:
  - alias: "Adaptive Hue Lighting"
    trigger:
      - platform: time_pattern
        minutes: "/30"
    condition:
      - condition: state
        entity_id: light.living_room_hue
        state: "on"
    action:
      - service: light.turn_on
        target:
          entity_id: light.living_room_hue
        data:
          color_temp: >
            {% set time = now().hour %}
            {% if time >= 6 and time < 9 %}
              450
            {% elif time >= 9 and time < 18 %}
              350
            {% elif time >= 18 and time < 22 %}
              400
            {% else %}
              500
            {% endif %}
```

## Integration with n8n

### 1. Home Assistant → n8n Webhook

**In Home Assistant:**
```yaml
# rest_command.yaml
rest_command:
  send_to_n8n:
    url: "http://chain_n8n:5678/webhook/home-assistant"
    method: POST
    payload: >
      {
        "entity_id": "{{ entity_id }}",
        "state": "{{ state }}",
        "timestamp": "{{ timestamp }}"
      }
    content_type: "application/json"

# automation.yaml
automation:
  - alias: "Send Critical Events to n8n"
    trigger:
      - platform: state
        entity_id:
          - binary_sensor.front_door
          - binary_sensor.smoke_detector
          - binary_sensor.water_leak
        to: "on"
    action:
      - service: rest_command.send_to_n8n
        data:
          entity_id: "{{ trigger.entity_id }}"
          state: "{{ trigger.to_state.state }}"
          timestamp: "{{ now() }}"
```

**In n8n workflow:**
```json
{
  "nodes": [
    {
      "name": "Webhook",
      "type": "n8n-nodes-base.webhook",
      "parameters": {
        "path": "home-assistant",
        "responseMode": "onReceived"
      }
    },
    {
      "name": "Process Event",
      "type": "n8n-nodes-base.function",
      "parameters": {
        "functionCode": "// Process HA event\nconst data = items[0].json;\nreturn [{ json: data }];"
      }
    },
    {
      "name": "Send Notification",
      "type": "n8n-nodes-base.httpRequest",
      "parameters": {
        "url": "http://messaging_gotify/message",
        "method": "POST"
      }
    }
  ]
}
```

### 2. n8n → Home Assistant Control

**n8n workflow to control HA:**
```javascript
// In n8n HTTP Request node
{
  "method": "POST",
  "url": "http://home_homeassistant:8123/api/services/light/turn_on",
  "headers": {
    "Authorization": "Bearer YOUR_LONG_LIVED_ACCESS_TOKEN",
    "Content-Type": "application/json"
  },
  "body": {
    "entity_id": "light.living_room",
    "brightness": 255
  }
}
```

## Notification Examples

### 1. Gotify Notifications

```yaml
# configuration.yaml
notify:
  - name: gotify
    platform: rest
    resource: http://messaging_gotify/message
    method: POST
    headers:
      X-Gotify-Key: "YOUR_APP_TOKEN"
    message_param_name: message
    title_param_name: title

# automation.yaml
automation:
  - alias: "Security Alert via Gotify"
    trigger:
      - platform: state
        entity_id: binary_sensor.motion_backyard
        to: "on"
    condition:
      - condition: state
        entity_id: alarm_control_panel.home_alarm
        state: "armed_away"
    action:
      - service: notify.gotify
        data:
          title: "🚨 Security Alert"
          message: "Motion detected in backyard while armed!"
          data:
            priority: 10
```

### 2. Combined Notification (Mobile + Gotify)

```yaml
automation:
  - alias: "Critical Alert - All Channels"
    trigger:
      - platform: state
        entity_id: binary_sensor.smoke_detector
        to: "on"
    action:
      - service: notify.mobile_app
        data:
          title: "🔥 SMOKE DETECTED"
          message: "Smoke detector activated!"
          data:
            priority: high
            sound: alarm.mp3
      - service: notify.gotify
        data:
          title: "🔥 SMOKE DETECTED"
          message: "Smoke detector activated!"
          data:
            priority: 10
      - service: tts.google_translate_say
        data:
          entity_id: media_player.all_speakers
          message: "Warning! Smoke detected. Please evacuate."
```

## Advanced Automations

### 1. Presence Detection with Multiple Sensors

```yaml
automation:
  - alias: "Smart Presence - Home"
    trigger:
      - platform: state
        entity_id:
          - device_tracker.phone_1
          - device_tracker.phone_2
        to: "home"
    action:
      - service: scene.turn_on
        target:
          entity_id: scene.welcome_home
      - service: climate.set_preset_mode
        target:
          entity_id: climate.main_thermostat
        data:
          preset_mode: "home"
      - service: mqtt.publish
        data:
          topic: "home/presence/status"
          payload: "occupied"

  - alias: "Smart Presence - Away"
    trigger:
      - platform: state
        entity_id:
          - device_tracker.phone_1
          - device_tracker.phone_2
        to: "not_home"
        for:
          minutes: 10
    condition:
      - condition: template
        value_template: >
          {{ states('device_tracker.phone_1') == 'not_home' 
             and states('device_tracker.phone_2') == 'not_home' }}
    action:
      - service: scene.turn_on
        target:
          entity_id: scene.away
      - service: climate.set_preset_mode
        target:
          entity_id: climate.main_thermostat
        data:
          preset_mode: "away"
      - service: alarm_control_panel.alarm_arm_away
        target:
          entity_id: alarm_control_panel.home_alarm
```

### 2. Energy Management

```yaml
automation:
  - alias: "High Energy Usage Alert"
    trigger:
      - platform: numeric_state
        entity_id: sensor.power_consumption
        above: 3000
        for:
          minutes: 5
    action:
      - service: notify.mobile_app
        data:
          message: "⚡ High energy usage detected: {{ states('sensor.power_consumption') }}W"
      - service: mqtt.publish
        data:
          topic: "home/energy/alert"
          payload: >
            {
              "usage": {{ states('sensor.power_consumption') }},
              "timestamp": "{{ now() }}"
            }

  - alias: "Load Shedding - Non-Essential Devices"
    trigger:
      - platform: numeric_state
        entity_id: sensor.power_consumption
        above: 4000
    action:
      - service: switch.turn_off
        target:
          entity_id:
            - switch.pool_pump
            - switch.water_heater
      - service: notify.mobile_app
        data:
          message: "⚡ Load shedding activated - non-essential devices turned off"
```

### 3. Weather-Based Automations

```yaml
automation:
  - alias: "Rain Detected - Close Windows"
    trigger:
      - platform: state
        entity_id: weather.home
        attribute: condition
        to: "rainy"
    condition:
      - condition: state
        entity_id: cover.bedroom_window
        state: "open"
    action:
      - service: cover.close_cover
        target:
          entity_id: cover.bedroom_window
      - service: notify.mobile_app
        data:
          message: "🌧️ Rain detected - closing bedroom window"

  - alias: "Strong Wind - Close Awning"
    trigger:
      - platform: numeric_state
        entity_id: sensor.wind_speed
        above: 30
    action:
      - service: cover.close_cover
        target:
          entity_id: cover.patio_awning
      - service: notify.mobile_app
        data:
          message: "💨 Strong wind detected - retracting awning"
```

### 4. Circadian Rhythm Lighting

```yaml
automation:
  - alias: "Circadian Lighting Update"
    trigger:
      - platform: time_pattern
        minutes: "/15"
    condition:
      - condition: state
        entity_id: input_boolean.circadian_lighting
        state: "on"
    action:
      - service: light.turn_on
        target:
          entity_id: light.adaptive_lights
        data:
          brightness_pct: >
            {% set hour = now().hour %}
            {% if hour >= 6 and hour < 9 %}
              60
            {% elif hour >= 9 and hour < 18 %}
              100
            {% elif hour >= 18 and hour < 21 %}
              80
            {% elif hour >= 21 and hour < 23 %}
              40
            {% else %}
              10
            {% endif %}
          color_temp: >
            {% set hour = now().hour %}
            {% if hour >= 6 and hour < 9 %}
              400
            {% elif hour >= 9 and hour < 18 %}
              300
            {% elif hour >= 18 and hour < 22 %}
              380
            {% else %}
              450
            {% endif %}
```

## Configuration Files Location

All these automations can be added to:

1. **UI-based**: Settings → Automations → Create Automation
2. **YAML-based**: 
   - `/config/automations.yaml` (inside Home Assistant container)
   - Or create includes: `/config/automations/`

To edit configuration:
```bash
# Access container
docker exec -it home_homeassistant bash

# Edit automations
cd /config
vi automations.yaml

# Check configuration
ha core check

# Reload automations
ha core restart
```

## Testing Automations

### 1. Developer Tools

Use Home Assistant's Developer Tools:
- **States**: View current entity states
- **Services**: Test service calls
- **Events**: Listen for events
- **Templates**: Test template syntax

### 2. Manual Triggers

Add manual triggers for testing:
```yaml
automation:
  - alias: "Test Automation"
    trigger:
      - platform: state
        entity_id: binary_sensor.motion_test
      - platform: event
        event_type: test_automation
    action:
      - service: persistent_notification.create
        data:
          message: "Test automation triggered!"
```

Trigger from Developer Tools → Events:
```yaml
event_type: test_automation
event_data: {}
```

## Best Practices

1. **Use descriptive names**: `"Motion - Living Room Lights"` not `"Automation 1"`
2. **Add descriptions**: Help future you understand the automation
3. **Use conditions**: Prevent unwanted triggers
4. **Test incrementally**: Build complex automations step by step
5. **Log important events**: Use notifications or MQTT for tracking
6. **Use input_boolean**: Create switches to enable/disable automations
7. **Version control**: Keep backups of your automations.yaml

## Resources

- [Home Assistant Automation Docs](https://www.home-assistant.io/docs/automation/)
- [Blueprint Exchange](https://community.home-assistant.io/c/blueprints-exchange)
- [Automation Examples](https://www.home-assistant.io/cookbook/)
- [n8n Workflows](https://n8n.io/workflows/)

---

**Remember**: Start simple and build complexity as you learn. Test automations thoroughly before relying on them for critical functions!
