import Foundation
import SwiftUI

// MARK: - African Cultural Context Implementation
struct AfricanCulturalContext: CulturalContext {
    let identifier = "african_traditional"
    let displayName = "African Traditional"
    let description = "Traditional African arts and cultural gifts - ancestral wisdom, community spirit, and natural harmony"
    let primaryLanguage = "sw"
    let supportedLanguages = ["sw", "am", "yo", "zu", "ha", "ig", "fr", "pt", "ar", "en"]

    // MARK: - Core Cultural Elements

    var genres: [CulturalGenre] {
        return [
            CulturalGenre(
                id: "traditional",
                displayName: "Traditional",
                icon: "figure.2.and.child.holdinghands",
                basePrompt: "traditional African art, tribal patterns, ancestral wisdom, community celebration, authentic cultural design",
                culturalWeight: 1.0,
                suggestedElementIds: ["tribal_patterns", "ancestral_symbols", "community_motifs", "traditional_masks"],
                culturalContext: identifier
            ),
            CulturalGenre(
                id: "nature",
                displayName: "Nature Inspired",
                icon: "leaf.fill",
                basePrompt: "African nature art, savanna beauty, wildlife inspiration, natural harmony, earth connection",
                culturalWeight: 0.95,
                suggestedElementIds: ["baobab_tree", "african_wildlife", "savanna_patterns", "natural_elements"],
                culturalContext: identifier
            ),
            CulturalGenre(
                id: "ceremonial",
                displayName: "Ceremonial",
                icon: "sparkles",
                basePrompt: "African ceremonial art, ritual significance, spiritual celebration, sacred traditions",
                culturalWeight: 0.9,
                suggestedElementIds: ["ceremonial_masks", "ritual_symbols", "spiritual_patterns", "celebration_motifs"],
                culturalContext: identifier
            ),
            CulturalGenre(
                id: "contemporary",
                displayName: "Contemporary",
                icon: "paintbrush.pointed.fill",
                basePrompt: "contemporary African art, modern expression, cultural fusion, urban African style",
                culturalWeight: 0.75,
                suggestedElementIds: ["modern_patterns", "urban_symbols", "fusion_elements"],
                culturalContext: identifier
            )
        ]
    }

    var colorPalettes: [CulturalColorPalette] {
        return [
            CulturalColorPalette(
                id: "earth_tones",
                displayName: "Earth & Savanna",
                colors: [
                    CulturalColor(name: "Savanna Gold", hex: "DAA520", symbolism: "African sun and prosperity"),
                    CulturalColor(name: "Earth Brown", hex: "8B4513", symbolism: "Connection to ancestral land"),
                    CulturalColor(name: "Sunset Orange", hex: "FF8C00", symbolism: "Warmth and community spirit"),
                    CulturalColor(name: "Acacia Green", hex: "228B22", symbolism: "Life and growth in nature")
                ],
                promptTokens: ["earth tones", "savanna colors", "African sunset", "natural palette", "warm colors"],
                culturalContext: identifier,
                culturalSignificance: 1.0
            ),
            CulturalColorPalette(
                id: "tribal",
                displayName: "Tribal Heritage",
                colors: [
                    CulturalColor(name: "Clay Red", hex: "CD853F", symbolism: "Sacred earth and life force"),
                    CulturalColor(name: "Charcoal Black", hex: "36454F", symbolism: "Strength and protection"),
                    CulturalColor(name: "Ivory White", hex: "FFFFF0", symbolism: "Purity and ancestral wisdom"),
                    CulturalColor(name: "Royal Blue", hex: "4169E1", symbolism: "Spiritual depth and sky connection")
                ],
                promptTokens: ["tribal colors", "traditional African", "ceremonial colors", "ancestral palette"],
                culturalContext: identifier,
                culturalSignificance: 0.95
            ),
            CulturalColorPalette(
                id: "vibrant",
                displayName: "Festival Celebration",
                colors: [
                    CulturalColor(name: "Festival Red", hex: "DC143C", symbolism: "Joy and celebration"),
                    CulturalColor(name: "Jungle Green", hex: "355E3B", symbolism: "Life and abundance"),
                    CulturalColor(name: "Sunset Yellow", hex: "FFFF00", symbolism: "Hope and energy"),
                    CulturalColor(name: "Purple Royalty", hex: "663399", symbolism: "Leadership and wisdom")
                ],
                promptTokens: ["vibrant colors", "celebration palette", "festival colors", "joyful African colors"],
                culturalContext: identifier,
                culturalSignificance: 0.85
            )
        ]
    }

