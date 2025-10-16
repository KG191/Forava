import Foundation
import SwiftUI

// MARK: - Chinese New Year Theme Structure
enum ChineseNewYearTheme: String, Codable, CaseIterable {
    case traditional = "Traditional"
    case zodiac = "Zodiac"
    case prosperity = "Prosperity"
    case modern = "Modern"

    var description: String {
        switch self {
        case .traditional:
            return "Classic Chinese New Year with authentic elements"
        case .zodiac:
            return "Celebrating the current zodiac animal year"
        case .prosperity:
            return "Focus on wealth, luck, and good fortune"
        case .modern:
            return "Contemporary Chinese New Year with modern twist"
        }
    }

    var giftOptions: [String] {
        switch self {
        case .traditional:
            return [
                "Imperial Dragon Card",
                "Traditional Lion Dance",
                "Red Lantern Festival",
                "Plum Blossom Branch",
                "Golden Temple Design",
                "Ancestral Blessing Card",
                "Classic Calligraphy Style",
                "Traditional Family Scene"
            ]
        case .zodiac:
            return [
                "Year of the Dragon",
                "Zodiac Animal Portrait",
                "12 Animals Circle",
                "Zodiac Compatibility Card",
                "Animal Characteristics",
                "Zodiac Calendar Design",
                "Lucky Animal Symbols",
                "Zodiac Fortune Card"
            ]
        case .prosperity:
            return [
                "Gold Coins Rain",
                "Fortune Tree Design",
                "Lucky Bamboo Card",
                "Wealth God Blessing",
                "Golden Ingots Scene",
                "Prosperity Characters",
                "Money Tree Branches",
                "Abundance Symbols"
            ]
        case .modern:
            return [
                "Digital Dragon Art",
                "Modern Red Envelope",
                "Contemporary Lanterns",
                "Urban Celebration",
                "Minimalist CNY Design",
                "Tech-Style Fireworks",
                "Modern Calligraphy",
                "Digital Prosperity Card"
            ]
        }
    }

    var primaryColor: Color {
        switch self {
        case .traditional:
            return Color(hex: "#DC143C") // Crimson Red
        case .zodiac:
            return Color(hex: "#B8860B") // Dark Golden Rod
        case .prosperity:
            return Color(hex: "#FFD700") // Gold
        case .modern:
            return Color(hex: "#FF6347") // Tomato Red
        }
    }
}

// MARK: - Chinese New Year Design Elements
struct ChineseNewYearElement: Identifiable, Codable {
    let id: UUID
    let name: String
    let category: ElementCategory
    let priority: Int // Higher number = higher priority
    let aiPromptModifier: String

    init(name: String, category: ElementCategory, priority: Int, aiPromptModifier: String) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.priority = priority
        self.aiPromptModifier = aiPromptModifier
    }

    enum ElementCategory: String, Codable, CaseIterable {
        case centrePiece = "Centre Piece"
        case supportingElement = "Supporting Element"

        var description: String {
            switch self {
            case .centrePiece:
                return "Takes visual precedence in the design"
            case .supportingElement:
                return "Complements the main design elements"
            }
        }
    }
}

// MARK: - Chinese New Year Elements Collection
extension ChineseNewYearElement {
    static let allElements: [ChineseNewYearElement] = [
        // Centre Pieces (Priority 90-100)
        ChineseNewYearElement(
            name: "Dragon",
            category: .centrePiece,
            priority: 100,
            aiPromptModifier: "magnificent Chinese dragon as central focal point, powerful and majestic"
        ),
        ChineseNewYearElement(
            name: "Lion Dance",
            category: .centrePiece,
            priority: 95,
            aiPromptModifier: "traditional lion dance as main feature, vibrant and energetic performance"
        ),
        ChineseNewYearElement(
            name: "Lanterns",
            category: .centrePiece,
            priority: 92,
            aiPromptModifier: "beautiful red lanterns as centerpiece, glowing with warm festive light"
        ),
        ChineseNewYearElement(
            name: "Fireworks",
            category: .centrePiece,
            priority: 90,
            aiPromptModifier: "spectacular fireworks display as focal point, bursting with celebration"
        ),

        // Supporting Elements (Priority 50-80)
        ChineseNewYearElement(
            name: "Plum Blossoms",
            category: .supportingElement,
            priority: 80,
            aiPromptModifier: "delicate plum blossoms as decorative accents, symbolizing renewal and hope"
        ),
        ChineseNewYearElement(
            name: "Gold Coins",
            category: .supportingElement,
            priority: 75,
            aiPromptModifier: "golden Chinese coins as prosperity embellishments"
        ),
        ChineseNewYearElement(
            name: "Bamboo",
            category: .supportingElement,
            priority: 70,
            aiPromptModifier: "elegant bamboo as border elements, representing strength and flexibility"
        ),
        ChineseNewYearElement(
            name: "Fu Character",
            category: .supportingElement,
            priority: 65,
            aiPromptModifier: "traditional Fu character as decorative element, symbolizing good fortune"
        )
    ]

    static var centrePieces: [ChineseNewYearElement] {
        return allElements.filter { $0.category == .centrePiece }.sorted { $0.priority > $1.priority }
    }

    static var supportingElements: [ChineseNewYearElement] {
        return allElements.filter { $0.category == .supportingElement }.sorted { $0.priority > $1.priority }
    }
}

