# Kompose Service Network - Complete Wiring Diagram

## 🌐 Network Architecture

```
┌────────────────────────────────────────────────────────────────────────────┐
│                          EXTERNAL INTERNET                                 │
│                                   ↓                                        │
│                          DNS: *.pivoine.art                                │
└────────────────────────────────────────────────────────────────────────────┘
                                    ↓
┌────────────────────────────────────────────────────────────────────────────┐
│                         TRAEFIK REVERSE PROXY                              │
│                      (Port 80 → 443, SSL/TLS)                             │
│                                                                            │
│  Routes:                                                                   │
│  ├─ auth.pivoine.art      → Keycloak (SSO)                               │
│  ├─ sso.pivoine.art       → OAuth2 Proxy                                 │
│  ├─ links.pivoine.art     → Linkwarden                                   │
│  ├─ news.pivoine.art      → Letterpress                                  │
│  ├─ analytics.pivoine.art → Umami                                        │
│  ├─ vault.pivoine.art     → Vaultwarden                                  │
│  ├─ prometheus.pivoine.art → Prometheus                                  │
│  ├─ grafana.pivoine.art    → Grafana                                     │
│  └─ alerts.pivoine.art     → Alertmanager                                │
│                                                                            │
│  Middlewares:                                                              │
│  ├─ sso-secure: SSO + Security Headers + Compression                     │
│  ├─ sso-internal-only: SSO + IP Restriction                              │
│  └─ rate-limit: Request throttling                                       │
└────────────────────────────────────────────────────────────────────────────┘
                                    ↓
┌────────────────────────────────────────────────────────────────────────────┐
│                        KOMPOSE DOCKER NETWORK                              │
│                        (Bridge: kompose)                                   │
└────────────────────────────────────────────────────────────────────────────┘
                                    │
        ┌───────────────────────────┼───────────────────────────┐
        │                           │                           │
        ↓                           ↓                           ↓
┌───────────────────┐    ┌──────────────────┐    ┌──────────────────┐
│   LEVEL 0: CORE   │    │ LEVEL 1: UTILITY │    │ LEVEL 2: CUSTOM  │
│   INFRASTRUCTURE  │    │    SERVICES      │    │     STACKS       │
└───────────────────┘    └──────────────────┘    └──────────────────┘
```

---

## 🔌 Level 0: Core Services Connections

### PostgreSQL (core-postgres)
```
Container: core-postgres
Network: kompose
Internal Port: 5432
External: Not exposed (internal only)

Connected Services:
├─ Keycloak (auth stack)
│  └─ Database: keycloak
├─ Linkwarden (link)
│  └─ Database: linkwarden
├─ Letterpress (news)
│  └─ Database: letterspace
├─ Umami (track)
│  └─ Database: umami
├─ Grafana (watch)
│  └─ Database: grafana
└─ KMPS (management)
   └─ Database: kmps

Monitoring:
└─ PostgreSQL Exporter (watch_postgres_exporter:9187)
   └─ Prometheus scrapes metrics
   └─ Grafana displays dashboards

Backup:
└─ Automated backups via kompose.sh
   └─ Location: /var/local/data/backups/postgres/
```

### Redis (core-redis)
```
Container: core-redis
Network: kompose
Internal Port: 6379
External: Not exposed (internal only)
Auth: Password protected

Connected Services:
├─ OAuth2 Proxy (auth stack)
│  └─ Session storage
├─ Linkwarden (link)
│  ├─ Cache: Frequently accessed bookmarks
│  └─ Session: User sessions
├─ Letterpress (news)
│  ├─ Cache: Article cache
│  └─ Session: Editor sessions
└─ Umami (track)
   └─ Cache: Analytics query results

Monitoring:
└─ Redis Exporter (watch_redis_exporter:9121)
   └─ Prometheus scrapes metrics
   └─ Grafana displays performance

Configuration:
├─ AOF persistence: Enabled
├─ Max memory: Configured per deployment
└─ Eviction policy: allkeys-lru
```

