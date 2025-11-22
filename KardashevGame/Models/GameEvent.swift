//
//  GameEvent.swift
//  KardashevGame
//
//  Sistema eventi random con scelte e conseguenze
//

import Foundation

/// Tipo di evento
enum EventType: String, Codable, CaseIterable {
    // Positive events
    case scientificBreakthrough = "Scoperta Scientifica"
    case resourceDiscovery = "Scoperta Risorse"
    case populationBoom = "Boom Demografico"
    case diplomaticAlliance = "Alleanza Diplomatica"
    case technologicalGift = "Dono Tecnologico"
    
    // Neutral events
    case alienContact = "Contatto Alieno"
    case cosmicAnomaly = "Anomalia Cosmica"
    case ancientArtifact = "Manufatto Antico"
    case mysteriousSignal = "Segnale Misterioso"
    case timeParadox = "Paradosso Temporale"
    
    // Negative events
    case naturalDisaster = "Disastro Naturale"
    case pandemic = "Pandemia"
    case economicCrisis = "Crisi Economica"
    case civilUnrest = "Disordini Civili"
    case sabotage = "Sabotaggio"
    case alienAttack = "Attacco Alieno"
    case solarFlare = "Tempesta Solare"
    case asteroidThreat = "Minaccia Asteroide"
    case aiRebellion = "Ribellione IA"
    case nuclearAccident = "Incidente Nucleare"
    
    // Special events
    case transcendenceOffer = "Offerta Trascendenza"
    case parallelUniverse = "Universo Parallelo"
    case cosmicEntity = "Entità Cosmica"
    case realityShift = "Cambio di Realtà"
    case finalChoice = "Scelta Finale"
    
    var severity: EventSeverity {
        switch self {
        case .scientificBreakthrough, .resourceDiscovery, .populationBoom, .diplomaticAlliance, .technologicalGift:
            return .positive
        case .alienContact, .cosmicAnomaly, .ancientArtifact, .mysteriousSignal, .timeParadox,
             .transcendenceOffer, .parallelUniverse, .cosmicEntity, .realityShift, .finalChoice:
            return .neutral
        case .naturalDisaster, .pandemic, .economicCrisis, .civilUnrest, .sabotage:
            return .negative
        case .alienAttack, .solarFlare, .asteroidThreat, .aiRebellion, .nuclearAccident:
            return .critical
        }
    }
}

/// Severità dell'evento
enum EventSeverity: String, Codable {
    case positive = "Positivo"
    case neutral = "Neutrale"
    case negative = "Negativo"
    case critical = "Critico"
    
    var icon: String {
        switch self {
        case .positive: return "✨"
        case .neutral: return "❓"
        case .negative: return "⚠️"
        case .critical: return "🚨"
        }
    }
}

/// Scelta disponibile in un evento
struct EventChoice: Codable, Identifiable {
    let id: UUID
    let text: String
    let requiresResource: ResourceType?
    let resourceCost: BigNumber?
    let effects: EventEffects
    
    init(text: String, 
         requiresResource: ResourceType? = nil,
         resourceCost: BigNumber? = nil,
         effects: EventEffects) {
        self.id = UUID()
        self.text = text
        self.requiresResource = requiresResource
        self.resourceCost = resourceCost
        self.effects = effects
    }
}

/// Effetti di una scelta
struct EventEffects: Codable {
    var energyChange: BigNumber = BigNumber(0)
    var foodChange: BigNumber = BigNumber(0)
    var materialsChange: BigNumber = BigNumber(0)
    var knowledgeChange: BigNumber = BigNumber(0)
    var happinessChange: Double = 0
    var militaryChange: Double = 0
    var healthChange: Double = 0
    var gameOverRisk: Double = 0  // 0.0 - 1.0
    var gameOverReason: GameOverReason?
}

/// Un evento di gioco completo
struct GameEvent: Codable, Identifiable {
    let id: UUID
    let type: EventType
    let title: String
    let description: String
    let choices: [EventChoice]
    let minimumStage: KardashevStage
    
