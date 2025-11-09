//
//  ResourceManager.swift
//  KardashevGame
//
//  Gestisce risorse e calcoli di produzione
//

import Foundation

class ResourceManager {
    static let shared = ResourceManager()
    
    private init() {}
    
    /// Calcola la produzione totale per secondo
    func calculateTotalProduction(from buildings: [BuildingType: Building]) -> BigNumber {
        var total = BigNumber(0)
        
        for (_, building) in buildings {
            if building.level > BigNumber(0) {
                total = total + building.totalProduction()
            }
        }
        
        return total
    }
    
    /// Aggiorna le risorse basate sulla produzione
    func updateResources(gameState: GameState, deltaTime: TimeInterval) {
        // Calcola produzione energia
        let energyProduction = calculateTotalProduction(from: gameState.buildings)
        let energyGained = energyProduction * deltaTime
        
        // Aggiorna risorsa energia
        gameState.resources.energy.add(energyGained)
        gameState.resources.energy.productionPerSecond = energyProduction
        
        // Aggiorna totale energia generata
        gameState.civilization.totalEnergyGenerated = gameState.civilization.totalEnergyGenerated + energyGained
    }
    
    /// Esegue un click manuale
    func performClick(gameState: GameState) {
        let reward = gameState.civilization.clickReward()
        let selectedResource = gameState.selectedClickResource
        
        // Aggiungi risorsa alla risorsa selezionata
        gameState.resources[selectedResource].add(reward)
        
        // Aggiorna statistiche (mantiene energia come metrica principale per compatibilità)
        gameState.civilization.totalClicks = gameState.civilization.totalClicks + BigNumber(1)
        if selectedResource == .energy {
            gameState.civilization.totalEnergyGenerated = gameState.civilization.totalEnergyGenerated + reward
        }
    }
    
    /// Acquista un edificio
    func purchaseBuilding(type: BuildingType, gameState: GameState) -> Bool {
        guard var building = gameState.buildings[type] else {
            return false
        }
        
        // Verifica se è sbloccato
        if !building.unlocked {
            return false
        }
        
        let cost = building.nextLevelCost()
        
        // Verifica se può permetterselo
        guard gameState.resources.energy.canAfford(cost) else {
            return false
        }
        
        // Sottrai costo
        gameState.resources.energy.subtract(cost)
        
        // Aumenta livello
        building.level = building.level + BigNumber(1)
        gameState.buildings[type] = building
        
        print("✅ Acquistato \(type.rawValue) livello \(building.level)")
        return true
    }
    
    /// Sblocca un edificio
    func unlockBuilding(type: BuildingType, gameState: GameState) -> Bool {
        guard var building = gameState.buildings[type] else {
            return false
        }
        
        if building.unlocked {
            return false
        }
        
        let unlockCost = building.type.unlockCost
        guard gameState.resources.energy.canAfford(unlockCost) else {
            return false
        }
        
        gameState.resources.energy.subtract(unlockCost)
        building.unlocked = true
        gameState.buildings[type] = building
        
        print("🔓 Sbloccato \(type.rawValue)")
        return true
    }
}
