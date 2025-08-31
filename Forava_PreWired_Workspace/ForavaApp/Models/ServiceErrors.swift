enum AIServiceError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case serverError(String)
    case generationFailed(String)
    case generationCanceled
    case timeout
    case noImageGenerated
    case networkError(Error)
    case unauthorized
    case configurationError
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL provided"
        case .invalidResponse:
            return "Invalid response from server"
        case .invalidData:
            return "Invalid data received"
        case .serverError(let message):
            return "Server error: \(message)"
        case .generationFailed(let reason):
            return "Image generation failed: \(reason)"
        case .generationCanceled:
            return "Image generation was canceled"
        case .timeout:
            return "Operation timed out"
        case .noImageGenerated:
            return "No image was generated"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .unauthorized:
            return "Unauthorized access"
        case .configurationError:
            return "Service configuration error"
        }
    }
}

enum CulturalAIServiceError: Error {
    case invalidConfiguration
    case processingError(String)
    case invalidInput(String)
    case networkError(Error)
    case serverError(String)
    case unsupportedCulture(String)
    case invalidContext
    case timeout
    
    var localizedDescription: String {
        switch self {
        case .invalidConfiguration:
            return "Invalid service configuration"
        case .processingError(let message):
            return "Processing error: \(message)"
        case .invalidInput(let detail):
            return "Invalid input: \(detail)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .serverError(let message):
            return "Server error: \(message)"
        case .unsupportedCulture(let culture):
            return "Unsupported cultural context: \(culture)"
        case .invalidContext:
            return "Invalid cultural context"
        case .timeout:
            return "Operation timed out"
        }
    }
}
