//
//  FreshStartView.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 12/5/25.
//

import SwiftUI

struct MenuBrowserView: View {
    @State private var menuItems: [MenuItem] = [
        // Breakfast
        MenuItem(
            name: "Pancakes",
            nutrition: "350 kcal",
            mealTimes: [.breakfast],
            dishType: .main
        ),
        MenuItem(
            name: "Fruit Parfait",
            nutrition: "220 kcal",
            mealTimes: [.breakfast],
            dishType: .side
        ),
        MenuItem(
            name: "Orange Juice",
            nutrition: "110 kcal",
            mealTimes: [.breakfast],
            dishType: .beverage
        ),
        
        // Lunch
        MenuItem(
            name: "Grilled Chicken Sandwich",
            nutrition: "480 kcal",
            mealTimes: [.lunch],
            dishType: .main
        ),
        MenuItem(
            name: "Caesar Salad",
            nutrition: "210 kcal",
            mealTimes: [.lunch],
            dishType: .side
        ),
        MenuItem(
            name: "Iced Tea",
            nutrition: "0 kcal (unsweetened)",
            mealTimes: [.lunch],
            dishType: .beverage
        ),
        
        // Dinner
        MenuItem(
            name: "Baked Salmon",
            nutrition: "350 kcal",
            mealTimes: [.dinner],
            dishType: .main
        ),
        MenuItem(
            name: "Steamed Broccoli",
            nutrition: "55 kcal",
            mealTimes: [.dinner],
            dishType: .side
        ),
        MenuItem(
            name: "Sparkling Water",
            nutrition: "0 kcal",
            mealTimes: [.dinner],
            dishType: .beverage
        ),
        
        // Special/All‑diet items
        MenuItem(
            name: "Spinach Omelette",
            nutrition: "250 kcal",
            mealTimes: [.breakfast],
            dishType: .main,
            isSpecial: true,
            diets: [.cardiac]
        ),
        MenuItem(
            name: "Whole Wheat Wrap",
            nutrition: "280 kcal",
            mealTimes: [.lunch],
            dishType: .side,
            isSpecial: true,
            diets: [.renal]
        ),
        MenuItem(
            name: "Quinoa & Veggie Bowl",
            nutrition: "310 kcal",
            mealTimes: [.dinner],
            dishType: .main,
            isSpecial: true,
            diets: [.carbControl]
        ),
        
        // Additional variety
        MenuItem(
            name: "Herbal Tea",
            nutrition: "0 kcal",
            mealTimes: [.breakfast, .lunch, .dinner],
            dishType: .beverage
        ),
        MenuItem(
            name: "Roasted Sweet Potatoes",
            nutrition: "180 kcal",
            mealTimes: [.lunch, .dinner],
            dishType: .side,
            diets: [.fiberRest]
        ),
        MenuItem(
            name: "Grilled Shrimp Skewers",
            nutrition: "220 kcal",
            mealTimes: [.dinner],
            dishType: .main,
            diets: [.fluidRest]
        ),
        MenuItem(
            name: "Turkey & Avocado Sandwich",
            nutrition: "410 kcal",
            mealTimes: [.lunch],
            dishType: .main
        ),
        MenuItem(
            name: "Mixed Green Salad",
            nutrition: "120 kcal",
            mealTimes: [.breakfast, .lunch, .dinner],
            dishType: .side
        ),
        MenuItem(
            name: "Sparkling Lemonade",
            nutrition: "95 kcal",
            mealTimes: [.breakfast, .lunch, .dinner],
            dishType: .beverage
        ),
        MenuItem(
            name: "Low‑Sodium Chicken Broth",
            nutrition: "15 kcal",
            mealTimes: [.breakfast, .lunch, .dinner],
            dishType: .beverage,
            isSpecial: true,
            diets: [.renal]
        ),
        MenuItem(
            name: "Whole Wheat Pasta",
            nutrition: "400 kcal",
            mealTimes: [.dinner],
            dishType: .main,
            isSpecial: true,
            diets: [.cardiac]
        )
    ]
    @State private var selectedDiet: Diet = .regular
    
    // Filtering Logic and process
    private var filteredMenuItems: [MenuItem] {
        if selectedDiet == .regular { return menuItems }
        return  menuItems.filter { $0.diets.contains(selectedDiet) }
    }
    
    // Grouping logic used for cases where we need a sections List in the UI (there are other alternatives)
    private var groupedDictionary: [MealTime: [MenuItem]] {
        var grouped : [MealTime: [MenuItem]] = [:]
        for item in filteredMenuItems {
            for time in item.mealTimes {
                grouped[time, default: []].append(item)
            }
        }
        return grouped
    }
    
    // Declaring the order of the sections to loop through later
    let sectionOrder: [MealTime] = [.breakfast, .lunch, .dinner]

    var body: some View {
        NavigationView {
            VStack {
                Picker("Diet", selection: $selectedDiet) {
                    ForEach(Diet.allCases, id:\.self) {diet in
                        Text(diet.title)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                List {
                    ForEach(sectionOrder, id: \.self) { time in
                        if let items = groupedDictionary[time], !items.isEmpty {
                            Section(header: Text(time.rawValue.capitalized)) {
                                ForEach(items) { item in
                                    Text(item.name)
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Menu")
            }
        }
    }
}

#Preview {
    MenuBrowserView()
}

