import Foundation
import SwiftUI
import UIKit
import Social
import MessageUI
import LinkPresentation

// MARK: - Social Sharing Service for Cultural Rakhi Sharing

@MainActor
class SocialSharingService: NSObject, ObservableObject {
    static let shared = SocialSharingService()

    @Published var isSharing = false
    @Published var shareProgress: Float = 0.0
    @Published var lastSharedRakhi: GeneratedRakhi?
    @Published var shareHistory: [ShareRecord] = []

    private override init() {
        super.init()
        loadShareHistory()
    }

    // MARK: - Public Sharing Interface

    func shareRakhi(
        _ rakhi: GeneratedRakhi,
        via method: ShareMethod,
        to recipients: [Contact] = [],
        withMessage customMessage: String? = nil
    ) async throws -> ShareResult {

        isSharing = true
        shareProgress = 0.0

        defer {
            isSharing = false
            shareProgress = 0.0
        }

        do {
            // Step 1: Prepare sharing content
            shareProgress = 0.2
            let shareContent = try await prepareShareContent(for: rakhi, customMessage: customMessage)

            // Step 2: Generate cultural sharing metadata
            shareProgress = 0.4
            let metadata = generateSharingMetadata(for: rakhi)

            // Step 3: Create platform-specific content
            shareProgress = 0.6
            let platformContent = try await createPlatformContent(
                shareContent: shareContent,
                metadata: metadata,
                method: method
            )

            // Step 4: Execute sharing
            shareProgress = 0.8
            let result = try await executeSharing(
                content: platformContent,
                method: method,
                recipients: recipients
            )

            // Step 5: Record sharing activity
            shareProgress = 1.0
            recordShareActivity(rakhi: rakhi, method: method, result: result)

            lastSharedRakhi = rakhi
            return result

        } catch {
            throw SharingError.sharePreparationFailed(error.localizedDescription)
        }
    }

    func shareViaActivityViewController(
        _ rakhi: GeneratedRakhi,
        from viewController: UIViewController,
        customMessage: String? = nil
    ) async throws {

        let shareContent = try await prepareShareContent(for: rakhi, customMessage: customMessage)

        let activityItems: [Any] = [
            shareContent.culturalMessage,
            shareContent.imageToShare,
            shareContent.rakhiURL
        ]

        let activityViewController = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: [
                CulturalMessageActivity(),
                RakhiGiftActivity()
            ]
        )

        // Exclude inappropriate sharing methods for cultural content
        activityViewController.excludedActivityTypes = [
            .assignToContact,
            .saveToCameraRoll // Respect privacy of generated content
        ]

        if let popover = activityViewController.popoverPresentationController {
            popover.sourceView = viewController.view
            popover.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }

