import Foundation
import WatchConnectivity
import WatchKit

class WatchConnectivityManager: NSObject, ObservableObject {
    static let shared = WatchConnectivityManager()
    
    @Published var isConnected = false
    @Published var receivedRakhis: [RakhiGift] = []
    @Published var availableAnimations: [String: AnimationData] = [:]
    @Published var enhancedPaymentContext: EnhancedPaymentContext?
    
    var onRakhiReceived: ((RakhiGift) -> Void)?
    var onAnimationReceived: ((String, AnimationData) -> Void)?
    var onPaymentContextReceived: ((EnhancedPaymentContext) -> Void)?
    
    private override init() {
        super.init()
        
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
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
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print("Watch received message: \(message)")
        
        guard let type = message["type"] as? String else {
            replyHandler(["success": false, "error": "Invalid message type"])
            return
        }
        
        switch type {
        case "rakhi_received":
            handleRakhiReceived(message: message, replyHandler: replyHandler)
        case "activate_watch_face":
            handleWatchFaceActivation(message: message, replyHandler: replyHandler)
        case "animation_data":
            handleAnimationData(message: message, replyHandler: replyHandler)
        case "payment_context":
            handlePaymentContext(message: message, replyHandler: replyHandler)
        case "real_time_update":
            handleRealTimeUpdate(message: message, replyHandler: replyHandler)
        default:
            replyHandler(["success": false, "error": "Unknown message type"])
        }
    }
    
    private func handleRakhiReceived(message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        guard let rakhiData = message["rakhi"] as? [String: Any],
              let sender = message["sender"] as? String,
              let recipient = message["recipient"] as? String else {
            replyHandler(["success": false, "error": "Invalid rakhi data"])
            return
        }
        
        // Create RakhiGift from received data
        if let rakhi = createRakhiFromData(rakhiData) {
            let rakhiGift = RakhiGift(
                rakhi: rakhi,
                sender: sender,
                recipient: recipient,
                sentDate: Date(),
                status: .received,
                paymentAmount: nil,
                message: nil
            )
            
            DispatchQueue.main.async {
                self.receivedRakhis.append(rakhiGift)
                self.onRakhiReceived?(rakhiGift)
            }
            
            replyHandler(["success": true, "message": "Rakhi received on watch"])
        } else {
            replyHandler(["success": false, "error": "Failed to create rakhi"])
        }
    }
    
    private func handleWatchFaceActivation(message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        // Handle watch face activation with enhanced features
        replyHandler(["success": true, "message": "Watch face activated with enhanced features"])
    }
    
    private func handleAnimationData(message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        guard let rakhiId = message["rakhi_id"] as? String,
              let animationData = message["animation"] as? [String: Any] else {
            replyHandler(["success": false, "error": "Invalid animation data"])
            return
        }
        
        if let animation = createAnimationFromData(animationData) {
            DispatchQueue.main.async {
                self.availableAnimations[rakhiId] = animation
                self.onAnimationReceived?(rakhiId, animation)
            }
            replyHandler(["success": true, "message": "Animation data received"])
        } else {
            replyHandler(["success": false, "error": "Failed to process animation data"])
        }
    }
    
    private func handlePaymentContext(message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        guard let contextData = message["context"] as? [String: Any] else {
            replyHandler(["success": false, "error": "Invalid payment context"])
            return
        }
        
        if let context = createPaymentContextFromData(contextData) {
            DispatchQueue.main.async {
                self.enhancedPaymentContext = context
                self.onPaymentContextReceived?(context)
            }
            replyHandler(["success": true, "message": "Payment context received"])
        } else {
            replyHandler(["success": false, "error": "Failed to process payment context"])
        }
    }
    
    private func handleRealTimeUpdate(message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        guard let updateType = message["update_type"] as? String else {
            replyHandler(["success": false, "error": "Invalid update type"])
            return
        }
        
        switch updateType {
        case "generation_progress":
            // Handle real-time generation progress
            if message["progress"] as? Float != nil {
                // Update UI with progress
                replyHandler(["success": true, "message": "Progress updated"])
            }
        case "cultural_blessing":
            // Handle cultural blessing received
            replyHandler(["success": true, "message": "Blessing received"])
        default:
            replyHandler(["success": true, "message": "Update acknowledged"])
        }
    }
    
