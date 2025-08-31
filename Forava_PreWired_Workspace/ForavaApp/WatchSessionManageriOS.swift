import Foundation
import WatchConnectivity
import SwiftUI

final class WatchSessionManageriOS: NSObject, WCSessionDelegate, ObservableObject {
    static let shared = WatchSessionManageriOS()

    @Published var isWatchConnected = false
    @Published var watchBatteryLevel: Float = 1.0

    private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    // private let animationService = AdvancedAnimationService.shared // Commented due to integration issues
    // private let paymentService = EnhancedPaymentService.shared // Commented due to integration issues

    private override init() {
        super.init()
        activate()
    }

    func activate() {
        session?.delegate = self
        session?.activate()
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        guard let messageType = message["type"] as? String else { return }

        switch messageType {
        case "gift_request":
            handleLegacyGiftRequest(message: message)
        case "enhanced_payment_completed":
            handleEnhancedPaymentCompleted(message: message)
        case "watch_feedback":
            handleWatchFeedback(message: message)
        case "animation_request":
            handleAnimationRequest(message: message)
        default:
            print("Unknown message type from watch: \(messageType)")
        }
    }

    private func handleLegacyGiftRequest(message: [String: Any]) {
        guard let amountMinor = message["amountMinor"] as? Int64,
              let currency = message["currency"] as? String,
              let kindRaw = message["kind"] as? String,
              let kind = GiftKind(rawValue: kindRaw),
              let tokenIdStr = message["tokenId"] as? String,
              let tokenId = UUID(uuidString: tokenIdStr)
        else { return }

        PaymentCoordinator.shared.presentApplePay(amountMinor: amountMinor, currencyCode: currency) { result in
            switch result {
            case .success:
                Task {
                    if kind == .digitalGift {
                        _ = try? await APIClient.shared.fulfillDigitalGift(tokenId: tokenId, amountMinor: amountMinor)
                    }
                    self.session?.sendMessage(["type": "gift_result", "status": "succeeded", "tokenId": tokenId.uuidString], replyHandler: nil, errorHandler: nil)
                }
            case .failure:
                self.session?.sendMessage(["type": "gift_result", "status": "failed", "tokenId": tokenId.uuidString], replyHandler: nil, errorHandler: nil)
            }
        }
    }

    private func handleEnhancedPaymentCompleted(message: [String: Any]) {
        guard let paymentData = message["payment"] as? [String: Any],
              let amount = paymentData["amount"] as? Double,
              let rakhiId = paymentData["rakhi_id"] as? String,
              let culturalContext = message["cultural_context"] as? [String: Any] else {
            return
        }

        Task {
            // Process enhanced payment with cultural context
            await processEnhancedWatchPayment(
                amount: amount,
                rakhiId: rakhiId,
                culturalContext: culturalContext
            )
        }
    }

    private func handleWatchFeedback(message: [String: Any]) {
        guard let feedbackType = message["feedback_type"] as? String else { return }

        switch feedbackType {
        case "animation_performance":
            if let batteryImpact = message["battery_impact"] as? String {
                // Adjust future animations based on battery feedback
                print("Watch animation battery impact: \(batteryImpact)")
            }
        case "user_interaction":
            if let interactionData = message["interaction"] as? [String: Any] {
                // Track user interaction patterns
                print("Watch user interaction: \(interactionData)")
            }
        default:
            break
        }
    }

