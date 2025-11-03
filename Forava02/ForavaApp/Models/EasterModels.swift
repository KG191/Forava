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
    let primaryHex: String
    let secondaryHex: String
    let accentHex: String
    let backgroundHex: String
    let aiColorHint: String

    init(
        name: String,
        description: String,
        primaryHex: String,
        secondaryHex: String,
        accentHex: String,
        backgroundHex: String,
        aiColorHint: String
    ) {
        self.id = UUID()
        self.name = name
        self.description = description
        self.primaryHex = primaryHex
        self.secondaryHex = secondaryHex
        self.accentHex = accentHex
        self.backgroundHex = backgroundHex
        self.aiColorHint = aiColorHint
    }

    // Computed properties for SwiftUI Color conversion
    var primaryColor: Color { Color(hex: primaryHex) }
    var secondaryColor: Color { Color(hex: secondaryHex) }
    var accentColor: Color { Color(hex: accentHex) }
    var backgroundColor: Color { Color(hex: backgroundHex) }
}

// MARK: - Easter Color Palettes Collection
extension EasterColorPalette {
    static let allPalettes: [EasterColorPalette] = [
        EasterColorPalette(
            name: "Pastel Spring",
            description: "Soft Pink, Baby Blue, Mint Green",
            primaryHex: "#FFB6C1",
            secondaryHex: "#ADD8E6",
            accentHex: "#98FB98",
            backgroundHex: "#F0F8FF",
            aiColorHint: "gentle spring morning atmosphere with soft pastels"
        ),
        EasterColorPalette(
            name: "Golden Sunrise",
            description: "Gold, Warm Yellow, Light Orange",
            primaryHex: "#FFD700",
            secondaryHex: "#FFFF00",
            accentHex: "#FFE4B5",
            backgroundHex: "#FFA500",
            aiColorHint: "warm Easter sunrise glow with golden tones"
        ),
        EasterColorPalette(
            name: "Traditional Easter",
            description: "Purple, White, Gold",
            primaryHex: "#8A2BE2",
            secondaryHex: "#FFFFFF",
            accentHex: "#FFD700",
            backgroundHex: "#4B0082",
            aiColorHint: "traditional Easter atmosphere with royal purple"
        ),
        EasterColorPalette(
            name: "Garden Fresh",
            description: "Fresh Green, Lavender, White",
            primaryHex: "#90EE90",
            secondaryHex: "#E6E6FA",
            accentHex: "#FFFFFF",
            backgroundHex: "#228B22",
            aiColorHint: "fresh spring garden setting with green growth"
        ),
        EasterColorPalette(
            name: "Bunny Soft",
            description: "Cream, Soft Brown, Pink",
            primaryHex: "#F5F5DC",
            secondaryHex: "#D2B48C",
            accentHex: "#FFC0CB",
            backgroundHex: "#A0826D",
            aiColorHint: "soft bunny fur texture with warm cream tones"
        ),
        EasterColorPalette(
            name: "Egg Hunt Colors",
            description: "Bright Multi-colors on White",
            primaryHex: "#FF6347",
            secondaryHex: "#32CD32",
            accentHex: "#FF69B4",
            backgroundHex: "#F5F5F5",
            aiColorHint: "bright festive egg hunt scene with vibrant colors"
        ),
        EasterColorPalette(
            name: "Modern Minimalist",
            description: "White, Sage Green, Gold Accent",
            primaryHex: "#FFFFFF",
            secondaryHex: "#9CAF88",
            accentHex: "#FFD700",
            backgroundHex: "#708238",
            aiColorHint: "clean modern Easter background with sage green"
        ),
        EasterColorPalette(
            name: "Resurrection Glory",
            description: "Pure White, Gold, Light Blue",
            primaryHex: "#FFFFFF",
            secondaryHex: "#FFD700",
            accentHex: "#87CEEB",
            backgroundHex: "#4682B4",
            aiColorHint: "radiant morning light with golden glory"
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

