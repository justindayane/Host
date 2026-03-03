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
    static func evaluate(_ items: [MenuItem], diet: Diet, mealTime: MealTime, extraConstraints: [Constraint] = []) -> EvaluationReport {
        let evaluations = items.map { item in
            evaluateItem(item, against: diet, mealTime: mealTime, extraConstraints: extraConstraints) // The helper is actually doing the evaluation job for each of those item
        }
        
        return EvaluationReport(evaluations: evaluations)
    }
    
    // MARK : - Private Helper
    /// Evaluates a single item against constraints using rules
    private static func evaluateItem(_ item: MenuItem, against diet: Diet, mealTime: MealTime, extraConstraints: [Constraint]) -> ItemEvaluation {
        var failedRules: [String] = [] // A list of the rules that this item failed - empty for now
        
        // Rule: Check Diet compatibility - Mealtime is already filtered
        
        // 1. Base constraints
        let baseConstraints = diet.constraints
        
        // 2. Then merge with extra constraints
        let constraints = baseConstraints + extraConstraints
        
        // 3. Handle duplicates with a helper function
        let uniqueConstraints = Array(Set(constraints))
        
        // 4. Then, create all the necessary rules and have them in a rules array
        let rules = uniqueConstraints.compactMap { RuleFactory.rule(for: $0)}
        
        // 5. Evaluate: The actual check of the item to each rule
        for rule in rules {
            let result = rule.evaluate(item)
            if let reason = result.failureReason {
                failedRules.append("\(rule.name) : \(reason)")
            }
        }
        
        
        let isAllowed = failedRules.isEmpty // if this list is still empty, then the item passed all rules
        
        return ItemEvaluation(item: item, isAllowed: isAllowed, failedRules: failedRules)
    }
}
