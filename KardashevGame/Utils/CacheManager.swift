//
//  CacheManager.swift
//  KardashevGame
//
//  Sistema di caching per ottimizzare calcoli costosi
//

import Foundation

/// Cache manager per memorizzare risultati di calcoli costosi
class CacheManager {
    static let shared = CacheManager()
    
    // Cache per costi edifici
    private var buildingCostCache: [String: BigNumber] = [:]
    private var productionCache: [String: BigNumber] = [:]
    
    // Cache per formattazioni stringhe
    private var formattedNumberCache: [String: String] = [:]
    
    private let cacheQueue = DispatchQueue(label: "com.kardashev.cache", qos: .utility)
    
    private init() {}
    
    // MARK: - Building Cost Cache
    
    /// Ottiene o calcola il costo di un edificio
    func getCachedBuildingCost(
        baseCost: Double,
        level: BigNumber,
        multiplier: Double
    ) -> BigNumber {
        let key = buildingCostKey(baseCost: baseCost, level: level, multiplier: multiplier)
        
        if let cached = buildingCostCache[key] {
            return cached
        }
        
        let cost = BalanceConfig.buildingCost(
            baseCost: baseCost,
            level: level,
            multiplier: multiplier
        )
        
        cacheQueue.async { [weak self] in
            self?.buildingCostCache[key] = cost
        }
        
        return cost
    }
    
    private func buildingCostKey(baseCost: Double, level: BigNumber, multiplier: Double) -> String {
        return "\(baseCost)_\(level.mantissa)_\(level.exponent)_\(multiplier)"
    }
    
    // MARK: - Production Cache
    
    /// Ottiene o calcola la produzione
    func getCachedProduction(
        baseProduction: Double,
        level: BigNumber,
        multiplier: Double
    ) -> BigNumber {
        let key = productionKey(baseProduction: baseProduction, level: level, multiplier: multiplier)
        
        if let cached = productionCache[key] {
            return cached
        }
        
        let production = BalanceConfig.buildingProduction(
            baseProduction: baseProduction,
            level: level,
            multiplier: multiplier
        )
        
        cacheQueue.async { [weak self] in
            self?.productionCache[key] = production
        }
        
        return production
    }
    
    private func productionKey(baseProduction: Double, level: BigNumber, multiplier: Double) -> String {
        return "\(baseProduction)_\(level.mantissa)_\(level.exponent)_\(multiplier)"
    }
    
    // MARK: - String Formatting Cache
    
    /// Cache per formattazione numeri
    func getCachedFormattedNumber(_ number: BigNumber) -> String {
        let key = "\(number.mantissa)_\(number.exponent)"
        
        if let cached = formattedNumberCache[key] {
            return cached
        }
        
        let formatted = number.formatted()
        
        cacheQueue.async { [weak self] in
            self?.formattedNumberCache[key] = formatted
        }
        
        return formatted
    }
    
    // MARK: - Cache Management
    
    /// Pulisce la cache quando necessario (call periodicamente)
    func clearCache() {
        cacheQueue.async { [weak self] in
            self?.buildingCostCache.removeAll()
            self?.productionCache.removeAll()
            self?.formattedNumberCache.removeAll()
            Logger.debug("Cache cleared")
        }
    }
    
    /// Pulisce cache quando superano la dimensione massima
    func pruneOldEntries() {
        cacheQueue.async { [weak self] in
            guard let self = self else { return }
            
            let maxEntries = 1000
            
            // Rimuovi metà delle entries quando si supera il massimo
            // Nota: implementazione semplificata, una LRU cache sarebbe più efficiente
            if self.buildingCostCache.count > maxEntries {
                let keysToRemove = Array(self.buildingCostCache.keys.prefix(maxEntries / 2))
                keysToRemove.forEach { self.buildingCostCache.removeValue(forKey: $0) }
                Logger.debug("Pruned \(keysToRemove.count) building cost cache entries")
            }
            
            if self.productionCache.count > maxEntries {
                let keysToRemove = Array(self.productionCache.keys.prefix(maxEntries / 2))
                keysToRemove.forEach { self.productionCache.removeValue(forKey: $0) }
                Logger.debug("Pruned \(keysToRemove.count) production cache entries")
            }
            
            if self.formattedNumberCache.count > maxEntries {
                let keysToRemove = Array(self.formattedNumberCache.keys.prefix(maxEntries / 2))
                keysToRemove.forEach { self.formattedNumberCache.removeValue(forKey: $0) }
                Logger.debug("Pruned \(keysToRemove.count) formatted number cache entries")
            }
        }
    }
}
