import Foundation
import SwiftUI
import Combine

// MARK: - Subscription Tiers (Simplified)
enum SubscriptionTier: String, Codable, CaseIterable {
    case free = "free"
    case subscribed = "subscribed"

    var displayName: String {
        switch self {
        case .free: return "Free"
        case .subscribed: return "Subscribed"
        }
    }

    var monthlyPrice: Double {
        switch self {
        case .free: return 0.00
        case .subscribed: return 4.99  // Single monthly subscription price
        }
    }

    var features: [String] {
        switch self {
        case .free:
            return [
                "Limited access",
                "Watermarked designs",
                "Basic cultural elements"
            ]
        case .subscribed:
            return [
                "Full app access",
                "All 12 cultural designs",
                "Unlimited AI generations",
                "No watermarks",
                "Premium cultural elements",
                "Priority support"
            ]
        }
    }

    var primaryColor: Color {
        switch self {
        case .free: return .gray
        case .subscribed: return Color(hex: "#FF8A00") // Forava orange
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
