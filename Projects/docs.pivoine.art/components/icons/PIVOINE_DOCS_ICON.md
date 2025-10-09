# 🌸 Pivoine Docs Icon - Complete Documentation

The official branding icon for the Pivoine Documentation Hub, featuring a beautiful peony flower with integrated documentation elements.

## 🎨 Design Concept

The icon combines two powerful visual metaphors:

1. **Peony Flower (Pivoine)** - Represents the brand identity
   - Multiple layers of petals in purple and pink gradients
   - Symbolizes beauty, elegance, and growth
   - Reflects the "Pivoine" brand name

2. **Documentation Pages** - Represents the hub's purpose
   - Stacked pages in the center of the flower
   - Blue text lines suggesting content
   - Golden center representing knowledge/enlightenment

### Color Palette

```css
/* Primary Petals */
Purple 1:  #a855f7 → #ec4899  /* Violet to pink */
Purple 2:  #9333ea → #db2777  /* Deep purple to rose */
Purple 3:  #c026d3 → #f472b6  /* Fuchsia to pink */

/* Center & Accents */
Golden:    #fbbf24 → #f59e0b → #d97706  /* Warm gold gradient */
Pages:     #f3f4f6 → #e5e7eb  /* Light gray */
Text:      #6366f1, #a855f7  /* Indigo and purple */
Background: #1e293b  /* Dark slate */
```

## 📦 Available Formats

### React Component (Animated)
**File**: `components/icons/PivoineDocsIcon.tsx`
- Full animations (hover, click, orbiting particles)
- Interactive and responsive
- Customizable size and behavior
- For hero sections and prominent displays

### Static SVG Icons
**Files**:
- `public/icon.svg` (256x256) - Full detail, all platforms
- `public/favicon.svg` (32x32 optimized) - Browser tabs

### PNG Icons (Generated)
Generate with: `./scripts/generate-icons.sh`
- `icon-192.png` - PWA icon (Android)
- `icon-512.png` - PWA icon (Android HD)
- `apple-touch-icon.png` - iOS home screen
- `favicon-32x32.png` - Standard favicon
- `favicon-16x16.png` - Small favicon

## 🎭 React Component Usage

### Basic Usage (Hero Area)
```tsx
import { PivoineDocsIcon } from '@/components/icons'

<PivoineDocsIcon size="200px" />
```

### Props

```typescript
interface PivoineDocsIconProps {
  size?: string          // Default: '256px'
  interactive?: boolean  // Default: true
  className?: string     // Additional classes
  showLabel?: boolean    // Default: false - Shows "Pivoine Docs" text
}
```

### Examples

```tsx
// Large hero icon with full interactivity
<PivoineDocsIcon size="256px" showLabel={true} />

// Medium size, interactive
<PivoineDocsIcon size="128px" />

// Small, non-interactive (for cards/lists)
<PivoineDocsIcon size="64px" interactive={false} />

// Custom styling
<PivoineDocsIcon 
  size="180px" 
  className="my-custom-class"
  showLabel={false}
/>
```

## ✨ Animations & Effects

### Default State
- **Flower starts CLOSED** as a tight bud 🌷
  - Outer petals: 30% size, 50% opacity
  - Middle petals: 40% size, 60% opacity
  - Inner petals: 50% size, 70% opacity
- **Subtle pulsing** background circle
- **Twinkling sparkles** at corners
- **Orbiting particles** around the flower
- **Gentle floating** of document pages
- **Text lines** appear with staggered animation

### Hover State (when `interactive={true}`)
- Icon **scales up** and **lifts** (transform 3D)
- **PETALS BLOOM OPEN** to full size! 🌸
  - Smooth 0.8s transition
  - Staggered timing for natural bloom:
    - Outer petals bloom first (0s delay)
    - Middle petals follow (0.05s delay)
    - Inner petals last (0.1s delay)
  - All reach 100% size and full opacity
- Enhanced **shadow and glow** effects
- Center golden circle **glows intensely**
- Sparkles **burst** and expand
- Pages **fan out** slightly with rotation
- Particles **accelerate**

