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
    private var currentDesignSpec: AnniversaryDesignSpec?

    override init() {
        super.init()
        print("🎊 AnniversaryAIService initialized")
        print("🔑 API Key Status: \(apiKeyStatus)")
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

        // Generate AI prompt using new architecture
        let prompt = createCulturalPrompt(from: designSpec)

        // Use mock generation for development/testing
        if useMockGeneration {
            return try await generateMockAnniversaryImage(designSpec: designSpec)
        }

        // Determine dimensions based on format
        let (width, height) = format == .iPhone
            ? (CulturalAIConfiguration.iPhoneWidth, CulturalAIConfiguration.iPhoneHeight)
            : (CulturalAIConfiguration.watchWidth, CulturalAIConfiguration.watchHeight)

        print("🎨 Generating \(format == .iPhone ? "iPhone" : "Apple Watch") format: \(width)x\(height)")

        // Build element-exclusion negative prompt (forbid unselected elements)
        let forbiddenElements = buildForbiddenElementsPrompt(selectedElement: elements.first)

        // Use centralized generation with cultural context, format-specific dimensions, and color enforcement
        // CRITICAL: Pass base color names (not weighted strings) for color-exclusion negative prompt
        return try await generateCulturalGift(
            prompt: enhanceCulturalPrompt(prompt),
            culturalContext: "Anniversary",
            width: width,
            height: height,
            primaryColor: colorPalette.primaryColorBase,
            secondaryColor: colorPalette.secondaryColorBase,
            accentColor: colorPalette.accentColorBase,
            additionalNegativePrompt: forbiddenElements
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

    // MARK: - AI Prompt Creation
    nonisolated func createCulturalPrompt(from designSpec: Any) -> String {
        guard let spec = designSpec as? AnniversaryDesignSpec else {
            return "Anniversary celebration design"
        }
        return createCulturalPrompt(from: spec)
    }

    nonisolated private func createCulturalPrompt(from spec: AnniversaryDesignSpec) -> String {
        // Use centralized template from configuration
        var prompt = CulturalAIConfiguration.culturalPromptTemplate

        // Replace template placeholders with Anniversary-specific content
        prompt = prompt.replacingOccurrences(of: "[CULTURAL_EVENT]", with: "anniversary")

        // Enhanced theme-specific styling with SDXL weight syntax for strict conformance
        let themeStyle: String
        switch spec.theme {
        case .romantic:
            themeStyle = """
                (romantic celebration:1.6), (intimate love and partnership:1.5), \
                (flowing romantic patterns:1.4), (soft hearts:1.4), \
                (elegant floral accents:1.3), (dreamy atmosphere:1.3), \
                (gentle romantic lighting:1.3), (tender emotional expression:1.3), \
                (refined romantic elegance:1.4), (graceful curves:1.3), \
                (warm passionate energy:1.3)
                """
        case .milestone:
            themeStyle = """
                (milestone commemoration:1.6), (significant achievement celebration:1.5), \
                (golden celebration energy:1.4), (triumph symbols:1.4), \
                (radiant success markers:1.3), (festive jubilation:1.3), \
                (accomplishment visualization:1.4), (sophisticated golden patterns:1.3), \
                (geometric celebration design:1.3)
                """
        case .family:
            themeStyle = """
                (family bond celebration:1.6), (warm connected patterns:1.5), \
                (unity and togetherness:1.4), (generational legacy symbols:1.4), \
                (heritage visualization:1.3), (cozy familial atmosphere:1.3), \
                (circular connection forms:1.3), (warm golden tones:1.3), \
                (nurturing warmth:1.3)
                """
        case .achievement:
            themeStyle = """
                (achievement celebration:1.6), (personal accomplishment:1.5), \
                (professional success visualization:1.4), (ascending progress patterns:1.4), \
                (growth trajectory:1.3), (victory symbols:1.3), \
                (excellence markers:1.3), (inspirational triumph energy:1.4), \
                (professional sophistication:1.3)
                """
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

        print("🎨 FINAL AI PROMPT WITH ALL USER SELECTIONS:")
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
