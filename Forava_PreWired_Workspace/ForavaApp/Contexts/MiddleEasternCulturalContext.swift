import Foundation
import SwiftUI

// MARK: - Middle Eastern Cultural Context Implementation
struct MiddleEasternCulturalContext: CulturalContext {
    let identifier = "middle_eastern_traditional"
    let displayName = "Middle Eastern Traditional"
    let description = "Traditional Middle Eastern arts and gifts - geometric beauty, hospitality, and spiritual harmony"
    let primaryLanguage = "ar"
    let supportedLanguages = ["ar", "fa", "ur", "tr", "en"]

    // MARK: - Core Cultural Elements

    var genres: [CulturalGenre] {
        return [
            CulturalGenre(
                id: "traditional",
                displayName: "Traditional",
                icon: "star.and.crescent.fill",
                basePrompt: "traditional Middle Eastern art, Islamic geometric patterns, arabesques, classical design",
                culturalWeight: 1.0,
                suggestedElementIds: ["geometric_patterns", "arabesque_motifs", "calligraphy_elements", "star_patterns"],
                culturalContext: identifier
            ),
            CulturalGenre(
                id: "geometric",
                displayName: "Geometric",
                icon: "hexagon.fill",
                basePrompt: "Islamic geometric art, mathematical patterns, tessellations, sacred geometry",
                culturalWeight: 0.95,
                suggestedElementIds: ["star_polygons", "tessellation_patterns", "geometric_borders"],
                culturalContext: identifier
            ),
            CulturalGenre(
                id: "ornamental",
                displayName: "Ornamental",
                icon: "sparkles",
                basePrompt: "ornate Middle Eastern decoration, intricate details, luxurious ornamentation",
                culturalWeight: 0.9,
                suggestedElementIds: ["arabesque_motifs", "floral_patterns", "decorative_borders", "precious_elements"],
                culturalContext: identifier
            ),
            CulturalGenre(
                id: "spiritual",
                displayName: "Spiritual",
                icon: "moon.stars.fill",
                basePrompt: "spiritual Islamic art, meditative patterns, divine geometry, peaceful design",
                culturalWeight: 0.85,
                suggestedElementIds: ["crescent_moon", "star_patterns", "prayer_motifs", "peaceful_elements"],
                culturalContext: identifier
            )
        ]
    }

    var colorPalettes: [CulturalColorPalette] {
        return [
            CulturalColorPalette(
                id: "traditional",
                displayName: "Traditional Islamic",
                colors: [
                    CulturalColor(name: "Deep Blue", hex: "003366", symbolism: "Infinity and divine wisdom"),
                    CulturalColor(name: "Golden Yellow", hex: "FFD700", symbolism: "Divine light and prosperity"),
                    CulturalColor(name: "Emerald Green", hex: "50C878", symbolism: "Paradise and nature"),
                    CulturalColor(name: "Burgundy Red", hex: "800020", symbolism: "Strength and nobility")
                ],
                promptTokens: ["Islamic colors", "traditional Middle Eastern", "deep blue", "gold", "emerald", "rich colors"],
                culturalContext: identifier,
                culturalSignificance: 1.0
            ),
            CulturalColorPalette(
                id: "desert",
                displayName: "Desert Sands",
                colors: [
                    CulturalColor(name: "Sand Beige", hex: "F4A460", symbolism: "Desert beauty and endurance"),
                    CulturalColor(name: "Terracotta", hex: "E2725B", symbolism: "Earth connection and warmth"),
                    CulturalColor(name: "Sunset Orange", hex: "FF8C69", symbolism: "Desert sunset and hospitality"),
                    CulturalColor(name: "Oasis Teal", hex: "008B8B", symbolism: "Life-giving water and hope")
                ],
                promptTokens: ["desert colors", "sand tones", "earth palette", "natural Middle Eastern colors"],
                culturalContext: identifier,
                culturalSignificance: 0.9
            ),
            CulturalColorPalette(
                id: "royal",
                displayName: "Royal Palace",
                colors: [
                    CulturalColor(name: "Royal Purple", hex: "663399", symbolism: "Nobility and wisdom"),
                    CulturalColor(name: "Palace Gold", hex: "DAA520", symbolism: "Wealth and divine favor"),
                    CulturalColor(name: "Sapphire Blue", hex: "0F52BA", symbolism: "Truth and divine connection"),
                    CulturalColor(name: "Pearl White", hex: "F8F6F0", symbolism: "Purity and perfection")
                ],
                promptTokens: ["royal colors", "luxurious palette", "palace decoration", "precious stone colors"],
                culturalContext: identifier,
                culturalSignificance: 0.85
            )
        ]
    }

