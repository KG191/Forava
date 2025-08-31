import Foundation
import SwiftUI

// MARK: - Buddhist Cultural Context Implementation
struct BuddhistCulturalContext: CulturalContext {
    let identifier = "buddhist_traditional"
    let displayName = "Buddhist Traditional"
    let description = "Traditional Buddhist wisdom gifts - mindfulness, compassion, and peaceful enlightenment"
    let primaryLanguage = "en"
    let supportedLanguages = ["en", "th", "my", "km", "lo", "si", "mn", "bo", "zh", "ja"]

    // MARK: - Core Cultural Elements

    var genres: [CulturalGenre] {
        return [
            CulturalGenre(
                id: "vesak_day",
                displayName: "Vesak Day",
                icon: "star.fill",
                basePrompt: "Vesak Day celebration, Buddha's birth enlightenment, lotus flowers, lantern festival, spiritual light",
                culturalWeight: 1.0,
                suggestedElementIds: ["lotus_flower", "dharma_wheel", "vesak_lanterns", "bodhi_tree"],
                culturalContext: identifier
            ),
            CulturalGenre(
                id: "mindfulness",
                displayName: "Mindfulness",
                icon: "brain.head.profile",
                basePrompt: "Buddhist mindfulness art, meditation symbols, present moment awareness, inner peace",
                culturalWeight: 0.95,
                suggestedElementIds: ["meditation_pose", "lotus_flower", "zen_circles", "mindful_breathing"],
                culturalContext: identifier
            ),
            CulturalGenre(
                id: "compassion",
                displayName: "Compassion",
                icon: "heart.fill",
                basePrompt: "Buddhist compassion art, loving kindness, universal love, bodhisattva ideals",
                culturalWeight: 0.95,
                suggestedElementIds: ["compassion_hands", "loving_kindness_symbol", "bodhisattva_figure", "heart_lotus"],
                culturalContext: identifier
            ),
            CulturalGenre(
                id: "wisdom",
                displayName: "Wisdom",
                icon: "book.fill",
                basePrompt: "Buddhist wisdom art, dharma teachings, enlightenment symbols, ancient wisdom",
                culturalWeight: 0.9,
                suggestedElementIds: ["dharma_wheel", "bodhi_tree", "wisdom_eyes", "teaching_mudra"],
                culturalContext: identifier
            ),
            CulturalGenre(
                id: "peace",
                displayName: "Inner Peace",
                icon: "leaf.fill",
                basePrompt: "Buddhist peace art, serenity, tranquility, harmonious balance, spiritual calm",
                culturalWeight: 0.85,
                suggestedElementIds: ["peaceful_buddha", "calm_water", "mountain_meditation", "gentle_breeze"],
                culturalContext: identifier
            )
        ]
    }

    var colorPalettes: [CulturalColorPalette] {
        return [
            CulturalColorPalette(
                id: "saffron",
                displayName: "Saffron Serenity",
                colors: [
                    CulturalColor(name: "Saffron Orange", hex: "F4A460", symbolism: "Monastic robes and spiritual dedication"),
                    CulturalColor(name: "Deep Maroon", hex: "800000", symbolism: "Tibetan monastic tradition"),
                    CulturalColor(name: "Golden Yellow", hex: "FFD700", symbolism: "Enlightenment and wisdom"),
                    CulturalColor(name: "Pure White", hex: "FFFFFF", symbolism: "Purity and liberation")
                ],
                promptTokens: ["saffron colors", "monastic robes", "Buddhist orange", "spiritual colors"],
                culturalContext: identifier,
                culturalSignificance: 1.0
            ),
            CulturalColorPalette(
                id: "peaceful",
                displayName: "Peaceful Blues",
                colors: [
                    CulturalColor(name: "Sky Blue", hex: "87CEEB", symbolism: "Infinite sky and boundless mind"),
                    CulturalColor(name: "Deep Navy", hex: "000080", symbolism: "Depth of meditation"),
                    CulturalColor(name: "Soft Turquoise", hex: "40E0D0", symbolism: "Healing and compassion"),
                    CulturalColor(name: "Cloud White", hex: "F8F8FF", symbolism: "Clarity and emptiness")
                ],
                promptTokens: ["peaceful blues", "meditation colors", "sky colors", "tranquil palette"],
                culturalContext: identifier,
                culturalSignificance: 0.9
            ),
            CulturalColorPalette(
                id: "natural",
                displayName: "Natural Harmony",
                colors: [
                    CulturalColor(name: "Forest Green", hex: "228B22", symbolism: "Natural world and interconnectedness"),
                    CulturalColor(name: "Earth Brown", hex: "8B4513", symbolism: "Grounding and stability"),
                    CulturalColor(name: "Stone Grey", hex: "708090", symbolism: "Mountain meditation and endurance"),
                    CulturalColor(name: "Bamboo Beige", hex: "F5F5DC", symbolism: "Simplicity and natural beauty")
                ],
                promptTokens: ["natural colors", "earth tones", "forest meditation", "organic palette"],
                culturalContext: identifier,
                culturalSignificance: 0.85
            )
        ]
    }

