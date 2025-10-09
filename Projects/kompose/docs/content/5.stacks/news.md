---
title: News - Self-Hosted Newsletter Empire
description: "Forget MailChimp, we're going full indie!"
navigation:
  icon: i-lucide-newspaper
---

> *"Forget MailChimp, we're going full indie!"* - Letterspace

## What's This All About?

This is Letterspace - open-source, privacy-focused newsletter platform! Think Substack meets indie-hacker meets "I actually own my subscriber list." Send beautiful newsletters, manage subscribers, track campaigns, and keep all your data under YOUR control!

## The Publishing Powerhouse

### :icon{name="lucide:mailbox"} Letterspace Backend

**Container**: `news_backend`  
**Image**: Custom build from the monorepo  
**Port**: 5000  
**Technology**: Node.js + Express + Prisma + PostgreSQL

The brains of the operation:
- :icon{name="lucide:file-text"} **Email Campaigns**: Create and send newsletters
- :icon{name="lucide:users"} **Subscriber Management**: Import, export, segment
- :icon{name="lucide:bar-chart"} **Analytics**: Track opens, clicks, and engagement
- :icon{name="lucide:palette"} **Templates**: Reusable email templates
- :icon{name="lucide:mail"} **SMTP Integration**: Works with any email provider
- :icon{name="lucide:lock-keyhole"} **Double Opt-in**: Legal compliance built-in
- :icon{name="lucide:database"} **Database-Driven**: PostgreSQL for reliability
- :icon{name="lucide:rocket"} **Cron Jobs**: Automated sending and maintenance

### The Stack Structure

This is a monorepo with multiple applications:
```
news/
├── apps/
│   ├── backend/       ← The API (what this stack runs)
│   ├── web/          ← Admin dashboard (React + Vite)
│   ├── docs/         ← Documentation (Next.js)
│   └── landing-page/ ← Marketing site (Next.js)
├── packages/
│   ├── ui/           ← Shared UI components
│   └── shared/       ← Shared utilities
```

## Features That Make You Look Pro :icon{name="lucide:sparkles"}

### Campaign Management
- :icon{name="lucide:mail"} Create beautiful emails with templates
- 📅 Schedule sends for later
- :icon{name="lucide:target"} Segment subscribers by tags/lists
- :icon{name="lucide:file-text"} Preview before sending
- :icon{name="lucide:refresh-cw"} A/B testing (coming soon™)

### Subscriber Management
- 📥 Import via CSV
- ✅ Double opt-in confirmation
- :icon{name="lucide:tag"} Tag and categorize
- :icon{name="lucide:bar-chart"} View engagement history
- :icon{name="lucide:ban"} Easy unsubscribe management

### Analytics Dashboard
- :icon{name="lucide:trending-up"} Open rates
- 👆 Click-through rates
- 📉 Unsubscribe rates
- :icon{name="lucide:bar-chart"} Subscriber growth over time
- :icon{name="lucide:target"} Campaign performance

### Email Features
- :icon{name="lucide:palette"} Custom HTML templates
- :icon{name="lucide:phone"} Mobile-responsive designs
- 🖼️ Image support
- :icon{name="lucide:link"} Link tracking
- :icon{name="lucide:user"} Personalization ({{name}}, etc.)

## Configuration Breakdown

### Database
```
Database: letterspace
Host: Shared PostgreSQL from data stack
Migrations: Handled by Prisma
```

### SMTP Settings
Configure in root `.env`:
```bash
EMAIL_FROM=newsletter@yourdomain.com
EMAIL_SMTP_HOST=smtp.yourprovider.com
EMAIL_SMTP_PORT=587
EMAIL_SMTP_USER=your_username
EMAIL_SMTP_PASSWORD=your_password
```

**Compatible with**:
- SendGrid
- Mailgun
- AWS SES
- Postmark
- Any SMTP server!

### JWT Secret
Used for authentication tokens:
```bash
JWT_SECRET=your-super-secret-key-here
```
Generate with: `openssl rand -hex 32`

## First Time Setup :icon{name="lucide:rocket"}

1. **Ensure database exists**:
   ```bash
   docker exec data_postgres createdb -U your_db_user letterspace
   ```

2. **Run migrations** (automatically on container start):
   ```bash
   # This happens automatically via entrypoint.sh
   npx prisma migrate deploy
   ```

3. **Start the stack**:
   ```bash
   docker compose up -d
   ```

4. **Access the API**:
   ```
   URL: https://news.pivoine.art
   Health Check: https://news.pivoine.art/api/v1/health
   ```

5. **Create admin user** (via API or database):
   ```bash
   # Access backend container
   docker exec -it news_backend sh
   npx prisma studio  # Opens DB GUI
   ```

## Cron Jobs (Automated Tasks)

The backend runs several automated jobs:

### Daily Maintenance (4 AM)
- Clean up old tracking data
- Archive old campaigns
- Update statistics

### Campaign Queue Processor
- Checks for scheduled campaigns
- Sends queued emails
- Handles rate limiting

### Message Sending
- Processes outgoing emails
- Tracks delivery status
- Handles bounces

## API Endpoints

### Subscribers
- `POST /api/v1/subscribers` - Add subscriber
- `GET /api/v1/subscribers` - List all
- `PUT /api/v1/subscribers/:id` - Update
- `DELETE /api/v1/subscribers/:id` - Remove

### Campaigns
- `POST /api/v1/campaigns` - Create campaign
- `GET /api/v1/campaigns` - List campaigns
- `POST /api/v1/campaigns/:id/send` - Send now
- `GET /api/v1/campaigns/:id/stats` - View analytics

