import Foundation
import SwiftUI

// MARK: - Shared Cultural Types
// This file provides canonical definitions for all cultural types to eliminate duplicates

// MARK: - Cultural Context Enum (Canonical Definition)

enum CulturalContext: String, CaseIterable, Codable, Hashable {
    case rakshabandhan = "raksha_bandhan"
    case diwali = "diwali"
    case holi = "holi"
    case chineseNewYear = "chinese_new_year"
    case midAutumnFestival = "mid_autumn_festival"
    case christmas = "christmas"
    case easter = "easter"
    case eidAlFitr = "eid_al_fitr"
    case eidAlAdha = "eid_al_adha"
    case vesakDay = "vesak_day"
    case roshHashanah = "rosh_hashanah"
    case hanukkah = "hanukkah"
    case birthday = "birthday"
    case anniversary = "anniversary"

    var displayName: String {
        switch self {
        case .rakshabandhan: return "Raksha Bandhan"
        case .diwali: return "Diwali"
        case .holi: return "Holi"
        case .chineseNewYear: return "Chinese New Year"
        case .midAutumnFestival: return "Mid-Autumn Festival"
        case .christmas: return "Christmas"
        case .easter: return "Easter"
        case .eidAlFitr: return "Eid al-Fitr"
        case .eidAlAdha: return "Eid al-Adha"
        case .vesakDay: return "Vesak Day"
        case .roshHashanah: return "Rosh Hashanah"
        case .hanukkah: return "Hanukkah"
        case .birthday: return "Birthday"
        case .anniversary: return "Anniversary"
        }
    }
}

// MARK: - Cultural Profile (Canonical Definition)

struct CulturalProfile: Identifiable, Codable {
    let id: UUID
    let userId: String
    let primaryCulturalContexts: [CulturalContext]
    let culturalAffinities: [CulturalContext: Double]
    let behaviorPatterns: [BehaviorPattern]
    let learningProgress: PersonalizationProgress
    let lastUpdated: Date

    // Social sharing specific properties
    let preferredContexts: [CulturalContext]
    let culturalBackground: [CulturalContext]
    let sharingPreferences: SharingPreferences?
    let interactionHistory: [CulturalInteraction]
    let personalizedInsights: [String]

    init(userId: String,
         primaryCulturalContexts: [CulturalContext] = [],
         culturalAffinities: [CulturalContext: Double] = [:],
         behaviorPatterns: [BehaviorPattern] = [],
         learningProgress: PersonalizationProgress = PersonalizationProgress(),
         preferredContexts: [CulturalContext] = [],
         culturalBackground: [CulturalContext] = [],
         sharingPreferences: SharingPreferences? = nil,
         interactionHistory: [CulturalInteraction] = [],
         personalizedInsights: [String] = []) {
        self.id = UUID()
        self.userId = userId
        self.primaryCulturalContexts = primaryCulturalContexts
        self.culturalAffinities = culturalAffinities
        self.behaviorPatterns = behaviorPatterns
        self.learningProgress = learningProgress
        self.preferredContexts = preferredContexts
        self.culturalBackground = culturalBackground
        self.sharingPreferences = sharingPreferences
        self.interactionHistory = interactionHistory
        self.personalizedInsights = personalizedInsights
        self.lastUpdated = Date()
    }
}

// MARK: - Cultural Interaction (Canonical Definition)

struct CulturalInteraction: Identifiable, Codable {
    let id: UUID
    let culturalContext: CulturalContext
    let interactionType: InteractionType
    let elements: [String]
    let colorPalette: ColorPalette
    let stylePreference: RakhiGenre?
    let timestamp: Date
    var satisfactionScore: Double // 0.0 to 1.0
    var culturalAuthenticityScore: Double // 0.0 to 1.0

    // Social sharing specific properties
    let engagementLevel: Double
    let platforms: [SharePlatform]

    enum InteractionType: String, Codable {
        case giftCreation
        case browsing
        case sharing
        case customization
    }

