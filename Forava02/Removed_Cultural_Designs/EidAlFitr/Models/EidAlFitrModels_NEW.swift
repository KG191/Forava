import Foundation
import SwiftUI

// MARK: - Eid al-Fitr Theme Structure
enum EidAlFitrTheme: String, Codable, CaseIterable {
    case traditional = "Traditional"
    case family = "Family"
    case spiritual = "Spiritual"
    case celebration = "Celebration"

    var description: String {
        switch self {
        case .traditional:
            return "Classic Eid traditions with timeless Islamic values"
        case .family:
            return "Family gathering and unity in Eid celebrations"
        case .spiritual:
            return "Sacred Eid meaning with spiritual reflections"
        case .celebration:
            return "Joyful Eid festivities with community spirit"
        }
    }

    var giftOptions: [String] {
        switch self {
        case .traditional:
            return [
                "Traditional Eid Mubarak Card",
                "Islamic Calligraphy Design",
                "Mosque Silhouette Card",
                "Crescent and Star Card",
                "Classic Arabic Greeting",
                "Traditional Pattern Card",
                "Heritage Eid Design",
                "Cultural Blessing Card"
            ]
        case .family:
            return [
                "Family Gathering Card",
                "Unity and Togetherness",
                "Generations Celebrating",
                "Home and Heart Design",
                "Family Feast Scene",
                "Children's Joy Card",
                "Multi-generation Card",
                "Family Blessing Design"
            ]
        case .spiritual:
            return [
                "Sacred Prayer Card",
                "Spiritual Reflection Design",
                "Divine Blessings Card",
                "Peaceful Worship Scene",
                "Sacred Journey Card",
                "Pilgrimage Memory Design",
                "Blessed Sacrifice Theme",
                "Spiritual Gratitude Card"
            ]
        case .celebration:
            return [
                "Festive Eid Celebration",
                "Joyful Community Card",
                "Colorful Festival Design",
                "Happy Gathering Scene",
                "Celebration Feast Card",
                "Festival Joy Design",
                "Community Spirit Card",
                "Vibrant Eid Festivities"
            ]
        }
    }

    var primaryColor: Color {
        switch self {
        case .traditional:
            return Color(hex: "#228B22") // Islamic Green
        case .family:
            return Color(hex: "#DAA520") // Golden Rod
        case .spiritual:
            return Color(hex: "#4169E1") // Royal Blue
        case .celebration:
            return Color(hex: "#FF6347") // Tomato Red
        }
    }
}

// MARK: - Eid al-Fitr Design Elements
struct EidAlFitrElement: Identifiable, Codable {
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
            aiPromptModifier: "beautiful mosque as central focal point, elegant Islamic architecture"
        ),
        EidAlAdhaElement(
            name: "Crescent and Star",
            category: .centrePiece,
            priority: 95,
            aiPromptModifier: "crescent moon and star as centerpiece, Islamic symbols of faith"
        ),
        EidAlAdhaElement(
            name: "Kaaba",
            category: .centrePiece,
            priority: 92,
            aiPromptModifier: "sacred Kaaba as focal point, symbol of Islamic pilgrimage"
        ),
        EidAlAdhaElement(
            name: "Arabic Calligraphy",
            category: .centrePiece,
            priority: 90,
            aiPromptModifier: "elegant Arabic calligraphy as centerpiece, beautiful Islamic script"
        ),

        // Supporting Elements (Priority 50-80)
        EidAlAdhaElement(
            name: "Geometric Patterns",
            category: .supportingElement,
            priority: 80,
            aiPromptModifier: "intricate Islamic geometric patterns as decorative accents"
        ),
        EidAlAdhaElement(
            name: "Palm Branches",
            category: .supportingElement,
            priority: 75,
            aiPromptModifier: "graceful palm branches as natural embellishments"
        ),
        EidAlAdhaElement(
            name: "Lanterns",
            category: .supportingElement,
            priority: 70,
            aiPromptModifier: "traditional Islamic lanterns as festive border elements"
        ),
        EidAlAdhaElement(
            name: "Prayer Beads",
            category: .supportingElement,
            priority: 65,
            aiPromptModifier: "elegant prayer beads as spiritual decorative elements"
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
        return (
            primary: Color(hex: primaryColor),
            secondary: Color(hex: secondaryColor),
            accent: Color(hex: accentColor)
        )
    }
}

