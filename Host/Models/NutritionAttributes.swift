//
//  NutritionAttributes.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 1/22/26.
//

import Foundation

/// Structured nutrition content for rule evaluation - This is grouping all the nutrient into one struct
struct NutritionAttributes: Codable, Hashable {
    /// Sodium content in milligrams
    let sodium: Int?
    
    /// Carbohydrates  content in grams
    let carbs: Int?
    
    /// Fluid volume in milliliters
    let fluid: Int?
    
    // Potassium, fat and other nutrients to be added as needed later
    
    /// Creates nutrition attributes with all values optional
    /// - Parameters:
    ///     - sodium: Sodium in mg (nil if unknown or not applicable)
    ///     - carbs: Carbs in grams (nil if unknown or not applicable)
    ///     - fluids: Fluid volume in ml (nill if unknow or not applicable)
    
    init(sodium: Int? = nil, carbs: Int? = nil, fluid: Int? = nil) {
        self.sodium = sodium
        self.carbs = carbs
        self.fluid = fluid
    }
}

// MARK: - Convenience Helpers
extension NutritionAttributes {
    /// Empty attributes (all nil) - for items where nutrition is not tracked
    static let none = NutritionAttributes()
    
    /// Low sodium preset to quickly create an sodium focus attribute
    static func lowSodium(_ amount: Int) -> NutritionAttributes {
        NutritionAttributes(sodium: amount)
    }
    
    /// Low carb preset to quickly create a carb focus attribute
    static func lowCarb(_ amount: Int) -> NutritionAttributes {
        NutritionAttributes(carbs: amount)
    }
    
}
