import Foundation
import SwiftUI

// MARK: - Universal Cultural Context Implementation
struct UniversalCulturalContext: CulturalContext {
    let identifier = "universal_celebrations"
    let displayName = "Universal Celebrations"
    let description = "Universal celebrations and life milestones - birthdays, anniversaries, and special moments"
    let primaryLanguage = "en"
    let supportedLanguages = ["en", "es", "fr", "de", "it", "pt", "ru", "zh", "ja", "ar", "hi"]

    // MARK: - Core Cultural Elements

    var genres: [CulturalGenre] {
        return [
            CulturalGenre(
                id: "birthday",
                displayName: "Birthday Celebration",
                icon: "birthday.cake.fill",
                basePrompt: "birthday celebration, festive joy, party atmosphere, celebratory design, age milestone",
                culturalWeight: 1.0,
                suggestedElementIds: ["birthday_cake", "balloons", "confetti", "celebration_banner"],
                culturalContext: identifier
            ),
            CulturalGenre(
                id: "anniversary",
                displayName: "Anniversary",
                icon: "heart.circle.fill",
                basePrompt: "anniversary celebration, love milestone, romantic celebration, togetherness, meaningful moments",
                culturalWeight: 0.95,
                suggestedElementIds: ["hearts", "wedding_rings", "flowers", "romantic_elements"],
                culturalContext: identifier
            ),
            CulturalGenre(
                id: "graduation",
                displayName: "Graduation",
                icon: "graduationcap.fill",
                basePrompt: "graduation celebration, achievement milestone, academic success, future bright, accomplishment",
                culturalWeight: 0.9,
                suggestedElementIds: ["graduation_cap", "diploma", "stars", "success_symbols"],
                culturalContext: identifier
            ),
            CulturalGenre(
                id: "achievement",
                displayName: "Achievement",
                icon: "trophy.fill",
                basePrompt: "achievement celebration, success milestone, accomplishment, victory, recognition",
                culturalWeight: 0.85,
                suggestedElementIds: ["trophy", "medal", "success_ribbon", "achievement_star"],
                culturalContext: identifier
            ),
            CulturalGenre(
                id: "friendship",
                displayName: "Friendship",
                icon: "person.2.fill",
                basePrompt: "friendship celebration, companionship, friendship bond, caring relationship, support",
                culturalWeight: 0.8,
                suggestedElementIds: ["friendship_hands", "unity_symbols", "caring_hearts", "support_elements"],
                culturalContext: identifier
            )
        ]
    }

    var colorPalettes: [CulturalColorPalette] {
        return [
            CulturalColorPalette(
                id: "birthday",
                displayName: "Birthday Party",
                colors: [
                    CulturalColor(name: "Party Pink", hex: "FF69B4", symbolism: "Joy and celebration"),
                    CulturalColor(name: "Celebration Blue", hex: "00BFFF", symbolism: "Happiness and excitement"),
                    CulturalColor(name: "Festive Yellow", hex: "FFD700", symbolism: "Sunshine and warmth"),
                    CulturalColor(name: "Fun Purple", hex: "9370DB", symbolism: "Creativity and fun")
                ],
                promptTokens: ["birthday colors", "party palette", "festive colors", "celebration rainbow"],
                culturalContext: identifier,
                culturalSignificance: 0.9
            ),
            CulturalColorPalette(
                id: "romantic",
                displayName: "Romantic Anniversary",
                colors: [
                    CulturalColor(name: "Love Red", hex: "DC143C", symbolism: "Passion and deep love"),
                    CulturalColor(name: "Rose Pink", hex: "FFB6C1", symbolism: "Tender affection"),
                    CulturalColor(name: "Pearl White", hex: "F8F8FF", symbolism: "Purity and new beginnings"),
                    CulturalColor(name: "Golden Anniversary", hex: "DAA520", symbolism: "Precious memories")
                ],
                promptTokens: ["romantic colors", "love palette", "anniversary colors", "tender tones"],
                culturalContext: identifier,
                culturalSignificance: 0.85
            ),
            CulturalColorPalette(
                id: "achievement",
                displayName: "Success & Achievement",
                colors: [
                    CulturalColor(name: "Victory Gold", hex: "FFD700", symbolism: "Success and achievement"),
                    CulturalColor(name: "Champion Blue", hex: "4169E1", symbolism: "Excellence and determination"),
                    CulturalColor(name: "Winner Silver", hex: "C0C0C0", symbolism: "Recognition and honor"),
                    CulturalColor(name: "Success Green", hex: "32CD32", symbolism: "Growth and progress")
                ],
                promptTokens: ["success colors", "achievement palette", "victory colors", "champion tones"],
                culturalContext: identifier,
                culturalSignificance: 0.8
            )
        ]
    }

