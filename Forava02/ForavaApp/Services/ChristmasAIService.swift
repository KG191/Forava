import Foundation
import SwiftUI
import Combine

// MARK: - Christmas AI Generation Service
@MainActor
class ChristmasAIService: BaseCulturalAIService, CulturalAIServiceProtocol {
    static let shared = ChristmasAIService()
    @Published var generatedImage: String?

    private let useMockGeneration = false
    private let useDALLE3 = true
    private var currentDesignSpec: ChristmasDesignSpec?
    private let dalle3Service = DALLE3Service.shared

    override init() {
        super.init()
        print("<� ChristmasAIService initialized")
    }

    enum ImageFormat {
        case iPhone
        case appleWatch
    }

    func generateChristmasGift(
        theme: ChristmasTheme,
        element: ChristmasElement?,
        colorPalette: ChristmasColorPalette,
        message: String,
        contactName: String,
        format: ImageFormat = .iPhone
    ) async throws -> String {
        let designSpec = ChristmasDesignSpec(
            theme: theme,
            element: element,
            colorPalette: colorPalette,
            message: message,
            contactName: contactName
        )

        if useDALLE3 {
            return try await generateWithDALLE3(designSpec: designSpec, format: format)
        }

        return try await generateWithSDXL(designSpec: designSpec, format: format)
    }

    private func generateWithDALLE3(designSpec: ChristmasDesignSpec, format: ImageFormat) async throws -> String {
        let dalle3Size: DALLE3Service.ImageSize = format == .iPhone ? .size1024x1792 : .size1024
        let prompt = createCulturalPrompt(from: designSpec)

        print("<� Generating Christmas gift with DALL-E 3")
        print("<� Theme: \(designSpec.theme.rawValue)")
        print("<� Element: \(designSpec.element?.name ?? "None")")
        print("<� Palette: \(designSpec.colorPalette.name)")
        print("<� Size: \(dalle3Size)")

        return try await dalle3Service.generateImage(
            prompt: prompt,
            negativePrompt: "",
            size: dalle3Size,
            quality: .standard
        )
    }

    private func generateWithSDXL(designSpec: ChristmasDesignSpec, format: ImageFormat) async throws -> String {
        let (width, height) = format == .iPhone ? (1024, 1792) : (1024, 1024)

        print("<� Generating Christmas gift with SDXL")
        print("<� Theme: \(designSpec.theme.rawValue)")
        print("<� Element: \(designSpec.element?.name ?? "None")")
        print("<� Palette: \(designSpec.colorPalette.name)")
        print("<� Size: \(width)x\(height)")

        return try await generateCulturalGift(
            prompt: createCulturalPrompt(from: designSpec),
            culturalContext: "Christmas",
            width: width,
            height: height,
            primaryColor: designSpec.colorPalette.primaryHex,
            secondaryColor: designSpec.colorPalette.secondaryHex,
            accentColor: designSpec.colorPalette.accentHex,
            additionalNegativePrompt: ""
        )
    }

    nonisolated private func createCulturalPrompt(from designSpec: ChristmasDesignSpec) -> String {
        var promptComponents: [String] = []

        // Base Christmas scene
        promptComponents.append("Beautiful Christmas celebration scene")

        // Theme description
        promptComponents.append(designSpec.theme.description)

        // Element (if selected)
        if let element = designSpec.element {
            promptComponents.append(element.aiPromptModifier)
        }

        // Color palette
        promptComponents.append(designSpec.colorPalette.aiColorHint)

        // Quality and style modifiers
        promptComponents.append("festive holiday atmosphere")
        promptComponents.append("high-resolution")
        promptComponents.append("professional digital art")
        promptComponents.append("warm and inviting")
        promptComponents.append("no text")
        promptComponents.append("culturally authentic")

        return promptComponents.joined(separator: ", ")
    }

    struct ChristmasDesignSpec {
        let theme: ChristmasTheme
        let element: ChristmasElement?
        let colorPalette: ChristmasColorPalette
        let message: String
        let contactName: String
    }

    // MARK: - CulturalAIServiceProtocol Conformance
    nonisolated var culturalEventType: String { "Christmas" }

    func generateCulturalGift(
        culturalTheme: Any,
        elements: [Any],
        colorPalette: Any,
        personalMessage: String,
        recipientName: String
    ) async throws -> String {
        guard let theme = culturalTheme as? ChristmasTheme,
              let palette = colorPalette as? ChristmasColorPalette else {
            throw CulturalAIConfiguration.CulturalAIError.invalidResponse
        }

        let element = elements.first as? ChristmasElement

        return try await generateChristmasGift(
            theme: theme,
            element: element,
            colorPalette: palette,
            message: personalMessage,
            contactName: recipientName
        )
    }

    nonisolated func getCulturalThemes() -> [Any] {
        ChristmasTheme.allCases
    }

    nonisolated func getCulturalElements() -> [Any] {
        ChristmasElement.allElements
    }

    nonisolated func getCulturalColorPalettes() -> [Any] {
        ChristmasColorPalette.allPalettes
    }

    nonisolated func createCulturalPrompt(from designSpec: Any) -> String {
        guard let spec = designSpec as? ChristmasDesignSpec else {
            return "Christmas celebration design"
        }
        return createCulturalPrompt(from: spec)
    }
}
