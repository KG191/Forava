import Foundation
import SwiftUI

// MARK: - Rakhi Cultural Context Implementation
struct RakhiCulturalContext: CulturalContext {
    let identifier = "rakhi_indian"
    let displayName = "Rakhi (Indian)"
    let description = "Traditional Indian Rakhi celebration - sacred bond between siblings"
    let primaryLanguage = "en"
    let supportedLanguages = ["en", "hi", "ur", "bn"]

    // MARK: - Core Cultural Elements

    var genres: [CulturalGenre] {
        return [
            CulturalGenre(
                id: "traditional",
                displayName: "Traditional",
                icon: "star.circle.fill",
                basePrompt: "traditional Indian rakhi, red thread, gold elements, classic design, Raksha Bandhan festival",
                culturalWeight: 1.0,
                suggestedElementIds: ["red_thread_mauli", "gold_beads", "traditional_motifs", "sacred_symbols"],
                culturalContext: identifier
            ),
            CulturalGenre(
                id: "modern",
                displayName: "Modern",
                icon: "sparkles",
                basePrompt: "modern contemporary rakhi, sleek design, innovative materials, stylish Indian festival thread",
                culturalWeight: 0.7,
                suggestedElementIds: ["silk_thread", "contemporary_beads", "geometric_patterns", "metallic_accents"],
                culturalContext: identifier
            ),
            CulturalGenre(
                id: "elegant",
                displayName: "Elegant",
                icon: "crown.fill",
                basePrompt: "elegant sophisticated rakhi, refined details, premium materials, graceful Indian design",
                culturalWeight: 0.8,
                suggestedElementIds: ["pearl_beads", "crystal_elements", "refined_patterns", "luxury_thread"],
                culturalContext: identifier
            ),
            CulturalGenre(
                id: "spiritual",
                displayName: "Spiritual",
                icon: "leaf.fill",
                basePrompt: "spiritual sacred rakhi, religious symbols, divine essence, blessed Indian ritual thread",
                culturalWeight: 0.95,
                suggestedElementIds: ["sacred_symbols", "rudraksha_beads", "om_symbol", "lotus_motif"],
                culturalContext: identifier
            )
        ]
    }

    var colorPalettes: [CulturalColorPalette] {
        return [
            CulturalColorPalette(
                id: "traditional",
                displayName: "Traditional",
                colors: [
                    CulturalColor(name: "Sindoor Red", hex: "D2001F", symbolism: "Auspiciousness and prosperity"),
                    CulturalColor(name: "Turmeric Gold", hex: "E3B505", symbolism: "Purity and sacred energy"),
                    CulturalColor(name: "Saffron Orange", hex: "FF9933", symbolism: "Spiritual awakening"),
                    CulturalColor(name: "Mauli Red", hex: "CC0000", symbolism: "Protection and sacred bond")
                ],
                promptTokens: ["red", "orange", "gold", "saffron", "traditional Indian colors", "auspicious colors"],
                culturalContext: identifier,
                culturalSignificance: 1.0
            ),
            CulturalColorPalette(
                id: "royal",
                displayName: "Royal",
                colors: [
                    CulturalColor(name: "Royal Purple", hex: "663399", symbolism: "Nobility and respect"),
                    CulturalColor(name: "Golden Yellow", hex: "FFD700", symbolism: "Prosperity and wisdom"),
                    CulturalColor(name: "Deep Maroon", hex: "800000", symbolism: "Strength and devotion"),
                    CulturalColor(name: "Pearl White", hex: "F8F6F0", symbolism: "Purity and peace")
                ],
                promptTokens: ["purple", "gold", "maroon", "royal colors", "regal", "majestic"],
                culturalContext: identifier,
                culturalSignificance: 0.85
            ),
            CulturalColorPalette(
                id: "modern",
                displayName: "Modern",
                colors: [
                    CulturalColor(name: "Contemporary Blue", hex: "2E86AB", symbolism: "Modernity and trust"),
                    CulturalColor(name: "Silver Grey", hex: "A8DADC", symbolism: "Sophistication"),
                    CulturalColor(name: "Coral Pink", hex: "F1FAEE", symbolism: "Joy and celebration"),
                    CulturalColor(name: "Mint Green", hex: "457B9D", symbolism: "Growth and harmony")
                ],
                promptTokens: ["blue", "silver", "contemporary colors", "modern palette", "sleek"],
                culturalContext: identifier,
                culturalSignificance: 0.6
            )
        ]
    }

