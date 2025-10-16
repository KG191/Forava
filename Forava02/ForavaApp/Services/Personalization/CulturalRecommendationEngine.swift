import Foundation
import SwiftUI
import Combine

// MARK: - Cultural Recommendation Engine for Smart Suggestions
@MainActor
class CulturalRecommendationEngine: ObservableObject {
    static let shared = CulturalRecommendationEngine()

    @Published var isGeneratingRecommendations = false
    @Published var currentRecommendations: [SmartRecommendation] = []
    @Published var trendingCulturalElements: [TrendingElement] = []
    @Published var seasonalRecommendations: [SeasonalRecommendation] = []

    private let personalizationService = PersonalizationService.shared
    private let culturalPromptMapper = CulturalPromptMapper.shared
    private var culturalKnowledgeBase: CulturalKnowledgeBase
    private var crossCulturalMappings: [CulturalMapping] = []
    private var userSimilarityEngine: UserSimilarityEngine

    private init() {
        self.culturalKnowledgeBase = CulturalKnowledgeBase()
        self.userSimilarityEngine = UserSimilarityEngine()
        loadCulturalKnowledge()
        loadCrossCulturalMappings()
    }

    // MARK: - Smart Recommendation Generation

    func generateSmartRecommendations(
        for context: CulturalContext? = nil,
        recipientProfile: RecipientProfile? = nil,
        occasionDetails: OccasionDetails? = nil
    ) async -> [SmartRecommendation] {

        isGeneratingRecommendations = true

        defer {
            isGeneratingRecommendations = false
        }

        var recommendations: [SmartRecommendation] = []

        // Generate different types of recommendations
        let personalizedRecs = await generatePersonalizedRecommendations(context: context)
        let culturalRecs = await generateCulturalInsightRecommendations(context: context)
        let similarUserRecs = await generateSimilarUserRecommendations(context: context)
        let crossCulturalRecs = await generateCrossCulturalRecommendations(context: context)
        let occasionRecs = await generateOccasionSpecificRecommendations(
            context: context,
            recipient: recipientProfile,
            occasion: occasionDetails
        )

        recommendations.append(contentsOf: personalizedRecs)
        recommendations.append(contentsOf: culturalRecs)
        recommendations.append(contentsOf: similarUserRecs)
        recommendations.append(contentsOf: crossCulturalRecs)
        recommendations.append(contentsOf: occasionRecs)

        // Score and rank recommendations
        let rankedRecommendations = await rankRecommendations(recommendations)

        // Update published properties
        currentRecommendations = Array(rankedRecommendations.prefix(10))

        return currentRecommendations
    }

    // MARK: - Personalized Recommendations

    private func generatePersonalizedRecommendations(context: CulturalContext?) async -> [SmartRecommendation] {
        guard let userProfile = personalizationService.userCulturalProfile else { return [] }

        var recommendations: [SmartRecommendation] = []

        // Recommend based on user's strongest cultural affinities
        let topAffinities = userProfile.culturalAffinities
            .sorted { $0.value > $1.value }
            .prefix(3)

        for (culturalContext, affinity) in topAffinities {
            if let specifiedContext = context, specifiedContext != culturalContext {
                continue
            }

            // Style recommendations based on user patterns
            if let preferredStyle = personalizationService.getPreferredStyleFor(culturalContext) {
                recommendations.append(SmartRecommendation(
                    id: UUID(),
                    type: .personalizedStyle,
                    culturalContext: culturalContext,
                    title: "Your Signature \(preferredStyle.displayName) Style",
                    description: "Create another beautiful \(culturalContext.displayName) gift in your favorite \(preferredStyle.displayName.lowercased()) style",
                    confidence: affinity * 0.9,
                    recommendationData: RecommendationData(
                        suggestedStyle: preferredStyle,
                        culturalElements: getSuggestedElements(for: culturalContext, style: preferredStyle),
                        colorPalette: getPreferredColorPalette(for: culturalContext, userProfile: userProfile),
                        reasoning: "Based on your creation history and preferences"
                    ),
                    priority: .high,
                    timestamp: Date()
                ))
            }

            // Element combination recommendations
            let elementRecommendations = generateElementCombinationRecommendations(
                culturalContext: culturalContext,
                userProfile: userProfile,
                affinity: affinity
            )
            recommendations.append(contentsOf: elementRecommendations)
        }

        return recommendations
    }

    // MARK: - Cultural Insight Recommendations

