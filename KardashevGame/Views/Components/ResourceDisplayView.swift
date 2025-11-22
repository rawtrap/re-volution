//
//  ResourceDisplayView.swift
//  KardashevGame
//
//  Mostra le risorse correnti
//

import SwiftUI

struct ResourceDisplayView: View {
    let resource: Resource
    @State private var previousAmount: String = ""
    
    var body: some View {
        HStack(spacing: 8) {
            Text(resource.type.icon)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 4) {
                    Text(resource.formattedAmount())
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(UIConstants.minimumScaleFactor)
                        .allowsTightening(true)
                        .monospacedDigit()
                        .onChange(of: resource.formattedAmount()) { newValue in
                            if !previousAmount.isEmpty && newValue != previousAmount {
                                // Animazione quando cambia
                            }
                            previousAmount = newValue
                        }
                    
                    if resource.productionPerSecond > BigNumber(0) {
                        Text(resource.formattedProduction())
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundColor(.kardashevSuccess)
                            .lineLimit(1)
                            .minimumScaleFactor(UIConstants.minimumScaleFactor)
                            .allowsTightening(true)
                            .monospacedDigit()
                    }
                }
                
                Text(resource.type.rawValue)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.gray)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.black.opacity(0.5))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.kardashevPrimary.opacity(0.3), lineWidth: 1)
        )
    }
}
