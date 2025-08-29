import Foundation

enum Endpoints {
    static func captureApplePay() -> URL { Constants.apiBaseURL.appendingPathComponent("/payments/applepay/capture") }
    static func logGift() -> URL { Constants.apiBaseURL.appendingPathComponent("/gifts/log") }
    static func ticketekCreateVoucher() -> URL { Constants.apiBaseURL.appendingPathComponent("/ticketek/voucher/create") }
}
