//
//  OllamaTrayRequestParser.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 5/31/26.
//

import Foundation

struct OllamaTrayRequestParser: TrayRequestParsing {
    
    private let endpoint = URL(string: "http://localhost:11434/api/generate")!
    private let model = "llama3.2"
    
    func parse(rawText: String) async -> Result<TrayRequestExtraction, Error> {
        // 1. Build the prompt string
        let prompt = """
        Extract structured tray request data from the user's text.

        Return only valid JSON with exactly these keys:
        - mealTimeText
        - dishTypeText
        - dietText

        Allowed values:
        - mealTimeText: breakfast, lunch, dinner
        - dishTypeText: main, side, beverage
        - dietText: regular, cardiac, renal, carbControl, carbControlCardiac, fluidRest, fiberRest

        Rules:
        1. Extract only values that are explicitly stated in the text.
        2. Do not guess or infer missing values.
        3. If a field is not clearly mentioned, return null for that field.
        4. If a field is ambiguous, return null for that field.
        5. A low sodium diet maps to cardiac only if the text explicitly indicates low sodium.
        6. Do not use common defaults. For example, if the text says "Make me a cardiac tray" and does not mention breakfast, lunch, or dinner, then mealTimeText must be null.
        7. Respond with JSON only. No explanation, no markdown, no extra text.

        Text: \(rawText)
        """
        
        // 2. Build the request body as a dictionary, with:
        //    - "model": model
        //    - "prompt": your prompt
        //    - "format": "json"
        //    - "stream": false
        let body: [String: Any] = ["model": model, "prompt": prompt, "format": "json", "stream": false]
        
        do {
            // 3. Serialize the body to JSON Data using JSONSerialization
            let bodyData = try JSONSerialization.data(withJSONObject: body, options: [])
            
            // 4. Build a URLRequest with:
            //    - method: POST
            //    - Content-Type: application/json
            //    - body: the serialized data
            var request = URLRequest(url: endpoint)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = bodyData
            
            // 5. Call URLSession.shared.data(for:) using await
            let (data, _) = try await URLSession.shared.data(for: request)
            
            // 6. Decode the response Data into OllamaResponse
            let decodedResponse = try JSONDecoder().decode(OllamaResponse.self, from: data)
        
            // Debug
            print("Raw extraction: \(decodedResponse.response)")
            
            // 7. Decode OllamaResponse.response string into TrayRequestExtraction
            guard let extractionData = decodedResponse.response.data(using: .utf8) else {
                
                return .failure(OllamaParserError.invalidResponseEncoding)
            }
            let extraction = try JSONDecoder().decode(TrayRequestExtraction.self, from: extractionData)
            
            // 8. Return the extraction, or a blank TrayRequestExtraction on failure
            return .success(extraction)
            
        } catch {
            print("Failed to send payload: \(error)")
            return .failure(error)
        }
    }
    
    
}

enum OllamaParserError: Error {
    case invalidResponseEncoding
}


struct OllamaResponse: Decodable {
    let response: String
}
