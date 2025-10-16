import Foundation
import StoreKit
import Combine
import SwiftUI

@MainActor
class SubscriptionManager: ObservableObject {
    static let shared = SubscriptionManager()

    @Published var subscriptionStatus: SubscriptionStatus
    @Published var availableProducts: [Product] = []
    @Published var purchasedProducts: Set<String> = []
    @Published var usageMetrics: UsageMetrics
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let userId: String
    private var updateListenerTask: Task<Void, Error>?

    // Product IDs for App Store
    private let productIds = [
        "forava_basic_monthly",
        "forava_basic_annual",
        "forava_premium_monthly",
        "forava_premium_annual",
        "forava_family_monthly",
        "forava_family_annual",
        "forava_pack_limited_edition",
        "forava_pack_seasonal_special",
        "forava_pack_artistic_masterpiece",
        "forava_pack_cultural_heritage",
        "forava_pack_modern_fusion",
        "forava_pack_royal_collection"
    ]

    private init() {
        // Initialize with current user ID (in production, this would come from authentication)
        self.userId = "current_user_id"
        self.subscriptionStatus = SubscriptionStatus(tier: .free)
        self.usageMetrics = UsageMetrics.current(for: userId)

        // Start listening for transaction updates
        updateListenerTask = listenForTransactions()

        Task {
            await loadProducts()
            await loadSubscriptionStatus()
        }
    }

    deinit {
        updateListenerTask?.cancel()
    }

    // MARK: - Product Loading
    func loadProducts() async {
        isLoading = true
        errorMessage = nil

        do {
            let products = try await Product.products(for: productIds)
            availableProducts = products.sorted { $0.price < $1.price }

            // Check current entitlements
            await updateSubscriptionStatus()
        } catch {
            errorMessage = "Failed to load products: \(error.localizedDescription)"
            print("Failed to load products: \(error)")
        }

        isLoading = false
    }

    // MARK: - Purchase Management
    func purchase(_ product: Product) async -> Bool {
        isLoading = true
        errorMessage = nil

        do {
            let result = try await product.purchase()

            switch result {
            case .success(let verification):
                let transaction = try await checkVerified(verification)
                await handlePurchase(transaction)
                await updateSubscriptionStatus()
                await transaction.finish()
                isLoading = false
                return true

            case .userCancelled:
                isLoading = false
                return false

            case .pending:
                errorMessage = "Purchase is pending approval"
                isLoading = false
                return false

            @unknown default:
                errorMessage = "Unknown purchase result"
                isLoading = false
                return false
            }
        } catch {
            errorMessage = "Purchase failed: \(error.localizedDescription)"
            isLoading = false
            return false
        }
    }

    func purchaseRegeneration() async -> Bool {
        isLoading = true

        // In a real app, this would be an IAP for consumable credits
        // For now, we'll simulate the purchase
        await MainActor.run {
            // Add 1 generation to current usage
            let newMetrics = UsageMetrics(
                userId: usageMetrics.userId,
                month: usageMetrics.month,
                year: usageMetrics.year,
                generationsUsed: usageMetrics.generationsUsed,
                culturesAccessed: usageMetrics.culturesAccessed,
                packsUsed: usageMetrics.packsUsed,
                totalSpent: usageMetrics.totalSpent + subscriptionStatus.tier.regenerationCost,
                regenerationsPurchased: usageMetrics.regenerationsPurchased + 1
            )

            usageMetrics = newMetrics
            saveSubscriptionStatus()
        }

        isLoading = false
        return true
    }

    func purchaseCulturalPack(_ pack: PremiumCulturalPack) async -> Bool {
        isLoading = true
        errorMessage = nil

        // Check if user meets subscription requirements
        guard subscriptionStatus.tier.rawValue >= pack.requiresSubscription.rawValue else {
            errorMessage = "This pack requires a \(pack.requiresSubscription.displayName) subscription"
            isLoading = false
            return false
        }

        // Check if already owned
        if subscriptionStatus.purchasedPacks.contains(pack) {
            errorMessage = "You already own this pack"
            isLoading = false
            return false
        }

        // Simulate purchase (in real app, this would go through StoreKit)
        let updatedStatus = SubscriptionStatus(tier: subscriptionStatus.tier)

        subscriptionStatus = updatedStatus
        saveSubscriptionStatus()

        isLoading = false
        return true
    }