    var designElements: [CulturalDesignElement] {
        return [
            // Birthday Elements
            CulturalDesignElement(
                id: "birthday_cake",
                displayName: "Birthday Cake",
                category: CulturalElementCategory(id: "birthday", displayName: "Birthday Elements", icon: "birthday.cake.fill", culturalContext: identifier),
                weight: 1.0,
                culturalSignificance: 0.9,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["birthday"],
                promptTokens: ["birthday cake", "celebration cake", "candles", "festive dessert"],
                culturalContext: identifier,
                description: "Traditional birthday cake representing celebration and milestones"
            ),
            CulturalDesignElement(
                id: "balloons",
                displayName: "Celebration Balloons",
                category: CulturalElementCategory(id: "party", displayName: "Party Elements", icon: "balloon.fill", culturalContext: identifier),
                weight: 0.8,
                culturalSignificance: 0.7,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["birthday", "achievement"],
                promptTokens: ["balloons", "party balloons", "colorful balloons", "celebration decor"],
                culturalContext: identifier,
                description: "Festive balloons representing joy and celebration"
            ),
            CulturalDesignElement(
                id: "confetti",
                displayName: "Confetti",
                category: CulturalElementCategory(id: "party", displayName: "Party Elements", icon: "sparkles", culturalContext: identifier),
                weight: 0.7,
                culturalSignificance: 0.6,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["birthday", "achievement", "graduation"],
                promptTokens: ["confetti", "celebration confetti", "party sparkles", "festive scatter"],
                culturalContext: identifier,
                description: "Colorful confetti representing joy and festive atmosphere"
            ),

            // Anniversary Elements
            CulturalDesignElement(
                id: "hearts",
                displayName: "Love Hearts",
                category: CulturalElementCategory(id: "romance", displayName: "Romantic Elements", icon: "heart.fill", culturalContext: identifier),
                weight: 0.9,
                culturalSignificance: 0.8,
                ageAppropriate: [ageGroups[1], ageGroups[2], ageGroups[3]], // adult, elder, any
                compatibleGenreIds: ["anniversary", "friendship"],
                promptTokens: ["hearts", "love hearts", "romantic hearts", "affection symbols"],
                culturalContext: identifier,
                description: "Hearts representing love, affection, and emotional connection"
            ),
            CulturalDesignElement(
                id: "wedding_rings",
                displayName: "Wedding Rings",
                category: CulturalElementCategory(id: "romance", displayName: "Romantic Elements", icon: "circle.circle.fill", culturalContext: identifier),
                weight: 0.8,
                culturalSignificance: 0.9,
                ageAppropriate: [ageGroups[1], ageGroups[2], ageGroups[3]], // adult, elder, any
                compatibleGenreIds: ["anniversary"],
                promptTokens: ["wedding rings", "marriage rings", "commitment rings", "eternal bond"],
                culturalContext: identifier,
                description: "Wedding rings representing eternal love and commitment"
            ),
            CulturalDesignElement(
                id: "flowers",
                displayName: "Beautiful Flowers",
                category: CulturalElementCategory(id: "nature", displayName: "Natural Beauty", icon: "leaf.fill", culturalContext: identifier),
                weight: 0.8,
                culturalSignificance: 0.7,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["anniversary", "friendship", "birthday"],
                promptTokens: ["flowers", "beautiful blooms", "floral arrangement", "natural beauty"],
                culturalContext: identifier,
                description: "Beautiful flowers representing beauty, growth, and natural love"
            ),

            // Achievement Elements
            CulturalDesignElement(
                id: "graduation_cap",
                displayName: "Graduation Cap",
                category: CulturalElementCategory(id: "achievement", displayName: "Achievement Elements", icon: "graduationcap.fill", culturalContext: identifier),
                weight: 0.9,
                culturalSignificance: 0.8,
                ageAppropriate: [ageGroups[0], ageGroups[1], ageGroups[3]], // young, adult, any
                compatibleGenreIds: ["graduation", "achievement"],
                promptTokens: ["graduation cap", "mortarboard", "academic cap", "education symbol"],
                culturalContext: identifier,
                description: "Graduation cap representing educational achievement and academic success"
            ),
            CulturalDesignElement(
                id: "trophy",
                displayName: "Victory Trophy",
                category: CulturalElementCategory(id: "achievement", displayName: "Achievement Elements", icon: "trophy.fill", culturalContext: identifier),
                weight: 0.9,
                culturalSignificance: 0.9,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["achievement"],
                promptTokens: ["trophy", "victory cup", "winner trophy", "champion award"],
                culturalContext: identifier,
                description: "Trophy representing victory, achievement, and success"
            ),
            CulturalDesignElement(
                id: "stars",
                displayName: "Achievement Stars",
                category: CulturalElementCategory(id: "achievement", displayName: "Achievement Elements", icon: "star.fill", culturalContext: identifier),
                weight: 0.7,
                culturalSignificance: 0.6,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["achievement", "graduation", "birthday"],
                promptTokens: ["stars", "achievement stars", "success stars", "shining stars"],
                culturalContext: identifier,
                description: "Shining stars representing excellence and outstanding achievement"
            ),

            // Friendship Elements
            CulturalDesignElement(
                id: "friendship_hands",
                displayName: "Friendship Hands",
                category: CulturalElementCategory(id: "friendship", displayName: "Friendship Elements", icon: "hands.clap.fill", culturalContext: identifier),
                weight: 0.8,
                culturalSignificance: 0.7,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["friendship"],
                promptTokens: ["friendship hands", "helping hands", "supportive hands", "caring gesture"],
                culturalContext: identifier,
                description: "Hands representing friendship, support, and caring relationships"
            ),
            CulturalDesignElement(
                id: "unity_symbols",
                displayName: "Unity Symbols",
                category: CulturalElementCategory(id: "friendship", displayName: "Friendship Elements", icon: "person.2.fill", culturalContext: identifier),
                weight: 0.7,
                culturalSignificance: 0.6,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["friendship"],
                promptTokens: ["unity symbols", "togetherness", "friendship bond", "connection symbols"],
                culturalContext: identifier,
                description: "Symbols representing unity, togetherness, and strong friendships"
            )
        ]
    }

