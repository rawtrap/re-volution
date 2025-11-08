//
//  GameManager.swift
//  KardashevGame
//
//  Manager principale del gioco - coordina tutti i sistemi
//

import Foundation
import Combine

class GameManager: ObservableObject {
    static let shared = GameManager()
    
    @Published var gameState: GameState
    @Published var isPaused: Bool = false
    @Published var showOfflineReward: Bool = false
    @Published var offlineReward: OfflineProgressManager.OfflineReward?
    
    private var gameTimer: Timer?
    private var saveTimer: Timer?
    private var lastUpdateTime: Date = Date()
    
    private init() {
        // Carica o crea nuovo stato
        if let loadedState = SaveManager.shared.load() {
            self.gameState = loadedState
            
            // Calcola progresso offline
            let offlineReward = OfflineProgressManager.shared.calculateOfflineProgress(gameState: loadedState)
            if let reward = offlineReward, reward.energyGained > BigNumber(0) {
                self.offlineReward = reward
                self.showOfflineReward = true
            }
        } else {
            self.gameState = GameState()
        }
        
        startGameLoop()
        startAutoSave()
    }
    
    // MARK: - Game Loop
    
    func startGameLoop() {
        gameTimer = Timer.scheduledTimer(withTimeInterval: Constants.resourceUpdateInterval, repeats: true) { [weak self] _ in
            self?.update()
        }
    }
    
    func stopGameLoop() {
        gameTimer?.invalidate()
        gameTimer = nil
    }
    
    private func update() {
        guard !isPaused else { return }
        
        let now = Date()
        let deltaTime = now.timeIntervalSince(lastUpdateTime)
        lastUpdateTime = now
        
        // Aggiorna risorse
        ResourceManager.shared.updateResources(gameState: gameState, deltaTime: deltaTime)
        
        // Verifica unlock automatici
        ProgressionManager.shared.checkAutoUnlocks(gameState: gameState)
        
        // Notifica cambiamenti
        objectWillChange.send()
    }
    
    // MARK: - Auto Save
    
    func startAutoSave() {
        saveTimer = Timer.scheduledTimer(withTimeInterval: Constants.autoSaveInterval, repeats: true) { [weak self] _ in
            self?.saveGame()
        }
    }
    
    func saveGame() {
        gameState.lastSaveTime = Date()
        SaveManager.shared.save(gameState)
    }
    
    // MARK: - Actions
    
    func performClick() {
        ResourceManager.shared.performClick(gameState: gameState)
    }
    
    func purchaseBuilding(_ type: BuildingType) -> Bool {
        return ResourceManager.shared.purchaseBuilding(type: type, gameState: gameState)
    }
    
    func unlockBuilding(_ type: BuildingType) -> Bool {
        return ResourceManager.shared.unlockBuilding(type: type, gameState: gameState)
    }
    
    func canAffordBuilding(_ type: BuildingType) -> Bool {
        guard let building = gameState.buildings[type], building.unlocked else {
            return false
        }
        let cost = building.nextLevelCost()
        return gameState.resources.energy.canAfford(cost)
    }
    
    func performPrestige() {
        ProgressionManager.shared.performPrestige(gameState: gameState)
        saveGame()
    }
    
    func advanceStage() {
        ProgressionManager.shared.advanceStage(gameState: gameState)
        saveGame()
    }
    
    // MARK: - Lifecycle
    
    func pause() {
        isPaused = true
        saveGame()
    }
    
    func resume() {
        isPaused = false
        lastUpdateTime = Date()
    }
    
    func onAppBackground() {
        saveGame()
    }
    
    func onAppForeground() {
        // Ricarica stato e calcola offline progress
        if let loadedState = SaveManager.shared.load() {
            let offlineReward = OfflineProgressManager.shared.calculateOfflineProgress(gameState: loadedState)
            if let reward = offlineReward, reward.energyGained > BigNumber(0) {
                self.offlineReward = reward
                self.showOfflineReward = true
            }
            self.gameState = loadedState
        }
        lastUpdateTime = Date()
    }
    
    func dismissOfflineReward() {
        showOfflineReward = false
        offlineReward = nil
    }
    
    // MARK: - Debug
    
    func resetGame() {
        SaveManager.shared.deleteSave()
        gameState = GameState()
        lastUpdateTime = Date()
    }
}
