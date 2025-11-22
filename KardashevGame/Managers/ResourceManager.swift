//
//  ResourceManager.swift
//  KardashevGame
//
//  Gestisce risorse e calcoli di produzione
//

import Foundation

class ResourceManager {
    static let shared = ResourceManager()
    
    // Thread-safe queue per operazioni su risorse
    private let resourceQueue = DispatchQueue(label: "com.kardashev.resources", qos: .userInteractive)
    
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
    func performClick(gameState: GameState) -> Bool {
        var reward = gameState.civilization.clickReward()
        let selectedResource = gameState.selectedClickResource
        
        // Critical Click: 5% chance per 10x reward
        let isCritical = Double.random(in: 0...1) < 0.05
        if isCritical {
            reward = reward * 10.0
        }
        
        // Aggiungi risorsa alla risorsa selezionata
        gameState.resources[selectedResource].add(reward)
        
        // Aggiorna statistiche (mantiene energia come metrica principale per compatibilità)
        gameState.civilization.totalClicks = gameState.civilization.totalClicks + BigNumber(1)
        if selectedResource == .energy {
            gameState.civilization.totalEnergyGenerated = gameState.civilization.totalEnergyGenerated + reward
        }
        
        return isCritical
    }
    
    /// Acquista un edificio con validazione transazione
    func purchaseBuilding(type: BuildingType, gameState: GameState) -> Bool {
        guard var building = gameState.buildings[type] else {
            Logger.error("Building \(type.rawValue) non trovato")
            return false
        }
        
        // Verifica se è sbloccato
        if !building.unlocked {
            Logger.warning("Building \(type.rawValue) non sbloccato")
            return false
        }
        
        let cost = building.nextLevelCost()
        
        // Validazione: verifica che il costo sia positivo e valido
        guard cost > BigNumber(0) else {
            Logger.error("Costo invalido per \(type.rawValue)")
            return false
        }
        
        // Verifica se può permetterselo
        guard gameState.resources.energy.canAfford(cost) else {
            Logger.debug("Energia insufficiente per \(type.rawValue). Costo: \(cost.formatted()), Disponibile: \(gameState.resources.energy.amount.formatted())")
            return false
        }
        
        // Salva stato precedente per rollback
        let previousAmount = gameState.resources.energy.amount
        
        // Sottrai costo
        gameState.resources.energy.subtract(cost)
        
        // Validazione post-sottrazione: verifica che non sia diventato negativo
        if gameState.resources.energy.amount < BigNumber(0) {
            Logger.error("Risorsa negativa dopo acquisto, rollback")
            gameState.resources.energy.amount = previousAmount
            return false
        }
        
        // Aumenta livello
        building.level = building.level + BigNumber(1)
        gameState.buildings[type] = building
        
        Logger.success("Acquistato \(type.rawValue) livello \(building.level.formatted())")
        Logger.transaction(
            resource: "Energy",
            amount: cost.formatted(),
            type: .subtract,
            success: true
        )
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
        
        Logger.success("Sbloccato \(type.rawValue)")
        Logger.transaction(
            resource: "Energy",
            amount: unlockCost.formatted(),
            type: .subtract,
            success: true
        )
        return true
    }
}
