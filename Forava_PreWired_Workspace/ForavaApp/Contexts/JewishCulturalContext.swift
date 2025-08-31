import Foundation
import SwiftUI

// MARK: - Jewish Cultural Context Implementation
struct JewishCulturalContext: CulturalContext {
    let identifier = "jewish_traditional"
    let displayName = "Jewish Traditional"
    let description = "Traditional Jewish celebration gifts - heritage, faith, and joyous festivals"
    let primaryLanguage = "he"
    let supportedLanguages = ["he", "en", "yi", "es", "fr", "ru", "ar"]

    // MARK: - Core Cultural Elements

    var genres: [CulturalGenre] {
        return [
            CulturalGenre(
                id: "shabbat",
                displayName: "Shabbat",
                icon: "candle.2.fill",
                basePrompt: "Shabbat celebration, peaceful rest, candles, blessing, holy day observance",
                culturalWeight: 1.0,
                suggestedElementIds: ["shabbat_candles", "challah_bread", "kiddush_cup", "star_of_david"],
                culturalContext: identifier
            ),
            CulturalGenre(
                id: "holidays",
                displayName: "Jewish Holidays",
                icon: "star.fill",
                basePrompt: "Jewish holiday celebration, festive traditions, religious observance, joyful gatherings",
                culturalWeight: 0.95,
                suggestedElementIds: ["menorah", "torah_scroll", "shofar", "holiday_symbols"],
                culturalContext: identifier
            ),
            CulturalGenre(
                id: "traditional",
                displayName: "Traditional",
                icon: "book.fill",
                basePrompt: "traditional Jewish art, heritage symbols, ancient wisdom, religious traditions",
                culturalWeight: 0.9,
                suggestedElementIds: ["star_of_david", "hebrew_text", "ancient_symbols", "traditional_patterns"],
                culturalContext: identifier
            ),
            CulturalGenre(
                id: "modern",
                displayName: "Contemporary",
                icon: "sparkles",
                basePrompt: "modern Jewish expression, contemporary design, cultural pride, artistic interpretation",
                culturalWeight: 0.8,
                suggestedElementIds: ["modern_star", "artistic_hebrew", "contemporary_symbols"],
                culturalContext: identifier
            )
        ]
    }

    var colorPalettes: [CulturalColorPalette] {
        return [
            CulturalColorPalette(
                id: "traditional",
                displayName: "Traditional Blue & White",
                colors: [
                    CulturalColor(name: "Tallit Blue", hex: "4169E1", symbolism: "Divine presence and heavenly connection"),
                    CulturalColor(name: "Pure White", hex: "FFFFFF", symbolism: "Purity and holiness"),
                    CulturalColor(name: "Silver", hex: "C0C0C0", symbolism: "Precious metals and Temple beauty"),
                    CulturalColor(name: "Deep Navy", hex: "000080", symbolism: "Night sky and divine mystery")
                ],
                promptTokens: ["blue and white", "Israeli colors", "tallit colors", "traditional Jewish"],
                culturalContext: identifier,
                culturalSignificance: 1.0
            ),
            CulturalColorPalette(
                id: "shabbat",
                displayName: "Shabbat Warmth",
                colors: [
                    CulturalColor(name: "Candle Gold", hex: "FFD700", symbolism: "Shabbat candle light and warmth"),
                    CulturalColor(name: "Wine Red", hex: "722F37", symbolism: "Kiddush wine and celebration"),
                    CulturalColor(name: "Challah Golden", hex: "DAA520", symbolism: "Challah bread and sustenance"),
                    CulturalColor(name: "Warm Cream", hex: "F5F5DC", symbolism: "Home warmth and peace")
                ],
                promptTokens: ["warm colors", "Shabbat colors", "candle glow", "home celebration"],
                culturalContext: identifier,
                culturalSignificance: 0.95
            ),
            CulturalColorPalette(
                id: "festive",
                displayName: "Holiday Festival",
                colors: [
                    CulturalColor(name: "Festival Blue", hex: "0080FF", symbolism: "Joy and celebration"),
                    CulturalColor(name: "Joyful Purple", hex: "663399", symbolism: "Royalty and majesty"),
                    CulturalColor(name: "Celebration Gold", hex: "FFB347", symbolism: "Precious moments and blessings"),
                    CulturalColor(name: "Clean White", hex: "F8F8FF", symbolism: "New beginnings and renewal")
                ],
                promptTokens: ["festive colors", "holiday celebration", "joyful palette", "festival blues"],
                culturalContext: identifier,
                culturalSignificance: 0.9
            )
        ]
    }

