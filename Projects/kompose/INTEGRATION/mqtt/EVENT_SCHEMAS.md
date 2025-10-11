# =================================================================
# MQTT Event Schemas and Topic Structure
# Kompose Service Integration
# =================================================================

## Overview

All services in the Kompose stack can publish and subscribe to MQTT events for real-time
cross-service communication and automation.

## Topic Structure

```
kompose/
├── linkwarden/
│   ├── bookmark/added        # New bookmark created
│   ├── bookmark/updated      # Bookmark modified
│   ├── bookmark/deleted      # Bookmark removed
│   ├── collection/created    # New collection
│   └── stats/daily           # Daily statistics
├── news/
│   ├── article/published     # New article published
│   ├── article/updated       # Article modified
│   ├── newsletter/sent       # Newsletter sent
│   └── campaign/completed    # Email campaign finished
├── analytics/
│   ├── pageview              # Page view event
│   ├── event                 # Custom event
│   ├── session/started       # New session
│   └── stats/realtime        # Real-time statistics
├── vault/
│   ├── security/login        # User login event
│   ├── security/failed       # Failed login attempt
│   ├── security/unlock       # Vault unlocked
│   └── security/item_accessed # Item accessed
├── system/
│   ├── health/check          # System health status
│   ├── backup/completed      # Backup finished
│   ├── update/available      # Update notification
│   └── alert/triggered       # Alert fired
└── automation/
    ├── trigger/#             # Automation triggers
    └── action/#              # Automation actions
```

## Event Schemas

### Linkwarden Events

#### Bookmark Added
**Topic**: `kompose/linkwarden/bookmark/added`

```json
{
  "event_id": "uuid-v4",
  "timestamp": "2025-10-12T10:30:00Z",
  "service": "linkwarden",
  "event_type": "bookmark.added",
  "data": {
    "bookmark_id": 12345,
    "url": "https://example.com",
    "title": "Example Website",
    "description": "A sample bookmark",
    "tags": ["web", "example", "tutorial"],
    "collection": "Tech Resources",
    "user_email": "user@domain.com",
    "is_public": false
  }
}
```

#### Bookmark Updated
**Topic**: `kompose/linkwarden/bookmark/updated`

```json
{
  "event_id": "uuid-v4",
  "timestamp": "2025-10-12T10:30:00Z",
  "service": "linkwarden",
  "event_type": "bookmark.updated",
  "data": {
    "bookmark_id": 12345,
    "url": "https://example.com",
    "changes": ["title", "tags"],
    "user_email": "user@domain.com"
  }
}
```

#### Daily Statistics
**Topic**: `kompose/linkwarden/stats/daily`

```json
{
  "event_id": "uuid-v4",
  "timestamp": "2025-10-12T23:59:59Z",
  "service": "linkwarden",
  "event_type": "stats.daily",
  "data": {
    "date": "2025-10-12",
    "bookmarks_added": 15,
    "bookmarks_deleted": 2,
    "total_bookmarks": 1543,
    "active_users": 8,
    "top_tags": ["javascript", "devops", "ai"]
  }
}
```

---

### News/Letterpress Events

#### Article Published
**Topic**: `kompose/news/article/published`

```json
{
  "event_id": "uuid-v4",
  "timestamp": "2025-10-12T10:30:00Z",
  "service": "letterpress",
  "event_type": "article.published",
  "data": {
    "article_id": 789,
    "title": "Latest Tech News",
    "slug": "latest-tech-news",
    "author": "editor@domain.com",
    "category": "Technology",
    "tags": ["tech", "news", "ai"],
    "published_url": "https://news.domain.com/latest-tech-news",
    "excerpt": "Brief summary of the article...",
    "word_count": 1200
  }
}
```

#### Newsletter Sent
**Topic**: `kompose/news/newsletter/sent`

```json
{
  "event_id": "uuid-v4",
  "timestamp": "2025-10-12T10:30:00Z",
  "service": "letterpress",
  "event_type": "newsletter.sent",
  "data": {
    "campaign_id": 456,
    "campaign_name": "Weekly Newsletter #42",
    "recipients_count": 1523,
    "articles_included": [789, 790, 791],
    "sent_at": "2025-10-12T10:00:00Z"
  }
}
```

---

### Analytics/Umami Events

#### Pageview Event
**Topic**: `kompose/analytics/pageview`

```json
{
  "event_id": "uuid-v4",
  "timestamp": "2025-10-12T10:30:00Z",
  "service": "umami",
  "event_type": "pageview",
  "data": {
    "website_id": "abc123",
    "url": "/blog/latest-post",
    "referrer": "https://google.com",
    "user_agent": "Mozilla/5.0...",
    "screen_resolution": "1920x1080",
    "language": "en-US",
    "country": "US",
    "device_type": "desktop"
  }
}
```

#### Custom Event
**Topic**: `kompose/analytics/event`

```json
{
  "event_id": "uuid-v4",
  "timestamp": "2025-10-12T10:30:00Z",
  "service": "umami",
  "event_type": "custom_event",
  "data": {
    "website_id": "abc123",
    "event_name": "newsletter_signup",
    "event_data": {
      "source": "homepage",
      "campaign": "fall2025"
    },
    "url": "/newsletter/subscribe"
  }
}
```

