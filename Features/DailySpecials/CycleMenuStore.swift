//
//  CycleMenuStore.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 5/25/26.
//
import Foundation

final class CycleMenuStore: ObservableObject {
    @Published var menu: CycleMenu

    init() {
        // Job 1: load DailySpecialsMenu.json from the bundle
        // and decode it into a CycleMenu object
        // (hint: this will look very similar to your old DailySpecialStore)
        let url = Bundle.main.url(forResource: "DailySpecialsMenu", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let decoder = JSONDecoder()
        do {
            menu = try decoder.decode(CycleMenu.self, from: data)
        } catch {
            print("Decoding failed:", error)
            // temporary fallback so the app can run
            menu = CycleMenu(anchor: "2026-05-24",days: [])
        }
    }

    func meals(for date: Date = Date()) -> CycleDay? {
        // Job 2:
        // Step A — parse the anchor date string into a Date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let anchorDate = formatter.date(from: menu.anchor) else { return nil }

        let normalizedAnchor = Calendar.current.startOfDay(for: anchorDate)
        let normalizedDate = Calendar.current.startOfDay(for: date)  // ← local calendar for picker date
        
        // Step B — calculate daysSinceAnchor
        let daysSinceAnchor = Calendar.current.dateComponents([.day], from: normalizedAnchor, to: normalizedDate).day ?? 0
        
        // Step C — calculate cycleDay using the formula
        let cycleDay = ((daysSinceAnchor % 14) + 14) % 14 + 1
        
        // Step D — find and return the matching CycleDay from menu.days
        return menu.days.first(where: { $0.day == cycleDay })
    }
}
