//
//  RunCardView.swift
//  KardashevGame
//
//  Componente card per mostrare una run (stile Balatro)
//

import SwiftUI

struct RunCardView: View {
    @ObservedObject var run: Run
    
    var body: some View {
        ZStack {
            // Background gradient basato su colore pianeta
            LinearGradient(
                colors: [
                    Color(hex: run.planetSeed.planetColor) ?? .blue,
                    Color(hex: run.planetSeed.planetColor)?.opacity(0.6) ?? .blue.opacity(0.6)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .cornerRadius(16)
            
            // Overlay scuro per leggibilità
            Color.black.opacity(0.3)
                .cornerRadius(16)
            
            VStack(alignment: .leading, spacing: 12) {
                // Header: Nome pianeta + icona
                HStack {
                    // Icona pianeta
                    ZStack {
                        Circle()
                            .fill(Color(hex: run.planetSeed.planetColor) ?? .blue)
                            .frame(width: 50, height: 50)
                        
                        Text(run.planetSeed.terrainType.emoji)
                            .font(.system(size: 28))
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(run.planetSeed.name)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Seed: \(run.planetSeed.seedNumber)")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    // Status badge
                    statusBadge
                }
                
                Divider()
                    .background(Color.white.opacity(0.3))
                
                // Stats row
                HStack(spacing: 16) {
                    statItem(
                        icon: "⚡️",
                        label: "Score",
                        value: (run.finalScore ?? run.currentScore).formatted()
                    )
                    
                    statItem(
                        icon: "🎯",
                        label: "Stage",
                        value: run.gameState.civilization.stage.displayName.components(separatedBy: " - ").first ?? "I"
                    )
                    
                    statItem(
                        icon: "⏱",
                        label: "Tempo",
                        value: run.formattedPlayTime()
                    )
                }
                
                // Progress bar
                progressView
                
                // Difficulty badge
                HStack {
                    difficultyBadge
                    
                    Spacer()
                    
                    if run.status != .inProgress {
                        Text(run.status.rawValue)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.red.opacity(0.3))
                            )
                    }
                }
            }
            .padding()
        }
        .frame(height: 200)
        .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Subviews
    
    private var statusBadge: some View {
        HStack(spacing: 4) {
            Text(run.status.emoji)
                .font(.system(size: 16))
            
            if run.status == .inProgress {
                Text("Attiva")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(statusColor.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(statusColor, lineWidth: 1)
                )
        )
    }
    
    private var statusColor: Color {
        switch run.status {
        case .inProgress:
            return .green
        case .completed:
            return .blue
        default:
            return .red
        }
    }
    
    private func statItem(icon: String, label: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(icon)
                .font(.system(size: 20))
            
            Text(value)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
            
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
    }
    
    private var progressView: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("Progresso")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.8))
                
                Spacer()
                
                Text("\(Int(run.stageProgress() * 100))%")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.2))
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            LinearGradient(
                                colors: [.kardashevPrimary, .kardashevAccent],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * run.stageProgress())
                }
            }
            .frame(height: 8)
        }
    }
    
    private var difficultyBadge: some View {
        HStack(spacing: 4) {
            Text(run.planetSeed.difficultyRating.emoji)
                .font(.system(size: 14))
            
            Text(run.planetSeed.difficultyRating.rawValue)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(run.planetSeed.difficultyRating.color.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(run.planetSeed.difficultyRating.color, lineWidth: 1)
                )
        )
    }
}

// Extension per supportare colori hex
extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            return nil
        }
        
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}
