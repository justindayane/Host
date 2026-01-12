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
    case regular
    case cardiac
    case renal
    case carbControl
    case carbControlCardiac
    case fluidRest
    case fiberRest
    
    
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
        case .carbControlCardiac:
            return "Carb Control & Cardiac"
        case .regular:
            return "Regular"
        }
    }
    
    static func == (lhs: Diet, rhs: Diet) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}

struct MenuItem: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var name: String
    var nutrition: String
    var mealTimes: [MealTime]
    var dishType: DishType
    var isSpecial: Bool = false
    var diets: [Diet] = [] // diets that are allowed to eat this item
    
}

struct Tray: Identifiable, Codable {
    let id: UUID
    let diet: Diet
    var mealTime: MealTime // New due to each tray serving one meal
    var items: [MenuItem]
    let createdAt: Date
    
    var itemCount: Int {
        items.count
    }
    var isEmpty: Bool {
        items.isEmpty
    }
    var displayName: String {
        "\(diet.title) Tray - \(mealTime.rawValue.capitalized)"
    }
    
    init(diet: Diet, time: MealTime, items: [MenuItem] = [], createdAt: Date = Date()) { // Setting Breakfast as default for now. Because I don't want to go find every tray object and fix it yet
        self.id = UUID()
        self.diet = diet
        self.items = items
        self.mealTime = time
        self.createdAt = createdAt
    }
}

extension MenuItem {
    static var samples: [MenuItem] {
        [
            // BREAKFAST - Regular (all diets)
            MenuItem(
                name: "Scrambled Eggs",
                nutrition: "180 kcal",
                mealTimes: [.breakfast],
                dishType: .main
            ),
            MenuItem(
                name: "Whole Wheat Toast",
                nutrition: "140 kcal",
                mealTimes: [.breakfast],
                dishType: .side
            ),
            MenuItem(
                name: "Fresh Fruit Cup",
                nutrition: "80 kcal",
                mealTimes: [.breakfast],
                dishType: .side
            ),
            MenuItem(
                name: "Coffee",
                nutrition: "5 kcal",
                mealTimes: [.breakfast],
                dishType: .beverage
            ),
            
            // BREAKFAST - Diet-specific
            MenuItem(
                name: "Oatmeal with Berries",
                nutrition: "220 kcal",
                mealTimes: [.breakfast],
                dishType: .main,
                isSpecial: true,
                diets: [.cardiac, .carbControl]
            ),
            MenuItem(
                name: "Egg White Omelette",
                nutrition: "120 kcal",
                mealTimes: [.breakfast],
                dishType: .main,
                isSpecial: true,
                diets: [.cardiac, .renal]
            ),
            
            // LUNCH - Regular
            MenuItem(
                name: "Turkey Sandwich",
                nutrition: "380 kcal",
                mealTimes: [.lunch],
                dishType: .main
            ),
            MenuItem(
                name: "Garden Salad",
                nutrition: "90 kcal",
                mealTimes: [.lunch],
                dishType: .side
            ),
            MenuItem(
                name: "Apple Slices",
                nutrition: "60 kcal",
                mealTimes: [.lunch],
                dishType: .side
            ),
            
            // LUNCH - Diet-specific
            MenuItem(
                name: "Grilled Chicken Breast (Unseasoned)",
                nutrition: "165 kcal",
                mealTimes: [.lunch, .dinner],
                dishType: .main,
                isSpecial: true,
                diets: [.cardiac, .renal, .fluidRest]
            ),
            MenuItem(
                name: "Steamed Vegetables",
                nutrition: "50 kcal",
                mealTimes: [.lunch, .dinner],
                dishType: .side,
                isSpecial: true,
                diets: [.cardiac, .renal]
            ),
            MenuItem(
                name: "Quinoa Bowl",
                nutrition: "220 kcal",
                mealTimes: [.lunch, .dinner],
                dishType: .main,
                isSpecial: true,
                diets: [.carbControl, .fiberRest]
            ),
            
            // DINNER - Regular
            MenuItem(
                name: "Baked Chicken",
                nutrition: "280 kcal",
                mealTimes: [.dinner],
                dishType: .main
            ),
            MenuItem(
                name: "Mashed Potatoes",
                nutrition: "210 kcal",
                mealTimes: [.dinner],
                dishType: .side
            ),
            MenuItem(
                name: "Green Beans",
                nutrition: "45 kcal",
                mealTimes: [.dinner],
                dishType: .side
            ),
            
            // DINNER - Diet-specific
            MenuItem(
                name: "Baked Salmon (Low Sodium)",
                nutrition: "280 kcal",
                mealTimes: [.dinner],
                dishType: .main,
                isSpecial: true,
                diets: [.cardiac, .renal]
            ),
            MenuItem(
                name: "Brown Rice",
                nutrition: "215 kcal",
                mealTimes: [.lunch, .dinner],
                dishType: .side,
                isSpecial: true,
                diets: [.carbControl, .fiberRest]
            ),
            
            // BEVERAGES - Available anytime
            MenuItem(
                name: "Water",
                nutrition: "0 kcal",
                mealTimes: [.breakfast, .lunch, .dinner],
                dishType: .beverage
            ),
            MenuItem(
                name: "Decaf Coffee",
                nutrition: "5 kcal",
                mealTimes: [.breakfast, .lunch, .dinner],
                dishType: .beverage
            ),
            MenuItem(
                name: "Cranberry Juice (Low Sugar)",
                nutrition: "50 kcal",
                mealTimes: [.breakfast, .lunch, .dinner],
                dishType: .beverage,
                isSpecial: true,
                diets: [.cardiac, .renal]
            )
        ]
    }
}

