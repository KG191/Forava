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
    
    // MARK: - Advanced Prompt Building
    
    private func buildCulturalContext(_ designSpec: RakhiDesignSpec) async -> String {
        var context = "traditional Indian rakhi, cultural authenticity, "
        
        switch designSpec.genre {
        case .traditional:
            context += "ancient Indian tradition, classical design, time-honored patterns, "
        case .spiritual:
            context += "spiritual significance, divine blessings, sacred symbols, "
        case .elegant:
            context += "refined elegance, sophisticated craftsmanship, premium quality, "
        case .modern:
            context += "contemporary fusion, modern aesthetics with traditional roots, "
        case .unknown:
            context += "culturally appropriate design, "
        }
        
        // Add festival context
        context += "Raksha Bandhan festival, sibling bond, protection thread, love and care, "
        
        return context
    }
    
    private func buildElementPrompts(_ elements: [DesignElement]) async -> String {
        var elementPrompts: [String] = []
        
        for element in elements {
            if let culturalPrompts = culturalPrompts[element.id] {
                let weightedPrompt = "(\\(culturalPrompts.primaryPrompt):\\(element.culturalSignificance))"
                elementPrompts.append(weightedPrompt)
                
                // Add secondary prompts with reduced weight
                for _ in culturalPrompts.secondaryPrompts.prefix(2) {
                    elementPrompts.append("(cultural-element:0.7)")
                }
            }
        }
        
        return elementPrompts.joined(separator: ", ")
    }
    
    private func buildStylePrompts(_ genre: RakhiGenre, colorPalette: ColorPalette) async -> String {
        var stylePrompts: [String] = []
        
        // Genre-specific style prompts
        switch genre {
        case .traditional:
            stylePrompts.append("(traditional Indian craftsmanship:1.3)")
            stylePrompts.append("(authentic cultural design:1.2)")
        case .spiritual:
            stylePrompts.append("(divine spiritual energy:1.4)")
            stylePrompts.append("(sacred geometry:1.2)")
        case .elegant:
            stylePrompts.append("(sophisticated elegance:1.3)")
            stylePrompts.append("(premium luxury finish:1.1)")
        case .modern:
            stylePrompts.append("(contemporary design:1.2)")
            stylePrompts.append("(modern artistic interpretation:1.1)")
        case .unknown:
            break
        }
        
        // Color palette prompts
        switch colorPalette {
        case .traditional:
            stylePrompts.append("(vibrant red and gold:1.3)")
            stylePrompts.append("(traditional saffron orange:1.2)")
        case .modern:
            stylePrompts.append("(contemporary color scheme:1.2)")
            stylePrompts.append("(sleek modern palette:1.1)")
        case .vibrant:
            stylePrompts.append("(bright festive colors:1.3)")
            stylePrompts.append("(joyful color palette:1.2)")
        case .pastel:
            stylePrompts.append("(soft pastel tones:1.2)")
            stylePrompts.append("(gentle color harmony:1.1)")
        case .earthy:
            stylePrompts.append("(natural earth tones:1.2)")
            stylePrompts.append("(organic color palette:1.1)")
        case .metallic:
            stylePrompts.append("(metallic gold and silver:1.4)")
            stylePrompts.append("(lustrous finish:1.2)")
        case .monochrome:
            stylePrompts.append("(elegant monochrome:1.2)")
            stylePrompts.append("(sophisticated single color:1.1)")
        }
        
        return stylePrompts.joined(separator: ", ")
    }
    
    private func buildAgeAppropriatePrompts(_ ageGroup: AgeGroup) async -> String {
        switch ageGroup {
        case .young:
            return "(child-friendly design:1.2), (playful elements:1.1), (bright and cheerful:1.1)"
        case .adult:
            return "(mature sophisticated design:1.2), (balanced aesthetics:1.1)"
        case .elder:
            return "(respectful traditional design:1.3), (dignified appearance:1.2), (classic elements:1.1)"
        case .any:
            return "(universally appealing:1.1)"
        }
    }
    
    private func buildPersonalizedPrompts(_ message: String?) async -> String {
        guard let message = message, !message.isEmpty else {
            return ""
        }
        
        // Analyze message sentiment and add appropriate visual prompts
        if message.lowercased().contains("love") {
            return ", (loving warmth:1.2), (heartfelt emotion:1.1)"
        } else if message.lowercased().contains("bless") {
            return ", (divine blessings:1.3), (spiritual glow:1.1)"
        } else if message.lowercased().contains("happy") {
            return ", (joyful celebration:1.2), (happiness radiance:1.1)"
        } else {
            return ", (personal meaningful touch:1.1)"
        }
    }
    
    private func selectOptimalLoRAs(for designSpec: RakhiDesignSpec) async -> [String] {
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
    
    private func combinePromptComponents(
        cultural: String,
        elements: String,
        style: String,
        age: String,
        personalized: String
    ) -> String {
        var components = [cultural, elements, style, age]
        
        if !personalized.isEmpty {
            components.append(personalized)
        }
        
        // Add quality enhancers
        components.append("masterpiece, best quality, ultra detailed, 8k resolution")
        components.append("professional photography, perfect lighting, sharp focus")
        
        return components.joined(separator: ", ")
    }
    
    private func buildCulturallySensitiveNegativePrompt(_ designSpec: RakhiDesignSpec) -> String {
        var negativePrompts = [
            "blurry", "low quality", "distorted", "inappropriate",
            "western symbols", "cross", "non-cultural", "offensive",
            "poorly crafted", "amateur", "inconsistent", "ugly",
            "nsfw", "inappropriate cultural representation"
        ]
        
        // Add age-specific negative prompts
        if designSpec.targetAgeGroup == .young {
            negativePrompts.append(contentsOf: ["scary", "intimidating", "dark themes"])
        }
        
        return negativePrompts.joined(separator: ", ")
    }
    
    private func calculateCulturalWeight(_ designSpec: RakhiDesignSpec) -> Double {
        let elementWeight = designSpec.elements.map { $0.culturalSignificance }.reduce(0, +) / Double(max(designSpec.elements.count, 1))
        let genreWeight = designSpec.genre.culturalWeight
        
        return (elementWeight + genreWeight) / 2.0
    }
    
    private func getQualityEnhancers(_ designSpec: RakhiDesignSpec) -> [String] {
        return [
            "high resolution",
            "professional quality",
            "detailed craftsmanship",
            "perfect symmetry",
            "vibrant colors",
            "excellent lighting"
        ]
    }
    
    private func getTechnicalParameters(_ designSpec: RakhiDesignSpec) -> TechnicalParameters {
        return TechnicalParameters(
            cfg_scale: 7.5,
            steps: 30,
            sampler: "DPMSolverMultistep",
            clip_skip: 2,
            strength: 0.75
        )
    }
    
    func getWeightedPrompts(for elementId: String, weight: Double = 1.0) async -> [WeightedPrompt] {
        if !isLoaded {
            await loadPromptMappings()
        }
        
        return promptMappings[elementId]?.map { promptToken in
            WeightedPrompt(
                token: promptToken.token,
                weight: weight * promptToken.baseWeight
            )
        } ?? []
    }
    
    // MARK: - Private Implementation
    private func loadPromptMappings() async {
        // Load from embedded CSV data first
        loadEmbeddedMappings()
        
        // Skip server mappings for now (no server available)
        // await loadServerMappings()
        
        isLoaded = true
    }
    
    private func loadCulturalPrompts() async {
        // Load enhanced cultural prompt mappings
        culturalPrompts = [
            "red_thread": CulturalPromptSet(
                primaryPrompt: "sacred red mauli thread",
                secondaryPrompts: ["traditional protection thread", "blessed rakhi string", "auspicious red cord"]
            ),
            "gold_beads": CulturalPromptSet(
                primaryPrompt: "lustrous gold beads",
                secondaryPrompts: ["golden spherical ornaments", "precious metal decorations", "shimmering gold accents"]
            ),
            "om_symbol": CulturalPromptSet(
                primaryPrompt: "sacred Om symbol",
                secondaryPrompts: ["divine AUM emblem", "Hindu spiritual icon", "universal consciousness symbol"]
            ),
            "lotus_motif": CulturalPromptSet(
                primaryPrompt: "lotus flower design",
                secondaryPrompts: ["sacred lotus pattern", "spiritual bloom motif", "purity flower symbol"]
            ),
            "rudraksha_beads": CulturalPromptSet(
                primaryPrompt: "holy rudraksha beads",
                secondaryPrompts: ["sacred Shiva beads", "divine seed ornaments", "spiritual meditation beads"]
            )
        ]
    }
    
    private func loadLoRAModels() async {
        // Load available LoRA model configurations
        loraModels = [
            "rakhi_traditional_v2": LoRAModel(
                name: "rakhi_traditional_v2",
                weight: 0.8,
                triggerWords: ["traditional rakhi", "mauli thread", "sacred thread"],
                culturalFocus: .traditional
            ),
            "indian_cultural_elements_v1": LoRAModel(
                name: "indian_cultural_elements_v1",
                weight: 0.7,
                triggerWords: ["indian culture", "cultural authenticity", "traditional craft"],
                culturalFocus: .cultural
            ),
            "hindu_spiritual_symbols_v2": LoRAModel(
                name: "hindu_spiritual_symbols_v2",
                weight: 0.9,
                triggerWords: ["om symbol", "lotus", "sacred geometry", "divine"],
                culturalFocus: .spiritual
            ),
            "premium_jewelry_design_v1": LoRAModel(
                name: "premium_jewelry_design_v1",
                weight: 0.6,
                triggerWords: ["elegant jewelry", "premium craftsmanship", "luxury design"],
                culturalFocus: .elegant
            )
        ]
    }
    
    private func loadEmbeddedMappings() {
        promptMappings = [
            // Thread Elements
            "red_thread": [
                PromptToken(token: "red thread", baseWeight: 1.0),
                PromptToken(token: "mauli", baseWeight: 0.9),
                PromptToken(token: "sacred thread", baseWeight: 0.8),
                PromptToken(token: "traditional red cord", baseWeight: 0.7)
            ],
            "silk_thread": [
                PromptToken(token: "silk thread", baseWeight: 1.0),
                PromptToken(token: "smooth thread", baseWeight: 0.8),
                PromptToken(token: "lustrous thread", baseWeight: 0.7),
                PromptToken(token: "premium fiber", baseWeight: 0.6)
            ],
            
            // Bead Elements
            "gold_beads": [
                PromptToken(token: "gold beads", baseWeight: 1.0),
                PromptToken(token: "golden spheres", baseWeight: 0.9),
                PromptToken(token: "metallic beads", baseWeight: 0.8),
                PromptToken(token: "shimmering gold", baseWeight: 0.7)
            ],
            "pearl_beads": [
                PromptToken(token: "pearl beads", baseWeight: 1.0),
                PromptToken(token: "white pearls", baseWeight: 0.9),
                PromptToken(token: "lustrous pearls", baseWeight: 0.8),
                PromptToken(token: "iridescent beads", baseWeight: 0.7)
            ],
            "rudraksha_beads": [
                PromptToken(token: "rudraksha beads", baseWeight: 1.0),
                PromptToken(token: "sacred beads", baseWeight: 0.9),
                PromptToken(token: "spiritual beads", baseWeight: 0.8),
                PromptToken(token: "brown seed beads", baseWeight: 0.7)
            ],
            
            // Center Piece Elements
            "om_symbol": [
                PromptToken(token: "om symbol", baseWeight: 1.0),
                PromptToken(token: "sacred om", baseWeight: 0.9),
                PromptToken(token: "hindu om", baseWeight: 0.8),
                PromptToken(token: "spiritual symbol", baseWeight: 0.7),
                PromptToken(token: "aum sign", baseWeight: 0.6)
            ],
            "lotus_motif": [
                PromptToken(token: "lotus flower", baseWeight: 1.0),
                PromptToken(token: "lotus petals", baseWeight: 0.9),
                PromptToken(token: "sacred lotus", baseWeight: 0.8),
                PromptToken(token: "pink lotus", baseWeight: 0.7),
                PromptToken(token: "blooming lotus", baseWeight: 0.6)
            ],
            "geometric_center": [
                PromptToken(token: "geometric pattern", baseWeight: 1.0),
                PromptToken(token: "modern design", baseWeight: 0.9),
                PromptToken(token: "abstract shape", baseWeight: 0.8),
                PromptToken(token: "symmetrical design", baseWeight: 0.7),
                PromptToken(token: "contemporary motif", baseWeight: 0.6)
            ],
            
            // Decorative Elements
            "tassels": [
                PromptToken(token: "tassels", baseWeight: 1.0),
                PromptToken(token: "hanging threads", baseWeight: 0.8),
                PromptToken(token: "decorative tassels", baseWeight: 0.7),
                PromptToken(token: "flowing threads", baseWeight: 0.6)
            ],
            "mirrors": [
                PromptToken(token: "mirror work", baseWeight: 1.0),
                PromptToken(token: "reflective elements", baseWeight: 0.8),
                PromptToken(token: "shiny mirrors", baseWeight: 0.7),
                PromptToken(token: "embedded mirrors", baseWeight: 0.6),
                PromptToken(token: "glass inlay", baseWeight: 0.5)
            ],
            
            // Symbols
            "swastika": [
                PromptToken(token: "swastika symbol", baseWeight: 1.0),
                PromptToken(token: "auspicious swastika", baseWeight: 0.9),
                PromptToken(token: "hindu swastika", baseWeight: 0.8),
                PromptToken(token: "traditional symbol", baseWeight: 0.7),
                PromptToken(token: "sacred symbol", baseWeight: 0.6)
            ],
            "peacock_motif": [
                PromptToken(token: "peacock design", baseWeight: 1.0),
                PromptToken(token: "peacock feathers", baseWeight: 0.9),
                PromptToken(token: "colorful peacock", baseWeight: 0.8),
                PromptToken(token: "bird motif", baseWeight: 0.7),
                PromptToken(token: "ornamental bird", baseWeight: 0.6)
            ]
        ]
    }
    
    private func loadServerMappings() async {
        // In production, this would fetch updated mappings from the server
        guard let url = URL(string: "https://api.forava.ai/v1/prompt-mappings") else {
            print("Invalid server URL for prompt mappings")
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  200...299 ~= httpResponse.statusCode else {
                print("Failed to fetch server mappings: Invalid response")
                return
            }
            
            let serverMappings = try JSONDecoder().decode([String: [PromptToken]].self, from: data)
            
            // Merge server mappings with embedded ones (server takes priority)
            for (key, value) in serverMappings {
                promptMappings[key] = value
            }
            
            print("Successfully loaded \(serverMappings.count) prompt mappings from server")
            
        } catch {
            print("Failed to load server mappings: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Utility Methods
    func getAllMappedElements() -> [String] {
        return Array(promptMappings.keys).sorted()
    }
    
    func getMappingInfo(for elementId: String) -> PromptMappingInfo? {
        guard let tokens = promptMappings[elementId] else { return nil }
        
        return PromptMappingInfo(
            elementId: elementId,
            tokenCount: tokens.count,
            primaryToken: tokens.first?.token ?? "",
            totalWeight: tokens.reduce(0) { $0 + $1.baseWeight }
        )
    }
}

// MARK: - Supporting Types

struct PromptToken: Codable {
    let token: String
    let baseWeight: Double
    let category: String?
    let culturalContext: String?
    
    init(token: String, baseWeight: Double, category: String? = nil, culturalContext: String? = nil) {
        self.token = token
        self.baseWeight = baseWeight
        self.category = category
        self.culturalContext = culturalContext
    }
}

struct WeightedPrompt {
    let token: String
    let weight: Double
    
    var formattedToken: String {
        if weight == 1.0 {
            return token
        } else {
            return "(\(token):\(String(format: "%.1f", weight)))"
        }
    }
}

struct PromptMappingInfo {
    let elementId: String
    let tokenCount: Int
    let primaryToken: String
    let totalWeight: Double
}

// MARK: - Prompt Builder
class PromptBuilder {
    
    func buildPrompt(from spec: RakhiDesignSpec) async -> String {
        var promptComponents: [String] = []
        
        // Add base quality prompts
        promptComponents.append("beautiful traditional Indian rakhi")
        promptComponents.append("intricate design")
        promptComponents.append("high quality")
        promptComponents.append("detailed")
        
        // Add genre-specific prompt
        promptComponents.append(spec.genre.basePrompt)
        
        // Add element-specific prompts
        for element in spec.elements {
            let weightedPrompts = await PromptMapper.shared.getWeightedPrompts(
                for: element.id,
                weight: element.weight
            )
            
            let formattedTokens = weightedPrompts.map { $0.formattedToken }
            promptComponents.append(contentsOf: formattedTokens)
        }
        
        // Add color palette prompts
        let colorPrompts = spec.colorPalette.promptTokens
        promptComponents.append(contentsOf: colorPrompts)
        
        // Add age-appropriate style adjustments
        let agePrompts = getAgeAppropriatePrompts(for: spec.targetAgeGroup)
        promptComponents.append(contentsOf: agePrompts)
        
        // Add technical quality prompts
        promptComponents.append("masterpiece")
        promptComponents.append("best quality")
        promptComponents.append("ultra detailed")
        promptComponents.append("8k resolution")
        promptComponents.append("professional photography")
        
        return promptComponents.joined(separator: ", ")
    }
    
    func buildNegativePrompt(from spec: RakhiDesignSpec) -> String {
        var negativeComponents: [String] = []
        
        // Base negative prompts
        negativeComponents.append("blurry")
        negativeComponents.append("low quality")
        negativeComponents.append("distorted")
        negativeComponents.append("inappropriate")
        negativeComponents.append("western symbols")
        negativeComponents.append("cross")
        negativeComponents.append("offensive")
        negativeComponents.append("ugly")
        negativeComponents.append("deformed")
        negativeComponents.append("bad anatomy")
        negativeComponents.append("worst quality")
        
        // Genre-specific negative prompts
        switch spec.genre {
        case .traditional:
            negativeComponents.append("modern materials")
            negativeComponents.append("synthetic")
        case .modern:
            negativeComponents.append("old-fashioned")
            negativeComponents.append("dated")
        case .elegant:
            negativeComponents.append("gaudy")
            negativeComponents.append("cheap")
        case .spiritual:
            negativeComponents.append("secular")
            negativeComponents.append("commercial")
        case .unknown:
            break
        }
        
        // Age-appropriate negative prompts
        switch spec.targetAgeGroup {
        case .young:
            negativeComponents.append("too serious")
            negativeComponents.append("intimidating")
        case .elder:
            negativeComponents.append("too playful")
            negativeComponents.append("childish")
        case .adult, .any:
            break
        }
        
        return negativeComponents.joined(separator: ", ")
    }
    
    private func getAgeAppropriatePrompts(for ageGroup: AgeGroup) -> [String] {
        switch ageGroup {
        case .young:
            return ["colorful", "playful", "fun", "bright"]
        case .adult:
            return ["sophisticated", "elegant", "refined"]
        case .elder:
            return ["traditional", "respectful", "dignified", "classic"]
        case .any:
            return ["timeless", "universal appeal"]
        }
    }
}

// MARK: - Enhanced Supporting Types

struct AdvancedPrompt {
    let positive: String
    let negative: String
    let loraModels: [String]
    let culturalWeight: Double
    let qualityEnhancers: [String]
    let technicalParameters: TechnicalParameters
}

struct CulturalPromptSet {
    let primaryPrompt: String
    let secondaryPrompts: [String]
}

struct LoRAModel {
    let name: String
    let weight: Double
    let triggerWords: [String]
    let culturalFocus: CulturalFocus
}

enum CulturalFocus {
    case traditional
    case spiritual
    case elegant
    case modern
    case cultural
}

struct TechnicalParameters {
    let cfg_scale: Double
    let steps: Int
    let sampler: String
    let clip_skip: Int
    let strength: Double
}