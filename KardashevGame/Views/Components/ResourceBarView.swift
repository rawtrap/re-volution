//
//  ResourceBarView.swift
//  KardashevGame
//
//  Barra orizzontale scrollabile con tile risorse a dimensione fissa
//

import SwiftUI

struct ResourceBarView: View {
    let resources: ResourceCollection
    let unlockedResources: [ResourceType]
    
    // Ordine fisso delle risorse
    private let resourceOrder: [ResourceType] = [.energy, .food, .materials, .knowledge, .population]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: UIConstants.mediumPadding) {
                ForEach(resourceOrder, id: \.self) { resourceType in
                    let resource = resources[resourceType]
                    let isUnlocked = unlockedResources.contains(resourceType)
                    
                    // Mostra sempre tutte le risorse, ma con opacità ridotta se locked
                    ResourceTileView(resource: resource, isUnlocked: isUnlocked)
                }
            }
            .padding(.horizontal, UIConstants.smallPadding)
        }
        .frame(height: UIConstants.resourceTileHeight + UIConstants.xLargePadding * 2)
    }
}
