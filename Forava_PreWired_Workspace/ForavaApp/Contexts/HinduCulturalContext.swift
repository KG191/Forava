import Foundation
import SwiftUI

// MARK: - Hindu Cultural Context Implementation (Enhanced)
struct HinduCulturalContext: CulturalContext {
    let identifier = "hindu_festivals"
    let displayName = "Hindu Festivals"
    let description = "Traditional Hindu celebrations - Raksha Bandhan, Diwali, Holi, and sacred festivals"
    let primaryLanguage = "hi"
    let supportedLanguages = ["hi", "en", "ur", "bn", "gu", "mr", "ta", "te", "kn", "ml", "pa", "or"]

    // MARK: - Core Cultural Elements

    var genres: [CulturalGenre] {
        return [
            CulturalGenre(
                id: "raksha_bandhan",
                displayName: "Raksha Bandhan",
                icon: "heart.fill",
                basePrompt: "Raksha Bandhan celebration, sacred thread, sibling bond, traditional rakhi, brother-sister love, protection blessing",
                culturalWeight: 1.0,
                suggestedElementIds: ["red_thread_mauli", "gold_beads", "om_symbol", "sacred_thread"],
                culturalContext: identifier
            ),
            CulturalGenre(
                id: "diwali",
                displayName: "Diwali Festival",
                icon: "flame.fill",
                basePrompt: "Diwali festival of lights, diyas, rangoli patterns, lakshmi celebration, prosperity and light, victory of good over evil",
                culturalWeight: 1.0,
                suggestedElementIds: ["diya_lamps", "rangoli_patterns", "lakshmi_lotus", "fireworks_motif"],
                culturalContext: identifier
            ),
            CulturalGenre(
                id: "holi",
                displayName: "Holi Festival",
                icon: "paintpalette.fill",
                basePrompt: "Holi festival of colors, vibrant powder colors, spring celebration, joy and unity, colorful festival",
                culturalWeight: 0.95,
                suggestedElementIds: ["color_powder", "spring_flowers", "celebration_dance", "unity_hands"],
                culturalContext: identifier
            ),
            CulturalGenre(
                id: "traditional",
                displayName: "Traditional Hindu",
                icon: "star.circle.fill",
                basePrompt: "traditional Hindu art, sacred geometry, spiritual symbols, temple art, devotional design",
                culturalWeight: 0.9,
                suggestedElementIds: ["om_symbol", "lotus_flower", "mandala_pattern", "sacred_geometry"],
                culturalContext: identifier
            ),
            CulturalGenre(
                id: "spiritual",
                displayName: "Spiritual Devotion",
                icon: "hands.clap.fill",
                basePrompt: "Hindu spiritual art, devotion and prayer, sacred mantras, divine connection, peaceful meditation",
                culturalWeight: 0.85,
                suggestedElementIds: ["prayer_hands", "meditation_pose", "sacred_mantras", "divine_light"],
                culturalContext: identifier
            )
        ]
    }

    var colorPalettes: [CulturalColorPalette] {
        return [
            CulturalColorPalette(
                id: "diwali",
                displayName: "Diwali Festival",
                colors: [
                    CulturalColor(name: "Diwali Orange", hex: "FF6B35", symbolism: "Sacred fire and prosperity"),
                    CulturalColor(name: "Golden Yellow", hex: "FFD700", symbolism: "Lakshmi's blessings and wealth"),
                    CulturalColor(name: "Deep Purple", hex: "663399", symbolism: "Spiritual wealth and wisdom"),
                    CulturalColor(name: "Sacred Red", hex: "DC143C", symbolism: "Auspiciousness and power")
                ],
                promptTokens: ["Diwali colors", "festival of lights", "deep orange", "golden yellow", "sacred Hindu colors"],
                culturalContext: identifier,
                culturalSignificance: 1.0
            ),
            CulturalColorPalette(
                id: "holi",
                displayName: "Holi Colors",
                colors: [
                    CulturalColor(name: "Gulal Pink", hex: "FF1493", symbolism: "Joy and love celebration"),
                    CulturalColor(name: "Spring Green", hex: "32CD32", symbolism: "New life and growth"),
                    CulturalColor(name: "Sky Blue", hex: "87CEEB", symbolism: "Krishna's divine play"),
                    CulturalColor(name: "Turmeric Yellow", hex: "FFFF00", symbolism: "Prosperity and purity")
                ],
                promptTokens: ["Holi colors", "festival colors", "vibrant gulal", "spring celebration", "colorful powder"],
                culturalContext: identifier,
                culturalSignificance: 0.95
            ),
            CulturalColorPalette(
                id: "traditional",
                displayName: "Traditional Hindu",
                colors: [
                    CulturalColor(name: "Saffron Orange", hex: "FF9933", symbolism: "Sacred fire and renunciation"),
                    CulturalColor(name: "Vermillion Red", hex: "E34234", symbolism: "Power and purity"),
                    CulturalColor(name: "Turmeric Yellow", hex: "FDD017", symbolism: "Knowledge and learning"),
                    CulturalColor(name: "Sacred White", hex: "FFFFFF", symbolism: "Peace and spirituality")
                ],
                promptTokens: ["traditional Hindu colors", "saffron", "vermillion", "sacred colors", "temple colors"],
                culturalContext: identifier,
                culturalSignificance: 0.9
            ),
            CulturalColorPalette(
                id: "rakhi",
                displayName: "Rakhi Traditional",
                colors: [
                    CulturalColor(name: "Sacred Red", hex: "DC143C", symbolism: "Protection and sibling love"),
                    CulturalColor(name: "Golden Thread", hex: "DAA520", symbolism: "Precious bond and prosperity"),
                    CulturalColor(name: "Pearl White", hex: "F8F8FF", symbolism: "Purity and blessings"),
                    CulturalColor(name: "Royal Purple", hex: "663399", symbolism: "Dignity and respect")
                ],
                promptTokens: ["Rakhi colors", "traditional rakhi", "sacred thread colors", "sibling bond colors"],
                culturalContext: identifier,
                culturalSignificance: 1.0
            )
        ]
    }

