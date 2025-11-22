//
//  RegenerationIAPManager.swift
//  Forava
//
//  Created for App Store Compliance
//  Re-generation IAP implementation using StoreKit 2
//
//  REQUIREMENT: BUSINESS-001 in ACTION_ITEMS_BACKLOG.md
//  COMPLIANCE: Apple Guideline 3.1 - All purchases through Apple IAP
//  REVENUE MODEL: $1.99 per AI regeneration credit (consumable IAP)
//

import Foundation
import StoreKit
import Combine

/// Manages consumable in-app purchases for AI regeneration credits
/// Uses StoreKit 2 for transaction handling and verification
@MainActor
class RegenerationIAPManager: ObservableObject {

    // MARK: - Published Properties

    /// Available IAP products fetched from App Store
    @Published private(set) var products: [Product] = []

    /// Loading state for product fetch
    @Published private(set) var isLoadingProducts = false

    /// Purchase in progress state
    @Published private(set) var isPurchasing = false

    /// Available regeneration credits (unused purchases)
    @Published private(set) var availableCredits: Int = 0

    /// All purchased credits (including used ones)
    @Published private(set) var allCredits: [RegenerationCredit] = []

    /// Last error message
    @Published var lastError: String?

    // MARK: - Private Properties

    private var updateListenerTask: Task<Void, Error>?
    private let creditsStorageKey = "forava.regeneration.credits"
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Singleton

    static let shared = RegenerationIAPManager()

    private init() {
        // Load saved credits immediately (fast operation)
        loadCreditsFromStorage()

        // Defer transaction listener to prevent blocking UI on launch
        // This runs in the background after a delay to avoid the 17-second freeze
        Task.detached(priority: .background) {
            // Wait 3 seconds to allow UI to fully load
            try? await Task.sleep(nanoseconds: 3_000_000_000)

            // Start transaction listener on main actor
            await MainActor.run {
                self.updateListenerTask = self.listenForTransactions()
            }
        }
    }

    deinit {
        updateListenerTask?.cancel()
    }

    // MARK: - Product Loading

    /// Fetch available products from App Store Connect
    func loadProducts() async {
        isLoadingProducts = true
        lastError = nil

        do {
            // Fetch all consumable products (credit packs + legacy regeneration credit)
            let productIDs: Set<String> = [
                IAPProduct.credits10.rawValue,
                IAPProduct.credits25.rawValue,
                IAPProduct.credits50.rawValue,
                IAPProduct.credits100.rawValue,
                IAPProduct.regenerationCredit.rawValue  // Legacy support
            ]
            let storeProducts = try await Product.products(for: productIDs)

            self.products = storeProducts

            if storeProducts.isEmpty {
                lastError = "No products available. Please check App Store Connect configuration."
                print("⚠️ No IAP products found for IDs: \(productIDs)")
            } else {
                print("✅ Loaded \(storeProducts.count) IAP product(s)")
                for product in storeProducts {
                    print("  - \(product.displayName): \(product.displayPrice)")
                }
            }
        } catch {
            lastError = "Failed to load products: \(error.localizedDescription)"
            print("❌ Error loading products: \(error)")
        }

        isLoadingProducts = false
    }

    // MARK: - Purchase Flow

    /// Purchase a regeneration credit
    /// - Returns: Transaction if successful, nil if cancelled or failed
    func purchaseRegenerationCredit() async throws -> Transaction? {
        guard let product = products.first(where: { $0.id == IAPProduct.regenerationCredit.rawValue }) else {
            throw IAPError.productNotFound
        }

        isPurchasing = true
        lastError = nil

        defer {
            isPurchasing = false
        }

        do {
            let result = try await product.purchase()

            switch result {
            case .success(let verification):
                // Verify transaction
                let transaction = try checkVerified(verification)

                // Add credit to user's account
                await addCredit(from: transaction)

                // Finish transaction
                await transaction.finish()

                print("✅ Purchase successful: \(transaction.id)")
                return transaction

            case .userCancelled:
                print("🚫 User cancelled purchase")
                return nil

            case .pending:
                print("⏳ Purchase pending (awaiting approval)")
                lastError = "Purchase is pending approval. Please check back later."
                return nil

            @unknown default:
                throw IAPError.unknownPurchaseResult
            }
        } catch {
            lastError = "Purchase failed: \(error.localizedDescription)"
            print("❌ Purchase error: \(error)")
            throw error
        }
    }

