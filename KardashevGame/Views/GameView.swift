//
//  GameView.swift
//  KardashevGame
//
//  Vista principale del gioco con SpriteKit integrato
//

import SwiftUI
import SpriteKit

struct GameView: View {
    @ObservedObject var gameManager = GameManager.shared
    @State private var showShop = false
    @State private var showStats = false
    
    var body: some View {
        ZStack {
            // SpriteKit Scene
            SpriteView(scene: createScene())
                .ignoresSafeArea()
                .onTapGesture {
                    gameManager.performClick()
                }
            
            // UI Overlay
            VStack {
                // Top Bar - Risorse e Score
                HStack {
                    // Back to runs button
                    if gameManager.currentRun != nil {
                        Button(action: {
                            gameManager.saveGame()
                            RunManager.shared.currentRun = nil
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .bold))
                                Text("RUNS")
                                    .font(.system(size: 14, weight: .bold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.6))
                            )
                        }
                    }
                    
                    Spacer()
                    
                    // Score display
                    if let currentRun = gameManager.currentRun {
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("SCORE")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.gray)
                            Text("\(currentRun.currentScore)")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.kardashevAccent)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.6))
                        )
                    }
                    
                    // All resources display
                    HStack(spacing: 8) {
                        ForEach([ResourceType.energy, .food, .materials, .knowledge, .population], id: \.self) { resourceType in
                            if gameManager.gameState.isResourceUnlocked(resourceType) {
                                ResourceDisplayView(resource: gameManager.gameState.resources[resourceType])
                            }
                        }
                    }
                    
                    // Menu buttons
                    HStack(spacing: 12) {
                        Button(action: { showStats = true }) {
                            Image(systemName: "chart.bar.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                                .background(Circle().fill(Color.black.opacity(0.6)))
                        }
                        
                        Button(action: { showShop = true }) {
                            Image(systemName: "cart.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                                .background(Circle().fill(Color.black.opacity(0.6)))
                        }
                    }
                }
                .padding()
                
                Spacer()
                
                // Resource selection buttons
                VStack(spacing: 8) {
                    Text("Click Genera:")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 12) {
                        ForEach([ResourceType.energy, .food, .materials, .knowledge], id: \.self) { resourceType in
                            if gameManager.gameState.isResourceUnlocked(resourceType) {
                                Button(action: {
                                    gameManager.gameState.selectedClickResource = resourceType
                                }) {
                                    VStack(spacing: 4) {
                                        Text(resourceType.icon)
                                            .font(.title2)
                                        Text(resourceType.rawValue)
                                            .font(.system(size: 10, weight: .medium))
                                    }
                                    .foregroundColor(gameManager.gameState.selectedClickResource == resourceType ? .kardashevAccent : .white)
                                    .frame(width: 60, height: 60)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.black.opacity(0.6))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(gameManager.gameState.selectedClickResource == resourceType ? Color.kardashevAccent : Color.clear, lineWidth: 2)
                                    )
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black.opacity(0.6))
                )
                .padding(.bottom, 8)
                
                // Stage info
                VStack(spacing: 4) {
                    Text(gameManager.gameState.civilization.stage.displayName)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                    
                    if gameManager.gameState.civilization.prestigeLevel > BigNumber(0) {
                        Text("Prestige: \(gameManager.gameState.civilization.prestigeLevel) (\(gameManager.gameState.civilization.prestigeMultiplier, specifier: "%.2f")x)")
                            .font(.system(size: 12))
                            .foregroundColor(.kardashevAccent)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black.opacity(0.6))
                )
                .padding(.bottom, 20)
            }
            
            // Critical click feedback
            if gameManager.showCriticalClick {
                VStack {
                    Text("💥 CRITICAL! x10 💥")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.yellow)
                        .shadow(color: .orange, radius: 10)
                }
                .transition(.scale.combined(with: .opacity))
                .animation(.spring(), value: gameManager.showCriticalClick)
            }
            
            // Offline reward popup
            if gameManager.showOfflineReward, let reward = gameManager.offlineReward {
                OfflineRewardView(
                    reward: reward,
                    onDismiss: {
                        gameManager.dismissOfflineReward()
                    }
                )
            }
        }
        .sheet(isPresented: $showShop) {
            ShopView()
        }
        .sheet(isPresented: $showStats) {
            StatsView()
        }
    }
    
    private func createScene() -> SKScene {
        let scene: BaseGameScene
        
        switch gameManager.gameState.civilization.stage {
        case .type1:
            scene = Stage1Scene()
        case .type2:
            scene = Stage2Scene()
        case .type3:
            scene = Stage3Scene()
        }
        
        scene.size = UIScreen.main.bounds.size
        scene.scaleMode = .resizeFill
        scene.onTap = {
            gameManager.performClick()
        }
        
        return scene
    }
}

// View per mostrare ricompense offline
struct OfflineRewardView: View {
    let reward: OfflineProgressManager.OfflineReward
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("⏰ Bentornato!")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                
                VStack(spacing: 8) {
                    Text("Sei stato offline per")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                    
                    Text(OfflineProgressManager.shared.formatOfflineTime(reward.timeOffline))
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.kardashevAccent)
                }
                
                VStack(spacing: 8) {
                    Text("Hai guadagnato")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 8) {
                        Text("⚡️")
                            .font(.title)
                        Text(reward.energyGained.formatted())
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.kardashevSuccess)
                    }
                    
                    Text("Energia")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.kardashevPrimary.opacity(0.2))
                )
                
                Button(action: onDismiss) {
                    Text("Continua")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.kardashevPrimary)
                        )
                }
                .padding(.horizontal, 40)
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.kardashevBackground)
            )
            .padding(40)
        }
    }
}
