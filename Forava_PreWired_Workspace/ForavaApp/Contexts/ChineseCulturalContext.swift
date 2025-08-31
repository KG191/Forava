import Foundation
import SwiftUI

// MARK: - Chinese Cultural Context Implementation (Example)
struct ChineseCulturalContext: CulturalContext {
    let identifier = "chinese_traditional"
    let displayName = "Chinese Traditional"
    let description = "Traditional Chinese gifts and decorative arts - symbols of prosperity and good fortune"
    let primaryLanguage = "zh"
    let supportedLanguages = ["zh", "en", "zh-TW", "zh-HK"]

    // MARK: - Core Cultural Elements

    var genres: [CulturalGenre] {
        return [
            CulturalGenre(
                id: "chinese_new_year",
                displayName: "Chinese New Year",
                icon: "sparkles",
                basePrompt: "Chinese New Year celebration, Spring Festival, red decorations, fireworks, prosperity symbols, lunar new year",
                culturalWeight: 1.0,
                suggestedElementIds: ["dragon_motif", "fireworks_motif", "prosperity_coins", "red_lanterns"],
                culturalContext: identifier
            ),
            CulturalGenre(
                id: "mid_autumn",
                displayName: "Mid-Autumn Festival",
                icon: "moon.fill",
                basePrompt: "Mid-Autumn Festival, moon festival, mooncakes, family reunion, harvest celebration, full moon",
                culturalWeight: 0.95,
                suggestedElementIds: ["full_moon", "mooncakes", "osmanthus_flowers", "family_reunion"],
                culturalContext: identifier
            ),
            CulturalGenre(
                id: "traditional",
                displayName: "Traditional",
                icon: "star.circle.fill",
                basePrompt: "traditional Chinese art, feng shui elements, auspicious symbols, classical design",
                culturalWeight: 0.9,
                suggestedElementIds: ["red_ribbon", "gold_coins", "dragon_motif", "bamboo_elements"],
                culturalContext: identifier
            ),
            CulturalGenre(
                id: "modern",
                displayName: "Contemporary",
                icon: "sparkles",
                basePrompt: "modern Chinese design, contemporary feng shui, minimalist oriental style",
                culturalWeight: 0.7,
                suggestedElementIds: ["geometric_patterns", "modern_calligraphy", "stylized_symbols"],
                culturalContext: identifier
            ),
            CulturalGenre(
                id: "festive",
                displayName: "Festive",
                icon: "party.popper.fill",
                basePrompt: "Chinese New Year celebration, festive decorations, joyful symbols, celebration art",
                culturalWeight: 0.9,
                suggestedElementIds: ["fireworks_motif", "lantern_symbols", "prosperity_coins", "festival_colors"],
                culturalContext: identifier
            ),
            CulturalGenre(
                id: "elegant",
                displayName: "Scholarly",
                icon: "book.fill",
                basePrompt: "Chinese scholarly tradition, elegant calligraphy, refined cultural symbols",
                culturalWeight: 0.95,
                suggestedElementIds: ["calligraphy_brush", "scroll_elements", "jade_symbols", "scholarly_motifs"],
                culturalContext: identifier
            )
        ]
    }

