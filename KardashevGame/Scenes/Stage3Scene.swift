//
//  Stage3Scene.swift
//  KardashevGame
//
//  Scena Tipo III - Vista Galattica con stelle e mega-progetti
//

import SpriteKit

class Stage3Scene: BaseGameScene {
    private var starSystems: [SKShapeNode] = []
    private var megaProjects: [String: SKShapeNode] = [:]
    
    override func setupScene() {
        backgroundColor = SKColor(red: 0.02, green: 0.02, blue: 0.1, alpha: 1.0)
        
        // Sfondo stellare denso
        createDenseStarfield()
        
        // Galassia spirale centrale
        createGalaxy()
        
        // Sistemi stellari colonizzati
        createStarSystems()
        
        // Rotte commerciali
        createTradeRoutes()
        
        // Label stage
        let label = SKLabelNode(text: "Type III - Galactic Civilization")
        label.fontColor = .white
        label.fontSize = 20
        label.fontName = "AvenirNext-Bold"
        label.position = CGPoint(x: size.width / 2, y: size.height - 50)
        label.alpha = 0.7
        addChild(label)
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        // Animate trade routes
        animateTradeRoutes()
    }
    
    // MARK: - Setup Elements
    
    private func createDenseStarfield() {
        for _ in 0..<300 {
            let star = SKShapeNode(circleOfRadius: CGFloat.random(in: 0.3...1.5))
            star.fillColor = .white
            star.strokeColor = .clear
            star.position = CGPoint(
                x: CGFloat.random(in: 0...size.width),
                y: CGFloat.random(in: 0...size.height)
            )
            star.alpha = CGFloat.random(in: 0.2...0.9)
            addChild(star)
            
            // Twinkle animation
            let fade = SKAction.sequence([
                SKAction.fadeAlpha(to: 0.2, duration: Double.random(in: 0.5...2)),
                SKAction.fadeAlpha(to: 0.9, duration: Double.random(in: 0.5...2))
            ])
            star.run(SKAction.repeatForever(fade))
        }
    }
    
    private func createGalaxy() {
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        
        // Galassia spirale multi-strato
        for i in 0..<5 {
            let radius = CGFloat(100 + i * 30)
            let galaxy = SKShapeNode(circleOfRadius: radius)
            galaxy.fillColor = .clear
            galaxy.strokeColor = SKColor(
                red: 0.8,
                green: 0.4 + CGFloat(i) * 0.1,
                blue: 1.0,
                alpha: 0.3 - CGFloat(i) * 0.05
            )
            galaxy.lineWidth = 3
            galaxy.position = center
            galaxy.glowWidth = 10.0 - CGFloat(i) * 2.0
            addChild(galaxy)
            
            // Rotazione differenziata per effetto spirale
            let duration = 40.0 + Double(i) * 10.0
            let rotate = SKAction.rotate(byAngle: .pi * 2, duration: duration)
            galaxy.run(SKAction.repeatForever(rotate))
        }
        
        // Nucleo galattico luminoso
        let core = SKShapeNode(circleOfRadius: 30)
        core.fillColor = SKColor(red: 1.0, green: 0.8, blue: 1.0, alpha: 0.8)
        core.strokeColor = .clear
        core.position = center
        core.glowWidth = 20.0
        addChild(core)
        
        // Pulsazione nucleo
        let pulse = SKAction.sequence([
            SKAction.scale(to: 1.1, duration: 1.5),
            SKAction.scale(to: 1.0, duration: 1.5)
        ])
        core.run(SKAction.repeatForever(pulse))
    }
    
    private func createStarSystems() {
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let systemCount = 20
        
        for i in 0..<systemCount {
            let angle = (CGFloat(i) / CGFloat(systemCount)) * 2 * .pi
            let distance = CGFloat.random(in: 120...250)
            
            let system = SKShapeNode(circleOfRadius: 5)
            system.fillColor = .yellow
            system.strokeColor = .orange
            system.lineWidth = 1
            system.glowWidth = 3.0
            system.position = CGPoint(
                x: center.x + cos(angle) * distance,
                y: center.y + sin(angle) * distance
            )
            system.name = "starSystem_\(i)"
            addChild(system)
            starSystems.append(system)
            
            // Colonization indicator
            let indicator = SKShapeNode(circleOfRadius: 10)
            indicator.strokeColor = SKColor(red: 0.0, green: 1.0, blue: 0.5, alpha: 0.5)
            indicator.fillColor = .clear
            indicator.lineWidth = 2
            system.addChild(indicator)
            
            // Pulse animation
            let pulse = SKAction.sequence([
                SKAction.scale(to: 1.3, duration: 1.0),
                SKAction.scale(to: 1.0, duration: 1.0)
            ])
            indicator.run(SKAction.repeatForever(pulse))
        }
    }
    
