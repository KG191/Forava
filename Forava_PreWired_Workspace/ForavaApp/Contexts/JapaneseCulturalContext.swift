import Foundation
import SwiftUI

// MARK: - Japanese Cultural Context Implementation
struct JapaneseCulturalContext: CulturalContext {
    let identifier = "japanese_traditional"
    let displayName = "Japanese Traditional"
    let description = "Traditional Japanese arts and ceremonial gifts - harmony, respect, and natural beauty"
    let primaryLanguage = "ja"
    let supportedLanguages = ["ja", "en", "ja-JP"]

    // MARK: - Core Cultural Elements

    var genres: [CulturalGenre] {
        return [
            CulturalGenre(
                id: "traditional",
                displayName: "Traditional (伝統的)",
                icon: "star.circle.fill",
                basePrompt: "traditional Japanese art, wa aesthetic, natural harmony, ceremonial elegance",
                culturalWeight: 1.0,
                suggestedElementIds: ["sakura_blossoms", "crane_motif", "bamboo_elements", "traditional_knots"],
                culturalContext: identifier
            ),
            CulturalGenre(
                id: "minimalist",
                displayName: "Minimalist (簡素)",
                icon: "circle",
                basePrompt: "Japanese minimalism, ma concept, negative space, subtle beauty, zen aesthetics",
                culturalWeight: 0.95,
                suggestedElementIds: ["zen_circles", "simple_lines", "natural_textures"],
                culturalContext: identifier
            ),
            CulturalGenre(
                id: "seasonal",
                displayName: "Seasonal (季節)",
                icon: "leaf.fill",
                basePrompt: "Japanese seasonal celebration, mono no aware, natural cycles, seasonal beauty",
                culturalWeight: 0.9,
                suggestedElementIds: ["seasonal_flowers", "autumn_leaves", "spring_elements", "winter_motifs"],
                culturalContext: identifier
            ),
            CulturalGenre(
                id: "ceremonial",
                displayName: "Ceremonial (儀式)",
                icon: "gift.fill",
                basePrompt: "Japanese ceremony tradition, formal presentation, respectful design, cultural protocol",
                culturalWeight: 0.85,
                suggestedElementIds: ["formal_wrapping", "ceremonial_knots", "traditional_colors"],
                culturalContext: identifier
            )
        ]
    }

    var colorPalettes: [CulturalColorPalette] {
        return [
            CulturalColorPalette(
                id: "traditional",
                displayName: "Traditional Japanese",
                colors: [
                    CulturalColor(name: "Sakura Pink", hex: "FFB7C5", symbolism: "Beauty and life's fleeting nature"),
                    CulturalColor(name: "Matcha Green", hex: "87A96B", symbolism: "Harmony and tranquility"),
                    CulturalColor(name: "Sumi Black", hex: "1C1C1C", symbolism: "Depth and sophistication"),
                    CulturalColor(name: "Washi White", hex: "F7F3E9", symbolism: "Purity and simplicity")
                ],
                promptTokens: ["traditional Japanese colors", "sakura pink", "matcha green", "sumi ink", "natural palette"],
                culturalContext: identifier,
                culturalSignificance: 1.0
            ),
            CulturalColorPalette(
                id: "seasonal",
                displayName: "Four Seasons",
                colors: [
                    CulturalColor(name: "Spring Cherry", hex: "F8BBD9", symbolism: "Spring renewal and hope"),
                    CulturalColor(name: "Summer Jade", hex: "7FB069", symbolism: "Summer vitality and growth"),
                    CulturalColor(name: "Autumn Maple", hex: "D2691E", symbolism: "Autumn wisdom and change"),
                    CulturalColor(name: "Winter Snow", hex: "F0F8FF", symbolism: "Winter purity and rest")
                ],
                promptTokens: ["seasonal colors", "four seasons", "natural cycles", "mono no aware"],
                culturalContext: identifier,
                culturalSignificance: 0.95
            ),
            CulturalColorPalette(
                id: "zen",
                displayName: "Zen Minimalism",
                colors: [
                    CulturalColor(name: "Stone Grey", hex: "A8A8A8", symbolism: "Balance and stability"),
                    CulturalColor(name: "Natural Beige", hex: "F5F5DC", symbolism: "Earth connection"),
                    CulturalColor(name: "Charcoal Black", hex: "36454F", symbolism: "Depth and meditation"),
                    CulturalColor(name: "Pure White", hex: "FFFFFF", symbolism: "Emptiness and potential")
                ],
                promptTokens: ["zen colors", "minimalist palette", "meditation colors", "natural tones"],
                culturalContext: identifier,
                culturalSignificance: 0.9
            )
        ]
    }

