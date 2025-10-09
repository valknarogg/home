---
title: Track - Privacy-First Analytics HQ
description: "We count visitors, not cookies!"
navigation:
  icon: i-lucide-bar-chart
---

> *"We count visitors, not cookies!"* - Umami Analytics

## What's This All About?

Umami is your self-hosted, privacy-focused alternative to Google Analytics! It's like having all the insights without selling your soul (or your visitors' data) to Big Tech. Track what matters, respect privacy, stay GDPR compliant, and sleep well at night knowing you're not contributing to the surveillance economy! :icon{name="lucide:search"}

## The Analytics Ace

### :icon{name="lucide:trending-up"} Umami

**Container**: `track_app`  
**Image**: `ghcr.io/umami-software/umami:postgresql-latest`  
**Port**: 3000  
**Home**: https://umami.pivoine.art

Umami is analytics done right:
- :icon{name="lucide:lock"} **Privacy-First**: No cookies, no tracking pixels, no creepy stuff
- :icon{name="lucide:euro"} **GDPR Compliant**: By design, not as an afterthought
- :icon{name="lucide:bar-chart"} **Beautiful Dashboards**: Real-time, clean, insightful
- :icon{name="lucide:globe"} **Multi-Site**: Track unlimited websites
- :icon{name="lucide:users"} **Team Features**: Invite team members
- :icon{name="lucide:phone"} **Events Tracking**: Custom events and goals
- :icon{name="lucide:palette"} **Simple Script**: Just one line of JavaScript
- :icon{name="lucide:smile"} **Open Source**: Free forever, your data, your server

## Features That Make Sense :icon{name="lucide:sparkles"}

### Core Metrics
- :icon{name="lucide:trending-up"} **Page Views**: Real-time visitor counts
- :icon{name="lucide:user"} **Unique Visitors**: Who's new, who's returning
- :icon{name="lucide:globe"} **Referrers**: Where traffic comes from
- :icon{name="lucide:phone"} **Devices**: Desktop vs Mobile vs Tablet
- :icon{name="lucide:globe"} **Countries**: Geographic distribution
- :icon{name="lucide:monitor"} **Browsers**: Chrome, Firefox, Safari, etc.
- :icon{name="lucide:laptop"} **Operating Systems**: Windows, Mac, Linux, etc.
- :icon{name="lucide:file"} **Pages**: Most popular content

### Advanced Features
- :icon{name="lucide:target"} **Custom Events**: Track buttons, forms, videos
- :icon{name="lucide:timer"} **Time on Site**: Engagement metrics
- :icon{name="lucide:bar-chart"} **Real-time Data**: Live visitor updates
- :icon{name="lucide:calendar"} **Date Ranges**: Custom time periods
- :icon{name="lucide:search"} **Filters**: Drill down into data
- :icon{name="lucide:upload"} **Export Data**: CSV downloads
- :icon{name="lucide:link"} **Share Links**: Public dashboard links
- :icon{name="lucide:palette"} **Themes**: Light/Dark mode

## Configuration Breakdown

### Database Connection
```bash
DATABASE_URL=postgresql://user:password@postgres:5432/umami
DATABASE_TYPE=postgresql
```

Stores all analytics data in PostgreSQL - reliable, scalable, queryable!

### App Secret
```bash
APP_SECRET=your-random-secret-here
```
Used for hashing and security. Generate with:
```bash
openssl rand -hex 32
```

### Health Check
Every 30 seconds, Umami pings itself:
```bash
curl -f http://localhost:3000/api/heartbeat
```

## First Time Setup :icon{name="lucide:rocket"}

### 1. Create Database
```bash
docker exec data_postgres createdb -U your_db_user umami
```

### 2. Start the Stack
```bash
docker compose up -d
```

### 3. First Login
```
URL: https://umami.pivoine.art
Username: admin
Password: umami
```

**:icon{name="lucide:siren"} IMMEDIATELY CHANGE THE PASSWORD!**
1. Click on username → Profile
2. Change password
3. Breathe easy

### 4. Add Your First Website

1. **Settings → Websites → Add Website**
2. **Name**: "My Awesome Blog"
3. **Domain**: "myblog.com"
4. **Enable Share URL**: Optional
5. **Save**

### 5. Get Your Tracking Code

After adding website, click "Edit" → "Tracking Code":
```html
<script async defer 
  data-website-id="your-unique-id"
  src="https://umami.pivoine.art/script.js">
</script>
```

### 6. Add to Your Website

Place in `<head>` section:
```html
<!DOCTYPE html>
<html>
<head>
  <title>My Site</title>
  <!-- Umami Analytics -->
  <script async defer 
    data-website-id="abc123..."
    src="https://umami.pivoine.art/script.js">
  </script>
</head>
<body>
  <!-- content -->
</body>
</html>
```

