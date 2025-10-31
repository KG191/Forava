import Foundation
import SwiftUI
import Combine

// MARK: - Diwali AI Generation Service
@MainActor
class DiwaliAIService: BaseCulturalAIService, CulturalAIServiceProtocol {
    static let shared = DiwaliAIService()

    @Published var generatedImage: String?

    // Diwali-specific configuration
    private let useMockGeneration = false // ✅ REAL AI GENERATION ENABLED
    private let useDALLE3 = true // 🎨 DALL-E 3 ENABLED (Primary AI)
    private var currentDesignSpec: DiwaliDesignSpec?

    // DALL-E 3 service instance
    private let dalle3Service = DALLE3Service.shared

    override init() {
        super.init()
        print("🪔 DiwaliAIService initialized")
        if useDALLE3 {
            print("🎨 AI Model: DALL-E 3 (OpenAI) - Superior prompt following")
        } else {
            print("🎨 AI Model: SDXL (Replicate)")
            print("🔑 API Key Status: \(apiKeyStatus)")
        }
        print("⚙️  Mock Generation: \(useMockGeneration ? "ENABLED" : "DISABLED - Using Real AI")")
    }

    // MARK: - Diwali Generation
    enum ImageFormat {
        case iPhone
        case appleWatch
    }

    func generateDiwaliGift(
        theme: DiwaliTheme,
        element: DiwaliElement?,
        colorPalette: DiwaliColorPalette,
        message: String,
        contactName: String,
        format: ImageFormat = .iPhone
    ) async throws -> String {

        // Create design specification
        let designSpec = DiwaliDesignSpec(
            theme: theme,
            element: element,
            colorPalette: colorPalette,
            message: message,
            contactName: contactName
        )

        self.currentDesignSpec = designSpec

        // Use mock generation for development/testing
        if useMockGeneration {
            return try await generateMockDiwaliImage(designSpec: designSpec)
        }

        // 🎨 DALL-E 3 GENERATION PATH
        if useDALLE3 {
            return try await generateWithDALLE3(
                designSpec: designSpec,
                format: format
            )
        }

        // ⚙️ SDXL GENERATION PATH (Fallback)
        return try await generateWithSDXL(
            designSpec: designSpec,
            format: format
        )
    }

    // MARK: - DALL-E 3 Generation
    private func generateWithDALLE3(
        designSpec: DiwaliDesignSpec,
        format: ImageFormat
    ) async throws -> String {

        print("🎨 ═══════════════════════════════════════════════════════")
        print("🎨 DALL-E 3 Diwali Generation Pipeline")
        print("🎨 ═══════════════════════════════════════════════════════")

        // Determine DALL-E 3 size based on format
        let dalle3Size: DALLE3Service.ImageSize
        switch format {
        case .iPhone:
            dalle3Size = .size1024x1792  // Portrait
            print("📱 Format: iPhone Portrait (1024×1792)")
        case .appleWatch:
            dalle3Size = .size1024  // Square
            print("⌚ Format: Apple Watch Square (1024×1024)")
        }

        // Build lookup key for alternative prompts
        let themeName = designSpec.theme.rawValue.lowercased().replacingOccurrences(of: " ", with: "")
        let elementName = designSpec.element?.name.lowercased().replacingOccurrences(of: " ", with: "") ?? "diya"
        let lookupKey = "\(themeName)-\(elementName)"

        let prompt: String
        let negativePrompt: String

        if let alternativePrompt = Self.alternativePrompts[lookupKey] {
            // Use alternative natural language prompt
            print("📝 Using alternative prompt for: \(lookupKey)")
            prompt = alternativePrompt.prompt
            // CRITICAL: Do NOT use negative prompt - DALL-E 3 rejects ANY negative instructions
            negativePrompt = ""
        } else {
            // Fallback to programmatic generation
            print("⚙️  Using programmatic prompt for: \(lookupKey)")
            prompt = createCulturalPrompt(from: designSpec)
            // CRITICAL: Do NOT use negative prompt - DALL-E 3 rejects ANY negative instructions
            negativePrompt = ""
        }

        // DALL-E 3: Send ONLY positive prompts
        print("📝 Prompt: \(prompt.prefix(100))...")
        print("ℹ️  Negative prompt: NONE (DALL-E 3 safety filter rejects negative instructions)")

        // Mirror progress from DALLE3Service to this service
        let progressTask = Task { @MainActor in
            while !Task.isCancelled {
                self.generationProgress = dalle3Service.generationProgress
                try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
            }
        }

        // Generate with DALL-E 3
        let imageURL = try await dalle3Service.generateImage(
            prompt: prompt,
            negativePrompt: negativePrompt,
            size: dalle3Size,
            quality: .standard  // $0.04 per image
        )

        progressTask.cancel()

        print("✅ DALL-E 3 generation complete!")
        print("🎨 ═══════════════════════════════════════════════════════")

        return imageURL
    }