// MARK: - Chinese New Year Color Palettes
struct ChineseNewYearColorPalette: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let primaryColor: String
    let secondaryColor: String
    let accentColor: String
    let backgroundHint: String

    init(name: String, description: String, primaryColor: String, 
         secondaryColor: String, accentColor: String, backgroundHint: String) {
        self.id = UUID()
        self.name = name
        self.description = description
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.accentColor = accentColor
        self.backgroundHint = backgroundHint
    }

    var primarySwiftUIColor: Color {
        return Color(hex: primaryColor)
    }
    
    var secondarySwiftUIColor: Color {
        return Color(hex: secondaryColor)
    }
    
    var accentSwiftUIColor: Color {
        return Color(hex: accentColor)
    }
}

// MARK: - Chinese New Year Color Palettes Collection
extension ChineseNewYearColorPalette {
    static let allPalettes: [ChineseNewYearColorPalette] = [
        ChineseNewYearColorPalette(
            name: "Classic Red Gold",
            description: "Traditional Chinese New Year colors",
            primaryColor: "#DC143C",
            secondaryColor: "#FFD700",
            accentColor: "#000000",
            backgroundHint: "festive traditional atmosphere"
        ),
        ChineseNewYearColorPalette(
            name: "Dragon Colors",
            description: "Deep red, gold, and emerald green",
            primaryColor: "#B71C1C",
            secondaryColor: "#FFD700",
            accentColor: "#50C878",
            backgroundHint: "imperial dragon presence"
        ),
        ChineseNewYearColorPalette(
            name: "Prosperity Gold",
            description: "Multiple gold shades with red accents",
            primaryColor: "#FFD700",
            secondaryColor: "#B8860B",
            accentColor: "#DC143C",
            backgroundHint: "golden prosperity glow"
        ),
        ChineseNewYearColorPalette(
            name: "Imperial Palace",
            description: "Royal red, yellow gold, and black",
            primaryColor: "#8B0000",
            secondaryColor: "#FFFF00",
            accentColor: "#000000",
            backgroundHint: "regal palace atmosphere"
        ),
        ChineseNewYearColorPalette(
            name: "Modern Minimalist",
            description: "Red, white, and gold accent",
            primaryColor: "#FF0000",
            secondaryColor: "#FFFFFF",
            accentColor: "#FFD700",
            backgroundHint: "clean modern celebration"
        ),
        ChineseNewYearColorPalette(
            name: "Zodiac Traditional",
            description: "Earth tones with red and gold",
            primaryColor: "#8B4513",
            secondaryColor: "#DC143C",
            accentColor: "#FFD700",
            backgroundHint: "natural earth harmony"
        ),
        ChineseNewYearColorPalette(
            name: "Festive Bright",
            description: "Bright red, electric gold, and white",
            primaryColor: "#FF4500",
            secondaryColor: "#FFDF00",
            accentColor: "#FFFFFF",
            backgroundHint: "vibrant celebration energy"
        ),
        ChineseNewYearColorPalette(
            name: "Elegant Lunar",
            description: "Deep red, rose gold, and cream",
            primaryColor: "#800020",
            secondaryColor: "#E8B4B8",
            accentColor: "#F5F5DC",
            backgroundHint: "elegant lunar celebration"
        )
    ]
}

// MARK: - Chinese New Year Personal Touch Messages
struct ChineseNewYearPersonalTouch: Identifiable, Codable {
    let id: UUID
    let message: String
    let tone: MessageTone

    init(message: String, tone: MessageTone) {
        self.id = UUID()
        self.message = message
        self.tone = tone
    }

    enum MessageTone: String, Codable, CaseIterable {
        case prosperous = "Prosperous"
        case joyful = "Joyful"
        case blessed = "Blessed"
        case fortunate = "Fortunate"
        case harmonious = "Harmonious"
        case celebratory = "Celebratory"

        var color: Color {
            switch self {
            case .prosperous: return Color(hex: "#FFD700")
            case .joyful: return Color(hex: "#FF6347")
            case .blessed: return Color(hex: "#DC143C")
            case .fortunate: return Color(hex: "#B8860B")
            case .harmonious: return Color(hex: "#50C878")
            case .celebratory: return Color(hex: "#FF4500")
            }
        }
    }
}

// MARK: - Chinese New Year Personal Touch Collection
extension ChineseNewYearPersonalTouch {
    static let optionalMessages: [ChineseNewYearPersonalTouch] = [
        ChineseNewYearPersonalTouch(
            message: "恭喜發財! Wishing you prosperity and happiness",
            tone: .prosperous
        ),
        ChineseNewYearPersonalTouch(
            message: "May the Year of [Zodiac] bring you good fortune",
            tone: .fortunate
        ),
        ChineseNewYearPersonalTouch(
            message: "新年快樂! Happy New Year filled with joy",
            tone: .joyful
        ),
        ChineseNewYearPersonalTouch(
            message: "Wishing you health, wealth, and happiness",
            tone: .blessed
        ),
        ChineseNewYearPersonalTouch(
            message: "May your dreams bloom like plum blossoms",
            tone: .harmonious
        ),
        ChineseNewYearPersonalTouch(
            message: "Sending you luck and prosperity this New Year",
            tone: .celebratory
        )
    ]

    static let personalMessagePlaceholder = "Add your own personal Chinese New Year message here..."
    static let maxPersonalMessageLength = 200
}