    private func createTradeRoutes() {
        // Connessioni tra sistemi vicini
        for i in 0..<starSystems.count {
            let system1 = starSystems[i]
            
            // Connetti a 2-3 sistemi vicini
            for j in 1...3 {
                let targetIndex = (i + j) % starSystems.count
                let system2 = starSystems[targetIndex]
                
                let path = UIBezierPath()
                path.move(to: system1.position)
                path.addLine(to: system2.position)
                
                let route = SKShapeNode(path: path.cgPath)
                route.strokeColor = SKColor(red: 0.0, green: 0.8, blue: 1.0, alpha: 0.2)
                route.lineWidth = 1
                route.lineCap = .round
                route.name = "tradeRoute"
                route.zPosition = -1
                addChild(route)
            }
        }
    }
    
    private func animateTradeRoutes() {
        // Animate trade route opacity to simulate traffic
        enumerateChildNodes(withName: "tradeRoute") { node, _ in
            if let route = node as? SKShapeNode {
                let random = CGFloat.random(in: 0.1...0.3)
                route.strokeColor = SKColor(red: 0.0, green: 0.8, blue: 1.0, alpha: random)
            }
        }
    }
    
    // MARK: - Mega Projects
    
    func addMegaProject(type: String, at position: CGPoint) {
        let project = SKShapeNode(circleOfRadius: 15)
        
        switch type {
        case "wormhole":
            project.fillColor = SKColor(red: 0.5, green: 0.0, blue: 1.0, alpha: 0.7)
            project.strokeColor = SKColor(red: 0.8, green: 0.0, blue: 1.0, alpha: 1.0)
        case "ringworld":
            project.fillColor = SKColor(red: 0.0, green: 1.0, blue: 0.5, alpha: 0.7)
            project.strokeColor = SKColor(red: 0.0, green: 1.0, blue: 0.8, alpha: 1.0)
        case "matrioshkaBrain":
            project.fillColor = SKColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 0.7)
            project.strokeColor = SKColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0)
        default:
            project.fillColor = .white
            project.strokeColor = .white
        }
        
        project.lineWidth = 2
        project.glowWidth = 10.0
        project.position = position
        project.name = "megaProject_\(type)"
        addChild(project)
        megaProjects[type] = project
        
        // Dramatic appearance animation
        project.setScale(0)
        let appear = SKAction.sequence([
            SKAction.scale(to: 1.5, duration: 0.5),
            SKAction.scale(to: 1.0, duration: 0.3)
        ])
        project.run(appear)
        
        // Ongoing animation
        let pulse = SKAction.sequence([
            SKAction.scale(to: 1.2, duration: 2.0),
            SKAction.scale(to: 1.0, duration: 2.0)
        ])
        project.run(SKAction.repeatForever(pulse))
    }
    
    // MARK: - Diplomacy Visualization
    
    func showDiplomaticRelation(from: Int, to: Int, status: String) {
        guard from < starSystems.count, to < starSystems.count else { return }
        
        let system1 = starSystems[from]
        let system2 = starSystems[to]
        
        let path = UIBezierPath()
        path.move(to: system1.position)
        path.addLine(to: system2.position)
        
        let relation = SKShapeNode(path: path.cgPath)
        
        switch status {
        case "alliance":
            relation.strokeColor = .green
        case "war":
            relation.strokeColor = .red
        case "trade":
            relation.strokeColor = .cyan
        default:
            relation.strokeColor = .gray
        }
        
        relation.lineWidth = 3
        relation.lineCap = .round
        relation.name = "diplomatic_\(from)_\(to)"
        relation.zPosition = 0
        addChild(relation)
    }
    
    func getStarSystemCount() -> Int {
        return starSystems.count
    }
    
    func colonizeSystem(index: Int) {
        guard index < starSystems.count else { return }
        let system = starSystems[index]
        
        // Enhanced colonization indicator
        let indicator = SKShapeNode(circleOfRadius: 12)
        indicator.strokeColor = .green
        indicator.lineWidth = 3
        indicator.fillColor = .clear
        indicator.name = "fullyColonized"
        system.addChild(indicator)
        
        let pulse = SKAction.sequence([
            SKAction.scale(to: 1.5, duration: 0.7),
            SKAction.scale(to: 1.0, duration: 0.7)
        ])
        indicator.run(SKAction.repeatForever(pulse))
    }
}