    var designElements: [CulturalDesignElement] {
        return [
            // Traditional Patterns
            CulturalDesignElement(
                id: "tribal_patterns",
                displayName: "Tribal Patterns",
                category: CulturalElementCategory(id: "patterns", displayName: "Traditional Patterns", icon: "hexagon.fill", culturalContext: identifier),
                weight: 1.0,
                culturalSignificance: 1.0,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["traditional", "ceremonial"],
                promptTokens: ["tribal patterns", "African geometric patterns", "traditional designs", "ancestral motifs"],
                culturalContext: identifier,
                description: "Traditional tribal patterns representing cultural identity and ancestral wisdom"
            ),
            CulturalDesignElement(
                id: "kente_patterns",
                displayName: "Kente Patterns",
                category: CulturalElementCategory(id: "textiles", displayName: "Traditional Textiles", icon: "square.grid.3x3.fill", culturalContext: identifier),
                weight: 0.9,
                culturalSignificance: 0.95,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["traditional", "ceremonial"],
                promptTokens: ["kente cloth", "West African patterns", "royal textiles", "geometric weaving"],
                culturalContext: identifier,
                description: "Traditional Kente patterns representing royalty, status, and cultural pride"
            ),
            CulturalDesignElement(
                id: "adinkra_symbols",
                displayName: "Adinkra Symbols",
                category: CulturalElementCategory(id: "symbols", displayName: "Sacred Symbols", icon: "circle.hexagongrid.fill", culturalContext: identifier),
                weight: 0.95,
                culturalSignificance: 1.0,
                ageAppropriate: [ageGroups[1], ageGroups[2], ageGroups[3]], // adult, elder, any
                compatibleGenreIds: ["traditional", "ceremonial"],
                promptTokens: ["adinkra symbols", "Ghanaian symbols", "wisdom symbols", "proverb symbols"],
                culturalContext: identifier,
                description: "Adinkra symbols representing wisdom, courage, and life lessons"
            ),

            // Nature Elements
            CulturalDesignElement(
                id: "baobab_tree",
                displayName: "Baobab Tree",
                category: CulturalElementCategory(id: "nature", displayName: "Sacred Nature", icon: "tree.fill", culturalContext: identifier),
                weight: 0.9,
                culturalSignificance: 0.9,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["nature", "traditional"],
                promptTokens: ["baobab tree", "tree of life", "African tree", "ancestral tree"],
                culturalContext: identifier,
                description: "Baobab tree symbolizing life, endurance, and connection to ancestral roots"
            ),
            CulturalDesignElement(
                id: "african_wildlife",
                displayName: "African Wildlife",
                category: CulturalElementCategory(id: "nature", displayName: "Sacred Nature", icon: "pawprint.fill", culturalContext: identifier),
                weight: 0.8,
                culturalSignificance: 0.8,
                ageAppropriate: [ageGroups[0], ageGroups[3]], // young, any
                compatibleGenreIds: ["nature", "traditional"],
                promptTokens: ["African animals", "safari wildlife", "elephant", "lion", "giraffe"],
                culturalContext: identifier,
                description: "African wildlife representing the continent's natural heritage and strength"
            ),

            // Cultural Symbols
            CulturalDesignElement(
                id: "ancestral_symbols",
                displayName: "Ancestral Symbols",
                category: CulturalElementCategory(id: "symbols", displayName: "Sacred Symbols", icon: "person.3.fill", culturalContext: identifier),
                weight: 0.95,
                culturalSignificance: 1.0,
                ageAppropriate: [ageGroups[1], ageGroups[2], ageGroups[3]], // adult, elder, any
                compatibleGenreIds: ["traditional", "ceremonial"],
                promptTokens: ["ancestral symbols", "family heritage", "spiritual connection", "elder wisdom"],
                culturalContext: identifier,
                description: "Symbols representing ancestral wisdom and spiritual connection to forebears"
            ),
            CulturalDesignElement(
                id: "community_motifs",
                displayName: "Community Unity",
                category: CulturalElementCategory(id: "symbols", displayName: "Sacred Symbols", icon: "hands.clap.fill", culturalContext: identifier),
                weight: 0.9,
                culturalSignificance: 0.9,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["traditional", "contemporary"],
                promptTokens: ["community symbols", "unity motifs", "together symbols", "family connection"],
                culturalContext: identifier,
                description: "Motifs representing community spirit, unity, and collective strength"
            ),

            // Artistic Elements
            CulturalDesignElement(
                id: "traditional_masks",
                displayName: "Traditional Masks",
                category: CulturalElementCategory(id: "artistic", displayName: "Traditional Arts", icon: "theatermasks.fill", culturalContext: identifier),
                weight: 0.8,
                culturalSignificance: 0.9,
                ageAppropriate: [ageGroups[1], ageGroups[2], ageGroups[3]], // adult, elder, any
                compatibleGenreIds: ["traditional", "ceremonial"],
                promptTokens: ["African masks", "traditional masks", "ceremonial masks", "tribal art"],
                culturalContext: identifier,
                description: "Traditional masks representing spiritual connection and cultural ceremonies"
            ),
            CulturalDesignElement(
                id: "drumbeat_patterns",
                displayName: "Drumbeat Patterns",
                category: CulturalElementCategory(id: "musical", displayName: "Musical Elements", icon: "waveform", culturalContext: identifier),
                weight: 0.8,
                culturalSignificance: 0.85,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["traditional", "ceremonial", "contemporary"],
                promptTokens: ["drum patterns", "rhythm symbols", "music motifs", "celebration beats"],
                culturalContext: identifier,
                description: "Visual representations of traditional drum rhythms and musical celebrations"
            ),

            // Modern Elements
            CulturalDesignElement(
                id: "urban_symbols",
                displayName: "Urban African",
                category: CulturalElementCategory(id: "contemporary", displayName: "Modern Elements", icon: "building.2.fill", culturalContext: identifier),
                weight: 0.6,
                culturalSignificance: 0.7,
                ageAppropriate: [ageGroups[0], ageGroups[1], ageGroups[3]], // young, adult, any
                compatibleGenreIds: ["contemporary"],
                promptTokens: ["modern African", "urban culture", "contemporary symbols", "African cities"],
                culturalContext: identifier,
                description: "Contemporary African urban culture and modern expressions of heritage"
            )
        ]
    }

