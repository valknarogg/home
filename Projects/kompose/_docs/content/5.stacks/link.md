---
title: Link - Your Digital Memory Palace
description: "Bookmark everything, forget nothing!"
navigation:
  icon: i-lucide-link
---

> *"Bookmark everything, forget nothing!"* - Linkwarden

## What's This All About?

Linkwarden is your self-hosted bookmark manager that doesn't just save links - it preserves entire web pages! Think of it as your personal Internet Archive. Every bookmark gets a screenshot, a PDF backup, and full-text search. Lost content, website changes, or dead links? Not your problem anymore!

## The Archive Keeper

### :icon{name="lucide:bookmark"} Linkwarden

**Container**: `link_app`  
**Image**: `ghcr.io/linkwarden/linkwarden:latest`  
**Home**: https://link.localhost  
**Database**: PostgreSQL

Linkwarden is your digital librarian with superpowers:
- :icon{name="lucide:camera"} **Automatic Screenshots**: Visual preview of every link
- :icon{name="lucide:file-text"} **Full Page Archives**: Complete webpage backups (PDF & HTML)
- :icon{name="lucide:search"} **Full-Text Search**: Find anything across all your bookmarks
- :icon{name="lucide:tags"} **Smart Organization**: Tags, collections, and folders
- :icon{name="lucide:users"} **Team Collaboration**: Share collections with others
- :icon{name="lucide:globe"} **Browser Extension**: Save from anywhere (Chrome, Firefox, Edge)
- :icon{name="lucide:smartphone"} **Mobile Apps**: iOS & Android (via PWA)
- :icon{name="lucide:shield"} **Privacy First**: Your bookmarks stay on your server
- :icon{name="lucide:zap"} **Lightning Fast**: Instant search across thousands of bookmarks

### :icon{name="lucide:database"} PostgreSQL Database

**Container**: `link_db`  
**Image**: `postgres:16-alpine`  
**Port**: 5432 (internal only)

The PostgreSQL database stores:
- Bookmark metadata and URLs
- Tags and collections
- User accounts and permissions
- Search indices for lightning-fast queries

## Configuration Breakdown

### Database Persistence
```yaml
volumes:
  - link_db_data:/var/lib/postgresql/data
```
All your bookmarks, tags, and archives are stored here. This is your treasure chest!

### Application Data
```yaml
volumes:
  - link_data:/data/data
```
This volume contains:
- Screenshot images
- PDF archives
- Full webpage HTML backups
- Uploaded file attachments

### Environment Variables

**Database Connection**:
```bash
DATABASE_URL=postgresql://linkwarden:password@link_db:5432/linkwarden
POSTGRES_PASSWORD=your-secure-password-here
```
🔒 Change the default password before deploying!

**Application Settings**:
```bash
NEXTAUTH_SECRET=your-secret-key-here
NEXTAUTH_URL=https://link.localhost
```
Generate a secure secret with:
```bash
openssl rand -base64 32
```

**Archive Configuration**:
```bash
# Storage location
STORAGE_FOLDER=/data/data

# Archive options (all enabled by default)
ARCHIVE_ENABLED=true
SCREENSHOT_ENABLED=true
PDF_ENABLED=true
```

## Why Linkwarden vs Browser Bookmarks?

| Feature | Linkwarden | Browser Bookmarks |
|---------|-----------|------------------|
| Archives | ✅ Screenshots + PDFs | ❌ Just URLs |
| Search | ✅ Full-text in pages | ❌ Title only |
| Sync | ✅ All devices/browsers | ⚠️ Single browser |
| Organization | ✅ Tags + Collections | ⚠️ Folders only |
| Sharing | ✅ Team collaboration | ❌ Export/import only |
| Dead Links | ✅ Archived content | ❌ Lost forever |
| Privacy | ✅ Your server | ⚠️ Browser syncs |

## First Time Setup :icon{name="lucide:rocket"}

### 1. Start the Stack
```bash
docker compose up -d
```

### 2. Create Your Account
```
URL: https://link.localhost
Click: "Sign Up"
Username: your-username
Email: your@email.com
Password: Something strong!
```

### 3. Configure Settings
After logging in:
1. Settings → General
2. Set your preferences:
   - Default view (Grid/List)
   - Archive options
   - Screenshot quality
   - PDF generation

### 4. Install Browser Extension