    private func generateCulturalInsightRecommendations(context: CulturalContext?) async -> [SmartRecommendation] {
        var recommendations: [SmartRecommendation] = []

        let culturalContexts = context != nil ? [context!] : CulturalContext.allCases

        for culturalContext in culturalContexts.prefix(3) {
            // Recommend exploring cultural depths
            let culturalInsight = culturalKnowledgeBase.getInsight(for: culturalContext)

            recommendations.append(SmartRecommendation(
                id: UUID(),
                type: .culturalInsight,
                culturalContext: culturalContext,
                title: "Discover \(culturalContext.displayName) Traditions",
                description: culturalInsight.description,
                confidence: 0.8,
                recommendationData: RecommendationData(
                    suggestedStyle: culturalInsight.recommendedStyle,
                    culturalElements: culturalInsight.authenticElements,
                    colorPalette: culturalInsight.traditionalColors,
                    reasoning: "Explore deeper cultural meanings and traditions"
                ),
                priority: .medium,
                timestamp: Date()
            ))

            // Recommend seasonal cultural elements
            let seasonalElements = getSeasonalCulturalElements(for: culturalContext)
            if !seasonalElements.isEmpty {
                recommendations.append(SmartRecommendation(
                    id: UUID(),
                    type: .seasonal,
                    culturalContext: culturalContext,
                    title: "Perfect for This Season",
                    description: "Create a \(culturalContext.displayName) gift that captures the essence of the current season",
                    confidence: 0.75,
                    recommendationData: RecommendationData(
                        suggestedStyle: .traditional,
                        culturalElements: seasonalElements,
                        colorPalette: getSeasonalColorPalette(for: culturalContext),
                        reasoning: "Seasonal cultural elements enhance authenticity"
                    ),
                    priority: .medium,
                    timestamp: Date()
                ))
            }
        }

        return recommendations
    }

    // MARK: - Similar User Recommendations

    private func generateSimilarUserRecommendations(context: CulturalContext?) async -> [SmartRecommendation] {
        guard let userProfile = personalizationService.userCulturalProfile else { return [] }

        let similarUsers = await userSimilarityEngine.findSimilarUsers(to: userProfile)
        var recommendations: [SmartRecommendation] = []

        for similarUser in similarUsers.prefix(2) {
            // Recommend popular choices among similar users
            let popularChoices = await getPopularChoicesFromSimilarUsers(similarUser, context: context)

            for choice in popularChoices {
                recommendations.append(SmartRecommendation(
                    id: UUID(),
                    type: .socialTrend,
                    culturalContext: choice.culturalContext,
                    title: "Popular with Similar Users",
                    description: "Users with similar preferences often choose \(choice.description)",
                    confidence: similarUser.similarity * 0.7,
                    recommendationData: choice.recommendationData,
                    priority: .medium,
                    timestamp: Date()
                ))
            }
        }

        return recommendations
    }

    // MARK: - Cross-Cultural Recommendations

    private func generateCrossCulturalRecommendations(context: CulturalContext?) async -> [SmartRecommendation] {
        var recommendations: [SmartRecommendation] = []

        guard let userProfile = personalizationService.userCulturalProfile else { return [] }

        // Find cross-cultural learning opportunities
        for mapping in crossCulturalMappings {
            let userAffinity1 = userProfile.culturalAffinities[mapping.context1] ?? 0.0
            let userAffinity2 = userProfile.culturalAffinities[mapping.context2] ?? 0.0

            // If user likes one culture, recommend exploring the mapped culture
            if userAffinity1 > 0.6 && userAffinity2 < 0.4 {
                recommendations.append(createCrossCulturalRecommendation(
                    from: mapping.context1,
                    to: mapping.context2,
                    mapping: mapping,
                    confidence: userAffinity1 * 0.6
                ))
            } else if userAffinity2 > 0.6 && userAffinity1 < 0.4 {
                recommendations.append(createCrossCulturalRecommendation(
                    from: mapping.context2,
                    to: mapping.context1,
                    mapping: mapping,
                    confidence: userAffinity2 * 0.6
                ))
            }
        }

        return recommendations
    }

    // MARK: - Occasion-Specific Recommendations

