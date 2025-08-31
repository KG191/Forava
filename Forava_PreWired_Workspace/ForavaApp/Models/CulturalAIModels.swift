import Foundation
import SwiftUI

// MARK: - Cultural Generated Artwork
struct CulturalGeneratedArtwork: Identifiable, Codable {
    let id: UUID
    let designSpec: CulturalDesignSpec
    let culturalContext: String
    let mainImage: CulturalImageResult
    let animationFrames: [CulturalAnimationFrame]
    let qualityScore: Double
    let culturalScore: Double
    let generatedAt: Date
    let metadata: CulturalGenerationMetadata

    var displayName: String {
        return "\(designSpec.genre.displayName) \(culturalContext.capitalized) Art"
    }

    var culturalContextDisplayName: String {
        if let context = CulturalContextManager.shared.getContext(for: culturalContext) {
            return context.displayName
        }
        return culturalContext.capitalized
    }
}

// MARK: - Cultural Image Result
struct CulturalImageResult: Codable {
    let imageData: Data
    let width: Int
    let height: Int
    let format: String
    let qualityScore: Double
    let seed: Int
    let model: String
    let culturalContext: String

    var image: UIImage? {
        return UIImage(data: imageData)
    }

    var swiftUIImage: Image? {
        guard let uiImage = image else { return nil }
        return Image(uiImage: uiImage)
    }
}

// MARK: - Cultural Animation Frame
struct CulturalAnimationFrame: Codable {
    let timestamp: Double
    let culturalContext: String
    var effectTemplates: [AnimationEffectTemplate]

    init(timestamp: Double, culturalContext: String, effectTemplates: [AnimationEffectTemplate] = []) {
        self.timestamp = timestamp
        self.culturalContext = culturalContext
        self.effectTemplates = effectTemplates
    }
}

// MARK: - Cultural Generation Metadata
struct CulturalGenerationMetadata: Codable {
    let culturalContext: String
    let model: String
    let prompt: String
    let negativePrompt: String
    let culturalEnhancers: [String]
    let steps: Int
    let cfgScale: Double
    let seed: Int
    let generatedAt: Date

    init(
        culturalContext: String,
        model: String,
        prompt: String,
        negativePrompt: String,
        culturalEnhancers: [String] = [],
        steps: Int = 30,
        cfgScale: Double = 7.5,
        seed: Int,
        generatedAt: Date = Date()
    ) {
        self.culturalContext = culturalContext
        self.model = model
        self.prompt = prompt
        self.negativePrompt = negativePrompt
        self.culturalEnhancers = culturalEnhancers
        self.steps = steps
        self.cfgScale = cfgScale
        self.seed = seed
        self.generatedAt = generatedAt
    }
}

// MARK: - Cultural Prompt
struct CulturalPrompt: Codable {
    let positive: String
    let negative: String
    let culturalContext: String
    let culturalEnhancers: [String]
    let steps: Int
    let cfgScale: Double
    let seed: Int

    init(
        positive: String,
        negative: String,
        culturalContext: String,
        culturalEnhancers: [String] = [],
        steps: Int = 30,
        cfgScale: Double = 7.5,
        seed: Int = -1
    ) {
        self.positive = positive
        self.negative = negative
        self.culturalContext = culturalContext
        self.culturalEnhancers = culturalEnhancers
        self.steps = steps
        self.cfgScale = cfgScale
        self.seed = seed
    }
}

// MARK: - Cultural Animation Effects
// Note: Uses AnimationEffect protocol from AnimationModels.swift to avoid duplicates
typealias CulturalAnimationEffect = AnimationEffect

// Cultural-specific animation effects using the core animation system
struct CulturalSparkleEffect: AnimationEffect {
    public let id = UUID()
    let sparkleIntensity: Double
    let culturalContext: String

    init(intensity: Double, culturalContext: String = "universal") {
        self.sparkleIntensity = intensity
        self.culturalContext = culturalContext
    }
}

struct CulturalBlessingEffect: AnimationEffect {
    public let id = UUID()
    let blessingIntensity: Double
    let culturalContext: String

    init(intensity: Double, culturalContext: String = "universal") {
        self.blessingIntensity = intensity
        self.culturalContext = culturalContext
    }
}

// MARK: - Cultural Animation Preset
struct CulturalAnimationPreset: Codable {
    let name: String
    let culturalContext: String
    let duration: Double
    let effects: [AnimationEffectTemplate]
    let description: String
}

struct AnimationEffectTemplate: Codable {
    let effectType: String
    let startTime: Double
    let endTime: Double
    let maxIntensity: Double
    let parameters: [String: String]