#### Real-time Statistics
**Topic**: `kompose/analytics/stats/realtime`

```json
{
  "event_id": "uuid-v4",
  "timestamp": "2025-10-12T10:30:00Z",
  "service": "umami",
  "event_type": "stats.realtime",
  "data": {
    "current_visitors": 42,
    "pageviews_last_minute": 23,
    "top_pages": [
      {"url": "/blog", "visitors": 15},
      {"url": "/about", "visitors": 8}
    ]
  }
}
```

---

### Vaultwarden Security Events

#### Login Event
**Topic**: `kompose/vault/security/login`

```json
{
  "event_id": "uuid-v4",
  "timestamp": "2025-10-12T10:30:00Z",
  "service": "vaultwarden",
  "event_type": "security.login",
  "data": {
    "user_email": "user@domain.com",
    "ip_address": "192.168.1.100",
    "device_type": "Browser",
    "device_name": "Firefox on Linux",
    "two_factor_enabled": true,
    "location": {
      "country": "DE",
      "city": "Karlsruhe"
    }
  }
}
```

#### Failed Login
**Topic**: `kompose/vault/security/failed`

```json
{
  "event_id": "uuid-v4",
  "timestamp": "2025-10-12T10:30:00Z",
  "service": "vaultwarden",
  "event_type": "security.failed_login",
  "data": {
    "email_attempted": "user@domain.com",
    "ip_address": "192.168.1.100",
    "reason": "invalid_password",
    "attempts_count": 3,
    "account_locked": false
  }
}
```

#### Vault Unlocked
**Topic**: `kompose/vault/security/unlock`

```json
{
  "event_id": "uuid-v4",
  "timestamp": "2025-10-12T10:30:00Z",
  "service": "vaultwarden",
  "event_type": "security.vault_unlock",
  "data": {
    "user_email": "user@domain.com",
    "device_name": "Firefox on Linux",
    "session_id": "session-uuid"
  }
}
```

---

### System Events

#### Health Check
**Topic**: `kompose/system/health/check`

```json
{
  "event_id": "uuid-v4",
  "timestamp": "2025-10-12T10:30:00Z",
  "service": "system",
  "event_type": "health.check",
  "data": {
    "services": {
      "postgresql": {"status": "healthy", "response_time_ms": 2},
      "redis": {"status": "healthy", "response_time_ms": 1},
      "mqtt": {"status": "healthy", "connected_clients": 15},
      "linkwarden": {"status": "healthy", "response_time_ms": 45},
      "umami": {"status": "healthy", "response_time_ms": 32}
    },
    "overall_status": "healthy"
  }
}
```

#### Backup Completed
**Topic**: `kompose/system/backup/completed`

```json
{
  "event_id": "uuid-v4",
  "timestamp": "2025-10-12T10:30:00Z",
  "service": "system",
  "event_type": "backup.completed",
  "data": {
    "backup_type": "postgresql",
    "database_name": "linkwarden",
    "backup_size_mb": 145,
    "duration_seconds": 23,
    "backup_file": "/backups/linkwarden_20251012.sql.gz",
    "success": true
  }
}
```

---

## QoS Levels

- **QoS 0** (At most once): Statistics, non-critical events
- **QoS 1** (At least once): Standard events, logging
- **QoS 2** (Exactly once): Security events, critical actions

## Retained Messages

The following topics use retained messages (last message is always available):
- `kompose/analytics/stats/realtime`
- `kompose/system/health/check`

## Integration Examples

### Example 1: New Bookmark → Analytics Tracking

```javascript
// Linkwarden publishes new bookmark
mqtt.publish('kompose/linkwarden/bookmark/added', bookmarkData);

// Umami subscribes and tracks event
mqtt.subscribe('kompose/linkwarden/bookmark/added', (message) => {
  trackEvent({
    name: 'bookmark_added',
    properties: {
      collection: message.data.collection,
      tags: message.data.tags
    }
  });
});
```

### Example 2: Published Article → Bookmark Creation

```javascript
// Letterpress publishes article
mqtt.publish('kompose/news/article/published', articleData);

// Automation creates bookmark in Linkwarden
mqtt.subscribe('kompose/news/article/published', (message) => {
  linkwardenAPI.createBookmark({
    url: message.data.published_url,
    title: message.data.title,
    collection: 'Published Articles',
    tags: message.data.tags
  });
});
```

### Example 3: Security Alert → Push Notification

```javascript
// Vaultwarden detects failed login
mqtt.publish('kompose/vault/security/failed', failedLoginData);

// Alert system triggers Gotify notification
mqtt.subscribe('kompose/vault/security/failed', (message) => {
  if (message.data.attempts_count > 3) {
    gotify.sendNotification({
      title: 'Security Alert',
      message: `Multiple failed login attempts for ${message.data.email_attempted}`,
      priority: 10
    });
  }
});
```

---

## Testing MQTT Events

### Publish Test Event
```bash
mosquitto_pub -h core-mqtt -t "kompose/test" -m '{"test": true}'
```

### Subscribe to All Events
```bash
mosquitto_sub -h core-mqtt -t "kompose/#" -v
```

### Monitor Specific Service
```bash
mosquitto_sub -h core-mqtt -t "kompose/linkwarden/#" -v
```

---

**Last Updated**: October 2025  
**Version**: 1.0.0
