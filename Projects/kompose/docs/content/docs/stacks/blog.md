---
title: Blog Stack - Your Lightning-Fast Static Site Delivery
description: "Speed is my middle name"
---

# 📝 Blog Stack - Your Lightning-Fast Static Site Delivery

> *"Speed is my middle name"* - Static Web Server

## What's This All About?

This stack serves your static blog with the speed of a caffeinated cheetah! It's a blazing-fast static web server written in Rust 🦀, serving pre-built HTML, CSS, and JavaScript files without any server-side processing overhead.

## The Speed Demon

### ⚡ Static Web Server

**Container**: `blog_app`  
**Image**: `joseluisq/static-web-server:latest`  
**Home**: https://pivoine.art

Think of this as nginx's cooler, faster cousin who runs marathons in their spare time:
- 🚀 **Blazing Fast**: Written in Rust for maximum performance
- 📦 **Tiny Footprint**: Minimal resource usage
- 🎯 **Simple**: Does one thing really, really well
- 🔒 **Secure**: No dynamic code execution means fewer attack vectors
- 📊 **HTTP/2**: Modern protocol support for faster loading

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

## Traefik Magic 🎩✨

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

No restarts, no cache clearing, no drama! 🎭

## What Makes Static Sites Awesome

### Speed 🏎️
- No database queries
- No server-side rendering
- Just pure file serving
- CDN-friendly

### Security 🔒
- No SQL injection
- No XSS vulnerabilities (from server)
- No admin panel to hack
- No WordPress updates to forget

### Cost 💰
- Minimal server resources
- Can handle huge traffic spikes
- No expensive database servers
- Can run on a potato (almost)

### Reliability 🎯
- Nothing to break
- Nothing to update constantly
- No dependency conflicts
- Rock solid uptime

## Ports & Networking

- **Internal Port**: 80
- **External Access**: Via Traefik at https://pivoine.art
- **Network**: `kompose` (the usual gang)

## Common Static Site Generators

### Hugo 🚀
The speed champion, written in Go
```bash
hugo new site myblog
hugo new posts/my-first-post.md
hugo server -D
hugo build
```

### Jekyll 💎
The Ruby classic, GitHub Pages favorite
```bash
jekyll new myblog
jekyll serve
jekyll build
```

### Gatsby ⚛️
React-based, GraphQL-powered
```bash
gatsby new myblog
gatsby develop
gatsby build
```

### 11ty (Eleventy) 🎈
Simple, JavaScript-based
```bash
npx @11ty/eleventy
```

## Performance Tips 💡

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

## Security Considerations 🛡️

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

## Content Ideas for Your Blog 📚

- 💻 Tech tutorials and guides
- 🎨 Design showcases and portfolios
- 📝 Personal thoughts and experiences
- 🔧 Project documentation
- 🎯 Case studies and success stories
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

*"The fastest code is the code that doesn't run. The fastest server is the one that just serves files."* - Ancient DevOps Wisdom 📜
