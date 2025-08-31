import Foundation
import SwiftUI
import Combine

// MARK: - Advanced Customization Service for Granular Rakhi Design Control

@MainActor
class AdvancedCustomizationService: ObservableObject {
    static let shared = AdvancedCustomizationService()

    // MARK: - Published Properties
    @Published var isCustomizing = false
    @Published var customizationProgress: Float = 0.0
    @Published var activeCustomization: CustomizationSession?
    @Published var availablePatterns: [DesignPattern] = []
    @Published var availableTextures: [TextureOption] = []
    @Published var availableMaterials: [MaterialOption] = []
    @Published var previewRakhi: GeneratedRakhi?
    @Published var customizationHistory: [CustomizationSession] = []

    private var cancellables = Set<AnyCancellable>()

    private init() {
        loadCustomizationAssets()
        setupRealTimePreview()
    }

    // MARK: - Customization Session Management

    func startCustomizationSession(from rakhi: GeneratedRakhi) -> CustomizationSession {
        let session = CustomizationSession(
            id: UUID(),
            baseRakhi: rakhi,
            customizations: [],
            startTime: Date()
        )

        activeCustomization = session
        isCustomizing = true
        // Preview generation disabled for performance

        return session
    }

    func saveCustomizationSession(_ session: CustomizationSession) {
        session.endTime = Date()
        customizationHistory.append(session)
        saveCustomizationData()
    }

    func endCustomizationSession() {
        if let session = activeCustomization {
            saveCustomizationSession(session)
        }

        activeCustomization = nil
        isCustomizing = false
        previewRakhi = nil
        customizationProgress = 0.0
    }

    // MARK: - Advanced Pattern Customization

    func applyCustomPattern(
        _ pattern: DesignPattern,
        to session: CustomizationSession,
        intensity: Float = 1.0,
        blend: BlendMode = .overlay
    ) async throws -> CustomizationResult {

        customizationProgress = 0.2

        let customization = PatternCustomization(
            id: UUID(),
            pattern: pattern,
            intensity: intensity,
            blendMode: blend,
            position: calculateOptimalPatternPosition(for: pattern, in: session.baseRakhi),
            scale: 1.0,
            rotation: 0.0,
            opacity: intensity
        )

        customizationProgress = 0.6

        session.customizations.append(.pattern(customization))

        // Generate preview with new pattern
        customizationProgress = 0.8
        try await generateRealTimePreview(for: session)

        customizationProgress = 1.0

        return CustomizationResult(
            success: true,
            customization: .pattern(customization),
            previewImage: previewRakhi?.mainImage,
            culturalScore: calculateCulturalScore(for: session),
            processingTime: 0.5
        )
    }

    func applyCustomTexture(
        _ texture: TextureOption,
        to session: CustomizationSession,
        coverage: Float = 1.0,
        roughness: Float = 0.5
    ) async throws -> CustomizationResult {

        customizationProgress = 0.3

        let customization = TextureCustomization(
            id: UUID(),
            texture: texture,
            coverage: coverage,
            roughness: roughness,
            metallicness: texture.defaultMetallic,
            normalStrength: texture.defaultNormalStrength,
            tiling: CGSize(width: 1.0, height: 1.0)
        )

        customizationProgress = 0.7

        session.customizations.append(.texture(customization))

        try await generateRealTimePreview(for: session)

        customizationProgress = 1.0

        return CustomizationResult(
            success: true,
            customization: .texture(customization),
            previewImage: previewRakhi?.mainImage,
            culturalScore: calculateCulturalScore(for: session),
            processingTime: 0.3
        )
    }

