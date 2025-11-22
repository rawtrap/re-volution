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
    @State private var isIncreasing: Bool = false
    
    var body: some View {
        HStack(spacing: DesignSystem.Spacing.small) {
            Text(resource.type.icon)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: DesignSystem.Spacing.tiny) {
                    AdaptiveText.numeric(
                        resource.formattedAmount(),
                        style: Font.system(size: 18, weight: .bold, design: .rounded),
                        color: .white
                    )
                    .onChange(of: resource.formattedAmount()) { newValue in
                        withAnimation(DesignSystem.Animation.quick) {
                            if !previousAmount.isEmpty && newValue != previousAmount {
                                isIncreasing = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    isIncreasing = false
                                }
                            }
                            previousAmount = newValue
                        }
                    }
                    
                    if resource.productionPerSecond > BigNumber(0) {
                        AdaptiveText.numeric(
                            resource.formattedProduction(),
                            style: Font.system(size: 12, weight: .medium, design: .rounded),
                            color: .kardashevSuccess
                        )
                    }
                }
                
                AdaptiveText(
                    text: resource.type.rawValue,
                    style: DesignSystem.Typography.small,
                    color: .gray,
                    minimumScale: DesignSystem.TextScaling.minimumScale
                )
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.medium)
        .padding(.vertical, DesignSystem.Spacing.small)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.Layout.smallCornerRadius)
                .fill(Color.black.opacity(0.5))
        )
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.Layout.smallCornerRadius)
                .stroke(Color.kardashevPrimary.opacity(0.3), lineWidth: 1)
        )
    }
}
