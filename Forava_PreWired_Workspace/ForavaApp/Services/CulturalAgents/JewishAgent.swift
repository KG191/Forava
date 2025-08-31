import Foundation
import SwiftUI

// MARK: - Jewish Occasions Cultural Agent
// Specialized agent for Jewish holidays (Rosh Hashanah, Hanukkah) design accuracy and cultural authenticity

class JewishAgent: CulturalAgent {

    private let occasion: String

    let culturalContext: String

    let primaryColors: [Color] = [
        Color(red: 0.0, green: 0.22, blue: 0.659),    // Blue #0038A8
        Color(red: 1.0, green: 1.0, blue: 1.0),       // White #FFFFFF
        Color(red: 0.753, green: 0.753, blue: 0.753)  // Silver #C0C0C0
    ]

    let culturalElements: [String]
    let culturalSymbols: [String]

    let designPrinciples: [String] = [
        "elegant_traditional_aesthetics", "meaningful_symbolism",
        "respectful_religious_imagery", "sophisticated_design", "cultural_heritage"
    ]

    init(occasion: String) {
        self.occasion = occasion

        switch occasion.lowercased() {
        case "rosh_hashanah":
            self.culturalContext = "rosh_hashanah_jewish"
            self.culturalElements = ["apples", "honey", "pomegranates", "shofar", "challah", "olive_branches"]
            self.culturalSymbols = ["🍎", "🍯", "🥖", "🐏", "🕊️"]
        case "hanukkah":
            self.culturalContext = "hanukkah_jewish"
            self.culturalElements = ["menorah", "dreidels", "oil_lamps", "star_of_david", "candles", "olive_oil"]
            self.culturalSymbols = ["🕎", "🕯️", "⭐", "✡️"]
        default:
            self.culturalContext = "jewish_general"
            self.culturalElements = ["star_of_david", "menorah", "olive_branches", "challah"]
            self.culturalSymbols = ["✡️", "🕎", "🕯️"]
        }
    }

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
            secondaryColors: [Color(red: 1.0, green: 0.843, blue: 0.0), .gray],
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

        // Check for Jewish colors
        if !hasJewishColors(designSpec.primaryColors) {
            suggestions.append(ValidationSuggestion(
                type: .culturalImprovement,
                description: "Consider traditional Jewish blue and white colors",
                implementationGuidance: "Include blue (#0038A8) and white for authenticity"
            ))
            authenticity -= 0.2
        }

        // Check for occasion-specific elements
        let hasEssentialElements = validateOccasionElements(designSpec.elements)
        if !hasEssentialElements {
            issues.append(ValidationIssue(
                severity: .major,
                description: "Missing essential \(occasion) elements",
                category: .culturalAccuracy,
                suggestedFix: getEssentialElementsSuggestion()
            ))
            accuracy -= 0.4
        }

        // Check for Star of David usage (religious sensitivity)
        let hasStarOfDavid = designSpec.symbols.contains { $0.symbol == "✡️" }
        if hasStarOfDavid {
            suggestions.append(ValidationSuggestion(
                type: .sensitivityImprovement,
                description: "Star of David requires respectful Jewish context",
                implementationGuidance: "Ensure Star of David is used with proper reverence"
            ))
        }

