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
    let primaryHex: String
    let secondaryHex: String
    let accentHex: String
    let backgroundHex: String
    let aiColorHint: String

    init(name: String, description: String, primaryHex: String, secondaryHex: String, accentHex: String, backgroundHex: String, aiColorHint: String) {
        self.id = UUID()
        self.name = name
        self.description = description
        self.primaryHex = primaryHex
        self.secondaryHex = secondaryHex
        self.accentHex = accentHex
        self.backgroundHex = backgroundHex
        self.aiColorHint = aiColorHint
    }

    // Computed Color properties for SwiftUI
    var primary: Color {
        Color(hex: primaryHex)
    }

    var secondary: Color {
        Color(hex: secondaryHex)
    }

    var accent: Color {
        Color(hex: accentHex)
    }

    var background: Color {
        Color(hex: backgroundHex)
    }
}

// MARK: - Christmas Color Palettes Collection
extension ChristmasColorPalette {
    static let allPalettes: [ChristmasColorPalette] = [
        ChristmasColorPalette(
            name: "Classic",
            description: "Traditional Christmas colors",
            primaryHex: "#C41E3A",
            secondaryHex: "#228B22",
            accentHex: "#FFD700",
            backgroundHex: "#FFFFFF",
            aiColorHint: "warm winter atmosphere with traditional red and green Christmas tones"
        ),
        ChristmasColorPalette(
            name: "Winter Wonderland",
            description: "Cool winter tones",
            primaryHex: "#FFFFFF",
            secondaryHex: "#C0C0C0",
            accentHex: "#4169E1",
            backgroundHex: "#E6F3FF",
            aiColorHint: "snowy winter landscape with cool silvery blue tones"
        ),
        ChristmasColorPalette(
            name: "Golden Elegance",
            description: "Luxurious golden theme",
            primaryHex: "#FFD700",
            secondaryHex: "#F5F5DC",
            accentHex: "#800020",
            backgroundHex: "#FFF9E6",
            aiColorHint: "elegant golden glow with luxurious burgundy accents"
        ),
        ChristmasColorPalette(
            name: "Modern Minimalist",
            description: "Contemporary simplicity",
            primaryHex: "#000000",
            secondaryHex: "#FFFFFF",
            accentHex: "#FFD700",
            backgroundHex: "#F5F5F5",
            aiColorHint: "clean modern background with minimalist black, white, and gold palette"
        ),
        ChristmasColorPalette(
            name: "Rustic Charm",
            description: "Cozy cabin vibes",
            primaryHex: "#8B4513",
            secondaryHex: "#228B22",
            accentHex: "#DC143C",
            backgroundHex: "#F4EAD5",
            aiColorHint: "rustic wooden texture with warm brown and forest green tones"
        ),
        ChristmasColorPalette(
            name: "Festive Bright",
            description: "Vibrant holiday spirit",
            primaryHex: "#FF0000",
            secondaryHex: "#00FF00",
            accentHex: "#FFFFFF",
            backgroundHex: "#FFF5E6",
            aiColorHint: "bright festive atmosphere with vibrant red and green holiday colors"
        ),
        ChristmasColorPalette(
            name: "Royal Christmas",
            description: "Regal purple and gold",
            primaryHex: "#663399",
            secondaryHex: "#FFD700",
            accentHex: "#C0C0C0",
            backgroundHex: "#F0E6FF",
            aiColorHint: "royal velvet backdrop with regal purple, gold, and silver tones"
        ),
        ChristmasColorPalette(
            name: "Warm Cozy",
            description: "Fireplace warmth",
            primaryHex: "#FF8C00",
            secondaryHex: "#8B4513",
            accentHex: "#FFD700",
            backgroundHex: "#FFF0E6",
            aiColorHint: "warm fireplace glow with cozy orange, brown, and golden tones"
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