    init(effectType: String, startTime: Double, endTime: Double, maxIntensity: Double, parameters: [String: String] = [:]) {
        self.effectType = effectType
        self.startTime = startTime
        self.endTime = endTime
        self.maxIntensity = maxIntensity
        self.parameters = parameters
    }
}

// MARK: - Cultural Quality Metrics
struct CulturalQualityMetrics: Codable {
    let overallScore: Double
    let culturalAuthenticityScore: Double
    let visualQualityScore: Double
    let ageAppropriatenessScore: Double
    let culturalSensitivityScore: Double
    let recommendations: [String]
    let warnings: [String]

    var isHighQuality: Bool {
        return overallScore >= 0.8
    }

    var isCulturallyAppropriate: Bool {
        return culturalAuthenticityScore >= 0.7 && culturalSensitivityScore >= 0.8
    }

    init(
        overallScore: Double,
        culturalAuthenticityScore: Double,
        visualQualityScore: Double,
        ageAppropriatenessScore: Double,
        culturalSensitivityScore: Double,
        recommendations: [String] = [],
        warnings: [String] = []
    ) {
        self.overallScore = overallScore
        self.culturalAuthenticityScore = culturalAuthenticityScore
        self.visualQualityScore = visualQualityScore
        self.ageAppropriatenessScore = ageAppropriatenessScore
        self.culturalSensitivityScore = culturalSensitivityScore
        self.recommendations = recommendations
        self.warnings = warnings
    }
}

// MARK: - Cultural Generation History
struct CulturalGenerationHistory: Codable {
    var entries: [CulturalGenerationHistoryEntry]

    init() {
        self.entries = []
    }

    mutating func addEntry(_ artwork: CulturalGeneratedArtwork) {
        let entry = CulturalGenerationHistoryEntry(
            id: artwork.id,
            culturalContext: artwork.culturalContext,
            genre: artwork.designSpec.genre.displayName,
            qualityScore: artwork.qualityScore,
            culturalScore: artwork.culturalScore,
            generatedAt: artwork.generatedAt,
            thumbnailData: artwork.mainImage.imageData
        )
        entries.insert(entry, at: 0) // Most recent first

        // Keep only last 50 entries
        if entries.count > 50 {
            entries = Array(entries.prefix(50))
        }
    }

    func getEntriesForContext(_ contextId: String) -> [CulturalGenerationHistoryEntry] {
        return entries.filter { $0.culturalContext == contextId }
    }

    func getRecentEntries(limit: Int = 10) -> [CulturalGenerationHistoryEntry] {
        return Array(entries.prefix(limit))
    }
}

struct CulturalGenerationHistoryEntry: Identifiable, Codable {
    let id: UUID
    let culturalContext: String
    let genre: String
    let qualityScore: Double
    let culturalScore: Double
    let generatedAt: Date
    let thumbnailData: Data

    var thumbnail: UIImage? {
        return UIImage(data: thumbnailData)
    }

    var displayName: String {
        return "\(genre) \(culturalContext.capitalized)"
    }
}

// MARK: - Legacy Compatibility Models
extension GeneratedRakhi {
    init(from culturalArtwork: CulturalGeneratedArtwork) {
        // Convert cultural artwork back to legacy Rakhi format
        // This requires the legacy spec to be reconstructed
        guard let legacySpec = LegacyRakhiBridge.shared.convertToLegacySpec(culturalArtwork.designSpec) else {
            // Fallback to a basic legacy spec
            let fallbackSpec = RakhiDesignSpec()

            self.init(
                id: culturalArtwork.id,
                designSpec: fallbackSpec,
                mainImage: AIImageResult(
                    imageData: culturalArtwork.mainImage.imageData,
                    width: culturalArtwork.mainImage.width,
                    height: culturalArtwork.mainImage.height,
                    format: culturalArtwork.mainImage.format,
                    qualityScore: culturalArtwork.mainImage.qualityScore,
                    seed: culturalArtwork.mainImage.seed,
                    model: culturalArtwork.mainImage.model
                ),
                animationFrames: culturalArtwork.animationFrames.map { frame in
                    AnimationFrame(timestamp: frame.timestamp)
                },
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
            return
        }

        self.init(
            id: culturalArtwork.id,
            designSpec: legacySpec,
            mainImage: AIImageResult(
                imageData: culturalArtwork.mainImage.imageData,
                width: culturalArtwork.mainImage.width,
                height: culturalArtwork.mainImage.height,
                format: culturalArtwork.mainImage.format,
                qualityScore: culturalArtwork.mainImage.qualityScore,
                seed: culturalArtwork.mainImage.seed,
                model: culturalArtwork.mainImage.model
            ),
            animationFrames: culturalArtwork.animationFrames.map { frame in
                AnimationFrame(timestamp: frame.timestamp)
            },
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
}
