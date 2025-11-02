import Foundation
import SwiftUI
import Combine

// MARK: - Anniversary AI Generation Service
@MainActor
class AnniversaryAIService: BaseCulturalAIService, CulturalAIServiceProtocol {
    static let shared = AnniversaryAIService()

    @Published var generatedImage: String?

    // Anniversary-specific configuration
    private let useMockGeneration = false // ✅ REAL AI GENERATION ENABLED
    private let useDALLE3 = true // 🎨 DALL-E 3 ENABLED (SDXL portrait bias causes statue busts)
    private var currentDesignSpec: AnniversaryDesignSpec?

    // DALL-E 3 service instance
    private let dalle3Service = DALLE3Service.shared

    override init() {
        super.init()
        print("🎊 AnniversaryAIService initialized")
        if useDALLE3 {
            print("🎨 AI Model: DALL-E 3 (OpenAI) - Superior prompt following, no portrait bias")
            // Check OpenAI API key availability
            let openAIKey = dalle3Service.apiKey
            print("🔑 OpenAI API Status: \(openAIKey.isEmpty ? "❌ NOT CONFIGURED" : "✅ CONFIGURED (\(openAIKey.prefix(8))...)")")
        } else {
            print("🎨 AI Model: SDXL (Replicate)")
            print("🔑 Replicate API Status: \(apiKeyStatus)")
        }
        print("⚙️  Mock Generation: \(useMockGeneration ? "ENABLED" : "DISABLED - Using Real AI")")
    }

    // MARK: - Anniversary Generation
    enum ImageFormat {
        case iPhone
        case appleWatch
    }

    func generateAnniversaryGift(
        theme: AnniversaryTheme,
        giftOption: String?,
        elements: [AnniversaryElement],
        colorPalette: AnniversaryColorPalette,
        message: String,
        contactName: String,
        format: ImageFormat = .iPhone
    ) async throws -> String {

        // Create design specification
        let designSpec = AnniversaryDesignSpec(
            theme: theme,
            giftOption: giftOption,
            elements: elements,
            colorPalette: colorPalette,
            message: message,
            contactName: contactName
        )

        self.currentDesignSpec = designSpec

        // Use mock generation for development/testing
        if useMockGeneration {
            return try await generateMockAnniversaryImage(designSpec: designSpec)
        }

        // 🎨 DALL-E 3 GENERATION PATH
        if useDALLE3 {
            return try await generateWithDALLE3(
                designSpec: designSpec,
                format: format
            )
        }

        // ⚙️ SDXL GENERATION PATH (Fallback - has portrait bias issues)
        return try await generateWithSDXL(
            designSpec: designSpec,
            format: format
        )
    }

    // MARK: - DALL-E 3 Generation
    private func generateWithDALLE3(
        designSpec: AnniversaryDesignSpec,
        format: ImageFormat
    ) async throws -> String {

        print("🎨 ═══════════════════════════════════════════════════════")
        print("🎨 DALL-E 3 Generation Pipeline")
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
        let themeName = designSpec.theme.rawValue.lowercased()
        let elementName = designSpec.elements.first?.name.lowercased() ?? "hearts"
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

        // DALL-E 3: Send ONLY positive prompts - safety filter rejects all negative instructions
        // Even benign terms like "oversaturated colors" trigger HTTP 400 content_policy_violation
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
        // Note: negativePrompt will be filtered by DALLE3Service to remove safety terms
        let imageURL = try await dalle3Service.generateImage(
            prompt: prompt,
            negativePrompt: negativePrompt,
            size: dalle3Size,
            quality: .standard  // $0.04 per image (vs .hd = $0.08)
        )

        progressTask.cancel()

        print("✅ DALL-E 3 generation complete!")
        print("🎨 ═══════════════════════════════════════════════════════")

        return imageURL
    }