    var designElements: [CulturalDesignElement] {
        return [
            // Core Buddhist Symbols
            CulturalDesignElement(
                id: "lotus_flower",
                displayName: "Lotus Flower",
                category: CulturalElementCategory(id: "symbols", displayName: "Sacred Symbols", icon: "leaf.fill", culturalContext: identifier),
                weight: 1.0,
                culturalSignificance: 1.0,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["mindfulness", "compassion", "wisdom"],
                promptTokens: ["lotus flower", "sacred lotus", "enlightenment symbol", "purity bloom"],
                culturalContext: identifier,
                description: "Sacred lotus representing purity, enlightenment, and spiritual rebirth"
            ),
            CulturalDesignElement(
                id: "dharma_wheel",
                displayName: "Dharma Wheel",
                category: CulturalElementCategory(id: "symbols", displayName: "Sacred Symbols", icon: "gear", culturalContext: identifier),
                weight: 0.95,
                culturalSignificance: 1.0,
                ageAppropriate: [ageGroups[1], ageGroups[2], ageGroups[3]], // adult, elder, any
                compatibleGenreIds: ["wisdom", "mindfulness"],
                promptTokens: ["dharma wheel", "wheel of law", "Buddhist wheel", "eight-spoke wheel"],
                culturalContext: identifier,
                description: "Dharma wheel representing the Noble Eightfold Path and Buddhist teachings"
            ),
            CulturalDesignElement(
                id: "bodhi_tree",
                displayName: "Bodhi Tree",
                category: CulturalElementCategory(id: "nature", displayName: "Sacred Nature", icon: "tree.fill", culturalContext: identifier),
                weight: 0.9,
                culturalSignificance: 0.95,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["wisdom", "peace"],
                promptTokens: ["bodhi tree", "enlightenment tree", "Buddha tree", "sacred fig tree"],
                culturalContext: identifier,
                description: "Sacred Bodhi tree under which Buddha achieved enlightenment"
            ),

            // Meditation and Mindfulness
            CulturalDesignElement(
                id: "meditation_pose",
                displayName: "Meditation Posture",
                category: CulturalElementCategory(id: "meditation", displayName: "Meditation Elements", icon: "figure.seated.side", culturalContext: identifier),
                weight: 0.9,
                culturalSignificance: 0.9,
                ageAppropriate: [ageGroups[1], ageGroups[2], ageGroups[3]], // adult, elder, any
                compatibleGenreIds: ["mindfulness", "peace"],
                promptTokens: ["meditation posture", "lotus position", "seated meditation", "mindful sitting"],
                culturalContext: identifier,
                description: "Traditional meditation posture representing inner contemplation and mindfulness"
            ),
            CulturalDesignElement(
                id: "zen_circles",
                displayName: "Enso Circles",
                category: CulturalElementCategory(id: "zen", displayName: "Zen Elements", icon: "circle", culturalContext: identifier),
                weight: 0.85,
                culturalSignificance: 0.9,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["mindfulness", "peace", "wisdom"],
                promptTokens: ["enso circle", "zen circle", "mindfulness circle", "meditation symbol"],
                culturalContext: identifier,
                description: "Enso circles representing enlightenment, strength, and the universe"
            ),

            // Compassion Elements
            CulturalDesignElement(
                id: "compassion_hands",
                displayName: "Compassionate Hands",
                category: CulturalElementCategory(id: "compassion", displayName: "Compassion Elements", icon: "hands.clap.fill", culturalContext: identifier),
                weight: 0.8,
                culturalSignificance: 0.85,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["compassion", "mindfulness"],
                promptTokens: ["compassionate hands", "mudra hands", "blessing hands", "loving kindness"],
                culturalContext: identifier,
                description: "Compassionate hand gestures representing loving kindness and care"
            ),
            CulturalDesignElement(
                id: "loving_kindness_symbol",
                displayName: "Loving Kindness Symbol",
                category: CulturalElementCategory(id: "compassion", displayName: "Compassion Elements", icon: "heart.fill", culturalContext: identifier),
                weight: 0.8,
                culturalSignificance: 0.9,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["compassion"],
                promptTokens: ["loving kindness", "metta symbol", "compassion heart", "universal love"],
                culturalContext: identifier,
                description: "Symbol of loving kindness (metta) and universal compassion"
            ),

            // Wisdom Elements
            CulturalDesignElement(
                id: "wisdom_eyes",
                displayName: "Buddha Eyes",
                category: CulturalElementCategory(id: "wisdom", displayName: "Wisdom Elements", icon: "eye.fill", culturalContext: identifier),
                weight: 0.85,
                culturalSignificance: 0.95,
                ageAppropriate: [ageGroups[1], ageGroups[2], ageGroups[3]], // adult, elder, any
                compatibleGenreIds: ["wisdom"],
                promptTokens: ["Buddha eyes", "wisdom eyes", "all-seeing eyes", "enlightened vision"],
                culturalContext: identifier,
                description: "Buddha's eyes representing wisdom, compassion, and enlightened vision"
            ),
            CulturalDesignElement(
                id: "teaching_mudra",
                displayName: "Teaching Mudra",
                category: CulturalElementCategory(id: "wisdom", displayName: "Wisdom Elements", icon: "hand.point.up.fill", culturalContext: identifier),
                weight: 0.8,
                culturalSignificance: 0.9,
                ageAppropriate: [ageGroups[1], ageGroups[2], ageGroups[3]], // adult, elder, any
                compatibleGenreIds: ["wisdom"],
                promptTokens: ["teaching mudra", "dharma mudra", "teaching gesture", "wisdom hand"],
                culturalContext: identifier,
                description: "Teaching mudra representing the sharing of dharma and wisdom"
            ),

            // Vesak Day Elements
            CulturalDesignElement(
                id: "vesak_lanterns",
                displayName: "Vesak Lanterns",
                category: CulturalElementCategory(id: "vesak", displayName: "Vesak Elements", icon: "lightbulb.fill", culturalContext: identifier),
                weight: 0.9,
                culturalSignificance: 0.9,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["vesak_day"],
                promptTokens: ["Vesak lanterns", "Buddhist lanterns", "colorful lanterns", "spiritual lights"],
                culturalContext: identifier,
                description: "Colorful lanterns hung during Vesak Day to celebrate Buddha's enlightenment"
            ),

            // Peace and Tranquility
            CulturalDesignElement(
                id: "peaceful_buddha",
                displayName: "Peaceful Buddha",
                category: CulturalElementCategory(id: "peace", displayName: "Peace Elements", icon: "figure.seated.side", culturalContext: identifier),
                weight: 0.9,
                culturalSignificance: 0.95,
                ageAppropriate: [ageGroups[1], ageGroups[2], ageGroups[3]], // adult, elder, any
                compatibleGenreIds: ["peace", "mindfulness"],
                promptTokens: ["peaceful Buddha", "serene Buddha", "calm Buddha", "tranquil meditation"],
                culturalContext: identifier,
                description: "Peaceful Buddha image representing inner tranquility and spiritual calm"
            ),
            CulturalDesignElement(
                id: "mountain_meditation",
                displayName: "Mountain Meditation",
                category: CulturalElementCategory(id: "nature", displayName: "Sacred Nature", icon: "mountain.2.fill", culturalContext: identifier),
                weight: 0.7,
                culturalSignificance: 0.8,
                ageAppropriate: [ageGroups[3]], // any
                compatibleGenreIds: ["peace", "mindfulness"],
                promptTokens: ["mountain meditation", "peak serenity", "high altitude peace", "mountain wisdom"],
                culturalContext: identifier,
                description: "Mountain meditation representing stability, endurance, and elevated consciousness"
            )
        ]
    }

