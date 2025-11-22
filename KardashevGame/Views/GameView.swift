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
    @State private var showEvolution = false
    
    var body: some View {
        // Ottimizzato: usa GeometryReader solo per safe area, non per size
        GeometryReader { geometry in
            let safeTop = geometry.safeAreaInsets.top
            let safeBottom = geometry.safeAreaInsets.bottom
            
            ZStack {
                // SpriteKit Scene - ignora safe area
                SpriteView(scene: createScene())
                    .ignoresSafeArea()
                    .onTapGesture {
                        gameManager.performClick()
                    }
                
                // UI Overlay con layout fisso - rispetta safe area
                VStack(spacing: 0) {
                    // Top Bar - posizionato sotto safe area
                    HStack(alignment: .top, spacing: DesignSystem.Spacing.medium) {
                        // Back button - top left
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
                        
                        // Score - center-left
                        if let currentRun = gameManager.currentRun {
                            ScoreBadgeView(score: currentRun.currentScore)
                        }
                        
                        Spacer(minLength: 0)
                        
                        // Resources display - scrollable orizzontalmente
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 6) {
                                ForEach([ResourceType.energy, .food, .materials, .knowledge, .population], id: \.self) { resourceType in
                                    if gameManager.gameState.isResourceUnlocked(resourceType) {
                                        ResourceTileView(resource: gameManager.gameState.resources[resourceType])
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: 450) // Limita larghezza massima
                        
                        // Menu buttons
                        HStack(spacing: 8) {
                            Button(action: { showEvolution = true }) {
                                Image(systemName: "brain.head.profile")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .frame(width: UIConstants.menuButtonSize, height: UIConstants.menuButtonSize)
                                    .background(Circle().fill(Color.black.opacity(0.6)))
                            }
                            
                            Button(action: { showStats = true }) {
                                Image(systemName: "chart.bar.fill")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .frame(width: UIConstants.menuButtonSize, height: UIConstants.menuButtonSize)
                                    .background(Circle().fill(Color.black.opacity(0.6)))
                            }
                            
                            Button(action: { showShop = true }) {
                                Image(systemName: "cart.fill")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .frame(width: UIConstants.menuButtonSize, height: UIConstants.menuButtonSize)
                                    .background(Circle().fill(Color.black.opacity(0.6)))
                            }
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.medium)
                    .padding(.top, max(safeTop, 20) + 12)
                    .padding(.bottom, DesignSystem.Spacing.small)
                    .frame(maxWidth: .infinity)
                    
                    Spacer()
                
                    // Resource selection buttons
                    VStack(spacing: 8) {
                        Text("Click Genera:")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.gray)
                            .lineLimit(1)
                        
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
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.7)
                                                .monospacedDigit()
                                        }
                                        .foregroundColor(gameManager.gameState.selectedClickResource == resourceType ? .kardashevAccent : .white)
                                        .frame(width: UIConstants.clickButtonWidth, height: UIConstants.clickButtonHeight)
                                        .background(
                                            RoundedRectangle(cornerRadius: UIConstants.tileCornerRadius)
                                                .fill(Color.black.opacity(0.6))
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: UIConstants.tileCornerRadius)
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
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                        
                        if gameManager.gameState.civilization.prestigeLevel > BigNumber(0) {
                            HStack(spacing: 4) {
                                Text("Prestige:")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                                Text(gameManager.gameState.civilization.prestigeLevel.formatted())
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.kardashevAccent)
                                    .lineLimit(1)
                                    .monospacedDigit()
                                Text("(\(gameManager.gameState.civilization.prestigeMultiplier, specifier: "%.2f")x)")
                                    .font(.system(size: 12))
                                    .foregroundColor(.kardashevAccent)
                            }
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.6))
                    )
                    .padding(.bottom, max(safeBottom, 20) + 12)
                }
                .allowsHitTesting(true)
                .zIndex(1000)
            
                // Critical click feedback
                if gameManager.showCriticalClick {
                    VStack {
                        Text("💥 CRITICAL! x10 💥")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.yellow)
                            .shadow(color: .orange, radius: 10)
                    }
                    .zIndex(2000)
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
                    .zIndex(3000)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .ignoresSafeArea()
        .sheet(isPresented: $showShop) {
            ShopView()
        }
        .sheet(isPresented: $showStats) {
            StatsView()
        }
        .sheet(isPresented: $showEvolution) {
            EvolutionView()
        }
        .sheet(isPresented: $gameManager.showEvent) {
            if let event = gameManager.currentEvent {
                EventView(event: event) { choice in
                    gameManager.handleEventChoice(choice)
                }
            }
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
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                            .monospacedDigit()
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
