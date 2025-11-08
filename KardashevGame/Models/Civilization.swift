//
//  Civilization.swift
//  KardashevGame
//
//  Modello della civiltà del giocatore
//

import Foundation

/// Rappresenta la civiltà del giocatore
struct Civilization: Codable {
    var stage: KardashevStage
    var prestigeLevel: Int
    var prestigeMultiplier: Double
    var totalClicks: Int
    var totalEnergyGenerated: BigNumber
    
    init() {
        self.stage = .type1
        self.prestigeLevel = 0
        self.prestigeMultiplier = 1.0
        self.totalClicks = 0
        self.totalEnergyGenerated = BigNumber(0)
    }
    
    /// Calcola il bonus click corrente
    func clickReward() -> BigNumber {
        let baseReward = BalanceConfig.baseClickReward * stage.clickMultiplier
        return BigNumber(baseReward * prestigeMultiplier)
    }
    
    /// Esegue un prestige
    mutating func performPrestige() {
        prestigeLevel += 1
        prestigeMultiplier = 1.0 + (Double(prestigeLevel) * BalanceConfig.prestigeMultiplierBase)
    }
    
    /// Verifica se può avanzare allo stage successivo
    func canAdvanceStage(currentEnergy: BigNumber) -> Bool {
        guard let nextStage = KardashevStage(rawValue: stage.rawValue + 1) else {
            return false
        }
        return currentEnergy >= nextStage.unlockCost
    }
    
    /// Avanza allo stage successivo
    mutating func advanceStage() {
        if let nextStage = KardashevStage(rawValue: stage.rawValue + 1) {
            stage = nextStage
        }
    }
}
