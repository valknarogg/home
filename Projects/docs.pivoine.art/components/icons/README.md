# Pivoine Docs Icon - Beautiful Animated Peony Blossom

A stunning, fully animated peony blossom icon component with smooth transitions, particle effects, and interactive states. Perfect for use as an app icon, favicon, PWA icon, or as a decorative element in your documentation.

## ✨ Features

### 🌸 Beautiful Peony Design
- Realistic multi-layered petal structure (outer, middle, inner layers)
- Natural gradient colors transitioning from pink to purple
- Golden center representing documentation pages
- Optimized for use at any size (favicon to full-screen)

### 🎭 Three Animation States

#### 1. **Normal State - Gentle Breathing**
- Petals gently pulsate in a closed bud position
- Soft sparkle twinkle effect
- Rotating stamens in the center
- Smooth breathing animation loop (6s cycle)
- Background subtle glow pulse

#### 2. **Hover State - Full Bloom**
- Petals smoothly open outward in a beautiful blooming motion
- **12 bloom particles** fly around the blossom in organic patterns
- Center grows and glows intensely with enhanced lighting
- Sparkles burst with energy
- Enhanced drop shadow and glow effects
- Continuous subtle pulsing while hovering

#### 3. **Click State - Smooth Closing**
- Petals elegantly close back to bud position
- Bloom particles burst outward then dissipate
- Icon bounces with satisfying feedback
- Center contracts smoothly
- Sparkles implode toward center
- Returns to normal state after animation (1.2s)

## 🎨 Usage

### Basic Usage

```tsx
import PivoineDocsIcon from '@/components/icons/PivoineDocsIcon'

// Default interactive icon
<PivoineDocsIcon size="256px" />

// With label
<PivoineDocsIcon size="200px" showLabel />

// Static (non-interactive)
<PivoineDocsIcon size="128px" interactive={false} />

// Custom styling
<PivoineDocsIcon 
  size="300px" 
  className="my-custom-class"
  interactive={true}
  showLabel={true}
/>
```

### Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `size` | `string` | `'256px'` | Size of the icon (CSS value) |
| `interactive` | `boolean` | `true` | Enable hover and click interactions |
| `className` | `string` | `''` | Additional CSS classes |
| `showLabel` | `boolean` | `false` | Show "Pivoine Docs" label below icon |

### As Favicon

```html
<!-- In your HTML head -->
<link rel="icon" type="image/svg+xml" href="/path/to/pivoine-icon.svg">
```

To export as static SVG for favicon:
1. Set `interactive={false}` to show the semi-open bloom state
2. The icon will display beautifully without animations
3. Use at 32x32, 64x64, or 128x128 for favicons

### As PWA Icon

Generate PNG versions at standard PWA sizes:
- 192x192px
- 512x512px
- 180x180px (Apple touch icon)
- 96x96px, 144x144px, etc.

The icon's semi-open bloom state (`interactive={false}`) is perfect for static PWA icons.

## 🎯 Animation Details

### Normal State Loop
- **Duration**: 6 seconds
- **Easing**: ease-in-out
- **Effect**: Gentle breathing/pulsing
- **Petals**: Subtle scale and translate animation
- **Center**: Soft pulsating glow
- **Sparkles**: Twinkling at different intervals

### Hover Bloom
- **Duration**: 1-2 seconds transition + continuous subtle animation
- **Easing**: cubic-bezier(0.34, 1.56, 0.64, 1) for smooth bounce
- **Petal Opening**: 
  - Outer: scale(1.1) + translateX(38px)
  - Middle: scale(1.05) + translateX(26px)
  - Inner: scale(1) + translateX(16px)
- **Particles**: 12 particles in circular pattern
- **Center Scale**: 1.3x → 1.5x
- **Glow**: Intense filter effects applied

