//
//  RuleFactory.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 1/28/26.
//

import Foundation

/// Factory that creates rule instances for given constraints - The Bridge  between constraints and rules
struct RuleFactory {
    /// Creates a Rule for a given constraint
    ///     - Parameter constraint: The constraint to create a rule for
    ///     - Returns: The  corresponding rule or nil if npt implemented yet
    
    static func rule(for constraint: Constraint) -> Rule? {
        // Compare by name
        switch constraint.name {
            // Medical constraints
        case "Low Sodium":
            return LowSodiumRule(maxSodium: 600)
        case "Low Carb":
            return LowCarbRule(maxCarbs: 30)
        case "Low Fat":
            return nil
        case "Low Potassium":
            return nil
        case "Fluid Restriction":
            return nil
        
            // Preference constraints
        case "Vegetarian":
            return VegetarianRule()
        case "Vegan":
            return nil
        case "Kosher":
            return nil
        case "Halal":
            return nil
        default:
            return nil
        
        }
    }
}
