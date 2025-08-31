import Foundation
import SwiftUI

// MARK: - Mid-Autumn Festival Theme Structure
enum MidAutumnFestivalTheme: String, Codable, CaseIterable {
    case traditional = "Traditional"
    case mooncakes = "Mooncakes"
    case family = "Family"
    case modern = "Modern"

    var description: String {
        switch self {
        case .traditional:
            return "Classic Mid-Autumn with authentic cultural elements"
        case .mooncakes:
            return "Celebrating the traditional delicacy and sharing"
        case .family:
            return "Family reunion and togetherness celebration"
        case .modern:
            return "Contemporary Mid-Autumn with modern artistic elements"
        }
    }

    var giftOptions: [String] {
        switch self {
        case .traditional:
            return [
                "Traditional Mooncake Display",
                "Chang'e Flying to Moon",
                "Jade Rabbit Legend",
                "Classic Lantern Festival",
                "Traditional Family Scene",
                "Osmanthus Wine Toast",
                "Ancient Moon Poetry",
                "Classical Festival Scene"
            ]
        case .mooncakes:
            return [
                "Golden Mooncake Gift",
                "Assorted Mooncake Box",
                "Traditional Recipe Card",
                "Mooncake Making Scene",
                "Family Sharing Mooncakes",
                "Elegant Mooncake Plate",
                "Premium Gift Box",
                "Sweet Tradition Card"
            ]
        case .family:
            return [
                "Family Moon Viewing",
                "Generations Together",
                "Family Reunion Dinner",
                "Children's Lantern Parade",
                "Grandparents & Grandchildren",
                "Family Garden Party",
                "Unity Under Moon",
                "Family Blessing Circle"
            ]
        case .modern:
            return [
                "Modern Mooncake Art",
                "Contemporary Lantern Design",
                "Urban Moon Viewing",
                "Digital Moon Phase",
                "Minimalist Festival Card",
                "Modern Chinese Typography",
                "Stylized Jade Rabbit",
                "Contemporary Festival Art"
            ]
        }
    }

    var primaryColor: Color {
        switch self {
        case .traditional:
            return Color(hex: "#FFD700") // Gold
        case .mooncakes:
            return Color(hex: "#CD853F") // Peru (mooncake color)
        case .family:
            return Color(hex: "#FF8C00") // Dark Orange
        case .modern:
            return Color(hex: "#36454F") // Charcoal Gray
        }
    }
}

// MARK: - Mid-Autumn Festival Design Elements
struct MidAutumnFestivalElement: Identifiable, Codable {
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

// MARK: - Mid-Autumn Festival Elements Collection
extension MidAutumnFestivalElement {
    static let allElements: [MidAutumnFestivalElement] = [
        // Centre Pieces (Priority 90-100)
        MidAutumnFestivalElement(
            name: "Full Moon",
            category: .centrePiece,
            priority: 100,
            aiPromptModifier: "luminous full moon as central focal point, bright and radiant"
        ),
        MidAutumnFestivalElement(
            name: "Mooncakes",
            category: .centrePiece,
            priority: 95,
            aiPromptModifier: "traditional mooncakes as centerpiece, elegant and delicious"
        ),
        MidAutumnFestivalElement(
            name: "Jade Rabbit",
            category: .centrePiece,
            priority: 92,
            aiPromptModifier: "mythical jade rabbit as focal point, mystical and cultural"
        ),
        MidAutumnFestivalElement(
            name: "Lanterns",
            category: .centrePiece,
            priority: 90,
            aiPromptModifier: "beautiful Chinese lanterns as centerpiece, colorful and festive"
        ),

        // Supporting Elements (Priority 50-80)
        MidAutumnFestivalElement(
            name: "Osmanthus Flowers",
            category: .supportingElement,
            priority: 80,
            aiPromptModifier: "fragrant osmanthus flowers as elegant decorative accents"
        ),
        MidAutumnFestivalElement(
            name: "Tea Set",
            category: .supportingElement,
            priority: 75,
            aiPromptModifier: "traditional Chinese tea set as cultural embellishments"
        ),
        MidAutumnFestivalElement(
            name: "Autumn Leaves",
            category: .supportingElement,
            priority: 70,
            aiPromptModifier: "beautiful autumn leaves as seasonal border elements"
        ),
        MidAutumnFestivalElement(
            name: "Chinese Calligraphy",
            category: .supportingElement,
            priority: 65,
            aiPromptModifier: "elegant Chinese calligraphy as artistic flourishes"
        )
    ]

