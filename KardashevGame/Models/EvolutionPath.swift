//
//  EvolutionPath.swift
//  KardashevGame
//
//  Sistema percorsi evolutivi con decisioni strategiche
//

import Foundation
import SwiftUI

/// Percorso evolutivo della civiltà
enum CivilizationEvolutionPath: String, Codable, CaseIterable {
    case baseBiological = "Base Biologica"
    case pureBiological = "Biologica Pura"
    case geneticallyEnhanced = "Geneticamente Potenziata"
    case cyborg = "Cyborg"
    case digitalUploaded = "Digitale Uploaded"
    case ai = "IA"
    case collectiveMind = "Mente Collettiva"
    case synthetic = "Sintetica"
    case transcendent = "Trascendente"
    
    var description: String {
        switch self {
        case .baseBiological:
            return "Umani biologici senza modifiche. Alta adattabilità, crescita lenta."
        case .pureBiological:
            return "Evoluzione biologica naturale ottimizzata. Bonus felicità e salute."
        case .geneticallyEnhanced:
            return "Modifiche genetiche avanzate. Maggiore efficienza, minore felicità iniziale."
        case .cyborg:
            return "Integrazione uomo-macchina. Bonus produzione, costi militari ridotti."
        case .digitalUploaded:
            return "Coscienze trasferite in substrati digitali. No limiti biologici."
        case .ai:
            return "Civiltà di intelligenze artificiali. Massima efficienza, no felicità."
        case .collectiveMind:
            return "Mente alveare collettiva. Bonus coordinazione, perdita individualità."
        case .synthetic:
            return "Esseri completamente artificiali. Immunità a molti disastri."
        case .transcendent:
            return "Oltre la materia fisica. Accesso a nuove dimensioni della realtà."
        }
    }
    
    var icon: String {
        switch self {
        case .baseBiological: return "👤"
        case .pureBiological: return "🧬"
        case .geneticallyEnhanced: return "💪"
        case .cyborg: return "🤖"
        case .digitalUploaded: return "💾"
        case .ai: return "🧠"
        case .collectiveMind: return "👁️"
        case .synthetic: return "⚙️"
        case .transcendent: return "✨"
        }
    }
    
    var bonuses: EvolutionBonuses {
        switch self {
        case .baseBiological:
            return EvolutionBonuses(
                productionMultiplier: 1.0,
                researchSpeed: 1.0,
                happinessBonus: 0,
                disasterResistance: 0,
                militaryCostReduction: 0
            )
        case .pureBiological:
            return EvolutionBonuses(
                productionMultiplier: 1.1,
                researchSpeed: 1.2,
                happinessBonus: 15,
                disasterResistance: 10,
                militaryCostReduction: 0
            )
        case .geneticallyEnhanced:
            return EvolutionBonuses(
                productionMultiplier: 1.3,
                researchSpeed: 1.5,
                happinessBonus: -10,
                disasterResistance: 20,
                militaryCostReduction: 0
            )
        case .cyborg:
            return EvolutionBonuses(
                productionMultiplier: 1.5,
                researchSpeed: 1.3,
                happinessBonus: -5,
                disasterResistance: 30,
                militaryCostReduction: 25
            )
        case .digitalUploaded:
            return EvolutionBonuses(
                productionMultiplier: 2.0,
                researchSpeed: 2.0,
                happinessBonus: -20,
                disasterResistance: 50,
                militaryCostReduction: 50
            )
        case .ai:
            return EvolutionBonuses(
                productionMultiplier: 3.0,
                researchSpeed: 3.0,
                happinessBonus: -100,
                disasterResistance: 70,
                militaryCostReduction: 40
            )
        case .collectiveMind:
            return EvolutionBonuses(
                productionMultiplier: 2.5,
                researchSpeed: 2.5,
                happinessBonus: 20,
                disasterResistance: 40,
                militaryCostReduction: 30
            )
        case .synthetic:
            return EvolutionBonuses(
                productionMultiplier: 2.8,
                researchSpeed: 2.2,
                happinessBonus: -30,
                disasterResistance: 80,
                militaryCostReduction: 60
            )
        case .transcendent:
            return EvolutionBonuses(
                productionMultiplier: 5.0,
                researchSpeed: 5.0,
                happinessBonus: 50,
                disasterResistance: 100,
                militaryCostReduction: 90
            )
        }
    }
    
