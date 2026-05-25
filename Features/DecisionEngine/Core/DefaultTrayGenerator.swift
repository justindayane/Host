//
//  DefaultTrayGenerator.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 4/7/26.
//

import Foundation

struct DefaultTrayGenerator {
    static var defaultComposition: [CategoryRequirement] {
        [
            CategoryRequirement(category: .main, quantity: 1),
            CategoryRequirement(category: .side, quantity: 1),
            CategoryRequirement(category: .beverage, quantity: 1)
        ]
    }
    
    static func generate(from allMenuItems: [MenuItem], for tray: Tray) -> GeneratedTray {
        let requiredComposition = defaultComposition
        var selectedItems: [MenuItem] = []
        var traces: [CategoryTrace] = []
        
        
        for requirement in requiredComposition {
            let result = selectItem(for: requirement, from: allMenuItems, tray: tray)
            if let selectedItem = result.selectedItem {
                selectedItems.append(selectedItem)
            }
            traces.append(result.trace)
        }
        
        // Build tray
        let newTray = Tray(diet: tray.diet, time: tray.mealTime, items: selectedItems, extraConstraints: tray.extraConstraints)
        
        return GeneratedTray(tray: newTray, requiredComposition: requiredComposition, traces: traces)
    }
    
    // Helper function
    private static func selectItem(for requirement: CategoryRequirement, from allMenuItems: [MenuItem], tray: Tray) -> (selectedItem: MenuItem?, trace: CategoryTrace) {
        // 1. filter by mealTime and dishType
        let filteredItems = allMenuItems.filter { item in
            item.mealTimes.contains(tray.mealTime) && item.dishType == (requirement.category)
        }
        // 2. evaluate with RulesEngine
        let report = RulesEngine.evaluate(filteredItems, diet: tray.diet, mealTime: tray.mealTime, extraConstraints: tray.extraConstraints)
        
        // 3. keep allowed items
        let allowedItems = report.allowedItems
        
        // 4. sort deterministically
        let sortedItems = allowedItems.sorted { lhs, rhs in
            // Compare Sodium first -> Then Carbs -> Then Tie-Break
            if lhs.attributes.sodium != rhs.attributes.sodium {
                return (lhs.attributes.sodium ?? Int.max) < (rhs.attributes.sodium ?? Int.max)
            }
            else {
                if lhs.attributes.carbs != rhs.attributes.carbs {
                    return (lhs.attributes.carbs ?? Int.max) < (rhs.attributes.carbs ?? Int.max) // Missing attribute is considered as 0 for now. vs commonly used approach of taking missing value for large value int.Max
                }
                else {
                    return lhs.id.uuidString < rhs.id.uuidString
                }
            }
        }
        
        // 5. select first
        let selectedItem = sortedItems.first
        
        // 6. build trace
        let candidateItemsIDs = filteredItems.map { $0.id }
        
        // The reason should be based on the shapr of the candidate pool
        // Either "No items after initial constraint filtering" or "No allowed Item after rule engine eval" or "Single Item after eval" or "Multiple Items after eval and then 1 selected"
        let reason: String
        if filteredItems.isEmpty {
            reason = "No category candidates existed for this meal time and dish type"
        }
        else if allowedItems.isEmpty {
            reason = "Candidates existed for this meal time and dish type but none pass the constraints"
        }
        else if allowedItems.count == 1 {
            reason = "Only one allowed candidate existed"
        }
        else {
            reason = "There were multiple allowed candidates; the heuristic selected the best one"
        }
        
        let trace = CategoryTrace(category: requirement.category, candidateItemsIDs: candidateItemsIDs, selectedItemID: selectedItem?.id, reason: reason)
        // 7. return tuple
        return (selectedItem, trace)
    }
}


