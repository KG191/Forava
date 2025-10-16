import Foundation
import SwiftUI
import Combine

// MARK: - Cultural Prompt Mapper for Adaptive AI Prompts
@MainActor
class CulturalPromptMapper: ObservableObject {
    static let shared = CulturalPromptMapper()
    
    @Published var isAnalyzing = false
    @Published var adaptationProgress: Float = 0.0
    
    private let basePromptMapper = PromptMapper.shared
    private var culturalPromptTemplates: [CulturalContext: CulturalPromptTemplate] = [:]
    private var userPersonalityPrompts: [String: PersonalityPromptModifier] = [:]
    
    private init() {
        loadCulturalPromptTemplates()
        loadPersonalityPrompts()
    }
    
    // MARK: - Adaptive Prompt Generation
    
    func buildPersonalizedPrompt(
        from designSpec: RakhiDesignSpec,
        culturalContext: CulturalContext,
        userProfile: CulturalProfile?
    ) async throws -> PersonalizedAIPrompt {
        
        isAnalyzing = true
        adaptationProgress = 0.0
        
        defer {
            isAnalyzing = false
            adaptationProgress = 0.0
        }
        
        // Step 1: Get base prompt from existing system
        adaptationProgress = 0.2
        let basePrompt = await basePromptMapper.buildAdvancedPrompt(from: designSpec)
        
        // Step 2: Analyze user cultural preferences
        adaptationProgress = 0.4
        let culturalPersonalization = analyzeCulturalPersonalization(
            context: culturalContext,
            profile: userProfile
        )
        
        // Step 3: Apply personality-driven modifications
        adaptationProgress = 0.6
        let personalityModifications = applyPersonalityModifications(
            basePrompt: basePrompt,
            culturalPersonalization: culturalPersonalization,
            designSpec: designSpec
        )
        
        // Step 4: Integrate cultural authenticity enhancements
        adaptationProgress = 0.8
        let culturallyEnhancedPrompt = integrateCulturalAuthenticity(
            prompt: personalityModifications,
            context: culturalContext,
            userProfile: userProfile
        )
        
        // Step 5: Apply user preference learning
        adaptationProgress = 1.0
        let finalPersonalizedPrompt = applyPreferenceLearning(
            prompt: culturallyEnhancedPrompt,
            designSpec: designSpec,
            userProfile: userProfile
        )
        
        return finalPersonalizedPrompt
    }
    
    // MARK: - Cultural Personalization Analysis
    
    private func analyzeCulturalPersonalization(
        context: CulturalContext,
        profile: CulturalProfile?
    ) -> CulturalPersonalization {
        
        // TODO: Integrate with PersonalizationService once compilation dependencies are resolved
        let culturalAffinity = getCulturalAffinityFallback(for: context)
        let preferredStyle = getPreferredStyleFallback(for: context)
        
        // Determine user's cultural familiarity level
        let familiarityLevel = calculateCulturalFamiliarityLevel(
            context: context,
            affinity: culturalAffinity,
            profile: profile
        )
        
        // Analyze traditional vs modern preference
        let modernityPreference = calculateModernityPreference(
            context: context,
            profile: profile
        )
        
        // Determine authenticity preference level
        let authenticityImportance = calculateAuthenticityImportance(
            context: context,
            profile: profile
        )
        
        return CulturalPersonalization(
            culturalContext: context,
            familiarityLevel: familiarityLevel,
            modernityPreference: modernityPreference,
            authenticityImportance: authenticityImportance,
            preferredStyle: preferredStyle,
            culturalAffinity: culturalAffinity
        )
    }
    
    private func calculateCulturalFamiliarityLevel(
        context: CulturalContext,
        affinity: Double,
        profile: CulturalProfile?
    ) -> CulturalFamiliarityLevel {
        
        guard let profile = profile else { return .beginner }
        
        let contextInteractions = profile.behaviorPatterns.compactMap { pattern -> Int? in
            // Count interactions with this cultural context
            switch pattern {
            case .stylePreference(let data):
                return data.styleFrequency.values.reduce(0, +)
            default:
                return nil
            }
        }.reduce(0, +)
        
        if contextInteractions > 20 && affinity > 0.8 {
            return .expert
        } else if contextInteractions > 10 && affinity > 0.6 {
            return .intermediate
        } else if contextInteractions > 3 && affinity > 0.4 {
            return .familiar
        } else {
            return .beginner
        }
    }
    