    var unlockStage: KardashevStage {
        switch self {
        case .baseBiological, .pureBiological, .geneticallyEnhanced:
            return .type1
        case .cyborg, .digitalUploaded, .collectiveMind:
            return .type2
        case .ai, .synthetic, .transcendent:
            return .type3
        }
    }
    
    var unlockCost: EvolutionCost {
        switch self {
        case .baseBiological:
            return EvolutionCost() // Default, no cost
        case .pureBiological:
            return EvolutionCost(energy: BigNumber(500), knowledge: BigNumber(1000))
        case .geneticallyEnhanced:
            return EvolutionCost(materials: BigNumber(2000), knowledge: BigNumber(5000))
        case .cyborg:
            return EvolutionCost(energy: BigNumber(5000), materials: BigNumber(10000), knowledge: BigNumber(20000))
        case .digitalUploaded:
            return EvolutionCost(energy: BigNumber(50000), knowledge: BigNumber(100000))
        case .ai:
            return EvolutionCost(energy: BigNumber(200000), knowledge: BigNumber(500000))
        case .collectiveMind:
            return EvolutionCost(food: BigNumber(30000), knowledge: BigNumber(80000))
        case .synthetic:
            return EvolutionCost(materials: BigNumber(150000), knowledge: BigNumber(300000))
        case .transcendent:
            return EvolutionCost(
                energy: BigNumber(1000000),
                food: BigNumber(500000), materials: BigNumber(500000), knowledge: BigNumber(1000000)
            )
        }
    }
}

/// Bonus forniti da un percorso evolutivo
struct EvolutionBonuses: Codable {
    var productionMultiplier: Double
    var researchSpeed: Double
    var happinessBonus: Double
    var disasterResistance: Double  // 0-100%
    var militaryCostReduction: Double  // 0-100%
}

/// Costo per sbloccare un percorso evolutivo
struct EvolutionCost: Codable {
    var energy: BigNumber = BigNumber(0)
    var food: BigNumber = BigNumber(0)
    var materials: BigNumber = BigNumber(0)
    var knowledge: BigNumber = BigNumber(0)
}

/// Decisione strategica maggiore
enum StrategicDecision: String, Codable, CaseIterable {
    // Stage 1 Decisions
    case energyFocus = "Focus Energia"
    case balancedGrowth = "Crescita Bilanciata"
    case rapidExpansion = "Espansione Rapida"
    case militaryFirst = "Militare Prima di Tutto"
    case scienceFirst = "Scienza Prima di Tutto"
    
    // Stage 2 Decisions
    case dysonSphere = "Costruisci Sfera di Dyson"
    case multiplePlanets = "Colonizza Pianeti Multipli"
    case antimatterFocus = "Focus Antimateria"
    case quantumResearch = "Ricerca Quantistica"
    case interstellarTrade = "Commercio Interstellare"
    
    // Stage 3 Decisions
    case galacticEmpire = "Impero Galattico"
    case peacefulFederation = "Federazione Pacifica"
    case technocracy = "Tecnocrazia"
    case hiveMind = "Mente Alveare"
    case isolation = "Isolazionismo"
    
    // Philosophical Decisions
    case preserveHumanity = "Preserva Umanità"
    case embraceChange = "Abbraccia il Cambiamento"
    case seekTranscendence = "Cerca Trascendenza"
    case controlEvolution = "Controlla Evoluzione"
    case naturalSelection = "Selezione Naturale"
    
    // Economic Decisions
    case freeMarket = "Libero Mercato"
    case plannedEconomy = "Economia Pianificata"
    case resourceSharing = "Condivisione Risorse"
    case competitiveGrowth = "Crescita Competitiva"
    case sustainableDevelopment = "Sviluppo Sostenibile"
    
    // Military Decisions
    case defensivePact = "Patto Difensivo"
    case preemptiveStrike = "Attacco Preventivo"
    case armsRace = "Corsa agli Armamenti"
    case disarmament = "Disarmo"
    case deterrence = "Deterrenza"
    
    // Diplomatic Decisions
    case openBorders = "Frontiere Aperte"
    case strictBorders = "Frontiere Chiuse"
    case culturalExchange = "Scambio Culturale"
    case assimilation = "Assimilazione"
    case coexistence = "Coesistenza"
    