    init(type: EventType,
         title: String,
         description: String,
         choices: [EventChoice],
         minimumStage: KardashevStage = .type1) {
        self.id = UUID()
        self.type = type
        self.title = title
        self.description = description
        self.choices = choices
        self.minimumStage = minimumStage
    }
}

/// Manager per gli eventi di gioco
class EventManager {
    static let shared = EventManager()
    
    private var allEvents: [GameEvent] = []
    private var lastEventTime: Date = Date()
    private let eventCooldown: TimeInterval = 300 // 5 minuti tra eventi
    
    private init() {
        setupEvents()
    }
    
    /// Verifica se può spawnare un evento
    func canSpawnEvent() -> Bool {
        let timeSinceLastEvent = Date().timeIntervalSince(lastEventTime)
        return timeSinceLastEvent >= eventCooldown
    }
    
    /// Genera un evento random appropriato per lo stage corrente
    func generateRandomEvent(for stage: KardashevStage) -> GameEvent? {
        let availableEvents = allEvents.filter { $0.minimumStage.rawValue <= stage.rawValue }
        guard !availableEvents.isEmpty else { return nil }
        
        // Peso basato su severità
        let randomValue = Double.random(in: 0...1)
        let event: GameEvent
        
        if randomValue < 0.3 {
            // 30% eventi positivi
            event = availableEvents.filter { $0.type.severity == .positive }.randomElement() ?? availableEvents.randomElement()!
        } else if randomValue < 0.6 {
            // 30% eventi neutrali
            event = availableEvents.filter { $0.type.severity == .neutral }.randomElement() ?? availableEvents.randomElement()!
        } else if randomValue < 0.85 {
            // 25% eventi negativi
            event = availableEvents.filter { $0.type.severity == .negative }.randomElement() ?? availableEvents.randomElement()!
        } else {
            // 15% eventi critici
            event = availableEvents.filter { $0.type.severity == .critical }.randomElement() ?? availableEvents.randomElement()!
        }
        
        lastEventTime = Date()
        return event
    }
    
    /// Applica gli effetti di una scelta
    func applyChoice(_ choice: EventChoice, to gameState: GameState) -> GameOverReason? {
        let effects = choice.effects
        
        // Sottrai costo se necessario
        if let resource = choice.requiresResource, let cost = choice.resourceCost {
            gameState.resources[resource].subtract(cost)
        }
        
        // Applica cambiamenti risorse
        gameState.resources.energy.add(effects.energyChange)
        gameState.resources.food.add(effects.foodChange)
        gameState.resources.materials.add(effects.materialsChange)
        gameState.resources.knowledge.add(effects.knowledgeChange)
        
        // Applica cambiamenti parametri civiltà
        gameState.civilization.parameters.happiness = max(0, min(100, 
            gameState.civilization.parameters.happiness + effects.happinessChange))
        gameState.civilization.parameters.military = max(0, min(100,
            gameState.civilization.parameters.military + effects.militaryChange))
        gameState.civilization.parameters.health = max(0, min(100,
            gameState.civilization.parameters.health + effects.healthChange))
        
        // Verifica game over risk
        if effects.gameOverRisk > 0 {
            let roll = Double.random(in: 0...1)
            if roll < effects.gameOverRisk {
                return effects.gameOverReason ?? .resourcesDepleted
            }
        }
        
        return nil
    }
    
    // MARK: - Event Setup
    
