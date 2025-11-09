//
//  Building.swift
//  KardashevGame
//
//  Rappresenta edifici/generatori del gioco
//

import Foundation

/// Tipo di edificio
enum BuildingType: String, Codable, CaseIterable {
    case solarGenerator = "Generatore Solare"
    case nuclearPlant = "Centrale Nucleare"
    case fusionPlant = "Centrale a Fusione"
    case orbitalFarm = "Fattoria Solare Orbitale"
    
    var description: String {
        switch self {
        case .solarGenerator:
            return "Pannelli solari che convertono la luce del sole in energia"
        case .nuclearPlant:
            return "Centrali nucleari per una produzione energetica stabile"
        case .fusionPlant:
            return "Reattori a fusione nucleare per energia pulita"
        case .orbitalFarm:
            return "Stazioni orbitali che raccolgono energia solare senza atmosfera"
        }
    }
    
    var icon: String {
        switch self {
        case .solarGenerator:
            return "☀️"
        case .nuclearPlant:
            return "⚛️"
        case .fusionPlant:
            return "🔥"
        case .orbitalFarm:
            return "🛰"
        }
    }
    
    var baseCost: Double {
        switch self {
        case .solarGenerator:
            return BalanceConfig.solarGeneratorBaseCost
        case .nuclearPlant:
            return BalanceConfig.nuclearPlantBaseCost
        case .fusionPlant:
            return BalanceConfig.fusionPlantBaseCost
        case .orbitalFarm:
            return BalanceConfig.orbitalFarmBaseCost
        }
    }
    
    var baseProduction: Double {
        switch self {
        case .solarGenerator:
            return BalanceConfig.solarGeneratorBaseProduction
        case .nuclearPlant:
            return BalanceConfig.nuclearPlantBaseProduction
        case .fusionPlant:
            return BalanceConfig.fusionPlantBaseProduction
        case .orbitalFarm:
            return BalanceConfig.orbitalFarmBaseProduction
        }
    }
    
    var costMultiplier: Double {
        switch self {
        case .solarGenerator:
            return BalanceConfig.solarGeneratorCostMultiplier
        case .nuclearPlant:
            return BalanceConfig.nuclearPlantCostMultiplier
        case .fusionPlant:
            return BalanceConfig.fusionPlantCostMultiplier
        case .orbitalFarm:
            return BalanceConfig.orbitalFarmCostMultiplier
        }
    }
    
    var productionMultiplier: Double {
        switch self {
        case .solarGenerator:
            return BalanceConfig.solarGeneratorProductionMultiplier
        case .nuclearPlant:
            return BalanceConfig.nuclearPlantProductionMultiplier
        case .fusionPlant:
            return BalanceConfig.fusionPlantProductionMultiplier
        case .orbitalFarm:
            return BalanceConfig.orbitalFarmProductionMultiplier
        }
    }
    
    var unlockStage: KardashevStage {
        switch self {
        case .solarGenerator, .nuclearPlant:
            return .type1
        case .fusionPlant, .orbitalFarm:
            return .type1
        }
    }
    
    var unlockCost: BigNumber {
        switch self {
        case .solarGenerator:
            return BigNumber(0) // Sempre disponibile
        case .nuclearPlant:
            return BigNumber(0) // Sempre disponibile
        case .fusionPlant:
            return BigNumber(500)
        case .orbitalFarm:
            return BigNumber(5000)
        }
    }
}

/// Rappresenta un edificio posseduto dal giocatore
struct Building: Codable, Identifiable {
    let id: UUID
    let type: BuildingType
    var level: BigNumber
    var unlocked: Bool
    
    init(type: BuildingType, level: BigNumber = BigNumber(0), unlocked: Bool = false) {
        self.id = UUID()
        self.type = type
        self.level = level
        self.unlocked = unlocked
    }
    
    /// Calcola il costo per comprare il prossimo livello
    func nextLevelCost() -> BigNumber {
        return BalanceConfig.buildingCost(
            baseCost: type.baseCost,
            level: level,
            multiplier: type.costMultiplier
        )
    }
    
    /// Calcola la produzione totale di questo edificio
    func totalProduction() -> BigNumber {
        if level <= BigNumber(0) {
            return BigNumber(0)
        }
        return BalanceConfig.buildingProduction(
            baseProduction: type.baseProduction,
            level: level,
            multiplier: type.productionMultiplier
        )
    }
    
    /// Verifica se può essere sbloccato
    func canUnlock(with energy: BigNumber) -> Bool {
        if unlocked {
            return false
        }
        return energy >= type.unlockCost
    }
}
