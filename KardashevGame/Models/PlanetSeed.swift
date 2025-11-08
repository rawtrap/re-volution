//
//  PlanetSeed.swift
//  KardashevGame
//
//  Modello per seed planetari procedurali
//

import Foundation
import SwiftUI

/// Tipo di terreno planetario
enum TerrainType: String, Codable, CaseIterable {
    case temperate = "Temperato"
    case oceanic = "Oceanico"
    case desert = "Desertico"
    case frozen = "Ghiacciato"
    case volcanic = "Vulcanico"
    case toxic = "Tossico"
    case paradise = "Paradiso"
    
    var emoji: String {
        switch self {
        case .temperate: return "🌍"
        case .oceanic: return "🌊"
        case .desert: return "🏜️"
        case .frozen: return "🧊"
        case .volcanic: return "🌋"
        case .toxic: return "☠️"
        case .paradise: return "🌺"
        }
    }
    
    var defaultColor: Color {
        switch self {
        case .temperate: return .green
        case .oceanic: return .blue
        case .desert: return .orange
        case .frozen: return .cyan
        case .volcanic: return .red
        case .toxic: return .purple
        case .paradise: return .pink
        }
    }
}

/// Rating di difficoltà del pianeta
enum DifficultyRating: String, Codable, CaseIterable {
    case veryEasy = "Molto Facile"
    case easy = "Facile"
    case medium = "Medio"
    case hard = "Difficile"
    case veryHard = "Molto Difficile"
    case nightmare = "Incubo"
    
    var emoji: String {
        switch self {
        case .veryEasy: return "⭐"
        case .easy: return "⭐⭐"
        case .medium: return "⭐⭐⭐"
        case .hard: return "⭐⭐⭐⭐"
        case .veryHard: return "⭐⭐⭐⭐⭐"
        case .nightmare: return "💀"
        }
    }
    
    var scoreMultiplier: Double {
        switch self {
        case .veryEasy: return 0.5
        case .easy: return 0.75
        case .medium: return 1.0
        case .hard: return 1.5
        case .veryHard: return 2.0
        case .nightmare: return 3.0
        }
    }
    
    var color: Color {
        switch self {
        case .veryEasy: return .green
        case .easy: return .blue
        case .medium: return .yellow
        case .hard: return .orange
        case .veryHard: return .red
        case .nightmare: return .purple
        }
    }
}

/// Seed planetario con tutti i parametri procedurali
struct PlanetSeed: Codable, Identifiable {
    let id: UUID
    let seedNumber: UInt64
    let name: String
    
    // Parametri risorsa (0.3 - 2.0)
    let solarEnergy: Double
    let waterAvailability: Double
    let windEnergy: Double
    let geothermalEnergy: Double
    let mineralResources: Double
    let biodiversity: Double
    
    // Parametri difficoltà (0.0 - 1.0)
    let naturalDisasterChance: Double
    let atmosphericToxicity: Double
    let hostileLifeforms: Bool
    let tectonicActivity: Double
    
    // Parametri visuali
    let terrainType: TerrainType
    let planetColor: String // Hex color
    let atmosphereColor: String // Hex color
    let hasRings: Bool
    let moonCount: Int
    
    // Difficoltà calcolata
    let difficultyRating: DifficultyRating
    let difficultyScore: Double
    
    init(id: UUID = UUID(),
         seedNumber: UInt64,
         name: String,
         solarEnergy: Double,
         waterAvailability: Double,
         windEnergy: Double,
         geothermalEnergy: Double,
         mineralResources: Double,
         biodiversity: Double,
         naturalDisasterChance: Double,
         atmosphericToxicity: Double,
         hostileLifeforms: Bool,
         tectonicActivity: Double,
         terrainType: TerrainType,
         planetColor: String,
         atmosphereColor: String,
         hasRings: Bool,
         moonCount: Int) {
        
        self.id = id
        self.seedNumber = seedNumber
        self.name = name
        self.solarEnergy = solarEnergy
        self.waterAvailability = waterAvailability
        self.windEnergy = windEnergy
        self.geothermalEnergy = geothermalEnergy
        self.mineralResources = mineralResources
        self.biodiversity = biodiversity
        self.naturalDisasterChance = naturalDisasterChance
        self.atmosphericToxicity = atmosphericToxicity
        self.hostileLifeforms = hostileLifeforms
        self.tectonicActivity = tectonicActivity
        self.terrainType = terrainType
        self.planetColor = planetColor
        self.atmosphereColor = atmosphereColor
        self.hasRings = hasRings
        self.moonCount = moonCount
        
        // Calcola difficoltà
        let avgResource = (solarEnergy + waterAvailability + windEnergy + geothermalEnergy + mineralResources + biodiversity) / 6.0
        self.difficultyScore = (1.0 - avgResource / 2.0) * 0.4 +
                               naturalDisasterChance * 0.3 +
                               atmosphericToxicity * 0.2 +
                               (hostileLifeforms ? 0.1 : 0.0)
        
        // Determina rating
        if difficultyScore < 0.2 {
            self.difficultyRating = .veryEasy
        } else if difficultyScore < 0.35 {
            self.difficultyRating = .easy
        } else if difficultyScore < 0.5 {
            self.difficultyRating = .medium
        } else if difficultyScore < 0.65 {
            self.difficultyRating = .hard
        } else if difficultyScore < 0.8 {
            self.difficultyRating = .veryHard
        } else {
            self.difficultyRating = .nightmare
        }
    }
    
    /// Valutazione qualitativa per un parametro risorsa
    func qualitativeRating(for value: Double) -> String {
        if value < 0.5 {
            return "Scarso"
        } else if value < 0.8 {
            return "Basso"
        } else if value < 1.2 {
            return "Normale"
        } else if value < 1.5 {
            return "Buono"
        } else {
            return "Eccellente"
        }
    }
    
    /// Percentuale per UI (0-100)
    func percentage(for value: Double) -> Int {
        return Int((value / 2.0) * 100)
    }
}