    var designElements: [CulturalDesignElement] {
        return [
            // Geometric Patterns
            CulturalDesignElement(
                id: "geometric_patterns",
                displayName: "Islamic Geometric Patterns",
                category: CulturalElementCategory(id: "patterns", displayName: "Sacred Patterns", icon: "hexagon.fill", culturalContext: identifier),
                weight: 1.0,
                culturalSignificance: 1.0,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["traditional", "geometric", "spiritual"],
                promptTokens: ["Islamic geometry", "geometric patterns", "mathematical art", "sacred geometry"],
                culturalContext: identifier,
                description: "Traditional Islamic geometric patterns representing divine order and unity"
            ),
            CulturalDesignElement(
                id: "star_polygons",
                displayName: "Star Polygons",
                category: CulturalElementCategory(id: "patterns", displayName: "Sacred Patterns", icon: "star.fill", culturalContext: identifier),
                weight: 0.9,
                culturalSignificance: 0.95,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["geometric", "traditional", "spiritual"],
                promptTokens: ["star patterns", "Islamic stars", "polygon patterns", "stellar geometry"],
                culturalContext: identifier,
                description: "Traditional star polygon patterns symbolizing divine guidance"
            ),
            CulturalDesignElement(
                id: "arabesque_motifs",
                displayName: "Arabesque Motifs",
                category: CulturalElementCategory(id: "decorative", displayName: "Decorative Elements", icon: "leaf.fill", culturalContext: identifier),
                weight: 0.9,
                culturalSignificance: 0.9,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["traditional", "ornamental"],
                promptTokens: ["arabesque", "floral patterns", "vine motifs", "organic decoration"],
                culturalContext: identifier,
                description: "Flowing arabesque patterns inspired by nature and divine creation"
            ),

            // Calligraphy Elements
            CulturalDesignElement(
                id: "calligraphy_elements",
                displayName: "Arabic Calligraphy",
                category: CulturalElementCategory(id: "artistic", displayName: "Sacred Arts", icon: "pencil", culturalContext: identifier),
                weight: 0.95,
                culturalSignificance: 1.0,
                ageAppropriate: [ageGroups[1], ageGroups[2], ageGroups[3]], // adult, elder, any
                compatibleGenreIds: ["traditional", "spiritual"],
                promptTokens: ["Arabic calligraphy", "Islamic calligraphy", "sacred writing", "beautiful script"],
                culturalContext: identifier,
                description: "Sacred Arabic calligraphy representing divine beauty and wisdom"
            ),
            CulturalDesignElement(
                id: "bismillah_script",
                displayName: "Bismillah Script",
                category: CulturalElementCategory(id: "artistic", displayName: "Sacred Arts", icon: "pencil", culturalContext: identifier),
                weight: 1.0,
                culturalSignificance: 1.0,
                ageAppropriate: [ageGroups[1], ageGroups[2], ageGroups[3]], // adult, elder, any
                compatibleGenreIds: ["traditional", "spiritual"],
                promptTokens: ["Bismillah", "sacred calligraphy", "Islamic blessing", "divine invocation"],
                culturalContext: identifier,
                description: "Bismillah calligraphy - the sacred invocation beginning with God's name"
            ),

            // Symbolic Elements
            CulturalDesignElement(
                id: "crescent_moon",
                displayName: "Crescent Moon",
                category: CulturalElementCategory(id: "symbols", displayName: "Sacred Symbols", icon: "moon.fill", culturalContext: identifier),
                weight: 0.8,
                culturalSignificance: 0.9,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["traditional", "spiritual"],
                promptTokens: ["crescent moon", "Islamic symbol", "lunar crescent", "celestial symbol"],
                culturalContext: identifier,
                description: "Crescent moon symbolizing Islamic faith and lunar calendar"
            ),
            CulturalDesignElement(
                id: "hamsa_hand",
                displayName: "Hamsa Hand",
                category: CulturalElementCategory(id: "symbols", displayName: "Sacred Symbols", icon: "hand.raised.fill", culturalContext: identifier),
                weight: 0.8,
                culturalSignificance: 0.85,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["traditional", "ornamental"],
                promptTokens: ["hamsa hand", "hand of Fatima", "protective symbol", "blessing hand"],
                culturalContext: identifier,
                description: "Hamsa hand symbolizing protection, blessings, and good fortune"
            ),

            // Architectural Elements
            CulturalDesignElement(
                id: "mosque_dome",
                displayName: "Mosque Dome",
                category: CulturalElementCategory(id: "architectural", displayName: "Sacred Architecture", icon: "building.columns.fill", culturalContext: identifier),
                weight: 0.7,
                culturalSignificance: 0.8,
                ageAppropriate: [ageGroups[1], ageGroups[2], ageGroups[3]], // adult, elder, any
                compatibleGenreIds: ["traditional", "spiritual"],
                promptTokens: ["mosque dome", "Islamic architecture", "sacred dome", "architectural beauty"],
                culturalContext: identifier,
                description: "Traditional mosque dome representing divine protection and unity"
            ),
            CulturalDesignElement(
                id: "minaret_tower",
                displayName: "Minaret Tower",
                category: CulturalElementCategory(id: "architectural", displayName: "Sacred Architecture", icon: "building.columns.fill", culturalContext: identifier),
                weight: 0.7,
                culturalSignificance: 0.8,
                ageAppropriate: [ageGroups[1], ageGroups[2], ageGroups[3]], // adult, elder, any
                compatibleGenreIds: ["traditional", "spiritual"],
                promptTokens: ["minaret", "Islamic tower", "call to prayer", "sacred tower"],
                culturalContext: identifier,
                description: "Minaret tower symbolizing the call to prayer and spiritual ascension"
            ),

            // Decorative Elements
            CulturalDesignElement(
                id: "precious_elements",
                displayName: "Precious Jewels",
                category: CulturalElementCategory(id: "decorative", displayName: "Decorative Elements", icon: "diamond.fill", culturalContext: identifier),
                weight: 0.6,
                culturalSignificance: 0.7,
                ageAppropriate: [ageGroups[1], ageGroups[2], ageGroups[3]], // adult, elder, any
                compatibleGenreIds: ["ornamental", "royal"],
                promptTokens: ["precious stones", "jewels", "ornate decoration", "luxury elements"],
                culturalContext: identifier,
                description: "Precious elements representing divine beauty and earthly abundance"
            )
        ]
    }

