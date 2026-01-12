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
            }
            .sheet(isPresented: $showingCreateTray) {
                CreateTrayView(onComplete: { newTray in
                    trays.append(newTray)
                })
            }
        }
    }
    
    private var traysList: some View {
        List {
            ForEach(trays.indices, id: \.self) { index in
                NavigationLink {
                    TrayDetailView(tray: $trays[index])
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
}

#Preview {
    TraysListView()
}