    var designElements: [CulturalDesignElement] {
        return [
            // Raksha Bandhan Elements
            CulturalDesignElement(
                id: "red_thread_mauli",
                displayName: "Sacred Rakhi Thread",
                category: CulturalElementCategory(id: "rakhi", displayName: "Rakhi Elements", icon: "link", culturalContext: identifier),
                weight: 1.0,
                culturalSignificance: 1.0,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["raksha_bandhan", "traditional"],
                promptTokens: ["rakhi thread", "sacred thread", "red mauli", "sibling bond thread"],
                culturalContext: identifier,
                description: "Sacred red thread (mauli) representing the protective bond between siblings"
            ),

            // Diwali Elements
            CulturalDesignElement(
                id: "diya_lamps",
                displayName: "Diya Oil Lamps",
                category: CulturalElementCategory(id: "diwali", displayName: "Diwali Elements", icon: "flame.fill", culturalContext: identifier),
                weight: 1.0,
                culturalSignificance: 1.0,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["diwali", "traditional"],
                promptTokens: ["diya lamps", "oil lamps", "Diwali lights", "festival lamps", "earthen lamps"],
                culturalContext: identifier,
                description: "Traditional clay oil lamps (diyas) symbolizing light conquering darkness"
            ),
            CulturalDesignElement(
                id: "rangoli_patterns",
                displayName: "Rangoli Patterns",
                category: CulturalElementCategory(id: "diwali", displayName: "Diwali Elements", icon: "hexagon.fill", culturalContext: identifier),
                weight: 0.9,
                culturalSignificance: 0.95,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["diwali", "traditional"],
                promptTokens: ["rangoli patterns", "kolam designs", "floor art", "geometric patterns", "colorful rangoli"],
                culturalContext: identifier,
                description: "Traditional rangoli floor patterns made during Diwali for prosperity"
            ),
            CulturalDesignElement(
                id: "lakshmi_lotus",
                displayName: "Lakshmi Lotus",
                category: CulturalElementCategory(id: "spiritual", displayName: "Spiritual Elements", icon: "leaf.fill", culturalContext: identifier),
                weight: 0.9,
                culturalSignificance: 1.0,
                ageAppropriate: [ageGroups[1], ageGroups[2], ageGroups[3]], // adult, elder, any
                compatibleGenreIds: ["diwali", "spiritual", "traditional"],
                promptTokens: ["lotus flower", "Lakshmi lotus", "divine lotus", "prosperity symbol"],
                culturalContext: identifier,
                description: "Sacred lotus associated with Goddess Lakshmi, symbol of prosperity and purity"
            ),

            // Holi Elements
            CulturalDesignElement(
                id: "color_powder",
                displayName: "Gulal Color Powder",
                category: CulturalElementCategory(id: "holi", displayName: "Holi Elements", icon: "paintpalette.fill", culturalContext: identifier),
                weight: 1.0,
                culturalSignificance: 0.9,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["holi"],
                promptTokens: ["gulal powder", "Holi colors", "color powder", "vibrant colors", "festive powder"],
                culturalContext: identifier,
                description: "Colorful gulal powder used in Holi celebration representing joy and unity"
            ),
            CulturalDesignElement(
                id: "spring_flowers",
                displayName: "Spring Flowers",
                category: CulturalElementCategory(id: "holi", displayName: "Holi Elements", icon: "leaf.fill", culturalContext: identifier),
                weight: 0.8,
                culturalSignificance: 0.8,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["holi", "traditional"],
                promptTokens: ["spring flowers", "Holi flowers", "marigold flowers", "colorful blooms"],
                culturalContext: identifier,
                description: "Beautiful spring flowers celebrating renewal and the arrival of spring"
            ),

            // Sacred Symbols
            CulturalDesignElement(
                id: "om_symbol",
                displayName: "Om Symbol (ॐ)",
                category: CulturalElementCategory(id: "spiritual", displayName: "Spiritual Elements", icon: "circle", culturalContext: identifier),
                weight: 0.95,
                culturalSignificance: 1.0,
                ageAppropriate: [ageGroups[1], ageGroups[2], ageGroups[3]], // adult, elder, any
                compatibleGenreIds: ["traditional", "spiritual", "raksha_bandhan"],
                promptTokens: ["Om symbol", "Aum", "sacred symbol", "Hindu Om", "spiritual Om"],
                culturalContext: identifier,
                description: "Sacred Om symbol representing the divine sound of the universe"
            ),
            CulturalDesignElement(
                id: "lotus_flower",
                displayName: "Sacred Lotus",
                category: CulturalElementCategory(id: "spiritual", displayName: "Spiritual Elements", icon: "leaf.fill", culturalContext: identifier),
                weight: 0.9,
                culturalSignificance: 0.95,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["traditional", "spiritual", "diwali"],
                promptTokens: ["lotus flower", "sacred lotus", "Hindu lotus", "divine flower", "spiritual bloom"],
                culturalContext: identifier,
                description: "Sacred lotus flower representing purity, enlightenment, and divine beauty"
            ),
            CulturalDesignElement(
                id: "mandala_pattern",
                displayName: "Mandala Patterns",
                category: CulturalElementCategory(id: "spiritual", displayName: "Spiritual Elements", icon: "circle.hexagongrid.fill", culturalContext: identifier),
                weight: 0.8,
                culturalSignificance: 0.9,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["traditional", "spiritual"],
                promptTokens: ["mandala patterns", "sacred geometry", "circular patterns", "spiritual mandala"],
                culturalContext: identifier,
                description: "Traditional mandala patterns representing the cosmos and spiritual journey"
            ),

            // Traditional Elements
            CulturalDesignElement(
                id: "gold_beads",
                displayName: "Golden Beads",
                category: CulturalElementCategory(id: "decorative", displayName: "Decorative Elements", icon: "circle.fill", culturalContext: identifier),
                weight: 0.7,
                culturalSignificance: 0.8,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["raksha_bandhan", "traditional", "diwali"],
                promptTokens: ["golden beads", "decorative beads", "precious beads", "ornamental gold"],
                culturalContext: identifier,
                description: "Traditional golden beads used in religious and festive decorations"
            ),
            CulturalDesignElement(
                id: "prayer_hands",
                displayName: "Prayer Hands (Namaste)",
                category: CulturalElementCategory(id: "spiritual", displayName: "Spiritual Elements", icon: "hands.clap.fill", culturalContext: identifier),
                weight: 0.85,
                culturalSignificance: 0.9,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["spiritual", "traditional"],
                promptTokens: ["namaste hands", "prayer hands", "anjali mudra", "respectful greeting"],
                culturalContext: identifier,
                description: "Traditional namaste gesture representing respect and spiritual greeting"
            )
        ]
    }

