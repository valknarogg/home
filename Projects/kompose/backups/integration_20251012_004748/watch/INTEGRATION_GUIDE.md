# Watch Stack Integration Guide

## Overview

This guide explains how the **watch** monitoring stack integrates with other Kompose services, specifically:
- **Umami** (Track service) - Web analytics platform
- **MQTT** (Core service) - Message broker for IoT and real-time data
- **Home Assistant** (Home service) - Smart home platform

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        Kompose Network                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────┐      ┌──────────────┐      ┌──────────────┐ │
│  │   Layer 0    │      │   Layer 1b   │      │   Layer 2    │ │
│  │     CORE     │      │   UTILITY    │      │    CUSTOM    │ │
│  └──────────────┘      └──────────────┘      └──────────────┘ │
│                                                                 │
│  ┌─────────────┐       ┌──────────────┐                        │
│  │ PostgreSQL  │◄──────┤  Prometheus  │                        │
│  │   (5432)    │       │    (9090)    │                        │
│  └─────────────┘       └──────┬───────┘                        │
│                               │                                 │
│  ┌─────────────┐       ┌──────▼───────┐       ┌─────────────┐ │
│  │    Redis    │◄──────┤   Grafana    │       │   Umami     │ │
│  │   (6379)    │       │    (3000)    │       │   (3000)    │ │
│  └─────────────┘       └──────────────┘       └──────┬──────┘ │
│                                                       │         │
│  ┌─────────────┐       ┌──────────────┐       ┌──────▼──────┐ │
│  │ Mosquitto   │◄──────┤     OTEL     │◄──────┤  Blackbox   │ │
│  │   (1883)    │       │  Collector   │       │  Exporter   │ │
│  └──────┬──────┘       └──────┬───────┘       └─────────────┘ │
│         │                     │                                │
│         │              ┌──────▼───────┐                        │
│         └──────────────┤     MQTT     │                        │
│                        │   Exporter   │                        │
│         ┌──────────────┤    (9000)    │                        │
│         │              └──────────────┘                        │
│         │                                                       │
│  ┌──────▼──────┐       ┌──────────────┐                        │
│  │    Home     │       │  Alertmanager│                        │
│  │ Assistant   │       │    (9093)    │                        │
│  │   (8123)    │       └──────────────┘                        │
│  └─────────────┘                                                │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Current Integration Status

### ✅ Already Connected Services

All services are connected via the shared `kompose_network`. The following integrations are **already configured**:

#### 1. **Core Services → Watch Stack**
- **PostgreSQL**: Monitored by `postgres-exporter` (port 9187)
- **Redis**: Monitored by `redis-exporter` (port 9121)
- **Mosquitto (MQTT)**: Monitored by `mqtt-exporter` (port 9000)

#### 2. **OTEL Collector → MQTT**
The OpenTelemetry Collector is configured to receive MQTT messages from topics:
- `homeassistant/#` - All Home Assistant topics
- `sensor/#` - Sensor data
- `device/#` - Device telemetry
- `telemetry/#` - General telemetry

Connection: `core-mqtt:1883`

#### 3. **Prometheus → All Services**
Prometheus scrapes metrics from:
- Core services (via exporters)
- Home Assistant API
- Umami (via blackbox exporter)
- Watch stack components

### ⚠️ Configuration Required

The following items need manual configuration to fully enable monitoring:

## Setup Instructions

### 1. Home Assistant Integration

#### Step 1: Create Long-Lived Access Token

1. Log into Home Assistant at `http://home_homeassistant:8123` or your configured domain
2. Click on your profile (bottom left)
3. Scroll down to **Long-Lived Access Tokens**
4. Click **Create Token**
5. Name it: `Prometheus Monitoring`
6. Copy the generated token

#### Step 2: Configure Prometheus

Edit the Prometheus configuration:

```bash
cd /home/valknar/Projects/kompose/+utilitiy/watch/prometheus
nano prometheus.yml
```

Find the Home Assistant job and replace the bearer token:

```yaml
# Home Assistant - Smart Home Platform
- job_name: 'homeassistant'
  metrics_path: '/api/prometheus'
  bearer_token: 'YOUR_LONG_LIVED_ACCESS_TOKEN'  # ← Replace this
  static_configs:
    - targets: ['home_homeassistant:8123']
      labels:
        service: 'homeassistant'
        stack: 'home'
        type: 'smart-home'
```