    var ageGroups: [CulturalAgeGroup] {
        return [
            CulturalAgeGroup(
                id: "young",
                displayName: "Young",
                ageRange: "5-18 years",
                preferences: ["colorful", "nature-inspired", "playful animals", "bright patterns", "educational"],
                culturalContext: identifier
            ),
            CulturalAgeGroup(
                id: "adult",
                displayName: "Adult",
                ageRange: "18-50 years",
                preferences: ["meaningful", "sophisticated", "balanced", "contemporary-traditional fusion", "empowering"],
                culturalContext: identifier
            ),
            CulturalAgeGroup(
                id: "elder",
                displayName: "Elder",
                ageRange: "50+ years",
                preferences: ["traditional", "respectful", "ancestral", "dignified", "wisdom-focused"],
                culturalContext: identifier
            ),
            CulturalAgeGroup(
                id: "any",
                displayName: "Any Age",
                ageRange: "All ages",
                preferences: ["universal", "timeless", "harmonious", "community-focused", "inspiring"],
                culturalContext: identifier
            )
        ]
    }

    // MARK: - AI Generation Parameters

    var basePromptEnhancers: [String] {
        return [
            "African traditional art",
            "cultural heritage",
            "ancestral wisdom",
            "community spirit",
            "natural harmony",
            "tribal authenticity",
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
            "warm earth tones",
            "spiritual connection"
        ]
    }

