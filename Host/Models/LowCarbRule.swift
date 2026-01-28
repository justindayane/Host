//
//  LowCarbRule.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 1/28/26.
//

import Foundation

/// Rule that enforces carbohydrates limits for carb control diet
struct LowCarbRule: Rule {
    /// Maximum allowed carb in grams
    let maxCarbs: Int
    
    /// Human-readable name
    var name: String {
        "Low Carb"
    }
    
    /// Evaluate if item's carb count is within limits
    func evaluate(_ item: MenuItem) -> RuleResult {
        // Check if the item has the carb data
        guard let carb = item.attributes.carbs else { return .pass } // Design choice: No data -> Safe
        
        if carb <= maxCarbs {
            return .pass
        } else {
            return .fail(reason: "Carbs \(carb)g exceeds limit of \(maxCarbs)g")
        }
    }
}
