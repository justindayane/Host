//
//  ItemSelectionView.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 1/4/26.
//

import SwiftUI

struct ItemSelectionView: View {
    let tray: Tray // <- Adding this so that I can maintain the mental model of passing the tray rather than pieces of details
    let allMenuItems: [MenuItem]
    var onComplete: ([MenuItem]) -> Void
    
    @State private var selectedItems: Set<UUID> = []
    @Environment(\.dismiss) var dismiss
    
    // State needed for failure explanation sheet
    @State private var selectedEvaluation: ItemEvaluation?
    
    
    private var report: EvaluationReport {
        // First lets apply the hard filter - mealTime
        let availableItems = allMenuItems.filter { item in
            item.mealTimes.contains(tray.mealTime)
        }
        
        // Then we apply the soft filter with explanations
        return RulesEngine.evaluate(availableItems, diet: tray.diet, mealTime: tray.mealTime, extraConstraints: tray.extraConstraints)
    }
    
    // Filtering logic (Reusing)
    private var filteredMenuItems: [MenuItem] {
        if tray.diet == .regular {
            return allMenuItems
        } else {
            return allMenuItems.filter { $0.diets.isEmpty || $0.diets.contains(tray.diet) }
        }
    }
    
    
    // Converting IDs into menuItems
    private func getSelectedItems() -> [MenuItem] {
        allMenuItems.filter { selectedItems.contains($0.id) }
    }
    
    // Toggling selection for an item
    private func toggleSelection(for item: MenuItem) {
        if selectedItems.contains(item.id) {
            selectedItems.remove(item.id)
        } else {
            selectedItems.insert(item.id)
        }
    }
    
    var body: some View {
        List {

            Section(header: Text("Items")) {
                ForEach(report.evaluations) { evaluation in
                    MenuItemRow(item: evaluation.item, isSelected: selectedItems.contains(evaluation.item.id), isAllowed: evaluation.isAllowed, onTap: {
                        // Only allow selection if item is allowed
                        if evaluation.isAllowed {
                            toggleSelection(for: evaluation.item)
                        }
                        else {
                            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                            impactFeedback.impactOccurred()
                            
                            selectedEvaluation = evaluation
                        }
                    })
                }
            }
        }
        .overlay {
            if !report.hasAllowedItems {
                VStack(spacing: 8) {
                    Text("No Item Passed the constraints")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .background(.red)
                    if let top = report.sortedFailureReasons.first {
                        Text("Most Items are blocked by: ")
                            .font(.subheadline)
                            .background(.red)
                        Text("\(top.reason)")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .background(.red)
                    }
                    Text("Try adjusting the diet or meal time, or ask the dietitian.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .background(.red)
                }
                .padding()
            }
        }
        .navigationTitle("Select Items")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") {
                    let selectedItems = getSelectedItems()
                    print("sending selected items: \(selectedItems)")
                    onComplete(selectedItems)
                    dismiss()
                }
                .disabled(selectedItems.isEmpty)
            }
        }
        .sheet(item: $selectedEvaluation) { evaluation in
            ItemExplanationView(evaluation: evaluation)
        }
    }
}

#Preview {
    ItemSelectionView(tray: Tray(diet: .carbControl, time: .lunch, items: [MenuItem.samples[0]]),
        allMenuItems: MenuItem.samples,
        onComplete: {
            _ in
        })
}
