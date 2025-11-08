# Kardashev - Idle Civilization Game

![iOS](https://img.shields.io/badge/iOS-16.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)
![SwiftUI](https://img.shields.io/badge/SwiftUI-✓-green.svg)
![SpriteKit](https://img.shields.io/badge/SpriteKit-✓-purple.svg)

Un gioco idle/incremental basato sulla **Scala di Kardašëv**, dove guidi la tua civiltà attraverso tre livelli di sviluppo tecnologico: dalla padronanza dell'energia planetaria (Tipo I) fino al controllo dell'intera galassia (Tipo III).

## 📖 Descrizione

Kardashev è un gioco incrementale che combina meccaniche idle classiche con una progressione basata sulla famosa scala di Kardašëv che classifica le civiltà in base alla loro capacità di sfruttare l'energia.

### La Scala di Kardašëv

- **Tipo I - Civiltà Planetaria**: Sfrutta tutta l'energia disponibile sul proprio pianeta
- **Tipo II - Civiltà Stellare**: Sfrutta tutta l'energia della propria stella tramite una Sfera di Dyson
- **Tipo III - Civiltà Galattica**: Sfrutta tutta l'energia disponibile nella galassia

## 🎮 Meccaniche di Gioco

### Core Gameplay

1. **Click Manuale**: Tocca la Terra per generare energia manualmente
2. **Produzione Passiva**: Costruisci generatori che producono energia automaticamente
3. **Upgrade Incrementali**: Acquista livelli di edifici con costi esponenziali
4. **Progressione**: Sblocca nuove tecnologie e avanza attraverso gli stadi di Kardašëv
5. **Offline Progress**: Guadagna risorse anche quando l'app è chiusa (fino a 8 ore)
6. **Prestige System**: Reset strategici per bonus permanenti

### Edifici/Generatori

- **⚡️ Generatore Solare**: Pannelli solari base per energia pulita
- **⚛️ Centrale Nucleare**: Produzione energetica stabile e potente
- **🔥 Centrale a Fusione**: Reattori a fusione avanzati
- **🛰 Fattoria Solare Orbitale**: Stazioni spaziali per raccolta energia

## 🏗️ Architettura Tecnica

### Struttura del Progetto

```
KardashevGame/
├── Models/                      # Layer dati
│   ├── Civilization.swift       # Stato civiltà giocatore
│   ├── Resource.swift           # Sistema risorse
│   ├── Building.swift           # Generatori/Edifici
│   ├── Technology.swift         # Tecnologie
│   ├── KardashevStage.swift    # Enum stadi (I, II, III)
│   └── GameState.swift         # Stato globale serializzabile
├── Managers/                    # Business Logic
│   ├── GameManager.swift       # Coordinatore principale
│   ├── ResourceManager.swift   # Calcoli risorse e produzione
│   ├── ProgressionManager.swift # Unlock e prestige
│   ├── SaveManager.swift       # Persistenza (UserDefaults)
│   └── OfflineProgressManager.swift # Calcolo risorse offline
├── Scenes/ (SpriteKit)          # Rendering grafico
│   ├── BaseGameScene.swift     # Classe base
│   ├── Stage1Scene.swift       # Terra rotante
│   ├── Stage2Scene.swift       # Sistema Solare (placeholder)
│   └── Stage3Scene.swift       # Galassia (placeholder)
├── Views/ (SwiftUI)             # Interfaccia utente
│   ├── ContentView.swift       # Container principale
│   ├── MainMenuView.swift      # Menu iniziale
│   ├── GameView.swift          # Overlay UI + SpriteKit
│   ├── ShopView.swift          # Shop edifici
│   ├── StatsView.swift         # Statistiche
│   └── Components/             # Componenti riusabili
├── Utils/                       # Utilities
│   ├── BigNumber.swift         # Gestione numeri grandi
│   ├── Constants.swift         # Costanti globali
│   ├── BalanceConfig.swift     # Bilanciamento gioco
│   └── Extensions.swift        # Estensioni Swift
└── Resources/
    └── Assets.xcassets         # Asset grafici
```

### Tecnologie Utilizzate

- **Swift 5.9+**: Linguaggio principale
- **SwiftUI**: UI moderna e dichiarativa
- **SpriteKit**: Rendering 2D e animazioni
- **Combine**: Reactive programming per state management
- **UserDefaults**: Persistenza dati (preparato per Core Data)

### Design Patterns

- **Singleton**: Managers (GameManager, ResourceManager, etc.)
- **Observer**: ObservableObject per reactive UI
- **State Pattern**: GameState centralizzato
- **Strategy**: Calcoli bilanciamento configurabili

## 🚀 Setup e Sviluppo

### Requisiti

- Xcode 15.0+
- iOS 16.0+ SDK
- macOS per sviluppo

### Installazione

```bash
# Clona il repository
git clone https://github.com/rawtrap/re-volution.git
cd re-volution

# Apri il progetto in Xcode
open KardashevGame.xcodeproj

# Build e Run (⌘ + R)
```

### Configurazione Build

Il progetto è configurato per:
- **Target iOS**: 16.0+
- **Supporto dispositivi**: iPhone e iPad
- **Orientamenti**: Portrait (iPhone), tutti (iPad)

## 🎯 Roadmap

### ✅ MVP Completato (Stage 1)

- [x] Sistema risorse con BigNumber
- [x] Click manuale con reward
- [x] 4 tipi di generatori funzionanti
- [x] Produzione passiva automatica
- [x] Sistema salvataggio/caricamento
- [x] Offline progress (max 8 ore, 50% produzione)
- [x] UI completa con SwiftUI
- [x] Scena Stage 1 con Terra rotante
- [x] Shop edifici funzionante
- [x] Statistiche giocatore

### 🔮 Future Features

#### Stage 2 - Sistema Solare
- [ ] Nuova scena con Sole e pianeti
- [ ] Sfera di Dyson progressiva
- [ ] Nuovi generatori stellari
- [ ] Minigioco raccolta energia solare

#### Stage 3 - Galassia
- [ ] Scena galattica
- [ ] Colonizzazione sistemi stellari
- [ ] Gestione flotta spaziale
- [ ] Generatori galattici

#### Sistemi Aggiuntivi
- [ ] Sistema tecnologie completo
- [ ] Achievement/Trofei
- [ ] Prestige tree
- [ ] Eventi casuali
- [ ] Sfide temporanee
- [ ] Classifiche online (Game Center)
- [ ] iCloud sync
- [ ] Supporto landscape
- [ ] Animazioni avanzate
- [ ] Sound effects e musica

## 🎮 Come Giocare

1. **Avvia il gioco** e vedrai la Terra rotante nello spazio stellato
2. **Tocca la Terra** per generare energia manualmente
3. **Apri lo Shop** (icona carrello) per vedere i generatori disponibili
4. **Acquista generatori** quando hai abbastanza energia
5. **Osserva la produzione** aumentare automaticamente
6. **Acquista più livelli** per aumentare la produzione
7. **Sblocca edifici avanzati** raggiungendo soglie di energia
8. **Chiudi l'app** e riapri per vedere le ricompense offline

## 📊 Bilanciamento

### Costi e Produzione

| Edificio | Costo Base | Produzione/s | Moltiplicatore Costo |
|----------|------------|--------------|---------------------|
| Generatore Solare | 10 | 0.1 | 1.15x |
| Centrale Nucleare | 100 | 1.0 | 1.15x |
| Centrale Fusione | 1,100 | 8.0 | 1.15x |
| Fattoria Orbitale | 12,000 | 47.0 | 1.15x |

### Formule

- **Costo Livello N**: `BaseCost × (Multiplier ^ N)`
- **Produzione Totale**: `BaseProduction × Level × ProductionMultiplier`
- **Click Reward**: `BaseReward × StageMultiplier × PrestigeMultiplier`
- **Offline Progress**: `TotalProduction × 0.5 × TimeOffline` (max 8h)

## 🐛 Testing

### Funzionalità Testate

- ✅ Avvio app e rendering scena
- ✅ Click manuale funzionante
- ✅ Aggiornamento counter risorse
- ✅ Acquisto edifici
- ✅ Calcolo produzione passiva
- ✅ Salvataggio stato
- ✅ Caricamento stato
- ✅ Calcolo offline progress
- ✅ Popup ricompense offline
- ✅ UI responsiva
- ✅ Gestione background/foreground

### Debug Features

- Bottone "Reset Gioco" nelle statistiche per testare new game flow
- Console logging per operazioni principali
- Validazione costi e produzioni

## 📱 Screenshots

_Coming soon - Il progetto è pronto per screenshot una volta eseguito su device/simulator_

## 🤝 Contribuire

Questo è un progetto privato. Per suggerimenti o bug report, aprire una issue nel repository.

## 📄 Licenza

Copyright © 2024. Tutti i diritti riservati.

## 👤 Autore

Progetto sviluppato per esplorare le meccaniche dei giochi incrementali e la programmazione iOS moderna.

## 🙏 Ringraziamenti

- Ispirato dalla Scala di Kardašëv del fisico russo Nikolai Kardašëv (1964)
- Meccaniche inspirate da Cookie Clicker, Antimatter Dimensions, e Universal Paperclips

---

**Buona scalata verso la Tipo III! ♾️**
