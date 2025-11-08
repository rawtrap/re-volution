//
//  ContentView.swift
//  KardashevGame
//
//  Vista principale del contenuto con navigation flow multi-run
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var gameManager = GameManager.shared
    @ObservedObject var runManager = RunManager.shared
    
    var body: some View {
        Group {
            if runManager.currentRun != nil {
                // Mostra GameView se c'è una run corrente
                GameView()
                    .onAppear {
                        // Carica il game state della run corrente
                        if let currentRun = runManager.currentRun {
                            gameManager.gameState = currentRun.gameState
                        }
                        gameManager.resume()
                    }
                    .onDisappear {
                        gameManager.pause()
                    }
            } else {
                // Mostra RunSelectionView se non c'è run corrente
                RunSelectionView()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            gameManager.onAppBackground()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            gameManager.onAppForeground()
        }
    }
}
