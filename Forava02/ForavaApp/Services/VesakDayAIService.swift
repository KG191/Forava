import Foundation
import SwiftUI
import Combine

// MARK: - Vesak Day AI Generation Service
@MainActor
class VesakDayAIService: BaseCulturalAIService, CulturalAIServiceProtocol {
    static let shared = VesakDayAIService()

    @Published var generatedImage: String?

    // Vesak Day-specific configuration
    private let useMockGeneration = false // ✅ REAL AI GENERATION ENABLED
    private let useDALLE3 = true // 🎨 DALL-E 3 ENABLED (Primary AI)
    private var currentDesignSpec: VesakDayDesignSpec?

    // DALL-E 3 service instance
    private let dalle3Service = DALLE3Service.shared

    override init() {
        super.init()
        print("🪷 VesakDayAIService initialized")
        if useDALLE3 {
            print("🎨 AI Model: DALL-E 3 (OpenAI) - Superior prompt following")
            // Check OpenAI API key availability
            let openAIKey = dalle3Service.apiKey
            print("🔑 OpenAI API Status: \(openAIKey.isEmpty ? "❌ NOT CONFIGURED" : "✅ CONFIGURED (\(openAIKey.prefix(8))...)")")
        } else {
            print("🎨 AI Model: SDXL (Replicate)")
            print("🔑 Replicate API Status: \(apiKeyStatus)")
        }
        print("⚙️  Mock Generation: \(useMockGeneration ? "ENABLED" : "DISABLED - Using Real AI")")
    }

    // MARK: - Vesak Day Generation
    enum ImageFormat {
        case iPhone
        case appleWatch
    }

