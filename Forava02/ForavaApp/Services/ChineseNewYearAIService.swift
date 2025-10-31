import Foundation
import SwiftUI
import Combine

// MARK: - Chinese New Year AI Generation Service
@MainActor
class ChineseNewYearAIService: BaseCulturalAIService, CulturalAIServiceProtocol {
    static let shared = ChineseNewYearAIService()

    @Published var generatedImage: String?

    // Chinese New Year-specific configuration
    private let useMockGeneration = false // ✅ REAL AI GENERATION ENABLED
    private let useDALLE3 = true // 🎨 DALL-E 3 ENABLED (Primary AI)
    private var currentDesignSpec: ChineseNewYearDesignSpec?

    // DALL-E 3 service instance
    private let dalle3Service = DALLE3Service.shared

    override init() {
        super.init()
        print("🐉 ChineseNewYearAIService initialized")
        if useDALLE3 {
            print("🎨 AI Model: DALL-E 3 (OpenAI) - Superior prompt following")
        } else {
            print("🎨 AI Model: SDXL (Replicate)")
            print("🔑 API Key Status: \(apiKeyStatus)")
        }
        print("⚙️  Mock Generation: \(useMockGeneration ? "ENABLED" : "DISABLED - Using Real AI")")
    }

    // MARK: - Chinese New Year Generation
    enum ImageFormat {
        case iPhone
        case appleWatch
    }