### MQTT Broker (core-mqtt)
```
Container: core-mqtt
Network: kompose
Internal Port: 1883 (MQTT), 9001 (WebSocket)
External: 1883 exposed for IoT devices

Event Topics:
├─ kompose/linkwarden/#
│  ├─ bookmark/added
│  ├─ bookmark/updated
│  └─ stats/daily
├─ kompose/news/#
│  ├─ article/published
│  └─ newsletter/sent
├─ kompose/analytics/#
│  ├─ pageview
│  └─ event
├─ kompose/vault/#
│  └─ security/*
└─ kompose/system/#
   ├─ health/check
   └─ backup/completed

Subscribers:
├─ Automation scripts
├─ Real-time dashboards
├─ Alert processors
└─ Analytics aggregators

Monitoring:
└─ MQTT Exporter (watch_mqtt_exporter:9000)
   └─ Prometheus scrapes broker stats
   └─ Grafana shows message flow
```

### Keycloak + OAuth2 Proxy (auth)
```
Keycloak:
├─ Container: auth_keycloak
├─ Network: kompose
├─ Port: 8080
├─ Database: PostgreSQL (keycloak)
└─ Realm: kompose

OAuth2 Proxy:
├─ Container: auth_oauth2_proxy
├─ Network: kompose
├─ Port: 4180
├─ Session Store: Redis (core-redis)
└─ OIDC Provider: Keycloak

Protected Services:
├─ Linkwarden (SSO required)
├─ Letterpress (SSO required)
├─ Umami (SSO for admin)
├─ Vaultwarden (Dual auth: SSO + master password)
├─ Grafana (SSO optional)
└─ KMPS (SSO required)

Authentication Flow:
User Request
   ↓
Traefik (sso-secure middleware)
   ↓
OAuth2 Proxy (checks session in Redis)
   ↓ (if not authenticated)
Keycloak (OIDC login)
   ↓ (credentials verified)
OAuth2 Proxy (creates session)
   ↓
Service (with user headers)
```

### Traefik (proxy)
```
Container: proxy_app
Network: kompose
Ports: 80 (HTTP), 443 (HTTPS), 8080 (Dashboard)

Features:
├─ Let's Encrypt SSL/TLS (automatic)
├─ HTTP → HTTPS redirect (global)
├─ Docker service discovery (labels)
├─ Dynamic configuration (file provider)
└─ Access logs + metrics

Middlewares:
├─ sso-secure
│  ├─ kompose-sso (OAuth2 forward auth)
│  ├─ security-headers (HSTS, CSP, etc.)
│  └─ compression (gzip)
├─ sso-secure-limited
│  ├─ sso-secure (chain)
│  └─ rate-limit (10 req/s)
└─ sso-internal-only
   ├─ sso-secure (chain)
   └─ ip-whitelist (internal IPs)

Certificate Management:
├─ Storage: /letsencrypt/acme.json
├─ Resolver: Let's Encrypt
├─ Auto-renewal: Yes
└─ Wildcard: *.pivoine.art (if configured)

Service Discovery:
All containers with labels:
  traefik.enable=true
  traefik.http.routers.<service>.rule=Host(`<host>`)
  traefik.http.routers.<service>.entrypoints=web-secure
  traefik.http.routers.<service>.tls.certresolver=resolver
```

### Mailhog + Gotify (messaging)
```
Mailhog:
├─ Container: messaging_mailhog
├─ Network: kompose
├─ SMTP Port: 1025 (internal)
├─ Web UI: 8025
└─ Purpose: Email testing & relay

Gotify:
├─ Container: messaging_gotify
├─ Network: kompose
├─ Port: 80
└─ Purpose: Push notifications

Email Flow:
Service sends email → Mailhog (SMTP) → External SMTP (optional)
                    ↓
              Web UI for testing

Notification Flow:
Prometheus Alert
   ↓
Alertmanager
   ↓
Gotify Webhook
   ↓
Push Notification to devices

Connected Services:
├─ Linkwarden → Email sharing
├─ Letterpress → Newsletters
├─ Vaultwarden → Password resets
├─ Gotify → System admin
└─ Alertmanager → Alert delivery
```

