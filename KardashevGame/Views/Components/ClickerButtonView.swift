//
//  ClickerButtonView.swift
//  KardashevGame
//
//  Bottone per click manuale (usato come fallback)
//

import SwiftUI

struct ClickerButtonView: View {
    let onClick: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            onClick()
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
            }
        }) {
            VStack(spacing: 8) {
                Image(systemName: "hand.tap.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
                
                Text("Clicca!")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }
            .frame(width: 120, height: 120)
            .background(
                Circle()
                    .fill(Color.kardashevPrimary)
                    .glow(color: .kardashevPrimary, radius: isPressed ? 30 : 20)
            )
            .scaleEffect(isPressed ? 0.9 : 1.0)
        }
    }
}
