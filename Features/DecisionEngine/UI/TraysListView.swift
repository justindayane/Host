//
//  TraysListView.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 12/17/25.
//

import SwiftUI

struct TraysListView: View {
    @State private var trays: [Tray] = Tray.samples
    @State private var showingCreateTray:Bool = false
    @StateObject private var history = DecisionHistory()
    
    @State private var showingAIParsing: Bool = false
    @State private var pendingParsedRequest: ParsedTrayRequest? = nil
    
    
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
                CreateTrayView(suggestedDiet: pendingParsedRequest?.diet, suggestedMealTime: pendingParsedRequest?.mealTime, onComplete: addTray)
            }
            .sheet(isPresented: $showingAIParsing) {
                AIParsingView { aiParsed in
                    pendingParsedRequest = aiParsed
                    showingAIParsing = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showingCreateTray = true
                    }
                }
                
            }
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

#Preview {
    TraysListView()
}
