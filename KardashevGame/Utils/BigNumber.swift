//
//  BigNumber.swift
//  KardashevGame
//
//  Sistema per gestire numeri molto grandi con formattazione
//

import Foundation

/// Rappresenta un numero molto grande usando mantissa ed esponente
struct BigNumber: Codable, Equatable {
    var mantissa: Double
    var exponent: Int
    
    init(_ value: Double = 0.0) {
        if value == 0 {
            self.mantissa = 0
            self.exponent = 0
        } else {
            let absValue = abs(value)
            let exp = Int(log10(absValue))
            self.mantissa = value / pow(10.0, Double(exp))
            self.exponent = exp
        }
        normalize()
    }
    
    init(mantissa: Double, exponent: Int) {
        self.mantissa = mantissa
        self.exponent = exponent
        normalize()
    }
    
    /// Normalizza il numero in modo che mantissa sia tra 1 e 10
    private mutating func normalize() {
        guard mantissa != 0 else {
            exponent = 0
            return
        }
        
        let sign = mantissa < 0 ? -1.0 : 1.0
        var absM = abs(mantissa)
        
        // Normalizzazione unificata e robusta usando floor(log10())
        // Verifica che absM sia maggiore di 0 per evitare log10(0) = -inf
        if absM > 0 && (absM >= 10.0 || absM < 1.0) {
            let correction = Int(floor(log10(absM)))
            absM /= pow(10.0, Double(correction))
            exponent += correction
        }
        
        mantissa = sign * absM
    }
    
    /// Converte in Double se possibile (per numeri piccoli)
    func toDouble() -> Double? {
        if exponent > 308 || exponent < -308 {
            return nil
        }
        return mantissa * pow(10.0, Double(exponent))
    }
    
    /// Formatta il numero per display con suffissi (K, M, B, T, etc)
    func formatted() -> String {
        if mantissa == 0 {
            return "0"
        }
        
        // Per numeri molto piccoli (< 1), usa il valore Double diretto
        // Threshold for scientific notation
        let scientificNotationThreshold = 0.001
        
        if exponent < 0 {
            if let doubleValue = toDouble() {
                if abs(doubleValue) < scientificNotationThreshold {
                    return String(format: "%.3e", doubleValue)
                }
                return String(format: "%.3f", doubleValue)
            }
        }
        
        // Suffissi standard per numeri grandi (ogni 3 ordini di grandezza)
        let suffixes = ["", "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No", "Dc", "Ud", "Dd", 
                       "Td", "Qad", "Qid", "Sxd", "Spd", "Ocd", "Nod", "Vg", "Uvg", "Dvg", "Tvg",
                       "Qav", "Qiv", "Sxv", "Spv", "Ocv", "Nov", "Tg", "Utg", "Dtg", "Ttg", "Qatg",
                       "Qitg", "Sxtg", "Sptg", "Octg", "Notg", "Qg", "Uqg", "Dqg", "Tqg", "Qaqg",
                       "Qiqg", "Sxqg", "Spqg", "Ocqg", "Noqg", "Qq", "Uqq", "Dqq", "Tqq", "Qaqq",
                       "Qiqq", "Sxqq", "Spqq", "Ocqq", "Noqq", "Sx", "Usx", "Dsx", "Tsx", "Qasx",
                       "Qisx", "Sxsx", "Spsx", "Ocsx", "Nosx", "Sp", "Usp", "Dsp", "Tsp", "Qasp",
                       "Qisp", "Sxsp", "Spsp", "Ocsp", "Nosp", "Og", "Uog", "Dog", "Tog", "Qaog",
                       "Qiog", "Sxog", "Spog", "Ocog", "Noog", "Nn", "Unn", "Dnn", "Tnn", "Qann",
                       "Qinn", "Sxnn", "Spnn", "Ocnn", "Nonn", "Ce"] // Fino a 10^303
        
        // Usa l'esponente normalizzato direttamente per determinare il suffixIndex
        let suffixIndex = exponent / 3
        let remainder = exponent % 3
        
        // Calcola la mantissa da visualizzare in base al resto
        let displayMantissa = mantissa * pow(10.0, Double(remainder))
        
        return formatted(displayMantissa, suffixIndex: suffixIndex, suffixes: suffixes)
    }
    
