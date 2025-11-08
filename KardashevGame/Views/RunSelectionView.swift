//
//  RunSelectionView.swift
//  KardashevGame
//
//  Vista principale per selezionare e gestire run multiple
//

import SwiftUI

enum RunFilter: String, CaseIterable {
    case all = "Tutte"
    case active = "Attive"
    case completed = "Completate"
    case failed = "Fallite"
}

enum RunSortOption: String, CaseIterable {
    case date = "Data"
    case score = "Score"
    case difficulty = "Difficoltà"
}

struct RunSelectionView: View {
    @ObservedObject var runManager = RunManager.shared
    @State private var showNewRun = false
    @State private var selectedFilter: RunFilter = .all
    @State private var sortOption: RunSortOption = .date
    @State private var runToDelete: Run?
    @State private var showDeleteConfirmation = false
    @State private var selectedRunForStats: Run?
    
    var body: some View {
        ZStack {
            Color.kardashevBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                headerView
                
                // Filters and Sort
                controlsView
                
                // Run List
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredAndSortedRuns()) { run in
                            RunCardView(run: run)
                                .onTapGesture {
                                    runManager.loadRun(run)
                                }
                                .contextMenu {
                                    Button {
                                        selectedRunForStats = run
                                    } label: {
                                        Label("Statistiche", systemImage: "chart.bar")
                                    }
                                    
                                    Button(role: .destructive) {
                                        runToDelete = run
                                        showDeleteConfirmation = true
                                    } label: {
                                        Label("Elimina", systemImage: "trash")
                                    }
                                }
                        }
                        
                        if runManager.runs.isEmpty {
                            emptyStateView
                        }
                    }
                    .padding()
                }
            }
        }
        .sheet(isPresented: $showNewRun) {
            NewRunView()
        }
        .sheet(item: $selectedRunForStats) { run in
            RunStatsView(run: run)
        }
        .alert("Elimina Run", isPresented: $showDeleteConfirmation, presenting: runToDelete) { run in
            Button("Annulla", role: .cancel) {
                runToDelete = nil
            }
            Button("Elimina", role: .destructive) {
                runManager.deleteRun(run)
                runToDelete = nil
            }
        } message: { run in
            Text("Sei sicuro di voler eliminare la run '\(run.planetSeed.name)'? Questa azione non può essere annullata.")
        }
    }
    
    // MARK: - Subviews
    
    private var headerView: some View {
        VStack(spacing: 12) {
            Text("♾️ Kardashev")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.white)
            
            Text("Le Tue Run")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.kardashevPrimary)
            
            // New Run Button
            Button(action: {
                showNewRun = true
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                    Text("NUOVA RUN")
                        .font(.system(size: 18, weight: .bold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.kardashevPrimary)
                        .shadow(color: .kardashevPrimary.opacity(0.5), radius: 10, x: 0, y: 4)
                )
            }
            .padding(.horizontal)
            .padding(.top, 8)
        }
        .padding(.vertical, 20)
    }
    
    private var controlsView: some View {
        VStack(spacing: 12) {
            // Filters
            HStack(spacing: 12) {
                ForEach(RunFilter.allCases, id: \.self) { filter in
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
            
            // Sort
            HStack {
                Text("Ordina per:")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                Picker("Sort", selection: $sortOption) {
                    ForEach(RunSortOption.allCases, id: \.self) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 12)
        .background(Color.black.opacity(0.2))
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Text("🌍")
                .font(.system(size: 80))
            
            Text("Nessuna Run")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            Text("Crea la tua prima run per iniziare\nl'avventura verso la Tipo III!")
                .font(.system(size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            Button(action: {
                showNewRun = true
            }) {
                Text("Crea Prima Run")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.kardashevPrimary)
                    )
            }
        }
        .padding(40)
    }
    
    // MARK: - Filtering and Sorting
    
    private func filteredAndSortedRuns() -> [Run] {
        var filtered: [Run]
        
        switch selectedFilter {
        case .all:
            filtered = runManager.runs
        case .active:
            filtered = runManager.activeRuns()
        case .completed:
            filtered = runManager.completedRuns()
        case .failed:
            filtered = runManager.failedRuns()
        }
        
        return filtered.sorted { run1, run2 in
            switch sortOption {
            case .date:
                return run1.lastPlayedAt > run2.lastPlayedAt
            case .score:
                let score1 = run1.finalScore ?? run1.currentScore
                let score2 = run2.finalScore ?? run2.currentScore
                return score1 > score2
            case .difficulty:
                return run1.planetSeed.difficultyScore > run2.planetSeed.difficultyScore
            }
        }
    }
}
