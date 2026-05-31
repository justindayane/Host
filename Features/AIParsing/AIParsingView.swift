//
//  AIParsingView.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 5/31/26.
//

import SwiftUI

struct AIParsingView: View {
    @State private var rawText: String = ""
    @State private var result: ParsedTrayRequest?
    @State private var isLoading: Bool = false
    
    private let parser: any TrayRequestParsing = OllamaTrayRequestParser()
    private let mapper = TrayRequestMapper()
    
    var body: some View {
        
        // 1. A TextEditor for rawText input
        TextEditor(text: $rawText)
        
        // 2. A Button that:
        //    - calls parser.parse(rawText:)
        //    - calls mapper.map(extraction:rawText:)
        //    - assigns the result to self.result
        
        if isLoading {
            ProgressView()
        } else {
            Button("Parse Request") {
                Task {
                    isLoading = true
                    let extraction = await parser.parse(rawText: rawText)
                    self.result = mapper.map(extraction: extraction, rawText: rawText)
                    isLoading = false
                }
            }
            .disabled(isLoading)
        }
        // 3. If result is not nil, show:
        //    - the rawText
        //    - mealTime, dishType, diet (show the raw value or "not found")
        if let result = result {
            VStack {
                Text("Raw Text: \(result.rawText)")
                Text("MealTime: \(result.mealTime?.rawValue ?? "Not Found")")
                Text("DishType: \(result.dishType?.rawValue ?? "Not Found")")
                Text("Diet: \(result.diet?.rawValue ?? "Not Found")")
            }
        }
    }
}

#Preview {
    AIParsingView()
}
