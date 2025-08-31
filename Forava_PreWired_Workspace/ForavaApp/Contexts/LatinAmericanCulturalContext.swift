import Foundation
import SwiftUI

// MARK: - Latin American Cultural Context Implementation
struct LatinAmericanCulturalContext: CulturalContext {
    let identifier = "latin_american_traditional"
    let displayName = "Latin American Traditional"
    let description = "Traditional Latin American arts and celebration - vibrant culture, family bonds, and festive spirit"
    let primaryLanguage = "es"
    let supportedLanguages = ["es", "pt", "qu", "gn", "en"]

    // MARK: - Core Cultural Elements

    var genres: [CulturalGenre] {
        return [
            CulturalGenre(
                id: "traditional",
                displayName: "Tradicional",
                icon: "sun.max.fill",
                basePrompt: "traditional Latin American art, indigenous patterns, colonial influence, cultural heritage, authentic folk art",
                culturalWeight: 1.0,
                suggestedElementIds: ["aztec_patterns", "talavera_pottery", "papel_picado", "indigenous_symbols"],
                culturalContext: identifier
            ),
            CulturalGenre(
                id: "festive",
                displayName: "Festivo",
                icon: "party.popper.fill",
                basePrompt: "Latin American celebration, fiesta colors, joyful patterns, carnival spirit, festive decorations",
                culturalWeight: 0.95,
                suggestedElementIds: ["carnival_motifs", "fiesta_colors", "celebration_patterns", "dance_elements"],
                culturalContext: identifier
            ),
            CulturalGenre(
                id: "nature",
                displayName: "Naturaleza",
                icon: "leaf.fill",
                basePrompt: "Latin American nature art, tropical flora, rainforest beauty, natural abundance, biodiversity celebration",
                culturalWeight: 0.9,
                suggestedElementIds: ["tropical_flowers", "rainforest_elements", "hummingbird_motifs", "jaguar_symbols"],
                culturalContext: identifier
            ),
            CulturalGenre(
                id: "spiritual",
                displayName: "Espiritual",
                icon: "heart.fill",
                basePrompt: "Latin American spiritual art, Day of the Dead beauty, sacred traditions, ancestral reverence",
                culturalWeight: 0.85,
                suggestedElementIds: ["calavera_art", "spiritual_symbols", "ancestral_motifs", "sacred_hearts"],
                culturalContext: identifier
            )
        ]
    }

    var colorPalettes: [CulturalColorPalette] {
        return [
            CulturalColorPalette(
                id: "vibrant",
                displayName: "Colores Vibrantes",
                colors: [
                    CulturalColor(name: "Sunset Orange", hex: "FF6B35", symbolism: "Warmth and passionate spirit"),
                    CulturalColor(name: "Fiesta Pink", hex: "FF1493", symbolism: "Joy and celebration of life"),
                    CulturalColor(name: "Tropical Turquoise", hex: "40E0D0", symbolism: "Caribbean waters and freedom"),
                    CulturalColor(name: "Golden Marigold", hex: "FFB347", symbolism: "Day of the Dead remembrance")
                ],
                promptTokens: ["vibrant colors", "fiesta colors", "tropical palette", "celebration colors"],
                culturalContext: identifier,
                culturalSignificance: 1.0
            ),
            CulturalColorPalette(
                id: "earth",
                displayName: "Tierra y Sol",
                colors: [
                    CulturalColor(name: "Adobe Clay", hex: "CD853F", symbolism: "Connection to ancestral earth"),
                    CulturalColor(name: "Terracotta Red", hex: "E2725B", symbolism: "Pottery traditions and craftsmanship"),
                    CulturalColor(name: "Sunflower Yellow", hex: "FFD700", symbolism: "Sun worship and abundance"),
                    CulturalColor(name: "Cactus Green", hex: "556B2F", symbolism: "Desert resilience and endurance")
                ],
                promptTokens: ["earth tones", "natural colors", "adobe colors", "desert palette"],
                culturalContext: identifier,
                culturalSignificance: 0.9
            ),
            CulturalColorPalette(
                id: "tropical",
                displayName: "Paraíso Tropical",
                colors: [
                    CulturalColor(name: "Parrot Green", hex: "32CD32", symbolism: "Rainforest vitality and life"),
                    CulturalColor(name: "Hibiscus Red", hex: "DC143C", symbolism: "Tropical passion and beauty"),
                    CulturalColor(name: "Ocean Blue", hex: "00CED1", symbolism: "Caribbean seas and adventure"),
                    CulturalColor(name: "Banana Yellow", hex: "FFFF99", symbolism: "Tropical abundance and happiness")
                ],
                promptTokens: ["tropical colors", "rainforest palette", "Caribbean colors", "natural vibrance"],
                culturalContext: identifier,
                culturalSignificance: 0.85
            )
        ]
    }

