//
//  ClickResourceSelectorView.swift
//  KardashevGame
//
//  Selettore risorse per il click con pulsanti a dimensione fissa
//

import SwiftUI

struct ClickResourceSelectorView: View {
    @Binding var selectedResource: ResourceType
    let unlockedResources: [ResourceType]
    
    // Ordine fisso delle risorse cliccabili
    private let clickableResources: [ResourceType] = [.energy, .food, .materials, .knowledge]
    
    var body: some View {
        VStack(spacing: UIConstants.mediumPadding) {
            Text("Click Genera:")
                .font(.system(size: UIConstants.smallFontSize, weight: .medium))
                .foregroundColor(.gray)
                .lineLimit(1)
            
            HStack(spacing: UIConstants.largePadding) {
                ForEach(clickableResources, id: \.self) { resourceType in
                    let isUnlocked = unlockedResources.contains(resourceType)
                    
                    Button(action: {
                        if isUnlocked {
                            selectedResource = resourceType
                        }
                    }) {
                        VStack(spacing: UIConstants.smallPadding) {
                            Text(resourceType.icon)
                                .font(.title2)
                                .lineLimit(1)
                            
                            Text(resourceType.rawValue)
                                .font(.system(size: UIConstants.tinyFontSize, weight: .medium))
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                        }
                        .foregroundColor(selectedResource == resourceType ? .kardashevAccent : .white)
                        .frame(width: UIConstants.clickButtonSize, height: UIConstants.clickButtonSize)
                        .background(
                            RoundedRectangle(cornerRadius: UIConstants.smallCornerRadius)
                                .fill(Color.black.opacity(UIConstants.backgroundOpacity))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: UIConstants.smallCornerRadius)
                                .stroke(selectedResource == resourceType ? Color.kardashevAccent : Color.clear, lineWidth: 2)
                        )
                        .opacity(isUnlocked ? 1.0 : 0.4)
                    }
                    .disabled(!isUnlocked)
                }
            }
        }
        .padding(.horizontal, UIConstants.xLargePadding)
        .padding(.vertical, UIConstants.mediumPadding)
        .background(
            RoundedRectangle(cornerRadius: UIConstants.mediumCornerRadius)
                .fill(Color.black.opacity(UIConstants.backgroundOpacity))
        )
    }
}