**Chrome/Edge**:
- Visit Chrome Web Store
- Search "Linkwarden"
- Install extension
- Configure server URL: `https://link.localhost`
- Enter your credentials

**Firefox**:
- Visit Firefox Add-ons
- Search "Linkwarden"  
- Install extension
- Configure server URL: `https://link.localhost`
- Enter your credentials

### 5. Mobile Access (PWA)
1. Visit https://link.localhost on mobile
2. Browser menu → "Add to Home Screen"
3. Now it works like a native app!

## Using Linkwarden :icon{name="lucide:bookmark-plus"}

### Adding Bookmarks

**Via Browser Extension**:
1. Browse to any webpage
2. Click Linkwarden extension icon
3. Optionally add:
   - Tags (press Enter after each)
   - Collection
   - Description
4. Click "Save"
5. Done! Screenshots and archives generated automatically

**Via Web Interface**:
1. Click "+ New Link"
2. Paste URL
3. Add tags and description
4. Choose collection
5. Save

**Via Bookmarklet**:
Add this to your bookmarks bar:
```javascript
javascript:(function(){window.open('https://link.localhost/new?url='+encodeURIComponent(window.location.href)+'&title='+encodeURIComponent(document.title));})();
```

### Organizing with Collections

**Create Collections**:
1. Sidebar → Collections → New
2. Name it (e.g., "Work Resources", "Recipes", "Travel")
3. Choose icon and color
4. Add description

**Use Cases**:
- 📚 Research topics
- 🍳 Recipe collections  
- 💼 Work projects
- 🎨 Design inspiration
- 🛠️ Dev resources
- ✈️ Travel planning

### Smart Tagging

**Best Practices**:
- Use lowercase (auto-converted)
- Be consistent: `javascript` not `JavaScript` or `JS`
- Use multi-word tags: `web-development`, `machine-learning`
- Tag by topic, type, and project
- Example: `tutorial`, `react`, `project-alpha`

**Auto-Suggest**:
Start typing - existing tags appear!

### Powerful Search :icon{name="lucide:search"}

Search works across:
- Link titles
- Descriptions
- Tags
- Full text of archived pages
- URL content

**Search Tips**:
- Use quotes for exact phrases: `"kubernetes deployment"`
- Search by tag: `tag:tutorial`
- Search by collection: `collection:work`
- Combine: `docker tag:tutorial collection:devops`

## Advanced Features

### Bulk Actions
Select multiple links to:
- Add/remove tags
- Move to different collection
- Delete
- Export

### Import Bookmarks
Import from:
- Chrome/Firefox HTML exports
- Pocket
- Raindrop.io
- Plain URL lists

**Import Process**:
1. Settings → Import
2. Choose format
3. Upload file
4. Map to collections
5. Import!

### Public Collections
Share collections publicly:
1. Collection settings → Make Public
2. Get shareable link
3. Others can view (no account needed)
4. Optional: Allow others to contribute

### RSS Feed
Each collection has an RSS feed:
```
https://link.localhost/api/collections/[id]/feed
```
Use with RSS readers like Miniflux!

## Archive Features :icon{name="lucide:archive"}

### Screenshot Archives
- Captured on bookmark save
- Full page screenshot (scrolls entire page)
- Saved as PNG
- Viewable in-app
- Click to enlarge

### PDF Archives  
- Complete webpage as PDF
- Preserves formatting
- Text-selectable
- Downloadable
- Great for offline reading

### HTML Archives
- Complete webpage saved
- All assets included
- Readable even if original dies
- Full-text searchable

### Re-Archive
If page content changes:
1. Open bookmark
2. Click "Re-archive"
3. New snapshot created
4. Old versions preserved

## Collaboration Features :icon{name="lucide:users"}

### Team Workspaces
1. Create collection
2. Settings → Members
3. Invite by email/username
4. Set permissions:
   - View only
   - Can contribute
   - Can edit
   - Admin

### Activity Feed
See what your team is doing:
- New bookmarks added
- Tags updated
- Collections modified
- Member activity

### Shared Collections
Perfect for:
- Research teams
- Project resources
- Knowledge bases
- Curated lists
- Team documentation

## API Access :icon{name="lucide:code"}

Linkwarden has a full REST API!

**Get API Token**:
1. Settings → API
2. Generate new token
3. Copy and save securely

