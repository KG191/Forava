import Foundation
import SwiftUI
import Combine

// MARK: - Rosh Hashanah AI Generation Service
@MainActor
class RoshHashanahAIService: BaseCulturalAIService, CulturalAIServiceProtocol {
    static let shared = RoshHashanahAIService()

    @Published var generatedImage: String?

    // Rosh Hashanah-specific configuration
    private let useMockGeneration = false // ✅ REAL AI GENERATION ENABLED
    private let useDALLE3 = true // 🎨 DALL-E 3 ENABLED (Primary AI)
    private var currentDesignSpec: RoshHashanahDesignSpec?

    // DALL-E 3 service instance
    private let dalle3Service = DALLE3Service.shared

    override init() {
        super.init()
        print("📯 RoshHashanahAIService initialized")
        if useDALLE3 {
            print("🎨 AI Model: DALL-E 3 (OpenAI) - Superior prompt following")
        } else {
            print("🎨 AI Model: SDXL (Replicate)")
            print("🔑 API Key Status: \(apiKeyStatus)")
        }
        print("⚙️  Mock Generation: \(useMockGeneration ? "ENABLED" : "DISABLED - Using Real AI")")
    }

    // MARK: - Rosh Hashanah Generation
    enum ImageFormat {
        case iPhone
        case appleWatch
    }