    // MARK: - SDXL Generation (Fallback)
    private func generateWithSDXL(
        designSpec: DiwaliDesignSpec,
        format: ImageFormat
    ) async throws -> String {

        // Determine dimensions based on format
        let (width, height) = format == .iPhone
            ? (CulturalAIConfiguration.iPhoneWidth, CulturalAIConfiguration.iPhoneHeight)
            : (CulturalAIConfiguration.watchWidth, CulturalAIConfiguration.watchHeight)

        print("🎨 Generating \(format == .iPhone ? "iPhone" : "Apple Watch") format: \(width)x\(height)")

        // Check if using alternative prompt system
        let themeName = designSpec.theme.rawValue.lowercased().replacingOccurrences(of: " ", with: "")
        let elementName = designSpec.element?.name.lowercased().replacingOccurrences(of: " ", with: "") ?? "diya"
        let lookupKey = "\(themeName)-\(elementName)"

        let prompt: String
        let additionalNegativePrompt: String

        if let alternativePrompt = Self.alternativePrompts[lookupKey] {
            // 🔄 USING ALTERNATIVE PROMPT SYSTEM
            print("🔄 Alternative prompt system active for: \(lookupKey)")
            prompt = alternativePrompt.prompt

            // Build combined negative prompt
            let forbiddenElements = buildForbiddenElementsPrompt(selectedElement: designSpec.element)
            additionalNegativePrompt = "\(alternativePrompt.negativePrompt), \(forbiddenElements)"

            print("🚫 Combined negative prompt: \(additionalNegativePrompt)")
        } else {
            // ⚙️ FALLBACK: Programmatic prompt generation
            print("⚙️ Using programmatic prompt generation for: \(lookupKey)")
            prompt = createCulturalPrompt(from: designSpec)

            // Build element-exclusion negative prompt
            additionalNegativePrompt = buildForbiddenElementsPrompt(selectedElement: designSpec.element)
        }

        // Use centralized generation with cultural context
        return try await generateCulturalGift(
            prompt: enhanceCulturalPrompt(prompt),
            culturalContext: "Diwali",
            width: width,
            height: height,
            primaryColor: designSpec.colorPalette.primaryColorBase,
            secondaryColor: designSpec.colorPalette.secondaryColorBase,
            accentColor: designSpec.colorPalette.accentColorBase,
            additionalNegativePrompt: additionalNegativePrompt
        )
    }

    // MARK: - Protocol Implementation

    nonisolated var culturalEventType: String {
        return "Diwali"
    }

    func generateCulturalGift(
        culturalTheme: Any,
        elements: [Any],
        colorPalette: Any,
        personalMessage: String,
        recipientName: String
    ) async throws -> String {
        guard let theme = culturalTheme as? DiwaliTheme,
              let element = elements.first as? DiwaliElement,
              let palette = colorPalette as? DiwaliColorPalette else {
            throw CulturalAIConfiguration.CulturalAIError.invalidResponse
        }

        return try await generateDiwaliGift(
            theme: theme,
            element: element,
            colorPalette: palette,
            message: personalMessage,
            contactName: recipientName
        )
    }

    nonisolated func getCulturalThemes() -> [Any] {
        return DiwaliTheme.allCases
    }

    nonisolated func getCulturalElements() -> [Any] {
        return DiwaliElement.allElements
    }

