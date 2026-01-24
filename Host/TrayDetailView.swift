//
//  TrayDetailView.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 12/26/25.
//

import SwiftUI

struct TrayDetailView: View {
    @Binding var tray: Tray // Unsure how to make preview work after this change
    
    
    var body: some View {
            List {
                // Header Section
                // consider making this match the color of the diet kit of the tray
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            DietKitIndicator(diet: tray.diet, size: 20)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("\(tray.displayName)")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Text("Diet Kit")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        Divider()
                        
                        HStack {
                            Text("Items:")
                                .foregroundStyle(.secondary)
                            Text("\(tray.itemCount)")
                                .fontWeight(.bold)
                        }
                    }
                }
                .listRowBackground(tray.diet.lightKitColor)
                
                // items will go here
                if tray.isEmpty {
                    Section {
                        ContentUnavailableView (
                            "No Item Yet",
                            systemImage: "tray",
                            description: Text("This tray doesn't have any item yet.")
                        )
                    }
                }
                else {
                    
                        
                            Section(header: Text("Items")) {
                                ForEach(
                                    tray.items
                                ) { item in
                                    // Use the Display only version of MenuItemRow
                                    MenuItemRow(
                                        item: item,
                                        isSelected: false, // Never Selected, No checkmark
                                        onTap: {
                                        }) // No Action on Tap.
                                }
                                .onDelete(perform: deleteItems)
                            }
                        
                    
                }
                
            }
            .navigationTitle(tray.displayName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        ItemSelectionView(diet: tray.diet, allMenuItems: MenuItem.samples, mealTime: tray.mealTime) { selectedItemsFromChild in
                            tray.items.append(contentsOf: selectedItemsFromChild)
                        }
                    } label: {
                        Label("Add items", systemImage: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
    }
    
    private func deleteItems(at offset: IndexSet) {
        tray.items.remove(atOffsets: offset)
    }
}

//#Preview("Tray with Items") {
//    NavigationStack {
//        TrayDetailView(tray: .constant(
//            Tray(
//                diet: .cardiac,
//                time: .lunch,
//                items: [
//                    MenuItem(
//                        name: "Oatmeal",
//                        attribute: .glutenFree,
//                        mealTimes: [.breakfast],
//                        dishType: .main
//                    )
//                ]
//            )
//        ))
//    }
//}

#Preview("Empty Tray") {
    NavigationStack {
        TrayDetailView(tray: .constant(
            Tray(diet: .renal, time: .lunch, items: [])
        ))
    }
}