**Example: Add Bookmark**:
```bash
curl -X POST https://link.localhost/api/v1/links \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://example.com",
    "name": "Example Site",
    "description": "An example bookmark",
    "tags": ["example", "test"],
    "collectionId": 1
  }'
```

**Example: Search**:
```bash
curl https://link.localhost/api/v1/links?q=docker \
  -H "Authorization: Bearer YOUR_TOKEN"
```

**Automate Everything**:
- Save from scripts
- Backup tools
- CI/CD pipelines
- Custom integrations

## Browser Extension Tips :icon{name="lucide:puzzle"}

### Keyboard Shortcuts
Set in browser extension settings:
- Default: `Alt+Shift+L` to save current page
- Customize to your preference

### Context Menu
Right-click on links:
- "Save to Linkwarden"
- Quick save without opening extension

### Bulk Save
On pages with many links:
1. Open extension
2. Click "Save all links"
3. Scans page for links
4. Batch save selected links

## Maintenance & Backups

### Backup Strategy
```bash
# Backup PostgreSQL database
docker exec link_db pg_dump -U linkwarden linkwarden > backup.sql

# Backup archives and screenshots
tar -czf linkwarden-data-$(date +%Y%m%d).tar.gz ./link_data/

# Backup both (recommended)
docker compose exec link_db pg_dump -U linkwarden linkwarden | \
  gzip > backup-$(date +%Y%m%d).sql.gz
```

### Restore from Backup
```bash
# Stop the stack
docker compose down

# Restore database
gunzip -c backup-20240101.sql.gz | \
  docker compose exec -T link_db psql -U linkwarden linkwarden

# Restore files
tar -xzf linkwarden-data-20240101.tar.gz

# Start stack
docker compose up -d
```

### Database Maintenance
```bash
# Check database size
docker exec link_db psql -U linkwarden linkwarden -c \
  "SELECT pg_size_pretty(pg_database_size('linkwarden'));"

# Vacuum database (optimize)
docker exec link_db psql -U linkwarden linkwarden -c "VACUUM ANALYZE;"
```

### Clean Old Archives
Over time, archives can grow large:
1. Settings → Storage
2. View storage usage
3. Delete archives for links you don't need
4. Or increase disk space allocation

## Performance Tuning

### Archive Settings
If storage/performance is a concern:

**Reduce Screenshot Quality**:
```bash
SCREENSHOT_QUALITY=medium  # high, medium, low
```

**Disable Certain Archives**:
```bash
PDF_ENABLED=false  # If you only need screenshots
```

**Archive on Demand**:
Instead of auto-archiving, archive manually when needed

### Database Optimization
```bash
# Increase shared memory (in docker-compose.yml)
services:
  link_db:
    command: postgres -c shared_buffers=256MB -c max_connections=200
```

## Troubleshooting :icon{name="lucide:wrench"}

**Q: Archives not generating?**  
A: Check container logs: `docker logs link_app`  
Ensure enough disk space is available

**Q: "Database connection failed"?**  
A: Verify DATABASE_URL is correct  
Check link_db container is running: `docker ps`

**Q: Can't login?**  
A: Reset password via forgot password link  
Or reset via database if needed

**Q: Browser extension not connecting?**  
A: Verify server URL matches exactly  
Check if you can access web interface  
Try re-authenticating in extension

**Q: Search not finding content?**  
A: Full-text search needs archives  
Wait for archive generation to complete  
Check archives exist for that bookmark

**Q: Slow performance?**  
A: Check database needs vacuuming  
Consider limiting archive quality/types  
Ensure adequate server resources

## Security Best Practices :icon{name="lucide:shield"}

### Authentication
- :icon{name="lucide:lock"} Use strong, unique passwords
- :icon{name="lucide:key"} Enable 2FA when available
- :icon{name="lucide:users"} Create separate accounts for team members
- :icon{name="lucide:eye-off"} Never share passwords

### API Tokens
- :icon{name="lucide:key"} Generate separate tokens per integration
- :icon{name="lucide:refresh-cw"} Rotate tokens regularly
- :icon{name="lucide:trash"} Revoke unused tokens
- :icon{name="lucide:lock-keyhole"} Store tokens securely (not in code!)

### Network Security
- :icon{name="lucide:globe"} HTTPS only (Traefik provides this)
- :icon{name="lucide:shield"} Keep containers updated
- :icon{name="lucide:database"} Database not exposed externally
- :icon{name="lucide:hard-drive"} Regular backups

