//
//  NewRunView.swift
//  KardashevGame
//
//  Vista modale per creare una nuova run con seed planetario
//

import SwiftUI

struct NewRunView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var runManager = RunManager.shared
    
    @State private var planetSeed: PlanetSeed = PlanetGenerator.generateRandom()
    @State private var showSeedInput = false
    @State private var seedInputText = ""
    @State private var isGenerating = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.kardashevBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Planet visualization
                        planetVisualizationView
                        
                        // Seed parameters card
                        seedParametersCard
                        
                        // Action buttons
                        actionButtons
                    }
                    .padding()
                }
            }
            .navigationTitle("Nuova Run")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annulla") {
                        dismiss()
                    }
                }
            }
        }
        .alert("Inserisci Seed", isPresented: $showSeedInput) {
            TextField("Numero seed", text: $seedInputText)
                .keyboardType(.numberPad)
            
            Button("Annulla", role: .cancel) {
                seedInputText = ""
            }
            
            Button("Genera") {
                if let seedNumber = UInt64(seedInputText) {
                    generatePlanet(from: seedNumber)
                }
                seedInputText = ""
            }
        } message: {
            Text("Inserisci un numero seed per generare un pianeta specifico. Stesso seed = stesso pianeta.")
        }
    }
    
    // MARK: - Subviews
    
    private var planetVisualizationView: some View {
        VStack(spacing: 16) {
            // Planet circle with animation
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(hex: planetSeed.planetColor) ?? .blue,
                                Color(hex: planetSeed.planetColor)?.opacity(0.7) ?? .blue.opacity(0.7)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 180, height: 180)
                    .shadow(color: Color(hex: planetSeed.planetColor)?.opacity(0.5) ?? .blue.opacity(0.5), radius: 20)
                    .overlay(
                        Circle()
                            .stroke(
                                Color(hex: planetSeed.atmosphereColor)?.opacity(0.3) ?? .cyan.opacity(0.3),
                                lineWidth: 8
                            )
                            .frame(width: 200, height: 200)
                    )
                    .scaleEffect(isGenerating ? 0.9 : 1.0)
                    .animation(.easeInOut(duration: 0.3), value: isGenerating)
                
                Text(planetSeed.terrainType.emoji)
                    .font(.system(size: 60))
            }
            
            // Planet name
            Text(planetSeed.name)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            // Terrain type
            Text(planetSeed.terrainType.rawValue)
                .font(.system(size: 16))
                .foregroundColor(.kardashevAccent)
            
            // Difficulty rating
            HStack(spacing: 8) {
                Text(planetSeed.difficultyRating.emoji)
                    .font(.system(size: 20))
                
                Text(planetSeed.difficultyRating.rawValue)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(planetSeed.difficultyRating.color)
                
                Text("(x\(String(format: "%.1f", planetSeed.difficultyRating.scoreMultiplier)) score)")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(planetSeed.difficultyRating.color.opacity(0.2))
            )
        }
    }
    
    private var seedParametersCard: some View {
        VStack(spacing: 16) {
            Text("Parametri Planetari")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Resource parameters
            VStack(spacing: 12) {
                parameterRow(icon: "☀️", label: "Energia Solare", value: planetSeed.solarEnergy)
                parameterRow(icon: "💧", label: "Acqua", value: planetSeed.waterAvailability)
                parameterRow(icon: "💨", label: "Vento", value: planetSeed.windEnergy)
                parameterRow(icon: "🔥", label: "Geotermico", value: planetSeed.geothermalEnergy)
                parameterRow(icon: "⛏️", label: "Minerali", value: planetSeed.mineralResources)
                parameterRow(icon: "🌿", label: "Biodiversità", value: planetSeed.biodiversity)
            }
            
            Divider()
                .background(Color.white.opacity(0.3))
            
            // Difficulty parameters
            VStack(spacing: 12) {
                difficultyRow(icon: "⚠️", label: "Disastri Naturali", value: planetSeed.naturalDisasterChance)
                difficultyRow(icon: "☠️", label: "Tossicità Atmosferica", value: planetSeed.atmosphericToxicity)
                
                HStack {
                    Text("👾")
                        .font(.system(size: 20))
                    
                    Text("Vita Ostile")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text(planetSeed.hostileLifeforms ? "Presente" : "Assente")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(planetSeed.hostileLifeforms ? .red : .green)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.4))
        )
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            // Start run button
            Button(action: {
                if let newRun = runManager.createRun(with: planetSeed) {
                    dismiss()
                }
            }) {
                HStack {
                    Image(systemName: "play.circle.fill")
                        .font(.title2)
                    Text("INIZIA RUN")
                        .font(.system(size: 18, weight: .bold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.kardashevSuccess)
                        .shadow(color: .kardashevSuccess.opacity(0.5), radius: 10, x: 0, y: 4)
                )
            }
            
            HStack(spacing: 12) {
                // Regenerate button
                Button(action: {
                    regeneratePlanet()
                }) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("RIGENERA")
                            .font(.system(size: 14, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.kardashevPrimary)
                    )
                }
                
                // Input seed button
                Button(action: {
                    showSeedInput = true
                }) {
                    HStack {
                        Image(systemName: "keyboard")
                        Text("SEED")
                            .font(.system(size: 14, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray)
                    )
                }
            }
        }
    }
    
    private func parameterRow(icon: String, label: String, value: Double) -> some View {
        HStack {
            Text(icon)
                .font(.system(size: 20))
            
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(.white)
            
            Spacer()
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.2))
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(colorForValue(value))
                        .frame(width: geometry.size.width * CGFloat(value / 2.0))
                }
            }
            .frame(width: 80, height: 8)
            
            Text("\(planetSeed.percentage(for: value))%")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 50, alignment: .trailing)
            
            Text(planetSeed.qualitativeRating(for: value))
                .font(.system(size: 12))
                .foregroundColor(.gray)
                .frame(width: 80, alignment: .leading)
        }
    }
    
    private func difficultyRow(icon: String, label: String, value: Double) -> some View {
        HStack {
            Text(icon)
                .font(.system(size: 20))
            
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(.white)
            
            Spacer()
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.2))
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.red.opacity(0.8))
                        .frame(width: geometry.size.width * CGFloat(value))
                }
            }
            .frame(width: 80, height: 8)
            
            Text("\(Int(value * 100))%")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.red)
                .frame(width: 50, alignment: .trailing)
        }
    }
    
    private func colorForValue(_ value: Double) -> Color {
        if value < 0.6 {
            return .red
        } else if value < 1.2 {
            return .yellow
        } else {
            return .green
        }
    }
    
    // MARK: - Actions
    
    private func regeneratePlanet() {
        isGenerating = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            planetSeed = PlanetGenerator.generateRandom()
            isGenerating = false
        }
    }
    
    private func generatePlanet(from seedNumber: UInt64) {
        isGenerating = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            planetSeed = PlanetGenerator.generate(from: seedNumber)
            isGenerating = false
        }
    }
}
