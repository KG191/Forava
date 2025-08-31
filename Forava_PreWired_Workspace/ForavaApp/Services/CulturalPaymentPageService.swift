import Foundation
import SwiftUI

// MARK: - Cultural Payment Page Service for Phase 3 Implementation

@MainActor
class CulturalPaymentPageService: ObservableObject {
    static let shared = CulturalPaymentPageService()

    @Published var isGeneratingPaymentLink = false
    @Published var generatedPaymentURL: URL?
    @Published var culturalMessaging: CulturalPaymentMessaging

    // Phase 3: Base URL configuration (kg191.github.io replacement)
    private let basePaymentURL = "https://kg191.github.io/forava-cultural-gifts"

    private init() {
        self.culturalMessaging = CulturalPaymentMessaging()
    }

    // MARK: - Phase 3.2: Sender Name Integration

    func generateCulturalPaymentURL(
        for culturalGift: CulturalGeneratedArtwork,
        senderName: String,
        recipientName: String,
        selectedOccasion: String,
        customMessage: String? = nil
    ) -> URL {

        var components = URLComponents(string: basePaymentURL)!

        // Phase 3: Remove amount display - no amount parameter included
        components.queryItems = [
            // Phase 3.2: Use actual sender name instead of "Forava Creator"
            URLQueryItem(name: "from", value: senderName),
            URLQueryItem(name: "to", value: recipientName),
            // Phase 3.4: Dynamic cultural context
            URLQueryItem(name: "occasion", value: selectedOccasion),
            URLQueryItem(name: "cultural_context", value: culturalGift.culturalContext),
            URLQueryItem(name: "gift_id", value: culturalGift.id.uuidString),
            URLQueryItem(name: "created_at", value: ISO8601DateFormatter().string(from: culturalGift.generatedAt))
        ]

        // Add custom message if provided
        if let message = customMessage, !message.isEmpty {
            components.queryItems?.append(URLQueryItem(name: "message", value: message))
        }

        // Add cultural metadata for enhanced experience
        components.queryItems?.append(contentsOf: [
            URLQueryItem(name: "cultural_score", value: String(format: "%.2f", culturalGift.culturalScore)),
            URLQueryItem(name: "quality_score", value: String(format: "%.2f", culturalGift.qualityScore))
        ])

        return components.url ?? URL(string: basePaymentURL)!
    }

    // MARK: - Phase 3.3: Update Cultural Messaging

    func generateCulturalMessaging(for occasion: String) -> CulturalPaymentPageContent {
        let occasionList = [
            "Birthdays", "Chinese New Year", "Diwali", "Christmas",
            "Eid", "Vesak", "Rosh Hashanah", "Hanukkah", "Holi",
            "Mid-Autumn Festival", "Easter", "Raksha Bandhan"
        ].joined(separator: ", ")

        return CulturalPaymentPageContent(
            // Phase 3.3: Enhanced cultural greeting message
            greetingMessage: """
            Enjoyed receiving the greeting, pass it forward? Download Forava and enjoy personalised
            generated greetings with the help of AI. Made for special occasions like \(occasionList)
            """,

            // Phase 3.4: Dynamic cultural context
            culturalFooter: "Made with ❤️ for \(occasion)",

            // Remove amount-focused messaging
            downloadPrompt: "Experience AI-powered cultural celebrations",

            // Cultural authenticity message
            authenticityMessage: "Celebrating traditions with respect and AI innovation"
        )
    }

    // MARK: - Cultural Messaging Templates

