import Foundation
import SwiftUI

// MARK: - Diwali Cultural Agent
// Specialized agent for Diwali design accuracy and cultural authenticity

class DiwaliAgent: CulturalAgent {

    let culturalContext = "diwali_indian"

    let primaryColors: [Color] = [
        Color(red: 1.0, green: 0.42, blue: 0.21),     // Deep Orange #FF6B35
        Color(red: 1.0, green: 0.843, blue: 0.0),     // Gold #FFD700
        Color(red: 0.502, green: 0.0, blue: 0.502)    // Purple #800080
    ]

    let culturalElements: [String] = [
        "rangoli_patterns", "diyas", "lotus_flowers", "peacocks",
        "elephants", "mango_leaves", "marigolds", "oil_lamps",
        "geometric_patterns", "paisley_motifs"
    ]

    let culturalSymbols: [String] = [
        "🪔", "🕉️", "✨", "🌸", "🦚", "🐘", "💫"
    ]

    let designPrinciples: [String] = [
        "intricate_patterns", "warm_luminous_colors", "circular_mandala_forms",
        "layered_complexity", "golden_highlights", "symmetrical_beauty"
    ]

    func generateDesign(relationship: String, personalMessage: String?) -> CulturalDesignSpec {

        let elements = generateCulturalElements(for: relationship)
        let symbols = generateCulturalSymbols(for: relationship)
        let typography = TypographyStyle.traditional
        let layout = LayoutPrinciples(
            symmetry: true,
            centerFocused: true,
            verticalFlow: false,
            gridBased: true,
            organicFlow: false
        )

        let culturalMessage = generateCulturalMessage(relationship: relationship, personalMessage: personalMessage)
        let aiPrompt = getCulturalPrompt(relationship: relationship, personalMessage: personalMessage)

        // Create default genre, color palette, and age group for Diwali
        let defaultGenre = CulturalGenre(
            id: "diwali_traditional",
            displayName: "Traditional Diwali",
            icon: "flame.fill",
            basePrompt: "traditional diwali festival of lights",
            culturalContext: culturalContext
        )

        let defaultColorPalette = CulturalColorPalette(
            id: "diwali_colors",
            displayName: "Diwali Colors",
            colors: [
                CulturalColor(name: "Deep Orange", hex: "#FF6B35", symbolism: "Festival warmth"),
                CulturalColor(name: "Gold", hex: "#FFD700", symbolism: "Prosperity"),
                CulturalColor(name: "Purple", hex: "#800080", symbolism: "Royalty")
            ],
            culturalContext: culturalContext
        )

        let defaultAgeGroup = CulturalAgeGroup(
            id: "diwali_all_ages",
            displayName: "All Ages",
            ageRange: "0-100",
            culturalContext: culturalContext
        )

        // Elements are already in CulturalDesignElement format
        let culturalDesignElements = elements

        return CulturalDesignSpec(
            culturalContext: culturalContext,
            genre: defaultGenre,
            elements: culturalDesignElements,
            colorPalette: defaultColorPalette,
            personalMessage: personalMessage,
            targetAgeGroup: defaultAgeGroup
        )
    }

    func validateDesign(_ designSpec: CulturalDesignSpec) -> CulturalValidationResult {
        var issues: [CulturalValidationIssue] = []
        var suggestions: [ValidationSuggestion] = []
        var accuracy = 1.0
        var authenticity = 1.0
        var appropriateness = 1.0

        // Check for traditional Diwali colors
        let hasTraditionalColors = designSpec.colorPalette.colors.contains { color in
            ["#FF6B35", "#FFD700", "#800080"].contains(color.hex)
        }

        if !hasTraditionalColors {
            issues.append(CulturalValidationIssue(
                severity: .major,
                description: "Missing traditional Diwali colors (deep orange, gold, purple)",
                category: .colorAppropriateness,
                suggestedFix: "Add deep orange (#FF6B35), gold (#FFD700), and purple (#800080)"
            ))
            authenticity -= 0.3
        }

        // Check for essential Diwali elements
        let hasEssentialElements = designSpec.elements.contains { element in
            ["rangoli_patterns", "diyas", "lotus_flowers"].contains(element.id)
        }

        if !hasEssentialElements {
            issues.append(CulturalValidationIssue(
                severity: .major,
                description: "Missing essential Diwali elements",
                category: .culturalAccuracy,
                suggestedFix: "Include rangoli patterns, diyas (oil lamps), or lotus flowers"
            ))
            accuracy -= 0.4
        }

        // Check for intricate patterns (authentic to Indian design)
        if !hasIntricatePatterns(designSpec.elements) {
            suggestions.append(ValidationSuggestion(
                type: .culturalImprovement,
                description: "Traditional Indian design emphasizes intricate patterns",
                implementationGuidance: "Add rangoli or mandala-style geometric patterns"
            ))
            authenticity -= 0.1
        }

        // Check for light/lamp symbolism (core to Diwali)
        if !hasLightSymbolism(designSpec.elements) {
            issues.append(CulturalValidationIssue(
                severity: .major,
                description: "Missing light symbolism central to Diwali (Festival of Lights)",
                category: .culturalAccuracy,
                suggestedFix: "Include diyas, oil lamps, or light-related elements"
            ))
            accuracy -= 0.4
        }

        return CulturalValidationResult(
            isValid: accuracy > 0.5 && authenticity > 0.5 && appropriateness > 0.5,
            accuracy: max(0.0, accuracy),
            culturalAuthenticity: max(0.0, authenticity),
            appropriateness: max(0.0, appropriateness),
            issues: issues,
            suggestions: suggestions
        )
    }

