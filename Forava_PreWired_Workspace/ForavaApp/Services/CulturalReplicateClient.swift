import Foundation

// MARK: - Cultural Replicate API Client
class CulturalReplicateClient {
    static let shared = CulturalReplicateClient()

    private let baseURL = "https://api.replicate.com/v1"

    private init() {}

    func submitPrediction(_ request: ReplicatePredictionRequest, apiKey: String) async throws -> ReplicatePrediction {
        guard let url = URL(string: "\(baseURL)/predictions") else {
            throw CulturalAIServiceError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Token \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(request)

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw CulturalAIServiceError.invalidResponse
        }

        guard 200...299 ~= httpResponse.statusCode else {
            let errorData = String(data: data, encoding: .utf8) ?? "Unknown error"
            print("[CulturalAI Error] Status: \(httpResponse.statusCode), Body: \(errorData)")
            throw CulturalAIServiceError.serverError("HTTP \(httpResponse.statusCode): \(errorData)")
        }

        return try JSONDecoder().decode(ReplicatePrediction.self, from: data)
    }

    func pollPredictionCompletion(
        predictionId: String,
        apiKey: String,
        progressCallback: @escaping (Float) -> Void
    ) async throws -> ReplicatePrediction {
        let maxAttempts = 60
        var attempts = 0

        while attempts < maxAttempts {
            let prediction = try await fetchPrediction(id: predictionId, apiKey: apiKey)

            switch prediction.status {
            case "succeeded":
                return prediction
            case "failed":
                let errorMessage = prediction.error ?? "Unknown error"
                throw CulturalAIServiceError.generationFailed(errorMessage)
            case "canceled":
                throw CulturalAIServiceError.generationCanceled
            default:
                attempts += 1
                progressCallback(Float(attempts) / Float(maxAttempts))
                try await Task.sleep(nanoseconds: 5_000_000_000)
            }
        }

        throw CulturalAIServiceError.timeout
    }

    func downloadImage(from urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw CulturalAIServiceError.invalidURL
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }

    private func fetchPrediction(id: String, apiKey: String) async throws -> ReplicatePrediction {
        guard let url = URL(string: "\(baseURL)/predictions/\(id)") else {
            throw CulturalAIServiceError.invalidURL
        }

        var request = URLRequest(url: url)
        request.setValue("Token \(apiKey)", forHTTPHeaderField: "Authorization")

        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(ReplicatePrediction.self, from: data)
    }
}
