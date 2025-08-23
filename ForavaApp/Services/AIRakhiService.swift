import Foundation
import SwiftUI
import Combine

// MARK: - AI Rakhi Generation Service
@MainActor
class AIRakhiService: ObservableObject {
    static let shared = AIRakhiService()
    
    @Published var isGenerating = false
    @Published var generationProgress: Float = 0.0
    @Published var generatedRakhi: GeneratedRakhi?
    @Published var error: AIServiceError?
    
    // Removed old endpoints - using Replicate API exclusively
    // private let baseURL = "https://api.forava.ai/v1" // Production endpoint (deprecated)
    // private let fallbackURL = "http://localhost:8000" // Local development (deprecated)
    
    // Replicate API configuration
    private let replicateBaseURL = "https://api.replicate.com/v1"
    private let replicateAPIKey: String
    private let culturalModel = "stability-ai/sdxl:39ed52f2a78e934b3ba6e2a89f5b1c712de7dfea535525255b1aa35c5565e08b"
    private let defaultModel = "stability-ai/sdxl:39ed52f2a78e934b3ba6e2a89f5b1c712de7dfea535525255b1aa35c5565e08b"
    
    // Demo mode - when true, uses mock generation instead of real API
    private let useMockGeneration = false
    
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        // Load Replicate API key - iOS app sandbox compatible approach
        print("🔑 Loading Replicate API key...")
        
        // Method 1: Try environment variable first (set in Xcode scheme)
        if let envVar = ProcessInfo.processInfo.environment["REPLICATE_API_TOKEN"] {
            self.replicateAPIKey = envVar
            print("✅ API key loaded from environment variable")
            return
        }
        
        // Method 2: Try app bundle .env file (if added to Xcode project)
        if let envPath = Bundle.main.path(forResource: ".env", ofType: nil) {
            print("📁 Found .env in bundle at: \(envPath)")
            do {
                let envContent = try String(contentsOfFile: envPath)
                if let apiKeyLine = envContent.components(separatedBy: .newlines).first(where: { $0.hasPrefix("Replicate_API:") }) {
                    let apiKey = String(apiKeyLine.dropFirst("Replicate_API:".count).trimmingCharacters(in: .whitespaces))
                    if !apiKey.isEmpty {
                        self.replicateAPIKey = apiKey
                        print("✅ API key loaded from app bundle")
                        return
                    }
                }
            } catch {
                print("❌ Failed to read bundle .env file: \(error)")
            }
        }
        