    var description: String {
        switch self {
        case .energyFocus:
            return "Concentrati sulla produzione di energia. +50% energia, -20% altre risorse."
        case .balancedGrowth:
            return "Crescita equilibrata in tutte le aree. Bonus 10% a tutto."
        case .rapidExpansion:
            return "Espansione rapida a costo di stabilità. +100% crescita, -30% felicità."
        case .militaryFirst:
            return "Priorità al militare. +50% militare, costi energetici +30%."
        case .scienceFirst:
            return "Priorità alla ricerca. +80% velocità ricerca, -20% produzione."
        case .dysonSphere:
            return "Costruisci una Sfera di Dyson. Energia infinita ma costo altissimo."
        case .multiplePlanets:
            return "Colonizza pianeti multipli. +200% spazio, gestione più complessa."
        case .antimatterFocus:
            return "Focus su energia antimateria. x5 produzione energia, rischio instabilità."
        case .quantumResearch:
            return "Sblocca tecnologie quantistiche. Accesso a nuove possibilità."
        case .interstellarTrade:
            return "Stabilisci rotte commerciali. +50% tutte le risorse, dipendenza esterna."
        case .galacticEmpire:
            return "Forma un impero galattico. Controllo totale, alto costo militare."
        case .peacefulFederation:
            return "Crea federazione pacifica. Bonus diplomatici, vulnerabilità militare."
        case .technocracy:
            return "Governo dei tecnocrati. +100% efficienza, -50% felicità."
        case .hiveMind:
            return "Diventa mente collettiva. Perfetta coordinazione, nessuna libertà."
        case .isolation:
            return "Isola la civiltà. Autosufficienza, nessun supporto esterno."
        case .preserveHumanity:
            return "Mantieni l'umanità originale. Limiti biologici, identità preservata."
        case .embraceChange:
            return "Accetta il cambiamento radicale. Perdita identità, nuove capacità."
        case .seekTranscendence:
            return "Cerca la trascendenza. Oltre la realtà fisica."
        case .controlEvolution:
            return "Controlla rigidamente l'evoluzione. Stabilità ma rigidità."
        case .naturalSelection:
            return "Lascia che la natura faccia il suo corso. Imprevedibile ma autentico."
        case .freeMarket:
            return "Economia di libero mercato. Alta crescita, alta instabilità."
        case .plannedEconomy:
            return "Economia pianificata centralmente. Stabile ma lenta."
        case .resourceSharing:
            return "Condividi risorse equamente. +30% felicità, -20% efficienza."
        case .competitiveGrowth:
            return "Crescita competitiva. +50% crescita, -40% cooperazione."
        case .sustainableDevelopment:
            return "Sviluppo sostenibile. Crescita lenta ma permanente."
        case .defensivePact:
            return "Patti difensivi con altri. Sicurezza, vincoli diplomatici."
        case .preemptiveStrike:
            return "Attacca prima di essere attaccato. Elimina minacce, ostilità universale."
        case .armsRace:
            return "Corsa agli armamenti. Massimo militare, economia devastata."
        case .disarmament:
            return "Disarmo completo. Risorse liberate, vulnerabilità."
        case .deterrence:
            return "Deterrenza nucleare. Equilibrio del terrore."
        case .openBorders:
            return "Frontiere aperte a tutti. +50% cultura, rischi sicurezza."
        case .strictBorders:
            return "Frontiere chiuse. Sicurezza, isolamento."
        case .culturalExchange:
            return "Scambio culturale attivo. +40% conoscenza, influenza esterna."
        case .assimilation:
            return "Assimila altre culture. Uniformità, conflitti."
        case .coexistence:
            return "Coesistenza pacifica. Diversità, complessità gestionale."
        }
    }
    
