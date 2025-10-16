import Foundation
import SwiftUI

// MARK: - Social Sharing Platform Types
// Note: Core cultural types are now imported from SharedCulturalTypes.swift

struct PlatformRecommendation: Codable {
    let platform: SharePlatform
    let suitabilityScore: Double
    let reasoningFactors: [String]
    let optimizationSuggestions: [String]
}

struct ShareRecommendation: Identifiable, Codable {
    let id: UUID
    let culturalContext: CulturalContext
    let recommendationType: String
    let title: String
    let description: String
    let actionText: String
    let relevanceScore: Double
    let platforms: [SharePlatform]
    let culturalInsights: [String]
    let personalizedElements: [String]

    init(culturalContext: CulturalContext, recommendationType: String, title: String, description: String, actionText: String, relevanceScore: Double, platforms: [SharePlatform], culturalInsights: [String], personalizedElements: [String]) {
        self.id = UUID()
        self.culturalContext = culturalContext
        self.recommendationType = recommendationType
        self.title = title
        self.description = description
        self.actionText = actionText
        self.relevanceScore = relevanceScore
        self.platforms = platforms
        self.culturalInsights = culturalInsights
        self.personalizedElements = personalizedElements
    }
}

// MARK: - Social Sharing Analytics Types
// Note: SharingIntent, ShareRecord, EngagementMetrics now defined in SharedCulturalTypes.swift

// MARK: - Community and Analytics Types
// Note: CommunityInsight, CulturalTrend, SharingPreferences now defined in SharedCulturalTypes.swift
