# PR #2 Visual Guide - UI Flow and Features

## Navigation Flow

```
App Launch
    ↓
┌─────────────────────────┐
│   RunSelectionView      │
│                         │
│  ♾️ Kardashev          │
│  Le Tue Run             │
│                         │
│  [+ NUOVA RUN]          │
│                         │
│  Filters: [All] Active  │
│           Completed     │
│           Failed        │
│                         │
│  Sort: [Date] Score     │
│        Difficulty       │
│                         │
│  ┌─────────────────┐   │
│  │ RunCard 1       │   │ ← Tap to continue
│  │ ⭐⭐⭐ Medium    │   │
│  └─────────────────┘   │
│  ┌─────────────────┐   │
│  │ RunCard 2       │   │
│  │ ⭐⭐⭐⭐ Hard    │   │
│  └─────────────────┘   │
└─────────────────────────┘
    ↓ Tap [+ NUOVA RUN]
┌─────────────────────────┐
│   NewRunView (Modal)    │
│                         │
│   🌍 (Animated)         │
│   Terra-Prime-XY42      │
│   Temperato             │
│   ⭐⭐⭐ Medium (1.0x) │
│                         │
│  Parametri Planetari:   │
│  ☀️ Solare    ████ 85% │
│  💧 Acqua     ███  65%  │
│  💨 Vento     █████ 95% │
│  🔥 Geoterm.  ██   45%  │
│  ⛏️ Minerali  ███  70%  │
│  🌿 Biodiv.   ████ 80%  │
│                         │
│  ⚠️ Disastri     35%    │
│  ☠️ Tossicità   20%     │
│  👾 Vita Ostile: No     │
│                         │
│  [INIZIA RUN]           │
│  [RIGENERA] [SEED]      │
│  [ANNULLA]              │
└─────────────────────────┘
    ↓ Tap [INIZIA RUN]
┌─────────────────────────┐
│      GameView           │
│                         │
│ [← RUNS]    SCORE: 1250│
│             ⚡ 15.2K    │
│                         │
│    (SpriteKit Scene)    │
│       🌍 Earth          │
│      Rotating           │
│                         │
│                         │
│                         │
│  Tipo I - Civiltà       │
│  Planetaria             │
│  [📊] [🛒]             │
└─────────────────────────┘
    ↓ Tap [← RUNS]
    Back to RunSelectionView
```

## RunCard Component (Balatro Style)

```
┌─────────────────────────────────────┐
│ Gradient Background (Planet Color)  │
│ ┌─────┐                             │
│ │ 🌍  │  Terra-Prime-XY42        🟢 │
│ │Blue │  Seed: 4297183924      Attiva│
│ └─────┘                             │
│ ────────────────────────────────────│
│  ⚡️ 1,250    🎯 Tipo I    ⏱ 2h 35m│
│   Score      Stage        Tempo     │
│                                     │
│  Progresso              [████░░] 75%│
│                                     │
│  ⭐⭐⭐ Medium                      │
└─────────────────────────────────────┘
```

### Card Color Variations by Terrain

**Temperato (Green):**
- Gradient: Green → Dark Green
- Icon: 🌍
- Feels: Natural, balanced

**Oceanico (Blue):**
- Gradient: Blue → Navy
- Icon: 🌊
- Feels: Water-rich, calm

**Desertico (Orange):**
- Gradient: Orange → Dark Orange
- Icon: 🏜️
- Feels: Arid, challenging

**Ghiacciato (Cyan):**
- Gradient: Cyan → Ice Blue
- Icon: 🧊
- Feels: Cold, harsh

**Vulcanico (Red):**
- Gradient: Red → Dark Red
- Icon: 🌋
- Feels: Hot, dangerous

**Tossico (Purple):**
- Gradient: Purple → Dark Purple
- Icon: ☠️
- Feels: Hazardous, hostile

**Paradiso (Pink):**
- Gradient: Pink → Rose
- Icon: 🌺
- Feels: Ideal, easy

## Status Indicators

### Run Status Badges
```
🟢 Attiva       - In progress, can be played
✅ Completata   - Victory achieved
💀 Game Over    - Run failed
```

### Difficulty Badges
```
⭐ Molto Facile     (0.5x score)
⭐⭐ Facile         (0.75x score)
⭐⭐⭐ Medio         (1.0x score)
⭐⭐⭐⭐ Difficile   (1.5x score)
⭐⭐⭐⭐⭐ Molto Difficile (2.0x score)
💀 Incubo           (3.0x score)
```

### Resource Parameter Bars

```
Qualitative Ratings:
████████████████████ (95-100%) Eccellente (Green)
███████████████      (75-94%)  Buono      (Light Green)
██████████           (60-74%)  Normale    (Yellow)
█████                (40-59%)  Basso      (Orange)
██                   (0-39%)   Scarso     (Red)
```

## Planet Preview Animation

```
NewRunView Planet Display:

Frame 1:
    🌍
   ╱ ╲    ← Glow effect
  ╱   ╲      (atmosphere color)
 ╱     ╲
└───────┘

Scale Animation:
Normal (1.0) → Generating (0.9) → Normal (1.0)
Duration: 0.3s ease-in-out

Rotation (Future Enhancement):
Slow 360° rotation over 20s
```

## Filter & Sort Controls

```
Filters (Horizontal Pills):
[Tutte] [Attive] [Completate] [Fallite]
  ^Blue   Gray     Gray        Gray

When selected: Blue background + Bold text
When unselected: Dark gray background + Normal text

Sort (Segmented Control):
┌──────┬───────┬───────────┐
│ Data │ Score │ Difficoltà │
└──────┴───────┴───────────┘
   ^Selected (highlighted)
```

