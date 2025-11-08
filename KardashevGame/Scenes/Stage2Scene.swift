//
//  Stage2Scene.swift
//  KardashevGame
//
//  Scena Tipo II - Sistema Solare (placeholder per future espansioni)
//

import SpriteKit

class Stage2Scene: BaseGameScene {
    override func setupScene() {
        backgroundColor = SKColor(red: 0.05, green: 0.05, blue: 0.15, alpha: 1.0)
        
        // Sole al centro
        let sun = SKShapeNode(circleOfRadius: 80)
        sun.fillColor = SKColor(red: 1.0, green: 0.9, blue: 0.2, alpha: 1.0)
        sun.strokeColor = SKColor(red: 1.0, green: 0.7, blue: 0.0, alpha: 1.0)
        sun.lineWidth = 3
        sun.position = CGPoint(x: size.width / 2, y: size.height / 2)
        sun.glowWidth = 10.0
        addChild(sun)
        
        // Label placeholder
        let label = SKLabelNode(text: "Stage 2 - Coming Soon")
        label.fontColor = .white
        label.fontSize = 24
        label.position = CGPoint(x: size.width / 2, y: size.height - 100)
        addChild(label)
    }
}