    var designElements: [CulturalDesignElement] {
        return [
            // Nature Elements
            CulturalDesignElement(
                id: "sakura_blossoms",
                displayName: "Sakura Blossoms (桜)",
                category: CulturalElementCategory(id: "nature", displayName: "Natural Elements", icon: "leaf.fill", culturalContext: identifier),
                weight: 1.0,
                culturalSignificance: 1.0,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["traditional", "seasonal", "ceremonial"],
                promptTokens: ["sakura blossoms", "cherry blossoms", "Japanese flowers", "spring beauty"],
                culturalContext: identifier,
                description: "Cherry blossoms symbolizing the beauty and transient nature of life"
            ),
            CulturalDesignElement(
                id: "crane_motif",
                displayName: "Crane (鶴)",
                category: CulturalElementCategory(id: "animals", displayName: "Sacred Animals", icon: "bird.fill", culturalContext: identifier),
                weight: 0.9,
                culturalSignificance: 1.0,
                ageAppropriate: [ageGroups[1], ageGroups[2], ageGroups[3]], // adult, elder, any
                compatibleGenreIds: ["traditional", "ceremonial"],
                promptTokens: ["Japanese crane", "tsuru", "longevity symbol", "peace bird"],
                culturalContext: identifier,
                description: "Crane representing longevity, good fortune, and peace"
            ),
            CulturalDesignElement(
                id: "bamboo_elements",
                displayName: "Bamboo (竹)",
                category: CulturalElementCategory(id: "nature", displayName: "Natural Elements", icon: "leaf.fill", culturalContext: identifier),
                weight: 0.8,
                culturalSignificance: 0.9,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["traditional", "minimalist", "zen"],
                promptTokens: ["bamboo", "take", "Japanese bamboo", "natural strength"],
                culturalContext: identifier,
                description: "Bamboo symbolizing flexibility, resilience, and growth"
            ),

            // Artistic Elements
            CulturalDesignElement(
                id: "zen_circles",
                displayName: "Enso Circle (円相)",
                category: CulturalElementCategory(id: "symbols", displayName: "Sacred Symbols", icon: "circle", culturalContext: identifier),
                weight: 0.9,
                culturalSignificance: 0.95,
                ageAppropriate: [ageGroups[1], ageGroups[2], ageGroups[3]], // adult, elder, any
                compatibleGenreIds: ["minimalist", "zen", "traditional"],
                promptTokens: ["enso circle", "zen circle", "Japanese calligraphy", "meditation symbol"],
                culturalContext: identifier,
                description: "Enso circle representing enlightenment, strength, and the universe"
            ),
            CulturalDesignElement(
                id: "wave_pattern",
                displayName: "Wave Pattern (波)",
                category: CulturalElementCategory(id: "patterns", displayName: "Traditional Patterns", icon: "wave.3.right", culturalContext: identifier),
                weight: 0.8,
                culturalSignificance: 0.85,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["traditional", "seasonal"],
                promptTokens: ["Japanese waves", "seigaiha pattern", "ocean waves", "traditional patterns"],
                culturalContext: identifier,
                description: "Traditional wave pattern symbolizing strength and resilience"
            ),
            CulturalDesignElement(
                id: "koi_fish",
                displayName: "Koi Fish (鯉)",
                category: CulturalElementCategory(id: "animals", displayName: "Sacred Animals", icon: "fish.fill", culturalContext: identifier),
                weight: 0.8,
                culturalSignificance: 0.9,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["traditional", "seasonal"],
                promptTokens: ["koi fish", "Japanese carp", "perseverance symbol", "prosperity fish"],
                culturalContext: identifier,
                description: "Koi fish representing perseverance, strength, and good fortune"
            ),

            // Cultural Symbols
            CulturalDesignElement(
                id: "origami_elements",
                displayName: "Origami (折り紙)",
                category: CulturalElementCategory(id: "artistic", displayName: "Artistic Elements", icon: "triangle.fill", culturalContext: identifier),
                weight: 0.7,
                culturalSignificance: 0.8,
                ageAppropriate: [ageGroups[0], ageGroups[3]], // young, any
                compatibleGenreIds: ["traditional", "minimalist"],
                promptTokens: ["origami", "paper folding", "Japanese art", "geometric beauty"],
                culturalContext: identifier,
                description: "Traditional paper folding representing patience and precision"
            ),
            CulturalDesignElement(
                id: "traditional_knots",
                displayName: "Mizuhiki Knots (水引)",
                category: CulturalElementCategory(id: "ceremonial", displayName: "Ceremonial Elements", icon: "figure.8", culturalContext: identifier),
                weight: 0.9,
                culturalSignificance: 0.95,
                ageAppropriate: [ageGroups[1], ageGroups[2], ageGroups[3]], // adult, elder, any
                compatibleGenreIds: ["ceremonial", "traditional"],
                promptTokens: ["mizuhiki", "ceremonial knots", "gift wrapping", "formal presentation"],
                culturalContext: identifier,
                description: "Traditional ceremonial cord knots for formal gift presentation"
            )
        ]
    }

