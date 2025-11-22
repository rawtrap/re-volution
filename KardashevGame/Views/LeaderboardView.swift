//
//  LeaderboardView.swift
//  KardashevGame
//
//  Vista leaderboard locale per confrontare run
//

import SwiftUI

struct LeaderboardView: View {
    @ObservedObject var runManager = RunManager.shared
    @Environment(\.dismiss) var dismiss
    @State private var selectedFilter: LeaderboardFilter = .allTime
    @State private var selectedDifficulty: DifficultyRating? = nil
    
    enum LeaderboardFilter: String, CaseIterable {
        case allTime = "Tutti i Tempi"
        case completed = "Completate"
        case byDifficulty = "Per Difficoltà"
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.kardashevBackground.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Filter selector
                    filterSelector
                    
                    // Difficulty selector (if by difficulty filter selected)
                    if selectedFilter == .byDifficulty {
                        difficultySelector
                    }
                    
                    // Stats summary
                    statsSummary
                    
                    // Leaderboard content
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(Array(filteredRuns().enumerated()), id: \.element.id) { index, run in
                                leaderboardRow(rank: index + 1, run: run)
                            }
                            
                            if filteredRuns().isEmpty {
                                emptyStateView
                            }
                            
                            Spacer(minLength: 50)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("🏆 Leaderboard")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Chiudi") {
                        dismiss()
                    }
                    .foregroundColor(.kardashevPrimary)
                }
            }
        }
    }
    
    // MARK: - Filter Selector
    
    private var filterSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(LeaderboardFilter.allCases, id: \.self) { filter in
                    Button(action: {
                        selectedFilter = filter
                    }) {
                        Text(filter.rawValue)
                            .font(.system(size: 14, weight: selectedFilter == filter ? .bold : .medium))
                            .foregroundColor(selectedFilter == filter ? .white : .gray)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(selectedFilter == filter ? Color.kardashevPrimary : Color.black.opacity(0.3))
                            )
                    }
                }
            }
            .padding()
        }
        .background(Color.black.opacity(0.3))
    }
    
    private var difficultySelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                Button(action: {
                    selectedDifficulty = nil
                }) {
                    Text("Tutte")
                        .font(.system(size: 12, weight: selectedDifficulty == nil ? .bold : .medium))
                        .foregroundColor(selectedDifficulty == nil ? .white : .gray)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(selectedDifficulty == nil ? Color.kardashevAccent : Color.black.opacity(0.3))
                        )
                }
                
                ForEach(DifficultyRating.allCases, id: \.self) { difficulty in
                    Button(action: {
                        selectedDifficulty = difficulty
                    }) {
                        HStack(spacing: 4) {
                            Text(difficulty.emoji)
                                .font(.caption)
                            Text(difficulty.rawValue)
                                .font(.system(size: 12, weight: selectedDifficulty == difficulty ? .bold : .medium))
                                .foregroundColor(selectedDifficulty == difficulty ? .white : .gray)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(selectedDifficulty == difficulty ? difficulty.color : Color.black.opacity(0.3))
                        )
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
    
    // MARK: - Stats Summary
    
    private var statsSummary: some View {
        HStack(spacing: 20) {
            statCard(icon: "🎮", label: "Run Totali", value: "\(runManager.runs.count)")
            statCard(icon: "✅", label: "Completate", value: "\(runManager.completedRuns().count)")
            statCard(icon: "⏱", label: "Tempo Totale", value: formatTime(runManager.totalPlayTimeAllRuns()))
        }
        .padding()
        .background(Color.black.opacity(0.3))
    }
    
    private func statCard(icon: String, label: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(icon)
                .font(.title2)
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Leaderboard Row
    
    private func leaderboardRow(rank: Int, run: Run) -> some View {
        HStack(spacing: 16) {
            // Rank badge
            ZStack {
                Circle()
                    .fill(rankColor(rank))
                    .frame(width: 40, height: 40)
                
                Text("\(rank)")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }
            
            // Planet info
            VStack(alignment: .leading, spacing: 4) {
                Text(run.planetSeed.name)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                
                HStack(spacing: 8) {
                    HStack(spacing: 2) {
                        Text(run.planetSeed.difficultyRating.emoji)
                            .font(.caption)
                        Text(run.planetSeed.difficultyRating.rawValue)
                            .font(.system(size: 10))
                            .foregroundColor(run.planetSeed.difficultyRating.color)
                    }
                    
                    Text("•")
                        .foregroundColor(.gray)
                    
                    Text(run.gameState.civilization.stage.displayName)
                        .font(.system(size: 10))
                        .foregroundColor(.kardashevAccent)
                    
                    Text("•")
                        .foregroundColor(.gray)
                    
                    Text(run.formattedPlayTime())
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            // Score
            VStack(alignment: .trailing, spacing: 2) {
                Text((run.finalScore ?? run.currentScore).formatted())
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.kardashevAccent)
                
                Text("SCORE")
                    .font(.system(size: 8, weight: .medium))
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(rank <= 3 ? rankColor(rank).opacity(0.2) : Color.black.opacity(0.4))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(rank <= 3 ? rankColor(rank).opacity(0.5) : Color.clear, lineWidth: 2)
        )
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Text("🏆")
                .font(.system(size: 60))
            
            Text("Nessuna Run")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            Text("Completa alcune run per vedere\nla leaderboard!")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding(40)
    }
    
    // MARK: - Helpers
    
    private func filteredRuns() -> [Run] {
        var runs = runManager.runs
        
        switch selectedFilter {
        case .allTime:
            runs = runManager.runs
        case .completed:
            runs = runManager.completedRuns()
        case .byDifficulty:
            if let difficulty = selectedDifficulty {
                runs = runManager.runs(byDifficulty: difficulty)
            }
        }
        
        // Sort by score (descending)
        return runs.sorted { run1, run2 in
            let score1 = run1.finalScore ?? run1.currentScore
            let score2 = run2.finalScore ?? run2.currentScore
            return score1 > score2
        }
    }
    
    private func rankColor(_ rank: Int) -> Color {
        switch rank {
        case 1: return .yellow // Gold
        case 2: return Color(red: 0.75, green: 0.75, blue: 0.75) // Silver
        case 3: return Color(red: 0.8, green: 0.5, blue: 0.2) // Bronze
        default: return .gray
        }
    }
    
    private func formatTime(_ seconds: TimeInterval) -> String {
        let hours = Int(seconds) / 3600
        let minutes = (Int(seconds) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}
