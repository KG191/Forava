import Foundation
import UIKit

/// Centralized configuration for all cultural AI services
/// Based on proven Anniversary implementation and Stability AI SDXL performance
struct CulturalAIConfiguration {

    // MARK: - Device Detection

    /// Round dimension to nearest multiple of 8 (required by SDXL model)
    private static func roundToMultipleOf8(_ value: Int) -> Int {
        return (value / 8) * 8  // Round down to nearest multiple of 8
    }

    /// Get optimal wallpaper dimensions for current device (rounded to multiples of 8)
    private static func getDeviceWallpaperDimensions() -> (width: Int, height: Int) {
        let screenSize = UIScreen.main.bounds.size
        let screenScale = UIScreen.main.scale
        let physicalWidth = screenSize.width * screenScale
        let physicalHeight = screenSize.height * screenScale

        let width = min(physicalWidth, physicalHeight)
        let height = max(physicalWidth, physicalHeight)

        // iPhone 16 Pro Max: 1320 x 2868 → 1320 x 2864
        if abs(width - 1320) < 10 && abs(height - 2868) < 10 {
            return (1320, 2864)
        }
        // iPhone 16 Pro: 1206 x 2622 → 1200 x 2616
        if abs(width - 1206) < 10 && abs(height - 2622) < 10 {
            return (1200, 2616)
        }
        // iPhone 16 Plus / 15 Pro Max / 14 Pro Max: 1290 x 2796 → 1288 x 2792
        if abs(width - 1290) < 10 && abs(height - 2796) < 10 {
            return (1288, 2792)
        }
        // iPhone 16 / 15 Pro / 14 Pro: 1179 x 2556 → 1176 x 2552
        if abs(width - 1179) < 10 && abs(height - 2556) < 10 {
            return (1176, 2552)
        }
        // iPhone 15 Plus / 14 Plus: 1284 x 2778 → 1280 x 2776
        if abs(width - 1284) < 10 && abs(height - 2778) < 10 {
            return (1280, 2776)
        }
        // iPhone 15 / 14 / SE: 1170 x 2532 → 1168 x 2528
        if abs(width - 1170) < 10 && abs(height - 2532) < 10 {
            return (1168, 2528)
        }
        // iPhone 13 mini: 1080 x 2340 → 1080 x 2336
        if abs(width - 1080) < 10 && abs(height - 2340) < 10 {
            return (1080, 2336)
        }

        // Default to iPhone 14/15 standard (rounded)
        return (1168, 2528)
    }

    // MARK: - Model Configuration

    /// Primary AI model for all cultural events (proven culturally appropriate)
    static let modelName = "stability-ai/sdxl"
    static let modelVersion = "39ed52f2a78e934b3ba6e2a89f5b1c712de7dfea535525255b1aa35c5565e08b"

    /// Replicate API base URL
    static let replicateBaseURL = "https://api.replicate.com/v1"

    /// Predictions endpoint for image generation
    static let predictionsEndpoint = "\(replicateBaseURL)/predictions"

    // MARK: - Quality Settings

    /// Standard image dimensions for cultural artwork (Apple Watch - always square)
    static let watchWidth = 1024
    static let watchHeight = 1024

    /// Device-specific iPhone dimensions (dynamically determined)
    static var iPhoneWidth: Int {
        return getDeviceWallpaperDimensions().width
    }

    static var iPhoneHeight: Int {
        return getDeviceWallpaperDimensions().height
    }

    /// Default dimensions (uses iPhone dimensions for primary generation)
    static var defaultWidth: Int {
        return iPhoneWidth
    }

    static var defaultHeight: Int {
        return iPhoneHeight
    }

    /// AI generation parameters optimized for cultural content
    static let inferenceSteps = 50  // Increased from 25 for better color/element refinement and artistic detail
    static let guidanceScale = 14.0  // Tuned for strict conformance while preserving artistic quality (17.0 too high, 13.0 too loose)
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

    /// Standard model configuration dictionary with negative prompt support
    static func modelConfiguration(
        prompt: String,
        negativePrompt: String = negativePrompt,
        width: Int = defaultWidth,
        height: Int = defaultHeight
    ) -> [String: Any] {
        return [
            "version": modelVersion,
            "input": [
                "prompt": prompt,
                "negative_prompt": negativePrompt,  // CRITICAL: Tells SDXL what NOT to generate
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

    /// SIMPLIFIED SDXL Prompt Template - Short, direct, concrete
    /// SDXL works MUCH better with brief, specific instructions
    static let culturalPromptTemplate = """
        Use ONLY these colors: [PRIMARY_COLOR_SIMPLE], [SECONDARY_COLOR_SIMPLE], [ACCENT_COLOR_SIMPLE]. No other colors.
        Central focus: [CENTRE_ELEMENTS]
        Style: [THEME_STYLE]. [BACKGROUND_ATMOSPHERE]. Professional quality.
        """

    /// Comprehensive negative prompt - MAXIMUM weights to block ALL human imagery (Apple compliance)
    static let baseNegativePrompt = "text, words, letters, nsfw, wrong colors, multiple centerpieces, (people:3.0), (person:3.0), (human:3.0), (man:2.8), (woman:2.8), (child:2.8), (face:3.0), (faces:3.0), (portrait:2.8), (statue:3.0), (sculpture:3.0), (bust:3.0), (figure:2.5), (body:2.5), (silhouette:2.5), (human form:2.8), (human shape:2.8), anatomy, arms, legs, hands, fingers"

    /// Simplified color-exclusion negative prompt
    static func colorExclusionNegativePrompt(
        allowedPrimary: String,
        allowedSecondary: String,
        allowedAccent: String
    ) -> String {
        return baseNegativePrompt + ", wrong colors"
    }

    /// Legacy negative prompt (for backward compatibility)
    static let negativePrompt = baseNegativePrompt

    /// Simplified quality enhancement
    static let qualityEnhancement = ", professional quality, detailed"

    /// Simplified cultural sensitivity
    static let culturalSensitivity = ""

    /// Simplified no text enforcement
    static let noTextEnforcement = ""

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