    func getCulturalPrompt(relationship: String, personalMessage: String?) -> String {
        let basePrompt = """
        Create an authentic Diwali (Festival of Lights) digital gift design featuring:

        ESSENTIAL ELEMENTS:
        - Deep orange (#FF6B35), gold (#FFD700), and purple (#800080) colors
        - Beautiful diyas (traditional oil lamps) with golden flames
        - Intricate rangoli patterns with geometric and floral motifs
        - Elegant lotus flowers symbolizing purity and prosperity
        - Warm golden lighting effects suggesting illumination

        CULTURAL ELEMENTS:
        - Peacocks with ornate feather patterns (symbol of grace)
        - Elephants decorated with traditional Indian motifs (prosperity)
        - Marigold flowers in garlands (auspicious flower)
        - Traditional paisley (mango) patterns
        - Mango leaves (symbol of fertility and growth)

        DESIGN PRINCIPLES:
        - Intricate, layered geometric patterns
        - Rich, warm, luminous color palette
        - Symmetrical mandala-style compositions
        - Golden highlights and light effects
        - Celebration of light over darkness theme
        - Traditional Indian aesthetic sensibilities
        """

        let relationshipContext = generateRelationshipContext(relationship)
        let personalContext = personalMessage != nil ? "Personal message: \(personalMessage!)" : ""

        return "\(basePrompt)\n\nRELATIONSHIP CONTEXT: \(relationshipContext)\n\(personalContext)"
    }

    // MARK: - Private Helper Methods

    private func generateCulturalElements(for relationship: String) -> [CulturalDesignElement] {
        let defaultAgeGroup = CulturalAgeGroup(
            id: "diwali_all_ages",
            displayName: "All Ages",
            ageRange: "0-100",
            culturalContext: culturalContext
        )

        var elements: [CulturalDesignElement] = [
            CulturalDesignElement(
                id: "diyas",
                displayName: "Traditional clay oil lamps with golden flames",
                category: .decorative,
                weight: 1.0,
                culturalSignificance: 0.9,
                ageAppropriate: [defaultAgeGroup],
                compatibleGenreIds: [],
                promptTokens: [],
                culturalContext: culturalContext,
                description: "Oil lamps representing light over darkness"
            ),
            CulturalDesignElement(
                id: "rangoli_patterns",
                displayName: "Intricate geometric and floral floor patterns",
                category: .decorative,
                weight: 1.0,
                culturalSignificance: 0.9,
                ageAppropriate: [defaultAgeGroup],
                compatibleGenreIds: [],
                promptTokens: [],
                culturalContext: culturalContext,
                description: "Decorative art symbolizing welcome and prosperity"
            ),
            CulturalDesignElement(
                id: "lotus_flowers",
                displayName: "Elegant pink and white lotus blooms",
                category: .decorative,
                weight: 1.0,
                culturalSignificance: 0.8,
                ageAppropriate: [defaultAgeGroup],
                compatibleGenreIds: [],
                promptTokens: [],
                culturalContext: culturalContext,
                description: "Purity, enlightenment, and prosperity"
            )
        ]

        // Add relationship-specific elements
        switch relationship.lowercased() {
        case "spouse", "partner":
            elements.append(CulturalDesignElement(
                id: "peacocks",
                displayName: "Ornate peacocks with flowing tail feathers",
                category: .decorative,
                weight: 1.0,
                culturalSignificance: 0.8,
                ageAppropriate: [defaultAgeGroup],
                compatibleGenreIds: [],
                promptTokens: [],
                culturalContext: culturalContext,
                description: "Grace, beauty, and marital harmony"
            ))
        case "parent", "grandparent":
            elements.append(CulturalDesignElement(
                id: "elephants",
                displayName: "Decorated elephants with traditional Indian motifs",
                category: .decorative,
                weight: 1.0,
                culturalSignificance: 0.8,
                ageAppropriate: [defaultAgeGroup],
                compatibleGenreIds: [],
                promptTokens: [],
                culturalContext: culturalContext,
                description: "Wisdom, strength, and family bonds"
            ))
        case "sibling", "brother", "sister":
            elements.append(CulturalDesignElement(
                id: "marigolds",
                displayName: "Orange and yellow marigold garlands",
                category: .decorative,
                weight: 1.0,
                culturalSignificance: 0.8,
                ageAppropriate: [defaultAgeGroup],
                compatibleGenreIds: [],
                promptTokens: [],
                culturalContext: culturalContext,
                description: "Auspicious flowers for celebrations"
            ))
        default:
            elements.append(CulturalDesignElement(
                id: "paisley_motifs",
                displayName: "Elegant paisley (mango) patterns",
                category: .decorative,
                weight: 1.0,
                culturalSignificance: 0.7,
                ageAppropriate: [defaultAgeGroup],
                compatibleGenreIds: [],
                promptTokens: [],
                culturalContext: culturalContext,
                description: "Traditional decorative patterns"
            ))
        }

        return elements
    }