## Tracking Events :icon{name="lucide:target"}

### Automatic Tracking
Page views are tracked automatically. That's it! :icon{name="lucide:party-popper"}

### Custom Events

**Track Button Clicks**:
```html
<button class="umami--click--signup-button">
  Sign Up
</button>
```

**Track Form Submissions**:
```html
<form class="umami--click--contact-form">
  <!-- form fields -->
</form>
```

**Using JavaScript**:
```javascript
// Track custom event
umami.track('Newsletter Signup', {
  email: 'user@example.com',
  source: 'homepage'
});

// Track with properties
umami.track(props => ({
  ...props,
  category: 'ecommerce',
  action: 'purchase',
  value: 99.99
}));
```

### Event Examples

**E-commerce**:
```javascript
// Product view
umami.track('Product View', { 
  product_id: '123',
  product_name: 'Cool Widget'
});

// Add to cart
umami.track('Add to Cart', {
  product_id: '123',
  quantity: 1
});

// Purchase
umami.track('Purchase', {
  order_id: 'ORDER-123',
  total: 99.99
});
```

**Content Engagement**:
```javascript
// Video play
umami.track('Video Play', {
  video_id: 'intro-video',
  duration: 120
});

// Download
umami.track('File Download', {
  filename: 'guide.pdf'
});
```

**User Actions**:
```javascript
// Search
umami.track('Search', {
  query: 'best practices'
});

// Share
umami.track('Social Share', {
  platform: 'twitter',
  url: window.location.href
});
```

## Dashboard Features :icon{name="lucide:bar-chart"}

### Overview
- :icon{name="lucide:eye"} Real-time visitor count
- :icon{name="lucide:trending-up"} Views & visitors today
- :icon{name="lucide:clock"} Average time on site
- :icon{name="lucide:refresh-cw"} Bounce rate

### Realtime View
Watch visitors as they browse:
- Current pages being viewed
- Referrer sources
- Countries
- Live count

### Reports
- :icon{name="lucide:calendar"} Custom date ranges
- :icon{name="lucide:bar-chart"} Page comparisons
- :icon{name="lucide:globe"} Geographic heatmaps
- :icon{name="lucide:phone"} Device breakdowns
- :icon{name="lucide:search"} Referrer analysis

### Filters
Drill down with:
- Date range
- Country
- Device type
- Browser
- OS
- URL path

## Multi-Website Management :icon{name="lucide:globe"}

### Add Multiple Sites
```
Settings → Websites → Add Website
```

Track unlimited sites from one Umami instance!

### Team Access
```
Settings → Teams → Add Team Member
```

Invite colleagues with different permission levels:
- **Owner**: Full access
- **User**: View only
- **View Only**: Stats but no config changes

### Shared Reports
Generate public dashboard links:
```
Website → Share → Enable & Copy URL
```

Anyone with the link can view stats (no login needed)!

## Privacy Features :icon{name="lucide:lock"}

### What Umami Does NOT Track
- :icon{name="lucide:x"} Personal information
- :icon{name="lucide:x"} Cookies (beyond session)
- :icon{name="lucide:x"} IP addresses (optional hashing)
- :icon{name="lucide:x"} Cross-site tracking
- :icon{name="lucide:x"} Fingerprinting

### What Umami DOES Track
- :icon{name="lucide:check"} Page views (anonymized)
- :icon{name="lucide:check"} Referrers
- :icon{name="lucide:check"} Device types (generic)
- :icon{name="lucide:check"} Countries (city-level optional)
- :icon{name="lucide:check"} Custom events

### GDPR Compliance
Umami is GDPR-compliant by default:
- No consent banner needed (in most cases)
- Data stored on YOUR server
- Easy data export/deletion
- No third-party data sharing
- Anonymous by design

## Ports & Networking

- **Internal Port**: 3000
- **External Access**: Via Traefik at https://umami.pivoine.art
- **Network**: `kompose` (database access)
- **Database**: PostgreSQL (from data stack)

## API Access :icon{name="lucide:plug"}

Umami has a REST API for programmatic access!

### Authentication
```bash
curl -X POST https://umami.pivoine.art/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"your-password"}'
```

Returns JWT token for API requests.

### Get Website Stats
```bash
curl https://umami.pivoine.art/api/websites/YOUR-WEBSITE-ID/stats \
  -H "Authorization: Bearer YOUR-JWT-TOKEN" \
  -d "startAt=1609459200000&endAt=1612137600000"
```

### Track Event via API
```bash
curl -X POST https://umami.pivoine.art/api/send \
  -H "Content-Type: application/json" \
  -d '{
    "payload": {
      "website": "your-website-id",
      "url": "/page",
      "event_name": "custom-event"
    },
    "type": "event"
  }'
```

## Performance & Scaling :icon{name="lucide:trending-up"}

