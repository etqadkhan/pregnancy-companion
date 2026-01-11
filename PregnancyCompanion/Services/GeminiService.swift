import Foundation

// MARK: - Gemini API Service
class GeminiService {
    static let shared = GeminiService()
    
    // IMPORTANT: Replace with your actual Gemini API key
    // You can get one from: https://makersuite.google.com/app/apikey
    private var apiKey: String {
        // Try to read from UserDefaults first (for runtime configuration)
        if let key = UserDefaults.standard.string(forKey: "gemini_api_key"), !key.isEmpty {
            return key
        }
        // Fallback to hardcoded key (replace this with your key)
        return "YOUR_GEMINI_API_KEY_HERE"
    }
    
    private let baseURL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent"
    
    private init() {}
    
    // MARK: - Set API Key
    func setAPIKey(_ key: String) {
        UserDefaults.standard.set(key, forKey: "gemini_api_key")
    }
    
    // MARK: - Analyze Food
    func analyzeFood(_ description: String, customProteinInfo: String? = nil) async throws -> NutritionInfo {
        var prompt = """
        Analyze the following food and provide nutritional estimates.
        
        Food: \(description)
        """
        
        if let customInfo = customProteinInfo, !customInfo.isEmpty {
            prompt += """
            
            Note: The user has specified custom protein information: \(customInfo)
            Please use this information for the protein calculation.
            """
        }
        
        prompt += """
        
        Respond ONLY with a JSON object in this exact format (no markdown, no explanation):
        {
            "protein": <number in grams>,
            "fiber": <number in grams>,
            "calories": <number>
        }
        
        If you cannot determine exact values, provide reasonable estimates based on typical serving sizes.
        """
        
        let requestBody: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": prompt]
                    ]
                ]
            ],
            "generationConfig": [
                "temperature": 0.1,
                "maxOutputTokens": 100
            ]
        ]
        
        guard let url = URL(string: "\(baseURL)?key=\(apiKey)") else {
            throw GeminiError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw GeminiError.invalidResponse
        }
        
        if httpResponse.statusCode != 200 {
            // Try to parse error message
            if let errorJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let error = errorJson["error"] as? [String: Any],
               let message = error["message"] as? String {
                throw GeminiError.apiError(message)
            }
            throw GeminiError.apiError("HTTP \(httpResponse.statusCode)")
        }
        
        // Parse response
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let candidates = json["candidates"] as? [[String: Any]],
              let firstCandidate = candidates.first,
              let content = firstCandidate["content"] as? [String: Any],
              let parts = content["parts"] as? [[String: Any]],
              let firstPart = parts.first,
              let text = firstPart["text"] as? String else {
            throw GeminiError.parsingError
        }
        
        // Clean up the text (remove any markdown code blocks if present)
        let cleanedText = text
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Parse the JSON response
        guard let nutritionData = cleanedText.data(using: .utf8),
              let nutritionJson = try? JSONSerialization.jsonObject(with: nutritionData) as? [String: Any] else {
            throw GeminiError.parsingError
        }
        
        let protein = (nutritionJson["protein"] as? Double) ?? (nutritionJson["protein"] as? Int).map { Double($0) } ?? 0
        let fiber = (nutritionJson["fiber"] as? Double) ?? (nutritionJson["fiber"] as? Int).map { Double($0) } ?? 0
        let calories = (nutritionJson["calories"] as? Double) ?? (nutritionJson["calories"] as? Int).map { Double($0) } ?? 0
        
        return NutritionInfo(protein: protein, fiber: fiber, calories: calories)
    }
}

// MARK: - Nutrition Info
struct NutritionInfo {
    let protein: Double
    let fiber: Double
    let calories: Double
}

// MARK: - Errors
enum GeminiError: LocalizedError {
    case invalidURL
    case invalidResponse
    case parsingError
    case apiError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid API URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .parsingError:
            return "Could not parse nutrition data"
        case .apiError(let message):
            return "API Error: \(message)"
        }
    }
}


