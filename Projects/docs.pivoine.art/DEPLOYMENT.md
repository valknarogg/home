# Deployment Guide

This guide covers different deployment options for the Pivoine Docs Hub.

## Table of Contents
- [Vercel (Recommended)](#vercel-recommended)
- [Netlify](#netlify)
- [Docker](#docker)
- [Traditional VPS](#traditional-vps)

---

## Vercel (Recommended)

Vercel is the easiest way to deploy Next.js applications.

### Method 1: Git Integration

1. **Push your code to GitHub/GitLab/Bitbucket**
2. **Import project on Vercel**:
   - Go to https://vercel.com
   - Click "Add New Project"
   - Import your repository
   - Configure settings:
     ```
     Framework Preset: Next.js
     Build Command: pnpm build
     Install Command: pnpm install
     ```
3. **Deploy**: Vercel will automatically deploy your site

### Method 2: Vercel CLI

```bash
# Install Vercel CLI
pnpm add -g vercel

# Login
vercel login

# Deploy
vercel

# Deploy to production
vercel --prod
```

### Custom Domain Setup

1. Go to your project settings on Vercel
2. Navigate to "Domains"
3. Add `docs.pivoine.art`
4. Configure DNS:
   ```
   Type: CNAME
   Name: docs
   Value: cname.vercel-dns.com
   ```

---

## Netlify

### Deploy via Git

1. **Push your code to Git**
2. **Connect to Netlify**:
   - Go to https://netlify.com
   - Click "Add new site" → "Import an existing project"
   - Choose your repository
3. **Configure build settings**:
   ```
   Build command: pnpm build
   Publish directory: .next
   ```

### Deploy via CLI

```bash
# Install Netlify CLI
pnpm add -g netlify-cli

# Login
netlify login

# Deploy
netlify deploy --prod
```

---

## Docker

### Build and Run Locally

```bash
# Build production image
docker build -t pivoine-docs-hub .

# Run container
docker run -p 3000:3000 pivoine-docs-hub
```

### Docker Compose

```bash
# Development
docker-compose up

# Production (create docker-compose.prod.yml first)
docker-compose -f docker-compose.prod.yml up
```

### Deploy to Container Registry

```bash
# Build and tag
docker build -t your-registry/pivoine-docs-hub:latest .

# Push to registry
docker push your-registry/pivoine-docs-hub:latest

# Pull and run on server
docker pull your-registry/pivoine-docs-hub:latest
docker run -d -p 3000:3000 your-registry/pivoine-docs-hub:latest
```

---

## Traditional VPS

Deploy to a traditional VPS (Ubuntu/Debian).

### Prerequisites

- Node.js 18.17+
- pnpm
- nginx (optional, for reverse proxy)
- PM2 (for process management)

### Setup Steps

1. **Install dependencies on server**:
```bash
# Install Node.js via nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install 18
nvm use 18

# Install pnpm
npm install -g pnpm

# Install PM2
npm install -g pm2
```

2. **Clone and build**:
```bash
cd /var/www
git clone your-repo-url pivoine-docs-hub
cd pivoine-docs-hub
pnpm install
pnpm build
```

3. **Run with PM2**:
```bash
pm2 start npm --name "docs-hub" -- start
pm2 save
pm2 startup
```

4. **Configure Nginx** (optional):
```nginx
server {
    listen 80;
    server_name docs.pivoine.art;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

5. **Enable site**:
```bash
sudo ln -s /etc/nginx/sites-available/docs-hub /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

6. **Setup SSL with Certbot**:
```bash
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d docs.pivoine.art
```

---

## Environment Variables

For production deployments, set these environment variables:

```bash
NEXT_PUBLIC_SITE_URL=https://docs.pivoine.art
NEXT_PUBLIC_BLOG_URL=http://pivoine.art
NEXT_PUBLIC_CODE_URL=https://code.pivoine.art
NODE_ENV=production
```

### On Vercel/Netlify
Add them in the project settings under "Environment Variables"

### On VPS
Add to `.env.local` or export in your shell profile

---

## Post-Deployment

### Verify Deployment

- Check site loads: https://docs.pivoine.art
- Test all links work
- Verify responsive design on mobile
- Check console for errors
- Test performance with Lighthouse

### Monitoring

**Vercel**: Built-in analytics and monitoring

**Other platforms**: Consider adding:
- Google Analytics
- Plausible Analytics
- Sentry for error tracking

---

## Troubleshooting

### Build Fails

**Check Node version**:
```bash
node --version  # Should be 18.17+
```

**Clear cache**:
```bash
rm -rf .next node_modules
pnpm install
pnpm build
```

### Site Not Loading

**Check service status**:
```bash
# PM2
pm2 status

# Docker
docker ps
```

**Check logs**:
```bash
# PM2
pm2 logs docs-hub

# Docker
docker logs container-name
```

### Domain Not Resolving

**Check DNS propagation**:
```bash
dig docs.pivoine.art
nslookup docs.pivoine.art
```

Wait 24-48 hours for full DNS propagation.

---

## Continuous Deployment

### GitHub Actions

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy to Vercel

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: pnpm/action-setup@v2
        with:
          version: 8
      - uses: actions/setup-node@v3
        with:
          node-version: 18
          cache: 'pnpm'
      - run: pnpm install
      - run: pnpm build
      - uses: amondnet/vercel-action@v20
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.ORG_ID }}
          vercel-project-id: ${{ secrets.PROJECT_ID }}
```

---

## Need Help?

- 📚 [Next.js Deployment Docs](https://nextjs.org/docs/deployment)
- 🔗 [Vercel Documentation](https://vercel.com/docs)
- 📧 Contact: http://pivoine.art

---

**Good luck with your deployment! 🚀**