        // Method 3: Environment variable for development
        // TODO: Set REPLICATE_API_TOKEN in environment variables
        if let envKey = ProcessInfo.processInfo.environment["REPLICATE_API_TOKEN"], !envKey.isEmpty {
            self.replicateAPIKey = envKey
            print("✅ API key loaded from environment variable")
        } else {
            print("⚠️ REPLICATE_API_TOKEN environment variable not set")
            print("Please add your API key to environment variables for security")
            self.replicateAPIKey = "YOUR_REPLICATE_API_TOKEN_HERE"
        }
    }
    
    // MARK: - Public Interface
    
    /// Clears any previously generated Rakhi to start a fresh design session
    func clearGeneratedRakhi() {
        generatedRakhi = nil
        error = nil
        generationProgress = 0.0
        print("🧹 Cleared previous generated Rakhi for new design session")
    }
    
    func generateRakhi(from designSpec: RakhiDesignSpec) async throws -> GeneratedRakhi {
        isGenerating = true
        generationProgress = 0.0
        error = nil
        
        defer {
            Task { @MainActor in
                isGenerating = false
                generationProgress = 0.0
            }
        }
        
        do {
            // Step 1: Validate design specification
            try validateDesignSpec(designSpec)
            await updateProgress(0.1)
            
            // Step 2: Build advanced AI prompt with LoRA integration
            let promptMapper = PromptMapper.shared
            let advancedPrompt = await promptMapper.buildAdvancedPrompt(from: designSpec)
            
            let prompt = AIPrompt(
                positive: advancedPrompt.positive,
                negative: advancedPrompt.negative,
                cfg_scale: advancedPrompt.technicalParameters.cfg_scale,
                steps: advancedPrompt.technicalParameters.steps,
                seed: Int.random(in: 0...2147483647),
                width: 1024,
                height: 1024
            )
            await updateProgress(0.2)
            
            // Step 3: Generate image using SDXL pipeline with LoRA models
            let imageResult = try await generateImage(prompt: prompt, loraModels: advancedPrompt.loraModels)
            await updateProgress(0.7)
            
            // Step 4: Create animation frames if needed
            let animationFrames = try await generateAnimationFrames(for: imageResult)
            await updateProgress(0.9)
            
            // Step 5: Package final result
            let generatedRakhi = GeneratedRakhi(
                id: UUID(),
                designSpec: designSpec,
                mainImage: imageResult,
                animationFrames: animationFrames,
                prompt: prompt,
                createdAt: Date(),
                culturalScore: calculateCulturalScore(designSpec),
                qualityScore: await assessQuality(imageResult)
            )
            
            await updateProgress(1.0)
            self.generatedRakhi = generatedRakhi
            
            return generatedRakhi
            
        } catch {
            self.error = AIServiceError.from(error)
            throw error
        }
    }
    
    // MARK: - Private Implementation
    private func validateDesignSpec(_ spec: RakhiDesignSpec) throws {
        guard !spec.elements.isEmpty else {
            throw AIServiceError.invalidDesignSpec("No design elements specified")
        }
        
        guard spec.genre != .unknown else {
            throw AIServiceError.invalidDesignSpec("Genre must be specified")
        }
        
        // Validate cultural appropriateness
        try validateCulturalElements(spec.elements)
    }
    
    private func validateCulturalElements(_ elements: [DesignElement]) throws {
        // Cultural validation using predefined rules
        let inappropriateElements = elements.filter { element in
            // Check against cultural inappropriateness database
            CulturalValidator.shared.isInappropriate(element)
        }
        
        if !inappropriateElements.isEmpty {
            throw AIServiceError.culturallyInappropriate(inappropriateElements.map(\.id))
        }
    }
    
    private func buildPromptOld(from spec: RakhiDesignSpec) async throws -> AIPrompt {
        let _ = PromptBuilder()
        
        // Base prompt for Rakhi generation
        var prompt = "beautiful traditional Indian rakhi, intricate design, high quality, detailed, "
        
        // Add genre-specific prompts
        prompt += spec.genre.basePrompt + ", "
        
        // Add element-specific prompts with weights
        for element in spec.elements {
            let elementPrompts = await PromptMapper.shared.getPrompts(for: element.id)
            let weightedPrompt = elementPrompts.map { "(\($0):\(element.weight))" }.joined(separator: ", ")
            prompt += weightedPrompt + ", "
        }
        
        // Add technical parameters
        prompt += "masterpiece, best quality, ultra detailed, 8k resolution, professional photography"
        
        // Build negative prompt
        let negativePrompt = "blurry, low quality, distorted, inappropriate, western symbols, cross, "
        
        return AIPrompt(
            positive: prompt,
            negative: negativePrompt,
            cfg_scale: 7.5,
            steps: 30,
            seed: Int.random(in: 0...2147483647),
            width: 1024,
            height: 1024
        )
    }
    
    private func generateImage(prompt: AIPrompt, loraModels: [String] = []) async throws -> AIImageResult {
        // Use mock generation for demo purposes
        if useMockGeneration {
            return try await generateMockImage(prompt: prompt)
        }
        
        // Use Replicate API exclusively for real generation
        print("🎯 Starting image generation with Replicate API...")
        print("🔑 API Key status: \(replicateAPIKey.isEmpty ? "❌ Empty" : "✅ Available")")
        
        guard !replicateAPIKey.isEmpty else {
            throw AIServiceError.invalidDesignSpec("Replicate API key not configured. Please check your .env file.")
        }
        
        // Progress tracking: Starting API call
        await updateProgress(0.3)
        
        do {
            let result = try await generateWithReplicate(prompt: prompt, useCulturalModel: true)
            
            // Progress tracking: Image generated successfully
            await updateProgress(0.7)
            
            print("✅ Replicate generation successful!")
            return result
            
        } catch {
            print("❌ Replicate API failed: \(error)")
            print("❌ Error details: \(error.localizedDescription)")
            if let apiError = error as? AIServiceError {
                print("❌ AIServiceError: \(apiError)")
            }
            
            // Provide specific error message for Replicate API failures
            throw error // Pass through the original error for better debugging
        }
    }
    
    // MARK: - Replicate API Integration
    
    private func generateWithReplicate(prompt: AIPrompt, useCulturalModel: Bool = true) async throws -> AIImageResult {
        guard !replicateAPIKey.isEmpty else {
            throw AIServiceError.invalidDesignSpec("Replicate API key not configured")
        }
        
        let startTime = Date()
        
        // Choose model based on cultural requirements
        let modelToUse = useCulturalModel ? culturalModel : defaultModel
        
        // Create optimized prompt for Rakhi generation
        let optimizedPrompt = buildCulturalRakhiPrompt(from: prompt)
        
        // DEBUG: Log the actual prompts being sent to SDXL
        print("🎯 POSITIVE PROMPT: \(optimizedPrompt.positive)")
        print("🚫 NEGATIVE PROMPT: \(optimizedPrompt.negative)")
        
        // Create prediction request - use the working SDXL model
        let predictionRequest = ReplicatePredictionRequest(
            version: "39ed52f2a78e934b3ba6e2a89f5b1c712de7dfea535525255b1aa35c5565e08b", // SDXL 1.0 version
            input: ReplicateInput(
                prompt: optimizedPrompt.positive,
                negative_prompt: optimizedPrompt.negative,
                width: prompt.width,
                height: prompt.height,
                num_outputs: 1,
                guidance_scale: prompt.cfg_scale,
                num_inference_steps: prompt.steps,
                seed: prompt.seed > 0 ? prompt.seed : nil,
                scheduler: "DPMSolverMultistep"
            )
        )
        
        // Submit prediction
        print("🚀 Submitting Replicate prediction...")
        let prediction = try await submitReplicatePrediction(request: predictionRequest)
        print("✅ Prediction submitted with ID: \(prediction.id)")
        
        // Poll for completion
        let completedPrediction = try await pollReplicatePredictionCompletion(predictionId: prediction.id)
        
        // Extract image URL from result - handle Replicate's response format
        guard let output = completedPrediction.output else {
            throw AIServiceError.serverError
        }
        
        var imageURL: String
        if let outputArray = output.value as? [String], let firstURL = outputArray.first {
            imageURL = firstURL
        } else if let outputString = output.value as? String {
            imageURL = outputString
        } else if let outputDict = output.value as? [String: Any], let url = outputDict["url"] as? String {
            imageURL = url
        } else {
            print("❌ Unexpected output format: \(output)")
            throw AIServiceError.serverError
        }
        
        // Download image data
        let imageData = try await downloadImage(from: imageURL)
        
        let _ = Date().timeIntervalSince(startTime) // Processing time tracked separately
        
        let metadata = GenerationMetadata(
            seed: prompt.seed,
            cfg_scale: prompt.cfg_scale,
            steps: prompt.steps,
            model: modelToUse,
            timestamp: Date()
        )
        
        return AIImageResult(
            imageData: imageData,
            timestamp: Date(),
            prompt: prompt,
            metadata: metadata
        )
    }
    
    private func buildCulturalRakhiPrompt(from prompt: AIPrompt) -> (positive: String, negative: String) {
        // Use ONLY the carefully crafted prompts from PromptMapper - do not override with generic elements
        var positivePrompt = """
        \(prompt.positive), 
        high quality photography, professional lighting, sharp details,
        masterpiece, best quality, ultra detailed, 8k resolution
        """
        
        var negativePrompt = """
        \(prompt.negative),
        western jewelry, inappropriate symbols, cross, star of david, christian symbols,
        blurry, low quality, distorted, deformed, ugly, bad anatomy,
        extra limbs, missing parts, watermark, signature, text,
        bad proportions, cloned elements, duplicate, cropped,
        out of frame, draft, worst quality, jpeg artifacts
        """
        
        // Clean up extra spaces and newlines
        positivePrompt = positivePrompt.replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "  ", with: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        negativePrompt = negativePrompt.replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "  ", with: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        return (positive: positivePrompt, negative: negativePrompt)
    }
    
    private func submitReplicatePrediction(request: ReplicatePredictionRequest) async throws -> ReplicatePrediction {
        let url = URL(string: "\(replicateBaseURL)/predictions")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Token \(replicateAPIKey)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        urlRequest.httpBody = try encoder.encode(request)
        
        print("📡 Sending request to: \(url)")
        print("📝 Request payload: \(String(data: urlRequest.httpBody ?? Data(), encoding: .utf8) ?? "Unable to decode")")
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ Invalid HTTP response")
            throw AIServiceError.serverError
        }
        
        print("📊 HTTP Status Code: \(httpResponse.statusCode)")
        print("📄 Response data: \(String(data: data, encoding: .utf8) ?? "Unable to decode")")
        
        guard 200...299 ~= httpResponse.statusCode else {
            print("❌ HTTP error: \(httpResponse.statusCode)")
            throw AIServiceError.serverError
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(ReplicatePrediction.self, from: data)
    }
    
    private func pollReplicatePredictionCompletion(predictionId: String) async throws -> ReplicatePrediction {
        let maxAttempts = 60 // 5 minutes max
        let pollInterval: TimeInterval = 5.0 // 5 seconds
        
        for _ in 0..<maxAttempts {
            let prediction = try await fetchReplicatePrediction(id: predictionId)
            
            switch prediction.status {
            case "succeeded":
                return prediction
            case "failed", "canceled":
                throw AIServiceError.serverError
            case "starting", "processing":
                // Continue polling
                try await Task.sleep(nanoseconds: UInt64(pollInterval * 1_000_000_000))
            default:
                throw AIServiceError.serverError
            }
        }
        
        throw AIServiceError.serverError
    }
    
    private func fetchReplicatePrediction(id: String) async throws -> ReplicatePrediction {
        let url = URL(string: "\(replicateBaseURL)/predictions/\(id)")!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Token \(replicateAPIKey)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw AIServiceError.networkError(URLError(.badServerResponse))
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(ReplicatePrediction.self, from: data)
    }
    
    private func downloadImage(from urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw AIServiceError.serverError
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw AIServiceError.serverError
        }
        
        return data
    }
    
    // MARK: - Mock Generation for Demo
    private func generateMockImage(prompt: AIPrompt) async throws -> AIImageResult {
        // Simulate realistic generation time
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        
        // Create a mock image result with placeholder data
        let metadata = GenerationMetadata(
            seed: Int.random(in: 1...1000000),
            cfg_scale: 7.5,
            steps: 30,
            model: "sdxl_base_1.0_mock",
            timestamp: Date()
        )
        
        return AIImageResult(
            imageData: createMockImageData(),
            timestamp: Date(),
            prompt: prompt,
            metadata: metadata
        )
    }
    
    private func createMockImageData() -> Data {
        // Create a simple colored square as placeholder image data
        let size = CGSize(width: 1024, height: 1024)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let image = renderer.image { context in
            // Create gradient background based on traditional Rakhi colors
            let colors = [UIColor.systemOrange, UIColor.systemRed, UIColor.systemYellow, UIColor.systemPink]
            let selectedColor = colors.randomElement() ?? UIColor.systemOrange
            
            // Create radial gradient
            let rect = CGRect(origin: .zero, size: size)
            context.cgContext.setFillColor(selectedColor.cgColor)
            context.cgContext.fill(rect)
            
            // Add some decorative elements
            context.cgContext.setFillColor(UIColor.white.cgColor)
            
            // Draw center circle
            let centerCircle = CGRect(x: 412, y: 412, width: 200, height: 200)
            context.cgContext.fillEllipse(in: centerCircle)
            
            // Draw smaller decorative circles
            for i in 0..<8 {
                let angle = Double(i) * .pi / 4
                let radius: CGFloat = 300
                let x = 512 + cos(angle) * radius - 25
                let y = 512 + sin(angle) * radius - 25
                let circle = CGRect(x: x, y: y, width: 50, height: 50)
                context.cgContext.fillEllipse(in: circle)
            }
            
            // Add text overlay
            context.cgContext.setFillColor(selectedColor.cgColor)
            let text = "🎊 Rakhi 🎊"
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 80, weight: .bold),
                .foregroundColor: selectedColor
            ]
            let attributedText = NSAttributedString(string: text, attributes: attributes)
            let textRect = CGRect(x: 350, y: 500, width: 324, height: 100)
            attributedText.draw(in: textRect)
        }
        
        return image.pngData() ?? Data()
    }
    
    private func performImageGeneration(request: ImageGenerationRequest, endpoint: String, loraModels: [String]) async throws -> AIImageResult {
        let startTime = Date()
        
        // Create URLRequest for SDXL API
        guard let url = URL(string: "\(endpoint)/generate/sdxl") else {
            throw AIServiceError.invalidEndpoint
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(getAPIKey())", forHTTPHeaderField: "Authorization")
        
        // Create enhanced request payload with LoRA and ControlNet
        let enhancedRequest = EnhancedImageGenerationRequest(
            prompt: request.prompt,
            model: "sdxl_base_1.0",
            scheduler: request.scheduler,
            lora_models: loraModels,
            controlnet_models: ["canny_edge", "depth_estimation"],
            safety_checker: true,
            cultural_filter: true,
            output_format: "png",
            quality: "high"
        )
        
        urlRequest.httpBody = try JSONEncoder().encode(enhancedRequest)
        
        // Progress tracking: Initial API call
        await updateProgress(0.3)
        
        // Perform request with timeout and retry logic
        let (data, response) = try await performRequestWithRetry(urlRequest)
        
        // Validate HTTP response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AIServiceError.networkError(URLError(.badServerResponse))
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            if httpResponse.statusCode == 400 {
                throw AIServiceError.invalidDesignSpec("Invalid prompt or parameters")
            } else if httpResponse.statusCode == 429 {
                throw AIServiceError.serverError
            }
            throw AIServiceError.networkError(URLError(.badServerResponse))
        }
        
        // Progress tracking: Processing response
        await updateProgress(0.6)
        
        // Decode generation response
        let generationResponse: ImageGenerationResponse
        do {
            generationResponse = try JSONDecoder().decode(ImageGenerationResponse.self, from: data)
        } catch {
            throw AIServiceError.decodingError
        }
        
        // Validate generated image URL
        guard let _ = URL(string: generationResponse.imageURL) else {
            throw AIServiceError.serverError
        }
        
        let processingTime = Date().timeIntervalSince(startTime)
        
        // Progress tracking: Image generation complete
        await updateProgress(0.8)
        
        return AIImageResult(
            imageURL: generationResponse.imageURL,
            metadata: GenerationMetadata(
                seed: request.prompt.seed,
                cfg_scale: request.prompt.cfg_scale,
                steps: request.prompt.steps,
                model: request.model,
                timestamp: Date()
            ),
            processingTime: processingTime
        )
    }
    
    private func performRequestWithRetry(_ request: URLRequest, maxRetries: Int = 3) async throws -> (Data, URLResponse) {
        var lastError: Error?
        
        for attempt in 1...maxRetries {
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                return (data, response)
            } catch {
                lastError = error
                
                // If it's a network error and we have retries left, wait and retry
                if attempt < maxRetries {
                    let backoffTime = min(pow(2.0, Double(attempt)), 8.0) // Exponential backoff, max 8 seconds
                    try await Task.sleep(nanoseconds: UInt64(backoffTime * 1_000_000_000))
                }
            }
        }
        
        throw lastError ?? AIServiceError.networkError(URLError(.timedOut))
    }
    
    private func generateAnimationFrames(for imageResult: AIImageResult) async throws -> [AnimationFrame] {
        // Progress tracking: Starting animation generation
        await updateProgress(0.82)
        
        // For now, create a placeholder URL since we use imageData instead of imageURL for Replicate
        let baseImageURL = imageResult.imageURL ?? "placeholder_image_url"
        
        // Generate Apple Watch optimized animation frames
        let animationRequest = AnimationGenerationRequest(
            baseImageURL: baseImageURL,
            animationType: .subtle_glow,
            frameCount: 12, // Optimized for Apple Watch
            duration: 3.0,
            outputFormat: "webp",
            quality: "medium", // Balance between quality and watch performance
            watchOptimized: true
        )
        
        let animationFrames = try await generateWatchOptimizedAnimation(request: animationRequest)
        
        // Progress tracking: Animation generation complete
        await updateProgress(0.95)
        
        return animationFrames
    }
    
    private func generateWatchOptimizedAnimation(request: AnimationGenerationRequest) async throws -> [AnimationFrame] {
        // For production, this would call an animation generation API
        // For Phase 2, we'll create a more sophisticated simulation
        var frames: [AnimationFrame] = []
        
        let frameDuration = request.duration / Double(request.frameCount)
        
        for frameIndex in 0..<request.frameCount {
            let timestamp = Double(frameIndex) * frameDuration
            
            // Generate frame-specific effects (glow, sparkle, etc.)
            let frameURL = await generateAnimationFrame(
                baseURL: request.baseImageURL,
                frameIndex: frameIndex,
                effectType: request.animationType,
                timestamp: timestamp
            )
            
            let frame = AnimationFrame(
                frameNumber: frameIndex,
                imageURL: frameURL,
                timestamp: timestamp
            )
            
            frames.append(frame)
        }
        
        return frames
    }
    
    private func generateAnimationFrame(
        baseURL: String,
        frameIndex: Int,
        effectType: AnimationType,
        timestamp: TimeInterval
    ) async -> String {
        // In production, this would be an API call to generate frame-specific effects
        // For now, we'll return a parameterized URL that indicates the frame
        return "\(baseURL)?frame=\(frameIndex)&effect=\(effectType.rawValue)&t=\(timestamp)"
    }
    
    private func calculateCulturalScore(_ spec: RakhiDesignSpec) -> Double {
        // Calculate cultural authenticity score based on elements and genre
        let genreScore = spec.genre.culturalWeight
        let elementScore = spec.elements.map { $0.culturalSignificance }.reduce(0, +) / Double(spec.elements.count)
        
        return (genreScore + elementScore) / 2.0
    }
    
    private func assessQuality(_ imageResult: AIImageResult) async -> Double {
        // Placeholder for quality assessment using CLIP or similar
        // For now, return a default good score
        return 0.85
    }
    
    private func updateProgress(_ progress: Float) async {
        await MainActor.run {
            self.generationProgress = progress
        }
    }
    
    private func getAPIKey() -> String {
        // In production, this should be securely stored
        return Bundle.main.object(forInfoDictionaryKey: "FORAVA_API_KEY") as? String ?? ""
    }
}

