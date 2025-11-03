import Foundation
import SwiftUI
import Combine

// MARK: - Easter AI Generation Service
@MainActor
class EasterAIService: BaseCulturalAIService, CulturalAIServiceProtocol {
    static let shared = EasterAIService()
    @Published var generatedImage: String?
    
    private let useMockGeneration = false
    private let useDALLE3 = true
    private var currentDesignSpec: EasterDesignSpec?
    private let dalle3Service = DALLE3Service.shared
    
    override init() {
        super.init()
        print("🐰 EasterAIService initialized")
    }
    
    enum ImageFormat {
        case iPhone
        case appleWatch
    }
    
    func generateEasterGift(
        theme: EasterTheme,
        element: EasterElement?,
        colorPalette: EasterColorPalette,
        message: String,
        contactName: String,
        format: ImageFormat = .iPhone
    ) async throws -> String {
        let designSpec = EasterDesignSpec(theme: theme, element: element, colorPalette: colorPalette, message: message, contactName: contactName)
        if useDALLE3 {
            return try await generateWithDALLE3(designSpec: designSpec, format: format)
        }
        return try await generateWithSDXL(designSpec: designSpec, format: format)
    }
    
    private func generateWithDALLE3(designSpec: EasterDesignSpec, format: ImageFormat) async throws -> String {
        let dalle3Size: DALLE3Service.ImageSize = format == .iPhone ? .size1024x1792 : .size1024
        let prompt = createCulturalPrompt(from: designSpec)
        return try await dalle3Service.generateImage(prompt: prompt, negativePrompt: "", size: dalle3Size, quality: .standard)
    }
    
    private func generateWithSDXL(designSpec: EasterDesignSpec, format: ImageFormat) async throws -> String {
        let (width, height) = format == .iPhone ? (1024, 1792) : (1024, 1024)
        return try await generateCulturalGift(prompt: createCulturalPrompt(from: designSpec), culturalContext: "Easter", width: width, height: height, primaryColor: designSpec.colorPalette.primaryHex, secondaryColor: designSpec.colorPalette.secondaryHex, accentColor: designSpec.colorPalette.accentHex, additionalNegativePrompt: "")
    }
    
    nonisolated private func createCulturalPrompt(from designSpec: EasterDesignSpec) -> String {
        return "Beautiful Easter celebration scene, \(designSpec.theme.description), \(designSpec.colorPalette.aiColorHint), festive spring atmosphere, high-resolution, no text, culturally authentic art."
    }
    
    struct EasterDesignSpec {
        let theme: EasterTheme
        let element: EasterElement?
        let colorPalette: EasterColorPalette
        let message: String
        let contactName: String
    }
    
    nonisolated var culturalEventType: String { "Easter" }
    
    func generateCulturalGift(culturalTheme: Any, elements: [Any], colorPalette: Any, personalMessage: String, recipientName: String) async throws -> String {
        guard let theme = culturalTheme as? EasterTheme, let element = elements.first as? EasterElement, let palette = colorPalette as? EasterColorPalette else {
            throw CulturalAIConfiguration.CulturalAIError.invalidResponse
        }
        return try await generateEasterGift(theme: theme, element: element, colorPalette: palette, message: personalMessage, contactName: recipientName)
    }
    
    nonisolated func getCulturalThemes() -> [Any] { EasterTheme.allCases }
    nonisolated func getCulturalElements() -> [Any] { EasterElement.allElements }
    nonisolated func getCulturalColorPalettes() -> [Any] { EasterColorPalette.allPalettes }
    nonisolated func createCulturalPrompt(from designSpec: Any) -> String {
        guard let spec = designSpec as? EasterDesignSpec else { return "Easter celebration design" }
        return createCulturalPrompt(from: spec)
    }
}
