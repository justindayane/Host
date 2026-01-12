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
                }
                .navigationTitle("Menu")
            }
        }
    }
}

#Preview {
    MenuBrowserView()
}

