import Foundation
import SwiftUI

// MARK: - Vesak Day Theme Structure
enum VesakDayTheme: String, Codable, CaseIterable {
    case traditional = "Traditional"
    case enlightenment = "Enlightenment"
    case compassion = "Compassion"
    case modern = "Modern"

    var description: String {
        switch self {
        case .traditional:
            return "Classic Buddhist celebration with authentic religious elements"
        case .enlightenment:
            return "Celebrating Buddha's spiritual awakening and wisdom"
        case .compassion:
            return "Loving-kindness, compassion, and Buddhist values"
        case .modern:
            return "Contemporary Buddhist celebration with modern elements"
        }
    }

    var giftOptions: [String] {
        switch self {
        case .traditional:
            return [
                "Buddha's Birth Celebration",
                "Traditional Temple Scene",
                "Sacred Bodhi Tree",
                "Buddhist Prayer Flags",
                "Traditional Monastery",
                "Classic Buddha Statue",
                "Sacred Lotus Pool",
                "Traditional Vesak Scene"
            ]
        case .enlightenment:
            return [
                "Buddha's Enlightenment",
                "Under Bodhi Tree",
                "Meditation Awakening",
                "Wisdom Light Card",
                "Enlightened Mind",
                "Spiritual Awakening",
                "Buddha's Insight",
                "Path to Nirvana"
            ]
        case .compassion:
            return [
                "Compassionate Buddha",
                "Loving-Kindness Card",
                "Helping Others Scene",
                "Peaceful Heart",
                "Compassion Practice",
                "Kindness Meditation",
                "Gentle Buddha Image",
                "Compassion Blessing"
            ]
        case .modern:
            return [
                "Modern Buddha Art",
                "Contemporary Lotus",
                "Minimalist Dharma Wheel",
                "Urban Meditation",
                "Modern Temple Design",
                "Stylized Buddha Figure",
                "Contemporary Vesak Card",
                "Modern Buddhist Art"
            ]
        }
    }

    var primaryColor: Color {
        switch self {
        case .traditional:
            return Color(hex: "#F99600") // Saffron Orange
        case .enlightenment:
            return Color(hex: "#FFD700") // Gold
        case .compassion:
            return Color(hex: "#FFB6C1") // Soft Pink
        case .modern:
            return Color(hex: "#9370DB") // Medium Slate Blue
        }
    }
}

// MARK: - Vesak Day Design Elements
struct VesakDayElement: Identifiable, Codable {
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

// MARK: - Vesak Day Elements Collection
extension VesakDayElement {
    static let allElements: [VesakDayElement] = [
        // Centre Pieces (Priority 90-100)
        VesakDayElement(
            name: "Lotus Flower",
            category: .centrePiece,
            priority: 100,
            aiPromptModifier: "sacred lotus flower as central focal point, symbolizing purity and enlightenment"
        ),
        VesakDayElement(
            name: "Buddha",
            category: .centrePiece,
            priority: 95,
            aiPromptModifier: "serene Buddha figure as centerpiece, peaceful and meditative pose"
        ),
        VesakDayElement(
            name: "Dharma Wheel",
            category: .centrePiece,
            priority: 92,
            aiPromptModifier: "sacred Dharma wheel as focal point, representing Buddhist teachings"
        ),
        VesakDayElement(
            name: "Bodhi Tree",
            category: .centrePiece,
            priority: 90,
            aiPromptModifier: "sacred Bodhi tree as centerpiece, where Buddha attained enlightenment"
        ),

        // Supporting Elements (Priority 50-80)
        VesakDayElement(
            name: "Prayer Flags",
            category: .supportingElement,
            priority: 80,
            aiPromptModifier: "colorful Buddhist prayer flags as decorative accents"
        ),
        VesakDayElement(
            name: "Lanterns",
            category: .supportingElement,
            priority: 75,
            aiPromptModifier: "traditional Buddhist lanterns as festive embellishments"
        ),
        VesakDayElement(
            name: "Meditation Pose",
            category: .supportingElement,
            priority: 70,
            aiPromptModifier: "peaceful meditation pose as spiritual border elements"
        ),
        VesakDayElement(
            name: "Buddhist Symbols",
            category: .supportingElement,
            priority: 65,
            aiPromptModifier: "traditional Buddhist symbols as decorative flourishes"
        )
    ]

    static var centrePieces: [VesakDayElement] {
        return allElements.filter { $0.category == .centrePiece }.sorted { $0.priority > $1.priority }
    }

    static var supportingElements: [VesakDayElement] {
        return allElements.filter { $0.category == .supportingElement }.sorted { $0.priority > $1.priority }
    }
}

// MARK: - Vesak Day Color Palettes
struct VesakDayColorPalette: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let primaryColor: String
    let secondaryColor: String
    let accentColor: String
    let backgroundHint: String