    private func generateOccasionSpecificRecommendations(
        context: CulturalContext?,
        recipient: RecipientProfile?,
        occasion: OccasionDetails?
    ) async -> [SmartRecommendation] {

        var recommendations: [SmartRecommendation] = []

        guard let recipient = recipient else { return recommendations }

        // Recommend based on recipient relationship
        let relationshipRecommendation = generateRelationshipSpecificRecommendation(
            recipient: recipient,
            context: context
        )
        if let recRec = relationshipRecommendation {
            recommendations.append(recRec)
        }

        // Recommend based on occasion timing
        if let occasion = occasion {
            let timingRecommendation = generateTimingSpecificRecommendation(
                occasion: occasion,
                context: context
            )
            if let timeRec = timingRecommendation {
                recommendations.append(timeRec)
            }
        }

        // Recommend based on recipient's cultural background
        if let recipientCulture = recipient.culturalBackground {
            let culturalBridgeRecommendation = generateCulturalBridgeRecommendation(
                recipientCulture: recipientCulture,
                context: context
            )
            if let bridgeRec = culturalBridgeRecommendation {
                recommendations.append(bridgeRec)
            }
        }

        return recommendations
    }

    // MARK: - Helper Methods

    private func rankRecommendations(_ recommendations: [SmartRecommendation]) async -> [SmartRecommendation] {
        return recommendations.sorted { first, second in
            // Primary sort by priority
            if first.priority != second.priority {
                return first.priority.rawValue > second.priority.rawValue
            }

            // Secondary sort by confidence
            if abs(first.confidence - second.confidence) > 0.1 {
                return first.confidence > second.confidence
            }

            // Tertiary sort by recency
            return first.timestamp > second.timestamp
        }
    }

    private func generateElementCombinationRecommendations(
        culturalContext: CulturalContext,
        userProfile: CulturalProfile,
        affinity: Double
    ) -> [SmartRecommendation] {

        var recommendations: [SmartRecommendation] = []

        // Find user's most used elements
        for pattern in userProfile.behaviorPatterns {
            if case .elementPreference(let data) = pattern {
                let topElements = data.elementFrequency.sorted { $0.value > $1.value }.prefix(2)

                for (elementId, frequency) in topElements where frequency > 2 {
                    // Suggest complementary elements
                    let complementaryElements = culturalKnowledgeBase.getComplementaryElements(
                        for: elementId,
                        in: culturalContext
                    )

                    if !complementaryElements.isEmpty {
                        recommendations.append(SmartRecommendation(
                            id: UUID(),
                            type: .elementCombination,
                            culturalContext: culturalContext,
                            title: "Enhance Your \(elementId) with Perfect Pairs",
                            description: "Discover elements that beautifully complement your favorite \(elementId)",
                            confidence: min(0.85, affinity * 0.7 + (Double(frequency) / 10.0)),
                            recommendationData: RecommendationData(
                                suggestedStyle: nil,
                                culturalElements: complementaryElements,
                                colorPalette: nil,
                                reasoning: "Elements that traditionally pair well with \(elementId)"
                            ),
                            priority: .medium,
                            timestamp: Date()
                        ))
                    }
                }
            }
        }

        return recommendations
    }

    private func createCrossCulturalRecommendation(
        from sourceContext: CulturalContext,
        to targetContext: CulturalContext,
        mapping: CulturalMapping,
        confidence: Double
    ) -> SmartRecommendation {

        return SmartRecommendation(
            id: UUID(),
            type: .crossCultural,
            culturalContext: targetContext,
            title: "Explore \(targetContext.displayName) Culture",
            description: "Since you love \(sourceContext.displayName), you might enjoy \(targetContext.displayName) - \(mapping.connectionReason)",
            confidence: confidence,
            recommendationData: RecommendationData(
                suggestedStyle: mapping.recommendedStyle,
                culturalElements: mapping.bridgeElements,
                colorPalette: mapping.sharedColorElements,
                reasoning: mapping.connectionReason
            ),
            priority: .medium,
            timestamp: Date()
        )
    }

    private func generateRelationshipSpecificRecommendation(
        recipient: RecipientProfile,
        context: CulturalContext?
    ) -> SmartRecommendation? {

        let relationshipGuidance = getRelationshipGuidance(recipient.relationship)

        guard let culturalContext = context ?? recipient.culturalBackground else { return nil }

        return SmartRecommendation(
            id: UUID(),
            type: .relationshipSpecific,
            culturalContext: culturalContext,
            title: "Perfect for \(recipient.relationship.displayName)",
            description: relationshipGuidance.description,
            confidence: 0.8,
            recommendationData: RecommendationData(
                suggestedStyle: relationshipGuidance.recommendedStyle,
                culturalElements: relationshipGuidance.appropriateElements,
                colorPalette: relationshipGuidance.suggestedColors,
                reasoning: "Tailored for \(recipient.relationship.displayName) relationships"
            ),
            priority: .high,
            timestamp: Date()
        )
    }

