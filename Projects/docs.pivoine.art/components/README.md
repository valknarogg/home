# Components

This directory contains reusable React components for the Pivoine Docs Hub.

## Icons

Custom animated icons for the documentation hub and projects.

### PivoineDocsIcon ⭐ NEW

The official branding icon for the Pivoine Docs Hub - a beautiful peony flower with integrated documentation elements.

#### Features
- 🌸 Multi-layer peony flower design (18 petals, 3 layers)
- 📄 Document pages in the center with text lines
- ✨ Twinkling sparkles and orbiting particles
- 💫 Smooth bloom animation on hover
- 🎯 3D rotation and ripple effect on click
- 🎨 Purple/pink gradients matching theme
- 📱 Fully responsive and touch-optimized
- ♿ Accessibility support (reduced motion)
- 🚀 GPU-accelerated animations (60 FPS)

#### Usage

```tsx
import { PivoineDocsIcon } from '@/components/icons'

// Hero section - large, interactive
<PivoineDocsIcon size="200px" />

// With label
<PivoineDocsIcon size="256px" showLabel={true} />

// Small, non-interactive
<PivoineDocsIcon size="64px" interactive={false} />
```

#### Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `size` | `string` | `'256px'` | Size of the icon (CSS width/height) |
| `interactive` | `boolean` | `true` | Enable/disable hover and click animations |
| `className` | `string` | `''` | Additional CSS classes |
| `showLabel` | `boolean` | `false` | Show "Pivoine Docs" text below icon |

#### Animations

**Default State:**
- Subtle pulsing background
- Twinkling sparkles (2s cycle)
- Orbiting particles (8s cycle)
- Gentle page floating
- Text lines appear on mount

**On Hover:**
- Icon scales and lifts
- Petals bloom in sequence (outer → middle → inner)
- Center glows intensely
- Sparkles burst
- Pages fan out with rotation

**On Click/Tap:**
- 3D rotation flip (360°)
- Petal explosion effect
- Center burst
- Ripple effect emanates from center
- Duration: ~800ms

#### Use Cases
- Hero sections and splash screens
- About pages
- Branding materials
- Favicon and PWA icons
- Social media graphics

#### Documentation
See [PIVOINE_DOCS_ICON.md](./icons/PIVOINE_DOCS_ICON.md) for complete documentation.

---

### KomposeIcon

A beautifully animated icon for the Kompose documentation project.

#### Features
- ✨ Smooth hover animations with glowing effects
- 🎯 Click/tap interactions with ripple effects
- 🎨 Custom gradient backgrounds with carbon fiber pattern
- 💫 Animated status indicator (pulsing dot)
- 📱 Responsive and touch-optimized
- ♿ Supports reduced motion preferences
- 🎭 3D rotation effects on interaction

#### Usage

```tsx
import { KomposeIcon } from '@/components/icons'

// Basic usage
<KomposeIcon />

// Custom size
<KomposeIcon size="128px" />

// Non-interactive (no hover/click effects)
<KomposeIcon size="64px" interactive={false} />

// With custom className
<KomposeIcon className="my-custom-class" />
```

#### Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `size` | `string` | `'192px'` | Size of the icon (CSS width/height) |
| `interactive` | `boolean` | `true` | Enable/disable hover and click animations |
| `className` | `string` | `''` | Additional CSS classes |

#### Animations

**On Hover:**
- Icon scales up slightly with shadow enhancement
- Letter "K" glows with animated glow effect
- Status dot pulses and expands
- Corner decorations animate in
- Lines redraw with slide animation

**On Click/Tap:**
- 3D rotation flip effect
- Bright flash with intense glow
- Ripple effect emanates from center
- Bounce animation

**Default State:**
- Subtle pulsing status indicator
- Gentle shadow glow

#### Customization

The icon uses these main colors from the Kompose brand:
- Primary: `#00DC82` (emerald green)
- Background: Dark gradient (`#1a1d2e` to `#0a0e27`)
- Accent: `#00a86b` (darker green)

#### Accessibility

- Respects `prefers-reduced-motion` settings
- Touch-optimized for mobile devices
- Proper cursor states
- Keyboard accessible (when interactive)

#### Performance

- Uses CSS animations (GPU accelerated)
- SVG filters for visual effects
- Minimal re-renders with React hooks
- Scoped styles with CSS-in-JS

#### Browser Support

Works in all modern browsers that support:
- SVG filters (`feGaussianBlur`, `feMerge`)
- CSS animations
- CSS transforms (3D)

#### Converting from Vue

This component was converted from a Vue 3 component. Key differences:
- Vue `ref()` → React `useState()`
- Vue `@click` → React `onClick`
- Vue `:class` → React `className` with template literals
- Vue `v-if` → React conditional rendering `{showRipple && ...}`
- Scoped styles → CSS-in-JS with `<style jsx>`

## Adding New Icons

To add a new project icon:

1. Create a new component in `components/icons/YourIcon.tsx`
2. Follow the same structure as `KomposeIcon.tsx`
3. Export it in `components/icons/index.ts`
4. Use it in `app/page.tsx` in the projects array

Example:
```tsx
// components/icons/MyProjectIcon.tsx
'use client'

import React from 'react'

export default function MyProjectIcon({ size = '192px' }) {
  return (
    <svg width={size} height={size}>
      {/* Your SVG content */}
    </svg>
  )
}
```

```tsx
// components/icons/index.ts
export { default as KomposeIcon } from './KomposeIcon'
export { default as MyProjectIcon } from './MyProjectIcon'
```

```tsx
// app/page.tsx
import { KomposeIcon, MyProjectIcon } from '@/components/icons'

const projects = [
  {
    name: 'Kompose',
    icon: KomposeIcon,
    // ...
  },
  {
    name: 'My Project',
    icon: MyProjectIcon,
    // ...
  }
]
```

---

**Need help?** Check the main [README.md](../README.md) or the component source code for more details.
