//
//  Person.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 10/16/25.
//

import SwiftUI

// ---------- NEW IMPLEMENTATION --------

enum DishType: String, Codable, CaseIterable, Identifiable {
    case main
    case side
    case beverage
    
    var id: Self { self }
}

enum MealTime: String, Codable, CaseIterable, Identifiable {
    case breakfast
    case lunch
    case dinner
    var id: Self { self }
}

enum Diet: String, Codable, CaseIterable, Identifiable {
    case cardiac
    case renal
    case carbControl
    case fluidRest
    case fiberRest
    case regular
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .carbControl:
            return "Carb Control"
        case .renal:
            return "Renal"
        case .cardiac:
            return "Cardiac"
        case .fluidRest:
            return "Fluid Rest"
        case .fiberRest:
            return "Fiber Rest"
        case .regular:
            return "Regular"
        }
    }
    
    static func == (lhs: Diet, rhs: Diet) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}

struct MenuItem: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var nutrition: String
    var mealTime: [MealTime]
    var dishType: DishType
    var isSpecial: Bool = false
    var diet: [Diet] = []
    
    // The idea is to have this computed property help identify meals that apply to all diet but the approach is not accurate yet. It will require looking into the entire "Diet" Logic.
//    var appliesToAllDiets: Bool {
//        return diet.isEmpty
//    }
}

struct AppTheme {
    static let cardCornerRadius: CGFloat = 14
    static let cardShadowRadius: CGFloat = 3
    static let cardPadding: CGFloat = 12
    static let sectionSpacing: CGFloat = 22
    static let gridSpacing: CGFloat = 14
    static let horizontalPadding: CGFloat = 16
}
