import Foundation
import SwiftUI
import Combine

// MARK: - EidAlAdha AI Generation Service
@MainActor
class EidAlAdhaAIService: BaseCulturalAIService, CulturalAIServiceProtocol {
    static let shared = EidAlAdhaAIService()
    @Published var generatedImage: String?
    
    private let useMockGeneration = false
    private let useDALLE3 = true
    private var currentDesignSpec: EidAlAdhaDesignSpec?
    private let dalle3Service = DALLE3Service.shared
    
    override init() {
        super.init()
        print("🐰 EidAlAdhaAIService initialized")
    }
    
    enum ImageFormat {
        case iPhone
        case appleWatch
    }
    
    func generateEidAlAdhaGift(
        theme: EidAlAdhaTheme,
        element: EidAlAdhaElement?,
        colorPalette: EidAlAdhaColorPalette,
        message: String,
        contactName: String,
        format: ImageFormat = .iPhone
    ) async throws -> String {
        let designSpec = EidAlAdhaDesignSpec(theme: theme, element: element, colorPalette: colorPalette, message: message, contactName: contactName)
        if useDALLE3 {
            return try await generateWithDALLE3(designSpec: designSpec, format: format)
        }
        return try await generateWithSDXL(designSpec: designSpec, format: format)
    }
    
    private func generateWithDALLE3(designSpec: EidAlAdhaDesignSpec, format: ImageFormat) async throws -> String {
        let dalle3Size: DALLE3Service.ImageSize = format == .iPhone ? .size1024x1792 : .size1024
        let prompt = createCulturalPrompt(from: designSpec)
        return try await dalle3Service.generateImage(prompt: prompt, negativePrompt: "", size: dalle3Size, quality: .standard)
    }
    
    private func generateWithSDXL(designSpec: EidAlAdhaDesignSpec, format: ImageFormat) async throws -> String {
        let (width, height) = format == .iPhone ? (1024, 1792) : (1024, 1024)
        return try await generateCulturalGift(
            prompt: createCulturalPrompt(from: designSpec),
            culturalContext: "Eid al-Adha",
            width: width,
            height: height,
            primaryColor: designSpec.colorPalette.primaryHex,
            secondaryColor: designSpec.colorPalette.secondaryHex,
            accentColor: designSpec.colorPalette.accentHex,
            additionalNegativePrompt: ""
        )
    }
    
    nonisolated private func createCulturalPrompt(from designSpec: EidAlAdhaDesignSpec) -> String {
        return "Beautiful Eid al-Adha celebration scene, \(designSpec.theme.description), " +
               "\(designSpec.colorPalette.aiColorHint), festive Islamic atmosphere, " +
               "high-resolution, no text, culturally authentic art."
    }
    
    struct EidAlAdhaDesignSpec {
        let theme: EidAlAdhaTheme
        let element: EidAlAdhaElement?
        let colorPalette: EidAlAdhaColorPalette
        let message: String
        let contactName: String
    }
    
    nonisolated var culturalEventType: String { "EidAlAdha" }
    
    func generateCulturalGift(culturalTheme: Any, elements: [Any], colorPalette: Any, personalMessage: String, recipientName: String) async throws -> String {
        guard let theme = culturalTheme as? EidAlAdhaTheme, let element = elements.first as? EidAlAdhaElement, let palette = colorPalette as? EidAlAdhaColorPalette else {
            throw CulturalAIConfiguration.CulturalAIError.invalidResponse
        }
        return try await generateEidAlAdhaGift(theme: theme, element: element, colorPalette: palette, message: personalMessage, contactName: recipientName)
    }
    
    nonisolated func getCulturalThemes() -> [Any] { EidAlAdhaTheme.allCases }
    nonisolated func getCulturalElements() -> [Any] { EidAlAdhaElement.allElements }
    nonisolated func getCulturalColorPalettes() -> [Any] { EidAlAdhaColorPalette.allPalettes }
    nonisolated func createCulturalPrompt(from designSpec: Any) -> String {
        guard let spec = designSpec as? EidAlAdhaDesignSpec else { return "EidAlAdha celebration design" }
        return createCulturalPrompt(from: spec)
    }
}