    private func calculateModernityPreference(
        context: CulturalContext,
        profile: CulturalProfile?
    ) -> ModernityPreference {
        
        guard let profile = profile else { return .balanced }
        
        // Analyze style preferences for modern vs traditional tendencies
        for pattern in profile.behaviorPatterns {
            if case .stylePreference(let data) = pattern {
                let modernCount = (data.styleFrequency[.modern] ?? 0) + (data.styleFrequency[.elegant] ?? 0)
                let traditionalCount = (data.styleFrequency[.traditional] ?? 0) + (data.styleFrequency[.spiritual] ?? 0)
                
                let totalCount = modernCount + traditionalCount
                guard totalCount > 0 else { continue }
                
                let modernRatio = Double(modernCount) / Double(totalCount)
                
                if modernRatio > 0.7 {
                    return .modern
                } else if modernRatio < 0.3 {
                    return .traditional
                } else {
                    return .balanced
                }
            }
        }
        
        return .balanced
    }
    
    private func calculateAuthenticityImportance(
        context: CulturalContext,
        profile: CulturalProfile?
    ) -> AuthenticityImportance {
        
        guard let profile = profile else { return .moderate }
        
        // High authenticity importance for primary cultural contexts
        if profile.primaryCulturalContexts.contains(context) {
            return .high
        }
        
        let affinity = profile.culturalAffinities[context] ?? 0.5
        
        if affinity > 0.8 {
            return .high
        } else if affinity > 0.5 {
            return .moderate
        } else {
            return .flexible
        }
    }
    
    // MARK: - Personality-Driven Modifications
    
    private func applyPersonalityModifications(
        basePrompt: AdvancedPrompt,
        culturalPersonalization: CulturalPersonalization,
        designSpec: RakhiDesignSpec
    ) -> AdvancedPrompt {
        
        var modifiedPrompt = basePrompt
        
        // Apply familiarity-based modifications
        modifiedPrompt = applyFamiliarityModifications(
            prompt: modifiedPrompt,
            familiarityLevel: culturalPersonalization.familiarityLevel,
            context: culturalPersonalization.culturalContext
        )
        
        // Apply modernity preference modifications
        modifiedPrompt = applyModernityModifications(
            prompt: modifiedPrompt,
            modernityPreference: culturalPersonalization.modernityPreference
        )
        
        // Apply authenticity importance modifications
        modifiedPrompt = applyAuthenticityModifications(
            prompt: modifiedPrompt,
            authenticityImportance: culturalPersonalization.authenticityImportance,
            context: culturalPersonalization.culturalContext
        )
        
        return modifiedPrompt
    }
    
    private func applyFamiliarityModifications(
        prompt: AdvancedPrompt,
        familiarityLevel: CulturalFamiliarityLevel,
        context: CulturalContext
    ) -> AdvancedPrompt {
        
        var modifiedPrompt = prompt
        
        switch familiarityLevel {
        case .beginner:
            // Add educational and explanatory elements
            modifiedPrompt.positive += ", educational cultural representation, clearly recognizable traditional symbols"
            modifiedPrompt.negative += ", overly complex symbolism, obscure cultural references"
            modifiedPrompt.technicalParameters = modifiedPrompt.technicalParameters.withCfgScale(min(modifiedPrompt.technicalParameters.cfg_scale + 1.0, 15.0))
            
        case .familiar:
            // Balance traditional and accessible elements
            modifiedPrompt.positive += ", culturally meaningful design, respectful traditional interpretation"
            modifiedPrompt.technicalParameters = modifiedPrompt.technicalParameters.withCfgScale(modifiedPrompt.technicalParameters.cfg_scale + 0.5)
            
        case .intermediate:
            // Add moderate cultural complexity
            modifiedPrompt.positive += ", nuanced cultural symbolism, deeper cultural meaning"
            
        case .expert:
            // Include sophisticated cultural elements
            modifiedPrompt.positive += ", sophisticated cultural interpretation, subtle cultural nuances, expert-level symbolism"
            modifiedPrompt.negative += ", oversimplified cultural elements"
            modifiedPrompt.technicalParameters = modifiedPrompt.technicalParameters.withCfgScale(max(modifiedPrompt.technicalParameters.cfg_scale - 1.0, 5.0))
        }
        
        return modifiedPrompt
    }
    
