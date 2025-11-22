//
//  ScoreBadgeView.swift
//  KardashevGame
//
//  Badge per visualizzare lo score con dimensioni fisse
//

import SwiftUI

struct ScoreBadgeView: View {
    let score: BigNumber
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 2) {
            Text("SCORE")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.gray)
                .lineLimit(1)
            
            Text(score.formatted())
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.kardashevAccent)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .allowsTightening(true)
                .monospacedDigit()
        }
        .frame(width: UIConstants.scoreBadgeWidth, height: UIConstants.scoreBadgeHeight)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: UIConstants.tileCornerRadius)
                .fill(Color.black.opacity(0.6))
        )
    }
}
