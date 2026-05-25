//
//  SpecialsModels.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 11/28/25.
//

import Foundation


struct DailySpecialMenu: Decodable {
    let meta: DailySpecialMeta
    let weeks: [DailySpecialWeek]
}

struct DailySpecialMeta: Decodable {
    let cycle_length_weeks: Int   // 2
    let start_date: String        // "2024-01-01"
}

struct DailySpecialWeek: Decodable, Identifiable {
    var id: UUID = UUID()
    let week_number: Int          // 1 or 2
    let days: [String: DailySpecialDay]       // "monday", "tuesday", ...
    
    private enum CodingKeys: String, CodingKey {
        case week_number
        case days
    }
}

struct DailySpecialDay: Decodable, Identifiable {
    var id: UUID = UUID()
    let meals: DailySpecialMeals
    
    private enum CodingKeys: String, CodingKey {
        case meals
    }
}

struct DailySpecialMeals: Decodable {
    let breakfast: [DailySpecialItem]
    let lunch: [DailySpecialItem]
    let dinner: [DailySpecialItem]
    
    
}

struct DailySpecialItem: Decodable, Identifiable {
    var id: UUID = UUID()
    let name: String
    let category: String
    
    private enum CodingKeys: String, CodingKey {
        case name
        case category
    }
}

// New Approach
struct CycleDay {
    let day: Int
    let breakfast: [CycleMenuItem]
    let lunch: [CycleMenuItem]
    let dinner: [CycleMenuItem]
}

struct CycleMenuItem {
//    let id: UUID = UUID()
    let name: String
}

struct CycleMenu {
    let anchor: String
    let days: [CycleDay]
}