        return CulturalValidationResult(
            isValid: accuracy > 0.5 && authenticity > 0.3 && appropriateness > 0.5,
            accuracy: max(0.0, accuracy),
            culturalAuthenticity: max(0.0, authenticity),
            appropriateness: max(0.0, appropriateness),
            issues: issues,
            suggestions: suggestions
        )
    }

    func getCulturalPrompt(relationship: String, personalMessage: String?) -> String {
        let basePrompt = getOccasionSpecificPrompt()
        let relationshipContext = generateRelationshipContext(relationship)
        let personalContext = personalMessage != nil ? "Personal message: \(personalMessage!)" : ""

        return "\(basePrompt)\n\nRELATIONSHIP CONTEXT: \(relationshipContext)\n\(personalContext)"
    }

    // MARK: - Private Helper Methods

    private func getOccasionSpecificPrompt() -> String {
        switch occasion.lowercased() {
        case "rosh_hashanah":
            return """
            Create an authentic Rosh Hashanah (Jewish New Year) digital gift design featuring:

            ESSENTIAL ELEMENTS:
            - Traditional blue (#0038A8), white, and silver colors
            - Fresh red apples (symbol of sweet new year)
            - Golden honey (sweetness for the coming year)
            - Pomegranates with ruby-red seeds (fertility and abundance)
            - Shofar (ram's horn) with traditional curved shape
            - Round challah bread (cyclical nature of year)

            DESIGN PRINCIPLES:
            - Elegant and sophisticated aesthetic
            - Meaningful Jewish symbolism
            - Traditional blue and white color scheme
            - Respectful religious imagery
            - Celebration of renewal and hope
            """
        case "hanukkah":
            return """
            Create an authentic Hanukkah (Festival of Lights) digital gift design featuring:

            ESSENTIAL ELEMENTS:
            - Traditional blue (#0038A8), white, and silver colors
            - Beautiful nine-branched Hanukkah menorah (hanukkiah)
            - Warm golden candle flames representing eight nights
            - Traditional dreidels with Hebrew letters
            - Star of David with respectful usage
            - Oil lamp elements (miracle of oil)

            DESIGN PRINCIPLES:
            - Eight nights of light theme
            - Elegant traditional aesthetics
            - Jewish blue and white colors
            - Respectful religious symbolism
            - Celebration of religious freedom
            """
        default:
            return """
            Create an authentic Jewish cultural digital gift design featuring traditional elements and respectful symbolism.
            """
        }
    }

    private func generateCulturalElements(for relationship: String) -> [CulturalElement] {
        switch occasion.lowercased() {
        case "rosh_hashanah":
            return [
                CulturalElement(
                    name: "apples",
                    significance: "Sweet new year ahead",
                    visualDescription: "Fresh red apples with green leaves",
                    culturalImportance: .essential
                ),
                CulturalElement(
                    name: "honey",
                    significance: "Sweetness for the coming year",
                    visualDescription: "Golden honey jar with wooden dipper",
                    culturalImportance: .essential
                ),
                CulturalElement(
                    name: "shofar",
                    significance: "Call to spiritual awakening",
                    visualDescription: "Traditional curved ram's horn",
                    culturalImportance: .important
                )
            ]
        case "hanukkah":
            return [
                CulturalElement(
                    name: "menorah",
                    significance: "Nine-branched Hanukkah menorah",
                    visualDescription: "Elegant hanukkiah with nine candles",
                    culturalImportance: .essential
                ),
                CulturalElement(
                    name: "dreidels",
                    significance: "Traditional Hanukkah game and symbol",
                    visualDescription: "Wooden dreidel with Hebrew letters",
                    culturalImportance: .essential
                ),
                CulturalElement(
                    name: "candles",
                    significance: "Eight nights of miracles",
                    visualDescription: "Blue and white Hanukkah candles",
                    culturalImportance: .important
                )
            ]
        default:
            return []
        }
    }

    private func generateCulturalSymbols(for relationship: String) -> [CulturalSymbol] {
        var baseSymbols: [CulturalSymbol] = []

        switch occasion.lowercased() {
        case "rosh_hashanah":
            baseSymbols = [
                CulturalSymbol(
                    symbol: "🍎",
                    meaning: "Apple",
                    culturalSignificance: "Symbol of sweet new year in Jewish tradition",
                    appropriateUsage: "Central element in Rosh Hashanah celebrations"
                ),
                CulturalSymbol(
                    symbol: "🍯",
                    meaning: "Honey",
                    culturalSignificance: "Sweetness for the coming year",
                    appropriateUsage: "Traditional Rosh Hashanah blessing"
                )
            ]
        case "hanukkah":
            baseSymbols = [
                CulturalSymbol(
                    symbol: "🕎",
                    meaning: "Menorah",
                    culturalSignificance: "Central symbol of Hanukkah celebration",
                    appropriateUsage: "Primary decorative element for Hanukkah"
                ),
                CulturalSymbol(
                    symbol: "🕯️",
                    meaning: "Candle",
                    culturalSignificance: "Eight nights of Hanukkah miracles",
                    appropriateUsage: "Represents the miracle of oil lasting eight nights"
                )
            ]
        default:
            break
        }

        return baseSymbols
    }

    private func generateCulturalMessage(relationship: String, personalMessage: String?) -> String {
        let relationshipGreeting = getRelationshipGreeting(relationship)
        let occasionWish = getOccasionWish()

        if let personal = personalMessage, !personal.isEmpty {
            return "\(relationshipGreeting)\n\n\(personal)\n\n\(occasionWish)"
        } else {
            return "\(relationshipGreeting)\n\n\(occasionWish)"
        }
    }

    private func getOccasionWish() -> String {
        switch occasion.lowercased() {
        case "rosh_hashanah":
            return "L'Shanah Tovah! May this new year bring you health, happiness, and sweet blessings. שנה טובה!"
        case "hanukkah":
            return "Happy Hanukkah! May the Festival of Lights bring warmth, joy, and miracles to your home. חנוכה שמח!"
        default:
            return "Wishing you joy and blessings in this special time."
        }
    }

    private func getRelationshipGreeting(_ relationship: String) -> String {
        switch relationship.lowercased() {
        case "spouse", "partner":
            return "To my beloved"
        case "parent":
            return "To my dear parent"
        case "friend":
            return "To my cherished friend"
        default:
            return "To someone special"
        }
    }

    private func generateRelationshipContext(_ relationship: String) -> String {
        return "Respectful Jewish design emphasizing tradition, family, and spiritual meaning"
    }

    private func hasJewishColors(_ colors: [Color]) -> Bool {
        let hasBlue = colors.contains { color in
            let uiColor = UIColor(color)
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            uiColor.getRed(&red, green: &green, blue: &blue, alpha: nil)
            return blue > 0.5 && red < 0.3 && green < 0.4
        }

        let hasWhite = colors.contains { color in
            let uiColor = UIColor(color)
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            uiColor.getRed(&red, green: &green, blue: &blue, alpha: nil)
            return red > 0.9 && green > 0.9 && blue > 0.9
        }

        return hasBlue && hasWhite
    }

    private func validateOccasionElements(_ elements: [CulturalElement]) -> Bool {
        switch occasion.lowercased() {
        case "rosh_hashanah":
            return elements.contains { ["apples", "honey", "shofar"].contains($0.name) }
        case "hanukkah":
            return elements.contains { ["menorah", "dreidels", "candles"].contains($0.name) }
        default:
            return true
        }
    }

    private func getEssentialElementsSuggestion() -> String {
        switch occasion.lowercased() {
        case "rosh_hashanah":
            return "Include apples, honey, or shofar for Rosh Hashanah authenticity"
        case "hanukkah":
            return "Include menorah, dreidels, or candles for Hanukkah authenticity"
        default:
            return "Include appropriate Jewish cultural elements"
        }
    }
}