    private func applyModernityModifications(
        prompt: AdvancedPrompt,
        modernityPreference: ModernityPreference
    ) -> AdvancedPrompt {
        
        var modifiedPrompt = prompt
        
        switch modernityPreference {
        case .traditional:
            modifiedPrompt.positive += ", classical traditional design, heritage craftsmanship, time-honored techniques"
            modifiedPrompt.negative += ", modern elements, contemporary styling, futuristic design"
            
        case .modern:
            modifiedPrompt.positive += ", contemporary interpretation, modern aesthetic, sleek design, innovative styling"
            modifiedPrompt.negative += ", outdated elements, old-fashioned styling"
            
        case .balanced:
            modifiedPrompt.positive += ", harmonious blend of traditional and contemporary, timeless design"
            modifiedPrompt.negative += ", jarring modern elements, inappropriate traditional mixing"
        }
        
        return modifiedPrompt
    }
    
    private func applyAuthenticityModifications(
        prompt: AdvancedPrompt,
        authenticityImportance: AuthenticityImportance,
        context: CulturalContext
    ) -> AdvancedPrompt {
        
        var modifiedPrompt = prompt
        let contextTemplate = culturalPromptTemplates[context]
        
        switch authenticityImportance {
        case .high:
            modifiedPrompt.positive += ", (culturally authentic:1.4), (traditional accuracy:1.3), (cultural respect:1.3)"
            if let template = contextTemplate {
                modifiedPrompt.positive += ", " + template.authenticityEnhancers.joined(separator: ", ")
            }
            modifiedPrompt.negative += ", cultural appropriation, inauthentic elements, disrespectful representation"
            modifiedPrompt.technicalParameters = modifiedPrompt.technicalParameters.withCfgScale(min(modifiedPrompt.technicalParameters.cfg_scale + 2.0, 15.0))
            
        case .moderate:
            modifiedPrompt.positive += ", culturally respectful, authentic inspiration"
            modifiedPrompt.negative += ", cultural insensitivity"
            modifiedPrompt.technicalParameters = modifiedPrompt.technicalParameters.withCfgScale(modifiedPrompt.technicalParameters.cfg_scale + 1.0)
            
        case .flexible:
            modifiedPrompt.positive += ", creative interpretation, cultural inspiration"
            // More flexibility in cultural representation
        }
        
        return modifiedPrompt
    }
    
    // MARK: - Cultural Authenticity Integration
    
    private func integrateCulturalAuthenticity(
        prompt: AdvancedPrompt,
        context: CulturalContext,
        userProfile: CulturalProfile?
    ) -> AdvancedPrompt {
        
        guard let template = culturalPromptTemplates[context] else { return prompt }
        
        var enhancedPrompt = prompt
        
        // Add context-specific cultural elements
        enhancedPrompt.positive += ", " + template.coreElements.joined(separator: ", ")
        
        // Add cultural color guidance
        enhancedPrompt.positive += ", " + template.colorGuidance.joined(separator: ", ")
        
        // Add cultural symbols and meanings
        enhancedPrompt.positive += ", " + template.symbolismGuidance.joined(separator: ", ")
        
        // Add cultural taboos to negative prompt
        enhancedPrompt.negative += ", " + template.culturalTaboos.joined(separator: ", ")
        
        // Apply LoRA models for cultural accuracy
        enhancedPrompt.loraModels.append(contentsOf: template.recommendedLoRAs)
        
        return enhancedPrompt
    }
    
    // MARK: - User Preference Learning Application
    
