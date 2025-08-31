import Foundation

struct CulturalElement: Codable, Identifiable {
    var id: String { name }
    let name: String
    let significance: String
    let visualDescription: String
    let culturalImportance: CulturalImportance
    
    enum CulturalImportance: String, Codable {
        case essential
        case important
        case optional
        
        var priority: Int {
            switch self {
            case .essential: return 0
            case .important: return 1
            case .optional: return 2
            }
        }
        
        var description: String {
            switch self {
            case .essential: return "Must be included in the design"
            case .important: return "Strongly recommended for cultural authenticity"
            case .optional: return "Can enhance the design but not required"
            }
        }
    }
}
