import PassKit

enum ApplePayConfig {
    static let merchantIdentifier = "merchant.com.yourcompany.forava" // change me
    static let supportedNetworks: [PKPaymentNetwork] = [.visa, .masterCard, .amex, .discover]
    static let merchantCapabilities: PKMerchantCapability = [.capability3DS, .capabilityCredit, .capabilityDebit]

    static func canUseApplePay() -> Bool {
        PKPaymentAuthorizationController.canMakePayments(usingNetworks: supportedNetworks)
    }
}
