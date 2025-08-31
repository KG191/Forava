import Foundation
import SwiftUI
import Combine

// MARK: - Cultural AI Generation Service
@MainActor
class CulturalAIService: ObservableObject {
    static let shared = CulturalAIService()

    @Published var isGenerating = false
    @Published var generationProgress: Float = 0.0
    @Published var generatedArtwork: CulturalGeneratedArtwork?
    @Published var error: CulturalAIServiceError?

    // Replicate API configuration
    private let replicateBaseURL = "https://api.replicate.com/v1"
    private let replicateAPIKey: String

    // Demo mode - when true, uses mock generation instead of real API
    private let useMockGeneration = false

    // Cultural framework integration
    private let culturalManager = CulturalContextManager.shared
    private let culturalConfig = CulturalConfiguration.shared
    private let multiLanguagePromptService = MultiLanguagePromptService.shared
    private let deviceImageService = DeviceOptimizedImageService.shared

    private var cancellables = Set<AnyCancellable>()

    private init() {
        // Load Replicate API key using the same method as legacy service
        print("🔑 [CulturalAI] Loading Replicate API key...")

        if let envVar = ProcessInfo.processInfo.environment["REPLICATE_API_TOKEN"] {
            self.replicateAPIKey = envVar
            print("✅ [CulturalAI] API key loaded from environment variable")
            return
        }

        if let envPath = Bundle.main.path(forResource: ".env", ofType: nil) {
            print("📁 [CulturalAI] Found .env in bundle at: \(envPath)")
            do {
                let envContent = try String(contentsOfFile: envPath)
                let lines = envContent.components(separatedBy: .newlines)

                for line in lines {
                    let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
                    if trimmed.hasPrefix("REPLICATE_API_TOKEN=") {
                        let value = String(trimmed.dropFirst("REPLICATE_API_TOKEN=".count))
                        self.replicateAPIKey = value.trimmingCharacters(in: .whitespacesAndNewlines)
                        print("✅ [CulturalAI] API key loaded from .env file")
                        return
                    }
                }
            } catch {
                print("⚠️ [CulturalAI] Error reading .env file: \(error)")
            }
        }

        print("⚠️ [CulturalAI] No Replicate API key found. Using demo mode.")
        self.replicateAPIKey = ""
    }

    // MARK: - Public Interface

    func clearGeneratedArtwork() {
        generatedArtwork = nil
        error = nil
        print("[CulturalAI] Cleared generated artwork and error state")
    }

    func generateArtwork(from designSpec: CulturalDesignSpec) async throws -> CulturalGeneratedArtwork {
        print("[CulturalAI] Starting generation for cultural design: \(designSpec.id)")

        try validateGenerationPreconditions(designSpec: designSpec)

        guard let context = culturalManager.getContext(for: designSpec.culturalContext) else {
            throw CulturalAIServiceError.invalidCulturalContext(designSpec.culturalContext)
        }

        return try await executeArtworkGeneration(designSpec: designSpec, context: context)
    }

    private func validateGenerationPreconditions(designSpec: CulturalDesignSpec) throws {
        guard !isGenerating else {
            throw CulturalAIServiceError.alreadyGenerating
        }
    }

    private func executeArtworkGeneration(
        designSpec: CulturalDesignSpec,
        context: CulturalContext
    ) async throws -> CulturalGeneratedArtwork {
        isGenerating = true
        generationProgress = 0.0
        error = nil

        defer {
            isGenerating = false
            generationProgress = 0.0
        }

        do {
            try validateDesignSpec(designSpec, in: context)
            generationProgress = 0.1

            let prompt = buildCulturalPrompt(from: designSpec, in: context)
            generationProgress = 0.2
            logPromptCreation(prompt: prompt, context: context)

            let imageResult = try await generateImage(
                prompt: prompt, usingModel: context.preferredAIModel, for: context
            )
            generationProgress = 0.3
            print("[CulturalAI] Generated image successfully using cultural model")

            let animationFrames = try await generateCulturalAnimationFrames(
                for: imageResult, with: context.animationStyle, in: context
            )
            generationProgress = 0.8

            let artwork = createArtworkFromComponents(
                designSpec: designSpec, context: context, imageResult: imageResult,
                animationFrames: animationFrames, prompt: prompt
            )

            generationProgress = 1.0
            self.generatedArtwork = artwork
            print("[CulturalAI] Successfully generated cultural artwork with ID: \(artwork.id)")
            return artwork
        } catch {
            return try handleGenerationError(error)
        }
    }

