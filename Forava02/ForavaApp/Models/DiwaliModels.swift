import Foundation
import SwiftUI

// MARK: - Diwali Theme Structure
enum DiwaliTheme: String, Codable, CaseIterable {
    case traditional = "Traditional"
    case rangoli = "Rangoli"
    case lakshmi = "Lakshmi"
    case modern = "Modern"

    var description: String {
        switch self {
        case .traditional:
            return "Classic Diwali with authentic religious elements"
        case .rangoli:
            return "Beautiful floor art patterns and designs"
        case .lakshmi:
            return "Celebrating the goddess of wealth and prosperity"
        case .modern:
            return "Contemporary Diwali with modern artistic elements"
        }
    }

    var giftOptions: [String] {
        switch self {
        case .traditional:
            return [
                "Golden Diya Array",
                "Traditional Lakshmi Puja",
                "Sacred Om Design",
                "Temple Lights Scene",
                "Religious Blessing Card",
                "Traditional Family Puja",
                "Sanskrit Mantra Design",
                "Classical Festival Scene"
            ]
        case .rangoli:
            return [
                "Geometric Rangoli Pattern",
                "Floral Rangoli Design",
                "Peacock Rangoli Art",
                "Mandala Rangoli Circle",
                "Traditional Kolam Pattern",
                "Colorful Rangoli Border",
                "Sacred Symbol Rangoli",
                "Festival Floor Art"
            ]
        case .lakshmi:
            return [
                "Goddess Lakshmi Portrait",
                "Lakshmi Pada (Footprints)",
                "Golden Lotus Throne",
                "Prosperity Blessing Card",
                "Wealth Goddess Scene",
                "Lakshmi Puja Setup",
                "Divine Blessing Design",
                "Prosperity Mandala"
            ]
        case .modern:
            return [
                "Modern Diya Arrangement",
                "Contemporary Rangoli",
                "Urban Diwali Lights",
                "Minimalist Festival Card",
                "Digital Art Lakshmi",
                "Modern Light Pattern",
                "Stylized Diwali Scene",
                "Contemporary Blessing"
            ]
        }
    }

    var primaryColor: Color {
        switch self {
        case .traditional:
            return Color(hex: "#FF6B35") // Festival Orange
        case .rangoli:
            return Color(hex: "#FF1493") // Deep Pink
        case .lakshmi:
            return Color(hex: "#673AB7") // Deep Purple
        case .modern:
            return Color(hex: "#000000") // Black
        }
    }
}

// MARK: - Diwali Design Elements
struct DiwaliElement: Identifiable, Codable {
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

// MARK: - Diwali Elements Collection
extension DiwaliElement {
    static let allElements: [DiwaliElement] = [
        // Centre Pieces (Priority 90-100)
        DiwaliElement(
            name: "Diya (Oil Lamp)",
            category: .centrePiece,
            priority: 100,
            aiPromptModifier: "beautiful traditional diya oil lamp as central focal point, glowing with warm light"
        ),
        DiwaliElement(
            name: "Lotus",
            category: .centrePiece,
            priority: 95,
            aiPromptModifier: "sacred lotus flower as centerpiece, symbol of purity and divinity"
        ),
        DiwaliElement(
            name: "Lakshmi",
            category: .centrePiece,
            priority: 92,
            aiPromptModifier: "Goddess Lakshmi as focal point, divine blessing of wealth and prosperity"
        ),
        DiwaliElement(
            name: "Fireworks",
            category: .centrePiece,
            priority: 90,
            aiPromptModifier: "spectacular fireworks as centerpiece, celebrating the festival of lights"
        ),

        // Supporting Elements (Priority 50-80)
        DiwaliElement(
            name: "Rangoli Patterns",
            category: .supportingElement,
            priority: 80,
            aiPromptModifier: "intricate rangoli patterns as decorative floor art accents"
        ),
        DiwaliElement(
            name: "Marigold Flowers",
            category: .supportingElement,
            priority: 75,
            aiPromptModifier: "vibrant marigold flowers as festive decorative elements"
        ),
        DiwaliElement(
            name: "Om Symbol",
            category: .supportingElement,
            priority: 70,
            aiPromptModifier: "sacred Om symbol as spiritual border elements"
        ),
        DiwaliElement(
            name: "Gold Coins",
            category: .supportingElement,
            priority: 65,
            aiPromptModifier: "golden coins as prosperity symbols and decorative accents"
        )
    ]

    static var centrePieces: [DiwaliElement] {
        return allElements.filter { $0.category == .centrePiece }.sorted { $0.priority > $1.priority }
    }

