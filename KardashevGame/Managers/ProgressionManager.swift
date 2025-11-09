//
//  ProgressionManager.swift
//  KardashevGame
//
//  Gestisce progressione, unlock e prestige
//

import Foundation

class ProgressionManager {
    static let shared = ProgressionManager()
    
    private init() {}
    
    /// Verifica e sblocca automaticamente edifici in base ai progressi
    func checkAutoUnlocks(gameState: GameState) {
        let currentEnergy = gameState.resources.energy.amount
        
        for (type, building) in gameState.buildings {
            if !building.unlocked && building.canUnlock(with: currentEnergy) {
                // Alcuni edifici si sbloccano automaticamente senza costo
                if type == .fusionPlant && currentEnergy >= BigNumber(500) {
                    if var updatedBuilding = gameState.buildings[type] {
                        updatedBuilding.unlocked = true
                        gameState.buildings[type] = updatedBuilding
                        print("🔓 Auto-sbloccato: \(type.rawValue)")
                    }
                }
                if type == .orbitalFarm && currentEnergy >= BigNumber(5000) {
                    if var updatedBuilding = gameState.buildings[type] {
                        updatedBuilding.unlocked = true
                        gameState.buildings[type] = updatedBuilding
                        print("🔓 Auto-sbloccato: \(type.rawValue)")
                    }
                }
            }
        }
    }
    
    /// Verifica se può fare prestige
    func canPrestige(gameState: GameState) -> Bool {
        return gameState.resources.energy.amount >= BigNumber(BalanceConfig.prestigeMinEnergy)
    }
    
    /// Esegue prestige (reset con bonus permanenti)
    func performPrestige(gameState: GameState) {
        guard canPrestige(gameState: gameState) else {
            return
        }
        
        // Salva informazioni importanti
        let oldPrestigeLevel = gameState.civilization.prestigeLevel
        
        // Esegui prestige nella civiltà
        gameState.civilization.performPrestige()
        
        // Reset risorse
        gameState.resources = ResourceCollection()
        
        // Reset edifici
        for type in BuildingType.allCases {
            let unlocked = (type == .solarGenerator || type == .nuclearPlant)
            gameState.buildings[type] = Building(type: type, level: BigNumber(0), unlocked: unlocked)
        }
        
        print("⭐️ Prestige \(oldPrestigeLevel) -> \(gameState.civilization.prestigeLevel)")
        print("   Moltiplicatore: \(gameState.civilization.prestigeMultiplier)x")
    }
    
    /// Verifica se può avanzare allo stage successivo
    func canAdvanceStage(gameState: GameState) -> Bool {
        return gameState.civilization.canAdvanceStage(currentEnergy: gameState.resources.energy.amount)
    }
    
    /// Avanza allo stage successivo
    func advanceStage(gameState: GameState) {
        guard canAdvanceStage(gameState: gameState) else {
            return
        }
        
        let oldStage = gameState.civilization.stage
        let cost = KardashevStage(rawValue: oldStage.rawValue + 1)?.unlockCost ?? BigNumber(0)
        
        // Sottrai il costo
        gameState.resources.energy.subtract(cost)
        
        // Avanza stage
        gameState.civilization.advanceStage()
        
        print("🚀 Avanzato da \(oldStage.displayName) a \(gameState.civilization.stage.displayName)")
    }
}
