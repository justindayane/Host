//
//  test.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 11/26/25.
//

import Combine
import SwiftUI

struct TodayMealsView: View {
    @StateObject var store = MenuStore()
    @State private var selectedDate = Date()

    var body: some View {
        VStack {
            DatePicker(
                "Select Date",
                selection: $selectedDate,
                displayedComponents: .date
            )
            .datePickerStyle(.compact)
            .padding()

            if let meals = store.meals(for: selectedDate) {
                List {
                    Section("Breakfast") {
                        ForEach(meals.breakfast) { item in
                            Text(item.name)
                        }
                    }
                    Section("Lunch") {
                        ForEach(meals.lunch) { item in
                            Text(item.name)
                        }
                    }
                    Section("Dinner") {
                        ForEach(meals.dinner) { item in
                            Text(item.name)
                        }
                    }
                }
            } else {
                Text("No menu for this date")
                    .padding()
            }
        }
        .navigationTitle("Menu by Date")
    }
}

#Preview {
    TodayMealsView()
}