    var designElements: [CulturalDesignElement] {
        return [
            // Thread Elements
            CulturalDesignElement(
                id: "red_thread_mauli",
                displayName: "Red Thread (Mauli)",
                category: CulturalElementCategory(id: "thread", displayName: "Thread", icon: "line.3.horizontal", culturalContext: identifier),
                weight: 1.0,
                culturalSignificance: 1.0,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["traditional", "spiritual"],
                promptTokens: ["red thread", "mauli", "sacred thread", "ritual thread"],
                culturalContext: identifier,
                description: "Traditional red cotton thread, considered sacred and protective"
            ),
            CulturalDesignElement(
                id: "silk_thread",
                displayName: "Silk Thread",
                category: CulturalElementCategory(id: "thread", displayName: "Thread", icon: "line.3.horizontal", culturalContext: identifier),
                weight: 0.8,
                culturalSignificance: 0.7,
                ageAppropriate: [ageGroups[1], ageGroups[3]], // adult, any
                compatibleGenreIds: ["modern", "elegant"],
                promptTokens: ["silk thread", "smooth thread", "premium thread"],
                culturalContext: identifier,
                description: "Fine silk thread for elegant and modern designs"
            ),

            // Beads Elements
            CulturalDesignElement(
                id: "rudraksha_beads",
                displayName: "Rudraksha Beads",
                category: CulturalElementCategory(id: "beads", displayName: "Beads", icon: "circle.grid.2x2.fill", culturalContext: identifier),
                weight: 1.0,
                culturalSignificance: 0.95,
                ageAppropriate: [ageGroups[1], ageGroups[2], ageGroups[3]], // adult, elder, any
                compatibleGenreIds: ["traditional", "spiritual"],
                promptTokens: ["rudraksha beads", "sacred beads", "spiritual beads", "holy beads"],
                culturalContext: identifier,
                description: "Sacred beads from Rudraksha tree, highly spiritual significance"
            ),
            CulturalDesignElement(
                id: "gold_beads",
                displayName: "Gold Beads",
                category: CulturalElementCategory(id: "beads", displayName: "Beads", icon: "circle.grid.2x2.fill", culturalContext: identifier),
                weight: 0.9,
                culturalSignificance: 0.85,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["traditional", "elegant"],
                promptTokens: ["gold beads", "golden beads", "metal beads", "precious beads"],
                culturalContext: identifier,
                description: "Traditional gold or gold-plated beads symbolizing prosperity"
            ),
            CulturalDesignElement(
                id: "pearl_beads",
                displayName: "Pearl Beads",
                category: CulturalElementCategory(id: "beads", displayName: "Beads", icon: "circle.grid.2x2.fill", culturalContext: identifier),
                weight: 0.8,
                culturalSignificance: 0.7,
                ageAppropriate: [ageGroups[1], ageGroups[2], ageGroups[3]], // adult, elder, any
                compatibleGenreIds: ["elegant", "modern"],
                promptTokens: ["pearl beads", "white beads", "lustrous beads", "elegant beads"],
                culturalContext: identifier,
                description: "Elegant pearl beads for sophisticated designs"
            ),

            // Sacred Symbols
            CulturalDesignElement(
                id: "om_symbol",
                displayName: "Om Symbol",
                category: CulturalElementCategory(id: "symbols", displayName: "Sacred Symbols", icon: "character.magnify", culturalContext: identifier),
                weight: 1.0,
                culturalSignificance: 1.0,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["traditional", "spiritual"],
                promptTokens: ["Om symbol", "AUM symbol", "sacred Om", "Hindu Om"],
                culturalContext: identifier,
                description: "Sacred Hindu symbol representing the divine sound of the universe"
            ),
            CulturalDesignElement(
                id: "lotus_motif",
                displayName: "Lotus Motif",
                category: CulturalElementCategory(id: "symbols", displayName: "Sacred Symbols", icon: "character.magnify", culturalContext: identifier),
                weight: 0.9,
                culturalSignificance: 0.9,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["traditional", "spiritual", "elegant"],
                promptTokens: ["lotus", "lotus flower", "sacred lotus", "spiritual lotus"],
                culturalContext: identifier,
                description: "Sacred lotus symbolizing purity, enlightenment, and spiritual awakening"
            ),

            // Decorative Elements
            CulturalDesignElement(
                id: "paisley_pattern",
                displayName: "Paisley Pattern",
                category: CulturalElementCategory(id: "patterns", displayName: "Patterns", icon: "grid", culturalContext: identifier),
                weight: 0.8,
                culturalSignificance: 0.8,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["traditional", "elegant"],
                promptTokens: ["paisley", "paisley pattern", "Indian paisley", "traditional pattern"],
                culturalContext: identifier,
                description: "Traditional teardrop-shaped ornamental design"
            ),
            CulturalDesignElement(
                id: "geometric_mandala",
                displayName: "Geometric Mandala",
                category: CulturalElementCategory(id: "patterns", displayName: "Patterns", icon: "grid", culturalContext: identifier),
                weight: 0.9,
                culturalSignificance: 0.85,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["traditional", "spiritual", "modern"],
                promptTokens: ["mandala", "geometric mandala", "sacred geometry", "circular pattern"],
                culturalContext: identifier,
                description: "Sacred geometric design representing the universe and spiritual journey"
            )
        ]
    }