    // MARK: - SDXL Generation (Legacy - has portrait bias)
    private func generateWithSDXL(
        designSpec: AnniversaryDesignSpec,
        format: ImageFormat
    ) async throws -> String {

        // Determine dimensions based on format
        let (width, height) = format == .iPhone
            ? (CulturalAIConfiguration.iPhoneWidth, CulturalAIConfiguration.iPhoneHeight)
            : (CulturalAIConfiguration.watchWidth, CulturalAIConfiguration.watchHeight)

        print("🎨 Generating \(format == .iPhone ? "iPhone" : "Apple Watch") format: \(width)x\(height)")

        // Check if using alternative prompt system
        let themeName = designSpec.theme.rawValue.lowercased()
        let elementName = designSpec.elements.first?.name.lowercased() ?? "hearts"
        let lookupKey = "\(themeName)-\(elementName)"

        let prompt: String
        let additionalNegativePrompt: String

        if let alternativePrompt = Self.alternativePrompts[lookupKey] {
            // 🔄 USING ALTERNATIVE PROMPT SYSTEM
            print("🔄 Alternative prompt system active for: \(lookupKey)")
            prompt = alternativePrompt.prompt

            // Build combined negative prompt: alternative + forbidden elements + base human blocking
            let forbiddenElements = buildForbiddenElementsPrompt(selectedElement: designSpec.elements.first)
            additionalNegativePrompt = "\(alternativePrompt.negativePrompt), \(forbiddenElements)"

            print("🚫 Combined negative prompt: \(additionalNegativePrompt)")
        } else {
            // ⚙️ FALLBACK: Programmatic prompt generation
            print("⚙️ Using programmatic prompt generation for: \(lookupKey)")
            prompt = createCulturalPrompt(from: designSpec)

            // Build element-exclusion negative prompt (forbid unselected elements)
            additionalNegativePrompt = buildForbiddenElementsPrompt(selectedElement: designSpec.elements.first)
        }

        // Use centralized generation with cultural context, format-specific dimensions, and color enforcement
        // CRITICAL: Pass base color names (not weighted strings) for color-exclusion negative prompt
        return try await generateCulturalGift(
            prompt: enhanceCulturalPrompt(prompt),
            culturalContext: "Anniversary",
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
        return "Anniversary"
    }

    func generateCulturalGift(
        culturalTheme: Any,
        elements: [Any],
        colorPalette: Any,
        personalMessage: String,
        recipientName: String
    ) async throws -> String {
        guard let theme = culturalTheme as? AnniversaryTheme,
              let anniversaryElements = elements as? [AnniversaryElement],
              let palette = colorPalette as? AnniversaryColorPalette else {
            throw CulturalAIConfiguration.CulturalAIError.invalidResponse
        }

        return try await generateAnniversaryGift(
            theme: theme,
            giftOption: nil,
            elements: anniversaryElements,
            colorPalette: palette,
            message: personalMessage,
            contactName: recipientName
        )
    }

    nonisolated func getCulturalThemes() -> [Any] {
        return AnniversaryTheme.allCases
    }

    nonisolated func getCulturalElements() -> [Any] {
        return AnniversaryElement.allElements
    }

    nonisolated func getCulturalColorPalettes() -> [Any] {
        return AnniversaryColorPalette.allPalettes
    }

    // MARK: - Alternative Natural Language Prompts
    // User-provided prompts to test as final SDXL attempt before DALL-E 3 migration
    nonisolated private static let alternativePrompts: [String: (prompt: String, negativePrompt: String)] = [
        // ❤️ ROMANTIC Theme
        "romantic-hearts": (
            prompt: "A dreamy romantic wallpaper featuring elegant glowing hearts floating in a warm pastel sunset atmosphere, soft pink and golden hues, cinematic lighting, designed for an iPhone background or Apple Watch face, high-resolution aesthetic, no text, no cartoon.",
            negativePrompt: "low resolution, harsh shadows"
        ),
        "romantic-trophy": (
            prompt: "A romantic-themed composition symbolizing shared success, featuring a golden trophy gently illuminated in a soft pink candlelit setting with delicate rose petals, cinematic glow, elegant and dreamy, perfect for Apple Watch or iPhone wallpaper, high resolution.",
            negativePrompt: "cartoon, clutter"
        ),
        "romantic-champagne": (
            prompt: "Elegant champagne glasses clinking in a softly lit romantic setting, warm bokeh lights, pastel rose highlights, cozy ambience, golden reflections, designed for iPhone wallpaper or Apple Watch face.",
            negativePrompt: "cartoon, distortion"
        ),
        "romantic-flowers": (
            prompt: "A dreamy romantic bloom of soft pink and white flowers swirling in a heart-shaped arrangement, glowing in warm golden light, atmospheric depth, calming aesthetic, high-resolution wallpaper design.",
            negativePrompt: "oversaturated colors, harsh contrast"
        ),

        // 📆 MILESTONE Theme
        "milestone-hearts": (
            prompt: "A milestone-themed wallpaper featuring subtle heart-shaped confetti floating against a gradient sky symbolizing growth and progress, uplifting but calm mood, elegant and minimalistic for Apple Watch or iPhone background.",
            negativePrompt: "chaotic composition, cartoon style"
        ),
        "milestone-trophy": (
            prompt: "A symbolic milestone trophy standing on a path leading toward a glowing horizon, representing progress and achievement, subtle celebratory atmosphere, modern and elegant, suitable for iPhone background or Apple Watch face.",
            negativePrompt: "cartoon, clutter"
        ),
        "milestone-champagne": (
            prompt: "Golden champagne bubbles rising against a soft gradient backdrop that represents a breakthrough moment, elegant and minimal, milestone celebration aesthetic, designed for high-resolution iPhone wallpaper.",
            negativePrompt: "messy, unrealistic foam"
        ),
        "milestone-flowers": (
            prompt: "A single blooming flower breaking through into light, symbolizing a milestone moment of growth, soft sunrise colors, elegant gradient background, minimal and modern Apple Watch wallpaper style.",
            negativePrompt: "overly busy floral pattern"
        ),

        // 👨‍👩‍👧 FAMILY Theme
        "family-hearts": (
            prompt: "A warm family-themed wallpaper featuring soft glowing heart shapes intertwined in a comforting gradient of warm oranges and gentle reds, representing unity and love, minimal yet cozy design for iPhone or Apple Watch face.",
            negativePrompt: "cartoon, overly complex"
        ),
        "family-trophy": (
            prompt: "A family-themed sense of achievement shown by a golden trophy set in a warm home-like ambient glow, gentle lighting symbolizing shared success, styled minimalistically for Apple Watch or iPhone wallpaper.",
            negativePrompt: "intense shadows, aggressive metallic shine"
        ),
        "family-champagne": (
            prompt: "A cozy celebratory atmosphere inspired by family joy, abstract champagne sparkle lights over a warm gradient reminiscent of a joyful gathering, high-resolution, comforting tone, ideal for wallpapers.",
            negativePrompt: "party chaos visuals"
        ),
        "family-flowers": (
            prompt: "A gentle floral arrangement symbolizing family love and togetherness, soft pastel colors in warm light, minimalistic and high-resolution for iPhone or Apple Watch background.",
            negativePrompt: "overly saturated bouquet"
        ),

        // 🏆 ACHIEVEMENT Theme
        "achievement-hearts": (
            prompt: "An achievement-inspired wallpaper with radiant hearts transformed into gleaming symbols of empowerment, energetic metallic lighting, gold and red gradient, powerful yet elegant, for iPhone or Apple Watch face.",
            negativePrompt: "cartoon, neon chaos"
        ),
        "achievement-trophy": (
            prompt: "A bold achievement-themed wallpaper featuring a golden trophy under a spotlight with a dynamic gradient background suggesting triumph and success, premium metallic shine, high-resolution, minimal and powerful aesthetic.",
            negativePrompt: "noisy background, cartoon"
        ),
        "achievement-champagne": (
            prompt: "Golden champagne splash moment captured mid-motion with a cinematic sense of victory and celebration, energetic composition, high-end metallic reflections, optimized for iPhone wallpaper or Apple Watch face.",
            negativePrompt: "messy, distorted bubbles"
        ),
        "achievement-flowers": (
            prompt: "A victorious floral arrangement bursting upward like confetti, symbolizing achievement and success, vibrant yet elegant, gradient lighting, modern minimalistic framing for iPhone or Apple Watch background.",
            negativePrompt: "chaotic or overly ornate floral collage"
        )
    ]

    // MARK: - AI Prompt Creation
    nonisolated func createCulturalPrompt(from designSpec: Any) -> String {
        guard let spec = designSpec as? AnniversaryDesignSpec else {
            return "Anniversary celebration design"
        }
        return createCulturalPrompt(from: spec)
    }

    nonisolated private func createCulturalPrompt(from spec: AnniversaryDesignSpec) -> String {
        // 🔄 ALTERNATIVE PROMPT SYSTEM: User-provided natural language prompts
        // This is the final SDXL test before potential DALL-E 3 migration

        // Build lookup key from theme + element
        let themeName = spec.theme.rawValue.lowercased()
        let elementName = spec.elements.first?.name.lowercased() ?? "hearts"
        let lookupKey = "\(themeName)-\(elementName)"

        // Retrieve alternative prompt if available
        if let alternativePrompt = Self.alternativePrompts[lookupKey] {
            print("🎨 USING ALTERNATIVE NATURAL LANGUAGE PROMPT:")
            print("=" + String(repeating: "=", count: 79))
            print("📊 USER SELECTIONS:")
            print("   Theme: \(spec.theme.rawValue)")
            print("   Element: \(spec.elements.first?.name ?? "NONE")")
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

        // Replace template placeholders with Anniversary-specific content
        prompt = prompt.replacingOccurrences(of: "[CULTURAL_EVENT]", with: "anniversary")

        // Simplified theme-specific styling with boosted SDXL weights
        let themeStyle: String
        switch spec.theme {
        case .romantic:
            themeStyle = "(romantic:2.0), (love:1.9), (intimate:1.8)"
        case .milestone:
            themeStyle = "(milestone:2.0), (golden:1.9), (celebration:1.8)"
        case .family:
            themeStyle = "(family:2.0), (together:1.9), (warmth:1.8)"
        case .achievement:
            themeStyle = "(achievement:2.0), (success:1.9), (victory:1.8)"
        }
        prompt = prompt.replacingOccurrences(of: "[THEME_STYLE]", with: themeStyle)

        // Single centerpiece element - MANDATORY with aggressive emphasis
        let centreElementsText: String
        if let selectedElement = spec.elements.first {
            // Triple repetition with SDXL weights for absolute conformance
            let repeatedPrompts = [
                "(\(selectedElement.name):1.8)",  // Highest weight - MUST appear
                "(\(selectedElement.name) centerpiece:1.7)",  // Reinforces central placement
                selectedElement.aiPromptModifier  // Detailed descriptor with built-in weights (1.5-1.6)
            ].joined(separator: ", ")
            centreElementsText = "YOU MUST INCLUDE THIS CENTERPIECE: \(repeatedPrompts), MANDATORY central focal element"
        } else {
            centreElementsText = "(decorative anniversary focal point:1.3), romantic celebration motifs"
        }
        prompt = prompt.replacingOccurrences(of: "[CENTRE_ELEMENTS]", with: centreElementsText)

        // Supporting elements - simplified (no longer used, but template still requires it)
        prompt = prompt.replacingOccurrences(of: "[SUPPORTING_ELEMENTS]", with: "elegant complementary decorative flourishes")

        // Color integration with SIMPLE SDXL-optimized names + STRICT ENFORCEMENT
        let colors = spec.colorPalette
        prompt = prompt.replacingOccurrences(of: "[PRIMARY_COLOR_SIMPLE]", with: colors.primaryColorSimple)
        prompt = prompt.replacingOccurrences(of: "[SECONDARY_COLOR_SIMPLE]", with: colors.secondaryColorSimple)
        prompt = prompt.replacingOccurrences(of: "[ACCENT_COLOR_SIMPLE]", with: colors.accentColorSimple)
        prompt = prompt.replacingOccurrences(of: "[BACKGROUND_ATMOSPHERE]", with: colors.backgroundHint)

        // Emotional context only - NO personal names or text to prevent AI from generating text
        prompt = prompt.replacingOccurrences(of: "[EMOTIONAL_CONTEXT]", with: "deep love, commitment, and celebration")

        // IMPORTANT: Personal message and recipient name are NEVER sent to AI
        // They will be added as native iOS text overlay post-generation for perfect typography

        print("🎨 FINAL AI PROMPT WITH ALL USER SELECTIONS (PROGRAMMATIC FALLBACK):")
        print("=" + String(repeating: "=", count: 79))
        print(prompt)
        print("=" + String(repeating: "=", count: 79))
        print("📊 USER SELECTIONS VERIFICATION:")
        print("   Theme: \(spec.theme.rawValue)")
        print("   Element: \(spec.elements.first?.name ?? "NONE")")
        print("   Color Palette: \(spec.colorPalette.name)")
        print("   🎨 SDXL COLOR ENFORCEMENT:")
        // swiftlint:disable:next line_length
        print("   ├─ PRIMARY (SIMPLE): \(spec.colorPalette.primaryColorSimple) [hex: \(spec.colorPalette.primaryColor)]")
        // swiftlint:disable:next line_length
        print("   ├─ SECONDARY (SIMPLE): \(spec.colorPalette.secondaryColorSimple) [hex: \(spec.colorPalette.secondaryColor)]")
        print("   └─ ACCENT (SIMPLE): \(spec.colorPalette.accentColorSimple) [hex: \(spec.colorPalette.accentColor)]")
        print("=" + String(repeating: "=", count: 79))

        return prompt
    }

    // MARK: - Element Exclusion
    nonisolated private func buildForbiddenElementsPrompt(selectedElement: AnniversaryElement?) -> String {
        // All possible centerpiece elements
        let allElementNames = ["Hearts", "Trophy", "Champagne", "Flowers"]

        // If no element selected, forbid all specific elements
        guard let selected = selectedElement else {
            return "hearts, trophy, champagne, flowers, no centerpiece element"
        }

        // Filter out the selected element to get forbidden list
        let forbiddenNames = allElementNames.filter { $0.lowercased() != selected.name.lowercased() }

        // Build comprehensive negative prompt with variations
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
    private func generateMockAnniversaryImage(designSpec: AnniversaryDesignSpec) async throws -> String {
        print("🧪 Using mock Anniversary generation...")

        // Simulate API call delay with progress updates
        for index in 1...10 {
            try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
            await MainActor.run {
                self.generationProgress = 0.3 + (Float(index) * 0.07)
            }
        }

        // Return mock image URL
        let mockImageURL = "mock_anniversary_\(designSpec.theme.rawValue.lowercased())_\(UUID().uuidString.prefix(8))"

        print("✅ Mock Anniversary generation completed: \(mockImageURL)")
        return mockImageURL
    }
}

// MARK: - Data Models
struct AnniversaryDesignSpec {
    let theme: AnniversaryTheme
    let giftOption: String?
    let elements: [AnniversaryElement]
    let colorPalette: AnniversaryColorPalette
    let message: String
    let contactName: String
    let timestamp: Date = Date()
}
