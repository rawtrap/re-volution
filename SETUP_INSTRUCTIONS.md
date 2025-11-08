# Setup Instructions - Kardashev Game

## Requisiti di Sistema

- **macOS**: Ventura (13.0) o superiore
- **Xcode**: 15.0 o superiore
- **iOS SDK**: 16.0 o superiore
- **Device/Simulator**: iPhone o iPad con iOS 16.0+

## Installazione e Build

### 1. Clone del Repository

```bash
git clone https://github.com/rawtrap/re-volution.git
cd re-volution
```

### 2. Apertura in Xcode

```bash
open KardashevGame.xcodeproj
```

Oppure:
- Apri Xcode
- File → Open
- Naviga a `KardashevGame.xcodeproj`
- Click su "Open"

### 3. Selezione Target

1. Nel top bar di Xcode, click sullo schema/target selector
2. Seleziona un simulatore (es. "iPhone 15 Pro") o un device fisico
3. Assicurati che il target sia "KardashevGame"

### 4. Build del Progetto

**Metodo 1 - Keyboard Shortcut:**
```
⌘ + B (Command + B)
```

**Metodo 2 - Menu:**
```
Product → Build
```

**Metodo 3 - Toolbar:**
Click sul bottone Play (▶️) in alto a sinistra

### 5. Run dell'Applicazione

```
⌘ + R (Command + R)
```

O click sul bottone Play (▶️) dopo che il build è completato.

## Risoluzione Problemi

### Errore: "No signing certificate found"

**Soluzione:**
1. Seleziona il progetto nel navigator (icona cartella blu)
2. Seleziona il target "KardashevGame"
3. Tab "Signing & Capabilities"
4. Cambia "Team" al tuo Apple ID (aggiungi account se necessario)
5. O seleziona "Automatically manage signing"

### Errore: "SDK not found"

**Soluzione:**
1. Xcode → Preferences → Locations
2. Verifica che "Command Line Tools" sia impostato alla versione corretta
3. Se necessario, reinstalla Xcode Command Line Tools:
```bash
xcode-select --install
```

### Simulatore non risponde

**Soluzione:**
1. Device → Erase All Content and Settings
2. Riavvia Xcode
3. Prova un altro simulatore

## Testing Manuale

### Checklist Funzionalità MVP

Dopo aver avviato l'app, testa le seguenti funzionalità:

#### ✅ 1. Avvio e Rendering
- [ ] L'app si avvia senza crash
- [ ] Viene mostrato il menu principale
- [ ] Click su "Inizia" porta alla schermata di gioco
- [ ] La Terra rotante è visibile al centro
- [ ] Le stelle sono visibili sullo sfondo

#### ✅ 2. Click Manuale
- [ ] Toccare la Terra incrementa il counter energia
- [ ] Il valore energia cambia visibilmente
- [ ] L'animazione di click è visibile (pulse della Terra)
- [ ] Multiple tap funzionano correttamente

#### ✅ 3. Shop e Acquisti
- [ ] Click sull'icona carrello apre lo shop
- [ ] Sono visibili 2 generatori iniziali (Solare e Nucleare)
- [ ] I bottoni di acquisto sono colorati se puoi permetterti l'edificio
- [ ] I bottoni sono grigi se non puoi permetterti l'edificio
- [ ] L'acquisto di un generatore funziona
- [ ] L'energia viene sottratta correttamente
- [ ] Il livello del generatore aumenta

#### ✅ 4. Produzione Passiva
- [ ] Dopo aver acquistato un generatore, l'energia aumenta automaticamente
- [ ] Il rate "+X/s" viene mostrato correttamente
- [ ] La produzione continua senza interazione
- [ ] Acquistare più livelli aumenta la produzione

#### ✅ 5. Unlock Progressivi
- [ ] Arrivando a 500 energia, si sblocca "Centrale a Fusione"
- [ ] Arrivando a 5000 energia, si sblocca "Fattoria Solare Orbitale"
- [ ] Gli edifici sbloccati appaiono nello shop

#### ✅ 6. Statistiche
- [ ] Click sull'icona grafico apre le statistiche
- [ ] Vengono mostrati: energia totale, click totali, produzione/s
- [ ] Gli edifici posseduti sono elencati con livelli
- [ ] Il bottone "Reset Gioco" funziona (per testing)

#### ✅ 7. Salvataggio
- [ ] Chiudi l'app (swipe up o home button)
- [ ] Riapri l'app
- [ ] Lo stato del gioco è preservato (energia, edifici, livelli)

#### ✅ 8. Offline Progress
- [ ] Chiudi completamente l'app
- [ ] Attendi 1-2 minuti
- [ ] Riapri l'app
- [ ] Appare il popup "Bentornato!"
- [ ] Viene mostrato il tempo offline
- [ ] Viene mostrata l'energia guadagnata offline
- [ ] L'energia viene aggiunta al totale dopo "Continua"

## Performance Target

### Frame Rate
- **Target**: 60 FPS costanti
- **Test**: Osserva la fluidità della rotazione della Terra
- **Strumenti**: Xcode → Debug → View Debugging → Performance

### Memoria
- **Target**: < 100 MB su iPhone
- **Test**: Xcode Memory Gauge durante gameplay
- **Leak**: Esegui Instruments → Leaks

### Battery
- **Target**: < 5% battery/hour in idle
- **Test**: Lascia app aperta per 30 minuti e monitora consumo

## Build per Distribution (Futuro)

### Archive Build

```bash
# Via Xcode:
Product → Archive

# Aspetta completamento
# Organizer si aprirà automaticamente
# Distribuisci via App Store Connect o Ad-Hoc
```

### Test su Device Fisico

1. Collega iPhone/iPad via USB
2. Sblocca device e accetta "Trust Computer"
3. Seleziona device nel target selector
4. Run normalmente (⌘ + R)

## Configurazioni Aggiuntive

### Cambio Bundle ID

Se necessario modificare il Bundle Identifier:

1. Project Navigator → Seleziona progetto
2. Target "KardashevGame"
3. Tab "General"
4. Cambia "Bundle Identifier" da `com.kardashev.game` al tuo

### Aggiunta Icona App

1. Crea immagini icona nelle dimensioni richieste
2. Drag & drop in `Assets.xcassets/AppIcon.appiconset`
3. Assicurati che coprano tutte le dimensioni richieste

## Support

Per problemi tecnici o domande:
- Apri una Issue nel repository GitHub
- Consulta la documentazione Apple per problemi Xcode-specifici
- Verifica che tutte le dipendenze di sistema siano aggiornate

## Next Steps

Dopo aver verificato che tutto funziona:

1. Personalizza il bilanciamento in `BalanceConfig.swift`
2. Aggiungi nuovi edifici in `Building.swift`
3. Espandi le tecnologie in `Technology.swift`
4. Implementa Stage 2 e 3 con nuove scene
5. Aggiungi sound effects e musica
6. Implementa achievement system
7. Prepara per submission App Store

---

**Buona programmazione! 🚀**
