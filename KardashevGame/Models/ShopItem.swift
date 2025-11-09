//
//  ShopItem.swift
//  KardashevGame
//
//  Sistema shop espanso con categorie multiple
//

import Foundation

/// Categoria di item nello shop
enum ShopCategory: String, Codable, CaseIterable {
    case generators = "Generatori"
    case infrastructure = "Infrastruttura"
    case research = "Ricerca"
    case civilization = "Civiltà"
    case military = "Militare"
    
    var icon: String {
        switch self {
        case .generators: return "⚡️"
        case .infrastructure: return "🏗️"
        case .research: return "🔬"
        case .civilization: return "🏛️"
        case .military: return "⚔️"
        }
    }
}

/// Tipo di item dello shop
enum ShopItemType: String, Codable, CaseIterable {
    // Generators
    case solarGenerator = "Generatore Solare"
    case nuclearPlant = "Centrale Nucleare"
    case fusionPlant = "Centrale a Fusione"
    case orbitalFarm = "Fattoria Solare Orbitale"
    case antimatterReactor = "Reattore Antimateria"
    
    // Infrastructure
    case powerGrid = "Rete Elettrica"
    case spaceElevator = "Ascensore Spaziale"
    case miningFacility = "Impianto Minerario"
    case waterProcessing = "Impianto Idrico"
    case foodFactory = "Fattoria Automatizzata"
    
    // Research
    case quantumComputer = "Computer Quantistico"
    case aiResearchLab = "Laboratorio AI"
    case nanoTech = "Laboratorio Nanotecnologie"
    case bioLab = "Laboratorio Biologico"
    case fusionResearch = "Ricerca Fusione"
    
    // Civilization
    case happinessProgram = "Programma Felicità"
    case transportNetwork = "Rete Trasporti"
    case foodSecurity = "Sicurezza Alimentare"
    case educationSystem = "Sistema Educativo"
    case healthCare = "Sistema Sanitario"
    
    // Military
    case defenseSystem = "Sistema Difensivo"
    case spaceFleet = "Flotta Spaziale"
    case planetaryShield = "Scudo Planetario"
    case weaponResearch = "Ricerca Armamenti"
    case earlyWarning = "Sistema Allerta"
    
    var category: ShopCategory {
        switch self {
        case .solarGenerator, .nuclearPlant, .fusionPlant, .orbitalFarm, .antimatterReactor:
            return .generators
        case .powerGrid, .spaceElevator, .miningFacility, .waterProcessing, .foodFactory:
            return .infrastructure
        case .quantumComputer, .aiResearchLab, .nanoTech, .bioLab, .fusionResearch:
            return .research
        case .happinessProgram, .transportNetwork, .foodSecurity, .educationSystem, .healthCare:
            return .civilization
        case .defenseSystem, .spaceFleet, .planetaryShield, .weaponResearch, .earlyWarning:
            return .military
        }
    }
    
    var icon: String {
        switch self {
        case .solarGenerator: return "☀️"
        case .nuclearPlant: return "⚛️"
        case .fusionPlant: return "🔥"
        case .orbitalFarm: return "🛰"
        case .antimatterReactor: return "💫"
        case .powerGrid: return "🔌"
        case .spaceElevator: return "🚀"
        case .miningFacility: return "⛏️"
        case .waterProcessing: return "💧"
        case .foodFactory: return "🏭"
        case .quantumComputer: return "🖥️"
        case .aiResearchLab: return "🤖"
        case .nanoTech: return "🔬"
        case .bioLab: return "🧬"
        case .fusionResearch: return "⚗️"
        case .happinessProgram: return "😊"
        case .transportNetwork: return "🚄"
        case .foodSecurity: return "🌾"
        case .educationSystem: return "📚"
        case .healthCare: return "🏥"
        case .defenseSystem: return "🛡️"
        case .spaceFleet: return "🚀"
        case .planetaryShield: return "🌐"
        case .weaponResearch: return "⚔️"
        case .earlyWarning: return "📡"
        }
    }
    
