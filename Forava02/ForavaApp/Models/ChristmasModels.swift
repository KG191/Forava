import Foundation
import SwiftUI

// MARK: - Christmas Theme Structure
enum ChristmasTheme: String, Codable, CaseIterable {
    case traditional = "Traditional"
    case modern = "Modern"
    case elegant = "Elegant"
    case spiritual = "Spiritual"

    var description: String {
        switch self {
        case .traditional:
            return "Classic Christmas spirit with timeless holiday charm"
        case .modern:
            return "Contemporary Christmas style with sleek design elements"
        case .elegant:
            return "Sophisticated Christmas aesthetics with refined beauty"
        case .spiritual:
            return "Sacred Christmas meaning with divine inspirations"
        }
    }

    var giftOptions: [String] {
        switch self {
        case .traditional:
            return [
                "Classic Christmas Tree Card",
                "Traditional Santa Card",
                "Holly & Mistletoe Card",
                "Candy Cane Border Card",
                "Christmas Wreath Card",
                "Vintage Ornament Card",
                "Classic Fireplace Scene",
                "Traditional Family Card"
            ]
        case .modern:
            return [
                "Minimalist Tree Design",
                "Geometric Christmas Card",
                "Contemporary Holiday Card",
                "Modern Typography Card",
                "Sleek Winter Landscape",
                "Abstract Christmas Card",
                "Urban Holiday Style",
                "Digital Art Christmas"
            ]
        case .elegant:
            return [
                "Luxury Gold Christmas Card",
                "Sophisticated Winter Card",
                "Premium Holiday Design",
                "Elegant Ornament Card",
                "Refined Christmas Scene",
                "Classy Holiday Greeting",
                "Upscale Christmas Card",
                "Distinguished Holiday Style"
            ]
        case .spiritual:
            return [
                "Nativity Scene Card",
                "Angel Christmas Card",
                "Holy Star Design",
                "Sacred Christmas Card",
                "Peaceful Winter Card",
                "Divine Light Christmas",
                "Blessed Holiday Card",
                "Spiritual Christmas Scene"
            ]
        }
    }

    var primaryColor: Color {
        switch self {
        case .traditional:
            return Color(hex: "#C41E3A") // Christmas Red
        case .modern:
            return Color(hex: "#2C3E50") // Modern Dark Blue
        case .elegant:
            return Color(hex: "#8B4513") // Elegant Brown
        case .spiritual:
            return Color(hex: "#4169E1") // Spiritual Blue
        }
    }
}

// MARK: - Christmas Design Elements
struct ChristmasElement: Identifiable, Codable {
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

// MARK: - Christmas Elements Collection
extension ChristmasElement {
    static let allElements: [ChristmasElement] = [
        // Centre Pieces (Priority 90-100)
        ChristmasElement(
            name: "Christmas Tree",
            category: .centrePiece,
            priority: 100,
            aiPromptModifier: "magnificent Christmas tree as central focal point, decorated with ornaments and lights"
        ),
        ChristmasElement(
            name: "Santa",
            category: .centrePiece,
            priority: 95,
            aiPromptModifier: "jolly Santa Claus as main character, warm and welcoming presence"
        ),
        ChristmasElement(
            name: "Angel",
            category: .centrePiece,
            priority: 92,
            aiPromptModifier: "beautiful Christmas angel as centerpiece, ethereal and graceful"
        ),
        ChristmasElement(
            name: "Star",
            category: .centrePiece,
            priority: 90,
            aiPromptModifier: "brilliant Christmas star as focal point, radiant and guiding"
        ),

        // Supporting Elements (Priority 50-80)
        ChristmasElement(
            name: "Holly",
            category: .supportingElement,
            priority: 80,
            aiPromptModifier: "festive holly leaves and berries as decorative accents"
        ),
        ChristmasElement(
            name: "Bells",
            category: .supportingElement,
            priority: 75,
            aiPromptModifier: "jingling Christmas bells as cheerful embellishments"
        ),
        ChristmasElement(
            name: "Candy Canes",
            category: .supportingElement,
            priority: 70,
            aiPromptModifier: "striped candy canes as playful border elements"
        ),
        ChristmasElement(
            name: "Ornaments",
            category: .supportingElement,
            priority: 65,
            aiPromptModifier: "colorful Christmas ornaments as scattered decorations"
        )
    ]

    static var centrePieces: [ChristmasElement] {
        return allElements.filter { $0.category == .centrePiece }.sorted { $0.priority > $1.priority }
    }

