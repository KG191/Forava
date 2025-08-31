import Foundation
import SwiftUI
import Combine

// MARK: - AI Rakhi Generation Service (Cultural Framework Enabled)
@MainActor
class AIRakhiService: ObservableObject {
    static let shared = AIRakhiService()

    @Published var isGenerating = false
    @Published var generationProgress: Float = 0.0
    @Published var generatedRakhi: GeneratedRakhi?
    @Published var error: AIServiceError?

    // Replicate API configuration
    private let replicateBaseURL = "https://api.replicate.com/v1"
    private let replicateAPIKey: String
    private let culturalModel = "stability-ai/sdxl:39ed52f2a78e934b3ba6e2a89f5b1c712de7dfea535525255b1aa35c5565e08b"
    private let defaultModel = "stability-ai/sdxl:39ed52f2a78e934b3ba6e2a89f5b1c712de7dfea535525255b1aa35c5565e08b"

    // Demo mode - when true, uses mock generation instead of real API
    private let useMockGeneration = false

    // Cultural framework integration
    private let culturalAIService = CulturalAIService.shared
    private let culturalConfig = CulturalConfiguration.shared

    private var cancellables = Set<AnyCancellable>()

    private init() {
        // Load Replicate API key - iOS app sandbox compatible approach
        print("🔑 Loading Replicate API key...")

        // Method 1: Try environment variable first (set in Xcode scheme)
        if let envVar = ProcessInfo.processInfo.environment["REPLICATE_API_TOKEN"] {
            self.replicateAPIKey = envVar
            print("✅ API key loaded from environment variable")
            return
        }

        // Method 2: Try app bundle .env file (if added to Xcode project)
        if let envPath = Bundle.main.path(forResource: ".env", ofType: nil) {
            print("📁 Found .env in bundle at: \(envPath)")
            do {
                let envContent = try String(contentsOfFile: envPath)
                let lines = envContent.components(separatedBy: .newlines)

                for line in lines {
                    let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
                    if trimmed.hasPrefix("REPLICATE_API_TOKEN=") {
                        let value = String(trimmed.dropFirst("REPLICATE_API_TOKEN=".count))
                        self.replicateAPIKey = value.trimmingCharacters(in: .whitespacesAndNewlines)
                        print("✅ API key loaded from .env file")
                        return
                    }
                }
            } catch {
                print("⚠️ Error reading .env file: \(error)")
            }
        }

        // Method 3: Fallback to placeholder (will cause demo mode)
        print("⚠️ No Replicate API key found. Using demo mode.")
        self.replicateAPIKey = ""

        print("📝 Setup instructions:")
        print("1. Get your API key from https://replicate.com/account/api-tokens")
        print("2. Add REPLICATE_API_TOKEN to your Xcode environment variables")
        print("3. Or add a .env file to your project bundle with REPLICATE_API_TOKEN=your_key_here")
        print("4. Restart the app to apply changes")
        print("")
    }

    // MARK: - Public Interface

    func clearGeneratedRakhi() {
        generatedRakhi = nil
        error = nil
        print("[DEBUG] Cleared generated rakhi and error state")
    }

    func generateRakhi(from designSpec: RakhiDesignSpec) async throws -> GeneratedRakhi {
        print("[AIRakhiService] Starting generation for design: \(designSpec.id) - Using cultural framework")

        guard !isGenerating else {
            throw AIServiceError.alreadyGenerating
        }

        // Initialize cultural framework if needed
        if !culturalConfig.isInitialized {
            await culturalConfig.initialize()
        }

        isGenerating = true
        generationProgress = 0.0
        error = nil

        defer {
            isGenerating = false
            generationProgress = 0.0
        }

        do {
            // Use cultural AI service for generation with legacy compatibility
            print("[AIRakhiService] Delegating to cultural AI service...")
            let culturalRakhi = try await culturalAIService.generateRakhi(from: designSpec)

            generationProgress = 1.0
            self.generatedRakhi = culturalRakhi

            print("[AIRakhiService] Successfully generated rakhi via cultural framework with ID: \(culturalRakhi.id)")
            return culturalRakhi

        } catch {
            // Convert cultural errors back to legacy errors for compatibility
            if let culturalError = error as? CulturalAIServiceError {
                self.error = convertCulturalError(culturalError)
            } else {
                self.error = error as? AIServiceError ?? .unknownError
            }
            print("[AIRakhiService] Generation failed: \(error)")
            throw self.error ?? .unknownError
        }
    }

    // MARK: - Legacy Support Methods

    private func convertCulturalError(_ culturalError: CulturalAIServiceError) -> AIServiceError {
        switch culturalError {
        case .alreadyGenerating:
            return .alreadyGenerating
        case .invalidDesignSpec(let reason):
            return .invalidDesignSpec(reason)
        case .noImageGenerated:
            return .noImageGenerated
        case .generationFailed(let reason):
            return .generationFailed(reason)
        case .generationCanceled:
            return .generationCanceled
        case .timeout:
            return .timeout
        case .invalidURL:
            return .invalidURL
        case .invalidResponse:
            return .invalidResponse
        case .serverError(let error):
            return .serverError(error)
        default:
            return .unknownError
        }
    }

    // MARK: - Private Helpers

    private func calculateCulturalScore(_ designSpec: RakhiDesignSpec) -> Double {
        let genreWeight = designSpec.genre.culturalWeight
        let elementWeights = designSpec.elements.map { $0.culturalSignificance }
        let avgElementWeight = elementWeights.isEmpty ? 0.5 : elementWeights.reduce(0, +) / Double(elementWeights.count)

        return (genreWeight * 0.4) + (avgElementWeight * 0.6)
    }
}