    init(culturalContext: CulturalContext,
         interactionType: InteractionType,
         elements: [String] = [],
         colorPalette: ColorPalette,
         stylePreference: RakhiGenre? = nil,
         satisfactionScore: Double = 0.5,
         culturalAuthenticityScore: Double = 0.5,
         engagementLevel: Double = 0.5,
         platforms: [SharePlatform] = []) {
        self.id = UUID()
        self.culturalContext = culturalContext
        self.interactionType = interactionType
        self.elements = elements
        self.colorPalette = colorPalette
        self.stylePreference = stylePreference
        self.timestamp = Date()
        self.satisfactionScore = satisfactionScore
        self.culturalAuthenticityScore = culturalAuthenticityScore
        self.engagementLevel = engagementLevel
        self.platforms = platforms
    }
}

// MARK: - Cultural Recommendation (Canonical Definition)

struct CulturalRecommendation: Identifiable, Codable {
    let id: UUID
    let type: RecommendationType
    let culturalContext: CulturalContext
    let title: String
    let description: String
    let confidenceScore: Double
    let data: [String: String]
    let timestamp: Date
    let actionText: String?
    let relevanceScore: Double?
    let expiresAt: Date?

    enum RecommendationType: String, Codable {
        case style
        case elements
        case colors
        case timing
        case cultural
    }

    init(type: RecommendationType,
         culturalContext: CulturalContext,
         title: String,
         description: String,
         confidenceScore: Double,
         data: [String: String] = [:],
         actionText: String? = nil,
         relevanceScore: Double? = nil,
         expiresAt: Date? = nil) {
        self.id = UUID()
        self.type = type
        self.culturalContext = culturalContext
        self.title = title
        self.description = description
        self.confidenceScore = confidenceScore
        self.data = data
        self.timestamp = Date()
        self.actionText = actionText
        self.relevanceScore = relevanceScore
        self.expiresAt = expiresAt
    }
}

// MARK: - Share Record (Canonical Definition)

struct ShareRecord: Identifiable, Codable {
    let id: UUID
    let platform: SharePlatform
    let culturalContext: CulturalContext
    let timestamp: Date
    let success: Bool
    let engagementMetrics: EngagementMetrics?

    // Legacy compatibility
    let rakhiId: UUID?
    let culturalScore: Double?

    init(platform: SharePlatform,
         culturalContext: CulturalContext,
         success: Bool,
         engagementMetrics: EngagementMetrics? = nil,
         rakhiId: UUID? = nil,
         culturalScore: Double? = nil) {
        self.id = UUID()
        self.platform = platform
        self.culturalContext = culturalContext
        self.timestamp = Date()
        self.success = success
        self.engagementMetrics = engagementMetrics
        self.rakhiId = rakhiId
        self.culturalScore = culturalScore
    }
}

// MARK: - Sharing Intent (Canonical Definition)

enum SharingIntent: String, Codable, CaseIterable {
    case celebration = "celebration"
    case gifting = "gifting"
    case culturalEducation = "cultural_education"
    case communitySharing = "community_sharing"
    case personalExpression = "personal_expression"
}

// MARK: - Supporting Types

struct PersonalizationProgress: Codable {
    var totalInteractions: Int = 0
    var culturalContextsCovered: Int = 0
    var confidenceScore: Double = 0.0
    var startDate: Date = Date()
}

enum BehaviorPattern: Codable {
    case timePreference(TimePreferenceData)
    case stylePreference(StylePreferenceData)
    case elementPreference(ElementPreferenceData)
    case colorPreference(ColorPreferenceData)
}

struct TimePreferenceData: Codable {
    var preferredHours: [Int: Int] = [:]
    var preferredDays: [Int: Int] = [:]
}

struct StylePreferenceData: Codable {
    var styleFrequency: [RakhiGenre: Int] = [:]
}

struct ElementPreferenceData: Codable {
    var elementFrequency: [String: Int] = [:]
}

struct ColorPreferenceData: Codable {
    var paletteFrequency: [ColorPalette: Int] = [:]
}

// MARK: - Social Sharing Supporting Types

enum SharePlatform: String, CaseIterable, Codable {
    case whatsapp = "WhatsApp"
    case instagram = "Instagram"
    case facebook = "Facebook"
    case twitter = "Twitter"
    case email = "Email"
    case messages = "Messages"
    case other = "Other"
}

