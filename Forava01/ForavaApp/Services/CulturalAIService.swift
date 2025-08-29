import Foundation
import SwiftUI
import Combine

// MARK: - Cultural AI Generation Service

@MainActor
class CulturalAIService: ObservableObject {
    static let shared = CulturalAIService()
    
    @Published var isGenerating = false
    @Published var generationProgress: Float = 0.0
    @Published var generatedGift: GeneratedCulturalGift?
    @Published var error: AIServiceError?
    @Published var currentContext: CulturalContext = .rakhi
    
    private let culturalContextManager = CulturalContextManager.shared
    private let aiRakhiService = AIRakhiService.shared
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        // Subscribe to cultural context changes
        culturalContextManager.$currentCulturalContext
            .receive(on: DispatchQueue.main)
            .sink { [weak self] context in
                self?.currentContext = context
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Cultural Gift Generation
    
    func generateCulturalGift(from spec: CulturalGiftSpec) async throws -> GeneratedCulturalGift {
        isGenerating = true
        generationProgress = 0.0
        error = nil
        
        do {
            let gift = try await performCulturalGeneration(spec: spec)
            
            await MainActor.run {
                self.generatedGift = gift
                self.generationProgress = 1.0
                self.isGenerating = false
            }
            
            return gift
            
        } catch {
            await MainActor.run {
                self.error = error as? AIServiceError ?? .generationFailed
                self.isGenerating = false
                self.generationProgress = 0.0
            }
            throw error
        }
    }
    
    private func performCulturalGeneration(spec: CulturalGiftSpec) async throws -> GeneratedCulturalGift {
        // Update progress
        await MainActor.run { self.generationProgress = 0.2 }
        
        switch spec.culturalContext {
        case .rakhi:
            // Use existing Rakhi service for backward compatibility
            return try await generateRakhiCompatible(spec: spec)
            
        case .chineseNewYear:
            return try await generateChineseNewYear(spec: spec)
            
        case .christmas, .diwali, .eid, .hanukkah, .vesak:
            // Placeholder for future cultural contexts
            throw AIServiceError.contextNotSupported
        }
    }
    
    // MARK: - Rakhi Backward Compatibility
    
    private func generateRakhiCompatible(spec: CulturalGiftSpec) async throws -> GeneratedCulturalGift {
        // Convert CulturalGiftSpec to RakhiDesignSpec
        let rakhiSpec = convertToRakhiSpec(spec)
        
        // Update progress
        await MainActor.run { self.generationProgress = 0.4 }
        
        // Generate using existing service
        let generatedRakhi = try await aiRakhiService.generateRakhi(from: rakhiSpec)
        
        // Update progress
        await MainActor.run { self.generationProgress = 0.8 }
        
        // Convert back to cultural gift
        let culturalGift = CulturalGift.fromRakhi(generatedRakhi.baseRakhi)
        
        return GeneratedCulturalGift(
            id: UUID(),
            baseCulturalGift: culturalGift,
            prompt: generateCulturalPrompt(for: spec),
            imageURL: generatedRakhi.imageURL,
            culturalScore: calculateCulturalScore(for: spec),
            generationMetadata: GenerationMetadata(
                model: "SDXL",
                processingTime: generatedRakhi.generationMetadata.processingTime,
                culturalContext: spec.culturalContext,
                qualityScore: generatedRakhi.generationMetadata.qualityScore
            )
        )
    }
    
    // MARK: - Chinese New Year Generation
    
    private func generateChineseNewYear(spec: CulturalGiftSpec) async throws -> GeneratedCulturalGift {
        await MainActor.run { self.generationProgress = 0.3 }
        
        let prompt = generateChineseNewYearPrompt(for: spec)
        
        // Mock implementation for now - will integrate with actual AI service
        await MainActor.run { self.generationProgress = 0.6 }
        
        // Simulate processing time
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        
        await MainActor.run { self.generationProgress = 0.9 }
        
        let culturalGift = CulturalGift(
            culturalContext: .chineseNewYear,
            name: spec.name.isEmpty ? "Generated Chinese New Year Card" : spec.name,
            imageName: "generated_chinese_\(UUID().uuidString)",
            description: "AI-generated Chinese New Year design with \(spec.elements.joined(separator: ", "))",
            price: 30.0,
            category: spec.category,
            colors: spec.colorPalette,
            culturalScore: calculateCulturalScore(for: spec)
        )
        
        return GeneratedCulturalGift(
            id: UUID(),
            baseCulturalGift: culturalGift,
            prompt: prompt,
            imageURL: URL(string: "https://example.com/generated-chinese-new-year.jpg"), // Mock URL
            culturalScore: calculateCulturalScore(for: spec),
            generationMetadata: GenerationMetadata(
                model: "SDXL-Cultural",
                processingTime: 15.2,
                culturalContext: .chineseNewYear,
                qualityScore: 0.92
            )
        )
    }
    
    // MARK: - Cultural Prompt Generation
    
    private func generateCulturalPrompt(for spec: CulturalGiftSpec) -> String {
        switch spec.culturalContext {
        case .rakhi:
            return generateRakhiPrompt(for: spec)
        case .chineseNewYear:
            return generateChineseNewYearPrompt(for: spec)
        default:
            return "Cultural gift design"
        }
    }
    
    private func generateRakhiPrompt(for spec: CulturalGiftSpec) -> String {
        let basePrompt = "Traditional Indian Rakhi bracelet, sacred brother-sister bond"
        let elements = spec.elements.joined(separator: ", ")
        let colors = spec.colorPalette.joined(separator: ", ")
        
        return "\(basePrompt), featuring \(elements), color palette: \(colors), high quality, detailed, authentic Indian cultural design"
    }
    
    private func generateChineseNewYearPrompt(for spec: CulturalGiftSpec) -> String {
        let basePrompt = "Chinese New Year greeting card design, traditional festive celebration"
        let elements = spec.elements.joined(separator: ", ")
        let colors = spec.colorPalette.joined(separator: ", ")
        
        return "\(basePrompt), featuring \(elements), color palette: \(colors), auspicious symbols, prosperity and good fortune, high quality, detailed, authentic Chinese cultural design"
    }
    
    // MARK: - Conversion Utilities
    
    private func convertToRakhiSpec(_ spec: CulturalGiftSpec) -> RakhiDesignSpec {
        let genre: RakhiGenre
        switch spec.category {
        case .traditional: genre = .traditional
        case .modern: genre = .modern
        case .elegant: genre = .elegant
        case .spiritual: genre = .spiritual
        default: genre = .traditional
        }
        
        return RakhiDesignSpec(
            genre: genre,
            elements: spec.elements,
            colorPalette: .custom(spec.colorPalette),
            personalization: spec.personalization
        )
    }
    
    private func calculateCulturalScore(for spec: CulturalGiftSpec) -> Double {
        var score: Double = 0.8 // Base score
        
        // Boost score for traditional elements
        if spec.category == .traditional {
            score += 0.1
        }
        
        // Boost score for spiritual/symbolic elements
        if spec.category == .spiritual || spec.category == .symbolic {
            score += 0.05
        }
        
        // Boost score for cultural-specific elements
        let contextBoost = spec.elements.contains { element in
            switch spec.culturalContext {
            case .rakhi:
                return ["om", "lotus", "thread", "bond"].contains(element.lowercased())
            case .chineseNewYear:
                return ["dragon", "phoenix", "bamboo", "prosperity", "fortune"].contains(element.lowercased())
            default:
                return false
            }
        }
        
        if contextBoost {
            score += 0.1
        }
        
        return min(score, 1.0)
    }
}

// MARK: - Cultural Gift Specification

struct CulturalGiftSpec {
    let culturalContext: CulturalContext
    let category: GiftCategory
    let elements: [String]
    let colorPalette: [String]
    let name: String
    let personalization: String
    
