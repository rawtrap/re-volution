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
            
            // Ammontare - FIXED: Better text handling
            Text(resource.formattedAmount())
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
                .minimumScaleFactor(0.7)
                .monospacedDigit()
                .shadow(color: .black.opacity(0.8), radius: 2, x: 0, y: 1)
            
            // Produzione per secondo (se presente)
            if resource.productionPerSecond > BigNumber(0) {
                Text(resource.formattedProduction())
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundColor(.kardashevSuccess)
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
                    .minimumScaleFactor(0.7)
                    .monospacedDigit()
                    .shadow(color: .black.opacity(0.8), radius: 1, x: 0, y: 1)
            } else {
                // Placeholder per mantenere altezza consistente
                Text(" ")
                    .font(.system(size: 11))
            }
            
            // Nome risorsa
            Text(resource.type.rawValue)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.gray)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .shadow(color: .black.opacity(0.6), radius: 1, x: 0, y: 1)
        }
        .frame(minWidth: UIConstants.resourceTileWidth,
               maxWidth: UIConstants.resourceTileWidth + 20,
               minHeight: UIConstants.resourceTileHeight,
               maxHeight: UIConstants.resourceTileHeight)
        .padding(.horizontal, UIConstants.tileHorizontalPadding)
        .padding(.vertical, UIConstants.tileVerticalPadding)
        .background(
            RoundedRectangle(cornerRadius: UIConstants.tileCornerRadius)
                .fill(Color.black.opacity(0.7))
        )
        .overlay(
            RoundedRectangle(cornerRadius: UIConstants.tileCornerRadius)
                .stroke(Color.kardashevPrimary.opacity(0.5), lineWidth: 1.5)
        )
        .shadow(color: .black.opacity(0.4), radius: 4, x: 0, y: 2)
    }
}