struct SharingPreferences: Codable {
    let preferredPlatforms: [SharePlatform]
    let optimalTiming: [String]
    let contentStyle: String
    let privacyLevel: String
    let culturalSensitivity: Double
}

struct EngagementMetrics: Codable {
    let views: Int
    let likes: Int
    let shares: Int
    let comments: Int
    let culturalRelevanceScore: Double
}

struct CommunityInsight: Identifiable, Codable {
    let id: UUID
    let content: String
    let relevance: Double
    let timestamp: Date
    
    // Extended properties for cultural context
    let culturalContext: CulturalContext?
    let insightType: String?
    let title: String?
    let description: String?
    let relevanceScore: Double?

    init(id: UUID = UUID(), content: String, relevance: Double, timestamp: Date, culturalContext: CulturalContext? = nil, insightType: String? = nil, title: String? = nil, description: String? = nil, relevanceScore: Double? = nil) {
        self.id = id
        self.content = content
        self.relevance = relevance
        self.timestamp = timestamp
        self.culturalContext = culturalContext
        self.insightType = insightType
        self.title = title
        self.description = description
        self.relevanceScore = relevanceScore
    }
}

struct CulturalTrend: Identifiable, Codable {
    let id: UUID
    let name: String
    let popularity: Double
    let timestamp: Date
    
    // Extended properties for cultural context
    let culturalContext: CulturalContext?
    let trendType: String?
    let title: String?
    let description: String?
    let platforms: [SharePlatform]?

    init(id: UUID = UUID(), name: String, popularity: Double, timestamp: Date, culturalContext: CulturalContext? = nil, trendType: String? = nil, title: String? = nil, description: String? = nil, platforms: [SharePlatform]? = nil) {
        self.id = id
        self.name = name
        self.popularity = popularity
        self.timestamp = timestamp
        self.culturalContext = culturalContext
        self.trendType = trendType
        self.title = title
        self.description = description
        self.platforms = platforms
    }
}

// MARK: - Personalization Supporting Types

struct PersonalizationInsights {
    let totalInteractions: Int
    let culturalContextsCovered: Int
    let confidenceScore: Double
    let topCulturalAffinities: [CulturalContext]
    let learningTrends: [LearningTrend]
}

struct LearningTrend {
    let category: TrendCategory
    let description: String
    let trend: TrendDirection
    let confidence: Double

    enum TrendCategory {
        case culturalInterest
        case stylePreference
        case colorPreference
        case usagePattern
    }

    enum TrendDirection {
        case increasing
        case decreasing
        case stable
    }
}

// MARK: - Lazy Loading Strategy Type

struct LazyLoadingStrategy {
    let priority: LoadingPriority
    let batchSize: Int
    let preloadCultures: Set<CulturalContext>
    var lazyLoadComponents: [String] = []
    var eagerLoadComponents: [String] = []
    var recommendedBatchSize: Int = 3

    enum LoadingPriority {
        case low
        case normal
        case high
        case critical
    }
}

// MARK: - Service Protocols for Dependency Safety
// Canonical protocol definitions to prevent duplicate declarations across services

protocol PersonalizationServiceProtocol {
    var userCulturalProfile: CulturalProfile? { get }
    func updateCulturalPreferences(_ preferences: [CulturalContext: Double])
    func getCulturalRecommendations() -> [CulturalRecommendation]
    func getCulturalRecommendations(for context: CulturalContext) -> [CulturalRecommendation]
    func updateCulturalInteraction(_ interaction: CulturalInteraction) async
}

protocol CulturalRecommendationEngineProtocol {
    func getCulturalRecommendations(for context: CulturalContext) -> [CulturalRecommendation]
}

// MARK: - Additional Types for Social Sharing Service
// Note: ShareRecommendation is defined in SocialSharingModels.swift

// Import necessary frameworks for Core Graphics support
import CoreGraphics
import UIKit

// Note: RakhiGenre and ColorPalette are defined in RakhiDesignModels.swift
// They are imported via the existing model files to avoid duplicate definitions