    func generateVesakDayGift(
        theme: VesakDayTheme,
        element: VesakDayElement?,
        colorPalette: VesakDayColorPalette,
        message: String,
        contactName: String,
        format: ImageFormat = .iPhone
    ) async throws -> String {

        // Create design specification
        let designSpec = VesakDayDesignSpec(
            theme: theme,
            element: element,
            colorPalette: colorPalette,
            message: message,
            contactName: contactName
        )

        self.currentDesignSpec = designSpec

        // Use mock generation for development/testing
        if useMockGeneration {
            return try await generateMockVesakDayImage(designSpec: designSpec)
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
        designSpec: VesakDayDesignSpec,
        format: ImageFormat
    ) async throws -> String {

        print("🎨 ═══════════════════════════════════════════════════════")
        print("🎨 DALL-E 3 Vesak Day Generation Pipeline")
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
        let elementName = designSpec.element?.name.lowercased().replacingOccurrences(of: " ", with: "") ?? "lotusflower"
        let lookupKey = "\(themeName)-\(elementName)"

        let basePrompt: String
        let negativePrompt: String

        if let alternativePrompt = Self.alternativePrompts[lookupKey] {
            // Use alternative natural language prompt
            print("📝 Using alternative prompt for: \(lookupKey)")
            basePrompt = alternativePrompt.prompt
            // CRITICAL: Do NOT use negative prompt - DALL-E 3 rejects ANY negative instructions
            negativePrompt = ""
        } else {
            // Fallback to programmatic generation
            print("⚙️  Using programmatic prompt for: \(lookupKey)")
            basePrompt = createCulturalPrompt(from: designSpec)
            // CRITICAL: Do NOT use negative prompt - DALL-E 3 rejects ANY negative instructions
            negativePrompt = ""
        }

        // Format-specific prompt adjustments
        let prompt: String
        switch format {
        case .iPhone:
            prompt = basePrompt
            print("📱 Using portrait composition (iPhone)")
        case .appleWatch:
            // Apple Watch: Emphasize centered, square composition
            let watchSuffix = " Centered square composition, balanced symmetrical layout, "
                + "main subject in center, square 1:1 aspect ratio."
            prompt = basePrompt + watchSuffix
            print("⌚ Using square composition (Apple Watch)")
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
        designSpec: VesakDayDesignSpec,
        format: ImageFormat
    ) async throws -> String {

        // Determine dimensions based on format
        let (width, height) = format == .iPhone
            ? (CulturalAIConfiguration.iPhoneWidth, CulturalAIConfiguration.iPhoneHeight)
            : (CulturalAIConfiguration.watchWidth, CulturalAIConfiguration.watchHeight)

        print("🎨 Generating \(format == .iPhone ? "iPhone" : "Apple Watch") format: \(width)x\(height)")

        // Check if using alternative prompt system
        let themeName = designSpec.theme.rawValue.lowercased().replacingOccurrences(of: " ", with: "")
        let elementName = designSpec.element?.name.lowercased().replacingOccurrences(of: " ", with: "") ?? "lotusflower"
        let lookupKey = "\(themeName)-\(elementName)"

        let basePrompt: String
        let additionalNegativePrompt: String

        if let alternativePrompt = Self.alternativePrompts[lookupKey] {
            // 🔄 USING ALTERNATIVE PROMPT SYSTEM
            print("🔄 Alternative prompt system active for: \(lookupKey)")
            basePrompt = alternativePrompt.prompt

            // Build combined negative prompt
            let forbiddenElements = buildForbiddenElementsPrompt(selectedElement: designSpec.element)
            additionalNegativePrompt = "\(alternativePrompt.negativePrompt), \(forbiddenElements)"

            print("🚫 Combined negative prompt: \(additionalNegativePrompt)")
        } else {
            // ⚙️ FALLBACK: Programmatic prompt generation
            print("⚙️ Using programmatic prompt generation for: \(lookupKey)")
            basePrompt = createCulturalPrompt(from: designSpec)

            // Build element-exclusion negative prompt
            additionalNegativePrompt = buildForbiddenElementsPrompt(selectedElement: designSpec.element)
        }

        // Format-specific prompt adjustments for SDXL
        let prompt: String
        switch format {
        case .iPhone:
            prompt = basePrompt
            print("📱 SDXL using portrait composition (iPhone)")
        case .appleWatch:
            // Apple Watch: Emphasize centered, square composition
            let watchSuffix = " Centered square composition, balanced symmetrical layout, "
                + "main subject in center, square 1:1 aspect ratio"
            prompt = basePrompt + watchSuffix
            print("⌚ SDXL using square composition (Apple Watch)")
        }

        // Get color palette components for SDXL
        let colors = designSpec.colorPalette
        let primaryColorBase: String
        let secondaryColorBase: String
        let accentColorBase: String

        // Extract base colors from hex codes
        let primaryHex = colors.primaryColor
        let secondaryHex = colors.secondaryColor
        let accentHex = colors.accentColor

        // Convert hex to color names
        primaryColorBase = hexToColorName(primaryHex)
        secondaryColorBase = hexToColorName(secondaryHex)
        accentColorBase = hexToColorName(accentHex)

        // Use centralized generation with cultural context
        return try await generateCulturalGift(
            prompt: enhanceCulturalPrompt(prompt),
            culturalContext: "Vesak Day",
            width: width,
            height: height,
            primaryColor: primaryColorBase,
            secondaryColor: secondaryColorBase,
            accentColor: accentColorBase,
            additionalNegativePrompt: additionalNegativePrompt
        )
    }

    // MARK: - Protocol Implementation

    nonisolated var culturalEventType: String {
        return "Vesak Day"
    }

    func generateCulturalGift(
        culturalTheme: Any,
        elements: [Any],
        colorPalette: Any,
        personalMessage: String,
        recipientName: String
    ) async throws -> String {
        guard let theme = culturalTheme as? VesakDayTheme,
              let element = elements.first as? VesakDayElement,
              let palette = colorPalette as? VesakDayColorPalette else {
            throw CulturalAIConfiguration.CulturalAIError.invalidResponse
        }

        return try await generateVesakDayGift(
            theme: theme,
            element: element,
            colorPalette: palette,
            message: personalMessage,
            contactName: recipientName
        )
    }

    nonisolated func getCulturalThemes() -> [Any] {
        return VesakDayTheme.allCases
    }

    nonisolated func getCulturalElements() -> [Any] {
        return VesakDayElement.allElements
    }

    nonisolated func getCulturalColorPalettes() -> [Any] {
        return VesakDayColorPalette.allPalettes
    }

    // MARK: - Alternative Natural Language Prompts (4 themes × 4 elements = 16 prompts)
    nonisolated private static let alternativePrompts: [String: (prompt: String, negativePrompt: String)] = [
        // 🏮 TRADITIONAL Theme
        "traditional-lotusflower": (
            prompt: "A beautiful sacred lotus flower blooming radiantly in the center, authentic Buddhist festival aesthetic with soft pink and white petals, spiritual Vesak Day atmosphere with golden light, traditional art style celebrating Buddha's birth, enlightenment and parinirvana, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "modern style, neon lights, cartoon, inappropriate cultural elements"
        ),
        "traditional-buddha": (
            prompt: "A serene traditional Buddha statue in peaceful meditation pose as centerpiece, authentic Buddhist aesthetic with golden tones and sacred atmosphere, calm spiritual Vesak Day celebration with temple setting, traditional art style honoring Buddha's teachings, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "disrespectful imagery, modern cartoon, inappropriate elements"
        ),
        "traditional-dharmawheel": (
            prompt: "A sacred Dharma wheel prominently centered with authentic Buddhist symbolism, traditional golden temple aesthetic representing the Noble Eightfold Path, spiritual Vesak Day atmosphere with 8 spokes symbolizing Buddha's teachings, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "modern minimalist, neon, cartoon style"
        ),
        "traditional-bodhitree": (
            prompt: "A majestic sacred Bodhi tree as centerpiece under which Buddha attained enlightenment, traditional Buddhist aesthetic with golden spiritual atmosphere, authentic Vesak Day celebration with temple setting and soft lighting, reverent art style, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "modern elements, cartoon, ordinary tree"
        ),

        // 💡 ENLIGHTENMENT Theme
        "enlightenment-lotusflower": (
            prompt: "A luminous lotus flower radiating enlightenment energy as focal point, petals glowing with wisdom light representing spiritual awakening, golden Buddha rays emanating from the sacred bloom, peaceful Vesak Day celebration of Buddha's enlightenment, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "dark tones, aggressive imagery, mundane flowers"
        ),
        "enlightenment-buddha": (
            prompt: "Buddha in profound enlightenment moment under Bodhi tree as centerpiece, radiant golden aura of wisdom surrounding the awakened one, spiritual breakthrough atmosphere with divine light rays, celebrating Buddha's supreme insight on Vesak Day, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "sleeping Buddha, dark atmosphere, disrespectful"
        ),
        "enlightenment-dharmawheel": (
            prompt: "A glowing Dharma wheel radiating enlightenment wisdom as central focal point, golden light emanating from the sacred symbol of Buddha's teachings, spiritual awakening atmosphere representing the path to nirvana, Vesak Day celebration of wisdom, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "static symbol, dark tones, modern minimalist"
        ),
        "enlightenment-bodhitree": (
            prompt: "The sacred Bodhi tree glowing with enlightenment energy as Buddha attained supreme wisdom beneath it, radiant golden leaves symbolizing spiritual awakening, divine light filtering through branches representing the moment of enlightenment, Vesak Day celebration, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "ordinary tree, dark atmosphere, modern style"
        ),

        // 🌸 COMPASSION Theme
        "compassion-lotusflower": (
            prompt: "A gentle soft pink lotus flower embodying loving-kindness as centerpiece, tender petals radiating compassion and metta energy, warm peaceful atmosphere symbolizing Buddha's teachings of karuna, heartwarming Vesak Day celebration of compassion, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "aggressive imagery, cold colors, harsh lighting"
        ),
        "compassion-buddha": (
            prompt: "A compassionate Buddha figure with gentle blessing mudra as focal point, serene loving-kindness expression radiating metta and karuna, soft warm pink and gold tones creating peaceful atmosphere, Vesak Day celebration of Buddha's infinite compassion, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "stern expression, aggressive pose, cold atmosphere"
        ),
        "compassion-dharmawheel": (
            prompt: "A gentle Dharma wheel surrounded by soft pink lotus petals symbolizing compassion, loving-kindness energy radiating from the sacred symbol, warm peaceful atmosphere representing Buddha's teachings of metta, Vesak Day celebration of compassionate heart, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "harsh imagery, aggressive symbols, cold tones"
        ),
        "compassion-bodhitree": (
            prompt: "The sacred Bodhi tree with soft pink blossoms representing loving-kindness, gentle compassionate atmosphere with warm golden light, peaceful metta energy flowing from branches, Vesak Day celebration of Buddha's compassionate teachings, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "harsh environment, aggressive imagery, cold atmosphere"
        ),

        // 🎨 MODERN Theme
        "modern-lotusflower": (
            prompt: "A contemporary minimalist lotus flower design with sleek modern aesthetics as centerpiece, stylized sacred symbol in elegant gradient tones, clean geometric spiritual composition, sophisticated urban Buddhist meditation vibe for Vesak Day, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "traditional ornate, cluttered design, vintage"
        ),
        "modern-buddha": (
            prompt: "A contemporary minimalist Buddha silhouette with sleek modern aesthetics, stylized meditation pose in elegant monochrome or gradient tones, clean geometric spiritual design, sophisticated urban Vesak Day celebration, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "traditional ornate, detailed features, vintage"
        ),
        "modern-dharmawheel": (
            prompt: "A minimalist modern Dharma wheel design with sleek contemporary aesthetics as focal point, clean geometric sacred symbol in elegant tones, sophisticated urban Buddhist spiritual vibe, stylish Vesak Day celebration with modern zen atmosphere, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "traditional ornate, complex patterns, vintage"
        ),
        "modern-bodhitree": (
            prompt: "A contemporary stylized Bodhi tree with minimalist modern aesthetics, sleek geometric branches and leaves in elegant tones, clean sophisticated sacred symbol design, urban zen Vesak Day celebration atmosphere, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "traditional realistic, ornate details, vintage"
        )
    ]

    // MARK: - AI Prompt Creation
    nonisolated func createCulturalPrompt(from designSpec: Any) -> String {
        guard let spec = designSpec as? VesakDayDesignSpec else {
            return "Vesak Day celebration design"
        }
        return createCulturalPrompt(from: spec)
    }

    nonisolated private func createCulturalPrompt(from spec: VesakDayDesignSpec) -> String {
        // Build lookup key from theme + element
        let themeName = spec.theme.rawValue.lowercased().replacingOccurrences(of: " ", with: "")
        let elementName = spec.element?.name.lowercased().replacingOccurrences(of: " ", with: "") ?? "lotusflower"
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

        // Replace template placeholders with Vesak Day-specific content
        prompt = prompt.replacingOccurrences(of: "[CULTURAL_EVENT]", with: "Vesak Day")

        // Theme-specific styling with boosted SDXL weights
        let themeStyle: String
        switch spec.theme {
        case .traditional:
            themeStyle = "(traditional:2.0), (authentic:1.9), (classic Buddhist:1.8), (temple:1.7)"
        case .enlightenment:
            themeStyle = "(enlightenment:2.0), (wisdom:1.9), (spiritual awakening:1.8), (Buddha's insight:1.7)"
        case .compassion:
            themeStyle = "(compassion:2.0), (loving-kindness:1.9), (metta:1.8), (karuna:1.7)"
        case .modern:
            themeStyle = "(modern:2.0), (contemporary:1.9), (minimalist:1.8), (zen:1.7)"
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
            centreElementsText = "(Buddhist sacred symbol focal point:1.3), celebration motifs"
        }
        prompt = prompt.replacingOccurrences(of: "[CENTRE_ELEMENTS]", with: centreElementsText)

        // Supporting elements
        prompt = prompt.replacingOccurrences(of: "[SUPPORTING_ELEMENTS]", with: "elegant Buddhist cultural decorative flourishes, prayer flags, lanterns")

        // Color integration
        let colors = spec.colorPalette
        let primarySimple = hexToColorName(colors.primaryColor)
        let secondarySimple = hexToColorName(colors.secondaryColor)
        let accentSimple = hexToColorName(colors.accentColor)

        prompt = prompt.replacingOccurrences(of: "[PRIMARY_COLOR_SIMPLE]", with: primarySimple)
        prompt = prompt.replacingOccurrences(of: "[SECONDARY_COLOR_SIMPLE]", with: secondarySimple)
        prompt = prompt.replacingOccurrences(of: "[ACCENT_COLOR_SIMPLE]", with: accentSimple)
        prompt = prompt.replacingOccurrences(of: "[BACKGROUND_ATMOSPHERE]", with: colors.backgroundHint)

        // Emotional context
        prompt = prompt.replacingOccurrences(of: "[EMOTIONAL_CONTEXT]", with: "peace, enlightenment, and spiritual awakening")

        print("🎨 FINAL AI PROMPT WITH ALL USER SELECTIONS (PROGRAMMATIC FALLBACK):")
        print("=" + String(repeating: "=", count: 79))
        print(prompt)
        print("=" + String(repeating: "=", count: 79))

        return prompt
    }

    // MARK: - Element Exclusion
    nonisolated private func buildForbiddenElementsPrompt(selectedElement: VesakDayElement?) -> String {
        // All possible centerpiece elements
        let allElementNames = ["Lotus Flower", "Buddha", "Dharma Wheel", "Bodhi Tree"]

        // If no element selected, forbid all specific elements
        guard let selected = selectedElement else {
            return "no centerpiece element, plain background"
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

    // MARK: - Helper: Hex to Color Name Conversion
    nonisolated private func hexToColorName(_ hex: String) -> String {
        let colorMap: [String: String] = [
            "#F99600": "saffron orange",
            "#FFD700": "golden",
            "#FFF8DC": "cream",
            "#FFFFFF": "white",
            "#FFB6C1": "soft pink",
            "#90EE90": "light green",
            "#9370DB": "purple",
            "#E6E6FA": "lavender",
            "#DAA520": "goldenrod",
            "#FFA500": "orange",
            "#87CEEB": "sky blue",
            "#228B22": "forest green",
            "#8B4513": "saddle brown",
            "#000000": "black"
        ]

        return colorMap[hex.uppercased()] ?? "vibrant"
    }

    // MARK: - Mock Generation (for development)
    private func generateMockVesakDayImage(designSpec: VesakDayDesignSpec) async throws -> String {
        print("🧪 Using mock Vesak Day generation...")

        // Simulate API call delay with progress updates
        for index in 1...10 {
            try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
            await MainActor.run {
                self.generationProgress = 0.3 + (Float(index) * 0.07)
            }
        }

        // Return mock image URL
        let mockImageURL = "mock_vesakday_\(designSpec.theme.rawValue.lowercased())_\(UUID().uuidString.prefix(8))"

        print("✅ Mock Vesak Day generation completed: \(mockImageURL)")
        return mockImageURL
    }
}

// MARK: - Data Models
struct VesakDayDesignSpec {
    let theme: VesakDayTheme
    let element: VesakDayElement?
    let colorPalette: VesakDayColorPalette
    let message: String
    let contactName: String
    let timestamp: Date = Date()
}
