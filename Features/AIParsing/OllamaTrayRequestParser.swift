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
    
    func parse(rawText: String) async -> TrayRequestExtraction {
        // 1. Build the prompt string
        let prompt = """
        Extract the meal time, dish type, and diet from the following text.
        Respond only in JSON with exactly these keys: mealTimeText, dishTypeText, dietText.
        Use null if a field is not mentioned.

        Valid values for mealTimeText: breakfast, lunch, dinner
        Valid values for dishTypeText: main, side, beverage
        Valid values for dietText: regular, cardiac, carbControl, carbControlCardiac, fluidRest, fiberRest
        
        A low sodium diet should map to cardiac
        
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
            let bodyData = try! JSONSerialization.data(withJSONObject: body, options: [])
            
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
                return TrayRequestExtraction(mealTimeText: nil, dishTypeText: nil, dietText: nil)
            }
            let extraction = try JSONDecoder().decode(TrayRequestExtraction.self, from: extractionData)
            
            // 8. Return the extraction, or a blank TrayRequestExtraction on failure
            return extraction
            
        } catch {
            print("Failed to send payload: \(error)")
        }
        
        return TrayRequestExtraction(mealTimeText: nil, dishTypeText: nil, dietText: nil)
    }
    
    
}


struct OllamaResponse: Decodable {
    let response: String
}
