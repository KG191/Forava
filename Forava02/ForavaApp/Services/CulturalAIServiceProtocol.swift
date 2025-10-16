import Foundation
import SwiftUI

/// Protocol defining the standard interface for all cultural AI services
/// Ensures consistency across Anniversary, Diwali, Christmas, and other cultural events
protocol CulturalAIServiceProtocol: AnyObject, ObservableObject {

    // MARK: - Published Properties

    /// Indicates whether AI generation is currently in progress
    var isGenerating: Bool { get set }

    /// Current generation progress (0.0 to 1.0)
    var generationProgress: Float { get set }

    /// Any error that occurred during generation
    var error: CulturalAIConfiguration.CulturalAIError? { get set }

    // MARK: - Core Generation Methods

    /// Generate a cultural gift image based on the provided specifications
    /// - Parameters:
    ///   - culturalTheme: The theme specific to the cultural event
    ///   - elements: Array of cultural design elements
    ///   - colorPalette: Color scheme for the cultural design
    ///   - personalMessage: Personal message to incorporate
    ///   - recipientName: Name of the gift recipient
    /// - Returns: URL string of the generated image
    /// - Throws: CulturalAIError for various failure scenarios
    func generateCulturalGift(
        culturalTheme: Any,
        elements: [Any],
        colorPalette: Any,
        personalMessage: String,
        recipientName: String
    ) async throws -> String

    /// Create a culturally appropriate AI prompt from design specifications
    /// - Parameter designSpec: The complete design specification
    /// - Returns: AI prompt string optimized for cultural authenticity
    func createCulturalPrompt(from designSpec: Any) -> String

    /// Validate the cultural appropriateness of generated content
    /// - Parameter imageUrl: URL of the generated image
    /// - Returns: Cultural authenticity score (0.0 to 1.0)
    func validateCulturalContent(imageUrl: String) async -> Double

    /// Get available cultural themes for this event type
    /// - Returns: Array of cultural themes
    func getCulturalThemes() -> [Any]

    /// Get available design elements for this cultural event
    /// - Returns: Array of cultural design elements
    func getCulturalElements() -> [Any]

    /// Get available color palettes for this cultural event
    /// - Returns: Array of cultural color palettes
    func getCulturalColorPalettes() -> [Any]

    // MARK: - Configuration Methods

    /// Check if the service is properly configured with API keys
    /// - Returns: True if ready for generation
    var isConfigured: Bool { get }

    /// Get the current API key status for debugging
    /// - Returns: Configuration status string
    var apiKeyStatus: String { get }

    // MARK: - Cultural Context Methods

    /// Get the cultural event type this service handles
    /// - Returns: String identifier for the cultural event
    var culturalEventType: String { get }

    /// Get cultural-specific prompt enhancements
    /// - Returns: Array of prompt modifiers for cultural authenticity
    func getCulturalPromptEnhancements() -> [String]

    /// Get quality requirements specific to this cultural event
    /// - Returns: Dictionary of quality metrics and thresholds
    func getCulturalQualityRequirements() -> [String: Double]
}

// MARK: - Cultural Event Types

/// Enumeration of supported cultural events
enum CulturalEventType: String, CaseIterable {
    case anniversary = "Anniversary"
    case rakshaBandhan = "Raksha Bandhan"
    case diwali = "Diwali"
    case christmas = "Christmas"
    case chineseNewYear = "Chinese New Year"
    case easter = "Easter"
    case eidAlFitr = "Eid al-Fitr"
    case eidAlAdha = "Eid al-Adha"
    case hanukkah = "Hanukkah"
    case midAutumnFestival = "Mid-Autumn Festival"
    case roshHashanah = "Rosh Hashanah"
    case vesakDay = "Vesak Day"
    case birthday = "Birthday"