    func getCulturalGreeting(for occasion: String, senderName: String) -> String {
        switch occasion.lowercased() {
        case "diwali":
            return "✨ \(senderName) has sent you a beautiful Diwali blessing! May this festival of lights bring joy, prosperity, and happiness to your home. 🪔"

        case "chinese new year", "chinese_new_year":
            return "🧧 \(senderName) wishes you a prosperous Chinese New Year! May the Year of abundance bring you good fortune and happiness. 🐉"

        case "christmas":
            return "🎄 \(senderName) has sent you warm Christmas wishes! May this season bring you peace, joy, and cherished moments with loved ones. ⭐"

        case "eid", "eid al-fitr", "eid al-adha":
            return "🌙 \(senderName) sends you blessed Eid greetings! May this holy celebration bring you peace, joy, and spiritual fulfillment. ✨"

        case "vesak", "vesak day":
            return "🪷 \(senderName) shares Vesak Day blessings with you! May the teachings of Buddha bring you inner peace and enlightenment. 🙏"

        case "rosh hashanah":
            return "🍎 \(senderName) wishes you a sweet and blessed Rosh Hashanah! May this new year bring you health, happiness, and prosperity. 🍯"

        case "hanukkah":
            return "🕎 \(senderName) sends you warm Hanukkah wishes! May the Festival of Lights illuminate your path with joy and miracles. ✡️"

        case "birthday":
            return "🎂 \(senderName) has created a special birthday greeting just for you! Wishing you a day filled with happiness and a year blessed with joy. 🎉"

        case "holi":
            return "🌈 \(senderName) celebrates Holi with you! May this festival of colors paint your life with happiness, love, and vibrant memories. 🎨"

        case "mid-autumn festival", "mid_autumn_festival":
            return "🥮 \(senderName) shares Mid-Autumn Festival blessings! May the full moon bring you reunion, harmony, and sweet memories. 🌕"

        case "easter":
            return "🐰 \(senderName) sends you joyful Easter greetings! May this celebration of renewal bring you hope, peace, and new beginnings. 🌸"

        case "raksha bandhan", "rakhi":
            return "🎊 \(senderName) has created a special Rakhi for you! This sacred thread carries love, protection, and the eternal bond of siblinghood. 💝"

        default:
            return "🎁 \(senderName) has sent you a special cultural greeting created with love and AI magic! May this thoughtful gesture bring you joy and happiness. ✨"
        }
    }

    // MARK: - Phase 3: Payment Page URL Generation

    func createSharablePaymentURL(
        culturalGift: CulturalGeneratedArtwork,
        senderName: String,
        recipientName: String,
        selectedOccasion: String,
        includePreview: Bool = true
    ) async -> URL {

        isGeneratingPaymentLink = true
        defer { isGeneratingPaymentLink = false }

        let baseURL = generateCulturalPaymentURL(
            for: culturalGift,
            senderName: senderName,
            recipientName: recipientName,
            selectedOccasion: selectedOccasion
        )

        // If preview is needed, generate preview image URL
        if includePreview {
            return await addPreviewImageToURL(baseURL, culturalGift: culturalGift)
        }

        generatedPaymentURL = baseURL
        return baseURL
    }

    private func addPreviewImageToURL(_ baseURL: URL, culturalGift: CulturalGeneratedArtwork) async -> URL {
        // In production, this would upload the image to a CDN and add the preview URL
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!

        // Add preview image placeholder (would be actual CDN URL in production)
        components.queryItems?.append(URLQueryItem(
            name: "preview_image",
            value: "https://cdn.forava.app/previews/\(culturalGift.id.uuidString).jpg"
        ))

        return components.url ?? baseURL
    }

    // MARK: - Cultural Context Validation

    func validateCulturalContext(
        occasion: String,
        culturalContext: String,
        senderName: String,
        recipientName: String
    ) -> CulturalValidationResult {

        var warnings: [String] = []
        var suggestions: [String] = []
        var isValid = true

        // Validate occasion matches cultural context
        let contextValidation = CulturalContextManager.shared.validateOccasionContext(
            occasion: occasion,
            context: culturalContext
        )

        if !contextValidation.isValid {
            warnings.append("The selected occasion may not align with the cultural context")
            suggestions.append("Consider selecting an occasion that matches the cultural theme")
            isValid = false
        }

        // Validate sender/recipient names are not empty
        if senderName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            warnings.append("Sender name is required for personalized experience")
            suggestions.append("Add the sender's name for authentic cultural greeting")
            isValid = false
        }