---

## 🛠️ Level 1: Utility Services Connections

### Linkwarden (link)
```
Container: link_app
Network: kompose
Port: 3000

Connections:
├─ PostgreSQL (core-postgres:5432)
│  └─ Database: linkwarden
├─ Redis (core-redis:6379)
│  ├─ Cache: Bookmarks, collections
│  └─ Session: User sessions
├─ MQTT (core-mqtt:1883)
│  └─ Publish: bookmark events
├─ Mailhog (messaging_mailhog:1025)
│  └─ Email: Sharing, notifications
└─ Traefik
   ├─ Host: links.pivoine.art
   └─ Middleware: sso-secure

Metrics Sidecar: link_metrics
├─ Port: 9100
├─ Prometheus: Scrapes metrics
└─ Grafana: Linkwarden dashboard

Data Flow:
User adds bookmark
   ↓
Linkwarden saves to PostgreSQL
   ↓
Cache in Redis
   ↓
Publish MQTT event (bookmark/added)
   ↓
Prometheus records metric
   ↓
Grafana dashboard updates
```

### Letterpress (news)
```
Container: news_backend
Network: kompose
Port: 5000

Connections:
├─ PostgreSQL (core-postgres:5432)
│  └─ Database: letterspace
├─ Redis (core-redis:6379)
│  ├─ Cache: Articles, templates
│  └─ Session: Editor sessions
├─ MQTT (core-mqtt:1883)
│  └─ Publish: article, newsletter events
├─ Mailhog (messaging_mailhog:1025)
│  └─ Email: Newsletter campaigns
└─ Traefik
   ├─ Host: news.pivoine.art
   └─ Middleware: sso-secure

Metrics Endpoint: /metrics (port 9090)

Publishing Flow:
Editor publishes article
   ↓
Letterpress saves to PostgreSQL
   ↓
Generate preview, cache in Redis
   ↓
Publish MQTT event (article/published)
   ↓
Trigger email campaign (if scheduled)
   ↓
Track in Umami (if integrated)
```

### Umami (track)
```
Container: track_app
Network: kompose
Port: 3000

Connections:
├─ PostgreSQL (core-postgres:5432)
│  └─ Database: umami
├─ Redis (core-redis:6379)
│  └─ Cache: Analytics queries
├─ MQTT (core-mqtt:1883)
│  └─ Publish: analytics events
└─ Traefik
   ├─ Host: analytics.pivoine.art
   └─ Middleware: sso-secure (admin) + CORS (tracking)

Metrics Endpoint: /api/metrics

Tracking Flow:
Page view on tracked site
   ↓
Umami tracking script
   ↓
POST to /api/collect
   ↓
Store in PostgreSQL
   ↓
Cache aggregates in Redis
   ↓
Publish MQTT event (pageview)
   ↓
Real-time dashboard via WebSocket

Integration Points:
├─ Linkwarden: Track bookmark clicks
├─ Letterpress: Track article views
└─ Custom sites: Add tracking code
```

### Vaultwarden (vault)
```
Container: vault_app
Network: kompose
Port: 80

Connections:
├─ PostgreSQL (optional migration from SQLite)
│  └─ Database: vaultwarden
├─ MQTT (core-mqtt:1883)
│  └─ Publish: security events
├─ Mailhog (messaging_mailhog:1025)
│  └─ Email: Password resets, 2FA
└─ Traefik
   ├─ Host: vault.pivoine.art
   └─ Middleware: sso-secure + rate-limit

Dual Authentication:
1. SSO Layer (Keycloak) → Access control
2. Master Password → Vault unlock

Security Event Flow:
User login attempt
   ↓
Vaultwarden checks credentials
   ↓
If success: Log to PostgreSQL + MQTT event
   ↓
If failure: Increment counter, log, MQTT event
   ↓
If threshold exceeded: Alert to Gotify
   ↓
Prometheus records security metrics
```