    /// Purchase a credit pack (10, 25, 50, or 100 credits)
    /// - Parameter product: The IAPProduct representing the credit pack
    /// - Returns: Transaction if successful, nil if cancelled or failed
    func purchaseCreditPack(_ product: IAPProduct) async throws -> Transaction? {
        // Verify it's a credit pack product
        guard let creditCount = product.creditCount else {
            throw IAPError.invalidProduct
        }

        guard let storeProduct = products.first(where: { $0.id == product.rawValue }) else {
            throw IAPError.productNotFound
        }

        isPurchasing = true
        lastError = nil

        defer {
            isPurchasing = false
        }

        do {
            let result = try await storeProduct.purchase()

            switch result {
            case .success(let verification):
                // Verify transaction
                let transaction = try checkVerified(verification)

                // Add multiple credits based on pack size
                await addCredits(count: creditCount, from: transaction)

                // Finish transaction
                await transaction.finish()

                print("✅ Purchase successful: \(creditCount) credits added (transaction: \(transaction.id))")
                return transaction

            case .userCancelled:
                print("🚫 User cancelled purchase")
                return nil

            case .pending:
                print("⏳ Purchase pending (awaiting approval)")
                lastError = "Purchase is pending approval. Please check back later."
                return nil

            @unknown default:
                throw IAPError.unknownPurchaseResult
            }
        } catch {
            lastError = "Purchase failed: \(error.localizedDescription)"
            print("❌ Purchase error: \(error)")
            throw error
        }
    }

    /// Use a regeneration credit for a cultural event
    /// - Parameter culturalEvent: Name of the cultural event being regenerated
    /// - Returns: True if credit was used, false if no credits available
    func useCredit(for culturalEvent: String) -> Bool {
        guard availableCredits > 0 else {
            print("❌ No available credits to use")
            lastError = "No regeneration credits available. Please purchase credits to continue."
            return false
        }

        // Find first unused credit
        guard let index = allCredits.firstIndex(where: { !$0.isUsed }) else {
            print("❌ No unused credits found (inconsistent state)")
            return false
        }

        // Mark as used
        allCredits[index] = allCredits[index].markAsUsed(for: culturalEvent)

        // Update available count
        availableCredits = allCredits.filter { !$0.isUsed }.count

        // Persist to storage
        saveCreditsToStorage()

        print("✅ Used credit for \(culturalEvent). Remaining: \(availableCredits)")
        return true
    }

    // MARK: - Transaction Verification

