import Foundation
import SwiftUI
import Combine

// MARK: - Hanukkah AI Generation Service
@MainActor
class HanukkahAIService: BaseCulturalAIService, CulturalAIServiceProtocol {
    static let shared = HanukkahAIService()

    @Published var generatedImage: String?

    // Hanukkah-specific configuration
    private let useMockGeneration = false // ✅ REAL AI GENERATION ENABLED
    private let useDALLE3 = true // 🎨 DALL-E 3 ENABLED (Primary AI)
    private var currentDesignSpec: HanukkahDesignSpec?

    // DALL-E 3 service instance
    private let dalle3Service = DALLE3Service.shared

    override init() {
        super.init()
        print("🕎 HanukkahAIService initialized")
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

    // MARK: - Hanukkah Generation
    enum ImageFormat {
        case iPhone
        case appleWatch
    }

    func generateHanukkahGift(
        theme: HanukkahTheme,
        element: HanukkahElement?,
        colorPalette: HanukkahColorPalette,
        message: String,
        contactName: String,
        format: ImageFormat = .iPhone
    ) async throws -> String {

        // Create design specification
        let designSpec = HanukkahDesignSpec(
            theme: theme,
            element: element,
            colorPalette: colorPalette,
            message: message,
            contactName: contactName
        )

        self.currentDesignSpec = designSpec

        // Use mock generation for development/testing
        if useMockGeneration {
            return try await generateMockHanukkahImage(designSpec: designSpec)
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
        designSpec: HanukkahDesignSpec,
        format: ImageFormat
    ) async throws -> String {

        print("🎨 ═══════════════════════════════════════════════════════")
        print("🎨 DALL-E 3 Hanukkah Generation Pipeline")
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
        let themeName = designSpec.theme.rawValue.lowercased().replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
        let elementName = designSpec.element?.name.lowercased().replacingOccurrences(of: " ", with: "") ?? "menorah"
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
        designSpec: HanukkahDesignSpec,
        format: ImageFormat
    ) async throws -> String {

        // Determine dimensions based on format
        let (width, height) = format == .iPhone
            ? (CulturalAIConfiguration.iPhoneWidth, CulturalAIConfiguration.iPhoneHeight)
            : (CulturalAIConfiguration.watchWidth, CulturalAIConfiguration.watchHeight)

        print("🎨 Generating Hanukkah image with SDXL...")
        print("   Format: \(format == .iPhone ? "iPhone" : "Apple Watch") (\(width)x\(height))")

        let prompt = createCulturalPrompt(from: designSpec)
        let negativePrompt = "low quality, blurry, distorted, text, watermark, ugly, bad anatomy"

        // Call inherited SDXL generation from BaseCulturalAIService
        return try await generateCulturalGift(
            prompt: prompt,
            culturalContext: "Hanukkah",
            width: width,
            height: height,
            primaryColor: designSpec.colorPalette.primaryHex,
            secondaryColor: designSpec.colorPalette.secondaryHex,
            accentColor: designSpec.colorPalette.accentHex,
            additionalNegativePrompt: negativePrompt
        )
    }

    // MARK: - Mock Generation
    private func generateMockHanukkahImage(designSpec: HanukkahDesignSpec) async throws -> String {
        print("🎭 Mock generation: Hanukkah image")
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        return "https://picsum.photos/1024/1792"
    }

    // MARK: - Prompt Creation
    nonisolated private func createCulturalPrompt(from designSpec: HanukkahDesignSpec) -> String {
        let themeDesc = designSpec.theme.description
        let elementModifier = designSpec.element?.aiPromptModifier ?? "magnificent nine-branched menorah as central focal point"
        let colorHint = designSpec.colorPalette.aiColorHint

        return """
        Beautiful Hanukkah Festival of Lights celebration scene with \(elementModifier), \
        \(themeDesc), \(colorHint), traditional Jewish cultural aesthetic, \
        festive winter atmosphere, cinematic lighting, designed for iPhone wallpaper or Apple Watch face, \
        high-resolution, no text, culturally authentic art.
        """
    }

    // MARK: - Design Specification
    struct HanukkahDesignSpec {
        let theme: HanukkahTheme
        let element: HanukkahElement?
        let colorPalette: HanukkahColorPalette
        let message: String
        let contactName: String
    }

    // MARK: - Protocol Conformance
    nonisolated var culturalEventType: String {
        return "Hanukkah"
    }

    func generateCulturalGift(
        culturalTheme: Any,
        elements: [Any],
        colorPalette: Any,
        personalMessage: String,
        recipientName: String
    ) async throws -> String {
        guard let theme = culturalTheme as? HanukkahTheme,
              let element = elements.first as? HanukkahElement,
              let palette = colorPalette as? HanukkahColorPalette else {
            throw CulturalAIConfiguration.CulturalAIError.invalidResponse
        }

        return try await generateHanukkahGift(
            theme: theme,
            element: element,
            colorPalette: palette,
            message: personalMessage,
            contactName: recipientName
        )
    }

    nonisolated func getCulturalThemes() -> [Any] {
        return HanukkahTheme.allCases
    }

    nonisolated func getCulturalElements() -> [Any] {
        return HanukkahElement.allElements
    }

    nonisolated func getCulturalColorPalettes() -> [Any] {
        return HanukkahColorPalette.allPalettes
    }

    nonisolated func createCulturalPrompt(from designSpec: Any) -> String {
        guard let spec = designSpec as? HanukkahDesignSpec else {
            return "Hanukkah celebration design"
        }
        return createCulturalPrompt(from: spec)
    }

    // MARK: - Alternative Natural Language Prompts (4 themes × 8 elements = 32 prompts)
    // CONTENT FILTER SAFE: Using "traditional", "cultural", "festive" instead of "sacred", "spiritual", "divine"
    nonisolated private static let alternativePrompts: [String: (prompt: String, negativePrompt: String)] = [
        // 🕎 TRADITIONAL Theme
        "traditional-menorah": (
            prompt: "Magnificent nine-branched menorah glowing warmly as centerpiece of traditional Hanukkah celebration, all candles lit with radiant flame, beautiful traditional Jewish cultural atmosphere with authentic festival elements, warm golden and blue tones, cinematic depth, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text, traditional art style.",
            negativePrompt: "cartoon, low resolution"
        ),
        "traditional-dreidel": (
            prompt: "Beautiful traditional dreidel spinning with Hebrew letters visible, authentic Hanukkah game piece showcased with cultural artistry, traditional festival colors with royal blue and gold tones, festive family atmosphere, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "modern style, plain"
        ),
        "traditional-starofdavid": (
            prompt: "Elegant Star of David in traditional Jewish artistic style, beautiful cultural symbol with authentic design patterns, royal blue and gold tones with white accents, Hanukkah festival atmosphere, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "modern geometric, minimal"
        ),
        "traditional-hanukkahcandles": (
            prompt: "Beautiful traditional Hanukkah candles burning brightly in warm celebration, eight candles plus shamash glowing with festive light, traditional blue and gold cultural atmosphere, authentic Jewish festival ambiance, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "modern LED, electric lights"
        ),
        "traditional-oillamp": (
            prompt: "Traditional oil lamp glowing with warm flame in Hanukkah celebration, authentic cultural vessel with elegant design, festival atmosphere with golden light and blue accents, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "modern style, electric"
        ),
        "traditional-geltcoins": (
            prompt: "Traditional chocolate gelt coins displayed elegantly for Hanukkah celebration, golden wrapped coins with authentic cultural presentation, festive blue and gold atmosphere, warm traditional Jewish festival ambiance, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "real coins, modern packaging"
        ),
        "traditional-hebrewletters": (
            prompt: "Elegant Hebrew calligraphy celebrating Hanukkah, beautiful traditional script with artistic flourishes, cultural lettering in royal blue and gold, authentic Jewish festival aesthetic, designed for iPhone wallpaper or Apple Watch face, high-resolution, minimal text.",
            negativePrompt: "printed font, modern typography"
        ),
        "traditional-blue&whiteribbons": (
            prompt: "Beautiful blue and white ribbons flowing elegantly in traditional Hanukkah celebration, cultural colors decorating festive scene with graceful movement, traditional Jewish festival atmosphere with royal blue and white accents, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "modern style, solid colors"
        ),

        // ✨ MIRACLE Theme
        "miracle-menorah": (
            prompt: "Miraculous menorah radiating brilliant light in Hanukkah celebration, all branches glowing with extraordinary flame representing eight days of light, traditional festival miracle atmosphere with golden radiance and blue accents, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "dark, minimal light"
        ),
        "miracle-dreidel": (
            prompt: "Spinning dreidel glowing with miracle light in Hanukkah celebration, traditional game piece surrounded by festive radiance, cultural atmosphere celebrating eight days of light, blue and gold miracle ambiance, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "static, plain"
        ),
        "miracle-starofdavid": (
            prompt: "Star of David shining brilliantly in Hanukkah miracle celebration, cultural symbol radiating with festive light, traditional blue and gold atmosphere celebrating eight days of illumination, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "dark, minimal"
        ),
        "miracle-hanukkahcandles": (
            prompt: "Miraculous Hanukkah candles burning with extraordinary light, eight flames lasting beyond expectation in traditional celebration, cultural miracle atmosphere with radiant golden glow and blue accents, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "dim, fading light"
        ),
        "miracle-oillamp": (
            prompt: "Traditional oil lamp glowing with miraculous light in Hanukkah celebration, small vessel burning for eight days with festive radiance, cultural miracle atmosphere with golden glow and blue tones, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "empty, unlit"
        ),
        "miracle-geltcoins": (
            prompt: "Golden gelt coins shimmering with miracle light in Hanukkah celebration, chocolate treasures glowing with festive radiance, cultural atmosphere celebrating eight days of abundance, blue and gold miracle ambiance, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "plain, dull"
        ),
        "miracle-hebrewletters": (
            prompt: "Hebrew letters glowing with miracle light celebrating Hanukkah, beautiful script radiating with festive illumination, cultural calligraphy in brilliant blue and gold, eight days of light atmosphere, designed for iPhone wallpaper or Apple Watch face, high-resolution, minimal text.",
            negativePrompt: "dark, plain"
        ),
        "miracle-blue&whiteribbons": (
            prompt: "Blue and white ribbons glowing with miracle light in Hanukkah celebration, cultural colors radiating with festive illumination, ribbons dancing with extraordinary brilliance for eight days, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "plain, dull"
        ),

        // 👨‍👩‍👧‍👦 FAMILY Theme
        "family-menorah": (
            prompt: "Warm family gathering around glowing menorah for Hanukkah celebration, togetherness and tradition atmosphere with all branches lit, heartwarming cultural scene with golden light and blue accents, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "solitary, empty"
        ),
        "family-dreidel": (
            prompt: "Family playing dreidel together in joyful Hanukkah celebration, heartwarming scene of togetherness with traditional game, children and adults enjoying festive tradition, warm cultural atmosphere with blue and gold tones, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "alone, serious"
        ),
        "family-starofdavid": (
            prompt: "Family celebrating under Star of David during Hanukkah gathering, heartwarming togetherness scene with cultural symbol overhead, warm traditional atmosphere with blue and gold festival colors, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "solitary, formal"
        ),
        "family-hanukkahcandles": (
            prompt: "Family lighting Hanukkah candles together in warm celebration, heartwarming togetherness ritual with eight flames glowing, traditional cultural bonding atmosphere with golden light, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "alone, cold"
        ),
        "family-oillamp": (
            prompt: "Family admiring traditional oil lamp during Hanukkah celebration, heartwarming scene of generations together appreciating cultural heritage, warm festival atmosphere with golden glow and blue accents, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "solitary, modern"
        ),
        "family-geltcoins": (
            prompt: "Family sharing gelt coins together in Hanukkah celebration, heartwarming scene of giving and togetherness with chocolate treasures, warm cultural atmosphere with festive joy, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "individual, formal"
        ),
        "family-hebrewletters": (
            prompt: "Family creating Hebrew blessings together for Hanukkah celebration, heartwarming scene of cultural teaching across generations, warm traditional atmosphere with artistic lettering, designed for iPhone wallpaper or Apple Watch face, high-resolution, minimal text.",
            negativePrompt: "individual, printed"
        ),
        "family-blue&whiteribbons": (
            prompt: "Family decorating with blue and white ribbons together for Hanukkah celebration, heartwarming togetherness scene with cultural colors creating festive atmosphere, warm family bonding with traditional Jewish decorations, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "solitary, minimal decor"
        ),

        // 🎨 MODERN Theme
        "modern-menorah": (
            prompt: "Minimalist contemporary menorah design for Hanukkah celebration, clean geometric composition with sleek modern aesthetics, sophisticated urban celebration vibe with blue and silver tones, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "traditional ornate, cluttered"
        ),
        "modern-dreidel": (
            prompt: "Contemporary minimalist dreidel with modern design aesthetics, sleek geometric form with clean lines and gradient colors, sophisticated Hanukkah celebration style, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "traditional ornate, vintage"
        ),
        "modern-starofdavid": (
            prompt: "Stylized geometric Star of David with modern minimalist design, clean contemporary interpretation of cultural symbol, sophisticated urban aesthetic with abstract forms and blue tones, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "traditional realistic, ornate"
        ),
        "modern-hanukkahcandles": (
            prompt: "Contemporary minimalist Hanukkah candles with sleek modern design, clean geometric flame forms with gradient glow, sophisticated urban celebration aesthetic with blue and silver, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "traditional wax, ornate"
        ),
        "modern-oillamp": (
            prompt: "Minimalist stylized oil lamp with contemporary design, clean geometric vessel form for modern Hanukkah aesthetic, sophisticated urban celebration with abstract shapes and blue gradients, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "traditional ornate, realistic"
        ),
        "modern-geltcoins": (
            prompt: "Contemporary minimalist gelt representation with sleek modern design, clean geometric coin forms with gradient metallic finish, sophisticated Hanukkah celebration style, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "traditional chocolate, ornate"
        ),
        "modern-hebrewletters": (
            prompt: "Contemporary stylized Hebrew typography for Hanukkah celebration, modern minimalist interpretation of cultural script with clean geometric forms, sophisticated urban aesthetic with blue gradients, designed for iPhone wallpaper or Apple Watch face, high-resolution, minimal text.",
            negativePrompt: "traditional calligraphy, ornate"
        ),
        "modern-blue&whiteribbons": (
            prompt: "Minimalist abstract blue and white ribbons with modern geometric design, clean contemporary flowing forms for Hanukkah celebration, sophisticated urban aesthetic with gradient blue and white tones, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "traditional fabric, ornate"
        )
    ]
}