### Watch Stack (watch)
```
Multiple Containers:
├─ watch_prometheus (Port: 9090)
├─ watch_grafana (Port: 3000)
├─ watch_otel (Port: 4317, 4318)
├─ watch_alertmanager (Port: 9093)
├─ watch_postgres_exporter (Port: 9187)
├─ watch_redis_exporter (Port: 9121)
├─ watch_mqtt_exporter (Port: 9000)
├─ watch_cadvisor (Port: 8080)
├─ watch_node_exporter (Port: 9100)
└─ watch_blackbox_exporter (Port: 9115)

Prometheus Scrape Targets:
├─ Self (localhost:9090)
├─ PostgreSQL Exporter → core-postgres metrics
├─ Redis Exporter → core-redis metrics
├─ MQTT Exporter → core-mqtt metrics
├─ cAdvisor → Container metrics
├─ Node Exporter → Host system metrics
├─ Linkwarden Metrics → link_metrics:9100
├─ Letterpress → news_backend:9090
├─ Umami → track_app:3000/api/metrics
├─ Vaultwarden → vault_app:80/metrics
└─ Blackbox → Endpoint health checks

Grafana Data Sources:
├─ Prometheus (primary)
└─ PostgreSQL (dashboard configs)

Alertmanager Flow:
Prometheus evaluates rules
   ↓
Alert fires (threshold met)
   ↓
Alertmanager receives alert
   ↓
Routes based on severity/category
   ↓
Sends to Gotify webhook
   ↓
Push notification delivered
   ↓
Email backup (for critical)

Dashboard Access:
├─ Prometheus: prometheus.pivoine.art
├─ Grafana: grafana.pivoine.art
└─ Alertmanager: alerts.pivoine.art
```

---

## 🔗 Cross-Service Integration Examples

### Example 1: New Bookmark → Analytics
```
User saves bookmark in Linkwarden
   ↓
link_app saves to PostgreSQL (core-postgres)
   ↓
link_app caches in Redis (core-redis)
   ↓
link_app publishes MQTT event:
   Topic: kompose/linkwarden/bookmark/added
   Payload: {id, url, title, tags, collection}
   ↓
Automation script subscribes to MQTT
   ↓
Posts event to Umami:
   POST /api/collect
   {event: 'bookmark_added', properties: {collection, tags}}
   ↓
track_app stores in PostgreSQL
   ↓
Grafana shows correlation dashboard
```

### Example 2: Published Article → Bookmark + Analytics
```
Editor publishes article in Letterpress
   ↓
news_backend saves to PostgreSQL
   ↓
news_backend publishes MQTT event:
   Topic: kompose/news/article/published
   Payload: {id, title, url, category, tags}
   ↓
Automation creates bookmark in Linkwarden:
   API POST /api/bookmarks
   {url: article.url, collection: 'Published', tags: article.tags}
   ↓
Linkwarden MQTT event triggers
   ↓
Umami tracks both events
   ↓
Grafana "Content Pipeline" dashboard shows flow
```

### Example 3: Security Event → Alert → Notification
```
Failed login attempt in Vaultwarden
   ↓
vault_app logs to database
   ↓
vault_app publishes MQTT event:
   Topic: kompose/vault/security/failed
   Payload: {email, ip, attempts, locked}
   ↓
vault_app exposes metric: failed_logins_total
   ↓
Prometheus scrapes metric
   ↓
Alert rule triggers (>10 failures in 5 min)
   ↓
Alertmanager receives alert
   ↓
Routes to 'gotify-security' receiver
   ↓
Webhook POST to Gotify
   ↓
Push notification: "Security Alert: Multiple failed logins"
   ↓
Email backup sent via Mailhog
```

