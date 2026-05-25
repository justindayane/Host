//
//  DecisionLog.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 5/5/26.
//
import Foundation

struct DecisionLog: Identifiable {
    let id: UUID
    let timestamp: Date
    let mealTime: MealTime
    let constraintNames: [String]
    let selectedItemNames: [String]
    let wasDefault: Bool
    
    init(from tray: Tray, wasDefault: Bool) {
        self.id = UUID()
        self.timestamp = Date()
        self.mealTime = tray.mealTime
        
        let dietConstraintNames = tray.diet.constraints.map { $0.name }
        let extraConstraintNames = tray.extraConstraints.map { $0.name }
        self.constraintNames = Array(Set(dietConstraintNames + extraConstraintNames))
        self.selectedItemNames = tray.items.map {
            $0.name
        }
        self.wasDefault = wasDefault
    }
}

class DecisionHistory: ObservableObject {
    @Published var logs: [DecisionLog] = []
    
    func recordDecision(from tray: Tray, wasDefault: Bool) {
        let log = DecisionLog(from: tray, wasDefault: wasDefault)
        
        logs.append(log)
    }
}
