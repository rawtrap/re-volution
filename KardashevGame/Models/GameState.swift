//
//  GameState.swift
//  KardashevGame
//
//  Stato globale del gioco
//

import Foundation

/// Stato completo del gioco (salvabile)
class GameState: ObservableObject, Codable {
    @Published var civilization: Civilization
    @Published var resources: ResourceCollection
    @Published var buildings: [BuildingType: Building]
    @Published var technologies: [TechnologyType: Technology]
    @Published var lastSaveTime: Date
    @Published var selectedClickResource: ResourceType
    
    init() {
        self.civilization = Civilization()
        self.resources = ResourceCollection()
        self.buildings = [:]
        self.technologies = [:]
        self.lastSaveTime = Date()
        self.selectedClickResource = .energy
        
        // Inizializza edifici
        for type in BuildingType.allCases {
            let unlocked = (type == .solarGenerator || type == .nuclearPlant)
            buildings[type] = Building(type: type, level: BigNumber(0), unlocked: unlocked)
        }
        
        // Inizializza tecnologie (per future espansioni)
        for type in [TechnologyType.efficientSolar, .advancedFission, .fusionBreakthrough, .quantumComputing] {
            technologies[type] = Technology(type: type, researched: false)
        }
    }
    
    // MARK: - Codable
    
    enum CodingKeys: String, CodingKey {
        case civilization
        case resources
        case buildings
        case technologies
        case lastSaveTime
        case selectedClickResource
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        civilization = try container.decode(Civilization.self, forKey: .civilization)
        resources = try container.decode(ResourceCollection.self, forKey: .resources)
        buildings = try container.decode([BuildingType: Building].self, forKey: .buildings)
        technologies = try container.decode([TechnologyType: Technology].self, forKey: .technologies)
        lastSaveTime = try container.decode(Date.self, forKey: .lastSaveTime)
        selectedClickResource = try container.decodeIfPresent(ResourceType.self, forKey: .selectedClickResource) ?? .energy
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(civilization, forKey: .civilization)
        try container.encode(resources, forKey: .resources)
        try container.encode(buildings, forKey: .buildings)
        try container.encode(technologies, forKey: .technologies)
        try container.encode(lastSaveTime, forKey: .lastSaveTime)
        try container.encode(selectedClickResource, forKey: .selectedClickResource)
    }
    
    // MARK: - Resource Unlock Logic
    
    /// Verifica se una risorsa è sbloccata in base alla progressione
    func isResourceUnlocked(_ resourceType: ResourceType) -> Bool {
        switch resourceType {
        case .energy:
            return true // Sempre disponibile
        case .food:
            // Sblocca al 10% del progresso verso Stage 2
            let unlockThreshold = BigNumber(BalanceConfig.stage1ToStage2UnlockCost * 0.1)
            return resources.energy.amount >= unlockThreshold
        case .materials:
            // Sblocca al 25% del progresso verso Stage 2
            let unlockThreshold = BigNumber(BalanceConfig.stage1ToStage2UnlockCost * 0.25)
            return resources.energy.amount >= unlockThreshold
        case .knowledge:
            // Sblocca al 50% del progresso verso Stage 2
            let unlockThreshold = BigNumber(BalanceConfig.stage1ToStage2UnlockCost * 0.5)
            return resources.energy.amount >= unlockThreshold
        case .population:
            // Sblocca in Stage 2
            return civilization.stage.rawValue >= 2
        }
    }
}
