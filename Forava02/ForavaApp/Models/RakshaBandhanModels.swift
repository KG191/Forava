import Foundation
import SwiftUI

// MARK: - Raksha Bandhan Theme Structure
enum RakshaBandhanTheme: String, Codable, CaseIterable {
    case traditional = "Traditional"
    case sacred = "Sacred"
    case modern = "Modern"
    case family = "Family"

    var description: String {
        switch self {
        case .traditional:
            return "Classic Raksha Bandhan with authentic religious elements"
        case .sacred:
            return "Spiritual significance and divine protection"
        case .modern:
            return "Contemporary Raksha Bandhan with modern elements"
        case .family:
            return "Extended family bonds and relationships"
        }
    }

    var giftOptions: [String] {
        switch self {
        case .traditional:
            return [
                "Sacred Thread Ceremony",
                "Traditional Rakhi Tying",
                "Brother Sister Ritual",
                "Classic Festival Scene",
                "Traditional Sweets Plate",
                "Sacred Tilaka Blessing",
                "Religious Rakhi Card",
                "Classical Bond Celebration"
            ]
        case .sacred:
            return [
                "Divine Protection Thread",
                "Sacred Om Rakhi",
                "Spiritual Bond Card",
                "Holy Protection Blessing",
                "Divine Sibling Love",
                "Sacred Knot Design",
                "Religious Protection Art",
                "Blessed Rakhi Scene"
            ]
        case .modern:
            return [
                "Modern Rakhi Design",
                "Contemporary Bond Card",
                "Stylized Thread Art",
                "Modern Brother Sister",
                "Designer Rakhi Style",
                "Contemporary Festival",
                "Modern Protection Symbol",
                "Trendy Rakhi Card"
            ]
        case .family:
            return [
                "Family Rakhi Celebration",
                "Multiple Siblings Scene",
                "Extended Family Bond",
                "Generational Rakhi",
                "Family Unity Card",
                "Cousin Rakhi Exchange",
                "Family Gathering Scene",
                "Complete Family Festival"
            ]
        }
    }

    var primaryColor: Color {
        switch self {
        case .traditional:
            return Color(hex: "#FF6B35") // Festival Orange
        case .sacred:
            return Color(hex: "#FFD700") // Gold
        case .modern:
            return Color(hex: "#FF69B4") // Modern Pink
        case .family:
            return Color(hex: "#228B22") // Forest Green
        }
    }
}

// MARK: - Raksha Bandhan Design Elements
struct RakshaBandhanElement: Identifiable, Codable {
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

// MARK: - Raksha Bandhan Elements Collection
extension RakshaBandhanElement {
    static let allElements: [RakshaBandhanElement] = [
        // Centre Pieces (Priority 90-100)
        RakshaBandhanElement(
            name: "Rakhi Thread",
            category: .centrePiece,
            priority: 100,
            aiPromptModifier: "beautiful rakhi thread as central focal point, sacred protection bond"
        ),
        RakshaBandhanElement(
            name: "Brother-Sister Bond",
            category: .centrePiece,
            priority: 95,
            aiPromptModifier: "brother-sister bond as centerpiece, loving sibling relationship"
        ),
        RakshaBandhanElement(
            name: "Sacred Knot",
            category: .centrePiece,
            priority: 92,
            aiPromptModifier: "sacred protective knot as focal point, divine protection symbol"
        ),
        RakshaBandhanElement(
            name: "Om Symbol",
            category: .centrePiece,
            priority: 90,
            aiPromptModifier: "sacred Om symbol as centerpiece, divine Hindu blessing"
        ),

        // Supporting Elements (Priority 50-80)
        RakshaBandhanElement(
            name: "Tilaka",
            category: .supportingElement,
            priority: 80,
            aiPromptModifier: "traditional tilaka as sacred decorative accent"
        ),
        RakshaBandhanElement(
            name: "Sweets Plate",
            category: .supportingElement,
            priority: 75,
            aiPromptModifier: "traditional sweets plate as festive embellishments"
        ),
        RakshaBandhanElement(
            name: "Aarti Diya",
            category: .supportingElement,
            priority: 70,
            aiPromptModifier: "sacred aarti diya as spiritual border elements"
        ),
        RakshaBandhanElement(
            name: "Marigold Flowers",
            category: .supportingElement,
            priority: 65,
            aiPromptModifier: "beautiful marigold flowers as festive decorative flourishes"
        )
    ]

    static var centrePieces: [RakshaBandhanElement] {
        return allElements.filter { $0.category == .centrePiece }.sorted { $0.priority > $1.priority }
    }