    init(culturalContext: CulturalContext, category: GiftCategory, elements: [String], colorPalette: [String], name: String = "", personalization: String = "") {
        self.culturalContext = culturalContext
        self.category = category
        self.elements = elements
        self.colorPalette = colorPalette
        self.name = name
        self.personalization = personalization
    }
}

// MARK: - Generated Cultural Gift

struct GeneratedCulturalGift: Identifiable, Codable {
    let id: UUID
    let baseCulturalGift: CulturalGift
    let prompt: String
    let imageURL: URL?
    let culturalScore: Double
    let generationMetadata: GenerationMetadata
    
    // Backward compatibility
    func toGeneratedRakhi() -> GeneratedRakhi {
        return GeneratedRakhi(
            id: id,
            baseRakhi: baseCulturalGift.toRakhi(),
            prompt: prompt,
            imageURL: imageURL,
            generationMetadata: RakhiGenerationMetadata(
                model: generationMetadata.model,
                processingTime: generationMetadata.processingTime,
                qualityScore: generationMetadata.qualityScore,
                timestamp: Date()
            )
        )
    }
}

// MARK: - Generation Metadata

struct GenerationMetadata: Codable {
    let model: String
    let processingTime: Double
    let culturalContext: CulturalContext
    let qualityScore: Double
    let timestamp: Date
    
    init(model: String, processingTime: Double, culturalContext: CulturalContext, qualityScore: Double) {
        self.model = model
        self.processingTime = processingTime
        self.culturalContext = culturalContext
        self.qualityScore = qualityScore
        self.timestamp = Date()
    }
}