    private func logPromptCreation(prompt: CulturalPrompt, context: CulturalContext) {
        let promptPrefix = prompt.positive.prefix(100)
        print("[CulturalAI] Built cultural prompt for \(context.displayName): \(promptPrefix)...")
    }

    private func createArtworkFromComponents(
        designSpec: CulturalDesignSpec,
        context: CulturalContext,
        imageResult: CulturalImageResult,
        animationFrames: [CulturalAnimationFrame],
        prompt: CulturalPrompt
    ) -> CulturalGeneratedArtwork {
        return CulturalGeneratedArtwork(
            id: UUID(),
            designSpec: designSpec,
            culturalContext: context.identifier,
            mainImage: imageResult,
            animationFrames: animationFrames,
            qualityScore: imageResult.qualityScore,
            culturalScore: calculateCulturalScore(designSpec, in: context),
            generatedAt: Date(),
            metadata: CulturalGenerationMetadata(
                culturalContext: context.identifier,
                model: context.preferredAIModel,
                prompt: prompt.positive,
                negativePrompt: prompt.negative,
                culturalEnhancers: context.basePromptEnhancers,
                steps: 30,
                cfgScale: 7.5,
                seed: imageResult.seed
            )
        )
    }

    private func handleGenerationError(_ error: Error) throws -> CulturalGeneratedArtwork {
        let culturalError = error as? CulturalAIServiceError ?? .unknownError(error.localizedDescription)
        self.error = culturalError
        print("[CulturalAI] Generation failed: \(error)")
        throw culturalError
    }

    // MARK: - Device-Optimized Generation

    func generateDeviceOptimizedArtwork(from designSpec: CulturalDesignSpec) async throws -> DeviceOptimizedImageSet {
        print("[CulturalAI] Starting device-optimized generation for cultural context: \(designSpec.culturalContext)")

        guard let context = culturalManager.getContext(for: designSpec.culturalContext) else {
            throw CulturalAIServiceError.invalidCulturalContext(designSpec.culturalContext)
        }

        isGenerating = true
        generationProgress = 0.0
        error = nil

        defer {
            isGenerating = false
            generationProgress = 0.0
        }

        do {
            // Step 1: Validate design specification
            generationProgress = 0.1
            try validateDesignSpec(designSpec, in: context)

            // Step 2: Generate device-optimized images
            generationProgress = 0.3
            let deviceOptimizedSet = try await deviceImageService.generateDeviceOptimizedImages(from: designSpec)

            // Step 3: Validate each device format
            generationProgress = 0.8
            let validationResults = validateDeviceImages(deviceOptimizedSet)

            // Log validation results
            for result in validationResults where !result.isValid {
                let issues = result.issues.joined(separator: ", ")
                print("[CulturalAI] Device validation issues for \(result.deviceType.displayName): \(issues)")
            }

            generationProgress = 1.0
            print("[CulturalAI] Successfully generated device-optimized cultural artwork set")

            return deviceOptimizedSet

        } catch {
            let culturalError = error as? CulturalAIServiceError ?? .unknownError(error.localizedDescription)
            self.error = culturalError
            print("[CulturalAI] Device-optimized generation failed: \(error)")
            throw culturalError
        }
    }

