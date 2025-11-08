//
//  StatsView.swift
//  KardashevGame
//
//  Vista statistiche del giocatore
//

import SwiftUI

struct StatsView: View {
    @ObservedObject var gameManager = GameManager.shared
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.kardashevBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Header
                        VStack(spacing: 8) {
                            Text("📊 Statistiche")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text(gameManager.gameState.civilization.stage.displayName)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.kardashevPrimary)
                        }
                        .padding()
                        
                        // Stats Cards
                        VStack(spacing: 12) {
                            StatCard(
                                icon: "⚡️",
                                title: "Energia Totale Generata",
                                value: gameManager.gameState.civilization.totalEnergyGenerated.formatted()
                            )
                            
                            StatCard(
                                icon: "👆",
                                title: "Click Totali",
                                value: "\(gameManager.gameState.civilization.totalClicks)"
                            )
                            
                            StatCard(
                                icon: "🏭",
                                title: "Produzione per Secondo",
                                value: gameManager.gameState.resources.energy.productionPerSecond.formatted()
                            )
                            
                            if gameManager.gameState.civilization.prestigeLevel > 0 {
                                StatCard(
                                    icon: "⭐️",
                                    title: "Livello Prestige",
                                    value: "\(gameManager.gameState.civilization.prestigeLevel)"
                                )
                                
                                StatCard(
                                    icon: "✨",
                                    title: "Moltiplicatore Prestige",
                                    value: String(format: "%.2fx", gameManager.gameState.civilization.prestigeMultiplier)
                                )
                            }
                        }
                        .padding(.horizontal)
                        
                        // Buildings owned
                        VStack(alignment: .leading, spacing: 12) {
                            Text("🏗 Edifici Posseduti")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            ForEach(BuildingType.allCases, id: \.rawValue) { type in
                                if let building = gameManager.gameState.buildings[type], building.level > 0 {
                                    HStack {
                                        Text(building.type.icon)
                                            .font(.title2)
                                        
                                        VStack(alignment: .leading) {
                                            Text(building.type.rawValue)
                                                .font(.system(size: 14, weight: .semibold))
                                                .foregroundColor(.white)
                                            
                                            Text("Livello \(building.level)")
                                                .font(.system(size: 12))
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Spacer()
                                        
                                        Text("+\(building.totalProduction().formatted())/s")
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(.kardashevSuccess)
                                    }
                                    .padding()
                                    .cardStyle()
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Debug/Reset button
                        Button(action: {
                            gameManager.resetGame()
                        }) {
                            Text("🔄 Reset Gioco (Debug)")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.kardashevDanger.opacity(0.3))
                                )
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                        
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

struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(icon)
                .font(.system(size: 40))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                
                Text(value)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Spacer()
        }
        .padding()
        .cardStyle()
    }
}
