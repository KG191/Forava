import Foundation

// MARK: - Cultural Validator
class CulturalValidator {
    static let shared = CulturalValidator()

    private let inappropriateElements: Set<String> = [
        // Add any culturally inappropriate element IDs here
        // This would be populated based on cultural expert consultation
    ]

    private let sensitiveElements: Set<String> = [
        // No sensitive elements currently defined
    ]

    private init() {}

    func isInappropriate(_ element: DesignElement) -> Bool {
        return inappropriateElements.contains(element.id)
    }

    func isSensitive(_ element: DesignElement) -> Bool {
        return sensitiveElements.contains(element.id)
    }

    func validateDesignSpec(_ spec: RakhiDesignSpec) -> CulturalValidationResult {
        var warnings: [String] = []
        var errors: [String] = []

        for element in spec.elements {
            if isInappropriate(element) {
                errors.append("Element '\(element.displayName)' is culturally inappropriate")
            } else if isSensitive(element) {
                warnings.append("Element '\(element.displayName)' requires cultural sensitivity")
            }
        }

        // Check age appropriateness
        let ageInappropriate = spec.elements.filter { element in
            !element.ageAppropriate.contains(spec.targetAgeGroup) &&
            !element.ageAppropriate.contains(.any)
        }

        for element in ageInappropriate {
            warnings.append("Element '\(element.displayName)' may not be age-appropriate for \(spec.targetAgeGroup.rawValue)")
        }

        return CulturalValidationResult(
            isValid: errors.isEmpty,
            warnings: warnings,
            errors: errors,
            culturalScore: calculateCulturalScore(spec)
        )
    }

    private func calculateCulturalScore(_ spec: RakhiDesignSpec) -> Double {
        let genreScore = spec.genre.culturalWeight
        let elementScores = spec.elements.map { $0.culturalSignificance }
        let avgElementScore = elementScores.isEmpty ? 0.5 : elementScores.reduce(0, +) / Double(elementScores.count)

        return (genreScore * 0.3) + (avgElementScore * 0.7)
    }
}

// NOTE: CulturalValidationResult is now defined in CulturalDesignAgentService.swift
// This file uses that authoritative definition
