//
//  Stage2Scene.swift
//  KardashevGame
//
//  Scena Tipo II - Sistema Solare con 8 pianeti e Dyson Sphere
//

import SpriteKit

class Stage2Scene: BaseGameScene {
    private var planets: [SKShapeNode] = []
    private var dysonSphere: SKShapeNode?
    private var dysonProgress: CGFloat = 0.0
    
    override func setupScene() {
        backgroundColor = SKColor(red: 0.05, green: 0.05, blue: 0.15, alpha: 1.0)
        
        // Stelle di sfondo
        createStarfield()
        
        // Sole al centro
        createSun()
        
        // 8 pianeti orbitanti
        createPlanets()
        
        // Dyson Sphere (inizialmente invisibile)
        createDysonSphere()
        
        // Label stage
        let label = SKLabelNode(text: "Type II - Solar System")
        label.fontColor = .white
        label.fontSize = 20
        label.fontName = "AvenirNext-Bold"
        label.position = CGPoint(x: size.width / 2, y: size.height - 50)
        label.alpha = 0.7
        addChild(label)
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        // Aggiorna progresso Dyson Sphere (simulato)
        updateDysonSphere()
    }
    
    // MARK: - Setup Elements
    
    private func createStarfield() {
        for _ in 0..<100 {
            let star = SKShapeNode(circleOfRadius: CGFloat.random(in: 0.5...2))
            star.fillColor = .white
            star.strokeColor = .clear
            star.position = CGPoint(
                x: CGFloat.random(in: 0...size.width),
                y: CGFloat.random(in: 0...size.height)
            )
            star.alpha = CGFloat.random(in: 0.3...0.8)
            addChild(star)
            
            // Twinkle animation
            let fade = SKAction.sequence([
                SKAction.fadeAlpha(to: 0.3, duration: Double.random(in: 1...3)),
                SKAction.fadeAlpha(to: 0.8, duration: Double.random(in: 1...3))
            ])
            star.run(SKAction.repeatForever(fade))
        }
    }
    
