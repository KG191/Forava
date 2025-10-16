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
            return "Intimate celebration of love and partnership"
        case .milestone:
            return "Commemorating significant achievements and years"
        case .family:
            return "Honoring family bonds and generational love"
        case .achievement:
            return "Celebrating personal and professional accomplishments"
        }
    }

    var giftOptions: [String] {
        switch self {
        case .romantic:
            return [
                "Classic Love Letter Card",
                "Romantic Garden Scene",
                "Elegant Couple Silhouette",
                "Heart Constellation Design",
                "Vintage Romance Card",
                "Modern Love Typography",
                "Sunset Together Scene",
                "Love Story Timeline"
            ]
        case .milestone:
            return [
                "Golden Years Celebration",
                "Milestone Number Design",
                "Achievement Timeline Card",
                "Memory Collage Style",
                "Progress Journey Map",
                "Celebration Fireworks",
                "Trophy Achievement Card",
                "Success Story Design"
            ]
        case .family:
            return [
                "Family Tree Design",
                "Generational Legacy Card",
                "Family Photo Mosaic",
                "Home & Hearts Theme",
                "Family Crest Style",
                "Heritage Celebration",
                "Unity Symbol Design",
                "Family Bond Circle"
            ]
        case .achievement:
            return [
                "Career Milestone Card",
                "Educational Achievement",
                "Personal Growth Journey",
                "Success Story Design",
                "Professional Recognition",
                "Goal Achievement Theme",
                "Excellence Award Style",
                "Accomplishment Timeline"
            ]
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

// MARK: - Anniversary Elements Collection
extension AnniversaryElement {
    static let allElements: [AnniversaryElement] = [
        // Centre Pieces (Priority 90-100)
        AnniversaryElement(
            name: "Hearts",
            category: .centrePiece,
            priority: 100,
            aiPromptModifier: "elegant hearts as central focal point, romantic and loving"
        ),
        AnniversaryElement(
            name: "Rings",
            category: .centrePiece,
            priority: 95,
            aiPromptModifier: "beautiful rings as centerpiece, symbolizing unity and commitment"
        ),
        AnniversaryElement(
            name: "Calendar",
            category: .centrePiece,
            priority: 92,
            aiPromptModifier: "special date calendar as focal point, marking important milestones"
        ),
        AnniversaryElement(
            name: "Trophy",
            category: .centrePiece,
            priority: 90,
            aiPromptModifier: "achievement trophy as centerpiece, celebrating accomplishments"
        ),

        // Supporting Elements (Priority 50-80)
        AnniversaryElement(
            name: "Flowers",
            category: .supportingElement,
            priority: 80,
            aiPromptModifier: "beautiful flowers as romantic decorative accents"
        ),
        AnniversaryElement(
            name: "Champagne",
            category: .supportingElement,
            priority: 75,
            aiPromptModifier: "celebratory champagne as festive embellishments"
        ),
        AnniversaryElement(
            name: "Confetti",
            category: .supportingElement,
            priority: 70,
            aiPromptModifier: "joyful confetti as celebration border elements"
        ),
        AnniversaryElement(
            name: "Ribbon",
            category: .supportingElement,
            priority: 65,
            aiPromptModifier: "elegant ribbons as decorative flourishes"
        )
    ]

    static var centrePieces: [AnniversaryElement] {
        return allElements.filter { $0.category == .centrePiece }.sorted { $0.priority > $1.priority }
    }

    static var supportingElements: [AnniversaryElement] {
        return allElements.filter { $0.category == .supportingElement }.sorted { $0.priority > $1.priority }
    }
}

// MARK: - Anniversary Color Palettes
struct AnniversaryColorPalette: Identifiable, Codable {
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

// MARK: - Anniversary Color Palettes Collection
extension AnniversaryColorPalette {
    static let allPalettes: [AnniversaryColorPalette] = [
        AnniversaryColorPalette(
            name: "Classic Romance",
            description: "Deep red and rose gold elegance",
            primaryColor: "#DC143C",
            secondaryColor: "#E6C2A6",
            accentColor: "#FDF5E6",
            backgroundHint: "romantic candlelit atmosphere"
        ),
        AnniversaryColorPalette(
            name: "Golden Years",
            description: "Luxurious golden celebration",
            primaryColor: "#FFD700",
            secondaryColor: "#F5DEB3",
            accentColor: "#FFF8DC",
            backgroundHint: "warm golden glow"
        ),
        AnniversaryColorPalette(
            name: "Silver Celebration",
            description: "Elegant silver and ice blue",
            primaryColor: "#C0C0C0",
            secondaryColor: "#F0F8FF",
            accentColor: "#4682B4",
            backgroundHint: "sophisticated silver shimmer"
        ),
        AnniversaryColorPalette(
            name: "Ruby Passion",
            description: "Rich ruby and burgundy tones",
            primaryColor: "#9B111E",
            secondaryColor: "#800020",
            accentColor: "#FFC0CB",
            backgroundHint: "passionate ruby atmosphere"
        ),
        AnniversaryColorPalette(
            name: "Elegant Black",
            description: "Sophisticated black and gold",
            primaryColor: "#000000",
            secondaryColor: "#FFD700",
            accentColor: "#FFFFFF",
            backgroundHint: "elegant black tie event"
        ),
        AnniversaryColorPalette(
            name: "Soft Pastels",
            description: "Gentle pastel harmony",
            primaryColor: "#FFB6C1",
            secondaryColor: "#E6E6FA",
            accentColor: "#F0FFF0",
            backgroundHint: "soft dreamy atmosphere"
        ),
        AnniversaryColorPalette(
            name: "Modern Minimalist",
            description: "Clean contemporary design",
            primaryColor: "#36454F",
            secondaryColor: "#E6C2A6",
            accentColor: "#FFFFFF",
            backgroundHint: "clean modern background"
        ),
        AnniversaryColorPalette(
            name: "Vintage Love",
            description: "Warm vintage romance",
            primaryColor: "#DEB887",
            secondaryColor: "#F5DEB3",
            accentColor: "#FFF8DC",
            backgroundHint: "vintage sepia warmth"
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