    func generateChineseNewYearGift(
        theme: ChineseNewYearTheme,
        element: ChineseNewYearElement?,
        colorPalette: ChineseNewYearColorPalette,
        message: String,
        contactName: String,
        format: ImageFormat = .iPhone
    ) async throws -> String {

        // Create design specification
        let designSpec = ChineseNewYearDesignSpec(
            theme: theme,
            element: element,
            colorPalette: colorPalette,
            message: message,
            contactName: contactName
        )

        self.currentDesignSpec = designSpec

        // Use mock generation for development/testing
        if useMockGeneration {
            return try await generateMockChineseNewYearImage(designSpec: designSpec)
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
        designSpec: ChineseNewYearDesignSpec,
        format: ImageFormat
    ) async throws -> String {

        print("🎨 ═══════════════════════════════════════════════════════")
        print("🎨 DALL-E 3 Chinese New Year Generation Pipeline")
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
        let elementName = designSpec.element?.name.lowercased().replacingOccurrences(of: " ", with: "") ?? "dragon"
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
        designSpec: ChineseNewYearDesignSpec,
        format: ImageFormat
    ) async throws -> String {

        // Determine dimensions based on format
        let (width, height) = format == .iPhone
            ? (CulturalAIConfiguration.iPhoneWidth, CulturalAIConfiguration.iPhoneHeight)
            : (CulturalAIConfiguration.watchWidth, CulturalAIConfiguration.watchHeight)

        print("🎨 Generating \(format == .iPhone ? "iPhone" : "Apple Watch") format: \(width)x\(height)")

        // Check if using alternative prompt system
        let themeName = designSpec.theme.rawValue.lowercased().replacingOccurrences(of: " ", with: "")
        let elementName = designSpec.element?.name.lowercased().replacingOccurrences(of: " ", with: "") ?? "dragon"
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
            culturalContext: "Chinese New Year",
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
        return "Chinese New Year"
    }

    func generateCulturalGift(
        culturalTheme: Any,
        elements: [Any],
        colorPalette: Any,
        personalMessage: String,
        recipientName: String
    ) async throws -> String {
        guard let theme = culturalTheme as? ChineseNewYearTheme,
              let element = elements.first as? ChineseNewYearElement,
              let palette = colorPalette as? ChineseNewYearColorPalette else {
            throw CulturalAIConfiguration.CulturalAIError.invalidResponse
        }

        return try await generateChineseNewYearGift(
            theme: theme,
            element: element,
            colorPalette: palette,
            message: personalMessage,
            contactName: recipientName
        )
    }

    nonisolated func getCulturalThemes() -> [Any] {
        return ChineseNewYearTheme.allCases
    }

    nonisolated func getCulturalElements() -> [Any] {
        return ChineseNewYearElement.allElements
    }

    nonisolated func getCulturalColorPalettes() -> [Any] {
        return ChineseNewYearColorPalette.allPalettes
    }

    // MARK: - Alternative Natural Language Prompts (4 themes × 4 elements = 16 prompts)
    nonisolated private static let alternativePrompts: [String: (prompt: String, negativePrompt: String)] = [
        // 🏮 TRADITIONAL Theme (传统)
        "traditional-dragon": (
            prompt: "A majestic traditional Chinese dragon in crimson red and brilliant gold, powerful mythical creature with intricate scales coiling through festive lantern-lit atmosphere, authentic Chinese cultural aesthetic, cinematic lighting, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text, traditional art style.",
            negativePrompt: "cartoon, western dragon, low resolution"
        ),
        "traditional-lantern": (
            prompt: "Beautiful traditional red Chinese lanterns glowing warmly against a festive celebration backdrop with golden accents, authentic festival atmosphere, elegant hanging lanterns illuminated from within, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "modern style, neon lights, cartoon"
        ),
        "traditional-firecrackers": (
            prompt: "Traditional red firecrackers in celebratory arrangement with golden fortune symbols, festive Chinese New Year atmosphere, classic cultural aesthetic with red and gold color scheme, cinematic depth, high-resolution wallpaper design for iPhone or Apple Watch.",
            negativePrompt: "modern elements, explosions, chaotic"
        ),
        "traditional-peony": (
            prompt: "Elegant blooming peony flowers in traditional Chinese painting style, prosperity symbols with red and gold tones, classical aesthetic with cultural authenticity, soft atmospheric lighting, designed for iPhone wallpaper or Apple Watch face, high-resolution.",
            negativePrompt: "western flowers, modern art, cartoon"
        ),

        // 🌟 MODERN Theme (现代)
        "modern-dragon": (
            prompt: "Contemporary minimalist Chinese dragon design with sleek modern aesthetics, stylized dragon silhouette in vibrant red tones, clean geometric patterns, sophisticated urban festival vibe, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "traditional ornate style, cluttered"
        ),
        "modern-lantern": (
            prompt: "Modern minimalist red lanterns with contemporary design, sleek clean lines against gradient background, sophisticated festival atmosphere with stylish aesthetics, optimized for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "traditional ornate, vintage style"
        ),
        "modern-firecrackers": (
            prompt: "Contemporary stylized firecracker design with minimalist modern aesthetic, clean geometric celebration symbols in red tones, sophisticated urban vibe, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "traditional ornate, cluttered design"
        ),
        "modern-peony": (
            prompt: "Minimalist modern peony flowers with sleek contemporary aesthetics, stylized floral design in vibrant tones, clean sophisticated composition, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "traditional painting style, ornate"
        ),

        // 👨‍👩‍👧 FAMILY REUNION Theme (团圆)
        "familyreunion-dragon": (
            prompt: "Warm family-themed Chinese dragon design symbolizing togetherness and unity, gentle dragon imagery in cozy red and warm tones, heartwarming reunion atmosphere with soft lighting, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "aggressive, intimidating, cold colors"
        ),
        "familyreunion-lantern": (
            prompt: "Cozy warm red lanterns creating family gathering atmosphere, gentle glowing lights symbolizing togetherness, heartwarming festival ambience with soft red and warm tones, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "formal, cold, isolated"
        ),
        "familyreunion-firecrackers": (
            prompt: "Warm celebratory firecrackers symbolizing family joy and reunion, cozy celebration atmosphere in warm red tones, heartwarming togetherness energy, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "aggressive, chaotic, cold colors"
        ),
        "familyreunion-peony": (
            prompt: "Warm blooming peonies symbolizing family love and togetherness, cozy floral arrangement in gentle red and warm tones, heartwarming reunion atmosphere, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "formal, cold colors, isolated"
        ),

        // 💰 PROSPERITY Theme (招财)
        "prosperity-dragon": (
            prompt: "Fortune-bringing Chinese dragon with abundant golden ingots and wealth symbols, prosperity and good luck visualization with brilliant gold and red, luxurious celebration of abundance, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "poverty symbols, dull colors"
        ),
        "prosperity-lantern": (
            prompt: "Golden prosperity lanterns radiating wealth and fortune energy, abundant celebration atmosphere with brilliant gold and red tones, lucky symbols of prosperity, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "plain, dull, poverty imagery"
        ),
        "prosperity-firecrackers": (
            prompt: "Fortune-bringing firecrackers with golden prosperity symbols and wealth visualization, abundant celebration energy in brilliant gold and red, symbols of good luck and riches, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "poverty symbols, dull tones"
        ),
        "prosperity-goldingots": (
            prompt: "Abundant golden Chinese ingots (yuanbao) symbolizing wealth and prosperity, luxurious fortune visualization with brilliant gold tones, traditional wealth symbols in celebratory arrangement, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "poverty, dull colors, modern currency"
        )
    ]

    // MARK: - AI Prompt Creation
    nonisolated func createCulturalPrompt(from designSpec: Any) -> String {
        guard let spec = designSpec as? ChineseNewYearDesignSpec else {
            return "Chinese New Year celebration design"
        }
        return createCulturalPrompt(from: spec)
    }

    nonisolated private func createCulturalPrompt(from spec: ChineseNewYearDesignSpec) -> String {
        // Build lookup key from theme + element
        let themeName = spec.theme.rawValue.lowercased().replacingOccurrences(of: " ", with: "")
        let elementName = spec.element?.name.lowercased().replacingOccurrences(of: " ", with: "") ?? "dragon"
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

        // Replace template placeholders with Chinese New Year-specific content
        prompt = prompt.replacingOccurrences(of: "[CULTURAL_EVENT]", with: "Chinese New Year")

        // Theme-specific styling with boosted SDXL weights
        let themeStyle: String
        switch spec.theme {
        case .traditional:
            themeStyle = "(traditional:2.0), (authentic:1.9), (classic:1.8), (传统:1.7)"
        case .modern:
            themeStyle = "(modern:2.0), (contemporary:1.9), (minimalist:1.8), (现代:1.7)"
        case .familyReunion:
            themeStyle = "(family reunion:2.0), (togetherness:1.9), (warmth:1.8), (团圆:1.7)"
        case .prosperity:
            themeStyle = "(prosperity:2.0), (wealth:1.9), (fortune:1.8), (招财:1.7)"
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
            centreElementsText = "(Chinese New Year decorative focal point:1.3), celebration motifs"
        }
        prompt = prompt.replacingOccurrences(of: "[CENTRE_ELEMENTS]", with: centreElementsText)

        // Supporting elements
        prompt = prompt.replacingOccurrences(of: "[SUPPORTING_ELEMENTS]", with: "elegant Chinese cultural decorative flourishes")

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
    nonisolated private func buildForbiddenElementsPrompt(selectedElement: ChineseNewYearElement?) -> String {
        // All possible centerpiece elements
        let allElementNames = ["Dragon", "Lantern", "Firecrackers", "Peony", "Gold Ingots"]

        // If no element selected, forbid all specific elements
        guard let selected = selectedElement else {
            return "dragon, lantern, firecrackers, peony, gold ingots, no centerpiece element"
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
    private func generateMockChineseNewYearImage(designSpec: ChineseNewYearDesignSpec) async throws -> String {
        print("🧪 Using mock Chinese New Year generation...")

        // Simulate API call delay with progress updates
        for index in 1...10 {
            try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
            await MainActor.run {
                self.generationProgress = 0.3 + (Float(index) * 0.07)
            }
        }

        // Return mock image URL
        let mockImageURL = "mock_chinesenewyear_\(designSpec.theme.rawValue.lowercased())_\(UUID().uuidString.prefix(8))"

        print("✅ Mock Chinese New Year generation completed: \(mockImageURL)")
        return mockImageURL
    }
}

// MARK: - Data Models
struct ChineseNewYearDesignSpec {
    let theme: ChineseNewYearTheme
    let element: ChineseNewYearElement?
    let colorPalette: ChineseNewYearColorPalette
    let message: String
    let contactName: String
    let timestamp: Date = Date()
}
