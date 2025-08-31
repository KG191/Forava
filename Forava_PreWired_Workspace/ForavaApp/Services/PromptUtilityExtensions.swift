import Foundation

// MARK: - Prompt Utility Extensions
extension PromptMapper {

    // MARK: - LoRA and Advanced Components

    internal func selectOptimalLoRAs(for designSpec: RakhiDesignSpec) async -> [String] {
        var selectedLoRAs: [String] = []

        // Base rakhi LoRA
        selectedLoRAs.append("rakhi_traditional_v2")

        // Genre-specific LoRAs
        switch designSpec.genre {
        case .traditional:
            selectedLoRAs.append("indian_traditional_crafts_v1")
        case .spiritual:
            selectedLoRAs.append("hindu_spiritual_symbols_v2")
        case .elegant:
            selectedLoRAs.append("premium_jewelry_design_v1")
        case .modern:
            selectedLoRAs.append("contemporary_fusion_v1")
        case .unknown:
            break
        }

        // Element-specific LoRAs
        let hasGoldElements = designSpec.elements.contains { $0.id.contains("gold") }
        if hasGoldElements {
            selectedLoRAs.append("gold_jewelry_texture_v2")
        }

        let hasSpiritualElements = designSpec.elements.contains { $0.culturalSignificance > 0.9 }
        if hasSpiritualElements {
            selectedLoRAs.append("sacred_geometry_v1")
        }

        return Array(selectedLoRAs.prefix(4)) // Limit to 4 LoRAs for optimal performance
    }

    internal func buildCulturallySensitiveNegativePrompt(_ designSpec: RakhiDesignSpec) -> String {
        var negativePrompts = [
            "blurry", "low quality", "distorted", "inappropriate",
            "western symbols", "cross", "non-cultural", "offensive",
            "poorly crafted", "amateur", "inconsistent", "ugly",
            "nsfw", "inappropriate cultural representation",
            "too many elements", "cluttered design", "overwhelming details"
        ]

        // Add color-specific negative prompts based on selected palette
        switch designSpec.colorPalette {
        case .modern:
            negativePrompts.append(contentsOf: ["red colors", "orange colors", "yellow colors", "traditional red gold", "saffron"])
        case .traditional:
            negativePrompts.append(contentsOf: ["blue colors", "modern blue", "contemporary colors"])
        case .pastel:
            negativePrompts.append(contentsOf: ["vibrant colors", "bright colors", "intense colors"])
        case .monochrome:
            negativePrompts.append(contentsOf: ["multiple colors", "colorful", "rainbow"])
        default:
            break
        }

        // Add element-specific negative prompts
        if designSpec.elements.count == 1 {
            negativePrompts.append(contentsOf: ["multiple design elements", "complex decorations", "many ornaments"])
        }

        let selectedElementIds = Set(designSpec.elements.map { $0.id })

        // If threads are not selected, strongly exclude them
        if !selectedElementIds.contains("red_thread") && !selectedElementIds.contains("silk_thread") {
            negativePrompts.append(contentsOf: ["threads", "string", "cord", "rope", "mauli", "sacred thread", "red thread", "silk thread", "thread bracelet", "braided thread"])
        }

        // If beads are not selected, strongly exclude them  
        if !selectedElementIds.contains("gold_beads") && !selectedElementIds.contains("pearl_beads") && !selectedElementIds.contains("rudraksha_beads") {
            negativePrompts.append(contentsOf: ["beads", "pearls", "spheres", "round beads", "gold beads", "pearl beads", "rudraksha beads", "bead work"])
        }

        return negativePrompts.joined(separator: ", ")
    }

    internal func calculateCulturalWeight(_ designSpec: RakhiDesignSpec) -> Double {
        let genreWeight = designSpec.genre.culturalWeight
        let elementWeights = designSpec.elements.map { $0.culturalSignificance }
        let avgElementWeight = elementWeights.isEmpty ? 0.5 : elementWeights.reduce(0, +) / Double(elementWeights.count)

        return (genreWeight * 0.4) + (avgElementWeight * 0.6)
    }

    internal func getQualityEnhancers(_ designSpec: RakhiDesignSpec) -> [String] {
        var enhancers = [
            "masterpiece", "best quality", "ultra detailed", "8k resolution",
            "professional photography", "perfect lighting", "sharp focus"
        ]

        // Add genre-specific enhancers
        if designSpec.genre == .elegant {
            enhancers.append("premium craftsmanship")
        }

        return enhancers
    }

    internal func getTechnicalParameters(_ designSpec: RakhiDesignSpec) -> TechnicalParameters {
        return TechnicalParameters(
            steps: 30,
            cfgScale: 7.5,
            seed: -1,
            sampler: "DPM++ 2M Karras"
        )
    }

    // MARK: - Data Loading

    internal func loadCulturalPrompts() async {
        // Load embedded cultural prompts
        culturalPrompts = [
            "om_symbol": CulturalPromptSet(
                primaryPrompt: "sacred Sanskrit AUM character",
                secondaryPrompts: ["spiritual meditation symbol", "divine om emblem"],
                culturalContext: "Hindu spiritual symbol representing universal consciousness"
            ),
            "lotus_motif": CulturalPromptSet(
                primaryPrompt: "pink lotus flower",
                secondaryPrompts: ["sacred lotus bloom", "spiritual flower"],
                culturalContext: "Symbol of purity and enlightenment in Hindu tradition"
            )
        ]
    }

    internal func loadLoRAModels() async {
        // Initialize available LoRA models
        loraModels = [
            "rakhi_traditional_v2": LoRAModel(
                name: "Rakhi Traditional V2",
                strength: 0.8,
                trigger: "traditional Indian rakhi"
            ),
            "indian_traditional_crafts_v1": LoRAModel(
                name: "Indian Traditional Crafts",
                strength: 0.7,
                trigger: "traditional Indian handicraft"
            ),
            "hindu_spiritual_symbols_v2": LoRAModel(
                name: "Hindu Spiritual Symbols V2",
                strength: 0.9,
                trigger: "Hindu spiritual symbol"
            )
        ]
    }
}
