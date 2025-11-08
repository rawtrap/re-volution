//
//  ContentView.swift
//  KardashevGame
//
//  Vista principale del contenuto
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var gameManager = GameManager.shared
    
    var body: some View {
        GameView()
            .onAppear {
                gameManager.resume()
            }
            .onDisappear {
                gameManager.pause()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                gameManager.onAppBackground()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                gameManager.onAppForeground()
            }
    }
}
