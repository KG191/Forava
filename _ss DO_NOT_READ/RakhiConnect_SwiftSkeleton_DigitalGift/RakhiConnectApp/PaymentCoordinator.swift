import Foundation
import PassKit
import SwiftUI

final class PaymentCoordinator: NSObject {
    static let shared = PaymentCoordinator()
    private override init() {}
    private var completion: ((Result<PKPayment, Error>) -> Void)?

    func checkAvailability() {
        print("Apple Pay available:", ApplePayConfig.canUseApplePay())
    }

    func presentApplePay(amountMinor: Int64,
                         currencyCode: String,
                         completion: @escaping (Result<PKPayment, Error>) -> Void) {

        guard ApplePayConfig.canUseApplePay() else {
            completion(.failure(NSError(domain: "ApplePay", code: 0,
                     userInfo: [NSLocalizedDescriptionKey: "Apple Pay not available"])))
            return
        }

        self.completion = completion

        let item = PKPaymentSummaryItem(label: "Rakhi Gift",
                                        amount: NSDecimalNumber(value: Double(amountMinor)/100.0),
                                        type: .final)

        let req = PKPaymentRequest()
        req.merchantIdentifier = ApplePayConfig.merchantIdentifier
        req.countryCode = Locale.current.region?.identifier ?? "AU"
        req.currencyCode = currencyCode
        req.supportedNetworks = ApplePayConfig.supportedNetworks
        req.merchantCapabilities = ApplePayConfig.merchantCapabilities
        req.paymentSummaryItems = [item]

        let controller = PKPaymentAuthorizationController(paymentRequest: req)
        controller.delegate = self
        controller.present { presented in
            if !presented {
                self.completion?(.failure(NSError(domain: "ApplePay", code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Failed to present Apple Pay"])))
            }
        }
    }
}

extension PaymentCoordinator: PKPaymentAuthorizationControllerDelegate {
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss {}
    }

    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController,
                                        didAuthorizePayment payment: PKPayment,
                                        handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        Task {
            do {
                try await APIClient.shared.captureApplePay(payment: payment)
                completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
                self.completion?(.success(payment))
            } catch {
                completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
                self.completion?(.failure(error))
            }
        }
    }
}
