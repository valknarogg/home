# 🌸 Pivoine Docs Hub

A stunning, modern documentation hub landing page for all Pivoine projects by Valknar. Built with Next.js 15, React 19, TypeScript, and Tailwind CSS 4.

![Next.js](https://img.shields.io/badge/Next.js-15-black)
![TypeScript](https://img.shields.io/badge/TypeScript-5.6-blue)
![Tailwind CSS](https://img.shields.io/badge/Tailwind-4.0-06B6D4)
![pnpm](https://img.shields.io/badge/pnpm-9.0-F69220)

## ✨ Features

- **Modern Stack**: Built with Next.js 15 App Router, React 19, TypeScript, and Tailwind CSS 4
- **Stunning Design**: Glassmorphism effects, gradient animations, and interactive elements
- **Responsive**: Fully responsive design that works on all devices
- **Performance Optimized**: Turbopack for lightning-fast dev builds, image optimization, and production-ready configuration
- **SEO Ready**: Comprehensive metadata and Open Graph tags
- **Type Safe**: Full TypeScript support for better developer experience
- **Developer Experience**: Hot reload, fast refresh, and excellent tooling

## 🎨 Design Highlights

- **Interactive Background**: Mouse-tracking animated orbs that follow cursor movement
- **Glassmorphism**: Frosted glass aesthetic with backdrop blur effects
- **Smooth Animations**: Hover effects, scale transitions, and gradient animations
- **Modern Color Scheme**: Purple and pink gradients with dark theme
- **Clean Typography**: Inter font family for optimal readability
- **Custom Scrollbar**: Styled scrollbar matching the site theme

## 📁 Project Structure

```
pivoine-docs-hub/
├── app/                    # Next.js App Router directory
│   ├── globals.css        # Global styles and Tailwind imports
│   ├── layout.tsx         # Root layout with metadata
│   └── page.tsx           # Main landing page component
├── public/                # Static assets (add your images here)
├── .eslintrc.json        # ESLint configuration
├── .gitignore            # Git ignore rules
├── next.config.js        # Next.js configuration
├── package.json          # Project dependencies
├── postcss.config.js     # PostCSS configuration
├── tailwind.config.js    # Tailwind CSS configuration
├── tsconfig.json         # TypeScript configuration
└── README.md             # This file
```

## 🚀 Getting Started

### Prerequisites

- **Node.js**: 18.18.0 or higher
- **pnpm**: 8.0.0 or higher (recommended package manager)

### Installation

1. **Clone the repository** (if not already):
   ```bash
   cd /home/valknar/Projects/docs.pivoine.art
   ```

2. **Install dependencies**:
   ```bash
   pnpm install
   ```

3. **Start the development server**:
   ```bash
   pnpm dev
   ```

4. **Open your browser** and navigate to:
   ```
   http://localhost:3000
   ```

The page will automatically reload when you make changes to the code.

## 📦 Available Scripts

- **`pnpm dev`** - Start the development server on http://localhost:3000
- **`pnpm build`** - Build the application for production
- **`pnpm start`** - Start the production server (run after `build`)
- **`pnpm lint`** - Run ESLint to check code quality
- **`pnpm type-check`** - Run TypeScript compiler to check types

## 🛠️ Configuration

### Next.js 15 Configuration

The `next.config.js` includes:
- React Strict Mode for identifying potential problems
- **Turbopack**: Lightning-fast bundler enabled by default in dev mode (`--turbopack` flag)
- Automatic console removal in production
- Security headers (X-Frame-Options, CSP, etc.)
- Image optimization with AVIF and WebP support
- React 19 support with improved performance

### TypeScript Configuration

TypeScript is configured for strict mode with:
- Path aliases (`@/*` points to root directory)
- Next.js plugin for optimal type checking
- Strict type checking enabled

### Tailwind CSS 4

Tailwind CSS 4 uses a new CSS-first configuration approach:
- Configuration via `@theme` in CSS files instead of JavaScript
- No more bulky config file needed (minimal config for content paths only)
- Built-in CSS variable support
- Faster build times and smaller bundle sizes
- Import with `@import "tailwindcss"` instead of `@tailwind` directives

## 📝 Adding New Documentation Sites

To add a new documentation project to the hub:

1. **Open `app/page.tsx`**
2. **Add a new project** to the `projects` array:

```typescript
const projects = [
  {
    name: 'Kompose',
    status: 'Active',
    description: 'Comprehensive documentation for Kompose project',
    url: '/kompose',
    gradient: 'from-violet-500 to-purple-600'
  },
  {
    name: 'Your New Project',
    status: 'Active',
    description: 'Description of your new project',
    url: '/your-project',
    gradient: 'from-blue-500 to-cyan-600'
  }
]
```

3. **Create the documentation** at the specified path (e.g., `/kompose`)

## 🎯 Deployment

### Building for Production

```bash
pnpm build
```

This creates an optimized production build in the `.next` directory.

### Starting Production Server

```bash
pnpm start
```

### Deployment Platforms

This project can be deployed to:

#### **Vercel** (Recommended)
```bash
# Install Vercel CLI
pnpm add -g vercel

# Deploy
vercel
```

#### **Netlify**
```bash
# Install Netlify CLI
pnpm add -g netlify-cli

# Deploy
netlify deploy --prod
```

#### **Docker**
Create a `Dockerfile`:
```dockerfile
FROM node:18-alpine AS base

# Install pnpm
RUN npm install -g pnpm

# Dependencies
FROM base AS deps
WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile

# Builder
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN pnpm build

# Runner
FROM base AS runner
WORKDIR /app
ENV NODE_ENV production
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static

EXPOSE 3000
CMD ["node", "server.js"]
```

## 🔧 Customization

### Changing Colors

Edit the gradient colors in `app/page.tsx`:
```typescript
gradient: 'from-violet-500 to-purple-600'  // Change these Tailwind classes
```

### Modifying Metadata

Update SEO metadata in `app/layout.tsx`:
```typescript
export const metadata: Metadata = {
  title: 'Your Custom Title',
  description: 'Your custom description',
  // ... other metadata
}
```

### Custom Fonts

The project uses Inter font by default. To change:
```typescript
import { YourFont } from 'next/font/google'

const yourFont = YourFont({ subsets: ['latin'] })
```

## 🔗 Links

- **Live Site**: https://docs.pivoine.art
- **Blog**: http://pivoine.art
- **Source Code**: https://code.pivoine.art
- **Kompose Docs**: https://docs.pivoine.art/kompose

## 🤝 Contributing

This is a personal project by Valknar. For suggestions or issues, please reach out through [pivoine.art](http://pivoine.art).

## 📄 License

Copyright © 2025 Valknar. All rights reserved.

## 🙏 Acknowledgments

- **Next.js** - The React Framework for Production
- **Tailwind CSS** - A utility-first CSS framework
- **Lucide React** - Beautiful & consistent icons
- **Vercel** - Platform for deploying Next.js applications

---

**Built with ❤️ by Valknar** | [pivoine.art](http://pivoine.art)
