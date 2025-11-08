//
//  BaseGameScene.swift
//  KardashevGame
//
//  Classe base per tutte le scene SpriteKit
//

import SpriteKit

class BaseGameScene: SKScene {
    var onTap: (() -> Void)?
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        setupScene()
    }
    
    /// Override per setup specifico della scena
    func setupScene() {
        // Da implementare nelle sottoclassi
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        onTap?()
    }
}
