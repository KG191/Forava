import Foundation
import PassKit

final class APIClient {
    static let shared = APIClient()
    private init() {}
    private let session = URLSession(configuration: .default)

    func captureApplePay(payment: PKPayment) async throws {
        let payload: [String: Any] = [
            "paymentToken": (payment.token.paymentData as Data).base64EncodedString(),
            "transactionIdentifier": payment.token.transactionIdentifier,
            "currencyCode": payment.paymentSheetLabel
        ]
        let data = try JSONSerialization.data(withJSONObject: payload, options: [])
        var req = URLRequest(url: Endpoints.captureApplePay())
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = data

        let (_, resp) = try await session.data(for: req)
        guard let http = resp as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw NSError(domain: "API", code: 1, userInfo: [NSLocalizedDescriptionKey: "Capture failed"])
        }
    }

    func ticketekCreateVoucher(rakhiId: UUID, amountMinor: Int64) async throws -> TicketekGift {
        let payload: [String: Any] = [
            "rakhiId": rakhiId.uuidString,
            "amountMinor": amountMinor
        ]
        let data = try JSONSerialization.data(withJSONObject: payload, options: [])
        var req = URLRequest(url: Endpoints.ticketekCreateVoucher())
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = data

        let (respData, resp) = try await session.data(for: req)
        guard let http = resp as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw NSError(domain: "API", code: 2, userInfo: [NSLocalizedDescriptionKey: "Ticketek fulfillment failed"])
        }
        return try JSONDecoder().decode(TicketekGift.self, from: respData)
    }
}