    private func createRakhiFromData(_ data: [String: Any]) -> Rakhi? {
        guard let name = data["name"] as? String,
              let imageName = data["imageName"] as? String,
              let description = data["description"] as? String,
              let price = data["price"] as? Double,
              let categoryString = data["category"] as? String,
              let category = RakhiCategory(rawValue: categoryString),
              let colors = data["colors"] as? [String] else {
            return nil
        }
        
        // Handle embedded image data
        var rakhiImageName = imageName
        if let imageDataString = data["image_data"] as? String,
           let imageData = Data(base64Encoded: imageDataString),
           let hasEmbeddedImage = data["has_embedded_image"] as? Bool,
           hasEmbeddedImage {
            
            // Save image data to Watch's documents directory
            let imageFileName = "rakhi_\(UUID().uuidString).jpg"
            if let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let imageURL = documentsPath.appendingPathComponent(imageFileName)
                
                do {
                    try imageData.write(to: imageURL)
                    rakhiImageName = imageFileName
                    print("Rakhi image saved to Watch: \(imageURL.path)")
                    
                    // Also save to Photos for easy access
                    if let image = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            WKInterfaceDevice.current().addMedia(image, name: "Rakhi_\(name)", completion: { success in
                                print("Added Rakhi to Watch Photos: \(success)")
                            })
                        }
                    }
                    
                } catch {
                    print("Failed to save Rakhi image: \(error.localizedDescription)")
                }
            }
        }
        
        return Rakhi(
            name: name,
            imageName: rakhiImageName,
            description: description,
            price: price,
            category: category,
            colors: colors
        )
    }
    
    private func createAnimationFromData(_ data: [String: Any]) -> AnimationData? {
        guard let frameCount = data["frame_count"] as? Int,
              let duration = data["duration"] as? Double,
              let batteryImpact = data["battery_impact"] as? String else {
            return nil
        }
        
        return AnimationData(
            frameCount: frameCount,
            duration: duration,
            batteryImpact: BatteryImpact(rawValue: batteryImpact) ?? .moderate,
            culturalElements: data["cultural_elements"] as? [String] ?? [],
            effects: data["effects"] as? [String] ?? []
        )
    }
    
    private func createPaymentContextFromData(_ data: [String: Any]) -> EnhancedPaymentContext? {
        guard let recommendedAmount = data["recommended_amount"] as? Double,
              let culturalSignificance = data["cultural_significance"] as? String,
              let relationshipType = data["relationship_type"] as? String else {
            return nil
        }
        
        return EnhancedPaymentContext(
            recommendedAmount: recommendedAmount,
            auspiciousAmounts: data["auspicious_amounts"] as? [Double] ?? [],
            culturalSignificance: culturalSignificance,
            relationshipType: relationshipType,
            blessingLevel: data["blessing_level"] as? String ?? "traditional"
        )
    }
    
    // MARK: - Send to iPhone
    
    func sendEnhancedFeedback(type: String, data: [String: Any]) {
        guard WCSession.default.isReachable else { return }
        
        var message: [String: Any] = [
            "type": "watch_feedback",
            "feedback_type": type,
            "timestamp": Date().timeIntervalSince1970,
            "device_info": [
                "model": "apple_watch",
                "battery_level": "optimal" // Could be actual battery level
            ]
        ]
        
        message.merge(data) { _, new in new }
        
        WCSession.default.sendMessage(message, replyHandler: { reply in
            print("Enhanced feedback sent successfully: \(reply)")
        }, errorHandler: { error in
            print("Failed to send enhanced feedback: \(error.localizedDescription)")
        })
    }
}

// MARK: - Data Models (copied for watch side)
struct Rakhi: Identifiable, Codable {
    let id: UUID
    let name: String
    let imageName: String
    let description: String
    let price: Double
    let category: RakhiCategory
    let colors: [String]
    
    init(name: String, imageName: String, description: String, price: Double, category: RakhiCategory, colors: [String]) {
        self.id = UUID()
        self.name = name
        self.imageName = imageName
        self.description = description
        self.price = price
        self.category = category
        self.colors = colors
    }
}

enum RakhiCategory: String, CaseIterable, Codable {
    case traditional = "Traditional"
    case modern = "Modern"
    case elegant = "Elegant"
    case spiritual = "Spiritual"
}

struct RakhiGift: Identifiable, Codable {
    let id: UUID
    let rakhi: Rakhi
    let sender: String
    let recipient: String
    let sentDate: Date
    let status: GiftStatus
    let paymentAmount: Double?
    let message: String?
    
    init(rakhi: Rakhi, sender: String, recipient: String, sentDate: Date, status: GiftStatus, paymentAmount: Double? = nil, message: String? = nil) {
        self.id = UUID()
        self.rakhi = rakhi
        self.sender = sender
        self.recipient = recipient
        self.sentDate = sentDate
        self.status = status
        self.paymentAmount = paymentAmount
        self.message = message
    }
}

enum GiftStatus: String, CaseIterable, Codable {
    case sent = "Sent"
    case received = "Received"
    case paid = "Paid"
    case completed = "Completed"
}

// MARK: - Enhanced Watch Data Models

struct AnimationData: Codable {
    let frameCount: Int
    let duration: Double
    let batteryImpact: BatteryImpact
    let culturalElements: [String]
    let effects: [String]
}

enum BatteryImpact: String, Codable {
    case minimal = "minimal"
    case moderate = "moderate"
    case high = "high"
}

struct EnhancedPaymentContext: Codable {
    let recommendedAmount: Double
    let auspiciousAmounts: [Double]
    let culturalSignificance: String
    let relationshipType: String
    let blessingLevel: String
}

// MARK: - Watch-specific Animation Types (simplified)

struct WatchAnimationFrame {
    let frameNumber: Int
    let timestamp: TimeInterval
    let effects: [WatchFrameEffect]
}

enum WatchFrameEffect {
    case glow(intensity: Float, color: WatchColor, radius: Float)
    case sparkle(density: Float, size: Float)
    case scale(factor: Float)
    case opacity(alpha: Float)
}

enum WatchColor: String, Codable {
    case orange = "orange"
    case red = "red"
    case gold = "gold"
    case green = "green"
    case blue = "blue"
    case white = "white"
}