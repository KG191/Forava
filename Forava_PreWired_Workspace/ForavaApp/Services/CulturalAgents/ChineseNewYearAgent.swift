import Foundation
import SwiftUI

// MARK: - Chinese New Year Cultural Agent
// Specialized agent for Chinese New Year design accuracy and cultural authenticity

class ChineseNewYearAgent: CulturalAgent {

    let culturalContext = "cny_chinese"

    let primaryColors: [Color] = [
        Color(red: 0.863, green: 0.078, blue: 0.235), // Traditional Red #DC143C
        Color(red: 1.0, green: 0.843, blue: 0.0)      // Gold #FFD700
    ]

    let culturalElements: [String] = [
        "dragons", "lanterns", "plum_blossoms", "coins",
        "firecrackers", "bamboo", "peonies", "phoenixes",
        "zodiac_animals", "traditional_gates"
    ]

    let culturalSymbols: [String] = [
        "福", "春", "囍", "寿", "🧧", "🏮", "🐉", "🎆"
    ]

    let designPrinciples: [String] = [
        "symmetrical_balance", "auspicious_numbers", "red_dominance",
        "gold_accents", "flowing_movements", "circular_harmony"
    ]

    func generateDesign(relationship: String, personalMessage: String?) -> CulturalDesignSpec {

        let elements = generateCulturalElements(for: relationship)
        let symbols = generateCulturalSymbols(for: relationship)
        let typography = TypographyStyle.traditional
        let layout = LayoutPrinciples(
            symmetry: true,
            centerFocused: true,
            verticalFlow: false,
            gridBased: false,
            organicFlow: true
        )

        let culturalMessage = generateCulturalMessage(relationship: relationship, personalMessage: personalMessage)
        let aiPrompt = getCulturalPrompt(relationship: relationship, personalMessage: personalMessage)

        return CulturalDesignSpec(
            culturalContext: culturalContext,
            primaryColors: primaryColors,
            secondaryColors: [.black, .white, Color(red: 0.6, green: 0.2, blue: 0.0)],
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

        // Check color authenticity
        if !hasTraditionalChineseColors(designSpec.primaryColors) {
            issues.append(ValidationIssue(
                severity: .major,
                description: "Missing traditional Chinese New Year colors (red and gold)",
                category: .colorAppropriateness,
                suggestedFix: "Add traditional red (#DC143C) and gold (#FFD700)"
            ))
            authenticity -= 0.3
        }

        // Check for essential elements
        let hasEssentialElements = designSpec.elements.contains { element in
            ["dragons", "lanterns", "plum_blossoms"].contains(element.name)
        }

        if !hasEssentialElements {
            issues.append(ValidationIssue(
                severity: .major,
                description: "Missing essential Chinese New Year elements",
                category: .culturalAccuracy,
                suggestedFix: "Include dragons, lanterns, or plum blossoms"
            ))
            accuracy -= 0.4
        }

        // Check for inappropriate elements
        if hasInappropriateElements(designSpec.elements) {
            issues.append(ValidationIssue(
                severity: .critical,
                description: "Contains culturally inappropriate elements",
                category: .culturalAccuracy,
                suggestedFix: "Remove non-Chinese cultural elements"
            ))
            appropriateness -= 0.5
        }

        // Check for auspicious symbols
        if !hasAuspiciousSymbols(designSpec.symbols) {
            suggestions.append(ValidationSuggestion(
                type: .culturalImprovement,
                description: "Consider adding traditional Chinese characters like 福 (fortune)",
                implementationGuidance: "Include 福, 春, or other auspicious Chinese characters"
            ))
        }

        // Check symmetry (important in Chinese design)
        if !designSpec.layout.symmetry {
            suggestions.append(ValidationSuggestion(
                type: .enhancement,
                description: "Chinese design traditionally emphasizes symmetrical balance",
                implementationGuidance: "Apply symmetrical layout principles"
            ))
            authenticity -= 0.1
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
        Create an authentic Chinese New Year digital gift design featuring:

        ESSENTIAL ELEMENTS:
        - Traditional Chinese red (#DC143C) and gold (#FFD700) colors
        - Elegant Chinese dragons in flowing, dynamic poses
        - Traditional red lanterns with golden tassels
        - Delicate plum blossoms (symbol of perseverance and hope)
        - Chinese coins with square holes (symbol of prosperity)
        - Bamboo elements (symbol of strength and flexibility)

        CULTURAL SYMBOLS:
        - 福 character (fortune/blessing) in golden calligraphy
        - Traditional Chinese decorative patterns
        - Auspicious cloud motifs
        - Phoenix imagery (if appropriate for relationship)

        DESIGN PRINCIPLES:
        - Symmetrical and balanced composition
        - Rich, saturated colors with gold accents
        - Flowing, organic movements
        - Traditional Chinese aesthetic sensibilities
        - Festive and prosperous atmosphere
        """

        let relationshipContext = generateRelationshipContext(relationship)
        let personalContext = personalMessage != nil ? "Personal message: \(personalMessage!)" : ""

        return "\(basePrompt)\n\nRELATIONSHIP CONTEXT: \(relationshipContext)\n\(personalContext)"
    }

    // MARK: - Private Helper Methods

    private func generateCulturalElements(for relationship: String) -> [CulturalElement] {
        var elements: [CulturalElement] = [
            CulturalElement(
                name: "dragons",
                significance: "Power, strength, and good fortune",
                visualDescription: "Flowing Chinese dragon with golden scales",
                culturalImportance: .essential
            ),
            CulturalElement(
                name: "lanterns",
                significance: "Light, hope, and celebration",
                visualDescription: "Traditional red lanterns with golden tassels",
                culturalImportance: .essential
            ),
            CulturalElement(
                name: "plum_blossoms",
                significance: "Perseverance and renewal",
                visualDescription: "Delicate pink and white plum blossoms",
                culturalImportance: .important
            )
        ]

        // Add relationship-specific elements
        switch relationship.lowercased() {
        case "spouse", "partner":
            elements.append(CulturalElement(
                name: "phoenixes",
                significance: "Harmony in marriage, imperial grace",
                visualDescription: "Elegant phoenix with flowing tail feathers",
                culturalImportance: .important
            ))
        case "parent", "grandparent":
            elements.append(CulturalElement(
                name: "peonies",
                significance: "Honor, wealth, and longevity",
                visualDescription: "Full-bloomed peonies in rich colors",
                culturalImportance: .important
            ))
        case "friend", "colleague":
            elements.append(CulturalElement(
                name: "bamboo",
                significance: "Friendship, strength, and flexibility",
                visualDescription: "Graceful bamboo stalks with leaves",
                culturalImportance: .important
            ))
        default:
            elements.append(CulturalElement(
                name: "coins",
                significance: "Prosperity and good fortune",
                visualDescription: "Traditional Chinese coins with square holes",
                culturalImportance: .decorative
            ))
        }

        return elements
    }

    private func generateCulturalSymbols(for relationship: String) -> [CulturalSymbol] {
        let baseSymbols = [
            CulturalSymbol(
                symbol: "福",
                meaning: "Fortune/Blessing",
                culturalSignificance: "Most important Chinese New Year symbol",
                appropriateUsage: "Central placement, often upside down for 'fortune arrives'"
            ),
            CulturalSymbol(
                symbol: "🧧",
                meaning: "Red envelope/hongbao",
                culturalSignificance: "Gift-giving tradition during Chinese New Year",
                appropriateUsage: "Represents monetary gifts and good wishes"
            ),
            CulturalSymbol(
                symbol: "🏮",
                meaning: "Red lantern",
                culturalSignificance: "Brings light and wards off evil spirits",
                appropriateUsage: "Decorative element, often in pairs"
            )
        ]

        return baseSymbols
    }

    private func generateCulturalMessage(relationship: String, personalMessage: String?) -> String {
        let relationshipGreeting = getRelationshipGreeting(relationship)
        let traditionalWish = "恭喜发财，新年快乐！" // Happy New Year, Wishing you prosperity!
        let englishWish = "Wishing you prosperity and happiness in the new year"

        if let personal = personalMessage, !personal.isEmpty {
            return "\(relationshipGreeting)\n\n\(personal)\n\n\(englishWish)\n\(traditionalWish)"
        } else {
            return "\(relationshipGreeting)\n\n\(englishWish)\n\(traditionalWish)"
        }
    }

    private func getRelationshipGreeting(_ relationship: String) -> String {
        switch relationship.lowercased() {
        case "spouse", "partner":
            return "To my beloved partner"
        case "parent":
            return "To my dear parent"
        case "sibling", "brother", "sister":
            return "To my wonderful sibling"
        case "friend":
            return "To my cherished friend"
        case "colleague":
            return "To my esteemed colleague"
        case "grandparent":
            return "To my honored grandparent"
        default:
            return "To someone special"
        }
    }

    private func generateRelationshipContext(_ relationship: String) -> String {
        switch relationship.lowercased() {
        case "spouse", "partner":
            return "Romantic and harmonious design emphasizing unity and shared prosperity"
        case "parent", "grandparent":
            return "Respectful and honoring design emphasizing longevity and family bonds"
        case "sibling", "brother", "sister":
            return "Warm and playful design emphasizing family connection and joy"
        case "friend":
            return "Friendly and celebratory design emphasizing good fortune and happiness"
        case "colleague":
            return "Professional yet warm design emphasizing success and prosperity"
        default:
            return "Traditional and respectful design suitable for general gifting"
        }
    }

    // MARK: - Validation Helper Methods

    private func hasTraditionalChineseColors(_ colors: [Color]) -> Bool {
        let redPresent = colors.contains { color in
            // Check if color is close to traditional Chinese red
            let uiColor = UIColor(color)
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            uiColor.getRed(&red, green: &green, blue: &blue, alpha: nil)
            return red > 0.7 && green < 0.3 && blue < 0.3
        }

        let goldPresent = colors.contains { color in
            // Check if color is close to gold
            let uiColor = UIColor(color)
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            uiColor.getRed(&red, green: &green, blue: &blue, alpha: nil)
            return red > 0.8 && green > 0.6 && blue < 0.3
        }

        return redPresent && goldPresent
    }

    private func hasInappropriateElements(_ elements: [CulturalElement]) -> Bool {
        let inappropriateElements = [
            "christmas_tree", "easter_egg", "menorah", "crescent_moon",
            "diya_lamp", "lotus_buddhist", "cross", "star_of_david"
        ]

        return elements.contains { element in
            inappropriateElements.contains(element.name)
        }
    }

    private func hasAuspiciousSymbols(_ symbols: [CulturalSymbol]) -> Bool {
        let auspiciousSymbols = ["福", "春", "囍", "寿"]
        return symbols.contains { symbol in
            auspiciousSymbols.contains(symbol.symbol)
        }
    }
}