    var ageGroups: [CulturalAgeGroup] {
        return [
            CulturalAgeGroup(
                id: "young",
                displayName: "Young",
                ageRange: "5-18 years",
                preferences: ["colorful", "playful", "fun", "energetic", "bright"],
                culturalContext: identifier
            ),
            CulturalAgeGroup(
                id: "adult",
                displayName: "Adult",
                ageRange: "18-50 years",
                preferences: ["meaningful", "elegant", "sophisticated", "balanced", "personal"],
                culturalContext: identifier
            ),
            CulturalAgeGroup(
                id: "elder",
                displayName: "Elder",
                ageRange: "50+ years",
                preferences: ["classic", "dignified", "timeless", "refined", "traditional"],
                culturalContext: identifier
            ),
            CulturalAgeGroup(
                id: "any",
                displayName: "Any Age",
                ageRange: "All ages",
                preferences: ["universal", "inclusive", "warm", "welcoming", "joyful"],
                culturalContext: identifier
            )
        ]
    }

    // MARK: - AI Generation Parameters

    var basePromptEnhancers: [String] {
        return [
            "celebration art",
            "universal appeal",
            "joyful atmosphere",
            "milestone celebration",
            "heartfelt design",
            "personal meaning",
            "handcrafted celebration art",
            "centered composition",
            "isolated on clean background",
            "masterpiece quality",
            "best quality",
            "ultra detailed",
            "professional photography",
            "perfect lighting",
            "sharp focus",
            "warm atmosphere",
            "celebratory mood"
        ]
    }

