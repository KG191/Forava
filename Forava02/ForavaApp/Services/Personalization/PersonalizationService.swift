import Foundation
import SwiftUI
import Combine

// MARK: - Cultural Personalization Service
@MainActor
class PersonalizationService: ObservableObject {
    static let shared = PersonalizationService()
    
    @Published var userCulturalProfile: CulturalProfile?
    @Published var personalizedRecommendations: [CulturalRecommendation] = []
    @Published var learningProgress: PersonalizationProgress
    @Published var culturalAffinities: [CulturalContext: Double] = [:]
    
    private var culturalPreferenceHistory: [CulturalInteraction] = []
    private var userBehaviorPatterns: [BehaviorPattern] = []
    private let userDefaults = UserDefaults.standard
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        self.learningProgress = PersonalizationProgress()
        loadUserCulturalProfile()
        loadCulturalPreferenceHistory()
        updateCulturalAffinities()
    }
    
    // MARK: - Cultural Preference Learning
    
    func recordCulturalInteraction(_ interaction: CulturalInteraction) {
        culturalPreferenceHistory.append(interaction)
        
        // Limit history to last 500 interactions for performance
        if culturalPreferenceHistory.count > 500 {
            culturalPreferenceHistory.removeFirst()
        }
        
        // Update cultural affinities based on interaction
        updateCulturalAffinityFor(interaction.culturalContext, interaction: interaction)
        
        // Update behavior patterns
        updateBehaviorPatternsFrom(interaction)
        
        // Save updates
        saveCulturalPreferenceHistory()
        updateUserCulturalProfile()
    }
    
    func recordGiftCreation(_ gift: GeneratedRakhi, culturalContext: CulturalContext) {
        let interaction = CulturalInteraction(
            id: UUID(),
            culturalContext: culturalContext,
            interactionType: .giftCreation,
            elements: gift.designSpec.elements.map { $0.id },
            colorPalette: gift.designSpec.colorPalette,
            stylePreference: gift.designSpec.genre,
            timestamp: Date(),
            satisfactionScore: 0.8, // Default, can be updated based on user feedback
            culturalAuthenticityScore: gift.culturalScore
        )
        
        recordCulturalInteraction(interaction)
    }
    
    func recordUserFeedback(for giftId: UUID, satisfaction: Double, culturalAccuracy: Double) {
        // Find and update the corresponding interaction
        if let index = culturalPreferenceHistory.firstIndex(where: { 
            $0.interactionType == .giftCreation && $0.timestamp > Date().addingTimeInterval(-3600) // Last hour
        }) {
            culturalPreferenceHistory[index].satisfactionScore = satisfaction
            culturalPreferenceHistory[index].culturalAuthenticityScore = culturalAccuracy
            
            // Adjust learning based on feedback
            adjustLearningFromFeedback(culturalPreferenceHistory[index])
        }
    }
    
    // MARK: - Cultural Affinity Calculation
    
    private func updateCulturalAffinityFor(_ context: CulturalContext, interaction: CulturalInteraction) {
        let currentAffinity = culturalAffinities[context] ?? 0.5
        
        // Calculate affinity adjustment based on interaction quality
        let affinityAdjustment = calculateAffinityAdjustment(interaction)
        
        // Apply weighted learning (recent interactions have more impact)
        let timeWeight = calculateTimeWeight(interaction.timestamp)
        let newAffinity = currentAffinity + (affinityAdjustment * timeWeight * 0.1)
        
        // Clamp between 0.0 and 1.0
        culturalAffinities[context] = max(0.0, min(1.0, newAffinity))
        
        // Update learning progress
        learningProgress.totalInteractions += 1
        learningProgress.culturalContextsCovered = Set(culturalAffinities.keys).count
        learningProgress.confidenceScore = calculateOverallConfidence()
    }
    
    private func calculateAffinityAdjustment(_ interaction: CulturalInteraction) -> Double {
        var adjustment = 0.0
        
        // Base adjustment from satisfaction
        adjustment += (interaction.satisfactionScore - 0.5) * 0.5
        
        // Bonus for high cultural authenticity
        if interaction.culturalAuthenticityScore > 0.8 {
            adjustment += 0.2
        }
        
        // Adjustment based on interaction type
        switch interaction.interactionType {
        case .giftCreation:
            adjustment += 0.1 // Creating gifts shows strong interest
        case .browsing:
            adjustment += 0.05 // Browsing shows mild interest
        case .sharing:
            adjustment += 0.15 // Sharing shows very strong interest
        case .customization:
            adjustment += 0.12 // Customization shows engagement
        }
        
        return adjustment
    }
    
    private func calculateTimeWeight(_ timestamp: Date) -> Double {
        let daysSince = Date().timeIntervalSince(timestamp) / 86400 // Days
        return exp(-daysSince * 0.1) // Exponential decay over time
    }
    
    private func calculateOverallConfidence() -> Double {
        guard !culturalAffinities.isEmpty else { return 0.0 }
        
        let totalInteractions = Double(culturalPreferenceHistory.count)
        let uniqueContexts = Double(culturalAffinities.count)
        
        // Confidence increases with interactions and diversity
        let interactionFactor = min(1.0, totalInteractions / 50.0) // Confidence builds over 50 interactions
        let diversityFactor = min(1.0, uniqueContexts / 8.0) // Confidence with 8+ cultural contexts
        
        return (interactionFactor * 0.7) + (diversityFactor * 0.3)
    }
    
    // MARK: - Behavior Pattern Analysis
    
    private func updateBehaviorPatternsFrom(_ interaction: CulturalInteraction) {
        // Analyze time patterns
        updateTimePreferences(interaction)
        
        // Analyze style preferences
        updateStylePreferences(interaction)
        
        // Analyze element preferences
        updateElementPreferences(interaction)
        
        // Analyze color preferences
        updateColorPreferences(interaction)
    }
    
    private func updateTimePreferences(_ interaction: CulturalInteraction) {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: interaction.timestamp)
        let dayOfWeek = calendar.component(.weekday, from: interaction.timestamp)
        
        // Find or create time pattern
        if let index = userBehaviorPatterns.firstIndex(where: { 
            if case .timePreference = $0 { return true }
            return false
        }) {
            // Update existing pattern
            if case .timePreference(var data) = userBehaviorPatterns[index] {
                data.preferredHours[hour] = (data.preferredHours[hour] ?? 0) + 1
                data.preferredDays[dayOfWeek] = (data.preferredDays[dayOfWeek] ?? 0) + 1
                userBehaviorPatterns[index] = .timePreference(data)
            }
        } else {
            // Create new pattern
            var timeData = TimePreferenceData()
            timeData.preferredHours[hour] = 1
            timeData.preferredDays[dayOfWeek] = 1
            userBehaviorPatterns.append(.timePreference(timeData))
        }
    }
    
    private func updateStylePreferences(_ interaction: CulturalInteraction) {
        if let style = interaction.stylePreference {
            if let index = userBehaviorPatterns.firstIndex(where: { 
                if case .stylePreference = $0 { return true }
                return false
            }) {
                if case .stylePreference(var data) = userBehaviorPatterns[index] {
                    data.styleFrequency[style] = (data.styleFrequency[style] ?? 0) + 1
                    userBehaviorPatterns[index] = .stylePreference(data)
                }
            } else {
                var styleData = StylePreferenceData()
                styleData.styleFrequency[style] = 1
                userBehaviorPatterns.append(.stylePreference(styleData))
            }
        }
    }
    
    private func updateElementPreferences(_ interaction: CulturalInteraction) {
        for elementId in interaction.elements {
            if let index = userBehaviorPatterns.firstIndex(where: { 
                if case .elementPreference = $0 { return true }
                return false
            }) {
                if case .elementPreference(var data) = userBehaviorPatterns[index] {
                    data.elementFrequency[elementId] = (data.elementFrequency[elementId] ?? 0) + 1
                    userBehaviorPatterns[index] = .elementPreference(data)
                }
            } else {
                var elementData = ElementPreferenceData()
                elementData.elementFrequency[elementId] = 1
                userBehaviorPatterns.append(.elementPreference(elementData))
            }
        }
    }
    
    private func updateColorPreferences(_ interaction: CulturalInteraction) {
        if let index = userBehaviorPatterns.firstIndex(where: { 
            if case .colorPreference = $0 { return true }
            return false
        }) {
            if case .colorPreference(var data) = userBehaviorPatterns[index] {
                data.paletteFrequency[interaction.colorPalette] = (data.paletteFrequency[interaction.colorPalette] ?? 0) + 1
                userBehaviorPatterns[index] = .colorPreference(data)
            }
        } else {
            var colorData = ColorPreferenceData()
            colorData.paletteFrequency[interaction.colorPalette] = 1
            userBehaviorPatterns.append(.colorPreference(colorData))
        }
    }
    
    // MARK: - Personalized Recommendations
    
    func generatePersonalizedRecommendations(for context: CulturalContext? = nil) -> [CulturalRecommendation] {
        var recommendations: [CulturalRecommendation] = []
        
        // Get user's strongest cultural affinities
        let topAffinities = culturalAffinities.sorted { $0.value > $1.value }.prefix(3)
        
        for (culturalContext, affinity) in topAffinities {
            if let specifiedContext = context, specifiedContext != culturalContext {
                continue // Skip if looking for specific context
            }
            
            // Generate recommendations based on behavior patterns
            let styleRecommendations = generateStyleRecommendations(for: culturalContext, affinity: affinity)
            let elementRecommendations = generateElementRecommendations(for: culturalContext, affinity: affinity)
            let colorRecommendations = generateColorRecommendations(for: culturalContext, affinity: affinity)
            
            recommendations.append(contentsOf: styleRecommendations)
            recommendations.append(contentsOf: elementRecommendations)
            recommendations.append(contentsOf: colorRecommendations)
        }
        
        // Sort by confidence and relevance
        recommendations.sort { $0.confidenceScore > $1.confidenceScore }
        
        // Limit to top 10 recommendations
        let topRecommendations = Array(recommendations.prefix(10))
        
        // Update published property
        DispatchQueue.main.async {
            self.personalizedRecommendations = topRecommendations
        }
        
        return topRecommendations
    }
    
    private func generateStyleRecommendations(for context: CulturalContext, affinity: Double) -> [CulturalRecommendation] {
        // Find user's preferred styles
        guard let stylePattern = userBehaviorPatterns.first(where: { 
            if case .stylePreference = $0 { return true }
            return false
        }) else { return [] }
        
        if case .stylePreference(let data) = stylePattern {
            let topStyles = data.styleFrequency.sorted { $0.value > $1.value }.prefix(2)
            
            return topStyles.map { style, frequency in
                CulturalRecommendation(
                    id: UUID(),
                    type: .style,
                    culturalContext: context,
                    title: "Try \(style.displayName) Style",
                    description: "Based on your preferences, you might enjoy creating gifts in \(style.displayName.lowercased()) style for \(context.displayName)",
                    confidenceScore: min(0.95, affinity * 0.7 + (Double(frequency) / 10.0)),
                    data: ["style": style.rawValue],
                    timestamp: Date()
                )
            }
        }
        
        return []
    }
    
    private func generateElementRecommendations(for context: CulturalContext, affinity: Double) -> [CulturalRecommendation] {
        guard let elementPattern = userBehaviorPatterns.first(where: { 
            if case .elementPreference = $0 { return true }
            return false
        }) else { return [] }
        
        if case .elementPreference(let data) = elementPattern {
            let topElements = data.elementFrequency.sorted { $0.value > $1.value }.prefix(3)
            
            return topElements.compactMap { elementId, frequency in
                // Create recommendations for complementary elements
                CulturalRecommendation(
                    id: UUID(),
                    type: .elements,
                    culturalContext: context,
                    title: "Combine with \(elementId)",
                    description: "You often use \(elementId) - try pairing it with culturally authentic elements for \(context.displayName)",
                    confidenceScore: min(0.85, affinity * 0.6 + (Double(frequency) / 8.0)),
                    data: ["elementId": elementId, "category": "complementary"],
                    timestamp: Date()
                )
            }
        }
        
        return []
    }
    
    private func generateColorRecommendations(for context: CulturalContext, affinity: Double) -> [CulturalRecommendation] {
        guard let colorPattern = userBehaviorPatterns.first(where: { 
            if case .colorPreference = $0 { return true }
            return false
        }) else { return [] }
        
        if case .colorPreference(let data) = colorPattern {
            let topPalettes = data.paletteFrequency.sorted { $0.value > $1.value }.prefix(2)
            
            return topPalettes.map { palette, frequency in
                CulturalRecommendation(
                    id: UUID(),
                    type: .colors,
                    culturalContext: context,
                    title: "Explore \(palette.displayName) Variations",
                    description: "Discover new \(palette.displayName.lowercased()) color combinations perfect for \(context.displayName) celebrations",
                    confidenceScore: min(0.80, affinity * 0.5 + (Double(frequency) / 6.0)),
                    data: ["palette": palette.rawValue],
                    timestamp: Date()
                )
            }
        }
        
        return []
    }
    
    // MARK: - Cultural Profile Management
    
    private func updateUserCulturalProfile() {
        let profile = CulturalProfile(
            userId: getUserId(),
            primaryCulturalContexts: getTopCulturalContexts(),
            culturalAffinities: culturalAffinities,
            behaviorPatterns: userBehaviorPatterns,
            learningProgress: learningProgress,
            lastUpdated: Date()
        )
        
        userCulturalProfile = profile
        saveCulturalProfile(profile)
    }
    
    private func getTopCulturalContexts() -> [CulturalContext] {
        return culturalAffinities
            .filter { $0.value > 0.6 } // Only include strong affinities
            .sorted { $0.value > $1.value }
            .prefix(5)
            .map { $0.key }
    }
    
    private func adjustLearningFromFeedback(_ interaction: CulturalInteraction) {
        // Adjust cultural affinity based on explicit feedback
        let feedbackWeight = 0.3 // Strong weight for explicit feedback
        let currentAffinity = culturalAffinities[interaction.culturalContext] ?? 0.5
        
        let feedbackAdjustment = (interaction.satisfactionScore - 0.5) * feedbackWeight
        let newAffinity = max(0.0, min(1.0, currentAffinity + feedbackAdjustment))
        
        culturalAffinities[interaction.culturalContext] = newAffinity
        
        // Update confidence based on feedback accuracy
        if interaction.culturalAuthenticityScore > 0.8 && interaction.satisfactionScore > 0.7 {
            learningProgress.confidenceScore = min(1.0, learningProgress.confidenceScore + 0.05)
        }
    }
    
    // MARK: - Data Persistence
    
    private func loadUserCulturalProfile() {
        if let data = userDefaults.data(forKey: "UserCulturalProfile"),
           let profile = try? JSONDecoder().decode(CulturalProfile.self, from: data) {
            userCulturalProfile = profile
            culturalAffinities = profile.culturalAffinities
            userBehaviorPatterns = profile.behaviorPatterns
            learningProgress = profile.learningProgress
        }
    }
    
    private func saveCulturalProfile(_ profile: CulturalProfile) {
        if let data = try? JSONEncoder().encode(profile) {
            userDefaults.set(data, forKey: "UserCulturalProfile")
        }
    }
    
    private func loadCulturalPreferenceHistory() {
        if let data = userDefaults.data(forKey: "CulturalPreferenceHistory"),
           let history = try? JSONDecoder().decode([CulturalInteraction].self, from: data) {
            culturalPreferenceHistory = history
        }
    }
    
    private func saveCulturalPreferenceHistory() {
        if let data = try? JSONEncoder().encode(culturalPreferenceHistory) {
            userDefaults.set(data, forKey: "CulturalPreferenceHistory")
        }
    }
    
    private func updateCulturalAffinities() {
        // Analyze existing history to build initial affinities
        for interaction in culturalPreferenceHistory {
            updateCulturalAffinityFor(interaction.culturalContext, interaction: interaction)
        }
    }
    
    private func getUserId() -> String {
        if let userId = userDefaults.string(forKey: "UserId") {
            return userId
        } else {
            let newUserId = UUID().uuidString
            userDefaults.set(newUserId, forKey: "UserId")
            return newUserId
        }
    }
    
    // MARK: - Public API
    
    func getCulturalAffinity(for context: CulturalContext) -> Double {
        return culturalAffinities[context] ?? 0.5
    }
    
    func getPreferredStyleFor(_ context: CulturalContext) -> RakhiGenre? {
        guard let stylePattern = userBehaviorPatterns.first(where: { 
            if case .stylePreference = $0 { return true }
            return false
        }) else { return nil }
        
        if case .stylePreference(let data) = stylePattern {
            return data.styleFrequency.max { $0.value < $1.value }?.key
        }
        
        return nil
    }
    
    func getPersonalizationInsights() -> PersonalizationInsights {
        return PersonalizationInsights(
            totalInteractions: learningProgress.totalInteractions,
            culturalContextsCovered: learningProgress.culturalContextsCovered,
            confidenceScore: learningProgress.confidenceScore,
            topCulturalAffinities: getTopCulturalContexts(),
            learningTrends: calculateLearningTrends()
        )
    }
    
    private func calculateLearningTrends() -> [LearningTrend] {
        // Analyze trends in user preferences over time
        let last30Days = culturalPreferenceHistory.filter { 
            $0.timestamp > Date().addingTimeInterval(-30 * 24 * 3600)
        }
        
        var trends: [LearningTrend] = []
        
        // Cultural context trends
        let contextCounts = Dictionary(grouping: last30Days) { $0.culturalContext }
            .mapValues { $0.count }
        
        for (context, count) in contextCounts.sorted(by: { $0.value > $1.value }).prefix(3) {
            trends.append(LearningTrend(
                category: .culturalInterest,
                description: "Increased interest in \(context.displayName)",
                trend: .increasing,
                confidence: min(1.0, Double(count) / 10.0)
            ))
        }
        
        return trends
    }
}

// MARK: - Supporting Types
// Note: Core cultural types are now imported from SharedCulturalTypes.swift