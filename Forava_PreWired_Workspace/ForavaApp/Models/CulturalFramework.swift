import Foundation
import SwiftUI

// MARK: - Cultural Framework Base Protocol
protocol CulturalContext {
    var identifier: String { get }
    var displayName: String { get }
    var description: String { get }
    var primaryLanguage: String { get }
    var supportedLanguages: [String] { get }

    // Core cultural elements
    var genres: [CulturalGenre] { get }
    var colorPalettes: [CulturalColorPalette] { get }
    var designElements: [CulturalDesignElement] { get }
    var ageGroups: [CulturalAgeGroup] { get }

    // AI generation parameters
    var basePromptEnhancers: [String] { get }
    var culturalNegativePrompts: [String] { get }
    var preferredAIModel: String { get }

    // Validation rules
    var validator: CulturalValidator { get }

    // Animation and visual preferences
    var animationStyle: CulturalAnimationStyle { get }
}

// MARK: - Cultural Design Specification
struct CulturalDesignSpec: Identifiable, Codable {
    let id: UUID
    let culturalContext: String // Cultural context identifier
    var genre: CulturalGenre
    var elements: [CulturalDesignElement]
    var colorPalette: CulturalColorPalette
    var personalMessage: String?
    var targetAgeGroup: CulturalAgeGroup
    var createdAt: Date

    init(
        culturalContext: String,
        genre: CulturalGenre,
        elements: [CulturalDesignElement] = [],
        colorPalette: CulturalColorPalette,
        personalMessage: String? = nil,
        targetAgeGroup: CulturalAgeGroup
    ) {
        self.id = UUID()
        self.createdAt = Date()
        self.culturalContext = culturalContext
        self.genre = genre
        self.elements = elements
        self.colorPalette = colorPalette
        self.personalMessage = personalMessage
        self.targetAgeGroup = targetAgeGroup
    }
    
    // MARK: - Backward Compatibility Properties
    // These computed properties maintain API compatibility with existing tests
    
    var isValid: Bool {
        !elements.isEmpty && !colorPalette.colors.isEmpty
    }
    
    var aiPrompt: String {
        generateAIPrompt()
    }
    
    var relationship: String {
        // Derive relationship context from cultural context or use default
        switch culturalContext.lowercased() {
        case let context where context.contains("family"):
            return "family"
        case let context where context.contains("friend"):
            return "friend"
        case let context where context.contains("colleague"):
            return "colleague"
        default:
            return "general"
        }
    }
    
    var culturalMessage: String {
        generateCulturalMessage()
    }
    
    // MARK: - Private Helper Methods
    
    private func generateAIPrompt() -> String {
        var prompt = "Create a \(culturalContext) design with \(genre.rawValue) style"
        
        if !elements.isEmpty {
            let elementNames = elements.map { $0.name }.joined(separator: ", ")
            prompt += " featuring \(elementNames)"
        }
        
        if !colorPalette.colors.isEmpty {
            let colorNames = colorPalette.colors.map { $0.name }.joined(separator: ", ")
            prompt += " using colors: \(colorNames)"
        }
        
        if let message = personalMessage {
            prompt += " with message: \(message)"
        }
        
        return prompt
    }
    
    private func generateCulturalMessage() -> String {
        switch culturalContext.lowercased() {
        case let context where context.contains("chinese"):
            return "Wishing you prosperity and happiness!"
        case let context where context.contains("diwali"):
            return "May your life be filled with light and joy!"
        case let context where context.contains("christmas"):
            return "Merry Christmas and Happy New Year!"
        case let context where context.contains("rakhi"):
            return "Happy Raksha Bandhan! May our bond grow stronger."
        default:
            return "Celebrating our shared moments and traditions!"
        }
    }
}

// MARK: - Cultural Genre
struct CulturalGenre: Identifiable, Codable {
    let id: String
    let displayName: String
    let icon: String
    let basePrompt: String
    let culturalWeight: Double
    let suggestedElementIds: [String]
    let culturalContext: String