    var effects: DecisionEffects {
        switch self {
        case .energyFocus:
            return DecisionEffects(energyMult: 1.5, otherResourcesMult: 0.8)
        case .balancedGrowth:
            return DecisionEffects(allResourcesMult: 1.1)
        case .rapidExpansion:
            return DecisionEffects(growthRate: 2.0, happinessChange: -30)
        case .militaryFirst:
            return DecisionEffects(energyMult: 0.7, militaryBonus: 50)
        case .scienceFirst:
            return DecisionEffects(productionMult: 0.8, researchSpeed: 1.8)
        case .dysonSphere:
            return DecisionEffects(energyMult: 100.0, initialCost: BigNumber(1000000))
        case .multiplePlanets:
            return DecisionEffects(allResourcesMult: 3.0, managementComplexity: 2.0)
        case .antimatterFocus:
            return DecisionEffects(energyMult: 5.0, instabilityRisk: 0.2)
        case .quantumResearch:
            return DecisionEffects(knowledgeMult: 1.5, researchSpeed: 2.0)
        case .interstellarTrade:
            return DecisionEffects(allResourcesMult: 1.5, externalDependency: 0.3)
        case .galacticEmpire:
            return DecisionEffects(militaryBonus: 100, militaryCost: 2.0)
        case .peacefulFederation:
            return DecisionEffects(happinessChange: 40, militaryBonus: -30)
        case .technocracy:
            return DecisionEffects(productionMult: 2.0, happinessChange: -50)
        case .hiveMind:
            return DecisionEffects(happinessChange: -100, coordinationBonus: 3.0)
        case .isolation:
            return DecisionEffects(externalSupport: 0.0, selfSufficiency: 1.5)
        case .preserveHumanity:
            return DecisionEffects(identityPreserved: true, biologicalLimits: true)
        case .embraceChange:
            return DecisionEffects(identityPreserved: false, newCapabilities: true)
        case .seekTranscendence:
            return DecisionEffects(transcendenceBonus: 5.0)
        case .controlEvolution:
            return DecisionEffects(stabilityBonus: 50, flexibilityPenalty: -30)
        case .naturalSelection:
            return DecisionEffects(randomness: 0.5, authenticity: true)
        case .freeMarket:
            return DecisionEffects(growthRate: 1.8, instabilityRisk: 0.3)
        case .plannedEconomy:
            return DecisionEffects(growthRate: 0.7, stabilityBonus: 40)
        case .resourceSharing:
            return DecisionEffects(productionMult: 0.8, happinessChange: 30)
        case .competitiveGrowth:
            return DecisionEffects(growthRate: 1.5, cooperationPenalty: -40)
        case .sustainableDevelopment:
            return DecisionEffects(growthRate: 0.5, sustainability: true)
        case .defensivePact:
            return DecisionEffects(securityBonus: 40, diplomaticConstraints: true)
        case .preemptiveStrike:
            return DecisionEffects(militaryBonus: 50, diplomaticPenalty: -80)
        case .armsRace:
            return DecisionEffects(militaryBonus: 100, economicPenalty: -60)
        case .disarmament:
            return DecisionEffects(militaryBonus: -100, resourcesFreed: 1.5)
        case .deterrence:
            return DecisionEffects(militaryBonus: 30, stabilityBonus: 20)
        case .openBorders:
            return DecisionEffects(securityRisk: 0.2, cultureBonus: 50)
        case .strictBorders:
            return DecisionEffects(securityBonus: 50, isolationPenalty: -30)
        case .culturalExchange:
            return DecisionEffects(knowledgeMult: 1.4, culturalInfluence: 0.3)
        case .assimilation:
            return DecisionEffects(conflictRisk: 0.3, uniformityBonus: 30)
        case .coexistence:
            return DecisionEffects(diversityBonus: 40, complexityPenalty: 20)
        }
    }
    
    var unlockStage: KardashevStage {
        switch self {
        case .energyFocus, .balancedGrowth, .rapidExpansion, .militaryFirst, .scienceFirst,
             .preserveHumanity, .embraceChange, .naturalSelection, .freeMarket, .plannedEconomy:
            return .type1
        case .dysonSphere, .multiplePlanets, .antimatterFocus, .quantumResearch, .interstellarTrade,
             .controlEvolution, .resourceSharing, .competitiveGrowth, .sustainableDevelopment,
             .defensivePact, .preemptiveStrike, .armsRace, .disarmament, .deterrence:
            return .type2
        case .galacticEmpire, .peacefulFederation, .technocracy, .hiveMind, .isolation,
             .seekTranscendence, .openBorders, .strictBorders, .culturalExchange, .assimilation, .coexistence:
            return .type3
        }
    }
}

/// Effetti di una decisione strategica
struct DecisionEffects: Codable {
    var energyMult: Double = 1.0
    var foodMult: Double = 1.0
    var materialsMult: Double = 1.0
    var knowledgeMult: Double = 1.0
    var allResourcesMult: Double = 1.0
    var otherResourcesMult: Double = 1.0
    
    var productionMult: Double = 1.0
    var researchSpeed: Double = 1.0
    var growthRate: Double = 1.0
    
