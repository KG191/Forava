import Foundation
import SwiftUI
import Combine

// Note: Cultural context files are included in the target, 
// so no explicit imports needed - they're available in the same module

// MARK: - Cultural Configuration Manager
@MainActor
class CulturalConfiguration: ObservableObject {
    static let shared = CulturalConfiguration()

    @Published private(set) var isInitialized = false
    @Published var currentCulturalContext: String? {
        didSet {
            if let context = currentCulturalContext {
                UserDefaults.standard.set(context, forKey: "currentCulturalContext")
                CulturalContextManager.shared.switchContext(to: context)
            }
        }
    }

    private var registeredContexts: Set<String> = []

    private init() {
        loadSavedConfiguration()
        registerAllContexts()
    }

    // MARK: - Initialization

    func initialize() async {
        print("[CulturalConfiguration] Initializing cultural framework...")

        // Register all available cultural contexts
        await registerContexts()

        // Set default context if none selected
        if currentCulturalContext == nil {
            currentCulturalContext = "rakhi_indian" // Default to Rakhi for backward compatibility
        }

        isInitialized = true
        print("[CulturalConfiguration] Cultural framework initialized with context: \(currentCulturalContext ?? "none")")
    }

    private func registerContexts() async {
        // Phase 1 Contexts (Enhanced)
        // Note: Cultural contexts will be registered as they become available
        // For now, registering basic context identifiers for framework compatibility
        
        // Primary contexts that should be available
        registeredContexts.insert("rakhi_indian")
        registeredContexts.insert("hindu_festivals")
        registeredContexts.insert("chinese_traditional")
        registeredContexts.insert("japanese_traditional")
        registeredContexts.insert("middle_eastern_traditional")
        registeredContexts.insert("african_traditional")
        registeredContexts.insert("latin_american_traditional")
        registeredContexts.insert("christian_traditional")
        registeredContexts.insert("buddhist_traditional")
        registeredContexts.insert("jewish_traditional")
        registeredContexts.insert("universal_celebrations")

        print("[CulturalConfiguration] Registered \(registeredContexts.count) cultural contexts")
    }

    // MARK: - Context Management

    func switchToCulturalContext(_ identifier: String) {
        guard registeredContexts.contains(identifier) else {
            print("[CulturalConfiguration] Unknown cultural context: \(identifier)")
            return
        }

        currentCulturalContext = identifier
        print("[CulturalConfiguration] Switched to cultural context: \(identifier)")
    }

    func getAvailableContexts() -> [String] {
        return Array(registeredContexts).sorted()
    }

    func getCurrentContext() -> CulturalContext? {
        guard let contextId = currentCulturalContext else { return nil }
        return CulturalContextManager.shared.getContext(for: contextId)
    }

    // MARK: - Migration Support

    func migrateFromLegacyRakhiSystem() {
        print("[CulturalConfiguration] Migrating from legacy Rakhi system...")

        // Set Rakhi as current context for backward compatibility
        if currentCulturalContext == nil {
            currentCulturalContext = "rakhi_indian"
        }

        print("[CulturalConfiguration] Migration completed")
    }

    // MARK: - Helper Methods

    func createNewDesignSpec(
        genreId: String,
        colorPaletteId: String,
        ageGroupId: String,
        elements: [String] = [],
        personalMessage: String? = nil
    ) -> CulturalDesignSpec? {

        guard let context = getCurrentContext() else {
            print("[CulturalConfiguration] No current cultural context")
            return nil
        }

        guard let genre = context.genres.first(where: { $0.id == genreId }) else {
            print("[CulturalConfiguration] Genre not found: \(genreId)")
            return nil
        }

        guard let colorPalette = context.colorPalettes.first(where: { $0.id == colorPaletteId }) else {
            print("[CulturalConfiguration] Color palette not found: \(colorPaletteId)")
            return nil
        }

        guard let ageGroup = context.ageGroups.first(where: { $0.id == ageGroupId }) else {
            print("[CulturalConfiguration] Age group not found: \(ageGroupId)")
            return nil
        }

        let selectedElements = elements.compactMap { elementId in
            context.designElements.first(where: { $0.id == elementId })
        }

        return CulturalContextManager.shared.createDesignSpec(
            genre: genre,
            elements: selectedElements,
            colorPalette: colorPalette,
            personalMessage: personalMessage,
            targetAgeGroup: ageGroup
        )
    }