    /// Cultural color associated with this event
    var culturalColor: Color {
        switch self {
        case .anniversary:
            return Color(hex: "#DC143C") // Crimson Red
        case .rakshaBandhan:
            return Color(hex: "#FF6B35") // Festival Orange
        case .diwali:
            return Color(hex: "#FF6B35") // Festival Orange
        case .christmas:
            return Color(hex: "#C41E3A") // Christmas Red
        case .chineseNewYear:
            return Color(hex: "#DC143C") // Crimson Red
        case .easter:
            return Color(hex: "#9C27B0") // Purple
        case .eidAlFitr:
            return Color(hex: "#4CAF50") // Green
        case .eidAlAdha:
            return Color(hex: "#4CAF50") // Green
        case .hanukkah:
            return Color(hex: "#1976D2") // Blue
        case .midAutumnFestival:
            return Color(hex: "#FF9800") // Orange
        case .roshHashanah:
            return Color(hex: "#9C27B0") // Purple
        case .vesakDay:
            return Color(hex: "#FFD700") // Gold
        case .birthday:
            return Color(hex: "#E91E63") // Pink
        }
    }

    /// Cultural authenticity requirements
    var authenticityThreshold: Double {
        switch self {
        case .rakshaBandhan, .diwali, .eidAlFitr, .eidAlAdha, .hanukkah, .roshHashanah, .vesakDay:
            return 0.90 // Higher threshold for religious/traditional events
        case .chineseNewYear, .midAutumnFestival:
            return 0.88 // High threshold for cultural celebrations
        case .christmas, .easter:
            return 0.85 // Moderate threshold for widely celebrated events
        case .anniversary, .birthday:
            return 0.80 // Standard threshold for personal celebrations
        }
    }
}

// MARK: - Default Protocol Implementations

extension CulturalAIServiceProtocol {

    /// Default implementation for cultural content validation
    func validateCulturalContent(imageUrl: String) async -> Double {
        // Simulate cultural validation
        // In production, this would integrate with actual validation services
        let baseScore = Double.random(in: 0.75...0.95)

        // Apply cultural event specific adjustments
        if let eventType = CulturalEventType(rawValue: culturalEventType) {
            let threshold = eventType.authenticityThreshold
            // Ensure scores meet cultural requirements
            return max(baseScore, threshold - 0.05)
        }

        return baseScore
    }

    /// Default cultural prompt enhancements
    func getCulturalPromptEnhancements() -> [String] {
        return [
            "culturally authentic",
            "respectful representation",
            "traditional elements",
            "appropriate symbolism",
            "high quality digital art"
        ]
    }

    /// Default quality requirements
    func getCulturalQualityRequirements() -> [String: Double] {
        if let eventType = CulturalEventType(rawValue: culturalEventType) {
            return [
                "cultural_authenticity": eventType.authenticityThreshold,
                "design_harmony": 0.85,
                "image_quality": 0.90,
                "color_appropriateness": 0.88
            ]
        }

        return [
            "cultural_authenticity": 0.80,
            "design_harmony": 0.85,
            "image_quality": 0.90,
            "color_appropriateness": 0.88
        ]
    }
}

// MARK: - Cultural Theme Protocol

/// Protocol for cultural themes to ensure consistency
protocol CulturalThemeProtocol {
    var name: String { get }
    var description: String { get }
    var culturalSignificance: String { get }
    var aiPromptModifier: String { get }
}

// MARK: - Cultural Element Protocol

/// Protocol for cultural design elements
protocol CulturalElementProtocol {
    var name: String { get }
    var category: String { get }
    var culturalMeaning: String { get }
    var aiPromptModifier: String { get }
    var priority: Int { get }
}

// MARK: - Cultural Color Palette Protocol

/// Protocol for cultural color palettes
protocol CulturalColorPaletteProtocol {
    var name: String { get }
    var primaryColor: String { get }
    var secondaryColor: String { get }
    var accentColor: String { get }
    var culturalMeaning: String { get }
    var backgroundHint: String { get }
}