// MARK: - Eid al-Adha Color Palettes Collection
extension EidAlAdhaColorPalette {
    static let allPalettes: [EidAlAdhaColorPalette] = [
        EidAlAdhaColorPalette(
            name: "Islamic Green",
            description: "Traditional Islamic colors",
            primaryColor: "#228B22",
            secondaryColor: "#DAA520",
            accentColor: "#FFFFFF",
            backgroundHint: "peaceful Islamic atmosphere"
        ),
        EidAlAdhaColorPalette(
            name: "Desert Sunset",
            description: "Warm desert tones",
            primaryColor: "#CD853F",
            secondaryColor: "#DEB887",
            accentColor: "#F4A460",
            backgroundHint: "warm desert landscape"
        ),
        EidAlAdhaColorPalette(
            name: "Golden Celebration",
            description: "Luxurious golden theme",
            primaryColor: "#DAA520",
            secondaryColor: "#F0E68C",
            accentColor: "#FFFFFF",
            backgroundHint: "golden festive glow"
        ),
        EidAlAdhaColorPalette(
            name: "Peaceful Blue",
            description: "Serene spiritual tones",
            primaryColor: "#4169E1",
            secondaryColor: "#87CEEB",
            accentColor: "#F0F8FF",
            backgroundHint: "peaceful sky atmosphere"
        ),
        EidAlAdhaColorPalette(
            name: "Royal Purple",
            description: "Elegant purple and gold",
            primaryColor: "#6A0DAD",
            secondaryColor: "#DAA520",
            accentColor: "#FFFFFF",
            backgroundHint: "royal Islamic court"
        ),
        EidAlAdhaColorPalette(
            name: "Pure White",
            description: "Clean spiritual purity",
            primaryColor: "#FFFFFF",
            secondaryColor: "#228B22",
            accentColor: "#DAA520",
            backgroundHint: "pure spiritual light"
        ),
        EidAlAdhaColorPalette(
            name: "Festive Red",
            description: "Vibrant celebration colors",
            primaryColor: "#DC143C",
            secondaryColor: "#DAA520",
            accentColor: "#FFFFFF",
            backgroundHint: "vibrant celebration atmosphere"
        ),
        EidAlAdhaColorPalette(
            name: "Earth Tones",
            description: "Natural earthy harmony",
            primaryColor: "#8B4513",
            secondaryColor: "#DEB887",
            accentColor: "#F5DEB3",
            backgroundHint: "natural earthly backdrop"
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
        case blessed = "Blessed"
        case joyful = "Joyful"
        case peaceful = "Peaceful"
        case grateful = "Grateful"
        case spiritual = "Spiritual"
        case family = "Family"

        var color: Color {
            switch self {
            case .blessed: return Color(hex: "#228B22")
            case .joyful: return Color(hex: "#DAA520")
            case .peaceful: return Color(hex: "#4169E1")
            case .grateful: return Color(hex: "#8B4513")
            case .spiritual: return Color(hex: "#6A0DAD")
            case .family: return Color(hex: "#DC143C")
            }
        }
    }
}

// MARK: - Eid al-Adha Personal Touch Collection
extension EidAlAdhaPersonalTouch {
    static let optionalMessages: [EidAlAdhaPersonalTouch] = [
        EidAlAdhaPersonalTouch(
            message: "May Allah's blessings be with you on this sacred day",
            tone: .blessed
        ),
        EidAlAdhaPersonalTouch(
            message: "Eid Mubarak! Wishing you joy and happiness",
            tone: .joyful
        ),
        EidAlAdhaPersonalTouch(
            message: "May this Eid bring peace and serenity to your heart",
            tone: .peaceful
        ),
        EidAlAdhaPersonalTouch(
            message: "Grateful for your presence in our lives this Eid",
            tone: .grateful
        ),
        EidAlAdhaPersonalTouch(
            message: "May your spiritual journey be blessed and rewarding",
            tone: .spiritual
        ),
        EidAlAdhaPersonalTouch(
            message: "Celebrating this blessed occasion with family love",
            tone: .family
        )
    ]

    static let personalMessagePlaceholder = "Add your own personal Eid al-Adha message here..."
    static let maxPersonalMessageLength = 200
}

// MARK: - Eid al-Adha Selection State
struct EidAlAdhaSelectionState: Codable {
    var selectedTheme: EidAlAdhaTheme?
    var selectedGift: String?
    var selectedElements: [EidAlAdhaElement] = []
    var selectedColorPalette: EidAlAdhaColorPalette?
    var selectedOptionalMessage: EidAlAdhaPersonalTouch?
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