    var ageGroups: [CulturalAgeGroup] {
        return [
            CulturalAgeGroup(
                id: "young",
                displayName: "Young",
                ageRange: "5-18 years",
                preferences: ["colorful", "simple patterns", "playful geometry", "bright colors", "educational"],
                culturalContext: identifier
            ),
            CulturalAgeGroup(
                id: "adult",
                displayName: "Adult",
                ageRange: "18-50 years",
                preferences: ["sophisticated", "meaningful", "balanced", "elegant patterns", "traditional"],
                culturalContext: identifier
            ),
            CulturalAgeGroup(
                id: "elder",
                displayName: "Elder",
                ageRange: "50+ years",
                preferences: ["traditional", "respectful", "classical", "dignified", "spiritual"],
                culturalContext: identifier
            ),
            CulturalAgeGroup(
                id: "any",
                displayName: "Any Age",
                ageRange: "All ages",
                preferences: ["universal", "timeless", "harmonious", "appropriate", "blessed"],
                culturalContext: identifier
            )
        ]
    }

    // MARK: - AI Generation Parameters

    var basePromptEnhancers: [String] {
        return [
            "Islamic traditional art",
            "Middle Eastern heritage",
            "geometric harmony",
            "sacred patterns",
            "cultural authenticity",
            "divine geometry",
            "handcrafted traditional art",
            "centered composition",
            "isolated on clean background",
            "masterpiece quality",
            "best quality",
            "ultra detailed",
            "professional photography",
            "perfect lighting",
            "sharp focus",
            "spiritual beauty",
            "ornate details"
        ]
    }

    var culturalNegativePrompts: [String] {
        return [
            "not Western",
            "not Far Eastern",
            "no inappropriate cultural mixing",
            "no incorrect symbols",
            "no disrespectful elements",
            "no modern technology",
            "no inappropriate religious symbols",
            "no offensive content",
            "no human figures in religious context",
            "no inappropriate Islamic symbols",
            "blurry",
            "low quality",
            "distorted",
            "nsfw",
            "inappropriate cultural representation"
        ]
    }

    var preferredAIModel: String {
        return "stability-ai/stable-diffusion-xl"
    }

    // MARK: - Validation and Animation

    var validator: CulturalValidator {
        return MiddleEasternCulturalValidator()
    }

    var animationStyle: CulturalAnimationStyle {
        return CulturalAnimationStyle(
            primaryStyle: "geometric-flowing",
            duration: 2.8,
            effects: ["geometric_reveal", "golden_glow", "pattern_cascade", "spiritual_shimmer"],
            culturalElements: ["geometric_particles", "golden_light", "pattern_waves"]
        )
    }
}

