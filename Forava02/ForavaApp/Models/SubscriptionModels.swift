import Foundation
import SwiftUI
import Combine
import StoreKit

// MARK: - IAP Product Identifiers
enum IAPProduct: String, CaseIterable {
    // Subscription Products (Auto-Renewable)
    case monthlySubscription = "com.forava.subscription.monthly"
    case annualSubscription = "com.forava.subscription.annual"

    // Credit Packs (Consumable)
    case credits10 = "com.forava.credits.10"
    case credits25 = "com.forava.credits.25"
    case credits50 = "com.forava.credits.50"
    case credits100 = "com.forava.credits.100"

    // Legacy (keep for backward compatibility)
    case regenerationCredit = "com.forava.regeneration.credit"

    var displayName: String {
        switch self {
        case .monthlySubscription:
            return "Monthly Unlimited"
        case .annualSubscription:
            return "Annual Unlimited"
        case .credits10:
            return "Starter Pack"
        case .credits25:
            return "Popular Pack"
        case .credits50:
            return "Family Pack"
        case .credits100:
            return "Festival Pack"
        case .regenerationCredit:
            return "Single Regeneration"
        }
    }

    var description: String {
        switch self {
        case .monthlySubscription:
            return "Unlimited AI generations for all 12 cultural events. Auto-renews monthly."
        case .annualSubscription:
            return "Unlimited generations + premium features. Best value - save 38%!"
        case .credits10:
            return "10 AI image generations. Perfect for a single event."
        case .credits25:
            return "25 AI image generations. Most popular choice!"
        case .credits50:
            return "50 AI image generations. Great for families."
        case .credits100:
            return "100 AI image generations. Maximum value!"
        case .regenerationCredit:
            return "Re-generate one image with new variations."
        }
    }

    var creditCount: Int? {
        switch self {
        case .credits10: return 10
        case .credits25: return 25
        case .credits50: return 50
        case .credits100: return 100
        case .regenerationCredit: return 1
        default: return nil
        }
    }

    var basePrice: Decimal {
        switch self {
        case .monthlySubscription: return 7.99
        case .annualSubscription: return 59.99
        case .credits10: return 9.99
        case .credits25: return 19.99
        case .credits50: return 34.99
        case .credits100: return 59.99
        case .regenerationCredit: return 1.99
        }
    }

    var perCreditCost: Decimal? {
        guard let credits = creditCount else { return nil }
        return basePrice / Decimal(credits)
    }

    var discountPercentage: Int {
        switch self {
        case .credits10: return 0  // Baseline
        case .credits25: return 20 // $0.80/credit vs $1.00
        case .credits50: return 30 // $0.70/credit vs $1.00
        case .credits100: return 40 // $0.60/credit vs $1.00
        case .annualSubscription: return 38 // vs monthly
        default: return 0
        }
    }

    var productType: Product.ProductType {
        switch self {
        case .monthlySubscription, .annualSubscription:
            return .autoRenewable
        case .credits10, .credits25, .credits50, .credits100, .regenerationCredit:
            return .consumable
        }
    }

    var isPopular: Bool {
        return self == .credits25 || self == .annualSubscription
    }
}

// MARK: - Regeneration Credit Model
struct RegenerationCredit: Codable, Identifiable {
    let id: UUID
    let purchaseDate: Date
    let isUsed: Bool
    let usedDate: Date?
    let culturalEvent: String? // Which event was regenerated

    init(id: UUID = UUID(), purchaseDate: Date = Date(), isUsed: Bool = false, usedDate: Date? = nil, culturalEvent: String? = nil) {
        self.id = id
        self.purchaseDate = purchaseDate
        self.isUsed = isUsed
        self.usedDate = usedDate
        self.culturalEvent = culturalEvent
    }

    func markAsUsed(for event: String) -> RegenerationCredit {
        return RegenerationCredit(
            id: self.id,
            purchaseDate: self.purchaseDate,
            isUsed: true,
            usedDate: Date(),
            culturalEvent: event
        )
    }
}

// MARK: - Subscription Tiers
enum SubscriptionTier: String, Codable, CaseIterable {
    case free = "free"
    case monthly = "monthly"
    case annual = "annual"

    var displayName: String {
        switch self {
        case .free: return "Free"
        case .monthly: return "Monthly"
        case .annual: return "Annual"
        }
    }

    var monthlyPrice: Double {
        switch self {
        case .free: return 0.00
        case .monthly: return 7.99
        case .annual: return 4.99  // Effective monthly ($59.99/12)
        }
    }

    var annualPrice: Double? {
        switch self {
        case .annual: return 59.99
        default: return nil
        }
    }

    var features: [String] {
        switch self {
        case .free:
            return [
                "3 free generations (lifetime)",
                "Watermarked images",
                "All 12 cultural events",
                "Basic customization"
            ]
        case .monthly:
            return [
                "Unlimited generations",
                "No watermarks",
                "All 12 cultural events",
                "Priority processing",
                "HD+ resolution (1792x1792)",
                "Batch generation"
            ]
        case .annual:
            return [
                "Everything in Monthly",
                "Save 38% annually",
                "Early access to new events",
                "Exclusive premium packs",
                "API access (coming soon)",
                "Priority support"
            ]
        }
    }

    var primaryColor: Color {
        switch self {
        case .free: return .gray
        case .monthly: return Color(hex: "#FF8A00") // Forava orange
        case .annual: return Color(hex: "#FFD700") // Gold for annual
        }
    }

    var badge: String? {
        switch self {
        case .annual: return "BEST VALUE"
        case .monthly: return "POPULAR"
        default: return nil
        }
    }
}

// MARK: - Subscription Status
struct SubscriptionStatus: Codable {
    var tier: SubscriptionTier
    var startDate: Date?
    var expirationDate: Date?
    var autoRenewing: Bool

    init(tier: SubscriptionTier, startDate: Date? = nil, expirationDate: Date? = nil, autoRenewing: Bool = false) {
        self.tier = tier
        self.startDate = startDate
        self.expirationDate = expirationDate
        self.autoRenewing = autoRenewing
    }

    var isActive: Bool {
        guard tier != .free else { return false }
        guard let expiration = expirationDate else { return true }
        return expiration > Date()
    }

    var daysRemaining: Int? {
        guard let expiration = expirationDate else { return nil }
        let days = Calendar.current.dateComponents([.day], from: Date(), to: expiration).day
        return max(0, days ?? 0)
    }
}
