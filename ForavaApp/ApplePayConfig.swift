import PassKit

enum ApplePayConfig {
    static let merchantIdentifier = "merchant.com.forava.app" // Update this with your actual merchant ID
    static let supportedNetworks: [PKPaymentNetwork] = [.visa, .masterCard, .amex, .discover]
    static let merchantCapabilities: PKMerchantCapability = [.threeDSecure, .credit, .debit]

    static func canUseApplePay() -> Bool {
        PKPaymentAuthorizationController.canMakePayments(usingNetworks: supportedNetworks)
    }
}
