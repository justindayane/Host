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
    // Make the url - File Location - Documents so that we can write to it
    private var url: URL {
        // Using content directory here
        let fm = FileManager.default
        let dir = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent("menuFromDirectory.json")
    }
    
    
    // Here we load the file if it exists, otherwise create a new one
    init() {
        load()
    }
    
    // MARK: Load/Save
    // Load takes care of creation of new file as well if it is missing
    private func load() {
        let decoder = JSONDecoder() // We will need this to turn the file content into our objects (menuItems)
        do {
            let data = try Data(contentsOf: url) // We get the data from the url (i.e. the file)
            items = try decoder.decode([MenuItem].self, from: data) // Use the decoder and save the menu items retrieved into *items*
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
    
    // Save is called after every change to the items array
    private func save() {
        let encoder = JSONEncoder() // To encode our objects (menuItems) into data
        encoder.outputFormatting = [.prettyPrinted] // Nicer look for debugging
        
        do {
            let data = try encoder.encode(items) // we make the data using the "beautifying" encoder
            try data.write(to: url, options: [.atomicWrite]) // We try to actually write the data into the file (@ url)
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