    var ageGroups: [CulturalAgeGroup] {
        return [
            CulturalAgeGroup(
                id: "young",
                displayName: "Young",
                ageRange: "5-18 years",
                preferences: ["peaceful", "colorful nature", "simple symbols", "gentle", "calming"],
                culturalContext: identifier
            ),
            CulturalAgeGroup(
                id: "adult",
                displayName: "Adult",
                ageRange: "18-50 years",
                preferences: ["mindful", "meaningful", "meditative", "balanced", "contemplative"],
                culturalContext: identifier
            ),
            CulturalAgeGroup(
                id: "elder",
                displayName: "Elder",
                ageRange: "50+ years",
                preferences: ["traditional", "wise", "serene", "dignified", "enlightened"],
                culturalContext: identifier
            ),
            CulturalAgeGroup(
                id: "any",
                displayName: "Any Age",
                ageRange: "All ages",
                preferences: ["peaceful", "harmonious", "compassionate", "mindful", "universal"],
                culturalContext: identifier
            )
        ]
    }

    // MARK: - AI Generation Parameters

    var basePromptEnhancers: [String] {
        return [
            "Buddhist traditional art",
            "meditation art",
            "spiritual serenity",
            "mindfulness imagery",
            "peaceful contemplation",
            "dharma art",
            "handcrafted meditation art",
            "centered composition",
            "isolated on clean background",
            "masterpiece quality",
            "best quality",
            "ultra detailed",
            "professional photography",
            "perfect lighting",
            "sharp focus",
            "serene atmosphere",
            "spiritual tranquility",
            "clean minimalist"
        ]
    }