    private func generateTimingSpecificRecommendation(
        occasion: OccasionDetails,
        context: CulturalContext?
    ) -> SmartRecommendation? {

        let timingGuidance = getTimingGuidance(occasion)

        guard let culturalContext = context else { return nil }

        return SmartRecommendation(
            id: UUID(),
            type: .timingSpecific,
            culturalContext: culturalContext,
            title: "Perfect Timing for \(occasion.eventName)",
            description: timingGuidance.description,
            confidence: 0.75,
            recommendationData: RecommendationData(
                suggestedStyle: timingGuidance.recommendedStyle,
                culturalElements: timingGuidance.seasonalElements,
                colorPalette: timingGuidance.occasionColors,
                reasoning: "Optimized for \(occasion.eventName) celebration"
            ),
            priority: .medium,
            timestamp: Date()
        )
    }

    private func generateCulturalBridgeRecommendation(
        recipientCulture: CulturalContext,
        context: CulturalContext?
    ) -> SmartRecommendation? {

        guard let context = context, context != recipientCulture else { return nil }

        let bridgeElements = findCulturalBridgeElements(from: context, to: recipientCulture)

        return SmartRecommendation(
            id: UUID(),
            type: .culturalBridge,
            culturalContext: context,
            title: "Bridge Two Cultures",
            description: "Combine \(context.displayName) and \(recipientCulture.displayName) elements for a meaningful cross-cultural gift",
            confidence: 0.7,
            recommendationData: RecommendationData(
                suggestedStyle: .elegant,
                culturalElements: bridgeElements,
                colorPalette: .traditional,
                reasoning: "Respectfully bridges \(context.displayName) and \(recipientCulture.displayName) traditions"
            ),
            priority: .high,
            timestamp: Date()
        )
    }

    // MARK: - Data Loading and Knowledge Base

    private func loadCulturalKnowledge() {
        // Initialize cultural knowledge base with insights for each context
        culturalKnowledgeBase.loadInsights()
    }

    private func loadCrossCulturalMappings() {
        crossCulturalMappings = [
            CulturalMapping(
                context1: .diwali,
                context2: .chineseNewYear,
                connectionReason: "Both celebrate light, prosperity, and new beginnings",
                bridgeElements: ["lights", "prosperity symbols", "festive colors"],
                sharedColorElements: .traditional,
                recommendedStyle: .elegant
            ),
            CulturalMapping(
                context1: .christmas,
                context2: .diwali,
                connectionReason: "Both are festivals of light and joy with family gatherings",
                bridgeElements: ["warm lighting", "family celebration", "gift giving"],
                sharedColorElements: .traditional,
                recommendedStyle: .traditional
            ),
            CulturalMapping(
                context1: .rakshabandhan,
                context2: .anniversary,
                connectionReason: "Both celebrate enduring bonds and relationships",
                bridgeElements: ["protective symbols", "eternal bonds", "meaningful connections"],
                sharedColorElements: .elegant,
                recommendedStyle: .spiritual
            )
            // Additional mappings would be added here...
        ]
    }

    // MARK: - Supporting Data Access Methods

    private func getSuggestedElements(for context: CulturalContext, style: RakhiGenre) -> [String] {
        return culturalKnowledgeBase.getElements(for: context, style: style)
    }

    private func getPreferredColorPalette(for context: CulturalContext, userProfile: CulturalProfile) -> ColorPalette? {
        // Find user's most used color palette for this context
        for pattern in userProfile.behaviorPatterns {
            if case .colorPreference(let data) = pattern {
                return data.paletteFrequency.max { $0.value < $1.value }?.key
            }
        }
        return nil
    }

    private func getSeasonalCulturalElements(for context: CulturalContext) -> [String] {
        let currentSeason = getCurrentSeason()
        return culturalKnowledgeBase.getSeasonalElements(for: context, season: currentSeason)
    }

    private func getSeasonalColorPalette(for context: CulturalContext) -> ColorPalette {
        let currentSeason = getCurrentSeason()
        return culturalKnowledgeBase.getSeasonalColors(for: context, season: currentSeason)
    }

