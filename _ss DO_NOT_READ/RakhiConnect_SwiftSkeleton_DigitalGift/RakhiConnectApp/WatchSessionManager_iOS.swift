import Foundation
import WatchConnectivity

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
              let amountMinor = message["amountMinor"] as? Int64,
              let currency = message["currency"] as? String,
              let kindRaw = message["kind"] as? String,
              let kind = GiftKind(rawValue: kindRaw),
              let rakhiIdStr = message["rakhiId"] as? String,
              let rakhiId = UUID(uuidString: rakhiIdStr)
        else { return }

        PaymentCoordinator.shared.presentApplePay(amountMinor: amountMinor, currencyCode: currency) { result in
            switch result {
            case .success:
                Task {
                    if kind == .digitalGift {
                        _ = try? await APIClient.shared.fulfillDigitalGift(rakhiId: rakhiId, amountMinor: amountMinor)
                    }
                    self.session?.sendMessage(["type":"gift_result","status":"succeeded","rakhiId": rakhiId.uuidString], replyHandler: nil, errorHandler: nil)
                }
            case .failure:
                self.session?.sendMessage(["type":"gift_result","status":"failed","rakhiId": rakhiId.uuidString], replyHandler: nil, errorHandler: nil)
            }
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) { session.activate() }
}
