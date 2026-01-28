//
//  Rule.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 1/28/26.
//

import Foundation

/// Protocol that all constraint rules must conform to
protocol Rule {
    /// Human-readable name of rule
    var name: String { get }
    
    /// Evaluate if a menu item saisfies this rule
    ///     - Parameter item: the menu item to evaluate
    ///     - Returns: RuleResult i.e. pass if item satisfies rule, fail with reason otherwise
    func evaluate(_ item: MenuItem) -> RuleResult
}

// Template for ALL numeric Medical Rules
//struct [RuleName]Rule: Rule {
//    let max[Attribute]: Int
//    var name: String { "[Display Name]" }
//    
//    func evaluate(_ item: MenuItem) -> RuleResult {
//        guard let value = item.attributes.[attribute] else {
//            return .pass
//        }
//        
//        if value <= max[Attribute] {
//            return .pass
//        } else {
//            return .fail(reason: "[Attribute] \(value)[unit] exceeds limit \(max[Attribute])[unit]")
//        }
//    }
//}
