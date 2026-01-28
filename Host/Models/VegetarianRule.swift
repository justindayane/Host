//
//  VegetarianRule.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 1/28/26.
//

import Foundation

/// Rule that ensure items are suitable for vegetarian diet
struct VegetarianRule: Rule {
    /// Human-readable name
    var name: String { "Vegetarian" }
    
    /// Evaluate if item is vegetarian-friendly
    func evaluate(_ item: MenuItem) -> RuleResult {
        // Vegetarian items do not contain any meat
        if item.tags.contains(.containsMeat) {
            return .fail(reason: "Item contains meat")
        } else {
            return .pass
        }
    }
}