    func applyCustomMaterial(
        _ material: MaterialOption,
        to session: CustomizationSession,
        weathering: Float = 0.0
    ) async throws -> CustomizationResult {

        customizationProgress = 0.25

        let customization = MaterialCustomization(
            id: UUID(),
            material: material,
            weathering: weathering,
            surfaceProperties: material.defaultSurfaceProperties,
            reflectance: material.baseReflectance,
            subsurfaceScattering: material.subsurfaceProperties
        )

        customizationProgress = 0.75

        session.customizations.append(.material(customization))

        try await generateRealTimePreview(for: session)

        customizationProgress = 1.0

        return CustomizationResult(
            success: true,
            customization: .material(customization),
            previewImage: previewRakhi?.mainImage,
            culturalScore: calculateCulturalScore(for: session),
            processingTime: 0.4
        )
    }

    // MARK: - Color Manipulation

    func applyAdvancedColorGrading(
        to session: CustomizationSession,
        hueShift: Float = 0.0,
        saturationBoost: Float = 0.0,
        contrastAdjustment: Float = 0.0,
        warmth: Float = 0.0
    ) async throws -> CustomizationResult {

        let colorGrading = ColorGradingCustomization(
            id: UUID(),
            hueShift: hueShift,
            saturation: 1.0 + saturationBoost,
            contrast: 1.0 + contrastAdjustment,
            brightness: 0.0,
            warmth: warmth,
            vibrance: 0.0,
            gamma: 1.0,
            highlights: 0.0,
            shadows: 0.0
        )

        session.customizations.append(.colorGrading(colorGrading))

        try await generateRealTimePreview(for: session)

        return CustomizationResult(
            success: true,
            customization: .colorGrading(colorGrading),
            previewImage: previewRakhi?.mainImage,
            culturalScore: calculateCulturalScore(for: session),
            processingTime: 0.2
        )
    }

    // MARK: - Geometric Transformations

    func applyGeometricTransformation(
        to session: CustomizationSession,
        transformation: GeometricTransformation
    ) async throws -> CustomizationResult {

        let geometryCustomization = GeometryCustomization(
            id: UUID(),
            transformation: transformation,
            preserveAspectRatio: true,
            interpolationMode: .bicubic
        )

        session.customizations.append(.geometry(geometryCustomization))

        try await generateRealTimePreview(for: session)

        return CustomizationResult(
            success: true,
            customization: .geometry(geometryCustomization),
            previewImage: previewRakhi?.mainImage,
            culturalScore: calculateCulturalScore(for: session),
            processingTime: 0.3
        )
    }

    // MARK: - Cultural Element Enhancement

    func enhanceCulturalElements(
        in session: CustomizationSession,
        enhancement: CulturalEnhancement
    ) async throws -> CustomizationResult {

        let culturalCustomization = CulturalCustomization(
            id: UUID(),
            enhancement: enhancement,
            intensity: enhancement.recommendedIntensity,
            preserveAuthenticity: true,
            culturalContext: session.baseRakhi.designSpec.genre
        )

        session.customizations.append(.cultural(culturalCustomization))

        try await generateRealTimePreview(for: session)

        // Recalculate cultural score with enhancement
        let newScore = calculateEnhancedCulturalScore(for: session, with: enhancement)

        return CustomizationResult(
            success: true,
            customization: .cultural(culturalCustomization),
            previewImage: previewRakhi?.mainImage,
            culturalScore: newScore,
            processingTime: 0.6
        )
    }

    // MARK: - Fine-Tuning Controls

    func adjustCustomizationParameter(
        in session: CustomizationSession,
        customizationId: UUID,
        parameter: String,
        value: Float
    ) async throws {

        guard let index = session.customizations.firstIndex(where: { $0.id == customizationId }) else {
            throw CustomizationError.customizationNotFound
        }

        // Update the specific parameter
        session.customizations[index] = updateCustomizationParameter(
            session.customizations[index],
            parameter: parameter,
            value: value
        )

        // Regenerate preview
        try await generateRealTimePreview(for: session)
    }

    func removeCustomization(
        from session: CustomizationSession,
        customizationId: UUID
    ) async throws {

        session.customizations.removeAll { $0.id == customizationId }

        // Regenerate preview without removed customization
        try await generateRealTimePreview(for: session)
    }

