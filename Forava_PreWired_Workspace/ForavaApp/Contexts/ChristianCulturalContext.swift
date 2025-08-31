import Foundation
import SwiftUI

// MARK: - Christian Cultural Context Implementation
struct ChristianCulturalContext: CulturalContext {
    let identifier = "christian_traditional"
    let displayName = "Christian Traditional"
    let description = "Traditional Christian celebration gifts - faith, love, and seasonal joy"
    let primaryLanguage = "en"
    let supportedLanguages = ["en", "es", "fr", "de", "it", "pt", "pl", "ru"]

    // MARK: - Core Cultural Elements

    var genres: [CulturalGenre] {
        return [
            CulturalGenre(
                id: "christmas",
                displayName: "Christmas",
                icon: "star.fill",
                basePrompt: "Christmas celebration, festive joy, holiday spirit, traditional Christian Christmas decorations",
                culturalWeight: 1.0,
                suggestedElementIds: ["christmas_star", "holly_leaves", "christmas_bells", "nativity_elements"],
                culturalContext: identifier
            ),
            CulturalGenre(
                id: "easter",
                displayName: "Easter",
                icon: "sun.max.fill",
                basePrompt: "Easter celebration, resurrection joy, spring renewal, hope and new beginnings",
                culturalWeight: 0.95,
                suggestedElementIds: ["easter_cross", "lily_flowers", "dove_symbol", "spring_elements"],
                culturalContext: identifier
            ),
            CulturalGenre(
                id: "traditional",
                displayName: "Traditional",
                icon: "heart.fill",
                basePrompt: "traditional Christian art, faith symbols, spiritual devotion, classic religious imagery",
                culturalWeight: 0.9,
                suggestedElementIds: ["cross_symbol", "dove_of_peace", "praying_hands", "heart_symbol"],
                culturalContext: identifier
            ),
            CulturalGenre(
                id: "inspirational",
                displayName: "Inspirational",
                icon: "sparkles",
                basePrompt: "inspirational Christian themes, hope and faith, uplifting messages, spiritual encouragement",
                culturalWeight: 0.85,
                suggestedElementIds: ["angel_wings", "light_rays", "scripture_scroll", "peaceful_dove"],
                culturalContext: identifier
            )
        ]
    }

    var colorPalettes: [CulturalColorPalette] {
        return [
            CulturalColorPalette(
                id: "christmas",
                displayName: "Christmas Traditional",
                colors: [
                    CulturalColor(name: "Christmas Red", hex: "C41E3A", symbolism: "Love and sacrifice of Christ"),
                    CulturalColor(name: "Forest Green", hex: "228B22", symbolism: "Eternal life and hope"),
                    CulturalColor(name: "Holy Gold", hex: "FFD700", symbolism: "Divine glory and kingship"),
                    CulturalColor(name: "Pure White", hex: "FFFFFF", symbolism: "Purity and righteousness")
                ],
                promptTokens: ["Christmas colors", "red and green", "holiday colors", "festive palette"],
                culturalContext: identifier,
                culturalSignificance: 1.0
            ),
            CulturalColorPalette(
                id: "easter",
                displayName: "Easter Spring",
                colors: [
                    CulturalColor(name: "Resurrection White", hex: "F8F8FF", symbolism: "Purity and new life"),
                    CulturalColor(name: "Spring Yellow", hex: "FFFF99", symbolism: "Joy and new beginnings"),
                    CulturalColor(name: "Lily Pink", hex: "FFB6C1", symbolism: "God's love and grace"),
                    CulturalColor(name: "Hope Purple", hex: "9370DB", symbolism: "Royalty and spiritual wealth")
                ],
                promptTokens: ["Easter colors", "spring palette", "pastel colors", "renewal colors"],
                culturalContext: identifier,
                culturalSignificance: 0.95
            ),
            CulturalColorPalette(
                id: "traditional",
                displayName: "Sacred Traditional",
                colors: [
                    CulturalColor(name: "Sacred Blue", hex: "4169E1", symbolism: "Heaven and divine truth"),
                    CulturalColor(name: "Royal Purple", hex: "663399", symbolism: "Majesty and spiritual wealth"),
                    CulturalColor(name: "Divine Gold", hex: "DAA520", symbolism: "Divine glory and eternal value"),
                    CulturalColor(name: "Ivory White", hex: "FFFFF0", symbolism: "Holiness and purity")
                ],
                promptTokens: ["sacred colors", "traditional Christian", "liturgical colors", "holy colors"],
                culturalContext: identifier,
                culturalSignificance: 0.9
            )
        ]
    }