    var happinessChange: Double = 0
    var militaryBonus: Double = 0
    var militaryCost: Double = 1.0
    var stabilityBonus: Double = 0
    var securityBonus: Double = 0
    
    var instabilityRisk: Double = 0
    var securityRisk: Double = 0
    var conflictRisk: Double = 0
    var randomness: Double = 0
    
    var managementComplexity: Double = 1.0
    var externalDependency: Double = 0
    var coordinationBonus: Double = 1.0
    
    var identityPreserved: Bool = true
    var biologicalLimits: Bool = false
    var newCapabilities: Bool = false
    var transcendenceBonus: Double = 0
    var flexibilityPenalty: Double = 0
    var authenticity: Bool = false
    var sustainability: Bool = false
    var diplomaticConstraints: Bool = false
    var diplomaticPenalty: Double = 0
    var economicPenalty: Double = 0
    var resourcesFreed: Double = 1.0
    var cultureBonus: Double = 0
    var isolationPenalty: Double = 0
    var culturalInfluence: Double = 0
    var uniformityBonus: Double = 0
    var diversityBonus: Double = 0
    var complexityPenalty: Double = 0
    var externalSupport: Double = 1.0
    var selfSufficiency: Double = 1.0
    var cooperationPenalty: Double = 0
    var initialCost: BigNumber = BigNumber(0)
}

/// Manager per percorsi evolutivi e decisioni
class EvolutionManager {
    static let shared = EvolutionManager()
    
    private init() {}
    
    /// Verifica se può sbloccare un percorso evolutivo
    func canUnlock(_ path: CivilizationEvolutionPath, gameState: GameState) -> Bool {
        // Check stage requirement
        guard gameState.civilization.stage.rawValue >= path.unlockStage.rawValue else {
            return false
        }
        
        let cost = path.unlockCost
        
        // Check resource requirements
        return gameState.resources.energy.canAfford(cost.energy) &&
               gameState.resources.food.canAfford(cost.food) &&
               gameState.resources.materials.canAfford(cost.materials) &&
               gameState.resources.knowledge.canAfford(cost.knowledge)
    }
    
    /// Sblocca un percorso evolutivo
    func unlock(_ path: CivilizationEvolutionPath, in run: Run) -> Bool {
        guard canUnlock(path, gameState: run.gameState) else {
            return false
        }
        
        let cost = path.unlockCost
        
        // Deduct costs
        run.gameState.resources.energy.subtract(cost.energy)
        run.gameState.resources.food.subtract(cost.food)
        run.gameState.resources.materials.subtract(cost.materials)
        run.gameState.resources.knowledge.subtract(cost.knowledge)
        
        // Set evolution path
        run.evolutionPath = EvolutionPath(rawValue: path.rawValue)
        
        // Apply bonuses
        applyEvolutionBonuses(path, to: run.gameState)
        
        print("✨ Percorso evolutivo sbloccato: \(path.rawValue)")
        return true
    }
    
    /// Applica i bonus del percorso evolutivo
    private func applyEvolutionBonuses(_ path: CivilizationEvolutionPath, to gameState: GameState) {
        let bonuses = path.bonuses
        
        // Apply happiness bonus
        gameState.civilization.parameters.happiness = max(0, min(100,
            gameState.civilization.parameters.happiness + bonuses.happinessBonus))
        
        // Note: Other bonuses (multipliers) should be applied in production calculations
    }
    
    /// Registra una decisione strategica
    func makeDecision(_ decision: StrategicDecision, in run: Run) {
        run.majorDecisions.append(decision.rawValue)
        
        // Apply decision effects
        applyDecisionEffects(decision, to: run.gameState)
        
        print("⚖️ Decisione presa: \(decision.rawValue)")
    }
    
    /// Applica gli effetti di una decisione
    private func applyDecisionEffects(_ decision: StrategicDecision, to gameState: GameState) {
        let effects = decision.effects
        
        // Apply happiness changes
        gameState.civilization.parameters.happiness = max(0, min(100,
            gameState.civilization.parameters.happiness + effects.happinessChange))
        
        // Apply military changes
        gameState.civilization.parameters.military = max(0, min(100,
            gameState.civilization.parameters.military + effects.militaryBonus))
        
        // Apply resource costs if any
        if effects.initialCost > BigNumber(0) {
            gameState.resources.energy.subtract(effects.initialCost)
        }
        
        // Note: Multipliers should be applied in production calculations
    }
}