    private func applyPreferenceLearning(
        prompt: AdvancedPrompt,
        designSpec: RakhiDesignSpec,
        userProfile: CulturalProfile?
    ) -> PersonalizedAIPrompt {
        
        var personalizedPrompt = PersonalizedAIPrompt(
            basePrompt: prompt,
            personalizationLevel: calculatePersonalizationLevel(userProfile),
            confidence: calculatePromptConfidence(userProfile),
            adaptationReasons: []
        )
        
        guard let profile = userProfile else {
            personalizedPrompt.adaptationReasons.append("No user profile available - using default settings")
            return personalizedPrompt
        }
        
        // Apply learned color preferences
        personalizedPrompt = applyColorPreferenceLearning(
            prompt: personalizedPrompt,
            profile: profile,
            designSpec: designSpec
        )
        
        // Apply learned element preferences
        personalizedPrompt = applyElementPreferenceLearning(
            prompt: personalizedPrompt,
            profile: profile,
            designSpec: designSpec
        )
        
        // Apply learned style preferences
        personalizedPrompt = applyStylePreferenceLearning(
            prompt: personalizedPrompt,
            profile: profile,
            designSpec: designSpec
        )
        
        // Apply time-based preferences (if relevant)
        personalizedPrompt = applyTimeBasedPreferences(
            prompt: personalizedPrompt,
            profile: profile
        )
        
        return personalizedPrompt
    }
    
    private func applyColorPreferenceLearning(
        prompt: PersonalizedAIPrompt,
        profile: CulturalProfile,
        designSpec: RakhiDesignSpec
    ) -> PersonalizedAIPrompt {
        
        var modifiedPrompt = prompt
        
        for pattern in profile.behaviorPatterns {
            if case .colorPreference(let data) = pattern {
                let topPalette = data.paletteFrequency.max { $0.value < $1.value }
                
                if let preferredPalette = topPalette, preferredPalette.value > 3 {
                    let paletteGuidance = generateColorPaletteGuidance(preferredPalette.key)
                    modifiedPrompt.basePrompt.positive += ", " + paletteGuidance
                    modifiedPrompt.adaptationReasons.append("Applied preferred \(preferredPalette.key.displayName) color palette")
                }
            }
        }
        
        return modifiedPrompt
    }
    
    private func applyElementPreferenceLearning(
        prompt: PersonalizedAIPrompt,
        profile: CulturalProfile,
        designSpec: RakhiDesignSpec
    ) -> PersonalizedAIPrompt {
        
        var modifiedPrompt = prompt
        
        for pattern in profile.behaviorPatterns {
            if case .elementPreference(let data) = pattern {
                let topElements = data.elementFrequency.sorted { $0.value > $1.value }.prefix(3)
                
                for (elementId, frequency) in topElements where frequency > 2 {
                    let elementGuidance = generateElementGuidance(elementId)
                    modifiedPrompt.basePrompt.positive += ", " + elementGuidance
                    modifiedPrompt.adaptationReasons.append("Enhanced \(elementId) based on usage pattern")
                }
            }
        }
        
        return modifiedPrompt
    }
    
    private func applyStylePreferenceLearning(
        prompt: PersonalizedAIPrompt,
        profile: CulturalProfile,
        designSpec: RakhiDesignSpec
    ) -> PersonalizedAIPrompt {
        
        var modifiedPrompt = prompt
        
        for pattern in profile.behaviorPatterns {
            if case .stylePreference(let data) = pattern {
                let topStyle = data.styleFrequency.max { $0.value < $1.value }
                
                if let preferredStyle = topStyle, preferredStyle.value > 3 {
                    let styleGuidance = generateStyleGuidance(preferredStyle.key)
                    modifiedPrompt.basePrompt.positive += ", " + styleGuidance
                    modifiedPrompt.adaptationReasons.append("Applied preferred \(preferredStyle.key.displayName) style characteristics")
                }
            }
        }
        
        return modifiedPrompt
    }
    
