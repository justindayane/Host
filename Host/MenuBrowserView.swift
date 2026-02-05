//
//  FreshStartView.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 12/5/25.
//

import SwiftUI

struct MenuBrowserView: View {
    @State private var menuItems: [MenuItem] = MenuItem.samples
    
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
                    Button("Test") {
                        // Test item 1: High Sodium Chicken
                        let highSodiumChicken = MenuItem(
                            name: "Deep Fried Chicken",
                            mealTimes: [.dinner],
                            dishType: .main,
                            attributes: NutritionAttributes(sodium: 900, carbs: 40, fluid: nil)
                        )
                        
                        let report = RulesEngine.evaluate([highSodiumChicken], diet: .cardiac, mealTime: .lunch)
                        print(" -------- High Sodium Chicken Evaluation --------")
                        if let evaluation = report.evaluations.first {
                            print("Item: \(evaluation.item.name)")
                            print("Allowed: \(evaluation.isAllowed)")
                            print("Failed rules: ")
                            for reason in evaluation.failedRules {
                                print("  - \(reason)")
                            }
                        }
                        
                        let salad = MenuItem(name: "Garden Salad", mealTimes: [.lunch, .dinner], dishType: .main, attributes: NutritionAttributes(sodium: 10, carbs: 20, fluid: 2))
                        let report2 = RulesEngine.evaluate([salad], diet: .cardiac, mealTime: .breakfast)
                        print("\n\n --------- Salad Evaluation ---------")
                        if let evaluation = report2.evaluations.first {
                            print("Item: \(evaluation.item.name)")
                            print("Allowed: \(evaluation.isAllowed)")
                            print("Failed rules: \(evaluation.failedRules.isEmpty ? "None" : "")")
                            for reason in evaluation.failedRules {
                                print("  - \(reason)")
                            }
                        }
                        
                        let highCarbRice = MenuItem(name: "Arroz", mealTimes: [.lunch, .dinner], dishType: .main, attributes: NutritionAttributes(carbs: 100))
                        let report3 = RulesEngine.evaluate([highCarbRice], diet: .carbControl, mealTime: .lunch)
                        if let evaluation = report3.evaluations.first {
                            print("\n\n --------- Rice Eval ---------")
                            print("Item: \(evaluation.item.name)")
                            print("Allowed: \(evaluation.isAllowed)")
                            print("Failed rules: \(evaluation.failedRules.isEmpty ? "None" : "")")
                            for reason in evaluation.failedRules {
                                print("  - \(reason)")
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

