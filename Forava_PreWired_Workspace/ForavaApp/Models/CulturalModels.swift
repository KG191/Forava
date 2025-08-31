import Foundation

struct CulturalGift: Codable {
    let id: String
    let name: String
    let description: String
    let price: Decimal
    let imageUrl: String
    let culturalContext: String
}

struct CulturalPromptSet: Codable {
    let id: String
    let prompts: [String]
    let context: String
}

struct LoRAModel: Codable {
    let id: String
    let name: String
    let version: String
    let path: String
}

struct AdvancedPrompt: Codable {
    let text: String
    let weight: Float
    let category: String
}

struct WeightedPrompt: Codable {
    let prompt: String
    let weight: Float
}

struct DebugPromptInfo: Codable {
    let originalPrompt: String
    let modifiedPrompt: String
    let modifications: [String]
}

struct TechnicalParameters: Codable {
    let cfgScale: Float
    let steps: Int
    let seed: Int?
    let width: Int
    let height: Int
}

struct AnimationMemoryInfo: Codable {
    let allocated: Int64
    let used: Int64
    let peak: Int64
}

enum AnimationQuality {
    case minimal
    case standard
    case high
}

struct WatchRakhiDisplay: Identifiable, Codable {
    let id: String
    let title: String
    let imageData: Data
    let displayMetadata: DisplayMetadata
    let timestamp: Date
    let watchOptimized: Bool
    let culturalScore: Double
    let colors: [Color]
    
    struct DisplayMetadata: Codable {
        let designStyle: String
        let animationPreset: String
        let complications: [String]
        let displayMode: DisplayMode
        
        enum DisplayMode: String, Codable {
            case standard
            case animated
            case interactive
        }
    }
    
    init(id: String = UUID().uuidString,
         title: String,
         imageData: Data,
         culturalScore: Double,
         colors: [Color] = [],
         timestamp: Date = Date(),
         displayMetadata: DisplayMetadata,
         watchOptimized: Bool = true) {
        self.id = id
        self.title = title
        self.imageData = imageData
        self.culturalScore = culturalScore
        self.colors = colors
        self.timestamp = timestamp
        self.displayMetadata = displayMetadata
        self.watchOptimized = watchOptimized
    }
}