// MARK: - Supporting Types

struct AIPrompt: Codable {
    let positive: String
    let negative: String
    let cfg_scale: Double
    let steps: Int
    let seed: Int
    let width: Int
    let height: Int
}

struct ImageGenerationRequest: Codable {
    let prompt: AIPrompt
    let model: String
    let scheduler: String
}

struct EnhancedImageGenerationRequest: Codable {
    let prompt: AIPrompt
    let model: String
    let scheduler: String
    let lora_models: [String]
    let controlnet_models: [String]
    let safety_checker: Bool
    let cultural_filter: Bool
    let output_format: String
    let quality: String
}

struct ImageGenerationResponse: Codable {
    let imageURL: String
    let metadata: GenerationMetadata
    let processingTime: TimeInterval
}

struct AIImageResult: Codable {
    let imageURL: String?
    let imageData: Data?
    let timestamp: Date
    let prompt: AIPrompt?
    let metadata: GenerationMetadata?
    let processingTime: TimeInterval?
    
    // Convenience initializers for different use cases
    init(imageURL: String, metadata: GenerationMetadata, processingTime: TimeInterval) {
        self.imageURL = imageURL
        self.imageData = nil
        self.timestamp = Date()
        self.prompt = nil
        self.metadata = metadata
        self.processingTime = processingTime
    }
    
