# Kompose Watch Stack - Integration Architecture

## Complete Integration Diagram

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                         Kompose Network (Bridge)                             │
│                              kompose_network                                 │
└──────────────────────────────────────────────────────────────────────────────┘
                                      │
    ┌─────────────────────────────────┼─────────────────────────────────┐
    │                                 │                                 │
    │                                 │                                 │
┌───▼───────────────────┐   ┌────────▼──────────┐   ┌─────────────────▼─────┐
│   Layer 0: CORE       │   │ Layer 1b: UTILITY │   │   Layer 1: HOME       │
│   (Foundation)        │   │ (System Services) │   │   (Smart Home)        │
└───────────────────────┘   └───────────────────┘   └───────────────────────┘
│                           │                       │                         │
│  ┌──────────────────┐    │  ┌──────────────┐    │  ┌──────────────────┐  │
│  │   PostgreSQL     │    │  │    Umami     │    │  │ Home Assistant   │  │
│  │  (core-postgres) │◄───┼──┤  (track_app) │    │  │   (8123)         │  │
│  │     :5432        │    │  │    :3000     │    │  │                  │  │
│  └────────┬─────────┘    │  └──────┬───────┘    │  └────────┬─────────┘  │
│           │              │         │            │           │            │
│           │              │         │            │           │            │
│  ┌────────▼─────────┐    │  ┌──────▼───────┐    │  ┌────────▼─────────┐  │
│  │     Redis        │◄───┼──┤   WATCH      │    │  │  Zigbee2MQTT     │  │
│  │  (core-redis)    │    │  │   STACK      │    │  │   (optional)     │  │
│  │     :6379        │    │  │              │    │  └──────────────────┘  │
│  └────────┬─────────┘    │  └──────────────┘    │                         │
│           │              │         │            │                         │
│           │              │         │            │                         │
│  ┌────────▼─────────┐    │  ┌──────▼───────┐    │                         │
│  │   Mosquitto      │◄───┼──┤              │────┼─────────────────────────┘
│  │   (core-mqtt)    │    │  │              │    │
│  │   :1883, :9001   │    │  │              │    │
│  └────────┬─────────┘    │  │              │    │
│           │              │  │              │    │
└───────────┼──────────────┘  │              │    └────────────────────────────
            │                 │              │
            │                 │  WATCH Stack │
            │                 │  Components: │
            │                 │              │
            │                 │  ┌──────────────────────┐
            │                 │  │  Prometheus          │
            └─────────────────┼──┤  (Metrics Storage)   │
                              │  │  :9090               │
                              │  └──────────┬───────────┘
                              │             │
                              │  ┌──────────▼───────────┐
                              │  │  Grafana             │
                              │  │  (Visualization)     │
                              │  │  :3000               │
                              │  └──────────────────────┘
                              │
                              │  ┌──────────────────────┐
                              │  │  OTEL Collector      │
                              │  │  (Telemetry)         │
                              │  │  :4317, :4318        │
                              │  └──────────────────────┘
                              │
                              │  ┌──────────────────────┐
                              │  │  Exporters           │
                              │  ├──────────────────────┤
                              │  │  • PostgreSQL :9187  │
                              │  │  • Redis :9121       │
                              │  │  • MQTT :9000        │
                              │  │  • cAdvisor :8082    │
                              │  │  • Node :9100        │
                              │  │  • Blackbox :9115    │
                              │  └──────────────────────┘
                              │
                              │  ┌──────────────────────┐
                              │  │  Alertmanager        │
                              │  │  (Alert Routing)     │
                              │  │  :9093               │
                              │  └──────────────────────┘
                              │
                              └───────────────────────────
```

## Data Flow Diagram

```
                    ┌─────────────────────────────────┐
                    │      Prometheus                 │
                    │   (Metrics Database)            │
                    │                                 │
                    │  Scrapes from:                  │
                    │  • PostgreSQL Exporter          │
                    │  • Redis Exporter               │
                    │  • MQTT Exporter                │
                    │  • Home Assistant API           │
                    │  • Umami (via Blackbox)         │
                    │  • OTEL Collector               │
                    │  • All other exporters          │
                    └──────────┬──────────────────────┘
                               │
                ┌──────────────┼──────────────┐
                │              │              │
        ┌───────▼──────┐  ┌────▼─────┐  ┌────▼──────────┐
        │   Grafana    │  │ OTEL     │  │ Alertmanager  │
        │              │  │ Pipeline │  │               │
        │ Dashboards   │  │          │  │ Email/Slack   │
        │ Queries      │  │ MQTT ←───┼──┤ Webhooks      │
        │ Alerts       │  │ Topics   │  │ PagerDuty     │
        └──────────────┘  └──────────┘  └───────────────┘
```

## MQTT Topic Flow

```
┌─────────────────────┐
│   Core MQTT Broker  │
│   (core-mqtt:1883)  │
└──────────┬──────────┘
           │
           │  Topics:
           │  • homeassistant/#
           │  • sensor/#
           │  • device/#
           │  • telemetry/#
           │  • custom/#
           │
    ┌──────┼──────┐
    │             │
┌───▼────┐   ┌────▼────────┐
│ MQTT   │   │ OTEL        │
│ Export │   │ Collector   │
│ :9000  │   │ MQTT Recv   │
└───┬────┘   └────┬────────┘
    │             │
    │             │
    └──────┬──────┘
           │
    ┌──────▼────────┐
    │  Prometheus   │
    │  (Metrics)    │
    └───────────────┘
