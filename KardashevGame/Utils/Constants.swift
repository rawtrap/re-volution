//
//  Constants.swift
//  KardashevGame
//
//  Costanti globali del gioco
//

import Foundation

struct Constants {
    // MARK: - Game Loop
    static let gameTickInterval: TimeInterval = 1.0 / 60.0 // 60 FPS
    static let resourceUpdateInterval: TimeInterval = 0.1 // Aggiorna risorse 10 volte al secondo
    static let autoSaveInterval: TimeInterval = 30.0 // Salva ogni 30 secondi
    
    // MARK: - Offline Progress
    static let maxOfflineHours: Double = 8.0
    static let offlineProductionMultiplier: Double = 0.5 // 50% della produzione normale
    
    // MARK: - Animation
    static let earthRotationDuration: TimeInterval = 30.0
    static let clickAnimationDuration: TimeInterval = 0.3
    static let purchaseFeedbackDuration: TimeInterval = 0.5
    
    // MARK: - UI
    static let cornerRadius: CGFloat = 12.0
    static let standardPadding: CGFloat = 16.0
    static let smallPadding: CGFloat = 8.0
    
    // MARK: - Save Keys
    static let saveKey = "kardashevGameSave"
    static let lastSaveTimeKey = "lastSaveTime"
}
