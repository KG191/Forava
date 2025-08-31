import Foundation
import SwiftUI

// MARK: - Eid Cultural Agent
// Specialized agent for Eid design accuracy and cultural authenticity

class EidAgent: CulturalAgent {

    let culturalContext = "eid_islamic"

    let primaryColors: [Color] = [
        Color(red: 0.133, green: 0.545, blue: 0.133), // Green #228B22
        Color(red: 1.0, green: 0.843, blue: 0.0),     // Gold #FFD700
        Color(red: 1.0, green: 1.0, blue: 1.0)        // White #FFFFFF
    ]

    let culturalElements: [String] = [
        "crescents", "geometric_patterns", "minarets", "arabic_calligraphy",
        "stars", "islamic_arches", "mosaic_patterns", "palm_branches"
    ]

    let culturalSymbols: [String] = [
        "🌙", "⭐", "🕌", "📿", "🤲", "☪️"
    ]

    let designPrinciples: [String] = [
        "geometric_symmetry", "islamic_art_motifs", "calligraphic_beauty",
        "peaceful_colors", "spiritual_elements", "traditional_patterns"
    ]

    func generateDesign(relationship: String, personalMessage: String?) -> CulturalDesignSpec {

        let elements = generateCulturalElements(for: relationship)
        let symbols = generateCulturalSymbols(for: relationship)
        let typography = TypographyStyle.calligraphic
        let layout = LayoutPrinciples(
            symmetry: true,
            centerFocused: true,
            verticalFlow: false,
            gridBased: true,
            organicFlow: false
        )

        let culturalMessage = generateCulturalMessage(relationship: relationship, personalMessage: personalMessage)
        let aiPrompt = getCulturalPrompt(relationship: relationship, personalMessage: personalMessage)

        return CulturalDesignSpec(
            culturalContext: culturalContext,
            primaryColors: primaryColors,
            secondaryColors: [.silver, Color(red: 0.0, green: 0.5, blue: 0.0)],
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

        // Check for traditional Islamic colors
        if !hasTraditionalIslamicColors(designSpec.primaryColors) {
            issues.append(ValidationIssue(
                severity: .major,
                description: "Missing traditional Islamic colors (green, gold, white)",
                category: .colorAppropriateness,
                suggestedFix: "Add Islamic green (#228B22), gold (#FFD700), and white"
            ))
            authenticity -= 0.3
        }

        // Check for essential Islamic elements
        let hasEssentialElements = designSpec.elements.contains { element in
            ["crescents", "geometric_patterns", "stars"].contains(element.name)
        }

        if !hasEssentialElements {
            issues.append(ValidationIssue(
                severity: .major,
                description: "Missing essential Islamic elements",
                category: .culturalAccuracy,
                suggestedFix: "Include crescents, stars, or geometric patterns"
            ))
            accuracy -= 0.4
        }

        // Check for crescent and star symbol usage
        let hasCrescentStar = designSpec.symbols.contains { symbol in
            ["🌙", "⭐", "☪️"].contains(symbol.symbol)
        }
        if hasCrescentStar {
            suggestions.append(ValidationSuggestion(
                type: .sensitivityImprovement,
                description: "Islamic symbols require respectful usage",
                implementationGuidance: "Ensure crescent and star are used with proper Islamic context"
            ))
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
        Create an authentic Eid digital gift design featuring:

        ESSENTIAL ELEMENTS:
        - Islamic green (#228B22), gold (#FFD700), and white colors
        - Beautiful crescent moon with golden highlights
        - Elegant five-pointed stars
        - Traditional Islamic geometric patterns
        - Peaceful and spiritual atmosphere

        ISLAMIC ART ELEMENTS:
        - Arabic calligraphy in golden script
        - Mosque silhouettes with minarets
        - Islamic arch patterns
        - Traditional mosaic tile patterns
        - Prayer beads (tasbih) elements

        DESIGN PRINCIPLES:
        - Geometric symmetry and balance
        - Islamic art motifs and patterns
        - Calligraphic beauty and elegance
        - Peaceful and serene color palette
        - Respectful spiritual elements
        """

        let relationshipContext = generateRelationshipContext(relationship)
        let personalContext = personalMessage != nil ? "Personal message: \(personalMessage!)" : ""

        return "\(basePrompt)\n\nRELATIONSHIP CONTEXT: \(relationshipContext)\n\(personalContext)"
    }

    // MARK: - Private Helper Methods

    private func generateCulturalElements(for relationship: String) -> [CulturalElement] {
        return [
            CulturalElement(
                name: "crescents",
                significance: "Islamic symbol of faith and lunar calendar",
                visualDescription: "Golden crescent moon shapes",
                culturalImportance: .essential
            ),
            CulturalElement(
                name: "geometric_patterns",
                significance: "Traditional Islamic art patterns",
                visualDescription: "Intricate geometric designs",
                culturalImportance: .essential
            ),
            CulturalElement(
                name: "stars",
                significance: "Guidance and divine light",
                visualDescription: "Five-pointed golden stars",
                culturalImportance: .important
            )
        ]
    }

    private func generateCulturalSymbols(for relationship: String) -> [CulturalSymbol] {
        return [
            CulturalSymbol(
                symbol: "🌙",
                meaning: "Crescent Moon",
                culturalSignificance: "Symbol of Islam and lunar calendar",
                appropriateUsage: "Primary Islamic symbol, use respectfully"
            ),
            CulturalSymbol(
                symbol: "⭐",
                meaning: "Star",
                culturalSignificance: "Divine guidance and light",
                appropriateUsage: "Often paired with crescent moon"
            )
        ]
    }

    private func generateCulturalMessage(relationship: String, personalMessage: String?) -> String {
        let relationshipGreeting = getRelationshipGreeting(relationship)
        let traditionalWish = "عيد مبارك!" // Eid Mubarak!
        let englishWish = "May this blessed Eid bring you peace, happiness, and spiritual fulfillment"

        if let personal = personalMessage, !personal.isEmpty {
            return "\(relationshipGreeting)\n\n\(personal)\n\n\(englishWish)\n\n\(traditionalWish)"
        } else {
            return "\(relationshipGreeting)\n\n\(englishWish)\n\n\(traditionalWish)"
        }
    }

    private func getRelationshipGreeting(_ relationship: String) -> String {
        switch relationship.lowercased() {
        case "spouse", "partner":
            return "To my beloved partner"
        case "parent":
            return "To my respected parent"
        case "sibling", "brother", "sister":
            return "To my dear sibling"
        case "friend":
            return "To my cherished friend"
        default:
            return "To someone special"
        }
    }

    private func generateRelationshipContext(_ relationship: String) -> String {
        return "Respectful Islamic design emphasizing peace, spirituality, and divine blessings"
    }

    private func hasTraditionalIslamicColors(_ colors: [Color]) -> Bool {
        return colors.contains { color in
            let uiColor = UIColor(color)
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            uiColor.getRed(&red, green: &green, blue: &blue, alpha: nil)
            return green > 0.4 && red < 0.3 && blue < 0.3
        }
    }
}
