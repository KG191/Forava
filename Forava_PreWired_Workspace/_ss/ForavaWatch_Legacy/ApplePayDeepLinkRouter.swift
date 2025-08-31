import Foundation

enum ApplePayDeepLinkRouter {
    static func handle(url: URL, manager: ApplePayManager) {
        print("[DEEP LINK] Watch received URL: \(url)")

        guard url.scheme == "https",
              url.host == AppConfig.associatedDomain,
              url.path == AppConfig.universalPayPath else {
            print("[DEEP LINK] Invalid URL format for Watch: \(url)")
            return
        }

        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        guard let queryItems = components?.queryItems else {
            print("[DEEP LINK] No query items found in Watch URL")
            return
        }

        var amount: Decimal = AppConfig.defaultAmount
        var description: String = AppConfig.defaultDescription
        var sender: String?
        var rakhiId: String?

        for item in queryItems {
            switch item.name {
            case "amount":
                if let value = item.value, let parsedAmount = Decimal(string: value) {
                    amount = parsedAmount
                    print("[DEEP LINK] Parsed amount: \(amount)")
                }
            case "desc":
                description = item.value ?? AppConfig.defaultDescription
            case "sender":
                sender = item.value
            case "rakhi_id":
                rakhiId = item.value
            case "cultural_significance":
                // Add cultural context to description
                if let cultural = item.value, cultural == AppConfig.culturalOccasion {
                    if !description.contains("🎊") {
                        description = "🎊 \(description)"
                    }
                }
            default:
                break
            }
        }

        // Enhance description with cultural context
        if let sender = sender {
            description = "Rakhi gift from \(sender)"
        }

        print("[DEEP LINK] Presenting Apple Pay - Amount: \(amount), Description: \(description)")

        // Present Apple Pay immediately
        DispatchQueue.main.async {
            if let rakhiId = rakhiId, let sender = sender {
                manager.presentCulturalGiftPay(rakhiId: rakhiId, sender: sender, amount: amount)
            } else if AppConfig.isAuspiciousAmount(amount) {
                manager.presentAuspiciousAmountPay(amount: amount)
            } else {
                manager.presentApplePay(amount: amount, description: description)
            }
        }
    }
}

// MARK: - URL Validation
extension ApplePayDeepLinkRouter {
    static func isValidForavaURL(_ url: URL) -> Bool {
        return url.scheme == "https" &&
               url.host == AppConfig.associatedDomain &&
               url.path == AppConfig.universalPayPath
    }

    static func extractPaymentInfo(from url: URL) -> PaymentInfo? {
        guard isValidForavaURL(url),
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            return nil
        }

        var amount: Decimal = AppConfig.defaultAmount
        var description: String = AppConfig.defaultDescription
        var sender: String?

        for item in queryItems {
            switch item.name {
            case "amount":
                if let value = item.value, let parsedAmount = Decimal(string: value) {
                    amount = parsedAmount
                }
            case "desc":
                description = item.value ?? AppConfig.defaultDescription
            case "sender":
                sender = item.value
            default:
                break
            }
        }

        return PaymentInfo(amount: amount, description: description, sender: sender)
    }
}

struct PaymentInfo {
    let amount: Decimal
    let description: String
    let sender: String?

    var isAuspicious: Bool {
        return AppConfig.isAuspiciousAmount(amount)
    }

    var culturalDescription: String {
        if let sender = sender {
            return "🎊 Rakhi blessing from \(sender)"
        }
        return isAuspicious ? "🪙 Auspicious gift of \(AppConfig.currencyCode) \(amount)" : description
    }
}
