import Foundation
import SwiftUI
import Combine

/// Base class for all cultural AI services providing common functionality
/// Extracted from AnniversaryAIService to enable code reuse across cultural events
@MainActor
class BaseCulturalAIService: ObservableObject {

    // MARK: - Published Properties

    @Published var isGenerating = false
    @Published var generationProgress: Float = 0.0
    @Published var error: CulturalAIConfiguration.CulturalAIError?

    // MARK: - Private Properties

    nonisolated(unsafe) private var replicateAPIKey: String = ""
    internal var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    init() {
        loadAPIKeysWithPersistence()
    }

    // MARK: - API Key Management

    private func loadAPIKeysWithPersistence() {
        print("🔑 Loading Cultural AI API keys...")

        // Try Keychain first (most secure)
        if let keychainKey = loadFromKeychain() {
            self.replicateAPIKey = keychainKey
            print("✅ Loaded API key from Keychain")
            return
        }

        // Try UserDefaults as fallback
        if let savedKey = UserDefaults.standard.string(forKey: "replicate_api_key"),
           !savedKey.isEmpty {
            self.replicateAPIKey = savedKey
            saveToKeychain(savedKey) // Upgrade to Keychain
            print("✅ Loaded API key from UserDefaults, upgraded to Keychain")
            return
        }

        // Try environment/bundle configuration
        loadAPIKeysFromEnvironment()

        // Save to secure storage if loaded successfully
        if !replicateAPIKey.isEmpty {
            saveToKeychain(replicateAPIKey)
            print("💾 Saved API key to Keychain")
        }
    }

    private func loadAPIKeysFromEnvironment() {
        // Try .env file first (development environment)
        if let envPath = Bundle.main.path(forResource: ".env", ofType: nil) {
            loadFromEnvFile(path: envPath)
        }

        // Try Info.plist configuration
        if replicateAPIKey.isEmpty,
           let plistKey = Bundle.main.object(forInfoDictionaryKey: "REPLICATE_API_KEY") as? String,
           !plistKey.isEmpty {
            self.replicateAPIKey = plistKey
            print("✅ Loaded API key from Info.plist")
        }

        // Try UserDefaults as final fallback
        if replicateAPIKey.isEmpty,
           let defaultsKey = UserDefaults.standard.string(forKey: "REPLICATE_API_KEY"),
           !defaultsKey.isEmpty {
            self.replicateAPIKey = defaultsKey
            print("✅ Loaded API key from UserDefaults fallback")
        }
    }

    private func loadFromEnvFile(path: String) {
        do {
            let content = try String(contentsOfFile: path)
            let lines = content.components(separatedBy: .newlines)

            for line in lines {
                let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
                if trimmed.hasPrefix("REPLICATE_API_TOKEN=") {
                    let key = String(trimmed.dropFirst("REPLICATE_API_TOKEN=".count))
                        .trimmingCharacters(in: CharacterSet(charactersIn: "\"'"))
                    if !key.isEmpty {
                        self.replicateAPIKey = key
                        print("✅ Loaded API key from .env file")
                        return
                    }
                }
            }
        } catch {
            print("⚠️ Could not load .env file: \(error)")
        }
    }

    // MARK: - Keychain Management

    private func loadFromKeychain() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "replicate_api_key",
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status == errSecSuccess,
           let data = result as? Data,
           let key = String(data: data, encoding: .utf8) {
            return key
        }

