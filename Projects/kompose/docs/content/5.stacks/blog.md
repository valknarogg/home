---
title: Blog - Lightning-Fast Static Site Delivery
description: "Speed is my middle name"
navigation:
  icon: i-lucide-file-text
---

> *"Speed is my middle name"* - Static Web Server

## What's This All About?

This stack serves your static blog with the speed of a caffeinated cheetah! It's a blazing-fast static web server written in Rust :icon{name="simple-icons:rust"}, serving pre-built HTML, CSS, and JavaScript files without any server-side processing overhead.

## The Speed Demon

### :icon{name="lucide:zap"} Static Web Server

**Container**: `blog_app`  
**Image**: `joseluisq/static-web-server:latest`  
**Home**: https://pivoine.art

Think of this as nginx's cooler, faster cousin who runs marathons in their spare time:
- :icon{name="lucide:rocket"} **Blazing Fast**: Written in Rust for maximum performance
- :icon{name="lucide:package"} **Tiny Footprint**: Minimal resource usage
- :icon{name="lucide:target"} **Simple**: Does one thing really, really well
- :icon{name="lucide:lock"} **Secure**: No dynamic code execution means fewer attack vectors
- :icon{name="lucide:bar-chart"} **HTTP/2**: Modern protocol support for faster loading

## Architecture

```
User Request
    ↓
Traefik (SSL + Routing)
    ↓
Static Web Server
    ↓
/var/www/pivoine.art (Your beautiful content!)
```

## Configuration Breakdown

### Volume Mapping
Your blog content lives at:
```
Host: /var/www/pivoine.art
Container: /public
```

This means you can update your blog by just replacing files on the host! No container restart needed (usually).

### No Health Check? No Problem!
Static web servers are so simple and reliable that Docker health checks aren't really necessary. Traefik can tell if it's alive by checking the port - if it responds, it's healthy!

## Traefik Magic :icon{name="lucide:hat"}:icon{name="lucide:sparkles"}

All the routing is handled by Traefik labels:
- **HTTP → HTTPS**: Automatic redirect for security
- **Domain**: `pivoine.art` (your main domain!)
- **Compression**: Enabled for faster page loads
- **SSL**: Handled by Traefik with Let's Encrypt

## Typical Workflow

### Publishing New Content

1. **Build your static site** (Hugo, Jekyll, Gatsby, etc.):
   ```bash
   hugo build  # or whatever your generator uses
   ```

2. **Copy files to the server**:
   ```bash
   rsync -avz public/ user@server:/var/www/pivoine.art/
   ```

3. **That's it!** The server automatically serves the new content

No restarts, no cache clearing, no drama! :icon{name="lucide:drama"}

## What Makes Static Sites Awesome

### Speed :icon{name="lucide:car"}
- No database queries
- No server-side rendering
- Just pure file serving
- CDN-friendly

### Security :icon{name="lucide:lock"}
- No SQL injection
- No XSS vulnerabilities (from server)
- No admin panel to hack
- No WordPress updates to forget

### Cost :icon{name="lucide:dollar-sign"}
- Minimal server resources
- Can handle huge traffic spikes
- No expensive database servers
- Can run on a potato (almost)

### Reliability :icon{name="lucide:target"}
- Nothing to break
- Nothing to update constantly
- No dependency conflicts
- Rock solid uptime

## Ports & Networking

- **Internal Port**: 80
- **External Access**: Via Traefik at https://pivoine.art
- **Network**: `kompose` (the usual gang)

## Common Static Site Generators

### Hugo :icon{name="lucide:rocket"}
The speed champion, written in Go
```bash
hugo new site myblog
hugo new posts/my-first-post.md
hugo server -D
hugo build
```

### Jekyll :icon{name="simple-icons:ruby"}
The Ruby classic, GitHub Pages favorite
```bash
jekyll new myblog
jekyll serve
jekyll build
```

### Gatsby :icon{name="simple-icons:react"}
React-based, GraphQL-powered
```bash
gatsby new myblog
gatsby develop
gatsby build
```

### 11ty (Eleventy) :icon{name="lucide:heart"}
Simple, JavaScript-based
```bash
npx @11ty/eleventy
```

## Performance Tips :icon{name="lucide:lightbulb"}

1. **Image Optimization**: Use WebP or AVIF formats
2. **Minification**: Compress CSS, JS, HTML
3. **Lazy Loading**: Don't load images until needed
4. **CDN**: Put Cloudflare in front (optional but awesome)
5. **HTTP/2**: Already supported by the server!

## Maintenance Tasks

### View Logs
```bash
docker logs blog_app -f
```

### Check What's Being Served
```bash
docker exec blog_app ls -lah /public
```

### Restart Container
```bash
docker compose restart
```

### Update Content
Just copy new files to `/var/www/pivoine.art` - no restart needed!

## Troubleshooting

**Q: Getting 404 errors?**  
A: Check if files exist at `/var/www/pivoine.art` and paths match URLs

**Q: Changes not showing up?**  
A: Clear browser cache (Ctrl+Shift+R) or check if files were actually copied

**Q: Slow loading?**  
A: Static sites are rarely slow - check your image sizes and network

**Q: Can't access the site?**  
A: Verify Traefik is running and DNS points to your server

## Security Considerations :icon{name="lucide:shield"}

✅ **Good News**: Static sites are inherently secure  
✅ **HTTPS**: Handled by Traefik with automatic certificates  
✅ **No Backend**: No server-side code to exploit  
✅ **Headers**: Can add security headers via Traefik

❌ **Watch Out For**:
- XSS in JavaScript if you're doing client-side stuff
- CORS issues if loading from other domains
- File permissions on the host volume

## Advanced: Custom 404 Pages

Create a `404.html` in your static site root:
```html
<!DOCTYPE html>
<html>
<head>
    <title>Page Not Found</title>
</head>
<body>
    <h1>Oops! 404</h1>
    <p>That page doesn't exist. Maybe it never did. 🤔</p>
</body>
</html>
```

The server will automatically use it for missing pages!

## Content Ideas for Your Blog :icon{name="lucide:book-open"}

- :icon{name="lucide:laptop"} Tech tutorials and guides
- :icon{name="lucide:palette"} Design showcases and portfolios
- :icon{name="lucide:file-text"} Personal thoughts and experiences
- :icon{name="lucide:wrench"} Project documentation
- :icon{name="lucide:target"} Case studies and success stories
- 🌟 Whatever makes your heart sing!

## Fun Facts

- Rust makes this server crazy efficient (like, really crazy)
- Can handle thousands of requests per second
- Used by developers worldwide who value speed
- Open source and actively maintained
- Probably faster than most dynamic CMSs on their best day

## Resources

- [Static Web Server Docs](https://static-web-server.net/)
- [Hugo Documentation](https://gohugo.io/documentation/)
- [JAMstack Resources](https://jamstack.org/)

---

*"The fastest code is the code that doesn't run. The fastest server is the one that just serves files."* - Ancient DevOps Wisdom :icon{name="lucide:scroll"}