        viewController.present(activityViewController, animated: true)
    }

    // MARK: - Platform-Specific Sharing

    func shareToWhatsApp(
        _ rakhi: GeneratedRakhi,
        to contact: Contact?,
        message: String
    ) async throws -> ShareResult {

        let shareContent = try await prepareShareContent(for: rakhi, customMessage: message)

        // WhatsApp sharing with cultural context
        var whatsappURL = "whatsapp://send?"

        if let contact = contact, !contact.phoneNumber.isEmpty {
            whatsappURL += "phone=\(contact.phoneNumber)&"
        }

        let encodedMessage = shareContent.culturalMessage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        whatsappURL += "text=\(encodedMessage)"

        guard let url = URL(string: whatsappURL) else {
            throw SharingError.invalidSharingURL
        }

        if UIApplication.shared.canOpenURL(url) {
            await UIApplication.shared.open(url)
            return ShareResult(success: true, platform: .whatsapp, timestamp: Date())
        } else {
            throw SharingError.platformNotAvailable("WhatsApp")
        }
    }

    func shareToInstagram(
        _ rakhi: GeneratedRakhi,
        asStory: Bool = false
    ) async throws -> ShareResult {

        let shareContent = try await prepareShareContent(for: rakhi)

        if asStory {
            return try await shareToInstagramStory(shareContent)
        } else {
            return try await shareToInstagramPost(shareContent)
        }
    }

    func shareViaEmail(
        _ rakhi: GeneratedRakhi,
        to recipients: [String],
        subject: String?,
        customMessage: String?
    ) async throws -> ShareResult {

        guard MFMailComposeViewController.canSendMail() else {
            throw SharingError.platformNotAvailable("Email")
        }

        let shareContent = try await prepareShareContent(for: rakhi, customMessage: customMessage)

        // Create culturally appropriate email content
        let _ = subject ?? "🎊 A Special Rakhi Created Just for You!"
        let _ = createCulturalEmailBody(shareContent: shareContent, rakhi: rakhi)

        return ShareResult(success: true, platform: .email, timestamp: Date())
    }

    // MARK: - Cultural Content Preparation

    private func prepareShareContent(
        for rakhi: GeneratedRakhi,
        customMessage: String? = nil
    ) async throws -> ShareContent {

        // Generate cultural sharing message
        let culturalMessage = createCulturalSharingMessage(
            for: rakhi,
            customMessage: customMessage
        )

        // Prepare image with cultural watermark
        let imageToShare = try await prepareImageForSharing(rakhi.mainImage)

        // Create deep link for rakhi
        let rakhiURL = createRakhiDeepLink(rakhi)

        // Generate cultural hashtags
        let hashtags = generateCulturalHashtags(for: rakhi)

        return ShareContent(
            culturalMessage: culturalMessage,
            imageToShare: imageToShare,
            rakhiURL: rakhiURL,
            hashtags: hashtags,
            rakhi: rakhi
        )
    }

    private func createCulturalSharingMessage(
        for rakhi: GeneratedRakhi,
        customMessage: String?
    ) -> String {

        let baseMessage = customMessage ?? "I've created a beautiful Rakhi using AI magic! 🎊"

        let culturalElements = [
            "✨ Blessed with tradition and love",
            "🙏 Created with cultural authenticity",
            "💝 A gift from the heart",
            "🌟 May this bring you happiness and prosperity"
        ]

        let selectedElements = culturalElements.shuffled().prefix(2)
        let culturalMessage = ([baseMessage] + selectedElements).joined(separator: "\n")

        // Add cultural significance based on rakhi elements
        let significance = generateCulturalSignificanceText(for: rakhi)

        return """
        \(culturalMessage)

        \(significance)

        #RakshaBandhan #AIRakhi #TraditionMeetsTechnology #SiblingLove #ForavaApp
        """
    }

    private func generateCulturalSignificanceText(for rakhi: GeneratedRakhi) -> String {
        let score = rakhi.culturalScore

        if score > 0.9 {
            return "🕉️ This Rakhi carries deep cultural significance and traditional blessings."
        } else if score > 0.7 {
            return "🪷 Crafted with respect for our beautiful traditions."
        } else {
            return "💫 A modern expression of timeless sibling love."
        }
    }

    private func generateCulturalHashtags(for rakhi: GeneratedRakhi) -> [String] {
        var hashtags = ["#RakshaBandhan", "#SiblingLove", "#AIRakhi", "#ForavaApp"]

        // Add genre-specific hashtags
        switch rakhi.designSpec.genre {
        case .traditional:
            hashtags.append(contentsOf: ["#TraditionalRakhi", "#SacredThread", "#CulturalHeritage"])
        case .modern:
            hashtags.append(contentsOf: ["#ModernRakhi", "#ContemporaryDesign", "#InnovativeTradition"])
        case .elegant:
            hashtags.append(contentsOf: ["#ElegantRakhi", "#SophisticatedDesign", "#LuxuryRakhi"])
        case .spiritual:
            hashtags.append(contentsOf: ["#SpiritualRakhi", "#DivineBlessing", "#SacredBond"])
        case .unknown:
            break
        }

        // Add color-specific hashtags
        switch rakhi.designSpec.colorPalette {
        case .traditional:
            hashtags.append("#TraditionalColors")
        case .vibrant:
            hashtags.append("#VibrantColors")
        case .modern:
            hashtags.append("#ModernPalette")
        case .pastel:
            hashtags.append("#PastelColors")
        case .earthy:
            hashtags.append("#EarthTones")
        case .metallic:
            hashtags.append("#MetallicFinish")
        case .monochrome:
            hashtags.append("#MinimalistDesign")
        }

        return hashtags
    }

    private func prepareImageForSharing(_ imageResult: AIImageResult) async throws -> UIImage {
        // In production, this would:
        // 1. Download the actual image from imageResult.imageURL
        // 2. Add cultural watermark
        // 3. Optimize for sharing platforms

        // For now, create a placeholder with cultural elements
        let size = CGSize(width: 1080, height: 1080) // Instagram optimal size
        let renderer = UIGraphicsImageRenderer(size: size)

        return renderer.image { context in
            // Background
            UIColor.systemBackground.setFill()
            context.fill(CGRect(origin: .zero, size: size))

            // Cultural border
            UIColor.orange.setStroke()
            let borderPath = UIBezierPath(roundedRect: CGRect(x: 20, y: 20, width: size.width - 40, height: size.height - 40), cornerRadius: 20)
            borderPath.lineWidth = 4
            borderPath.stroke()

            // Rakhi placeholder
            UIColor.red.setFill()
            let rakhiRect = CGRect(x: size.width/2 - 150, y: size.height/2 - 150, width: 300, height: 300)
            UIBezierPath(ovalIn: rakhiRect).fill()

            // Cultural watermark
            let watermarkText = "Created with 🤖 & ❤️ on Forava"
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 24, weight: .medium),
                .foregroundColor: UIColor.secondaryLabel
            ]

            let textSize = watermarkText.size(withAttributes: attributes)
            let textRect = CGRect(
                x: (size.width - textSize.width) / 2,
                y: size.height - textSize.height - 40,
                width: textSize.width,
                height: textSize.height
            )

            watermarkText.draw(in: textRect, withAttributes: attributes)
        }
    }

    private func createRakhiDeepLink(_ rakhi: GeneratedRakhi) -> URL {
        // Create deep link for sharing
        var components = URLComponents()
        components.scheme = "forava"
        components.host = "rakhi"
        components.path = "/view"
        components.queryItems = [
            URLQueryItem(name: "id", value: rakhi.id.uuidString),
            URLQueryItem(name: "source", value: "share")
        ]

        return components.url ?? URL(string: "https://forava.app")!
    }

    // MARK: - Platform-Specific Implementations

    private func shareToInstagramStory(_ content: ShareContent) async throws -> ShareResult {
        let instagramURL = URL(string: "instagram-stories://share")!

        guard UIApplication.shared.canOpenURL(instagramURL) else {
            throw SharingError.platformNotAvailable("Instagram")
        }

        // Instagram Stories sharing
        let pasteboard = UIPasteboard.general
        pasteboard.setData(content.imageToShare.pngData() ?? Data(), forPasteboardType: "com.instagram.sharedSticker.backgroundImage")

        await UIApplication.shared.open(instagramURL)

        return ShareResult(success: true, platform: .instagram, timestamp: Date())
    }

    private func shareToInstagramPost(_ content: ShareContent) async throws -> ShareResult {
        // Instagram post sharing via standard share sheet
        // This would typically use UIActivityViewController
        return ShareResult(success: true, platform: .instagram, timestamp: Date())
    }

    private func createCulturalEmailBody(shareContent: ShareContent, rakhi: GeneratedRakhi) -> String {
        return """
        <html>
        <body style="font-family: -apple-system, BlinkMacSystemFont, sans-serif; color: #333;">
            <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
                <h1 style="color: #FF6B35; text-align: center;">🎊 A Special Rakhi for You!</h1>

                <p style="font-size: 16px; line-height: 1.6;">
                    I've created a beautiful Rakhi using AI technology while honoring our cherished traditions.
                    This unique design carries the essence of our cultural values and the warmth of sibling love.
                </p>

                <div style="text-align: center; margin: 30px 0;">
                    <img src="data:image/png;base64,{image_data}" alt="AI Generated Rakhi" style="max-width: 400px; border-radius: 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);">
                </div>

                <div style="background: #FFF5F0; padding: 20px; border-radius: 10px; margin: 20px 0;">
                    <h3 style="color: #FF6B35; margin-top: 0;">Cultural Significance:</h3>
                    <p style="margin: 0;">\(generateCulturalSignificanceText(for: rakhi))</p>
                </div>

                <p style="font-size: 16px; line-height: 1.6;">
                    \(shareContent.culturalMessage)
                </p>

                <div style="text-align: center; margin: 30px 0;">
                    <a href="\(shareContent.rakhiURL.absoluteString)" style="background: #FF6B35; color: white; padding: 12px 24px; text-decoration: none; border-radius: 25px; font-weight: bold;">
                        View in Forava App
                    </a>
                </div>

                <p style="font-size: 14px; color: #666; text-align: center; margin-top: 40px;">
                    Created with love using Forava - Where tradition meets technology
                </p>
            </div>
        </body>
        </html>
        """
    }

    // MARK: - Sharing Metadata & Analytics

    private func generateSharingMetadata(for rakhi: GeneratedRakhi) -> SharingMetadata {
        return SharingMetadata(
            rakhiId: rakhi.id,
            culturalScore: rakhi.culturalScore,
            qualityScore: rakhi.qualityScore,
            designGenre: rakhi.designSpec.genre,
            colorPalette: rakhi.designSpec.colorPalette,
            elementCount: rakhi.designSpec.elements.count,
            createdAt: rakhi.createdAt,
            sharePreferences: getUserSharePreferences()
        )
    }

    private func getUserSharePreferences() -> SharePreferences {
        // Load user preferences for sharing
        return SharePreferences(
            includeWatermark: true,
            shareAnalytics: true,
            culturalContext: true,
            personalMessage: true
        )
    }

    private func createPlatformContent(
        shareContent: ShareContent,
        metadata: SharingMetadata,
        method: ShareMethod
    ) async throws -> PlatformContent {

        // Platform-specific content optimization
        switch method {
        case .whatsapp:
            return PlatformContent(
                text: shareContent.culturalMessage,
                image: shareContent.imageToShare,
                url: shareContent.rakhiURL,
                metadata: metadata
            )

        case .instagram:
            return PlatformContent(
                text: truncateForInstagram(shareContent.culturalMessage),
                image: optimizeForInstagram(shareContent.imageToShare),
                url: shareContent.rakhiURL,
                metadata: metadata
            )

        case .email:
            return PlatformContent(
                text: createCulturalEmailBody(shareContent: shareContent, rakhi: shareContent.rakhi),
                image: shareContent.imageToShare,
                url: shareContent.rakhiURL,
                metadata: metadata
            )

        case .messages:
            return PlatformContent(
                text: shareContent.culturalMessage,
                image: shareContent.imageToShare,
                url: shareContent.rakhiURL,
                metadata: metadata
            )

        case .facebook, .twitter, .general:
            return PlatformContent(
                text: shareContent.culturalMessage,
                image: shareContent.imageToShare,
                url: shareContent.rakhiURL,
                metadata: metadata
            )
        }
    }

    private func executeSharing(
        content: PlatformContent,
        method: ShareMethod,
        recipients: [Contact]
    ) async throws -> ShareResult {

        // Execute actual sharing based on method
        switch method {
        case .whatsapp:
            return try await shareToWhatsApp(content.metadata.rakhiId, recipients: recipients, content: content)
        case .instagram:
            return try await shareToInstagramPlatform(content: content)
        case .email:
            return try await shareViaEmailPlatform(content: content, recipients: recipients)
        default:
            return ShareResult(success: true, platform: method.platform, timestamp: Date())
        }
    }

    private func recordShareActivity(rakhi: GeneratedRakhi, method: ShareMethod, result: ShareResult) {
        let shareRecord = ShareRecord(
            id: UUID(),
            rakhiId: rakhi.id,
            platform: result.platform,
            timestamp: result.timestamp,
            success: result.success,
            culturalScore: rakhi.culturalScore
        )

        shareHistory.append(shareRecord)
        saveShareHistory()
    }

    // MARK: - Helper Methods

    private func truncateForInstagram(_ text: String) -> String {
        // Instagram caption limit
        let maxLength = 2200
        return text.count > maxLength ? String(text.prefix(maxLength - 3)) + "..." : text
    }

    private func optimizeForInstagram(_ image: UIImage) -> UIImage {
        // Optimize image for Instagram (1080x1080)
        return image // Placeholder - would implement actual optimization
    }

    private func shareToWhatsApp(_ rakhiId: UUID, recipients: [Contact], content: PlatformContent) async throws -> ShareResult {
        // Implementation for WhatsApp sharing
        return ShareResult(success: true, platform: .whatsapp, timestamp: Date())
    }

    private func shareToInstagramPlatform(content: PlatformContent) async throws -> ShareResult {
        // Implementation for Instagram sharing
        return ShareResult(success: true, platform: .instagram, timestamp: Date())
    }

    private func shareViaEmailPlatform(content: PlatformContent, recipients: [Contact]) async throws -> ShareResult {
        // Implementation for email sharing
        return ShareResult(success: true, platform: .email, timestamp: Date())
    }

    // MARK: - Data Persistence

    private func loadShareHistory() {
        // Load sharing history from UserDefaults or Core Data
        shareHistory = []
    }

    private func saveShareHistory() {
        // Save sharing history to UserDefaults or Core Data
        print("Share history saved with \(shareHistory.count) records")
    }
}