    var ageGroups: [CulturalAgeGroup] {
        return [
            CulturalAgeGroup(
                id: "young",
                displayName: "Young",
                ageRange: "5-18 years",
                preferences: ["colorful", "festive", "joyful", "bright festivals", "fun celebrations"],
                culturalContext: identifier
            ),
            CulturalAgeGroup(
                id: "adult",
                displayName: "Adult",
                ageRange: "18-50 years",
                preferences: ["meaningful", "traditional", "spiritual", "family-oriented", "devotional"],
                culturalContext: identifier
            ),
            CulturalAgeGroup(
                id: "elder",
                displayName: "Elder",
                ageRange: "50+ years",
                preferences: ["traditional", "spiritual", "reverent", "sacred", "classical"],
                culturalContext: identifier
            ),
            CulturalAgeGroup(
                id: "any",
                displayName: "Any Age",
                ageRange: "All ages",
                preferences: ["universal", "peaceful", "blessed", "harmonious", "auspicious"],
                culturalContext: identifier
            )
        ]
    }

    // MARK: - AI Generation Parameters

    var basePromptEnhancers: [String] {
        return [
            "Hindu traditional art",
            "Indian festival celebration",
            "sacred Hindu symbols",
            "spiritual devotion",
            "cultural authenticity",
            "traditional Indian design",
            "handcrafted traditional art",
            "centered composition",
            "isolated on clean background",
            "masterpiece quality",
            "best quality",
            "ultra detailed",
            "professional photography",
            "perfect lighting",
            "sharp focus",
            "spiritual atmosphere",
            "festival celebration"
        ]
    }

