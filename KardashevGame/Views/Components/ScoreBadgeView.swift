//
//  ScoreBadgeView.swift
//  KardashevGame
//
//  Badge con dimensioni fisse per visualizzare lo score
//

import SwiftUI

struct ScoreBadgeView: View {
    let score: BigNumber
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 2) {
            Text("SCORE")
                .font(.system(size: UIConstants.tinyFontSize, weight: .bold))
                .foregroundColor(.gray)
                .lineLimit(1)
            
            Text(score.formatted(.short, decimals: 2))
                .font(.system(size: UIConstants.largeFontSize, weight: .bold))
                .foregroundColor(.kardashevAccent)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .monospacedDigit()
        }
        .frame(width: UIConstants.scoreBadgeWidth, height: UIConstants.scoreBadgeHeight)
        .padding(.horizontal, UIConstants.largePadding)
        .padding(.vertical, UIConstants.mediumPadding)
        .background(
            RoundedRectangle(cornerRadius: UIConstants.smallCornerRadius)
                .fill(Color.black.opacity(UIConstants.backgroundOpacity))
        )
    }
}