    static var supportingElements: [ChristmasElement] {
        return allElements.filter { $0.category == .supportingElement }.sorted { $0.priority > $1.priority }
    }
}

// MARK: - Christmas Color Palettes
struct ChristmasColorPalette: Identifiable, Codable {
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

// MARK: - Christmas Color Palettes Collection
extension ChristmasColorPalette {
    static let allPalettes: [ChristmasColorPalette] = [
        ChristmasColorPalette(
            name: "Classic",
            description: "Traditional Christmas colors",
            primaryColor: "#C41E3A",
            secondaryColor: "#228B22",
            accentColor: "#FFD700",
            backgroundHint: "warm winter atmosphere"
        ),
        ChristmasColorPalette(
            name: "Winter Wonderland",
            description: "Cool winter tones",
            primaryColor: "#FFFFFF",
            secondaryColor: "#C0C0C0",
            accentColor: "#4169E1",
            backgroundHint: "snowy winter landscape"
        ),
        ChristmasColorPalette(
            name: "Golden Elegance",
            description: "Luxurious golden theme",
            primaryColor: "#FFD700",
            secondaryColor: "#F5F5DC",
            accentColor: "#800020",
            backgroundHint: "elegant golden glow"
        ),
        ChristmasColorPalette(
            name: "Modern Minimalist",
            description: "Contemporary simplicity",
            primaryColor: "#000000",
            secondaryColor: "#FFFFFF",
            accentColor: "#FFD700",
            backgroundHint: "clean modern background"
        ),
        ChristmasColorPalette(
            name: "Rustic Charm",
            description: "Cozy cabin vibes",
            primaryColor: "#8B4513",
            secondaryColor: "#228B22",
            accentColor: "#DC143C",
            backgroundHint: "rustic wooden texture"
        ),
        ChristmasColorPalette(
            name: "Festive Bright",
            description: "Vibrant holiday spirit",
            primaryColor: "#FF0000",
            secondaryColor: "#00FF00",
            accentColor: "#FFFFFF",
            backgroundHint: "bright festive atmosphere"
        ),
        ChristmasColorPalette(
            name: "Royal Christmas",
            description: "Regal purple and gold",
            primaryColor: "#663399",
            secondaryColor: "#FFD700",
            accentColor: "#C0C0C0",
            backgroundHint: "royal velvet backdrop"
        ),
        ChristmasColorPalette(
            name: "Warm Cozy",
            description: "Fireplace warmth",
            primaryColor: "#FF8C00",
            secondaryColor: "#8B4513",
            accentColor: "#FFD700",
            backgroundHint: "warm fireplace glow"
        )
    ]
}

// MARK: - Christmas Personal Touch Messages
struct ChristmasPersonalTouch: Identifiable, Codable {
    let id: UUID
    let message: String
    let tone: MessageTone

    init(message: String, tone: MessageTone) {
        self.id = UUID()
        self.message = message
        self.tone = tone
    }

    enum MessageTone: String, Codable, CaseIterable {
        case peaceful = "Peaceful"
        case joyful = "Joyful"
        case warm = "Warm"
        case magical = "Magical"
        case blessed = "Blessed"
        case bright = "Bright"

        var color: Color {
            switch self {
            case .peaceful: return Color(hex: "#4169E1")
            case .joyful: return Color(hex: "#FFD700")
            case .warm: return Color(hex: "#FF8C00")
            case .magical: return Color(hex: "#9370DB")
            case .blessed: return Color(hex: "#228B22")
            case .bright: return Color(hex: "#FF69B4")
            }
        }
    }
}

// MARK: - Christmas Personal Touch Collection
extension ChristmasPersonalTouch {
    static let optionalMessages: [ChristmasPersonalTouch] = [
        ChristmasPersonalTouch(
            message: "Wishing you peace and joy this Christmas",
            tone: .peaceful
        ),
        ChristmasPersonalTouch(
            message: "May your holidays sparkle with joy and laughter",
            tone: .joyful
        ),
        ChristmasPersonalTouch(
            message: "Sending warm Christmas wishes your way",
            tone: .warm
        ),
        ChristmasPersonalTouch(
            message: "May the magic of Christmas fill your heart",
            tone: .magical
        ),
        ChristmasPersonalTouch(
            message: "Christmas blessings and New Year joy",
            tone: .blessed
        ),
        ChristmasPersonalTouch(
            message: "Hope your Christmas is merry and bright",
            tone: .bright
        )
    ]

    static let personalMessagePlaceholder = "Add your own personal Christmas message here..."
    static let maxPersonalMessageLength = 200
}

