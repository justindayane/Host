//
//  ItemExplanationView.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 2/12/26.
//

import SwiftUI

struct ItemExplanationView: View {
    let evaluation: ItemEvaluation
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                // Section 1: Status
                Section("Status") {
                    HStack {
                        // Status Icon
                        Image(systemName: evaluation.isAllowed ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundStyle(evaluation.isAllowed ? .green : .red)
                            .font(.title2)
                        
                        // Status Text
                        Text(evaluation.isAllowed ? "Allowed" : "Blocked")
                            .font(.headline)
                            .foregroundStyle(evaluation.isAllowed ? .green : .red)
                    }
                    .padding(.vertical, 4)
                }
                
                // Section 2: Reasons, if blocked
                if !evaluation.isAllowed {
                    Section("Reasons") {
                        if evaluation.failedRules.isEmpty {
                            Text("Item is blocked (No Specific Reasons Provided)")
                                .foregroundStyle(.secondary)
                                .italic()
                        } else {
                            ForEach(evaluation.failedRules, id: \.self) { reason in
                                Label {
                                    Text(reason)
                                        .font(.body)
                                } icon: {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundStyle(.orange)
                                }
                            }
                        }
                    }
                }
                
                // Section 3: Item Details
                Section("Item Details") {
                    if let sodium = evaluation.item.attributes.sodium {
                        HStack {
                            Text("Sodium:")
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text("\(sodium) mg")
                        }
                    }
                    
                    if let carbs = evaluation.item.attributes.carbs {
                        HStack {
                            Text("Carbs:")
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text("\(carbs) g")
                        }
                    }
                    
                    if let fluid = evaluation.item.attributes.fluid {
                        HStack {
                            Text("Fluid:")
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text("\(fluid) mL")
                        }
                    }
                    
                    if !evaluation.item.tags.isEmpty {
                        HStack {
                            Text("Tags")
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text(evaluation.item.tags.map { $0.title }.joined(separator: ", "))
                        }
                    }
                }
            }
            .navigationTitle(evaluation.item.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    let previewEvaluation: ItemEvaluation = .init(item: MenuItem(name: "Test Item", mealTimes: [.dinner], dishType: .main, attributes: NutritionAttributes(sodium: 23, carbs: 30, fluid: 20), tags: [.vegan, .vegetarian]), isAllowed: false, failedRules: ["Test Rule Failure", "Another Test Rule Failure"])
    ItemExplanationView(evaluation: previewEvaluation)
}
