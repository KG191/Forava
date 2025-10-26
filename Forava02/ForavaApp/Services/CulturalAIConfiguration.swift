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

    /// Base prompt structure - OPTIMIZED FOR SDXL (front-to-back processing)
    /// Critical requirements FIRST, atmospheric details LAST
    /// Combines rich descriptive guidance with SDXL weight syntax for optimal results
    static let culturalPromptTemplate = """
        CRITICAL REQUIREMENTS - Create an exquisite [CULTURAL_EVENT] celebration design:

        ═══════════════════════════════════════════════════════════════════════════════
        1. COLOR PALETTE MANDATE (NON-NEGOTIABLE - HIGHEST PRIORITY):
        ═══════════════════════════════════════════════════════════════════════════════

        PRIMARY COLOR: [PRIMARY_COLOR_SIMPLE] - Use for central focal elements (approximately 70% dominance)
        SECONDARY COLOR: [SECONDARY_COLOR_SIMPLE] - Use for supporting decorative elements (approximately 20%)
        ACCENT COLOR: [ACCENT_COLOR_SIMPLE] - Use for highlights and refined details (approximately 10%)

        ABSOLUTELY REQUIRED: Use ONLY these three colors - do not introduce any other colors whatsoever.
        STRICTLY FORBIDDEN: Adding colors outside this palette, rainbow effects, or multicolored elements.
        The color palette is NON-NEGOTIABLE and must be strictly followed throughout the entire composition.

        ═══════════════════════════════════════════════════════════════════════════════
        2. MANDATORY CENTERPIECE ELEMENT (MUST APPEAR PROMINENTLY):
        ═══════════════════════════════════════════════════════════════════════════════

        [CENTRE_ELEMENTS]

        THIS ELEMENT IS ABSOLUTELY MANDATORY - IT MUST APPEAR PROMINENTLY as the dominant visual focus.
        This centerpiece should be the primary focal point with refined details, elegant presentation,
        and sophisticated artistic rendering. Ensure clear, unmistakable, PROMINENT presence.

        ═══════════════════════════════════════════════════════════════════════════════
        3. ARTISTIC THEME & VISUAL STYLE:
        ═══════════════════════════════════════════════════════════════════════════════

        [THEME_STYLE]

        Create this design with professional quality, refined elegance, and sophisticated visual harmony.
        Use graceful composition, balanced visual hierarchy, and exquisite attention to decorative details.

        ═══════════════════════════════════════════════════════════════════════════════
        4. ATMOSPHERIC BACKGROUND & EMOTIONAL CONTEXT:
        ═══════════════════════════════════════════════════════════════════════════════

        Background atmosphere: [BACKGROUND_ATMOSPHERE]
        Emotional expression: [EMOTIONAL_CONTEXT]

        The overall composition should evoke appropriate emotional resonance through visual elements,
        lighting effects, and atmospheric depth, creating a memorable and meaningful design.

        ═══════════════════════════════════════════════════════════════════════════════
        5. SUPPORTING DECORATIVE ELEMENTS (complementary accents):
        ═══════════════════════════════════════════════════════════════════════════════

        [SUPPORTING_ELEMENTS]

        These elements add graceful embellishment and refined decorative harmony,
        complementing the central elements with elegant visual balance.

        ═══════════════════════════════════════════════════════════════════════════════
        CRITICAL ARTISTIC DIRECTIVES:
        ═══════════════════════════════════════════════════════════════════════════════

        ✓ CREATE: Harmonious color coordination using ONLY the three specified colors - NO EXCEPTIONS
        ✓ CREATE: The specified centerpiece element MUST be clearly visible and prominent
        ✓ CREATE: Professional quality with exquisite details and refined artistic execution
        ✓ CREATE: Sophisticated visual hierarchy with balanced composition and elegant proportions
        ✓ CREATE: Exquisite but refined composition - avoid excessive ornamentation
        ✓ CREATE: Sophisticated elegance with restraint - not overly busy or cluttered

        ✗ AVOID: Colors outside the specified three-color palette - ABSOLUTELY FORBIDDEN
        ✗ AVOID: Missing or obscured centerpiece element - MUST BE CLEARLY VISIBLE
        ✗ AVOID: Text, words, letters, numbers, typography, or any readable characters
        ✗ AVOID: Generic or simplistic execution - aim for refined, exquisite quality
        ✗ AVOID: Excessive decoration, overly busy compositions, or cluttered designs
        ✗ AVOID: Elements not specified by the user

        Generate decorative patterns, elegant shapes, and sophisticated abstract visual elements
        that create a memorable, professional, and artistically beautiful composition with refined restraint.
        """

    /// Base negative prompt - explicitly forbidden elements for SDXL (industry-standard technique)
    /// Includes NSFW safety terms to prevent false positives from content filter
    static let baseNegativePrompt = "text, words, letters, writing, typography, calligraphy, numbers, alphabet, script, handwriting, printed text, captions, labels, titles, messages, quotes, sayings, greetings, card text, watermarks, signatures, readable characters, nsfw, nudity, explicit, sexual, inappropriate, adult content, suggestive, provocative, revealing"

    /// All possible colors for exclusion (comprehensive list of common SDXL-understood colors)
    private static let allKnownColors = [
        "red", "blue", "green", "yellow", "orange", "purple", "pink", "brown",
        "black", "white", "gray", "grey", "silver", "gold", "bronze", "copper",
        "cyan", "magenta", "lime", "navy", "teal", "aqua", "maroon", "olive",
        "coral", "salmon", "peach", "lavender", "violet", "indigo", "turquoise",
        "mint", "emerald", "jade", "ruby", "sapphire", "amber", "ivory", "cream",
        "beige", "tan", "burgundy", "crimson", "scarlet", "rose", "fuchsia",
        "plum", "periwinkle", "chartreuse", "mauve", "taupe", "khaki", "steel"
    ]

    /// Generate color-exclusion negative prompt - forbids ALL colors except the selected 3
    static func colorExclusionNegativePrompt(
        allowedPrimary: String,
        allowedSecondary: String,
        allowedAccent: String
    ) -> String {
        // Normalize to lowercase for comparison
        let allowed = Set([
            allowedPrimary.lowercased(),
            allowedSecondary.lowercased(),
            allowedAccent.lowercased()
        ])

        // Filter out allowed colors and create forbidden list
        let forbiddenColors = allKnownColors.filter { !allowed.contains($0.lowercased()) }

        // Build comprehensive negative prompt
        var negativePrompt = baseNegativePrompt
        negativePrompt += ", wrong colors, off-palette colors, unspecified colors, rainbow, multicolored"
        negativePrompt += ", " + forbiddenColors.joined(separator: ", ")

        return negativePrompt
    }

    /// Legacy negative prompt (for backward compatibility)
    static let negativePrompt = baseNegativePrompt + ", wrong colors, off-palette colors, unspecified colors, rainbow, excessive colors, multicolored chaos, overly busy, excessive decoration, cluttered composition, too many elements, extra elements not requested"

    /// Quality enhancement suffix for all prompts
    static let qualityEnhancement = ", masterpiece, best quality, highly detailed, professional digital art, pure decorative patterns, abstract visual elements only"

    /// Cultural sensitivity suffix for all prompts
    static let culturalSensitivity = ", respectful cultural representation, authentic traditional elements"

    /// No text enforcement suffix - aggressive agent directives
    static let noTextEnforcement = ", YOU MUST NEVER INCLUDE: any text OR words OR letters OR numbers OR symbols OR writing OR typography OR calligraphy OR readable characters of any kind, ONLY decorative patterns and abstract shapes"

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
