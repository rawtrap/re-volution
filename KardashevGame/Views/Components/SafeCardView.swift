//
//  SafeCardView.swift
//  KardashevGame
//
//  Componente card riusabile con stile standardizzato
//

import SwiftUI

/// Card container con stile consistente
struct SafeCardView<Content: View>: View {
    let content: Content
    var backgroundColor: Color = Color.black.opacity(0.4)
    var borderColor: Color = Color.kardashevPrimary.opacity(0.3)
    var cornerRadius: CGFloat = DesignSystem.Layout.cardCornerRadius
    var padding: CGFloat = DesignSystem.Layout.cardPadding
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: 1)
            )
    }
}

// MARK: - Convenience Modifiers

extension SafeCardView {
    /// Card con background personalizzato
    func background(_ color: Color) -> SafeCardView {
        var view = self
        view.backgroundColor = color
        return view
    }
    
    /// Card con bordo personalizzato
    func border(_ color: Color) -> SafeCardView {
        var view = self
        view.borderColor = color
        return view
    }
    
    /// Card con corner radius personalizzato
    func corners(_ radius: CGFloat) -> SafeCardView {
        var view = self
        view.cornerRadius = radius
        return view
    }
    
    /// Card con padding personalizzato
    func cardPadding(_ padding: CGFloat) -> SafeCardView {
        var view = self
        view.padding = padding
        return view
    }
}

// MARK: - View Extension for easier usage

extension View {
    /// Applica stile card con SafeCardView
    func safeCard(
        backgroundColor: Color = Color.black.opacity(0.4),
        borderColor: Color = Color.kardashevPrimary.opacity(0.3)
    ) -> some View {
        SafeCardView {
            self
        }
    }
}
