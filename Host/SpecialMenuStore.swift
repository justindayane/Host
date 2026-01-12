//
//  SpecialMenuStore.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 11/28/25.
//

import Foundation


final class MenuStore: ObservableObject {
    @Published var menu: Menu

    init() {
        let url = Bundle.main.url(forResource: "specials", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let decoder = JSONDecoder()
        do {
            menu = try decoder.decode(Menu.self, from: data)
        } catch {
            print("Decoding failed:", error)
            // temporary fallback so the app can run
            menu = Menu(meta: Meta(cycle_length_weeks: 2, start_date: "2024-01-01"),
                        weeks: [])
        }
    }
}


extension MenuStore {
    func meals(for date: Date = Date()) -> DayMeals? {
        // 1. Parse start_date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let start = formatter.date(from: menu.meta.start_date) else { return nil }
        print("the start date is \(start)")

        // 2. Weeks since start (can be negative)
        let daysDiff = Calendar.current.dateComponents([.day], from: start, to: date).day ?? 0
        print(daysDiff)
        let weeksDiff = daysDiff / 7

        // 3. Cycle-safe week index
        let cycleLength = menu.meta.cycle_length_weeks        // 2 in your JSON
        if cycleLength == 0 || menu.weeks.isEmpty { return nil }

        let positiveWeeksDiff = (weeksDiff % cycleLength + cycleLength) % cycleLength
        let weekIndex = min(max(positiveWeeksDiff, 0), menu.weeks.count - 1)
        // or guard:
        // guard weekIndex >= 0 && weekIndex < menu.weeks.count else { return nil }

        // 4. Day key
        let weekdayIndex = Calendar.current.component(.weekday, from: date)
        let dayNames = ["sunday","monday","tuesday","wednesday","thursday","friday","saturday"]
        let dayKey = dayNames[weekdayIndex - 1]

        // 5. Look up week and day
        let week = menu.weeks[weekIndex]
        guard let day = week.days[dayKey] else { return nil }

        return day.meals
    }

}
