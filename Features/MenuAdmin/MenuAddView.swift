//
//  MenuAddView.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 10/27/25.
//

import SwiftUI

struct MenuAddView: View {
    @Environment(\.dismiss) private var dismiss
    
    // MARK: Form state
    @State private var name = ""
    @State private var nutrition = ""
    
    // Keep the selected values as Sets
    @State private var selectedMealTimes = Set<MealTime>()
    @State private var selectedDishTypes = Set<DishType>()
    @State private var selectedDiets = Set<Diet>()
    
    @State private var isSpecial = false
    
    // MARK: Dependencies
    @ObservedObject var viewModel: MenuViewModel
    
    // MARK: Helpers
    private var allMealTimes: [MealTime] { MealTime.allCases }
    private var allDishTypes: [DishType] { DishType.allCases }
    private var allDiets: [Diet] { Diet.allCases }
    
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Basic info")) {
                    TextField("Name", text: $name)
                    TextField("Nutrition", text: $nutrition)
                }
                
//                Section(header: Text("Meal Times")) {
//                    ForEach(allMealTimes) { time in
//                        Toggle(
//                            time.rawValue.capitalized,
//                            isOn: Binding(
//                                get: {
//                                    selectedMealTimes.contains(time)
//                                },
//                                set: { toggle in
//                                    toggle ? selectedMealTimes.insert(time) : selectedMealTimes.remove(time)
//                                })
//                        )
//                    }
//                }
                Section(header: Text("Meal Times")) {
                    ForEach(MealTime.allCases) { mt in
                        MultiSelectToggle(selection: $selectedMealTimes, element: mt)
                    }
                }
//                Section(header: Text("Dish Type")) {
//                    ForEach(allDishTypes) { type in
//                        Toggle(
//                            type.rawValue.capitalized,
//                            isOn: Binding(
//                                get: {
//                                    selectedDishTypes.contains(time)
//                                },
//                                set: { toggle in
//                                    toggle ? selectedDishTypes.insert(time) : selectedDishTypes.remove(time)
//                                })
//                        )
//                    }
//                }
                Section(header: Text("Dish Types")) {
                    ForEach(DishType.allCases) { dt in
                        MultiSelectToggle(selection: $selectedDishTypes, element: dt)
                    }
                    
                }
//                Section(header: Text("Diets")) {
//                    ForEach(allDiets) { d in
//                        Toggle(
//                            d.rawValue.capitalized,
//                            isOn: Binding(
//                                get: {
//                                    selectedDiets.contains(time)
//                                },
//                                set: { toggle in
//                                    toggle ? selectedDiets.insert(time) : selectedDiets.remove(time)
//                                })
//                        )
//                    }
//                    Toggle("Special", isOn: $isSpecial)
//                }
                
                Section(header: Text("Diets")) {
                    ForEach(Diet.allCases) { d in
                        MultiSelectToggle(selection: $selectedDiets, element: d)
                    }
                }
                
                Section {
                    Toggle("Special", isOn: $isSpecial)
                }
            }
            .navigationTitle("Add Menu Item")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
//                        viewModel.addItem(name: name, nutrition: nutrition, mealTime: Array(selectedMealTimes), dishType: Array(selectedDishTypes), isSpecial: isSpecial, diet: Array(selectedDiets))
////                        print("We should be adding an item here: \(name), \(nutrition), \(mealTime), \(dishType), \(isSpecial), \(diet)")
//                        dismiss()
                    }
                    .disabled(name.isEmpty) // quick validation
                }
            }
        }
    }
}

//#Preview {
//    MenuAddView()
//}