### For Small Sites (<10k/month)
Default setup works great! No optimization needed.

### For Medium Sites (10k-100k/month)
- :icon{name="lucide:check"} Enable database indexes (auto-created)
- :icon{name="lucide:check"} Regular database maintenance
- :icon{name="lucide:check"} Monitor disk space

### For Large Sites (100k+/month)
- :icon{name="lucide:rocket"} Increase PostgreSQL memory
- :icon{name="lucide:rocket"} Add read replicas
- :icon{name="lucide:rocket"} Consider CDN for script.js
- :icon{name="lucide:rocket"} Enable database connection pooling

### Optimization Tips
```sql
-- Regular vacuum (PostgreSQL)
VACUUM ANALYZE;

-- Check index usage
SELECT * FROM pg_stat_user_indexes;
```

## Data Management :icon{name="lucide:database"}

### Export Data
```
Settings → Export → Select Date Range → Download CSV
```

### Database Backups
```bash
# Backup Umami database
docker exec data_postgres pg_dump -U your_db_user umami > umami-backup.sql

# Restore if needed
docker exec -i data_postgres psql -U your_db_user umami < umami-backup.sql
```

### Data Retention
Configure automatic cleanup:
```sql
-- Delete data older than 1 year
DELETE FROM event 
WHERE created_at < NOW() - INTERVAL '1 year';
```

## Troubleshooting :icon{name="lucide:wrench"}

**Q: Script not loading?**  
A: Check browser console for errors, verify script URL is correct

**Q: No data showing up?**  
A: Verify tracking code is on page, check browser ad blockers

**Q: "Website not found" error?**  
A: Check website ID matches, ensure website is active

**Q: Slow dashboard?**  
A: Reduce date range, check database performance, add indexes

**Q: Can't log in?**  
A: Reset password via database or recreate user

## Integration Examples

### Hugo (Static Site Generator)
```html
<!-- layouts/partials/umami.html -->
{{ if not .Site.IsServer }}
<script async defer 
  data-website-id="{{ .Site.Params.umamiId }}"
  src="{{ .Site.Params.umamiUrl }}/script.js">
</script>
{{ end }}
```

### Next.js
```javascript
// components/Analytics.js
import Script from 'next/script'

export default function Analytics() {
  return (
    <Script
      async
      defer
      data-website-id={process.env.NEXT_PUBLIC_UMAMI_ID}
      src="https://umami.pivoine.art/script.js"
    />
  )
}
```

### WordPress
Install via plugin or add to theme's `header.php`:
```php
<?php if (!is_user_logged_in()) { ?>
<script async defer 
  data-website-id="your-id"
  src="https://umami.pivoine.art/script.js">
</script>
<?php } ?>
```

## Umami vs. Google Analytics

| Feature | Umami | Google Analytics |
|---------|-------|------------------|
| Privacy | ✅ Excellent | ❌ Terrible |
| GDPR | ✅ Compliant | :icon{name="lucide:alert-triangle"} Complicated |
| Data Ownership | ✅ Yours | ❌ Google's |
| Cookie Banner | ✅ Not needed | ❌ Required |
| Speed | ✅ Fast | :icon{name="lucide:alert-triangle"} Slower |
| Setup | ✅ Simple | :icon{name="lucide:alert-triangle"} Complex |
| Cost | ✅ Free | ✅ Free (but...) |
| Learning Curve | ✅ Easy | ❌ Steep |

## Why Track with Umami? :icon{name="lucide:target"}

- :icon{name="lucide:lock"} **Privacy**: Respect your visitors
- :icon{name="lucide:bar-chart"} **Insights**: Get data that matters
- :icon{name="lucide:palette"} **Simple**: No complexity overload
- :icon{name="lucide:smile"} **Free**: No limits, no upsells
- :icon{name="lucide:rocket"} **Fast**: Lightweight script
- :icon{name="lucide:dumbbell"} **Reliable**: Self-hosted stability
- :icon{name="lucide:globe"} **Ethical**: Do the right thing

## Advanced Features

### Custom Domains
Point your own domain to Umami:
```
analytics.yourdomain.com → Traefik → Umami
```

### Visitor Segments
Filter by any combination:
- Country + Device
- Referrer + Browser
- Page + OS
- Custom event properties

### Goals & Funnels
Track conversion paths:
1. Landing page view
2. Feature page view
3. Signup form
4. Thank you page

## Resources

- [Umami Documentation](https://umami.is/docs)
- [API Reference](https://umami.is/docs/api)
- [GitHub Repository](https://github.com/umami-software/umami)
- [Community Forum](https://github.com/umami-software/umami/discussions)

---

*"The best analytics are the ones that respect privacy while still giving you the insights you need."* - Ethical Analytics Manifesto :icon{name="lucide:bar-chart"}:icon{name="lucide:sparkles"}
