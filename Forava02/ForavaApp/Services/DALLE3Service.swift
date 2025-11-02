import Foundation
import SwiftUI

// MARK: - DALL-E 3 Image Generation Service
// Purpose: Generate Anniversary images using OpenAI's DALL-E 3 model
// Reason: SDXL has portrait format bias causing statue/bust generation
// DALL-E 3 has superior prompt following without portrait photography bias

@MainActor
class DALLE3Service: ObservableObject {
    static let shared = DALLE3Service()

    @Published var generationProgress: Float = 0.0
    @Published var isGenerating: Bool = false
    @Published var error: DALLE3Error?

    // MARK: - API Configuration

    internal var apiKey: String {
        return loadOpenAIAPIKey()
    }

    private var apiKeyStatus: String {
        let key = apiKey
        return key.isEmpty ? "❌ NOT CONFIGURED" : "✅ CONFIGURED (\(key.prefix(8))...)"
    }

    private let openAIBaseURL = "https://api.openai.com/v1"
    private let imagesEndpoint = "/images/generations"

    // MARK: - Quality Configuration

    enum ImageQuality: String {
        case standard = "standard"  // $0.040 per image
        case hd = "hd"              // $0.080 per image (2x cost)
    }

    enum ImageSize: String {
        case size1024 = "1024x1024"     // Square (Apple Watch)
        case size1792x1024 = "1792x1024" // Landscape
        case size1024x1792 = "1024x1792" // Portrait (iPhone)
    }

    private init() {
        print("🎨 DALL-E 3 Service initialized")
        print("🔑 API Key Status: \(apiKeyStatus)")
    }

    // MARK: - API Key Loading

    private func loadOpenAIAPIKey() -> String {
        // Priority 1: Environment variable (from .env or Xcode scheme)
        if let envKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"], !envKey.isEmpty {
            // Reject common placeholder values
            if envKey == "your_openai_api_key_here" || envKey.hasPrefix("your_") {
                print("❌ DALL-E 3: Placeholder API key detected: '\(envKey)'")
                print("💡 Please add your real OpenAI API key to .env file or environment variables")
                // Continue to check other sources
            } else {
                print("✅ DALL-E 3: Loaded API key from environment variable")
                return envKey
            }
        }

        // Priority 2: UserDefaults (for persistent storage)
        if let defaultsKey = UserDefaults.standard.string(forKey: "OPENAI_API_KEY"), !defaultsKey.isEmpty {
            // Reject placeholder values
            if defaultsKey == "your_openai_api_key_here" || defaultsKey.hasPrefix("your_") {
                print("❌ DALL-E 3: Placeholder API key in UserDefaults: '\(defaultsKey)'")
                // Continue to check other sources
            } else {
                print("✅ DALL-E 3: Loaded API key from UserDefaults")
                return defaultsKey
            }
        }

        // Priority 3: Info.plist
        if let plistKey = Bundle.main.object(forInfoDictionaryKey: "OPENAI_API_KEY") as? String, !plistKey.isEmpty {
            // Reject placeholder values
            if plistKey == "your_openai_api_key_here" || plistKey.hasPrefix("your_") {
                print("❌ DALL-E 3: Placeholder API key in Info.plist: '\(plistKey)'")
                // Continue to check other sources
            } else {
                print("✅ DALL-E 3: Loaded API key from Info.plist")
                return plistKey
            }
        }

        // Priority 4: Attempt to read .env file directly
        // Try multiple approaches to find the project root
        var searchPaths: [String] = []

        // Approach 1: Fix case-sensitivity - replace both /Build/ and /build/
        if let resourcePath = Bundle.main.resourcePath {
            let path1 = resourcePath.replacingOccurrences(of: "/Build/", with: "/")
            let path2 = resourcePath.replacingOccurrences(of: "/build/", with: "/")
            searchPaths.append(path1)
            if path2 != path1 {
                searchPaths.append(path2)
            }
        }

        // Approach 2: Use FileManager to get current working directory
        let currentDir = FileManager.default.currentDirectoryPath
        searchPaths.append(currentDir)

        // Approach 3: Common project paths
        searchPaths.append("/Users/kirangokal/Documents/Forava/Forava02")
        searchPaths.append("/Users/kirangokal/Documents/Forava")

        print("🔍 DALL-E 3: Searching for .env file in \(searchPaths.count) locations...")