    var description: String {
        switch self {
        case .solarGenerator: return "Pannelli solari per energia pulita"
        case .nuclearPlant: return "Centrali nucleari per produzione stabile"
        case .fusionPlant: return "Reattori a fusione nucleare avanzati"
        case .orbitalFarm: return "Stazioni orbitali per energia solare"
        case .antimatterReactor: return "Generatori ad antimateria ultrapotenti"
        case .powerGrid: return "Aumenta l'efficienza di tutti i generatori del 10%"
        case .spaceElevator: return "Riduce i costi di costruzione spaziale del 20%"
        case .miningFacility: return "Aumenta produzione materiali del 50%"
        case .waterProcessing: return "Aumenta produzione cibo del 30%"
        case .foodFactory: return "Produzione cibo automatizzata +100%"
        case .quantumComputer: return "Aumenta velocità ricerca del 100%"
        case .aiResearchLab: return "Ricerca automatica conoscenza +50/s"
        case .nanoTech: return "Riduce costi edifici del 15%"
        case .bioLab: return "Aumenta efficienza popolazione del 25%"
        case .fusionResearch: return "Sblocca tecnologie fusione avanzate"
        case .happinessProgram: return "Aumenta Felicità di 10 punti"
        case .transportNetwork: return "Aumenta Trasporti di 10 punti"
        case .foodSecurity: return "Aumenta Cibo di 10 punti"
        case .educationSystem: return "Aumenta Educazione di 10 punti"
        case .healthCare: return "Aumenta Sanità di 10 punti"
        case .defenseSystem: return "Aumenta Militare di 10 punti, riduce rischio eventi negativi"
        case .spaceFleet: return "Protezione contro invasioni, +20 Militare"
        case .planetaryShield: return "Riduce danno disastri naturali del 50%"
        case .weaponResearch: return "Sblocca armamenti avanzati, +15 Militare"
        case .earlyWarning: return "Aumenta tempo preavviso eventi del 200%"
        }
    }
    
    var baseCost: Double {
        switch self {
        case .solarGenerator: return 10
        case .nuclearPlant: return 100
        case .fusionPlant: return 1_100
        case .orbitalFarm: return 12_000
        case .antimatterReactor: return 150_000
        case .powerGrid: return 5_000
        case .spaceElevator: return 50_000
        case .miningFacility: return 8_000
        case .waterProcessing: return 3_000
        case .foodFactory: return 25_000
        case .quantumComputer: return 100_000
        case .aiResearchLab: return 200_000
        case .nanoTech: return 75_000
        case .bioLab: return 45_000
        case .fusionResearch: return 500_000
        case .happinessProgram: return 10_000
        case .transportNetwork: return 15_000
        case .foodSecurity: return 12_000
        case .educationSystem: return 20_000
        case .healthCare: return 18_000
        case .defenseSystem: return 30_000
        case .spaceFleet: return 250_000
        case .planetaryShield: return 500_000
        case .weaponResearch: return 100_000
        case .earlyWarning: return 50_000
        }
    }
    
    var costMultiplier: Double {
        switch self {
        case .solarGenerator, .nuclearPlant, .fusionPlant, .orbitalFarm, .antimatterReactor:
            return 1.15 // Generatori scalano come prima
        default:
            return 1.25 // Altri items scalano più velocemente
        }
    }
    
    var unlockStage: KardashevStage {
        switch self {
        case .solarGenerator, .nuclearPlant, .powerGrid, .happinessProgram, .defenseSystem:
            return .type1
        case .fusionPlant, .orbitalFarm, .spaceElevator, .miningFacility, .waterProcessing,
             .foodFactory, .transportNetwork, .foodSecurity, .educationSystem, .healthCare:
            return .type1
        case .antimatterReactor, .quantumComputer, .aiResearchLab, .nanoTech, .bioLab,
             .fusionResearch, .spaceFleet, .planetaryShield, .weaponResearch, .earlyWarning:
            return .type2
        }
    }
    
    var requiresResource: ResourceType {
        switch category {
        case .generators, .infrastructure: return .energy
        case .research: return .knowledge
        case .civilization: return .food
        case .military: return .materials
        }
    }
}

/// Item acquistabile nello shop
struct ShopItem: Codable, Identifiable {
    let id: UUID
    let type: ShopItemType
    var level: BigNumber
    var unlocked: Bool
    
    init(type: ShopItemType, level: BigNumber = BigNumber(0), unlocked: Bool = false) {
        self.id = UUID()
        self.type = type
        self.level = level
        self.unlocked = unlocked
    }
    
    /// Calcola il costo per il prossimo livello
    func nextLevelCost() -> BigNumber {
        let cost = type.baseCost * pow(type.costMultiplier, level.toDouble() ?? 0)
        return BigNumber(cost)
    }
    
    /// Calcola l'effetto corrente dell'item
    func currentEffect() -> Double {
        guard level > BigNumber(0) else { return 0 }
        let levelDouble = level.toDouble() ?? 0
        
        switch type.category {
        case .generators:
            // I generatori hanno una produzione
            let baseProduction: Double
            switch type {
            case .antimatterReactor: baseProduction = 500.0
            default: baseProduction = 0 // Gli altri sono già gestiti da Building
            }
            return baseProduction * levelDouble
        case .infrastructure, .research, .military:
            // Effetti moltiplicativi
            return levelDouble * 0.1 // 10% per livello
        case .civilization:
            // Bonus ai parametri
            return levelDouble * 10.0 // +10 per livello
        }
    }
}
