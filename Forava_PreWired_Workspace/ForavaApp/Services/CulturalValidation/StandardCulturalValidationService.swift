import Foundation
import SwiftUI

class StandardCulturalValidationService: CulturalValidationService {
    private let colorValidator: ColorValidationService
    private let elementValidator: ElementValidationService
    private let symbolValidator: SymbolValidationService
    private let layoutValidator: LayoutValidationService
    
    init(
        colorValidator: ColorValidationService = DefaultColorValidationService(),
        elementValidator: ElementValidationService = DefaultElementValidationService(),
        symbolValidator: SymbolValidationService = DefaultSymbolValidationService(),
        layoutValidator: LayoutValidationService = DefaultLayoutValidationService()
    ) {
        self.colorValidator = colorValidator
        self.elementValidator = elementValidator
        self.symbolValidator = symbolValidator
        self.layoutValidator = layoutValidator
    }
    
    func validateElements(_ elements: [CulturalElement], context: String) -> ValidationResult {
        return elementValidator.validate(elements, context: context)
    }
    
    func validateSymbols(_ symbols: [CulturalSymbol], context: String) -> ValidationResult {
        return symbolValidator.validate(symbols, context: context)
    }
    
    func validateColors(_ colors: [Color], context: String) -> ValidationResult {
        return colorValidator.validate(colors, context: context)
    }
    
    func validateLayout(_ layout: LayoutPrinciples, context: String) -> ValidationResult {
        return layoutValidator.validate(layout, context: context)
    }
}

// MARK: - Color Validation
protocol ColorValidationService {
    func validate(_ colors: [Color], context: String) -> ValidationResult
}

class DefaultColorValidationService: ColorValidationService {
    func validate(_ colors: [Color], context: String) -> ValidationResult {
        var issues: [ValidationIssue] = []
        
        if colors.isEmpty {
            issues.append(ValidationIssue(
                id: UUID().uuidString,
                severity: .major,
                category: .color,
                message: "No colors defined",
                elementId: nil,
                recommendation: "Add appropriate colors for the cultural context"
            ))
        }
        
        // Context-specific color validation could be added here
        
        return ValidationResult(
            issues: issues,
            score: calculateScore(issues: issues),
            timestamp: Date(),
            metadata: ["validation_type": "color", "context": context]
        )
    }
    
    private func calculateScore(issues: [ValidationIssue]) -> Double {
        let criticalCount = issues.filter { $0.severity == .critical }.count
        let majorCount = issues.filter { $0.severity == .major }.count
        
        var score = 1.0
        score -= Double(criticalCount) * 0.3
        score -= Double(majorCount) * 0.1
        
        return max(0.0, min(1.0, score))
    }
}

// MARK: - Element Validation
protocol ElementValidationService {
    func validate(_ elements: [CulturalElement], context: String) -> ValidationResult
}

class DefaultElementValidationService: ElementValidationService {
    func validate(_ elements: [CulturalElement], context: String) -> ValidationResult {
        var issues: [ValidationIssue] = []
        
        if elements.isEmpty {
            issues.append(ValidationIssue(
                id: UUID().uuidString,
                severity: .critical,
                category: .cultural,
                message: "No cultural elements defined",
                elementId: nil,
                recommendation: "Add essential cultural elements"
            ))
        }
        
        // Check for essential elements
        let essentialElements = elements.filter { $0.culturalImportance == .essential }
        if essentialElements.isEmpty {
            issues.append(ValidationIssue(
                id: UUID().uuidString,
                severity: .major,
                category: .cultural,
                message: "Missing essential cultural elements",
                elementId: nil,
                recommendation: "Add at least one essential cultural element"
            ))
        }
        
        return ValidationResult(
            issues: issues,
            score: calculateScore(issues: issues),
            timestamp: Date(),
            metadata: ["validation_type": "elements", "context": context]
        )
    }
    
    private func calculateScore(issues: [ValidationIssue]) -> Double {
        let criticalCount = issues.filter { $0.severity == .critical }.count
        let majorCount = issues.filter { $0.severity == .major }.count
        
        var score = 1.0
        score -= Double(criticalCount) * 0.3
        score -= Double(majorCount) * 0.1
        
        return max(0.0, min(1.0, score))
    }
}

// MARK: - Symbol Validation
protocol SymbolValidationService {
    func validate(_ symbols: [CulturalSymbol], context: String) -> ValidationResult
}

class DefaultSymbolValidationService: SymbolValidationService {
    func validate(_ symbols: [CulturalSymbol], context: String) -> ValidationResult {
        var issues: [ValidationIssue] = []
        
        if symbols.isEmpty {
            issues.append(ValidationIssue(
                id: UUID().uuidString,
                severity: .minor,
                category: .symbolism,
                message: "No cultural symbols defined",
                elementId: nil,
                recommendation: "Consider adding cultural symbols to enhance meaning"
            ))
        }
        
        return ValidationResult(
            issues: issues,
            score: calculateScore(issues: issues),
            timestamp: Date(),
            metadata: ["validation_type": "symbols", "context": context]
        )
    }
    
    private func calculateScore(issues: [ValidationIssue]) -> Double {
        let criticalCount = issues.filter { $0.severity == .critical }.count
        let majorCount = issues.filter { $0.severity == .major }.count
        
        var score = 1.0
        score -= Double(criticalCount) * 0.3
        score -= Double(majorCount) * 0.1
        
        return max(0.0, min(1.0, score))
    }
}

// MARK: - Layout Validation
protocol LayoutValidationService {
    func validate(_ layout: LayoutPrinciples, context: String) -> ValidationResult
}

class DefaultLayoutValidationService: LayoutValidationService {
    func validate(_ layout: LayoutPrinciples, context: String) -> ValidationResult {
        var issues: [ValidationIssue] = []
        
        // Add layout-specific validation rules here
        // For example, checking if symmetry is appropriate for the cultural context
        
        return ValidationResult(
            issues: issues,
            score: calculateScore(issues: issues),
            timestamp: Date(),
            metadata: ["validation_type": "layout", "context": context]
        )
    }
    
    private func calculateScore(issues: [ValidationIssue]) -> Double {
        let criticalCount = issues.filter { $0.severity == .critical }.count
        let majorCount = issues.filter { $0.severity == .major }.count
        
        var score = 1.0
        score -= Double(criticalCount) * 0.3
        score -= Double(majorCount) * 0.1
        
        return max(0.0, min(1.0, score))
    }
}