    // MARK: - Preset and Template System

    func createCustomizationPreset(
        from session: CustomizationSession,
        name: String,
        description: String?
    ) -> CustomizationPreset {

        let preset = CustomizationPreset(
            id: UUID(),
            name: name,
            description: description,
            customizations: session.customizations,
            createdAt: Date(),
            culturalCompatibility: calculateCulturalCompatibility(for: session),
            tags: generatePresetTags(for: session)
        )

        saveCustomizationPreset(preset)
        return preset
    }

    func applyCustomizationPreset(
        _ preset: CustomizationPreset,
        to session: CustomizationSession,
        intensity: Float = 1.0
    ) async throws {

        // Apply each customization from preset with intensity scaling
        for customization in preset.customizations {
            let scaledCustomization = scaleCustomizationIntensity(customization, by: intensity)
            session.customizations.append(scaledCustomization)
        }

        try await generateRealTimePreview(for: session)
    }

    // MARK: - Real-time Preview Generation

    internal func generateRealTimePreview(for session: CustomizationSession) async throws {
        // In production, this would:
        // 1. Apply all customizations to the base rakhi
        // 2. Generate a new image with all modifications
        // 3. Calculate quality and cultural scores
        // 4. Update the preview

        let enhancedRakhi = session.baseRakhi
        // Apply customizations...

        previewRakhi = enhancedRakhi
    }

