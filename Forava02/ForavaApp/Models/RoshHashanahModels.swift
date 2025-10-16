import Foundation
import SwiftUI

// MARK: - Rosh Hashanah Theme Structure
enum RoshHashanahTheme: String, Codable, CaseIterable {
    case traditional = "Traditional"
    case renewal = "Renewal"
    case family = "Family"
    case modern = "Modern"

    var description: String {
        switch self {
        case .traditional:
            return "Classic Rosh Hashanah with authentic religious elements"
        case .renewal:
            return "Spiritual renewal and fresh beginnings"
        case .family:
            return "Family traditions and generational celebration"
        case .modern:
            return "Contemporary Rosh Hashanah with modern elements"
        }
    }

    var giftOptions: [String] {
        switch self {
        case .traditional:
            return [
                "Traditional Shofar Blessing",
                "Apples & Honey Tradition",
                "Sacred Torah Reading",
                "Synagogue New Year",
                "Traditional Prayer Scene",
                "Religious Blessing Card",
                "Classic Holiday Table",
                "Traditional Family Gathering"
            ]
        case .renewal:
            return [
                "New Year Reflection",
                "Spiritual Renewal Card",
                "Fresh Start Blessing",
                "Book of Life Entry",
                "Teshuvah Journey",
                "Soul Cleansing Theme",
                "New Beginning Path",
                "Renewal Prayer Scene"
            ]
        case .family:
            return [
                "Family Holiday Table",
                "Generations Together",
                "Family Blessing Scene",
                "Holiday Dinner Gathering",
                "Children's New Year",
                "Family Tradition Card",
                "Multi-Generation Celebration",
                "Family Unity Blessing"
            ]
        case .modern:
            return [
                "Modern Shofar Art",
                "Contemporary Jewish Design",
                "Minimalist New Year",
                "Urban Synagogue Scene",
                "Modern Hebrew Typography",
                "Stylized Star of David",
                "Contemporary Holiday Card",
                "Modern Jewish Art"
            ]
        }
    }

    var primaryColor: Color {
        switch self {
        case .traditional:
            return Color(hex: "#0066CC") // Traditional Blue
        case .renewal:
            return Color(hex: "#32CD32") // New Beginning Green
        case .family:
            return Color(hex: "#8B4513") // Warm Family Brown
        case .modern:
            return Color(hex: "#4169E1") // Contemporary Royal Blue
        }
    }
}

// MARK: - Rosh Hashanah Design Elements
struct RoshHashanahElement: Identifiable, Codable {
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

// MARK: - Rosh Hashanah Elements Collection
extension RoshHashanahElement {
    static let allElements: [RoshHashanahElement] = [
        // Centre Pieces (Priority 90-100)
        RoshHashanahElement(
            name: "Shofar",
            category: .centrePiece,
            priority: 100,
            aiPromptModifier: "traditional shofar horn as central focal point, sacred and ceremonial"
        ),
        RoshHashanahElement(
            name: "Apples & Honey",
            category: .centrePiece,
            priority: 95,
            aiPromptModifier: "apples and honey as centerpiece, symbolizing sweetness for the new year"
        ),
        RoshHashanahElement(
            name: "Star of David",
            category: .centrePiece,
            priority: 92,
            aiPromptModifier: "Star of David as focal point, representing Jewish faith and identity"
        ),
        RoshHashanahElement(
            name: "Torah Scroll",
            category: .centrePiece,
            priority: 90,
            aiPromptModifier: "sacred Torah scroll as centerpiece, representing Jewish learning and wisdom"
        ),

        // Supporting Elements (Priority 50-80)
        RoshHashanahElement(
            name: "Pomegranates",
            category: .supportingElement,
            priority: 80,
            aiPromptModifier: "pomegranates as symbolic decorative elements, representing abundance"
        ),
        RoshHashanahElement(
            name: "Challah Bread",
            category: .supportingElement,
            priority: 75,
            aiPromptModifier: "round challah bread as traditional holiday embellishments"
        ),
        RoshHashanahElement(
            name: "Hebrew Calligraphy",
            category: .supportingElement,
            priority: 70,
            aiPromptModifier: "beautiful Hebrew calligraphy as decorative border elements"
        ),
        RoshHashanahElement(
            name: "New Year Symbols",
            category: .supportingElement,
            priority: 65,
            aiPromptModifier: "Jewish New Year symbols as celebratory flourishes"
        )
    ]

    static var centrePieces: [RoshHashanahElement] {
        return allElements.filter { $0.category == .centrePiece }.sorted { $0.priority > $1.priority }
    }

