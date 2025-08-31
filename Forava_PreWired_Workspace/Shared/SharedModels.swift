import Foundation

public enum GiftKind: String, Codable, CaseIterable, Identifiable {
    case cash
    case digitalGift
    public var id: String { rawValue }
    public var displayName: String { self == .cash ? "Cash" : "Digital Gift" }
}

public struct RitualToken: Codable, Identifiable, Equatable {
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
    public let tokenId: UUID
    public let amountMinor: Int64
    public let currency: String
    public let kind: GiftKind
}

public struct GiftReceipt: Codable, Identifiable {
    public var id: UUID
    public let tokenId: UUID
    public let amountMinor: Int64
    public let currency: String
    public let kind: GiftKind
    public let createdAt: Date
    public let status: GiftStatus
    public enum GiftStatus: String, Codable { case pending, succeeded, failed }
}

public struct DigitalGiftVoucher: Codable, Identifiable {
    public var id: UUID
    public let tokenId: UUID
    public let voucherCode: String?
    public let voucherURL: URL?
    public let expiry: Date?
}
