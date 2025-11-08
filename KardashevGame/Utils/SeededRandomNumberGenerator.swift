//
//  SeededRandomNumberGenerator.swift
//  KardashevGame
//
//  Generatore di numeri casuali con seed per riproducibilità
//

import Foundation

/// Generatore di numeri casuali deterministico basato su seed
struct SeededRandomNumberGenerator: RandomNumberGenerator {
    private var state: UInt64
    
    init(seed: UInt64) {
        self.state = seed
    }
    
    mutating func next() -> UInt64 {
        // Algoritmo Linear Congruential Generator (LCG)
        // Parametri compatibili con Java's Random
        state = (state &* 6364136223846793005) &+ 1442695040888963407
        return state
    }
    
    /// Genera un Double tra 0.0 e 1.0
    mutating func nextDouble() -> Double {
        return Double(next() >> 11) * 0x1.0p-53
    }
    
    /// Genera un Double in un range specifico
    mutating func nextDouble(in range: ClosedRange<Double>) -> Double {
        let value = nextDouble()
        return range.lowerBound + value * (range.upperBound - range.lowerBound)
    }
    
    /// Genera un Int in un range specifico
    mutating func nextInt(in range: ClosedRange<Int>) -> Int {
        let value = nextDouble()
        return range.lowerBound + Int(value * Double(range.upperBound - range.lowerBound + 1))
    }
    
    /// Genera un Bool con una certa probabilità
    mutating func nextBool(probability: Double = 0.5) -> Bool {
        return nextDouble() < probability
    }
}
