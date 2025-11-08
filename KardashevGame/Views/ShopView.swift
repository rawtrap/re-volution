//
//  ShopView.swift
//  KardashevGame
//
//  Vista shop per acquistare edifici
//

import SwiftUI

struct ShopView: View {
    @ObservedObject var gameManager = GameManager.shared
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.kardashevBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Header
                        VStack(spacing: 8) {
                            Text("🏭 Edifici")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Costruisci generatori per produrre energia passivamente")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        
                        // Lista edifici
                        ForEach(BuildingType.allCases, id: \.rawValue) { type in
                            if let building = gameManager.gameState.buildings[type], building.unlocked {
                                BuildingCardView(
                                    building: building,
                                    canAfford: gameManager.canAffordBuilding(type)
                                ) {
                                    if gameManager.purchaseBuilding(type) {
                                        // Feedback haptic
                                        let generator = UIImpactFeedbackGenerator(style: .medium)
                                        generator.impactOccurred()
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.top)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Chiudi") {
                        dismiss()
                    }
                    .foregroundColor(.kardashevPrimary)
                }
            }
        }
    }
}
