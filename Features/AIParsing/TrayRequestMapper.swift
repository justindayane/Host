//
//  TrayRequestMapper.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 5/31/26.
//

import Foundation

// Sits between TrayRequestExtraction and ParsedTrayRequest and does the mapping
struct TrayRequestMapper {
    func map(extraction: TrayRequestExtraction, rawText: String) -> ParsedTrayRequest {
        
        var mealTime: MealTime?
//        var dishType: DishType?
        var diet: Diet?
        
        // 1. Try to map mealTimeText to a MealTime
        if let mealTimeText = extraction.mealTimeText {
            mealTime = MealTime(rawValue: mealTimeText.lowercased())
        }
        
//        // 2. Try to map dishTypeText to a DishType
//        if let dishTypeText = extraction.dishTypeText {
//            dishType = DishType(rawValue: dishTypeText.lowercased())
//        }
        
        // 3. Try to map dietText to a Diet
        if let dietText = extraction.dietText {
            diet = Diet(rawValue: dietText.lowercased())
        }
        
        // 4. Return a ParsedTrayRequest with rawText + the three optional results
        return ParsedTrayRequest(rawText: rawText, mealTime: mealTime, diet: diet)
    }
}
