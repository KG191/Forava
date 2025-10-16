import Foundation
import SwiftUI

// MARK: - Hanukkah Theme Structure
enum HanukkahTheme: String, Codable, CaseIterable {
    case traditional = "Traditional"
    case miracle = "Miracle"
    case family = "Family"
    case modern = "Modern"

    var description: String {
        switch self {
        case .traditional:
            return "Classic Hanukkah with authentic religious elements"
        case .miracle:
            return "Celebrating the miracle of oil and divine intervention"
        case .family:
            return "Family traditions, games, and celebration"
        case .modern:
            return "Contemporary Hanukkah with modern artistic elements"
        }
    }

    var giftOptions: [String] {
        switch self {
        case .traditional:
            return [
                "Traditional Menorah Light",
                "Classic Dreidel Game",
                "Hebrew Prayer Card",
                "Traditional Family Scene",
                "Sacred Oil Miracle",
                "Temple Rededication",
                "Religious Freedom Card",
                "Classic Festival Scene"
            ]
        case .miracle:
            return [
                "Miracle Oil Jar",
                "Eight Days Light",
                "Divine Intervention",
                "Sacred Light Miracle",
                "Temple Oil Story",
                "Miraculous Flame",
                "Eight Candle Glow",
                "Sacred Miracle Card"
            ]
        case .family:
            return [
                "Family Menorah Lighting",
                "Dreidel Game Night",
                "Hanukkah Gift Exchange",
                "Family Gathering Card",
                "Eight Nights Together",
                "Traditional Family Feast",
                "Children Playing Dreidel",
                "Family Celebration Scene"
            ]
        case .modern:
            return [
                "Modern Menorah Design",
                "Contemporary Star Art",
                "Minimalist Hanukkah",
                "Digital Candle Light",
                "Modern Hebrew Typography",
                "Stylized Dreidel Art",
                "Contemporary Festival Card",
                "Modern Jewish Art"
            ]
        }
    }

    var primaryColor: Color {
        switch self {
        case .traditional:
            return Color(hex: "#0047AB") // Traditional Blue
        case .miracle:
            return Color(hex: "#FFD700") // Menorah Gold
        case .family:
            return Color(hex: "#4169E1") // Family Blue
        case .modern:
            return Color(hex: "#000000") // Modern Black
        }
    }
}

// MARK: - Hanukkah Design Elements
struct HanukkahElement: Identifiable, Codable {
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

// MARK: - Hanukkah Elements Collection
extension HanukkahElement {
    static let allElements: [HanukkahElement] = [
        // Centre Pieces (Priority 90-100)
        HanukkahElement(
            name: "Menorah",
            category: .centrePiece,
            priority: 100,
            aiPromptModifier: "magnificent nine-branched menorah as central focal point, glowing with sacred light"
        ),
        HanukkahElement(
            name: "Star of David",
            category: .centrePiece,
            priority: 95,
            aiPromptModifier: "beautiful Star of David as centerpiece, symbolizing Jewish faith and identity"
        ),
        HanukkahElement(
            name: "Dreidel",
            category: .centrePiece,
            priority: 92,
            aiPromptModifier: "traditional dreidel as focal point, representing Hanukkah games and joy"
        ),
        HanukkahElement(
            name: "Hanukkah Candles",
            category: .centrePiece,
            priority: 90,
            aiPromptModifier: "eight glowing Hanukkah candles as centerpiece, representing the miracle of light"
        ),

        // Supporting Elements (Priority 50-80)
        HanukkahElement(
            name: "Oil Jug",
            category: .supportingElement,
            priority: 80,
            aiPromptModifier: "sacred oil jug as decorative element, symbolizing the miracle of oil"
        ),
        HanukkahElement(
            name: "Hebrew Letters",
            category: .supportingElement,
            priority: 75,
            aiPromptModifier: "beautiful Hebrew letters as cultural embellishments"
        ),
        HanukkahElement(
            name: "Blue & White Ribbons",
            category: .supportingElement,
            priority: 70,
            aiPromptModifier: "elegant blue and white ribbons as decorative border elements"
        ),
        HanukkahElement(
            name: "Gelt Coins",
            category: .supportingElement,
            priority: 65,
            aiPromptModifier: "traditional chocolate gelt coins as festive accents"
        )
    ]

    static var centrePieces: [HanukkahElement] {
        return allElements.filter { $0.category == .centrePiece }.sorted { $0.priority > $1.priority }
    }