    /// Helper per formattare con suffisso specifico
    private func formatted(_ value: Double, suffixIndex: Int, suffixes: [String]) -> String {
        let absValue = abs(value)
        
        if suffixIndex < suffixes.count {
            if suffixIndex == 0 {
                // Numeri sotto 1000 - mostra con precisione appropriata
                if absValue < 1.0 {
                    // Numeri molto piccoli con decimali
                    return String(format: "%.3f", value)
                } else if absValue < 10 {
                    return String(format: "%.2f", value)
                } else if absValue < 100 {
                    return String(format: "%.1f", value)
                } else {
                    return String(format: "%.0f", value)
                }
            }
            
            // Numeri con suffisso - mantieni lunghezza ragionevole
            let suffix = suffixes[suffixIndex]
            if absValue < 10 {
                return String(format: "%.2f%@", value, suffix)
            } else if absValue < 100 {
                return String(format: "%.1f%@", value, suffix)
            } else {
                return String(format: "%.0f%@", value, suffix)
            }
        } else {
            // Per numeri estremamente grandi usa notazione scientifica
            // Calcola l'esponente effettivo considerando il suffixIndex
            let effectiveExponent = suffixIndex * 3 + Int(log10(abs(value)))
            return String(format: "%.2fe%d", value, effectiveExponent)
        }
    }
    
    // MARK: - Operazioni
    
    static func + (lhs: BigNumber, rhs: BigNumber) -> BigNumber {
        if lhs.mantissa == 0 { return rhs }
        if rhs.mantissa == 0 { return lhs }
        
        // Allinea le mantisse in base alla differenza degli esponenti
        let diff = lhs.exponent - rhs.exponent
        
        if diff >= 0 {
            // lhs ha esponente maggiore o uguale
            let rhsAdjusted = rhs.mantissa * pow(10.0, Double(-diff))
            return BigNumber(mantissa: lhs.mantissa + rhsAdjusted, exponent: lhs.exponent)
        } else {
            // rhs ha esponente maggiore
            let lhsAdjusted = lhs.mantissa * pow(10.0, Double(diff))
            return BigNumber(mantissa: lhsAdjusted + rhs.mantissa, exponent: rhs.exponent)
        }
    }
    
    static func - (lhs: BigNumber, rhs: BigNumber) -> BigNumber {
        return lhs + BigNumber(mantissa: -rhs.mantissa, exponent: rhs.exponent)
    }
    
    static func * (lhs: BigNumber, rhs: BigNumber) -> BigNumber {
        return BigNumber(mantissa: lhs.mantissa * rhs.mantissa, 
                        exponent: lhs.exponent + rhs.exponent)
    }
    
    static func / (lhs: BigNumber, rhs: BigNumber) -> BigNumber {
        return BigNumber(mantissa: lhs.mantissa / rhs.mantissa, 
                        exponent: lhs.exponent - rhs.exponent)
    }
    
    static func * (lhs: BigNumber, rhs: Double) -> BigNumber {
        // Converti Double in BigNumber e usa la moltiplicazione tra BigNumber
        let rhsBigNumber = BigNumber(rhs)
        return lhs * rhsBigNumber
    }
    
    static func < (lhs: BigNumber, rhs: BigNumber) -> Bool {
        return compare(lhs, rhs) == .orderedAscending
    }
    
    static func > (lhs: BigNumber, rhs: BigNumber) -> Bool {
        return compare(lhs, rhs) == .orderedDescending
    }
    
    static func >= (lhs: BigNumber, rhs: BigNumber) -> Bool {
        let result = compare(lhs, rhs)
        return result == .orderedDescending || result == .orderedSame
    }
    
    static func <= (lhs: BigNumber, rhs: BigNumber) -> Bool {
        let result = compare(lhs, rhs)
        return result == .orderedAscending || result == .orderedSame
    }
    
    /// Operatore di comparazione più robusto con tolleranza per floating point errors
    static func compare(_ lhs: BigNumber, _ rhs: BigNumber) -> ComparisonResult {
        // Confronta esponenti
        if lhs.exponent != rhs.exponent {
            return lhs.exponent > rhs.exponent ? .orderedDescending : .orderedAscending
        }
        
        // Stesso esponente, confronta mantisse con tolleranza
        let diff = lhs.mantissa - rhs.mantissa
        if abs(diff) < 1e-10 { 
            return .orderedSame 
        }
        return diff > 0 ? .orderedDescending : .orderedAscending
    }
}
