//
//  Constraint.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 1/24/26.
//

import Foundation

struct Constraint: Identifiable, Hashable, Codable {
    let id: UUID
    let name: String
    let type: ConstraintType
    
    init(id: UUID = UUID(), name: String, type: ConstraintType) {
        self.id = id
        self.name = name
        self.type = type
    }
}

// MARK: - Common constraints

extension Constraint {
    // Some medical constraints
    static let lowSodium = Constraint(name: "Low Sodium", type: ConstraintType.medical)
    static let lowCarb = Constraint(name: "Low Carb", type: .medical)
    static let lowFat = Constraint(name: "Low Fat", type: .medical)
    static let lowPotassium = Constraint(name: "Low Potassium", type: .medical)
    static let fluidRestriction = Constraint(name: "Fluid Restriction", type: .medical)
    
    // Some preference constraints
    static let kosher = Constraint(name: "Kosher", type: .preference)
    static let halal = Constraint(name: "Halal", type: .preference)
    static let vegetarian = Constraint(name: "Vegetarian", type: .preference)
    static let vegan = Constraint(name: "Vegan", type: .preference)
}