    var colorPalettes: [CulturalColorPalette] {
        return [
            CulturalColorPalette(
                id: "traditional",
                displayName: "Traditional Red & Gold",
                colors: [
                    CulturalColor(name: "Imperial Red", hex: "DC143C", symbolism: "Good fortune and joy"),
                    CulturalColor(name: "Golden Yellow", hex: "FFD700", symbolism: "Prosperity and wealth"),
                    CulturalColor(name: "Jade Green", hex: "00A86B", symbolism: "Harmony and balance"),
                    CulturalColor(name: "Royal Purple", hex: "663399", symbolism: "Nobility and respect")
                ],
                promptTokens: ["red", "gold", "imperial colors", "auspicious colors", "Chinese traditional colors"],
                culturalContext: identifier,
                culturalSignificance: 1.0
            ),
            CulturalColorPalette(
                id: "five_elements",
                displayName: "Five Elements",
                colors: [
                    CulturalColor(name: "Fire Red", hex: "FF4500", symbolism: "Fire element - energy and passion"),
                    CulturalColor(name: "Earth Yellow", hex: "DAA520", symbolism: "Earth element - stability"),
                    CulturalColor(name: "Metal White", hex: "F8F8FF", symbolism: "Metal element - precision"),
                    CulturalColor(name: "Water Blue", hex: "4169E1", symbolism: "Water element - wisdom"),
                    CulturalColor(name: "Wood Green", hex: "228B22", symbolism: "Wood element - growth")
                ],
                promptTokens: ["five elements", "feng shui colors", "elemental harmony", "balance"],
                culturalContext: identifier,
                culturalSignificance: 0.95
            ),
            CulturalColorPalette(
                id: "modern",
                displayName: "Modern Minimalist",
                colors: [
                    CulturalColor(name: "Ink Black", hex: "2F2F2F", symbolism: "Depth and sophistication"),
                    CulturalColor(name: "Pearl White", hex: "F8F6F0", symbolism: "Purity and clarity"),
                    CulturalColor(name: "Bamboo Green", hex: "8FBC8F", symbolism: "Growth and flexibility"),
                    CulturalColor(name: "Stone Grey", hex: "708090", symbolism: "Stability and calm")
                ],
                promptTokens: ["minimalist", "contemporary", "modern Chinese", "zen colors"],
                culturalContext: identifier,
                culturalSignificance: 0.6
            )
        ]
    }

