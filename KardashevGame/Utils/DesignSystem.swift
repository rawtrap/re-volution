//
//  DesignSystem.swift
//  KardashevGame
//
//  Sistema di design centralizzato per layout, typography e spacing consistenti
//

import SwiftUI

enum DesignSystem {
    // MARK: - Spacing
    enum Spacing {
        static let tiny: CGFloat = 4
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let xlarge: CGFloat = 24
        static let xxlarge: CGFloat = 32
    }
    
    // MARK: - Typography
    enum Typography {
        static let title = Font.system(size: 28, weight: .bold)
        static let headline = Font.system(size: 20, weight: .bold)
        static let subheadline = Font.system(size: 18, weight: .semibold)
        static let body = Font.system(size: 16, weight: .regular)
        static let bodyBold = Font.system(size: 16, weight: .bold)
        static let caption = Font.system(size: 12, weight: .regular)
        static let captionBold = Font.system(size: 12, weight: .bold)
        static let small = Font.system(size: 10, weight: .regular)
    }
    
    // MARK: - Layout
    enum Layout {
        static let cardCornerRadius: CGFloat = 16
        static let buttonCornerRadius: CGFloat = 12
        static let smallCornerRadius: CGFloat = 8
        static let cardPadding: CGFloat = 16
        static let minTapTarget: CGFloat = 44
        static let shadowRadius: CGFloat = 8
        static let shadowOffset: CGFloat = 4
    }
    
    // MARK: - Animation
    enum Animation {
        static let quick = SwiftUI.Animation.easeInOut(duration: 0.2)
        static let standard = SwiftUI.Animation.easeInOut(duration: 0.3)
        static let slow = SwiftUI.Animation.easeInOut(duration: 0.5)
        static let spring = SwiftUI.Animation.spring(response: 0.3, dampingFraction: 0.7)
    }
    
    // MARK: - Text Scaling
    enum TextScaling {
        static let minimumScale: CGFloat = 0.7
        static let aggressiveScale: CGFloat = 0.5
        static let conservativeScale: CGFloat = 0.85
    }
}
