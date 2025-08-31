import Foundation

// MARK: - Replicate API Integration Extensions
extension AIRakhiService {

    internal func generateImage(prompt: AIPrompt, loraModels: [String] = []) async throws -> AIImageResult {
        guard !replicateAPIKey.isEmpty else {
            print("[AIRakhiService] No API key - using mock generation")
            return try await generateMockImage(prompt: prompt)
        }

        print("[AIRakhiService] Generating image with Replicate API...")
        return try await generateWithReplicate(prompt: prompt, useCulturalModel: true)
    }

    private func generateWithReplicate(prompt: AIPrompt, useCulturalModel: Bool = true) async throws -> AIImageResult {
        let model = useCulturalModel ? culturalModel : defaultModel

        // Build culturally-aware prompts
        let (culturalPositive, culturalNegative) = buildCulturalRakhiPrompt(from: prompt)

        let request = ReplicatePredictionRequest(
            version: model,
            input: ReplicateInput(
                prompt: culturalPositive,
                negativePrompt: culturalNegative,
                width: 1024,
                height: 1024,
                numInferenceSteps: prompt.steps,
                guidanceScale: prompt.cfgScale,
                seed: prompt.seed == -1 ? nil : prompt.seed,
                numOutputs: 1,
                scheduler: "DPMSolverMultistep"
            )
        )

        print("[Replicate] Submitting prediction with model: \(model)")
        let prediction = try await submitReplicatePrediction(request: request)
        print("[Replicate] Prediction submitted with ID: \(prediction.id)")

        generationProgress = 0.5
        let completedPrediction = try await pollReplicatePredictionCompletion(predictionId: prediction.id)
        print("[Replicate] Prediction completed")

        generationProgress = 0.7
        guard let outputURL = completedPrediction.output?.first else {
            throw AIServiceError.noImageGenerated
        }

        let imageData = try await downloadImage(from: outputURL)
        print("[Replicate] Downloaded image data: \(imageData.count) bytes")

        return AIImageResult(
            imageData: imageData,
            width: 1024,
            height: 1024,
            format: "png",
            qualityScore: 0.95,
            seed: completedPrediction.input.seed ?? -1,
            model: model
        )
    }

    private func buildCulturalRakhiPrompt(from prompt: AIPrompt) -> (positive: String, negative: String) {
        // Enhance the prompt with cultural context and Rakhi-specific details
        var enhancedPositive = prompt.positive

        // Add strong Rakhi-specific elements at the beginning for maximum impact
        let rakhiPrefix = "Indian rakhi bracelet, traditional Hindu festival thread, sacred brother-sister bond symbol, "
        enhancedPositive = rakhiPrefix + enhancedPositive

        // Add cultural styling cues
        enhancedPositive += ", Raksha Bandhan festival, Indian cultural heritage, handcrafted traditional art"
        enhancedPositive += ", centered composition, isolated on clean background"

        // Enhanced negative prompt with Rakhi-specific exclusions
        var enhancedNegative = prompt.negative
        enhancedNegative += ", not a necklace, not a ring, not jewelry, not a bracelet for wrist"
        enhancedNegative += ", no hands, no people, no faces, no body parts, no multiple rakhis"
        enhancedNegative += ", not western, not Christmas, not Halloween, no inappropriate symbols"

        return (enhancedPositive, enhancedNegative)
    }

    private func submitReplicatePrediction(request: ReplicatePredictionRequest) async throws -> ReplicatePrediction {
        guard let url = URL(string: "\(replicateBaseURL)/predictions") else {
            throw AIServiceError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Token \(replicateAPIKey)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(request)

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw AIServiceError.invalidResponse
        }

        guard 200...299 ~= httpResponse.statusCode else {
            let errorData = String(data: data, encoding: .utf8) ?? "Unknown error"
            print("[Replicate Error] Status: \(httpResponse.statusCode), Body: \(errorData)")
            throw AIServiceError.serverError("HTTP \(httpResponse.statusCode): \(errorData)")
        }

        return try JSONDecoder().decode(ReplicatePrediction.self, from: data)
    }

    private func pollReplicatePredictionCompletion(predictionId: String) async throws -> ReplicatePrediction {
        let maxAttempts = 60 // 5 minutes max wait time
        var attempts = 0

        while attempts < maxAttempts {
            let prediction = try await fetchReplicatePrediction(id: predictionId)

            switch prediction.status {
            case "succeeded":
                return prediction
            case "failed":
                let errorMessage = prediction.error ?? "Unknown error"
                throw AIServiceError.generationFailed(errorMessage)
            case "canceled":
                throw AIServiceError.generationCanceled
            default:
                // Still processing
                attempts += 1
                generationProgress = 0.5 + (Float(attempts) / Float(maxAttempts) * 0.2)
                try await Task.sleep(nanoseconds: 5_000_000_000) // 5 seconds
            }
        }

        throw AIServiceError.timeout
    }

    private func fetchReplicatePrediction(id: String) async throws -> ReplicatePrediction {
        guard let url = URL(string: "\(replicateBaseURL)/predictions/\(id)") else {
            throw AIServiceError.invalidURL
        }

        var request = URLRequest(url: url)
        request.setValue("Token \(replicateAPIKey)", forHTTPHeaderField: "Authorization")

        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(ReplicatePrediction.self, from: data)
    }

    private func downloadImage(from urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw AIServiceError.invalidURL
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}