    var designElements: [CulturalDesignElement] {
        return [
            // Traditional Symbols
            CulturalDesignElement(
                id: "dragon_motif",
                displayName: "Dragon Motif",
                category: CulturalElementCategory(id: "symbols", displayName: "Sacred Symbols", icon: "character.magnify", culturalContext: identifier),
                weight: 1.0,
                culturalSignificance: 1.0,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["traditional", "festive"],
                promptTokens: ["Chinese dragon", "dragon motif", "imperial dragon", "auspicious dragon"],
                culturalContext: identifier,
                description: "Traditional Chinese dragon symbolizing power, strength, and good luck"
            ),
            CulturalDesignElement(
                id: "phoenix_symbol",
                displayName: "Phoenix Symbol",
                category: CulturalElementCategory(id: "symbols", displayName: "Sacred Symbols", icon: "character.magnify", culturalContext: identifier),
                weight: 0.9,
                culturalSignificance: 0.95,
                ageAppropriate: [ageGroups[1], ageGroups[2], ageGroups[3]], // adult, elder, any
                compatibleGenreIds: ["traditional", "elegant"],
                promptTokens: ["Chinese phoenix", "fenghuang", "phoenix bird", "prosperity symbol"],
                culturalContext: identifier,
                description: "Phoenix symbolizing renewal, prosperity, and harmony"
            ),

            // Mid-Autumn Festival Elements
            CulturalDesignElement(
                id: "full_moon",
                displayName: "Full Moon",
                category: CulturalElementCategory(id: "moon_festival", displayName: "Moon Festival", icon: "moon.fill", culturalContext: identifier),
                weight: 1.0,
                culturalSignificance: 0.95,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["mid_autumn", "traditional"],
                promptTokens: ["full moon", "harvest moon", "bright moon", "Mid-Autumn moon"],
                culturalContext: identifier,
                description: "Full moon central to Mid-Autumn Festival celebration"
            ),
            CulturalDesignElement(
                id: "mooncakes",
                displayName: "Traditional Mooncakes",
                category: CulturalElementCategory(id: "moon_festival", displayName: "Moon Festival", icon: "circle.fill", culturalContext: identifier),
                weight: 0.9,
                culturalSignificance: 0.9,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["mid_autumn"],
                promptTokens: ["mooncakes", "moon festival cakes", "traditional pastries", "reunion cakes"],
                culturalContext: identifier,
                description: "Traditional mooncakes shared during Mid-Autumn Festival family reunions"
            ),
            CulturalDesignElement(
                id: "osmanthus_flowers",
                displayName: "Osmanthus Flowers",
                category: CulturalElementCategory(id: "moon_festival", displayName: "Moon Festival", icon: "leaf.fill", culturalContext: identifier),
                weight: 0.8,
                culturalSignificance: 0.8,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["mid_autumn", "traditional"],
                promptTokens: ["osmanthus flowers", "sweet osmanthus", "autumn flowers", "fragrant blossoms"],
                culturalContext: identifier,
                description: "Osmanthus flowers that bloom during Mid-Autumn, symbolizing love and romance"
            ),
            CulturalDesignElement(
                id: "red_lanterns",
                displayName: "Red Lanterns",
                category: CulturalElementCategory(id: "decorative", displayName: "Decorative Elements", icon: "lightbulb.fill", culturalContext: identifier),
                weight: 0.85,
                culturalSignificance: 0.85,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["chinese_new_year", "traditional"],
                promptTokens: ["red lanterns", "Chinese lanterns", "festival lanterns", "celebration lights"],
                culturalContext: identifier,
                description: "Traditional red lanterns used in Chinese celebrations and festivals"
            ),

            // Decorative Elements
            CulturalDesignElement(
                id: "bamboo_elements",
                displayName: "Bamboo Elements",
                category: CulturalElementCategory(id: "decorative", displayName: "Decorative Elements", icon: "sparkles", culturalContext: identifier),
                weight: 0.8,
                culturalSignificance: 0.85,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["traditional", "modern", "elegant"],
                promptTokens: ["bamboo", "bamboo leaves", "bamboo stalks", "zen bamboo"],
                culturalContext: identifier,
                description: "Bamboo representing flexibility, strength, and perseverance"
            ),
            CulturalDesignElement(
                id: "plum_blossoms",
                displayName: "Plum Blossoms",
                category: CulturalElementCategory(id: "decorative", displayName: "Decorative Elements", icon: "sparkles", culturalContext: identifier),
                weight: 0.8,
                culturalSignificance: 0.9,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["traditional", "elegant", "festive"],
                promptTokens: ["plum blossoms", "mei flower", "spring flowers", "Chinese blossoms"],
                culturalContext: identifier,
                description: "Plum blossoms symbolizing resilience and hope"
            ),

            // Lucky Symbols
            CulturalDesignElement(
                id: "double_happiness",
                displayName: "Double Happiness (囍)",
                category: CulturalElementCategory(id: "symbols", displayName: "Sacred Symbols", icon: "character.magnify", culturalContext: identifier),
                weight: 1.0,
                culturalSignificance: 1.0,
                ageAppropriate: [ageGroups[1], ageGroups[2], ageGroups[3]], // adult, elder, any
                compatibleGenreIds: ["traditional", "festive"],
                promptTokens: ["double happiness", "xi symbol", "marriage symbol", "joy character"],
                culturalContext: identifier,
                description: "Double happiness symbol traditionally used for weddings and celebrations"
            ),
            CulturalDesignElement(
                id: "prosperity_coins",
                displayName: "Prosperity Coins",
                category: CulturalElementCategory(id: "symbols", displayName: "Sacred Symbols", icon: "character.magnify", culturalContext: identifier),
                weight: 0.9,
                culturalSignificance: 0.9,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["traditional", "festive"],
                promptTokens: ["Chinese coins", "prosperity coins", "feng shui coins", "wealth symbols"],
                culturalContext: identifier,
                description: "Traditional coins symbolizing wealth and prosperity"
            ),

            // Calligraphy Elements
            CulturalDesignElement(
                id: "calligraphy_brush",
                displayName: "Calligraphy Brush Strokes",
                category: CulturalElementCategory(id: "artistic", displayName: "Artistic Elements", icon: "paintbrush.fill", culturalContext: identifier),
                weight: 0.8,
                culturalSignificance: 0.9,
                ageAppropriate: [ageGroups[1], ageGroups[2], ageGroups[3]], // adult, elder, any
                compatibleGenreIds: ["elegant", "traditional"],
                promptTokens: ["Chinese calligraphy", "brush strokes", "elegant writing", "scholarly art"],
                culturalContext: identifier,
                description: "Traditional Chinese calligraphy representing culture and education"
            ),
            CulturalDesignElement(
                id: "seal_stamp",
                displayName: "Traditional Seal",
                category: CulturalElementCategory(id: "artistic", displayName: "Artistic Elements", icon: "paintbrush.fill", culturalContext: identifier),
                weight: 0.7,
                culturalSignificance: 0.8,
                ageAppropriate: [ageGroups[1], ageGroups[2], ageGroups[3]], // adult, elder, any
                compatibleGenreIds: ["elegant", "traditional"],
                promptTokens: ["Chinese seal", "red stamp", "traditional seal", "signature stamp"],
                culturalContext: identifier,
                description: "Traditional Chinese seal stamp representing authenticity and authority"
            )
        ]
    }