    nonisolated func getCulturalColorPalettes() -> [Any] {
        return DiwaliColorPalette.allPalettes
    }

    // MARK: - Alternative Natural Language Prompts (4 themes × 4 elements = 16 prompts)
    nonisolated private static let alternativePrompts: [String: (prompt: String, negativePrompt: String)] = [
        // 🏮 TRADITIONAL Theme (पारंपरिक)
        "traditional-diya": (
            prompt: "A beautiful traditional earthen diya oil lamp glowing with sacred warm flame, authentic Indian festival of lights aesthetic with orange and gold tones, intricate clay lamp design with flickering candlelight, spiritual Diwali atmosphere, cinematic lighting, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text, traditional art style.",
            negativePrompt: "cartoon, inappropriate cultural elements, low resolution"
        ),
        "traditional-rangoli": (
            prompt: "Intricate traditional colorful rangoli floor art with vibrant geometric patterns, authentic Indian festive decoration with symmetrical mandala design, sacred symbols and floral motifs in orange gold purple colors, Diwali celebration atmosphere, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "modern style, neon lights, cartoon"
        ),
        "traditional-lotus": (
            prompt: "Sacred pink lotus flowers blooming in divine arrangement, spiritual purity and enlightenment symbols with elegant petals, traditional Indian aesthetic with soft atmospheric lighting in festival colors, Diwali celebration backdrop, high-resolution wallpaper design for iPhone or Apple Watch.",
            negativePrompt: "modern elements, explosions, chaotic"
        ),
        "traditional-lakshmi": (
            prompt: "Goddess Lakshmi seated on golden lotus throne with divine radiance, Hindu deity of wealth and prosperity with blessing mudra gestures, traditional sacred art style with gold and purple tones, spiritual Diwali atmosphere, designed for iPhone wallpaper or Apple Watch face, high-resolution.",
            negativePrompt: "western flowers, modern art, cartoon"
        ),

        // 🌟 MODERN Theme (आधुनिक)
        "modern-diya": (
            prompt: "Contemporary minimalist diya oil lamp design with sleek modern aesthetics, stylized flame silhouette in vibrant orange and gold tones, clean geometric patterns, sophisticated urban Diwali vibe, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "traditional ornate style, cluttered"
        ),
        "modern-rangoli": (
            prompt: "Modern minimalist rangoli pattern with contemporary geometric design, sleek clean lines in vibrant colors against gradient background, sophisticated festival atmosphere with stylish aesthetics, optimized for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "traditional ornate, vintage style"
        ),
        "modern-lotus": (
            prompt: "Contemporary stylized lotus flower design with minimalist modern aesthetic, clean geometric sacred symbol in elegant tones, sophisticated spiritual vibe with sleek composition, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "traditional ornate, cluttered design"
        ),
        "modern-lakshmi": (
            prompt: "Minimalist modern artistic interpretation of Goddess Lakshmi with sleek contemporary aesthetics, stylized divine feminine deity design in elegant tones, clean sophisticated sacred composition, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "traditional painting style, ornate"
        ),

        // 👨‍👩‍👧 FAMILY REUNION Theme (पारिवारिक उत्सव)
        "familycelebration-diya": (
            prompt: "Warm cozy traditional diya oil lamps creating family gathering atmosphere, gentle glowing flames symbolizing togetherness and unity, heartwarming Diwali reunion ambience with soft orange and warm golden tones, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "aggressive, intimidating, cold colors"
        ),
        "familycelebration-rangoli": (
            prompt: "Cozy warm rangoli floor art created by family together, gentle colorful patterns symbolizing togetherness, heartwarming festival ambience with family celebration energy in vibrant warm tones, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "formal, cold, isolated"
        ),
        "familycelebration-lotus": (
            prompt: "Warm gentle lotus flowers symbolizing family unity and love, cozy floral arrangement in soft sacred tones, heartwarming togetherness atmosphere for Diwali family celebration, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "aggressive, chaotic, cold colors"
        ),
        "familycelebration-lakshmi": (
            prompt: "Goddess Lakshmi blessing family celebration with divine warmth, cozy sacred atmosphere symbolizing family prosperity and love in gentle warm golden tones, heartwarming reunion blessings, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "formal, cold colors, isolated"
        ),

        // 💰 PROSPERITY Theme (समृद्धि)
        "prosperity-diya": (
            prompt: "Fortune-bringing golden prosperity diyas radiating abundant wealth energy, luxurious oil lamps with brilliant gold flames and prosperity symbols, opulent Diwali celebration of abundance, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "poverty symbols, dull colors"
        ),
        "prosperity-rangoli": (
            prompt: "Golden prosperity rangoli floor art with abundant fortune symbols and wealth visualization, luxurious colorful patterns in brilliant gold and vibrant tones, opulent celebration atmosphere, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "plain, dull, poverty imagery"
        ),
        "prosperity-lotus": (
            prompt: "Luxurious golden lotus flowers symbolizing prosperity and divine wealth, abundant sacred blooms with fortune energy in brilliant gold tones, opulent Diwali blessing atmosphere, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "poverty symbols, dull tones"
        ),
        "prosperity-lakshmi": (
            prompt: "Goddess Lakshmi with abundant golden coins and prosperity blessings, divine wealth deity radiating fortune energy with luxurious gold elements, opulent sacred atmosphere celebrating abundance, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "poverty, dull colors, modern currency"
        )
    ]

