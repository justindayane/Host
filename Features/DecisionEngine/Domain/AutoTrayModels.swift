//
//  AutoTrayModels.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 4/7/26.
//

import Foundation

struct CategoryRequirement {
    var category: DishType
    var quantity: Int
}

struct CategoryTrace: Hashable {
    var category: DishType
    var candidateItemsIDs: [UUID]
    var selectedItemID: UUID?
    var reason: String
}

struct GeneratedTray : Identifiable {
    let id = UUID()
    let tray: Tray
    let requiredComposition: [CategoryRequirement]
    let traces: [CategoryTrace]
    
    var isComplete: Bool {
        // For each required category, does the tray contain at least quantity items whose dishType matches that category?
        for requirement in requiredComposition {
            let categoryCount = tray.items.filter {
                $0.dishType == requirement.category
            }.count
            if categoryCount < requirement.quantity {
                return false
            }
        }
        
        return true
    }
}
