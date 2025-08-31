import Foundation
import WatchConnectivity

final class WatchSessionManagerWatch: NSObject, WCSessionDelegate {
    static let shared = WatchSessionManagerWatch()
    private override init() { super.init() }

    private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    private var replyHandlers: [UUID: (Bool) -> Void] = [:]

    func activate() {
        session?.delegate = self
        session?.activate()
    }

    func sendGiftRequest(token: RitualToken, amountMinor: Int64, currency: String, kind: GiftKind, completion: @escaping (Bool) -> Void) {
        guard let session = session, session.isReachable else {
            completion(false); return
        }
        replyHandlers[token.id] = completion
        session.sendMessage([
            "type": "gift_request",
            "tokenId": token.id.uuidString,
            "amountMinor": amountMinor,
            "currency": currency,
            "kind": kind.rawValue
        ], replyHandler: nil, errorHandler: { _ in completion(false) })
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        guard message["type"] as? String == "gift_result",
              let tokenIdString = message["tokenId"] as? String,
              let tokenId = UUID(uuidString: tokenIdString),
              let status = message["status"] as? String
        else { return }
        let ok = (status == "succeeded")
        replyHandlers[tokenId]?(ok)
        replyHandlers[tokenId] = nil
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
}