    init(name: String, description: String, primaryColor: String, secondaryColor: String, 
         accentColor: String, backgroundHint: String) {
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

// MARK: - Vesak Day Color Palettes Collection
extension VesakDayColorPalette {
    static let allPalettes: [VesakDayColorPalette] = [
        VesakDayColorPalette(
            name: "Sacred Saffron",
            description: "Saffron orange and gold harmony",
            primaryColor: "#F99600",
            secondaryColor: "#FFD700",
            accentColor: "#FFF8DC",
            backgroundHint: "sacred saffron monastery atmosphere"
        ),
        VesakDayColorPalette(
            name: "Lotus Purity",
            description: "White, pink, and light green serenity",
            primaryColor: "#FFFFFF",
            secondaryColor: "#FFB6C1",
            accentColor: "#90EE90",
            backgroundHint: "pure lotus pond tranquility"
        ),
        VesakDayColorPalette(
            name: "Meditation Calm",
            description: "Deep purple, gold, and lavender peace",
            primaryColor: "#9370DB",
            secondaryColor: "#FFD700",
            accentColor: "#E6E6FA",
            backgroundHint: "deep meditation sanctuary"
        ),
        VesakDayColorPalette(
            name: "Enlightenment Gold",
            description: "Multiple gold shades with orange",
            primaryColor: "#FFD700",
            secondaryColor: "#DAA520",
            accentColor: "#FFA500",
            backgroundHint: "golden enlightenment radiance"
        ),
        VesakDayColorPalette(
            name: "Peaceful Blue",
            description: "Sky blue, white, and gold serenity",
            primaryColor: "#87CEEB",
            secondaryColor: "#FFFFFF",
            accentColor: "#FFD700",
            backgroundHint: "peaceful sky meditation"
        ),
        VesakDayColorPalette(
            name: "Nature Harmony",
            description: "Forest green, brown, and gold balance",
            primaryColor: "#228B22",
            secondaryColor: "#8B4513",
            accentColor: "#FFD700",
            backgroundHint: "natural forest harmony"
        ),
        VesakDayColorPalette(
            name: "Modern Minimalist",
            description: "Black, white, and saffron accent",
            primaryColor: "#000000",
            secondaryColor: "#FFFFFF",
            accentColor: "#F99600",
            backgroundHint: "modern minimalist zen"
        ),
        VesakDayColorPalette(
            name: "Compassion Pink",
            description: "Soft pink, white, and gold loving-kindness",
            primaryColor: "#FFB6C1",
            secondaryColor: "#FFFFFF",
            accentColor: "#FFD700",
            backgroundHint: "compassionate pink warmth"
        )
    ]
}

// MARK: - Vesak Day Personal Touch Messages
struct VesakDayPersonalTouch: Identifiable, Codable {
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
        case enlightening = "Enlightening"
        case compassionate = "Compassionate"
        case spiritual = "Spiritual"
        case mindful = "Mindful"
        case joyful = "Joyful"

        var color: Color {
            switch self {
            case .peaceful: return Color(hex: "#87CEEB")
            case .enlightening: return Color(hex: "#FFD700")
            case .compassionate: return Color(hex: "#FFB6C1")
            case .spiritual: return Color(hex: "#9370DB")
            case .mindful: return Color(hex: "#228B22")
            case .joyful: return Color(hex: "#FFA500")
            }
        }
    }
}

// MARK: - Vesak Day Personal Touch Collection
extension VesakDayPersonalTouch {
    static let optionalMessages: [VesakDayPersonalTouch] = [
        VesakDayPersonalTouch(
            message: "May the Buddha's teachings bring you peace and wisdom",
            tone: .peaceful
        ),
        VesakDayPersonalTouch(
            message: "Wishing you enlightenment and compassion this Vesak Day",
            tone: .enlightening
        ),
        VesakDayPersonalTouch(
            message: "May your path be filled with mindfulness and loving-kindness",
            tone: .mindful
        ),
        VesakDayPersonalTouch(
            message: "Celebrating the birth, enlightenment, and parinirvana of Buddha",
            tone: .spiritual
        ),
        VesakDayPersonalTouch(
            message: "May you find inner peace and spiritual awakening",
            tone: .compassionate
        ),
        VesakDayPersonalTouch(
            message: "Sending you blessings of wisdom, compassion, and joy",
            tone: .joyful
        )
    ]

    static let personalMessagePlaceholder = "Add your own personal Vesak Day message here..."
    static let maxPersonalMessageLength = 200
}

// MARK: - Vesak Day Selection State
struct VesakDaySelectionState: Codable {
    var selectedTheme: VesakDayTheme?
    var selectedGift: String?
    var selectedElements: [VesakDayElement] = []
    var selectedColorPalette: VesakDayColorPalette?
    var selectedOptionalMessage: VesakDayPersonalTouch?
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
