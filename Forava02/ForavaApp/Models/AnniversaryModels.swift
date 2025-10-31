import Foundation
import SwiftUI

// MARK: - Anniversary Theme Structure
enum AnniversaryTheme: String, Codable, CaseIterable {
    case romantic = "Romantic"
    case milestone = "Milestone"
    case family = "Family"
    case achievement = "Achievement"

    var description: String {
        switch self {
        case .romantic:
            return "Intimate celebration of love and partnership with flowing romantic patterns, soft hearts, elegant floral accents, dreamy atmosphere, tender emotional expression"
        case .milestone:
            return "Commemorating significant achievements with golden celebration energy, triumph symbols, radiant success markers, festive jubilation, accomplishment visualization"
        case .family:
            return "Honoring family bonds with warm connected patterns, generational legacy symbols, heritage visualization, unity and togetherness, cozy familial atmosphere"
        case .achievement:
            return "Celebrating personal and professional accomplishments with success visualization, ascending progress patterns, victory symbols, excellence markers, inspirational triumph energy"
        }
    }

    var primaryColor: Color {
        switch self {
        case .romantic:
            return Color(hex: "#DC143C") // Deep Red
        case .milestone:
            return Color(hex: "#FFD700") // Gold
        case .family:
            return Color(hex: "#228B22") // Forest Green
        case .achievement:
            return Color(hex: "#4169E1") // Royal Blue
        }
    }
}

// MARK: - Anniversary Design Elements
struct AnniversaryElement: Identifiable, Codable {
    let id: UUID
    let name: String
    let weight: Double // SDXL emphasis weight (1.4-1.5 for centerpiece presence)
    let aiPromptModifier: String

    init(name: String, weight: Double, aiPromptModifier: String) {
        self.id = UUID()
        self.name = name
        self.weight = weight
        self.aiPromptModifier = aiPromptModifier
    }
}

// MARK: - Anniversary Elements Collection
extension AnniversaryElement {
    static let allElements: [AnniversaryElement] = [
        // All elements are centerpieces - user selects exactly ONE
        AnniversaryElement(
            name: "Hearts",
            weight: 2.2,
            aiPromptModifier: "(large flowing hearts:2.2), romantic red hearts"
        ),
        AnniversaryElement(
            name: "Trophy",
            weight: 2.5,
            aiPromptModifier: "(golden sports trophy cup:2.5), inanimate award trophy, NOT a bust, NOT a statue, celebration prize"
        ),
        AnniversaryElement(
            name: "Champagne",
            weight: 2.2,
            aiPromptModifier: "(champagne bottle glasses:2.2), celebration toast"
        ),
        AnniversaryElement(
            name: "Flowers",
            weight: 2.2,
            aiPromptModifier: "(romantic flowers bouquet:2.2), elegant blooms"
        )
    ]
}

