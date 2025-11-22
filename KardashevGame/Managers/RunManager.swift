//
//  RunManager.swift
//  KardashevGame
//
//  Manager per gestire multiple run parallele
//

import Foundation
import Combine

class RunManager: ObservableObject {
    static let shared = RunManager()
    
    @Published var runs: [Run] = []
    @Published var currentRun: Run?
    
    private let maxActiveRuns = 5
    
    private init() {
        loadAllRuns()
    }
    
    // MARK: - Run Management
    
    /// Crea una nuova run con il seed specificato
    func createRun(with planetSeed: PlanetSeed) -> Run? {
        // Verifica limite run attive
        let activeRuns = runs.filter { $0.status == .inProgress }
        if activeRuns.count >= maxActiveRuns {
            print("❌ Limite massimo di \(maxActiveRuns) run attive raggiunto")
            return nil
        }
        
        let newRun = Run(planetSeed: planetSeed)
        runs.append(newRun)
        currentRun = newRun
        
        saveAllRuns()
        print("✅ Nuova run creata: \(newRun.planetSeed.name)")
        return newRun
    }
    
    /// Carica una run esistente e la imposta come corrente
    func loadRun(_ run: Run) {
        currentRun = run
        run.lastPlayedAt = Date()
        saveAllRuns()
        print("✅ Run caricata: \(run.planetSeed.name)")
    }
    
    /// Elimina una run
    func deleteRun(_ run: Run) {
        if let index = runs.firstIndex(where: { $0.id == run.id }) {
            runs.remove(at: index)
            
            // Se era la run corrente, deseleziona
            if currentRun?.id == run.id {
                currentRun = nil
            }
            
            saveAllRuns()
            print("🗑 Run eliminata: \(run.planetSeed.name)")
        }
    }
    
    /// Duplica una run esistente con un nuovo seed
    func duplicateRun(_ run: Run) -> Run? {
        let activeRuns = runs.filter { $0.status == .inProgress }
        if activeRuns.count >= maxActiveRuns {
            print("❌ Limite massimo di \(maxActiveRuns) run attive raggiunto")
            return nil
        }
        
        // Crea nuova run con stesso seed number (stesso pianeta)
        let newSeed = PlanetGenerator.generate(from: run.planetSeed.seedNumber)
        return createRun(with: newSeed)
    }
    
    // MARK: - Queries
    
    /// Ottiene tutte le run attive
    func activeRuns() -> [Run] {
        return runs.filter { $0.status == .inProgress }
    }
    
    /// Ottiene tutte le run completate
    func completedRuns() -> [Run] {
        return runs.filter { $0.status == .completed }
    }
    
    /// Ottiene tutte le run fallite (game over)
    func failedRuns() -> [Run] {
        return runs.filter {
            $0.status != .inProgress && $0.status != .completed
        }
    }
    
    /// Ottiene run filtrate per difficoltà
    func runs(byDifficulty difficulty: DifficultyRating) -> [Run] {
        return runs.filter { $0.planetSeed.difficultyRating == difficulty }
    }
    
    /// Trova la run con il punteggio più alto
    func bestRun() -> Run? {
        return runs.max { run1, run2 in
            let score1 = run1.finalScore ?? run1.currentScore
            let score2 = run2.finalScore ?? run2.currentScore
            return score1 < score2
        }
    }
    
    // MARK: - Score Calculation
    
