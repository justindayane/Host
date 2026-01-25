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
    let id: UUID
    let name: String
    let mealTimes: [MealTime]
    let dishType: DishType
    let attributes: NutritionAttributes
    let tags: [ItemTag]
    let isSpecial: Bool
    let diets: [Diet]  // diets that are allowed to eat this item
    
    init(id: UUID = UUID(), name: String,  mealTimes: [MealTime], dishType: DishType, diets: [Diet] = [], attributes: NutritionAttributes = .none, tags: [ItemTag] = [], isSpecial: Bool = false) {
        self.id = id
        self.name = name
        self.mealTimes = mealTimes
        self.dishType = dishType
        self.diets = diets
        self.attributes = attributes
        self.tags = tags
        self.isSpecial = isSpecial
    }
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
                mealTimes: [.breakfast],
                dishType: .main,
                attributes: NutritionAttributes(
                    sodium: 380,   // Moderate sodium
                    carbs: 2,      // Low carb
                    fluid: nil
                ),
                tags: [.vegetarian]
            ),
            MenuItem(
                name: "Whole Wheat Toast",
                
                mealTimes: [.breakfast],
                dishType: .side,
                
                diets: [
                    .cardiac,
                    .carbControl
                ],
                attributes: NutritionAttributes(
                    sodium: 120,
                    carbs: 15,
                    fluid: nil
                ),
                tags: [
                    .vegetarian,
                    .vegan
                ]
            ),
            // Cardiac-friendly breakfast
            MenuItem(
                name: "Oatmeal",
                mealTimes: [.breakfast],
                dishType: .main,
                diets: [.cardiac],
                attributes: NutritionAttributes(
                    sodium: 150,
                    // Low sodium
                    carbs: 27,
                    // Moderate carbs
                    fluid: nil
                ),
                tags: [
                    .vegetarian,
                    .vegan
                ]
            ),
            MenuItem(
                name: "Coffee",
                mealTimes: [.breakfast],
                dishType: .beverage,
                attributes: NutritionAttributes(sodium: nil, carbs: nil, fluid: 240)
            ),
            
            // BREAKFAST - Diet-specific
            MenuItem(
                name: "Oatmeal with Berries",
                mealTimes: [.breakfast],
                dishType: .main,
                diets: [.cardiac, .carbControl],
                attributes: NutritionAttributes(sodium: 5, carbs: 35, fluid: 180)
            ),
            MenuItem(
                name: "Egg White Omelette",
                mealTimes: [.breakfast],
                dishType: .main,
                diets: [.cardiac, .renal],
                attributes: NutritionAttributes(sodium: 300, carbs: 2, fluid: nil)
            ),
            
            // LUNCH - Regular
            MenuItem(
                name: "Turkey Sandwich",
                mealTimes: [.lunch],
                dishType: .main,
                attributes: NutritionAttributes(sodium: 900, carbs: 30, fluid: nil)
            ),
            MenuItem(
                name: "Garden Salad",
                mealTimes: [.lunch, .dinner],
                dishType: .side,
                diets: [],  // Universal
                attributes: NutritionAttributes(
                    sodium: 45,    // Very low sodium
                    carbs: 8,      // Low carbs
                    fluid: nil
                ),
                tags: [.vegetarian, .vegan]
            ),
                        
            MenuItem(
                name: "Apple Slices",
                mealTimes: [.lunch],
                dishType: .side,
                attributes: NutritionAttributes(sodium: nil, carbs: 15, fluid: 100)
            ),
            
            // LUNCH - Diet-specific
            MenuItem(
                name: "Grilled Chicken Breast (Unseasoned)",
                mealTimes: [.lunch, .dinner],
                dishType: .main,
                diets: [.cardiac, .renal, .fluidRest],
                attributes: NutritionAttributes(sodium: 70, carbs: nil, fluid: nil),
                tags: [.containsMeat]
            ),
            MenuItem(
                name: "Steamed Vegetables",
                mealTimes: [.lunch, .dinner],
                dishType: .side,
                diets: [.cardiac, .renal],
                attributes: NutritionAttributes(sodium: 40, carbs: 12, fluid: 120),
                tags: [.vegetarian, .vegan]
            ),
            MenuItem(
                name: "Quinoa Bowl",
                mealTimes: [.lunch, .dinner],
                dishType: .main,
                diets: [.carbControl, .fiberRest],
                attributes: NutritionAttributes(sodium: 200, carbs: 40, fluid: nil)
            ),
            
            // DINNER - Regular
            MenuItem(
                name: "Baked Chicken",
                mealTimes: [.dinner],
                dishType: .main,
                attributes: NutritionAttributes(sodium: 200, carbs: 40, fluid: nil)
            ),
            MenuItem(
                name: "Mashed Potatoes",
                mealTimes: [.dinner],
                dishType: .side,
                attributes: NutritionAttributes(sodium: 250, carbs: nil, fluid: nil)
            ),
            MenuItem(
                name: "Green Beans",
                mealTimes: [.dinner],
                dishType: .side,
                attributes: NutritionAttributes(sodium: 10, carbs: 8, fluid: 80)
            ),
            
            // DINNER - Diet-specific
            MenuItem(
                name: "Baked Salmon (Low Sodium)",
                mealTimes: [.dinner],
                dishType: .main,
                diets: [.cardiac, .renal],
                attributes: NutritionAttributes(sodium: 120, carbs: nil, fluid: nil)
            ),
            MenuItem(
                name: "Baked Salmon",
                mealTimes: [.dinner],
                dishType: .main,
                diets: [.cardiac, .renal],
                attributes: NutritionAttributes(
                    sodium: 320,
                    carbs: 0,
                    fluid: nil
                ),
                tags: [.containsMeat]
            ),
            
            MenuItem(
                name: "Steamed Broccoli",
                mealTimes: [.lunch, .dinner],
                dishType: .side,
                diets: [],  // Universal
                attributes: NutritionAttributes(
                    sodium: 30,
                    carbs: 7,
                    fluid: nil
                ),
                tags: [.vegetarian, .vegan]
            ),
            MenuItem(
                name: "Brown Rice",
                mealTimes: [.lunch, .dinner],
                dishType: .side,
                diets: [.carbControl],
                attributes: NutritionAttributes(
                    sodium: 5,     // Very low sodium
                    carbs: 23,     // Moderate carbs
                    fluid: nil
                ),
                tags: [.vegetarian, .vegan]
            ),
            
            // BEVERAGES - Available anytime
            MenuItem(
                name: "Water",
                mealTimes: [.breakfast, .lunch, .dinner],
                dishType: .beverage,
                diets: [],  // Universal
                attributes: NutritionAttributes(
                    sodium: 0,
                    carbs: 0,
                    fluid: 250     // 250ml
                ),
                tags: [.vegetarian, .vegan]
            ),
            MenuItem(
                name: "Decaf Coffee",
                mealTimes: [.breakfast, .lunch, .dinner],
                dishType: .beverage,
                attributes: NutritionAttributes(sodium: nil, carbs: nil, fluid: 240)
            ),
            MenuItem(
                name: "Cranberry Juice (Low Sugar)",
                mealTimes: [.breakfast, .lunch, .dinner],
                dishType: .beverage,
                diets: [.cardiac, .renal],
                attributes: NutritionAttributes(sodium: 10, carbs: 15, fluid: 240)
            ),
            MenuItem(
                name: "Low-Fat Milk",
                mealTimes: [.breakfast, .lunch, .dinner],
                dishType: .beverage,
                diets: [.cardiac],
                attributes: NutritionAttributes(
                    sodium: 100,
                    carbs: 12,
                    fluid: 240
                ),
                tags: [.vegetarian]
            ),
            MenuItem(
                name: "Orange Juice",
                mealTimes: [.breakfast],
                dishType: .beverage,
                diets: [.regular],
                attributes: NutritionAttributes(
                    sodium: 5,
                    carbs: 26,     // High sugar/carbs
                    fluid: 240
                ),
                tags: [.vegetarian, .vegan]
            ),
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
    
    /// The contraints that define this diet
    var constraints: [Constraint] {
        switch self {
        case .regular:
            return [] // No constraint
        case .cardiac:
            return [
                .lowSodium,
                .lowFat
            ]
        case .renal:
            return [
                .lowSodium,
                .lowPotassium,
                .fluidRestriction
            ]
        case .carbControl:
            return [
                .lowCarb
            ]
        case .carbControlCardiac:
            return [
                .lowFat,
                .lowSodium,
                .lowCarb
            ]
        case .fluidRest:
            return [
                .fluidRestriction
            ]
        case .fiberRest:
            return [
                // To be defined
            ]
        }
    }
    
    /// Whether this diet has any medical restrictions/constraints at all
    var hasMedicalRestrictions: Bool {
        constraints.contains {
            $0.type == .medical
        }
    }
    
    /// All medical constraints for this diet
    var medicalConstraints: [Constraint] {
        constraints.filter {
            $0.type == .medical
        }
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
                        mealTimes: [.breakfast],
                        dishType: .side,
                        diets: [
                            .carbControl,
                            .cardiac
                        ]
                    ),
                    MenuItem(
                        name: "Whole Wheat Toast",
                        
                        mealTimes: [.breakfast],
                        dishType: .side,
                        
                        diets: [
                            .cardiac,
                            .carbControl
                        ],
                        attributes: NutritionAttributes(
                            sodium: 120,
                            carbs: 15,
                            fluid: nil
                        ),
                        tags: [
                            .vegetarian,
                            .vegan
                        ]
                    ),
                    MenuItem(
                        name: "Quinoa",
                        mealTimes: [.breakfast],
                        dishType: .side,
                        diets: [.carbControl]
                    ),
                    MenuItem(
                        name: "Bagel",
                        mealTimes: [.lunch],
                        dishType: .main,
                        diets: [.carbControl],
                        attributes: NutritionAttributes(sodium: nil, carbs: nil, fluid: 240)
                    )
                ], createdAt: yesterday
            ),
            Tray(
                diet: .renal,
                time: .lunch,
                items: [
                    MenuItem(
                        name: "Garden Salad",
                        mealTimes: [.breakfast],
                        dishType: .main,
                        diets: [.renal],
                        attributes: NutritionAttributes(sodium: nil, carbs: nil, fluid: 240)
                    ),
                    MenuItem(
                        name: "Whole Wheat Toast",
                        
                        mealTimes: [.breakfast],
                        dishType: .side,
                        
                        diets: [
                            .cardiac,
                            .carbControl
                        ],
                        attributes: NutritionAttributes(
                            sodium: 120,
                            carbs: 15,
                            fluid: nil
                        ),
                        tags: [
                            .vegetarian,
                            .vegan
                        ]
                    ),
                ]
            ),
            Tray(
                diet: .regular,
                time: .dinner,
                items: [
                    MenuItem(
                        name: "Whole Wheat Toast",
                        
                        mealTimes: [.breakfast],
                        dishType: .side,
                        
                        diets: [
                            .cardiac,
                            .carbControl
                        ],
                        attributes: NutritionAttributes(
                            sodium: 120,
                            carbs: 15,
                            fluid: nil
                        ),
                        tags: [
                            .vegetarian,
                            .vegan
                        ]
                    ),
                    MenuItem(
                        name: "Mashed Potatoes",
                        mealTimes: [.dinner],
                        dishType: .main,
                        diets: []
                    ),
                    MenuItem(
                        name: "Chicken Breast",
                        mealTimes: [.dinner],
                        dishType: .main,
                        diets: [],
                        attributes: NutritionAttributes(sodium: nil, carbs: nil, fluid: 240)
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
