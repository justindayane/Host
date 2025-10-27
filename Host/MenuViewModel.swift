//
//  PersonViewModel.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 10/16/25.
//

import SwiftUI

class MenuViewModel: ObservableObject {
    @Published var people : [Meal] = []
    
    init() {
        addPeople()
    }
    
    func addPeople() {
        people = peopleData
    }
    
    func shuffleOrder() {
        people.shuffle()
    }
    
    func reverseOrder() {
        people.reverse()
    }
    
    func removeLast() {
        people.removeLast()
    }
    
    func removeFirst() {
        people.removeFirst()
    }
}

let peopleData = [
    Meal(name: "Jon Snow", email: "jon@email.com", phoneNumber: "555-5555"),
    Meal(name: "Rami Arias", email: "Rami@email.com", phoneNumber: "555-5555"),
    Meal(name: "Amine Gbadamassi", email: "Amine@email.com", phoneNumber: "555-5555"),
    Meal(name: "Justin Dayane", email: "justin@email.com", phoneNumber: "555-5555"),
    Meal(name: "Damaris Dominguez", email: "damaris@email.com", phoneNumber: "555-5555")
]
