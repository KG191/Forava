import Foundation
import StoreKit
import Combine

/// Comprehensive payment service integrating subscription and consumable IAP
/// Provides unified interface for all payment operations in Forava app
@MainActor
class ComprehensivePaymentService: ObservableObject {

    // MARK: - Singleton

    static let shared = ComprehensivePaymentService()

    // MARK: - Published Properties

    /// Current subscription status
    @Published var subscriptionStatus: SubscriptionStatus = SubscriptionStatus(tier: .free)

    /// Regeneration IAP manager
    @Published var regenerationManager: RegenerationIAPManager

    /// Loading state
    @Published var isLoading = false

    /// Error message
    @Published var errorMessage: String?

    // MARK: - Private Properties

    private var cancellables = Set<AnyCancellable>()
    private let subscriptionStatusKey = "forava.subscription.status"

    // MARK: - Initialization

    private init() {
        self.regenerationManager = RegenerationIAPManager.shared

        // Load saved subscription status
        loadSubscriptionStatus()

        // Observe regeneration manager errors
        observeRegenerationManager()
    }

    // MARK: - Product Loading

    /// Load all IAP products (subscription + consumable)
    func loadAllProducts() async {
        isLoading = true
        errorMessage = nil

        // Load regeneration products
        await regenerationManager.loadProducts()

        // Future: Load subscription products here
        // await subscriptionManager.loadProducts()

        print("✅ All IAP products loaded")

        isLoading = false
    }

    // MARK: - Credit Pack Purchase

    /// Purchase credit pack (10, 25, 50, or 100 credits)
    /// - Parameter product: The credit pack product to purchase
    /// - Returns: True if purchase successful, false otherwise
    func purchaseCreditPack(_ product: IAPProduct) async -> Bool {
        do {
            let transaction = try await regenerationManager.purchaseCreditPack(product)
            return transaction != nil
        } catch {
            errorMessage = "Purchase failed: \(error.localizedDescription)"
            print("❌ Credit pack purchase failed: \(error)")
            return false
        }
    }

    /// Purchase single regeneration credit (legacy support)
    /// - Returns: True if purchase successful, false otherwise
    func purchaseRegenerationCredit() async -> Bool {
        do {
            let transaction = try await regenerationManager.purchaseRegenerationCredit()
            return transaction != nil
        } catch {
            errorMessage = "Purchase failed: \(error.localizedDescription)"
            print("❌ Regeneration purchase failed: \(error)")
            return false
        }
    }

    /// Use regeneration credit for cultural event
    /// - Parameter culturalEvent: Name of cultural event (e.g., "Christmas", "Diwali")
    /// - Returns: True if credit used successfully, false if no credits available
    func useRegenerationCredit(for culturalEvent: String) -> Bool {
        let success = regenerationManager.useCredit(for: culturalEvent)

        if !success {
            errorMessage = "No regeneration credits available. Please purchase credits to continue."
        }

        return success
    }

    /// Check if user has available regeneration credits
    func hasRegenerationCredits() -> Bool {
        return regenerationManager.hasAvailableCredits()
    }

    /// Get count of available regeneration credits
    func getAvailableCreditsCount() -> Int {
        return regenerationManager.availableCredits
    }

    /// Get formatted price for regeneration credit
    func getRegenerationPrice() -> String {
        return regenerationManager.getRegenerationPrice()
    }

    // MARK: - Restore Purchases

    /// Restore all previous purchases (subscription + consumable)
    /// - Returns: True if any purchases were restored, false otherwise
    func restorePurchases() async -> Bool {
        isLoading = true
        errorMessage = nil

        // Restore regeneration credits
        await regenerationManager.restorePurchases()

        // Future: Restore subscription purchases here
        // await subscriptionManager.restorePurchases()

        isLoading = false

        // Check if user now has credits or subscription
        let hasCreditsOrSubscription = hasRegenerationCredits() || isSubscribed

        if hasCreditsOrSubscription {
            print("✅ Restore purchases completed - purchases found")
            return true
        } else {
            print("ℹ️ Restore purchases completed - no purchases found")
            errorMessage = "No previous purchases found"
            return false
        }
    }

    /// Legacy method for backward compatibility
    func restoreAllPurchases() async {
        _ = await restorePurchases()
    }

    // MARK: - Subscription Management

    /// Computed property for subscription status (convenience)
    var isSubscribed: Bool {
        return hasActiveSubscription()
    }

    /// Check if user has active subscription
    func hasActiveSubscription() -> Bool {
        return subscriptionStatus.isActive
    }

    /// Get subscription tier
    func getSubscriptionTier() -> SubscriptionTier {
        return subscriptionStatus.tier
    }

    /// Subscribe to monthly or annual plan
    /// - Parameter product: The subscription product (.monthlySubscription or .annualSubscription)
    /// - Returns: True if subscription successful, false otherwise
    func subscribe(_ product: IAPProduct) async -> Bool {
        // Validate it's a subscription product
        guard product == .monthlySubscription || product == .annualSubscription else {
            errorMessage = "Invalid subscription product"
            print("❌ Invalid subscription product: \(product.rawValue)")
            return false
        }

        isLoading = true
        errorMessage = nil

        // TODO: Implement SubscriptionManager when ready
        // For now, this is a placeholder that returns false
        // Future implementation will:
        // 1. Use StoreKit 2 Product.purchase() for auto-renewable subscriptions
        // 2. Verify transaction with checkVerified()
        // 3. Update subscriptionStatus with tier and expiration
        // 4. Enable subscription features (unlimited generations, no watermark, etc.)

        print("⚠️ Subscription purchase not yet implemented")
        print("   Product: \(product.rawValue)")
        print("   This will be implemented in SubscriptionManager")

        await MainActor.run {
            isLoading = false
            errorMessage = "Subscription feature is not available. Please use credit packs instead."
        }

        return false
    }

    /// Update subscription status (called when subscription changes)
    func updateSubscriptionStatus(tier: SubscriptionTier, expirationDate: Date? = nil) {
        subscriptionStatus = SubscriptionStatus(
            tier: tier,
            startDate: Date(),
            expirationDate: expirationDate,
            autoRenewing: tier != .free
        )
        saveSubscriptionStatus()
        print("✅ Subscription status updated to: \(tier.displayName)")
    }

    // MARK: - Persistence

    private func saveSubscriptionStatus() {
        do {
            let data = try JSONEncoder().encode(subscriptionStatus)
            UserDefaults.standard.set(data, forKey: subscriptionStatusKey)
        } catch {
            print("❌ Failed to save subscription status: \(error)")
        }
    }

    private func loadSubscriptionStatus() {
        guard let data = UserDefaults.standard.data(forKey: subscriptionStatusKey) else {
            print("ℹ️ No saved subscription status, using free tier")
            return
        }

        do {
            subscriptionStatus = try JSONDecoder().decode(SubscriptionStatus.self, from: data)
            print("✅ Loaded subscription status: \(subscriptionStatus.tier.displayName)")
        } catch {
            print("❌ Failed to load subscription status: \(error)")
        }
    }

    // MARK: - Observers

    private func observeRegenerationManager() {
        regenerationManager.$lastError
            .sink { [weak self] error in
                if let error = error {
                    self?.errorMessage = error
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Reset (for testing)

    func reset() {
        subscriptionStatus = SubscriptionStatus(tier: .free)
        UserDefaults.standard.removeObject(forKey: subscriptionStatusKey)
        regenerationManager.clearAllCredits()
        print("🗑️ Payment service reset")
    }
}