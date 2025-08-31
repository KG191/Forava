import Foundation
import SwiftUI

// MARK: - Enhanced Payment Intelligence Service

@MainActor
class EnhancedPaymentService: ObservableObject {
    static let shared = EnhancedPaymentService()

    @Published var suggestedPaymentOptions: [PaymentOption] = []
    @Published var culturalContext: CulturalPaymentContext?
    @Published var isAnalyzing = false

    private init() {}

    // MARK: - Public Interface

    func analyzeCulturalPaymentContext(
        designSpec: RakhiDesignSpec,
        recipient: Contact,
        relationship: RelationshipType
    ) async -> CulturalPaymentContext {
        isAnalyzing = true
        defer { isAnalyzing = false }

        // Analyze design complexity
        let complexityScore = calculateDesignComplexity(designSpec)

        // Determine relationship-based amounts
        let baseAmounts = getBaseAmounts(for: relationship)

        // Apply cultural multipliers
        let culturalMultiplier = calculateCulturalMultiplier(designSpec)

        // Calculate auspicious amounts
        let ausauspiciousAmounts = baseAmounts.map { amount in
            let adjusted = Double(amount) * culturalMultiplier
            return roundToAuspiciousAmount(adjusted)
        }

        // Generate payment options with cultural context
        let paymentOptions = generatePaymentOptions(
            amounts: ausauspiciousAmounts,
            relationship: relationship,
            culturalScore: designSpec.elements.map { $0.culturalSignificance }.reduce(0, +) / Double(designSpec.elements.count)
        )

        let context = CulturalPaymentContext(
            recommendedAmount: ausauspiciousAmounts.first ?? 51,
            alternativeAmounts: Array(ausauspiciousAmounts.dropFirst()),
            paymentOptions: paymentOptions,
            culturalSignificance: getCulturalSignificance(for: ausauspiciousAmounts.first ?? 51),
            relationshipContext: relationship,
            complexityJustification: getComplexityJustification(complexityScore)
        )

        self.culturalContext = context
        self.suggestedPaymentOptions = paymentOptions

        return context
    }

    // MARK: - Private Implementation

    private func calculateDesignComplexity(_ spec: RakhiDesignSpec) -> Double {
        var complexity = 0.0

        // Base complexity from genre
        complexity += spec.genre.complexityWeight

        // Element complexity
        complexity += Double(spec.elements.count) * 0.1

        // Cultural significance complexity
        let culturalComplexity = spec.elements.map { $0.culturalSignificance }.reduce(0, +)
        complexity += culturalComplexity * 0.2

        // Personalization complexity
        if spec.personalMessage != nil {
            complexity += 0.15
        }

        return min(complexity, 1.0)
    }

    private func getBaseAmounts(for relationship: RelationshipType) -> [Int] {
        switch relationship {
        case .brother:
            return [51, 101, 201, 501]
        case .sister:
            return [31, 51, 101, 251]
        case .cousin:
            return [21, 51, 101, 201]
        case .friend:
            return [11, 21, 51, 101]
        case .elder:
            return [101, 201, 501, 1001]
        case .younger:
            return [21, 51, 101, 201]
        }
    }

    private func calculateCulturalMultiplier(_ spec: RakhiDesignSpec) -> Double {
        var multiplier = 1.0

        // Genre-based multiplier
        switch spec.genre {
        case .traditional:
            multiplier += 0.2
        case .spiritual:
            multiplier += 0.3
        case .elegant:
            multiplier += 0.15
        case .modern:
            multiplier += 0.05
        case .unknown:
            break
        }

        // Element-based multiplier
        let hasHighCulturalElements = spec.elements.contains { $0.culturalSignificance > 0.8 }
        if hasHighCulturalElements {
            multiplier += 0.1
        }

        return multiplier
    }

    private func roundToAuspiciousAmount(_ amount: Double) -> Int {
        let rounded = Int(amount)

        // Ensure it ends in 1 (auspicious in Indian culture)
        let lastDigit = rounded % 10
        let adjustment = (11 - lastDigit) % 10

        return rounded + adjustment
    }

    private func generatePaymentOptions(
        amounts: [Int],
        relationship: RelationshipType,
        culturalScore: Double
    ) -> [PaymentOption] {
        return amounts.enumerated().map { index, amount in
            PaymentOption(
                amount: amount,
                priority: index == 0 ? .primary : (index == 1 ? .secondary : .alternative),
                culturalJustification: getCulturalJustification(amount, relationship: relationship),
                benefits: getBenefits(for: amount, relationship: relationship),
                icon: getPaymentIcon(for: amount)
            )
        }
    }

