import Foundation
import SwiftUI

// MARK: - Birthday Theme Structure
enum BirthdayTheme: String, Codable, CaseIterable {
    case celebration = "Celebration"
    case milestone = "Milestone"
    case kids = "Kids"
    case adult = "Adult"

    var description: String {
        switch self {
        case .celebration:
            return "Joyful party atmosphere with festive elements"
        case .milestone:
            return "Special age celebrations and life achievements"
        case .kids:
            return "Fun and colorful designs perfect for children"
        case .adult:
            return "Sophisticated and elegant birthday designs"
        }
    }

    var giftOptions: [String] {
        switch self {
        case .celebration:
            return [
                "Party Celebration Card",
                "Balloon Festival Design",
                "Confetti Explosion Theme",
                "Birthday Banner Style",
                "Festive Cake Design",
                "Party Lights Background",
                "Celebration Fireworks",
                "Happy Birthday Typography"
            ]
        case .milestone:
            return [
                "Milestone Age Display",
                "Years of Wisdom Design",
                "Decade Celebration Card",
                "Achievement Timeline",
                "Life Journey Map",
                "Milestone Moments",
                "Anniversary of Birth",
                "Year Counter Design"
            ]
        case .kids:
            return [
                "Cartoon Character Party",
                "Animal Friends Birthday",
                "Superhero Birthday Card",
                "Princess Castle Theme",
                "Adventure Birthday Map",
                "Toy Box Celebration",
                "Rainbow Magic Design",
                "Playful Birthday Scene"
            ]
        case .adult:
            return [
                "Elegant Minimalist Card",
                "Sophisticated Typography",
                "Classy Celebration Design",
                "Adult Achievement Card",
                "Professional Birthday Wish",
                "Mature Milestone Design",
                "Refined Birthday Greeting",
                "Executive Style Birthday"
            ]
        }
    }

    var primaryColor: Color {
        switch self {
        case .celebration:
            return Color(hex: "#FF69B4") // Hot Pink
        case .milestone:
            return Color(hex: "#FFD700") // Gold
        case .kids:
            return Color(hex: "#00CED1") // Dark Turquoise
        case .adult:
            return Color(hex: "#4B0082") // Indigo
        }
    }
}

// MARK: - Birthday Design Elements
struct BirthdayElement: Identifiable, Codable {
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

// MARK: - Birthday Elements Collection
extension BirthdayElement {
    static let allElements: [BirthdayElement] = [
        // Centre Pieces (Priority 90-100)
        BirthdayElement(
            name: "Birthday Cake",
            category: .centrePiece,
            priority: 100,
            aiPromptModifier: "magnificent birthday cake as central focal point, decorated with candles and frosting"
        ),
        BirthdayElement(
            name: "Balloons",
            category: .centrePiece,
            priority: 95,
            aiPromptModifier: "colorful birthday balloons as main feature, floating and festive"
        ),
        BirthdayElement(
            name: "Candles",
            category: .centrePiece,
            priority: 92,
            aiPromptModifier: "birthday candles as centerpiece, glowing with warm light and celebration"
        ),
        BirthdayElement(
            name: "Gift Box",
            category: .centrePiece,
            priority: 90,
            aiPromptModifier: "beautifully wrapped gift box as focal point, ribbon and bow decoration"
        ),

        // Supporting Elements (Priority 50-80)
        BirthdayElement(
            name: "Confetti",
            category: .supportingElement,
            priority: 80,
            aiPromptModifier: "colorful confetti scattered as celebration accents"
        ),
        BirthdayElement(
            name: "Party Hats",
            category: .supportingElement,
            priority: 75,
            aiPromptModifier: "festive party hats as cheerful decorative elements"
        ),
        BirthdayElement(
            name: "Streamers",
            category: .supportingElement,
            priority: 70,
            aiPromptModifier: "birthday streamers as flowing decorative ribbons"
        ),
        BirthdayElement(
            name: "Stars",
            category: .supportingElement,
            priority: 65,
            aiPromptModifier: "sparkling stars as magical birthday embellishments"
        )
    ]

    static var centrePieces: [BirthdayElement] {
        return allElements.filter { $0.category == .centrePiece }.sorted { $0.priority > $1.priority }
    }

    static var supportingElements: [BirthdayElement] {
        return allElements.filter { $0.category == .supportingElement }.sorted { $0.priority > $1.priority }
    }
}

// MARK: - Birthday Color Palettes
struct BirthdayColorPalette: Identifiable, Codable {
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
        Color(hex: primaryColor)
    }

    var secondarySwiftUIColor: Color {
        Color(hex: secondaryColor)
    }