    private func getPopularChoicesFromSimilarUsers(
        _ similarUser: SimilarUser,
        context: CulturalContext?
    ) async -> [PopularChoice] {
        // This would integrate with analytics to find popular choices
        return []
    }

    private func getRelationshipGuidance(_ relationship: RecipientRelationship) -> RelationshipGuidance {
        switch relationship {
        case .sibling:
            return RelationshipGuidance(
                description: "Create something that celebrates your unique sibling bond",
                recommendedStyle: .traditional,
                appropriateElements: ["protective symbols", "family bonds", "sibling love"],
                suggestedColors: .traditional
            )
        case .parent:
            return RelationshipGuidance(
                description: "Honor your parent with respectful and meaningful design",
                recommendedStyle: .spiritual,
                appropriateElements: ["respect symbols", "gratitude elements", "blessing imagery"],
                suggestedColors: .traditional
            )
        case .friend:
            return RelationshipGuidance(
                description: "Celebrate friendship with joyful and warm elements",
                recommendedStyle: .modern,
                appropriateElements: ["friendship symbols", "joy elements", "celebration imagery"],
                suggestedColors: .vibrant
            )
        case .romantic:
            return RelationshipGuidance(
                description: "Express love with elegant and intimate design",
                recommendedStyle: .elegant,
                appropriateElements: ["love symbols", "romantic elements", "intimate imagery"],
                suggestedColors: .pastel
            )
        }
    }

    private func getTimingGuidance(_ occasion: OccasionDetails) -> TimingGuidance {
        return TimingGuidance(
            description: "Perfect elements for this special occasion",
            recommendedStyle: .traditional,
            seasonalElements: getSeasonalElements(for: occasion.date),
            occasionColors: getOccasionColors(for: occasion.type)
        )
    }

    private func findCulturalBridgeElements(from: CulturalContext, to: CulturalContext) -> [String] {
        // Find elements that respectfully bridge two cultures
        let mapping = crossCulturalMappings.first {
            ($0.context1 == from && $0.context2 == to) ||
            ($0.context1 == to && $0.context2 == from)
        }
        return mapping?.bridgeElements ?? []
    }

    private func getCurrentSeason() -> String {
        let month = Calendar.current.component(.month, from: Date())
        switch month {
        case 12, 1, 2: return "winter"
        case 3, 4, 5: return "spring"
        case 6, 7, 8: return "summer"
        case 9, 10, 11: return "autumn"
        default: return "spring"
        }
    }

    private func getSeasonalElements(for date: Date) -> [String] {
        let season = getCurrentSeason()
        switch season {
        case "spring": return ["fresh blooms", "renewal symbols", "growth elements"]
        case "summer": return ["vibrant energy", "sun symbols", "abundance elements"]
        case "autumn": return ["harvest symbols", "gratitude elements", "warm tones"]
        case "winter": return ["cozy elements", "warmth symbols", "celebration imagery"]
        default: return []
        }
    }

    private func getOccasionColors(for occasionType: String) -> ColorPalette {
        switch occasionType.lowercased() {
        case "celebration": return .vibrant
        case "spiritual": return .traditional
        case "romantic": return .pastel
        case "formal": return .elegant
        default: return .traditional
        }
    }

    // MARK: - Social Sharing Integration Methods

    func generateSharingRecommendations(
        culturalContext: CulturalContext,
        recipients: [Contact],
        platform: SharePlatform
    ) async -> [PlatformRecommendation] {

        var recommendations: [PlatformRecommendation] = []

        // Analyze platform suitability for cultural context
        let suitabilityScore = calculatePlatformSuitability(platform: platform, culturalContext: culturalContext)

        // Generate platform-specific recommendations
        let optimizations = getPlatformOptimizations(platform: platform, culturalContext: culturalContext)
        let reasoningFactors = getReasoningFactors(platform: platform, culturalContext: culturalContext)

        recommendations.append(PlatformRecommendation(
            platform: platform,
            suitabilityScore: suitabilityScore,
            reasoningFactors: reasoningFactors,
            optimizationSuggestions: optimizations
        ))

        return recommendations
    }

