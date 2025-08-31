import Foundation
import SwiftUI

// MARK: - Easter Theme Structure
enum EasterTheme: String, Codable, CaseIterable {
    case resurrection = "Resurrection"
    case spring = "Spring"
    case family = "Family"
    case modern = "Modern"

    var description: String {
        switch self {
        case .resurrection:
            return "Spiritual celebration of Christ's resurrection"
        case .spring:
            return "Celebrating new life and seasonal renewal"
        case .family:
            return "Traditional family Easter celebrations"
        case .modern:
            return "Contemporary Easter with modern artistic elements"
        }
    }

    var giftOptions: [String] {
        switch self {
        case .resurrection:
            return [
                "Golden Cross Sunrise",
                "Empty Tomb Glory",
                "Resurrection Morning",
                "He is Risen Text",
                "Divine Light Cross",
                "Sacred Easter Scene",
                "Salvation Message Card",
                "Blessed Resurrection"
            ]
        case .spring:
            return [
                "Blooming Easter Garden",
                "Spring Flower Bouquet",
                "Baby Animals Scene",
                "Butterfly Transformation",
                "Fresh Green Meadow",
                "Flowering Tree Branch",
                "New Life Celebration",
                "Spring Awakening"
            ]
        case .family:
            return [
                "Easter Egg Hunt Scene",
                "Family Gathering Card",
                "Easter Basket Display",
                "Decorated Eggs Collection",
                "Easter Bunny Visit",
                "Family Church Service",
                "Easter Brunch Table",
                "Traditional Family Easter"
            ]
        case .modern:
            return [
                "Minimalist Cross Design",
                "Modern Egg Pattern",
                "Contemporary Easter Card",
                "Stylized Bunny Art",
                "Geometric Easter Design",
                "Modern Typography Easter",
                "Abstract Spring Theme",
                "Digital Easter Art"
            ]
        }
    }

    var primaryColor: Color {
        switch self {
        case .resurrection:
            return Color(hex: "#FFD700") // Gold
        case .spring:
            return Color(hex: "#98FB98") // Pale Green
        case .family:
            return Color(hex: "#FFB6C1") // Light Pink
        case .modern:
            return Color(hex: "#F0F8FF") // Alice Blue
        }
    }
}

// MARK: - Easter Design Elements
struct EasterElement: Identifiable, Codable {
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

// MARK: - Easter Elements Collection
extension EasterElement {
    static let allElements: [EasterElement] = [
        // Centre Pieces (Priority 90-100)
        EasterElement(
            name: "Cross",
            category: .centrePiece,
            priority: 100,
            aiPromptModifier: "magnificent cross as central focal point, radiant with divine light"
        ),
        EasterElement(
            name: "Easter Eggs",
            category: .centrePiece,
            priority: 95,
            aiPromptModifier: "beautifully decorated Easter eggs as main centerpiece, colorful and festive"
        ),
        EasterElement(
            name: "Bunny",
            category: .centrePiece,
            priority: 92,
            aiPromptModifier: "adorable Easter bunny as centerpiece, gentle and welcoming"
        ),
        EasterElement(
            name: "Lily Flowers",
            category: .centrePiece,
            priority: 90,
            aiPromptModifier: "pure white lilies as focal point, elegant and symbolic of resurrection"
        ),

        // Supporting Elements (Priority 50-80)
        EasterElement(
            name: "Spring Flowers",
            category: .supportingElement,
            priority: 80,
            aiPromptModifier: "vibrant spring flowers as decorative accents"
        ),
        EasterElement(
            name: "Baby Chicks",
            category: .supportingElement,
            priority: 75,
            aiPromptModifier: "cute baby chicks as playful embellishments"
        ),
        EasterElement(
            name: "Butterflies",
            category: .supportingElement,
            priority: 70,
            aiPromptModifier: "delicate butterflies as transformation symbols"
        ),
        EasterElement(
            name: "Pastel Ribbons",
            category: .supportingElement,
            priority: 65,
            aiPromptModifier: "soft pastel ribbons as elegant decorative flourishes"
        )
    ]

    static var centrePieces: [EasterElement] {
        return allElements.filter { $0.category == .centrePiece }.sorted { $0.priority > $1.priority }
    }

    static var supportingElements: [EasterElement] {
        return allElements.filter { $0.category == .supportingElement }.sorted { $0.priority > $1.priority }
    }
}

// MARK: - Easter Color Palettes
struct EasterColorPalette: Identifiable, Codable {
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

