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
        
        let absM = abs(mantissa)
        if absM >= 10 {
            let adjustment = Int(log10(absM))
            mantissa /= pow(10.0, Double(adjustment))
            exponent += adjustment
        } else if absM < 1 && absM > 0 {
            let adjustment = Int(floor(log10(absM)))
            mantissa *= pow(10.0, Double(-adjustment))
            exponent += adjustment
        }
    }
    
    /// Converte in Double se possibile (per numeri piccoli)
    func toDouble() -> Double? {
        if exponent > 308 || exponent < -308 {
            return nil
        }
        return mantissa * pow(10.0, Double(exponent))
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