extension Diet {
    var kitColor: Color {
        switch self {
        case .regular:
            return Color(red: 0.2, green: 0.5, blue: 0.9)
        case .carbControl:
            return Color(red: 1.0, green: 0.85, blue: 0.1)
        case .renal, .cardiac:
            return Color(red: 0.5, green: 0.5, blue: 0.5)
        case .carbControlCardiac:
            return Color(red: 1.0, green: 0.6, blue: 0.0)
        default:
            return .green
        }
    }
    
    var lightKitColor: Color {
        kitColor.opacity(0.15)
    }
    
    var darkKitColor: Color {
        kitColor.opacity(0.8)
    }
}

extension Tray {
    static var samples: [Tray] {
        let twoHoursAgo = Date().addingTimeInterval(-2 * 60 * 60)
        let yesterday = Date().addingTimeInterval(-24 * 60 * 60)
        
        return [
            Tray(
                diet: .carbControl,
                time: .breakfast,
                items: [
                    MenuItem(
                        name: "Avena",
                        nutrition: "Some facts",
                        mealTimes: [.breakfast],
                        dishType: .side,
                        diets: [
                            .carbControl,
                            .cardiac
                        ]
                    ),
                    MenuItem(
                        name: "Quinoa",
                        nutrition: "Some other facts",
                        mealTimes: [.breakfast],
                        dishType: .side,
                        diets: [.carbControl]
                    ),
                    MenuItem(
                        name: "Bagel",
                        nutrition: "So many facts",
                        mealTimes: [.lunch],
                        dishType: .main,
                        diets: [.carbControl]
                    ),
                ], createdAt: yesterday
            ),
            Tray(
                diet: .renal,
                time: .lunch,
                items: [
                    MenuItem(
                        name: "Garden Salad",
                        nutrition: "here we go again with the facts",
                        mealTimes: [.breakfast],
                        dishType: .main,
                        diets: [.renal]
                    )
                ]
            ),
            Tray(
                diet: .regular,
                time: .dinner,
                items: [
                    MenuItem(
                        name: "String Beans",
                        nutrition: "here we go again with the facts",
                        mealTimes: [.dinner],
                        dishType: .main,
                        diets: []
                    ),
                    MenuItem(
                        name: "Mashed Potatoes",
                        nutrition: "here we go again with the facts",
                        mealTimes: [.dinner],
                        dishType: .main,
                        diets: []
                    ),
                    MenuItem(
                        name: "Chicken Breast",
                        nutrition: "here we go again with the facts",
                        mealTimes: [.dinner],
                        dishType: .main,
                        diets: []
                    )
                ],
                createdAt: twoHoursAgo
            )
        ]
    }
}

struct AppTheme {
    static let cardCornerRadius: CGFloat = 14
    static let cardShadowRadius: CGFloat = 3
    static let cardPadding: CGFloat = 12
    static let sectionSpacing: CGFloat = 22
    static let gridSpacing: CGFloat = 14
    static let horizontalPadding: CGFloat = 16
}
