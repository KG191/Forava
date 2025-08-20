import Foundation
import WatchConnectivity

class WatchConnectivityManager: NSObject, ObservableObject {
    static let shared = WatchConnectivityManager()
    
    @Published var isConnected = false
    @Published var receivedRakhis: [RakhiGift] = []
    
    private override init() {
        super.init()
        
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
    
    func sendRakhiToWatch(rakhi: Rakhi, to contact: Contact) {
        guard WCSession.default.isReachable else {
            print("Watch is not reachable")
            return
        }
        
        let rakhiData: [String: Any] = [
            "type": "rakhi_received",
            "rakhi": [
                "id": rakhi.id.uuidString,
                "name": rakhi.name,
                "imageName": rakhi.imageName,
                "description": rakhi.description,
                "price": rakhi.price,
                "category": rakhi.category.rawValue,
                "colors": rakhi.colors
            ],
            "sender": "You", // This would be the current user's name
            "recipient": contact.name,
            "timestamp": Date().timeIntervalSince1970
        ]
        
        WCSession.default.sendMessage(rakhiData, replyHandler: { reply in
            print("Rakhi sent successfully: \(reply)")
        }, errorHandler: { error in
            print("Failed to send rakhi: \(error.localizedDescription)")
        })
    }
    
    func sendRakhiWatchFace(rakhi: Rakhi) {
        guard WCSession.default.isReachable else {
            print("Watch is not reachable")
            return
        }
        
        let watchFaceData: [String: Any] = [
            "type": "activate_watch_face",
            "rakhi": [
                "id": rakhi.id.uuidString,
                "name": rakhi.name,
                "imageName": rakhi.imageName,
                "colors": rakhi.colors
            ],
            "timestamp": Date().timeIntervalSince1970
        ]
        
        WCSession.default.sendMessage(watchFaceData, replyHandler: { reply in
            print("Watch face activated: \(reply)")
        }, errorHandler: { error in
            print("Failed to activate watch face: \(error.localizedDescription)")
        })
    }
    
    func requestPayment(for rakhi: Rakhi, from sender: String) {
        guard WCSession.default.isReachable else {
            print("Watch is not reachable")
            return
        }
        
        let paymentRequest: [String: Any] = [
            "type": "payment_request",
            "rakhi": [
                "id": rakhi.id.uuidString,
                "name": rakhi.name,
                "price": rakhi.price
            ],
            "sender": sender,
            "timestamp": Date().timeIntervalSince1970
        ]
        
        WCSession.default.sendMessage(paymentRequest, replyHandler: { reply in
            print("Payment request sent: \(reply)")
        }, errorHandler: { error in
            print("Failed to send payment request: \(error.localizedDescription)")
        })
    }
}

// MARK: - WCSessionDelegate
extension WatchConnectivityManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            self.isConnected = activationState == .activated
        }
        
        if let error = error {
            print("WC Session activation failed: \(error.localizedDescription)")
        } else {
            print("WC Session activated with state: \(activationState.rawValue)")
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isConnected = false
        }
        print("WC Session became inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isConnected = false
        }
        print("WC Session deactivated")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print("Received message from watch: \(message)")
        
        guard let type = message["type"] as? String else {
            replyHandler(["success": false, "error": "Invalid message type"])
            return
        }
        
        switch type {
        case "rakhi_tap":
            handleRakhiTap(message: message, replyHandler: replyHandler)
        case "payment_completed":
            handlePaymentCompleted(message: message, replyHandler: replyHandler)
        case "watch_status":
            replyHandler(["success": true, "connected": true])
        default:
            replyHandler(["success": false, "error": "Unknown message type"])
        }
    }
    
    private func handleRakhiTap(message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        // Handle when user taps on rakhi watch face
        // This would trigger the payment flow
        
        guard let rakhiData = message["rakhi"] as? [String: Any],
              let rakhiId = rakhiData["id"] as? String,
              let _ = message["sender"] as? String else {
            replyHandler(["success": false, "error": "Invalid rakhi data"])
            return
        }
        
        // Find the rakhi and trigger payment flow
        if Rakhi.sampleRakhis.first(where: { $0.id.uuidString == rakhiId }) != nil {
            DispatchQueue.main.async {
                // You would present the PaymentReceiveView here
                // For now, we'll just acknowledge
                replyHandler(["success": true, "action": "payment_flow_initiated"])
            }
        } else {
            replyHandler(["success": false, "error": "Rakhi not found"])
        }
    }
    
    private func handlePaymentCompleted(message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        // Handle payment completion from watch
        
        guard let paymentData = message["payment"] as? [String: Any],
              let amount = paymentData["amount"] as? Double,
              let rakhiId = paymentData["rakhi_id"] as? String else {
            replyHandler(["success": false, "error": "Invalid payment data"])
            return
        }
        
        DispatchQueue.main.async {
            // Update UI to reflect payment completion
            // Activate watch face
            print("Payment completed: $\(amount) for rakhi \(rakhiId)")
            replyHandler(["success": true, "watch_face_activated": true])
        }
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("Received application context: \(applicationContext)")
        
        DispatchQueue.main.async {
            // Handle persistent data updates
            if let rakhisData = applicationContext["received_rakhis"] as? [[String: Any]] {
                // Update received rakhis list
                self.updateReceivedRakhis(from: rakhisData)
            }
        }
    }
    
    private func updateReceivedRakhis(from data: [[String: Any]]) {
        // Convert received data to RakhiGift objects
        // This would be used to sync rakhi gifts between devices
    }
}

// MARK: - Watch Connectivity Helper Extensions
extension WatchConnectivityManager {
    var isWatchAppInstalled: Bool {
        return WCSession.default.isWatchAppInstalled
    }
    
    var isWatchReachable: Bool {
        return WCSession.default.isReachable
    }
    
    func sendApplicationContext(_ context: [String: Any]) {
        do {
            try WCSession.default.updateApplicationContext(context)
        } catch {
            print("Failed to send application context: \(error.localizedDescription)")
        }
    }
}