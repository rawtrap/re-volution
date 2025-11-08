//
//  Extensions.swift
//  KardashevGame
//
//  Estensioni utili per il progetto
//

import SwiftUI

// MARK: - Color Extensions
extension Color {
    static let kardashevBackground = Color(red: 0.05, green: 0.05, blue: 0.15)
    static let kardashevPrimary = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let kardashevSecondary = Color(red: 0.8, green: 0.4, blue: 1.0)
    static let kardashevAccent = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let kardashevSuccess = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let kardashevDanger = Color(red: 1.0, green: 0.3, blue: 0.3)
}

// MARK: - View Extensions
extension View {
    /// Aggiunge un glow effect
    func glow(color: Color = .white, radius: CGFloat = 10) -> some View {
        self
            .shadow(color: color.opacity(0.6), radius: radius, x: 0, y: 0)
            .shadow(color: color.opacity(0.4), radius: radius / 2, x: 0, y: 0)
    }
    
    /// Applica stile card standard
    func cardStyle() -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .fill(Color.black.opacity(0.6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .stroke(Color.kardashevPrimary.opacity(0.3), lineWidth: 1)
            )
    }
}

// MARK: - Double Extensions
extension Double {
    /// Formatta come percentuale
    func asPercentage() -> String {
        return String(format: "%.0f%%", self * 100)
    }
}

// MARK: - Date Extensions
extension Date {
    /// Calcola secondi trascorsi da questa data
    func secondsSince() -> TimeInterval {
        return Date().timeIntervalSince(self)
    }
}