    var accentSwiftUIColor: Color {
        Color(hex: accentColor)
    }
}

// MARK: - Birthday Color Palettes Collection
extension BirthdayColorPalette {
    static let allPalettes: [BirthdayColorPalette] = [
        BirthdayColorPalette(
            name: "Rainbow Celebration",
            description: "Rainbow colors with white and gold",
            primaryColor: "#FF69B4",
            secondaryColor: "#FFFFFF",
            accentColor: "#FFD700",
            backgroundHint: "vibrant rainbow celebration atmosphere"
        ),
        BirthdayColorPalette(
            name: "Classic Party",
            description: "Traditional party colors",
            primaryColor: "#FF0000",
            secondaryColor: "#0000FF",
            accentColor: "#FFFF00",
            backgroundHint: "classic birthday party setting"
        ),
        BirthdayColorPalette(
            name: "Elegant Adult",
            description: "Sophisticated navy, rose gold, and cream",
            primaryColor: "#191970",
            secondaryColor: "#F7C6C7",
            accentColor: "#F5F5DC",
            backgroundHint: "elegant mature celebration"
        ),
        BirthdayColorPalette(
            name: "Kids Fun",
            description: "Bright pink, sky blue, and lime green",
            primaryColor: "#FF1493",
            secondaryColor: "#87CEEB",
            accentColor: "#32CD32",
            backgroundHint: "playful children's party atmosphere"
        ),
        BirthdayColorPalette(
            name: "Vintage Birthday",
            description: "Sepia, antique gold, and warm beige",
            primaryColor: "#704214",
            secondaryColor: "#B8860B",
            accentColor: "#F5F5DC",
            backgroundHint: "nostalgic vintage celebration"
        ),
        BirthdayColorPalette(
            name: "Modern Minimalist",
            description: "Black, white, and neon accent",
            primaryColor: "#000000",
            secondaryColor: "#FFFFFF",
            accentColor: "#00FF00",
            backgroundHint: "clean contemporary design"
        ),
        BirthdayColorPalette(
            name: "Pastel Dream",
            description: "Soft pink, baby blue, and mint green",
            primaryColor: "#FFB6C1",
            secondaryColor: "#ADD8E6",
            accentColor: "#98FB98",
            backgroundHint: "dreamy pastel wonderland"
        ),
        BirthdayColorPalette(
            name: "Bold & Bright",
            description: "Electric blue, hot pink, and sunshine yellow",
            primaryColor: "#0080FF",
            secondaryColor: "#FF69B4",
            accentColor: "#FFD700",
            backgroundHint: "energetic bold celebration"
        )
    ]
}

// MARK: - Birthday Personal Touch Messages
struct BirthdayPersonalTouch: Identifiable, Codable {
    let id: UUID
    let message: String
    let tone: MessageTone

    init(message: String, tone: MessageTone) {
        self.id = UUID()
        self.message = message
        self.tone = tone
    }

    enum MessageTone: String, Codable, CaseIterable {
        case joyful = "Joyful"
        case celebratory = "Celebratory"
        case warm = "Warm"
        case magical = "Magical"
        case inspiring = "Inspiring"
        case cheerful = "Cheerful"

        var color: Color {
            switch self {
            case .joyful: return Color(hex: "#FFD700")
            case .celebratory: return Color(hex: "#FF69B4")
            case .warm: return Color(hex: "#FF8C00")
            case .magical: return Color(hex: "#9370DB")
            case .inspiring: return Color(hex: "#4169E1")
            case .cheerful: return Color(hex: "#32CD32")
            }
        }
    }
}

// MARK: - Birthday Personal Touch Collection
extension BirthdayPersonalTouch {
    static let optionalMessages: [BirthdayPersonalTouch] = [
        BirthdayPersonalTouch(
            message: "Wishing you a fantastic birthday filled with joy!",
            tone: .joyful
        ),
        BirthdayPersonalTouch(
            message: "Hope your special day is as amazing as you are",
            tone: .celebratory
        ),
        BirthdayPersonalTouch(
            message: "Another year older, another year more wonderful",
            tone: .warm
        ),
        BirthdayPersonalTouch(
            message: "May all your birthday wishes come true",
            tone: .magical
        ),
        BirthdayPersonalTouch(
            message: "Celebrating you and the joy you bring to others",
            tone: .inspiring
        ),
        BirthdayPersonalTouch(
            message: "Here's to another year of adventures and happiness",
            tone: .cheerful
        )
    ]

    static let personalMessagePlaceholder = "Add your own personal birthday message here..."
    static let maxPersonalMessageLength = 200
}

