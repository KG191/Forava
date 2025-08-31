import Foundation

// MARK: - Generation Metadata
struct GenerationMetadata: Codable {
    let seed: Int
    let cfgScale: Float
    let steps: Int
    let model: String
    let timestamp: Date
    let extraParams: [String: String]?
    
    init(seed: Int = -1,
         cfgScale: Float = 7.5,
         steps: Int = 30,
         model: String,
         timestamp: Date = Date(),
         extraParams: [String: String]? = nil) {
        self.seed = seed
        self.cfgScale = cfgScale
        self.steps = steps
        self.model = model
        self.timestamp = timestamp
        self.extraParams = extraParams
    }

    // Compatibility initializer accepting snake_case parameter names used in some previews/tests
    init(seed: Int = -1,
         cfg_scale: Float = 7.5,
         steps: Int = 30,
         model: String,
         timestamp: Date = Date(),
         extra_params: [String: String]? = nil) {
        self.init(seed: seed,
                  cfgScale: cfg_scale,
                  steps: steps,
                  model: model,
                  timestamp: timestamp,
                  extraParams: extra_params)
    }
}

struct CulturalGenerationMetadata: Codable {
    let baseMetadata: GenerationMetadata
    let culturalContext: String
    let promptWeights: [String: Float]
    let loraModels: [String]
    
    init(baseMetadata: GenerationMetadata,
         culturalContext: String,
         promptWeights: [String: Float],
         loraModels: [String] = []) {
        self.baseMetadata = baseMetadata
        self.culturalContext = culturalContext
        self.promptWeights = promptWeights
        self.loraModels = loraModels
    }
}

// MARK: - Watch Transfer Models
struct WatchToiPhoneTransfer: Codable {
    let id: String
    let timestamp: Date
    let transferType: TransferType
    let data: Data
    let metadata: [String: String]
    
    enum TransferType: String, Codable {
        case rakhi
        case payment
        case animation
        case other
    }
}

// Moved to CulturalModels.swift to avoid duplication

// MARK: - Technical Parameters
// Use the canonical `TechnicalParameters` definition in `CulturalModels.swift`
typealias TechnicalParameters = ForavaApp.TechnicalParameters

// MARK: - Cultural Models
// Use canonical cultural model types defined in `CulturalModels.swift` to avoid duplicates.
typealias CulturalPromptSet = ForavaApp.CulturalPromptSet
typealias LoRAModel = ForavaApp.LoRAModel
typealias WeightedPrompt = ForavaApp.WeightedPrompt
typealias DebugPromptInfo = ForavaApp.DebugPromptInfo
