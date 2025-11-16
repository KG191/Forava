import Foundation
import SwiftUI

/// Manages the free tier quota system (3 generations lifetime)
@MainActor
class GenerationQuotaManager: ObservableObject {
    static let shared = GenerationQuotaManager()

    // Free tier constants
    private let freeGenerationLimit = 3
    private let quotaKey = "com.forava.freeQuotaUsed"
    private let firstLaunchKey = "com.forava.firstLaunchDate"

    @Published private(set) var quotaUsed: Int = 0
    @Published private(set) var quotaRemaining: Int = 3

    private init() {
        loadQuota()
    }

    // MARK: - Public Interface

    /// Check if user has free generations remaining
    func hasFreeQuota() -> Bool {
        return quotaRemaining > 0
    }

    /// Get number of free generations remaining
    func getRemainingCount() -> Int {
        return quotaRemaining
    }

    /// Get number of free generations used
    func getUsedCount() -> Int {
        return quotaUsed
    }

    /// Use one free generation
    /// Returns true if successful, false if quota exhausted
    @discardableResult
    func useFreeGeneration() -> Bool {
        guard hasFreeQuota() else {
            return false
        }

        quotaUsed += 1
        quotaRemaining = max(0, freeGenerationLimit - quotaUsed)
        saveQuota()

        print("📊 Free quota used: \(quotaUsed)/\(freeGenerationLimit)")
        return true
    }

    /// Check if user is on free tier (no subscription, no credits)
    func isFreeTier(paymentService: ComprehensivePaymentService) -> Bool {
        return !paymentService.isSubscribed && !paymentService.hasRegenerationCredits()
    }

    /// Reset quota (for testing/debugging only)
    func resetQuota() {
        quotaUsed = 0
        quotaRemaining = freeGenerationLimit
        saveQuota()
        print("🔄 Quota reset to \(freeGenerationLimit)")
    }

    // MARK: - Persistence

    private func loadQuota() {
        // Record first launch if needed
        if UserDefaults.standard.object(forKey: firstLaunchKey) == nil {
            UserDefaults.standard.set(Date(), forKey: firstLaunchKey)
        }

        quotaUsed = UserDefaults.standard.integer(forKey: quotaKey)
        quotaRemaining = max(0, freeGenerationLimit - quotaUsed)

        print("📊 Quota loaded: \(quotaUsed) used, \(quotaRemaining) remaining")
    }

    private func saveQuota() {
        UserDefaults.standard.set(quotaUsed, forKey: quotaKey)

        // Sync to iCloud (optional, for cross-device sync)
        NSUbiquitousKeyValueStore.default.set(quotaUsed, forKey: quotaKey)
        NSUbiquitousKeyValueStore.default.synchronize()
    }

    // MARK: - Analytics Helpers

    /// Get days since first launch
    func daysSinceFirstLaunch() -> Int {
        guard let firstLaunch = UserDefaults.standard.object(forKey: firstLaunchKey) as? Date else {
            return 0
        }

        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: firstLaunch, to: Date())
        return components.day ?? 0
    }

    /// Check if user hit paywall (exhausted free tier)
    func hasHitPaywall() -> Bool {
        return quotaUsed >= freeGenerationLimit
    }
}