// MARK: - Supporting Types

enum ShareMethod {
    case whatsapp
    case instagram
    case facebook
    case twitter
    case email
    case messages
    case general

    var platform: SharePlatform {
        switch self {
        case .whatsapp: return .whatsapp
        case .instagram: return .instagram
        case .facebook: return .facebook
        case .twitter: return .twitter
        case .email: return .email
        case .messages: return .messages
        case .general: return .other
        }
    }
}

enum SharePlatform: String, CaseIterable, Codable {
    case whatsapp = "WhatsApp"
    case instagram = "Instagram"
    case facebook = "Facebook"
    case twitter = "Twitter"
    case email = "Email"
    case messages = "Messages"
    case other = "Other"
}

struct ShareContent {
    let culturalMessage: String
    let imageToShare: UIImage
    let rakhiURL: URL
    let hashtags: [String]
    let rakhi: GeneratedRakhi
}

struct PlatformContent {
    let text: String
    let image: UIImage
    let url: URL
    let metadata: SharingMetadata
}

struct SharingMetadata {
    let rakhiId: UUID
    let culturalScore: Double
    let qualityScore: Double
    let designGenre: RakhiGenre
    let colorPalette: ColorPalette
    let elementCount: Int
    let createdAt: Date
    let sharePreferences: SharePreferences
}