    var designElements: [CulturalDesignElement] {
        return [
            // Pre-Columbian Elements
            CulturalDesignElement(
                id: "aztec_patterns",
                displayName: "Aztec Patterns",
                category: CulturalElementCategory(id: "patterns", displayName: "Indigenous Patterns", icon: "square.grid.3x3.fill", culturalContext: identifier),
                weight: 0.95,
                culturalSignificance: 1.0,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["traditional", "spiritual"],
                promptTokens: ["Aztec patterns", "pre-Columbian art", "indigenous designs", "ancient symbols"],
                culturalContext: identifier,
                description: "Traditional Aztec patterns representing ancient wisdom and cultural heritage"
            ),
            CulturalDesignElement(
                id: "mayan_symbols",
                displayName: "Mayan Symbols",
                category: CulturalElementCategory(id: "symbols", displayName: "Sacred Symbols", icon: "pyramid.fill", culturalContext: identifier),
                weight: 0.9,
                culturalSignificance: 0.95,
                ageAppropriate: [ageGroups[1], ageGroups[2], ageGroups[3]], // adult, elder, any
                compatibleGenreIds: ["traditional", "spiritual"],
                promptTokens: ["Mayan symbols", "ancient glyphs", "pyramid motifs", "calendar symbols"],
                culturalContext: identifier,
                description: "Sacred Mayan symbols representing cosmic knowledge and spiritual connection"
            ),
            CulturalDesignElement(
                id: "quetzal_bird",
                displayName: "Quetzal Bird",
                category: CulturalElementCategory(id: "nature", displayName: "Sacred Nature", icon: "bird.fill", culturalContext: identifier),
                weight: 0.8,
                culturalSignificance: 0.9,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["traditional", "nature"],
                promptTokens: ["quetzal bird", "sacred bird", "Mesoamerican symbol", "freedom bird"],
                culturalContext: identifier,
                description: "Quetzal bird symbolizing freedom, beauty, and divine messenger"
            ),

            // Colonial and Folk Art Elements
            CulturalDesignElement(
                id: "talavera_pottery",
                displayName: "Talavera Patterns",
                category: CulturalElementCategory(id: "crafts", displayName: "Traditional Crafts", icon: "circle.hexagongrid.fill", culturalContext: identifier),
                weight: 0.85,
                culturalSignificance: 0.9,
                ageAppropriate: [ageGroups[1], ageGroups[2], ageGroups[3]], // adult, elder, any
                compatibleGenreIds: ["traditional"],
                promptTokens: ["Talavera pottery", "Mexican ceramics", "folk art patterns", "colonial art"],
                culturalContext: identifier,
                description: "Traditional Talavera pottery patterns blending indigenous and Spanish influences"
            ),
            CulturalDesignElement(
                id: "papel_picado",
                displayName: "Papel Picado",
                category: CulturalElementCategory(id: "crafts", displayName: "Traditional Crafts", icon: "scissors", culturalContext: identifier),
                weight: 0.8,
                culturalSignificance: 0.85,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["festive", "traditional"],
                promptTokens: ["papel picado", "paper flags", "Mexican decorations", "fiesta banners"],
                culturalContext: identifier,
                description: "Traditional papel picado representing celebration and community gathering"
            ),

            // Nature Elements
            CulturalDesignElement(
                id: "tropical_flowers",
                displayName: "Tropical Flowers",
                category: CulturalElementCategory(id: "nature", displayName: "Sacred Nature", icon: "leaf.fill", culturalContext: identifier),
                weight: 0.8,
                culturalSignificance: 0.8,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["nature", "festive"],
                promptTokens: ["tropical flowers", "hibiscus", "bougainvillea", "jungle flowers"],
                culturalContext: identifier,
                description: "Vibrant tropical flowers representing natural abundance and beauty"
            ),
            CulturalDesignElement(
                id: "hummingbird_motifs",
                displayName: "Hummingbird Motifs",
                category: CulturalElementCategory(id: "nature", displayName: "Sacred Nature", icon: "bird.fill", culturalContext: identifier),
                weight: 0.75,
                culturalSignificance: 0.8,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["nature", "spiritual"],
                promptTokens: ["hummingbird", "colibri", "messenger bird", "nectar seeker"],
                culturalContext: identifier,
                description: "Hummingbird representing joy, love, and messages between worlds"
            ),

            // Cultural Celebrations
            CulturalDesignElement(
                id: "calavera_art",
                displayName: "Calavera Art",
                category: CulturalElementCategory(id: "spiritual", displayName: "Spiritual Elements", icon: "theatermasks.fill", culturalContext: identifier),
                weight: 0.8,
                culturalSignificance: 0.95,
                ageAppropriate: [ageGroups[1], ageGroups[2], ageGroups[3]], // adult, elder, any
                compatibleGenreIds: ["spiritual", "traditional"],
                promptTokens: ["sugar skulls", "Day of the Dead", "calaveras", "ancestral art"],
                culturalContext: identifier,
                description: "Beautiful calavera art celebrating life and honoring ancestors"
            ),
            CulturalDesignElement(
                id: "carnival_motifs",
                displayName: "Carnival Motifs",
                category: CulturalElementCategory(id: "celebration", displayName: "Festive Elements", icon: "theatermasks.fill", culturalContext: identifier),
                weight: 0.7,
                culturalSignificance: 0.8,
                ageAppropriate: [ageGroups[0], ageGroups[1], ageGroups[3]], // young, adult, any
                compatibleGenreIds: ["festive"],
                promptTokens: ["carnival masks", "Brazilian carnival", "feathers", "dancing figures"],
                culturalContext: identifier,
                description: "Vibrant carnival elements representing joy, music, and cultural celebration"
            ),

            // Religious and Spiritual
            CulturalDesignElement(
                id: "sacred_hearts",
                displayName: "Sacred Hearts",
                category: CulturalElementCategory(id: "spiritual", displayName: "Spiritual Elements", icon: "heart.fill", culturalContext: identifier),
                weight: 0.8,
                culturalSignificance: 0.9,
                ageAppropriate: [ageGroups[1], ageGroups[2], ageGroups[3]], // adult, elder, any
                compatibleGenreIds: ["spiritual", "traditional"],
                promptTokens: ["sacred heart", "religious art", "devotional symbols", "love symbols"],
                culturalContext: identifier,
                description: "Sacred hearts representing divine love, devotion, and spiritual connection"
            ),
            CulturalDesignElement(
                id: "virgin_mary_motifs",
                displayName: "Virgin Mary Motifs",
                category: CulturalElementCategory(id: "spiritual", displayName: "Spiritual Elements", icon: "sparkles", culturalContext: identifier),
                weight: 0.85,
                culturalSignificance: 0.95,
                ageAppropriate: [ageGroups[1], ageGroups[2], ageGroups[3]], // adult, elder, any
                compatibleGenreIds: ["spiritual", "traditional"],
                promptTokens: ["Virgin of Guadalupe", "religious icons", "maternal protection", "spiritual guidance"],
                culturalContext: identifier,
                description: "Virgin Mary motifs representing maternal protection and spiritual guidance"
            )
        ]
    }