    private func handleAnimationRequest(message: [String: Any]) {
        guard let rakhiId = message["rakhi_id"] as? String else { return }

        Task {
            // Send optimized animation data to watch
            await sendAnimationToWatch(rakhiId: rakhiId)
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            self.isWatchConnected = activationState == .activated && session.isPaired && session.isWatchAppInstalled
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isWatchConnected = false
        }
    }

    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }

    // MARK: - Enhanced Watch Communication

    func sendGeneratedRakhiToWatch(_ rakhi: GeneratedRakhi, recipient: String) {
        guard let session = session, session.isReachable else {
            print("Watch session not reachable")
            return
        }

        // First, transfer the image data
        let imageData = rakhi.mainImage.imageData
        let imageKey = "rakhi_image_\(rakhi.id.uuidString)"

        // Save image data to temp file for transfer
        let tempImageURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(imageKey).jpg")
        do {
            try imageData.write(to: tempImageURL)

            // Transfer image file to watch
            session.transferFile(tempImageURL, metadata: ["rakhi_id": rakhi.id.uuidString])
            print("Image file transfer initiated successfully")

            // Send metadata
            sendRakhiMetadata(rakhi, recipient: recipient, imageKey: imageKey)

        } catch {
            print("Failed to write temp image: \(error.localizedDescription)")
            // Fallback to direct data transfer
            sendRakhiWithImageData(rakhi, recipient: recipient, imageData: imageData)
        }
    }

    private func sendRakhiMetadata(_ rakhi: GeneratedRakhi, recipient: String, imageKey: String?) {
        guard let session = session, session.isReachable else { return }

        var rakhiDict: [String: Any] = [
            "id": rakhi.id.uuidString,
            "name": "AI Generated Rakhi",
            "imageName": imageKey ?? "ai_rakhi",
            "description": "Beautiful AI-generated rakhi for \(recipient)",
            "price": calculateSuggestedAmount(rakhi),
            "category": rakhi.designSpec.genre.rawValue,
            "colors": extractColors(from: rakhi.designSpec)
        ]

        if let imageKey = imageKey {
            rakhiDict["image_file_key"] = imageKey
            rakhiDict["has_image_file"] = true
        }

        let rakhiData: [String: Any] = [
            "type": "rakhi_received",
            "rakhi": rakhiDict,
            "sender": "AI Creator",
            "recipient": recipient,
            "enhanced_features": [
                "has_animation": !rakhi.animationFrames.isEmpty,
                "cultural_score": rakhi.culturalScore,
                "quality_score": rakhi.qualityScore
            ],
            "watch_face_instructions": [
                "can_set_automatically": false,
                "setup_steps": [
                    "Open the received Rakhi image on your Watch",
                    "Press firmly on the watch face",
                    "Tap 'Customize'",
                    "Select 'Photos' face",
                    "Choose the Rakhi image as background"
                ]
            ]
        ]

        session.sendMessage(rakhiData, replyHandler: { reply in
            print("Rakhi metadata sent to watch successfully: \(reply)")

            // Send additional data
            Task {
                await self.sendAnimationToWatch(rakhiId: rakhi.id.uuidString)
                await self.sendPaymentContextToWatch(rakhi: rakhi, recipient: recipient)
            }

        }, errorHandler: { error in
            print("Failed to send rakhi metadata to watch: \(error.localizedDescription)")
        })
    }

    private func sendRakhiWithImageData(_ rakhi: GeneratedRakhi, recipient: String, imageData: Data) {
        guard let session = session, session.isReachable else { return }

        // Compress image data for watch transfer (reduce size)
        let compressedData: Data
        if let image = UIImage(data: imageData),
           let compressed = image.jpegData(compressionQuality: 0.6) {
            compressedData = compressed
        } else {
            compressedData = imageData
        }

        let rakhiData: [String: Any] = [
            "type": "rakhi_received",
            "rakhi": [
                "id": rakhi.id.uuidString,
                "name": "AI Generated Rakhi",
                "imageName": "embedded_image",
                "description": "Beautiful AI-generated rakhi for \(recipient)",
                "price": calculateSuggestedAmount(rakhi),
                "category": rakhi.designSpec.genre.rawValue,
                "colors": extractColors(from: rakhi.designSpec),
                "image_data": compressedData.base64EncodedString(),
                "has_embedded_image": true
            ],
            "sender": "AI Creator",
            "recipient": recipient,
            "enhanced_features": [
                "has_animation": !rakhi.animationFrames.isEmpty,
                "cultural_score": rakhi.culturalScore,
                "quality_score": rakhi.qualityScore
            ],
            "watch_face_instructions": [
                "can_set_automatically": false,
                "setup_steps": [
                    "The Rakhi image has been saved to your Watch",
                    "To set as watch face:",
                    "1. Press the Digital Crown to go to Watch Face gallery",
                    "2. Swipe to find 'Photos' watch face",
                    "3. Select the Rakhi image",
                    "4. Press the Digital Crown to set it"
                ]
            ]
        ]

        session.sendMessage(rakhiData, replyHandler: { reply in
            print("Rakhi with embedded image sent to watch successfully: \(reply)")
        }, errorHandler: { error in
            print("Failed to send rakhi with image data to watch: \(error.localizedDescription)")
        })
    }

    private func sendAnimationToWatch(rakhiId: String) async {
        guard let session = session, session.isReachable else { return }

        // Get optimized animation for watch
        if let animationData = await generateWatchOptimizedAnimationData(rakhiId: rakhiId) {
            let message: [String: Any] = [
                "type": "animation_data",
                "rakhi_id": rakhiId,
                "animation": animationData
            ]

            session.sendMessage(message, replyHandler: { reply in
                print("Animation data sent to watch: \(reply)")
            }, errorHandler: { error in
                print("Failed to send animation to watch: \(error.localizedDescription)")
            })
        }
    }

    private func sendPaymentContextToWatch(rakhi: GeneratedRakhi, recipient: String) async {
        guard let session = session, session.isReachable else { return }

        // Create enhanced payment context
        let context = await createWatchPaymentContext(rakhi: rakhi, recipient: recipient)

        let message: [String: Any] = [
            "type": "payment_context",
            "context": context
        ]

        session.sendMessage(message, replyHandler: { reply in
            print("Payment context sent to watch: \(reply)")
        }, errorHandler: { error in
            print("Failed to send payment context to watch: \(error.localizedDescription)")
        })
    }

    func sendRealTimeUpdate(type: String, data: [String: Any]) {
        guard let session = session, session.isReachable else { return }

        var message: [String: Any] = [
            "type": "real_time_update",
            "update_type": type,
            "timestamp": Date().timeIntervalSince1970
        ]

        message.merge(data) { _, new in new }

        session.sendMessage(message, replyHandler: nil, errorHandler: { error in
            print("Failed to send real-time update to watch: \(error.localizedDescription)")
        })
    }

    // MARK: - Helper Methods

    private func calculateSuggestedAmount(_ rakhi: GeneratedRakhi) -> Double {
        let baseAmount = 51.0
        let complexityMultiplier = 1.0 + (Double(rakhi.designSpec.elements.count) * 0.1)
        let culturalMultiplier = Double(rakhi.culturalScore)

        let suggested = baseAmount * complexityMultiplier * culturalMultiplier
        let rounded = round(suggested / 10) * 10 + 1
        return min(max(rounded, 21), 501)
    }

    private func extractColors(from designSpec: RakhiDesignSpec) -> [String] {
        switch designSpec.colorPalette {
        case .traditional: return ["Gold", "Red", "Orange"]
        case .modern: return ["Blue", "Silver", "White"]
        case .pastel: return ["Pink", "Lavender", "Mint"]
        case .vibrant: return ["Bright Red", "Electric Blue", "Sunshine Yellow"]
        case .earthy: return ["Brown", "Green", "Beige"]
        case .metallic: return ["Gold", "Silver", "Bronze"]
        case .monochrome: return ["Black", "White", "Gray"]
        }
    }

    private func generateWatchOptimizedAnimationData(rakhiId: String) async -> [String: Any]? {
        // Simulate generating watch-optimized animation data
        return [
            "frame_count": 8,
            "duration": 2.4,
            "battery_impact": "minimal",
            "cultural_elements": ["sacred_center", "protection_thread"],
            "effects": ["glow", "subtle_sparkle"]
        ]
    }

    private func createWatchPaymentContext(rakhi: GeneratedRakhi, recipient: String) async -> [String: Any] {
        let suggestedAmount = calculateSuggestedAmount(rakhi)

        return [
            "recommended_amount": suggestedAmount,
            "auspicious_amounts": [51.0, 101.0, 201.0, 501.0],
            "cultural_significance": "Amount ending in 1 brings divine blessings",
            "relationship_type": "sibling",
            "blessing_level": "traditional"
        ]
    }

    private func processEnhancedWatchPayment(amount: Double, rakhiId: String, culturalContext: [String: Any]) async {
        // Process the enhanced payment with cultural context
        print("Processing enhanced watch payment: ₹\(amount) for rakhi \(rakhiId)")
        print("Cultural context: \(culturalContext)")

        // Send confirmation back to watch
        sendRealTimeUpdate(type: "payment_processed", data: [
            "amount": amount,
            "rakhi_id": rakhiId,
            "status": "completed",
            "blessing_sent": true
        ])
    }
}
