//
//  ContentView.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 10/16/25.
//

import SwiftUI

struct MenuView: View {
    @ObservedObject var viewModel = MenuViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                // Diet selector
                Picker("Diet", selection: $viewModel.selectedDiet) {
                    ForEach(Diet.allCases) { order in
                        Text(order.title).tag(order)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                // List
                List {
                    // ----- Specials: No grouping here --------
                    Section(header: Text("Specials")) {
                        ForEach(viewModel.specialtems) { item in
                            MenuRow(item: item)
                        }
                    }
                    
                    // ----- Normal Hierarchy --------
                    ForEach(MealTime.allCases) { meal in
                        Section(header: Text(meal.rawValue.capitalized)) {
                            ForEach(DishType.allCases) { dish in
                                DisclosureGroup(
                                    isExpanded: Binding(get: { viewModel.isExpanded(meal: meal, dish: dish)}, set: { _ in viewModel.toggleExpanded(meal: meal, dish: dish)}), content: {
                                        ForEach(viewModel.grouped[meal]?[dish] ?? []) { item in
                                            MenuRow(item: item)
                                        }
                                    }, label: {
                                        Text(dish.rawValue.capitalized)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                )
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
                .navigationTitle("Menu")
                
            }
//            TabView {
//                Tab("Breakfast", systemImage: "circle.grid.3x3.circle") {
//                    List (viewModel.brItems) { item in
//                        HStack {
//                            Text(item.name)
//                        }
//                        .frame(height: 5)
//                        .padding()
//                    }
//                }
//                
//                Tab("Lunch", systemImage: "circle.hexagongrid.fill") {
//                    List (viewModel.lItems) { item in
//                        HStack {
//                            Text(item.name)
//                        }
//                        .frame(height: 5)
//                        .padding()
//                    }
//                }
//                    
//                Tab("Dinner", systemImage: "circle.hexagongrid.circle") {
//                    List (viewModel.dItems) { item in
//                        HStack {
//                            Text(item.name)
//                        }
//                        .frame(height: 5)
//                        .padding()
//                    }
//                }
//            }
        }
    }
}

#Preview {
    MenuView()
}