    var culturalNegativePrompts: [String] {
        return [
            "not European",
            "not Asian",
            "not American colonial",
            "no inappropriate cultural stereotypes",
            "no colonial imagery",
            "no disrespectful elements",
            "no modern technology",
            "no inappropriate tribal stereotypes",
            "no offensive content",
            "no exploitative imagery",
            "no primitivism",
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
        return AfricanCulturalValidator()
    }

    var animationStyle: CulturalAnimationStyle {
        return CulturalAnimationStyle(
            primaryStyle: "rhythmic-flowing",
            duration: 3.2,
            effects: ["tribal_rhythm", "earth_pulse", "community_wave", "ancestral_glow"],
            culturalElements: ["drumbeat_particles", "earth_tones", "unity_waves"]
        )
    }
}

// MARK: - African Cultural Validator
class AfricanCulturalValidator: CulturalValidator, CulturalValidatorProtocol {

    private let inappropriateElements: Set<String> = [
        // Elements that perpetuate stereotypes or colonial imagery
        // This would be populated based on cultural expert consultation
    ]

    private let sensitiveElements: Set<String> = [
        "traditional_masks",
        "ancestral_symbols",
        "adinkra_symbols",
        "ceremonial_elements"
    ]

    func validateDesignSpec(_ spec: CulturalDesignSpec) -> CulturalValidationResult {
        var warnings: [String] = []
        var errors: [String] = []
        var recommendations: [String] = []

        // Validate cultural context
        guard spec.culturalContext == "african_traditional" else {
            errors.append("Invalid cultural context for African validation")
            return CulturalValidationResult(isValid: false, errors: errors)
        }

        // Validate elements
        for element in spec.elements {
            if inappropriateElements.contains(element.id) {
                errors.append("Element '\(element.displayName)' may perpetuate inappropriate stereotypes")
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

        // African-specific recommendations
        if spec.elements.isEmpty {
            recommendations.append("Consider adding traditional patterns or nature elements to honor African heritage")
        }

        if !spec.elements.contains(where: { $0.category.id == "patterns" || $0.category.id == "symbols" }) {
            recommendations.append("Adding traditional patterns or symbols enhances cultural authenticity")
        }

        // Check for respectful representation
        let maskElements = spec.elements.filter { $0.id == "traditional_masks" }
        if !maskElements.isEmpty {
            recommendations.append("Traditional masks have deep spiritual significance - ensure respectful context")
        }

        // Check color palette appropriateness
        if spec.colorPalette.id == "vibrant" && spec.targetAgeGroup.id == "elder" {
            recommendations.append("Consider earth tones or tribal colors for elder age group preferences")
        }

        let culturalScore = calculateCulturalScore(spec)
        if culturalScore < 0.7 {
            recommendations.append("Consider adding more traditional African elements to increase authenticity")
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

        // African scoring emphasizes traditional patterns and community elements
        let traditionalElements = spec.elements.filter {
            $0.category.id == "patterns" || $0.category.id == "symbols" || $0.category.id == "textiles"
        }
        let traditionBonus = traditionalElements.isEmpty ? 0.0 : 0.15

        // Bonus for community/nature focus
        let communityNatureElements = spec.elements.filter {
            $0.id.contains("community") || $0.id.contains("nature") || $0.category.id == "nature"
        }
        let communityBonus = communityNatureElements.isEmpty ? 0.0 : 0.1

        return (genreScore * 0.25) + (avgElementScore * 0.4) + (paletteScore * 0.2) + traditionBonus + communityBonus
    }
}

// MARK: - Context Registration
extension AfricanCulturalContext {
    static func register() {
        Task { @MainActor in
            CulturalContextManager.shared.registerContext(AfricanCulturalContext())
        }
    }
}