    var ageGroups: [CulturalAgeGroup] {
        return [
            CulturalAgeGroup(
                id: "young",
                displayName: "Young",
                ageRange: "5-18 years",
                preferences: ["colorful", "playful", "bright", "fun", "vibrant"],
                culturalContext: identifier
            ),
            CulturalAgeGroup(
                id: "adult",
                displayName: "Adult",
                ageRange: "18-50 years",
                preferences: ["elegant", "sophisticated", "meaningful", "quality", "refined"],
                culturalContext: identifier
            ),
            CulturalAgeGroup(
                id: "elder",
                displayName: "Elder",
                ageRange: "50+ years",
                preferences: ["traditional", "spiritual", "classic", "respectful", "blessed"],
                culturalContext: identifier
            ),
            CulturalAgeGroup(
                id: "any",
                displayName: "Any Age",
                ageRange: "All ages",
                preferences: ["universal", "timeless", "beautiful", "appropriate", "meaningful"],
                culturalContext: identifier
            )
        ]
    }

    // MARK: - AI Generation Parameters

    var basePromptEnhancers: [String] {
        return [
            "Indian rakhi bracelet",
            "traditional Hindu festival thread",
            "sacred brother-sister bond symbol",
            "Raksha Bandhan festival",
            "Indian cultural heritage",
            "handcrafted traditional art",
            "centered composition",
            "isolated on clean background",
            "masterpiece",
            "best quality",
            "ultra detailed",
            "professional photography",
            "perfect lighting",
            "sharp focus"
        ]
    }

    var culturalNegativePrompts: [String] {
        return [
            "not a necklace",
            "not a ring",
            "not jewelry",
            "not a bracelet for wrist",
            "no hands",
            "no people",
            "no faces",
            "no body parts",
            "no multiple rakhis",
            "not western",
            "not Christmas",
            "not Halloween",
            "no inappropriate symbols",
            "no non-Hindu symbols",
            "no cross",
            "no inappropriate cultural elements",
            "blurry",
            "low quality",
            "distorted",
            "nsfw"
        ]
    }

    var preferredAIModel: String {
        return "stability-ai/stable-diffusion-xl"
    }

    // MARK: - Validation and Animation

    var validator: CulturalValidator {
        return RakhiCulturalValidator()
    }

    var animationStyle: CulturalAnimationStyle {
        return CulturalAnimationStyle(
            primaryStyle: "traditional-elegant",
            duration: 2.5,
            effects: ["fade", "glow", "sparkle", "blessing"],
            culturalElements: ["sacred_light", "divine_sparkles", "blessing_glow"]
        )
    }
}

// MARK: - Rakhi Cultural Validator
class RakhiCulturalValidator: CulturalValidator, CulturalValidatorProtocol {

    private let inappropriateElements: Set<String> = [
        // Elements that are not appropriate for Rakhi context
        // This would be populated based on cultural expert consultation
    ]

    private let sensitiveElements: Set<String> = [
        "om_symbol",
        "sacred_symbols",
        "rudraksha_beads"
    ]

    func validateDesignSpec(_ spec: CulturalDesignSpec) -> CulturalValidationResult {
        var warnings: [String] = []
        var errors: [String] = []
        var recommendations: [String] = []

        // Validate cultural context
        guard spec.culturalContext == "rakhi_indian" else {
            errors.append("Invalid cultural context for Rakhi validation")
            return CulturalValidationResult(isValid: false, errors: errors)
        }

        // Validate elements
        for element in spec.elements {
            if inappropriateElements.contains(element.id) {
                errors.append("Element '\(element.displayName)' is culturally inappropriate for Rakhi")
            } else if sensitiveElements.contains(element.id) {
                warnings.append("Element '\(element.displayName)' has high cultural significance - use respectfully")
            }
        }

        // Check age appropriateness
        let inappropriateElements = spec.elements.filter { element in
            !element.ageAppropriate.contains { $0.id == spec.targetAgeGroup.id || $0.id == "any" }
        }

        for element in inappropriateElements {
            warnings.append("Element '\(element.displayName)' may not be suitable for \(spec.targetAgeGroup.displayName)")
        }

        // Recommendations
        if spec.elements.isEmpty {
            recommendations.append("Add at least one traditional element like red thread or sacred beads")
        }

        if !spec.elements.contains(where: { $0.category.id == "thread" }) {
            recommendations.append("Consider adding a thread element as the base of your Rakhi")
        }

        let culturalScore = calculateCulturalScore(spec)
        if culturalScore < 0.5 {
            recommendations.append("Consider adding more traditional elements to increase cultural authenticity")
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

        return (genreScore * 0.4) + (avgElementScore * 0.4) + (paletteScore * 0.2)
    }
}

// MARK: - Context Registration
extension RakhiCulturalContext {
    static func register() {
        Task { @MainActor in
            CulturalContextManager.shared.registerContext(RakhiCulturalContext())
        }
    }
}
