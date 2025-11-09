//
//  BalanceConfig.swift
//  KardashevGame
//
//  Configurazione bilanciamento del gioco
//

import Foundation

struct BalanceConfig {
    // MARK: - Click Manuale
    static let baseClickReward = 1.0
    static let clickMultiplierPerStage = 2.0  // Ridotto da 10.0
    
    // MARK: - Generatore Solare (Primo generatore)
    static let solarGeneratorBaseCost = 10.0
    static let solarGeneratorBaseProduction = 0.1 // energia per secondo
    static let solarGeneratorCostMultiplier = 1.15
    static let solarGeneratorProductionMultiplier = 1.0 // Lineare
    
    // MARK: - Centrale Nucleare (Secondo generatore)
    static let nuclearPlantBaseCost = 100.0
    static let nuclearPlantBaseProduction = 0.5  // Ridotto da 1.0
    static let nuclearPlantCostMultiplier = 1.18  // Aumentato da 1.15
    static let nuclearPlantProductionMultiplier = 1.0
    
    // MARK: - Centrale a Fusione (Terzo generatore)
    static let fusionPlantBaseCost = 1_500.0  // Aumentato da 1_100
    static let fusionPlantBaseProduction = 3.0  // Ridotto da 8.0
    static let fusionPlantCostMultiplier = 1.20  // Aumentato da 1.15
    static let fusionPlantProductionMultiplier = 1.0
    
    // MARK: - Fattoria Solare Orbitale (Quarto generatore)
    static let orbitalFarmBaseCost = 20_000.0  // Aumentato da 12_000
    static let orbitalFarmBaseProduction = 15.0  // Ridotto da 47.0
    static let orbitalFarmCostMultiplier = 1.22  // Aumentato da 1.15
    static let orbitalFarmProductionMultiplier = 1.0
    
    // MARK: - Progression
    static let stage1ToStage2UnlockCost = 10_000_000.0  // Aumentato da 1M
    static let stage2ToStage3UnlockCost = 10_000_000_000.0  // Aumentato da 1B
    
    // MARK: - Prestige
    static let prestigeMinEnergy = 100_000.0
    static let prestigeMultiplierBase = 0.05 // 5% bonus per prestige
    
    // MARK: - Offline
    static let offlineMaxHours = 8.0
    static let offlineMultiplier = 0.5
    
    // MARK: - Auto-save
    static let autoSaveIntervalSeconds = 30.0
    
    /// Calcola il costo di un edificio al livello specificato
    static func buildingCost(baseCost: Double, level: BigNumber, multiplier: Double) -> BigNumber {
        // Usa la formula: baseCost * (multiplier ^ level)
        // Per evitare overflow, usiamo logaritmi: log(cost) = log(baseCost) + level * log(multiplier)
        
        // Calcola il livello come double se possibile, altrimenti usa approssimazione
        let levelValue: Double
        if let levelDouble = level.toDouble() {
            levelValue = levelDouble
        } else {
            // Per livelli enormi, usa mantissa * 10^exponent
            levelValue = level.mantissa * pow(10.0, Double(level.exponent))
        }
        
        // Usa logaritmi per calcolare in modo sicuro
        let logBaseCost = log10(baseCost)
        let logMultiplier = log10(multiplier)
        let logCost = logBaseCost + levelValue * logMultiplier
        
        // Converti back da logaritmo a BigNumber
        let exponent = Int(floor(logCost))
        let mantissa = pow(10.0, logCost - Double(exponent))
        return BigNumber(mantissa: mantissa, exponent: exponent)
    }
    
    /// Calcola la produzione di un edificio al livello specificato
    static func buildingProduction(baseProduction: Double, level: BigNumber, multiplier: Double) -> BigNumber {
        // Produzione = baseProduction * level * multiplier
        let baseBigNumber = BigNumber(baseProduction * multiplier)
        return baseBigNumber * level
    }
}