    var swiftUIColors: (primary: Color, secondary: Color, accent: Color) {
        (
            primary: Color(hex: primaryColor),
            secondary: Color(hex: secondaryColor),
            accent: Color(hex: accentColor)
        )
    }
}

// MARK: - Easter Color Palettes Collection
extension EasterColorPalette {
    static let allPalettes: [EasterColorPalette] = [
        EasterColorPalette(
            name: "Pastel Spring",
            description: "Soft Pink, Baby Blue, Mint Green",
            primaryColor: "#FFB6C1",
            secondaryColor: "#ADD8E6",
            accentColor: "#98FB98",
            backgroundHint: "gentle spring morning atmosphere"
        ),
        EasterColorPalette(
            name: "Golden Sunrise",
            description: "Gold, Warm Yellow, Light Orange",
            primaryColor: "#FFD700",
            secondaryColor: "#FFFF00",
            accentColor: "#FFE4B5",
            backgroundHint: "warm Easter sunrise glow"
        ),
        EasterColorPalette(
            name: "Traditional Easter",
            description: "Purple, White, Gold",
            primaryColor: "#8A2BE2",
            secondaryColor: "#FFFFFF",
            accentColor: "#FFD700",
            backgroundHint: "sacred traditional Easter atmosphere"
        ),
        EasterColorPalette(
            name: "Garden Fresh",
            description: "Fresh Green, Lavender, White",
            primaryColor: "#90EE90",
            secondaryColor: "#E6E6FA",
            accentColor: "#FFFFFF",
            backgroundHint: "fresh spring garden setting"
        ),
        EasterColorPalette(
            name: "Bunny Soft",
            description: "Cream, Soft Brown, Pink",
            primaryColor: "#F5F5DC",
            secondaryColor: "#D2B48C",
            accentColor: "#FFC0CB",
            backgroundHint: "soft bunny fur texture"
        ),
        EasterColorPalette(
            name: "Egg Hunt Colors",
            description: "Bright Multi-colors on White",
            primaryColor: "#FF6347",
            secondaryColor: "#32CD32",
            accentColor: "#FF69B4",
            backgroundHint: "bright festive egg hunt scene"
        ),
        EasterColorPalette(
            name: "Modern Minimalist",
            description: "White, Sage Green, Gold Accent",
            primaryColor: "#FFFFFF",
            secondaryColor: "#9CAF88",
            accentColor: "#FFD700",
            backgroundHint: "clean modern Easter background"
        ),
        EasterColorPalette(
            name: "Resurrection Glory",
            description: "Pure White, Gold, Light Blue",
            primaryColor: "#FFFFFF",
            secondaryColor: "#FFD700",
            accentColor: "#87CEEB",
            backgroundHint: "radiant resurrection morning light"
        )
    ]
}

// MARK: - Easter Personal Touch Messages
struct EasterPersonalTouch: Identifiable, Codable {
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
        case hopeful = "Hopeful"
        case joyful = "Joyful"
        case peaceful = "Peaceful"
        case renewing = "Renewing"
        case miraculous = "Miraculous"

        var color: Color {
            switch self {
            case .blessed: return Color(hex: "#FFD700")
            case .hopeful: return Color(hex: "#87CEEB")
            case .joyful: return Color(hex: "#FFB6C1")
            case .peaceful: return Color(hex: "#98FB98")
            case .renewing: return Color(hex: "#E6E6FA")
            case .miraculous: return Color(hex: "#F0F8FF")
            }
        }
    }
}

// MARK: - Easter Personal Touch Collection
extension EasterPersonalTouch {
    static let optionalMessages: [EasterPersonalTouch] = [
        EasterPersonalTouch(
            message: "He is risen! Wishing you a blessed Easter",
            tone: .blessed
        ),
        EasterPersonalTouch(
            message: "May the joy of Easter fill your heart with hope",
            tone: .hopeful
        ),
        EasterPersonalTouch(
            message: "Celebrating new life and fresh beginnings",
            tone: .joyful
        ),
        EasterPersonalTouch(
            message: "Easter blessings of peace and renewal",
            tone: .peaceful
        ),
        EasterPersonalTouch(
            message: "May this Easter bring you joy and happiness",
            tone: .renewing
        ),
        EasterPersonalTouch(
            message: "Wishing you the miracle of Easter's hope",
            tone: .miraculous
        )
    ]

    static let personalMessagePlaceholder = "Add your own personal Easter message here..."
    static let maxPersonalMessageLength = 200
}

// MARK: - Easter Selection State
struct EasterSelectionState: Codable {
    var selectedTheme: EasterTheme?
    var selectedGift: String?
    var selectedElements: [EasterElement] = []
    var selectedColorPalette: EasterColorPalette?
    var selectedOptionalMessage: EasterPersonalTouch?
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