    // MARK: - Subscription Management
    func upgradeSubscription(to tier: SubscriptionTier) async -> Bool {
        guard tier != .free else { return false }

        isLoading = true
        errorMessage = nil

        // Find the appropriate product
        let productId = "\(tier.rawValue)_monthly"
        guard let product = availableProducts.first(where: { $0.id == productId }) else {
            errorMessage = "Product not found"
            isLoading = false
            return false
        }

        return await purchase(product)
    }

    func restorePurchases() async {
        isLoading = true
        errorMessage = nil

        do {
            try await AppStore.sync()
            await updateSubscriptionStatus()
        } catch {
            errorMessage = "Failed to restore purchases: \(error.localizedDescription)"
        }

        isLoading = false
    }

    // MARK: - Usage Tracking
    func recordGeneration(culture: CulturalCategory, pack: PremiumCulturalPack? = nil) {
        // Update usage metrics
        var updatedMetrics = usageMetrics
        let newCultures = Set(updatedMetrics.culturesAccessed + [culture])
        var newPacks = updatedMetrics.packsUsed

        if let pack = pack {
            newPacks = Array(Set(newPacks + [pack]))
        }

        updatedMetrics = UsageMetrics(
            userId: updatedMetrics.userId,
            month: updatedMetrics.month,
            year: updatedMetrics.year,
            generationsUsed: updatedMetrics.generationsUsed + 1,
            culturesAccessed: Array(newCultures),
            packsUsed: newPacks,
            totalSpent: updatedMetrics.totalSpent,
            regenerationsPurchased: updatedMetrics.regenerationsPurchased
        )

        // Update subscription status
        let updatedSubscription = SubscriptionStatus(tier: subscriptionStatus.tier)

        usageMetrics = updatedMetrics
        subscriptionStatus = updatedSubscription

        saveSubscriptionStatus()
    }

    func canGenerate() -> (allowed: Bool, reason: String?) {
        let access = CulturalContentAccess(subscription: subscriptionStatus)
        return access.canGenerate()
    }

    func canAccessCulture(_ culture: CulturalCategory) -> Bool {
        return subscriptionStatus.canAccessCulture(culture)
    }

    func canAccessPack(_ pack: PremiumCulturalPack) -> Bool {
        return subscriptionStatus.canAccessPremiumPack(pack)
    }

