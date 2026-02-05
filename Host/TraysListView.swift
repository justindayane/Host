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
//                    Button("Testsssss") {
//                        let sodiumConstraint = Constraint.lowSodium
//                        if let rule = RuleFactory.rule(for: sodiumConstraint) {
//                            print("Created: \(rule.name)")
//                            print("Type: \(type(of: rule))")
//                        } else {
//                            print("No rule for: \(sodiumConstraint.name)")
//                        }
//                        
//                        let carbConstraint = Constraint.lowCarb
//                        if let rule = RuleFactory.rule(for: carbConstraint) {
//                            print("\nCreated: \(rule.name)")
//                        } else {
//                            print("\nNo rule for: \(carbConstraint.name)")
//                        }
//                        
//                        // Test 3: Get rule for unimplemented constraint
//                        let fatConstraint = Constraint.lowFat
//                        if let rule = RuleFactory.rule(for: fatConstraint) {
//                            print("\nCreated: \(rule.name)")
//                        } else {
//                            print("\nNo rule for: \(fatConstraint.name)")
//                        }
//                        
//                        // Test 4: Get all rules for a diet
//                        print("\n--- Cardiac Diet Rules ---")
//                        let cardiacConstraints = Diet.cardiac.constraints
//                        let cardiacRules = cardiacConstraints.compactMap { RuleFactory.rule(for: $0) }
//                        print("Constraints: \(cardiacConstraints.map { $0.name })")
//                        print("Rules created: \(cardiacRules.map { $0.name })")
//                    }
                    
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
