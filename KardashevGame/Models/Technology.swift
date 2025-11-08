//
//  Technology.swift
//  KardashevGame
//
//  Sistema tecnologie (preparato per future espansioni)
//

import Foundation

/// Tipo di tecnologia
enum TechnologyType: String, Codable {
    case efficientSolar = "Pannelli Solari Efficienti"
    case advancedFission = "Fissione Avanzata"
    case fusionBreakthrough = "Scoperta della Fusione"
    case quantumComputing = "Computer Quantistici"
    
    var description: String {
        switch self {
        case .efficientSolar:
            return "Aumenta l'efficienza dei generatori solari del 50%"
        case .advancedFission:
            return "Migliora la produzione delle centrali nucleari del 100%"
        case .fusionBreakthrough:
            return "Sblocca le centrali a fusione"
        case .quantumComputing:
            return "Accelera la ricerca scientifica"
        }
    }
    
    var cost: BigNumber {
        switch self {
        case .efficientSolar:
            return BigNumber(500)
        case .advancedFission:
            return BigNumber(2000)
        case .fusionBreakthrough:
            return BigNumber(10000)
        case .quantumComputing:
            return BigNumber(50000)
        }
    }
}

/// Rappresenta una tecnologia ricercata
struct Technology: Codable, Identifiable {
    let id: UUID
    let type: TechnologyType
    var researched: Bool
    
    init(type: TechnologyType, researched: Bool = false) {
        self.id = UUID()
        self.type = type
        self.researched = researched
    }
}
