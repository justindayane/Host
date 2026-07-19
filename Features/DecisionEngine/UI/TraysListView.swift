//
//  Created by Justin Dayane  Gbadamassi on 12/17/25.

//  TraysListView.swift
//  Host
//

//

import SwiftUI

struct TraysListView: View {
    @State private var trays: [Tray] = Tray.samples
    @State private var showingCreateTray:Bool = false
    @StateObject private var history = DecisionHistory()
    
    @State private var showingAIParsing: Bool = false
    @State private var pendingParsedRequest: ParsedTrayRequest? = nil
    
    @State private var candidateGeneratedTray: GeneratedTray? = nil
    
    @State private var selectedTray: SelectedTray? = nil
    
    var body: some View {
        NavigationStack {
            Group {
                if trays.isEmpty {
                    ContentUnavailableView(
                        "No Trays",
                        systemImage: "tray.fill",
                        description: Text(
                            "Create a Tray to get started"
                        )
                    )
                } else {
                    traysList
                }
                
            }
            .navigationTitle("Trays")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add", systemImage: "plus") {
                        showingCreateTray = true
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        DecisionHistoryView(history: history)
                    } label: {
                        Image(systemName: "list.bullet.clipboard")
                    }
                }
                ToolbarItem {
                    Button("AI", systemImage: "wand.and.stars") {
                        showingAIParsing = true
                    }
                }
            }
            .sheet(isPresented: $showingCreateTray, onDismiss: { pendingParsedRequest = nil }) {
                CreateTrayView(suggestedDiet: pendingParsedRequest?.diet, suggestedMealTime: pendingParsedRequest?.mealTime, onComplete: { tray in
                    trays.append(tray)
                    selectedTray = SelectedTray(id: tray.id)
                } )
            }
            .sheet(item: $selectedTray) { selected in
                NavigationStack {
                    let id = selected.id
                    if let index = trays.firstIndex(where: { $0.id == id }) {
                        ItemSelectionView(tray: $trays[index], allMenuItems: MenuItem.samples, onDone: {
                            if let i = trays.firstIndex(where: { $0.id == id }){
                                history.recordDecision(from: trays[i], wasDefault: false)
                            }
                            selectedTray = nil
                        }, onCancel: {
                            if let i = trays.firstIndex(where: { $0.id == id }) {
                                trays.remove(at: i)
                            }
                            selectedTray = nil
                        })
                    }
                    else {
                        Text("Tray Not Found")
                    }
                }
            }
            .sheet(isPresented: $showingAIParsing) {
                AIParsingView { aiParsed in
                    if let diet = aiParsed.diet, let mealTime = aiParsed.mealTime  {
                        let tray = Tray(diet: diet, time: mealTime)
                        let generatedTray = DefaultTrayGenerator.generate(from: MenuItem.samples, for: tray)
                        showingAIParsing = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            candidateGeneratedTray = generatedTray
                        }
                    }
                    else {
                        pendingParsedRequest = aiParsed
                        showingAIParsing = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            showingCreateTray = true
                        }
                    }
                }
            }
            .sheet(item: $candidateGeneratedTray) { generatedTray in
                ScrollView {
                    VStack (alignment: .leading, spacing: 8){
                        Text("Generated Tray")
                            .font(.title2)
                        Text(generatedTray.tray.displayName) // includes the diet and the mealTime
                        Text("Status: \(generatedTray.isComplete ? "Complete" : "Incomplete")")
                        Divider()
                        ForEach(generatedTray.tray.items) { item in
                            MenuItemRow(item: item, isSelected: false, isAllowed: true, onTap: {})
                        }
                        Divider()
                        VStack(alignment: .leading) {
                            Text("Explanations")
                                .font(.headline)
                                .padding(.bottom, 4)
                            ForEach(generatedTray.traces, id: \.self) { trace in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(trace.category.rawValue.capitalized)
                                        .fontWeight(.semibold)
                                    Text(trace.reason)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    HStack {
                        Button("Use This Tray") {
                            trays.append(generatedTray.tray)
                            history.recordDecision(from: generatedTray.tray, wasDefault: true)
                            candidateGeneratedTray = nil
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button("Discard", role: .destructive) {
                            candidateGeneratedTray = nil
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
            .presentationDetents([.medium, .large])
        }
    }
    
    private var traysList: some View {
        List {
            ForEach(trays.indices, id: \.self) { index in
                NavigationLink {
                    TrayDetailView(tray: $trays[index], history: history, addTray: addTray)
                } label: {
                    TrayRowView(tray: trays[index])
                }
            }
            .onDelete(perform: deleteTray)
        }
    }
    
    private func deleteTray(at offsets: IndexSet) {
        trays.remove(atOffsets: offsets)
    }
    
    private func addTray(_ tray: Tray) {
        trays.append(tray)
    }
    
}

// Small wrapper needed around the selectedTray id so we can drive .sheet(item:) with an Identifiable value
struct SelectedTray: Identifiable {
    let id: UUID
}
#Preview {
    TraysListView()
}
