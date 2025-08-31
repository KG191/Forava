import Foundation

// MARK: - AI Prompt Building Extensions
extension AIRakhiService {

    internal func buildPrompt(from spec: RakhiDesignSpec) async throws -> AIPrompt {
        // Use the advanced prompt mapper for sophisticated prompt building
        let promptMapper = PromptMapper.shared
        let advancedPrompt = await promptMapper.buildAdvancedPrompt(from: spec)

        // Convert to our AIPrompt format
        return AIPrompt(
            positive: advancedPrompt.positive,
            negative: advancedPrompt.negative,
            steps: advancedPrompt.technicalParameters.steps,
            cfgScale: advancedPrompt.technicalParameters.cfgScale,
            seed: advancedPrompt.technicalParameters.seed,
            loraModels: advancedPrompt.loraModels
        )
    }

    private func buildPromptOld(from spec: RakhiDesignSpec) async throws -> AIPrompt {
        var positivePrompts: [String] = []
        var negativePrompts: [String] = []

        // Base rakhi description
        positivePrompts.append("beautiful handcrafted rakhi, traditional Indian design")

        // Genre-based styling
        switch spec.genre {
        case .traditional:
            positivePrompts.append("traditional style, classic Indian motifs, vibrant colors")
        case .modern:
            positivePrompts.append("modern contemporary design, sleek appearance, refined details")
        case .elegant:
            positivePrompts.append("elegant sophisticated design, premium materials, graceful")
        case .spiritual:
            positivePrompts.append("spiritual sacred design, divine symbols, peaceful aura")
        case .unknown:
            positivePrompts.append("beautiful design")
        }

        // Color palette
        switch spec.colorPalette {
        case .traditional:
            positivePrompts.append("red and gold colors, traditional saffron, vibrant orange")
            negativePrompts.append("blue colors, modern colors, contemporary palette")
        case .modern:
            positivePrompts.append("blue and silver tones, contemporary colors, sleek palette")
            negativePrompts.append("red colors, traditional colors, saffron")
        default:
            break
        }

        // Elements
        for element in spec.elements {
            let promptMapper = PromptMapper.shared
            let elementPrompts = await promptMapper.getPrompts(for: element.id)
            positivePrompts.append(contentsOf: elementPrompts)
        }

        // Quality enhancers
        positivePrompts.append("masterpiece, best quality, ultra detailed, 8k resolution")
        positivePrompts.append("professional photography, perfect lighting, sharp focus")

        // Negative prompts
        negativePrompts.append(contentsOf: [
            "blurry", "low quality", "distorted", "inappropriate",
            "western symbols", "cross", "non-cultural", "nsfw"
        ])

        return AIPrompt(
            positive: positivePrompts.joined(separator: ", "),
            negative: negativePrompts.joined(separator: ", "),
            steps: 30,
            cfgScale: 7.5,
            seed: -1
        )
    }
}