    private func generateCulturalSymbols(for relationship: String) -> [CulturalSymbol] {
        var baseSymbols = [
            CulturalSymbol(
                symbol: "🪔",
                meaning: "Diya/Oil lamp",
                culturalSignificance: "Central symbol of Diwali - light over darkness",
                appropriateUsage: "Primary decorative element, often in groups"
            ),
            CulturalSymbol(
                symbol: "✨",
                meaning: "Sparkles/Light",
                culturalSignificance: "Represents the lights and fireworks of Diwali",
                appropriateUsage: "Accent element to enhance luminous theme"
            ),
            CulturalSymbol(
                symbol: "🌸",
                meaning: "Flower blossom",
                culturalSignificance: "Represents beauty and auspicious occasions",
                appropriateUsage: "Decorative element for warmth and celebration"
            )
        ]

        // Add Om symbol for appropriate relationships
        if ["parent", "grandparent", "spouse"].contains(relationship.lowercased()) {
            baseSymbols.append(
                CulturalSymbol(
                    symbol: "🕉️",
                    meaning: "Om/Aum",
                    culturalSignificance: "Sacred Hindu symbol representing universal consciousness",
                    appropriateUsage: "Use respectfully in spiritual context only"
                )
            )
        }

        return baseSymbols
    }

    private func generateCulturalMessage(relationship: String, personalMessage: String?) -> String {
        let relationshipGreeting = getRelationshipGreeting(relationship)
        let traditionalWish = "दीपावली की हार्दिक शुभकामनाएं!" // Happy Diwali wishes!
        let englishWish = "May this Festival of Lights illuminate your path with joy, prosperity, and happiness"

        if let personal = personalMessage, !personal.isEmpty {
            return "\(relationshipGreeting)\n\n\(personal)\n\n\(englishWish)\n\n\(traditionalWish)"
        } else {
            return "\(relationshipGreeting)\n\n\(englishWish)\n\n\(traditionalWish)"
        }
    }

    private func getRelationshipGreeting(_ relationship: String) -> String {
        switch relationship.lowercased() {
        case "spouse", "partner":
            return "To my beloved life partner"
        case "parent":
            return "To my respected parent"
        case "sibling", "brother", "sister":
            return "To my dear sibling"
        case "friend":
            return "To my cherished friend"
        case "colleague":
            return "To my esteemed colleague"
        case "grandparent":
            return "To my revered grandparent"
        default:
            return "To someone special in my life"
        }
    }

    private func generateRelationshipContext(_ relationship: String) -> String {
        switch relationship.lowercased() {
        case "spouse", "partner":
            return "Romantic and harmonious design emphasizing shared light and prosperity"
        case "parent", "grandparent":
            return "Respectful and reverent design emphasizing blessings and family traditions"
        case "sibling", "brother", "sister":
            return "Warm and celebratory design emphasizing family bonds and shared joy"
        case "friend":
            return "Friendly and festive design emphasizing light, happiness, and good fortune"
        case "colleague":
            return "Professional yet warm design emphasizing success and prosperity"
        default:
            return "Traditional and respectful design celebrating the triumph of light over darkness"
        }
    }

    // MARK: - Validation Helper Methods

    private func hasTraditionalDiwaliColors(_ colors: [Color]) -> Bool {
        let deepOrangePresent = colors.contains { color in
            let uiColor = UIColor(color)
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            uiColor.getRed(&red, green: &green, blue: &blue, alpha: nil)
            return red > 0.8 && green > 0.3 && green < 0.6 && blue < 0.4
        }

        let goldPresent = colors.contains { color in
            let uiColor = UIColor(color)
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            uiColor.getRed(&red, green: &green, blue: &blue, alpha: nil)
            return red > 0.8 && green > 0.6 && blue < 0.3
        }

        return deepOrangePresent && goldPresent
    }

    private func hasIntricatePatterns(_ elements: [CulturalDesignElement]) -> Bool {
        let patternElements = ["rangoli_patterns", "geometric_patterns", "paisley_motifs", "mandala_designs"]
        return elements.contains { element in
            patternElements.contains(element.id)
        }
    }

    private func hasLightSymbolism(_ elements: [CulturalDesignElement]) -> Bool {
        let lightElements = ["diyas", "oil_lamps", "candles", "fireworks"]
        return elements.contains { element in
            lightElements.contains(element.id)
        }
    }
}
