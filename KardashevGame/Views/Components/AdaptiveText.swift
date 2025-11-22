//
//  AdaptiveText.swift
//  KardashevGame
//
//  Componente text adattivo che gestisce automaticamente sizing e wrapping
//

import SwiftUI

/// Componente text che si adatta automaticamente al contenuto disponibile
struct AdaptiveText: View {
    let text: String
    var style: Font = DesignSystem.Typography.body
    var maxLines: Int = 1
    var color: Color = .white
    var minimumScale: CGFloat = DesignSystem.TextScaling.minimumScale
    var monospacedDigits: Bool = false
    
    var body: some View {
        Text(text)
            .font(style)
            .foregroundColor(color)
            .lineLimit(maxLines)
            .minimumScaleFactor(minimumScale)
            .allowsTightening(true)
            .modifier(MonospacedDigitModifier(enabled: monospacedDigits))
    }
}

/// Modificatore per applicare condizionalmente monospaced digits
struct MonospacedDigitModifier: ViewModifier {
    let enabled: Bool
    
    func body(content: Content) -> some View {
        if enabled {
            content.monospacedDigit()
        } else {
            content
        }
    }
}

// MARK: - Convenience Initializers

extension AdaptiveText {
    /// Testo adattivo per numeri (con monospaced digits)
    static func numeric(_ text: String, style: Font = DesignSystem.Typography.body, color: Color = .white) -> AdaptiveText {
        AdaptiveText(
            text: text,
            style: style,
            color: color,
            monospacedDigits: true
        )
    }
    
    /// Testo adattivo per titoli (con scala conservativa)
    static func title(_ text: String, color: Color = .white) -> AdaptiveText {
        AdaptiveText(
            text: text,
            style: DesignSystem.Typography.title,
            color: color,
            minimumScale: DesignSystem.TextScaling.conservativeScale
        )
    }
    
    /// Testo adattivo per body multilinea
    static func multiline(_ text: String, maxLines: Int = 3, color: Color = .white) -> AdaptiveText {
        AdaptiveText(
            text: text,
            style: DesignSystem.Typography.body,
            maxLines: maxLines,
            color: color
        )
    }
}
