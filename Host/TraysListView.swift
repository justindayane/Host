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
//                        // Create rule with 30g limit (typical for carb control)
//                        let rule = LowCarbRule(maxCarbs: 30)
//
//                        // Test 1: Low carb item (chicken - no carbs)
//                        let chicken = MenuItem(
//                            name: "Grilled Chicken",
//                            mealTimes: [.lunch],
//                            dishType: .main,
//                            attributes: NutritionAttributes(carbs: 0)
//                        )
//                        let result1 = rule.evaluate(chicken)
//                        print(result1)
//                        print("Chicken: \(result1.isPassing ? "PASS" : "FAIL")")
//                        if let reason = result1.failureReason {
//                            print("Reason: \(result1.failureReason)")
//                        } else {
//                            print("Reason: none")
//                        }
//                        
//
////                         Test 2: High carb item (rice)
//                        let rice = MenuItem(
//                            name: "White Rice",
//                            mealTimes: [.lunch],
//                            dishType: .side,
//                            attributes: NutritionAttributes(carbs: 45)
//                        )
//                        let result2 = rule.evaluate(rice)
//                        print("\nRice: \(result2.isPassing ? "PASS" : "FAIL")")
//                        if let reason = result2.failureReason {
//                            print("Reason: \(result2.failureReason)")
//                        } else {
//                            print("Reason: none")
//                        }
//
////                         Test 3: Moderate carb item (at limit)
//                        let toast = MenuItem(
//                            name: "Whole Wheat Toast",
//                            mealTimes: [.breakfast],
//                            dishType: .side,
//                            attributes: NutritionAttributes(carbs: 30)
//                        )
//                        let result3 = rule.evaluate(toast)
//                        print("\nToast (30g): \(result3.isPassing ? "PASS" : "FAIL")")
//                        if let reason = result3.failureReason {
//                            print("Reason: \(result3.failureReason)")
//                        } else {
//                            print("Reason: none")
//                        }
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