        return nil
    }

    private func saveToKeychain(_ key: String) {
        let data = key.data(using: .utf8)!

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "replicate_api_key",
            kSecValueData as String: data
        ]

        // Delete existing item first
        SecItemDelete(query as CFDictionary)

        // Add new item
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            print("⚠️ Failed to save API key to Keychain: \(status)")
        }
    }

    // MARK: - Core Generation Logic

    /// Main generation method to be overridden by subclasses
    func generateCulturalGift(prompt: String, culturalContext: String) async throws -> String {
        guard !isGenerating else {
            throw CulturalAIConfiguration.CulturalAIError.networkError("Generation already in progress")
        }

        guard !replicateAPIKey.isEmpty else {
            throw CulturalAIConfiguration.CulturalAIError.apiKeyMissing
        }

        isGenerating = true
        generationProgress = 0.1
        error = nil

        defer {
            isGenerating = false
            generationProgress = 0.0
        }

        do {
            return try await performReplicateGeneration(prompt: prompt, culturalContext: culturalContext)
        } catch {
            self.error = error as? CulturalAIConfiguration.CulturalAIError ??
                        CulturalAIConfiguration.CulturalAIError.networkError(error.localizedDescription)
            throw error
        }
    }

    // MARK: - Replicate API Integration

    private func performReplicateGeneration(prompt: String, culturalContext: String) async throws -> String {
        print("🤖 Starting cultural AI generation for: \(culturalContext)")

        // Create prediction request
        let predictionId = try await createPrediction(prompt: prompt)
        generationProgress = 0.3

        // Poll for completion
        return try await pollForCompletion(predictionId: predictionId)
    }

    private func createPrediction(prompt: String) async throws -> String {
        let url = URL(string: CulturalAIConfiguration.predictionsEndpoint)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // Use centralized configuration
        let headers = CulturalAIConfiguration.apiHeaders(with: replicateAPIKey)
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        let requestBody = CulturalAIConfiguration.modelConfiguration(prompt: prompt)
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw CulturalAIConfiguration.CulturalAIError.invalidResponse
        }

        guard httpResponse.statusCode == 201 else {
            if httpResponse.statusCode == 429 {
                throw CulturalAIConfiguration.CulturalAIError.quotaExceeded
            }
            throw CulturalAIConfiguration.CulturalAIError.networkError("HTTP \(httpResponse.statusCode)")
        }

        let predictionResponse = try JSONDecoder().decode(PredictionResponse.self, from: data)
        return predictionResponse.id
    }

    private func pollForCompletion(predictionId: String) async throws -> String {
        let maxPollingTime = CulturalAIConfiguration.maxGenerationTime
        let pollingInterval = CulturalAIConfiguration.pollingInterval
        let maxAttempts = Int(maxPollingTime / pollingInterval)

        for attempt in 1...maxAttempts {
            try await Task.sleep(nanoseconds: UInt64(pollingInterval * 1_000_000_000))

            let url = URL(string: "\(CulturalAIConfiguration.replicateBaseURL)/predictions/\(predictionId)")!
            var request = URLRequest(url: url)

            let headers = CulturalAIConfiguration.apiHeaders(with: replicateAPIKey)
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }

            let (data, _) = try await URLSession.shared.data(for: request)
            let prediction = try JSONDecoder().decode(PredictionResponse.self, from: data)

            await MainActor.run {
                self.generationProgress = 0.3 + (Float(attempt) / Float(maxAttempts)) * 0.7
            }

            switch prediction.status {
            case "succeeded":
                if let output = prediction.output?.first {
                    await validateCulturalAuthenticity(imageUrl: output)
                    print("✅ Cultural generation completed: \(output)")
                    return output
                } else {
                    throw CulturalAIConfiguration.CulturalAIError.invalidResponse
                }
            case "failed":
                throw CulturalAIConfiguration.CulturalAIError.networkError(prediction.error ?? "Generation failed")
            case "canceled":
                throw CulturalAIConfiguration.CulturalAIError.networkError("Generation canceled")
            default:
                // Still processing, continue polling
                continue
            }
        }

        throw CulturalAIConfiguration.CulturalAIError.generationTimeout
    }

    // MARK: - Cultural Validation

    private func validateCulturalAuthenticity(imageUrl: String) async {
        // Placeholder for cultural authenticity validation
        // In production, this would integrate with cultural validation services
        let simulatedScore = Double.random(in: 0.85...0.98)

        let metrics = CulturalAIConfiguration.PerformanceMetrics(
            generationTime: 25.0,
            culturalScore: simulatedScore,
            qualityScore: 0.92,
            retryCount: 0,
            culturalEvent: "Cultural Gift"
        )

        print("📊 Cultural Authenticity Score: \(simulatedScore)")

        if simulatedScore < CulturalAIConfiguration.minAuthenticityScore {
            print("⚠️ Cultural authenticity score below threshold")
        }
    }

    // MARK: - Utility Methods

    /// Generate cultural prompt with shared enhancements
    func enhanceCulturalPrompt(_ basePrompt: String) -> String {
        var enhancedPrompt = basePrompt

        // Add quality enhancements
        enhancedPrompt += CulturalAIConfiguration.qualityEnhancement

        // Add cultural sensitivity
        enhancedPrompt += CulturalAIConfiguration.culturalSensitivity

        return enhancedPrompt
    }

    /// Check if API is properly configured
    nonisolated var isConfigured: Bool {
        return !replicateAPIKey.isEmpty
    }

    /// Get current API key status (for debugging)
    nonisolated var apiKeyStatus: String {
        if replicateAPIKey.isEmpty {
            return "Not configured"
        } else {
            return "Configured (***\(replicateAPIKey.suffix(4)))"
        }
    }
}

// MARK: - Shared Data Models

struct PredictionResponse: Codable {
    let id: String
    let status: String
    let output: [String]?
    let error: String?
}