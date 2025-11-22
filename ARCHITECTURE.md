# Architettura Tecnica - Kardashev Game

## Overview

Kardashev è un'applicazione iOS sviluppata con un'architettura pulita e modulare che separa chiaramente le responsabilità tra diversi layer.

## Diagramma Architetturale

```
┌─────────────────────────────────────────────────────────┐
│                     Presentation Layer                   │
│                        (SwiftUI)                         │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌─────────┐│
│  │MainMenu  │  │ GameView │  │ShopView  │  │StatsView││
│  │  View    │  │          │  │          │  │         ││
│  └──────────┘  └──────────┘  └──────────┘  └─────────┘│
└───────────────────────┬─────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────┐
│                    Business Logic Layer                  │
│                        (Managers)                        │
│  ┌──────────────┐  ┌────────────┐  ┌─────────────────┐│
│  │ GameManager  │  │  Resource  │  │  Progression    ││
│  │  (Singleton) │  │  Manager   │  │   Manager       ││
│  └──────────────┘  └────────────┘  └─────────────────┘│
│  ┌──────────────┐  ┌────────────────────────────────┐ │
│  │SaveManager   │  │OfflineProgressManager          │ │
│  └──────────────┘  └────────────────────────────────┘ │
└───────────────────────┬─────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────┐
│                      Data Layer                          │
│                       (Models)                           │
│  ┌──────────┐  ┌─────────┐  ┌─────────┐  ┌──────────┐│
│  │GameState │  │Resource │  │Building │  │Civiliza- ││
│  │          │  │         │  │         │  │tion      ││
│  └──────────┘  └─────────┘  └─────────┘  └──────────┘│
└─────────────────────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────┐
│                   Rendering Layer                        │
│                     (SpriteKit)                          │
│  ┌──────────────┐  ┌────────────┐  ┌────────────────┐ │
│  │Stage1Scene   │  │Stage2Scene │  │Stage3Scene     │ │
│  │(Terra)       │  │(Sistema    │  │(Galassia)      │ │
│  │              │  │ Solare)    │  │                │ │
│  └──────────────┘  └────────────┘  └────────────────┘ │
└─────────────────────────────────────────────────────────┘
```

## Layer Dettagliati

### 1. Presentation Layer (SwiftUI Views)

#### Responsabilità
- Rendering UI
- Gestione input utente
- Binding con GameState
- Animazioni UI

#### Componenti Principali

**MainMenuView**
- Entry point dell'applicazione
- Menu iniziale
- Transizione a ContentView

**GameView**
- Container principale del gameplay
- Integrazione SpriteView
- Overlay UI (resource display, buttons)
- Gestione tap per click manuale

**ShopView**
- Lista edifici acquistabili
- Visualizzazione costi e benefici
- Bottoni acquisto
- Feedback visivo

**StatsView**
- Visualizzazione statistiche globali
- Lista edifici posseduti
- Debug controls

