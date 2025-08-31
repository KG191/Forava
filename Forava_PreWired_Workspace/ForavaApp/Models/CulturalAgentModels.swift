import Foundation
import SwiftUI

// MARK: - Cultural Agent Protocol

protocol CulturalAgent {
    var culturalContext: String { get }
    
    func generateDesign(relationship: String, personalMessage: String?) -> CulturalDesignSpec
    func validateDesign(_ designSpec: CulturalDesignSpec) -> CulturalValidationResult
    func getCulturalPrompt(relationship: String, personalMessage: String?) -> String
}

// MARK: - Cultural Design Models

struct CulturalDesignSpec {
    let culturalContext: String
    let primaryColors: [Color]
    let secondaryColors: [Color]
    let elements: [CulturalDesignElement]
    let symbols: [CulturalSymbol]
    let typography: TypographyStyle
    let layout: LayoutPrinciples
    let culturalMessage: String
    let aiPrompt: String
    let relationship: String
    let personalMessage: String?
}

struct CulturalDesignElement {
    let name: String
    let significance: String
    let visualDescription: String
    let culturalImportance: CulturalImportance
    
    enum CulturalImportance {
        case essential
        case important
        case optional
    }
}

struct CulturalSymbol {
    let symbol: String
    let meaning: String
    let culturalSignificance: String
    let appropriateUsage: String
}

enum CulturalValidationSeverity {
    case critical
    case major
    case minor
    case info
}

struct CulturalValidationResult {
    let isValid: Bool
    let accuracy: Double
    let culturalAuthenticity: Double
    let appropriateness: Double
    let issues: [ValidationIssue]
    let suggestions: [ValidationSuggestion]
}

struct LayoutPrinciples {
    let symmetry: Bool
    let centerFocused: Bool
    let verticalFlow: Bool
    let gridBased: Bool
    let organicFlow: Bool
}
