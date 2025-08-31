import Foundation

// MARK: - Advanced Prompt Mapping Service with LoRA Integration
@MainActor
class PromptMapper: ObservableObject {
    static let shared = PromptMapper()

    private var promptMappings: [String: [PromptToken]] = [:]
    private var culturalPrompts: [String: CulturalPromptSet] = [:]
    private var loraModels: [String: LoRAModel] = [:]
    private var isLoaded = false

    private init() {
        Task {
            await loadPromptMappings()
            await loadCulturalPrompts()
            await loadLoRAModels()
        }
    }

    // MARK: - Enhanced Public Interface

    func getPrompts(for elementId: String) async -> [String] {
        if !isLoaded {
            await loadPromptMappings()
        }

        return promptMappings[elementId]?.map { $0.token } ?? []
    }

    func buildAdvancedPrompt(from designSpec: RakhiDesignSpec) async -> AdvancedPrompt {
        if !isLoaded {
            await loadPromptMappings()
            await loadCulturalPrompts()
            await loadLoRAModels()
        }

        // Build culturally-intelligent prompt
        let culturalContext = await buildCulturalContext(designSpec)
        let elementPrompts = await buildElementPrompts(designSpec.elements)
        let stylePrompts = await buildStylePrompts(designSpec.genre, colorPalette: designSpec.colorPalette)
        let ageAppropriatePrompts = await buildAgeAppropriatePrompts(designSpec.targetAgeGroup)
        let personalizedPrompts = await buildPersonalizedPrompts(designSpec.personalMessage)

        // Select optimal LoRA models
        let selectedLoRAs = await selectOptimalLoRAs(for: designSpec)

        // Combine all prompt components with appropriate weights
        let combinedPrompt = combinePromptComponents(
            cultural: culturalContext,
            elements: elementPrompts,
            style: stylePrompts,
            age: ageAppropriatePrompts,
            personalized: personalizedPrompts
        )

        // Build negative prompt with cultural sensitivity
        let negativePrompt = buildCulturallySensitiveNegativePrompt(designSpec)

        return AdvancedPrompt(
            positive: combinedPrompt,
            negative: negativePrompt,
            loraModels: selectedLoRAs,
            culturalWeight: calculateCulturalWeight(designSpec),
            qualityEnhancers: getQualityEnhancers(designSpec),
            technicalParameters: getTechnicalParameters(designSpec)
        )
    }

    func getWeightedPrompts(for elementId: String, weight: Double = 1.0) async -> [WeightedPrompt] {
        if !isLoaded {
            await loadPromptMappings()
        }

        guard let tokens = promptMappings[elementId] else {
            return []
        }

        return tokens.map { token in
            WeightedPrompt(
                prompt: token.token,
                weight: token.baseWeight * weight
            )
        }
    }

    // MARK: - Private Implementation

    private func loadPromptMappings() async {
        guard !isLoaded else { return }

        // Load embedded mappings first
        promptMappings = PromptMappingData.embeddeduktMappings

        // Try to load from server (with fallback to embedded)
        await loadServerMappings()

        isLoaded = true
    }
}
