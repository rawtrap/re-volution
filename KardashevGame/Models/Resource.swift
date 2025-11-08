//
//  Resource.swift
//  KardashevGame
//
//  Sistema risorse del gioco
//

import Foundation

/// Tipo di risorsa nel gioco
enum ResourceType: String, Codable, CaseIterable {
    case energy = "Energia"
    case materials = "Materiali"
    case knowledge = "Conoscenza"
    case population = "Popolazione"
    
    var icon: String {
        switch self {
        case .energy:
            return "⚡️"
        case .materials:
            return "🔩"
        case .knowledge:
            return "🧬"
        case .population:
            return "👥"
        }
    }
}

/// Rappresenta una risorsa del gioco
struct Resource: Codable {
    let type: ResourceType
    var amount: BigNumber
    var productionPerSecond: BigNumber
    
    init(type: ResourceType, amount: BigNumber = BigNumber(0), productionPerSecond: BigNumber = BigNumber(0)) {
        self.type = type
        self.amount = amount
        self.productionPerSecond = productionPerSecond
    }
    
    /// Aggiunge alla risorsa
    mutating func add(_ value: BigNumber) {
        amount = amount + value
    }
    
    /// Sottrae dalla risorsa
    mutating func subtract(_ value: BigNumber) {
        amount = amount - value
        // Non andare mai sotto zero
        if amount < BigNumber(0) {
            amount = BigNumber(0)
        }
    }
    
    /// Verifica se possiamo permetterci un certo costo
    func canAfford(_ cost: BigNumber) -> Bool {
        return amount >= cost
    }
    
    /// Formatta per display
    func formattedAmount() -> String {
        return amount.formatted()
    }
    
    /// Formatta produzione per secondo
    func formattedProduction() -> String {
        if productionPerSecond <= BigNumber(0) {
            return ""
        }
        return "+\(productionPerSecond.formatted())/s"
    }
}

/// Collezione di tutte le risorse
struct ResourceCollection: Codable {
    var energy: Resource
    var materials: Resource
    var knowledge: Resource
    var population: Resource
    
    init() {
        self.energy = Resource(type: .energy)
        self.materials = Resource(type: .materials)
        self.knowledge = Resource(type: .knowledge)
        self.population = Resource(type: .population)
    }
    
    /// Ottiene una risorsa per tipo
    subscript(type: ResourceType) -> Resource {
        get {
            switch type {
            case .energy: return energy
            case .materials: return materials
            case .knowledge: return knowledge
            case .population: return population
            }
        }
        set {
            switch type {
            case .energy: energy = newValue
            case .materials: materials = newValue
            case .knowledge: knowledge = newValue
            case .population: population = newValue
            }
        }
    }
    
    /// Verifica se possiamo permetterci un costo
    func canAfford(_ cost: BigNumber, for type: ResourceType) -> Bool {
        return self[type].canAfford(cost)
    }
}
