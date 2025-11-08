//
//  OfflineProgressManager.swift
//  KardashevGame
//
//  Calcola il progresso offline
//

import Foundation

class OfflineProgressManager {
    static let shared = OfflineProgressManager()
    
    private init() {}
    
    struct OfflineReward {
        let energyGained: BigNumber
        let timeOffline: TimeInterval
    }
    
    /// Calcola e applica il progresso offline
    func calculateOfflineProgress(gameState: GameState) -> OfflineReward? {
        let timeOffline = gameState.lastSaveTime.secondsSince()
        
        // Se offline per meno di 10 secondi, ignora
        if timeOffline < 10 {
            return nil
        }
        
        // Limita il tempo offline al massimo configurato
        let maxOfflineSeconds = Constants.maxOfflineHours * 3600
        let effectiveTimeOffline = min(timeOffline, maxOfflineSeconds)
        
        // Calcola produzione
        let production = ResourceManager.shared.calculateTotalProduction(from: gameState.buildings)
        let offlineProduction = production * Constants.offlineProductionMultiplier
        let energyGained = offlineProduction * effectiveTimeOffline
        
        // Applica le ricompense
        if energyGained > BigNumber(0) {
            gameState.resources.energy.add(energyGained)
            gameState.civilization.totalEnergyGenerated = gameState.civilization.totalEnergyGenerated + energyGained
        }
        
        return OfflineReward(energyGained: energyGained, timeOffline: effectiveTimeOffline)
    }
    
    /// Formatta il tempo offline per display
    func formatOfflineTime(_ seconds: TimeInterval) -> String {
        let hours = Int(seconds) / 3600
        let minutes = (Int(seconds) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else if minutes > 0 {
            return "\(minutes)m"
        } else {
            return "\(Int(seconds))s"
        }
    }
}