    /// Verify transaction authenticity
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified(_, let error):
            // Transaction failed verification
            print("❌ Transaction verification failed: \(error)")
            throw IAPError.verificationFailed
        case .verified(let transaction):
            // Transaction passed verification
            return transaction
        }
    }

    // MARK: - Transaction Listener

    /// Listen for transaction updates (purchases, renewals, etc.)
    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            // Iterate through any unfinished transactions
            for await result in Transaction.updates {
                do {
                    // Inline verification to avoid actor isolation issues
                    let transaction: Transaction
                    switch result {
                    case .unverified(_, let error):
                        print("❌ Transaction verification failed: \(error)")
                        throw IAPError.verificationFailed
                    case .verified(let verified):
                        transaction = verified
                    }

                    // Deliver products to the user
                    await self.addCredit(from: transaction)

                    // Always finish a transaction
                    await transaction.finish()

                    print("✅ Transaction update processed: \(transaction.id)")
                } catch {
                    print("❌ Transaction verification failed: \(error)")
                }
            }
        }
    }

    // MARK: - Restore Purchases

    /// Restore previously purchased credits
    func restorePurchases() async {
        isPurchasing = true
        lastError = nil

        var restoredCount = 0

        do {
            // Sync with App Store
            try await AppStore.sync()

            // Iterate through all user transactions
            for await result in Transaction.currentEntitlements {
                let transaction = try checkVerified(result)

                // Process all consumable credit products
                let allCreditProducts = [
                    IAPProduct.credits10.rawValue,
                    IAPProduct.credits25.rawValue,
                    IAPProduct.credits50.rawValue,
                    IAPProduct.credits100.rawValue,
                    IAPProduct.regenerationCredit.rawValue  // Legacy support
                ]

                if allCreditProducts.contains(transaction.productID) {
                    // Determine credit count from product
                    let creditCount: Int
                    switch transaction.productID {
                    case IAPProduct.credits10.rawValue: creditCount = 10
                    case IAPProduct.credits25.rawValue: creditCount = 25
                    case IAPProduct.credits50.rawValue: creditCount = 50
                    case IAPProduct.credits100.rawValue: creditCount = 100
                    case IAPProduct.regenerationCredit.rawValue: creditCount = 1
                    default: creditCount = 1
                    }

                    await addCredits(count: creditCount, from: transaction)
                    restoredCount += creditCount
                }
            }

            if restoredCount > 0 {
                print("✅ Restored \(restoredCount) regeneration credit(s)")
            } else {
                print("ℹ️ No purchases to restore")
                lastError = "No previous purchases found."
            }
        } catch {
            lastError = "Failed to restore purchases: \(error.localizedDescription)"
            print("❌ Restore error: \(error)")
        }

        isPurchasing = false
    }

    // MARK: - Credit Management

    /// Add credit from verified transaction
    private func addCredit(from transaction: Transaction) async {
        // Check if we've already added this transaction
        if allCredits.contains(where: { $0.id.uuidString == transaction.id.description }) {
            print("ℹ️ Credit already added for transaction: \(transaction.id)")
            return
        }

        // Create new credit
        let credit = RegenerationCredit(
            id: UUID(),
            purchaseDate: transaction.purchaseDate ?? Date(),
            isUsed: false,
            usedDate: nil,
            culturalEvent: nil
        )

        // Add to credits array
        allCredits.append(credit)

        // Update available count
        availableCredits = allCredits.filter { !$0.isUsed }.count

        // Persist to storage
        saveCreditsToStorage()

        print("✅ Added regeneration credit. Total available: \(availableCredits)")
    }

    /// Add multiple credits from verified transaction (for credit packs)
    private func addCredits(count: Int, from transaction: Transaction) async {
        // Check if we've already added this transaction
        if allCredits.contains(where: { $0.id.uuidString == transaction.id.description }) {
            print("ℹ️ Credits already added for transaction: \(transaction.id)")
            return
        }

        // Create multiple credits (one for each credit in the pack)
        for _ in 0..<count {
            let credit = RegenerationCredit(
                id: UUID(),
                purchaseDate: transaction.purchaseDate ?? Date(),
                isUsed: false,
                usedDate: nil,
                culturalEvent: nil
            )
            allCredits.append(credit)
        }

        // Update available count
        availableCredits = allCredits.filter { !$0.isUsed }.count

        // Persist to storage
        saveCreditsToStorage()

        print("✅ Added \(count) credits from pack purchase. Total available: \(availableCredits)")
    }

    // MARK: - Persistence

    /// Save credits to UserDefaults
    private func saveCreditsToStorage() {
        do {
            let data = try JSONEncoder().encode(allCredits)
            UserDefaults.standard.set(data, forKey: creditsStorageKey)
            print("💾 Saved \(allCredits.count) credits to storage")
        } catch {
            print("❌ Failed to save credits: \(error)")
        }
    }

    /// Load credits from UserDefaults
    private func loadCreditsFromStorage() {
        guard let data = UserDefaults.standard.data(forKey: creditsStorageKey) else {
            print("ℹ️ No saved credits found")
            return
        }

        do {
            allCredits = try JSONDecoder().decode([RegenerationCredit].self, from: data)
            availableCredits = allCredits.filter { !$0.isUsed }.count
            print("✅ Loaded \(allCredits.count) credits from storage (\(availableCredits) available)")
        } catch {
            print("❌ Failed to load credits: \(error)")
        }
    }

    /// Clear all credits (for testing only)
    func clearAllCredits() {
        allCredits.removeAll()
        availableCredits = 0
        UserDefaults.standard.removeObject(forKey: creditsStorageKey)
        print("🗑️ Cleared all credits")
    }

    // MARK: - Helper Methods

    /// Get formatted price for regeneration credit
    func getRegenerationPrice() -> String {
        guard let product = products.first(where: { $0.id == IAPProduct.regenerationCredit.rawValue }) else {
            return "$1.99" // Default fallback
        }
        return product.displayPrice
    }

    /// Check if user has available credits
    func hasAvailableCredits() -> Bool {
        return availableCredits > 0
    }
}

// MARK: - IAP Error Types

enum IAPError: LocalizedError {
    case productNotFound
    case invalidProduct
    case verificationFailed
    case unknownPurchaseResult
    case noPurchasesFound

    var errorDescription: String? {
        switch self {
        case .productNotFound:
            return "Product not found. Please check App Store Connect configuration."
        case .invalidProduct:
            return "Invalid product type."
        case .verificationFailed:
            return "Transaction verification failed. Please try again."
        case .unknownPurchaseResult:
            return "Unknown purchase result. Please try again."
        case .noPurchasesFound:
            return "No previous purchases found."
        }
    }
}