    var ageGroups: [CulturalAgeGroup] {
        return [
            CulturalAgeGroup(
                id: "young",
                displayName: "Young",
                ageRange: "5-18 years",
                preferences: ["colorful", "playful", "seasonal", "origami-style", "kawaii elements"],
                culturalContext: identifier
            ),
            CulturalAgeGroup(
                id: "adult",
                displayName: "Adult",
                ageRange: "18-50 years",
                preferences: ["elegant", "minimalist", "meaningful", "sophisticated", "seasonal appreciation"],
                culturalContext: identifier
            ),
            CulturalAgeGroup(
                id: "elder",
                displayName: "Elder",
                ageRange: "50+ years",
                preferences: ["traditional", "respectful", "ceremonial", "classical", "dignified"],
                culturalContext: identifier
            ),
            CulturalAgeGroup(
                id: "any",
                displayName: "Any Age",
                ageRange: "All ages",
                preferences: ["universal", "harmonious", "natural", "timeless", "peaceful"],
                culturalContext: identifier
            )
        ]
    }

    // MARK: - AI Generation Parameters

    var basePromptEnhancers: [String] {
        return [
            "Japanese traditional art",
            "wa aesthetic harmony",
            "mono no aware beauty",
            "natural elegance",
            "ceremonial presentation",
            "handcrafted traditional art",
            "centered composition",
            "isolated on clean background",
            "masterpiece quality",
            "best quality",
            "ultra detailed",
            "professional photography",
            "perfect lighting",
            "sharp focus",
            "cultural authenticity",
            "zen minimalism",
            "seasonal beauty"
        ]
    }

    var culturalNegativePrompts: [String] {
        return [
            "not Chinese",
            "not Korean",
            "not Western",
            "no inappropriate cultural mixing",
            "no incorrect symbols",
            "no disrespectful elements",
            "no modern technology",
            "no inappropriate religious symbols",
            "no offensive content",
            "no overly bright colors",
            "no cluttered design",
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
        return JapaneseCulturalValidator()
    }

    var animationStyle: CulturalAnimationStyle {
        return CulturalAnimationStyle(
            primaryStyle: "zen-flowing",
            duration: 3.5,
            effects: ["fade", "gentle_flow", "seasonal_transition", "harmony"],
            culturalElements: ["floating_petals", "gentle_waves", "zen_circles"]
        )
    }
}

// MARK: - Japanese Cultural Validator
class JapaneseCulturalValidator: CulturalValidator, CulturalValidatorProtocol {

    private let inappropriateElements: Set<String> = [
        // Elements that are not appropriate for Japanese cultural context
        // This would be populated based on cultural expert consultation
    ]

    private let sensitiveElements: Set<String> = [
        "crane_motif",
        "sakura_blossoms",
        "zen_circles",
        "traditional_knots"
    ]

    func validateDesignSpec(_ spec: CulturalDesignSpec) -> CulturalValidationResult {
        var warnings: [String] = []
        var errors: [String] = []
        var recommendations: [String] = []

        // Validate cultural context
        guard spec.culturalContext == "japanese_traditional" else {
            errors.append("Invalid cultural context for Japanese validation")
            return CulturalValidationResult(isValid: false, errors: errors)
        }

        // Validate elements
        for element in spec.elements {
            if inappropriateElements.contains(element.id) {
                errors.append("Element '\(element.displayName)' is culturally inappropriate for Japanese context")
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

        // Japanese-specific recommendations
        if spec.elements.isEmpty {
            recommendations.append("Consider adding natural elements like sakura or bamboo for authentic Japanese aesthetics")
        }

        if !spec.elements.contains(where: { $0.category.id == "nature" }) {
            recommendations.append("Adding natural elements enhances the wa aesthetic principle")
        }

        // Check for minimalism principle
        if spec.elements.count > 5 {
            warnings.append("Japanese aesthetics favor simplicity - consider reducing the number of elements")
        }

        // Check color palette cultural alignment
        if spec.colorPalette.id == "zen" && spec.genre.id == "seasonal" {
            recommendations.append("Consider seasonal colors to better match the selected genre")
        }

        let culturalScore = calculateCulturalScore(spec)
        if culturalScore < 0.7 {
            recommendations.append("Consider adding traditional Japanese elements to increase cultural authenticity")
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

        // Japanese cultural scoring emphasizes harmony and natural elements
        let naturalElements = spec.elements.filter { $0.category.id == "nature" }
        let harmonyBonus = naturalElements.isEmpty ? 0.0 : 0.15

        // Bonus for simplicity (fewer elements can be better in Japanese aesthetics)
        let simplicityBonus = spec.elements.count <= 3 ? 0.1 : 0.0

        return (genreScore * 0.25) + (avgElementScore * 0.45) + (paletteScore * 0.2) + harmonyBonus + simplicityBonus
    }
}

// MARK: - Context Registration
extension JapaneseCulturalContext {
    static func register() {
        Task { @MainActor in
            CulturalContextManager.shared.registerContext(JapaneseCulturalContext())
        }
    }
}
