//
//  MenuDataProvider.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 10/24/25.
//

import Foundation
import Combine

final class MenuDataProvider {
    func fetchAll() async throws -> [MenuItem] {
        guard let url = Bundle.main.url(forResource: "Menu", withExtension: "json") else {
            throw URLError(.badURL, userInfo: [NSLocalizedDescriptionKey: "Menu.json not found"])
        }
        
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        do {
            return try decoder.decode([MenuItem].self, from: data)
        } catch {
            print("Json decoding failed: \(error)")
            throw error
        }
        
    }
}
