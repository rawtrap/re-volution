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
    
    /// Calcola il punteggio corrente per una run
    func calculateCurrentScore(for run: Run) -> BigNumber {
        let gameState = run.gameState
        
        // Score base: energia totale / 1000
        let energyScore = gameState.resources.energy.amount / BigNumber(1000.0)
        
        // Score stage: stage corrente * 10000
        let stageScore = BigNumber(Double(gameState.civilization.stage.rawValue * 10000))
        
        // Score progresso stage (placeholder, sarà più complesso)
        let progressScore = BigNumber(run.stageProgress() * 100)
        
        // Applica moltiplicatore difficoltà
        let baseScore = energyScore + stageScore + progressScore
        let finalScore = baseScore * run.planetSeed.difficultyRating.scoreMultiplier
        
        return finalScore
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