    var designElements: [CulturalDesignElement] {
        return [
            // Christmas Elements
            CulturalDesignElement(
                id: "christmas_star",
                displayName: "Star of Bethlehem",
                category: CulturalElementCategory(id: "christmas", displayName: "Christmas Elements", icon: "star.fill", culturalContext: identifier),
                weight: 1.0,
                culturalSignificance: 1.0,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["christmas"],
                promptTokens: ["Star of Bethlehem", "Christmas star", "nativity star", "guiding star"],
                culturalContext: identifier,
                description: "The Star of Bethlehem that guided the wise men to Jesus"
            ),
            CulturalDesignElement(
                id: "holly_leaves",
                displayName: "Holly and Ivy",
                category: CulturalElementCategory(id: "christmas", displayName: "Christmas Elements", icon: "leaf.fill", culturalContext: identifier),
                weight: 0.8,
                culturalSignificance: 0.8,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["christmas", "traditional"],
                promptTokens: ["holly leaves", "Christmas holly", "ivy decoration", "festive foliage"],
                culturalContext: identifier,
                description: "Traditional Christmas holly symbolizing eternal life"
            ),
            CulturalDesignElement(
                id: "christmas_bells",
                displayName: "Christmas Bells",
                category: CulturalElementCategory(id: "christmas", displayName: "Christmas Elements", icon: "bell.fill", culturalContext: identifier),
                weight: 0.7,
                culturalSignificance: 0.75,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["christmas"],
                promptTokens: ["Christmas bells", "holiday bells", "church bells", "joyful bells"],
                culturalContext: identifier,
                description: "Christmas bells announcing the good news of Christ's birth"
            ),

            // Core Christian Symbols
            CulturalDesignElement(
                id: "cross_symbol",
                displayName: "Christian Cross",
                category: CulturalElementCategory(id: "symbols", displayName: "Sacred Symbols", icon: "plus", culturalContext: identifier),
                weight: 1.0,
                culturalSignificance: 1.0,
                ageAppropriate: [ageGroups[1], ageGroups[2], ageGroups[3]], // adult, elder, any
                compatibleGenreIds: ["traditional", "inspirational"],
                promptTokens: ["Christian cross", "holy cross", "salvation symbol", "faith symbol"],
                culturalContext: identifier,
                description: "The Christian cross representing salvation and God's love"
            ),
            CulturalDesignElement(
                id: "dove_of_peace",
                displayName: "Dove of Peace",
                category: CulturalElementCategory(id: "symbols", displayName: "Sacred Symbols", icon: "bird.fill", culturalContext: identifier),
                weight: 0.9,
                culturalSignificance: 0.95,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["traditional", "inspirational", "easter"],
                promptTokens: ["dove of peace", "Holy Spirit dove", "peace dove", "spiritual dove"],
                culturalContext: identifier,
                description: "Dove representing the Holy Spirit and God's peace"
            ),

            // Easter Elements
            CulturalDesignElement(
                id: "easter_cross",
                displayName: "Easter Cross",
                category: CulturalElementCategory(id: "easter", displayName: "Easter Elements", icon: "plus", culturalContext: identifier),
                weight: 0.95,
                culturalSignificance: 1.0,
                ageAppropriate: [ageGroups[1], ageGroups[2], ageGroups[3]], // adult, elder, any
                compatibleGenreIds: ["easter", "traditional"],
                promptTokens: ["Easter cross", "resurrection cross", "victory cross", "triumphant cross"],
                culturalContext: identifier,
                description: "Easter cross celebrating Christ's resurrection and victory over death"
            ),
            CulturalDesignElement(
                id: "lily_flowers",
                displayName: "Easter Lilies",
                category: CulturalElementCategory(id: "easter", displayName: "Easter Elements", icon: "leaf.fill", culturalContext: identifier),
                weight: 0.8,
                culturalSignificance: 0.85,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["easter", "inspirational"],
                promptTokens: ["Easter lilies", "resurrection lilies", "white lilies", "purity flowers"],
                culturalContext: identifier,
                description: "Easter lilies symbolizing purity, hope, and new life in Christ"
            ),

            // Inspirational Elements
            CulturalDesignElement(
                id: "angel_wings",
                displayName: "Angel Wings",
                category: CulturalElementCategory(id: "spiritual", displayName: "Spiritual Elements", icon: "wing.left.fill", culturalContext: identifier),
                weight: 0.8,
                culturalSignificance: 0.9,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["inspirational", "christmas"],
                promptTokens: ["angel wings", "heavenly wings", "guardian angel", "divine protection"],
                culturalContext: identifier,
                description: "Angel wings representing divine protection and heavenly messengers"
            ),
            CulturalDesignElement(
                id: "praying_hands",
                displayName: "Praying Hands",
                category: CulturalElementCategory(id: "spiritual", displayName: "Spiritual Elements", icon: "hands.clap.fill", culturalContext: identifier),
                weight: 0.85,
                culturalSignificance: 0.9,
                ageAppropriate: [ageGroups[1], ageGroups[2], ageGroups[3]], // adult, elder, any
                compatibleGenreIds: ["traditional", "inspirational"],
                promptTokens: ["praying hands", "prayer symbol", "worship hands", "devotion symbol"],
                culturalContext: identifier,
                description: "Praying hands representing devotion, worship, and communication with God"
            ),

            // Heart and Love Elements
            CulturalDesignElement(
                id: "sacred_heart",
                displayName: "Sacred Heart",
                category: CulturalElementCategory(id: "spiritual", displayName: "Spiritual Elements", icon: "heart.fill", culturalContext: identifier),
                weight: 0.9,
                culturalSignificance: 0.95,
                ageAppropriate: [ageGroups[1], ageGroups[2], ageGroups[3]], // adult, elder, any
                compatibleGenreIds: ["traditional", "inspirational"],
                promptTokens: ["Sacred Heart", "Jesus' heart", "divine love", "holy heart"],
                culturalContext: identifier,
                description: "Sacred Heart of Jesus representing God's infinite love and mercy"
            )
        ]
    }

