//
//  ParsedTrayRequest.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 5/29/26.
//

import Foundation

struct ParsedTrayRequest {
    let rawText: String
    let mealTime: MealTime?
    let dishType: DishType?
    let diet: Diet?
}