    private func validateDeviceImages(_ imageSet: DeviceOptimizedImageSet) -> [DeviceValidationResult] {
        return [
            deviceImageService.validateImageForDevice(imageSet.watchFace.image, deviceType: .watchFace),
            deviceImageService.validateImageForDevice(imageSet.phoneWallpaper.image, deviceType: .phoneWallpaper),
            deviceImageService.validateImageForDevice(imageSet.phoneLockscreen.image, deviceType: .phoneLockscreen)
        ]
    }

    // MARK: - Legacy Compatibility

    func generateRakhi(from legacySpec: RakhiDesignSpec) async throws -> GeneratedRakhi {
        print("[CulturalAI] Converting legacy Rakhi spec to cultural framework")

        guard let culturalSpec = LegacyRakhiBridge.shared.convertLegacySpec(legacySpec) else {
            throw CulturalAIServiceError.legacyConversionFailed
        }

        let culturalArtwork = try await generateArtwork(from: culturalSpec)

        // Convert back to legacy format for backward compatibility
        return GeneratedRakhi(
            id: culturalArtwork.id,
            designSpec: legacySpec,
            mainImage: culturalArtwork.mainImage,
            animationFrames: culturalArtwork.animationFrames,
            qualityScore: culturalArtwork.qualityScore,
            culturalScore: culturalArtwork.culturalScore,
            generatedAt: culturalArtwork.generatedAt,
            metadata: GenerationMetadata(
                model: culturalArtwork.metadata.model,
                prompt: culturalArtwork.metadata.prompt,
                negativePrompt: culturalArtwork.metadata.negativePrompt,
                steps: culturalArtwork.metadata.steps,
                cfgScale: culturalArtwork.metadata.cfgScale,
                seed: culturalArtwork.metadata.seed
            )
        )
    }

    // MARK: - Private Helpers

    private func validateDesignSpec(_ spec: CulturalDesignSpec, in context: CulturalContext) throws {
        let validationResult = context.validator.validateDesignSpec(spec)

        if !validationResult.isValid {
            let errorMessage = validationResult.errors.joined(separator: "; ")
            throw CulturalAIServiceError.invalidDesignSpec(errorMessage)
        }

        // Log warnings
        if !validationResult.warnings.isEmpty {
            print("[CulturalAI] Validation warnings: \(validationResult.warnings.joined(separator: "; "))")
        }

        // Log recommendations
        if !validationResult.recommendations.isEmpty {
            print("[CulturalAI] Recommendations: \(validationResult.recommendations.joined(separator: "; "))")
        }
    }

    private func buildCulturalPrompt(
        from spec: CulturalDesignSpec,
        in context: CulturalContext
    ) -> CulturalPrompt {
        // Use multi-language prompt service for enhanced cultural prompts
        let (positive, negative) = multiLanguagePromptService.buildMultiLanguagePrompt(from: spec, in: context)

        // Perform cultural bias detection
        let biasResult = multiLanguagePromptService.detectCulturalBias(in: positive, for: context)
        if !biasResult.isAppropriate {
            let warnings = biasResult.warnings.joined(separator: "; ")
            print("[CulturalAI] Cultural bias detected in prompt. Warnings: \(warnings)")
            if !biasResult.suggestions.isEmpty {
                let suggestions = biasResult.suggestions.joined(separator: "; ")
                print("[CulturalAI] Suggestions: \(suggestions)")
            }
        }

        // Optimize prompt for cultural context
        let optimizedPositive = multiLanguagePromptService.optimizePromptForCulture(positive, context: context)

        return CulturalPrompt(
            positive: optimizedPositive,
            negative: negative,
            culturalContext: context.identifier,
            culturalEnhancers: context.basePromptEnhancers,
            steps: 30,
            cfgScale: 7.5,
            seed: -1
        )
    }

    private func generateImage(
        prompt: CulturalPrompt,
        usingModel model: String,
        for context: CulturalContext
    ) async throws -> CulturalImageResult {

        guard !replicateAPIKey.isEmpty else {
            print("[CulturalAI] No API key - using mock generation")
            return try await generateMockImage(prompt: prompt, for: context)
        }

        print("[CulturalAI] Generating image with cultural model: \(model)")
        return try await generateWithReplicate(
            prompt: prompt,
            model: model,
            for: context
        )
    }