### Click Close
- **Duration**: 1.2 seconds
- **Easing**: cubic-bezier(0.68, -0.55, 0.27, 1.55) for elastic feel
- **Petal Closing**: Reverse bloom with overshoot
- **Particles**: Burst outward then fade
- **Center**: Contract with bounce
- **Icon**: Subtle press and pulse effect

## 🎨 Color Palette

The icon uses a natural peony color scheme:

### Petals
- Light pink: `#fce7f3` → `#ec4899`
- Purple: `#fae8ff` → `#c084fc`
- Magenta: `#fdf4ff` → `#d946ef`
- Rose: `#fce7f3` → `#f43f5e`

### Center (Stamen)
- Outer: `#fef3c7` → `#fbbf24` → `#f59e0b`
- Inner: `#fffbeb` → `#fef3c7` → `#fde68a`
- Stamens: `#d97706`

### Accents
- Sparkles: Various from the petal palette + gold
- Glow effects: Soft radial blur with 50% opacity

## ♿ Accessibility

### Reduced Motion Support
The component respects `prefers-reduced-motion: reduce`:
- All animations are disabled
- Petals shown in beautiful semi-open state
- Smooth opacity/transform transitions only
- Bloom particles hidden
- Full functionality maintained

### Touch Device Optimization
On touch devices:
- Shows semi-open bloom by default
- Enhanced touch feedback on press
- Optimized hover state for touch
- Smooth transitions without complex animations

### High Performance Mode
For devices with `prefers-reduced-data: reduce`:
- Particle effects disabled
- Drop shadows removed
- Core functionality preserved

## 📱 Responsive Design

The icon automatically adjusts for different screen sizes:

### Desktop (>768px)
- Full animation effects
- Maximum petal spread on hover
- All particle effects visible

### Mobile (≤768px)
- Slightly reduced petal spread
- Optimized animation performance
- Touch-friendly interaction

## 🎭 State Classes

The component uses these CSS classes for styling:

- `.is-interactive` - Interactive mode enabled
- `.is-hovered` - Mouse hovering over icon
- `.is-clicked` - Click animation active

You can target these for custom styling:

```css
.pivoine-docs-icon-wrapper.is-hovered {
  /* Your hover styles */
}
```

## 🔧 Customization

### Change Colors

Edit the gradient definitions in the TSX file:

```tsx
<radialGradient id="petal-gradient-1">
  <stop offset="0%" style={{ stopColor: '#your-color' }} />
  {/* ... */}
</radialGradient>
```

### Adjust Animation Speed

Modify animation durations in CSS:

```css
.outer-petal {
  animation: petal-breathe 6s ease-in-out infinite; /* Change 6s */
}
```

### Add More Particles

In the TSX, increase the array size:

```tsx
const bloomParticles = Array.from({ length: 20 }, (_, i) => ({
  // Increase from 12 to 20
  // ...
}))
```

## 🚀 Performance

- Uses CSS transforms and opacity for GPU acceleration
- SVG-based for crisp rendering at any size
- Efficient particle system (only visible on hover)
- Optimized animation timing functions
- No JavaScript animation loops (CSS-based)
- Minimal re-renders (React.useState only for interaction states)

## 📦 File Structure

```
components/icons/
├── PivoineDocsIcon.tsx  # React component
├── PivoineDocsIcon.css  # All animations and styles
└── README.md           # This file
```

## 🐛 Browser Support

- Chrome/Edge: Full support
- Firefox: Full support
- Safari: Full support
- Mobile browsers: Full support with touch optimization

## 📄 License

Part of the Pivoine documentation project.

## 🎉 Tips

1. **For Favicons**: Use `interactive={false}` for a clean, non-animated version
2. **Loading States**: The icon works great as a loading spinner
3. **Hero Section**: Place at large size (400-600px) for impressive visual impact
4. **Documentation Pages**: Use small (64-128px) in headers or as page decorations
5. **Custom Events**: Add onClick handler for custom interactions

---

Made with 🌸 for beautiful documentation experiences.
