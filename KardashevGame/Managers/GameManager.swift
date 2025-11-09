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
    private var sessionStartTime: Date = Date()
    
    var currentRun: Run? {
        return RunManager.shared.currentRun
    }
    
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
        
        // Se c'è una run corrente, usa il suo game state
        if let currentRun = RunManager.shared.currentRun {
            self.gameState = currentRun.gameState
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
        
        // Applica moltiplicatori seed planetario
        applyPlanetSeedModifiers()
        
        // Aggiorna risorse
        ResourceManager.shared.updateResources(gameState: gameState, deltaTime: deltaTime)
        
        // Verifica unlock automatici
        ProgressionManager.shared.checkAutoUnlocks(gameState: gameState)
        
        // Aggiorna score e statistiche run
        updateRunStatistics(deltaTime: deltaTime)
        
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
        
        // Se c'è una run corrente, salva attraverso RunManager
        if let currentRun = RunManager.shared.currentRun {
            currentRun.gameState = gameState
            currentRun.lastPlayedAt = Date()
            RunManager.shared.saveCurrentRun()
        } else {
            // Fallback al vecchio sistema di salvataggio
            SaveManager.shared.save(gameState)
        }
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
    
    // MARK: - Planet Seed Modifiers
    
    /// Applica moltiplicatori del seed planetario alla produzione degli edifici
    func applyPlanetSeedModifiers() {
        guard let currentRun = RunManager.shared.currentRun else { return }
        let seed = currentRun.planetSeed
        
        // Applica moltiplicatori specifici per tipo di edificio
        for (type, building) in gameState.buildings {
            guard var building = gameState.buildings[type], building.level > BigNumber(0) else { continue }
            
            // Mappa edifici ai moltiplicatori risorsa appropriati
            let multiplier: Double
            switch type {
            case .solarGenerator:
                multiplier = seed.solarEnergy
            case .nuclearPlant:
                multiplier = seed.geothermalEnergy
            case .fusionPlant:
                multiplier = (seed.geothermalEnergy + seed.mineralResources) / 2.0
            case .orbitalFarm:
                multiplier = seed.solarEnergy
            }
            
            // I moltiplicatori sono già considerati nel calcolo base
            // Questo metodo è qui come placeholder per futura logica più complessa
            _ = multiplier
        }
    }
    
    /// Aggiorna score e statistiche della run corrente
    func updateRunStatistics(deltaTime: TimeInterval) {
        guard let currentRun = RunManager.shared.currentRun else { return }
        
        // Aggiorna tempo giocato
        currentRun.totalPlayTime += deltaTime
        
        // Aggiorna tempo per stage
        switch gameState.civilization.stage {
        case .type1:
            currentRun.statistics.timeInStage1 += deltaTime
        case .type2:
            currentRun.statistics.timeInStage2 += deltaTime
        case .type3:
            currentRun.statistics.timeInStage3 += deltaTime
        }
        
        // Aggiorna statistiche
        currentRun.statistics.totalClicks = gameState.civilization.totalClicks
        currentRun.statistics.totalEnergyGenerated = gameState.civilization.totalEnergyGenerated
        
        // Conta edifici acquistati
        var buildingCount = BigNumber(0)
        for (_, building) in gameState.buildings {
            buildingCount = buildingCount + building.level
        }
        currentRun.statistics.buildingsPurchased = buildingCount
        
        // Aggiorna score
        RunManager.shared.updateScore(for: currentRun)
    }
    
    // MARK: - Debug
    
    func resetGame() {
        SaveManager.shared.deleteSave()
        gameState = GameState()
        lastUpdateTime = Date()
    }
}