```

## Service Dependencies

```
Prometheus
  ├─ Depends on: None (first to start)
  └─ Required by: Grafana, Alertmanager

Grafana
  ├─ Depends on: Prometheus, PostgreSQL
  └─ Datasource: Prometheus

OTEL Collector
  ├─ Depends on: Prometheus (for export)
  └─ Connects to: MQTT Broker

PostgreSQL Exporter
  ├─ Depends on: PostgreSQL (core-postgres)
  └─ Scrapped by: Prometheus

Redis Exporter
  ├─ Depends on: Redis (core-redis)
  └─ Scrapped by: Prometheus

MQTT Exporter
  ├─ Depends on: Mosquitto (core-mqtt)
  └─ Scrapped by: Prometheus

Home Assistant
  ├─ Depends on: MQTT Broker (optional)
  └─ Scrapped by: Prometheus (via API)

Umami
  ├─ Depends on: PostgreSQL
  └─ Monitored by: Blackbox Exporter
```

## Port Mapping Reference

```
Service                    Internal Port    External Port    Protocol
────────────────────────────────────────────────────────────────────────
Prometheus                 9090             9090             HTTP
Grafana                    3000             3001             HTTP
OTEL Collector (gRPC)      4317             4317             gRPC
OTEL Collector (HTTP)      4318             4318             HTTP
OTEL Health Check          13133            13133            HTTP
PostgreSQL Exporter        9187             9187             HTTP
Redis Exporter             9121             9121             HTTP
MQTT Exporter              9000             9000             HTTP
cAdvisor                   8080             8082             HTTP
Node Exporter              9100             9100 (host)      HTTP
Blackbox Exporter          9115             9115             HTTP
Alertmanager               9093             9093             HTTP
───────────────────────────────────────────────────────────────────────
PostgreSQL (core)          5432             -                TCP
Redis (core)               6379             -                TCP
Mosquitto (core)           1883, 9001       1883, 9001       TCP/WS
Home Assistant             8123             8123             HTTP
Umami                      3000             3000             HTTP
```

## Network Layout

```
┌──────────────────────────────────────────────────────────────┐
│                     kompose (Bridge Network)                 │
│                                                              │
│  Subnet: 172.18.0.0/16 (auto-assigned)                      │
│  Driver: bridge                                             │
│  External: true (created separately)                        │
│                                                              │
│  Connected Containers:                                       │
│  ├─ core-postgres       (172.18.0.2)                       │
│  ├─ core-redis          (172.18.0.3)                       │
│  ├─ core-mqtt           (172.18.0.4)                       │
│  ├─ watch_prometheus    (172.18.0.10)                      │
│  ├─ watch_grafana       (172.18.0.11)                      │
│  ├─ watch_otel          (172.18.0.12)                      │
│  ├─ watch_*_exporter    (172.18.0.13-19)                   │
│  ├─ track_app           (172.18.0.20)                      │
│  ├─ home_homeassistant  (172.18.0.30)                      │
│  └─ proxy_app (Traefik) (172.18.0.5)                       │
│                                                              │
│  DNS Resolution: Container names resolve automatically      │
│  Example: core-mqtt resolves to 172.18.0.4                 │
└──────────────────────────────────────────────────────────────┘

Note: Actual IP addresses are assigned dynamically by Docker
```

## Monitoring Coverage

```
┌─────────────────────────────────────────────────────────────┐
│                      What Gets Monitored                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Infrastructure Layer                                        │
│  ├─ Host System (CPU, Memory, Disk, Network)               │
│  ├─ Docker Containers (cAdvisor)                           │
│  └─ Network Connectivity (Blackbox)                        │
│                                                             │
│  Core Services Layer                                        │
│  ├─ PostgreSQL (Connections, Queries, Replication)         │
│  ├─ Redis (Cache, Memory, Commands)                        │
│  └─ Mosquitto (Messages, Topics, Connections)              │
│                                                             │
│  Application Layer                                          │
│  ├─ Umami (Availability, Response Time)                    │
│  ├─ Home Assistant (Sensors, States, Events)               │
│  └─ Watch Stack (Self-monitoring)                          │
│                                                             │
│  Telemetry Layer                                            │
│  ├─ MQTT Topics (Real-time messages)                       │
│  ├─ OTEL Traces (if enabled)                               │
│  └─ Custom Metrics (via OTEL)                              │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Alert Flow

```
┌──────────────┐
│  Prometheus  │  Evaluates Rules
│  Alert Rules │  Every 15s
└──────┬───────┘
       │
       │  Alert Triggered
       │
┌──────▼────────┐
│ Alertmanager  │  Routes & Groups
│               │  Deduplicates
└──────┬────────┘
       │
       │  Sends Notifications
       │
   ┌───┼───┬───────────┐
   │       │           │
┌──▼──┐ ┌──▼───┐ ┌────▼────┐
│Email│ │Slack │ │PagerDuty│
└─────┘ └──────┘ └─────────┘
```

---

## Legend

- `─`, `│`, `┌`, `┐`, `└`, `┘` : Box drawing characters
- `◄`, `►`, `▼`, `▲` : Flow direction
- `:port` : Port numbers
- `(name)` : Container/service names
- `#` : MQTT wildcard (all topics)

---

**For detailed configuration and setup, see:**
- INTEGRATION_GUIDE.md
- INTEGRATION_QUICK_REF.md
- SETUP_SUMMARY.md
