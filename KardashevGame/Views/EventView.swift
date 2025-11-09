//
//  EventView.swift
//  KardashevGame
//
//  Vista per mostrare eventi random con scelte
//

import SwiftUI

struct EventView: View {
    let event: GameEvent
    let onChoice: (EventChoice) -> Void
    @Environment(\.dismiss) var dismiss
    @ObservedObject var gameManager = GameManager.shared
    
    var body: some View {
        ZStack {
            // Background with severity color
            Color.black.opacity(0.95)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Severity indicator
                HStack {
                    Text(event.type.severity.icon)
                        .font(.title)
                    Text(event.type.severity.rawValue)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(severityColor)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(severityColor.opacity(0.2))
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Event title and description
                        VStack(spacing: 12) {
                            Text(event.title)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            Text(event.description)
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding(.top, 20)
                        
                        // Choices
                        VStack(spacing: 16) {
                            ForEach(event.choices) { choice in
                                eventChoiceCard(choice)
                            }
                        }
                        .padding()
                        
                        Spacer(minLength: 50)
                    }
                }
            }
        }
    }
    
    // MARK: - Choice Card
    
    private func eventChoiceCard(_ choice: EventChoice) -> some View {
        Button(action: {
            handleChoice(choice)
        }) {
            VStack(alignment: .leading, spacing: 12) {
                // Choice text
                Text(choice.text)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                
                // Cost if any
                if let resource = choice.requiresResource, let cost = choice.resourceCost {
                    HStack(spacing: 8) {
                        Text("Costo:")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        HStack(spacing: 4) {
                            Text(resource.icon)
                            Text(cost.formatted())
                                .font(.system(size: 14, weight: .medium))
                        }
                        .foregroundColor(canAfford(choice) ? .white : .red)
                    }
                }
                
                // Effects preview
                VStack(alignment: .leading, spacing: 4) {
                    if choice.effects.energyChange != BigNumber(0) {
                        effectRow(icon: "⚡️", value: choice.effects.energyChange)
                    }
                    if choice.effects.foodChange != BigNumber(0) {
                        effectRow(icon: "🍎", value: choice.effects.foodChange)
                    }
                    if choice.effects.materialsChange != BigNumber(0) {
                        effectRow(icon: "🔩", value: choice.effects.materialsChange)
                    }
                    if choice.effects.knowledgeChange != BigNumber(0) {
                        effectRow(icon: "🧬", value: choice.effects.knowledgeChange)
                    }
                    if choice.effects.happinessChange != 0 {
                        parameterEffectRow(icon: "😊", name: "Felicità", value: choice.effects.happinessChange)
                    }
                    if choice.effects.militaryChange != 0 {
                        parameterEffectRow(icon: "⚔️", name: "Militare", value: choice.effects.militaryChange)
                    }
                    if choice.effects.healthChange != 0 {
                        parameterEffectRow(icon: "🏥", name: "Sanità", value: choice.effects.healthChange)
                    }
                    if choice.effects.gameOverRisk > 0 {
                        HStack(spacing: 4) {
                            Text("⚠️")
                            Text("Rischio Game Over: \(Int(choice.effects.gameOverRisk * 100))%")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.red)
                        }
                    }
                }
                .padding(.top, 4)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(canAfford(choice) ? Color.kardashevPrimary.opacity(0.3) : Color.gray.opacity(0.2))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(canAfford(choice) ? Color.kardashevPrimary : Color.gray, lineWidth: 2)
            )
        }
        .disabled(!canAfford(choice))
    }
    
    private func effectRow(icon: String, value: BigNumber) -> some View {
        HStack(spacing: 4) {
            Text(icon)
                .font(.caption)
            Text(value > BigNumber(0) ? "+" : "")
                .font(.system(size: 12))
            Text(value.formatted())
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(value > BigNumber(0) ? .kardashevSuccess : .red)
        }
    }
    
    private func parameterEffectRow(icon: String, name: String, value: Double) -> some View {
        HStack(spacing: 4) {
            Text(icon)
                .font(.caption)
            Text(name)
                .font(.system(size: 12))
                .foregroundColor(.gray)
            Text(value > 0 ? "+" : "")
                .font(.system(size: 12))
            Text("\(Int(value))")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(value > 0 ? .kardashevSuccess : .red)
        }
    }
    
    // MARK: - Helpers
    
    private var severityColor: Color {
        switch event.type.severity {
        case .positive: return .green
        case .neutral: return .blue
        case .negative: return .orange
        case .critical: return .red
        }
    }
    
    private func canAfford(_ choice: EventChoice) -> Bool {
        guard let resource = choice.requiresResource, let cost = choice.resourceCost else {
            return true
        }
        return gameManager.gameState.resources[resource].canAfford(cost)
    }
    
    private func handleChoice(_ choice: EventChoice) {
        // Apply choice effects
        onChoice(choice)
        
        // Dismiss the event view
        dismiss()
    }
}