    var ageGroups: [CulturalAgeGroup] {
        return [
            CulturalAgeGroup(
                id: "young",
                displayName: "Young",
                ageRange: "5-18 years",
                preferences: ["joyful", "colorful", "celebration themes", "simple symbols", "festive"],
                culturalContext: identifier
            ),
            CulturalAgeGroup(
                id: "adult",
                displayName: "Adult",
                ageRange: "18-50 years",
                preferences: ["meaningful", "inspirational", "balanced", "faith-centered", "elegant"],
                culturalContext: identifier
            ),
            CulturalAgeGroup(
                id: "elder",
                displayName: "Elder",
                ageRange: "50+ years",
                preferences: ["traditional", "reverent", "classic", "dignified", "spiritual"],
                culturalContext: identifier
            ),
            CulturalAgeGroup(
                id: "any",
                displayName: "Any Age",
                ageRange: "All ages",
                preferences: ["universal", "hopeful", "peaceful", "loving", "blessed"],
                culturalContext: identifier
            )
        ]
    }

    // MARK: - AI Generation Parameters

    var basePromptEnhancers: [String] {
        return [
            "Christian traditional art",
            "faith-based design",
            "spiritual beauty",
            "religious devotion",
            "holy imagery",
            "sacred art",
            "handcrafted religious art",
            "centered composition",
            "isolated on clean background",
            "masterpiece quality",
            "best quality",
            "ultra detailed",
            "professional photography",
            "perfect lighting",
            "sharp focus",
            "reverent presentation",
            "spiritual atmosphere"
        ]
    }

    var culturalNegativePrompts: [String] {
        return [
            "not secular",
            "not other religions",
            "no inappropriate religious mixing",
            "no disrespectful religious imagery",
            "no modern technology",
            "no inappropriate Christian symbols",
            "no offensive religious content",
            "no blasphemous elements",
            "no commercialization of sacred symbols",
            "blurry",
            "low quality",
            "distorted",
            "nsfw",
            "inappropriate religious representation"
        ]
    }