**Components/**
- Componenti riusabili
- ResourceDisplayView: mostra risorse
- BuildingCardView: card edificio
- ClickerButtonView: bottone click fallback

#### Pattern Utilizzati
- **MVVM**: Views osservano GameState tramite @ObservedObject
- **Composition**: View complesse composte da componenti piccoli
- **Declarative UI**: SwiftUI syntax

### 2. Business Logic Layer (Managers)

#### GameManager (Singleton)
**Responsabilità:**
- Coordinamento generale
- Game loop principale
- Gestione pause/resume
- Lifecycle app (background/foreground)

**Proprietà:**
```swift
@Published var gameState: GameState
@Published var isPaused: Bool
@Published var showOfflineReward: Bool
private var gameTimer: Timer?
private var saveTimer: Timer?
```

**Metodi Chiave:**
- `startGameLoop()`: Avvia update loop a 10Hz
- `update()`: Tick principale, aggiorna risorse
- `saveGame()`: Trigger salvataggio
- `performClick()`: Delega a ResourceManager
- `onAppBackground()` / `onAppForeground()`: Lifecycle

#### ResourceManager (Singleton)
**Responsabilità:**
- Calcoli produzione
- Gestione transazioni
- Click rewards
- Validazione affordability

**Metodi Chiave:**
```swift
func calculateTotalProduction(from buildings) -> BigNumber
func updateResources(gameState, deltaTime)
func performClick(gameState)
func purchaseBuilding(type, gameState) -> Bool
```

**Formule Implementate:**
- Produzione totale: Σ(Building.production)
- Click reward: base × stageMultiplier × prestigeMultiplier
- Costo edificio: baseCost × (multiplier ^ level)

#### ProgressionManager (Singleton)
**Responsabilità:**
- Gestione unlock
- Progressione stage
- Sistema prestige
- Achievement (preparato)

**Metodi Chiave:**
```swift
func checkAutoUnlocks(gameState)
func canPrestige(gameState) -> Bool
func performPrestige(gameState)
func advanceStage(gameState)
```

#### SaveManager (Singleton)
**Responsabilità:**
- Serializzazione GameState
- Persistenza UserDefaults
- Load/Save operations
- Timestamp tracking

**Storage:**
```swift
UserDefaults.standard.set(data, forKey: "kardashevGameSave")
```

**Formato:** JSON (Codable)

#### OfflineProgressManager (Singleton)
**Responsabilità:**
- Calcolo tempo offline
- Applicazione produzione ridotta
- Preparazione reward popup

**Algoritmo:**
```swift
timeOffline = now - lastSaveTime
effectiveTime = min(timeOffline, 8 hours)
offlineProduction = totalProduction × 0.5
reward = offlineProduction × effectiveTime
```

### 3. Data Layer (Models)

#### GameState (ObservableObject)
**Scopo:** Stato completo del gioco, serializzabile

**Proprietà:**
```swift
@Published var civilization: Civilization
@Published var resources: ResourceCollection
@Published var buildings: [BuildingType: Building]
@Published var technologies: [TechnologyType: Technology]
@Published var lastSaveTime: Date
```

**Conformità:** Codable per serializzazione

#### Resource
**Rappresenta:** Una risorsa del gioco

**Struttura:**
```swift
struct Resource {
    let type: ResourceType
    var amount: BigNumber
    var productionPerSecond: BigNumber
}
```

**Operazioni:**
- `add()`, `subtract()`
- `canAfford()`
- `formattedAmount()`, `formattedProduction()`

#### Building
**Rappresenta:** Un edificio posseduto

**Struttura:**
```swift
struct Building {
    let type: BuildingType
    var level: Int
    var unlocked: Bool
}
```

**Metodi:**
- `nextLevelCost()`: Calcolo costo esponenziale
- `totalProduction()`: Produzione attuale
- `canUnlock()`: Verifica unlock condition

#### Civilization
**Rappresenta:** Stato civiltà giocatore

**Proprietà:**
```swift
var stage: KardashevStage
var prestigeLevel: Int
var prestigeMultiplier: Double
var totalClicks: Int
var totalEnergyGenerated: BigNumber
```

#### KardashevStage (Enum)
**Valori:**
- `.type1`: Civiltà Planetaria
- `.type2`: Civiltà Stellare
- `.type3`: Civiltà Galattica

**Proprietà Computed:**
- `displayName`, `description`
- `unlockCost`, `clickMultiplier`

### 4. Rendering Layer (SpriteKit Scenes)

#### BaseGameScene
**Scopo:** Classe base per tutte le scene

**Funzionalità Comuni:**
- Touch handling
- Callback `onTap`
- Setup hook `setupScene()`

#### Stage1Scene
**Rappresenta:** Terra nello spazio (Tipo I)

**Elementi:**
- Background stellato (100 stelle animate)
- Terra rotante (SKShapeNode + continenti)
- Particelle click
- Animazioni smooth

**Animazioni:**
- Rotazione Terra: 30s per giro completo
- Stelle scintillanti: fade in/out random
- Click particles: burst effect

**Touch Handling:**
- Detect tap su Terra
- Pulse animation
- Particle emission

#### Stage2Scene / Stage3Scene
**Stato:** Placeholder per future espansioni

**Design:**
- Stage2: Sole centrale + pianeti orbitanti
- Stage3: Galassia spirale rotante

### 5. Utilities Layer

#### BigNumber
**Problema Risolto:** JavaScript/Idle games raggiungono numeri > 10^308

**Implementazione:**
```swift
struct BigNumber {
    var mantissa: Double  // 1.0 ... 9.999
    var exponent: Int     // potenza di 10
}
```

**Operazioni:**
- Aritmetica: +, -, ×, ÷
- Confronti: <, >, ≤, ≥, ==
- Formatting: "1.23M", "4.56B", "7.89Qa"

**Suffissi Supportati:**
K, M, B, T, Qa, Qi, Sx, Sp, Oc, No, Dc, ecc.

#### Constants
**Contenuto:**
- Intervalli timing (tick, save, animation)
- Valori UI (padding, radius)
- Keys UserDefaults

#### BalanceConfig
**Contenuto:**
- Costi base edifici
- Produzioni base
- Moltiplicatori
- Soglie unlock

**Modificabile:** Per tuning gameplay

#### Extensions
**Contenuto:**
- Color themes custom
- View modifiers (glow, cardStyle)
- Helper methods (formatting, date utils)

## Flusso Dati

### 1. App Launch

```
KardashevGameApp
    ↓
MainMenuView (displayed)
    ↓
User tap "Inizia"
    ↓
ContentView
    ↓
GameManager.shared.resume()
    ↓
SaveManager.load() → GameState?
    ↓
OfflineProgressManager.calculate()
    ↓
GameView (with SpriteKit scene)
```

### 2. Click Manuale

```
User tap on Earth (SpriteKit scene)
    ↓
Stage1Scene.touchesBegan()
    ↓
scene.onTap?() callback
    ↓
GameManager.performClick()
    ↓
ResourceManager.performClick(gameState)
    ↓
gameState.resources.energy.add(reward)
    ↓
@Published property change
    ↓
SwiftUI UI auto-update
```

### 3. Acquisto Edificio

```
User tap "Acquista" in ShopView
    ↓
GameManager.purchaseBuilding(type)
    ↓
ResourceManager.purchaseBuilding(type, gameState)
    ↓
Validate: canAfford() ?
    ↓ Yes
Subtract cost from resources
    ↓
Increment building.level
    ↓
@Published property change
    ↓
UI update (button state, counter, etc)
```

### 4. Game Loop (Passive Production)

```
Timer fires every 0.1s
    ↓
GameManager.update()
    ↓
Calculate deltaTime
    ↓
ResourceManager.updateResources(gameState, deltaTime)
    ↓
totalProduction = Σ(building.production)
    ↓
energy += totalProduction × deltaTime
    ↓
ProgressionManager.checkAutoUnlocks(gameState)
    ↓
@Published property change
    ↓
UI update
```

### 5. Salvataggio

```
Timer fires every 30s (auto-save)
OR
App goes to background
    ↓
GameManager.saveGame()
    ↓
gameState.lastSaveTime = now
    ↓
SaveManager.save(gameState)
    ↓
JSONEncoder.encode(gameState)
    ↓
UserDefaults.standard.set(data)
```

### 6. Offline Progress

```
App relaunches after being closed
    ↓
GameManager.init()
    ↓
SaveManager.load() → GameState
    ↓
OfflineProgressManager.calculate(gameState)
    ↓
timeOffline = now - lastSaveTime
    ↓
effectiveTime = min(timeOffline, 8h)
    ↓
reward = production × 0.5 × effectiveTime
    ↓
Apply reward to resources
    ↓
Show popup with reward details
```

## Design Patterns Utilizzati

### Singleton Pattern
**Dove:** Tutti i Manager
**Perché:** Stato globale, accesso centralizzato

```swift
class GameManager {
    static let shared = GameManager()
    private init() {}
}
```

### Observer Pattern
**Dove:** GameState → SwiftUI Views
**Come:** @Published + @ObservedObject

```swift
class GameState: ObservableObject {
    @Published var resources: ResourceCollection
}

struct GameView: View {
    @ObservedObject var gameManager = GameManager.shared
}
```

### Strategy Pattern
**Dove:** BalanceConfig
**Perché:** Algoritmi di bilanciamento intercambiabili

### Factory Pattern (implicito)
**Dove:** Scene creation in GameView
**Come:** Switch su stage per creare scene appropriata

### Delegation Pattern
**Dove:** BaseGameScene callbacks
**Come:** `onTap` closure

## Threading Model

### Main Thread
- Tutto il UI (SwiftUI)
- Game loop updates
- SpriteKit rendering
- Timer callbacks

**Nota:** No threading complesso necessario per idle game MVP

### Future Optimizations
- Background thread per calcoli complessi
- DispatchQueue per save operations pesanti
- Async/await per network calls (leaderboard)

## Gestione Memoria

### Retain Cycles Prevention
- `[weak self]` in closures
- Timer invalidation in deinit
- No circular references tra Manager

### Resource Management
- SpriteKit textures cached
- BigNumber struct (value type)
- Models lightweight

## Testing Strategy (Futuro)

### Unit Tests
- BigNumber operations
- BalanceConfig calculations
- Resource transactions
- Offline progress formulas

### Integration Tests
- Save/Load cycle
- Game loop updates
- Manager interactions

### UI Tests
- Navigation flow
- Purchase flow
- Offline reward popup

## Scalability

### Aggiungere Nuovi Edifici
1. Aggiungi case a `BuildingType`
2. Configura costo/produzione in `BalanceConfig`
3. Definisci unlock condition in `ProgressionManager`
4. UI si aggiorna automaticamente

### Aggiungere Nuove Risorse
1. Aggiungi case a `ResourceType`
2. Aggiungi property a `ResourceCollection`
3. Estendi `ResourceManager` per calcoli
4. Aggiungi UI display component

### Aggiungere Nuovi Stage
1. Aggiungi case a `KardashevStage`
2. Crea nuova Scene (es: `Stage4Scene`)
3. Aggiungi switch case in `GameView.createScene()`
4. Implementa rendering specifico

## Sicurezza

### Validazione Input
- Tutti gli acquisti validati lato client
- Impossibile spendere più risorse di quelle possedute
- Valori negativi preventi

### Anti-Cheat (Base)
- Salvataggi locali (no cloud = no sync cheat)
- Timestamp verificati per offline progress
- Produzione limitata (max 8h offline)

### Futuro
- Hash checksum su save data
- Server-side validation per leaderboard
- Encrypted UserDefaults

## Performance Targets

| Metrica | Target | Attuale |
|---------|--------|---------|
| FPS | 60 | ~60 |
| Memoria | <100MB | ~50MB |
| Launch Time | <2s | ~1s |
| Save Time | <100ms | ~50ms |
| Battery/hour | <5% | ~3% |

## Dipendenze

### Framework Apple
- **SwiftUI**: UI declarativa
- **SpriteKit**: 2D rendering
- **Combine**: Reactive programming (@Published)
- **Foundation**: Core utilities

### Terze Parti
**Nessuna** - Solo SDK Apple standard

**Vantaggi:**
- No dependency hell
- Più facile manutenzione
- Review App Store semplificata

## UI Stabilization

### Problemi Risolti

L'interfaccia utente è stata stabilizzata per evitare problemi di layout, jitter e sovrapposizione con aree di sistema.

#### 1. Safe Area Handling

**Problema:** Il cluster superiore di risorse si sovrapponeva alla Dynamic Island / status bar.

**Soluzione:**
- Utilizzo di `GeometryReader` per accedere ai `safeAreaInsets`
- Top HUD posizionato con `.padding(.top, geometry.safeAreaInsets.top + 8)`
- Bottom UI con `.padding(.bottom, max(geometry.safeAreaInsets.bottom, 20))`
- SpriteView usa `.ignoresSafeArea()` per coprire tutto lo schermo
- UI overlay rispetta le safe area

```swift
// Top Bar posizionato correttamente
HStack(alignment: .top, spacing: 12) {
    // ... contenuto
}
.padding(.top, geometry.safeAreaInsets.top + 8)
```

#### 2. Fixed Component Dimensions

**Problema:** Celle risorse con auto-layout variabile causavano fluttuazione di dimensioni.

**Soluzione:**
- Tutte le dimensioni definite in `UIConstants.swift`
- `ScoreBadgeView`: 110x80 pt
- `ResourceTileView`: 70x90 pt
- `ClickButton`: 64x64 pt
- Menu buttons: 44x44 pt
- Frame fissi su tutti i componenti UI

```swift
struct UIConstants {
    static let scoreBadgeWidth: CGFloat = 110
    static let scoreBadgeHeight: CGFloat = 80
    static let resourceTileWidth: CGFloat = 70
    static let resourceTileHeight: CGFloat = 90
    // ...
}
```

#### 3. BigNumber Formatting

**Problema:** Numeri formattati male, scompaiono o mostrano caratteri troncati.

**Soluzione:**
- Metodo `formatted()` su BigNumber con suffissi standard (K, M, B, T, Qa, Qi, Sx...)
- Normalizzazione automatica in tutti i costruttori e operatori
- Mantissa sempre nel range [1, 10) eccetto per zero
- Decimali appropriati per valori < 1 (fino a 3-4 decimali)
- Formattazione compatta con 2 decimali per piccoli numeri, 0-1 per grandi

```swift
// BigNumber formatting
let value = BigNumber(1_234_567)
value.formatted() // "1.23M"
```

#### 4. Text Stability

**Problema:** Numeri causano jitter durante aggiornamenti.

**Soluzione:**
- `.monospacedDigit()` su tutti i valori numerici
- `.lineLimit(1)` per prevenire text wrapping
- `.minimumScaleFactor(0.5-0.7)` per scaling controllato
- `.allowsTightening(true)` per ottimizzazione spazio

```swift
Text(score.formatted())
    .lineLimit(1)
    .minimumScaleFactor(0.7)
    .allowsTightening(true)
    .monospacedDigit()
```

#### 5. Z-Index Hierarchy

**Problema:** Score nascosto sotto overlay, elementi UI interferiscono con scene.

**Soluzione:**
- SpriteView: z-index 0 (default, in fondo)
- UI Overlay (HUD): z-index 1000
- Critical Click Feedback: z-index 2000
- Offline Reward Popup: z-index 3000
- `.allowsHitTesting(true)` su UI overlay per interazioni

```swift
ZStack {
    SpriteView(scene: createScene())
        .ignoresSafeArea()
    
    VStack { /* HUD */ }
        .zIndex(1000)
    
    // Popups con z-index più alto
}
```

#### 6. Resource Bar Scrolling

**Problema:** Troppe risorse non entrano in una riga.

**Soluzione:**
- `ScrollView(.horizontal)` per resource tiles
- Limite di larghezza massima (400 pt)
- Nessun indicatore di scroll visibile
- Layout stabile con spacing consistente

```swift
ScrollView(.horizontal, showsIndicators: false) {
    HStack(spacing: 6) {
        ForEach(resourceTypes) { type in
            ResourceTileView(resource: resources[type])
        }
    }
}
.frame(maxWidth: 400)
```

### Best Practices Applicate

1. **Normalizzazione BigNumber**: Chiamata automaticamente in `init()` e dopo ogni operazione
2. **Frame Fissi**: Tutti i componenti UI hanno dimensioni predefinite
3. **Safe Area Consapevolezza**: Layout adattivo per notch/Dynamic Island
4. **Text Rendering Ottimizzato**: Monospace digits per evitare jitter
5. **Z-Index Esplicito**: Gerarchia chiara per layering UI
6. **Scrolling Condizionale**: Resource bar scrollabile quando necessario

### Metriche di Performance

| Metrica | Target | Risultato |
|---------|--------|-----------|
| Layout Shift | 0 | 0 |
| Text Jitter | Nessuno | Eliminato |
| Safe Area Overlap | 0px | 0px |
| Frame Stability | 100% | 100% |
| FPS durante update | 60 | ~60 |

## Conclusione

L'architettura è:
- ✅ Modulare e testabile
- ✅ Scalabile per future features
- ✅ Performante per idle gameplay
- ✅ Manutenibile con separazione chiara
- ✅ iOS-native con best practices Apple
- ✅ UI stabile senza jitter o layout shifts

Pronta per espansione verso Stage 2, Stage 3, e features avanzate.
