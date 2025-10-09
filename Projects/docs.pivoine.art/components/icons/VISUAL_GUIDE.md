# Pivoine Docs Icon - Visual Animation Guide

## 🎬 Animation State Visualization

### State 1: NORMAL (Idle Breathing)

```
         ✨
      🌸 · 🌸
    🌸   📄   🌸      ← Petals in semi-closed bud
      🌸 ⭐ 🌸            Gentle breathing motion
         🌸            Soft sparkle twinkling
      ✨     ✨         Rotating stamens in center
```

**Characteristics:**
- Petals: `scale(0.3-0.35)` - small, closed
- Center: Gentle pulsing (1.0x → 1.08x)
- Animation: 6-second loop
- Effect: Peaceful, living blossom

---

### State 2: HOVER (Full Bloom)

```
       ✨ · * · ✨
    *🌸    *    🌸*
  🌸  *  ⭐📄⭐  *  🌸    ← Petals fully opened
    *🌸  *  *  🌸*        Bloom particles flying
  🌸  *    *    *  🌸      Enhanced center glow
    *🌸    *    🌸*        Sparkles bursting
      🌸  *  🌸
       ✨ * ✨
```

**Characteristics:**
- Petals: `scale(1.0-1.1)` - fully extended
- Center: `scale(1.3-1.5)` - enlarged with intense glow
- Particles: 12 bloom particles orbiting
- Effect: Majestic, fully bloomed flower

**Animation Flow:**
```
T=0.0s: Mouse enters
T=0.1s: Outer petals start opening
T=0.2s: Middle petals follow
T=0.3s: Inner petals open + particles appear
T=0.5s: Center begins growing
T=0.8s: Full bloom achieved
T=1.0s+: Continuous pulsing animation
```

---

### State 3: CLICK (Closing)

```
T=0.0s (Start):        T=0.6s (Mid):         T=1.2s (End):
    🌸 🌸 🌸               🌸 🌸 🌸               
  🌸  ⭐  🌸    →       🌸  ⭐  🌸    →         ✨
    🌸 🌸 🌸             🌸 ⭐ 🌸              🌸 ⭐ 🌸
                          ✨                    ✨

  Full bloom            Closing              Closed bud
  Particles burst       Particles fade       Normal state
```

**Characteristics:**
- Duration: 1.2 seconds
- Petals: Smoothly scale down and translate inward
- Particles: Burst outward then disappear
- Center: Contracts with elastic bounce
- Effect: Elegant closing with satisfying feedback

**Animation Curve:**
```
cubic-bezier(0.68, -0.55, 0.27, 1.55)

Scale ^
  1.0 |    ╱‾‾╲
      |   ╱    ╲___
      |  ╱         ╲
  0.3 | ╱           ╲___
      |─────────────────→ Time
      0s   0.6s     1.2s

Elastic bounce-back effect
```

---

## 🎨 Layer Structure (Z-Index)

```
┌─────────────────────────────────────┐
│  Layer 8: Bloom Particles (hover)   │  opacity: 0 → 0.7
├─────────────────────────────────────┤
│  Layer 7: Sparkles                  │  Fixed positions, twinkling
├─────────────────────────────────────┤
│  Layer 6: Center Inner (light)      │  r=18, light gradient
├─────────────────────────────────────┤
│  Layer 5: Center Outer (golden)     │  r=26, main center
├─────────────────────────────────────┤
│  Layer 4: Center Stamens            │  8 small dots, rotating
├─────────────────────────────────────┤
│  Layer 3: Document Pages            │  3 stacked rectangles
├─────────────────────────────────────┤
│  Layer 2: Petals (3 sub-layers)     │
│    - Inner (10 petals)              │
│    - Middle (8 petals)              │
│    - Outer (8 petals)               │
├─────────────────────────────────────┤
│  Layer 1: Background Glow           │  Subtle radial gradient
└─────────────────────────────────────┘
```

---

## 💫 Particle Movement Patterns

### Normal State: No Particles

### Hover State: 12 Particles Flying

```
Particle positions at different angles:

      P1 (0°)
       ↑
       |
P4 ←--( • )--→ P2    Center
       |          
       ↓
      P3 (180°)

Each particle:
- Starts at center (opacity: 0)
- Moves outward along its angle
- Reaches max distance (80-100px)
- Fades out at edges
- Duration: 3s loop
```

**Particle Pattern:**
```
Angular distribution (12 particles):
  0°, 30°, 60°, 90°, 120°, 150°, 
180°, 210°, 240°, 270°, 300°, 330°

Staggered delays:
Each particle offset by 0.08s
Creates smooth orbital effect
```

### Click State: Burst Pattern

```
        ▪ ← P1 (fast)
    ▪       ▪
  ▪    ( • )    ▪ ← Particles explode
    ▪       ▪        outward 2x speed
        ▪ ← then fade

Burst sequence:
0.0s: Particles at normal hover positions
0.3s: Particles shoot outward (2x distance)
0.6s: Particles start fading
1.2s: Particles invisible
```

---

## 🎯 Center Animation Detail

### Normal State:
```
   ╭─────╮
  │  ⭐⭐  │  ← Stamens rotating
  │ ⭐📄⭐ │  ← Golden outer ring
  │  ⭐⭐  │  ← Light inner core
   ╰─────╯
   
Outer: r=26, breathing 1.0x → 1.08x
Inner: r=18, breathing 1.0x → 1.12x
Stamens: 20s continuous rotation
```

