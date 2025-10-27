//
//  PersonViewModel.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 10/16/25.
//

import SwiftUI
import Combine

@MainActor
class MenuViewModel: ObservableObject {
    // MARK: - Public API
    @Published private(set) var menuItems: [MenuItem] = []
    @Published var selectedDiet: Diet = .regular
    @Published var expandedGroups: Set<String> = []
    
    // MARK: - Dependencies (needed for the new approach allowing writing)
    private let store: MenuItemStore
    private var cancellables = Set<AnyCancellable>()
    
    
    // MARK: – Derived data
    /// All items that match the selected diet
    var filteredItems: [MenuItem] {
        menuItems.filter {
            $0.diet.contains(selectedDiet)
        }
    }
    
    /// specials only
    var specialtems: [MenuItem] {
        filteredItems.filter { $0.isSpecial }
    }
    
    /// Grouping by meal -> dish -> item
    var grouped: [MealTime: [DishType: [MenuItem]]] {
        var out: [MealTime: [DishType: [MenuItem]]] = [:]
        
        for meal in MealTime.allCases {
            var dishDict: [DishType: [MenuItem]] = [:]
            for dish in DishType.allCases {
                dishDict[dish] = filteredItems.filter {
                    $0.mealTime.contains(meal) && $0.dishType.contains(dish)
                }
            }
            out[meal] = dishDict
        }
        return out
    }
    
    // MARK: – Init & Data Loading
    
    private let provider = MenuDataProvider()
    
//    init() {
//        Task {
//            await loadData()
//        }
//    }
//
    // New Init
    init(store: MenuItemStore = MenuItemStore()) {
        self.store = store
        
        store.$items
            .receive(on: DispatchQueue.main)
            .assign(to: &$menuItems)
    }
    
    @MainActor
    private func loadData() async {
        do {
            self.menuItems = try await provider.fetchAll()
        } catch {
            print("[MenuViewModel] failed to load data from provider: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Helpers for UI
    func toggleExpanded(meal: MealTime, dish: DishType) {
        let key = "\(meal.rawValue)_\(dish.rawValue)"
        if expandedGroups.contains(key) {
            expandedGroups.remove(key)
        } else {
            expandedGroups.insert(key)
        }
    }
    
    func isExpanded(meal: MealTime, dish: DishType) -> Bool {
        let key = "\(meal.rawValue)_\(dish.rawValue)"
        return expandedGroups.contains(key)
    }
    
    // MARK: -Add/Delete
    func addItem(name: String, nutrition: String, mealTime: [MealTime], dishType: [DishType], isSpecial: Bool, diet: [Diet]) {
        let newItem = MenuItem(id: UUID(), name: name, nutrition: nutrition, mealTime: mealTime, dishType: dishType, isSpecial: isSpecial, diet: diet)
        
        store.add(newItem)
    }
    
    func deleteItem(_ item: MenuItem) {
        store.delete(item)
    }
}


