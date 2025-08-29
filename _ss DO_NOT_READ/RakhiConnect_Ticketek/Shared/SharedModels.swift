import Foundation

public enum GiftKind: String, Codable, CaseIterable, Identifiable {
    case cash
    case ticketek
    public var id: String { rawValue }
    public var displayName: String {
        switch self {
        case .cash: return "Cash"
        case .ticketek: return "Ticketek"
        }
    }
}

public struct Rakhi: Codable, Identifiable, Equatable {
    public let id: UUID
    public let senderUserId: String
    public let receiverUserId: String
    public let sentAt: Date
    public let expiresAt: Date
    public let message: String?
    public let designId: String
    public var isExpired: Bool { Date() >= expiresAt }
}

public struct GiftIntent: Codable {
    public let rakhiId: UUID
    public let amountMinor: Int64
    public let currency: String
    public let kind: GiftKind
}

public struct GiftReceipt: Codable, Identifiable {
    public var id: UUID
    public let rakhiId: UUID
    public let amountMinor: Int64
    public let currency: String
    public let kind: GiftKind
    public let createdAt: Date
    public let status: GiftStatus
    public enum GiftStatus: String, Codable { case pending, succeeded, failed }
}

public struct TicketekGift: Codable, Identifiable {
    public var id: UUID
    public let rakhiId: UUID
    public let voucherCode: String?
    public let voucherURL: URL?
    public let expiry: Date?
}
