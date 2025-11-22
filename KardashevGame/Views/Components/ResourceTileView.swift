//
//  ResourceTileView.swift
//  KardashevGame
//
//  Tile con dimensioni fisse per visualizzare una singola risorsa
//

import SwiftUI

struct ResourceTileView: View {
    let resource: Resource
    let isUnlocked: Bool
    
    var body: some View {
        VStack(spacing: UIConstants.smallPadding) {
            // Icona
            Text(resource.type.icon)
                .font(.title2)
                .opacity(isUnlocked ? 1.0 : 0.4)
            
            // Valore
            Text(isUnlocked ? resource.amount.formatted(.short, decimals: 2) : "0")
                .font(.system(size: UIConstants.mediumFontSize, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .monospacedDigit()
                .opacity(isUnlocked ? 1.0 : 0.4)
            
            // Produzione
            if isUnlocked && resource.productionPerSecond > BigNumber(0) {
                Text("+\(resource.productionPerSecond.formatted(.short, decimals: 1))/s")
                    .font(.system(size: UIConstants.tinyFontSize, weight: .medium, design: .rounded))
                    .foregroundColor(.kardashevSuccess)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .monospacedDigit()
            } else {
                Text(" ")
                    .font(.system(size: UIConstants.tinyFontSize))
            }
            
            // Nome risorsa
            Text(resource.type.rawValue)
                .font(.system(size: UIConstants.tinyFontSize, weight: .medium))
                .foregroundColor(.gray)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .opacity(isUnlocked ? 1.0 : 0.4)
        }
        .frame(width: UIConstants.resourceTileWidth, height: UIConstants.resourceTileHeight)
        .padding(.horizontal, UIConstants.mediumPadding)
        .padding(.vertical, UIConstants.mediumPadding)
        .background(
            RoundedRectangle(cornerRadius: UIConstants.smallCornerRadius)
                .fill(Color.black.opacity(isUnlocked ? UIConstants.backgroundOpacity : UIConstants.subtleOpacity))
        )
        .overlay(
            RoundedRectangle(cornerRadius: UIConstants.smallCornerRadius)
                .stroke(Color.kardashevPrimary.opacity(isUnlocked ? 0.3 : 0.1), lineWidth: 1)
        )
    }
}
