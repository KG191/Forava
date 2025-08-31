import Foundation

protocol CulturalValidationService {
    func validateElements(_ elements: [CulturalElement], context: String) -> ValidationResult
    func validateSymbols(_ symbols: [CulturalSymbol], context: String) -> ValidationResult
    func validateColors(_ colors: [Color], context: String) -> ValidationResult
    func validateLayout(_ layout: LayoutPrinciples, context: String) -> ValidationResult
}

protocol CulturalTransformationService {
    func transformDesign(_ design: CulturalDesignSpec, targetCulture: String) -> CulturalDesignSpec
    func validateTransformation(_ original: CulturalDesignSpec, transformed: CulturalDesignSpec) -> ValidationResult
}

protocol CulturalMessageGenerator {
    func generateMessage(for relationship: String, culture: String, occasion: String) -> String
    func validateMessage(_ message: String, culture: String) -> ValidationResult
}

// Default implementation for common validation logic
extension CulturalValidationService {
    func validateBasicRequirements(_ design: CulturalDesignSpec) -> ValidationResult {
        var issues: [ValidationIssue] = []
        
        // Check for empty elements
        if design.elements.isEmpty {
            issues.append(ValidationIssue(
                id: UUID().uuidString,
                severity: .critical,
                category: .cultural,
                message: "No cultural elements provided",
                elementId: nil,
                recommendation: "Add at least one essential cultural element"
            ))
        }
        
        // Check for empty colors
        if design.primaryColors.isEmpty && design.secondaryColors.isEmpty {
            issues.append(ValidationIssue(
                id: UUID().uuidString,
                severity: .major,
                category: .design,
                message: "No colors defined in the design",
                elementId: nil,
                recommendation: "Add primary and/or secondary colors"
            ))
        }
        
        let score = calculateBasicScore(issues: issues)
        
        return ValidationResult(
            issues: issues,
            score: score,
            timestamp: Date(),
            metadata: ["validation_type": "basic_requirements"]
        )
    }
    
    private func calculateBasicScore(issues: [ValidationIssue]) -> Double {
        let criticalCount = issues.filter { $0.severity == .critical }.count
        let majorCount = issues.filter { $0.severity == .major }.count
        
        var score = 1.0
        score -= Double(criticalCount) * 0.3
        score -= Double(majorCount) * 0.1
        
        return max(0.0, min(1.0, score))
    }
}
