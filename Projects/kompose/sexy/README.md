# 💅 Sexy Stack - Your Headless CMS Runway

> *"We make content management look good!"* - Directus + SvelteKit

## What's This All About?

This is your full-stack content management system! A headless CMS (Directus) paired with a blazing-fast SvelteKit frontend. It's like WordPress if WordPress went to design school, hit the gym, and learned to code properly. All at sexy.pivoine.art because why not make content management... sexy? 😎

## The Power Couple

### 🎨 Directus API

**Container**: `sexy_api`  
**Image**: `directus/directus:11.12.0`  
**Port**: 8055  
**Home**: https://sexy.pivoine.art/api

Directus is the headless CMS that doesn't make you cry:
- 📊 **Database-First**: Works with your existing database
- 🎛️ **Admin Panel**: Beautiful UI out of the box
- 🔌 **REST + GraphQL**: Choose your flavor
- 🖼️ **Asset Management**: Images, videos, files - all handled
- 👥 **User Roles**: Granular permissions
- 🔄 **Real-time**: WebSocket support for live updates
- 🎨 **Customizable**: Extensions, hooks, custom fields
- 🔐 **Auth**: Built-in user management and SSO

### ⚡ SvelteKit Frontend

**Container**: `sexy_frontend`  
**Image**: `node:22`  
**Port**: 3000  
**Home**: https://sexy.pivoine.art

The face of your content:
- 🚀 **Lightning Fast**: Svelte's magic compilation
- 🎯 **SEO Friendly**: Server-side rendering
- 📱 **Responsive**: Mobile-first design
- 🎨 **Beautiful**: Because sexy.pivoine.art deserves it
- 🔄 **Real-time Updates**: Live data from Directus
- 💅 **Styled**: Tailwind CSS + custom design

## Architecture

```
User Request (sexy.pivoine.art)
    ↓
Traefik
    ├─ /api/* → Directus API (Backend)
    └─ /* → SvelteKit (Frontend)
```

The magic:
- Frontend requests `/api/items/posts`
- Traefik strips `/api` prefix
- Routes to Directus
- Returns JSON
- Frontend renders beautifully

## Configuration Breakdown

### Directus Environment

**Database**:
```bash
DB_CLIENT=pg  # PostgreSQL ftw!
DB_HOST=postgres
DB_DATABASE=directus
```

**Cache** (Redis for speed):
```bash
CACHE_ENABLED=true
CACHE_STORE=redis
REDIS=redis://redis:6379
```

**WebSockets** (Real-time magic):
```bash
WEBSOCKETS_ENABLED=true
```

**CORS** (Frontend can talk to API):
```bash
CORS_ENABLED=true
CORS_ORIGIN=https://sexy.pivoine.art
SESSION_COOKIE_DOMAIN=sexy.pivoine.art
```

**Extensions** (Custom functionality):
```bash
EXTENSIONS_PATH=./extensions
DIRECTUS_BUNDLE=/var/www/sexy.pivoine.art/packages/bundle
```

### Frontend Setup

Running from `/var/www/sexy.pivoine.art`:
```bash
# Built SvelteKit app
node build/index.js
```

## First Time Setup 🚀

### 1. Create Database
```bash
docker exec data_postgres createdb -U your_db_user directus
```

### 2. Start the Stack
```bash
docker compose up -d
```

### 3. Access Directus Admin
```
URL: https://sexy.pivoine.art/api/admin
Email: Your ADMIN_EMAIL
Password: Your ADMIN_PASSWORD
```

### 4. Create Your First Collection

1. **Go to Settings → Data Model**
2. **Click "Create Collection"**
3. **Name it** (e.g., "posts")
4. **Add Fields**:
   - Title (String)
   - Content (WYSIWYG)
   - Author (Many-to-One User)
   - Published Date (DateTime)
   - Featured Image (Image)

5. **Save and Create Item!**

## Using the Admin Panel 🎛️

### Content Management

**Create Items**:
- Navigate to your collection
- Click "+" button
- Fill in fields
- Save as draft or publish

**Media Library**:
- Upload images, videos, PDFs
- Organize in folders
- Generate thumbnails automatically
- Serve optimized versions

**User Management**:
- Create editors, authors, admins
- Set granular permissions
- SSO integration available

### Data Model

**Field Types**:
- 📝 Text (String, Text, Markdown)
- 🔢 Numbers (Integer, Float, Decimal)
- 📅 Dates (Date, DateTime, Time)
- ✅ Booleans & Toggles
- 🎨 JSON & Code
- 🔗 Relations (O2M, M2O, M2M)
- 🖼️ Files & Images
- 📍 Geolocation

## API Usage 🔌

### REST API

**Get All Posts**:
```bash
curl https://sexy.pivoine.art/api/items/posts
```

**Get Single Post**:
```bash
curl https://sexy.pivoine.art/api/items/posts/1
```

**Create Post** (Auth required):
```bash
curl -X POST https://sexy.pivoine.art/api/items/posts \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "My First Post",
    "content": "Hello World!"
  }'
```

**Filter & Sort**:
```bash
curl "https://sexy.pivoine.art/api/items/posts?filter[status][_eq]=published&sort=-date"
```