    var culturalNegativePrompts: [String] {
        return [
            "no specific cultural appropriation",
            "no religious symbols without context",
            "no cultural stereotypes",
            "no inappropriate celebration",
            "no offensive content",
            "no sad or negative themes",
            "blurry",
            "low quality",
            "distorted",
            "nsfw",
            "inappropriate celebration"
        ]
    }

    var preferredAIModel: String {
        return "stability-ai/stable-diffusion-xl"
    }

    // MARK: - Validation and Animation

    var validator: CulturalValidator {
        return UniversalCulturalValidator()
    }

    var animationStyle: CulturalAnimationStyle {
        return CulturalAnimationStyle(
            primaryStyle: "joyful-celebration",
            duration: 2.5,
            effects: ["celebration_sparkle", "joyful_bounce", "warm_glow", "festive_flow"],
            culturalElements: ["confetti_burst", "celebration_particles", "joy_waves"]
        )
    }
}

// MARK: - Universal Cultural Validator
class UniversalCulturalValidator: CulturalValidator, CulturalValidatorProtocol {

    private let inappropriateElements: Set<String> = [
        // Elements that are inappropriate for universal celebrations
    ]

    private let sensitiveElements: Set<String> = [
        "wedding_rings"
    ]

    func validateDesignSpec(_ spec: CulturalDesignSpec) -> CulturalValidationResult {
        var warnings: [String] = []
        var errors: [String] = []
        var recommendations: [String] = []

        // Validate cultural context
        guard spec.culturalContext == "universal_celebrations" else {
            errors.append("Invalid cultural context for Universal validation")
            return CulturalValidationResult(isValid: false, errors: errors)
        }

        // Validate elements
        for element in spec.elements {
            if inappropriateElements.contains(element.id) {
                errors.append("Element '\(element.displayName)' is inappropriate for universal context")
            } else if sensitiveElements.contains(element.id) {
                warnings.append("Element '\(element.displayName)' may be context-specific - ensure appropriate usage")
            }
        }

        // Check age appropriateness
        let inappropriateElements = spec.elements.filter { element in
            !element.ageAppropriate.contains { $0.id == spec.targetAgeGroup.id || $0.id == "any" }
        }

        for element in inappropriateElements {
            warnings.append("Element '\(element.displayName)' may not be suitable for \(spec.targetAgeGroup.displayName)")
        }

        // Universal-specific recommendations
        if spec.elements.isEmpty {
            recommendations.append("Consider adding celebration elements like balloons or stars")
        }

        // Check genre-element alignment
        if spec.genre.id == "birthday" && !spec.elements.contains(where: { $0.category.id == "birthday" || $0.category.id == "party" }) {
            recommendations.append("Consider adding birthday-specific elements like cake or balloons")
        }

        if spec.genre.id == "anniversary" && !spec.elements.contains(where: { $0.category.id == "romance" }) {
            recommendations.append("Consider adding romantic elements like hearts or flowers")
        }

        if spec.genre.id == "achievement" && !spec.elements.contains(where: { $0.category.id == "achievement" }) {
            recommendations.append("Consider adding achievement elements like trophies or stars")
        }

        let culturalScore = calculateCulturalScore(spec)
        if culturalScore < 0.6 {
            recommendations.append("Consider adding more celebration-focused elements")
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

        // Universal scoring emphasizes appropriateness and joy
        let celebrationElements = spec.elements.filter {
            $0.category.id == "party" || $0.category.id == "birthday" || $0.category.id == "achievement"
        }
        let celebrationBonus = celebrationElements.isEmpty ? 0.0 : 0.1

        // Bonus for age-appropriate design
        let appropriatenessBonus = spec.elements.allSatisfy { element in
            element.ageAppropriate.contains { $0.id == spec.targetAgeGroup.id || $0.id == "any" }
        } ? 0.1 : 0.0

        return (genreScore * 0.3) + (avgElementScore * 0.4) + (paletteScore * 0.2) + celebrationBonus + appropriatenessBonus
    }
}

// MARK: - Context Registration
extension UniversalCulturalContext {
    static func register() {
        Task { @MainActor in
            CulturalContextManager.shared.registerContext(UniversalCulturalContext())
        }
    }
}