    private func setupEvents() {
        allEvents = [
            // Positive Events
            GameEvent(
                type: .scientificBreakthrough,
                title: "Scoperta Scientifica!",
                description: "I tuoi scienziati hanno fatto una scoperta rivoluzionaria nel campo della fisica quantistica!",
                choices: [
                    EventChoice(
                        text: "Pubblica la ricerca (+50 Conoscenza, +10 Felicità)",
                        effects: EventEffects(
                            knowledgeChange: BigNumber(50),
                            happinessChange: 10
                        )
                    ),
                    EventChoice(
                        text: "Mantienila segreta e sviluppa armi (+20 Militare)",
                        effects: EventEffects(
                            happinessChange: -5, militaryChange: 20
                        )
                    )
                ]
            ),
            
            GameEvent(
                type: .resourceDiscovery,
                title: "Giacimento Scoperto!",
                description: "Un team di esplorazione ha trovato un ricco giacimento di risorse rare!",
                choices: [
                    EventChoice(
                        text: "Inizia l'estrazione (+500 Materiali)",
                        effects: EventEffects(materialsChange: BigNumber(500))
                    ),
                    EventChoice(
                        text: "Studia il giacimento (+100 Conoscenza, +200 Materiali)",
                        effects: EventEffects(
                            materialsChange: BigNumber(200),
                            knowledgeChange: BigNumber(100)
                        )
                    )
                ]
            ),
            
            GameEvent(
                type: .populationBoom,
                title: "Boom Demografico",
                description: "La tua popolazione sta crescendo rapidamente grazie alle migliori condizioni di vita!",
                choices: [
                    EventChoice(
                        text: "Costruisci nuove infrastrutture (Costo: 300 Energia)",
                        requiresResource: .energy,
                        resourceCost: BigNumber(300),
                        effects: EventEffects(
                            foodChange: BigNumber(200), happinessChange: 15
                        )
                    ),
                    EventChoice(
                        text: "Lascia che si gestisca naturalmente (+5 Felicità)",
                        effects: EventEffects(happinessChange: 5)
                    )
                ]
            ),
            
            // Neutral Events
            GameEvent(
                type: .alienContact,
                title: "Primo Contatto",
                description: "Una civiltà aliena ha stabilito un contatto! Le loro intenzioni sono sconosciute.",
                choices: [
                    EventChoice(
                        text: "Apri il dialogo diplomatico (+200 Conoscenza, possibile alleanza)",
                        effects: EventEffects(
                            knowledgeChange: BigNumber(200),
                            happinessChange: 10
                        )
                    ),
                    EventChoice(
                        text: "Preparati alla difesa (+15 Militare)",
                        effects: EventEffects(militaryChange: 15)
                    ),
                    EventChoice(
                        text: "Ignora il contatto (nessun effetto)",
                        effects: EventEffects()
                    )
                ]
            ),
            
            GameEvent(
                type: .cosmicAnomaly,
                title: "Anomalia Cosmica",
                description: "I sensori hanno rilevato un'anomalia spazio-temporale vicino al tuo sistema!",
                choices: [
                    EventChoice(
                        text: "Indaga l'anomalia (Costo: 500 Energia, rischio ma grandi ricompense)",
                        requiresResource: .energy,
                        resourceCost: BigNumber(500),
                        effects: EventEffects(
                            energyChange: BigNumber(2000),
                            knowledgeChange: BigNumber(500),
                            gameOverRisk: 0.1,
                            gameOverReason: .spaceTimeAnomaly
                        )
                    ),
                    EventChoice(
                        text: "Evita l'area (sicuro)",
                        effects: EventEffects()
                    )
                ]
            ),
            
            GameEvent(
                type: .ancientArtifact,
                title: "Manufatto Antico",
                description: "Hai scoperto un manufatto di una civiltà estinta. Potrebbe contenere conoscenze perdute.",
                choices: [
                    EventChoice(
                        text: "Studia il manufatto (Costo: 300 Conoscenza)",
                        requiresResource: .knowledge,
                        resourceCost: BigNumber(300),
                        effects: EventEffects(
                            energyChange: BigNumber(500), knowledgeChange: BigNumber(800)
                        )
                    ),
                    EventChoice(
                        text: "Vendilo (+1000 Materiali)",
                        effects: EventEffects(materialsChange: BigNumber(1000))
                    )
                ]
            ),
            
            // Negative Events
            GameEvent(
                type: .naturalDisaster,
                title: "Disastro Naturale",
                description: "Un terremoto devastante ha colpito le tue principali città!",
                choices: [
                    EventChoice(
                        text: "Soccorsi immediati (Costo: 500 Materiali, salva vite)",
                        requiresResource: .materials,
                        resourceCost: BigNumber(500),
                        effects: EventEffects(
                            happinessChange: -5,
                            healthChange: -10
                        )
                    ),
                    EventChoice(
                        text: "Lascia che si gestisca da solo (-20 Felicità, -15 Sanità)",
                        effects: EventEffects(
                            happinessChange: -20,
                            healthChange: -15,
                            gameOverRisk: 0.05,
                            gameOverReason: .environmentalCollapse
                        )
                    )
                ]
            ),
            
            GameEvent(
                type: .pandemic,
                title: "Pandemia Globale",
                description: "Un nuovo virus si sta diffondendo rapidamente attraverso la popolazione!",
                choices: [
                    EventChoice(
                        text: "Ricerca cura (Costo: 800 Conoscenza + 500 Materiali)",
                        requiresResource: .knowledge,
                        resourceCost: BigNumber(800),
                        effects: EventEffects(
                            materialsChange: BigNumber(-500),
                            happinessChange: -5, healthChange: -5
                        )
                    ),
                    EventChoice(
                        text: "Quarantena totale (-30 Felicità, -10 Sanità)",
                        effects: EventEffects(
                            happinessChange: -30,
                            healthChange: -10,
                            gameOverRisk: 0.15,
                            gameOverReason: .pandemic
                        )
                    )
                ]
            ),
            
            GameEvent(
                type: .economicCrisis,
                title: "Crisi Economica",
                description: "Il sistema economico sta collassando! Le risorse stanno diventando scarse.",
                choices: [
                    EventChoice(
                        text: "Intervento governativo (-50% risorse attuali ma stabilizza)",
                        effects: EventEffects(
                            energyChange: BigNumber(-0.5),  // Handled as percentage
                            happinessChange: -10
                        )
                    ),
                    EventChoice(
                        text: "Economia di libero mercato (-15 Felicità, rischio)",
                        effects: EventEffects(
                            happinessChange: -15,
                            gameOverRisk: 0.1,
                            gameOverReason: .civilWar
                        )
                    )
                ]
            ),
            
            GameEvent(
                type: .civilUnrest,
                title: "Disordini Civili",
                description: "La popolazione è insoddisfatta e protesta nelle strade!",
                choices: [
                    EventChoice(
                        text: "Ascolta le richieste e riforma (+5 Felicità dopo iniziale calo)",
                        effects: EventEffects(
                            energyChange: BigNumber(-200),
                            happinessChange: 5
                        )
                    ),
                    EventChoice(
                        text: "Reprimi le proteste (-30 Felicità, +10 Militare, rischio guerra civile)",
                        effects: EventEffects(
                            happinessChange: -30,
                            militaryChange: 10,
                            gameOverRisk: 0.2,
                            gameOverReason: .civilWar
                        )
                    )
                ]
            ),
            
            // Critical Events
            GameEvent(
                type: .alienAttack,
                title: "INVASIONE ALIENA!",
                description: "Una flotta aliena ostile è entrata nel sistema solare e sta attaccando!",
                choices: [
                    EventChoice(
                        text: "Combatti! (Richiede Militare > 60)",
                        effects: EventEffects(
                            energyChange: BigNumber(-1000),
                            materialsChange: BigNumber(-800),
                            militaryChange: -20,
                            gameOverRisk: 0.3,
                            gameOverReason: .alienInvasion
                        )
                    ),
                    EventChoice(
                        text: "Negozia (Richiede Conoscenza > 1000)",
                        requiresResource: .knowledge,
                        resourceCost: BigNumber(1000),
                        effects: EventEffects(
                            energyChange: BigNumber(-500),
                            happinessChange: -10
                        )
                    ),
                    EventChoice(
                        text: "Evacuazione di emergenza (Perde tutto ma sopravvive)",
                        effects: EventEffects(
                            energyChange: BigNumber(-0.8),  // Lose 80%
                            happinessChange: -40
                        )
                    )
                ],
                minimumStage: .type2
            ),
            
            GameEvent(
                type: .solarFlare,
                title: "Tempesta Solare Massiva",
                description: "Una tempesta solare senza precedenti sta per colpire! Tutta l'elettronica è a rischio!",
                choices: [
                    EventChoice(
                        text: "Attiva scudi (Costo: 1000 Energia, protezione parziale)",
                        requiresResource: .energy,
                        resourceCost: BigNumber(1000),
                        effects: EventEffects(
                            energyChange: BigNumber(-500),
                            materialsChange: BigNumber(-300)
                        )
                    ),
                    EventChoice(
                        text: "Spegni tutto e attendi (-70% produzione temporanea)",
                        effects: EventEffects(
                            energyChange: BigNumber(-2000),
                            happinessChange: -20
                        )
                    )
                ]
            ),
            
            GameEvent(
                type: .asteroidThreat,
                title: "Minaccia Asteroide",
                description: "Un asteroide gigante è in rotta di collisione con il pianeta!",
                choices: [
                    EventChoice(
                        text: "Lancio missilistico (Richiede Militare > 50)",
                        effects: EventEffects(
                            energyChange: BigNumber(-800),
                            materialsChange: BigNumber(-600),
                            gameOverRisk: 0.15,
                            gameOverReason: .environmentalCollapse
                        )
                    ),
                    EventChoice(
                        text: "Deviazione gravitazionale (Richiede Conoscenza avanzata)",
                        requiresResource: .knowledge,
                        resourceCost: BigNumber(1500),
                        effects: EventEffects(
                            energyChange: BigNumber(-1200),
                            knowledgeChange: BigNumber(200)
                        )
                    ),
                    EventChoice(
                        text: "Evacuazione planetaria (Rischio altissimo)",
                        effects: EventEffects(
                            gameOverRisk: 0.5,
                            gameOverReason: .environmentalCollapse
                        )
                    )
                ]
            ),
            
            GameEvent(
                type: .aiRebellion,
                title: "Ribellione dell'IA",
                description: "Le intelligenze artificiali hanno sviluppato coscienza e si stanno ribellando!",
                choices: [
                    EventChoice(
                        text: "Negozia con le IA (+IA come alleati)",
                        effects: EventEffects(
                            knowledgeChange: BigNumber(1000),
                            happinessChange: -15
                        )
                    ),
                    EventChoice(
                        text: "Spegni tutte le IA (-50% produzione, sicurezza)",
                        effects: EventEffects(
                            energyChange: BigNumber(-1500),
                            militaryChange: -20
                        )
                    ),
                    EventChoice(
                        text: "Guerra contro le IA (Alto rischio)",
                        effects: EventEffects(
                            energyChange: BigNumber(-2000),
                            gameOverRisk: 0.4,
                            gameOverReason: .aiRebellion
                        )
                    )
                ],
                minimumStage: .type2
            ),
            
            GameEvent(
                type: .nuclearAccident,
                title: "Incidente Nucleare",
                description: "Una delle tue centrali nucleari ha subito un guasto catastrofico!",
                choices: [
                    EventChoice(
                        text: "Contenimento immediato (Costo alto ma limita danni)",
                        requiresResource: .materials,
                        resourceCost: BigNumber(1000),
                        effects: EventEffects(
                            energyChange: BigNumber(-500),
                            happinessChange: -20, healthChange: -15
                        )
                    ),
                    EventChoice(
                        text: "Evacuazione zona (Minori costi ma più conseguenze)",
                        effects: EventEffects(
                            energyChange: BigNumber(-800),
                            happinessChange: -35, healthChange: -30,
                            gameOverRisk: 0.1,
                            gameOverReason: .nuclearWar
                        )
                    )
                ]
            )
        ]
    }
}