### GraphQL

```graphql
query {
  posts {
    id
    title
    content
    author {
      first_name
      last_name
    }
  }
}
```

### Authentication

**Login**:
```bash
curl -X POST https://sexy.pivoine.art/api/auth/login \
  -d '{"email": "user@example.com", "password": "secret"}'
```

Returns access token for authenticated requests.

## Frontend Integration

### Fetching in SvelteKit

```javascript
// src/routes/blog/+page.js
export async function load({ fetch }) {
  const res = await fetch('https://sexy.pivoine.art/api/items/posts');
  const { data } = await res.json();
  
  return {
    posts: data
  };
}
```

```svelte
<!-- src/routes/blog/+page.svelte -->
<script>
  export let data;
</script>

{#each data.posts as post}
  <article>
    <h2>{post.title}</h2>
    <p>{post.content}</p>
  </article>
{/each}
```

### Image Optimization

Directus automatically generates thumbnails:
```html
<img 
  src="https://sexy.pivoine.art/api/assets/{id}?width=800&quality=80"
  alt="Featured"
>
```

## Real-Time Updates 🔄

### WebSocket Connection

```javascript
import { createDirectus, realtime } from '@directus/sdk';

const client = createDirectus('https://sexy.pivoine.art/api')
  .with(realtime());

client.subscribe('posts', {
  event: 'create',
  query: {
    fields: ['*']
  }
}, (message) => {
  console.log('New post!', message);
});
```

## Extensions & Customization 🔧

### Custom Hooks

```javascript
// extensions/hooks/notify-on-publish/index.js
export default ({ filter }) => {
  filter('posts.items.create', async (payload) => {
    // Send notification when post created
    await sendNotification(payload);
    return payload;
  });
};
```

### Custom Endpoints

```javascript
// extensions/endpoints/stats/index.js
export default (router) => {
  router.get('/', async (req, res) => {
    const stats = await calculateStats();
    res.json(stats);
  });
};
```

### Custom Panels

Create custom admin panels with Vue.js!

## Volumes & Data

### Uploads Directory
```
./uploads → /directus/uploads
```
All uploaded files stored here.

### Extensions Bundle
```
/var/www/sexy.pivoine.art/packages/bundle
```
Custom extensions and functionality.

## Ports & Networking

| Service | Internal Port | External Access |
|---------|--------------|-----------------|
| Directus API | 8055 | /api/* via Traefik |
| Frontend | 3000 | /* via Traefik |

## Content Workflows

### Blog Post Workflow

1. **Draft**: Writer creates post
2. **Review**: Editor reviews content
3. **Approve**: Admin approves
4. **Schedule**: Set publish date
5. **Publish**: Goes live automatically

### User Permissions

- **Admin**: Full access
- **Editor**: Edit content, manage media
- **Author**: Create own posts
- **Public**: Read published content

## Performance Optimization 🚀

### Caching Strategy
```javascript
// Redis cache for API responses
CACHE_AUTO_PURGE=true  // Auto-clear on changes
CACHE_TTL=300          // 5 minutes
```

### Image Optimization
- Automatic WebP conversion
- Lazy loading
- Responsive images
- CDN-ready URLs

### Database Queries
- Indexed fields
- Query result caching
- Connection pooling

## Security Best Practices 🔒

1. **Change Default Password**: First thing!
2. **API Access Tokens**: Use tokens, not passwords
3. **CORS Configuration**: Only allow your domain
4. **Rate Limiting**: Protect against abuse
5. **File Upload Validation**: Check file types
6. **Regular Backups**: Both database and uploads

## Troubleshooting

**Q: Can't access admin panel?**  
A: Check ADMIN_EMAIL and ADMIN_PASSWORD in .env

**Q: API returns 401?**  
A: Need authentication token for private collections

**Q: Images not loading?**  
A: Check uploads volume is mounted correctly

**Q: Frontend can't fetch API?**  
A: Verify CORS settings and PUBLIC_URL

**Q: Real-time not working?**  
A: Check WEBSOCKETS_ENABLED=true and wss:// connection

## Common Use Cases

### Blog Platform
- Posts, authors, categories
- Comments system
- SEO optimization
- RSS feed

### E-commerce
- Products catalog
- Inventory management
- Order processing
- Customer data

### Portfolio Site
- Project showcase
- Case studies
- Client testimonials
- Contact forms

### Documentation
- Articles & guides
- Search functionality
- Version control
- Multi-language support

## Why This Stack is Sexy 💅

- ✨ **Developer Experience**: Joy to work with
- 🚀 **Performance**: Fast out of the box
- 🎨 **Design**: Beautiful admin interface
- 🔧 **Flexibility**: Customize everything
- 📱 **Modern**: Built with latest tech
- 🆓 **Open Source**: Free forever
- 💪 **Production Ready**: Powers serious sites

## Resources

- [Directus Documentation](https://docs.directus.io/)
- [SvelteKit Docs](https://kit.svelte.dev/docs)
- [Directus Extensions](https://docs.directus.io/extensions/)
- [GraphQL Guide](https://graphql.org/learn/)

---

*"Content management should feel like art, not work."* - Sexy Philosophy 💅✨