    var designElements: [CulturalDesignElement] {
        return [
            // Core Jewish Symbols
            CulturalDesignElement(
                id: "star_of_david",
                displayName: "Star of David (Magen David)",
                category: CulturalElementCategory(id: "symbols", displayName: "Sacred Symbols", icon: "star.fill", culturalContext: identifier),
                weight: 1.0,
                culturalSignificance: 1.0,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["traditional", "holidays", "modern"],
                promptTokens: ["Star of David", "Magen David", "Jewish star", "six-pointed star"],
                culturalContext: identifier,
                description: "Star of David (Magen David) - the most recognizable symbol of Judaism"
            ),
            CulturalDesignElement(
                id: "menorah",
                displayName: "Menorah",
                category: CulturalElementCategory(id: "ritual", displayName: "Ritual Objects", icon: "candle.2.fill", culturalContext: identifier),
                weight: 0.95,
                culturalSignificance: 1.0,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["traditional", "holidays"],
                promptTokens: ["menorah", "seven-branched candelabra", "Temple menorah", "eternal light"],
                culturalContext: identifier,
                description: "Seven-branched menorah representing the Temple and eternal light"
            ),
            CulturalDesignElement(
                id: "chanukah_menorah",
                displayName: "Chanukah Menorah (Hanukkiah)",
                category: CulturalElementCategory(id: "ritual", displayName: "Ritual Objects", icon: "candle.2.fill", culturalContext: identifier),
                weight: 0.9,
                culturalSignificance: 0.95,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["holidays"],
                promptTokens: ["hanukkiah", "Chanukah menorah", "nine-branched menorah", "Festival of Lights"],
                culturalContext: identifier,
                description: "Nine-branched Hanukkiah for Chanukah celebration"
            ),

            // Shabbat Elements
            CulturalDesignElement(
                id: "shabbat_candles",
                displayName: "Shabbat Candles",
                category: CulturalElementCategory(id: "shabbat", displayName: "Shabbat Elements", icon: "candle.2.fill", culturalContext: identifier),
                weight: 0.9,
                culturalSignificance: 0.9,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["shabbat", "traditional"],
                promptTokens: ["Shabbat candles", "Friday night candles", "blessing candles", "peaceful light"],
                culturalContext: identifier,
                description: "Shabbat candles welcoming the holy day with light and peace"
            ),
            CulturalDesignElement(
                id: "challah_bread",
                displayName: "Challah Bread",
                category: CulturalElementCategory(id: "shabbat", displayName: "Shabbat Elements", icon: "circle.grid.cross.fill", culturalContext: identifier),
                weight: 0.8,
                culturalSignificance: 0.85,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["shabbat", "holidays"],
                promptTokens: ["challah bread", "braided bread", "Shabbat bread", "holy bread"],
                culturalContext: identifier,
                description: "Traditional braided challah bread for Shabbat and holidays"
            ),
            CulturalDesignElement(
                id: "kiddush_cup",
                displayName: "Kiddush Cup",
                category: CulturalElementCategory(id: "ritual", displayName: "Ritual Objects", icon: "cup.and.saucer.fill", culturalContext: identifier),
                weight: 0.8,
                culturalSignificance: 0.85,
                ageAppropriate: [ageGroups[1], ageGroups[2], ageGroups[3]], // adult, elder, any
                compatibleGenreIds: ["shabbat", "holidays", "traditional"],
                promptTokens: ["kiddush cup", "wine cup", "sanctification cup", "blessing cup"],
                culturalContext: identifier,
                description: "Kiddush cup for wine blessing on Shabbat and holidays"
            ),

            // Religious Items
            CulturalDesignElement(
                id: "torah_scroll",
                displayName: "Torah Scroll",
                category: CulturalElementCategory(id: "sacred", displayName: "Sacred Items", icon: "scroll.fill", culturalContext: identifier),
                weight: 0.95,
                culturalSignificance: 1.0,
                ageAppropriate: [ageGroups[1], ageGroups[2], ageGroups[3]], // adult, elder, any
                compatibleGenreIds: ["traditional", "holidays"],
                promptTokens: ["Torah scroll", "sacred scroll", "holy scriptures", "parchment scroll"],
                culturalContext: identifier,
                description: "Sacred Torah scroll containing the Five Books of Moses"
            ),
            CulturalDesignElement(
                id: "shofar",
                displayName: "Shofar",
                category: CulturalElementCategory(id: "ritual", displayName: "Ritual Objects", icon: "speaker.wave.2.fill", culturalContext: identifier),
                weight: 0.85,
                culturalSignificance: 0.9,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["holidays", "traditional"],
                promptTokens: ["shofar", "ram's horn", "ritual horn", "call to prayer"],
                culturalContext: identifier,
                description: "Shofar ram's horn blown during High Holy Days"
            ),

            // Hebrew and Text Elements
            CulturalDesignElement(
                id: "hebrew_text",
                displayName: "Hebrew Text",
                category: CulturalElementCategory(id: "text", displayName: "Sacred Text", icon: "textformat.abc", culturalContext: identifier),
                weight: 0.9,
                culturalSignificance: 0.95,
                ageAppropriate: [ageGroups[1], ageGroups[2], ageGroups[3]], // adult, elder, any
                compatibleGenreIds: ["traditional", "modern"],
                promptTokens: ["Hebrew text", "Hebrew letters", "sacred Hebrew", "Jewish script"],
                culturalContext: identifier,
                description: "Sacred Hebrew text and lettering"
            ),
            CulturalDesignElement(
                id: "hebrew_blessings",
                displayName: "Hebrew Blessings",
                category: CulturalElementCategory(id: "text", displayName: "Sacred Text", icon: "textformat.abc", culturalContext: identifier),
                weight: 0.85,
                culturalSignificance: 0.9,
                ageAppropriate: [ageGroups[1], ageGroups[2], ageGroups[3]], // adult, elder, any
                compatibleGenreIds: ["traditional", "shabbat", "holidays"],
                promptTokens: ["Hebrew blessings", "prayer text", "blessing words", "sacred phrases"],
                culturalContext: identifier,
                description: "Traditional Hebrew blessings and prayers"
            ),

            // Cultural Patterns
            CulturalDesignElement(
                id: "jewish_patterns",
                displayName: "Traditional Jewish Patterns",
                category: CulturalElementCategory(id: "patterns", displayName: "Traditional Patterns", icon: "square.grid.3x3.fill", culturalContext: identifier),
                weight: 0.7,
                culturalSignificance: 0.8,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["traditional", "modern"],
                promptTokens: ["Jewish patterns", "traditional designs", "geometric patterns", "heritage motifs"],
                culturalContext: identifier,
                description: "Traditional Jewish artistic patterns and geometric designs"
            )
        ]
    }

