//
//  MenuItemStore.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 10/27/25.
//

import Foundation
import Combine

final class MenuItemStore: ObservableObject {
    @Published private(set) var items: [MenuItem] = []
    
    // MARK: - File handling
    // Make the url
    private var url: URL {
        // Using content directory here
        let fm = FileManager.default
        let dir = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent("menuFromDirectory.json")
    }
    
    init() {
        load()
    }
    
    // MARK: Load/Save
    private func load() {
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: url)
            let items = try decoder.decode([MenuItem].self, from: data)
        } catch {
            // If the file does not exist yet, create an empty array
            if (error as NSError).code == NSFileNoSuchFileError {
                items = []
                save() // Create the file so that the UI can read it later
            } else {
                print("❌ MenuItemStore failed to load: \(error)")
                items = []
            }
        }
    }
    
    private func save() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted] // Nicer look for debugging
        
        do {
            let data = try encoder.encode(items)
            try data.write(to: url, options: [.atomicWrite])
        } catch {
            print("❌ MenuItemStore failed to save: \(error)")
        }
    }
    
    // MARK: CRUD
    func add(_ item: MenuItem) {
        items.append(item)
        save()
    }
    
    
    func delete(_ item: MenuItem) {
        items.removeAll { $0.id == item.id }
        save()
    }
    
    func update(_ item: MenuItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
            save()
        }
    }
}
