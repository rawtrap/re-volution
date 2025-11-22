//
//  BigNumber+Format.swift
//  KardashevGame
//
//  Estensione per formattazione avanzata di BigNumber
//

import Foundation

extension BigNumber {
    /// Stile di formattazione per BigNumber
    enum FormatStyle {
        case short      // Formato compatto con suffissi (es: 1.23K, 4.56M)
        case long       // Formato esteso (es: 1,234)
        case scientific // Notazione scientifica (es: 1.23e4)
    }
    
    /// Formatta il BigNumber secondo lo stile specificato
    /// - Parameters:
    ///   - style: Stile di formattazione (default: .short)
    ///   - decimals: Numero di decimali da mostrare (default: 2)
    /// - Returns: Stringa formattata
    func formatted(_ style: FormatStyle = .short, decimals: Int = 2) -> String {
        switch style {
        case .short:
            return formatShort(decimals: decimals)
        case .long:
            return formatLong()
        case .scientific:
            return formatScientific(decimals: decimals)
        }
    }
    
    // MARK: - Private Formatting Methods
    
    /// Formato compatto con suffissi standard
    private func formatShort(decimals: Int) -> String {
        if mantissa == 0 {
            return "0"
        }
        
        // Suffissi estesi per numeri molto grandi
        let suffixes = [
            "",    // 10^0
            "K",   // 10^3
            "M",   // 10^6
            "B",   // 10^9
            "T",   // 10^12
            "Qa",  // 10^15
            "Qi",  // 10^18
            "Sx",  // 10^21
            "Sp",  // 10^24
            "Oc",  // 10^27
            "No",  // 10^30
            "Dc",  // 10^33
            "Ud",  // 10^36
            "Dd"   // 10^39
        ]
        
        let suffixIndex = exponent / 3
        
        // Per numeri molto grandi fuori dalla tabella, usa notazione scientifica
        if suffixIndex >= suffixes.count {
            return formatScientific(decimals: decimals)
        }
        
        let displayExponent = exponent % 3
        let displayMantissa = mantissa * pow(10.0, Double(displayExponent))
        
        // Per numeri sotto 1000 (no suffisso)
        if suffixIndex == 0 {
            if let value = toDouble(), value < 1000 {
                // Numeri molto piccoli (< 1)
                if abs(value) < 1 && abs(value) > 0 {
                    // Mostra fino a 4 decimali per numeri piccoli
                    let formatted = String(format: "%.4f", value)
                    // Rimuovi zeri trailing
                    return formatted.replacingOccurrences(of: #"\.?0+$"#, with: "", options: .regularExpression)
                }
                // Numeri tra 1 e 10
                else if abs(value) < 10 {
                    return String(format: "%.2f", value)
                }
                // Numeri tra 10 e 100
                else if abs(value) < 100 {
                    return String(format: "%.1f", value)
                }
                // Numeri tra 100 e 1000
                else {
                    return String(format: "%.0f", value)
                }
            }
        }
        
        // Numeri con suffisso - adatta i decimali in base alla grandezza
        var effectiveDecimals = decimals
        if displayMantissa >= 100 {
            effectiveDecimals = 0
        } else if displayMantissa >= 10 {
            effectiveDecimals = min(1, decimals)
        }
        
        let formatString = "%.\(effectiveDecimals)f%@"
        return String(format: formatString, displayMantissa, suffixes[suffixIndex])
    }
    
    /// Formato esteso con separatori di migliaia
    private func formatLong() -> String {
        guard let value = toDouble() else {
            // Per numeri troppo grandi, fallback a short
            return formatShort(decimals: 0)
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "0"
    }
    
    /// Notazione scientifica
    private func formatScientific(decimals: Int) -> String {
        if mantissa == 0 {
            return "0"
        }
        
        let formatString = "%.\(decimals)fe%d"
        return String(format: formatString, mantissa, exponent)
    }
}
