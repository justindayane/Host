//
//  EvaluationModels.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 1/15/26.
//

import Foundation

// This is the result type that will be return for each item evaluated
struct ItemEvaluation: Identifiable {
    let id: UUID
    let item: MenuItem
    let isAllowed: Bool
    let failedRules: [String] // This will contain the reasons for all the blocked items post evaluation
    
    init(item: MenuItem, isAllowed: Bool, failedRules: [String]) {
        self.id = UUID()
        self.item = item
        self.isAllowed = isAllowed
        self.failedRules = failedRules
    }
}

// This is the full report from evaluating all items
struct EvaluationReport {
    let evaluations: [ItemEvaluation] // Of course it contains a list of all the individual evaluations
    
    // Also lets have a list of all the items that past the evaluation as a computed variable
    var allowedItems: [MenuItem] {
        evaluations.filter {
            $0.isAllowed // This would return the actual evaluations
        }.map {
            $0.item // This will extract the items from the evaluations to match our return type
        }
    }
    
    // We are interested in the blocked evaluations. Not just the items because we want to know the reason being their blockage
    var blockedEvaluations: [ItemEvaluation] {
        evaluations.filter { $0.isAllowed == false }
    }
    
    // A count of allowed items
    var allowedCount: Int {
        allowedItems.count
    }
    
    // A count off blocked items
    var blockedCount: Int {
        blockedEvaluations.count
    }
    
    // This is needed to implement and empty state for step 12
    var hasAllowedItems: Bool {
        !allowedItems.isEmpty
    }
}

extension EvaluationReport {
    // Temporarily grabbing the first blocked item
    var tempBlockingReason: String? {
        guard let first = blockedEvaluations.first, let reason = first.failedRules.first else {
            return nil
        }
        return reason
    }
    
    // Let's get the frequency of each failure reason
    var failureReasonCount: [String : Int] {
        var counts = [String : Int]()
        for eval in blockedEvaluations {
            for reason in eval.failedRules {
                counts[reason, default: 0] += 1
            }
        }
        
        return counts
    }
    
    // Let's now sort the counts dictionnary: For that we need to make it an array of tuples
    var sortedFailureReasons: [(reason: String, count: Int)] {
        failureReasonCount
            .map { (reason: $0.key, count: $0.value) }
            .sorted { item1, item2 in
            item1.count > item2.count
        }
    }
}
