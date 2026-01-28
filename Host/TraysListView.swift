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
//                    Button("Testons", systemImage: "plus") {
//                    let rule = VegetarianRule()
//                    
//                    // Test 1: Meat item (should fail)
//                    let chicken = MenuItem(
//                        name: "Grilled Chicken",
//                        mealTimes: [.lunch],
//                        dishType: .main,
//                        attributes: .none,
//                        tags: [.containsMeat]
//                    )
//                    let result1 = rule.evaluate(chicken)
//                    print("Chicken: \(result1.isPassing ? "PASS" : "FAIL")")
////                    print("Reason: \(result1.failureReason ?? "none")")
//
//                    // Test 2: Vegetarian item with tag (should pass)
//                    let salad = MenuItem(
//                        name: "Garden Salad",
//                        mealTimes: [.lunch],
//                        dishType: .side,
//                        attributes: .none,
//                        tags: [.vegetarian, .vegan]
//                    )
//                    let result2 = rule.evaluate(salad)
//                    print("\nSalad: \(result2.isPassing ? "PASS" : "FAIL")")
////                    print("Reason: \(result2.failureReason ?? "none")")
//
//                    // Test 3: Item with no tags (should pass - no meat!)
//                    let rice = MenuItem(
//                        name: "Brown Rice",
//                        mealTimes: [.lunch],
//                        dishType: .side,
//                        attributes: .none,
//                        tags: []
//                    )
//                    let result3 = rule.evaluate(rice)
//                    print("\nRice (no tags): \(result3.isPassing ? "PASS" : "FAIL")")
////                    print("Reason: \(result3.failureReason ?? "none")")
//
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