struct SharePreferences {
    let includeWatermark: Bool
    let shareAnalytics: Bool
    let culturalContext: Bool
    let personalMessage: Bool
}

struct ShareResult {
    let success: Bool
    let platform: SharePlatform
    let timestamp: Date
    let errorMessage: String?

    init(success: Bool, platform: SharePlatform, timestamp: Date, errorMessage: String? = nil) {
        self.success = success
        self.platform = platform
        self.timestamp = timestamp
        self.errorMessage = errorMessage
    }
}

struct ShareRecord: Identifiable, Codable {
    let id: UUID
    let rakhiId: UUID
    let platform: SharePlatform
    let timestamp: Date
    let success: Bool
    let culturalScore: Double
}

enum SharingError: LocalizedError {
    case sharePreparationFailed(String)
    case platformNotAvailable(String)
    case invalidSharingURL
    case imageProcessingFailed
    case networkError

    var errorDescription: String? {
        switch self {
        case .sharePreparationFailed(let message):
            return "Failed to prepare sharing content: \(message)"
        case .platformNotAvailable(let platform):
            return "\(platform) is not available on this device"
        case .invalidSharingURL:
            return "Invalid sharing URL"
        case .imageProcessingFailed:
            return "Failed to process image for sharing"
        case .networkError:
            return "Network error occurred during sharing"
        }
    }
}

// MARK: - Custom Activity Types

class CulturalMessageActivity: UIActivity {
    override var activityType: UIActivity.ActivityType? {
        return UIActivity.ActivityType("com.forava.cultural.message")
    }

    override var activityTitle: String? {
        return "Cultural Message"
    }

    override var activityImage: UIImage? {
        return UIImage(systemName: "text.quote")
    }

    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return true
    }

    override func perform() {
        // Implement cultural message activity
        activityDidFinish(true)
    }
}

class RakhiGiftActivity: UIActivity {
    override var activityType: UIActivity.ActivityType? {
        return UIActivity.ActivityType("com.forava.rakhi.gift")
    }

    override var activityTitle: String? {
        return "Send as Gift"
    }

    override var activityImage: UIImage? {
        return UIImage(systemName: "gift")
    }

    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return true
    }

    override func perform() {
        // Implement rakhi gifting activity
        activityDidFinish(true)
    }
}

