import Foundation
import StoreKit
import Combine

// MARK: - Phase 1: Revenue Model & Subscription Management
// Implements subscription-based revenue tracking with re-generation credits

@MainActor
class SubscriptionManager: ObservableObject {
    static let shared = SubscriptionManager()

    // MARK: - Published Properties
    @Published var isPremiumSubscriber: Bool = false
    @Published var currentSubscription: SubscriptionTier = .free
    @Published var regenerationCredits: Int = 0
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // MARK: - Product Identifiers
    private enum ProductIdentifiers {
        static let monthlySubscription = "com.forava.premium.monthly"
        static let annualSubscription = "com.forava.premium.annual"
        static let regenerationCredit = "com.forava.regeneration.credit"
    }

    // MARK: - Private Properties
    private var products: [Product] = []
    private var cancellables = Set<AnyCancellable>()
    private let userDefaults = UserDefaults.standard

    private init() {
        loadSubscriptionStatus()
        observeTransactions()
    }

    // MARK: - Public Methods

    func loadProducts() async {
        isLoading = true

        do {
            let productIds = [
                ProductIdentifiers.monthlySubscription,
                ProductIdentifiers.annualSubscription,
                ProductIdentifiers.regenerationCredit
            ]

            products = try await Product.products(for: productIds)
            isLoading = false
            print("✅ Loaded \(products.count) subscription products")
        } catch {
            await handleError("Failed to load products: \(error.localizedDescription)")
        }
    }

    func purchaseSubscription(tier: SubscriptionTier) async {
        guard let product = getProduct(for: tier) else {
            await handleError("Product not available")
            return
        }

        isLoading = true

        do {
            let result = try await product.purchase()

            switch result {
            case .success(let verification):
                switch verification {
                case .verified(let transaction):
                    await handleSuccessfulPurchase(transaction)
                case .unverified:
                    await handleError("Purchase verification failed")
                }
            case .pending:
                await handleError("Purchase is pending approval")
            case .userCancelled:
                isLoading = false
            @unknown default:
                await handleError("Unknown purchase result")
            }
        } catch {
            await handleError("Purchase failed: \(error.localizedDescription)")
        }
    }

    func purchaseRegenerationCredit() async -> Bool {
        guard let product = products.first(where: { $0.id == ProductIdentifiers.regenerationCredit }) else {
            await handleError("Regeneration credit not available")
            return false
        }

        isLoading = true

        do {
            let result = try await product.purchase()

            switch result {
            case .success(let verification):
                switch verification {
                case .verified(let transaction):
                    await handleRegenerationCreditPurchase(transaction)
                    return true
                case .unverified:
                    await handleError("Credit verification failed")
                    return false
                }
            case .userCancelled:
                isLoading = false
                return false
            default:
                await handleError("Credit purchase failed")
                return false
            }
        } catch {
            await handleError("Credit purchase error: \(error.localizedDescription)")
            return false
        }
    }

    func canGenerate() -> Bool {
        // Free tier: 1 free generation per month
        // Premium: Unlimited
        // Regeneration: Requires credits

        if isPremiumSubscriber {
            return true
        }

        if hasUsedFreeGeneration() {
            return regenerationCredits > 0
        }

        return true // First free generation
    }

    func consumeGenerationCredit() {
        if isPremiumSubscriber {
            return // Premium users don't consume credits
        }

        if hasUsedFreeGeneration() && regenerationCredits > 0 {
            regenerationCredits -= 1
            saveSubscriptionStatus()
        }

        markFreeGenerationUsed()
    }

    func restorePurchases() async {
        isLoading = true

        do {
            try await AppStore.sync()
            await updateSubscriptionStatus()
            isLoading = false
        } catch {
            await handleError("Failed to restore purchases: \(error.localizedDescription)")
        }
    }

    // MARK: - Private Methods

    private func getProduct(for tier: SubscriptionTier) -> Product? {
        let productId = tier == .monthlyPremium ? ProductIdentifiers.monthlySubscription : ProductIdentifiers.annualSubscription
        return products.first { $0.id == productId }
    }

    private func handleSuccessfulPurchase(_ transaction: StoreKit.Transaction) async {
        await transaction.finish()
        await updateSubscriptionStatus()
        isLoading = false
        print("✅ Subscription purchase successful: \(transaction.productID)")
    }

    private func handleRegenerationCreditPurchase(_ transaction: StoreKit.Transaction) async {
        await transaction.finish()
        regenerationCredits += 1
        saveSubscriptionStatus()
        isLoading = false
        print("✅ Regeneration credit purchased")
    }

    private func observeTransactions() {
        Task {
            for await result in StoreKit.Transaction.updates {
                switch result {
                case .verified(let transaction):
                    await updateSubscriptionStatus()
                    await transaction.finish()
                case .unverified:
                    print("⚠️ Unverified transaction received")
                }
            }
        }
    }

