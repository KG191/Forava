import Foundation
import SwiftUI

// MARK: - Christmas Cultural Agent
// Specialized agent for Christmas design accuracy and cultural authenticity

class ChristmasAgent: CulturalAgent {

    let culturalContext = "christmas_christian"

    let primaryColors: [Color] = [
        Color(red: 0.769, green: 0.118, blue: 0.227), // Traditional Red #C41E3A
        Color(red: 0.133, green: 0.545, blue: 0.133), // Green #228B22
        Color(red: 1.0, green: 0.843, blue: 0.0)       // Gold #FFD700
    ]

    let culturalElements: [String] = [
        "holly", "pine_trees", "stars", "angels", "wreaths",
        "bells", "candles", "snowflakes", "gift_boxes", "ribbons"
    ]

    let culturalSymbols: [String] = [
        "🎄", "⭐", "🕯️", "🔔", "❄️", "🎁", "👼", "✝️"
    ]

    let designPrinciples: [String] = [
        "traditional_western_aesthetics", "warm_festive_atmosphere",
        "symmetrical_arrangements", "golden_accents", "peaceful_imagery"
    ]

    func generateDesign(relationship: String, personalMessage: String?) -> CulturalDesignSpec {

        let elements = generateCulturalElements(for: relationship)
        let symbols = generateCulturalSymbols(for: relationship)
        let typography = TypographyStyle.serif
        let layout = LayoutPrinciples(
            symmetry: true,
            centerFocused: true,
            verticalFlow: true,
            gridBased: false,
            organicFlow: false
        )

        let culturalMessage = generateCulturalMessage(relationship: relationship, personalMessage: personalMessage)
        let aiPrompt = getCulturalPrompt(relationship: relationship, personalMessage: personalMessage)

        return CulturalDesignSpec(
            culturalContext: culturalContext,
            primaryColors: primaryColors,
            secondaryColors: [.white, .silver, Color(red: 0.6, green: 0.4, blue: 0.2)],
            elements: elements,
            symbols: symbols,
            typography: typography,
            layout: layout,
            culturalMessage: culturalMessage,
            aiPrompt: aiPrompt,
            relationship: relationship,
            personalMessage: personalMessage
        )
    }

