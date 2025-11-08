//
//  PlanetGenerator.swift
//  KardashevGame
//
//  Utility per generare seed planetari procedurali
//

import Foundation
import SwiftUI

struct PlanetGenerator {
    
    /// Genera un seed planetario completamente casuale
    static func generateRandom() -> PlanetSeed {
        let seedNumber = UInt64.random(in: 0...UInt64.max)
        return generate(from: seedNumber)
    }
    
    /// Genera un seed planetario da un numero specifico (riproducibile)
    static func generate(from seedNumber: UInt64) -> PlanetSeed {
        var rng = SeededRandomNumberGenerator(seed: seedNumber)
        
        // Genera parametri risorsa (0.3 - 2.0)
        let solarEnergy = rng.nextDouble(in: 0.3...2.0)
        let waterAvailability = rng.nextDouble(in: 0.3...2.0)
        let windEnergy = rng.nextDouble(in: 0.3...2.0)
        let geothermalEnergy = rng.nextDouble(in: 0.3...2.0)
        let mineralResources = rng.nextDouble(in: 0.3...2.0)
        let biodiversity = rng.nextDouble(in: 0.3...2.0)
        
        // Genera parametri difficoltà
        let naturalDisasterChance = rng.nextDouble(in: 0.0...1.0)
        let atmosphericToxicity = rng.nextDouble(in: 0.0...1.0)
        let hostileLifeforms = rng.nextBool(probability: 0.3)
        let tectonicActivity = rng.nextDouble(in: 0.0...1.0)
        
        // Determina tipo terreno basato su parametri
        let terrainType = determineTerrainType(
            temp: rng.nextDouble(),
            water: waterAvailability,
            toxicity: atmosphericToxicity,
            &rng
        )
        
        // Genera parametri visuali
        let planetColor = generatePlanetColor(terrain: terrainType, &rng)
        let atmosphereColor = generateAtmosphereColor(terrain: terrainType, toxicity: atmosphericToxicity, &rng)
        let hasRings = rng.nextBool(probability: 0.15)
        let moonCount = rng.nextInt(in: 0...3)
        
        // Genera nome procedurale
        let name = generatePlanetName(seedNumber: seedNumber, terrain: terrainType, &rng)
        
        return PlanetSeed(
            seedNumber: seedNumber,
            name: name,
            solarEnergy: solarEnergy,
            waterAvailability: waterAvailability,
            windEnergy: windEnergy,
            geothermalEnergy: geothermalEnergy,
            mineralResources: mineralResources,
            biodiversity: biodiversity,
            naturalDisasterChance: naturalDisasterChance,
            atmosphericToxicity: atmosphericToxicity,
            hostileLifeforms: hostileLifeforms,
            tectonicActivity: tectonicActivity,
            terrainType: terrainType,
            planetColor: planetColor,
            atmosphereColor: atmosphereColor,
            hasRings: hasRings,
            moonCount: moonCount
        )
    }
    
    /// Valida che il seed sia bilanciato e giocabile
    static func isPlayable(_ seed: PlanetSeed) -> Bool {
        // Almeno una risorsa deve essere decente (> 0.6)
        let resources = [
            seed.solarEnergy,
            seed.waterAvailability,
            seed.windEnergy,
            seed.geothermalEnergy,
            seed.mineralResources,
            seed.biodiversity
        ]
        
        let hasDecentResource = resources.contains { $0 > 0.6 }
        
        // Non troppo difficile per essere ingiocabile
        let notTooHard = seed.difficultyScore < 0.95
        
        return hasDecentResource && notTooHard
    }
    
    // MARK: - Private Helpers
    
    private static func determineTerrainType(
        temp: Double,
        water: Double,
        toxicity: Double,
        _ rng: inout SeededRandomNumberGenerator
    ) -> TerrainType {
        
        // Paradiso: alto water, bassa toxicity
        if water > 1.4 && toxicity < 0.2 && rng.nextBool(probability: 0.7) {
            return .paradise
        }
        
        // Tossico: alta toxicity
        if toxicity > 0.7 {
            return .toxic
        }
        
        // Oceanic: molto water
        if water > 1.5 {
            return .oceanic
        }
        
        // Desert: basso water
        if water < 0.6 {
            return .desert
        }
        
        // Frozen: bassa temperatura
        if temp < 0.25 {
            return .frozen
        }
        
        // Volcanic: alta temperatura
        if temp > 0.75 {
            return .volcanic
        }
        
        // Default: temperate
        return .temperate
    }
    
    private static func generatePlanetColor(
        terrain: TerrainType,
        _ rng: inout SeededRandomNumberGenerator
    ) -> String {
        
        let baseColors: [String]
        
        switch terrain {
        case .temperate:
            baseColors = ["#4A7C59", "#5B8C5A", "#6B9B6B"]
        case .oceanic:
            baseColors = ["#1E3A8A", "#2563EB", "#3B82F6"]
        case .desert:
            baseColors = ["#D97706", "#F59E0B", "#FBBF24"]
        case .frozen:
            baseColors = ["#DBEAFE", "#BFDBFE", "#93C5FD"]
        case .volcanic:
            baseColors = ["#7F1D1D", "#991B1B", "#B91C1C"]
        case .toxic:
            baseColors = ["#581C87", "#6B21A8", "#7C3AED"]
        case .paradise:
            baseColors = ["#DB2777", "#EC4899", "#F472B6"]
        }
        
        let index = rng.nextInt(in: 0...(baseColors.count - 1))
        return baseColors[index]
    }
    
    private static func generateAtmosphereColor(
        terrain: TerrainType,
        toxicity: Double,
        _ rng: inout SeededRandomNumberGenerator
    ) -> String {
        
        if toxicity > 0.7 {
            let colors = ["#4C1D95", "#5B21B6", "#6D28D9"]
            let index = rng.nextInt(in: 0...(colors.count - 1))
            return colors[index]
        }
        
        switch terrain {
        case .temperate, .paradise:
            return "#60A5FA"
        case .oceanic:
            return "#3B82F6"
        case .desert:
            return "#FDE047"
        case .frozen:
            return "#E0F2FE"
        case .volcanic:
            return "#F87171"
        case .toxic:
            return "#A78BFA"
        }
    }
    
    private static func generatePlanetName(
        seedNumber: UInt64,
        terrain: TerrainType,
        _ rng: inout SeededRandomNumberGenerator
    ) -> String {
        
        let prefixes = [
            "Terra", "Nova", "Kepler", "Gliese", "Proxima",
            "Alpha", "Beta", "Gamma", "Delta", "Omega",
            "Zeta", "Theta", "Sigma", "Epsilon", "Tau"
        ]
        
        let middleNames = [
            "Prime", "Secundus", "Tertius", "Major", "Minor",
            "Centauri", "Draconis", "Orionis", "Aquilae", "Lyrae"
        ]
        
        let prefix = prefixes[rng.nextInt(in: 0...(prefixes.count - 1))]
        let middle = middleNames[rng.nextInt(in: 0...(middleNames.count - 1))]
        
        // Genera suffisso alfanumerico
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let letter1 = letters[letters.index(letters.startIndex, offsetBy: rng.nextInt(in: 0...25))]
        let letter2 = letters[letters.index(letters.startIndex, offsetBy: rng.nextInt(in: 0...25))]
        let number = rng.nextInt(in: 1...99)
        
        return "\(prefix)-\(middle)-\(letter1)\(letter2)\(number)"
    }
}
