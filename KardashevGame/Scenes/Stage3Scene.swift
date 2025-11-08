//
//  Stage3Scene.swift
//  KardashevGame
//
//  Scena Tipo III - Galassia (placeholder per future espansioni)
//

import SpriteKit

class Stage3Scene: BaseGameScene {
    override func setupScene() {
        backgroundColor = SKColor(red: 0.02, green: 0.02, blue: 0.1, alpha: 1.0)
        
        // Galassia spirale (placeholder)
        let galaxy = SKShapeNode(circleOfRadius: 150)
        galaxy.fillColor = SKColor(red: 0.8, green: 0.4, blue: 1.0, alpha: 0.3)
        galaxy.strokeColor = SKColor(red: 0.8, green: 0.4, blue: 1.0, alpha: 0.6)
        galaxy.lineWidth = 2
        galaxy.position = CGPoint(x: size.width / 2, y: size.height / 2)
        galaxy.glowWidth = 15.0
        addChild(galaxy)
        
        // Rotazione lenta
        let rotate = SKAction.rotate(byAngle: .pi * 2, duration: 60)
        galaxy.run(SKAction.repeatForever(rotate))
        
        // Label placeholder
        let label = SKLabelNode(text: "Stage 3 - Coming Soon")
        label.fontColor = .white
        label.fontSize = 24
        label.position = CGPoint(x: size.width / 2, y: size.height - 100)
        addChild(label)
    }
}