    func validateDesign(_ designSpec: CulturalDesignSpec) -> CulturalValidationResult {
        var issues: [ValidationIssue] = []
        var suggestions: [ValidationSuggestion] = []
        var accuracy = 1.0
        var authenticity = 1.0
        var appropriateness = 1.0

        // Check for traditional Christmas colors
        if !hasTraditionalChristmasColors(designSpec.primaryColors) {
            issues.append(ValidationIssue(
                severity: .major,
                description: "Missing traditional Christmas colors (red, green, gold)",
                category: .colorAppropriateness,
                suggestedFix: "Add traditional red (#C41E3A), green (#228B22), and gold (#FFD700)"
            ))
            authenticity -= 0.3
        }

        // Check for essential Christmas elements
        let hasEssentialElements = designSpec.elements.contains { element in
            ["pine_trees", "stars", "wreaths", "holly"].contains(element.name)
        }

        if !hasEssentialElements {
            issues.append(ValidationIssue(
                severity: .major,
                description: "Missing essential Christmas elements",
                category: .culturalAccuracy,
                suggestedFix: "Include Christmas trees, stars, wreaths, or holly"
            ))
            accuracy -= 0.4
        }

        // Check for cross symbol usage (religious sensitivity)
        let hasCrossSymbol = designSpec.symbols.contains { $0.symbol == "✝️" }
        if hasCrossSymbol {
            suggestions.append(ValidationSuggestion(
                type: .sensitivityImprovement,
                description: "Cross symbol requires respectful Christian context",
                implementationGuidance: "Ensure cross is used appropriately in religious context"
            ))
        }

        // Check for winter/festive theme
        if !hasWinterFestiveTheme(designSpec.elements) {
            suggestions.append(ValidationSuggestion(
                type: .culturalImprovement,
                description: "Traditional Christmas emphasizes winter festive elements",
                implementationGuidance: "Add snowflakes, bells, or candles for authentic atmosphere"
            ))
            authenticity -= 0.1
        }

        // Check for inappropriate elements from other cultures
        if hasInappropriateElements(designSpec.elements) {
            issues.append(ValidationIssue(
                severity: .critical,
                description: "Contains non-Christmas cultural elements",
                category: .culturalAccuracy,
                suggestedFix: "Remove elements from other religious or cultural traditions"
            ))
            appropriateness -= 0.5
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
        Create an authentic Christmas digital gift design featuring:

        ESSENTIAL ELEMENTS:
        - Traditional Christmas colors: red (#C41E3A), green (#228B22), and gold (#FFD700)
        - Elegant Christmas tree with golden star on top
        - Holly leaves with bright red berries
        - Beautiful Christmas wreath with red ribbon
        - Warm golden stars suggesting the Star of Bethlehem
        - White snowflakes creating winter atmosphere

        CHRISTMAS SYMBOLS:
        - Church bells with golden finish
        - Warm candles with soft golden light
        - Wrapped gift boxes with festive ribbons
        - Angels with flowing robes and wings
        - Pine boughs and evergreen elements

        DESIGN PRINCIPLES:
        - Traditional Western Christmas aesthetic
        - Warm, festive, and peaceful atmosphere
        - Symmetrical and balanced compositions
        - Golden accents and soft lighting effects
        - Classic Christmas card styling
        - Family-friendly and joyful mood
        """

        let relationshipContext = generateRelationshipContext(relationship)
        let personalContext = personalMessage != nil ? "Personal message: \(personalMessage!)" : ""

        return "\(basePrompt)\n\nRELATIONSHIP CONTEXT: \(relationshipContext)\n\(personalContext)"
    }

    // MARK: - Private Helper Methods

    private func generateCulturalElements(for relationship: String) -> [CulturalElement] {
        var elements: [CulturalElement] = [
            CulturalElement(
                name: "pine_trees",
                significance: "Evergreen life and hope during winter",
                visualDescription: "Traditional Christmas tree with golden star",
                culturalImportance: .essential
            ),
            CulturalElement(
                name: "stars",
                significance: "Star of Bethlehem guiding the way",
                visualDescription: "Golden stars with radiating light",
                culturalImportance: .essential
            ),
            CulturalElement(
                name: "holly",
                significance: "Protection and eternal life",
                visualDescription: "Green holly leaves with red berries",
                culturalImportance: .important
            )
        ]

        // Add relationship-specific elements
        switch relationship.lowercased() {
        case "spouse", "partner":
            elements.append(CulturalElement(
                name: "bells",
                significance: "Joy and celebration of love",
                visualDescription: "Golden church bells with ribbons",
                culturalImportance: .important
            ))
        case "parent", "grandparent":
            elements.append(CulturalElement(
                name: "angels",
                significance: "Divine protection and blessings",
                visualDescription: "Graceful angels with flowing robes",
                culturalImportance: .important
            ))
        case "friend", "colleague":
            elements.append(CulturalElement(
                name: "wreaths",
                significance: "Welcome and hospitality",
                visualDescription: "Green wreaths with red bows",
                culturalImportance: .important
            ))
        default:
            elements.append(CulturalElement(
                name: "candles",
                significance: "Light of Christ and warmth",
                visualDescription: "Warm candles with golden flames",
                culturalImportance: .decorative
            ))
        }

        return elements
    }

    private func generateCulturalSymbols(for relationship: String) -> [CulturalSymbol] {
        var baseSymbols = [
            CulturalSymbol(
                symbol: "🎄",
                meaning: "Christmas Tree",
                culturalSignificance: "Central symbol of Christmas celebration",
                appropriateUsage: "Primary decorative element, often centrally placed"
            ),
            CulturalSymbol(
                symbol: "⭐",
                meaning: "Christmas Star",
                culturalSignificance: "Star of Bethlehem that guided the wise men",
                appropriateUsage: "Top of tree or as guiding light element"
            ),
            CulturalSymbol(
                symbol: "🎁",
                meaning: "Gift Box",
                culturalSignificance: "Spirit of giving and God's gift to humanity",
                appropriateUsage: "Decorative element representing generosity"
            )
        ]

        // Add cross for appropriate relationships (family/close)
        if ["parent", "grandparent", "spouse"].contains(relationship.lowercased()) {
            baseSymbols.append(
                CulturalSymbol(
                    symbol: "✝️",
                    meaning: "Christian Cross",
                    culturalSignificance: "Central symbol of Christianity and Christmas meaning",
                    appropriateUsage: "Use respectfully in religious context only"
                )
            )
        }

        return baseSymbols
    }

    private func generateCulturalMessage(relationship: String, personalMessage: String?) -> String {
        let relationshipGreeting = getRelationshipGreeting(relationship)
        let englishWish = "May the peace and joy of Christmas fill your heart and home with blessings"
        let traditionalWish = "Merry Christmas and God bless!"

        if let personal = personalMessage, !personal.isEmpty {
            return "\(relationshipGreeting)\n\n\(personal)\n\n\(englishWish)\n\n\(traditionalWish)"
        } else {
            return "\(relationshipGreeting)\n\n\(englishWish)\n\n\(traditionalWish)"
        }
    }

    private func getRelationshipGreeting(_ relationship: String) -> String {
        switch relationship.lowercased() {
        case "spouse", "partner":
            return "To my beloved"
        case "parent":
            return "To my dear parent"
        case "sibling", "brother", "sister":
            return "To my wonderful sibling"
        case "friend":
            return "To my dear friend"
        case "colleague":
            return "To my valued colleague"
        case "grandparent":
            return "To my cherished grandparent"
        default:
            return "To someone special"
        }
    }

    private func generateRelationshipContext(_ relationship: String) -> String {
        switch relationship.lowercased() {
        case "spouse", "partner":
            return "Romantic and warm design emphasizing love and togetherness during Christmas"
        case "parent", "grandparent":
            return "Respectful and traditional design emphasizing family bonds and blessings"
        case "sibling", "brother", "sister":
            return "Warm and joyful design emphasizing family connection and shared memories"
        case "friend":
            return "Friendly and festive design emphasizing joy, peace, and good wishes"
        case "colleague":
            return "Professional yet warm design emphasizing goodwill and season's greetings"
        default:
            return "Traditional Christmas design suitable for general holiday greetings"
        }
    }

    // MARK: - Validation Helper Methods

    private func hasTraditionalChristmasColors(_ colors: [Color]) -> Bool {
        let redPresent = colors.contains { color in
            let uiColor = UIColor(color)
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            uiColor.getRed(&red, green: &green, blue: &blue, alpha: nil)
            return red > 0.6 && green < 0.3 && blue < 0.4
        }

        let greenPresent = colors.contains { color in
            let uiColor = UIColor(color)
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            uiColor.getRed(&red, green: &green, blue: &blue, alpha: nil)
            return red < 0.3 && green > 0.4 && blue < 0.3
        }

        return redPresent && greenPresent
    }

    private func hasWinterFestiveTheme(_ elements: [CulturalElement]) -> Bool {
        let winterElements = ["snowflakes", "candles", "bells", "wreaths", "gift_boxes"]
        return elements.contains { element in
            winterElements.contains(element.name)
        }
    }

    private func hasInappropriateElements(_ elements: [CulturalElement]) -> Bool {
        let inappropriateElements = [
            "menorah", "crescent_moon", "diya_lamp", "lotus_buddhist",
            "dragons", "lanterns", "om_symbol", "star_of_david"
        ]

        return elements.contains { element in
            inappropriateElements.contains(element.name)
        }
    }
}
