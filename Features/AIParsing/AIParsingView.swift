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
    @State private var errorMessage: String?
    private let parser: any TrayRequestParsing = OllamaTrayRequestParser()
    private let mapper = TrayRequestMapper()
    
    let onConfirm: (ParsedTrayRequest) -> Void
    
    var body: some View {
        
        // 1. A TextEditor for rawText input
        TextEditor(text: $rawText)
        
        // Error Message
        if let errorMessage {
            Text(errorMessage)
        }
        // 2. A Button that:
        //    - calls parser.parse(rawText:)
        //    - calls mapper.map(extraction:rawText:)
        //    - assigns the result to self.result
        
        if isLoading {
            ProgressView()
        } else {
            Button("Parse Request") {
                Task {
                    errorMessage = nil
                    result = nil
                    
                    guard !rawText.trimmingCharacters(in: .whitespaces).isEmpty else {
                        errorMessage = "Please enter a request."
                        return
                    }
                    
                    isLoading = true
                    let parserResult = await parser.parse(rawText: rawText)
                    switch parserResult {
                    case .success(let extraction):
                        self.result = mapper.map(extraction: extraction, rawText: rawText)
                    case .failure(let error):
                        self.errorMessage = "\(error)"
                    }
                    isLoading = false
                }
            }
            .disabled(isLoading)
            .buttonStyle(.bordered)
        }
        // 3. If result is not nil, show:
        //    - the rawText
        //    - mealTime, dishType, diet (show the raw value or "not found")
        if let result = result {
            VStack {
                Text("Raw Text: \(result.rawText)")
                Text("MealTime: \(result.mealTime?.rawValue ?? "Not Found")")
                Text("Diet: \(result.diet?.rawValue ?? "Not Found")")
                HStack {
                    Button("Confirm") { onConfirm(result) }
                        .buttonStyle(.borderedProminent)
                    Button("Dismiss", role: .destructive) {
                        self.result = nil
                        self.rawText = ""
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
    }
}

#Preview {
    AIParsingView(onConfirm: { _ in })
}
