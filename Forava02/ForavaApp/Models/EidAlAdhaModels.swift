import Foundation
import SwiftUI

// MARK: - Eid al-Adha Theme Structure
enum EidAlAdhaTheme: String, Codable, CaseIterable {
    case traditional = "Traditional"
    case modern = "Modern"
    case spiritual = "Spiritual"
    case festive = "Festive"

    var description: String {
        switch self {
        case .traditional:
            return "Classic Islamic aesthetics with timeless spiritual elements"
        case .modern:
            return "Contemporary Islamic design with sleek geometric patterns"
        case .spiritual:
            return "Sacred meanings with devotional inspirations"
        case .festive:
            return "Vibrant celebration with joyful family gathering vibes"
        }
    }

    var giftOptions: [String] {
        switch self {
        case .traditional:
            return [
                "Classic Mosque Card",
                "Traditional Crescent Moon",
                "Heritage Kaaba Design",
                "Classic Islamic Calligraphy",
                "Traditional Geometric Pattern",
                "Vintage Lantern Card",
                "Classic Prayer Mat Design",
                "Traditional Family Gathering"
            ]
        case .modern:
            return [
                "Minimalist Mosque Design",
                "Contemporary Geometric Card",
                "Modern Crescent Moon",
                "Sleek Typography Card",
                "Abstract Islamic Art",
                "Modern Lantern Style",
                "Digital Islamic Pattern",
                "Contemporary Celebration"
            ]
        case .spiritual:
            return [
                "Sacred Kaaba Scene",
                "Devotional Prayer Card",
                "Spiritual Reflection Design",
                "Blessed Sacrifice Theme",
                "Divine Light Card",
                "Sacred Islamic Calligraphy",
                "Peaceful Worship Scene",
                "Spiritual Blessings Card"
            ]
        case .festive:
            return [
                "Vibrant Celebration Card",
                "Joyful Family Gathering",
                "Festive Lanterns Design",
                "Colorful Geometric Pattern",
                "Bright Eid Celebration",
                "Happy Family Card",
                "Festive Mosque Scene",
                "Joyous Celebration Design"
            ]
        }
    }

    var primaryColor: Color {
        switch self {
        case .traditional:
            return Color(hex: "#2E7D32") // Islamic Green
        case .modern:
            return Color(hex: "#00796B") // Modern Teal
        case .spiritual:
            return Color(hex: "#4A148C") // Spiritual Purple
        case .festive:
            return Color(hex: "#F57C00") // Festive Orange
        }
    }
}

// MARK: - Eid al-Adha Design Elements
struct EidAlAdhaElement: Identifiable, Codable {
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

// MARK: - Eid al-Adha Elements Collection
extension EidAlAdhaElement {
    static let allElements: [EidAlAdhaElement] = [
        // Centre Pieces (Priority 90-100)
        EidAlAdhaElement(
            name: "Mosque",
            category: .centrePiece,
            priority: 100,
            aiPromptModifier: "majestic mosque with minarets as central focal point, architectural Islamic beauty"
        ),
        EidAlAdhaElement(
            name: "Crescent Moon",
            category: .centrePiece,
            priority: 95,
            aiPromptModifier: "luminous crescent moon as main symbol, radiant Islamic celestial beauty"
        ),
        EidAlAdhaElement(
            name: "Kaaba",
            category: .centrePiece,
            priority: 92,
            aiPromptModifier: "sacred Kaaba as centerpiece, spiritual focal point with devotional atmosphere"
        ),
        EidAlAdhaElement(
            name: "Islamic Star",
            category: .centrePiece,
            priority: 90,
            aiPromptModifier: "brilliant Islamic star as focal point, geometric radiance and spiritual light"
        ),

        // Supporting Elements (Priority 50-80)
        EidAlAdhaElement(
            name: "Lanterns",
            category: .supportingElement,
            priority: 80,
            aiPromptModifier: "elegant Islamic lanterns as decorative accents, warm glowing ambiance"
        ),
        EidAlAdhaElement(
            name: "Calligraphy",
            category: .supportingElement,
            priority: 75,
            aiPromptModifier: "beautiful Arabic calligraphy as artistic embellishment, flowing sacred script"
        ),
        EidAlAdhaElement(
            name: "Geometric Patterns",
            category: .supportingElement,
            priority: 70,
            aiPromptModifier: "intricate Islamic geometric patterns as border elements, mathematical sacred art"
        ),
        EidAlAdhaElement(
            name: "Prayer Mat",
            category: .supportingElement,
            priority: 65,
            aiPromptModifier: "ornate prayer mat as grounding element, devotional foundation imagery"
        )
    ]

    static var centrePieces: [EidAlAdhaElement] {
        return allElements.filter { $0.category == .centrePiece }.sorted { $0.priority > $1.priority }
    }

