//
//  EvolutionView.swift
//  KardashevGame
//
//  Vista per percorsi evolutivi e decisioni strategiche
//

import SwiftUI

struct EvolutionView: View {
    @ObservedObject var gameManager = GameManager.shared
    @Environment(\.dismiss) var dismiss
    @State private var selectedTab: EvolutionTab = .paths
    
    enum EvolutionTab: String, CaseIterable {
        case paths = "Percorsi"
        case decisions = "Decisioni"
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.kardashevBackground.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Tab selector
                    tabSelector
                    
                    // Content
                    if selectedTab == .paths {
                        evolutionPathsContent
                    } else {
                        strategicDecisionsContent
                    }
                }
            }
            .navigationTitle("Evoluzione")
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
    
    // MARK: - Tab Selector
    
    private var tabSelector: some View {
        HStack(spacing: 0) {
            ForEach(EvolutionTab.allCases, id: \.self) { tab in
                Button(action: {
                    selectedTab = tab
                }) {
                    Text(tab.rawValue)
                        .font(.system(size: 16, weight: selectedTab == tab ? .bold : .medium))
                        .foregroundColor(selectedTab == tab ? .white : .gray)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(selectedTab == tab ? Color.kardashevPrimary : Color.clear)
                }
            }
        }
        .background(Color.black.opacity(0.3))
    }
    
    // MARK: - Evolution Paths Content
    
    private var evolutionPathsContent: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Current path display
                if let currentPath = gameManager.currentRun?.evolutionPath {
                    currentEvolutionPathCard(EvolutionPath(rawValue: currentPath.rawValue) ?? .baseBiological)
                }
                
                // Available paths
                ForEach(CivilizationEvolutionPath.allCases, id: \.rawValue) { path in
                    evolutionPathCard(path)
                }
                
                Spacer(minLength: 50)
            }
            .padding()
        }
    }
    
    private func currentEvolutionPathCard(_ path: EvolutionPath) -> some View {
        VStack(spacing: 12) {
            HStack {
                Text("Percorso Attuale")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
            }
            
            if let civPath = CivilizationEvolutionPath(rawValue: path.rawValue) {
                HStack(spacing: 16) {
                    Text(civPath.icon)
                        .font(.system(size: 50))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(civPath.rawValue)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        Text(civPath.description)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                }
                
                // Bonuses
                let bonuses = civPath.bonuses
                VStack(alignment: .leading, spacing: 4) {
                    bonusRow(label: "Produzione", value: "x\(bonuses.productionMultiplier, default: "%.1f")")
                    bonusRow(label: "Velocità Ricerca", value: "x\(bonuses.researchSpeed, default: "%.1f")")
                    bonusRow(label: "Felicità", value: formatBonus(bonuses.happinessBonus))
                    bonusRow(label: "Resistenza Disastri", value: "\(Int(bonuses.disasterResistance))%")
                    bonusRow(label: "Riduzione Costi Militari", value: "\(Int(bonuses.militaryCostReduction))%")
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.kardashevPrimary.opacity(0.3))
        )
    }
    
    private func evolutionPathCard(_ path: CivilizationEvolutionPath) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(path.icon)
                    .font(.system(size: 40))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(path.rawValue)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(path.description)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .lineLimit(2)
                }
                
                Spacer()
            }
            
            // Requirements
            HStack {
                Text("Richiede:")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                
                Text(path.unlockStage.displayName)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.kardashevAccent)
            }
            
            // Costs
            let cost = path.unlockCost
            if cost.energy > BigNumber(0) || cost.knowledge > BigNumber(0) {
                VStack(alignment: .leading, spacing: 4) {
                    if cost.energy > BigNumber(0) {
                        costRow(icon: "⚡️", value: cost.energy, canAfford: gameManager.gameState.resources.energy.canAfford(cost.energy))
                    }
                    if cost.food > BigNumber(0) {
                        costRow(icon: "🍎", value: cost.food, canAfford: gameManager.gameState.resources.food.canAfford(cost.food))
                    }
                    if cost.materials > BigNumber(0) {
                        costRow(icon: "🔩", value: cost.materials, canAfford: gameManager.gameState.resources.materials.canAfford(cost.materials))
                    }
                    if cost.knowledge > BigNumber(0) {
                        costRow(icon: "🧬", value: cost.knowledge, canAfford: gameManager.gameState.resources.knowledge.canAfford(cost.knowledge))
                    }
                }
            }
            
            // Unlock button
            if EvolutionManager.shared.canUnlock(path, gameState: gameManager.gameState) {
                Button(action: {
                    if let run = gameManager.currentRun {
                        _ = EvolutionManager.shared.unlock(path, in: run)
                        let generator = UIImpactFeedbackGenerator(style: .heavy)
                        generator.impactOccurred()
                    }
                }) {
                    Text("SBLOCCA")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.kardashevSuccess)
                        )
                }
            } else {
                Text("Non ancora disponibile")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.4))
        )
    }
    
    // MARK: - Strategic Decisions Content
    
    private var strategicDecisionsContent: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Decisions made
                if let run = gameManager.currentRun, !run.majorDecisions.isEmpty {
                    decisionsHistory(run.majorDecisions)
                }
                
                // Available decisions
                ForEach(StrategicDecision.allCases, id: \.rawValue) { decision in
                    if isDecisionAvailable(decision) {
                        strategicDecisionCard(decision)
                    }
                }
                
                Spacer(minLength: 50)
            }
            .padding()
        }
    }
    
    private func decisionsHistory(_ decisions: [String]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Decisioni Prese")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            ForEach(decisions, id: \.self) { decisionStr in
                if let decision = StrategicDecision(rawValue: decisionStr) {
                    HStack {
                        Text("✓")
                            .foregroundColor(.kardashevSuccess)
                        Text(decision.rawValue)
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                        Spacer()
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.4))
        )
    }
    
    private func strategicDecisionCard(_ decision: StrategicDecision) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(decision.rawValue)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
            
            Text(decision.description)
                .font(.system(size: 12))
                .foregroundColor(.gray)
            
            // Effects preview
            let effects = decision.effects
            VStack(alignment: .leading, spacing: 4) {
                if effects.energyMult != 1.0 {
                    effectMultRow(label: "Energia", mult: effects.energyMult)
                }
                if effects.happinessChange != 0 {
                    effectChangeRow(label: "Felicità", change: effects.happinessChange)
                }
                if effects.militaryBonus != 0 {
                    effectChangeRow(label: "Militare", change: effects.militaryBonus)
                }
                if effects.researchSpeed != 1.0 {
                    effectMultRow(label: "Velocità Ricerca", mult: effects.researchSpeed)
                }
            }
            
            // Make decision button
            if !hasDecisionBeenMade(decision) {
                Button(action: {
                    if let run = gameManager.currentRun {
                        EvolutionManager.shared.makeDecision(decision, in: run)
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                    }
                }) {
                    Text("SCEGLI")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.kardashevPrimary)
                        )
                }
            } else {
                Text("✓ Già scelto")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.kardashevSuccess)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.4))
        )
    }
    
    // MARK: - Helpers
    
    private func bonusRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white)
        }
    }
    
    private func costRow(icon: String, value: BigNumber, canAfford: Bool) -> some View {
        HStack(spacing: 4) {
            Text(icon)
                .font(.caption)
            Text(value.formatted())
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(canAfford ? .white : .red)
        }
    }
    
    private func effectMultRow(label: String, mult: Double) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.gray)
            Text("x\(mult, specifier: "%.1f")")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(mult > 1.0 ? .kardashevSuccess : .red)
        }
    }
    
    private func effectChangeRow(label: String, change: Double) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.gray)
            Text(change > 0 ? "+\(Int(change))" : "\(Int(change))")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(change > 0 ? .kardashevSuccess : .red)
        }
    }
    
    private func formatBonus(_ value: Double) -> String {
        if value > 0 {
            return "+\(Int(value))"
        } else if value < 0 {
            return "\(Int(value))"
        } else {
            return "0"
        }
    }
    
    private func isDecisionAvailable(_ decision: StrategicDecision) -> Bool {
        return gameManager.gameState.civilization.stage.rawValue >= decision.unlockStage.rawValue
    }
    
    private func hasDecisionBeenMade(_ decision: StrategicDecision) -> Bool {
        return gameManager.currentRun?.majorDecisions.contains(decision.rawValue) ?? false
    }
}