    func generateSharingRecommendations(basedOn profile: CulturalProfile) async -> [ShareRecommendation] {

        var recommendations: [ShareRecommendation] = []

        // Generate recommendations based on user's cultural profile
        for (culturalContext, affinity) in profile.culturalAffinities.sorted(by: { $0.value > $1.value }).prefix(3) {

            if affinity > 0.6 {
                recommendations.append(ShareRecommendation(
                    id: UUID(),
                    culturalContext: culturalContext,
                    recommendationType: "cultural_engagement",
                    title: "Share More \(culturalContext.displayName) Gifts",
                    description: "You have strong affinity for \(culturalContext.displayName) culture - share more to inspire others",
                    actionText: "Create & Share",
                    relevanceScore: affinity,
                    timestamp: Date()
                ))
            }

            // Recommend exploring new sharing platforms
            if profile.learningProgress.totalInteractions > 10 {
                recommendations.append(ShareRecommendation(
                    id: UUID(),
                    culturalContext: culturalContext,
                    recommendationType: "platform_exploration",
                    title: "Try New Sharing Platforms",
                    description: "Expand your \(culturalContext.displayName) gift sharing to new platforms",
                    actionText: "Explore Platforms",
                    relevanceScore: min(0.8, affinity * 0.9),
                    timestamp: Date()
                ))
            }
        }

        return recommendations
    }

    // MARK: - Helper Methods for Sharing Integration

    private func calculatePlatformSuitability(platform: SharePlatform, culturalContext: CulturalContext) -> Double {
        switch (platform, culturalContext) {
        case (.whatsapp, _):
            return 0.9 // WhatsApp generally excellent for cultural sharing
        case (.instagram, .diwali), (.instagram, .chineseNewYear):
            return 0.85 // Visual platforms great for colorful festivals
        case (.facebook, _):
            return 0.8 // Good for community sharing
        case (.email, .rakshabandhan), (.email, .anniversary):
            return 0.75 // Good for personal relationships
        default:
            return 0.7 // Base suitability
        }
    }

    private func getPlatformOptimizations(platform: SharePlatform, culturalContext: CulturalContext) -> [String] {
        switch platform {
        case .instagram:
            return ["Use square 1:1 aspect ratio", "Add cultural hashtags", "Include story highlights"]
        case .whatsapp:
            return ["Keep messages concise", "Use cultural emojis", "Share in relevant groups"]
        case .facebook:
            return ["Write engaging captions", "Tag cultural communities", "Post at optimal times"]
        default:
            return ["Optimize for platform", "Use cultural context", "Engage audience"]
        }
    }

    private func getReasoningFactors(platform: SharePlatform, culturalContext: CulturalContext) -> [String] {
        switch platform {
        case .whatsapp:
            return ["High personal engagement", "Cultural message delivery", "Family sharing"]
        case .instagram:
            return ["Visual cultural impact", "Young audience reach", "Trending potential"]
        case .facebook:
            return ["Community engagement", "Cultural education", "Broad reach"]
        default:
            return ["Platform engagement", "Cultural sharing", "Community impact"]
        }
    }
}

// MARK: - Supporting Types

struct SmartRecommendation: Identifiable {
    let id: UUID
    let type: RecommendationType
    let culturalContext: CulturalContext
    let title: String
    let description: String
    let confidence: Double
    let recommendationData: RecommendationData
    let priority: RecommendationPriority
    let timestamp: Date

    enum RecommendationType {
        case personalizedStyle
        case elementCombination
        case culturalInsight
        case crossCultural
        case seasonal
        case socialTrend
        case relationshipSpecific
        case timingSpecific
        case culturalBridge
    }

    enum RecommendationPriority: Int {
        case low = 1
        case medium = 2
        case high = 3
    }
}

struct RecommendationData {
    let suggestedStyle: RakhiGenre?
    let culturalElements: [String]
    let colorPalette: ColorPalette?
    let reasoning: String
}

struct RecipientProfile {
    let name: String
    let relationship: RecipientRelationship
    let culturalBackground: CulturalContext?
    let preferences: RecipientPreferences?
}

enum RecipientRelationship {
    case sibling
    case parent
    case friend
    case romantic

    var displayName: String {
        switch self {
        case .sibling: return "Sibling"
        case .parent: return "Parent"
        case .friend: return "Friend"
        case .romantic: return "Partner"
        }
    }
}

struct RecipientPreferences {
    let preferredStyle: RakhiGenre?
    let favoriteColors: [ColorPalette]
    let culturalSensitivity: Double // 0.0 to 1.0
}

struct OccasionDetails {
    let eventName: String
    let date: Date
    let type: String
    let significance: OccasionSignificance
}

enum OccasionSignificance {
    case personal
    case cultural
    case religious
    case social
}