// MARK: - Middle Eastern Cultural Validator
class MiddleEasternCulturalValidator: CulturalValidator, CulturalValidatorProtocol {

    private let inappropriateElements: Set<String> = [
        // Elements that are not appropriate for Middle Eastern cultural context
        // This would be populated based on cultural and religious expert consultation
    ]

    private let sensitiveElements: Set<String> = [
        "bismillah_script",
        "crescent_moon",
        "calligraphy_elements",
        "geometric_patterns"
    ]

    func validateDesignSpec(_ spec: CulturalDesignSpec) -> CulturalValidationResult {
        var warnings: [String] = []
        var errors: [String] = []
        var recommendations: [String] = []

        // Validate cultural context
        guard spec.culturalContext == "middle_eastern_traditional" else {
            errors.append("Invalid cultural context for Middle Eastern validation")
            return CulturalValidationResult(isValid: false, errors: errors)
        }

        // Validate elements
        for element in spec.elements {
            if inappropriateElements.contains(element.id) {
                errors.append("Element '\(element.displayName)' is culturally inappropriate for Middle Eastern context")
            } else if sensitiveElements.contains(element.id) {
                warnings.append("Element '\(element.displayName)' has high cultural significance - ensure respectful representation")
            }
        }

        // Check age appropriateness
        let inappropriateElements = spec.elements.filter { element in
            !element.ageAppropriate.contains { $0.id == spec.targetAgeGroup.id || $0.id == "any" }
        }

        for element in inappropriateElements {
            warnings.append("Element '\(element.displayName)' may not be suitable for \(spec.targetAgeGroup.displayName)")
        }

        // Middle Eastern-specific recommendations
        if spec.elements.isEmpty {
            recommendations.append("Consider adding traditional geometric patterns or arabesque motifs")
        }

        if !spec.elements.contains(where: { $0.category.id == "patterns" }) {
            recommendations.append("Adding geometric patterns enhances traditional Middle Eastern aesthetics")
        }

        // Check for balance in elements
        let religiousElements = spec.elements.filter { $0.category.id == "artistic" && $0.culturalSignificance > 0.9 }
        if religiousElements.count > 2 {
            warnings.append("Consider balancing sacred elements with decorative ones for broader appeal")
        }

        // Check color palette cultural alignment
        if spec.colorPalette.id == "desert" && spec.genre.id == "royal" {
            recommendations.append("Consider royal palace colors to better match the ornate genre")
        }

        let culturalScore = calculateCulturalScore(spec)
        if culturalScore < 0.7 {
            recommendations.append("Consider adding more traditional Middle Eastern elements to increase authenticity")
        }

        return CulturalValidationResult(
            isValid: errors.isEmpty,
            warnings: warnings,
            errors: errors,
            culturalScore: culturalScore,
            recommendations: recommendations
        )
    }

    func isAppropriate(_ element: CulturalDesignElement, for context: CulturalContext) -> Bool {
        return !inappropriateElements.contains(element.id)
    }

    func getCulturalScore(for spec: CulturalDesignSpec, in context: CulturalContext) -> Double {
        return calculateCulturalScore(spec)
    }

    func getRecommendations(for spec: CulturalDesignSpec, in context: CulturalContext) -> [String] {
        return validateDesignSpec(spec).recommendations
    }

    private func calculateCulturalScore(_ spec: CulturalDesignSpec) -> Double {
        let genreScore = spec.genre.culturalWeight
        let elementScores = spec.elements.map { $0.culturalSignificance }
        let avgElementScore = elementScores.isEmpty ? 0.5 : elementScores.reduce(0, +) / Double(elementScores.count)
        let paletteScore = spec.colorPalette.culturalSignificance

        // Middle Eastern scoring emphasizes geometric patterns and traditional elements
        let geometricElements = spec.elements.filter { $0.category.id == "patterns" }
        let geometricBonus = geometricElements.isEmpty ? 0.0 : 0.15

        // Bonus for appropriate balance of elements
        let balanceBonus = spec.elements.count >= 2 && spec.elements.count <= 4 ? 0.1 : 0.0

        return (genreScore * 0.25) + (avgElementScore * 0.4) + (paletteScore * 0.2) + geometricBonus + balanceBonus
    }
}

// MARK: - Context Registration
extension MiddleEasternCulturalContext {
    static func register() {
        Task { @MainActor in
            CulturalContextManager.shared.registerContext(MiddleEasternCulturalContext())
        }
    }
}
