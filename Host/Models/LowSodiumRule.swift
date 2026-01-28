//
//  LowSodiumRule.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 1/28/26.
//

import Foundation

/// Rule that enforces sodium limits for medical diets (Renal, Cardiac)
struct LowSodiumRule: Rule {
    /// Maximum allowed sodium in milligrams
    let maxSodium: Int
    
    /// Human-readable name
    var name: String { "Low Sodium" }
    
    /// Evaluate if sodium content of the menu item is within the limit
    func evaluate(_ item: MenuItem) -> RuleResult {
        // Step 1: Check if we even have sodium count of the item
        guard let sodium = item.attributes.sodium else { return .pass } // No sodium count -> Safe (design choice)
        
        if sodium <= maxSodium {
            return .pass
        } else {
            // Failed -> Explain with specific numbers
            return .fail(reason: "Sodium \(sodium)mg exceeds sodium limit of \(maxSodium)mg")
        }
        
    }
}
