//
//  SaveManager.swift
//  KardashevGame
//
//  Gestisce il salvataggio e caricamento dello stato del gioco
//

import Foundation

class SaveManager {
    static let shared = SaveManager()
    
    private init() {}
    
    /// Salva lo stato del gioco
    func save(_ gameState: GameState) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(gameState)
            UserDefaults.standard.set(data, forKey: Constants.saveKey)
            UserDefaults.standard.set(Date(), forKey: Constants.lastSaveTimeKey)
            print("✅ Gioco salvato con successo")
        } catch {
            print("❌ Errore nel salvataggio: \(error)")
        }
    }
    
    /// Carica lo stato del gioco
    func load() -> GameState? {
        guard let data = UserDefaults.standard.data(forKey: Constants.saveKey) else {
            print("ℹ️ Nessun salvataggio trovato, nuovo gioco")
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            let gameState = try decoder.decode(GameState.self, from: data)
            print("✅ Gioco caricato con successo")
            return gameState
        } catch {
            print("❌ Errore nel caricamento: \(error)")
            return nil
        }
    }
    
    /// Ottiene il tempo dall'ultimo salvataggio
    func timeSinceLastSave() -> TimeInterval? {
        guard let lastSaveTime = UserDefaults.standard.object(forKey: Constants.lastSaveTimeKey) as? Date else {
            return nil
        }
        return Date().timeIntervalSince(lastSaveTime)
    }
    
    /// Cancella il salvataggio (per reset)
    func deleteSave() {
        UserDefaults.standard.removeObject(forKey: Constants.saveKey)
        UserDefaults.standard.removeObject(forKey: Constants.lastSaveTimeKey)
        print("🗑 Salvataggio cancellato")
    }
}
