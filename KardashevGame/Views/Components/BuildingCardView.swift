//
//  BuildingCardView.swift
//  KardashevGame
//
//  Card per visualizzare e acquistare edifici
//

import SwiftUI

struct BuildingCardView: View {
    let building: Building
    let canAfford: Bool
    let onPurchase: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Icona
            Text(building.type.icon)
                .font(.system(size: 40))
                .frame(width: 60, height: 60)
                .background(
                    Circle()
                        .fill(Color.kardashevPrimary.opacity(0.2))
                )
            
            // Informazioni
            VStack(alignment: .leading, spacing: 4) {
                Text(building.type.rawValue)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                
                Text(building.type.description)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .lineLimit(2)
                
                HStack(spacing: 8) {
                    // Livello
                    if building.level > BigNumber(0) {
                        Text("Lv. \(building.level.formatted())")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.kardashevAccent)
                            .lineLimit(1)
                            .monospacedDigit()
                    }
                    
                    // Produzione
                    if building.level > BigNumber(0) {
                        Text("+\(building.totalProduction().formatted())/s")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.kardashevSuccess)
                            .lineLimit(1)
                            .monospacedDigit()
                    }
                }
            }
            
            Spacer()
            
            // Bottone acquisto
            VStack(spacing: 4) {
                Button(action: onPurchase) {
                    VStack(spacing: 2) {
                        Text(building.level <= BigNumber(0) ? "Acquista" : "Upgrade")
                            .font(.system(size: 12, weight: .bold))
                        
                        Text(building.nextLevelCost().formatted())
                            .font(.system(size: 14, weight: .bold))
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                            .monospacedDigit()
                    }
                    .foregroundColor(canAfford ? .white : .gray)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(canAfford ? Color.kardashevPrimary : Color.gray.opacity(0.3))
                    )
                }
                .disabled(!canAfford)
            }
        }
        .padding(12)
        .cardStyle()
    }
}