    // MARK: - Private Methods
    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached { [weak self] in
            for await result in StoreKit.Transaction.updates {
                guard let self = self else { break }

                do {
                    let transaction = try await self.checkVerified(result)
                    await self.handlePurchase(transaction)
                    await self.updateSubscriptionStatus()
                    await transaction.finish()
                } catch {
                    print("Transaction verification failed: \(error)")
                }
            }
        }
    }

    private func handlePurchase(_ transaction: StoreKit.Transaction) async {
        // Handle different types of purchases
        if transaction.productID.contains("basic") {
            await updateSubscription(to: .basic, transaction: transaction)
        } else if transaction.productID.contains("premium") {
            await updateSubscription(to: .premium, transaction: transaction)
        } else if transaction.productID.contains("family") {
            await updateSubscription(to: .family, transaction: transaction)
        } else if transaction.productID.contains("pack") {
            await handlePackPurchase(transaction)
        }
    }

    private func updateSubscription(to tier: SubscriptionTier, transaction: StoreKit.Transaction) async {
        await MainActor.run {
            // Create new subscription status with proper initialization
            let newStatus = SubscriptionStatus(tier: tier)

            // Calculate transaction price properly
            let transactionPrice = (transaction.price as NSDecimalNumber?)?.doubleValue ?? 0.0

            // For now, we'll use the default initialization and track the spending separately
            // The SubscriptionStatus struct has computed properties for most values
            subscriptionStatus = newStatus

            // Update usage metrics to track the spending
            let updatedMetrics = UsageMetrics(
                userId: usageMetrics.userId,
                month: usageMetrics.month,
                year: usageMetrics.year,
                generationsUsed: usageMetrics.generationsUsed,
                culturesAccessed: usageMetrics.culturesAccessed,
                packsUsed: usageMetrics.packsUsed,
                totalSpent: usageMetrics.totalSpent + transactionPrice,
                regenerationsPurchased: usageMetrics.regenerationsPurchased
            )

            usageMetrics = updatedMetrics
            saveSubscriptionStatus()
        }
    }

    private func handlePackPurchase(_ transaction: StoreKit.Transaction) async {
        // Determine which pack was purchased based on product ID
        var purchasedPack: PremiumCulturalPack?

        if transaction.productID.contains("limited_edition") {
            purchasedPack = .limitedEdition
        } else if transaction.productID.contains("seasonal_special") {
            purchasedPack = .seasonalSpecial
        } else if transaction.productID.contains("artistic_masterpiece") {
            purchasedPack = .artisticMasterpiece
        } else if transaction.productID.contains("cultural_heritage") {
            purchasedPack = .culturalHeritage
        } else if transaction.productID.contains("modern_fusion") {
            purchasedPack = .modernFusion
        } else if transaction.productID.contains("royal_collection") {
            purchasedPack = .royalCollection
        }

        if let pack = purchasedPack {
            await MainActor.run {
                if !subscriptionStatus.purchasedPacks.contains(pack) {
                    let updatedStatus = SubscriptionStatus(tier: subscriptionStatus.tier)

                    subscriptionStatus = updatedStatus
                    saveSubscriptionStatus()
                }
            }
        }
    }

    private func updateSubscriptionStatus() async {
        // Check current entitlements and update subscription status
        var currentEntitlements: [String] = []

        for await result in StoreKit.Transaction.currentEntitlements {
            do {
                let transaction = try await checkVerified(result)
                currentEntitlements.append(transaction.productID)
            } catch {
                continue
            }
        }

        // Update subscription based on current entitlements
        await MainActor.run {
            if currentEntitlements.contains(where: { $0.contains("family") }) {
                if subscriptionStatus.tier != .family {
                    subscriptionStatus = SubscriptionStatus(tier: .family)
                }
            } else if currentEntitlements.contains(where: { $0.contains("premium") }) {
                if subscriptionStatus.tier != .premium {
                    subscriptionStatus = SubscriptionStatus(tier: .premium)
                }
            } else if currentEntitlements.contains(where: { $0.contains("basic") }) {
                if subscriptionStatus.tier != .basic {
                    subscriptionStatus = SubscriptionStatus(tier: .basic)
                }
            } else {
                if subscriptionStatus.tier != .free {
                    subscriptionStatus = SubscriptionStatus(tier: .free)
                }
            }

            purchasedProducts = Set(currentEntitlements)
            saveSubscriptionStatus()
        }
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) async throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let signedType):
            return signedType
        }
    }

    private func calculateRenewalDate(from purchaseDate: Date, for tier: SubscriptionTier) -> Date {
        return Calendar.current.date(byAdding: .month, value: 1, to: purchaseDate) ?? purchaseDate
    }

    private func loadSubscriptionStatus() async {
        // Load saved subscription status from UserDefaults
        if let data = UserDefaults.standard.data(forKey: "subscriptionStatus"),
           let status = try? JSONDecoder().decode(SubscriptionStatus.self, from: data) {
            await MainActor.run {
                subscriptionStatus = status
            }
        }

        // Load saved usage metrics
        if let data = UserDefaults.standard.data(forKey: "usageMetrics"),
           let metrics = try? JSONDecoder().decode(UsageMetrics.self, from: data) {
            await MainActor.run {
                usageMetrics = metrics
            }
        }
    }

    private func saveSubscriptionStatus() {
        // Save subscription status to UserDefaults
        if let data = try? JSONEncoder().encode(subscriptionStatus) {
            UserDefaults.standard.set(data, forKey: "subscriptionStatus")
        }

        // Save usage metrics
        if let data = try? JSONEncoder().encode(usageMetrics) {
            UserDefaults.standard.set(data, forKey: "usageMetrics")
        }
    }
}

// MARK: - Store Errors
enum StoreError: Error {
    case failedVerification
    case productNotFound
    case purchaseFailed
    case restoreFailed
}

// MARK: - Extensions
extension Color {
    static let gold = Color(red: 1.0, green: 0.843, blue: 0.0)
}