#### Step 3: Restart Prometheus

```bash
cd /home/valknar/Projects/kompose/+utilitiy/watch
docker compose restart prometheus
```

#### Step 4: Verify Home Assistant Metrics

1. Open Prometheus at `http://localhost:9090` or your configured domain
2. Go to **Status → Targets**
3. Find the `homeassistant` job
4. Status should be **UP** (green)
5. Test query: `homeassistant_sensor_temperature_celsius`

### 2. Umami Analytics Integration

Umami (at `+utilitiy/track`) doesn't expose native Prometheus metrics. We use blackbox exporter to monitor its availability:

#### Current Monitoring

The following endpoints are monitored for uptime:

```yaml
- job_name: 'blackbox'
  static_configs:
    - targets:
        - http://track_app:3000  # Umami availability
```

#### Optional: Custom Metrics Export

If you need detailed analytics metrics, consider:

1. **Option A**: Use Umami's API to create a custom exporter
2. **Option B**: Query Umami's PostgreSQL database directly
3. **Option C**: Use OTEL collector with HTTP receiver

Example custom metrics collector (create if needed):

```yaml
# Add to prometheus.yml if you create a custom exporter
- job_name: 'umami-metrics'
  static_configs:
    - targets: ['track_app:9999']  # Custom exporter port
  scrape_interval: 60s
```

### 3. MQTT Topics Monitoring

#### Current Configuration

The MQTT exporter is already configured to monitor all MQTT topics:

```yaml
# In watch/.env
MQTT_EXPORTER_TOPIC=#  # Subscribes to all topics
```

#### Verify MQTT Connection

1. Check MQTT exporter logs:
```bash
docker logs watch_mqtt_exporter
```

2. Check metrics:
```bash
curl http://localhost:9000/metrics | grep mqtt_
```

3. In Prometheus, query:
```promql
mqtt_message_count
mqtt_topic_messages_total
```

#### Configure Topic-Specific Monitoring

If you want to monitor specific topics only:

1. Edit `watch/.env`:
```bash
MQTT_EXPORTER_TOPIC=homeassistant/#,sensor/+/temperature
```

2. Restart the MQTT exporter:
```bash
docker compose restart mqtt-exporter
```

### 4. OTEL Collector MQTT Integration

The OTEL collector receives MQTT messages and converts them to telemetry data.

#### Verify OTEL MQTT Connection

1. Check OTEL collector logs:
```bash
docker logs watch_otel
```

2. Verify MQTT receiver is active:
```bash
curl http://localhost:13133/  # Health check
```

#### Configure Additional MQTT Topics

Edit `otel-collector/config.yaml`:

```yaml
receivers:
  mqtt:
    endpoint: core-mqtt:1883
    topics:
      - homeassistant/#
      - sensor/#
      - device/#
      - telemetry/#
      - custom/topic/#  # Add your custom topics
    qos: 1
    client_id: otel-collector
```

Restart OTEL collector:
```bash
docker compose restart otel-collector
```

## Service URLs

| Service | Internal URL | Description |
|---------|-------------|-------------|
| Prometheus | `http://watch_prometheus:9090` | Metrics database |
| Grafana | `http://watch_grafana:3000` | Visualization |
| Alertmanager | `http://watch_alertmanager:9093` | Alert routing |
| OTEL Collector | `http://watch_otel:4318` | Telemetry pipeline |
| PostgreSQL Exporter | `http://watch_postgres_exporter:9187` | DB metrics |
| Redis Exporter | `http://watch_redis_exporter:9121` | Cache metrics |
| MQTT Exporter | `http://watch_mqtt_exporter:9000` | MQTT metrics |
| Umami | `http://track_app:3000` | Web analytics |
| MQTT Broker | `tcp://core-mqtt:1883` | Message broker |
| Home Assistant | `http://home_homeassistant:8123` | Smart home hub |

## Verification Commands

### Check All Service Connections

```bash
# From the watch directory
cd /home/valknar/Projects/kompose/+utilitiy/watch

# Check all containers are running
docker compose ps

# Check Prometheus targets
curl -s http://localhost:9090/api/v1/targets | jq '.data.activeTargets[] | {job: .labels.job, health: .health}'

# Check MQTT exporter metrics
curl -s http://localhost:9000/metrics | grep mqtt_

# Check PostgreSQL exporter
curl -s http://localhost:9187/metrics | grep pg_

# Check Redis exporter
curl -s http://localhost:9121/metrics | grep redis_

# Test Home Assistant connection
curl -H "Authorization: Bearer YOUR_TOKEN" http://home_homeassistant:8123/api/prometheus
```

