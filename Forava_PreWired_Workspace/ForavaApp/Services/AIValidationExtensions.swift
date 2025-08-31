import Foundation

// MARK: - AI Validation Extensions
extension AIRakhiService {

    // MARK: - Validation Methods

    internal func validateDesignSpec(_ spec: RakhiDesignSpec) throws {
        guard spec.genre != .unknown else {
            throw AIServiceError.invalidDesignSpec("Genre must be specified")
        }

        guard !spec.elements.isEmpty else {
            throw AIServiceError.invalidDesignSpec("At least one design element must be selected")
        }

        try validateCulturalElements(spec.elements)
    }

    private func validateCulturalElements(_ elements: [DesignElement]) throws {
        for element in elements {
            if element.culturalSignificance > 0.95 {
                // High cultural significance - validate appropriateness
                let validator = CulturalValidator.shared
                if validator.isInappropriate(element) {
                    throw AIServiceError.culturallyInappropriate("Element '\(element.displayName)' is not culturally appropriate")
                }
            }
        }
    }
}