### Data Privacy
- :icon{name="lucide:server"} All data on your server
- :icon{name="lucide:lock"} Not sent to third parties
- :icon{name="lucide:eye"} Full control over who sees what
- :icon{name="lucide:trash"} Permanent deletion when you delete

## Data & Volumes

### PostgreSQL Data
```
Volume: link_db_data
Contains:
├── Database files
├── User accounts
├── Bookmark metadata
└── Search indices
```

### Application Data
```
Volume: link_data
Contains:
├── screenshots/     # Bookmark screenshots (PNG)
├── archives/        # PDF archives
├── htmlarchives/    # Full HTML archives
└── uploads/         # User uploaded files
```

**Storage Growth**:
- Each bookmark: ~500KB - 5MB (depends on page)
- Plan disk space accordingly
- Monitor with `du -sh` in container

## Ports & Networking

- **App Port**: 3000 (internal)
- **Database Port**: 5432 (internal only)
- **External Access**: Via Traefik at https://link.localhost
- **Network**: `kompose` (isolated, secure)

## Useful Commands

### View Logs
```bash
# Application logs
docker logs link_app -f

# Database logs
docker logs link_db -f

# Both simultaneously
docker compose logs -f
```

### Check Status
```bash
# Container status
docker compose ps

# Resource usage
docker stats link_app link_db
```

### Restart Services
```bash
# Restart all
docker compose restart

# Restart just app
docker compose restart link_app
```

### Database Console
```bash
# Access PostgreSQL
docker exec -it link_db psql -U linkwarden linkwarden

# Useful queries
SELECT COUNT(*) FROM links;  -- Count bookmarks
SELECT * FROM users;         -- List users
```

## Import From Other Services

### Pocket
1. Export from Pocket (HTML or JSON)
2. Linkwarden → Import
3. Select Pocket format
4. Upload and import

### Browser Bookmarks
1. Export from browser (Bookmarks → Export)
2. Linkwarden → Import
3. Select "HTML Bookmarks"
4. Map to collections
5. Import

### Other Services
Supports imports from:
- Raindrop.io
- Instapaper
- Pinboard
- Any service with HTML/JSON export

## Export Your Data

Never locked in! Export anytime:

1. Settings → Export
2. Choose format:
   - HTML (browser compatible)
   - JSON (full data)
   - CSV (spreadsheet)
3. Include options:
   - Archives
   - Screenshots
   - Tags
4. Download

## Why Self-Host Your Bookmarks?

- :icon{name="lucide:server"} **Control**: Your data, your rules
- :icon{name="lucide:eye-off"} **Privacy**: No tracking or data mining
- :icon{name="lucide:archive"} **Permanence**: Archives survive link death
- :icon{name="lucide:search"} **Search**: Full-text across all content
- :icon{name="lucide:users"} **Collaboration**: Share with your team
- :icon{name="lucide:zap"} **Speed**: Local network = instant
- :icon{name="lucide:dollar-sign"} **Cost**: Free and unlimited
- :icon{name="lucide:ban"} **No Limits**: Unlimited bookmarks and storage

## Use Cases & Inspiration

### Personal Knowledge Base
Bookmark articles, tutorials, and documentation. Build your second brain!

### Research Collection
Gather sources for projects, papers, or investigations. Full archives mean citations never break.

### Recipe Archive
Save recipes with full page archives. Even if the blog dies, you keep the recipe!

### Travel Planning
Bookmark hotels, attractions, articles. Share collection with travel companions.

### Design Inspiration
Screenshot-perfect for saving design examples and mockups.

### Dev Resources
Keep tutorials, docs, Stack Overflow answers. Full-text search across all.

### Shopping Research
Save product pages with prices and reviews before they change.

### News Clipping
Archive news articles before they're paywalled or deleted.

## Resources

- [Linkwarden Documentation](https://docs.linkwarden.app/)
- [GitHub Repository](https://github.com/linkwarden/linkwarden)
- [Discord Community](https://discord.linkwarden.app)
- [Browser Extensions](https://linkwarden.app/download)

---

*"The internet is ephemeral. Your bookmarks don't have to be."* - A wise bookmark hoarder :icon{name="lucide:bookmark"}:icon{name="lucide:sparkles"}
