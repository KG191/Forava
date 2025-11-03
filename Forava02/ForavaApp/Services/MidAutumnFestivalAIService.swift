import Foundation
import SwiftUI
import Combine

// MARK: - Mid-Autumn Festival AI Generation Service
@MainActor
class MidAutumnFestivalAIService: BaseCulturalAIService, CulturalAIServiceProtocol {
    static let shared = MidAutumnFestivalAIService()

    @Published var generatedImage: String?

    // Mid-Autumn Festival-specific configuration
    private let useMockGeneration = false // ✅ REAL AI GENERATION ENABLED
    private let useDALLE3 = true // 🎨 DALL-E 3 ENABLED (Primary AI)
    private var currentDesignSpec: MidAutumnFestivalDesignSpec?

    // DALL-E 3 service instance
    private let dalle3Service = DALLE3Service.shared

    override init() {
        super.init()
        print("🌕 MidAutumnFestivalAIService initialized")
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

    // MARK: - Mid-Autumn Festival Generation
    enum ImageFormat {
        case iPhone
        case appleWatch
    }

    func generateMidAutumnFestivalGift(
        theme: MidAutumnFestivalTheme,
        element: MidAutumnFestivalElement?,
        colorPalette: MidAutumnFestivalColorPalette,
        message: String,
        contactName: String,
        format: ImageFormat = .iPhone
    ) async throws -> String {

        // Create design specification
        let designSpec = MidAutumnFestivalDesignSpec(
            theme: theme,
            element: element,
            colorPalette: colorPalette,
            message: message,
            contactName: contactName
        )

        self.currentDesignSpec = designSpec

        // Use mock generation for development/testing
        if useMockGeneration {
            return try await generateMockMidAutumnFestivalImage(designSpec: designSpec)
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
        designSpec: MidAutumnFestivalDesignSpec,
        format: ImageFormat
    ) async throws -> String {

        print("🎨 ═══════════════════════════════════════════════════════")
        print("🎨 DALL-E 3 Mid-Autumn Festival Generation Pipeline")
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
        let elementName = designSpec.element?.name.lowercased().replacingOccurrences(of: " ", with: "") ?? "fullmoon"
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
        designSpec: MidAutumnFestivalDesignSpec,
        format: ImageFormat
    ) async throws -> String {

        // Determine dimensions based on format
        let (width, height) = format == .iPhone
            ? (CulturalAIConfiguration.iPhoneWidth, CulturalAIConfiguration.iPhoneHeight)
            : (CulturalAIConfiguration.watchWidth, CulturalAIConfiguration.watchHeight)

        print("🎨 Generating Mid-Autumn Festival image with SDXL...")
        print("   Format: \(format == .iPhone ? "iPhone" : "Apple Watch") (\(width)x\(height))")

        let prompt = createCulturalPrompt(from: designSpec)
        let negativePrompt = "low quality, blurry, distorted, text, watermark, ugly, bad anatomy"

        // Call inherited SDXL generation from BaseCulturalAIService
        return try await generateCulturalGift(
            prompt: prompt,
            culturalContext: "Mid-Autumn Festival",
            width: width,
            height: height,
            primaryColor: designSpec.colorPalette.primaryHex,
            secondaryColor: designSpec.colorPalette.secondaryHex,
            accentColor: designSpec.colorPalette.accentHex,
            additionalNegativePrompt: negativePrompt
        )
    }

    // MARK: - Mock Generation
    private func generateMockMidAutumnFestivalImage(designSpec: MidAutumnFestivalDesignSpec) async throws -> String {
        print("🎭 Mock generation: Mid-Autumn Festival image")
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        return "https://picsum.photos/1024/1792"
    }

    // MARK: - Prompt Creation
    nonisolated private func createCulturalPrompt(from designSpec: MidAutumnFestivalDesignSpec) -> String {
        let themeDesc = designSpec.theme.description
        let elementModifier = designSpec.element?.aiPromptModifier ?? "luminous full moon as central focal point"
        let colorHint = designSpec.colorPalette.aiColorHint

        return """
        Beautiful Mid-Autumn Festival celebration scene with \(elementModifier), \
        \(themeDesc), \(colorHint), traditional Chinese cultural aesthetic, \
        festive autumn atmosphere, cinematic lighting, designed for iPhone wallpaper or Apple Watch face, \
        high-resolution, no text, culturally authentic art.
        """
    }

    // MARK: - Design Specification
    struct MidAutumnFestivalDesignSpec {
        let theme: MidAutumnFestivalTheme
        let element: MidAutumnFestivalElement?
        let colorPalette: MidAutumnFestivalColorPalette
        let message: String
        let contactName: String
    }

    // MARK: - Protocol Conformance
    nonisolated var culturalEventType: String {
        return "Mid-Autumn Festival"
    }

    func generateCulturalGift(
        culturalTheme: Any,
        elements: [Any],
        colorPalette: Any,
        personalMessage: String,
        recipientName: String
    ) async throws -> String {
        guard let theme = culturalTheme as? MidAutumnFestivalTheme,
              let element = elements.first as? MidAutumnFestivalElement,
              let palette = colorPalette as? MidAutumnFestivalColorPalette else {
            throw CulturalAIConfiguration.CulturalAIError.invalidResponse
        }

        return try await generateMidAutumnFestivalGift(
            theme: theme,
            element: element,
            colorPalette: palette,
            message: personalMessage,
            contactName: recipientName
        )
    }

    nonisolated func getCulturalThemes() -> [Any] {
        return MidAutumnFestivalTheme.allCases
    }

    nonisolated func getCulturalElements() -> [Any] {
        return MidAutumnFestivalElement.allElements
    }

    nonisolated func getCulturalColorPalettes() -> [Any] {
        return MidAutumnFestivalColorPalette.allPalettes
    }

    nonisolated func createCulturalPrompt(from designSpec: Any) -> String {
        guard let spec = designSpec as? MidAutumnFestivalDesignSpec else {
            return "Mid-Autumn Festival celebration design"
        }
        return createCulturalPrompt(from: spec)
    }

    // MARK: - Alternative Natural Language Prompts (4 themes × 8 elements = 32 prompts)
    // CONTENT FILTER SAFE: Using "traditional", "cultural", "festive" instead of "sacred", "spiritual", "divine"
    nonisolated private static let alternativePrompts: [String: (prompt: String, negativePrompt: String)] = [
        // 🌕 TRADITIONAL Theme
        "traditional-fullmoon": (
            prompt: "Magnificent luminous full moon in night sky as centerpiece of traditional Mid-Autumn Festival celebration, bright radiant moonlight illuminating serene landscape with warm golden glow, authentic Chinese cultural atmosphere with elegant autumn elements, cinematic depth, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text, traditional art style.",
            negativePrompt: "cartoon, low resolution"
        ),
        "traditional-mooncakes": (
            prompt: "Beautiful traditional mooncakes with intricate golden patterns and elegant presentation, authentic Mid-Autumn Festival delicacy showcased with cultural artistry, warm festive colors with rich brown and gold tones, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "modern style, plain"
        ),
        "traditional-jaderabbit": (
            prompt: "Mystical jade rabbit in traditional Chinese folklore style, elegant legendary creature under full moon with cultural authenticity, soft jade green and white tones with golden accents, Mid-Autumn Festival atmosphere, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "realistic rabbit, modern style"
        ),
        "traditional-lanterns": (
            prompt: "Beautiful traditional Chinese lanterns glowing warmly in Mid-Autumn Festival night, colorful paper lanterns with authentic designs creating festive atmosphere, red and gold cultural celebration ambiance, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "modern LED, western style"
        ),
        "traditional-osmanthusflowers": (
            prompt: "Delicate osmanthus flowers in traditional Chinese arrangement, fragrant golden blossoms symbolizing Mid-Autumn Festival, elegant floral details with warm autumn colors and cultural authenticity, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "western flowers, bright colors"
        ),
        "traditional-teaset": (
            prompt: "Traditional Chinese tea set with elegant ceramic design for Mid-Autumn Festival celebration, authentic cultural tea ceremony setup with warm tones and refined aesthetics, festive autumn atmosphere, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "modern style, western teapot"
        ),
        "traditional-autumnleaves": (
            prompt: "Beautiful autumn leaves in traditional Chinese artistic style, warm golden and orange foliage creating Mid-Autumn Festival atmosphere, elegant seasonal elements with cultural aesthetic, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "western style, photorealistic"
        ),
        "traditional-chinesecalligraphy": (
            prompt: "Elegant Chinese calligraphy artwork celebrating Mid-Autumn Festival, beautiful brush strokes with traditional ink painting aesthetic, cultural poetry and festive greetings in artistic composition, designed for iPhone or Apple Watch wallpaper, high-resolution, minimal text.",
            negativePrompt: "printed font, western style"
        ),

        // 🥮 MOONCAKES Theme
        "mooncakes-fullmoon": (
            prompt: "Luminous full moon rising above elegant mooncake display, traditional Mid-Autumn Festival scene combining celestial beauty with delicious cultural delicacy, warm golden and brown tones, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "modern style, minimal"
        ),
        "mooncakes-mooncakes": (
            prompt: "Exquisite mooncakes as central focus with intricate golden patterns and rich textures, traditional Mid-Autumn Festival delicacy showcased in elegant gift box arrangement, warm inviting colors with authentic cultural presentation, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "plain, modern packaging"
        ),
        "mooncakes-jaderabbit": (
            prompt: "Charming jade rabbit presenting traditional mooncakes in mythical Mid-Autumn Festival scene, delightful combination of legendary creature and festive delicacy, warm cultural colors with jade green and golden brown, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "realistic, modern style"
        ),
        "mooncakes-lanterns": (
            prompt: "Beautiful mooncakes displayed with glowing lanterns in festive Mid-Autumn Festival setting, warm lantern light illuminating delicious traditional treats, cultural celebration atmosphere with red and gold tones, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "dark, minimal lighting"
        ),
        "mooncakes-osmanthusflowers": (
            prompt: "Elegant mooncakes surrounded by fragrant osmanthus flowers, traditional Mid-Autumn Festival pairing of delicacy and blossoms, warm golden tones with floral accents and cultural authenticity, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "modern style, stark"
        ),
        "mooncakes-teaset": (
            prompt: "Traditional mooncakes beautifully presented with Chinese tea set, authentic Mid-Autumn Festival celebration of food and tea culture, warm inviting atmosphere with cultural elegance, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "western style, coffee"
        ),
        "mooncakes-autumnleaves": (
            prompt: "Delicious mooncakes displayed among colorful autumn leaves, seasonal Mid-Autumn Festival celebration combining festive treat with fall foliage, warm golden and orange tones with cultural charm, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "winter, minimal decor"
        ),
        "mooncakes-chinesecalligraphy": (
            prompt: "Traditional mooncakes elegantly presented with Chinese calligraphy blessing, cultural Mid-Autumn Festival scene combining delicacy with artistic poetry, warm festive colors with authentic aesthetic, designed for iPhone or Apple Watch wallpaper, high-resolution, minimal text.",
            negativePrompt: "printed labels, modern"
        ),

        // 👨‍👩‍👧‍👦 FAMILY Theme
        "family-fullmoon": (
            prompt: "Warm family gathering under luminous full moon for Mid-Autumn Festival celebration, togetherness and reunion atmosphere with bright moonlight creating intimate scene, heartwarming cultural celebration with golden glow, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "solitary, cold atmosphere"
        ),
        "family-mooncakes": (
            prompt: "Family sharing traditional mooncakes together in joyful Mid-Autumn Festival reunion, heartwarming scene of togetherness with delicious treats being passed around, warm loving atmosphere with cultural celebration colors, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "individual, formal"
        ),
        "family-jaderabbit": (
            prompt: "Children delighting in jade rabbit legend during family Mid-Autumn Festival celebration, heartwarming multigenerational scene with mythical storytelling, warm family togetherness atmosphere with cultural charm, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "alone, serious mood"
        ),
        "family-lanterns": (
            prompt: "Family carrying colorful lanterns together in Mid-Autumn Festival celebration, children and adults enjoying festive tradition with glowing lights, heartwarming togetherness atmosphere with cultural joy, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "single person, dark"
        ),
        "family-osmanthusflowers": (
            prompt: "Family admiring fragrant osmanthus flowers during Mid-Autumn Festival garden gathering, heartwarming scene of generations together appreciating natural beauty, warm cultural celebration with floral elegance, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "solitary, formal setting"
        ),
        "family-teaset": (
            prompt: "Family tea ceremony during Mid-Autumn Festival reunion, heartwarming scene of generations sharing traditional tea together, warm cultural bonding atmosphere with authentic tea set, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "individual, modern style"
        ),
        "family-autumnleaves": (
            prompt: "Family enjoying autumn scenery together during Mid-Autumn Festival outing, heartwarming togetherness among golden fall foliage, warm seasonal celebration with cultural family values, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "alone, winter scene"
        ),
        "family-chinesecalligraphy": (
            prompt: "Family creating Chinese calligraphy together for Mid-Autumn Festival greetings, heartwarming scene of cultural teaching and learning across generations, warm bonding atmosphere with artistic tradition, designed for iPhone or Apple Watch wallpaper, high-resolution, minimal text.",
            negativePrompt: "individual, printed"
        ),

        // 🎨 MODERN Theme
        "modern-fullmoon": (
            prompt: "Minimalist contemporary full moon design for Mid-Autumn Festival, clean geometric composition with sleek modern aesthetics, sophisticated urban celebration vibe with cool tones and gradients, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "traditional ornate, cluttered"
        ),
        "modern-mooncakes": (
            prompt: "Contemporary minimalist mooncakes with modern design aesthetics, sleek clean presentation with innovative patterns and gradient colors, sophisticated Mid-Autumn Festival celebration style, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "traditional ornate, vintage"
        ),
        "modern-jaderabbit": (
            prompt: "Stylized geometric jade rabbit with modern minimalist design, clean contemporary interpretation of Mid-Autumn Festival legend, sophisticated urban aesthetic with abstract forms, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "traditional realistic, ornate"
        ),
        "modern-lanterns": (
            prompt: "Contemporary minimalist lanterns with sleek modern lighting design, clean geometric forms with LED-style glow for Mid-Autumn Festival, sophisticated urban celebration aesthetic, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "traditional paper, ornate"
        ),
        "modern-osmanthusflowers": (
            prompt: "Minimalist stylized osmanthus flowers with contemporary design, clean geometric floral patterns for modern Mid-Autumn Festival aesthetic, sophisticated urban celebration with abstract forms, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "traditional realistic, ornate"
        ),
        "modern-teaset": (
            prompt: "Contemporary minimalist tea set with sleek modern design, clean geometric forms with sophisticated aesthetic for Mid-Autumn Festival, urban celebration style with gradient colors, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "traditional ornate, vintage"
        ),
        "modern-autumnleaves": (
            prompt: "Minimalist abstract autumn leaves with modern geometric design, clean contemporary fall aesthetic for Mid-Autumn Festival, sophisticated urban celebration with gradient colors, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "realistic foliage, traditional"
        ),
        "modern-chinesecalligraphy": (
            prompt: "Contemporary stylized Chinese typography for Mid-Autumn Festival, modern minimalist interpretation of calligraphy with clean lines and geometric forms, sophisticated urban aesthetic, designed for iPhone or Apple Watch wallpaper, high-resolution, minimal text.",
            negativePrompt: "traditional brush, ornate"
        )
    ]
}
