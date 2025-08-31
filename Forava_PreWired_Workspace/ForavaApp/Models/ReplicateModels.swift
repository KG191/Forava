import Foundation

struct ReplicateInput: Codable {
    let prompt: String
    let negativePrompt: String?
    let width: Int
    let height: Int
    let numInferenceSteps: Int
    let guidanceScale: Float
    let seed: Int?
    let numOutputs: Int
    let scheduler: String
    
    enum CodingKeys: String, CodingKey {
        case prompt
        case negativePrompt = "negative_prompt"
        case width
        case height
        case numInferenceSteps = "num_inference_steps"
        case guidanceScale = "guidance_scale"
        case seed
        case numOutputs = "num_outputs"
        case scheduler
    }
}

struct ReplicatePredictionRequest: Codable {
    let version: String
    let input: ReplicateInput
}

struct ReplicatePrediction: Codable {
    let id: String
    let version: String
    let status: String
    let input: ReplicateInput
    let output: [String]?
    let error: String?
    let logs: String?
    let metrics: ReplicateMetrics?
    
    enum CodingKeys: String, CodingKey {
        case id, version, status, input, output, error, logs, metrics
    }
}

struct ReplicateMetrics: Codable {
    let predictTime: Double
    
    enum CodingKeys: String, CodingKey {
        case predictTime = "predict_time"
    }
}