    static var supportingElements: [HanukkahElement] {
        return allElements.filter { $0.category == .supportingElement }.sorted { $0.priority > $1.priority }
    }
}

// MARK: - Hanukkah Color Palettes
struct HanukkahColorPalette: Identifiable, Codable {
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

// MARK: - Hanukkah Color Palettes Collection
extension HanukkahColorPalette {
    static let allPalettes: [HanukkahColorPalette] = [
        HanukkahColorPalette(
            name: "Traditional Blue",
            description: "Royal Blue, Gold, and White",
            primaryColor: "#0047AB",
            secondaryColor: "#FFD700",
            accentColor: "#FFFFFF",
            backgroundHint: "traditional blue and gold atmosphere"
        ),
        HanukkahColorPalette(
            name: "Menorah Gold",
            description: "Multiple Gold Shades with Blue Accents",
            primaryColor: "#FFD700",
            secondaryColor: "#FFA500",
            accentColor: "#4169E1",
            backgroundHint: "warm golden menorah glow"
        ),
        HanukkahColorPalette(
            name: "Winter Festival",
            description: "Silver, Ice Blue, and White",
            primaryColor: "#C0C0C0",
            secondaryColor: "#B0E0E6",
            accentColor: "#FFFFFF",
            backgroundHint: "winter festival shimmer"
        ),
        HanukkahColorPalette(
            name: "Classic Hanukkah",
            description: "Navy Blue, Silver, and Cream",
            primaryColor: "#000080",
            secondaryColor: "#C0C0C0",
            accentColor: "#F5F5DC",
            backgroundHint: "classic Hanukkah elegance"
        ),
        HanukkahColorPalette(
            name: "Miracle Light",
            description: "Bright Blue, Gold, and Yellow",
            primaryColor: "#1E90FF",
            secondaryColor: "#FFD700",
            accentColor: "#FFFF00",
            backgroundHint: "brilliant miracle light"
        ),
        HanukkahColorPalette(
            name: "Family Celebration",
            description: "Warm Blue, Gold, and Beige",
            primaryColor: "#4682B4",
            secondaryColor: "#DAA520",
            accentColor: "#F5F5DC",
            backgroundHint: "warm family gathering"
        ),
        HanukkahColorPalette(
            name: "Modern Minimalist",
            description: "Black, White, and Blue Accent",
            primaryColor: "#000000",
            secondaryColor: "#FFFFFF",
            accentColor: "#0066CC",
            backgroundHint: "clean modern background"
        ),
        HanukkahColorPalette(
            name: "Elegant Silver",
            description: "Silver, Pearl White, and Soft Blue",
            primaryColor: "#C0C0C0",
            secondaryColor: "#F8F8FF",
            accentColor: "#87CEEB",
            backgroundHint: "elegant silver sophistication"
        )
    ]
}

// MARK: - Hanukkah Personal Touch Messages
struct HanukkahPersonalTouch: Identifiable, Codable {
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
        case joyful = "Joyful"
        case peaceful = "Peaceful"
        case miraculous = "Miraculous"
        case festive = "Festive"
        case loving = "Loving"

        var color: Color {
            switch self {
            case .blessed: return Color(hex: "#4169E1")
            case .joyful: return Color(hex: "#FFD700")
            case .peaceful: return Color(hex: "#87CEEB")
            case .miraculous: return Color(hex: "#9370DB")
            case .festive: return Color(hex: "#0047AB")
            case .loving: return Color(hex: "#FF69B4")
            }
        }
    }
}

// MARK: - Hanukkah Personal Touch Collection
extension HanukkahPersonalTouch {
    static let optionalMessages: [HanukkahPersonalTouch] = [
        HanukkahPersonalTouch(
            message: "חג שמח! Happy Hanukkah and Festival of Lights!",
            tone: .blessed
        ),
        HanukkahPersonalTouch(
            message: "May the miracle of Hanukkah brighten your home",
            tone: .miraculous
        ),
        HanukkahPersonalTouch(
            message: "Wishing you eight nights of joy and light",
            tone: .joyful
        ),
        HanukkahPersonalTouch(
            message: "May the Hanukkah lights bring peace and happiness",
            tone: .peaceful
        ),
        HanukkahPersonalTouch(
            message: "Celebrating religious freedom and faith",
            tone: .festive
        ),
        HanukkahPersonalTouch(
            message: "May your Hanukkah be filled with light and love",
            tone: .loving
        )
    ]

    static let personalMessagePlaceholder = "Add your own personal Hanukkah message here..."
    static let maxPersonalMessageLength = 200
}