### Lists
- `POST /api/v1/lists` - Create list
- `GET /api/v1/lists` - View all lists
- `POST /api/v1/lists/:id/subscribers` - Add to list

## Sending Your First Newsletter :icon{name="lucide:mailbox"}

1. **Create a list**:
   ```bash
   curl -X POST https://news.pivoine.art/api/v1/lists \
     -H "Authorization: Bearer $TOKEN" \
     -d '{"name": "Weekly Updates"}'
   ```

2. **Add subscribers**:
   ```bash
   curl -X POST https://news.pivoine.art/api/v1/subscribers \
     -H "Authorization: Bearer $TOKEN" \
     -d '{"email": "fan@example.com", "name": "Happy Reader"}'
   ```

3. **Create campaign**:
   ```bash
   curl -X POST https://news.pivoine.art/api/v1/campaigns \
     -H "Authorization: Bearer $TOKEN" \
     -d '{
       "subject": "Hello World!",
       "content": "<h1>My First Newsletter</h1><p>Thanks for subscribing!</p>",
       "listId": 1
     }'
   ```

4. **Send it**:
   ```bash
   curl -X POST https://news.pivoine.art/api/v1/campaigns/1/send \
     -H "Authorization: Bearer $TOKEN"
   ```

## Ports & Networking

- **API Port**: 5000
- **External Access**: Via Traefik at https://news.pivoine.art
- **Network**: `kompose` (database access)
- **Health Check**: Runs every 30 seconds

## Database Schema Highlights

### Core Tables
- `User` - Admin users
- `Organization` - Multi-org support
- `Subscriber` - Email addresses
- `List` - Subscriber groups
- `Campaign` - Email campaigns
- `Message` - Individual emails sent
- `Template` - Reusable designs

### Tracking Tables
- `Open` - Email opens
- `Click` - Link clicks
- `Unsubscribe` - Opt-outs

## Privacy & Compliance :icon{name="lucide:lock"}

### GDPR Compliant
- ✅ Double opt-in
- ✅ Easy unsubscribe
- ✅ Data export
- ✅ Data deletion
- ✅ Consent tracking

### CAN-SPAM Compliant
- ✅ Physical address in footer
- ✅ Clear unsubscribe link
- ✅ Opt-in records
- ✅ "From" address accuracy

## Performance Optimization

### Email Sending
```javascript
// Batch sending with delays
rateLimit: 10 emails/second
batchSize: 100 subscribers
delayBetweenBatches: 5 seconds
```

### Database Queries
- Indexed email columns
- Optimized joins
- Connection pooling
- Query caching

### Caching Strategy
```javascript
// Common queries cached
subscriberCount: 5 minutes
campaignStats: 10 minutes
listMembers: 1 minute
```

## Monitoring & Debugging

### Check Health
```bash
curl https://news.pivoine.art/api/v1/health
```

### View Logs
```bash
docker logs news_backend -f --tail=100
```

### Database Stats
```bash
docker exec news_backend npx prisma studio
```

### Check Cron Jobs
```bash
docker exec news_backend crontab -l
```

## Troubleshooting

**Q: Emails not sending?**  
A: Check SMTP credentials and test connection:
```bash
# Test SMTP in container
docker exec -it news_backend node -e "
  const nodemailer = require('nodemailer');
  // Test transport...
"
```

**Q: Subscribers not receiving?**  
A: Check spam folders, verify email addresses, check sending queue

**Q: Database migration failed?**  
```bash
docker exec news_backend npx prisma migrate reset
```

**Q: API not responding?**  
A: Check if PostgreSQL is healthy and JWT_SECRET is set

## Email Best Practices :icon{name="lucide:mail"}

### Subject Lines
- Keep under 50 characters
- Personalize when possible
- Create urgency (tastefully)
- Avoid spam trigger words

### Content
- Mobile-first design
- Clear call-to-action
- Alt text for images
- Plain text fallback

### Timing
- Test different send times
- Avoid weekends (usually)
- Consider time zones
- Track engagement patterns

### List Hygiene
- Remove bounces regularly
- Re-engage inactive subscribers
- Honor unsubscribes immediately
- Keep lists clean and segmented

## Integration Examples

### Embed Signup Form
```html
<form action="https://news.pivoine.art/api/v1/subscribe" method="POST">
  <input type="email" name="email" required>
  <input type="text" name="name">
  <button type="submit">Subscribe</button>
</form>
```

### Webhook After Send
```javascript
// Trigger after campaign sends
webhooks: [{
  url: 'https://yourapp.com/campaign-sent',
  events: ['campaign.sent', 'campaign.opened']
}]
```

### Connect to Analytics
```javascript
// Send events to your analytics
trackOpen(subscriberId, campaignId)
trackClick(subscriberId, linkUrl)
```

## Scaling Tips :icon{name="lucide:rocket"}

### For Large Lists (10k+ subscribers)
1. Use dedicated SMTP service (SendGrid, Mailgun)
2. Enable connection pooling
3. Increase batch sizes
4. Monitor sending reputation
5. Implement warm-up schedule

### For High Volume
1. Add Redis for caching
2. Optimize database indexes
3. Use read replicas
4. Implement CDN for images
5. Consider email queue service

## Resources

- [Letterspace Docs](Check the /apps/docs folder!)
- [Email Marketing Best Practices](https://www.mailgun.com/blog/email-best-practices/)
- [GDPR Compliance Guide](https://gdpr.eu/)

---

*"The money is in the list, but the trust is in respecting that list."* - Email Marketing Wisdom 💌:icon{name="lucide:sparkles"}