### Click/Tap State
- **3D bounce** with rotation (0-180-360°)
- Petals **explode** outward briefly
- Center **bursts** with glow
- **Ripple effect** emanates from center
- Duration: ~800ms
- Smooth cubic-bezier easing

### Continuous Animations
Even when not hovered:
- Background pulse (4s cycle)
- Sparkle twinkle (2s cycle, staggered)
- Particle orbit (8s rotation, staggered)
- Center pulse (3s cycle)
- Page float (3s gentle movement)
- Text lines draw in on mount

## 📱 Responsive & Accessible

### Responsive Behavior
```css
/* Desktop: Full effects */
@media (min-width: 769px) {
  hover: scale(1.08) translateY(-8px)
}

/* Tablet/Mobile: Reduced scale */
@media (max-width: 768px) {
  hover: scale(1.05) translateY(-4px)
}

/* Touch devices: Active state */
@media (hover: none) and (pointer: coarse) {
  active: scale(0.95)
}
```

### Accessibility
- ✅ **Reduced Motion**: All animations disabled when `prefers-reduced-motion: reduce`
- ✅ **Touch Optimized**: Larger hit areas, optimized tap response
- ✅ **Keyboard Navigation**: Focusable when interactive
- ✅ **Screen Readers**: Appropriate ARIA labels (add as needed)

## 🎯 Integration Points

### 1. Hero Section (Landing Page)
**Location**: `app/page.tsx`
```tsx
<div className="flex justify-center mb-8">
  <PivoineDocsIcon size="200px" showLabel={false} />
</div>
```

### 2. Favicon (Browser Tab)
**Location**: `app/layout.tsx`
```tsx
icons: {
  icon: [
    { url: '/favicon.svg', type: 'image/svg+xml' },
    { url: '/icon.svg', type: 'image/svg+xml', sizes: 'any' },
  ],
}
```

### 3. PWA Manifest
**Location**: `public/manifest.json`
```json
{
  "icons": [
    {
      "src": "/icon.svg",
      "sizes": "any",
      "type": "image/svg+xml"
    },
    {
      "src": "/icon-192.png",
      "sizes": "192x192",
      "type": "image/png"
    },
    {
      "src": "/icon-512.png",
      "sizes": "512x512",
      "type": "image/png"
    }
  ]
}
```

### 4. Apple Touch Icon
**Location**: `app/layout.tsx`
```tsx
icons: {
  apple: [
    { url: '/apple-touch-icon.png', sizes: '180x180' },
  ],
}
```

## 🛠️ Technical Details

### Performance
- **GPU Accelerated**: All animations use CSS transforms
- **Optimized**: Minimal JavaScript, mostly CSS
- **60 FPS**: Smooth on modern devices
- **No External Assets**: Inline SVG, no image loading
- **File Size**: ~10KB component + ~3KB SVG

### Browser Support
- ✅ Chrome/Edge 90+
- ✅ Firefox 88+
- ✅ Safari 14+
- ✅ iOS Safari 14+
- ✅ Chrome Mobile
- ✅ Samsung Internet

### SVG Filters Used
- `feGaussianBlur` - Glow effects
- `feMerge` - Combining blur with original
- `feDropShadow` - Page shadows

### Gradients
- **8 unique gradients** total
- Linear gradients for petals
- Radial gradients for ripple
- Golden gradient for center
- Page gradients for documents

## 📐 Size Guidelines

| Context | Recommended Size | Interactive |
|---------|-----------------|-------------|
| Hero section | 200-256px | Yes |
| Page header | 64-96px | Optional |
| Sidebar | 48-64px | No |
| Favicon | Auto (SVG) | N/A |
| PWA Icon | Auto (PNG) | N/A |
| Avatar/Profile | 40-48px | No |

## 🎨 Customization

### Changing Colors

Edit the gradient definitions in `PivoineDocsIcon.tsx`:

```tsx
<linearGradient id="petal-gradient-1">
  <stop offset="0%" style={{ stopColor: '#YOUR_COLOR' }} />
  <stop offset="100%" style={{ stopColor: '#YOUR_COLOR' }} />
</linearGradient>
```

### Adjusting Animations

Modify keyframes in the `<style jsx>` section:

```css
@keyframes your-custom-animation {
  0% { /* start state */ }
  100% { /* end state */ }
}
```