    static var supportingElements: [EidAlAdhaElement] {
        return allElements.filter { $0.category == .supportingElement }.sorted { $0.priority > $1.priority }
    }
}

// MARK: - Eid al-Adha Color Palettes
struct EidAlAdhaColorPalette: Identifiable, Codable {
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

// MARK: - Eid al-Adha Color Palettes Collection
extension EidAlAdhaColorPalette {
    static let allPalettes: [EidAlAdhaColorPalette] = [
        EidAlAdhaColorPalette(
            name: "Classic Green & Gold",
            description: "Traditional Islamic colors",
            primaryHex: "#2E7D32",
            secondaryHex: "#FFD700",
            accentHex: "#FFFFFF",
            backgroundHex: "#F5F5DC",
            aiColorHint: "traditional Islamic colors with green and gold tones, warm cream background"
        ),
        EidAlAdhaColorPalette(
            name: "Desert Sunset",
            description: "Warm Arabian tones",
            primaryHex: "#FF6B35",
            secondaryHex: "#F7931E",
            accentHex: "#8B4513",
            backgroundHex: "#FFF0E6",
            aiColorHint: "warm desert sunset with amber and earthy brown tones, soft peachy background"
        ),
        EidAlAdhaColorPalette(
            name: "Elegant White",
            description: "Pure and pristine",
            primaryHex: "#FFFFFF",
            secondaryHex: "#C0C0C0",
            accentHex: "#2E7D32",
            backgroundHex: "#F5F5F5",
            aiColorHint: "pure white with elegant silver and green accents, clean light background"
        ),
        EidAlAdhaColorPalette(
            name: "Modern Teal",
            description: "Contemporary serenity",
            primaryHex: "#00796B",
            secondaryHex: "#26A69A",
            accentHex: "#FFD700",
            backgroundHex: "#E0F2F1",
            aiColorHint: "modern teal with turquoise and gold accents, serene aqua background"
        ),
        EidAlAdhaColorPalette(
            name: "Royal Purple",
            description: "Regal spirituality",
            primaryHex: "#4A148C",
            secondaryHex: "#7B1FA2",
            accentHex: "#FFD700",
            backgroundHex: "#F3E5F5",
            aiColorHint: "royal purple with violet and gold accents, majestic lavender background"
        ),
        EidAlAdhaColorPalette(
            name: "Warm Earth",
            description: "Natural harmony",
            primaryHex: "#8B4513",
            secondaryHex: "#D2691E",
            accentHex: "#2E7D32",
            backgroundHex: "#F4EAD5",
            aiColorHint: "warm earth tones with brown and green accents, natural beige background"
        ),
        EidAlAdhaColorPalette(
            name: "Bright Festive",
            description: "Vibrant celebration",
            primaryHex: "#F57C00",
            secondaryHex: "#FFA726",
            accentHex: "#2E7D32",
            backgroundHex: "#FFF3E0",
            aiColorHint: "bright festive orange with warm amber and green tones, cheerful cream background"
        ),
        EidAlAdhaColorPalette(
            name: "Midnight Blue",
            description: "Night prayer serenity",
            primaryHex: "#0D47A1",
            secondaryHex: "#1976D2",
            accentHex: "#FFD700",
            backgroundHex: "#E3F2FD",
            aiColorHint: "midnight blue with azure and gold star accents, peaceful sky blue background"
        )
    ]
}

// MARK: - Eid al-Adha Personal Touch Messages
struct EidAlAdhaPersonalTouch: Identifiable, Codable {
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
        case blessed = "Blessed"
        case joyful = "Joyful"
        case reflective = "Reflective"
        case grateful = "Grateful"
        case celebratory = "Celebratory"

        var color: Color {
            switch self {
            case .peaceful: return Color(hex: "#00796B")
            case .blessed: return Color(hex: "#2E7D32")
            case .joyful: return Color(hex: "#F57C00")
            case .reflective: return Color(hex: "#4A148C")
            case .grateful: return Color(hex: "#8B4513")
            case .celebratory: return Color(hex: "#FFD700")
            }
        }
    }
}

// MARK: - Eid al-Adha Personal Touch Collection
extension EidAlAdhaPersonalTouch {
    static let optionalMessages: [EidAlAdhaPersonalTouch] = [
        EidAlAdhaPersonalTouch(
            message: "May peace and blessings be with you this Eid al-Adha",
            tone: .peaceful
        ),
        EidAlAdhaPersonalTouch(
            message: "Wishing you a blessed Eid filled with divine mercy",
            tone: .blessed
        ),
        EidAlAdhaPersonalTouch(
            message: "Eid Mubarak! May joy and happiness surround you",
            tone: .joyful
        ),
        EidAlAdhaPersonalTouch(
            message: "May this sacred occasion bring spiritual reflection",
            tone: .reflective
        ),
        EidAlAdhaPersonalTouch(
            message: "Grateful for your friendship this Eid al-Adha",
            tone: .grateful
        ),
        EidAlAdhaPersonalTouch(
            message: "Celebrating Eid al-Adha with heartfelt wishes for you",
            tone: .celebratory
        )
    ]

    static let personalMessagePlaceholder = "Add your own personal Eid al-Adha message here..."
    static let maxPersonalMessageLength = 200
}