    func generateRoshHashanahGift(
        theme: RoshHashanahTheme,
        element: RoshHashanahElement?,
        colorPalette: RoshHashanahColorPalette,
        message: String,
        contactName: String,
        format: ImageFormat = .iPhone
    ) async throws -> String {

        // Create design specification
        let designSpec = RoshHashanahDesignSpec(
            theme: theme,
            element: element,
            colorPalette: colorPalette,
            message: message,
            contactName: contactName
        )

        self.currentDesignSpec = designSpec

        // Use mock generation for development/testing
        if useMockGeneration {
            return try await generateMockRoshHashanahImage(designSpec: designSpec)
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
        designSpec: RoshHashanahDesignSpec,
        format: ImageFormat
    ) async throws -> String {

        print("🎨 ═══════════════════════════════════════════════════════")
        print("🎨 DALL-E 3 Rosh Hashanah Generation Pipeline")
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
        let elementName = designSpec.element?.name.lowercased()
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "&", with: "")
            ?? "shofar"
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
        designSpec: RoshHashanahDesignSpec,
        format: ImageFormat
    ) async throws -> String {

        // Determine dimensions based on format
        let (width, height) = format == .iPhone
            ? (CulturalAIConfiguration.iPhoneWidth, CulturalAIConfiguration.iPhoneHeight)
            : (CulturalAIConfiguration.watchWidth, CulturalAIConfiguration.watchHeight)

        print("🎨 Generating \(format == .iPhone ? "iPhone" : "Apple Watch") format: \(width)x\(height)")

        // Check if using alternative prompt system
        let themeName = designSpec.theme.rawValue.lowercased().replacingOccurrences(of: " ", with: "")
        let elementName = designSpec.element?.name.lowercased()
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "&", with: "")
            ?? "shofar"
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
            culturalContext: "Rosh Hashanah",
            width: width,
            height: height,
            primaryColor: primaryColorBase,
            secondaryColor: secondaryColorBase,
            accentColor: accentColorBase,
            additionalNegativePrompt: additionalNegativePrompt
        )
    }

    // MARK: - Alternative Prompts (16 total: 4 themes × 4 centerpiece elements)
    nonisolated private static let alternativePrompts: [String: (prompt: String, negativePrompt: String)] = [
        // 📯 TRADITIONAL Theme
        "traditional-shofar": (
            prompt: """
A beautiful traditional ram's horn shofar with authentic Jewish New Year aesthetic, \
sacred spiritual instrument with curved natural horn texture in warm brown tones, \
High Holy Days atmosphere with blue and gold accents, cinematic lighting, designed for \
iPhone wallpaper or Apple Watch face, high-resolution, no text, traditional art style.
""",
            negativePrompt: "cartoon, inappropriate cultural elements, low resolution"
        ),
        "traditional-appleshoney": (
            prompt: """
Traditional sweet apples and golden honey arrangement for Rosh Hashanah blessing, \
fresh red apples with honey drizzle in authentic Jewish New Year aesthetic, \
warm inviting composition with blue and gold tones, spiritual celebration atmosphere, \
designed for iPhone or Apple Watch wallpaper, high-resolution, no text.
""",
            negativePrompt: "modern style, neon lights, cartoon"
        ),
        "traditional-starofdavid": (
            prompt: """
Sacred Star of David symbol in traditional royal blue and gold, authentic Jewish \
spiritual aesthetic with elegant six-pointed star design, High Holy Days atmosphere \
with reverent lighting, designed for iPhone wallpaper or Apple Watch face, \
high-resolution, no text, traditional sacred art style.
""",
            negativePrompt: "modern elements, chaotic, inappropriate"
        ),
        "traditional-torahscroll": (
            prompt: """
Sacred Torah scroll with traditional Hebrew calligraphy, authentic Jewish spiritual \
aesthetic with reverent parchment texture and wooden rollers, High Holy Days atmosphere \
in blue and gold tones, designed for iPhone wallpaper or Apple Watch face, \
high-resolution, no text, traditional sacred art.
""",
            negativePrompt: "western religious symbols, modern art, cartoon"
        ),

        // 🌅 RENEWAL Theme
        "renewal-shofar": (
            prompt: """
Ram's horn shofar symbolizing fresh spiritual awakening and new beginnings, bright \
clean aesthetic representing renewal and transformation, hopeful Rosh Hashanah atmosphere \
with fresh blue and gold tones, designed for iPhone wallpaper or Apple Watch face, \
high-resolution, no text, uplifting composition.
""",
            negativePrompt: "dark, gloomy, vintage worn"
        ),
        "renewal-appleshoney": (
            prompt: """
Fresh bright apples and golden honey representing sweet new year and renewal blessings, \
clean vibrant composition symbolizing new beginnings, hopeful uplifting atmosphere with \
fresh blue and gold accents, designed for iPhone or Apple Watch wallpaper, high-resolution, \
no text, bright optimistic aesthetic.
""",
            negativePrompt: "dark tones, gloomy, vintage"
        ),
        "renewal-starofdavid": (
            prompt: """
Bright Star of David symbolizing spiritual renewal and fresh beginnings, clean elegant \
composition in vibrant blue and gold, uplifting hopeful Rosh Hashanah atmosphere, \
designed for iPhone wallpaper or Apple Watch face, high-resolution, no text, \
fresh optimistic aesthetic.
""",
            negativePrompt: "dark, worn, gloomy atmosphere"
        ),
        "renewal-torahscroll": (
            prompt: """
Fresh Torah scroll symbolizing spiritual renewal and new year wisdom, bright clean \
aesthetic with hopeful atmosphere in blue and gold tones, uplifting Rosh Hashanah \
composition representing fresh beginnings, designed for iPhone or Apple Watch wallpaper, \
high-resolution, no text.
""",
            negativePrompt: "dark, worn, vintage aesthetic"
        ),

        // 👨‍👩‍👧 FAMILY Theme
        "family-shofar": (
            prompt: """
Warm cozy shofar creating family gathering atmosphere for High Holy Days, gentle sacred \
tones symbolizing togetherness and unity, heartwarming Rosh Hashanah reunion ambience \
with soft blue and warm golden tones, designed for iPhone wallpaper or Apple Watch face, \
high-resolution, no text, family celebration aesthetic.
""",
            negativePrompt: "aggressive, intimidating, cold colors"
        ),
        "family-appleshoney": (
            prompt: """
Cozy warm apples and honey arrangement for family Rosh Hashanah celebration, heartwarming \
composition symbolizing family togetherness and sweet blessings, gentle warm atmosphere \
with family reunion energy in soft blue and gold, designed for iPhone or Apple Watch \
wallpaper, high-resolution, no text.
""",
            negativePrompt: "formal, cold, isolated"
        ),
        "family-starofdavid": (
            prompt: """
Warm Star of David symbol representing family unity and Jewish heritage, cozy heartwarming \
composition in soft blue and gold tones, family togetherness atmosphere for Rosh Hashanah \
celebration, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text, \
family reunion aesthetic.
""",
            negativePrompt: "aggressive, chaotic, cold colors"
        ),
        "family-torahscroll": (
            prompt: """
Warm Torah scroll blessing family celebration with gentle sacred atmosphere, cozy \
composition symbolizing family heritage and unity in soft blue and golden tones, \
heartwarming Rosh Hashanah reunion blessings, designed for iPhone or Apple Watch wallpaper, \
high-resolution, no text.
""",
            negativePrompt: "formal, cold colors, isolated"
        ),

        // 🌟 MODERN Theme
        "modern-shofar": (
            prompt: """
Contemporary minimalist shofar design with sleek modern Jewish New Year aesthetics, \
stylized ram's horn silhouette in vibrant blue and gold tones, clean geometric patterns, \
sophisticated urban Rosh Hashanah vibe, designed for iPhone wallpaper or Apple Watch face, \
high-resolution, no text, modern elegant style.
""",
            negativePrompt: "traditional ornate style, cluttered"
        ),
        "modern-appleshoney": (
            prompt: """
Modern minimalist apples and honey design with contemporary clean aesthetics, sleek \
geometric composition in vibrant blue and gold against gradient background, sophisticated \
Rosh Hashanah atmosphere with stylish modern vibe, optimized for iPhone or Apple Watch \
wallpaper, high-resolution, no text.
""",
            negativePrompt: "traditional ornate, vintage style"
        ),
        "modern-starofdavid": (
            prompt: """
Contemporary minimalist Star of David with sleek modern aesthetic, clean geometric sacred \
symbol in elegant blue and gold tones, sophisticated spiritual vibe with modern composition, \
designed for iPhone wallpaper or Apple Watch face, high-resolution, no text, \
stylish contemporary design.
""",
            negativePrompt: "traditional ornate, cluttered design"
        ),
        "modern-torahscroll": (
            prompt: """
Minimalist modern artistic interpretation of Torah scroll with sleek contemporary aesthetics, \
stylized sacred design in elegant blue and gold tones, clean sophisticated spiritual \
composition for Rosh Hashanah, designed for iPhone or Apple Watch wallpaper, high-resolution, \
no text, modern minimalist style.
""",
            negativePrompt: "traditional painting style, ornate"
        )
    ]

    // MARK: - AI Prompt Creation
    nonisolated func createCulturalPrompt(from designSpec: Any) -> String {
        guard let spec = designSpec as? RoshHashanahDesignSpec else {
            return "Rosh Hashanah celebration design"
        }
        return createCulturalPrompt(from: spec)
    }

    nonisolated private func createCulturalPrompt(from spec: RoshHashanahDesignSpec) -> String {
        // Build lookup key from theme + element
        let themeName = spec.theme.rawValue.lowercased().replacingOccurrences(of: " ", with: "")
        let elementName = spec.element?.name.lowercased()
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "&", with: "")
            ?? "shofar"
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

        var prompt = "Beautiful Rosh Hashanah celebration design with Jewish New Year aesthetic, "
        prompt += "High Holy Days spiritual atmosphere, "
        prompt += "vibrant royal blue and gold tones, "

        // Add theme style
        switch spec.theme {
        case .traditional:
            prompt += "traditional sacred art style with authentic Jewish heritage, "
        case .renewal:
            prompt += "fresh renewal aesthetic with bright hopeful atmosphere, "
        case .family:
            prompt += "warm family togetherness celebration vibe, "
        case .modern:
            prompt += "contemporary minimalist design with sleek modern aesthetics, "
        }

        // Add centerpiece element
        if let element = spec.element {
            prompt += "featuring \(element.name) as central focal point, "
            prompt += "\(element.aiPromptModifier), "
        }

        // Add color palette
        let colors = spec.colorPalette
        prompt += "incorporating \(colors.name) color scheme with "
        prompt += "\(colors.primaryColor) primary, \(colors.secondaryColor) secondary, "
        prompt += "and \(colors.accentColor) accent tones, "

        prompt += "designed for iPhone wallpaper or Apple Watch face, high-resolution, no text."

        return prompt
    }

    // MARK: - Element Exclusion
    nonisolated private func buildForbiddenElementsPrompt(selectedElement: RoshHashanahElement?) -> String {
        // All possible centerpiece elements
        let allElementNames = ["Shofar", "Apples & Honey", "Star of David", "Torah Scroll"]

        // If no element selected, forbid all specific elements
        guard let selected = selectedElement else {
            return "shofar, apples, honey, star of david, torah, no centerpiece element"
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
    private func generateMockRoshHashanahImage(designSpec: RoshHashanahDesignSpec) async throws -> String {
        print("🎯 MOCK: Generating Rosh Hashanah gift...")
        print("   Theme: \(designSpec.theme.rawValue)")
        print("   Element: \(designSpec.element?.name ?? "None")")
        print("   Palette: \(designSpec.colorPalette.name)")

        // Simulate AI generation delay
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds

        // Return placeholder mock URL
        return "https://via.placeholder.com/1024x1792/4169E1/FFD700?text=Rosh+Hashanah"
    }

    // MARK: - Protocol Requirements
    nonisolated func getCulturalThemes() -> [Any] {
        return RoshHashanahTheme.allCases
    }

    nonisolated func getCulturalElements() -> [Any] {
        return RoshHashanahElement.allElements
    }

    nonisolated func getCulturalColorPalettes() -> [Any] {
        return RoshHashanahColorPalette.allPalettes
    }

    nonisolated var culturalEventType: String {
        return "Rosh Hashanah"
    }

    // MARK: - Helper: Hex to Color Name Conversion
    nonisolated private func hexToColorName(_ hex: String) -> String {
        let colorMap: [String: String] = [
            "#0066CC": "royal blue",
            "#FFD700": "golden",
            "#FFFFFF": "white",
            "#DC143C": "crimson red",
            "#FFF8DC": "cornsilk",
            "#8B4513": "saddle brown",
            "#DAA520": "goldenrod",
            "#F5F5DC": "beige",
            "#8B0000": "dark red",
            "#800020": "burgundy",
            "#191970": "midnight blue",
            "#C0C0C0": "silver",
            "#000000": "black",
            "#4169E1": "royal blue",
            "#87CEEB": "sky blue",
            "#FFFFF0": "ivory"
        ]

        return colorMap[hex.uppercased()] ?? "vibrant"
    }

    // MARK: - CulturalAIServiceProtocol Conformance
    func generateCulturalGift(
        culturalTheme: Any,
        elements: [Any],
        colorPalette: Any,
        personalMessage: String,
        recipientName: String
    ) async throws -> String {
        guard let theme = culturalTheme as? RoshHashanahTheme,
              let roshHashanahElements = elements as? [RoshHashanahElement],
              let palette = colorPalette as? RoshHashanahColorPalette else {
            throw CulturalAIConfiguration.CulturalAIError.invalidResponse
        }

        // Get first element (single selection)
        let element = roshHashanahElements.first

        return try await generateRoshHashanahGift(
            theme: theme,
            element: element,
            colorPalette: palette,
            message: personalMessage,
            contactName: recipientName
        )
    }
}

// MARK: - Design Specification Data Model
struct RoshHashanahDesignSpec {
    let theme: RoshHashanahTheme
    let element: RoshHashanahElement?
    let colorPalette: RoshHashanahColorPalette
    let message: String
    let contactName: String
    let timestamp: Date = Date()
}
