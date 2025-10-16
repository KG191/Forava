import Foundation

/// Centralized configuration for all cultural AI services
/// Based on proven Anniversary implementation and Stability AI SDXL performance
struct CulturalAIConfiguration {

    // MARK: - Model Configuration

    /// Primary AI model for all cultural events (proven culturally appropriate)
    static let primaryModel = "stability-ai/sdxl:39ed52f2a78e934b3ba6e2a89f5b1c712de7dfea535225255b1aa35c5565e08b"

    /// Replicate API base URL
    static let replicateBaseURL = "https://api.replicate.com/v1"

    /// Predictions endpoint for image generation
    static let predictionsEndpoint = "\(replicateBaseURL)/predictions"

    // MARK: - Quality Settings

    /// Standard image dimensions for cultural artwork
    static let defaultWidth = 1024
    static let defaultHeight = 1024

    /// AI generation parameters optimized for cultural content
    static let inferenceSteps = 25
    static let guidanceScale = 7.5
    static let scheduler = "K_EULER_ANCESTRAL"

    // MARK: - Cultural Authenticity Standards

    /// Minimum cultural authenticity score required (0.0 - 1.0)
    static let minAuthenticityScore = 0.80

    /// Maximum time allowed for image generation
    static let maxGenerationTime: TimeInterval = 60.0

    /// Number of retry attempts for failed generations
    static let retryAttempts = 3

    /// Polling interval for checking generation status
    static let pollingInterval: TimeInterval = 2.0

    // MARK: - Cultural Quality Metrics

    /// Target quality scores for cultural validation
    struct QualityTargets {
        static let culturalAuthenticity = 0.92
        static let designHarmony = 0.88
        static let imageQuality = 0.95
    }

    // MARK: - API Configuration

    /// Headers for Replicate API requests
    static func apiHeaders(with apiKey: String) -> [String: String] {
        return [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json",
            "User-Agent": "Forava-iOS/1.0"
        ]
    }

    /// Standard model configuration dictionary
    static func modelConfiguration(
        prompt: String,
        width: Int = defaultWidth,
        height: Int = defaultHeight
    ) -> [String: Any] {
        return [
            "version": primaryModel,
            "input": [
                "prompt": prompt,
                "width": width,
                "height": height,
                "num_inference_steps": inferenceSteps,
                "guidance_scale": guidanceScale,
                "scheduler": scheduler,
                "apply_watermark": false,
                "high_noise_frac": 0.8
            ]
        ]
    }

    // MARK: - Cultural Prompt Standards

    /// Base prompt structure for cultural authenticity
    static let culturalPromptTemplate = """
        Create an elegant [CULTURAL_EVENT] celebration design in a [THEME_STYLE] style \
        with [CULTURAL_ELEMENTS] using a [COLOR_PALETTE] color scheme creating a \
        [BACKGROUND_ATMOSPHERE] expressing [EMOTIONAL_CONTEXT] suitable for [RECIPIENT_NAME], \
        high quality digital art, professional design suitable for both mobile phone \
        and smartwatch backgrounds, culturally sensitive and universally appropriate
        """

    /// Quality enhancement suffix for all prompts
    static let qualityEnhancement = ", masterpiece, best quality, highly detailed, professional digital art"

    /// Cultural sensitivity suffix for all prompts
    static let culturalSensitivity = ", respectful cultural representation, authentic traditional elements"

    // MARK: - Error Handling

    /// Standard error types for cultural AI generation
    enum CulturalAIError: LocalizedError {
        case apiKeyMissing
        case networkError(String)
        case generationTimeout
        case culturalValidationFailed(Double)
        case invalidResponse
        case quotaExceeded

        var errorDescription: String? {
            switch self {
            case .apiKeyMissing:
                return "API key not configured"
            case .networkError(let message):
                return "Network error: \(message)"
            case .generationTimeout:
                return "Generation timed out after \(maxGenerationTime) seconds"
            case .culturalValidationFailed(let score):
                return "Cultural authenticity too low: \(score) < \(minAuthenticityScore)"
            case .invalidResponse:
                return "Invalid API response"
            case .quotaExceeded:
                return "API quota exceeded"
            }
        }
    }

    // MARK: - Performance Monitoring

    /// Metrics for monitoring AI generation performance
    struct PerformanceMetrics {
        let generationTime: TimeInterval
        let culturalScore: Double
        let qualityScore: Double
        let retryCount: Int
        let culturalEvent: String

        var isSuccessful: Bool {
            return culturalScore >= minAuthenticityScore &&
                   generationTime <= maxGenerationTime
        }
    }
}