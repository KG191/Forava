import Foundation
import SwiftUI

// MARK: - Cultural Design Models

@MainActor
protocol CulturalAgent {
    var culturalContext: String { get }
    func generateDesign(relationship: String, personalMessage: String?) async -> CulturalDesignSpec
    func validateDesign(_ designSpec: CulturalDesignSpec) async -> CulturalValidationResult
    func getCulturalPrompt(relationship: String, personalMessage: String?) -> String
}

struct CulturalDesignSpec {
    let culturalContext: String
    let primaryColors: [Color]
    let secondaryColors: [Color]
    let elements: [CulturalElement]
    let symbols: [CulturalSymbol]
    let typography: TypographyStyle
    let layout: LayoutPrinciples
    let culturalMessage: String
    let aiPrompt: String
    let relationship: String
    let personalMessage: String?
    let genre: String?
    let colorPalette: [Color]?
    let targetAgeGroup: String?
    
    init(culturalContext: String, primaryColors: [Color] = [], secondaryColors: [Color] = [], elements: [CulturalElement] = [], symbols: [CulturalSymbol] = [], typography: TypographyStyle = .serif, layout: LayoutPrinciples = LayoutPrinciples(symmetry: true, centerFocused: true, verticalFlow: true, gridBased: false, organicFlow: false), culturalMessage: String = "", aiPrompt: String = "", relationship: String = "", personalMessage: String? = nil, genre: String? = nil, colorPalette: [Color]? = nil, targetAgeGroup: String? = nil) {
        self.culturalContext = culturalContext
        self.primaryColors = primaryColors
        self.secondaryColors = secondaryColors
        self.elements = elements
        self.symbols = symbols
        self.typography = typography
        self.layout = layout
        self.culturalMessage = culturalMessage
        self.aiPrompt = aiPrompt
        self.relationship = relationship
        self.personalMessage = personalMessage
        self.genre = genre
        self.colorPalette = colorPalette
        self.targetAgeGroup = targetAgeGroup
    }
}

struct CulturalElement: Codable, Hashable {
    let name: String
    let significance: String
    let visualDescription: String
    let culturalImportance: CulturalImportance
    
    init(name: String, significance: String, visualDescription: String, culturalImportance: CulturalImportance) {
        self.name = name
        self.significance = significance
        self.visualDescription = visualDescription
        self.culturalImportance = culturalImportance
    }
}

enum CulturalImportance: String, Codable, CaseIterable {
    case essential
    case important
    case optional
}

struct CulturalSymbol: Codable, Hashable {
    let symbol: String
    let meaning: String
    let culturalSignificance: String
    let appropriateUsage: String
    
    init(symbol: String, meaning: String, culturalSignificance: String, appropriateUsage: String) {
        self.symbol = symbol
        self.meaning = meaning
        self.culturalSignificance = culturalSignificance
        self.appropriateUsage = appropriateUsage
    }
}

// TypographyStyle moved to CulturalFramework.swift to avoid duplication

struct LayoutPrinciples: Codable, Hashable {
    let symmetry: Bool
    let centerFocused: Bool
    let verticalFlow: Bool
    let gridBased: Bool
    let organicFlow: Bool
    
    init(symmetry: Bool, centerFocused: Bool, verticalFlow: Bool, gridBased: Bool, organicFlow: Bool) {
        self.symmetry = symmetry
        self.centerFocused = centerFocused
        self.verticalFlow = verticalFlow
        self.gridBased = gridBased
        self.organicFlow = organicFlow
    }
}

struct CulturalValidationResult: Codable {
    let isValid: Bool
    let accuracy: Double
    let culturalAuthenticity: Double
    let appropriateness: Double
    let issues: [ValidationIssue]
    let suggestions: [ValidationSuggestion]
}

struct ValidationIssue: Codable {
    let severity: IssueSeverity
    let description: String
    let recommendation: String
    
    enum IssueSeverity: String, Codable, CaseIterable {
        case low
        case medium
        case high
        case critical
    }
}

struct ValidationSuggestion: Codable {
    let type: SuggestionType
    let description: String
    let implementationGuidance: String
    
    enum SuggestionType: String, Codable, CaseIterable {
        case culturalImprovement
        case technicalImprovement
        case accessibilityImprovement
    }
}