// MARK: - Anniversary Color Palettes
struct AnniversaryColorPalette: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let primaryColor: String        // Hex code (e.g., "#DC143C")
    let secondaryColor: String      // Hex code
    let accentColor: String         // Hex code
    let primaryColorName: String    // Descriptive name for AI (e.g., "deep crimson red")
    let secondaryColorName: String  // Descriptive name for AI
    let accentColorName: String     // Descriptive name for AI
    let primaryColorSimple: String  // SDXL-weighted prompt syntax (e.g., "(rich vibrant red:1.6)")
    let secondaryColorSimple: String // SDXL-weighted prompt syntax (e.g., "(warm gold:1.5)")
    let accentColorSimple: String   // SDXL-weighted prompt syntax (e.g., "(soft cream:1.4)")
    let primaryColorBase: String    // Base color name for exclusion logic (e.g., "red")
    let secondaryColorBase: String  // Base color name for exclusion logic (e.g., "gold")
    let accentColorBase: String     // Base color name for exclusion logic (e.g., "cream")
    let backgroundHint: String

    // swiftlint:disable:next line_length
    init(name: String, description: String, primaryColor: String, secondaryColor: String, accentColor: String, primaryColorName: String, secondaryColorName: String, accentColorName: String, primaryColorSimple: String, secondaryColorSimple: String, accentColorSimple: String, primaryColorBase: String, secondaryColorBase: String, accentColorBase: String, backgroundHint: String) {
        self.id = UUID()
        self.name = name
        self.description = description
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.accentColor = accentColor
        self.primaryColorName = primaryColorName
        self.secondaryColorName = secondaryColorName
        self.accentColorName = accentColorName
        self.primaryColorSimple = primaryColorSimple
        self.secondaryColorSimple = secondaryColorSimple
        self.accentColorSimple = accentColorSimple
        self.primaryColorBase = primaryColorBase
        self.secondaryColorBase = secondaryColorBase
        self.accentColorBase = accentColorBase
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

// MARK: - Anniversary Color Palettes Collection
extension AnniversaryColorPalette {
    static let allPalettes: [AnniversaryColorPalette] = [
        AnniversaryColorPalette(
            name: "Classic Romance",
            description: "Deep red and rose gold elegance",
            primaryColor: "#DC143C",
            secondaryColor: "#E6C2A6",
            accentColor: "#FDF5E6",
            primaryColorName: "deep crimson red",
            secondaryColorName: "warm rose gold",
            accentColorName: "soft cream",
            primaryColorSimple: "(vibrant red:2.0)",
            secondaryColorSimple: "(gold:1.8)",
            accentColorSimple: "(cream:1.6)",
            primaryColorBase: "red",
            secondaryColorBase: "gold",
            accentColorBase: "cream",
            backgroundHint: "romantic candlelit atmosphere with warm glow"
        ),
        AnniversaryColorPalette(
            name: "Golden Years",
            description: "Luxurious golden celebration",
            primaryColor: "#FFD700",
            secondaryColor: "#F5DEB3",
            accentColor: "#FFF8DC",
            primaryColorName: "rich golden yellow",
            secondaryColorName: "pale wheat beige",
            accentColorName: "cornsilk white",
            primaryColorSimple: "(gold:2.0)",
            secondaryColorSimple: "(beige:1.8)",
            accentColorSimple: "(white:1.6)",
            primaryColorBase: "gold",
            secondaryColorBase: "beige",
            accentColorBase: "white",
            backgroundHint: "warm radiant golden glow with shimmer"
        ),
        AnniversaryColorPalette(
            name: "Silver Celebration",
            description: "Elegant silver and ice blue",
            primaryColor: "#C0C0C0",
            secondaryColor: "#F0F8FF",
            accentColor: "#4682B4",
            primaryColorName: "metallic silver",
            secondaryColorName: "pale ice blue",
            accentColorName: "steel blue",
            primaryColorSimple: "(silver:2.0)",
            secondaryColorSimple: "(ice blue:1.8)",
            accentColorSimple: "(steel blue:1.6)",
            primaryColorBase: "silver",
            secondaryColorBase: "blue",
            accentColorBase: "blue",
            backgroundHint: "sophisticated silver shimmer with cool elegance"
        ),
        AnniversaryColorPalette(
            name: "Ruby Passion",
            description: "Rich ruby and burgundy tones",
            primaryColor: "#9B111E",
            secondaryColor: "#800020",
            accentColor: "#FFC0CB",
            primaryColorName: "deep ruby red",
            secondaryColorName: "dark burgundy",
            accentColorName: "soft pink",
            primaryColorSimple: "(ruby red:2.0)",
            secondaryColorSimple: "(burgundy:1.8)",
            accentColorSimple: "(pink:1.6)",
            primaryColorBase: "red",
            secondaryColorBase: "burgundy",
            accentColorBase: "pink",
            backgroundHint: "passionate ruby atmosphere with romantic depth"
        )
    ]
}

// MARK: - Anniversary Personal Touch Messages
struct AnniversaryPersonalTouch: Identifiable, Codable {
    let id: UUID
    let message: String
    let tone: MessageTone

    init(message: String, tone: MessageTone) {
        self.id = UUID()
        self.message = message
        self.tone = tone
    }

    enum MessageTone: String, Codable, CaseIterable {
        case romantic = "Romantic"
        case celebratory = "Celebratory"
        case heartfelt = "Heartfelt"
        case inspiring = "Inspiring"
        case grateful = "Grateful"
        case joyful = "Joyful"

        var color: Color {
            switch self {
            case .romantic: return Color(hex: "#DC143C")
            case .celebratory: return Color(hex: "#FFD700")
            case .heartfelt: return Color(hex: "#FF69B4")
            case .inspiring: return Color(hex: "#4169E1")
            case .grateful: return Color(hex: "#228B22")
            case .joyful: return Color(hex: "#FF8C00")
            }
        }
    }
}

// MARK: - Anniversary Personal Touch Collection
extension AnniversaryPersonalTouch {
    static let optionalMessages: [AnniversaryPersonalTouch] = [
        AnniversaryPersonalTouch(
            message: "Celebrating another year of love and happiness",
            tone: .romantic
        ),
        AnniversaryPersonalTouch(
            message: "Here's to many more wonderful years together",
            tone: .celebratory
        ),
        AnniversaryPersonalTouch(
            message: "Commemorating this special milestone in your journey",
            tone: .heartfelt
        ),
        AnniversaryPersonalTouch(
            message: "Your love story continues to inspire",
            tone: .inspiring
        ),
        AnniversaryPersonalTouch(
            message: "Cherishing the memories and looking forward to more",
            tone: .grateful
        ),
        AnniversaryPersonalTouch(
            message: "Honoring the beautiful bond you share",
            tone: .joyful
        )
    ]

    static let personalMessagePlaceholder = "Add your own personal anniversary message here..."
    static let maxPersonalMessageLength = 200
}