    // MARK: - AI Prompt Creation
    nonisolated func createCulturalPrompt(from designSpec: Any) -> String {
        guard let spec = designSpec as? DiwaliDesignSpec else {
            return "Diwali celebration design"
        }
        return createCulturalPrompt(from: spec)
    }

    nonisolated private func createCulturalPrompt(from spec: DiwaliDesignSpec) -> String {
        // Build lookup key from theme + element
        let themeName = spec.theme.rawValue.lowercased().replacingOccurrences(of: " ", with: "")
        let elementName = spec.element?.name.lowercased().replacingOccurrences(of: " ", with: "") ?? "diya"
        let lookupKey = "\(themeName)-\(elementName)"

        // Retrieve alternative prompt if available
        if let alternativePrompt = Self.alternativePrompts[lookupKey] {
            print("🎨 USING ALTERNATIVE NATURAL LANGUAGE PROMPT:")
            print("=" + String(repeating: "=", count: 79))
            print("📊 USER SELECTIONS:")
            print("   Theme: \(spec.theme.rawValue)")
            print("   Element: \(spec.element?.name ?? "NONE")")
            print("   Color Palette: \(spec.colorPalette.name)")
            print("   Lookup Key: \(lookupKey)")
            print("")
            print("📝 PROMPT:")
            print(alternativePrompt.prompt)
            print("")
            print("🚫 NEGATIVE PROMPT (from alternative):")
            print(alternativePrompt.negativePrompt)
            print("=" + String(repeating: "=", count: 79))

            return alternativePrompt.prompt
        }

        // ⚠️ FALLBACK: Use programmatic template if alternative not found
        print("⚠️ Alternative prompt not found for key: \(lookupKey). Using programmatic generation.")

        // Use centralized template from configuration
        var prompt = CulturalAIConfiguration.culturalPromptTemplate

        // Replace template placeholders with Diwali-specific content
        prompt = prompt.replacingOccurrences(of: "[CULTURAL_EVENT]", with: "Diwali")

        // Theme-specific styling with boosted SDXL weights
        let themeStyle: String
        switch spec.theme {
        case .traditional:
            themeStyle = "(traditional:2.0), (authentic:1.9), (classic:1.8), (पारंपरिक:1.7)"
        case .modern:
            themeStyle = "(modern:2.0), (contemporary:1.9), (minimalist:1.8), (आधुनिक:1.7)"
        case .familyCelebration:
            themeStyle = "(family celebration:2.0), (togetherness:1.9), (warmth:1.8), (पारिवारिक उत्सव:1.7)"
        case .prosperity:
            themeStyle = "(prosperity:2.0), (wealth:1.9), (fortune:1.8), (समृद्धि:1.7)"
        }
        prompt = prompt.replacingOccurrences(of: "[THEME_STYLE]", with: themeStyle)

        // Single centerpiece element
        let centreElementsText: String
        if let selectedElement = spec.element {
            let repeatedPrompts = [
                "(\(selectedElement.name):1.8)",
                "(\(selectedElement.name) centerpiece:1.7)",
                selectedElement.aiPromptModifier
            ].joined(separator: ", ")
            centreElementsText = "YOU MUST INCLUDE THIS CENTERPIECE: \(repeatedPrompts), MANDATORY central focal element"
        } else {
            centreElementsText = "(Diwali decorative focal point:1.3), celebration motifs"
        }
        prompt = prompt.replacingOccurrences(of: "[CENTRE_ELEMENTS]", with: centreElementsText)

        // Supporting elements
        prompt = prompt.replacingOccurrences(of: "[SUPPORTING_ELEMENTS]", with: "elegant Indian cultural decorative flourishes")

        // Color integration
        let colors = spec.colorPalette
        prompt = prompt.replacingOccurrences(of: "[PRIMARY_COLOR_SIMPLE]", with: colors.primaryColorSimple)
        prompt = prompt.replacingOccurrences(of: "[SECONDARY_COLOR_SIMPLE]", with: colors.secondaryColorSimple)
        prompt = prompt.replacingOccurrences(of: "[ACCENT_COLOR_SIMPLE]", with: colors.accentColorSimple)
        prompt = prompt.replacingOccurrences(of: "[BACKGROUND_ATMOSPHERE]", with: colors.backgroundHint)

        // Emotional context
        prompt = prompt.replacingOccurrences(of: "[EMOTIONAL_CONTEXT]", with: "prosperity, fortune, and celebration")

        print("🎨 FINAL AI PROMPT WITH ALL USER SELECTIONS (PROGRAMMATIC FALLBACK):")
        print("=" + String(repeating: "=", count: 79))
        print(prompt)
        print("=" + String(repeating: "=", count: 79))

        return prompt
    }

