//
//  Run.swift
//  KardashevGame
//
//  Modello per una singola run di gioco
//

import Foundation

/// Motivo di game over
enum GameOverReason: String, Codable, CaseIterable {
    case inProgress = "In Corso"
    case completed = "Completata"
    case resourcesDepleted = "Risorse Esaurite"
    case nuclearWar = "Guerra Nucleare"
    case environmentalCollapse = "Collasso Ambientale"
    case civilWar = "Guerra Civile"
    case pandemic = "Pandemia"
    case alienInvasion = "Invasione Aliena"
    case spaceTimeAnomaly = "Anomalia Spazio-Temporale"
    case abandoned = "Abbandonata"
    
    var emoji: String {
        switch self {
        case .inProgress: return "🟢"
        case .completed: return "✅"
        case .resourcesDepleted: return "⚠️"
        case .nuclearWar: return "☢️"
        case .environmentalCollapse: return "🌡️"
        case .civilWar: return "⚔️"
        case .pandemic: return "🦠"
        case .alienInvasion: return "👽"
        case .spaceTimeAnomaly: return "🌀"
        case .abandoned: return "💤"
        }
    }
}

/// Evolution path (placeholder per future feature)
enum EvolutionPath: String, Codable, CaseIterable {
    case baseBiological = "Base Biologica"
    case pureBiological = "Biologica Pura"
    case geneticallyEnhanced = "Geneticamente Potenziata"
    case cyborg = "Cyborg"
    case digitalUploaded = "Digitale Uploaded"
    case ai = "AI"
    case collectiveMind = "Mente Collettiva"
    case synthetic = "Sintetica"
    case transcendent = "Trascendente"
}

/// Statistiche dettagliate per una run
struct RunStatistics: Codable {
    var totalClicks: BigNumber = BigNumber(0)
    var totalEnergyGenerated: BigNumber = BigNumber(0)
    var buildingsPurchased: BigNumber = BigNumber(0)
    var technologiesResearched: BigNumber = BigNumber(0)
    var planetsColonized: BigNumber = BigNumber(0)
    var disastersSurvived: BigNumber = BigNumber(0)
    
    // Tempo per stage (in secondi)
    var timeInStage1: TimeInterval = 0
    var timeInStage2: TimeInterval = 0
    var timeInStage3: TimeInterval = 0
    
    var totalPlayTime: TimeInterval {
        return timeInStage1 + timeInStage2 + timeInStage3
    }
}

/// Score breakdown dettagliato
struct ScoreBreakdown: Codable {
    var stageProgress: BigNumber = BigNumber(0)
    var efficiencyBonus: BigNumber = BigNumber(0)
    var speedBonus: BigNumber = BigNumber(0)
    var technologyBonus: BigNumber = BigNumber(0)
    var expansionBonus: BigNumber = BigNumber(0)
    var difficultyBonus: BigNumber = BigNumber(0)
    var survivalBonus: BigNumber = BigNumber(0)
    
    var totalScore: BigNumber {
        return stageProgress + efficiencyBonus + speedBonus + 
               technologyBonus + expansionBonus + difficultyBonus + survivalBonus
    }
}

/// Rappresenta una singola run di gioco
class Run: ObservableObject, Codable, Identifiable {
    let id: UUID
    let planetSeed: PlanetSeed
    
    // Metadata
    let createdAt: Date
    @Published var lastPlayedAt: Date
    @Published var totalPlayTime: TimeInterval
    
    // Stato run
    @Published var status: GameOverReason
    @Published var currentScore: BigNumber
    var finalScore: BigNumber?
    var scoreBreakdown: ScoreBreakdown
    
    // Game state
    @Published var gameState: GameState
    
    // Statistiche
    @Published var statistics: RunStatistics
    
    // Future features (placeholder)
    var evolutionPath: EvolutionPath?
    var majorDecisions: [String] = []
    
    init(planetSeed: PlanetSeed) {
        self.id = UUID()
        self.planetSeed = planetSeed
        self.createdAt = Date()
        self.lastPlayedAt = Date()
        self.totalPlayTime = 0
        self.status = .inProgress
        self.currentScore = BigNumber(0)
        self.finalScore = nil
        self.scoreBreakdown = ScoreBreakdown()
        self.gameState = GameState()
        self.statistics = RunStatistics()
        self.evolutionPath = nil
        self.majorDecisions = []
    }
    
    // MARK: - Codable
    
    enum CodingKeys: String, CodingKey {
        case id, planetSeed, createdAt, lastPlayedAt, totalPlayTime
        case status, currentScore, finalScore, scoreBreakdown
        case gameState, statistics, evolutionPath, majorDecisions
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        planetSeed = try container.decode(PlanetSeed.self, forKey: .planetSeed)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        lastPlayedAt = try container.decode(Date.self, forKey: .lastPlayedAt)
        totalPlayTime = try container.decode(TimeInterval.self, forKey: .totalPlayTime)
        status = try container.decode(GameOverReason.self, forKey: .status)
        currentScore = try container.decode(BigNumber.self, forKey: .currentScore)
        finalScore = try container.decodeIfPresent(BigNumber.self, forKey: .finalScore)
        scoreBreakdown = try container.decode(ScoreBreakdown.self, forKey: .scoreBreakdown)
        gameState = try container.decode(GameState.self, forKey: .gameState)
        statistics = try container.decode(RunStatistics.self, forKey: .statistics)
        evolutionPath = try container.decodeIfPresent(EvolutionPath.self, forKey: .evolutionPath)
        majorDecisions = try container.decode([String].self, forKey: .majorDecisions)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(planetSeed, forKey: .planetSeed)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(lastPlayedAt, forKey: .lastPlayedAt)
        try container.encode(totalPlayTime, forKey: .totalPlayTime)
        try container.encode(status, forKey: .status)
        try container.encode(currentScore, forKey: .currentScore)
        try container.encode(finalScore, forKey: .finalScore)
        try container.encode(scoreBreakdown, forKey: .scoreBreakdown)
        try container.encode(gameState, forKey: .gameState)
        try container.encode(statistics, forKey: .statistics)
        try container.encode(evolutionPath, forKey: .evolutionPath)
        try container.encode(majorDecisions, forKey: .majorDecisions)
    }
    
    // MARK: - Helpers
    
    /// Formatta il tempo giocato
    func formattedPlayTime() -> String {
        let hours = Int(totalPlayTime) / 3600
        let minutes = (Int(totalPlayTime) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    /// Calcola il progresso percentuale attraverso gli stage
    func stageProgress() -> Double {
        let stageValue = Double(gameState.civilization.stage.rawValue - 1) / 2.0 // 0.0, 0.5, 1.0
        return stageValue
    }
}