    var culturalNegativePrompts: [String] {
        return [
            "not other religions",
            "no inappropriate religious mixing",
            "no disrespectful Hindu imagery",
            "no modern technology",
            "no inappropriate Hindu symbols",
            "no offensive religious content",
            "no inappropriate use of sacred symbols",
            "no commercialization of religious imagery",
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
        return HinduCulturalValidator()
    }

    var animationStyle: CulturalAnimationStyle {
        return CulturalAnimationStyle(
            primaryStyle: "spiritual-festive",
            duration: 3.0,
            effects: ["diya_glow", "color_burst", "spiritual_shimmer", "festive_sparkle"],
            culturalElements: ["floating_diyas", "color_powder_burst", "golden_particles"]
        )
    }
}

// MARK: - Hindu Cultural Validator
class HinduCulturalValidator: CulturalValidator, CulturalValidatorProtocol {

    private let inappropriateElements: Set<String> = [
        // Elements that are religiously inappropriate or disrespectful
        // This would be populated based on Hindu religious expert consultation
    ]

    private let sensitiveElements: Set<String> = [
        "om_symbol",
        "lakshmi_lotus",
        "prayer_hands",
        "mandala_pattern"
    ]

    func validateDesignSpec(_ spec: CulturalDesignSpec) -> CulturalValidationResult {
        var warnings: [String] = []
        var errors: [String] = []
        var recommendations: [String] = []

        // Validate cultural context
        guard spec.culturalContext == "hindu_festivals" else {
            errors.append("Invalid cultural context for Hindu validation")
            return CulturalValidationResult(isValid: false, errors: errors)
        }

        // Validate elements
        for element in spec.elements {
            if inappropriateElements.contains(element.id) {
                errors.append("Element '\(element.displayName)' is inappropriate for Hindu context")
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

        // Hindu-specific recommendations
        if spec.elements.isEmpty {
            recommendations.append("Consider adding traditional Hindu elements like lotus flowers or diyas")
        }

        // Festival-specific recommendations
        if spec.genre.id == "diwali" && !spec.elements.contains(where: { $0.category.id == "diwali" }) {
            recommendations.append("Consider adding Diwali-specific elements like diyas or rangoli patterns")
        }

        if spec.genre.id == "holi" && !spec.elements.contains(where: { $0.category.id == "holi" }) {
            recommendations.append("Consider adding Holi-specific elements like color powder or spring flowers")
        }

        if spec.genre.id == "raksha_bandhan" && !spec.elements.contains(where: { $0.category.id == "rakhi" }) {
            recommendations.append("Consider adding rakhi-specific elements like sacred thread")
        }

        let culturalScore = calculateCulturalScore(spec)
        if culturalScore < 0.7 {
            recommendations.append("Consider adding more traditional Hindu elements to increase authenticity")
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

        // Hindu scoring emphasizes festival-specific elements and spiritual symbols
        let festivalElements = spec.elements.filter {
            $0.category.id == "diwali" || $0.category.id == "holi" || $0.category.id == "rakhi"
        }
        let festivalBonus = festivalElements.isEmpty ? 0.0 : 0.15

        // Bonus for spiritual elements
        let spiritualElements = spec.elements.filter { $0.category.id == "spiritual" }
        let spiritualBonus = spiritualElements.isEmpty ? 0.0 : 0.1

        return (genreScore * 0.3) + (avgElementScore * 0.35) + (paletteScore * 0.2) + festivalBonus + spiritualBonus
    }
}

// MARK: - Context Registration
extension HinduCulturalContext {
    static func register() {
        Task { @MainActor in
            CulturalContextManager.shared.registerContext(HinduCulturalContext())
        }
    }
}
