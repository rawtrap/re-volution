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
        if mantissa == 0 {
            exponent = 0
            return
        }
        
        let sign = mantissa < 0 ? -1.0 : 1.0
        var absM = abs(mantissa)
        
        // Gestisce mantissa >= 10
        while absM >= 10.0 {
            absM /= 10.0
            exponent += 1
        }
        
        // Gestisce mantissa < 1
        while absM < 1.0 && absM > 0 {
            absM *= 10.0
            exponent -= 1
        }
        
        // Gestisce casi limite di precisione floating point
        if absM >= 10.0 {
            absM /= 10.0
            exponent += 1
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
        
        let suffixIndex = exponent / 3
        let displayExponent = exponent % 3
        var displayMantissa = mantissa * pow(10.0, Double(displayExponent))
        
        // Gestisce casi in cui la mantissa dopo la regolazione supera 1000
        if abs(displayMantissa) >= 1000.0 {
            displayMantissa /= 1000.0
            return formatted(displayMantissa, suffixIndex: suffixIndex + 1, suffixes: suffixes)
        }
        
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
            return String(format: "%.2fe%d", mantissa, exponent)
        }
    }
    
    // MARK: - Operazioni
    
    static func + (lhs: BigNumber, rhs: BigNumber) -> BigNumber {
        if lhs.mantissa == 0 { return rhs }
        if rhs.mantissa == 0 { return lhs }
        
        let diff = lhs.exponent - rhs.exponent
        if diff > 15 { return lhs } // rhs è trascurabile
        if diff < -15 { return rhs } // lhs è trascurabile
        
        let rhsAdjusted = rhs.mantissa * pow(10.0, Double(diff))
        return BigNumber(mantissa: lhs.mantissa + rhsAdjusted, exponent: lhs.exponent)
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
        return BigNumber(mantissa: lhs.mantissa * rhs, exponent: lhs.exponent)
    }
    
    static func < (lhs: BigNumber, rhs: BigNumber) -> Bool {
        if lhs.exponent != rhs.exponent {
            return lhs.exponent < rhs.exponent
        }
        return lhs.mantissa < rhs.mantissa
    }
    
    static func > (lhs: BigNumber, rhs: BigNumber) -> Bool {
        if lhs.exponent != rhs.exponent {
            return lhs.exponent > rhs.exponent
        }
        return lhs.mantissa > rhs.mantissa
    }
    
    static func >= (lhs: BigNumber, rhs: BigNumber) -> Bool {
        return lhs > rhs || lhs == rhs
    }
    
    static func <= (lhs: BigNumber, rhs: BigNumber) -> Bool {
        return lhs < rhs || lhs == rhs
    }
}