    private func setupRealTimePreview() {
        // Observe customization changes and update preview
        $activeCustomization
            .compactMap { $0 }
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] session in
                Task {
                    try? await self?.generateRealTimePreview(for: session)
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Scoring and Analysis

    private func calculateCulturalScore(for session: CustomizationSession) -> Double {
        let baseScore = session.baseRakhi.culturalScore

        // Analyze how customizations affect cultural authenticity
        let culturalModifier = session.customizations.reduce(0.0) { total, customization in
            total + getCulturalImpact(of: customization)
        }

        return max(0.0, min(1.0, baseScore + culturalModifier))
    }

    private func calculateEnhancedCulturalScore(
        for session: CustomizationSession,
        with enhancement: CulturalEnhancement
    ) -> Double {
        let currentScore = calculateCulturalScore(for: session)
        return min(1.0, currentScore + enhancement.scoreBoost)
    }

    private func getCulturalImpact(of customization: AnyCustomization) -> Double {
        switch customization {
        case .pattern(let pattern):
            return pattern.pattern.culturalRelevance - 0.1 // Slight penalty for modification
        case .cultural(let cultural):
            return cultural.enhancement.scoreBoost
        case .colorGrading:
            return -0.05 // Minor penalty for color changes
        default:
            return -0.02 // Very minor penalty for other modifications
        }
    }

    // MARK: - Helper Methods

    private func calculateOptimalPatternPosition(
        for pattern: DesignPattern,
        in rakhi: GeneratedRakhi
    ) -> CGPoint {
        // Calculate optimal position based on pattern type and rakhi composition
        switch pattern.placementHint {
        case .center:
            return CGPoint(x: 0.5, y: 0.5)
        case .border:
            return CGPoint(x: 0.5, y: 0.8)
        case .corner:
            return CGPoint(x: 0.8, y: 0.2)
        case .distributed:
            return CGPoint(x: 0.3, y: 0.3)
        }
    }

    private func updateCustomizationParameter(
        _ customization: AnyCustomization,
        parameter: String,
        value: Float
    ) -> AnyCustomization {
        // Update specific parameter based on customization type
        switch customization {
        case .pattern(var pattern):
            switch parameter {
            case "intensity": pattern.intensity = value
            case "scale": pattern.scale = value
            case "rotation": pattern.rotation = value
            case "opacity": pattern.opacity = value
            default: break
            }
            return .pattern(pattern)
        case .texture(var texture):
            switch parameter {
            case "coverage": texture.coverage = value
            case "roughness": texture.roughness = value
            case "metallicness": texture.metallicness = value
            default: break
            }
            return .texture(texture)
        default:
            return customization
        }
    }

    private func scaleCustomizationIntensity(
        _ customization: AnyCustomization,
        by intensity: Float
    ) -> AnyCustomization {
        // Scale customization intensity for preset application
        switch customization {
        case .pattern(var pattern):
            pattern.intensity *= intensity
            pattern.opacity *= intensity
            return .pattern(pattern)
        case .texture(var texture):
            texture.coverage *= intensity
            return .texture(texture)
        default:
            return customization
        }
    }

    private func calculateCulturalCompatibility(for session: CustomizationSession) -> Float {
        // Calculate how well customizations work with different cultural styles
        let culturalCustomizations = session.customizations.compactMap { customization in
            if case .cultural(let cultural) = customization {
                return cultural
            }
            return nil
        }

        if culturalCustomizations.isEmpty {
            return 0.5
        } else {
            let intensitySum = culturalCustomizations.map { Double($0.intensity) }.reduce(0, +)
            let average = intensitySum / Double(culturalCustomizations.count)
            return Float(average)
        }
    }

    private func generatePresetTags(for session: CustomizationSession) -> [String] {
        var tags: [String] = []

        for customization in session.customizations {
            switch customization {
            case .pattern(let pattern):
                tags.append(pattern.pattern.category.rawValue)
            case .texture(let texture):
                tags.append(texture.texture.category.rawValue)
            case .material(let material):
                tags.append(material.material.type.rawValue)
            case .cultural(let cultural):
                tags.append(cultural.enhancement.type.rawValue)
            default:
                break
            }
        }

        return Array(Set(tags)) // Remove duplicates
    }

    // MARK: - Asset Loading

    private func loadCustomizationAssets() {
        // Load available patterns
        availablePatterns = DesignPattern.defaultPatterns

        // Load available textures
        availableTextures = TextureOption.defaultTextures

        // Load available materials
        availableMaterials = MaterialOption.defaultMaterials
    }

    // MARK: - Data Persistence

    private func saveCustomizationData() {
        // Save customization history to UserDefaults or Core Data
        // Encoding disabled - CustomizationSession contains @Published properties
        // if let data = try? JSONEncoder().encode(customizationHistory) {
        //     UserDefaults.standard.set(data, forKey: "customization_history")
        // }
    }

    private func saveCustomizationPreset(_ preset: CustomizationPreset) {
        var presets = loadCustomizationPresets()
        presets.append(preset)

        if let data = try? JSONEncoder().encode(presets) {
            UserDefaults.standard.set(data, forKey: "customization_presets")
        }
    }

    private func loadCustomizationPresets() -> [CustomizationPreset] {
        guard let data = UserDefaults.standard.data(forKey: "customization_presets"),
              let presets = try? JSONDecoder().decode([CustomizationPreset].self, from: data) else {
            return []
        }
        return presets
    }
}

// MARK: - Supporting Types

class CustomizationSession: ObservableObject {
    let id: UUID
    let baseRakhi: GeneratedRakhi
    @Published var customizations: [AnyCustomization]
    let startTime: Date
    var endTime: Date?

    init(id: UUID, baseRakhi: GeneratedRakhi, customizations: [AnyCustomization], startTime: Date) {
        self.id = id
        self.baseRakhi = baseRakhi
        self.customizations = customizations
        self.startTime = startTime
    }
}

enum AnyCustomization: Identifiable, Codable {
    case pattern(PatternCustomization)
    case texture(TextureCustomization)
    case material(MaterialCustomization)
    case colorGrading(ColorGradingCustomization)
    case geometry(GeometryCustomization)
    case cultural(CulturalCustomization)