    static var supportingElements: [RoshHashanahElement] {
        return allElements.filter { $0.category == .supportingElement }.sorted { $0.priority > $1.priority }
    }
}

// MARK: - Rosh Hashanah Color Palettes
struct RoshHashanahColorPalette: Identifiable, Codable {
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

// MARK: - Rosh Hashanah Color Palettes Collection
extension RoshHashanahColorPalette {
    static let allPalettes: [RoshHashanahColorPalette] = [
        RoshHashanahColorPalette(
            name: "Traditional Blue Gold",
            description: "Royal blue with golden accents",
            primaryColor: "#0066CC",
            secondaryColor: "#FFD700",
            accentColor: "#FFFFFF",
            backgroundHint: "traditional synagogue atmosphere"
        ),
        RoshHashanahColorPalette(
            name: "Apple Honey",
            description: "Red apple and golden honey tones",
            primaryColor: "#DC143C",
            secondaryColor: "#FFD700",
            accentColor: "#FFF8DC",
            backgroundHint: "warm harvest table setting"
        ),
        RoshHashanahColorPalette(
            name: "Shofar Natural",
            description: "Horn brown with golden highlights",
            primaryColor: "#8B4513",
            secondaryColor: "#DAA520",
            accentColor: "#F5F5DC",
            backgroundHint: "natural sacred ceremony"
        ),
        RoshHashanahColorPalette(
            name: "Pomegranate Rich",
            description: "Deep red with burgundy depth",
            primaryColor: "#8B0000",
            secondaryColor: "#FFD700",
            accentColor: "#800020",
            backgroundHint: "rich abundant harvest"
        ),
        RoshHashanahColorPalette(
            name: "New Year Fresh",
            description: "Clean white with golden hope",
            primaryColor: "#FFFFFF",
            secondaryColor: "#FFD700",
            accentColor: "#87CEEB",
            backgroundHint: "fresh beginning atmosphere"
        ),
        RoshHashanahColorPalette(
            name: "Synagogue Royal",
            description: "Deep blue with silver elegance",
            primaryColor: "#191970",
            secondaryColor: "#C0C0C0",
            accentColor: "#FFFFFF",
            backgroundHint: "sacred ceremonial space"
        ),
        RoshHashanahColorPalette(
            name: "Modern Minimalist",
            description: "Contemporary black and white with blue",
            primaryColor: "#000000",
            secondaryColor: "#FFFFFF",
            accentColor: "#4169E1",
            backgroundHint: "clean modern design"
        ),
        RoshHashanahColorPalette(
            name: "Warm Blessing",
            description: "Golden warmth with ivory comfort",
            primaryColor: "#DAA520",
            secondaryColor: "#8B4513",
            accentColor: "#FFFFF0",
            backgroundHint: "warm blessing atmosphere"
        )
    ]
}

// MARK: - Rosh Hashanah Personal Touch Messages
struct RoshHashanahPersonalTouch: Identifiable, Codable {
    let id: UUID
    let message: String
    let tone: MessageTone

    init(message: String, tone: MessageTone) {
        self.id = UUID()
        self.message = message
        self.tone = tone
    }

    enum MessageTone: String, Codable, CaseIterable {
        case traditional = "Traditional"
        case spiritual = "Spiritual"
        case blessing = "Blessing"
        case hopeful = "Hopeful"
        case family = "Family"
        case renewal = "Renewal"

        var color: Color {
            switch self {
            case .traditional: return Color(hex: "#0066CC")
            case .spiritual: return Color(hex: "#4169E1")
            case .blessing: return Color(hex: "#FFD700")
            case .hopeful: return Color(hex: "#32CD32")
            case .family: return Color(hex: "#8B4513")
            case .renewal: return Color(hex: "#87CEEB")
            }
        }
    }
}

// MARK: - Rosh Hashanah Personal Touch Collection
extension RoshHashanahPersonalTouch {
    static let optionalMessages: [RoshHashanahPersonalTouch] = [
        RoshHashanahPersonalTouch(
            message: "שנה טובה! Wishing you a sweet and blessed New Year",
            tone: .traditional
        ),
        RoshHashanahPersonalTouch(
            message: "May you be inscribed in the Book of Life",
            tone: .spiritual
        ),
        RoshHashanahPersonalTouch(
            message: "L'Shanah Tovah! May this year bring peace and joy",
            tone: .blessing
        ),
        RoshHashanahPersonalTouch(
            message: "Wishing you apples and honey for a sweet year",
            tone: .hopeful
        ),
        RoshHashanahPersonalTouch(
            message: "May your prayers be answered this New Year",
            tone: .spiritual
        ),
        RoshHashanahPersonalTouch(
            message: "Sending blessings for health, happiness, and prosperity",
            tone: .family
        )
    ]

    static let personalMessagePlaceholder = "Add your own personal Rosh Hashanah message here..."
    static let maxPersonalMessageLength = 200
}

