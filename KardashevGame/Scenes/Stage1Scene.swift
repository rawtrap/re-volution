//
//  Stage1Scene.swift
//  KardashevGame
//
//  Scena Tipo I - Terra rotante nello spazio
//

import SpriteKit

class Stage1Scene: BaseGameScene {
    private var earthNode: SKShapeNode?
    private var starsNode: SKNode?
    private var clickParticles: SKEmitterNode?
    
    override func setupScene() {
        backgroundColor = SKColor(red: 0.05, green: 0.05, blue: 0.15, alpha: 1.0)
        
        setupStarfield()
        setupEarth()
        setupParticles()
    }
    
    private func setupStarfield() {
        starsNode = SKNode()
        guard let starsNode = starsNode else { return }
        addChild(starsNode)
        
        // Crea stelle casuali
        for _ in 0..<100 {
            let star = SKShapeNode(circleOfRadius: CGFloat.random(in: 1...3))
            star.fillColor = .white
            star.strokeColor = .clear
            star.position = CGPoint(
                x: CGFloat.random(in: 0...size.width),
                y: CGFloat.random(in: 0...size.height)
            )
            star.alpha = CGFloat.random(in: 0.3...1.0)
            
            // Animazione scintillante
            let fadeOut = SKAction.fadeAlpha(to: 0.3, duration: Double.random(in: 1...3))
            let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: Double.random(in: 1...3))
            let sequence = SKAction.sequence([fadeOut, fadeIn])
            star.run(SKAction.repeatForever(sequence))
            
            starsNode.addChild(star)
        }
    }
    
    private func setupEarth() {
        // Crea la Terra come cerchio
        let earthRadius: CGFloat = 120
        earthNode = SKShapeNode(circleOfRadius: earthRadius)
        
        guard let earthNode = earthNode else { return }
        
        // Colori della Terra (blu e verde)
        earthNode.fillColor = SKColor(red: 0.2, green: 0.5, blue: 0.9, alpha: 1.0)
        earthNode.strokeColor = SKColor(red: 0.1, green: 0.4, blue: 0.8, alpha: 1.0)
        earthNode.lineWidth = 2
        earthNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
        // Aggiungi effetto glow
        earthNode.glowWidth = 5.0
        
        // Crea continenti (forme verdi)
        let continent1 = SKShapeNode(circleOfRadius: 30)
        continent1.fillColor = SKColor(red: 0.2, green: 0.7, blue: 0.3, alpha: 1.0)
        continent1.strokeColor = .clear
        continent1.position = CGPoint(x: -20, y: 30)
        earthNode.addChild(continent1)
        
        let continent2 = SKShapeNode(circleOfRadius: 40)
        continent2.fillColor = SKColor(red: 0.2, green: 0.7, blue: 0.3, alpha: 1.0)
        continent2.strokeColor = .clear
        continent2.position = CGPoint(x: 40, y: -20)
        earthNode.addChild(continent2)
        
        let continent3 = SKShapeNode(circleOfRadius: 25)
        continent3.fillColor = SKColor(red: 0.2, green: 0.7, blue: 0.3, alpha: 1.0)
        continent3.strokeColor = .clear
        continent3.position = CGPoint(x: -40, y: -40)
        earthNode.addChild(continent3)
        
        addChild(earthNode)
        
        // Animazione rotazione
        let rotateAction = SKAction.rotate(byAngle: .pi * 2, duration: Constants.earthRotationDuration)
        earthNode.run(SKAction.repeatForever(rotateAction))
    }
    
    private func setupParticles() {
        // Prepara emitter per click (verrà attivato al click)
        clickParticles = SKEmitterNode()
        if let clickParticles = clickParticles {
            clickParticles.particleTexture = SKTexture(imageNamed: "spark")
            clickParticles.particleBirthRate = 50
            clickParticles.numParticlesToEmit = 20
            clickParticles.particleLifetime = 0.5
            clickParticles.particleScale = 0.1
            clickParticles.particleScaleRange = 0.05
            clickParticles.particleAlpha = 1.0
            clickParticles.particleAlphaSpeed = -2.0
            clickParticles.particleColor = SKColor(red: 1.0, green: 0.8, blue: 0.2, alpha: 1.0)
            clickParticles.emissionAngleRange = .pi * 2
            clickParticles.particleSpeed = 100
            clickParticles.particleSpeedRange = 50
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        // Effetto visivo al click
        if let touch = touches.first, let earthNode = earthNode {
            let location = touch.location(in: self)
            
            // Verifica se il touch è sulla Terra
            if earthNode.contains(location) {
                // Animazione pulse
                let scaleUp = SKAction.scale(to: 1.1, duration: 0.1)
                let scaleDown = SKAction.scale(to: 1.0, duration: 0.1)
                earthNode.run(SKAction.sequence([scaleUp, scaleDown]))
                
                // Aggiungi particelle
                if let particles = clickParticles?.copy() as? SKEmitterNode {
                    particles.position = location
                    addChild(particles)
                    
                    // Rimuovi dopo l'animazione
                    let wait = SKAction.wait(forDuration: 0.5)
                    let remove = SKAction.removeFromParent()
                    particles.run(SKAction.sequence([wait, remove]))
                }
            }
        }
    }
    
    // MARK: - Public Methods
    
    func addBuilding(at position: CGPoint) {
        // Aggiunge un piccolo edificio sulla Terra
        let building = SKShapeNode(rectOf: CGSize(width: 10, height: 15))
        building.fillColor = .gray
        building.strokeColor = .white
        building.position = position
        earthNode?.addChild(building)
    }
}