    private func applyTimeBasedPreferences(
        prompt: PersonalizedAIPrompt,
        profile: CulturalProfile
    ) -> PersonalizedAIPrompt {
        
        var modifiedPrompt = prompt
        
        // Apply seasonal or time-of-day preferences if relevant
        let currentHour = Calendar.current.component(.hour, from: Date())
        let _ = getCurrentSeason() // TODO: Implement seasonal modifications
        
        if currentHour >= 18 || currentHour <= 6 {
            // Evening/night time - might prefer warmer, more intimate designs
            modifiedPrompt.basePrompt.positive += ", warm ambient lighting, intimate atmosphere"
            modifiedPrompt.adaptationReasons.append("Applied evening time preferences")
        } else {
            // Daytime - might prefer brighter, more vibrant designs  
            modifiedPrompt.basePrompt.positive += ", bright natural lighting, vibrant colors"
            modifiedPrompt.adaptationReasons.append("Applied daytime preferences")
        }
        
        return modifiedPrompt
    }
    
    // MARK: - Helper Methods
    
    private func calculatePersonalizationLevel(_ profile: CulturalProfile?) -> PersonalizationLevel {
        guard let profile = profile else { return .basic }
        
        let interactionCount = profile.learningProgress.totalInteractions
        let confidence = profile.learningProgress.confidenceScore
        
        if interactionCount > 50 && confidence > 0.8 {
            return .advanced
        } else if interactionCount > 20 && confidence > 0.6 {
            return .intermediate
        } else if interactionCount > 5 {
            return .basic
        } else {
            return .minimal
        }
    }
    
    private func calculatePromptConfidence(_ profile: CulturalProfile?) -> Double {
        guard let profile = profile else { return 0.3 }
        
        let baseConfidence = profile.learningProgress.confidenceScore
        let diversityBonus = min(0.2, Double(profile.culturalAffinities.count) * 0.025)
        
        return min(1.0, baseConfidence + diversityBonus)
    }
    
    private func generateColorPaletteGuidance(_ palette: ColorPalette) -> String {
        switch palette {
        case .traditional:
            return "(rich traditional colors:1.2), saffron orange, deep red, golden yellow, sacred colors"
        case .vibrant:
            return "(vibrant saturated colors:1.2), bold color contrasts, energetic palette"
        case .modern:
            return "(contemporary color harmony:1.1), sleek color combinations, modern palette"
        case .pastel:
            return "(soft pastel tones:1.1), gentle color transitions, delicate hues"
        case .earthy:
            return "(natural earth tones:1.1), organic color palette, grounded colors"
        case .metallic:
            return "(metallic finishes:1.2), gold accents, silver highlights, lustrous colors"
        case .monochrome:
            return "(monochromatic scheme:1.1), tonal variations, minimalist color approach"
        }
    }
    
    private func generateElementGuidance(_ elementId: String) -> String {
        // This would be enhanced to map specific element IDs to guidance
        return "(enhanced \(elementId) detailing:1.1), prominent \(elementId) features"
    }
    
    private func generateStyleGuidance(_ style: RakhiGenre) -> String {
        switch style {
        case .traditional:
            return "(traditional craftsmanship:1.2), heritage design elements, classical techniques"
        case .modern:
            return "(contemporary design:1.2), innovative elements, modern aesthetics"
        case .elegant:
            return "(sophisticated elegance:1.2), refined details, graceful composition"
        case .spiritual:
            return "(spiritual significance:1.2), sacred geometry, divine symbolism"
        case .unknown:
            return "balanced design approach"
        }
    }
    
    private func getCurrentSeason() -> Season {
        let month = Calendar.current.component(.month, from: Date())
        
        switch month {
        case 12, 1, 2: return .winter
        case 3, 4, 5: return .spring
        case 6, 7, 8: return .summer
        case 9, 10, 11: return .autumn
        default: return .spring
        }
    }
    
    // MARK: - Data Loading
    