    static var centrePieces: [MidAutumnFestivalElement] {
        return allElements.filter { $0.category == .centrePiece }.sorted { $0.priority > $1.priority }
    }

    static var supportingElements: [MidAutumnFestivalElement] {
        return allElements.filter { $0.category == .supportingElement }.sorted { $0.priority > $1.priority }
    }
}

// MARK: - Mid-Autumn Festival Color Palettes
struct MidAutumnFestivalColorPalette: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let primaryColor: String
    let secondaryColor: String
    let accentColor: String
    let backgroundHint: String

    init(name: String, description: String, primaryColor: String, secondaryColor: String, accentColor: String, backgroundHint: String) {
        self.id = UUID()
        self.name = name
        self.description = description
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.accentColor = accentColor
        self.backgroundHint = backgroundHint
    }

    var swiftUIColors: (primary: Color, secondary: Color, accent: Color) {
        return (
            primary: Color(hex: primaryColor),
            secondary: Color(hex: secondaryColor),
            accent: Color(hex: accentColor)
        )
    }
}

// MARK: - Mid-Autumn Festival Color Palettes Collection
extension MidAutumnFestivalColorPalette {
    static let allPalettes: [MidAutumnFestivalColorPalette] = [
        MidAutumnFestivalColorPalette(
            name: "Harvest Moon",
            description: "Golden yellow, orange, and deep brown",
            primaryColor: "#FFD700",
            secondaryColor: "#FF8C00",
            accentColor: "#8B4513",
            backgroundHint: "warm harvest moon glow"
        ),
        MidAutumnFestivalColorPalette(
            name: "Autumn Leaves",
            description: "Rust orange, golden brown, and deep red",
            primaryColor: "#CD853F",
            secondaryColor: "#D2691E",
            accentColor: "#8B0000",
            backgroundHint: "rich autumn foliage atmosphere"
        ),
        MidAutumnFestivalColorPalette(
            name: "Traditional Lantern",
            description: "Red, gold, and warm yellow",
            primaryColor: "#DC143C",
            secondaryColor: "#FFD700",
            accentColor: "#FFF8DC",
            backgroundHint: "festive lantern celebration"
        ),
        MidAutumnFestivalColorPalette(
            name: "Moonlight Silver",
            description: "Silver, pearl white, and soft blue",
            primaryColor: "#C0C0C0",
            secondaryColor: "#F8F8FF",
            accentColor: "#ADD8E6",
            backgroundHint: "serene moonlight ambiance"
        ),
        MidAutumnFestivalColorPalette(
            name: "Jade Rabbit",
            description: "Jade green, white, and gold",
            primaryColor: "#00A86B",
            secondaryColor: "#FFFFFF",
            accentColor: "#FFD700",
            backgroundHint: "mystical jade rabbit legend"
        ),
        MidAutumnFestivalColorPalette(
            name: "Osmanthus Gold",
            description: "Golden yellow, orange, and cream",
            primaryColor: "#FFAA00",
            secondaryColor: "#FF8C00",
            accentColor: "#FFFDD0",
            backgroundHint: "fragrant osmanthus blossom"
        ),
        MidAutumnFestivalColorPalette(
            name: "Modern Minimalist",
            description: "Black, white, and gold accent",
            primaryColor: "#000000",
            secondaryColor: "#FFFFFF",
            accentColor: "#FFD700",
            backgroundHint: "contemporary minimalist design"
        ),
        MidAutumnFestivalColorPalette(
            name: "Warm Family",
            description: "Warm orange, brown, and ivory",
            primaryColor: "#FF8C00",
            secondaryColor: "#A0522D",
            accentColor: "#FFFFF0",
            backgroundHint: "cozy family gathering warmth"
        )
    ]
}

