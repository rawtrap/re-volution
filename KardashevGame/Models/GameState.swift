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
    
    init() {
        self.civilization = Civilization()
        self.resources = ResourceCollection()
        self.buildings = [:]
        self.technologies = [:]
        self.lastSaveTime = Date()
        
        // Inizializza edifici
        for type in BuildingType.allCases {
            let unlocked = (type == .solarGenerator || type == .nuclearPlant)
            buildings[type] = Building(type: type, level: 0, unlocked: unlocked)
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
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        civilization = try container.decode(Civilization.self, forKey: .civilization)
        resources = try container.decode(ResourceCollection.self, forKey: .resources)
        buildings = try container.decode([BuildingType: Building].self, forKey: .buildings)
        technologies = try container.decode([TechnologyType: Technology].self, forKey: .technologies)
        lastSaveTime = try container.decode(Date.self, forKey: .lastSaveTime)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(civilization, forKey: .civilization)
        try container.encode(resources, forKey: .resources)
        try container.encode(buildings, forKey: .buildings)
        try container.encode(technologies, forKey: .technologies)
        try container.encode(lastSaveTime, forKey: .lastSaveTime)
    }
}