struct CulturalMapping {
    let context1: CulturalContext
    let context2: CulturalContext
    let connectionReason: String
    let bridgeElements: [String]
    let sharedColorElements: ColorPalette
    let recommendedStyle: RakhiGenre
}

struct SimilarUser {
    let userId: String
    let similarity: Double
    let sharedPreferences: [String]
}

struct PopularChoice {
    let culturalContext: CulturalContext
    let description: String
    let recommendationData: RecommendationData
    let popularity: Double
}

struct RelationshipGuidance {
    let description: String
    let recommendedStyle: RakhiGenre
    let appropriateElements: [String]
    let suggestedColors: ColorPalette
}

struct TimingGuidance {
    let description: String
    let recommendedStyle: RakhiGenre
    let seasonalElements: [String]
    let occasionColors: ColorPalette
}

struct TrendingElement {
    let elementId: String
    let culturalContext: CulturalContext
    let trendScore: Double
    let usageGrowth: Double
}

struct SeasonalRecommendation {
    let culturalContext: CulturalContext
    let seasonalElements: [String]
    let description: String
    let relevanceScore: Double
}

// MARK: - Knowledge Base and Engine Classes

class CulturalKnowledgeBase {
    private var insights: [CulturalContext: CulturalInsight] = [:]

    func loadInsights() {
        // Load cultural insights for each context
        insights[.rakshabandhan] = CulturalInsight(
            context: .rakshabandhan,
            description: "Raksha Bandhan celebrates the sacred bond between siblings, emphasizing protection and love",
            recommendedStyle: .traditional,
            authenticElements: ["sacred thread", "Om symbol", "protective blessings"],
            traditionalColors: .traditional
        )

        insights[.diwali] = CulturalInsight(
            context: .diwali,
            description: "Diwali is the festival of lights, celebrating the victory of light over darkness",
            recommendedStyle: .spiritual,
            authenticElements: ["diya lamps", "rangoli patterns", "goddess Lakshmi"],
            traditionalColors: .traditional
        )

        // Additional insights would be loaded here...
    }

    func getInsight(for context: CulturalContext) -> CulturalInsight {
        return insights[context] ?? CulturalInsight(
            context: context,
            description: "Explore the rich traditions of \(context.displayName)",
            recommendedStyle: .traditional,
            authenticElements: [],
            traditionalColors: .traditional
        )
    }

    func getElements(for context: CulturalContext, style: RakhiGenre) -> [String] {
        let insight = getInsight(for: context)
        return insight.authenticElements
    }

    func getComplementaryElements(for elementId: String, in context: CulturalContext) -> [String] {
        // Return elements that complement the given element
        switch elementId.lowercased() {
        case "om": return ["lotus petals", "sacred geometry", "divine light"]
        case "lotus": return ["Om symbol", "sacred water", "spiritual energy"]
        case "dragon": return ["phoenix", "prosperity coins", "cloud patterns"]
        default: return ["traditional patterns", "cultural symbols"]
        }
    }

    func getSeasonalElements(for context: CulturalContext, season: String) -> [String] {
        switch (context, season) {
        case (.diwali, "autumn"): return ["harvest symbols", "autumn leaves", "warm lighting"]
        case (.chineseNewYear, "winter"): return ["plum blossoms", "winter symbols", "renewal elements"]
        default: return []
        }
    }

    func getSeasonalColors(for context: CulturalContext, season: String) -> ColorPalette {
        switch season {
        case "spring": return .pastel
        case "summer": return .vibrant
        case "autumn": return .earthy
        case "winter": return .traditional
        default: return .traditional
        }
    }
}

struct CulturalInsight {
    let context: CulturalContext
    let description: String
    let recommendedStyle: RakhiGenre
    let authenticElements: [String]
    let traditionalColors: ColorPalette
}

class UserSimilarityEngine {
    func findSimilarUsers(to profile: CulturalProfile) async -> [SimilarUser] {
        // This would implement collaborative filtering to find similar users
        // For now, return mock data
        return [
            SimilarUser(
                userId: "similar_user_1",
                similarity: 0.8,
                sharedPreferences: ["traditional style", "spiritual elements"]
            ),
            SimilarUser(
                userId: "similar_user_2",
                similarity: 0.7,
                sharedPreferences: ["vibrant colors", "modern style"]
            )
        ]
    }
}

// MARK: - Social Sharing Integration Types



