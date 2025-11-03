import Foundation
import SwiftUI
import Combine

// MARK: - Raksha Bandhan AI Generation Service
@MainActor
class RakshaBandhanAIService: BaseCulturalAIService, CulturalAIServiceProtocol {
    static let shared = RakshaBandhanAIService()

    @Published var generatedImage: String?

    // Raksha Bandhan-specific configuration
    private let useMockGeneration = false // ✅ REAL AI GENERATION ENABLED
    private let useDALLE3 = true // 🎨 DALL-E 3 ENABLED (Primary AI)
    private var currentDesignSpec: RakshaBandhanDesignSpec?

    // DALL-E 3 service instance
    private let dalle3Service = DALLE3Service.shared

    override init() {
        super.init()
        print("🪷 RakshaBandhanAIService initialized")
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

    // MARK: - Raksha Bandhan Generation
    enum ImageFormat {
        case iPhone
        case appleWatch
    }

    func generateRakshaBandhanGift(
        theme: RakshaBandhanTheme,
        element: RakshaBandhanElement?,
        colorPalette: RakshaBandhanColorPalette,
        message: String,
        contactName: String,
        format: ImageFormat = .iPhone
    ) async throws -> String {

        // Create design specification
        let designSpec = RakshaBandhanDesignSpec(
            theme: theme,
            element: element,
            colorPalette: colorPalette,
            message: message,
            contactName: contactName
        )

        self.currentDesignSpec = designSpec

        // Use mock generation for development/testing
        if useMockGeneration {
            return try await generateMockRakshaBandhanImage(designSpec: designSpec)
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
        designSpec: RakshaBandhanDesignSpec,
        format: ImageFormat
    ) async throws -> String {

        print("🎨 ═══════════════════════════════════════════════════════")
        print("🎨 DALL-E 3 Raksha Bandhan Generation Pipeline")
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
        let elementName = designSpec.element?.name.lowercased().replacingOccurrences(of: " ", with: "") ?? "rakhithread"
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
        designSpec: RakshaBandhanDesignSpec,
        format: ImageFormat
    ) async throws -> String {

        print("🎨 Generating Raksha Bandhan image with SDXL...")

        let prompt = createCulturalPrompt(from: designSpec)
        let negativePrompt = "low quality, blurry, distorted, text, watermark, ugly, bad anatomy"

        // Determine dimensions
        let width: Int
        let height: Int

        switch format {
        case .iPhone:
            width = 1024
            height = 1792  // Portrait for iPhone
        case .appleWatch:
            width = 1024
            height = 1024  // Square for Watch
        }

        return try await generateWithSDXL(
            prompt: prompt,
            negativePrompt: negativePrompt,
            width: width,
            height: height
        )
    }

    // MARK: - Mock Generation
    private func generateMockRakshaBandhanImage(designSpec: RakshaBandhanDesignSpec) async throws -> String {
        print("🎭 Mock generation: Raksha Bandhan image")
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        return "https://picsum.photos/1024/1792"
    }

    // MARK: - Prompt Creation
    private func createCulturalPrompt(from designSpec: RakshaBandhanDesignSpec) -> String {
        let themeDesc = designSpec.theme.description
        let elementModifier = designSpec.element?.aiPromptModifier ?? "traditional rakhi thread with festive celebration"
        let colorHint = designSpec.colorPalette.aiColorHint

        return """
        Beautiful Raksha Bandhan celebration scene with \(elementModifier), \
        \(themeDesc), \(colorHint), traditional Indian cultural aesthetic, \
        festive atmosphere, cinematic lighting, designed for iPhone wallpaper or Apple Watch face, \
        high-resolution, no text, culturally authentic art.
        """
    }

    // MARK: - Design Specification
    struct RakshaBandhanDesignSpec {
        let theme: RakshaBandhanTheme
        let element: RakshaBandhanElement?
        let colorPalette: RakshaBandhanColorPalette
        let message: String
        let contactName: String
    }

    // MARK: - Protocol Conformance
    func generateCulturalGift(
        theme: Any,
        element: Any?,
        colorPalette: Any,
        personalMessage: String,
        recipientName: String
    ) async throws -> String {
        guard let theme = theme as? RakshaBandhanTheme,
              let element = element as? RakshaBandhanElement,
              let palette = colorPalette as? RakshaBandhanColorPalette else {
            throw CulturalAIConfiguration.CulturalAIError.invalidResponse
        }

        return try await generateRakshaBandhanGift(
            theme: theme,
            element: element,
            colorPalette: palette,
            message: personalMessage,
            contactName: recipientName
        )
    }

    nonisolated func getCulturalThemes() -> [Any] {
        return RakshaBandhanTheme.allCases
    }

    nonisolated func getCulturalElements() -> [Any] {
        return RakshaBandhanElement.allElements
    }

    nonisolated func getCulturalColorPalettes() -> [Any] {
        return RakshaBandhanColorPalette.allPalettes
    }

    // MARK: - Alternative Natural Language Prompts (4 themes × 8 elements = 32 prompts)
    // CONTENT FILTER SAFE: Using "traditional", "cultural", "festive" instead of "sacred", "spiritual", "divine"
    nonisolated private static let alternativePrompts: [String: (prompt: String, negativePrompt: String)] = [
        // 🪷 TRADITIONAL Theme (पारंपरिक)
        "traditional-rakhithread": (
            prompt: "Beautiful traditional rakhi thread with intricate colorful design and golden embellishments, elegant protective bond symbol in vibrant festival colors, authentic Indian cultural aesthetic with warm festive atmosphere, cinematic lighting, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text, traditional art style.",
            negativePrompt: "cartoon, low resolution"
        ),
        "traditional-sweetsthali": (
            prompt: "Traditional Indian sweets plate (thali) filled with colorful mithai, ladoo, and barfi, festive Raksha Bandhan celebration arrangement with golden decorations, authentic cultural aesthetic, warm inviting atmosphere, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "western desserts, modern style"
        ),
        "traditional-diya": (
            prompt: "Traditional oil lamp (diya) with warm glowing flame creating festive Raksha Bandhan atmosphere, beautiful cultural lighting with golden and orange tones, elegant celebration ambience, cinematic depth, high-resolution wallpaper design for iPhone or Apple Watch.",
            negativePrompt: "modern candles, dark atmosphere"
        ),
        "traditional-marigold": (
            prompt: "Beautiful orange marigold flowers in traditional Indian celebration arrangement, vibrant festive garland with cultural authenticity, Raksha Bandhan atmosphere with warm tones, soft atmospheric lighting, designed for iPhone wallpaper or Apple Watch face, high-resolution.",
            negativePrompt: "western flowers, muted colors"
        ),
        "traditional-giftbox": (
            prompt: "Elegant traditional gift box with beautiful Indian wrapping and decorative elements, festive Raksha Bandhan presentation with vibrant colors and cultural patterns, warm celebration atmosphere, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "western style, plain wrapping"
        ),
        "traditional-tilakplate": (
            prompt: "Traditional tilak plate with kumkum, rice grains, and decorative elements, authentic Raksha Bandhan cultural setup with warm festive colors, beautiful ceremonial arrangement, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "modern style, minimal design"
        ),
        "traditional-aartithali": (
            prompt: "Traditional aarti thali with beautiful ceremonial items and decorations, festive Raksha Bandhan celebration setup with golden and vibrant accents, authentic Indian cultural aesthetic, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "modern minimalist, western style"
        ),
        "traditional-brothersister": (
            prompt: "Beautiful brother and sister celebrating Raksha Bandhan together in traditional Indian attire, joyful sibling bond moment with festive decorations and warm colors, heartwarming cultural celebration atmosphere, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "western clothing, formal poses"
        ),

        // 💛 BROTHER-SISTER BOND Theme (भाई-बहन का प्यार)
        "brothersisterbond-rakhithread": (
            prompt: "Heartwarming rakhi thread symbolizing beautiful sibling bond, colorful thread with loving care details in warm golden and pink tones, emotional connection visualization with soft festive lighting, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "cold colors, impersonal"
        ),
        "brothersisterbond-sweetsthali": (
            prompt: "Loving sweets thali representing brother-sister celebration together, colorful mithai arranged with care and warmth, heartfelt Raksha Bandhan atmosphere in joyful tones, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "formal, cold atmosphere"
        ),
        "brothersisterbond-diya": (
            prompt: "Warm diya lamp creating intimate sibling celebration atmosphere, gentle flame symbolizing loving bond between brother and sister, heartwarming Raksha Bandhan moment with soft golden glow, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "harsh lighting, cold tones"
        ),
        "brothersisterbond-marigold": (
            prompt: "Beautiful marigold flowers representing joyful sibling love and celebration, warm vibrant blooms in heartfelt arrangement, brother-sister bond visualization with festive orange and gold tones, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "dark flowers, formal arrangement"
        ),
        "brothersisterbond-giftbox": (
            prompt: "Heartfelt gift box exchanged between loving siblings, beautiful wrapping representing brother-sister care and affection, warm Raksha Bandhan celebration with joyful colors, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "impersonal, corporate style"
        ),
        "brothersisterbond-tilakplate": (
            prompt: "Affectionate tilak ceremony plate symbolizing sister's care for brother, warm traditional setup with loving details and soft festive colors, heartwarming sibling bond moment, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "formal, cold atmosphere"
        ),
        "brothersisterbond-aartithali": (
            prompt: "Loving aarti thali prepared with care for sibling celebration, heartfelt Raksha Bandhan ceremony setup with warm golden tones, beautiful brother-sister bond visualization, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "formal, impersonal setup"
        ),
        "brothersisterbond-brothersister": (
            prompt: "Joyful brother and sister sharing loving Raksha Bandhan moment together, heartwarming sibling bond celebration with beautiful smiles and festive atmosphere, emotional connection in warm vibrant colors, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "formal poses, distant"
        ),

        // 🌸 MODERN Theme (आधुनिक)
        "modern-rakhithread": (
            prompt: "Contemporary minimalist rakhi thread design with sleek modern aesthetics, stylized thread in vibrant colors with clean geometric patterns, sophisticated urban festival vibe, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "traditional ornate style, cluttered"
        ),
        "modern-sweetsthali": (
            prompt: "Modern minimalist Indian sweets presentation with contemporary design, sleek clean arrangement against gradient background, sophisticated festival aesthetic, optimized for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "traditional ornate, vintage style"
        ),
        "modern-diya": (
            prompt: "Contemporary stylized diya lamp with minimalist modern aesthetic, clean geometric lighting design with warm glow, sophisticated Raksha Bandhan celebration vibe, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "traditional ornate, cluttered design"
        ),
        "modern-marigold": (
            prompt: "Minimalist modern marigold flowers with sleek contemporary aesthetics, stylized floral design in vibrant orange tones, clean sophisticated composition for Raksha Bandhan, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "traditional painting style, ornate"
        ),
        "modern-giftbox": (
            prompt: "Contemporary minimalist gift box with modern design elements, sleek clean wrapping in vibrant colors, sophisticated Raksha Bandhan celebration aesthetic, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "traditional ornate, cluttered"
        ),
        "modern-tilakplate": (
            prompt: "Modern minimalist tilak plate with contemporary clean design, stylized ceremonial setup with sleek aesthetics and vibrant accents, sophisticated festival atmosphere, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "traditional ornate, vintage"
        ),
        "modern-aartithali": (
            prompt: "Contemporary stylized aarti thali with minimalist modern aesthetic, clean geometric ceremonial design with vibrant colors, sophisticated Raksha Bandhan vibe, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "traditional ornate, cluttered"
        ),
        "modern-brothersister": (
            prompt: "Modern stylized brother-sister celebration with contemporary aesthetics, sleek minimalist design capturing joyful sibling bond, sophisticated urban Raksha Bandhan atmosphere with clean composition, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "traditional poses, ornate style"
        ),

        // 🛡️ PROTECTION PROMISE Theme (रक्षा का वादा)
        "protectionpromise-rakhithread": (
            prompt: "Strong beautiful rakhi thread symbolizing powerful promise of care and protection, vibrant thread with confident design in bold red and gold tones, celebration of commitment and trust, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "weak, faded colors"
        ),
        "protectionpromise-sweetsthali": (
            prompt: "Abundant sweets thali representing joyful promise and celebration of protection, generous arrangement with vibrant festive colors, Raksha Bandhan commitment visualization with warm atmosphere, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "sparse, minimal arrangement"
        ),
        "protectionpromise-diya": (
            prompt: "Bright confident diya flame representing strong promise of care and protection, powerful warm glow in bold golden tones, celebration of Raksha Bandhan commitment with vibrant atmosphere, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "dim light, weak flame"
        ),
        "protectionpromise-marigold": (
            prompt: "Vibrant abundant marigold flowers representing strong promise of care, bold orange and gold blooms in powerful arrangement, celebration of protection commitment with festive energy, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "pale flowers, sparse arrangement"
        ),
        "protectionpromise-giftbox": (
            prompt: "Beautiful substantial gift box representing strong promise and commitment, elegant wrapping with bold festive colors and confident design, Raksha Bandhan celebration of care and protection, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "small, plain wrapping"
        ),
        "protectionpromise-tilakplate": (
            prompt: "Confident traditional tilak plate representing strong promise of care, bold ceremonial setup with vibrant festive colors and powerful presence, Raksha Bandhan commitment celebration, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "minimal, weak design"
        ),
        "protectionpromise-aartithali": (
            prompt: "Abundant aarti thali representing strong celebration of protection promise, generous ceremonial setup with vibrant bold colors and confident arrangement, powerful Raksha Bandhan commitment visualization, designed for iPhone wallpaper or Apple Watch face, high-resolution, no text.",
            negativePrompt: "sparse, minimal setup"
        ),
        "protectionpromise-brothersister": (
            prompt: "Confident brother and sister celebrating strong Raksha Bandhan promise together, powerful visualization of care and protection commitment with bold vibrant colors, joyful celebration of sibling trust and loyalty, designed for iPhone or Apple Watch wallpaper, high-resolution, no text.",
            negativePrompt: "uncertain poses, weak colors"
        )
    ]
}
