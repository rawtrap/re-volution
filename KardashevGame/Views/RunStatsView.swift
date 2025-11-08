//
//  RunStatsView.swift
//  KardashevGame
//
//  Vista modale per mostrare statistiche dettagliate di una run
//

import SwiftUI

struct RunStatsView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var run: Run
    @ObservedObject var runManager = RunManager.shared
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.kardashevBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Planet header
                        planetHeaderView
                        
                        // Score breakdown
                        scoreBreakdownCard
                        
                        // Statistics
                        statisticsCard
                        
                        // Planet parameters
                        planetParametersCard
                        
                        // Comparison with personal average
                        if runManager.runs.count > 1 {
                            comparisonCard
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Statistiche Run")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Chiudi") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    private var planetHeaderView: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(hex: run.planetSeed.planetColor) ?? .blue,
                                Color(hex: run.planetSeed.planetColor)?.opacity(0.7) ?? .blue.opacity(0.7)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                
                Text(run.planetSeed.terrainType.emoji)
                    .font(.system(size: 50))
            }
            
            Text(run.planetSeed.name)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            Text("Seed: \(run.planetSeed.seedNumber)")
                .font(.system(size: 14))
                .foregroundColor(.gray)
            
            HStack(spacing: 16) {
                statusBadge
                difficultyBadge
            }
        }
    }
    
    private var statusBadge: some View {
        HStack(spacing: 4) {
            Text(run.status.emoji)
            Text(run.status.rawValue)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(statusColor.opacity(0.3))
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
    
    private var difficultyBadge: some View {
        HStack(spacing: 4) {
            Text(run.planetSeed.difficultyRating.emoji)
            Text(run.planetSeed.difficultyRating.rawValue)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(run.planetSeed.difficultyRating.color.opacity(0.3))
        )
    }
    
    private var scoreBreakdownCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Score")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            // Total score
            HStack {
                Text("Score Totale")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(run.finalScore ?? run.currentScore)")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.kardashevSuccess)
            }
            
            Divider()
                .background(Color.white.opacity(0.3))
            
            // Breakdown (base for now, will be expanded)
            scoreBreakdownRow(
                label: "Stage Progress",
                value: run.scoreBreakdown.stageProgress,
                total: run.scoreBreakdown.totalScore
            )
            
            scoreBreakdownRow(
                label: "Difficulty Bonus",
                value: run.scoreBreakdown.difficultyBonus,
                total: run.scoreBreakdown.totalScore
            )
            
            Text("* Score breakdown dettagliato verrà espanso in future versioni")
                .font(.system(size: 12))
                .foregroundColor(.gray)
                .italic()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.4))
        )
    }
    
    private func scoreBreakdownRow(label: String, value: Int, total: Int) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.8))
            
            Spacer()
            
            Text("\(value)")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
            
            if total > 0 {
                Text("(\(Int(Double(value) / Double(total) * 100))%)")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
        }
    }
    
    private var statisticsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Statistiche")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            statRow(icon: "⏱", label: "Tempo Giocato", value: run.formattedPlayTime())
            statRow(icon: "🖱", label: "Click Totali", value: "\(run.statistics.totalClicks)")
            statRow(icon: "⚡️", label: "Energia Generata", value: run.statistics.totalEnergyGenerated.formatted())
            statRow(icon: "🏗", label: "Edifici Acquistati", value: "\(run.statistics.buildingsPurchased)")
            statRow(icon: "🎯", label: "Stage Corrente", value: run.gameState.civilization.stage.displayName)
            statRow(icon: "📅", label: "Data Creazione", value: formatDate(run.createdAt))
            statRow(icon: "🕐", label: "Ultima Giocata", value: formatDate(run.lastPlayedAt))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.4))
        )
    }
    
    private var planetParametersCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Parametri Planetari")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            parameterRow(icon: "☀️", label: "Energia Solare", value: run.planetSeed.solarEnergy)
            parameterRow(icon: "💧", label: "Acqua", value: run.planetSeed.waterAvailability)
            parameterRow(icon: "💨", label: "Vento", value: run.planetSeed.windEnergy)
            parameterRow(icon: "🔥", label: "Geotermico", value: run.planetSeed.geothermalEnergy)
            parameterRow(icon: "⛏️", label: "Minerali", value: run.planetSeed.mineralResources)
            parameterRow(icon: "🌿", label: "Biodiversità", value: run.planetSeed.biodiversity)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.4))
        )
    }
    
    private var comparisonCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Confronto con Media Personale")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            let avgScore = runManager.averageScore()
            let currentScore = Double(run.finalScore ?? run.currentScore)
            let scoreDiff = currentScore - avgScore
            
            comparisonRow(
                label: "Score vs Media",
                value: scoreDiff >= 0 ? "+\(Int(scoreDiff))" : "\(Int(scoreDiff))",
                isPositive: scoreDiff >= 0
            )
            
            comparisonRow(
                label: "Tasso Completamento",
                value: "\(Int(runManager.completionRate() * 100))%",
                isPositive: runManager.completionRate() > 0.5
            )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.4))
        )
    }
    
    private func statRow(icon: String, label: String, value: String) -> some View {
        HStack {
            Text(icon)
                .font(.system(size: 20))
            
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(.white)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.kardashevAccent)
        }
    }
    
    private func parameterRow(icon: String, label: String, value: Double) -> some View {
        HStack {
            Text(icon)
                .font(.system(size: 20))
            
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(.white)
            
            Spacer()
            
            Text("\(run.planetSeed.percentage(for: value))%")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
            
            Text(run.planetSeed.qualitativeRating(for: value))
                .font(.system(size: 12))
                .foregroundColor(.gray)
                .frame(width: 80, alignment: .trailing)
        }
    }
    
    private func comparisonRow(label: String, value: String, isPositive: Bool) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(.white)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(isPositive ? .green : .red)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
