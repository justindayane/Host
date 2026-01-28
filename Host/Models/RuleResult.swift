//
//  RuleResult.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 1/28/26.
//

import Foundation

/// The result of evaluating a rule against a menu item
enum RuleResult: Equatable {
    case pass
    case fail(reason: String)
    
    /// Wethe the rule passed
    var isPassing: Bool {
        if case .pass = self {
            return true
        }
        return false
    }
    
    /// The failure reason if failed
    var failureReason: String? {
        if case .fail(let reason) = self {
            return reason
        }
        return nil
    }
}