    var ageGroups: [CulturalAgeGroup] {
        return [
            CulturalAgeGroup(
                id: "young",
                displayName: "Joven",
                ageRange: "5-18 years",
                preferences: ["colorful", "festive", "playful", "tropical nature", "celebration themes"],
                culturalContext: identifier
            ),
            CulturalAgeGroup(
                id: "adult",
                displayName: "Adulto",
                ageRange: "18-50 years",
                preferences: ["meaningful", "artistic", "balanced", "cultural pride", "family-oriented"],
                culturalContext: identifier
            ),
            CulturalAgeGroup(
                id: "elder",
                displayName: "Mayor",
                ageRange: "50+ years",
                preferences: ["traditional", "respectful", "spiritual", "ancestral", "dignified"],
                culturalContext: identifier
            ),
            CulturalAgeGroup(
                id: "any",
                displayName: "Todas las Edades",
                ageRange: "All ages",
                preferences: ["universal", "family-friendly", "harmonious", "celebratory", "welcoming"],
                culturalContext: identifier
            )
        ]
    }

    // MARK: - AI Generation Parameters

    var basePromptEnhancers: [String] {
        return [
            "Latin American traditional art",
            "vibrant cultural heritage",
            "indigenous wisdom",
            "colonial folk art",
            "family celebration",
            "festive spirit",
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
            "warm vibrant colors",
            "joyful expression"
        ]
    }