    var id: UUID {
        switch self {
        case .pattern(let p): return p.id
        case .texture(let t): return t.id
        case .material(let m): return m.id
        case .colorGrading(let c): return c.id
        case .geometry(let g): return g.id
        case .cultural(let c): return c.id
        }
    }
}

struct PatternCustomization: Identifiable, Codable {
    let id: UUID
    let pattern: DesignPattern
    var intensity: Float
    let blendMode: BlendMode
    var position: CGPoint
    var scale: Float
    var rotation: Float
    var opacity: Float
}

struct TextureCustomization: Identifiable, Codable {
    let id: UUID
    let texture: TextureOption
    var coverage: Float
    var roughness: Float
    var metallicness: Float
    let normalStrength: Float
    let tiling: CGSize
}

struct MaterialCustomization: Identifiable, Codable {
    let id: UUID
    let material: MaterialOption
    let weathering: Float
    let surfaceProperties: SurfaceProperties
    let reflectance: Float
    let subsurfaceScattering: SubsurfaceProperties
}

struct ColorGradingCustomization: Identifiable, Codable {
    let id: UUID
    let hueShift: Float
    let saturation: Float
    let contrast: Float
    let brightness: Float
    let warmth: Float
    let vibrance: Float
    let gamma: Float
    let highlights: Float
    let shadows: Float
}

struct GeometryCustomization: Identifiable, Codable {
    let id: UUID
    let transformation: GeometricTransformation
    let preserveAspectRatio: Bool
    let interpolationMode: InterpolationMode
}

struct CulturalCustomization: Identifiable, Codable {
    let id: UUID
    let enhancement: CulturalEnhancement
    var intensity: Float
    let preserveAuthenticity: Bool
    let culturalContext: RakhiGenre
}

struct DesignPattern: Identifiable, Codable {
    let id: UUID
    let name: String
    let category: PatternCategory
    let culturalRelevance: Double
    let placementHint: PlacementHint
    let complexity: Float

    static let defaultPatterns: [DesignPattern] = [
        DesignPattern(id: UUID(), name: "Mandala", category: .geometric, culturalRelevance: 0.9, placementHint: .center, complexity: 0.8),
        DesignPattern(id: UUID(), name: "Paisley", category: .cultural, culturalRelevance: 0.95, placementHint: .distributed, complexity: 0.7),
        DesignPattern(id: UUID(), name: "Lotus", category: .spiritual, culturalRelevance: 0.9, placementHint: .center, complexity: 0.6),
        DesignPattern(id: UUID(), name: "Peacock Feather", category: .cultural, culturalRelevance: 0.85, placementHint: .border, complexity: 0.9)
    ]
}

struct TextureOption: Identifiable, Codable {
    let id: UUID
    let name: String
    let category: TextureCategory
    let defaultMetallic: Float
    let defaultNormalStrength: Float

    static let defaultTextures: [TextureOption] = [
        TextureOption(id: UUID(), name: "Silk", category: .fabric, defaultMetallic: 0.1, defaultNormalStrength: 0.3),
        TextureOption(id: UUID(), name: "Gold Leaf", category: .metallic, defaultMetallic: 0.9, defaultNormalStrength: 0.1),
        TextureOption(id: UUID(), name: "Velvet", category: .fabric, defaultMetallic: 0.0, defaultNormalStrength: 0.8),
        TextureOption(id: UUID(), name: "Beads", category: .decorative, defaultMetallic: 0.3, defaultNormalStrength: 1.0)
    ]
}

struct MaterialOption: Identifiable, Codable {
    let id: UUID
    let name: String
    let type: MaterialType
    let baseReflectance: Float
    let defaultSurfaceProperties: SurfaceProperties
    let subsurfaceProperties: SubsurfaceProperties

