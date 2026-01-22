//
//  RulesEngine.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 1/15/26.
//

import Foundation

// This is the brain of the system

struct RulesEngine {
    
    /// Evaluates all the items against given constraints (diet and time)
    /// - Parameters:
    ///     - items: All available menu items
    ///     - diet: the diet constraint to apply
    ///     - mealTime: the mealTime constraint to apply
    /// - Returns: Report with allowed and blocked items
    static func evaluate(_ items: [MenuItem], diet: Diet, mealTime: MealTime) -> EvaluationReport {
        let evaluations = items.map { item in
            evaluateItem(item, against: diet, mealTime: mealTime) // The helper is actually doing the evaluation job for each of those item
        }
        
        return EvaluationReport(evaluations: evaluations)
    }
    
    private static func evaluateItem(_ item: MenuItem, against diet: Diet, mealTime: MealTime) -> ItemEvaluation {
        var failedRules: [String] = [] // A list of the rules that this item failed - empty for now
        
        // Rule 1: Check MealTime compatibility - first constraint
        if !item.mealTimes.contains(mealTime){
            //failed so we add it to the appropriate list
            failedRules.append("Not available for \(mealTime.rawValue.capitalized)")
        }
        
        // Rule 2: Check Diet compatibility - second constraint
        // if the item's diet list is empty or contains our diet of interest -> pass
        // if the item's diet list does not contain our diet of interest -> fail
        
        if !item.diets.isEmpty && !item.diets.contains(diet){
            failedRules.append("Not suitable for \(diet.title) diet")
        }
        
        let isAllowed = failedRules.isEmpty // if this list is still empty, then the item passed all rules
        
        return ItemEvaluation(item: item, isAllowed: isAllowed, failedRules: failedRules)
    }
}