    static var supportingElements: [RakshaBandhanElement] {
        return allElements.filter { $0.category == .supportingElement }.sorted { $0.priority > $1.priority }
    }
}

// MARK: - Raksha Bandhan Color Palettes
struct RakshaBandhanColorPalette: Identifiable, Codable {
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

// MARK: - Raksha Bandhan Color Palettes Collection
extension RakshaBandhanColorPalette {
    static let allPalettes: [RakshaBandhanColorPalette] = [
        RakshaBandhanColorPalette(
            name: "Traditional Rakhi",
            description: "Saffron orange, red, and gold",
            primaryColor: "#FF6B35",
            secondaryColor: "#DC143C",
            accentColor: "#FFD700",
            backgroundHint: "traditional festival atmosphere"
        ),
        RakshaBandhanColorPalette(
            name: "Sacred Thread",
            description: "Gold, crimson, and white",
            primaryColor: "#FFD700",
            secondaryColor: "#DC143C",
            accentColor: "#FFFFFF",
            backgroundHint: "sacred golden glow"
        ),
        RakshaBandhanColorPalette(
            name: "Festival Bright",
            description: "Red, pink, orange, and gold",
            primaryColor: "#DC143C",
            secondaryColor: "#FF69B4",
            accentColor: "#FFD700",
            backgroundHint: "bright festive celebration"
        ),
        RakshaBandhanColorPalette(
            name: "Royal Protection",
            description: "Deep red, gold, and maroon",
            primaryColor: "#8B0000",
            secondaryColor: "#FFD700",
            accentColor: "#800000",
            backgroundHint: "royal protection atmosphere"
        ),
        RakshaBandhanColorPalette(
            name: "Modern Elegance",
            description: "Rose gold, coral, and cream",
            primaryColor: "#E6C2A6",
            secondaryColor: "#FF7F50",
            accentColor: "#FFF8DC",
            backgroundHint: "modern elegant setting"
        ),
        RakshaBandhanColorPalette(
            name: "Brother Sister Bond",
            description: "Blue, pink, and gold",
            primaryColor: "#4169E1",
            secondaryColor: "#FF69B4",
            accentColor: "#FFD700",
            backgroundHint: "sibling bond harmony"
        ),
        RakshaBandhanColorPalette(
            name: "Classic Hindu",
            description: "Saffron, red, and yellow",
            primaryColor: "#FF9933",
            secondaryColor: "#DC143C",
            accentColor: "#FFFF00",
            backgroundHint: "classic Hindu tradition"
        ),
        RakshaBandhanColorPalette(
            name: "Warm Family",
            description: "Orange, gold, and beige",
            primaryColor: "#FF8C00",
            secondaryColor: "#FFD700",
            accentColor: "#F5F5DC",
            backgroundHint: "warm family gathering"
        )
    ]
}

// MARK: - Raksha Bandhan Personal Touch Messages
struct RakshaBandhanPersonalTouch: Identifiable, Codable {
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
        case blessing = "Blessing"
        case protective = "Protective"
        case loving = "Loving"
        case joyful = "Joyful"
        case sacred = "Sacred"

        var color: Color {
            switch self {
            case .traditional: return Color(hex: "#FF6B35")
            case .blessing: return Color(hex: "#FFD700")
            case .protective: return Color(hex: "#DC143C")
            case .loving: return Color(hex: "#FF69B4")
            case .joyful: return Color(hex: "#228B22")
            case .sacred: return Color(hex: "#9370DB")
            }
        }
    }
}

// MARK: - Raksha Bandhan Personal Touch Collection
extension RakshaBandhanPersonalTouch {
    static let optionalMessages: [RakshaBandhanPersonalTouch] = [
        RakshaBandhanPersonalTouch(
            message: "रक्षा बंधन की शुभकामनाएं! Happy Raksha Bandhan!",
            tone: .traditional
        ),
        RakshaBandhanPersonalTouch(
            message: "May the bond of protection grow stronger each year",
            tone: .blessing
        ),
        RakshaBandhanPersonalTouch(
            message: "Celebrating the sacred thread of love and care",
            tone: .protective
        ),
        RakshaBandhanPersonalTouch(
            message: "Wishing you happiness and protection always",
            tone: .loving
        ),
        RakshaBandhanPersonalTouch(
            message: "The thread that binds hearts forever",
            tone: .joyful
        ),
        RakshaBandhanPersonalTouch(
            message: "May this Rakhi bring joy and blessings",
            tone: .sacred
        )
    ]

    static let personalMessagePlaceholder = "Add your own personal Raksha Bandhan message here..."
    static let maxPersonalMessageLength = 200
}

