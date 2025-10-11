# Watch Stack Integration - Quick Reference

## 🔗 Integration Map

```
+utilitiy/watch (Layer 1b - System Services)
│
├─► core (Layer 0 - Foundation)
│   ├── PostgreSQL (core-postgres:5432)
│   ├── Redis (core-redis:6379)
│   └── Mosquitto (core-mqtt:1883)
│
├─► +utilitiy/track (Layer 1b - Umami Analytics)
│   └── Umami (track_app:3000)
│
└─► home (Layer 1 - Smart Home)
    └── Home Assistant (home_homeassistant:8123)
```

## ✅ Integration Checklist

### Core Services Integration (✓ Complete)
- [x] PostgreSQL exporter configured
- [x] Redis exporter configured  
- [x] MQTT exporter configured
- [x] Network connectivity established
- [x] Prometheus scrape configs added

### Umami Integration (✓ Partial - Basic Monitoring)
- [x] Blackbox exporter monitors availability
- [x] HTTP health checks configured
- [ ] Custom metrics exporter (optional)
- [ ] Database-level analytics (optional)

### Home Assistant Integration (⚠️ Action Required)
- [x] Prometheus scrape config added
- [x] OTEL collector MQTT receiver configured
- [ ] **Long-lived access token required**
- [ ] Grafana dashboards imported

### MQTT Integration (✓ Complete)
- [x] OTEL collector subscribed to topics
- [x] MQTT exporter monitoring all topics
- [x] Home Assistant MQTT integration ready
- [x] Network connectivity verified

## 🎯 Action Items

### Priority 1: Required for Full Functionality
1. **Create Home Assistant Access Token**
   - Go to: http://home_homeassistant:8123
   - Profile → Long-Lived Access Tokens
   - Create token named "Prometheus"
   - Update: `prometheus/prometheus.yml`

### Priority 2: Recommended Setup
1. **Change Default Passwords** (in watch/.env)
   - GRAFANA_ADMIN_PASSWORD
   - GRAFANA_DB_PASSWORD
   - POSTGRES_EXPORTER_PASSWORD
   - REDIS_EXPORTER_PASSWORD

2. **Import Grafana Dashboards**
   - Dashboard 1860: Node Exporter
   - Dashboard 3662: Prometheus Overview
   - Dashboard 13177: Home Assistant

### Priority 3: Optional Enhancements
1. **Configure MQTT Authentication**
2. **Set up Custom Umami Metrics**
3. **Configure Alertmanager Notifications**

## 📊 Service Endpoints

| Service | Port | Internal Address | Purpose |
|---------|------|-----------------|---------|
| Prometheus | 9090 | watch_prometheus:9090 | Metrics Storage |
| Grafana | 3001 | watch_grafana:3000 | Visualization |
| OTEL Collector | 4317/4318 | watch_otel:4317 | Telemetry Pipeline |
| PostgreSQL Exporter | 9187 | watch_postgres_exporter:9187 | DB Metrics |
| Redis Exporter | 9121 | watch_redis_exporter:9121 | Cache Metrics |
| MQTT Exporter | 9000 | watch_mqtt_exporter:9000 | MQTT Metrics |
| Alertmanager | 9093 | watch_alertmanager:9093 | Alert Management |
| Umami | 3000 | track_app:3000 | Web Analytics |
| MQTT Broker | 1883 | core-mqtt:1883 | Message Broker |
| Home Assistant | 8123 | home_homeassistant:8123 | Smart Home |

## 🧪 Quick Tests

### Test 1: Core Services
```bash
# PostgreSQL
curl http://localhost:9187/metrics | grep pg_up

# Redis  
curl http://localhost:9121/metrics | grep redis_up

# MQTT
curl http://localhost:9000/metrics | grep mqtt_
```

### Test 2: Umami Availability
```bash
curl http://track_app:3000/api/heartbeat
# Expected: 200 OK response
```

### Test 3: Home Assistant (requires token)
```bash
curl -H "Authorization: Bearer YOUR_TOKEN" \
  http://home_homeassistant:8123/api/prometheus
# Expected: Prometheus format metrics
```