## Empty State

```
┌─────────────────────────┐
│                         │
│         🌍              │
│      (Large)            │
│                         │
│   Nessuna Run           │
│                         │
│  Crea la tua prima run  │
│  per iniziare           │
│  l'avventura verso      │
│  la Tipo III!           │
│                         │
│  [Crea Prima Run]       │
│                         │
└─────────────────────────┘
```

## RunStatsView Layout

```
┌─────────────────────────────────────┐
│            🌍 (Large)               │
│        Terra-Prime-XY42             │
│         Seed: 4297183924            │
│    [🟢 In Corso] [⭐⭐⭐ Medio]    │
│                                     │
│ ┌─────────────────────────────────┐│
│ │ Score                           ││
│ │ Score Totale          1,250     ││
│ │ ─────────────────────────────── ││
│ │ Stage Progress          1,000   ││
│ │ Difficulty Bonus          250   ││
│ └─────────────────────────────────┘│
│                                     │
│ ┌─────────────────────────────────┐│
│ │ Statistiche                     ││
│ │ ⏱ Tempo Giocato        2h 35m   ││
│ │ 🖱 Click Totali          1,234   ││
│ │ ⚡️ Energia Generata     15.2K   ││
│ │ 🏗 Edifici Acquistati       42   ││
│ │ 🎯 Stage Corrente      Tipo I    ││
│ └─────────────────────────────────┘│
│                                     │
│ ┌─────────────────────────────────┐│
│ │ Parametri Planetari             ││
│ │ ☀️ Energia Solare  85% Buono    ││
│ │ 💧 Acqua           65% Normale  ││
│ │ 💨 Vento           95% Eccellente││
│ │ 🔥 Geotermico      45% Basso    ││
│ │ ⛏️ Minerali        70% Buono     ││
│ │ 🌿 Biodiversità    80% Buono    ││
│ └─────────────────────────────────┘│
│                                     │
│              [Chiudi]               │
└─────────────────────────────────────┘
```

## GameView Score Display

```
Top Bar Layout:

[← RUNS]    [Empty Space]    SCORE: 1,250    ⚡ 15.2K    [📊][🛒]
                                    ^New           ^Existing
                              Semi-transparent black background
```

## Color Palette

### Brand Colors
- Background: `#0D0D26` (Very Dark Blue)
- Primary: `#3399FF` (Bright Blue)
- Secondary: `#CC66FF` (Purple)
- Accent: `#FFCC33` (Gold)
- Success: `#33CC66` (Green)
- Danger: `#FF5533` (Red)

### Planet Colors
- Temperate: `#4A7C59` - `#6B9B6B` (Greens)
- Oceanic: `#1E3A8A` - `#3B82F6` (Blues)
- Desert: `#D97706` - `#FBBF24` (Oranges)
- Frozen: `#DBEAFE` - `#93C5FD` (Ice Blues)
- Volcanic: `#7F1D1D` - `#B91C1C` (Reds)
- Toxic: `#581C87` - `#7C3AED` (Purples)
- Paradise: `#DB2777` - `#F472B6` (Pinks)

### Atmosphere Colors
- Normal: `#60A5FA` (Light Blue)
- Toxic: `#A78BFA` (Light Purple)

## Typography

### Fonts
- Headers: System Bold, 24-36pt
- Body: System Regular, 14-16pt
- Stats: System Semibold, 14pt
- Labels: System Medium, 12pt
- Small: System Regular, 10-12pt

### Hierarchy
```
Page Title        → 36pt Bold
Section Header    → 24pt Bold
Card Title        → 18pt Bold
Body Text         → 16pt Regular
Stat Value        → 16pt Semibold
Label             → 14pt Medium
Caption           → 12pt Regular
```

## Animations

### Transitions
- Screen transitions: 0.3s ease-in-out
- Card appearance: Slide up + fade in
- Score updates: Number count animation
- Button press: Scale 0.95 + haptic

### Loading States
- Planet generation: Scale pulse (0.9-1.0)
- Data loading: Spinner + message
- Save operation: Brief flash

### Gestures
- Tap: Standard UIKit behavior
- Long press: Context menu (0.5s delay)
- Swipe: Dismiss modals
- Scroll: Natural iOS scroll physics

## Responsive Design

### iPhone (Portrait)
- Single column layout
- Full-width cards
- Bottom sheet modals
- Safe area respected

### iPad (All Orientations)
- Two-column layout option
- Floating modals (centered)
- More visible cards
- Larger planet previews

## Accessibility

### VoiceOver Labels
- Run cards: "Planet [name], Difficulty [level], Score [value]"
- Buttons: Clear action names
- Stats: "Label: Value"

### Dynamic Type
- All text scales with system settings
- Minimum touch targets: 44x44pt
- High contrast support

### Color Contrast
- Text on backgrounds: WCAG AA minimum
- Important info: WCAG AAA preferred
- Alternative indicators beyond color

## Performance

### Rendering
- LazyVStack for run list
- Image caching for icons
- GPU-accelerated animations
- 60 FPS target

### Memory
- Efficient GameState storage
- JSON encoding for saves
- No memory leaks (weak references)

## Future UI Enhancements

### Considered for Later
- 3D planet rendering (SceneKit)
- Particle effects on cards
- Sound effects
- Haptic feedback patterns
- Animated transitions between stages
- Planet rotation in preview
- Constellation backgrounds
- Comet trails
- Achievement popups
- Stat comparison graphs
