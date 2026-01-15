//
//  ItemSelectionView.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 1/4/26.
//

import SwiftUI

struct ItemSelectionView: View {
    let diet: Diet
    let allMenuItems: [MenuItem]
    let mealTime: MealTime // Needed to add this in order to use the RulesEngine
    var onComplete: ([MenuItem]) -> Void
    
    @State private var selectedItems: Set<UUID> = []
    @Environment(\.dismiss) var dismiss
    
    private var report: EvaluationReport {
        RulesEngine.evaluate(allMenuItems, diet: diet, mealTime: mealTime)
        
        // Test
//        let r = RulesEngine.evaluate(
//                allMenuItems,
//                diet: diet,
//                mealTime: mealTime
//            )
//            
//            print("📊 Report: \(r.allowedCount) allowed, \(r.blockedCount) blocked")
//            return r
    }
    
    // Filtering logic (Reusing)
    private var filteredMenuItems: [MenuItem] {
        if diet == .regular {
            return allMenuItems
        } else {
            return allMenuItems.filter { $0.diets.isEmpty || $0.diets.contains(diet) }
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
            // Old
//            Section(header: Text("Old Way - Items")) {
//                ForEach(allMenuItems, id: \.id) { item in
//                    HStack {
//                        // Check Mark Indicator
//                        Image(systemName: selectedItems.contains(item.id) ? "checkmark.circle.fill" : "circle")
//                            .foregroundStyle(selectedItems.contains(item.id) ? .blue : .secondary)
//                        // Item Details
//                        VStack (alignment: .leading, spacing: 4){
//                            Text(item.name)
//                                .font(.headline)
//                            Text(item.nutrition)
//                                .font(.caption)
//                                .foregroundStyle(.secondary)
//                        }
//                        
//                        Spacer()
//                    }
//                    .contentShape(Rectangle())
//                    .onTapGesture {
//                        toggleSelection(for: item)
//                    }
//                }
//            }
            
            // New
            Section(header: Text("Items")) {
                ForEach(report.allowedItems) { item in
                    HStack {
                        // Check Mark Indicator
                        Image(systemName: selectedItems.contains(item.id) ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(selectedItems.contains(item.id) ? .blue : .secondary)
                        // Item Details
                        VStack (alignment: .leading, spacing: 4){
                            Text(item.name)
                                .font(.headline)
                            Text(item.nutrition)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        toggleSelection(for: item)
                    }
                }
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
    }
}

#Preview {
    ItemSelectionView(
        diet: .carbControl,
        allMenuItems: MenuItem.samples,
        mealTime: .lunch,
        onComplete: {
            _ in
        })
}
