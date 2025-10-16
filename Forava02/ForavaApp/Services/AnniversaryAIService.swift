import Foundation
import SwiftUI
import Combine

// MARK: - Anniversary AI Generation Service
@MainActor
class AnniversaryAIService: BaseCulturalAIService, CulturalAIServiceProtocol {
    static let shared = AnniversaryAIService()

    @Published var generatedImage: String?

    // Anniversary-specific configuration
    private let useMockGeneration = false
    private var currentDesignSpec: AnniversaryDesignSpec?

    override init() {
        super.init()
    }

    // MARK: - Anniversary Generation
    func generateAnniversaryGift(
        theme: AnniversaryTheme,
        elements: [AnniversaryElement],
        colorPalette: AnniversaryColorPalette,
        message: String,
        contactName: String
    ) async throws -> String {

        // Create design specification
        let designSpec = AnniversaryDesignSpec(
            theme: theme,
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

        // Use centralized generation with cultural context
        return try await generateCulturalGift(
            prompt: enhanceCulturalPrompt(prompt),
            culturalContext: "Anniversary"
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

        // Theme-specific styling
        let themeStyle: String
        switch spec.theme {
        case .romantic:
            themeStyle = "romantic style with intimate, loving elements"
        case .milestone:
            themeStyle = "milestone celebration with golden accents and achievement symbols"
        case .family:
            themeStyle = "family-centered style with warm, generational elements"
        case .achievement:
            themeStyle = "achievement celebration with success and recognition themes"
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

        // Color palette integration
        let colors = spec.colorPalette
        let colorScheme = """
            \(colors.name.lowercased()) with \(colors.primaryColor), \
            \(colors.secondaryColor), and \(colors.accentColor)
            """
        prompt = prompt.replacingOccurrences(of: "[COLOR_PALETTE]", with: colorScheme)
        prompt = prompt.replacingOccurrences(of: "[BACKGROUND_ATMOSPHERE]", with: colors.backgroundHint)

        // Personal context
        prompt = prompt.replacingOccurrences(of: "[EMOTIONAL_CONTEXT]", with: "deep love, commitment, and celebration")
        prompt = prompt.replacingOccurrences(of: "[RECIPIENT_NAME]", with: spec.contactName)

        print("🎨 Generated Anniversary AI Prompt:")
        print(prompt)

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
    let elements: [AnniversaryElement]
    let colorPalette: AnniversaryColorPalette
    let message: String
    let contactName: String
    let timestamp: Date = Date()
}