### Grafana Dashboards

Access Grafana at your configured URL and import these dashboard IDs:

- **1860**: Node Exporter Full
- **3662**: Prometheus 2.0 Overview
- **7362**: PostgreSQL Database
- **763**: Redis Dashboard
- **13177**: Home Assistant
- **13032**: MQTT Monitoring

## Troubleshooting

### Issue: Prometheus Can't Reach Home Assistant

**Symptom**: Home Assistant target shows as DOWN in Prometheus

**Solutions**:
1. Verify Home Assistant is running:
   ```bash
   docker ps | grep homeassistant
   ```

2. Check if Home Assistant responds:
   ```bash
   curl http://home_homeassistant:8123/api/
   ```

3. Verify the access token is correct:
   ```bash
   curl -H "Authorization: Bearer YOUR_TOKEN" http://home_homeassistant:8123/api/prometheus
   ```

4. Check Prometheus logs:
   ```bash
   docker logs watch_prometheus | grep homeassistant
   ```

### Issue: MQTT Metrics Not Appearing

**Symptom**: No MQTT metrics in Prometheus

**Solutions**:
1. Verify MQTT broker is running:
   ```bash
   docker ps | grep mqtt
   ```

2. Test MQTT connection:
   ```bash
   docker exec core-mqtt mosquitto_sub -t '#' -v -C 1
   ```

3. Check MQTT exporter logs:
   ```bash
   docker logs watch_mqtt_exporter
   ```

4. Verify network connectivity:
   ```bash
   docker exec watch_mqtt_exporter ping -c 3 core-mqtt
   ```

### Issue: OTEL Collector Not Receiving MQTT Data

**Symptom**: MQTT topics not appearing in OTEL metrics

**Solutions**:
1. Check OTEL collector logs:
   ```bash
   docker logs watch_otel | grep mqtt
   ```

2. Verify MQTT receiver configuration:
   ```bash
   docker exec watch_otel cat /etc/otel-collector-config.yaml | grep -A 10 mqtt
   ```

3. Test MQTT connection from OTEL container:
   ```bash
   docker exec watch_otel wget -qO- http://core-mqtt:1883
   ```

### Issue: Umami Monitoring Not Working

**Symptom**: Blackbox exporter shows Umami as DOWN

**Solutions**:
1. Verify Umami is running:
   ```bash
   docker ps | grep track_app
   ```

2. Test Umami endpoint:
   ```bash
   curl http://track_app:3000/api/heartbeat
   ```

3. Check blackbox exporter config:
   ```bash
   cat blackbox-exporter/blackbox.yml
   ```

## Network Connectivity

All services communicate via the shared `kompose_network`. Verify connectivity:

```bash
# List all containers on the network
docker network inspect kompose | jq -r '.[] | .Containers | to_entries[] | "\(.value.Name): \(.value.IPv4Address)"'

# Test connectivity between services
docker exec watch_prometheus ping -c 3 core-mqtt
docker exec watch_prometheus ping -c 3 home_homeassistant
docker exec watch_prometheus ping -c 3 track_app
```

## Security Considerations

1. **Prometheus & Alertmanager**: Protected by basic auth (configure in .env)
2. **Grafana**: Has admin credentials (change default password)
3. **Home Assistant Token**: Keep the long-lived token secure
4. **MQTT**: Consider enabling authentication in Mosquitto config
5. **Internal Services**: Use Traefik for external access with SSL

## Next Steps

1. **Configure Home Assistant Token** (required)
2. **Set up Grafana Dashboards** (recommended)
3. **Configure Alert Rules** (optional)
4. **Enable MQTT Authentication** (recommended for production)
5. **Set up Custom Umami Metrics** (optional)

## Additional Resources

- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)
- [Home Assistant Prometheus Integration](https://www.home-assistant.io/integrations/prometheus/)
- [OTEL Collector Configuration](https://opentelemetry.io/docs/collector/configuration/)
- [Mosquitto MQTT Broker](https://mosquitto.org/documentation/)

## Support

For issues specific to the Kompose project, check the main README or open an issue in the repository.