    private func getCulturalJustification(_ amount: Int, relationship: RelationshipType) -> String {
        switch amount {
        case 11, 21, 31:
            return "Traditional starter amount with divine blessings"
        case 51:
            return "Classic auspicious amount, perfect for \(relationship.displayName.lowercased())"
        case 101:
            return "Premium blessing amount with extra spiritual significance"
        case 201, 251:
            return "Generous amount showing deep affection and respect"
        case 501, 1001:
            return "Grand gesture amount for special relationships"
        default:
            return "Auspicious amount ending in 1 for divine blessings"
        }
    }

    private func getBenefits(for amount: Int, relationship: RelationshipType) -> [String] {
        var benefits: [String] = []

        if amount >= 51 {
            benefits.append("Includes personalized message")
        }

        if amount >= 101 {
            benefits.append("Premium animation effects")
            benefits.append("High-quality image generation")
        }

        if amount >= 201 {
            benefits.append("Multiple animation styles")
            benefits.append("Extended watch face duration")
        }

        if amount >= 501 {
            benefits.append("Exclusive cultural elements")
            benefits.append("Priority processing")
            benefits.append("Lifetime keepsake storage")
        }

        return benefits
    }

    private func getPaymentIcon(for amount: Int) -> String {
        switch amount {
        case ..<50:
            return "heart.circle.fill"
        case 50..<100:
            return "star.circle.fill"
        case 100..<300:
            return "crown.fill"
        default:
            return "sparkles"
        }
    }

    private func getCulturalSignificance(for amount: Int) -> String {
        switch amount {
        case 11:
            return "11 represents new beginnings and divine blessings in Hindu tradition"
        case 21:
            return "21 signifies completeness and prosperity for the recipient"
        case 51:
            return "51 is considered highly auspicious, representing the 51 Shakti Peethas"
        case 101:
            return "101 symbolizes the addition of one more blessing beyond completion (100)"
        case 201:
            return "201 represents doubled blessings and exceptional care"
        case 501:
            return "501 signifies grand gestures and deep spiritual connection"
        case 1001:
            return "1001 represents infinite blessings and eternal bond"
        default:
            return "Amount ending in 1 ensures divine blessings and good fortune"
        }
    }

    private func getComplexityJustification(_ complexity: Double) -> String {
        switch complexity {
        case 0.0..<0.3:
            return "Simple design with focused cultural elements"
        case 0.3..<0.6:
            return "Moderate complexity with multiple cultural elements"
        case 0.6..<0.8:
            return "Rich design with high cultural authenticity"
        default:
            return "Premium design with maximum cultural significance"
        }
    }
}

// MARK: - Supporting Types

// CulturalPaymentContext moved to PaymentModels.swift to avoid duplication

struct PaymentOption: Identifiable {
    let id = UUID()
    let amount: Int
    let priority: PaymentPriority
    let culturalJustification: String
    let benefits: [String]
    let icon: String
}

enum PaymentPriority {
    case primary
    case secondary
    case alternative

    var displayName: String {
        switch self {
        case .primary: return "Recommended"
        case .secondary: return "Popular Choice"
        case .alternative: return "Alternative"
        }
    }

    var color: Color {
        switch self {
        case .primary: return .orange
        case .secondary: return .blue
        case .alternative: return .gray
        }
    }
}

enum RelationshipType: String, CaseIterable {
    case brother = "Brother"
    case sister = "Sister"
    case cousin = "Cousin"
    case friend = "Friend"
    case elder = "Elder"
    case younger = "Younger"

    var displayName: String { self.rawValue }

    static func detectFrom(contact: Contact) -> RelationshipType {
        // Simple heuristic - in production this could use ML or user input
        let name = contact.name.lowercased()

        if name.contains("bro") || ["raj", "dev", "amit", "rohan", "kiran", "arjun"].contains(where: name.contains) {
            return .brother
        } else if name.contains("sis") || ["priya", "shreya", "anaya", "kavya", "diya"].contains(where: name.contains) {
            return .sister
        } else {
            return .friend
        }
    }
}

extension RakhiGenre {
    var complexityWeight: Double {
        switch self {
        case .traditional: return 0.4
        case .spiritual: return 0.5
        case .elegant: return 0.3
        case .modern: return 0.2
        case .unknown: return 0.1
        }
    }
}
