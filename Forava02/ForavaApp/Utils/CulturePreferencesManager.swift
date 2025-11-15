import Foundation
import SwiftUI

/// Manages user's selected cultures and onboarding state
class CulturePreferencesManager: ObservableObject {
    // MARK: - AppStorage Properties

    @AppStorage("selectedCultureIDs") private var selectedCultureIDsData: Data = Data()
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false

    // MARK: - Published Properties

    @Published var selectedCultureIDs: Set<String> = []

    // MARK: - Initialization

    init() {
        loadCultures()
    }

    // MARK: - Public Methods

    /// Save selected cultures to persistent storage
    func saveCultures() {
        if let encoded = try? JSONEncoder().encode(selectedCultureIDs) {
            selectedCultureIDsData = encoded
        }
    }

    /// Load selected cultures from persistent storage
    func loadCultures() {
        if let decoded = try? JSONDecoder().decode(Set<String>.self, from: selectedCultureIDsData) {
            selectedCultureIDs = decoded
        }
    }

    /// Check if user has completed onboarding (selected cultures)
    func isFirstLaunch() -> Bool {
        return !hasCompletedOnboarding
    }

    /// Mark onboarding as complete
    func completeOnboarding() {
        guard !selectedCultureIDs.isEmpty else {
            print("⚠️ Cannot complete onboarding without selecting at least one culture")
            return
        }
        hasCompletedOnboarding = true
        saveCultures()
    }

    /// Toggle culture selection
    func toggleCulture(_ cultureID: String) {
        if selectedCultureIDs.contains(cultureID) {
            selectedCultureIDs.remove(cultureID)
        } else {
            selectedCultureIDs.insert(cultureID)
        }
        saveCultures()
    }

    /// Check if a culture is selected
    func isSelected(_ cultureID: String) -> Bool {
        return selectedCultureIDs.contains(cultureID)
    }

    /// Reset preferences (for testing or user reset)
    func resetPreferences() {
        selectedCultureIDs.removeAll()
        hasCompletedOnboarding = false
        saveCultures()
    }
}