    var culturalNegativePrompts: [String] {
        return [
            "not North American",
            "not European",
            "not Asian",
            "no inappropriate stereotypes",
            "no colonial exploitation imagery",
            "no disrespectful elements",
            "no modern technology",
            "no inappropriate religious mixing",
            "no offensive content",
            "no drug references",
            "no political symbols",
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
        return LatinAmericanCulturalValidator()
    }

    var animationStyle: CulturalAnimationStyle {
        return CulturalAnimationStyle(
            primaryStyle: "festive-rhythmic",
            duration: 2.5,
            effects: ["salsa_rhythm", "tropical_breeze", "celebration_sparkle", "warm_glow"],
            culturalElements: ["dancing_lights", "tropical_particles", "festive_colors"]
        )
    }
}

// MARK: - Latin American Cultural Validator
class LatinAmericanCulturalValidator: CulturalValidator, CulturalValidatorProtocol {

    private let inappropriateElements: Set<String> = [
        // Elements that perpetuate harmful stereotypes
        // This would be populated based on cultural expert consultation
    ]

    private let sensitiveElements: Set<String> = [
        "calavera_art",
        "sacred_hearts",
        "virgin_mary_motifs",
        "aztec_patterns",
        "mayan_symbols"
    ]

    func validateDesignSpec(_ spec: CulturalDesignSpec) -> CulturalValidationResult {
        var warnings: [String] = []
        var errors: [String] = []
        var recommendations: [String] = []

        // Validate cultural context
        guard spec.culturalContext == "latin_american_traditional" else {
            errors.append("Invalid cultural context for Latin American validation")
            return CulturalValidationResult(isValid: false, errors: errors)
        }

        // Validate elements
        for element in spec.elements {
            if inappropriateElements.contains(element.id) {
                errors.append("Element '\(element.displayName)' may perpetuate inappropriate stereotypes")
            } else if sensitiveElements.contains(element.id) {
                warnings.append("Element '\(element.displayName)' has high cultural or religious significance - ensure respectful representation")
            }
        }

        // Check age appropriateness
        let inappropriateElements = spec.elements.filter { element in
            !element.ageAppropriate.contains { $0.id == spec.targetAgeGroup.id || $0.id == "any" }
        }

        for element in inappropriateElements {
            warnings.append("Element '\(element.displayName)' may not be suitable for \(spec.targetAgeGroup.displayName)")
        }

        // Latin American-specific recommendations
        if spec.elements.isEmpty {
            recommendations.append("Consider adding traditional patterns or nature elements to celebrate Latin American heritage")
        }

        if !spec.elements.contains(where: { $0.category.id == "nature" || $0.category.id == "crafts" }) {
            recommendations.append("Adding natural elements or traditional crafts enhances cultural authenticity")
        }

        // Check for respectful religious representation
        let religiousElements = spec.elements.filter { $0.category.id == "spiritual" }
        if religiousElements.count > 1 {
            warnings.append("Multiple religious elements - ensure respectful and appropriate context")
        }

        // Check color palette vibrancy
        if spec.colorPalette.id == "earth" && spec.genre.id == "festive" {
            recommendations.append("Consider vibrant colors to better match the festive genre")
        }

        let culturalScore = calculateCulturalScore(spec)
        if culturalScore < 0.7 {
            recommendations.append("Consider adding more traditional Latin American elements to increase authenticity")
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

        // Latin American scoring emphasizes indigenous elements and vibrant expression
        let indigenousElements = spec.elements.filter {
            $0.id.contains("aztec") || $0.id.contains("mayan") || $0.category.id == "patterns"
        }
        let indigenousBonus = indigenousElements.isEmpty ? 0.0 : 0.15

        // Bonus for festive/celebratory elements
        let festiveElements = spec.elements.filter {
            $0.category.id == "celebration" || $0.id.contains("carnival") || $0.id.contains("fiesta")
        }
        let festiveBonus = festiveElements.isEmpty ? 0.0 : 0.1

        return (genreScore * 0.25) + (avgElementScore * 0.4) + (paletteScore * 0.2) + indigenousBonus + festiveBonus
    }
}

// MARK: - Context Registration
extension LatinAmericanCulturalContext {
    static func register() {
        Task { @MainActor in
            CulturalContextManager.shared.registerContext(LatinAmericanCulturalContext())
        }
    }
}
