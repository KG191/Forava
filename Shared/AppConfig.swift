import Foundation

struct AppConfig {
    // MARK: - Universal Links & Deep Linking
    static let associatedDomain = "kg191.github.io"
    static let universalPayPath = "/pay"
    
    // MARK: - Apple Pay Configuration
    static let merchantID = "merchant.C6MJDCDAUG.forava"
    static let countryCode = "AU"  // Australia
    static let currencyCode = "AUD"
    
    // MARK: - Default Values
    static let defaultAmount: Decimal = 101  // Auspicious amount
    static let defaultDescription = "Rakhi Blessing Gift"
    
    // MARK: - Cultural Context
    static let culturalOccasion = "raksha_bandhan"
    static let appName = "Forava"
    
    // MARK: - URL Generation
    static func universalPayURL(amount: Decimal, desc: String, rakhiId: String? = nil, sender: String? = nil) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = associatedDomain
        components.path = universalPayPath
        
        var queryItems = [
            URLQueryItem(name: "amount", value: String(describing: amount)),
            URLQueryItem(name: "desc", value: desc),
            URLQueryItem(name: "cultural_significance", value: culturalOccasion),
            URLQueryItem(name: "currency", value: currencyCode)
        ]
        
        if let rakhiId = rakhiId {
            queryItems.append(URLQueryItem(name: "rakhi_id", value: rakhiId))
        }
        
        if let sender = sender {
            queryItems.append(URLQueryItem(name: "sender", value: sender))
        }
        
        components.queryItems = queryItems
        return components.url
    }
    
    // MARK: - Message Templates
    static func createRakhiMessage(amount: Decimal, desc: String, rakhiId: String? = nil, sender: String? = nil) -> String {
        let payURL = universalPayURL(amount: amount, desc: desc, rakhiId: rakhiId, sender: sender)?.absoluteString ?? "https://\(associatedDomain)"
        
        return """
        🎊 I've created a beautiful Rakhi just for you!
        
        ⌚️ To set as Apple Watch face:
        • Tap the image and "Save to Photos"
        • On your Watch: Face Gallery → Photos → Select Rakhi
        
        💝 To send a gift back:
        • Tap this link: \(payURL)
        
        Made with love using \(appName) ❤️
        """
    }
    
    // MARK: - Watch Face Instructions
    static let watchFaceInstructions = [
        "Tap and hold the image in Messages",
        "Select 'Save to Photos'",
        "On Apple Watch: Press Digital Crown",
        "Swipe to Photos watch face",
        "Select your Rakhi image",
        "Press Digital Crown to set"
    ]
    
    // MARK: - Apple Pay Summary Items
    static func createPaymentSummaryItems(amount: Decimal, description: String) -> [String: Any] {
        return [
            "items": [
                ["label": description, "amount": String(describing: amount)],
                ["label": appName, "amount": String(describing: amount)]
            ],
            "total": String(describing: amount)
        ]
    }
}

// MARK: - Cultural Extensions
extension AppConfig {
    static let auspiciousAmounts: [Decimal] = [21, 51, 101, 201, 501, 1001]
    
    static let culturalBlessings = [
        "May this Rakhi bring you happiness and prosperity",
        "With blessings of protection and good fortune",
        "Celebrating our eternal bond of love",
        "May divine grace always be with you"
    ]
    
    static func isAuspiciousAmount(_ amount: Decimal) -> Bool {
        let intValue = Int(truncating: amount as NSDecimalNumber)
        return intValue % 10 == 1 || auspiciousAmounts.contains(amount)
    }
}