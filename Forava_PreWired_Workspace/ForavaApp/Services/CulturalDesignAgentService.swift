import Foundation
import SwiftUI

// MARK: - Phase 6: Cultural Design Accuracy
// Specialized cultural agents for authentic design elements and validation

@MainActor
class CulturalDesignAgentService: ObservableObject {
    static let shared = CulturalDesignAgentService()

    @Published var activeAgent: CulturalAgent?
    @Published var validationResults: CulturalValidationResult?

    private init() {}

    // MARK: - Agent Selection

    func selectAgent(for occasion: String) {
        activeAgent = createAgent(for: occasion)
    }

    func createAgent(for occasion: String) -> CulturalAgent {
        switch occasion.lowercased() {
        case "chinese_new_year":
            return ChineseNewYearAgent()
        case "diwali":
            return DiwaliAgent()
        case "christmas":
            return ChristmasAgent()
        case "eid":
            return EidAgent()
        case "vesak":
            return VesakAgent()
        case "rosh_hashanah", "hanukkah":
            return JewishAgent(occasion: occasion)
        case "raksha_bandhan":
            return RakshaBandhanAgent()
        case "holi":
            return HoliAgent()
        case "mid_autumn_festival":
            return MidAutumnAgent()
        case "easter":
            return EasterAgent()
        case "birthday":
            return BirthdayAgent()
        default:
            return GenericAgent()
        }
    }

    // MARK: - Design Generation

    func generateCulturalDesign(for occasion: String, relationship: String, personalMessage: String?) -> CulturalDesignSpec {
        let agent = createAgent(for: occasion)
        return agent.generateDesign(relationship: relationship, personalMessage: personalMessage)
    }

    // MARK: - Cultural Validation

    func validateDesign(_ designSpec: CulturalDesignSpec, for occasion: String) -> CulturalValidationResult {
        let agent = createAgent(for: occasion)
        let result = agent.validateDesign(designSpec)
        validationResults = result
        return result
    }

    // MARK: - Cultural Sensitivity Check

    func performSensitivityCheck(_ designSpec: CulturalDesignSpec) -> SensitivityValidationResult {
        return SensitivityValidator.validate(designSpec)
    }
}

// MARK: - Cultural Agent Protocol

protocol CulturalAgent {
    var culturalContext: String { get }
    var primaryColors: [Color] { get }
    var culturalElements: [String] { get }
    var culturalSymbols: [String] { get }
    var designPrinciples: [String] { get }

    func generateDesign(relationship: String, personalMessage: String?) -> CulturalDesignSpec
    func validateDesign(_ designSpec: CulturalDesignSpec) -> CulturalValidationResult
    func getCulturalPrompt(relationship: String, personalMessage: String?) -> String
}

// MARK: - Cultural Design Specification

// NOTE: CulturalDesignSpec is now defined in CulturalFramework.swift
// This service works with that authoritative definition

struct CulturalElement {
    let name: String
    let significance: String
    let visualDescription: String
    let culturalImportance: CulturalImportance
}

struct CulturalSymbol {
    let symbol: String
    let meaning: String
    let culturalSignificance: String
    let appropriateUsage: String
}

enum CulturalImportance: String, CaseIterable {
    case essential = "Essential"
    case important = "Important"
    case decorative = "Decorative"
    case optional = "Optional"
}

enum TypographyStyle {
    case traditional
    case modern
    case calligraphic
    case geometric
    case serif
    case sansSerif
}

struct LayoutPrinciples {
    let symmetry: Bool
    let centerFocused: Bool
    let verticalFlow: Bool
    let gridBased: Bool
    let organicFlow: Bool
}

// MARK: - Validation Results

struct CulturalValidationResult {
    let isValid: Bool
    let accuracy: Double // 0.0 - 1.0
    let culturalAuthenticity: Double // 0.0 - 1.0
    let appropriateness: Double // 0.0 - 1.0
    let issues: [ValidationIssue]
    let suggestions: [ValidationSuggestion]

    var overallScore: Double {
        (accuracy + culturalAuthenticity + appropriateness) / 3.0
    }
}

struct ValidationIssue {
    let severity: IssueSeverity
    let description: String
    let category: IssueCategory
    let suggestedFix: String?
}