    static var supportingElements: [DiwaliElement] {
        return allElements.filter { $0.category == .supportingElement }.sorted { $0.priority > $1.priority }
    }
}

// MARK: - Diwali Color Palettes
struct DiwaliColorPalette: Identifiable, Codable {
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

// MARK: - Diwali Color Palettes Collection
extension DiwaliColorPalette {
    static let allPalettes: [DiwaliColorPalette] = [
        DiwaliColorPalette(
            name: "Classic Diwali",
            description: "Deep orange, gold, and purple",
            primaryColor: "#FF6B35",
            secondaryColor: "#FFD700",
            accentColor: "#673AB7",
            backgroundHint: "warm festive diya glow"
        ),
        DiwaliColorPalette(
            name: "Golden Prosperity",
            description: "Multiple gold shades with orange accents",
            primaryColor: "#FFD700",
            secondaryColor: "#FFA500",
            accentColor: "#B8860B",
            backgroundHint: "luxurious golden prosperity"
        ),
        DiwaliColorPalette(
            name: "Lakshmi Blessings",
            description: "Rich purple, gold, and deep pink",
            primaryColor: "#673AB7",
            secondaryColor: "#FFD700",
            accentColor: "#C2185B",
            backgroundHint: "divine goddess blessing"
        ),
        DiwaliColorPalette(
            name: "Rangoli Colors",
            description: "Bright multi-colors with white base",
            primaryColor: "#FF1493",
            secondaryColor: "#00FF7F",
            accentColor: "#FFFFFF",
            backgroundHint: "vibrant rangoli art background"
        ),
        DiwaliColorPalette(
            name: "Royal Elegance",
            description: "Deep purple, rose gold, and cream",
            primaryColor: "#4A148C",
            secondaryColor: "#E91E63",
            accentColor: "#FFF8E1",
            backgroundHint: "elegant royal celebration"
        ),
        DiwaliColorPalette(
            name: "Traditional Festival",
            description: "Saffron, red, and gold",
            primaryColor: "#FF9933",
            secondaryColor: "#DC143C",
            accentColor: "#FFD700",
            backgroundHint: "authentic traditional festival"
        ),
        DiwaliColorPalette(
            name: "Modern Minimalist",
            description: "Black, gold, and orange accent",
            primaryColor: "#000000",
            secondaryColor: "#FFD700",
            accentColor: "#FF6B35",
            backgroundHint: "contemporary minimalist design"
        ),
        DiwaliColorPalette(
            name: "Warm Celebration",
            description: "Warm orange, copper, and ivory",
            primaryColor: "#FF8C00",
            secondaryColor: "#CD853F",
            accentColor: "#FFFFF0",
            backgroundHint: "warm candlelit celebration"
        )
    ]
}

// MARK: - Diwali Personal Touch Messages
struct DiwaliPersonalTouch: Identifiable, Codable {
    let id: UUID
    let message: String
    let tone: MessageTone

    init(message: String, tone: MessageTone) {
        self.id = UUID()
        self.message = message
        self.tone = tone
    }

    enum MessageTone: String, Codable, CaseIterable {
        case blessed = "Blessed"
        case prosperous = "Prosperous"
        case joyful = "Joyful"
        case divine = "Divine"
        case traditional = "Traditional"
        case bright = "Bright"

        var color: Color {
            switch self {
            case .blessed: return Color(hex: "#673AB7")
            case .prosperous: return Color(hex: "#FFD700")
            case .joyful: return Color(hex: "#FF6B35")
            case .divine: return Color(hex: "#4A148C")
            case .traditional: return Color(hex: "#FF9933")
            case .bright: return Color(hex: "#FF1493")
            }
        }
    }
}

// MARK: - Diwali Personal Touch Collection
extension DiwaliPersonalTouch {
    static let optionalMessages: [DiwaliPersonalTouch] = [
        DiwaliPersonalTouch(
            message: "दीपावली की हार्दिक शुभकामनाएं! Happy Diwali!",
            tone: .traditional
        ),
        DiwaliPersonalTouch(
            message: "May Goddess Lakshmi bless you with prosperity",
            tone: .prosperous
        ),
        DiwaliPersonalTouch(
            message: "Wishing you light, love, and happiness this Diwali",
            tone: .joyful
        ),
        DiwaliPersonalTouch(
            message: "May the festival of lights brighten your life",
            tone: .bright
        ),
        DiwaliPersonalTouch(
            message: "शुभ दीपावली! May joy illuminate your path",
            tone: .blessed
        ),
        DiwaliPersonalTouch(
            message: "Celebrating the victory of light over darkness",
            tone: .divine
        )
    ]

    static let personalMessagePlaceholder = "Add your own personal Diwali message here..."
    static let maxPersonalMessageLength = 200
}

// MARK: - Diwali Selection State
struct DiwaliSelectionState: Codable {
    var selectedTheme: DiwaliTheme?
    var selectedGift: String?
    var selectedElements: [DiwaliElement] = []
    var selectedColorPalette: DiwaliColorPalette?
    var selectedOptionalMessage: DiwaliPersonalTouch?
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