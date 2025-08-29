import Foundation
import WatchConnectivity

final class WatchSessionManager_Watch: NSObject, WCSessionDelegate {
    static let shared = WatchSessionManager_Watch()
    private override init() { super.init(); activate() }

    private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    private var replyHandlers: [UUID: (Bool) -> Void] = [:]

    func activate() {
        session?.delegate = self
        session?.activate()
    }

    func sendGiftRequest(rakhi: Rakhi, amountMinor: Int64, currency: String, kind: GiftKind, completion: @escaping (Bool) -> Void) {
        guard let session = session, session.isReachable else {
            completion(false); return
        }
        replyHandlers[rakhi.id] = completion
        session.sendMessage([
            "type": "gift_request",
            "rakhiId": rakhi.id.uuidString,
            "amountMinor": amountMinor,
            "currency": currency,
            "kind": kind.rawValue
        ], replyHandler: nil, errorHandler: { _ in completion(false) })
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        guard message["type"] as? String == "gift_result",
              let rakhiIdString = message["rakhiId"] as? String,
              let rakhiId = UUID(uuidString: rakhiIdString),
              let status = message["status"] as? String
        else { return }
        let ok = (status == "succeeded")
        replyHandlers[rakhiId]?(ok)
        replyHandlers[rakhiId] = nil
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
}