    init(imageData: Data, timestamp: Date, prompt: AIPrompt? = nil, metadata: GenerationMetadata? = nil) {
        self.imageURL = nil
        self.imageData = imageData
        self.timestamp = timestamp
        self.prompt = prompt
        self.metadata = metadata
        self.processingTime = nil
    }
}

struct GenerationMetadata: Codable {
    let seed: Int
    let cfg_scale: Double
    let steps: Int
    let model: String
    let timestamp: Date
}

struct GeneratedRakhi: Identifiable, Codable {
    let id: UUID
    let designSpec: RakhiDesignSpec
    let mainImage: AIImageResult
    let animationFrames: [AnimationFrame]
    let prompt: AIPrompt
    let createdAt: Date
    let culturalScore: Double
    let qualityScore: Double
}

struct AnimationFrame: Codable {
    let frameNumber: Int
    let imageURL: String
    let timestamp: TimeInterval
}

struct AnimationGenerationRequest: Codable {
    let baseImageURL: String
    let animationType: AnimationType
    let frameCount: Int
    let duration: TimeInterval
    let outputFormat: String
    let quality: String
    let watchOptimized: Bool
}

enum AnimationType: String, Codable, CaseIterable {
    case subtle_glow = "subtle_glow"
    case sparkle_effect = "sparkle_effect"
    case gentle_pulse = "gentle_pulse"
    case thread_shimmer = "thread_shimmer"
    case cultural_blessing = "cultural_blessing"
    