    private func updateSubscriptionStatus() async {
        var activeSubscription = false

        for await result in StoreKit.Transaction.currentEntitlements {
            switch result {
            case .verified(let transaction):
                if transaction.productID == ProductIdentifiers.monthlySubscription {
                    activeSubscription = true
                    currentSubscription = .monthlyPremium
                } else if transaction.productID == ProductIdentifiers.annualSubscription {
                    activeSubscription = true
                    currentSubscription = .annualPremium
                }
            case .unverified:
                break
            }
        }

        isPremiumSubscriber = activeSubscription
        if !activeSubscription {
            currentSubscription = .free
        }

        saveSubscriptionStatus()
    }

    private func hasUsedFreeGeneration() -> Bool {
        let lastFreeUse = userDefaults.object(forKey: "lastFreeGenerationDate") as? Date
        guard let lastUse = lastFreeUse else { return false }

        let calendar = Calendar.current
        let now = Date()

        // Reset monthly if a month has passed
        if !calendar.isDate(lastUse, equalTo: now, toGranularity: .month) {
            userDefaults.removeObject(forKey: "lastFreeGenerationDate")
            return false
        }

        return true
    }

    private func markFreeGenerationUsed() {
        userDefaults.set(Date(), forKey: "lastFreeGenerationDate")
    }

    private func loadSubscriptionStatus() {
        isPremiumSubscriber = userDefaults.bool(forKey: "isPremiumSubscriber")
        regenerationCredits = userDefaults.integer(forKey: "regenerationCredits")

        if let tierString = userDefaults.string(forKey: "subscriptionTier"),
           let tier = SubscriptionTier(rawValue: tierString) {
            currentSubscription = tier
        }
    }

    private func saveSubscriptionStatus() {
        userDefaults.set(isPremiumSubscriber, forKey: "isPremiumSubscriber")
        userDefaults.set(regenerationCredits, forKey: "regenerationCredits")
        userDefaults.set(currentSubscription.rawValue, forKey: "subscriptionTier")
    }

    private func handleError(_ message: String) async {
        isLoading = false
        errorMessage = message
        print("❌ Subscription Error: \(message)")
    }
}

// MARK: - Subscription Models

enum SubscriptionTier: String, CaseIterable {
    case free = "free"
    case monthlyPremium = "monthly_premium"
    case annualPremium = "annual_premium"

    var displayName: String {
        switch self {
        case .free: return "Free"
        case .monthlyPremium: return "Premium Monthly"
        case .annualPremium: return "Premium Annual"
        }
    }

    var price: String {
        switch self {
        case .free: return "Free"
        case .monthlyPremium: return "$4.99/month"
        case .annualPremium: return "$39.99/year"
        }
    }

    var benefits: [String] {
        switch self {
        case .free:
            return ["1 free generation per month", "Basic cultural designs", "Standard support"]
        case .monthlyPremium, .annualPremium:
            return [
                "Unlimited generations",
                "Premium cultural agents",
                "Advanced validation",
                "Priority support",
                "Early access to new cultures"
            ]
        }
    }
}

struct SubscriptionUsageStats {
    let generationsThisMonth: Int
    let totalGenerations: Int
    let creditsRemaining: Int
    let subscriptionStartDate: Date?
    let nextRenewalDate: Date?
}

// MARK: - Revenue Tracking Extensions

extension SubscriptionManager {

    func getUsageStats() -> SubscriptionUsageStats {
        let generationsThisMonth = userDefaults.integer(forKey: "generationsThisMonth")
        let totalGenerations = userDefaults.integer(forKey: "totalGenerations")

        return SubscriptionUsageStats(
            generationsThisMonth: generationsThisMonth,
            totalGenerations: totalGenerations,
            creditsRemaining: regenerationCredits,
            subscriptionStartDate: userDefaults.object(forKey: "subscriptionStartDate") as? Date,
            nextRenewalDate: userDefaults.object(forKey: "nextRenewalDate") as? Date
        )
    }

    func incrementGenerationCount() {
        let currentMonthGenerations = userDefaults.integer(forKey: "generationsThisMonth")
        let totalGenerations = userDefaults.integer(forKey: "totalGenerations")

        userDefaults.set(currentMonthGenerations + 1, forKey: "generationsThisMonth")
        userDefaults.set(totalGenerations + 1, forKey: "totalGenerations")

        // Reset monthly counter if needed
        if let lastReset = userDefaults.object(forKey: "lastMonthlyReset") as? Date {
            let calendar = Calendar.current
            if !calendar.isDate(lastReset, equalTo: Date(), toGranularity: .month) {
                userDefaults.set(0, forKey: "generationsThisMonth")
                userDefaults.set(Date(), forKey: "lastMonthlyReset")
            }
        } else {
            userDefaults.set(Date(), forKey: "lastMonthlyReset")
        }
    }
}