    private func loadCulturalPromptTemplates() {
        // Load cultural-specific prompt templates
        culturalPromptTemplates = [
            .rakshabandhan: CulturalPromptTemplate(
                context: .rakshabandhan,
                coreElements: [
                    "sacred thread bracelet",
                    "Hindu festival symbolism",
                    "sibling protection bond",
                    "traditional Indian craftsmanship"
                ],
                colorGuidance: [
                    "saffron orange primary",
                    "deep red accents",
                    "golden yellow highlights"
                ],
                symbolismGuidance: [
                    "Om symbol centerpiece",
                    "protective blessing imagery",
                    "spiritual significance"
                ],
                culturalTaboos: [
                    "inappropriate religious symbols",
                    "non-Hindu religious imagery",
                    "culturally insensitive elements"
                ],
                authenticityEnhancers: [
                    "traditional Sanskrit blessings",
                    "authentic Indian art style",
                    "respectful cultural representation"
                ],
                recommendedLoRAs: ["hindu_symbolism", "traditional_indian_art"]
            ),
            
            .chineseNewYear: CulturalPromptTemplate(
                context: .chineseNewYear,
                coreElements: [
                    "Chinese cultural symbols",
                    "lunar new year celebration",
                    "prosperity and fortune themes",
                    "traditional Chinese craftsmanship"
                ],
                colorGuidance: [
                    "lucky red primary",
                    "golden prosperity accents",
                    "traditional Chinese colors"
                ],
                symbolismGuidance: [
                    "dragon and phoenix imagery",
                    "fortune symbols",
                    "prosperity characters"
                ],
                culturalTaboos: [
                    "unlucky colors",
                    "inappropriate cultural mixing",
                    "disrespectful symbol usage"
                ],
                authenticityEnhancers: [
                    "traditional Chinese art style",
                    "cultural accuracy",
                    "respectful representation"
                ],
                recommendedLoRAs: ["chinese_traditional_art", "lunar_new_year"]
            )
            
            // Additional cultural contexts would be added here...
        ]
    }
    
    private func loadPersonalityPrompts() {
        // Load personality-based prompt modifiers
        userPersonalityPrompts = [
            "creative": PersonalityPromptModifier(
                positiveModifiers: ["innovative design", "creative interpretation", "artistic flair"],
                negativeModifiers: ["generic design", "unoriginal elements"],
                technicalAdjustments: ["cfg_scale": 1.0]
            ),
            "traditional": PersonalityPromptModifier(
                positiveModifiers: ["classic design", "time-honored elements", "heritage styling"],
                negativeModifiers: ["overly modern", "non-traditional elements"],
                technicalAdjustments: ["cfg_scale": 2.0]
            ),
            "minimalist": PersonalityPromptModifier(
                positiveModifiers: ["clean design", "simple elegance", "uncluttered composition"],
                negativeModifiers: ["busy design", "cluttered elements"],
                technicalAdjustments: ["cfg_scale": -1.0]
            )
        ]
    }
    
    // MARK: - Fallback Methods (Temporary until PersonalizationService integration)
    
    private func getCulturalAffinityFallback(for context: CulturalContext) -> Double {
        // Return default moderate affinity
        return 0.7
    }
    
    private func getPreferredStyleFallback(for context: CulturalContext) -> RakhiGenre? {
        // Return default traditional style as RakhiGenre
        return .traditional
    }
}

// MARK: - Supporting Types

struct CulturalPersonalization {
    let culturalContext: CulturalContext
    let familiarityLevel: CulturalFamiliarityLevel
    let modernityPreference: ModernityPreference
    let authenticityImportance: AuthenticityImportance
    let preferredStyle: RakhiGenre?
    let culturalAffinity: Double
}

enum CulturalFamiliarityLevel {
    case beginner
    case familiar
    case intermediate
    case expert
}

enum ModernityPreference {
    case traditional
    case balanced
    case modern
}

enum AuthenticityImportance {
    case flexible
    case moderate
    case high
}

enum PersonalizationLevel {
    case minimal
    case basic
    case intermediate
    case advanced
}

enum Season {
    case spring, summer, autumn, winter
}

struct PersonalizedAIPrompt {
    var basePrompt: AdvancedPrompt
    let personalizationLevel: PersonalizationLevel
    let confidence: Double
    var adaptationReasons: [String]
}

struct CulturalPromptTemplate {
    let context: CulturalContext
    let coreElements: [String]
    let colorGuidance: [String]
    let symbolismGuidance: [String]
    let culturalTaboos: [String]
    let authenticityEnhancers: [String]
    let recommendedLoRAs: [String]
}

struct PersonalityPromptModifier {
    let positiveModifiers: [String]
    let negativeModifiers: [String]
    let technicalAdjustments: [String: Double]
}

