import Foundation

// MARK: - Validation Issue Types
struct ValidationIssue: Identifiable {
    let id = UUID()
    let severity: IssueSeverity
    let description: String
    let category: ValidationCategory
    let location: String?
    let suggestedFix: String?
    
    enum IssueSeverity: String {
        case critical = "Critical"
        case major = "Major"
        case minor = "Minor"
        case info = "Info"
        
        var icon: String {
            switch self {
            case .critical: return "exclamationmark.triangle.fill"
            case .major: return "exclamationmark.circle.fill"
            case .minor: return "exclamationmark.circle"
            case .info: return "info.circle"
            }
        }
        
        var color: String {
            switch self {
            case .critical: return "red"
            case .major: return "orange"
            case .minor: return "yellow"
            case .info: return "blue"
            }
        }
    }
}

// MARK: - Cultural Validation
typealias CulturalValidationIssue = ValidationIssue

extension String {
    static let culturalAccuracy = "Cultural Accuracy"
    static let contextMismatch = "Context Mismatch"
}

enum ValidationCategory: String {
    case culturalAccuracy = "Cultural Accuracy"
    case contextMismatch = "Context Mismatch"
    case technicalIssue = "Technical Issue"
    case designGuidelines = "Design Guidelines"
    case accessibility = "Accessibility"
    case localization = "Localization"
}

struct ValidationResult {
    let issues: [ValidationIssue]
    let score: Double
    let timestamp: Date
    let metadata: [String: Any]
    
    init(
        issues: [ValidationIssue] = [],
        score: Double = 1.0,
        timestamp: Date = Date(),
        metadata: [String: Any] = [:]
    ) {
        self.issues = issues
        self.score = score
        self.timestamp = timestamp
        self.metadata = metadata
    }
}
