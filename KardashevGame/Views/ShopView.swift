//
//  ShopView.swift
//  KardashevGame
//
//  Vista shop espansa con categorie multiple
//

import SwiftUI

struct ShopView: View {
    @ObservedObject var gameManager = GameManager.shared
    @Environment(\.dismiss) var dismiss
    @State private var selectedCategory: ShopCategory = .generators
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.kardashevBackground.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Category selector
                    categorySelector
                    
                    // Content
                    ScrollView {
                        VStack(spacing: 16) {
                            // Civilization Parameters (special section)
                            if selectedCategory == .civilization {
                                civilizationParametersView
                            }
                            
                            // Items for selected category
                            ForEach(itemsForCategory(selectedCategory), id: \.id) { item in
                                ShopItemCardView(
                                    item: item,
                                    canAfford: canAfford(item)
                                ) {
                                    purchaseItem(item.type)
                                }
                                .padding(.horizontal)
                            }
                            
                            // Legacy buildings (generators only)
                            if selectedCategory == .generators {
                                ForEach(BuildingType.allCases, id: \.rawValue) { type in
                                    if let building = gameManager.gameState.buildings[type], building.unlocked {
                                        BuildingCardView(
                                            building: building,
                                            canAfford: gameManager.canAffordBuilding(type)
                                        ) {
                                            if gameManager.purchaseBuilding(type) {
                                                let generator = UIImpactFeedbackGenerator(style: .medium)
                                                generator.impactOccurred()
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.top)
                    }
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
    
    // MARK: - Category Selector
    
    private var categorySelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(ShopCategory.allCases, id: \.self) { category in
                    Button(action: {
                        selectedCategory = category
                    }) {
                        VStack(spacing: 4) {
                            Text(category.icon)
                                .font(.title2)
                            Text(category.rawValue)
                                .font(.system(size: 12, weight: selectedCategory == category ? .bold : .medium))
                        }
                        .foregroundColor(selectedCategory == category ? .white : .gray)
                        .frame(width: 80, height: 70)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(selectedCategory == category ? Color.kardashevPrimary : Color.black.opacity(0.3))
                        )
                    }
                }
            }
            .padding()
        }
        .background(Color.black.opacity(0.3))
    }
    
    // MARK: - Civilization Parameters
    
    private var civilizationParametersView: some View {
        VStack(spacing: 12) {
            Text("Parametri Civiltà")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            let params = gameManager.gameState.civilization.parameters
            
            VStack(spacing: 8) {
                parameterRow(icon: "😊", name: "Felicità", value: params.happiness)
                parameterRow(icon: "🚄", name: "Trasporti", value: params.transportation)
                parameterRow(icon: "🌾", name: "Cibo", value: params.food)
                parameterRow(icon: "📚", name: "Educazione", value: params.education)
                parameterRow(icon: "⚔️", name: "Militare", value: params.military)
                parameterRow(icon: "🏥", name: "Sanità", value: params.health)
            }
            
            Text("Moltiplicatore Totale: \(params.overallMultiplier(), specifier: "%.2f")x")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.kardashevAccent)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.4))
        )
        .padding(.horizontal)
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
    
    // MARK: - Helpers
    
    private func itemsForCategory(_ category: ShopCategory) -> [ShopItem] {
        return ShopItemType.allCases
            .filter { $0.category == category }
            .compactMap { gameManager.gameState.shopItems[$0] }
            .filter { $0.unlocked }
    }
    
    private func canAfford(_ item: ShopItem) -> Bool {
        let cost = item.nextLevelCost()
        let resource = item.type.requiresResource
        return gameManager.gameState.resources[resource].canAfford(cost)
    }
    
    private func purchaseItem(_ type: ShopItemType) {
        guard var item = gameManager.gameState.shopItems[type] else { return }
        
        let cost = item.nextLevelCost()
        let resource = type.requiresResource
        
        guard gameManager.gameState.resources[resource].canAfford(cost) else { return }
        
        // Sottrai costo
        gameManager.gameState.resources[resource].subtract(cost)
        
        // Aumenta livello
        item.level = item.level + BigNumber(1)
        gameManager.gameState.shopItems[type] = item
        
        // Applica effetti
        applyItemEffect(type, level: item.level)
        
        // Feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    private func applyItemEffect(_ type: ShopItemType, level: BigNumber) {
        // Applica effetti agli item di categoria civilization
        if type.category == .civilization {
            let bonus = 10.0 * (level.toDouble() ?? 1.0)
            switch type {
            case .happinessProgram:
                gameManager.gameState.civilization.parameters.happiness = min(100, gameManager.gameState.civilization.parameters.happiness + 10)
            case .transportNetwork:
                gameManager.gameState.civilization.parameters.transportation = min(100, gameManager.gameState.civilization.parameters.transportation + 10)
            case .foodSecurity:
                gameManager.gameState.civilization.parameters.food = min(100, gameManager.gameState.civilization.parameters.food + 10)
            case .educationSystem:
                gameManager.gameState.civilization.parameters.education = min(100, gameManager.gameState.civilization.parameters.education + 10)
            case .healthCare:
                gameManager.gameState.civilization.parameters.health = min(100, gameManager.gameState.civilization.parameters.health + 10)
            default:
                break
            }
        }
        
        // Effetti militari
        if type.category == .military {
            switch type {
            case .defenseSystem:
                gameManager.gameState.civilization.parameters.military = min(100, gameManager.gameState.civilization.parameters.military + 10)
            case .spaceFleet:
                gameManager.gameState.civilization.parameters.military = min(100, gameManager.gameState.civilization.parameters.military + 20)
            case .weaponResearch:
                gameManager.gameState.civilization.parameters.military = min(100, gameManager.gameState.civilization.parameters.military + 15)
            default:
                break
            }
        }
    }
}

// MARK: - Shop Item Card View

struct ShopItemCardView: View {
    let item: ShopItem
    let canAfford: Bool
    let onPurchase: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            Text(item.type.icon)
                .font(.system(size: 36))
                .frame(width: 60, height: 60)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black.opacity(0.3))
                )
            
            // Info
            VStack(alignment: .leading, spacing: 4) {
                AdaptiveText(
                    text: item.type.rawValue,
                    style: DesignSystem.Typography.bodyBold,
                    color: .white
                )
                
                AdaptiveText.multiline(
                    item.type.description,
                    maxLines: 2,
                    color: .gray
                )
                
                HStack(spacing: 8) {
                    AdaptiveText.numeric(
                        "Livello: \(item.level.formatted())",
                        style: DesignSystem.Typography.caption,
                        color: .kardashevAccent
                    )
                    
                    if item.level > BigNumber(0) {
                        AdaptiveText(
                            text: "• Effetto: \(item.currentEffect(), specifier: "%.1f")",
                            style: DesignSystem.Typography.caption,
                            color: .kardashevSuccess
                        )
                    }
                }
            }
            
            Spacer()
            
            // Purchase button
            VStack(spacing: 4) {
                Button(action: onPurchase) {
                    Text("Acquista")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(canAfford ? Color.kardashevSuccess : Color.gray)
                        )
                }
                .disabled(!canAfford)
                
                HStack(spacing: 4) {
                    Text(item.type.requiresResource.icon)
                        .font(.caption)
                    AdaptiveText.numeric(
                        item.nextLevelCost().formatted(),
                        style: DesignSystem.Typography.small,
                        color: canAfford ? .white : .red
                    )
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.4))
        )
    }
}
