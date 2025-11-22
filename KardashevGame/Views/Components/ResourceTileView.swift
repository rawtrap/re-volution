//
//  ResourceTileView.swift
//  KardashevGame
//
//  Tile per visualizzare una risorsa con dimensioni fisse
//

import SwiftUI

struct ResourceTileView: View {
    let resource: Resource
    
    var body: some View {
        VStack(spacing: 4) {
            // Icona risorsa
            Text(resource.type.icon)
                .font(.title3)
            
            // Ammontare
            Text(resource.formattedAmount())
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(UIConstants.minimumScaleFactor)
                .allowsTightening(true)
                .monospacedDigit()
            
            // Produzione per secondo (se presente)
            if resource.productionPerSecond > BigNumber(0) {
                Text(resource.formattedProduction())
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .foregroundColor(.kardashevSuccess)
                    .lineLimit(1)
                    .minimumScaleFactor(UIConstants.minimumScaleFactor)
                    .allowsTightening(true)
                    .monospacedDigit()
            } else {
                // Placeholder per mantenere altezza consistente
                Text(" ")
                    .font(.system(size: 10))
            }
            
            // Nome risorsa
            Text(resource.type.rawValue)
                .font(.system(size: 9, weight: .medium))
                .foregroundColor(.gray)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(width: UIConstants.resourceTileWidth, height: UIConstants.resourceTileHeight)
        .padding(.horizontal, UIConstants.tileHorizontalPadding)
        .padding(.vertical, UIConstants.tileVerticalPadding)
        .background(
            RoundedRectangle(cornerRadius: UIConstants.tileCornerRadius)
                .fill(Color.black.opacity(0.5))
        )
        .overlay(
            RoundedRectangle(cornerRadius: UIConstants.tileCornerRadius)
                .stroke(Color.kardashevPrimary.opacity(0.3), lineWidth: 1)
        )
    }
}