### Adding New Effects

1. Add new SVG elements to the component
2. Define animations in CSS
3. Apply animations to elements
4. Test hover/click states

## 🚀 Generating PNG Icons

### Prerequisites
Install `librsvg`:
```bash
# macOS
brew install librsvg

# Ubuntu/Debian
sudo apt-get install librsvg2-bin
```

### Generate All Icons
```bash
chmod +x scripts/generate-icons.sh
./scripts/generate-icons.sh
```

This creates:
- icon-192.png (192x192)
- icon-512.png (512x512)
- apple-touch-icon.png (180x180)
- favicon-32x32.png (32x32)
- favicon-16x16.png (16x16)

### Manual Generation
```bash
cd public
rsvg-convert -w 192 -h 192 icon.svg -o icon-192.png
rsvg-convert -w 512 -h 512 icon.svg -o icon-512.png
rsvg-convert -w 180 -h 180 icon.svg -o apple-touch-icon.png
```

## 📝 Usage in Documentation

### Markdown
```markdown
![Pivoine Docs Logo](/icon.svg)
```

### HTML
```html
<img src="/icon.svg" alt="Pivoine Docs" width="64" height="64">
```

### React
```tsx
import { PivoineDocsIcon } from '@/components/icons'
<PivoineDocsIcon size="64px" />
```

## 🎯 Design Philosophy

### Why This Design?

1. **Brand Recognition**: The peony (pivoine) directly represents the brand
2. **Purpose Clarity**: Document pages in center clearly indicate "documentation"
3. **Visual Hierarchy**: Flower draws eye to center (docs)
4. **Modern Aesthetic**: Gradients and effects feel contemporary
5. **Memorable**: Unique design stands out from generic doc icons
6. **Scalable**: Works at all sizes (16px to 512px+)
7. **Thematic**: Matches the purple/pink theme of the landing page

### Symbolism

- **Petals**: Multiple layers represent comprehensive documentation
- **Colors**: Purple/pink for creativity and accessibility
- **Golden Center**: Knowledge and enlightenment
- **Pages**: Clear representation of documentation
- **Bloom Animation**: Growth and expanding knowledge
- **Particles**: Dynamic, always-evolving content

## 🐛 Troubleshooting

### Icon Not Showing
```bash
# Clear Next.js cache
rm -rf .next
pnpm dev
```

### Animations Not Working
- Check browser support for SVG filters
- Verify no conflicting CSS
- Check `prefers-reduced-motion` setting

### PNG Icons Not Generating
```bash
# Check if rsvg-convert is installed
which rsvg-convert

# If not, install librsvg
brew install librsvg  # macOS
```

### Performance Issues
- Use `interactive={false}` for multiple icons
- Reduce size for better performance
- Consider static SVG for lists/grids

## 📊 File Structure

```
docs.pivoine.art/
├── components/
│   └── icons/
│       ├── PivoineDocsIcon.tsx  # React component
│       ├── KomposeIcon.tsx      # Other icons
│       └── index.ts             # Exports
├── public/
│   ├── icon.svg                 # Full detail SVG
│   ├── favicon.svg              # Simplified for small sizes
│   ├── manifest.json            # PWA manifest
│   ├── icon-192.png             # Generated
│   ├── icon-512.png             # Generated
│   └── apple-touch-icon.png     # Generated
├── scripts/
│   └── generate-icons.sh        # PNG generation script
└── app/
    ├── layout.tsx               # Icon metadata
    └── page.tsx                 # Icon usage
```

## 🎉 Credits

- **Design**: Custom peony + documentation hybrid
- **Colors**: Tailwind CSS palette (purple, pink, gold)
- **Animations**: CSS keyframes + React hooks
- **Inspiration**: Nature (peony flower) + technology (docs)

## 📚 Related Documentation

- [components/README.md](../README.md) - Component usage guide
- [components/icons/SHOWCASE.md](./SHOWCASE.md) - KomposeIcon example
- [README.md](../../README.md) - Main project documentation

---

**Created with care for Valknar** | [pivoine.art](http://pivoine.art)

*A peony in full bloom, with knowledge at its heart* 🌸📚