### Test 4: MQTT Topics
```bash
docker exec core-mqtt mosquitto_sub -t '#' -v -C 5
# Expected: See published messages
```

### Test 5: Prometheus Targets
```bash
curl http://localhost:9090/api/v1/targets | jq '.data.activeTargets[].health'
# Expected: All "up"
```

## 🔧 Common Commands

### Restart Individual Services
```bash
cd /home/valknar/Projects/kompose/+utilitiy/watch
docker compose restart prometheus
docker compose restart grafana
docker compose restart otel-collector
docker compose restart mqtt-exporter
```

### View Logs
```bash
docker logs -f watch_prometheus
docker logs -f watch_grafana
docker logs -f watch_otel
docker logs -f watch_mqtt_exporter
```

### Check Service Health
```bash
# All watch services
docker compose ps

# Specific service
docker compose exec prometheus wget -qO- localhost:9090/-/healthy
```

### Reload Prometheus Config (without restart)
```bash
curl -X POST http://localhost:9090/-/reload
```

## 🎨 Grafana Quick Setup

### Access Grafana
```
URL: http://localhost:3001 or https://grafana.localhost
User: admin
Pass: (from watch/.env: GRAFANA_ADMIN_PASSWORD)
```

### Add Prometheus Data Source
1. Configuration → Data Sources → Add data source
2. Select Prometheus
3. URL: `http://watch_prometheus:9090`
4. Save & Test

### Import Dashboards
1. Dashboards → Import
2. Enter Dashboard ID:
   - 1860: Node Exporter Full
   - 3662: Prometheus 2.0 Overview  
   - 7362: PostgreSQL Database
   - 763: Redis Dashboard
   - 13177: Home Assistant
3. Select Prometheus data source
4. Import

## 🚨 Troubleshooting

### Issue: Service Won't Start
```bash
# Check logs
docker compose logs [service-name]

# Check dependencies
docker compose ps

# Verify network
docker network inspect kompose
```

### Issue: Can't Connect to Core Services
```bash
# Test connectivity
docker exec watch_prometheus ping -c 3 core-mqtt
docker exec watch_prometheus ping -c 3 core-postgres

# Check network membership
docker network inspect kompose | grep -A 5 "watch_"
```

### Issue: Metrics Not Appearing
```bash
# Check Prometheus targets
curl http://localhost:9090/api/v1/targets

# Check exporter health
curl http://localhost:9187/  # postgres exporter
curl http://localhost:9121/metrics  # redis exporter
curl http://localhost:9000/metrics  # mqtt exporter
```

## 📁 Important Files

| File | Purpose |
|------|---------|
| `compose.yaml` | Main service definitions |
| `.env` | Configuration variables |
| `prometheus/prometheus.yml` | Scrape configurations |
| `otel-collector/config.yaml` | OTEL pipeline config |
| `grafana/provisioning/` | Auto-provisioning configs |
| `alertmanager/alertmanager.yml` | Alert routing rules |

## 🔐 Security Notes

1. **Change default passwords** in `.env`
2. **Protect access tokens** (Home Assistant, Grafana)
3. **Use Traefik** for external access with SSL
4. **Enable MQTT auth** for production
5. **Review firewall rules** for exposed ports

## 📚 Related Documentation

- Main Integration Guide: `INTEGRATION_GUIDE.md`
- Core Stack: `/home/valknar/Projects/kompose/core/README.md`
- Home Stack: `/home/valknar/Projects/kompose/home/README.md`
- Track Stack: `/home/valknar/Projects/kompose/+utilitiy/track/`

## 🎯 Success Criteria

✅ All integration requirements met when:
- [ ] All Prometheus targets show "UP" status
- [ ] Grafana displays data from all sources
- [ ] Home Assistant metrics visible in Prometheus
- [ ] MQTT messages flowing through OTEL collector
- [ ] Umami availability monitored
- [ ] Alerts configured and tested
- [ ] All default passwords changed
