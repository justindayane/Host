//
//  FakeTrayRequestParser.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 5/31/26.
//

struct FakeTrayRequestParser: TrayRequestParsing {
    func parse(rawText: String) async -> TrayRequestExtraction {
        // Ignore rawText for now
        // ...
        
        // Return hardcoded TrayRequestExtraction
        TrayRequestExtraction(mealTimeText: "breakfast", dishTypeText: "main", dietText: "regular")
    }
}
