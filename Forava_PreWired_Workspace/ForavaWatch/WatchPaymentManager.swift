import WatchKit
import PassKit
import Foundation

@MainActor
class WatchPaymentManager: NSObject, ObservableObject {
    static let shared = WatchPaymentManager()

    @Published var paymentStatus: PaymentStatus = .idle
    @Published var currentPaymentRequest: WatchPaymentRequest?
    @Published var lastPaymentResult: PaymentResult?

    private let hapticManager = WatchHapticManager.shared
    private let connectivity = WatchSessionManagerWatch.shared

    enum PaymentStatus {
        case idle
        case processing
        case authenticating
        case completed
        case failed
        case cancelled
    }

    struct WatchPaymentRequest {
        let rakhiId: UUID
        let recipientName: String
        let amount: Decimal
        let currency: String
        let culturalContext: CulturalPaymentContext
        let timestamp: Date
    }

    // CulturalPaymentContext moved to PaymentModels.swift to avoid duplication

    struct PaymentResult {
        let success: Bool
        let transactionId: String?
        let amount: Decimal
        let currency: String
        let timestamp: Date
        let errorMessage: String?
        let gratitudeMessage: String?
    }

    private override init() {
        super.init()
        setupPaymentCapabilities()
    }

    // MARK: - Payment Initiation

    func initiatePayment(for rakhi: WatchRakhiDisplay, amount: Decimal, relationship: String) async {
        hapticManager.playPaymentInitiated()

        let culturalContext = generateCulturalContext(
            relationship: relationship,
            amount: amount,
            rakhi: rakhi
        )

        let request = WatchPaymentRequest(
            rakhiId: rakhi.id,
            recipientName: extractSenderName(from: rakhi),
            amount: amount,
            currency: "AUD", // Based on AUD_CURRENCY_AND_APPLE_WATCH_WORKFLOW.md
            culturalContext: culturalContext,
            timestamp: Date()
        )

        currentPaymentRequest = request
        paymentStatus = .processing

        // Send payment request to iPhone for Apple Pay processing
        await requestiPhonePayment(request)
    }

    private func requestiPhonePayment(_ request: WatchPaymentRequest) async {
        let paymentData: [String: Any] = [
            "action": "process_payment",
            "rakhi_id": request.rakhiId.uuidString,
            "amount": NSDecimalNumber(decimal: request.amount).doubleValue,
            "currency": request.currency,
            "recipient_name": request.recipientName,
            "cultural_context": [
                "occasion": request.culturalContext.occasion,
                "relationship": request.culturalContext.relationship,
                "blessing": request.culturalContext.blessing,
                "cultural_note": request.culturalContext.culturalNote
            ],
            "timestamp": request.timestamp.timeIntervalSince1970
        ]

        connectivity.sendMessage(paymentData) { [weak self] result in
            Task { @MainActor in
                switch result {
                case .success:
                    self?.paymentStatus = .authenticating
                    self?.hapticManager.playHaptic(.start)
                case .failure(let error):
                    self?.handlePaymentError(error.localizedDescription)
                }
            }
        }
    }

    // MARK: - Payment Response Handling

    func handlePaymentResponse(_ response: [String: Any]) {
        guard let success = response["success"] as? Bool else { return }

        if success {
            handlePaymentSuccess(response)
        } else {
            let errorMessage = response["error"] as? String ?? "Payment failed"
            handlePaymentError(errorMessage)
        }
    }