### Example 4: System Health Monitoring
```
Every 30 seconds:
├─ Prometheus scrapes all exporters
├─ PostgreSQL Exporter: DB stats
├─ Redis Exporter: Cache stats
├─ MQTT Exporter: Message stats
├─ cAdvisor: Container stats
├─ Node Exporter: System stats
└─ Blackbox: Endpoint health

Metrics stored in Prometheus TSDB (30-day retention)
   ↓
Grafana queries Prometheus every 30s
   ↓
System Overview dashboard auto-refreshes
   ↓
If threshold exceeded:
   ├─ Alert fires in Prometheus
   ├─ Alertmanager processes
   ├─ Gotify notifies admin
   └─ Dashboard highlights issue
```

---

## 🔒 Security Layers

### Layer 1: Network Isolation
```
All services in kompose bridge network
Only Traefik exposes ports 80/443
Internal services communicate via container names
```

### Layer 2: SSL/TLS
```
Traefik handles all SSL/TLS
Let's Encrypt automatic certificates
Internal HTTP communication (within Docker network)
```

### Layer 3: Authentication
```
Keycloak centralized identity
OAuth2 Proxy forward auth
Service-specific credentials (master passwords, API keys)
```

### Layer 4: Authorization
```
Keycloak roles and groups
Service-level permissions
IP restrictions (for admin interfaces)
Rate limiting (for public endpoints)
```

### Layer 5: Monitoring
```
All access logged
Failed attempts tracked
Security events via MQTT
Alerts on suspicious activity
```

---

## 📊 Data Flow Summary

### User Request Flow
```
User Browser
   ↓ HTTPS
Traefik (SSL termination)
   ↓ Forward Auth Middleware
OAuth2 Proxy (check Redis session)
   ↓ (if not authenticated)
Keycloak (login)
   ↓ (session created in Redis)
OAuth2 Proxy (set cookie, inject headers)
   ↓ HTTP
Service Container (with X-Auth-Request-* headers)
   ↓ (if needed)
PostgreSQL (data storage)
Redis (caching)
   ↓
Response to User
```

### Event Flow
```
Service Action (bookmark, article, login, etc.)
   ↓
Store in PostgreSQL
   ↓
Cache in Redis (if applicable)
   ↓
Publish MQTT Event
   ↓ (subscribers)
├─ Automation Scripts
├─ Analytics Tracking
├─ Alert Processors
└─ Dashboard Updates
   ↓
Metrics Exported
   ↓
Prometheus Scrapes
   ↓
Grafana Displays
   ↓
Alerts Evaluated
   ↓ (if threshold met)
Alertmanager Routes
   ↓
Gotify Notifies
```

---

## 🗺️ Network Map

```
INTERNET (*.pivoine.art)
        │
        ↓ :80/:443
    ┌───────┐
    │Traefik│ (proxy_app)
    └───┬───┘
        │ kompose network
        ├─────────────────────────────────────────┐
        │                                         │
    ┌───▼────┐  ┌──────┐  ┌─────┐  ┌─────┐     │
    │Keycloak│  │Redis │  │MQTT │  │PG   │     │
    │OAuth2  │  │Cache │  │Broker│ │SQL  │     │
    └───┬────┘  └──┬───┘  └──┬──┘  └──┬──┘     │
        │          │         │        │         │
        │  ┌───────┴─────────┴────────┴─────┐   │
        │  │                                │   │
        ↓  ↓                                ↓   ↓
    ┌────────┐  ┌──────┐  ┌─────┐  ┌─────────┐
    │Linkwrd │  │Letter│  │Umami│  │Vaultwrdn│
    │+metrics│  │press │  │     │  │+monitor │
    └────┬───┘  └───┬──┘  └──┬──┘  └────┬────┘
         │          │        │           │
         └──────────┴────────┴───────────┘
                    │
                    ↓ metrics
            ┌───────────────┐
            │  Prometheus   │
            │   Grafana     │
            │ Alertmanager  │
            │   Exporters   │
            └───────────────┘
                    │
                    ↓ alerts
            ┌───────────────┐
            │    Gotify     │
            │   Mailhog     │
            └───────────────┘
```

---

**Last Updated**: October 2025  
**Status**: Production Ready  
**Network**: kompose (172.18.0.0/16)  
**Services**: 20+ containers fully integrated
