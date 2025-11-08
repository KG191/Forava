import Foundation
import StoreKit
import Combine
import SwiftUI

@MainActor
class SubscriptionManager: ObservableObject {
    static let shared = SubscriptionManager()

    @Published var isSubscribed = false
    @Published var availableProduct: Product?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var updateListenerTask: Task<Void, Error>?
    private var hasStarted = false

    // Single monthly subscription product for full app access
    private let productId = "forava_monthly_full_access"

    private init() {
        // Minimal initialization - defer product loading until needed
        // This prevents 12-15 second App Store call during app startup
    }

    deinit {
        updateListenerTask?.cancel()
    }

    // MARK: - Lazy Initialization
    /// Call this when user navigates to Settings or subscription UI
    /// Defers expensive StoreKit operations until actually needed
    func startIfNeeded() {
        guard !hasStarted else { return }
        hasStarted = true

        // Start listening for transaction updates
        updateListenerTask = listenForTransactions()

        Task {
            await loadProduct()
            await checkSubscriptionStatus()
        }
    }

    // MARK: - Product Loading
    private func loadProduct() async {
        isLoading = true
        errorMessage = nil

        do {
            let products = try await Product.products(for: [productId])
            availableProduct = products.first

            // Check current subscription status
            await checkSubscriptionStatus()
        } catch {
            errorMessage = "Failed to load subscription: \(error.localizedDescription)"
            print("❌ Failed to load product: \(error)")
        }

        isLoading = false
    }

    // MARK: - Purchase Management
    func purchase() async -> Bool {
        guard let product = availableProduct else {
            errorMessage = "Product not available"
            return false
        }

        isLoading = true
        errorMessage = nil

        do {
            let result = try await product.purchase()

            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await transaction.finish()
                await checkSubscriptionStatus()
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

    // MARK: - Subscription Status
    private func checkSubscriptionStatus() async {
        var activeSubscription = false

        // Check for active subscription entitlements
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)

                // Check if this is our subscription product
                if transaction.productID == productId {
                    activeSubscription = true
                    break
                }
            } catch {
                print("❌ Transaction verification failed: \(error)")
            }
        }

        isSubscribed = activeSubscription
    }

    // MARK: - Restore Purchases
    func restorePurchases() async {
        isLoading = true
        errorMessage = nil

        do {
            try await AppStore.sync()
            await checkSubscriptionStatus()
            isLoading = false
        } catch {
            errorMessage = "Failed to restore purchases: \(error.localizedDescription)"
            isLoading = false
        }
    }

    // MARK: - Transaction Verification
    nonisolated private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }

    // MARK: - Transaction Listener
    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            // Listen for transaction updates
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)

                    // Update subscription status
                    await self.checkSubscriptionStatus()

                    // Finish the transaction
                    await transaction.finish()
                } catch {
                    print("❌ Transaction update failed: \(error)")
                }
            }
        }
    }

    // MARK: - Subscription Status Helpers
    func loadSubscriptionStatus() async {
        await checkSubscriptionStatus()
    }

    var subscriptionStatusText: String {
        isSubscribed ? "Active" : "Not Active"
    }

    var subscriptionPrice: String {
        availableProduct?.displayPrice ?? "$4.99"
    }
}

// MARK: - Store Errors
enum StoreError: Error {
    case failedVerification
}
