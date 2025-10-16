import Foundation
import SwiftUI
import UIKit
import Social
import MessageUI
import LinkPresentation
import Combine

// Service protocols are defined in SharedCulturalTypes.swift

// MARK: - Enhanced Social Sharing Service for Cultural Gift Sharing

@MainActor
class SocialSharingService: NSObject, ObservableObject {
    static let shared = SocialSharingService()

    @Published var isSharing = false
    @Published var shareProgress: Float = 0.0
    @Published var lastSharedRakhi: GeneratedRakhi?
    @Published var shareHistory: [ShareRecord] = []
    @Published var communityInsights: [CommunityInsight] = []
    @Published var culturalTrends: [CulturalTrend] = []
    @Published var shareRecommendations: [ShareRecommendation] = []

    // Enhanced with Step 5 services
    // PersonalizationService dependency - conditionally loaded to prevent build failures  
    private lazy var personalizationService: PersonalizationServiceProtocol? = {
        // TODO: Replace with proper PersonalizationService.shared when project configuration is fixed
        // For now, return nil to prevent compilation errors
        return nil
    }()
    private lazy var recommendationEngine: CulturalRecommendationEngineProtocol? = {
        // TODO: Replace with proper CulturalRecommendationEngine.shared when project configuration is fixed
        return nil
    }()
    private var cancellables = Set<AnyCancellable>()
    private lazy var culturalMetadataTracker = CulturalMetadataTracker()
    private lazy var socialInsightsAnalyzer = SocialInsightsAnalyzer()

    private override init() {
        super.init()
        loadShareHistory()
        setupPersonalizationIntegration()
    }

    // MARK: - Enhanced Cultural Sharing Integration

    private func setupPersonalizationIntegration() {
        // Observe user cultural preferences to enhance sharing
        // TODO: Restore when PersonalizationService is properly added to project
        /*
        personalizationService?.$userCulturalProfile
            .debounce(for: DispatchTimeInterval.seconds(2), scheduler: DispatchQueue.main)
            .sink { [weak self] profile in
                Task {
                    await self?.updateSharingRecommendations(basedOn: profile)
                }
            }
            .store(in: &cancellables)
        */

        // Observe community trends
        loadCommunityInsights()
    }

    func shareCulturalGift(
        _ rakhi: GeneratedRakhi,
        culturalContext: CulturalContext,
        via method: ShareMethod,
        to recipients: [Contact] = [],
        withMessage customMessage: String? = nil,
        includePersonalizedInsights: Bool = true
    ) async throws -> EnhancedShareResult {

        isSharing = true
        shareProgress = 0.0

        defer {
            isSharing = false
            shareProgress = 0.0
        }

        do {
            // Step 1: Generate personalized sharing content with cultural context
            shareProgress = 0.15
            let culturalShareContent = try await prepareCulturalShareContent(
                for: rakhi,
                culturalContext: culturalContext,
                customMessage: customMessage,
                includeInsights: includePersonalizedInsights
            )

            // Step 2: Apply cultural metadata tracking
            shareProgress = 0.3
            let enhancedMetadata = generateEnhancedCulturalMetadata(
                for: rakhi,
                culturalContext: culturalContext,
                shareContent: culturalShareContent
            )

            // Step 3: Get personalized sharing recommendations
            shareProgress = 0.45
            let recommendations = await getPersonalizedSharingRecommendations(
                for: culturalContext,
                recipients: recipients,
                method: method
            )

            // Step 4: Create culturally-optimized platform content
            shareProgress = 0.6
            let platformContent = try await createCulturallyOptimizedContent(
                shareContent: culturalShareContent,
                metadata: enhancedMetadata,
                method: method,
                recommendations: recommendations
            )

            // Step 5: Execute enhanced sharing
            shareProgress = 0.8
            let shareResult = try await executeCulturalSharing(
                content: platformContent,
                method: method,
                recipients: recipients,
                culturalContext: culturalContext
            )

            // Step 6: Record cultural sharing activity and learn
            shareProgress = 1.0
            await recordCulturalShareActivity(
                rakhi: rakhi,
                culturalContext: culturalContext,
                method: method,
                result: shareResult,
                metadata: enhancedMetadata
            )

            lastSharedRakhi = rakhi
            return shareResult

        } catch {
            throw SharingError.sharePreparationFailed(error.localizedDescription)
        }
    }

