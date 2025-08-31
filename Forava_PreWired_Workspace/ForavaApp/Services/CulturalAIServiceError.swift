import Foundation

// MARK: - Cultural AI Service Errors
enum CulturalAIServiceError: LocalizedError {
    case alreadyGenerating
    case invalidCulturalContext(String)
    case invalidDesignSpec(String)
    case legacyConversionFailed
    case noImageGenerated
    case generationFailed(String)
    case generationCanceled
    case timeout
    case invalidURL
    case invalidResponse
    case serverError(String)
    case unknownError(String)

    var errorDescription: String? {
        switch self {
        case .alreadyGenerating:
            return "Generation already in progress"
        case .invalidCulturalContext(let context):
            return "Invalid cultural context: \(context)"
        case .invalidDesignSpec(let reason):
            return "Invalid design specification: \(reason)"
        case .legacyConversionFailed:
            return "Failed to convert legacy specification to cultural format"
        case .noImageGenerated:
            return "No image was generated"
        case .generationFailed(let error):
            return "Generation failed: \(error)"
        case .generationCanceled:
            return "Generation was canceled"
        case .timeout:
            return "Generation timed out"
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .serverError(let error):
            return "Server error: \(error)"
        case .unknownError(let error):
            return "Unknown error: \(error)"
        }
    }
}