### Hover State:
```
    ╭────────╮
   │  ⭐ ⭐  │
  │ ⭐ 📄 ⭐ │  ← Center expands
  │  ⭐ ⭐  │  ← Enhanced glow
   │ ✨ ✨ ✨│  ← Intense lighting
    ╰────────╯

Outer: r=26 → r=39 (1.5x scale)
Inner: r=18 → r=28.8 (1.6x scale)
Stamens: Dance up and down
Glow: intense-glow filter applied
```

### Click State:
```
  ╭─────╮ → ╭───╮ → ╭─────╮
  │ ⭐📄⭐│   │⭐📄⭐│   │ ⭐📄⭐│
  ╰─────╯   ╰───╯   ╰─────╯
  
   1.3x   →  0.8x  →   1.0x
  (hover)   (contract) (normal)
  
Elastic bounce-back animation
```

---

## 🌈 Color Transition Map

### Petal Gradients (Radial):

```
Gradient 1 (Pink):
  #fce7f3 (light pink) → #fbcfe8 → #f9a8d4 → #ec4899 (hot pink)
  █████████▓▓▓▓▓▓▓▓▒▒▒▒▒▒░░░░

Gradient 2 (Purple):
  #fae8ff (lavender) → #f3e8ff → #e9d5ff → #c084fc (purple)
  █████████▓▓▓▓▓▓▓▓▒▒▒▒▒▒░░░░

Gradient 3 (Magenta):
  #fdf4ff (near white) → #fae8ff → #f0abfc → #d946ef (magenta)
  █████████▓▓▓▓▓▓▓▓▒▒▒▒▒▒░░░░

Gradient 4 (Rose):
  #fce7f3 (light pink) → #fda4af → #fb7185 → #f43f5e (rose)
  █████████▓▓▓▓▓▓▓▓▒▒▒▒▒▒░░░░
```

### Center Gradients (Radial):

```
Golden Outer:
  #fef3c7 (cream) → #fde68a → #fbbf24 → #f59e0b (amber)
  ████████▓▓▓▓▓▓▒▒▒▒░░░░

Light Inner:
  #fffbeb (pale yellow) → #fef3c7 → #fde68a (golden)
  ████████▓▓▓▓░░░░

Stamens:
  #d97706 (dark amber) - solid color
  ████████
```

---

## ⚡ Performance Characteristics

### Frame Rate Target: 60 FPS

```
Animation Layer        CPU Cost    GPU Cost
───────────────────────────────────────────
Background Glow        █░░░░       ██░░░
Outer Petals (8)       ██░░░       ████░
Middle Petals (8)      ██░░░       ████░
Inner Petals (10)      ██░░░       ████░
Center (2 circles)     █░░░░       ███░░
Stamens (8)            █░░░░       ██░░░
Sparkles (8)           █░░░░       ██░░░
Particles (12)         ██░░░       ████░
Glow Filters           █░░░░       █████
───────────────────────────────────────────
Total (Hover)          ███░░       ████░

█ = 20% utilization
```

### Optimization Strategies:

1. **Transform & Opacity Only**
   - No layout-triggering properties
   - Hardware accelerated
   
2. **Will-Change Applied**
   - `will-change: transform, opacity`
   - GPU layer creation
   
3. **Staggered Animation**
   - Spreads CPU load over time
   - Smoother visual perception

---

## 📐 Geometric Calculations

### Petal Position Formula:
```javascript
For petal at angle θ:
x = centerX + cos(θ) * distance
y = centerY + sin(θ) * distance

Outer petals: distance = 38px (hover)
Middle petals: distance = 26px (hover)
Inner petals: distance = 16px (hover)
```

### Particle Trajectory:
```javascript
// Hover animation
translate(
  cos(angle) * maxDistance,
  sin(angle) * maxDistance
)

// Click burst
translate(
  cos(angle) * maxDistance * 2,
  sin(angle) * maxDistance * 2
)
```

---

## 🎭 State Transition Diagram

```
                    ┌──────────────┐
                    │   NORMAL     │
                    │ (Breathing)  │
                    └───────┬──────┘
                            │
                Mouse Enter │ Mouse Leave
                            │      ↓
                    ┌───────▼──────┐
                    │    HOVER     │
              ┌────▶│ (Full Bloom) │◀────┐
              │     └───────┬──────┘     │
              │             │            │
    Click ends│        Click│            │ Hover maintains
              │             │            │
              │     ┌───────▼──────┐     │
              └─────│    CLICK     │─────┘
                    │  (Closing)   │
                    └──────────────┘
                          │
                   After 1.2s
                          │
                          ▼
                    Return to NORMAL
```

---

## 💡 Design Philosophy

### Visual Hierarchy:
1. **Center (Focal Point)**: Documentation pages = purpose
2. **Petals (Beauty)**: Organic, natural flower form
3. **Particles (Magic)**: Dynamic, alive feeling
4. **Sparkles (Polish)**: Finishing touch of elegance

### Animation Principles:
- **Anticipation**: Slight scale-down before bloom
- **Follow-through**: Elastic bounce on close
- **Staging**: Staggered petal animation
- **Timing**: Slower start, faster middle, slower end
- **Secondary Motion**: Particles enhance main animation

### Color Psychology:
- **Pink/Purple**: Creative, artistic, documentation
- **Golden Center**: Knowledge, enlightenment
- **Gradient Flow**: Natural, organic, alive

---

**Visual Guide Version**: 1.0  
**Last Updated**: October 2025

For implementation details, see `REFACTORING_SUMMARY.md`  
For usage examples, see `README.md`
