//
//  ItemTag.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 1/22/26.
//

import Foundation

/// Preference tags for menu items
enum ItemTag: String, CaseIterable, Codable, Hashable {
    case vegetarian = "Vegetarian"
    case vegan = "Vegan"
    case containsMeat = "Contains Meat"
    
    /// Display-friendly title
    var title: String {
        rawValue
    }
}
