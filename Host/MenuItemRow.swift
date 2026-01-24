//
//  MenuItemRow.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 1/24/26.
//

import SwiftUI

// This could be reused both for ItemSelectionView and TrayDetailView (Even though the TrayDetailView version should not allow tap)
struct MenuItemRow: View {
    let item: MenuItem
    let isSelected: Bool // Will always be false at call from TrayDetailView because we are not supposed to be cheking or unchecking there
    let onTap: () -> Void //(leave empty {} at call time when you don't want any action performed when tapped
    
    var body: some View {
        HStack {
            // Checkmark Indicator
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(isSelected ? .blue : .secondary)
            
            // Item Details
            VStack (alignment: .leading, spacing: 4){
                Text(item.name)
                    .font(.headline)
                
                VStack(alignment: .leading, spacing: 2) {
                    // Show Sodium count if present
                    if let sodium = item.attributes.sodium {
                        Text("Sodium: \(sodium)mg")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    // Show Carb count if any
                    if let carb = item.attributes.carbs {
                        Text("Carbs: \(carb)g")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    // Show Fluid if present
                    if let fluid = item.attributes.fluid {
                        Text("Fluid: \(fluid)ml")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    // Show tags if any
                    if !item.tags.isEmpty {
                        Text(item.tags.map {$0.title}.joined(separator: ", "))
                            .font(.caption)
                            .foregroundStyle(.blue)
                    }
                }
                
            }
            
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }
    
}