        for searchPath in searchPaths {
            if let envPath = findEnvFile(startingFrom: searchPath) {
                print("📂 DALL-E 3: Found .env at: \(envPath)")
                do {
                    let envContent = try String(contentsOfFile: envPath, encoding: .utf8)
                    let lines = envContent.components(separatedBy: .newlines)
                    for line in lines {
                        let trimmed = line.trimmingCharacters(in: .whitespaces)
                        if trimmed.hasPrefix("OPENAI_API_KEY=") {
                            let key = String(trimmed.dropFirst("OPENAI_API_KEY=".count))
                                .trimmingCharacters(in: .whitespaces)
                            if !key.isEmpty && key != "your_openai_api_key_here" {
                                print("✅ DALL-E 3: Loaded API key from .env file")
                                return key
                            }
                        }
                    }
                } catch {
                    print("⚠️ DALL-E 3: Failed to read .env file at \(envPath): \(error)")
                    // Continue to next search path
                }
            }
        }

        print("❌ DALL-E 3: No .env file found in any search location")

        print("❌ DALL-E 3: No API key found")
        return ""
    }

    private func findEnvFile(startingFrom path: String) -> String? {
        var currentPath = path
        for _ in 0..<10 {
            let envPath = (currentPath as NSString).appendingPathComponent(".env")
            if FileManager.default.fileExists(atPath: envPath) {
                return envPath
            }
            currentPath = (currentPath as NSString).deletingLastPathComponent
        }
        return nil
    }

    // MARK: - Image Generation

    func generateImage(
        prompt: String,
        negativePrompt: String = "",
        size: ImageSize = .size1024x1792,
        quality: ImageQuality = .standard
    ) async throws -> String {

        guard !apiKey.isEmpty else {
            throw DALLE3Error.apiKeyMissing
        }

        await MainActor.run {
            self.isGenerating = true
            self.generationProgress = 0.1
            self.error = nil
        }

        print("🎨 DALL-E 3 Generation Request:")
        print("   Size: \(size.rawValue)")
        print("   Quality: \(quality.rawValue)")
        print("   Prompt length: \(prompt.count) characters")

        // DALL-E 3 CRITICAL: The safety filter rejects ANY negative instructions
        // Even benign terms like "Avoid: oversaturated colors" trigger HTTP 400 content_policy_violation
        // Solution: Send ONLY the positive prompt with ZERO modifications
        // DALL-E 3's built-in safety handles all content filtering automatically

        let enhancedPrompt = prompt  // Use prompt exactly as provided - no additions

        print("   📝 Sending clean prompt without negative terms (DALL-E 3 handles safety)")
        print("   ℹ️  Note: Negative prompt ignored to prevent safety filter rejection")

        // DALL-E 3 API request body
        let requestBody: [String: Any] = [
            "model": "dall-e-3",
            "prompt": enhancedPrompt,
            "n": 1,
            "size": size.rawValue,
            "quality": quality.rawValue,
            "response_format": "url"
        ]

        await MainActor.run {
            self.generationProgress = 0.2
        }

        // Create request
        guard let url = URL(string: "\(openAIBaseURL)\(imagesEndpoint)") else {
            throw DALLE3Error.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Forava-iOS/1.0", forHTTPHeaderField: "User-Agent")

        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)

        await MainActor.run {
            self.generationProgress = 0.3
        }

        print("🚀 Sending DALL-E 3 request...")

        // Make API call
        let (data, response) = try await URLSession.shared.data(for: request)

        await MainActor.run {
            self.generationProgress = 0.8
        }

        // Parse response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw DALLE3Error.invalidResponse
        }

        print("📡 DALL-E 3 Response: HTTP \(httpResponse.statusCode)")

        guard httpResponse.statusCode == 200 else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            print("❌ DALL-E 3 Error: \(errorMessage)")
            throw DALLE3Error.apiError(httpResponse.statusCode, errorMessage)
        }

        // Parse JSON response
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let dataArray = json["data"] as? [[String: Any]],
              let firstImage = dataArray.first,
              let imageURL = firstImage["url"] as? String else {
            throw DALLE3Error.invalidResponse
        }

        await MainActor.run {
            self.generationProgress = 1.0
            self.isGenerating = false
        }

        print("✅ DALL-E 3 generation complete!")
        print("   Image URL: \(imageURL.prefix(60))...")

        return imageURL
    }

    // MARK: - Error Types

    enum DALLE3Error: LocalizedError {
        case apiKeyMissing
        case invalidURL
        case invalidResponse
        case apiError(Int, String)
        case networkError(String)

        var errorDescription: String? {
            switch self {
            case .apiKeyMissing:
                return "OpenAI API key not configured. Add OPENAI_API_KEY to .env file."
            case .invalidURL:
                return "Invalid OpenAI API URL"
            case .invalidResponse:
                return "Invalid response from DALL-E 3 API"
            case .apiError(let code, let message):
                return "DALL-E 3 API error (\(code)): \(message)"
            case .networkError(let message):
                return "Network error: \(message)"
            }
        }
    }
}