    var ageGroups: [CulturalAgeGroup] {
        return [
            CulturalAgeGroup(
                id: "young",
                displayName: "Young",
                ageRange: "5-18 years",
                preferences: ["colorful", "festive", "educational", "joyful celebrations", "simple symbols"],
                culturalContext: identifier
            ),
            CulturalAgeGroup(
                id: "adult",
                displayName: "Adult",
                ageRange: "18-50 years",
                preferences: ["meaningful", "traditional", "balanced", "family-oriented", "spiritual"],
                culturalContext: identifier
            ),
            CulturalAgeGroup(
                id: "elder",
                displayName: "Elder",
                ageRange: "50+ years",
                preferences: ["traditional", "reverent", "heritage-focused", "dignified", "sacred"],
                culturalContext: identifier
            ),
            CulturalAgeGroup(
                id: "any",
                displayName: "Any Age",
                ageRange: "All ages",
                preferences: ["universal", "peaceful", "meaningful", "family-friendly", "blessed"],
                culturalContext: identifier
            )
        ]
    }

    // MARK: - AI Generation Parameters

    var basePromptEnhancers: [String] {
        return [
            "Jewish traditional art",
            "Hebrew cultural heritage",
            "religious devotion",
            "sacred traditions",
            "Jewish celebrations",
            "ritual beauty",
            "handcrafted Jewish art",
            "centered composition",
            "isolated on clean background",
            "masterpiece quality",
            "best quality",
            "ultra detailed",
            "professional photography",
            "perfect lighting",
            "sharp focus",
            "reverent presentation",
            "cultural authenticity"
        ]
    }