    var ageGroups: [CulturalAgeGroup] {
        return [
            CulturalAgeGroup(
                id: "young",
                displayName: "Young",
                ageRange: "5-18 years",
                preferences: ["colorful", "playful", "festive", "cartoon-like", "bright"],
                culturalContext: identifier
            ),
            CulturalAgeGroup(
                id: "adult",
                displayName: "Adult",
                ageRange: "18-50 years",
                preferences: ["elegant", "sophisticated", "meaningful", "balanced", "refined"],
                culturalContext: identifier
            ),
            CulturalAgeGroup(
                id: "elder",
                displayName: "Elder",
                ageRange: "50+ years",
                preferences: ["traditional", "respectful", "classic", "dignified", "auspicious"],
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
            "Chinese traditional art",
            "feng shui principles",
            "auspicious symbols",
            "Chinese cultural heritage",
            "oriental design",
            "handcrafted traditional art",
            "centered composition",
            "isolated on clean background",
            "masterpiece quality",
            "best quality",
            "ultra detailed",
            "professional photography",
            "perfect lighting",
            "sharp focus",
            "cultural authenticity"
        ]
    }

    var culturalNegativePrompts: [String] {
        return [
            "not Japanese",
            "not Korean",
            "not Western",
            "no inappropriate cultural mixing",
            "no incorrect symbols",
            "no disrespectful elements",
            "no modern technology",
            "no inappropriate religious symbols",
            "no offensive content",
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
        return ChineseCulturalValidator()
    }

    var animationStyle: CulturalAnimationStyle {
        return CulturalAnimationStyle(
            primaryStyle: "flowing-elegant",
            duration: 3.0,
            effects: ["fade", "flow", "prosperity_glow", "harmony"],
            culturalElements: ["flowing_energy", "golden_particles", "harmony_waves"]
        )
    }
}

// MARK: - Chinese Cultural Validator
class ChineseCulturalValidator: CulturalValidator, CulturalValidatorProtocol {

    private let inappropriateElements: Set<String> = [
        // Elements that are not appropriate for Chinese cultural context
        // This would be populated based on cultural expert consultation
    ]

    private let sensitiveElements: Set<String> = [
        "dragon_motif",
        "double_happiness",
        "prosperity_coins",
        "phoenix_symbol"
    ]

    func validateDesignSpec(_ spec: CulturalDesignSpec) -> CulturalValidationResult {
        var warnings: [String] = []
        var errors: [String] = []
        var recommendations: [String] = []

        // Validate cultural context
        guard spec.culturalContext == "chinese_traditional" else {
            errors.append("Invalid cultural context for Chinese validation")
            return CulturalValidationResult(isValid: false, errors: errors)
        }

        // Validate elements
        for element in spec.elements {
            if inappropriateElements.contains(element.id) {
                errors.append("Element '\(element.displayName)' is culturally inappropriate for Chinese context")
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

        // Chinese-specific recommendations
        if spec.elements.isEmpty {
            recommendations.append("Consider adding traditional elements like bamboo or prosperity symbols")
        }

        if !spec.elements.contains(where: { $0.category.id == "symbols" }) {
            recommendations.append("Adding auspicious symbols can enhance cultural authenticity")
        }

        // Check color palette cultural alignment
        if spec.colorPalette.id == "modern" && spec.genre.id == "traditional" {
            warnings.append("Modern color palette with traditional genre may reduce cultural authenticity")
        }

        let culturalScore = calculateCulturalScore(spec)
        if culturalScore < 0.6 {
            recommendations.append("Consider adding more traditional Chinese elements to increase cultural authenticity")
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

        // Chinese cultural scoring gives slightly more weight to symbols
        let symbolElements = spec.elements.filter { $0.category.id == "symbols" }
        let symbolBonus = symbolElements.isEmpty ? 0.0 : 0.1

        return (genreScore * 0.3) + (avgElementScore * 0.5) + (paletteScore * 0.2) + symbolBonus
    }
}

// MARK: - Context Registration
extension ChineseCulturalContext {
    static func register() {
        Task { @MainActor in
            CulturalContextManager.shared.registerContext(ChineseCulturalContext())
        }
    }
}