    /// Calcola il punteggio corrente per una run con breakdown completo
    func calculateCurrentScore(for run: Run) -> BigNumber {
        let gameState = run.gameState
        var breakdown = ScoreBreakdown()
        
        // 1. Stage Progress Score (peso 40%)
        let stageValue = Double(gameState.civilization.stage.rawValue)
        let stageProgress = run.stageProgress()
        breakdown.stageProgress = BigNumber((stageValue * 10000 + stageProgress * 5000))
        
        // 2. Efficiency Bonus (peso 15%)
        // Basato su quanto efficiente è stata la produzione
        let totalProduction = gameState.resources.energy.amount + 
                             gameState.resources.food.amount +
                             gameState.resources.materials.amount +
                             gameState.resources.knowledge.amount
        let timeEfficiency = totalProduction / BigNumber(max(1.0, run.totalPlayTime / 60.0)) // Per minuto
        breakdown.efficiencyBonus = timeEfficiency * 0.5
        
        // 3. Speed Bonus (peso 10%)
        // Bonus per completamento veloce degli stage
        if run.totalPlayTime > 0 {
            let speedMultiplier = 10000.0 / max(1.0, run.totalPlayTime / 60.0) // Inversamente proporzionale al tempo
            breakdown.speedBonus = BigNumber(speedMultiplier * 100)
        }
        
        // 4. Technology Bonus (peso 10%)
        breakdown.technologyBonus = run.statistics.technologiesResearched * BigNumber(500)
        
        // 5. Expansion Bonus (peso 10%)
        breakdown.expansionBonus = run.statistics.planetsColonized * BigNumber(1000) +
                                  run.statistics.buildingsPurchased * BigNumber(10)
        
        // 6. Difficulty Bonus (peso 10%)
        let difficultyMult = run.planetSeed.difficultyRating.scoreMultiplier
        breakdown.difficultyBonus = (breakdown.stageProgress + breakdown.efficiencyBonus) * 
                                    (difficultyMult - 1.0)
        
        // 7. Survival Bonus (peso 5%)
        // Bonus per sopravvivere a disastri
        breakdown.survivalBonus = run.statistics.disastersSurvived * BigNumber(2000)
        
        // Bonus evoluzione e decisioni
        if let evolutionPath = run.evolutionPath {
            if let civPath = CivilizationEvolutionPath(rawValue: evolutionPath.rawValue) {
                let evolutionBonus = civPath.bonuses.productionMultiplier * 1000
                breakdown.technologyBonus = breakdown.technologyBonus + BigNumber(evolutionBonus)
            }
        }
        
        // Bonus per decisioni strategiche
        let decisionBonus = Double(run.majorDecisions.count) * 500.0
        breakdown.expansionBonus = breakdown.expansionBonus + BigNumber(decisionBonus)
        
        // Bonus parametri civiltà
        let civParams = gameState.civilization.parameters
        let avgParam = (civParams.happiness + civParams.transportation + civParams.food +
                       civParams.education + civParams.military + civParams.health) / 6.0
        let paramBonus = avgParam * 100.0
        breakdown.efficiencyBonus = breakdown.efficiencyBonus + BigNumber(paramBonus)
        
        // Aggiorna breakdown nella run
        run.scoreBreakdown = breakdown
        
        return breakdown.totalScore
    }
    
    /// Aggiorna il punteggio corrente di una run
    func updateScore(for run: Run) {
        run.currentScore = calculateCurrentScore(for: run)
    }
    
    // MARK: - Statistics
    
    /// Calcola il tempo totale giocato su tutte le run
    func totalPlayTimeAllRuns() -> TimeInterval {
        return runs.reduce(0) { $0 + $1.totalPlayTime }
    }
    
    /// Calcola la media dei punteggi
    func averageScore() -> BigNumber {
        guard !runs.isEmpty else { return BigNumber(0) }
        var totalScore = BigNumber(0)
        for run in runs {
            totalScore = totalScore + (run.finalScore ?? run.currentScore)
        }
        return totalScore / BigNumber(Double(runs.count))
    }
    
    /// Calcola il tasso di completamento
    func completionRate() -> Double {
        guard !runs.isEmpty else { return 0 }
        let completed = completedRuns().count
        return Double(completed) / Double(runs.count)
    }
    
    // MARK: - Persistence
    
    /// Salva tutte le run
    func saveAllRuns() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(runs)
            UserDefaults.standard.set(data, forKey: "kardashevAllRuns")
            
            // Salva anche l'ID della run corrente
            if let currentRun = currentRun {
                UserDefaults.standard.set(currentRun.id.uuidString, forKey: "kardashevCurrentRunId")
            } else {
                UserDefaults.standard.removeObject(forKey: "kardashevCurrentRunId")
            }
            
            print("✅ \(runs.count) run salvate")
        } catch {
            print("❌ Errore nel salvataggio delle run: \(error)")
        }
    }
    
    /// Carica tutte le run
    func loadAllRuns() {
        guard let data = UserDefaults.standard.data(forKey: "kardashevAllRuns") else {
            print("ℹ️ Nessuna run salvata trovata")
            return
        }
        
        do {
            let decoder = JSONDecoder()
            runs = try decoder.decode([Run].self, from: data)
            
            // Ripristina la run corrente
            if let currentRunIdString = UserDefaults.standard.string(forKey: "kardashevCurrentRunId"),
               let currentRunId = UUID(uuidString: currentRunIdString) {
                currentRun = runs.first { $0.id == currentRunId }
            }
            
            print("✅ \(runs.count) run caricate")
        } catch {
            print("❌ Errore nel caricamento delle run: \(error)")
        }
    }
    
    /// Salva solo la run corrente (più veloce)
    func saveCurrentRun() {
        guard let currentRun = currentRun else { return }
        
        // Trova e aggiorna la run nell'array
        if let index = runs.firstIndex(where: { $0.id == currentRun.id }) {
            runs[index] = currentRun
            saveAllRuns()
        }
    }
    
    /// Carica una run specifica da ID
    func loadRun(byId id: UUID) -> Run? {
        return runs.first { $0.id == id }
    }
    
    // MARK: - Debug
    
    /// Reset completo (cancella tutte le run)
    func resetAll() {
        runs.removeAll()
        currentRun = nil
        UserDefaults.standard.removeObject(forKey: "kardashevAllRuns")
        UserDefaults.standard.removeObject(forKey: "kardashevCurrentRunId")
        print("🗑 Tutte le run cancellate")
    }
}