    init(
        id: String,
        displayName: String,
        icon: String,
        basePrompt: String,
        culturalWeight: Double = 0.8,
        suggestedElementIds: [String] = [],
        culturalContext: String
    ) {
        self.id = id
        self.displayName = displayName
        self.icon = icon
        self.basePrompt = basePrompt
        self.culturalWeight = culturalWeight
        self.suggestedElementIds = suggestedElementIds
        self.culturalContext = culturalContext
    }
}

// MARK: - Cultural Design Element
struct CulturalDesignElement: Identifiable, Codable {
    let id: String
    let displayName: String
    let category: CulturalElementCategory
    let weight: Double
    let culturalSignificance: Double
    let ageAppropriate: [CulturalAgeGroup]
    let compatibleGenreIds: [String]
    let promptTokens: [String]
    let culturalContext: String
    let description: String?

    init(
        id: String,
        displayName: String,
        category: CulturalElementCategory,
        weight: Double = 1.0,
        culturalSignificance: Double = 0.8,
        ageAppropriate: [CulturalAgeGroup],
        compatibleGenreIds: [String] = [],
        promptTokens: [String] = [],
        culturalContext: String,
        description: String? = nil
    ) {
        self.id = id
        self.displayName = displayName
        self.category = category
        self.weight = weight
        self.culturalSignificance = culturalSignificance
        self.ageAppropriate = ageAppropriate
        self.compatibleGenreIds = compatibleGenreIds
        self.promptTokens = promptTokens
        self.culturalContext = culturalContext
        self.description = description
    }
}

// MARK: - Cultural Element Category
struct CulturalElementCategory: Identifiable, Codable {
    let id: String
    let displayName: String
    let icon: String
    let culturalContext: String
}

// MARK: - Cultural Color Palette
struct CulturalColorPalette: Identifiable, Codable {
    let id: String
    let displayName: String
    let colors: [CulturalColor]
    let promptTokens: [String]
    let culturalContext: String
    let culturalSignificance: Double

    init(
        id: String,
        displayName: String,
        colors: [CulturalColor],
        promptTokens: [String] = [],
        culturalContext: String,
        culturalSignificance: Double = 0.8
    ) {
        self.id = id
        self.displayName = displayName
        self.colors = colors
        self.promptTokens = promptTokens
        self.culturalContext = culturalContext
        self.culturalSignificance = culturalSignificance
    }
}

// MARK: - Cultural Color
struct CulturalColor: Codable {
    let name: String
    let hex: String
    let symbolism: String?

    var color: Color {
        return Color(hex: hex) ?? .primary
    }
}

// MARK: - Cultural Age Group
struct CulturalAgeGroup: Identifiable, Codable {
    let id: String
    let displayName: String
    let ageRange: String
    let preferences: [String]
    let culturalContext: String

    init(
        id: String,
        displayName: String,
        ageRange: String,
        preferences: [String] = [],
        culturalContext: String
    ) {
        self.id = id
        self.displayName = displayName
        self.ageRange = ageRange
        self.preferences = preferences
        self.culturalContext = culturalContext
    }
}

// MARK: - Cultural Animation Style
struct CulturalAnimationStyle: Codable {
    let primaryStyle: String
    let duration: Double
    let effects: [String]
    let culturalElements: [String]

    init(
        primaryStyle: String = "elegant",
        duration: Double = 2.0,
        effects: [String] = ["fade", "glow"],
        culturalElements: [String] = []
    ) {
        self.primaryStyle = primaryStyle
        self.duration = duration
        self.effects = effects
        self.culturalElements = culturalElements
    }
}

// MARK: - Color Extension for Hex Support
extension Color {
    init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }

        self.init(
            .sRGB,
            red: Double(red) / 255,
            green: Double(green) / 255,
            blue: Double(blue) / 255,
            opacity: Double(alpha) / 255
        )
    }
}