    private func handlePaymentSuccess(_ response: [String: Any]) {
        paymentStatus = .completed
        hapticManager.playPaymentCompleted()

        let result = PaymentResult(
            success: true,
            transactionId: response["transaction_id"] as? String,
            amount: currentPaymentRequest?.amount ?? 0,
            currency: currentPaymentRequest?.currency ?? "AUD",
            timestamp: Date(),
            errorMessage: nil,
            gratitudeMessage: generateGratitudeMessage()
        )

        lastPaymentResult = result

        // Show gratitude animation
        showGratitudeExpression(result)

        // Clear current request after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.currentPaymentRequest = nil
            self.paymentStatus = .idle
        }
    }

    private func handlePaymentError(_ errorMessage: String) {
        paymentStatus = .failed
        hapticManager.playHaptic(.failure)

        let result = PaymentResult(
            success: false,
            transactionId: nil,
            amount: currentPaymentRequest?.amount ?? 0,
            currency: currentPaymentRequest?.currency ?? "AUD",
            timestamp: Date(),
            errorMessage: errorMessage,
            gratitudeMessage: nil
        )

        lastPaymentResult = result

        // Clear after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.paymentStatus = .idle
        }
    }

    // MARK: - Cultural Context Generation

    private func generateCulturalContext(relationship: String, amount: Decimal, rakhi: WatchRakhiDisplay) -> CulturalPaymentContext {
        let occasion = "Raksha Bandhan"
        let blessing = getBlessingForRelationship(relationship)
        let suggestedAmounts = getSuggestedAmounts(for: relationship)
        let culturalNote = getCulturalNote(relationship: relationship, amount: amount)

        return CulturalPaymentContext(
            occasion: occasion,
            relationship: relationship,
            blessing: blessing,
            suggestedAmounts: suggestedAmounts,
            culturalNote: culturalNote
        )
    }

    private func getBlessingForRelationship(_ relationship: String) -> String {
        switch relationship.lowercased() {
        case "sister", "sibling":
            return "May you always be protected and blessed 🙏"
        case "cousin":
            return "Wishing you happiness and prosperity ✨"
        case "friend":
            return "May our friendship remain strong forever 💕"
        case "elder":
            return "Seeking your blessings and guidance 🙏"
        default:
            return "May you be blessed with joy and success 🌟"
        }
    }

    private func getSuggestedAmounts(for relationship: String) -> [Decimal] {
        switch relationship.lowercased() {
        case "sister", "sibling":
            return [51, 101, 251, 501] // Auspicious amounts
        case "cousin":
            return [21, 51, 101, 251]
        case "friend":
            return [11, 21, 51, 101]
        case "elder":
            return [101, 251, 501, 1001]
        default:
            return [21, 51, 101, 251]
        }
    }

    private func getCulturalNote(relationship: String, amount: Decimal) -> String {
        let amountDouble = NSDecimalNumber(decimal: amount).doubleValue

        if amountDouble.truncatingRemainder(dividingBy: 10) == 1 {
            return "Auspicious amount ending in 1 - bringing good fortune 🌟"
        } else if [11, 21, 51, 101, 251, 501, 1001].contains(Int(amountDouble)) {
            return "Traditional Rakhi gift amount - culturally significant 🎁"
        } else {
            return "Your heartfelt gift carries love and blessings ❤️"
        }
    }

    private func extractSenderName(from rakhi: WatchRakhiDisplay) -> String {
        // Extract sender name from rakhi title or metadata
        // For now, return a placeholder
        return "Sister"
    }

    // MARK: - Gratitude Expression

    private func generateGratitudeMessage() -> String {
        let messages = [
            "Your love and blessings are received with joy! 🙏",
            "Thank you for this beautiful expression of care! ✨",
            "Your generosity touches the heart! 💕",
            "May this bond of love grow stronger! 🌸",
            "Your blessings are treasured always! 🌟"
        ]

        return messages.randomElement() ?? messages[0]
    }

    private func showGratitudeExpression(_ result: PaymentResult) {
        // This would trigger a beautiful animation
        // For now, we'll use haptic feedback
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.hapticManager.playHaptic(.success)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.hapticManager.playHaptic(.success)
        }
    }

    // MARK: - Payment Capabilities

    private func setupPaymentCapabilities() {
        // Check if device supports payments
        if !PKPaymentAuthorizationController.canMakePayments() {
            print("⚠️ Watch does not support payments - will delegate to iPhone")
        }
    }

    // MARK: - Quick Payment Actions

    func getQuickAmountSuggestions(for relationship: String) -> [QuickAmountOption] {
        let amounts = getSuggestedAmounts(for: relationship)

        return amounts.map { amount in
            QuickAmountOption(
                amount: amount,
                displayText: "$\(NSDecimalNumber(decimal: amount))",
                culturalSignificance: getCulturalSignificance(for: amount),
                isRecommended: isRecommendedAmount(amount, for: relationship)
            )
        }
    }

    private func getCulturalSignificance(for amount: Decimal) -> String {
        let amountInt = NSDecimalNumber(decimal: amount).intValue

        switch amountInt {
        case 101, 501, 1001:
            return "Highly Auspicious"
        case 51, 251:
            return "Traditional"
        case 21:
            return "Blessed"
        case 11:
            return "Sacred"
        default:
            return "Meaningful"
        }
    }

    private func isRecommendedAmount(_ amount: Decimal, for relationship: String) -> Bool {
        let recommendedAmounts: [String: Decimal] = [
            "sister": 101,
            "sibling": 101,
            "cousin": 51,
            "friend": 21,
            "elder": 251
        ]

        return recommendedAmounts[relationship.lowercased()] == amount
    }
}

struct QuickAmountOption: Identifiable {
    let id = UUID()
    let amount: Decimal
    let displayText: String
    let culturalSignificance: String
    let isRecommended: Bool
}
