import Foundation
import PassKit
import WatchKit

final class ApplePayManager: NSObject, ObservableObject {
    @Published var isProcessing = false
    @Published var lastPaymentResult: PaymentResult?

    private var controller: PKPaymentAuthorizationController?

    enum PaymentResult {
        case success(amount: Decimal, description: String)
        case failure(error: String)
        case cancelled
    }

    func presentApplePay(
        amount: Decimal = AppConfig.defaultAmount,
        description: String = AppConfig.defaultDescription,
        merchantID: String = AppConfig.merchantID
    ) {
        guard PKPaymentAuthorizationController.canMakePayments() else {
            print("[APPLE PAY] Apple Pay not available")
            lastPaymentResult = .failure(error: "Apple Pay not available")
            return
        }

        guard !isProcessing else {
            print("[APPLE PAY] Payment already in progress")
            return
        }

        print("[APPLE PAY] Presenting Apple Pay for amount: \(amount)")

        let request = PKPaymentRequest()
        request.merchantIdentifier = merchantID
        request.merchantCapabilities = [.capability3DS]
        request.countryCode = AppConfig.countryCode
        request.currencyCode = AppConfig.currencyCode
        request.supportedNetworks = [.visa, .masterCard, .amex, .discover]

        let amountNS = NSDecimalNumber(decimal: amount)
        request.paymentSummaryItems = [
            PKPaymentSummaryItem(label: description, amount: amountNS),
            PKPaymentSummaryItem(label: AppConfig.appName, amount: amountNS)
        ]

        let controller = PKPaymentAuthorizationController(paymentRequest: request)
        controller.delegate = self
        self.controller = controller

        isProcessing = true
        controller.present { presented in
            if !presented {
                DispatchQueue.main.async {
                    self.isProcessing = false
                    self.lastPaymentResult = .failure(error: "Could not present Apple Pay")
                }
            }
        }
    }
}

// MARK: - PKPaymentAuthorizationControllerDelegate
extension ApplePayManager: PKPaymentAuthorizationControllerDelegate {
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        print("[APPLE PAY] Payment authorization finished")
        controller.dismiss {
            DispatchQueue.main.async {
                self.isProcessing = false
            }
        }

        // Provide haptic feedback
        WKInterfaceDevice.current().play(.success)
    }

    func paymentAuthorizationController(
        _ controller: PKPaymentAuthorizationController,
        didAuthorizePayment payment: PKPayment,
        handler completion: @escaping (PKPaymentAuthorizationResult) -> Void
    ) {
        print("[APPLE PAY] Payment authorized")

        // In a real app, send payment.token.paymentData to your server
        // For now, simulate successful processing

        let amount = payment.token.paymentMethod.displayName ?? "Unknown"

        DispatchQueue.main.async {
            self.lastPaymentResult = .success(
                amount: AppConfig.defaultAmount,
                description: "Gift sent successfully"
            )
        }

        // Return success to Apple Pay
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }
}

// MARK: - Cultural Integration
extension ApplePayManager {
    func presentCulturalGiftPay(rakhiId: String, sender: String, amount: Decimal) {
        let culturalDescription = "🎊 Rakhi Gift for \(sender)"
        presentApplePay(
            amount: amount,
            description: culturalDescription,
            merchantID: AppConfig.merchantID
        )
    }

    func presentAuspiciousAmountPay(amount: Decimal) {
        let blessing = AppConfig.culturalBlessings.randomElement() ?? AppConfig.defaultDescription
        presentApplePay(
            amount: amount,
            description: blessing,
            merchantID: AppConfig.merchantID
        )
    }
}
