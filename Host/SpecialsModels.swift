//
//  SpecialsModels.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 11/28/25.
//

import Foundation


struct Menu: Decodable {
    let meta: Meta
    let weeks: [Week]
}

struct Meta: Decodable {
    let cycle_length_weeks: Int   // 2
    let start_date: String        // "2024-01-01"
}

struct Week: Decodable, Identifiable {
    var id: UUID = UUID()
    let week_number: Int          // 1 or 2
    let days: [String: Day]       // "monday", "tuesday", ...
    
    private enum CodingKeys: String, CodingKey {
        case week_number
        case days
    }
}

struct Day: Decodable, Identifiable {
    var id: UUID = UUID()
    let meals: DayMeals
    
    private enum CodingKeys: String, CodingKey {
        case meals
    }
}

struct DayMeals: Decodable {
    let breakfast: [MealItem]
    let lunch: [MealItem]
    let dinner: [MealItem]
    
    
}

struct MealItem: Decodable, Identifiable {
    var id: UUID = UUID()
    let name: String
    let category: String
    
    private enum CodingKeys: String, CodingKey {
        case name
        case category
    }
}