    var displayName: String {
        switch self {
        case .subtle_glow: return "Subtle Glow"
        case .sparkle_effect: return "Sparkle Effect"
        case .gentle_pulse: return "Gentle Pulse"
        case .thread_shimmer: return "Thread Shimmer"
        case .cultural_blessing: return "Cultural Blessing"
        }
    }
    
    var description: String {
        switch self {
        case .subtle_glow: return "A warm, gentle glow around the Rakhi"
        case .sparkle_effect: return "Delicate sparkles highlighting key elements"
        case .gentle_pulse: return "A soft pulsing light effect"
        case .thread_shimmer: return "Shimmering threads with golden highlights"
        case .cultural_blessing: return "Blessed aura with traditional symbols"
        }
    }
}

// MARK: - Error Handling

enum AIServiceError: LocalizedError {
    case invalidDesignSpec(String)
    case culturallyInappropriate([String])
    case networkError(Error)
    case serverError
    case invalidEndpoint
    case allEndpointsFailed
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidDesignSpec(let message):
            return "Invalid design specification: \(message)"
        case .culturallyInappropriate(let elements):
            return "Some design elements may not be culturally appropriate: \(elements.joined(separator: ", "))"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .serverError:
            return "Server error occurred while generating Rakhi"
        case .invalidEndpoint:
            return "Invalid API endpoint"
        case .allEndpointsFailed:
            return "Replicate AI generation service is currently unavailable"
        case .decodingError:
            return "Failed to decode server response"
        }
    }
    
    static func from(_ error: Error) -> AIServiceError {
        if let aiError = error as? AIServiceError {
            return aiError
        } else if error is DecodingError {
            return .decodingError
        } else {
            return .networkError(error)
        }
    }
}