    private func generateWithReplicate(
        prompt: CulturalPrompt,
        model: String,
        for context: CulturalContext
    ) async throws -> CulturalImageResult {

        let request = ReplicatePredictionRequest(
            version: model,
            input: ReplicateInput(
                prompt: prompt.positive,
                negativePrompt: prompt.negative,
                width: 1024,
                height: 1024,
                numInferenceSteps: prompt.steps,
                guidanceScale: prompt.cfgScale,
                seed: prompt.seed == -1 ? nil : prompt.seed,
                numOutputs: 1,
                scheduler: "DPMSolverMultistep"
            )
        )

        print("[CulturalAI] Submitting prediction for \(context.displayName)")
        let prediction = try await submitReplicatePrediction(request: request)
        print("[CulturalAI] Prediction submitted with ID: \(prediction.id)")

        generationProgress = 0.5
        let completedPrediction = try await pollReplicatePredictionCompletion(predictionId: prediction.id)
        print("[CulturalAI] Prediction completed")

        generationProgress = 0.7
        guard let outputURL = completedPrediction.output?.first else {
            throw CulturalAIServiceError.noImageGenerated
        }

        let imageData = try await downloadImage(from: outputURL)
        print("[CulturalAI] Downloaded image data: \(imageData.count) bytes")

        return CulturalImageResult(
            imageData: imageData,
            width: 1024,
            height: 1024,
            format: "png",
            qualityScore: 0.95,
            seed: completedPrediction.input.seed ?? -1,
            model: model,
            culturalContext: context.identifier
        )
    }

    private func generateMockImage(
        prompt: CulturalPrompt,
        for context: CulturalContext
    ) async throws -> CulturalImageResult {
        print("[CulturalAI] Using mock generation for \(context.displayName)")

        // Simulate API delay
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        generationProgress = 0.5

        try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
        generationProgress = 0.8

        // Create culturally-appropriate mock image data based on context
        let mockImageData = createCulturalMockImageData(for: context)

        return CulturalImageResult(
            imageData: mockImageData,
            width: 512,
            height: 512,
            format: "png",
            qualityScore: 0.85,
            seed: Int.random(in: 1...100000),
            model: "mock-cultural-model-v1",
            culturalContext: context.identifier
        )
    }

    private func createCulturalMockImageData(for context: CulturalContext) -> Data {
        return CulturalMockImageGenerator.shared.createMockImageData(for: context)
    }

    private func generateCulturalAnimationFrames(
        for imageResult: CulturalImageResult,
        with style: CulturalAnimationStyle,
        in context: CulturalContext
    ) async throws -> [CulturalAnimationFrame] {
        return try await CulturalAnimationGenerator.shared.generateFrames(
            for: imageResult,
            with: style,
            in: context
        )
    }

    private func calculateCulturalScore(_ spec: CulturalDesignSpec, in context: CulturalContext) -> Double {
        return context.validator.getCulturalScore(for: spec, in: context)
    }

    // MARK: - Replicate API Methods (Reused from original)

    private func submitReplicatePrediction(request: ReplicatePredictionRequest) async throws -> ReplicatePrediction {
        return try await CulturalReplicateClient.shared.submitPrediction(request, apiKey: replicateAPIKey)
    }

    private func pollReplicatePredictionCompletion(predictionId: String) async throws -> ReplicatePrediction {
        return try await CulturalReplicateClient.shared.pollPredictionCompletion(
            predictionId: predictionId,
            apiKey: replicateAPIKey,
            progressCallback: { progress in
                generationProgress = 0.5 + (progress * 0.2)
            }
        )
    }

    private func downloadImage(from urlString: String) async throws -> Data {
        return try await CulturalReplicateClient.shared.downloadImage(from: urlString)
    }
}