    private func createSun() {
        let sunRadius: CGFloat = 60
        let sun = SKShapeNode(circleOfRadius: sunRadius)
        sun.fillColor = SKColor(red: 1.0, green: 0.9, blue: 0.2, alpha: 1.0)
        sun.strokeColor = SKColor(red: 1.0, green: 0.7, blue: 0.0, alpha: 1.0)
        sun.lineWidth = 3
        sun.position = CGPoint(x: size.width / 2, y: size.height / 2)
        sun.glowWidth = 15.0
        sun.name = "sun"
        addChild(sun)
        
        // Pulsating effect
        let pulse = SKAction.sequence([
            SKAction.scale(to: 1.05, duration: 2.0),
            SKAction.scale(to: 1.0, duration: 2.0)
        ])
        sun.run(SKAction.repeatForever(pulse))
        
        // Corona effect
        let corona = SKShapeNode(circleOfRadius: sunRadius + 10)
        corona.strokeColor = SKColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 0.3)
        corona.lineWidth = 5
        corona.glowWidth = 10
        corona.fillColor = .clear
        sun.addChild(corona)
    }
    
    private func createPlanets() {
        let planetData: [(name: String, radius: CGFloat, orbitRadius: CGFloat, color: UIColor, duration: TimeInterval)] = [
            ("Mercury", 4, 100, UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0), 15),
            ("Venus", 8, 130, UIColor(red: 0.9, green: 0.8, blue: 0.5, alpha: 1.0), 20),
            ("Earth", 9, 160, UIColor(red: 0.2, green: 0.5, blue: 0.8, alpha: 1.0), 25),
            ("Mars", 7, 190, UIColor(red: 0.8, green: 0.4, blue: 0.3, alpha: 1.0), 30),
            ("Jupiter", 20, 240, UIColor(red: 0.8, green: 0.6, blue: 0.4, alpha: 1.0), 40),
            ("Saturn", 18, 290, UIColor(red: 0.9, green: 0.8, blue: 0.6, alpha: 1.0), 50),
            ("Uranus", 12, 330, UIColor(red: 0.5, green: 0.7, blue: 0.9, alpha: 1.0), 60),
            ("Neptune", 12, 360, UIColor(red: 0.3, green: 0.4, blue: 0.9, alpha: 1.0), 70)
        ]
        
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        
        for data in planetData {
            // Orbit path
            let orbit = SKShapeNode(circleOfRadius: data.orbitRadius)
            orbit.strokeColor = SKColor(white: 1.0, alpha: 0.1)
            orbit.lineWidth = 1
            orbit.fillColor = .clear
            orbit.position = center
            addChild(orbit)
            
            // Planet
            let planet = SKShapeNode(circleOfRadius: data.radius)
            planet.fillColor = data.color
            planet.strokeColor = data.color.withAlphaComponent(0.8)
            planet.lineWidth = 1
            planet.name = data.name
            planet.glowWidth = 2.0
            
            // Position on orbit
            let angle = CGFloat.random(in: 0...(2 * .pi))
            planet.position = CGPoint(
                x: center.x + cos(angle) * data.orbitRadius,
                y: center.y + sin(angle) * data.orbitRadius
            )
            addChild(planet)
            planets.append(planet)
            
            // Orbital motion
            let orbitPath = UIBezierPath(
                arcCenter: center,
                radius: data.orbitRadius,
                startAngle: angle,
                endAngle: angle + 2 * .pi,
                clockwise: true
            )
            let follow = SKAction.follow(
                orbitPath.cgPath,
                asOffset: false,
                orientToPath: false,
                duration: data.duration
            )
            planet.run(SKAction.repeatForever(follow))
            
            // Planet rotation
            let rotate = SKAction.rotate(byAngle: .pi * 2, duration: 5)
            planet.run(SKAction.repeatForever(rotate))
        }
    }
    
    private func createDysonSphere() {
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let sphereRadius: CGFloat = 80
        
        // Create multiple rings to form sphere
        for i in 0..<12 {
            let ring = SKShapeNode(circleOfRadius: sphereRadius)
            ring.strokeColor = SKColor(red: 0.0, green: 0.8, blue: 1.0, alpha: 0.0) // Initially invisible
            ring.lineWidth = 2
            ring.fillColor = .clear
            ring.position = center
            ring.name = "dysonRing"
            ring.zPosition = -1
            addChild(ring)
            
            // Different rotation angles for 3D effect
            let rotateX = SKAction.rotate(byAngle: .pi * 2, duration: 20 + Double(i))
            ring.run(SKAction.repeatForever(rotateX))
        }
    }
    
    private func updateDysonSphere() {
        // Simulate Dyson Sphere construction progress
        // In real game, this would be tied to actual building progress
        dysonProgress = min(1.0, dysonProgress + 0.0001)
        
        // Update sphere visibility based on progress
        enumerateChildNodes(withName: "dysonRing") { node, _ in
            if let ring = node as? SKShapeNode {
                ring.strokeColor = SKColor(
                    red: 0.0,
                    green: 0.8,
                    blue: 1.0,
                    alpha: self.dysonProgress * 0.3
                )
                ring.glowWidth = self.dysonProgress * 5.0
            }
        }
    }
    
    // MARK: - Planet Colonization
    
    func colonizePlanet(named name: String) {
        if let planet = planets.first(where: { $0.name == name }) {
            // Add colonization indicator
            let indicator = SKShapeNode(circleOfRadius: planet.frame.width / 2 + 5)
            indicator.strokeColor = .green
            indicator.lineWidth = 2
            indicator.fillColor = .clear
            indicator.name = "colonized"
            planet.addChild(indicator)
            
            // Pulse animation
            let pulse = SKAction.sequence([
                SKAction.scale(to: 1.2, duration: 0.5),
                SKAction.scale(to: 1.0, duration: 0.5)
            ])
            indicator.run(SKAction.repeatForever(pulse))
        }
    }
    
    func getDysonProgress() -> CGFloat {
        return dysonProgress
    }
    
    func setDysonProgress(_ progress: CGFloat) {
        dysonProgress = min(1.0, max(0.0, progress))
    }
}