// MARK: - Replicate API Data Models

struct ReplicatePredictionRequest: Codable {
    let version: String
    let input: ReplicateInput
}

struct ReplicateInput: Codable {
    let prompt: String
    let negative_prompt: String
    let width: Int
    let height: Int
    let num_outputs: Int
    let guidance_scale: Double
    let num_inference_steps: Int
    let seed: Int?
    let scheduler: String
}

struct ReplicatePrediction: Codable {
    let id: String
    let status: String
    let output: AnyCodable?
    let error: String?
    
    private enum CodingKeys: String, CodingKey {
        case id, status, output, error
    }
}

// Helper for decoding dynamic JSON
struct AnyCodable: Codable {
    let value: Any
    
    init<T>(_ value: T?) {
        self.value = value ?? ()
    }
}

extension AnyCodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if container.decodeNil() {
            value = ()
        } else if let bool = try? container.decode(Bool.self) {
            value = bool
        } else if let int = try? container.decode(Int.self) {
            value = int
        } else if let double = try? container.decode(Double.self) {
            value = double
        } else if let string = try? container.decode(String.self) {
            value = string
        } else if let array = try? container.decode([AnyCodable].self) {
            value = array.map { $0.value }
        } else if let dictionary = try? container.decode([String: AnyCodable].self) {
            value = dictionary.mapValues { $0.value }
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode value")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch value {
        case is Void:
            try container.encodeNil()
        case let bool as Bool:
            try container.encode(bool)
        case let int as Int:
            try container.encode(int)
        case let double as Double:
            try container.encode(double)
        case let string as String:
            try container.encode(string)
        case let array as [Any]:
            let encodableArray = array.map { AnyCodable($0) }
            try container.encode(encodableArray)
        case let dictionary as [String: Any]:
            let encodableDictionary = dictionary.mapValues { AnyCodable($0) }
            try container.encode(encodableDictionary)
        default:
            throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: [], debugDescription: "Cannot encode value"))
        }
    }
}