    // MARK: - Element Exclusion
    nonisolated private func buildForbiddenElementsPrompt(selectedElement: DiwaliElement?) -> String {
        // All possible centerpiece elements
        let allElementNames = ["Dragon", "Lantern", "Firecrackers", "Peony", "Gold Ingots"]

        // If no element selected, forbid all specific elements
        guard let selected = selectedElement else {
            return "diya, rangoli, lotus, lakshmi, fireworks, no centerpiece element"
        }

        // Filter out the selected element to get forbidden list
        let forbiddenNames = allElementNames.filter { $0.lowercased() != selected.name.lowercased() }

        // Build comprehensive negative prompt
        var negativeTerms: [String] = []

        for name in forbiddenNames {
            let lower = name.lowercased()
            negativeTerms.append(lower)
            negativeTerms.append("no \(lower)")
            negativeTerms.append("\(lower) missing")
            negativeTerms.append("\(lower) absent")
        }

        // Add general prohibition
        negativeTerms.append("multiple centerpiece elements")
        negativeTerms.append("mixed centerpieces")
        negativeTerms.append("wrong centerpiece")

        print("🚫 FORBIDDEN ELEMENTS: \(forbiddenNames.joined(separator: ", "))")

        return negativeTerms.joined(separator: ", ")
    }

    // MARK: - Mock Generation (for development)
    private func generateMockDiwaliImage(designSpec: DiwaliDesignSpec) async throws -> String {
        print("🧪 Using mock Diwali generation...")

        // Simulate API call delay with progress updates
        for index in 1...10 {
            try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
            await MainActor.run {
                self.generationProgress = 0.3 + (Float(index) * 0.07)
            }
        }

        // Return mock image URL
        let mockImageURL = "mock_diwali_\(designSpec.theme.rawValue.lowercased())_\(UUID().uuidString.prefix(8))"

        print("✅ Mock Diwali generation completed: \(mockImageURL)")
        return mockImageURL
    }
}

// MARK: - Data Models
struct DiwaliDesignSpec {
    let theme: DiwaliTheme
    let element: DiwaliElement?
    let colorPalette: DiwaliColorPalette
    let message: String
    let contactName: String
    let timestamp: Date = Date()
}
