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
    private var replicateAPIKey: String
    private var blackForestLabsAPIKey: String
    
    // Enhanced model selection for professional cultural artwork (2025)
    private let fluxProModel = "black-forest-labs/flux-pro"      // Best quality (2025)
    private let fluxDevModel = "black-forest-labs/flux-dev"      // Best balance
    private let culturalModel = "stability-ai/sdxl:39ed52f2a78e934b3ba6e2a89f5b1c712de7dfea535525255b1aa35c5565e08b"
    private let defaultModel = "stability-ai/sdxl:39ed52f2a78e934b3ba6e2a89f5b1c712de7dfea535525255b1aa35c5565e08b"
    
    // Quality settings - SDXL Primary (Cost-effective + Proven Cultural Quality)
    private let useFluxForPremiumQuality = false // DISABLED: Use SDXL for better cost/quality
    private let useMockGeneration = false        // ✅ ENABLED: Real API with SDXL

    private var cancellables = Set<AnyCancellable>()
    private var currentDesignSpec: RakhiDesignSpec?

    private init() {
        // Initialize with empty strings, will be loaded dynamically
        self.replicateAPIKey = ""
        self.blackForestLabsAPIKey = ""
        
        // Load API keys immediately
        self.loadAPIKeysWithPersistence()
    }
    
    // MARK: - Robust API Key Management
    private func loadAPIKeysWithPersistence() {
        print("🔑 Loading API keys with persistence...")
        
        // Try to load from persistent storage first
        if let storedKey = loadFromKeychain(key: "replicate_api_key"), !storedKey.isEmpty {
            self.replicateAPIKey = storedKey
            print("✅ Replicate API key loaded from secure storage")
        } else {
            // Fall back to environment/bundle loading
            let loadedKey = loadAPIKeyFromSources()
            if !loadedKey.isEmpty {
                self.replicateAPIKey = loadedKey
                // Store for future use
                saveToKeychain(key: "replicate_api_key", value: loadedKey)
                print("✅ Replicate API key loaded and stored securely")
            } else {
                print("❌ No Replicate API key found from any source")
            }
        }
        
        // Load Black Forest Labs key similarly
        if let storedBFKey = loadFromKeychain(key: "black_forest_api_key"), !storedBFKey.isEmpty {
            self.blackForestLabsAPIKey = storedBFKey
            print("✅ Black Forest Labs API key loaded from secure storage")
        }
        
        // Validate final state
        validateAPIKeyConfiguration()
    }
    
    private func loadAPIKeyFromSources() -> String {
        // Method 1: Environment variables (Xcode scheme)
        if let envKey = ProcessInfo.processInfo.environment["REPLICATE_API_TOKEN"], !envKey.isEmpty {
            print("✅ Found API key in environment variables")
            return envKey
        }
        
        // Method 2: Alternative environment variable names
        if let altKey = ProcessInfo.processInfo.environment["REPLICATE_API_KEY"], !altKey.isEmpty {
            print("✅ Found API key in alternative environment variable")
            return altKey
        }
        
        // Method 3: App bundle .env file
        if let envPath = Bundle.main.path(forResource: ".env", ofType: nil) {
            print("📁 Checking bundle .env file at: \(envPath)")
            do {
                let envContent = try String(contentsOfFile: envPath)
                let lines = envContent.components(separatedBy: .newlines)
                
                // Look for formatted key
                if let tokenLine = lines.first(where: { $0.hasPrefix("REPLICATE_API_TOKEN=") }) {
                    let apiKey = String(tokenLine.dropFirst("REPLICATE_API_TOKEN=".count).trimmingCharacters(in: .whitespaces))
                    if !apiKey.isEmpty {
                        print("✅ Found API key in .env file (formatted)")
                        return apiKey
                    }
                }
                
                // Look for raw key on second line
                if lines.count > 1 && lines[1].hasPrefix("r8_") {
                    let apiKey = lines[1].trimmingCharacters(in: .whitespaces)
                    if !apiKey.isEmpty {
                        print("✅ Found API key in .env file (raw)")
                        return apiKey
                    }
                }
            } catch {
                print("❌ Failed to read .env file: \(error)")
            }
        }
        
        return ""
    }
    
    // Keychain storage for persistent API keys
    private func saveToKeychain(key: String, value: String) {
        let data = value.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        // Delete any existing item
        SecItemDelete(query as CFDictionary)
        
        // Add new item
        let status = SecItemAdd(query as CFDictionary, nil)
        if status == errSecSuccess {
            print("✅ API key stored securely in Keychain")
        } else {
            print("⚠️ Failed to store API key in Keychain: \(status)")
        }
    }
    
    private func loadFromKeychain(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess,
           let data = result as? Data,
           let value = String(data: data, encoding: .utf8) {
            return value
        }
        
        return nil
    }
    
    private func validateAPIKeyConfiguration() {
        if replicateAPIKey.isEmpty {
            print("❌ CRITICAL: No Replicate API key available")
            print("🔧 Troubleshooting Steps:")
            print("   1. Check Xcode Scheme > Run > Environment Variables")
            print("   2. Ensure REPLICATE_API_TOKEN is set correctly")
            print("   3. Verify .env file is added to app bundle")
            print("   4. Restart Xcode and clean build")
        } else {
            print("✅ API configuration validated successfully")
            print("🔑 API Key prefix: \(String(replicateAPIKey.prefix(8)))...")
        }
    }

    // MARK: - Public Interface
    func generateRakhi(from designSpec: RakhiDesignSpec) async throws -> GeneratedRakhi {
        isGenerating = true
        generationProgress = 0.0
        error = nil
        currentDesignSpec = designSpec // Store for mock generation

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

            // Step 4: Animation generation removed - static images only
            await updateProgress(0.9)

            // Step 5: Package final result
            let generatedRakhi = GeneratedRakhi(
                id: UUID(),
                designSpec: designSpec,
                mainImage: imageResult,
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

        // Validate API key availability BEFORE proceeding
        let currentKey = getCurrentAPIKey()
        if currentKey.isEmpty {
            let status = getAPIKeyStatus()
            throw AIServiceError.invalidDesignSpec("Replicate API key not configured. Status: \(status.keyPrefix) from \(status.source). Please check environment variables or .env file.")
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
        _ = PromptBuilder()

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
            return try await generateMockImage(prompt: prompt, designSpec: currentDesignSpec)
        }

        // Use SDXL for cost-effective, high-quality cultural artwork
        print("🎯 Starting SDXL image generation with Replicate API...")
        print("🔑 API Key status: \(replicateAPIKey.isEmpty ? "❌ Empty" : "✅ Available")")
        print("🎨 Using Stable Diffusion XL for optimized cultural artwork")

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
        // Robust API key loading with multiple fallbacks
        let currentAPIKey = getCurrentAPIKey()
        
        print("🔑 API Key Validation:")
        print("   Stored key: \(replicateAPIKey.isEmpty ? "❌ Empty" : "✅ Has Value")")
        print("   Environment key: \(ProcessInfo.processInfo.environment["REPLICATE_API_TOKEN"] != nil ? "✅ Set" : "❌ Not Set")")
        print("   Final key: \(currentAPIKey.isEmpty ? "❌ Empty" : "✅ Available (\(String(currentAPIKey.prefix(8)))...)")")
        
        guard !currentAPIKey.isEmpty else {
            print("❌ CRITICAL: No API key available from any source")
            print("🔧 Troubleshooting:")
            print("   1. Check Xcode Scheme > Run > Environment Variables")
            print("   2. Ensure REPLICATE_API_TOKEN is set") 
            print("   3. Restart Xcode and rebuild")
            throw AIServiceError.invalidDesignSpec("Replicate API key not configured. Please check your .env file.")
        }

        let startTime = Date()

        // Choose model for professional cultural artwork (2025 enhanced)
        let modelToUse: String
        if useFluxForPremiumQuality {
            modelToUse = fluxProModel  // FLUX Pro for Ganesh-quality results
        } else if useCulturalModel {
            modelToUse = culturalModel // SDXL fallback
        } else {
            modelToUse = defaultModel
        }

        // Create enhanced prompt for professional cultural artwork
        let optimizedPrompt = useFluxForPremiumQuality ? 
            buildEnhancedCulturalPrompt(from: prompt) : 
            buildCulturalRakhiPrompt(from: prompt)

        // Create prediction request with dynamic model selection
        let predictionRequest: ReplicatePredictionRequest
        if useFluxForPremiumQuality {
            // FLUX Pro request format - use model directly as version
            predictionRequest = ReplicatePredictionRequest(
                version: modelToUse,
                input: ReplicateInput(
                    prompt: optimizedPrompt.positive,
                    width: prompt.width,
                    height: prompt.height,
                    num_outputs: 1,
                    guidance_scale: prompt.cfg_scale,
                    num_inference_steps: prompt.steps,
                    seed: prompt.seed > 0 ? prompt.seed : nil,
                    output_format: "png",
                    output_quality: 95
                )
            )
        } else {
            // SDXL request format - optimized for cultural artwork
            predictionRequest = ReplicatePredictionRequest(
                version: "39ed52f2a78e934b3ba6e2a89f5b1c712de7dfea535525255b1aa35c5565e08b",
                input: ReplicateInput(
                    prompt: optimizedPrompt.positive,
                    negative_prompt: optimizedPrompt.negative,
                    width: prompt.width,
                    height: prompt.height,
                    num_outputs: 1,
                    guidance_scale: 15.0,  // Maximum guidance for symbol adherence  
                    num_inference_steps: 75,  // Maximum steps for intricate symbol detail
                    seed: prompt.seed > 0 ? prompt.seed : nil,
                    scheduler: "DPMSolverMultistep"  // Best for detailed artwork
                )
            )
        }

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

        _ = Date().timeIntervalSince(startTime) // Processing time tracked separately

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
        // Build highly detailed SDXL-optimized prompt based on user selections
        let designSpecificPrompt = buildDetailedDesignPrompt()
        let colorSpecificPrompt = buildColorSpecificPrompt() 
        let elementSpecificPrompt = buildElementSpecificPrompt()
        
        var positivePrompt = """
        CENTERPIECE SYMBOLS FIRST: \(elementSpecificPrompt),
        SUPPORTING STRUCTURE: subtle rakhi design around centerpiece, minimal thread bracelet, 
        DESIGN CONTEXT: \(designSpecificPrompt),
        COLORS: \(colorSpecificPrompt),
        (Hindu cultural symbols:1.4), (authentic Indian craftsmanship:1.1),
        spiritual significance, festival of Raksha Bandhan,
        (high quality photography:1.1), professional lighting, sharp details,
        traditional Indian art style, (masterpiece quality:1.2),
        ultra detailed, 8k resolution, photorealistic textures,
        intricate details, premium craftsmanship
        """

        var negativePrompt = """
        \(prompt.negative),
        AVOID RAKHI DOMINATION: (overwhelming rakhi structure:1.5), (dominant thread design:1.4), (oversized rakhi:1.4), (complex rakhi overwhelming symbols:1.3), busy rakhi design, elaborate rakhi structure, intricate rakhi patterns dominating center,
        AVOID CENTERPIECE FAILURES: (empty center:1.6), (blank centerpiece:1.5), (no central symbol:1.5), (missing Om symbol:1.4), (missing Ganesha:1.4), (invisible symbol:1.3), (faded center:1.3), (unclear centerpiece:1.3), plain center, bare centerpiece, symbol-free design, featureless center, hollow medallion, blank space center,
        AVOID INAPPROPRIATE SYMBOLS: cross, star of david, christian symbols, islamic symbols, crescent moon, buddhist symbols, western religious imagery, swastika symbol, nazi imagery, offensive symbols, 
        AVOID QUALITY ISSUES: (generic stock photo:1.3), (database image:1.2), pre-existing rakhi photo, western jewelry, modern watch, bracelet, plastic materials, mass produced,
        cartoon, anime, illustration, clipart, flat design,
        blurry, low quality, distorted, deformed, ugly, bad anatomy,
        extra limbs, missing parts, watermark, signature, text overlay,
        bad proportions, cloned elements, duplicate, cropped,
        out of frame, draft, worst quality, jpeg artifacts,
        wrong colors, dull colors, poor lighting, bad composition
        """

        // Clean up extra spaces and newlines
        positivePrompt = positivePrompt.replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "  ", with: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        negativePrompt = negativePrompt.replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "  ", with: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        // Debug logging for SDXL prompt accuracy
        print("🎨 SDXL PROMPT DEBUG:")
        print("📝 Positive: \(String(positivePrompt.prefix(200)))...")
        print("❌ Negative: \(String(negativePrompt.prefix(100)))...")

        return (positive: positivePrompt, negative: negativePrompt)
    }
    
    // Enhanced prompting for FLUX models - Professional Ganesh-quality artwork
    private func buildEnhancedCulturalPrompt(from prompt: AIPrompt) -> (positive: String, negative: String) {
        // Build highly specific design prompt based on exact user selections
        let designSpecificPrompt = buildDetailedDesignPrompt()
        let colorSpecificPrompt = buildColorSpecificPrompt()
        let elementSpecificPrompt = buildElementSpecificPrompt()
        
        var positivePrompt = """
        GENERATE AI ARTWORK: Professional 3D rendered Indian Rakhi bracelet, 
        EXACT SPECIFICATIONS: \(designSpecificPrompt),
        COLOR REQUIREMENTS: \(colorSpecificPrompt),
        ELEMENT DETAILS: \(elementSpecificPrompt),
        TECHNICAL QUALITY: hyper-detailed intricate craftsmanship, premium metallic finish,
        photorealistic texture detail, professional jewelry photography lighting,
        8K resolution, masterpiece artistry, gallery museum quality,
        CULTURAL AUTHENTICITY: traditional Indian craftsmanship, festival of Raksha Bandhan,
        sacred thread bracelet, ceremonial religious significance
        """

        var negativePrompt = """
        AVOID: generic stock photos, database images, pre-existing rakhi photos,
        non-AI generated content, western jewelry, modern watch, bracelet, 
        plastic materials, cheap appearance, mass produced look,
        inappropriate religious symbols, cross, star of david, crescent moon,
        christian symbols, islamic symbols, buddhist imagery,
        cartoon style, anime style, flat illustration, clipart,
        low quality, blurry, distorted, deformed, ugly anatomy,
        watermark, signature, text overlay, logo, copyright mark,
        duplicate elements, cropped design, out of frame,
        worst quality, jpeg artifacts, noise, grain,
        wrong colors, dull colors, flat lighting, poor composition
        """

        // Clean up extra spaces and newlines
        positivePrompt = positivePrompt.replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "  ", with: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        negativePrompt = negativePrompt.replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "  ", with: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        // Debug logging for prompt accuracy
        print("🎨 ENHANCED PROMPT DEBUG:")
        print("📝 Positive: \(String(positivePrompt.prefix(200)))...")
        print("❌ Negative: \(String(negativePrompt.prefix(100)))...")

        return (positive: positivePrompt, negative: negativePrompt)
    }

    private func submitReplicatePrediction(request: ReplicatePredictionRequest) async throws -> ReplicatePrediction {
        // Use robust API key loading
        let currentAPIKey = getCurrentAPIKey()
            
        let url = URL(string: "\(replicateBaseURL)/predictions")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Token \(currentAPIKey)", forHTTPHeaderField: "Authorization")
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
        // Use robust API key loading
        let currentAPIKey = getCurrentAPIKey()
            
        let url = URL(string: "\(replicateBaseURL)/predictions/\(id)")!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Token \(currentAPIKey)", forHTTPHeaderField: "Authorization")

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
    private func generateMockImage(prompt: AIPrompt, designSpec: RakhiDesignSpec?) async throws -> AIImageResult {
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
            imageData: createMockImageData(prompt: prompt, designSpec: designSpec),
            timestamp: Date(),
            prompt: prompt,
            metadata: metadata
        )
    }

    private func createMockImageData(prompt: AIPrompt? = nil, designSpec: RakhiDesignSpec? = nil) -> Data {
        // Create a personalized Rakhi design based on user selections
        let size = CGSize(width: 1024, height: 1024)
        let renderer = UIGraphicsImageRenderer(size: size)

        let image = renderer.image { context in
            let ctx = context.cgContext
            let center = CGPoint(x: 512, y: 512)

            // Get colors from user selection
            let userColors = getUserSelectedColors(designSpec: designSpec)
            let threadColor = userColors.thread
            let backgroundStyle = getUserBackgroundStyle(designSpec: designSpec)

            // Draw background based on genre
            drawBackground(ctx: ctx, center: center, style: backgroundStyle, colors: userColors)

            // Draw main rakhi structure based on user selections
            drawRakhiStructure(ctx: ctx, center: center, designSpec: designSpec, colors: userColors)

            // Draw threads based on user selections
            drawRakhiThreads(ctx: ctx, center: center, designSpec: designSpec, threadColor: threadColor)

            // Draw selected elements (beads, patterns, symbols)
            drawSelectedElements(ctx: ctx, center: center, designSpec: designSpec, colors: userColors)

            // Draw center piece based on genre and elements
            drawCenterPiece(ctx: ctx, center: center, designSpec: designSpec, colors: userColors)
        }

        return image.pngData() ?? Data()
    }

    // Helper structures and functions for personalized generation
    private struct RakhiColors {
        let primary: UIColor
        let accent: UIColor
        let thread: UIColor
        let background: UIColor
    }

    private func getUserSelectedColors(designSpec: RakhiDesignSpec?) -> RakhiColors {
        guard let designSpec = designSpec else {
            return RakhiColors(primary: .systemOrange, accent: .systemYellow, thread: .systemRed, background: .systemBackground)
        }

        // Convert SwiftUI colors to UIColors based on user's color palette
        let swiftUIColors = designSpec.colorPalette.colors
        let uiColors = swiftUIColors.map { UIColor($0) }

        return RakhiColors(
            primary: uiColors.first ?? .systemOrange,
            accent: uiColors.count > 1 ? uiColors[1] : .systemYellow,
            thread: uiColors.count > 2 ? uiColors[2] : .systemRed,
            background: .systemBackground
        )
    }

    private func getUserBackgroundStyle(designSpec: RakhiDesignSpec?) -> String {
        return designSpec?.genre.rawValue ?? "Traditional"
    }

    private func drawBackground(ctx: CGContext, center: CGPoint, style: String, colors: RakhiColors) {
        // Background varies by genre
        switch style.lowercased() {
        case "modern":
            // Clean gradient background
            let gradientColors = [colors.background.cgColor, colors.primary.withAlphaComponent(0.1).cgColor]
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let gradient = CGGradient(colorsSpace: colorSpace, colors: gradientColors as CFArray, locations: [0.0, 1.0])!
            ctx.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 1024, y: 1024), options: [])

        case "elegant":
            // Subtle radial gradient
            let gradientColors = [UIColor.systemBackground.cgColor, colors.primary.withAlphaComponent(0.05).cgColor]
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let gradient = CGGradient(colorsSpace: colorSpace, colors: gradientColors as CFArray, locations: [0.0, 1.0])!
            ctx.drawRadialGradient(gradient, startCenter: center, startRadius: 0, endCenter: center, endRadius: 700, options: [])

        case "spiritual":
            // Warm, peaceful background
            ctx.setFillColor(UIColor.systemBackground.cgColor)
            ctx.fill(CGRect(origin: .zero, size: CGSize(width: 1024, height: 1024)))
            // Add subtle lotus pattern
            drawLotusPetals(ctx: ctx, center: center, color: colors.primary.withAlphaComponent(0.03))

        default: // Traditional
            // Classic cream/white background with subtle texture
            ctx.setFillColor(UIColor.systemBackground.cgColor)
            ctx.fill(CGRect(origin: .zero, size: CGSize(width: 1024, height: 1024)))
        }
    }

    private func drawRakhiStructure(ctx: CGContext, center: CGPoint, designSpec: RakhiDesignSpec?, colors: RakhiColors) {
        let genre = designSpec?.genre ?? .traditional

        switch genre {
        case .modern:
            drawModernRakhiStructure(ctx: ctx, center: center, colors: colors)
        case .elegant:
            drawElegantRakhiStructure(ctx: ctx, center: center, colors: colors)
        case .spiritual:
            drawSpiritualRakhiStructure(ctx: ctx, center: center, colors: colors)
        default:
            drawTraditionalRakhiStructure(ctx: ctx, center: center, colors: colors)
        }
    }

    private func drawTraditionalRakhiStructure(ctx: CGContext, center: CGPoint, colors: RakhiColors) {
        // Traditional circular medallion
        ctx.setFillColor(colors.primary.cgColor)
        let outerCircle = CGRect(x: center.x - 90, y: center.y - 90, width: 180, height: 180)
        ctx.fillEllipse(in: outerCircle)

        // Inner decorative ring
        ctx.setFillColor(colors.accent.cgColor)
        let innerRing = CGRect(x: center.x - 70, y: center.y - 70, width: 140, height: 140)
        ctx.fillEllipse(in: innerRing)

        // Center medallion
        ctx.setFillColor(colors.primary.cgColor)
        let centerMedallion = CGRect(x: center.x - 45, y: center.y - 45, width: 90, height: 90)
        ctx.fillEllipse(in: centerMedallion)
    }

    private func drawModernRakhiStructure(ctx: CGContext, center: CGPoint, colors: RakhiColors) {
        // Modern hexagonal design
        drawHexagon(ctx: ctx, center: center, radius: 85, color: colors.primary)
        drawHexagon(ctx: ctx, center: center, radius: 65, color: colors.accent)
        drawHexagon(ctx: ctx, center: center, radius: 40, color: colors.primary)
    }

    private func drawElegantRakhiStructure(ctx: CGContext, center: CGPoint, colors: RakhiColors) {
        // Elegant flower-like design
        drawFlowerPetals(ctx: ctx, center: center, petalCount: 8, radius: 80, color: colors.primary)
        drawFlowerPetals(ctx: ctx, center: center, petalCount: 6, radius: 55, color: colors.accent)

        // Center circle
        ctx.setFillColor(colors.primary.cgColor)
        let centerCircle = CGRect(x: center.x - 30, y: center.y - 30, width: 60, height: 60)
        ctx.fillEllipse(in: centerCircle)
    }

    private func drawSpiritualRakhiStructure(ctx: CGContext, center: CGPoint, colors: RakhiColors) {
        // Spiritual lotus-inspired design
        drawLotusPetals(ctx: ctx, center: center, color: colors.primary)

        // Inner circle for Om symbol
        ctx.setFillColor(colors.accent.cgColor)
        let innerCircle = CGRect(x: center.x - 50, y: center.y - 50, width: 100, height: 100)
        ctx.fillEllipse(in: innerCircle)
    }

    private func drawRakhiThreads(ctx: CGContext, center: CGPoint, designSpec: RakhiDesignSpec?, threadColor: UIColor) {
        let elements = designSpec?.elements ?? []
        let threadWidth: CGFloat = elements.contains { $0.category == .thread } ? 15 : 12

        ctx.setStrokeColor(threadColor.cgColor)
        ctx.setLineWidth(threadWidth)
        ctx.setLineCap(.round)

        // Left thread
        ctx.move(to: CGPoint(x: center.x - 90, y: center.y))
        ctx.addLine(to: CGPoint(x: 150, y: center.y))
        ctx.strokePath()

        // Right thread
        ctx.move(to: CGPoint(x: center.x + 90, y: center.y))
        ctx.addLine(to: CGPoint(x: 874, y: center.y))
        ctx.strokePath()
    }

    private func drawSelectedElements(ctx: CGContext, center: CGPoint, designSpec: RakhiDesignSpec?, colors: RakhiColors) {
        guard let elements = designSpec?.elements else { return }

        for element in elements {
            switch element.category {
            case .beads:
                drawBeads(ctx: ctx, center: center, element: element, colors: colors)
            case .symbols:
                drawSymbol(ctx: ctx, center: center, element: element, colors: colors)
            case .patterns:
                drawPattern(ctx: ctx, center: center, element: element, colors: colors)
            case .decorativeElements:
                drawDecorativeElements(ctx: ctx, center: center, element: element, colors: colors)
            default:
                break
            }
        }
    }

    private func drawCenterPiece(ctx: CGContext, center: CGPoint, designSpec: RakhiDesignSpec?, colors: RakhiColors) {
        let genre = designSpec?.genre ?? .traditional

        // Add center symbol or text based on genre
        var symbolText = ""
        var symbolColor = UIColor.white

        switch genre {
        case .spiritual:
            symbolText = "ॐ" // Om symbol
            symbolColor = colors.primary
        case .traditional:
            symbolText = "श्री" // Sri symbol
            symbolColor = UIColor.white
        case .elegant:
            // No text, just decorative pattern
            drawCenterPattern(ctx: ctx, center: center, colors: colors)
            return
        case .modern:
            // Geometric symbol
            drawGeometricCenter(ctx: ctx, center: center, colors: colors)
            return
        default:
            symbolText = "🎊"
        }

        if !symbolText.isEmpty {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36, weight: .semibold),
                .foregroundColor: symbolColor
            ]
            let attributedText = NSAttributedString(string: symbolText, attributes: attributes)
            let textSize = attributedText.size()
            let textRect = CGRect(x: center.x - textSize.width/2, y: center.y - textSize.height/2,
                                width: textSize.width, height: textSize.height)
            attributedText.draw(in: textRect)
        }
    }

    // Helper drawing functions
    private func drawHexagon(ctx: CGContext, center: CGPoint, radius: CGFloat, color: UIColor) {
        ctx.setFillColor(color.cgColor)
        ctx.move(to: CGPoint(x: center.x + radius, y: center.y))

        for i in 1...6 {
            let angle = Double(i) * .pi / 3
            let x = center.x + cos(angle) * radius
            let y = center.y + sin(angle) * radius
            ctx.addLine(to: CGPoint(x: x, y: y))
        }

        ctx.closePath()
        ctx.fillPath()
    }

    private func drawFlowerPetals(ctx: CGContext, center: CGPoint, petalCount: Int, radius: CGFloat, color: UIColor) {
        ctx.setFillColor(color.cgColor)

        for i in 0..<petalCount {
            let angle = Double(i) * 2 * .pi / Double(petalCount)
            let petalX = center.x + cos(angle) * radius * 0.7
            let petalY = center.y + sin(angle) * radius * 0.7
            let petalSize: CGFloat = 25

            let petal = CGRect(x: petalX - petalSize/2, y: petalY - petalSize/2,
                             width: petalSize, height: petalSize)
            ctx.fillEllipse(in: petal)
        }
    }

    private func drawLotusPetals(ctx: CGContext, center: CGPoint, color: UIColor) {
        ctx.setFillColor(color.cgColor)

        // Draw lotus petals in layers
        for layer in 1...3 {
            let petalCount = layer * 6
            let radius = CGFloat(layer * 30 + 40)

            for i in 0..<petalCount {
                let angle = Double(i) * 2 * .pi / Double(petalCount)
                let petalX = center.x + cos(angle) * radius
                let petalY = center.y + sin(angle) * radius
                let petalSize: CGFloat = CGFloat(35 - layer * 5)

                let petal = CGRect(x: petalX - petalSize/2, y: petalY - petalSize/2,
                                 width: petalSize, height: petalSize)
                ctx.fillEllipse(in: petal)
            }
        }
    }

    private func drawBeads(ctx: CGContext, center: CGPoint, element: DesignElement, colors: RakhiColors) {
        // Draw beads along the threads
        let beadColor = element.displayName.contains("gold") ? UIColor.systemYellow : colors.accent
        ctx.setFillColor(beadColor.cgColor)

        let beadSize: CGFloat = 18
        let beadCount = 7

        for i in 0..<beadCount {
            // Left side beads
            let leftX = 200 + CGFloat(i * 45)
            let leftBead = CGRect(x: leftX - beadSize/2, y: center.y - beadSize/2, width: beadSize, height: beadSize)
            ctx.fillEllipse(in: leftBead)

            // Right side beads
            let rightX = 824 - CGFloat(i * 45)
            let rightBead = CGRect(x: rightX - beadSize/2, y: center.y - beadSize/2, width: beadSize, height: beadSize)
            ctx.fillEllipse(in: rightBead)
        }
    }

    private func drawSymbol(ctx: CGContext, center: CGPoint, element: DesignElement, colors: RakhiColors) {
        // Draw specific symbols based on element
        if element.displayName.contains("Om") || element.displayName.contains("om") {
            // Already handled in center piece
            return
        }
        // Add other symbol drawing logic here
    }

    private func drawPattern(ctx: CGContext, center: CGPoint, element: DesignElement, colors: RakhiColors) {
        // Draw patterns around the center
        ctx.setStrokeColor(colors.accent.withAlphaComponent(0.6).cgColor)
        ctx.setLineWidth(2)

        // Draw decorative lines around the center
        for i in 0..<8 {
            let angle = Double(i) * .pi / 4
            let startRadius: CGFloat = 60
            let endRadius: CGFloat = 85

            let startX = center.x + cos(angle) * startRadius
            let startY = center.y + sin(angle) * startRadius
            let endX = center.x + cos(angle) * endRadius
            let endY = center.y + sin(angle) * endRadius

            ctx.move(to: CGPoint(x: startX, y: startY))
            ctx.addLine(to: CGPoint(x: endX, y: endY))
            ctx.strokePath()
        }
    }

    private func drawDecorativeElements(ctx: CGContext, center: CGPoint, element: DesignElement, colors: RakhiColors) {
        // Add sparkles or decorative dots
        ctx.setFillColor(colors.accent.withAlphaComponent(0.8).cgColor)

        for i in 0..<12 {
            let angle = Double(i) * .pi / 6
            let radius: CGFloat = 120
            let dotX = center.x + cos(angle) * radius
            let dotY = center.y + sin(angle) * radius
            let dotSize: CGFloat = 6

            let dot = CGRect(x: dotX - dotSize/2, y: dotY - dotSize/2, width: dotSize, height: dotSize)
            ctx.fillEllipse(in: dot)
        }
    }

    private func drawCenterPattern(ctx: CGContext, center: CGPoint, colors: RakhiColors) {
        // Elegant center pattern
        ctx.setStrokeColor(UIColor.white.cgColor)
        ctx.setLineWidth(2)

        // Draw cross pattern
        ctx.move(to: CGPoint(x: center.x - 25, y: center.y - 25))
        ctx.addLine(to: CGPoint(x: center.x + 25, y: center.y + 25))
        ctx.move(to: CGPoint(x: center.x - 25, y: center.y + 25))
        ctx.addLine(to: CGPoint(x: center.x + 25, y: center.y - 25))
        ctx.strokePath()
    }

    private func drawGeometricCenter(ctx: CGContext, center: CGPoint, colors: RakhiColors) {
        // Modern geometric pattern
        ctx.setStrokeColor(UIColor.white.cgColor)
        ctx.setLineWidth(3)

        // Draw diamond shape
        ctx.move(to: CGPoint(x: center.x, y: center.y - 20))
        ctx.addLine(to: CGPoint(x: center.x + 20, y: center.y))
        ctx.addLine(to: CGPoint(x: center.x, y: center.y + 20))
        ctx.addLine(to: CGPoint(x: center.x - 20, y: center.y))
        ctx.closePath()
        ctx.strokePath()
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

    // Animation generation functions removed - app now uses static images only

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

struct AIPrompt: Codable, Hashable {
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

struct AIImageResult: Codable, Hashable {
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

struct GenerationMetadata: Codable, Hashable {
    let seed: Int
    let cfg_scale: Double
    let steps: Int
    let model: String
    let timestamp: Date
}

struct GeneratedRakhi: Identifiable, Codable, Hashable {
    let id: UUID
    let designSpec: RakhiDesignSpec
    let mainImage: AIImageResult
    let prompt: AIPrompt
    let createdAt: Date
    let culturalScore: Double
    let qualityScore: Double
}

// Animation-related structs removed - app now uses static images only

// AnimationType removed - app now uses static images only

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
    let negative_prompt: String?  // Optional for FLUX models
    let width: Int
    let height: Int
    let num_outputs: Int
    let guidance_scale: Double
    let num_inference_steps: Int
    let seed: Int?
    let scheduler: String?        // Optional for FLUX models
    let output_format: String?    // For FLUX models
    let output_quality: Int?      // For FLUX models
    
    // Convenience initializers for different model types
    init(prompt: String, negative_prompt: String, width: Int, height: Int, num_outputs: Int, 
         guidance_scale: Double, num_inference_steps: Int, seed: Int?, scheduler: String) {
        self.prompt = prompt
        self.negative_prompt = negative_prompt
        self.width = width
        self.height = height
        self.num_outputs = num_outputs
        self.guidance_scale = guidance_scale
        self.num_inference_steps = num_inference_steps
        self.seed = seed
        self.scheduler = scheduler
        self.output_format = nil
        self.output_quality = nil
    }
    
    init(prompt: String, width: Int, height: Int, num_outputs: Int, guidance_scale: Double,
         num_inference_steps: Int, seed: Int?, output_format: String, output_quality: Int) {
        self.prompt = prompt
        self.negative_prompt = nil
        self.width = width
        self.height = height
        self.num_outputs = num_outputs
        self.guidance_scale = guidance_scale
        self.num_inference_steps = num_inference_steps
        self.seed = seed
        self.scheduler = nil
        self.output_format = output_format
        self.output_quality = output_quality
    }
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

// MARK: - Detailed Design-Specific Prompt Building
extension AIRakhiService {
    
    // Build minimal design structure that doesn't compete with symbols
    private func buildDetailedDesignPrompt() -> String {
        guard let designSpec = currentDesignSpec else { return "minimal supporting structure" }
        
        var designPrompt = ""
        
        // Minimal structure that supports symbols without competing
        switch designSpec.genre {
        case .traditional:
            designPrompt = "subtle circular border frame, minimal decorative rings supporting centerpiece"
        case .modern:
            designPrompt = "clean minimal geometric frame, simple angular border supporting centerpiece"
        case .elegant:
            designPrompt = "delicate floral border frame, graceful curved frame supporting centerpiece"
        case .spiritual:
            designPrompt = "sacred geometry border frame, mandala-inspired minimal frame supporting centerpiece"
        default:
            designPrompt = "minimal supporting border frame"
        }
        
        return designPrompt
    }
    
    // Build specific color requirements
    private func buildColorSpecificPrompt() -> String {
        guard let designSpec = currentDesignSpec else { return "traditional red and gold colors" }
        
        let colors = designSpec.colorPalette.colors
        guard !colors.isEmpty else { return "traditional Indian festival colors" }
        
        var colorPrompt = "SPECIFIC COLOR PALETTE: "
        
        // Convert SwiftUI colors to descriptive terms for AI
        for (index, color) in colors.enumerated() {
            let colorDescription = describeColorForAI(color)
            switch index {
            case 0:
                colorPrompt += "PRIMARY COLOR: \(colorDescription) dominates the main structure, "
            case 1:
                colorPrompt += "ACCENT COLOR: \(colorDescription) highlights decorative elements, "
            case 2:
                colorPrompt += "THREAD COLOR: \(colorDescription) for the connecting threads, "
            default:
                colorPrompt += "ADDITIONAL: \(colorDescription), "
            }
        }
        
        return colorPrompt
    }
    
    // Build element-specific detailed requirements with symbol-first prioritization
    private func buildElementSpecificPrompt() -> String {
        guard let designSpec = currentDesignSpec else { return "basic rakhi elements" }
        
        var elementPrompt = ""
        var hasSymbols = false
        
        // CRITICAL: Process symbols FIRST to ensure prominence
        for element in designSpec.elements where element.category == .symbols {
            hasSymbols = true
            if element.displayName.contains("Om") || element.displayName.contains("om") {
                elementPrompt += "MANDATORY CENTERPIECE: (high-resolution intricate Hindu Om ॐ symbol:1.6), (centered golden glowing Om:1.5), (divine golden aura Om symbol:1.5), (clean symmetrical spiritual Om ॐ:1.4), (luminous gradients saffron gold Om:1.4), (sacred elegant Om symbol:1.4), (fine ornamental detailing Om:1.3), (subtle mandala pattern around Om:1.3), (photorealistic textures Om:1.3), (modern artistic finish Om:1.3), (crystal-clear edges Om ॐ:1.3), (8K quality highly detailed Om:1.2), (decorative Rakhi centered Om symbol:1.2), "
            } else if element.displayName.contains("Ganesha") || element.displayName.contains("ganesha") || element.displayName.contains("Ganesh") {
                elementPrompt += "MANDATORY CENTERPIECE: (beautifully detailed Lord Ganesha:1.6), (seated gracefully Ganesha:1.5), (serene expression Ganesha:1.5), (elephant head ornate crown Ganesha:1.4), (gentle smile Ganesha:1.4), (rich ornaments saffron clothing Ganesha:1.4), (radiating divine light Ganesha:1.3), (classical Indian miniature painting Ganesha:1.3), (modern digital art Ganesha:1.3), (vibrant saffron gold deep red Ganesha:1.3), (sharp detailing Ganesha:1.3), (soft golden aura Ganesha:1.3), (symmetrical majestic spiritual Ganesha:1.2), (8K resolution photorealistic Ganesha:1.2), (decorative Rakhi Ganesha:1.2), "
            } else if element.displayName.contains("Swastika") || element.displayName.contains("swastika") {
                // Replace with enhanced Om symbol for better generation
                elementPrompt += "MANDATORY CENTERPIECE: (high-resolution intricate Hindu Om ॐ symbol:1.6), (centered golden glowing Om:1.5), (divine golden aura Om symbol:1.5), (clean symmetrical spiritual Om ॐ:1.4), (luminous gradients saffron gold Om:1.4), (sacred elegant Om symbol:1.4), "
            } else {
                elementPrompt += "CENTERPIECE SYMBOL: (\(element.displayName):1.3), Hindu sacred symbol, (religious iconography:1.2), traditional cultural symbol, "
            }
        }
        
        // Add default centerpiece if no symbols specified
        if !hasSymbols {
            elementPrompt += "CENTERPIECE: (traditional Hindu symbol:1.2), sacred rakhi center medallion, "
        }
        
        // Add other elements with less weight to avoid competition
        for element in designSpec.elements where element.category != .symbols {
            switch element.category {
            case .beads:
                elementPrompt += "beadwork: \(element.displayName) beading, bead patterns, "
            case .patterns:
                elementPrompt += "patterns: \(element.displayName) motifs, decorative work, "
            case .decorativeElements:
                elementPrompt += "decoration: \(element.displayName) embellishments, "
            case .thread:
                elementPrompt += "thread: \(element.displayName) threading, "
            default:
                elementPrompt += "\(element.displayName) elements, "
            }
        }
        
        return elementPrompt
    }
    
    // Convert SwiftUI Color to descriptive AI prompt terms
    private func describeColorForAI(_ color: Color) -> String {
        // This is a simplified color description - in a production app, you'd want more sophisticated color analysis
        // For now, using common color names that AI models understand well
        
        // Convert to UIColor to get RGB components (simplified approach)
        let uiColor = UIColor(color)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // Determine primary color characteristics
        if red > 0.8 && green < 0.3 && blue < 0.3 {
            return "vibrant red"
        } else if red > 0.8 && green > 0.6 && blue < 0.3 {
            return "golden yellow"
        } else if red < 0.3 && green > 0.6 && blue < 0.3 {
            return "emerald green"
        } else if red < 0.3 && green < 0.3 && blue > 0.8 {
            return "royal blue"
        } else if red > 0.6 && green < 0.6 && blue > 0.6 {
            return "purple"
        } else if red > 0.8 && green > 0.4 && blue > 0.8 {
            return "pink"
        } else if red > 0.6 && green > 0.3 && blue < 0.2 {
            return "orange"
        } else if red < 0.2 && green < 0.2 && blue < 0.2 {
            return "deep black"
        } else if red > 0.9 && green > 0.9 && blue > 0.9 {
            return "pure white"
        } else {
            return "rich traditional color"
        }
    }
}

// MARK: - API Key Management
extension AIRakhiService {
    // Enhanced API key retrieval with automatic reloading and validation
    private func getCurrentAPIKey() -> String {
        // Method 1: Use cached key if available and valid
        if !replicateAPIKey.isEmpty && isValidAPIKey(replicateAPIKey) {
            return replicateAPIKey
        }
        
        // Method 2: Key is empty or invalid, try to reload from all sources
        print("⚠️ API key empty or invalid, attempting reload...")
        loadAPIKeysWithPersistence()
        
        // Method 3: Check if reload was successful
        if !replicateAPIKey.isEmpty && isValidAPIKey(replicateAPIKey) {
            print("✅ API key reloaded successfully")
            return replicateAPIKey
        }
        
        // Method 4: Last resort - try fresh environment read
        if let envKey = ProcessInfo.processInfo.environment["REPLICATE_API_TOKEN"], 
           !envKey.isEmpty, isValidAPIKey(envKey) {
            print("✅ API key recovered from environment")
            self.replicateAPIKey = envKey
            saveToKeychain(key: "replicate_api_key", value: envKey)
            return envKey
        }
        
        print("❌ CRITICAL: Unable to recover valid API key from any source")
        return ""
    }
    
    // Validate API key format
    private func isValidAPIKey(_ key: String) -> Bool {
        // Replicate API keys start with "r8_" and are typically 40+ characters
        return key.hasPrefix("r8_") && key.count >= 20
    }
    
    // Public method to manually refresh API keys (useful for testing)
    public func refreshAPIKeys() {
        print("🔄 Manually refreshing API keys...")
        loadAPIKeysWithPersistence()
    }
    
    // Public method to check API key status
    public func getAPIKeyStatus() -> (isValid: Bool, keyPrefix: String, source: String) {
        let isValid = !replicateAPIKey.isEmpty && isValidAPIKey(replicateAPIKey)
        let keyPrefix = replicateAPIKey.isEmpty ? "None" : String(replicateAPIKey.prefix(8)) + "..."
        
        var source = "Unknown"
        if !replicateAPIKey.isEmpty {
            if loadFromKeychain(key: "replicate_api_key") != nil {
                source = "Keychain"
            } else if ProcessInfo.processInfo.environment["REPLICATE_API_TOKEN"] != nil {
                source = "Environment"
            } else {
                source = "Bundle"
            }
        }
        
        return (isValid: isValid, keyPrefix: keyPrefix, source: source)
    }
}
