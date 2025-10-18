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

        // Use centralized generation with cultural context, format-specific dimensions, and color enforcement
        return try await generateCulturalGift(
            prompt: enhanceCulturalPrompt(prompt),
            culturalContext: "Anniversary",
            width: width,
            height: height,
            primaryColor: colorPalette.primaryColorSimple,
            secondaryColor: colorPalette.secondaryColorSimple,
            accentColor: colorPalette.accentColorSimple
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

        // Theme-specific styling with PATTERN-FOCUSED gift option integration
        let themeStyle: String
        if let giftOption = spec.giftOption {
            // Strip text-triggering words and convert to pattern descriptions
            let patternFocus = giftOption
                .replacingOccurrences(of: "Card", with: "Pattern")
                .replacingOccurrences(of: "Letter", with: "Decorative Design")
                .replacingOccurrences(of: "Collage", with: "Composition")
                .replacingOccurrences(of: "Message", with: "Visual Elements")
                .replacingOccurrences(of: "Book", with: "Layout")
                .replacingOccurrences(of: "Album", with: "Arrangement")

            // Emphasize PATTERNS ONLY in descriptions
            switch spec.theme {
            case .romantic:
                themeStyle = "\(patternFocus) rendered as romantic decorative patterns with heart shapes, floral motifs, and flowing organic forms"
            case .milestone:
                themeStyle = "\(patternFocus) rendered as celebratory patterns with golden geometric shapes, achievement symbols, and radiant abstract elements"
            case .family:
                themeStyle = "\(patternFocus) rendered as family-centered patterns with warm circular forms, connected geometric shapes, and generational abstract motifs"
            case .achievement:
                themeStyle = "\(patternFocus) rendered as achievement patterns with success symbols, ascending geometric forms, and recognition abstract elements"
            }
        } else {
            // Fallback to PATTERN-ONLY general theme descriptions
            switch spec.theme {
            case .romantic:
                themeStyle = "romantic decorative patterns with heart shapes, floral motifs, and flowing organic forms"
            case .milestone:
                themeStyle = "milestone celebration patterns with golden geometric shapes, achievement symbols, and radiant abstract elements"
            case .family:
                themeStyle = "family-centered patterns with warm circular forms, connected geometric shapes, and generational abstract motifs"
            case .achievement:
                themeStyle = "achievement patterns with success symbols, ascending geometric forms, and recognition abstract elements"
            }
        }
        prompt = prompt.replacingOccurrences(of: "[THEME_STYLE]", with: themeStyle)

        // Design elements integration
        let centrePieces = spec.elements.filter { $0.category == .centrePiece }
        let supportingElements = spec.elements.filter { $0.category == .supportingElement }

        var elementsText = ""
        if !centrePieces.isEmpty {
            let centrePrompts = centrePieces.map { $0.aiPromptModifier }.joined(separator: " and ")
            elementsText = "\(centrePrompts) as central focus"
        }
        if !supportingElements.isEmpty {
            let supportPrompts = supportingElements.map { $0.aiPromptModifier }.joined(separator: ", ")
            if !elementsText.isEmpty {
                elementsText += " adorned with \(supportPrompts)"
            } else {
                elementsText = supportPrompts
            }
        }
        prompt = prompt.replacingOccurrences(of: "[CULTURAL_ELEMENTS]", with: elementsText)

        // Color integration with SIMPLE SDXL-optimized names (repeated throughout template for max adherence)
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
        print("   Gift Option: \(spec.giftOption ?? "none")")
        print("   Elements (\(spec.elements.count)): \(spec.elements.map { $0.name }.joined(separator: ", "))")
        print("   Color Palette: \(spec.colorPalette.name)")
        print("   🎨 SDXL COLOR ENFORCEMENT:")
        print("   ├─ PRIMARY (SIMPLE): \(spec.colorPalette.primaryColorSimple) [hex: \(spec.colorPalette.primaryColor)]")
        print("   ├─ SECONDARY (SIMPLE): \(spec.colorPalette.secondaryColorSimple) [hex: \(spec.colorPalette.secondaryColor)]")
        print("   └─ ACCENT (SIMPLE): \(spec.colorPalette.accentColorSimple) [hex: \(spec.colorPalette.accentColor)]")
        print("=" + String(repeating: "=", count: 79))

        return prompt
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