    var culturalNegativePrompts: [String] {
        return [
            "not Hindu",
            "not other religions",
            "no inappropriate religious mixing",
            "no disrespectful Buddhist imagery",
            "no commercialization of sacred symbols",
            "no modern technology",
            "no inappropriate Buddhist symbols",
            "no offensive religious content",
            "no violence or aggression",
            "no cluttered busy design",
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
        return BuddhistCulturalValidator()
    }

    var animationStyle: CulturalAnimationStyle {
        return CulturalAnimationStyle(
            primaryStyle: "zen-flowing",
            duration: 4.0,
            effects: ["gentle_breath", "mindful_flow", "peaceful_fade", "serene_glow"],
            culturalElements: ["floating_lotus", "gentle_ripples", "soft_light"]
        )
    }
}

// MARK: - Buddhist Cultural Validator
class BuddhistCulturalValidator: CulturalValidator, CulturalValidatorProtocol {

    private let inappropriateElements: Set<String> = [
        // Elements that are religiously inappropriate or disrespectful
        // This would be populated based on Buddhist scholarly consultation
    ]

    private let sensitiveElements: Set<String> = [
        "peaceful_buddha",
        "dharma_wheel",
        "lotus_flower",
        "wisdom_eyes"
    ]

    func validateDesignSpec(_ spec: CulturalDesignSpec) -> CulturalValidationResult {
        var warnings: [String] = []
        var errors: [String] = []
        var recommendations: [String] = []

        // Validate cultural context
        guard spec.culturalContext == "buddhist_traditional" else {
            errors.append("Invalid cultural context for Buddhist validation")
            return CulturalValidationResult(isValid: false, errors: errors)
        }

        // Validate elements
        for element in spec.elements {
            if inappropriateElements.contains(element.id) {
                errors.append("Element '\(element.displayName)' is inappropriate for Buddhist context")
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

        // Buddhist-specific recommendations
        if spec.elements.isEmpty {
            recommendations.append("Consider adding traditional Buddhist symbols like lotus or dharma wheel")
        }

        if !spec.elements.contains(where: { $0.category.id == "symbols" }) {
            recommendations.append("Adding sacred symbols enhances Buddhist authenticity")
        }

        // Check for peaceful design principles
        if spec.elements.count > 4 {
            recommendations.append("Buddhist aesthetics favor simplicity and minimalism - consider fewer elements")
        }

        // Validate genre-element alignment
        if spec.genre.id == "mindfulness" && !spec.elements.contains(where: { $0.category.id == "meditation" || $0.category.id == "zen" }) {
            recommendations.append("Consider adding meditation elements for mindfulness genre")
        }

        if spec.genre.id == "compassion" && !spec.elements.contains(where: { $0.category.id == "compassion" }) {
            recommendations.append("Consider adding compassion elements for compassion genre")
        }

        // Check color appropriateness
        if spec.colorPalette.id == "natural" && spec.genre.id == "mindfulness" {
            // This is good - natural colors support mindfulness
        } else if spec.colorPalette.id == "saffron" && spec.targetAgeGroup.id == "young" {
            recommendations.append("Consider peaceful blues for younger audiences")
        }

        let culturalScore = calculateCulturalScore(spec)
        if culturalScore < 0.7 {
            recommendations.append("Consider adding more traditional Buddhist elements to increase authenticity")
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

        // Buddhist scoring emphasizes simplicity and sacred symbols
        let sacredElements = spec.elements.filter { $0.category.id == "symbols" }
        let sacredBonus = sacredElements.isEmpty ? 0.0 : 0.15

        // Bonus for simplicity (Buddhist aesthetic principles)
        let simplicityBonus = spec.elements.count <= 3 ? 0.1 : 0.0

        // Bonus for meditation/mindfulness focus
        let mindfulElements = spec.elements.filter {
            $0.category.id == "meditation" || $0.category.id == "zen" || $0.category.id == "compassion"
        }
        let mindfulBonus = mindfulElements.isEmpty ? 0.0 : 0.1

        return (genreScore * 0.25) + (avgElementScore * 0.35) + (paletteScore * 0.2) + sacredBonus + simplicityBonus + mindfulBonus
    }
}

// MARK: - Context Registration
extension BuddhistCulturalContext {
    static func register() {
        Task { @MainActor in
            CulturalContextManager.shared.registerContext(BuddhistCulturalContext())
        }
    }
}
