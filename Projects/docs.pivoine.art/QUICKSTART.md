# Quick Start Guide

## Installation & Setup

### 1. Install Dependencies
```bash
pnpm install
```

### 2. Run Development Server
```bash
pnpm dev
```

This will start the development server with Turbopack for ultra-fast hot reload!

Visit http://localhost:3000 to see your site!

## First Steps

### Add a New Documentation Project

1. Open `app/page.tsx`
2. Add your project to the `projects` array:
```typescript
{
  name: 'Your Project',
  status: 'Active',
  description: 'Your project description',
  url: '/your-project',
  gradient: 'from-blue-500 to-cyan-600'
}
```

### Customize Colors & Branding

**Change main colors**: Edit gradient classes in `app/page.tsx`
```typescript
gradient: 'from-purple-500 to-pink-600' // Your colors here
```

**Update metadata**: Edit `app/layout.tsx`
```typescript
export const metadata: Metadata = {
  title: 'Your Title',
  description: 'Your description',
}
```

### Build for Production

```bash
# Create optimized production build
pnpm build

# Test production build locally
pnpm start
```

## Project Structure

```
app/
├── layout.tsx    # Root layout, metadata, fonts
├── page.tsx      # Landing page component
└── globals.css   # Global styles

public/           # Static assets (images, favicon)
```

## Common Tasks

### Add a Custom Font
```typescript
// app/layout.tsx
import { YourFont } from 'next/font/google'
const yourFont = YourFont({ subsets: ['latin'] })
```

### Add Environment Variables
1. Copy `.env.example` to `.env.local`
2. Add your variables
3. Use in code: `process.env.NEXT_PUBLIC_YOUR_VAR`

### Deploy to Vercel
```bash
pnpm add -g vercel
vercel
```

## Troubleshooting

**Port 3000 already in use?**
```bash
pnpm dev -- -p 3001
```

**Dependencies issues?**
```bash
rm -rf node_modules .next
pnpm install
```

**Type errors?**
```bash
pnpm type-check
```

## Need Help?

- 📚 [Full README](README.md)
- 🔗 [Next.js Docs](https://nextjs.org/docs)
- 🎨 [Tailwind Docs](https://tailwindcss.com/docs)

---

**Happy coding! 🌸**
