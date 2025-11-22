//
//  GameOverView.swift
//  KardashevGame
//
//  Vista Game Over con statistiche dettagliate
//

import SwiftUI

struct GameOverView: View {
    let run: Run
    let onRestart: () -> Void
    let onMainMenu: () -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header con motivo game over
                    gameOverHeader
                    
                    // Score finale
                    finalScoreCard
                    
                    // Statistiche dettagliate
                    detailedStatsCard
                    
                    // Parametri finali civiltà
                    civilizationStatsCard
                    
                    // Pianeta info
                    planetInfoCard
                    
                    // Azioni
                    actionButtons
                    
                    Spacer(minLength: 50)
                }
                .padding()
            }
        }
    }
    
    // MARK: - Subviews
    
    private var gameOverHeader: some View {
        VStack(spacing: 12) {
            Text(run.status.emoji)
                .font(.system(size: 80))
            
            Text(run.status == .completed ? "VITTORIA!" : "GAME OVER")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(run.status == .completed ? .kardashevSuccess : .red)
            
            Text(run.status.rawValue)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)
            
            if run.status != .completed && run.status != .inProgress {
                Text("La tua civiltà è giunta al termine")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
    }
    
    private var finalScoreCard: some View {
        VStack(spacing: 16) {
            Text("Score Finale")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            Text((run.finalScore ?? run.currentScore).formatted())
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.kardashevAccent)
            
            // Score breakdown
            VStack(spacing: 8) {
                scoreBreakdownRow(label: "Progresso Stage", value: run.scoreBreakdown.stageProgress)
                scoreBreakdownRow(label: "Bonus Efficienza", value: run.scoreBreakdown.efficiencyBonus)
                scoreBreakdownRow(label: "Bonus Velocità", value: run.scoreBreakdown.speedBonus)
                scoreBreakdownRow(label: "Bonus Tecnologia", value: run.scoreBreakdown.technologyBonus)
                scoreBreakdownRow(label: "Bonus Espansione", value: run.scoreBreakdown.expansionBonus)
                scoreBreakdownRow(label: "Bonus Difficoltà", value: run.scoreBreakdown.difficultyBonus)
                scoreBreakdownRow(label: "Bonus Sopravvivenza", value: run.scoreBreakdown.survivalBonus)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.6))
        )
    }
    
    private func scoreBreakdownRow(label: String, value: BigNumber) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(.gray)
            Spacer()
            Text(value.formatted())
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
        }
    }
    
    private var detailedStatsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Statistiche")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            VStack(spacing: 12) {
                statRow(icon: "⏱", label: "Tempo Totale", value: run.formattedPlayTime())
                statRow(icon: "🎯", label: "Stage Raggiunto", value: run.gameState.civilization.stage.displayName)
                statRow(icon: "👆", label: "Click Totali", value: run.statistics.totalClicks.formatted())
                statRow(icon: "⚡️", label: "Energia Generata", value: run.statistics.totalEnergyGenerated.formatted())
                statRow(icon: "🏭", label: "Edifici Costruiti", value: run.statistics.buildingsPurchased.formatted())
                statRow(icon: "🔬", label: "Tecnologie Ricercate", value: run.statistics.technologiesResearched.formatted())
                statRow(icon: "🌍", label: "Pianeti Colonizzati", value: run.statistics.planetsColonized.formatted())
                statRow(icon: "🛡️", label: "Disastri Sopravvissuti", value: run.statistics.disastersSurvived.formatted())
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.6))
        )
    }
    
    private var civilizationStatsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Parametri Civiltà Finali")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            let params = run.gameState.civilization.parameters
            
            VStack(spacing: 8) {
                parameterRow(icon: "😊", name: "Felicità", value: params.happiness)
                parameterRow(icon: "🚄", name: "Trasporti", value: params.transportation)
                parameterRow(icon: "🌾", name: "Cibo", value: params.food)
                parameterRow(icon: "📚", name: "Educazione", value: params.education)
                parameterRow(icon: "⚔️", name: "Militare", value: params.military)
                parameterRow(icon: "🏥", name: "Sanità", value: params.health)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.6))
        )
    }
    
    private var planetInfoCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Pianeta Giocato")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            HStack(spacing: 16) {
                // Planet visual
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
                        .frame(width: 80, height: 80)
                    
                    Text(run.planetSeed.terrainType.emoji)
                        .font(.system(size: 40))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(run.planetSeed.name)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Seed: \(run.planetSeed.seedNumber)")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 4) {
                        Text(run.planetSeed.difficultyRating.emoji)
                        Text(run.planetSeed.difficultyRating.rawValue)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(run.planetSeed.difficultyRating.color)
                    }
                }
                
                Spacer()
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.6))
        )
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            if run.status != .completed {
                Button(action: onRestart) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                            .font(.title3)
                        Text("RIPROVA")
                            .font(.system(size: 18, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.kardashevPrimary)
                            .shadow(color: .kardashevPrimary.opacity(0.5), radius: 10)
                    )
                }
            }
            
            Button(action: onMainMenu) {
                HStack {
                    Image(systemName: "house.fill")
                        .font(.title3)
                    Text("MENU PRINCIPALE")
                        .font(.system(size: 18, weight: .bold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray)
                )
            }
        }
        .padding()
    }
    
    // MARK: - Helpers
    
    private func statRow(icon: String, label: String, value: String) -> some View {
        HStack {
            Text(icon)
                .font(.title3)
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
        }
    }
    
    private func parameterRow(icon: String, name: String, value: Double) -> some View {
        HStack {
            Text(icon)
                .font(.title3)
            Text(name)
                .font(.system(size: 14))
                .foregroundColor(.white)
            Spacer()
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.2))
                    RoundedRectangle(cornerRadius: 4)
                        .fill(colorForValue(value))
                        .frame(width: geometry.size.width * CGFloat(value / 100.0))
                }
            }
            .frame(width: 100, height: 8)
            Text("\(Int(value))")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 30)
        }
    }
    
    private func colorForValue(_ value: Double) -> Color {
        if value < 30 { return .red }
        else if value < 60 { return .yellow }
        else { return .green }
    }
}