    static let defaultMaterials: [MaterialOption] = [
        MaterialOption(
            id: UUID(),
            name: "Traditional Thread",
            type: .thread,
            baseReflectance: 0.1,
            defaultSurfaceProperties: SurfaceProperties(roughness: 0.8, metallic: 0.0),
            subsurfaceProperties: SubsurfaceProperties(scattering: 0.3, thickness: 0.1)
        ),
        MaterialOption(
            id: UUID(),
            name: "Gold Wire",
            type: .metal,
            baseReflectance: 0.9,
            defaultSurfaceProperties: SurfaceProperties(roughness: 0.1, metallic: 1.0),
            subsurfaceProperties: SubsurfaceProperties(scattering: 0.0, thickness: 0.0)
        )
    ]
}

struct CulturalEnhancement: Identifiable, Codable {
    let id: UUID
    let name: String
    let type: EnhancementType
    let scoreBoost: Double
    let recommendedIntensity: Float

    static let defaultEnhancements: [CulturalEnhancement] = [
        CulturalEnhancement(id: UUID(), name: "Traditional Motifs", type: .motif, scoreBoost: 0.15, recommendedIntensity: 0.8),
        CulturalEnhancement(id: UUID(), name: "Sacred Symbols", type: .symbol, scoreBoost: 0.2, recommendedIntensity: 0.6),
        CulturalEnhancement(id: UUID(), name: "Regional Style", type: .regional, scoreBoost: 0.1, recommendedIntensity: 0.7)
    ]
}

struct GeometricTransformation: Codable {
    let scale: CGPoint
    let rotation: Float
    let translation: CGPoint
    let skew: CGPoint
}

struct SurfaceProperties: Codable {
    let roughness: Float
    let metallic: Float
}

struct SubsurfaceProperties: Codable {
    let scattering: Float
    let thickness: Float
}

struct CustomizationResult {
    let success: Bool
    let customization: AnyCustomization
    let previewImage: AIImageResult?
    let culturalScore: Double
    let processingTime: TimeInterval
}

struct CustomizationPreset: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String?
    let customizations: [AnyCustomization]
    let createdAt: Date
    let culturalCompatibility: Float
    let tags: [String]
}

enum PatternCategory: String, CaseIterable, Codable {
    case geometric = "Geometric"
    case cultural = "Cultural"
    case spiritual = "Spiritual"
    case modern = "Modern"
    case traditional = "Traditional"
}

enum TextureCategory: String, CaseIterable, Codable {
    case fabric = "Fabric"
    case metallic = "Metallic"
    case decorative = "Decorative"
    case natural = "Natural"
}

enum MaterialType: String, CaseIterable, Codable {
    case thread = "Thread"
    case metal = "Metal"
    case bead = "Bead"
    case gem = "Gem"
    case fabric = "Fabric"
}

enum EnhancementType: String, CaseIterable, Codable {
    case motif = "Motif"
    case symbol = "Symbol"
    case regional = "Regional"
    case spiritual = "Spiritual"
}

enum PlacementHint: String, CaseIterable, Codable {
    case center = "Center"
    case border = "Border"
    case corner = "Corner"
    case distributed = "Distributed"
}

enum BlendMode: String, CaseIterable, Codable {
    case overlay = "Overlay"
    case multiply = "Multiply"
    case screen = "Screen"
    case softLight = "Soft Light"
    case hardLight = "Hard Light"
}

enum InterpolationMode: String, CaseIterable, Codable {
    case bicubic = "Bicubic"
    case bilinear = "Bilinear"
    case nearestNeighbor = "Nearest Neighbor"
}

enum CustomizationError: LocalizedError {
    case customizationNotFound
    case invalidParameter
    case previewGenerationFailed
    case assetLoadingFailed

    var errorDescription: String? {
        switch self {
        case .customizationNotFound:
            return "The specified customization could not be found"
        case .invalidParameter:
            return "Invalid parameter value provided"
        case .previewGenerationFailed:
            return "Failed to generate preview image"
        case .assetLoadingFailed:
            return "Failed to load customization assets"
        }
    }
}
