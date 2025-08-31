import Foundation
import SwiftUI

// MARK: - Cultural Framework Initializer
@MainActor
class CulturalFrameworkInitializer {
    static let shared = CulturalFrameworkInitializer()

    private var isInitialized = false

    private init() {}

    func initializeFramework() async {
        guard !isInitialized else {
            print("[CulturalFramework] Already initialized")
            return
        }

        print("[CulturalFramework] Initializing cultural framework...")

        // Step 1: Initialize cultural configuration
        await CulturalConfiguration.shared.initialize()

        // Step 2: Migrate from legacy system if needed
        CulturalConfiguration.shared.migrateFromLegacyRakhiSystem()

        // Step 3: Ensure Rakhi context is active for backward compatibility
        CulturalConfiguration.shared.switchToCulturalContext("rakhi_indian")

        isInitialized = true
        print("[CulturalFramework] Cultural framework initialized successfully")
    }

    func isFrameworkReady() -> Bool {
        return isInitialized && CulturalConfiguration.shared.isInitialized
    }

    func getCurrentCulturalContext() -> CulturalContext? {
        return CulturalConfiguration.shared.getCurrentContext()
    }

    func switchContext(to identifier: String) {
        CulturalConfiguration.shared.switchToCulturalContext(identifier)
    }

    func getAvailableContexts() -> [String] {
        return CulturalConfiguration.shared.getAvailableContexts()
    }
}

// MARK: - App Delegate Integration Helper
extension CulturalFrameworkInitializer {
    func setupForAppLaunch() {
        Task { @MainActor in
            await initializeFramework()
        }
    }
}

// MARK: - SwiftUI Environment Integration
struct CulturalFrameworkKey: EnvironmentKey {
    static let defaultValue: CulturalFrameworkInitializer = CulturalFrameworkInitializer.shared
}

extension EnvironmentValues {
    var culturalFramework: CulturalFrameworkInitializer {
        get { self[CulturalFrameworkKey.self] }
        set { self[CulturalFrameworkKey.self] = newValue }
    }
}

// MARK: - View Modifier for Cultural Framework
struct CulturalFrameworkModifier: ViewModifier {
    @State private var isInitialized = false

    func body(content: Content) -> some View {
        content
            .task {
                if !isInitialized {
                    await CulturalFrameworkInitializer.shared.initializeFramework()
                    isInitialized = true
                }
            }
            .environment(\.culturalFramework, CulturalFrameworkInitializer.shared)
    }
}

extension View {
    func culturalFramework() -> some View {
        modifier(CulturalFrameworkModifier())
    }
}