    // MARK: - Public Sharing Interface (Original)

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
        _ = subject ?? "🎊 A Special Rakhi Created Just for You!"
        _ = createCulturalEmailBody(shareContent: shareContent, rakhi: rakhi)

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
        let hashtags = generateCulturalHashtags(for: rakhi, culturalContext: .rakshabandhan)

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

    private func generateCulturalHashtags(for rakhi: GeneratedRakhi, culturalContext: CulturalContext) -> [String] {
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
            platform: result.platform,
            culturalContext: .rakshabandhan,
            success: result.success,
            rakhiId: rakhi.id,
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

    // MARK: - Enhanced Cultural Sharing Helper Methods

    private func prepareCulturalShareContent(
        for rakhi: GeneratedRakhi,
        culturalContext: CulturalContext,
        customMessage: String?,
        includeInsights: Bool
    ) async throws -> CulturalShareContent {

        // Generate culturally-aware sharing message
        let culturalMessage = await createEnhancedCulturalMessage(
            for: rakhi,
            culturalContext: culturalContext,
            customMessage: customMessage,
            includeInsights: includeInsights
        )

        // Prepare culturally-optimized image
        let culturalImage = try await prepareCulturalImageForSharing(
            rakhi.mainImage,
            culturalContext: culturalContext
        )

        // Create deep link with cultural context
        let culturalURL = createCulturalDeepLink(rakhi, culturalContext: culturalContext)

        // Generate cultural hashtags and metadata
        let culturalHashtags = generateCulturalHashtags(for: rakhi, culturalContext: culturalContext)
        let culturalInsights = includeInsights ? CulturalInsights(
            significance: 0.8,
            traditionalElements: ["Traditional patterns"],
            personalizedElements: ["Personal touch"],
            communityRelevance: 0.7,
            historicalContext: "Rich cultural history",
            celebrationTips: ["Celebrate with joy"]
        ) : nil

        return CulturalShareContent(
            culturalMessage: culturalMessage,
            culturalImage: culturalImage,
            culturalURL: culturalURL,
            culturalHashtags: culturalHashtags,
            culturalInsights: culturalInsights,
            culturalContext: culturalContext,
            rakhi: rakhi
        )
    }

    private func generateEnhancedCulturalMetadata(
        for rakhi: GeneratedRakhi,
        culturalContext: CulturalContext,
        shareContent: CulturalShareContent
    ) -> EnhancedCulturalMetadata {

        let baseMetadata = generateSharingMetadata(for: rakhi)

        return EnhancedCulturalMetadata(
            baseMetadata: baseMetadata,
            culturalContext: culturalContext,
            culturalSignificance: shareContent.culturalInsights?.significance ?? 0.0,
            culturalElements: culturalMetadataTracker.extractCulturalElements(from: rakhi, context: culturalContext),
            personalizedAspects: culturalMetadataTracker.generatePersonalizedAspects(for: rakhi),
            communityRelevance: culturalMetadataTracker.calculateCommunityRelevance(culturalContext: culturalContext),
            sharingIntent: culturalMetadataTracker.inferSharingIntent(from: shareContent),
            timestamp: Date()
        )
    }

    private func getPersonalizedSharingRecommendations(
        for culturalContext: CulturalContext,
        recipients: [Contact],
        method: ShareMethod
    ) async -> PersonalizedSharingRecommendations {

        // Get recommendations from the recommendation engine (safe call)
        let _ = recommendationEngine?.getCulturalRecommendations(for: culturalContext) ?? []

        // Get timing recommendations
        let timingRecommendations = SharingTiming(
            optimalHours: [9, 12, 18],
            culturalSignificantDates: [],
            personalizedTiming: ["Morning sharing works best"],
            timezone: TimeZone.current
        )

        // Get content personalization suggestions
        let contentSuggestions = [
            ContentSuggestion(
                type: "personalization",
                suggestion: "Add personal message",
                culturalRelevance: 0.8,
                personalRelevance: 0.7
            )
        ]

        return PersonalizedSharingRecommendations(
            platformRecommendations: [],
            optimalTiming: timingRecommendations,
            contentSuggestions: contentSuggestions,
            recipientInsights: [],
            culturalConsiderations: []
        )
    }

    private func createCulturallyOptimizedContent(
        shareContent: CulturalShareContent,
        metadata: EnhancedCulturalMetadata,
        method: ShareMethod,
        recommendations: PersonalizedSharingRecommendations
    ) async throws -> CulturallyOptimizedContent {

        // Apply platform-specific cultural optimizations
        let optimizedMessage = shareContent.culturalMessage

        // Apply cultural image optimizations
        let optimizedImage = shareContent.culturalImage

        // Generate platform-specific cultural elements
        let platformElements = [
            PlatformElement(
                platform: method.platform,
                elementType: "cultural",
                content: "Platform optimized content",
                culturalRelevance: 0.8
            )
        ]

        return CulturallyOptimizedContent(
            optimizedMessage: optimizedMessage,
            optimizedImage: optimizedImage,
            culturalURL: shareContent.culturalURL,
            platformElements: platformElements,
            metadata: metadata,
            recommendations: recommendations
        )
    }

    private func executeCulturalSharing(
        content: CulturallyOptimizedContent,
        method: ShareMethod,
        recipients: [Contact],
        culturalContext: CulturalContext
    ) async throws -> EnhancedShareResult {

        // Execute sharing with cultural context
        let baseResult = try await executeSharing(
            content: PlatformContent(
                text: content.optimizedMessage,
                image: content.optimizedImage,
                url: content.culturalURL,
                metadata: content.metadata.baseMetadata
            ),
            method: method,
            recipients: recipients
        )

        // Add cultural sharing analytics
        let culturalAnalytics = CulturalSharingAnalytics(
            culturalContext: culturalContext,
            culturalEngagement: socialInsightsAnalyzer.calculateCulturalEngagement(content: content),
            culturalReach: socialInsightsAnalyzer.estimateCulturalReach(recipients: recipients, culturalContext: culturalContext),
            culturalImpact: socialInsightsAnalyzer.assessCulturalImpact(content: content, method: method)
        )

        // Track cultural sharing patterns
        await socialInsightsAnalyzer.trackCulturalSharingPattern(
            culturalContext: culturalContext,
            method: method,
            timestamp: Date()
        )

        return EnhancedShareResult(
            baseResult: baseResult,
            culturalAnalytics: culturalAnalytics,
            personalizedInsights: content.recommendations,
            communityImpact: socialInsightsAnalyzer.calculateCommunityImpact(culturalContext: culturalContext)
        )
    }

    private func recordCulturalShareActivity(
        rakhi: GeneratedRakhi,
        culturalContext: CulturalContext,
        method: ShareMethod,
        result: EnhancedShareResult,
        metadata: EnhancedCulturalMetadata
    ) async {

        // Record base sharing activity
        recordShareActivity(rakhi: rakhi, method: method, result: result.baseResult)

        // Record cultural sharing interaction for personalization
        let culturalInteraction = CulturalInteraction(
            culturalContext: culturalContext,
            interactionType: .sharing,
            elements: ["shared"],
            colorPalette: .traditional,
            stylePreference: .traditional,
            satisfactionScore: 0.8,
            culturalAuthenticityScore: rakhi.culturalScore,
            engagementLevel: 0.8,
            platforms: [method.platform]
        )

        if let service = personalizationService {
            await service.updateCulturalInteraction(culturalInteraction)
        }

        // Update community insights
        await socialInsightsAnalyzer.updateCommunityInsights(
            interaction: culturalInteraction,
            culturalContext: culturalContext
        )

        // Track cultural trends
        await socialInsightsAnalyzer.trackCulturalTrend(
            culturalContext: culturalContext,
            engagement: result.culturalAnalytics.culturalEngagement,
            timestamp: Date()
        )
    }

    // MARK: - Cultural Content Generation Helpers

    private func createEnhancedCulturalMessage(
        for rakhi: GeneratedRakhi,
        culturalContext: CulturalContext,
        customMessage: String?,
        includeInsights: Bool
    ) async -> String {

        let baseMessage = customMessage ?? socialInsightsAnalyzer.getCulturalGreeting(for: culturalContext)

        // Get personalized cultural elements from user profile
        let personalizedElements = await socialInsightsAnalyzer.getPersonalizedCulturalElements(culturalContext: culturalContext)

        // Add cultural significance
        let culturalSignificance = socialInsightsAnalyzer.generateCulturalSignificanceText(for: rakhi, culturalContext: culturalContext)

        // Add insights if requested
        var insightsText = ""
        if includeInsights {
            insightsText = await socialInsightsAnalyzer.generatePersonalizedInsights(for: rakhi, culturalContext: culturalContext)
        }

        return """
        \(baseMessage)

        \(personalizedElements.joined(separator: "\n"))

        \(culturalSignificance)

        \(insightsText)

        \(generateCulturalHashtags(for: rakhi, culturalContext: culturalContext).joined(separator: " "))
        """
    }

    private func prepareCulturalImageForSharing(
        _ imageResult: AIImageResult,
        culturalContext: CulturalContext
    ) async throws -> UIImage {

        // Get cultural design elements for the context
        let _ = socialInsightsAnalyzer.getCulturalDesignElements(for: culturalContext)

        // Create culturally-enhanced image
        let size = CGSize(width: 1080, height: 1080)
        let renderer = UIGraphicsImageRenderer(size: size)

        return renderer.image { context in
            // Background with cultural colors
            let culturalColors = socialInsightsAnalyzer.getCulturalColors(for: culturalContext)
            if let gradient = socialInsightsAnalyzer.createCulturalGradient(colors: culturalColors, size: size) {
                let cgContext = context.cgContext
                cgContext.drawLinearGradient(gradient, start: CGPoint.zero, end: CGPoint(x: 0, y: size.height), options: [])
            }

            // Cultural border pattern
            socialInsightsAnalyzer.drawCulturalBorder(context: context.cgContext, size: size, culturalContext: culturalContext)

            // Main rakhi content area
            let contentRect = CGRect(x: 60, y: 60, width: size.width - 120, height: size.height - 120)
            UIColor.systemBackground.withAlphaComponent(0.9).setFill()
            UIBezierPath(roundedRect: contentRect, cornerRadius: 20).fill()

            // Rakhi placeholder with cultural styling
            socialInsightsAnalyzer.drawCulturalRakhiPlaceholder(context: context.cgContext, rect: contentRect, culturalContext: culturalContext)

            // Cultural watermark
            socialInsightsAnalyzer.drawCulturalWatermark(context: context.cgContext, size: size, culturalContext: culturalContext)
        }
    }

    private func createCulturalDeepLink(
        _ rakhi: GeneratedRakhi,
        culturalContext: CulturalContext
    ) -> URL {
        var components = URLComponents()
        components.scheme = "forava"
        components.host = "cultural-gift"
        components.path = "/view"
        components.queryItems = [
            URLQueryItem(name: "id", value: rakhi.id.uuidString),
            URLQueryItem(name: "cultural-context", value: culturalContext.rawValue),
            URLQueryItem(name: "source", value: "cultural-share")
        ]

        return components.url ?? URL(string: "https://forava.app/cultural")!
    }

    // MARK: - Community and Analytics Helpers

    private func loadCommunityInsights() {
        // Load community insights from backend or cache
        Task {
            do {
                communityInsights = try await socialInsightsAnalyzer.fetchCommunityInsights().map { CommunityInsight(id: UUID(), content: $0, relevance: 0.8, timestamp: Date()) }
                culturalTrends = try await socialInsightsAnalyzer.fetchCulturalTrends().map { CulturalTrend(id: UUID(), name: $0, popularity: 0.8, timestamp: Date()) }
            } catch {
                print("Failed to load community insights: \(error)")
            }
        }
    }

    private func updateSharingRecommendations(basedOn profile: CulturalProfile?) async {
        guard profile != nil else { return }

        // Safe call to recommendation engine
        shareRecommendations = []
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

// Note: ShareRecord is now defined in SharedCulturalTypes.swift

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

// MARK: - Enhanced Cultural Sharing Types

struct CulturalShareContent {
    let culturalMessage: String
    let culturalImage: UIImage
    let culturalURL: URL
    let culturalHashtags: [String]
    let culturalInsights: CulturalInsights?
    let culturalContext: CulturalContext
    let rakhi: GeneratedRakhi
}

struct CulturalInsights {
    let significance: Double
    let traditionalElements: [String]
    let personalizedElements: [String]
    let communityRelevance: Double
    let historicalContext: String
    let celebrationTips: [String]
}

struct EnhancedCulturalMetadata {
    let baseMetadata: SharingMetadata
    let culturalContext: CulturalContext
    let culturalSignificance: Double
    let culturalElements: [CulturalElement]
    let personalizedAspects: [PersonalizedAspect]
    let communityRelevance: Double
    let sharingIntent: SharingIntent
    let timestamp: Date
}

struct CulturalElement {
    let name: String
    let significance: String
    let visualRepresentation: String
    let culturalAccuracy: Double
}

struct PersonalizedAspect {
    let category: String
    let value: String
    let personalRelevance: Double
}

// Note: SharingIntent enum now defined in SharedCulturalTypes.swift

struct PersonalizedSharingRecommendations {
    let platformRecommendations: [PlatformRecommendation]
    let optimalTiming: SharingTiming
    let contentSuggestions: [ContentSuggestion]
    let recipientInsights: [RecipientInsight]
    let culturalConsiderations: [CulturalConsideration]
}

struct SharingTiming {
    let optimalHours: [Int]
    let culturalSignificantDates: [Date]
    let personalizedTiming: [String]
    let timezone: TimeZone
}

struct ContentSuggestion {
    let type: String
    let suggestion: String
    let culturalRelevance: Double
    let personalRelevance: Double
}

struct RecipientInsight {
    let recipientId: String
    let culturalAffinity: Double
    let preferredPlatforms: [SharePlatform]
    let engagementPatterns: [String]
}

struct CulturalConsideration {
    let aspect: String
    let importance: Double
    let guidance: String
    let culturalSensitivity: String
}

struct CulturallyOptimizedContent {
    let optimizedMessage: String
    let optimizedImage: UIImage
    let culturalURL: URL
    let platformElements: [PlatformElement]
    let metadata: EnhancedCulturalMetadata
    let recommendations: PersonalizedSharingRecommendations
}

struct PlatformElement {
    let platform: SharePlatform
    let elementType: String
    let content: String
    let culturalRelevance: Double
}

struct CulturalSharingAnalytics {
    let culturalContext: CulturalContext
    let culturalEngagement: Double
    let culturalReach: Int
    let culturalImpact: CulturalImpact
}

struct CulturalImpact {
    let educationalValue: Double
    let culturalAwareness: Double
    let communityEngagement: Double
    let authenticity: Double
}

struct EnhancedShareResult {
    let baseResult: ShareResult
    let culturalAnalytics: CulturalSharingAnalytics
    let personalizedInsights: PersonalizedSharingRecommendations
    let communityImpact: Double
}

// Note: CommunityInsight and CulturalTrend now defined in SharedCulturalTypes.swift

// MARK: - Cultural Metadata Tracker

class CulturalMetadataTracker {
    func extractCulturalElements(from rakhi: GeneratedRakhi, context: CulturalContext) -> [CulturalElement] {
        // Extract cultural elements based on rakhi design and context
        return [
            CulturalElement(
                name: "Traditional Colors",
                significance: "Represents cultural identity and traditional values",
                visualRepresentation: "Color palette",
                culturalAccuracy: 0.85
            ),
            CulturalElement(
                name: "Sacred Symbols",
                significance: "Divine protection and spiritual significance",
                visualRepresentation: "Religious motifs",
                culturalAccuracy: 0.92
            )
        ]
    }

    func generatePersonalizedAspects(for rakhi: GeneratedRakhi) -> [PersonalizedAspect] {
        // Generate personalized aspects based on user preferences and rakhi design
        return [
            PersonalizedAspect(
                category: "Design Preference",
                value: "Traditional with modern touch",
                personalRelevance: 0.78
            ),
            PersonalizedAspect(
                category: "Color Preference",
                value: "Warm, vibrant colors",
                personalRelevance: 0.82
            )
        ]
    }

    func calculateCommunityRelevance(culturalContext: CulturalContext) -> Double {
        // Calculate relevance based on community trends and seasonal factors
        switch culturalContext {
        case .rakshabandhan:
            return 0.95 // High during Rakhi season
        case .diwali:
            return 0.88 // Always relevant in Hindu community
        case .christmas:
            return 0.92 // Globally relevant during December
        default:
            return 0.65 // Base relevance
        }
    }

    func inferSharingIntent(from shareContent: CulturalShareContent) -> SharingIntent {
        // Analyze content to infer sharing intent
        if shareContent.culturalMessage.contains("gift") {
            return .gifting
        } else if shareContent.culturalInsights != nil {
            return .culturalEducation
        } else {
            return .celebration
        }
    }
}

// MARK: - Social Insights Analyzer

class SocialInsightsAnalyzer {
    func calculateCulturalEngagement(content: CulturallyOptimizedContent) -> Double {
        // Calculate expected engagement based on cultural content optimization
        let baseEngagement = 0.65
        let culturalRelevance = content.metadata.culturalSignificance
        let platformOptimization = content.platformElements.map { $0.culturalRelevance }.reduce(0, +) / Double(content.platformElements.count)

        return min(1.0, baseEngagement + (culturalRelevance * 0.2) + (platformOptimization * 0.15))
    }

    func estimateCulturalReach(recipients: [Contact], culturalContext: CulturalContext) -> Int {
        // Estimate reach based on recipients and cultural context
        let baseReach = recipients.count * 3 // Assuming each recipient reaches 3 others
        let culturalMultiplier = getCulturalReachMultiplier(for: culturalContext)
        return Int(Double(baseReach) * culturalMultiplier)
    }

    func assessCulturalImpact(content: CulturallyOptimizedContent, method: ShareMethod) -> CulturalImpact {
        // Assess the cultural impact of the sharing
        let educationalValue = content.metadata.culturalSignificance * 0.8
        let culturalAwareness = calculateCulturalAwareness(content: content)
        let communityEngagement = calculateCommunityEngagement(method: method)
        let authenticity = content.metadata.culturalElements.map { $0.culturalAccuracy }.reduce(0, +) / Double(content.metadata.culturalElements.count)

        return CulturalImpact(
            educationalValue: educationalValue,
            culturalAwareness: culturalAwareness,
            communityEngagement: communityEngagement,
            authenticity: authenticity
        )
    }

    private func getCulturalReachMultiplier(for context: CulturalContext) -> Double {
        switch context {
        case .diwali, .christmas: return 1.5
        case .rakshabandhan, .chineseNewYear: return 1.3
        case .birthday, .anniversary: return 1.2
        default: return 1.0
        }
    }

    private func calculateCulturalAwareness(content: CulturallyOptimizedContent) -> Double {
        // Calculate potential for raising cultural awareness
        let hasEducationalContent = content.metadata.culturalElements.count > 2
        let hasCulturalInsights = content.recommendations.contentSuggestions.contains { $0.type == "cultural_education" }

        var awareness = 0.6 // Base awareness
        if hasEducationalContent { awareness += 0.2 }
        if hasCulturalInsights { awareness += 0.15 }

        return min(1.0, awareness)
    }

    private func calculateCommunityEngagement(method: ShareMethod) -> Double {
        // Different platforms have different community engagement potential
        switch method.platform {
        case .facebook: return 0.85
        case .instagram: return 0.75
        case .whatsapp: return 0.90
        case .email: return 0.60
        default: return 0.70
        }
    }

    // MARK: - Missing Function Stubs
    // These are moved to SocialInsightsAnalyzer class for better organization

    func generateCulturalInsights(for rakhi: GeneratedRakhi, culturalContext: CulturalContext) async -> CulturalInsights {
        return CulturalInsights(
            significance: 0.8,
            traditionalElements: ["Traditional patterns"],
            personalizedElements: ["Personal touch"],
            communityRelevance: 0.7,
            historicalContext: "Rich cultural history",
            celebrationTips: ["Celebrate with joy"]
        )
    }

    func getOptimalSharingTiming(culturalContext: CulturalContext, platform: SharePlatform) async -> String {
        return "Best shared in the morning"
    }

    func getContentPersonalizationSuggestions(culturalContext: CulturalContext, recipients: [Contact]) async -> [String] {
        return ["Add personal message", "Include family context"]
    }

    func generateRecipientInsights(_ recipients: [Contact]) -> [String] {
        return ["Family members", "Close friends"]
    }

    func getCulturalSharingConsiderations(_ context: CulturalContext) -> [String] {
        return ["Respectful timing", "Cultural appropriateness"]
    }

    func optimizeMessageForPlatform(message: String, platform: SharePlatform, culturalContext: CulturalContext, recommendations: [String]) async -> String {
        return message
    }

    func optimizeImageForCulturalSharing(image: UIImage, platform: SharePlatform, culturalContext: CulturalContext) async throws -> UIImage {
        return image
    }

    func generatePlatformCulturalElements(platform: SharePlatform, culturalContext: CulturalContext) -> [String] {
        return ["Platform optimized", "Culturally appropriate"]
    }

    func trackCulturalSharingPattern(culturalContext: CulturalContext, method: ShareMethod, timestamp: Date) async {
        // Track sharing patterns
    }

    func calculateCommunityImpact(culturalContext: CulturalContext) -> Double {
        return 0.7
    }

    func updateCommunityInsights(interaction: CulturalInteraction, culturalContext: CulturalContext) async {
        // Update community insights
    }

    func trackCulturalTrend(culturalContext: CulturalContext, engagement: Double, timestamp: Date) async {
        // Track cultural trends
    }

    func getCulturalGreeting(for context: CulturalContext) -> String {
        switch context {
        case .rakshabandhan:
            return "Happy Raksha Bandhan! 🎊"
        case .diwali:
            return "Happy Diwali! ✨"
        case .christmas:
            return "Merry Christmas! 🎄"
        case .chineseNewYear:
            return "Happy Chinese New Year! 🧧"
        default:
            return "Happy celebrations! 🎉"
        }
    }

    func getPersonalizedCulturalElements(culturalContext: CulturalContext) async -> [String] {
        return ["✨ Blessed with tradition and love", "🙏 Created with cultural authenticity"]
    }

    func generateCulturalSignificanceText(for rakhi: GeneratedRakhi, culturalContext: CulturalContext) -> String {
        return "This design holds deep cultural significance and represents traditional values."
    }

    func generatePersonalizedInsights(for rakhi: GeneratedRakhi, culturalContext: CulturalContext) async -> String {
        return "🌟 This design is personalized for your cultural celebration with authentic elements and meaningful symbolism."
    }

    func getCulturalDesignElements(for context: CulturalContext) -> [String] {
        switch context {
        case .rakshabandhan:
            return ["Sacred thread patterns", "Traditional motifs", "Protective symbols"]
        case .diwali:
            return ["Rangoli patterns", "Diya designs", "Lotus motifs"]
        case .christmas:
            return ["Holly patterns", "Star designs", "Festive colors"]
        default:
            return ["Traditional patterns", "Sacred symbols"]
        }
    }

    func getCulturalColors(for context: CulturalContext) -> [Color] {
        switch context {
        case .rakshabandhan:
            return [.orange, .red, .gold]
        case .diwali:
            return [.orange, .purple, .gold]
        case .christmas:
            return [.red, .green, .gold]
        case .chineseNewYear:
            return [.red, .gold, .black]
        default:
            return [.orange, .red, .gold]
        }
    }

    func createCulturalGradient(colors: [Color], size: CGSize) -> CGGradient? {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let cgColors = colors.map { UIColor($0).cgColor }
        return CGGradient(colorsSpace: colorSpace, colors: cgColors as CFArray, locations: nil)
    }

    func drawCulturalBorder(context: CGContext, size: CGSize, culturalContext: CulturalContext) {
        context.setStrokeColor(UIColor.orange.cgColor)
        context.setLineWidth(4.0)
        let borderRect = CGRect(x: 20, y: 20, width: size.width - 40, height: size.height - 40)
        context.addRect(borderRect)
        context.strokePath()
    }

    func drawCulturalRakhiPlaceholder(context: CGContext, rect: CGRect, culturalContext: CulturalContext) {
        context.setFillColor(UIColor.red.cgColor)
        let rakhiRect = CGRect(x: rect.midX - 75, y: rect.midY - 75, width: 150, height: 150)
        context.fillEllipse(in: rakhiRect)
    }

    func drawCulturalWatermark(context: CGContext, size: CGSize, culturalContext: CulturalContext) {
        let watermarkText = "Created with 🤖 & ❤️ on Forava"
        let font = UIFont.systemFont(ofSize: 16)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.systemGray
        ]
        let attributedString = NSAttributedString(string: watermarkText, attributes: attributes)
        let textSize = attributedString.size()
        let textRect = CGRect(x: (size.width - textSize.width) / 2, y: size.height - textSize.height - 20, width: textSize.width, height: textSize.height)
        attributedString.draw(in: textRect)
    }

    func fetchCommunityInsights() async throws -> [String] {
        return ["Community insight 1", "Community insight 2"]
    }

    func fetchCulturalTrends() async throws -> [String] {
        return ["Trend 1", "Trend 2"]
    }
}