// MARK: - Mid-Autumn Festival Personal Touch Messages
struct MidAutumnFestivalPersonalTouch: Identifiable, Codable {
    let id: UUID
    let message: String
    let tone: MessageTone

    init(message: String, tone: MessageTone) {
        self.id = UUID()
        self.message = message
        self.tone = tone
    }

    enum MessageTone: String, Codable, CaseIterable {
        case traditional = "Traditional"
        case blessing = "Blessing"
        case family = "Family"
        case peaceful = "Peaceful"
        case grateful = "Grateful"
        case loving = "Loving"

        var color: Color {
            switch self {
            case .traditional: return Color(hex: "#DC143C")
            case .blessing: return Color(hex: "#FFD700")
            case .family: return Color(hex: "#FF8C00")
            case .peaceful: return Color(hex: "#ADD8E6")
            case .grateful: return Color(hex: "#00A86B")
            case .loving: return Color(hex: "#FF69B4")
            }
        }
    }
}

// MARK: - Mid-Autumn Festival Personal Touch Collection
extension MidAutumnFestivalPersonalTouch {
    static let optionalMessages: [MidAutumnFestivalPersonalTouch] = [
        MidAutumnFestivalPersonalTouch(
            message: "中秋快樂! Wishing you a happy Mid-Autumn Festival",
            tone: .traditional
        ),
        MidAutumnFestivalPersonalTouch(
            message: "May the full moon bring you peace and prosperity",
            tone: .blessing
        ),
        MidAutumnFestivalPersonalTouch(
            message: "Celebrating family unity under the bright moon",
            tone: .family
        ),
        MidAutumnFestivalPersonalTouch(
            message: "Sharing mooncakes and warm wishes with you",
            tone: .peaceful
        ),
        MidAutumnFestivalPersonalTouch(
            message: "May your family be blessed with happiness and harmony",
            tone: .grateful
        ),
        MidAutumnFestivalPersonalTouch(
            message: "Under the same moon, we share the same love",
            tone: .loving
        )
    ]

    static let personalMessagePlaceholder = "Add your own personal Mid-Autumn Festival message here..."
    static let maxPersonalMessageLength = 200
}

// MARK: - Mid-Autumn Festival Selection State
struct MidAutumnFestivalSelectionState: Codable {
    var selectedTheme: MidAutumnFestivalTheme?
    var selectedGift: String?
    var selectedElements: [MidAutumnFestivalElement] = []
    var selectedColorPalette: MidAutumnFestivalColorPalette?
    var selectedOptionalMessage: MidAutumnFestivalPersonalTouch?
    var personalMessage: String = ""

    var isComplete: Bool {
        return selectedTheme != nil &&
               selectedGift != nil &&
               !selectedElements.isEmpty &&
               selectedColorPalette != nil &&
               (selectedOptionalMessage?.message.isEmpty == false || !personalMessage.isEmpty)
    }

    var summary: String {
        var parts: [String] = []

        if let theme = selectedTheme {
            parts.append("Style: \(theme.rawValue)")
        }

        if let gift = selectedGift {
            parts.append("Gift: \(gift)")
        }

        if !selectedElements.isEmpty {
            let elementNames = selectedElements.map { $0.name }
            parts.append("Elements: \(elementNames.joined(separator: ", "))")
        }

        if let palette = selectedColorPalette {
            parts.append("Colors: \(palette.name)")
        }

        if let optionalMsg = selectedOptionalMessage, !optionalMsg.message.isEmpty {
            parts.append("Message: \(optionalMsg.message)")
        } else if !personalMessage.isEmpty {
            parts.append("Personal Message: \(personalMessage)")
        }

        return parts.joined(separator: "\n")
    }
}
