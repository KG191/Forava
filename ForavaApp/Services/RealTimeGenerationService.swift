import Foundation
import SwiftUI
import Combine

// MARK: - Real-time Image Generation Service

@MainActor
class RealTimeGenerationService: ObservableObject {
    static let shared = RealTimeGenerationService()
    
    @Published var currentGenerationStatus: GenerationStatus = .idle
    @Published var realTimeProgress: GenerationProgress?
    @Published var qualityMetrics: QualityMetrics?
    @Published var estimatedTimeRemaining: TimeInterval = 0
    
    private var progressStream: URLSessionWebSocketTask?
    private var cancellables = Set<AnyCancellable>()
    private var generationStartTime: Date?
    
    private init() {}
    
    // MARK: - Public Interface
    
    func startRealTimeGeneration(with prompt: AdvancedPrompt, designSpec: RakhiDesignSpec) async throws -> AsyncThrowingStream<GenerationUpdate, Error> {
        currentGenerationStatus = .connecting
        generationStartTime = Date()
        
        return AsyncThrowingStream { continuation in
            Task {
                do {
                    try await self.initiateRealTimeGeneration(
                        prompt: prompt,
                        designSpec: designSpec,
                        continuation: continuation
                    )
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
    
    private func initiateRealTimeGeneration(
        prompt: AdvancedPrompt,
        designSpec: RakhiDesignSpec,
        continuation: AsyncThrowingStream<GenerationUpdate, Error>.Continuation
    ) async throws {
        
        // 1. Establish WebSocket connection for real-time updates
        try await establishProgressStream(continuation: continuation)
        
        // 2. Submit generation request with streaming enabled
        let streamingRequest = StreamingGenerationRequest(
            prompt: prompt,
            designSpec: designSpec,
            streamingEnabled: true,
            qualityPreference: determineQualityPreference(designSpec),
            progressCallbackURL: getProgressWebSocketURL()
        )
        
        currentGenerationStatus = .submitting
        continuation.yield(.statusUpdate(.submitting))
        
        // 3. Submit to generation queue
        try await submitStreamingRequest(streamingRequest)
        
        currentGenerationStatus = .processing
        continuation.yield(.statusUpdate(.processing))
        
        // 4. Monitor progress and provide real-time updates
        await monitorGenerationProgress(continuation: continuation)
    }
    
    private func establishProgressStream(
        continuation: AsyncThrowingStream<GenerationUpdate, Error>.Continuation
    ) async throws {
        
        guard let url = URL(string: "wss://api.forava.ai/v1/generation/stream") else {
            throw RealTimeGenerationError.invalidStreamURL
        }
        
        let urlSession = URLSession(configuration: .default)
        progressStream = urlSession.webSocketTask(with: url)
        
        // Set up message receiving
        startReceivingMessages(continuation: continuation)
        
        progressStream?.resume()
        
        // Wait for connection to be established
        try await waitForConnection()
    }
    
    private func startReceivingMessages(
        continuation: AsyncThrowingStream<GenerationUpdate, Error>.Continuation
    ) {
        guard let stream = progressStream else { return }
        
        stream.receive { [weak self] result in
            Task { @MainActor in
                switch result {
                case .success(let message):
                    await self?.handleStreamMessage(message, continuation: continuation)
                    // Continue receiving
                    self?.startReceivingMessages(continuation: continuation)
                    
                case .failure(let error):
                    continuation.finish(throwing: RealTimeGenerationError.streamError(error))
                }
            }
        }
    }
    
    private func handleStreamMessage(
        _ message: URLSessionWebSocketTask.Message,
        continuation: AsyncThrowingStream<GenerationUpdate, Error>.Continuation
    ) async {
        
        switch message {
        case .string(let text):
            do {
                let update = try JSONDecoder().decode(GenerationProgressUpdate.self, from: Data(text.utf8))
                await processProgressUpdate(update, continuation: continuation)
            } catch {
                print("Failed to decode progress update: \(error)")
            }
            
        case .data(let data):
            do {
                let update = try JSONDecoder().decode(GenerationProgressUpdate.self, from: data)
                await processProgressUpdate(update, continuation: continuation)
            } catch {
                print("Failed to decode binary progress update: \(error)")
            }
            
        @unknown default:
            print("Unknown WebSocket message type received")
        }
    }
    
    private func processProgressUpdate(
        _ update: GenerationProgressUpdate,
        continuation: AsyncThrowingStream<GenerationUpdate, Error>.Continuation
    ) async {
        
        // Update internal state
        realTimeProgress = GenerationProgress(
            stage: update.stage,
            progress: update.progress,
            currentStep: update.currentStep,
            totalSteps: update.totalSteps,
            timestamp: Date()
        )
        
        // Calculate time remaining
        if let startTime = generationStartTime {
            let elapsed = Date().timeIntervalSince(startTime)
            let progressRatio = Double(update.progress)
            
            if progressRatio > 0 {
                estimatedTimeRemaining = (elapsed / progressRatio) - elapsed
            }
        }
        
        // Update quality metrics if available
        if let metrics = update.qualityMetrics {
            qualityMetrics = QualityMetrics(
                culturalAuthenticity: metrics.culturalAuthenticity,
                visualQuality: metrics.visualQuality,
                elementCoherence: metrics.elementCoherence,
                overallScore: metrics.overallScore
            )
        }
        
        // Yield update to stream
        continuation.yield(.progressUpdate(realTimeProgress!))
        
        // Handle completion
        if update.stage == .completed {
            if let result = update.result {
                continuation.yield(.completed(result))
            }
            continuation.finish()
            await cleanup()
        } else if update.stage == .failed {
            let error = RealTimeGenerationError.generationFailed(update.error ?? "Unknown error")
            continuation.finish(throwing: error)
            await cleanup()
        }
    }
    
    private func submitStreamingRequest(_ request: StreamingGenerationRequest) async throws {
        guard let url = URL(string: "https://api.forava.ai/v1/generation/stream-submit") else {
            throw RealTimeGenerationError.invalidEndpoint
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(getAPIKey())", forHTTPHeaderField: "Authorization")
        
        urlRequest.httpBody = try JSONEncoder().encode(request)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw RealTimeGenerationError.submissionFailed
        }
        
        let submissionResponse = try JSONDecoder().decode(GenerationSubmissionResponse.self, from: data)
        print("Generation submitted with ID: \(submissionResponse.generationId)")
    }
    
    private func monitorGenerationProgress(
        continuation: AsyncThrowingStream<GenerationUpdate, Error>.Continuation
    ) async {
        // Progress monitoring is handled by WebSocket messages
        // This method can be used for fallback polling if WebSocket fails
    }
    
    private func waitForConnection() async throws {
        // Simple connection wait - in production, this would be more sophisticated
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
    }
    
    private func cleanup() async {
        progressStream?.cancel(with: .goingAway, reason: nil)
        progressStream = nil
        currentGenerationStatus = .idle
        generationStartTime = nil
    }
    
    private func determineQualityPreference(_ designSpec: RakhiDesignSpec) -> QualityPreference {
        let culturalComplexity = designSpec.elements.map { $0.culturalSignificance }.reduce(0, +) / Double(max(designSpec.elements.count, 1))
        let elementCount = designSpec.elements.count
        
        if culturalComplexity > 0.8 || elementCount > 5 {
            return .ultra
        } else if culturalComplexity > 0.6 || elementCount > 3 {
            return .high
        } else {
            return .standard
        }
    }
    
    private func getProgressWebSocketURL() -> String {
        return "wss://api.forava.ai/v1/generation/stream"
    }
    
    private func getAPIKey() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "FORAVA_API_KEY") as? String ?? ""
    }
    
    // MARK: - Public Utilities
    
    func cancelGeneration() async {
        await cleanup()
        currentGenerationStatus = .cancelled
    }
    
    func getEstimatedCost(for designSpec: RakhiDesignSpec) -> GenerationCost {
        let basePrice = 0.10 // Base cost in USD
        let culturalComplexity = designSpec.elements.map { $0.culturalSignificance }.reduce(0, +) / Double(max(designSpec.elements.count, 1))
        
        let complexityMultiplier = 1.0 + (culturalComplexity * 0.5)
        let elementMultiplier = 1.0 + (Double(designSpec.elements.count) * 0.1)
        
        let totalCost = basePrice * complexityMultiplier * elementMultiplier
        
        return GenerationCost(
            basePrice: basePrice,
            complexityAdjustment: complexityMultiplier - 1.0,
            totalCost: totalCost,
            currency: "USD"
        )
    }
}

// MARK: - Supporting Types

enum GenerationStatus {
    case idle
    case connecting
    case submitting
    case processing
    case completed
    case failed
    case cancelled
    
    var displayName: String {
        switch self {
        case .idle: return "Ready"
        case .connecting: return "Connecting"
        case .submitting: return "Submitting"
        case .processing: return "Processing"
        case .completed: return "Completed"
        case .failed: return "Failed"
        case .cancelled: return "Cancelled"
        }
    }
    
    var color: Color {
        switch self {
        case .idle: return .gray
        case .connecting, .submitting: return .blue
        case .processing: return .orange
        case .completed: return .green
        case .failed: return .red
        case .cancelled: return .gray
        }
    }
}

struct GenerationProgress {
    let stage: GenerationStage
    let progress: Float // 0.0 to 1.0
    let currentStep: String
    let totalSteps: Int
    let timestamp: Date
}

enum GenerationStage: String, Codable {
    case initializing = "initializing"
    case promptProcessing = "prompt_processing"
    case modelLoading = "model_loading"
    case imageGeneration = "image_generation"
    case qualityEnhancement = "quality_enhancement"
    case animationGeneration = "animation_generation"
    case finalProcessing = "final_processing"
    case completed = "completed"
    case failed = "failed"
    
    var displayName: String {
        switch self {
        case .initializing: return "Initializing"
        case .promptProcessing: return "Processing Prompt"
        case .modelLoading: return "Loading AI Models"
        case .imageGeneration: return "Generating Image"
        case .qualityEnhancement: return "Enhancing Quality"
        case .animationGeneration: return "Creating Animation"
        case .finalProcessing: return "Final Processing"
        case .completed: return "Completed"
        case .failed: return "Failed"
        }
    }
}

enum GenerationUpdate {
    case statusUpdate(GenerationStatus)
    case progressUpdate(GenerationProgress)
    case completed(GeneratedRakhi)
}

struct StreamingGenerationRequest: Codable {
    let prompt: AdvancedPrompt
    let designSpec: RakhiDesignSpec
    let streamingEnabled: Bool
    let qualityPreference: QualityPreference
    let progressCallbackURL: String
}

enum QualityPreference: String, Codable {
    case standard = "standard"
    case high = "high"
    case ultra = "ultra"
    
    var processingTime: TimeInterval {
        switch self {
        case .standard: return 15.0
        case .high: return 25.0
        case .ultra: return 45.0
        }
    }
}

struct GenerationProgressUpdate: Codable {
    let stage: GenerationStage
    let progress: Float
    let currentStep: String
    let totalSteps: Int
    let qualityMetrics: QualityMetricsUpdate?
    let result: GeneratedRakhi?
    let error: String?
}

struct QualityMetricsUpdate: Codable {
    let culturalAuthenticity: Double
    let visualQuality: Double
    let elementCoherence: Double
    let overallScore: Double
}

struct QualityMetrics {
    let culturalAuthenticity: Double
    let visualQuality: Double
    let elementCoherence: Double
    let overallScore: Double
    
    var grade: String {
        switch overallScore {
        case 0.9...: return "A+"
        case 0.8..<0.9: return "A"
        case 0.7..<0.8: return "B+"
        case 0.6..<0.7: return "B"
        default: return "C"
        }
    }
    
    var color: Color {
        switch overallScore {
        case 0.8...: return .green
        case 0.6..<0.8: return .orange
        default: return .red
        }
    }
}

struct GenerationSubmissionResponse: Codable {
    let generationId: String
    let estimatedCompletionTime: TimeInterval
    let queuePosition: Int?
}

struct GenerationCost {
    let basePrice: Double
    let complexityAdjustment: Double
    let totalCost: Double
    let currency: String
    
    var formattedCost: String {
        return String(format: "$%.2f %@", totalCost, currency)
    }
}

enum RealTimeGenerationError: LocalizedError {
    case invalidStreamURL
    case invalidEndpoint
    case streamError(Error)
    case submissionFailed
    case generationFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidStreamURL:
            return "Invalid streaming URL"
        case .invalidEndpoint:
            return "Invalid API endpoint"
        case .streamError(let error):
            return "Stream error: \(error.localizedDescription)"
        case .submissionFailed:
            return "Failed to submit generation request"
        case .generationFailed(let message):
            return "Generation failed: \(message)"
        }
    }
}