    var preferredAIModel: String {
        return "stability-ai/stable-diffusion-xl"
    }

    // MARK: - Validation and Animation

    var validator: CulturalValidator {
        return ChristianCulturalValidator()
    }

    var animationStyle: CulturalAnimationStyle {
        return CulturalAnimationStyle(
            primaryStyle: "peaceful-gentle",
            duration: 3.0,
            effects: ["gentle_glow", "peaceful_fade", "holy_light", "serene_flow"],
            culturalElements: ["golden_light", "peaceful_particles", "gentle_waves"]
        )
    }
}

// MARK: - Christian Cultural Validator
class ChristianCulturalValidator: CulturalValidator, CulturalValidatorProtocol {

    private let inappropriateElements: Set<String> = [
        // Elements that are religiously inappropriate or disrespectful
        // This would be populated based on theological expert consultation
    ]

    private let sensitiveElements: Set<String> = [
        "cross_symbol",
        "sacred_heart",
        "easter_cross",
        "praying_hands"
    ]

    func validateDesignSpec(_ spec: CulturalDesignSpec) -> CulturalValidationResult {
        var warnings: [String] = []
        var errors: [String] = []
        var recommendations: [String] = []

        // Validate cultural context
        guard spec.culturalContext == "christian_traditional" else {
            errors.append("Invalid cultural context for Christian validation")
            return CulturalValidationResult(isValid: false, errors: errors)
        }

        // Validate elements
        for element in spec.elements {
            if inappropriateElements.contains(element.id) {
                errors.append("Element '\(element.displayName)' is inappropriate for Christian context")
            } else if sensitiveElements.contains(element.id) {
                warnings.append("Element '\(element.displayName)' has high religious significance - ensure respectful representation")
            }
        }

        // Check age appropriateness
        let inappropriateElements = spec.elements.filter { element in
            !element.ageAppropriate.contains { $0.id == spec.targetAgeGroup.id || $0.id == "any" }
        }

        for element in inappropriateElements {
            warnings.append("Element '\(element.displayName)' may not be suitable for \(spec.targetAgeGroup.displayName)")
        }

        // Christian-specific recommendations
        if spec.elements.isEmpty {
            recommendations.append("Consider adding traditional Christian symbols or seasonal elements")
        }

        if !spec.elements.contains(where: { $0.category.id == "symbols" }) {
            recommendations.append("Adding sacred symbols enhances Christian authenticity")
        }

        // Check for appropriate seasonal context
        if spec.genre.id == "christmas" && !spec.elements.contains(where: { $0.category.id == "christmas" }) {
            recommendations.append("Consider adding Christmas-specific elements for the Christmas genre")
        }

        if spec.genre.id == "easter" && !spec.elements.contains(where: { $0.category.id == "easter" }) {
            recommendations.append("Consider adding Easter-specific elements for the Easter genre")
        }

        // Check religious appropriateness
        let religiousElements = spec.elements.filter { $0.culturalSignificance > 0.9 }
        if religiousElements.count > 2 {
            warnings.append("Multiple highly sacred elements - ensure appropriate reverent context")
        }

        let culturalScore = calculateCulturalScore(spec)
        if culturalScore < 0.7 {
            recommendations.append("Consider adding more traditional Christian elements to increase authenticity")
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

        // Christian scoring emphasizes sacred symbols and seasonal appropriateness
        let sacredElements = spec.elements.filter { $0.category.id == "symbols" || $0.category.id == "spiritual" }
        let sacredBonus = sacredElements.isEmpty ? 0.0 : 0.15

        // Bonus for genre-appropriate elements
        let seasonalElements = spec.elements.filter { element in
            (spec.genre.id == "christmas" && element.category.id == "christmas") ||
            (spec.genre.id == "easter" && element.category.id == "easter")
        }
        let seasonalBonus = seasonalElements.isEmpty ? 0.0 : 0.1

        return (genreScore * 0.3) + (avgElementScore * 0.4) + (paletteScore * 0.2) + sacredBonus + seasonalBonus
    }
}

// MARK: - Context Registration
extension ChristianCulturalContext {
    static func register() {
        Task { @MainActor in
            CulturalContextManager.shared.registerContext(ChristianCulturalContext())
        }
    }
}
