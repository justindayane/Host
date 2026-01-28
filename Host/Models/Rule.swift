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
