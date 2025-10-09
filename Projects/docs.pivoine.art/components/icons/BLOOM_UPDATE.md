# 🌸 Pivoine Docs Icon - Closed/Open States Update

## ✨ New Behavior: Closed → Open on Hover

The Pivoine Docs Icon now features a beautiful **blooming animation**!

### Initial State: CLOSED 🌷
- Petals start **small and close to the center**
- Outer petals: 30% size, 50% opacity
- Middle petals: 40% size, 60% opacity  
- Inner petals: 50% size, 70% opacity
- Flower appears as a **tight bud**

### Hover State: OPEN 🌸
- Petals **bloom outward** to full size
- Smooth 0.8s cubic-bezier transition
- Staggered timing for natural bloom:
  - Outer petals bloom first
  - Middle petals follow (0.05s delay)
  - Inner petals last (0.1s delay)
- All petals reach 100% size and full opacity
- Enhanced glow effects activate

### Visual Effect
```
Closed (default):      Hover (blooming):       Click (burst):
    🌷          →           🌸            →          ✨
   (bud)              (full bloom)            (explosion)
```

## 🎯 States Comparison

| State | Outer Petals | Middle Petals | Inner Petals | Effect |
|-------|-------------|---------------|--------------|--------|
| **Closed (default)** | 30% scale | 40% scale | 50% scale | Tight bud |
| **Non-interactive** | 85% scale | 88% scale | 90% scale | Slightly open |
| **Hover (bloom)** | 100% scale | 100% scale | 100% scale | Full bloom |
| **Click (burst)** | 130% scale | 130% scale | 130% scale | Explosion |

## 🎨 Animation Details

### Timing
- **Transition duration**: 0.8s
- **Easing**: cubic-bezier(0.34, 1.56, 0.64, 1) - bouncy bloom
- **Stagger delays**: 0s → 0.05s → 0.1s (outer to inner)

### Visual Changes
**Closed State:**
- Petals scaled down and condensed
- Reduced opacity for depth
- Documents still visible in center
- Sparkles still twinkling
- Subtle animations continue

**Open State (Hover):**
- Petals expand to natural size
- Full opacity and glow
- Enhanced shadow effects
- Center glows brightly
- All animations intensify

## 💡 Why This Works

1. **Metaphor**: Represents knowledge "blooming" as you explore
2. **Engagement**: Invites interaction through visual curiosity
3. **Delight**: Satisfying transformation surprises users
4. **Natural**: Mimics real flower behavior
5. **Smooth**: Staggered timing feels organic

## 📝 Code Changes

### Before (Always Open)
```css
.petal {
  transform: scale(1);
  opacity: 0.85;
}
```

### After (Closed → Open)
```css
/* Closed by default */
.outer-petal {
  transform: scale(0.3);
  opacity: 0.5;
}

/* Open on hover */
.is-interactive:hover .outer-petal {
  transform: scale(1);
  opacity: 0.85;
}
```

## 🎭 Usage Notes

### Interactive Mode (Default)
- Starts **closed** (tight bud)
- **Opens on hover** (full bloom)
- Click for burst effect
- Returns to closed on mouse leave

### Non-Interactive Mode
- Starts **slightly open** (85-90% size)
- Static, no hover effects
- Better for cards/lists where you want visibility
- Still shows the beautiful design

### Example Usage
```tsx
// Interactive - starts closed, blooms on hover
<PivoineDocsIcon size="200px" />

// Non-interactive - slightly open, static
<PivoineDocsIcon size="64px" interactive={false} />
```

## ✨ Benefits

✅ **More engaging** - Invites user interaction  
✅ **Metaphorical** - "Knowledge blooms" as you explore  
✅ **Delightful** - Surprising transformation creates joy  
✅ **Natural** - Follows real flower blooming behavior  
✅ **Smooth** - Staggered animation feels organic  
✅ **Accessible** - Reduced motion users see semi-open state  

## 🎬 Animation Timeline

```
Time    Event
────────────────────────────────────
0.0s    Mouse enters → bloom starts
0.0s    Outer petals begin expanding
0.05s   Middle petals begin expanding  
0.1s    Inner petals begin expanding
0.8s    All petals fully bloomed
        (continuous hover animations)
────    Mouse leaves → petals close
0.8s    Back to closed bud state
```

## 🎨 Visual States

### 1. Initial Load (Closed)
```
     •
   • • •
  •  🗎  •
   • • •
     •
   (bud)
```

### 2. Hover Start (Blooming)
```
    • •
  •   •   •
 •    🗎    •
  •   •   •
    • •
 (opening)
```

### 3. Fully Bloomed
```
  •   •   •
 •    •    •
•     🗎     •
 •    •    •
  •   •   •
  (bloom!)
```

### 4. Click (Burst)
```
 •     •     •
   •   •   •
•    ✨🗎✨    •
   •   •   •
 •     •     •
  (explode!)
```

## 🔧 Customization

Want to adjust the closed/open states?

### Change Initial Size (Closed State)
```css
.outer-petal {
  transform: scale(0.3);  /* 0 = fully closed, 1 = fully open */
}
```

### Adjust Bloom Speed
```css
.outer-petal {
  transition: all 0.8s;  /* Make faster: 0.4s, slower: 1.2s */
}
```

### Modify Stagger Timing
```css
.outer-petal { transition-delay: 0s; }
.middle-petal { transition-delay: 0.05s; }  /* Adjust these */
.inner-petal { transition-delay: 0.1s; }
```

## 📱 Responsive Behavior

### Desktop
- Full bloom animation on hover
- Smooth 0.8s transition
- Staggered petal opening

### Mobile/Touch
- Tap to trigger bloom
- Automatic return to closed after interaction
- Optimized touch targets

### Reduced Motion
- Shows in semi-open state (85-90%)
- No animations
- Static display
- Still beautiful and clear

## 🎯 Perfect For

✅ Hero sections - dramatic entrance effect  
✅ Landing pages - engaging first impression  
✅ About pages - tells a story  
✅ Portfolio sites - shows attention to detail  
✅ Documentation hubs - "knowledge blooming"  

## 🚀 See It In Action

```bash
pnpm dev
```

Visit http://localhost:3000 and:
1. **See the closed bud** on page load
2. **Hover over icon** to watch it bloom open
3. **Move mouse away** to see it close again
4. **Click** for burst effect
5. **Enjoy** the smooth, natural animation!

---

**Updated for Valknar** | [pivoine.art](http://pivoine.art)

*From bud to bloom - knowledge opens up* 🌷→🌸