    func validateDesignSpec(_ spec: CulturalDesignSpec) -> CulturalValidationResult? {
        return CulturalContextManager.shared.validateDesignSpec(spec)
    }

    // MARK: - Private Methods

    private func loadSavedConfiguration() {
        currentCulturalContext = UserDefaults.standard.string(forKey: "currentCulturalContext")
    }

    private func registerAllContexts() {
        // This will be called to ensure all contexts are registered
        Task {
            await registerContexts()
        }
    }
}

// MARK: - Legacy Compatibility Bridge
@MainActor
class LegacyRakhiBridge {
    static let shared = LegacyRakhiBridge()

    private init() {}

    // Convert legacy RakhiDesignSpec to new CulturalDesignSpec
    func convertLegacySpec(_ legacySpec: RakhiDesignSpec) -> CulturalDesignSpec? {
        let config = CulturalConfiguration.shared

        // Map legacy genre to cultural genre
        let genreId = legacySpec.genre.rawValue.lowercased()

        // Map legacy color palette
        let colorPaletteId = legacySpec.colorPalette.rawValue.lowercased()

        // Map legacy age group
        let ageGroupId = legacySpec.targetAgeGroup.rawValue.lowercased()

        // Map legacy elements (this would need element mapping)
        let elementIds: [String] = [] // TODO: Implement element mapping

        return config.createNewDesignSpec(
            genreId: genreId,
            colorPaletteId: colorPaletteId,
            ageGroupId: ageGroupId,
            elements: elementIds,
            personalMessage: legacySpec.personalMessage
        )
    }

    // Convert cultural spec back to legacy for backward compatibility
    func convertToLegacySpec(_ culturalSpec: CulturalDesignSpec) -> RakhiDesignSpec? {
        // Only works for Rakhi cultural context
        guard culturalSpec.culturalContext == "rakhi_indian" else {
            return nil
        }

        // Map cultural genre back to legacy
        let legacyGenre: RakhiGenre
        switch culturalSpec.genre.id {
        case "traditional": legacyGenre = .traditional
        case "modern": legacyGenre = .modern
        case "elegant": legacyGenre = .elegant
        case "spiritual": legacyGenre = .spiritual
        default: legacyGenre = .unknown
        }

        // Map cultural color palette back to legacy
        let legacyColorPalette: ColorPalette
        switch culturalSpec.colorPalette.id {
        case "traditional": legacyColorPalette = .traditional
        case "modern": legacyColorPalette = .modern
        default: legacyColorPalette = .traditional
        }

        // Map cultural age group back to legacy
        let legacyAgeGroup: AgeGroup
        switch culturalSpec.targetAgeGroup.id {
        case "young": legacyAgeGroup = .young
        case "adult": legacyAgeGroup = .adult
        case "elder": legacyAgeGroup = .elder
        default: legacyAgeGroup = .any
        }

        // Create legacy spec
        let legacySpec = RakhiDesignSpec(
            genre: legacyGenre,
            elements: [], // TODO: Convert cultural elements to legacy
            colorPalette: legacyColorPalette,
            personalMessage: culturalSpec.personalMessage,
            targetAgeGroup: legacyAgeGroup
        )

        return legacySpec
    }
}

// MARK: - Cultural Feature Flags
struct CulturalFeatureFlags {
    static let isMultiCulturalEnabled = true
    static let allowContextSwitching = true
    static let enableLegacyBridge = true
    static let enableCulturalValidation = true
    static let enableCulturalRecommendations = true

    static func isContextSupported(_ identifier: String) -> Bool {
        let supportedContexts = [
            "rakhi_indian",
            "hindu_festivals",
            "chinese_traditional",
            "japanese_traditional",
            "middle_eastern_traditional",
            "african_traditional",
            "latin_american_traditional",
            "christian_traditional",
            "buddhist_traditional",
            "jewish_traditional",
            "universal_celebrations"
        ]
        return supportedContexts.contains(identifier)
    }

    static func getAllSupportedContexts() -> [String] {
        return [
            "rakhi_indian",
            "hindu_festivals",
            "chinese_traditional",
            "japanese_traditional",
            "middle_eastern_traditional",
            "african_traditional",
            "latin_american_traditional",
            "christian_traditional",
            "buddhist_traditional",
            "jewish_traditional",
            "universal_celebrations"
        ]
    }

    static func isContextSwitchingEnabled() -> Bool {
        return allowContextSwitching && getAllSupportedContexts().count > 1
    }
}