struct ValidationSuggestion {
    let type: SuggestionType
    let description: String
    let implementationGuidance: String
}

enum IssueSeverity: String, CaseIterable {
    case critical = "Critical"
    case major = "Major"
    case minor = "Minor"
    case informational = "Informational"
}

enum IssueCategory: String, CaseIterable {
    case culturalAccuracy = "Cultural Accuracy"
    case religiousSensitivity = "Religious Sensitivity"
    case colorAppropriateness = "Color Appropriateness"
    case symbolUsage = "Symbol Usage"
    case designPrinciples = "Design Principles"
    case contextMismatch = "Context Mismatch"
}

enum SuggestionType: String, CaseIterable {
    case enhancement = "Enhancement"
    case alternative = "Alternative"
    case culturalImprovement = "Cultural Improvement"
    case sensitivityImprovement = "Sensitivity Improvement"
}

// MARK: - Sensitivity Validation

struct SensitivityValidationResult {
    let isAppropriate: Bool
    let riskLevel: SensitivityRiskLevel
    let concerns: [SensitivityConcern]
    let recommendations: [String]
}

enum SensitivityRiskLevel: String, CaseIterable {
    case low = "Low"
    case moderate = "Moderate"
    case high = "High"
    case critical = "Critical"
}

struct SensitivityConcern {
    let area: SensitivityArea
    let description: String
    let mitigation: String
}

enum SensitivityArea: String, CaseIterable {
    case religiousSymbols = "Religious Symbols"
    case culturalAppropriation = "Cultural Appropriation"
    case colorSignificance = "Color Significance"
    case textualContent = "Textual Content"
    case visualRepresentation = "Visual Representation"
}

// MARK: - Sensitivity Validator

class SensitivityValidator {
    static func validate(_ designSpec: CulturalDesignSpec) -> SensitivityValidationResult {
        var concerns: [SensitivityConcern] = []
        var riskLevel: SensitivityRiskLevel = .low

        // Check for religious symbols
        for symbol in designSpec.symbols {
            if isReligiousSymbol(symbol.symbol) {
                concerns.append(SensitivityConcern(
                    area: .religiousSymbols,
                    description: "Contains religious symbol: \(symbol.symbol)",
                    mitigation: "Ensure respectful usage and cultural context"
                ))
                riskLevel = .moderate
            }
        }

        // Check for cultural appropriation risks
        if hasCulturalApropriationRisk(designSpec) {
            concerns.append(SensitivityConcern(
                area: .culturalAppropriation,
                description: "Design may risk cultural appropriation",
                mitigation: "Review cultural elements for authenticity and respect"
            ))
            riskLevel = .high
        }

        // Check color significance
        if hasColorSignificanceConcerns(designSpec) {
            concerns.append(SensitivityConcern(
                area: .colorSignificance,
                description: "Color choices may have unintended cultural meanings",
                mitigation: "Verify color significance in target culture"
            ))
        }

        let isAppropriate = concerns.isEmpty || riskLevel == .low
        let recommendations = generateRecommendations(for: concerns)

        return SensitivityValidationResult(
            isAppropriate: isAppropriate,
            riskLevel: riskLevel,
            concerns: concerns,
            recommendations: recommendations
        )
    }

    private static func isReligiousSymbol(_ symbol: String) -> Bool {
        let religiousSymbols = ["✝️", "☪️", "🕎", "☸️", "🕉️", "☦️"]
        return religiousSymbols.contains(symbol)
    }

    private static func hasCulturalApropriationRisk(_ designSpec: CulturalDesignSpec) -> Bool {
        // Basic heuristic - could be enhanced with ML
        return designSpec.elements.count > 5 && designSpec.symbols.count > 3
    }

    private static func hasColorSignificanceConcerns(_ designSpec: CulturalDesignSpec) -> Bool {
        // Check for potentially problematic color combinations
        let colors = designSpec.primaryColors + designSpec.secondaryColors
        return colors.count > 4
    }

    private static func generateRecommendations(for concerns: [SensitivityConcern]) -> [String] {
        return concerns.map { $0.mitigation }
    }
}