        if recipientName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            warnings.append("Recipient name helps create personalized cultural greeting")
            suggestions.append("Add recipient's name for better personalization")
        }

        // Convert warnings to CulturalValidationIssue format
        let issues = warnings.map { warning in
            CulturalValidationIssue(
                severity: .minor,
                description: warning,
                category: .culturalAccuracy,
                suggestedFix: nil
            )
        }
        
        // Convert suggestions to ValidationSuggestion format
        let validationSuggestions = suggestions.map { suggestion in
            ValidationSuggestion(
                type: .enhancement,
                description: suggestion,
                implementationGuidance: "Consider implementing the suggested improvement"
            )
        }
        
        return CulturalValidationResult(
            isValid: isValid,
            accuracy: isValid ? 0.85 : 0.45,
            culturalAuthenticity: isValid ? 0.9 : 0.5,
            appropriateness: isValid ? 0.8 : 0.4,
            issues: issues,
            suggestions: validationSuggestions
        )
    }
}

// MARK: - Supporting Types for Phase 3

struct CulturalPaymentPageContent {
    let greetingMessage: String
    let culturalFooter: String
    let downloadPrompt: String
    let authenticityMessage: String

    var fullPageContent: String {
        return """
        \(greetingMessage)

        \(authenticityMessage)

        \(downloadPrompt)

        \(culturalFooter)
        """
    }
}

struct CulturalPaymentMessaging {
    var enhancedGreetingTemplate: String = """
    Enjoyed receiving the greeting, pass it forward? Download Forava and enjoy personalised
    generated greetings with the help of AI. Made for special occasions like {occasions_list}
    """

    var culturalFooterTemplate: String = "Made with ❤️ for {selected_occasion}"

    var occasionsList: [String] = [
        "Birthdays", "Chinese New Year", "Diwali", "Christmas",
        "Eid", "Vesak", "Rosh Hashanah", "Hanukkah", "Holi",
        "Mid-Autumn Festival", "Easter", "Raksha Bandhan"
    ]

    func generateMessaging(for occasion: String) -> CulturalPaymentPageContent {
        let occasionsText = occasionsList.joined(separator: ", ")

        let greeting = enhancedGreetingTemplate.replacingOccurrences(
            of: "{occasions_list}",
            with: occasionsText
        )

        let footer = culturalFooterTemplate.replacingOccurrences(
            of: "{selected_occasion}",
            with: occasion
        )

        return CulturalPaymentPageContent(
            greetingMessage: greeting,
            culturalFooter: footer,
            downloadPrompt: "Experience AI-powered cultural celebrations",
            authenticityMessage: "Celebrating traditions with respect and AI innovation"
        )
    }
}

// MARK: - Phase 3 Integration Extensions

extension CulturalPaymentPageService {

    // Integration with existing sharing service
    func integrateWithSocialSharing(
        culturalGift: CulturalGeneratedArtwork,
        senderName: String,
        recipientName: String,
        occasion: String
    ) -> CulturalSharingPackage {

        let paymentURL = generateCulturalPaymentURL(
            for: culturalGift,
            senderName: senderName,
            recipientName: recipientName,
            selectedOccasion: occasion
        )

        let culturalGreeting = getCulturalGreeting(
            for: occasion,
            senderName: senderName
        )

        let messaging = generateCulturalMessaging(for: occasion)

        return CulturalSharingPackage(
            paymentURL: paymentURL,
            culturalGreeting: culturalGreeting,
            messaging: messaging,
            occasion: occasion,
            culturalContext: culturalGift.culturalContext
        )
    }
}

struct CulturalSharingPackage {
    let paymentURL: URL
    let culturalGreeting: String
    let messaging: CulturalPaymentPageContent
    let occasion: String
    let culturalContext: String

    var sharableMessage: String {
        return """
        \(culturalGreeting)

        \(messaging.greetingMessage)

        View your cultural gift: \(paymentURL.absoluteString)

        \(messaging.culturalFooter)
        """
    }
}