    var culturalNegativePrompts: [String] {
        return [
            "not Christian",
            "not Islamic",
            "not other religions",
            "no inappropriate religious mixing",
            "no disrespectful Jewish imagery",
            "no modern technology",
            "no inappropriate Jewish symbols",
            "no offensive religious content",
            "no antisemitic imagery",
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
        return JewishCulturalValidator()
    }

    var animationStyle: CulturalAnimationStyle {
        return CulturalAnimationStyle(
            primaryStyle: "gentle-elegant",
            duration: 3.0,
            effects: ["candle_glow", "peaceful_shimmer", "holy_light", "gentle_flow"],
            culturalElements: ["golden_sparkles", "soft_glow", "peaceful_waves"]
        )
    }
}

// MARK: - Jewish Cultural Validator
class JewishCulturalValidator: CulturalValidator, CulturalValidatorProtocol {

    private let inappropriateElements: Set<String> = [
        // Elements that are religiously inappropriate or potentially offensive
        // This would be populated based on rabbinical and cultural expert consultation
    ]

    private let sensitiveElements: Set<String> = [
        "torah_scroll",
        "star_of_david",
        "hebrew_text",
        "hebrew_blessings"
    ]

    func validateDesignSpec(_ spec: CulturalDesignSpec) -> CulturalValidationResult {
        var warnings: [String] = []
        var errors: [String] = []
        var recommendations: [String] = []

        // Validate cultural context
        guard spec.culturalContext == "jewish_traditional" else {
            errors.append("Invalid cultural context for Jewish validation")
            return CulturalValidationResult(isValid: false, errors: errors)
        }

        // Validate elements
        for element in spec.elements {
            if inappropriateElements.contains(element.id) {
                errors.append("Element '\(element.displayName)' is inappropriate for Jewish context")
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

        // Jewish-specific recommendations
        if spec.elements.isEmpty {
            recommendations.append("Consider adding traditional Jewish symbols like Star of David or menorah")
        }

        if !spec.elements.contains(where: { $0.category.id == "symbols" || $0.category.id == "ritual" }) {
            recommendations.append("Adding ritual objects or sacred symbols enhances Jewish authenticity")
        }

        // Check genre-element alignment
        if spec.genre.id == "shabbat" && !spec.elements.contains(where: { $0.category.id == "shabbat" }) {
            recommendations.append("Consider adding Shabbat elements like candles or challah for Shabbat genre")
        }

        if spec.genre.id == "holidays" && !spec.elements.contains(where: { $0.category.id == "ritual" }) {
            recommendations.append("Consider adding holiday ritual objects for Jewish holidays genre")
        }

        // Check for appropriate Hebrew text usage
        let hebrewElements = spec.elements.filter { $0.category.id == "text" }
        if hebrewElements.count > 1 {
            warnings.append("Multiple Hebrew text elements - ensure proper Hebrew grammar and religious appropriateness")
        }

        // Check color appropriateness
        if spec.colorPalette.id == "traditional" && !spec.elements.contains(where: { $0.id == "star_of_david" }) {
            recommendations.append("Traditional blue and white colors pair well with Star of David")
        }

        let culturalScore = calculateCulturalScore(spec)
        if culturalScore < 0.7 {
            recommendations.append("Consider adding more traditional Jewish elements to increase authenticity")
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

        // Jewish scoring emphasizes sacred symbols and ritual objects
        let sacredElements = spec.elements.filter {
            $0.category.id == "symbols" || $0.category.id == "ritual" || $0.category.id == "sacred"
        }
        let sacredBonus = sacredElements.isEmpty ? 0.0 : 0.15

        // Bonus for appropriate genre-element matching
        let genreAlignment: Double
        if spec.genre.id == "shabbat" {
            let shabbatElements = spec.elements.filter { $0.category.id == "shabbat" }
            genreAlignment = shabbatElements.isEmpty ? 0.0 : 0.1
        } else if spec.genre.id == "holidays" {
            let holidayElements = spec.elements.filter { $0.category.id == "ritual" }
            genreAlignment = holidayElements.isEmpty ? 0.0 : 0.1
        } else {
            genreAlignment = 0.05 // small bonus for other genres
        }

        return (genreScore * 0.3) + (avgElementScore * 0.4) + (paletteScore * 0.2) + sacredBonus + genreAlignment
    }
}

// MARK: - Context Registration
extension JewishCulturalContext {
    static func register() {
        Task { @MainActor in
            CulturalContextManager.shared.registerContext(JewishCulturalContext())
        }
    }
}
