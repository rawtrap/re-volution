//
//  MainMenuView.swift
//  KardashevGame
//
//  Menu principale del gioco
//

import SwiftUI

struct MainMenuView: View {
    @State private var startGame = false
    
    var body: some View {
        ZStack {
            // Background
            Color.kardashevBackground.ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                // Title
                VStack(spacing: 8) {
                    Text("♾️")
                        .font(.system(size: 80))
                    
                    Text("Kardashev")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .glow(color: .kardashevPrimary, radius: 20)
                    
                    Text("Idle Civilization")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.kardashevPrimary)
                }
                
                // Subtitle
                Text("Scala di Kardašëv")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .padding(.top, -10)
                
                Spacer()
                
                // Start button
                Button(action: {
                    startGame = true
                }) {
                    Text("Inizia")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: 250)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.kardashevPrimary)
                                .glow(color: .kardashevPrimary, radius: 15)
                        )
                }
                
                Spacer()
                
                // Footer
                Text("Dalla Tipo I alla Tipo III")
                    .font(.system(size: 12))
                    .foregroundColor(.gray.opacity(0.6))
                    .padding(.bottom, 20)
            }
            .padding()
        }
        .fullScreenCover(isPresented: $startGame) {
            ContentView()
        }
    }
}
