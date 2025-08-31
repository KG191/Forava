import Foundation
import SwiftUI

// MARK: - Vesak Day Cultural Agent
// Specialized agent for Vesak Day design accuracy and cultural authenticity

class VesakAgent: CulturalAgent {

    let culturalContext = "vesak_buddhist"

    let primaryColors: [Color] = [
        Color(red: 1.0, green: 0.6, blue: 0.2),       // Saffron #FF9933
        Color(red: 1.0, green: 1.0, blue: 1.0),       // White #FFFFFF
        Color(red: 0.678, green: 0.847, blue: 0.902)  // Light Blue #ADE8E6
    ]

    let culturalElements: [String] = [
        "lotus_flowers", "buddha_imagery", "dharma_wheels", "bodhi_leaves",
        "prayer_flags", "temple_architecture", "meditation_poses", "incense"
    ]

    let culturalSymbols: [String] = [
        "🪷", "☸️", "🧘", "🕯️", "🙏", "☮️"
    ]

    let designPrinciples: [String] = [
        "serene_meditative_aesthetic", "peaceful_imagery", "balanced_composition",
        "spiritual_symbolism", "natural_elements", "mindful_simplicity"
    ]

    func generateDesign(relationship: String, personalMessage: String?) -> CulturalDesignSpec {

        let elements = generateCulturalElements(for: relationship)
        let symbols = generateCulturalSymbols(for: relationship)

        // Build genre, color palette and age group using authoritative types from CulturalFramework
        let defaultGenre = CulturalGenre(
            id: "vesak_traditional",
            displayName: "Traditional Vesak",
            icon: "lotus.fill",
            basePrompt: "traditional Vesak buddhist design",
            culturalContext: culturalContext
        )

        let defaultColorPalette = CulturalColorPalette(
            id: "vesak_colors",
            displayName: "Vesak Colors",
            colors: [
                CulturalColor(name: "Saffron", hex: "#FF9933", symbolism: "Spiritual purity"),
                CulturalColor(name: "White", hex: "#FFFFFF", symbolism: "Purity and peace"),
                CulturalColor(name: "LightBlue", hex: "#ADE8E6", symbolism: "Compassion and calm")
            ],
            culturalContext: culturalContext
        )

        let defaultAgeGroup = CulturalAgeGroup(
            id: "vesak_all_ages",
            displayName: "All Ages",
            ageRange: "0-100",
            culturalContext: culturalContext
        )

        return CulturalDesignSpec(
            culturalContext: culturalContext,
            genre: defaultGenre,
            elements: elements,
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

        // Check for Buddhist colors (inspect palette hex values)
        let hasSaffron = designSpec.colorPalette.colors.contains { $0.hex.lowercased() == "#ff9933" }
        if !hasSaffron {
            suggestions.append(ValidationSuggestion(
                type: .culturalImprovement,
                description: "Consider adding traditional Buddhist saffron color",
                implementationGuidance: "Include saffron (#FF9933) for authenticity"
            ))
            authenticity -= 0.2
        }

        // Check for essential Buddhist elements by id
        let elementIds = designSpec.elements.map { $0.id }
        let hasEssentialElements = elementIds.contains(where: { ["lotus_flowers", "dharma_wheels", "bodhi_leaves"].contains($0) })

        if !hasEssentialElements {
            issues.append(CulturalValidationIssue(
                severity: .major,
                description: "Missing essential Buddhist elements",
                category: .culturalAccuracy,
                suggestedFix: "Include lotus flowers, dharma wheels, or bodhi leaves"
            ))
            accuracy -= 0.4
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
        let basePrompt = """
        Create an authentic Vesak Day (Buddha's Birthday) digital gift design featuring:

        ESSENTIAL ELEMENTS:
        - Saffron (#FF9933), white, and light blue colors
        - Beautiful lotus flowers in full bloom (symbol of enlightenment)
        - Dharma wheel (Wheel of Dharma) with eight spokes
        - Bodhi tree leaves (tree of enlightenment)
        - Peaceful and meditative atmosphere

        BUDDHIST SYMBOLS:
        - Buddha in meditation pose (respectfully depicted)
        - Prayer flags with peaceful colors
        - Temple architecture elements
        - Incense with gentle smoke
        - Peaceful water elements

        DESIGN PRINCIPLES:
        - Serene and meditative aesthetic
        - Balanced and harmonious composition
        - Natural elements and organic forms
        - Mindful simplicity and peace
        - Spiritual symbolism with reverence
        """

        let relationshipContext = generateRelationshipContext(relationship)
        let personalContext = personalMessage != nil ? "Personal message: \(personalMessage!)" : ""

        return "\(basePrompt)\n\nRELATIONSHIP CONTEXT: \(relationshipContext)\n\(personalContext)"
    }

    // MARK: - Private Helper Methods

    private func generateCulturalElements(for relationship: String) -> [CulturalDesignElement] {
        let defaultAgeGroup = CulturalAgeGroup(
            id: "vesak_all_ages",
            displayName: "All Ages",
            ageRange: "0-100",
            culturalContext: culturalContext
        )

        var elements: [CulturalDesignElement] = [
            CulturalDesignElement(
                id: "lotus_flowers",
                displayName: "Lotus Flowers",
                category: .sacred,
                weight: 1.0,
                culturalSignificance: 0.95,
                ageAppropriate: [defaultAgeGroup],
                compatibleGenreIds: [],
                promptTokens: [],
                culturalContext: culturalContext,
                description: "Pink and white lotus blooms representing purity and enlightenment"
            ),
            CulturalDesignElement(
                id: "dharma_wheels",
                displayName: "Dharma Wheel",
                category: .sacred,
                weight: 1.0,
                culturalSignificance: 0.9,
                ageAppropriate: [defaultAgeGroup],
                compatibleGenreIds: [],
                promptTokens: [],
                culturalContext: culturalContext,
                description: "Golden wheel with eight spokes representing the teachings of the Buddha"
            ),
            CulturalDesignElement(
                id: "bodhi_leaves",
                displayName: "Bodhi Leaves",
                category: .natural,
                weight: 0.8,
                culturalSignificance: 0.8,
                ageAppropriate: [defaultAgeGroup],
                compatibleGenreIds: [],
                promptTokens: [],
                culturalContext: culturalContext,
                description: "Heart-shaped leaves from the Bodhi tree"
            )
        ]

        // relationship specific additions
        switch relationship.lowercased() {
        case "spouse", "partner":
            elements.append(CulturalDesignElement(
                id: "paired_lotus",
                displayName: "Paired Lotus",
                category: .decorative,
                weight: 0.9,
                culturalSignificance: 0.75,
                ageAppropriate: [defaultAgeGroup],
                compatibleGenreIds: [],
                promptTokens: [],
                culturalContext: culturalContext,
                description: "Two lotus flowers representing partnership"
            ))
        default:
            break
        }

        return elements
    }

    private func generateCulturalSymbols(for relationship: String) -> [CulturalSymbol] {
        return [
            CulturalSymbol(
                symbol: "🪷",
                meaning: "Lotus Flower",
                culturalSignificance: "Symbol of purity and spiritual awakening",
                appropriateUsage: "Primary Buddhist symbol of enlightenment"
            ),
            CulturalSymbol(
                symbol: "☸️",
                meaning: "Dharma Wheel",
                culturalSignificance: "Wheel of Buddhist teachings",
                appropriateUsage: "Sacred symbol, use with reverence"
            )
        ]
    }

    private func generateCulturalMessage(relationship: String, personalMessage: String?) -> String {
        let relationshipGreeting = getRelationshipGreeting(relationship)
        let englishWish = "May the teachings of Buddha bring you inner peace, wisdom, and compassion"
        let traditionalWish = "Happy Vesak Day! May you find enlightenment on your spiritual journey."

        if let personal = personalMessage, !personal.isEmpty {
            return "\(relationshipGreeting)\n\n\(personal)\n\n\(englishWish)\n\n\(traditionalWish)"
        } else {
            return "\(relationshipGreeting)\n\n\(englishWish)\n\n\(traditionalWish)"
        }
    }

    private func getRelationshipGreeting(_ relationship: String) -> String {
        switch relationship.lowercased() {
        case "spouse", "partner":
            return "To my beloved companion on the path"
        case "parent":
            return "To my respected parent"
        case "friend":
            return "To my dharma friend"
        default:
            return "To a fellow being on the path to enlightenment"
        }
    }

    private func generateRelationshipContext(_ relationship: String) -> String {
        return "Peaceful Buddhist design emphasizing compassion, wisdom, and spiritual growth"
    }

    private func hasBuddhistColors(_ colors: [Color]) -> Bool {
        return colors.contains { color in
            let uiColor = UIColor(color)
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            uiColor.getRed(&red, green: &green, blue: &blue, alpha: nil)
            return red > 0.8 && green > 0.5 && green < 0.7 && blue < 0.4 // Saffron range
        }
    }
}
