import Foundation
import WatchConnectivity
import UIKit

final class WatchSessionManager_iOS: NSObject, WCSessionDelegate {
    static let shared = WatchSessionManager_iOS()
    private override init() { super.init(); activate() }

    private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil

    func activate() {
        session?.delegate = self
        session?.activate()
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        guard message["type"] as? String == "gift_request",
              let rakhiIdString = message["rakhiId"] as? String,
              let rakhiId = UUID(uuidString: rakhiIdString),
              let amountMinor = message["amountMinor"] as? Int64,
              let currency = message["currency"] as? String,
              let kindRaw = message["kind"] as? String,
              let kind = GiftKind(rawValue: kindRaw) else { return }

        let complete: (Result<Void, Error>) -> Void = { result in
            let status = (try? result.get()) == () ? "succeeded" : "failed"
            self.session?.sendMessage([
                "type": "gift_result",
                "rakhiId": rakhiId.uuidString,
                "status": status
            ], replyHandler: nil, errorHandler: nil)
        }

        switch kind {
        case .cash:
            PaymentCoordinator.shared.presentApplePayForCash(amountMinor: amountMinor,
                                                             currencyCode: currency,
                                                             rakhiId: rakhiId) { result in
                switch result {
                case .success: complete(.success(()))
                case .failure(let e): complete(.failure(e))
                }
            }
        case .ticketek:
            PaymentCoordinator.shared.presentApplePayForTicketek(amountMinor: amountMinor,
                                                                 currencyCode: currency,
                                                                 rakhiId: rakhiId) { result in
                switch result {
                case .success:
                    Task {
                        do {
                            _ = try await TicketekCoordinator.shared.fulfillTicketekVoucher(rakhiId: rakhiId, amountMinor: amountMinor)
                            complete(.success(()))
                        } catch { complete(.failure(error)) }
                    }
                case .failure(let e): complete(.failure(e))
                }
            }
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) { session.activate() }
}
