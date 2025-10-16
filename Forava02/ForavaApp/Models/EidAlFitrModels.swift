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
                "Ramadan Memory Design",
                "Blessed Fasting Theme",
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

// MARK: - Eid al-Fitr Elements Collection
extension EidAlFitrElement {
    static let allElements: [EidAlFitrElement] = [
        // Centre Pieces (Priority 90-100)
        EidAlFitrElement(
            name: "Mosque",
            category: .centrePiece,
            priority: 100,
            aiPromptModifier: "beautiful mosque as central focal point, elegant Islamic architecture with minarets"
        ),
        EidAlFitrElement(
            name: "Crescent Moon",
            category: .centrePiece,
            priority: 95,
            aiPromptModifier: "radiant crescent moon as main symbol, glowing and serene"
        ),
        EidAlFitrElement(
            name: "Arabic Calligraphy",
            category: .centrePiece,
            priority: 92,
            aiPromptModifier: "elegant Arabic calligraphy as centerpiece, flowing and artistic"
        ),
        EidAlFitrElement(
            name: "Islamic Star",
            category: .centrePiece,
            priority: 90,
            aiPromptModifier: "brilliant Islamic star as focal point, symbolic and radiant"
        ),

        // Supporting Elements (Priority 50-80)
        EidAlFitrElement(
            name: "Lanterns",
            category: .supportingElement,
            priority: 80,
            aiPromptModifier: "colorful Ramadan lanterns as festive decorations"
        ),
        EidAlFitrElement(
            name: "Dates",
            category: .supportingElement,
            priority: 75,
            aiPromptModifier: "fresh dates as traditional breaking fast elements"
        ),
        EidAlFitrElement(
            name: "Islamic Patterns",
            category: .supportingElement,
            priority: 70,
            aiPromptModifier: "intricate Islamic geometric patterns as border elements"
        ),
        EidAlFitrElement(
            name: "Prayer Beads",
            category: .supportingElement,
            priority: 65,
            aiPromptModifier: "prayer beads (tasbih) as spiritual decorative elements"
        )
    ]

    static var centrePieces: [EidAlFitrElement] {
        return allElements.filter { $0.category == .centrePiece }.sorted { $0.priority > $1.priority }
    }

    static var supportingElements: [EidAlFitrElement] {
        return allElements.filter { $0.category == .supportingElement }.sorted { $0.priority > $1.priority }
    }
}

// MARK: - Eid al-Fitr Color Palettes
struct EidAlFitrColorPalette: Identifiable, Codable {
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

// MARK: - Eid al-Fitr Color Palettes Collection
extension EidAlFitrColorPalette {
    static let allPalettes: [EidAlFitrColorPalette] = [
        EidAlFitrColorPalette(
            name: "Classic Islamic",
            description: "Traditional Islamic colors",
            primaryColor: "#228B22",
            secondaryColor: "#DAA520",
            accentColor: "#FFFFFF",
            backgroundHint: "peaceful Islamic atmosphere"
        ),
        EidAlFitrColorPalette(
            name: "Moonlight Serenity",
            description: "Peaceful night tones",
            primaryColor: "#483D8B",
            secondaryColor: "#C0C0C0",
            accentColor: "#FFD700",
            backgroundHint: "serene moonlit night"
        ),
        EidAlFitrColorPalette(
            name: "Golden Celebration",
            description: "Luxurious golden theme",
            primaryColor: "#FFD700",
            secondaryColor: "#F5F5DC",
            accentColor: "#228B22",
            backgroundHint: "elegant golden celebration"
        ),
        EidAlFitrColorPalette(
            name: "Festive Joy",
            description: "Bright celebration colors",
            primaryColor: "#FF6347",
            secondaryColor: "#32CD32",
            accentColor: "#FFD700",
            backgroundHint: "vibrant festive atmosphere"
        ),
        EidAlFitrColorPalette(
            name: "Spiritual Calm",
            description: "Peaceful meditation tones",
            primaryColor: "#4169E1",
            secondaryColor: "#F0F8FF",
            accentColor: "#DAA520",
            backgroundHint: "calm spiritual environment"
        ),
        EidAlFitrColorPalette(
            name: "Desert Sunset",
            description: "Warm desert evening",
            primaryColor: "#FF4500",
            secondaryColor: "#F4A460",
            accentColor: "#228B22",
            backgroundHint: "warm desert sunset"
        ),
        EidAlFitrColorPalette(
            name: "Royal Heritage",
            description: "Regal Islamic colors",
            primaryColor: "#800080",
            secondaryColor: "#FFD700",
            accentColor: "#FFFFFF",
            backgroundHint: "royal Islamic heritage"
        ),
        EidAlFitrColorPalette(
            name: "Community Unity",
            description: "Harmonious gathering",
            primaryColor: "#20B2AA",
            secondaryColor: "#FFA500",
            accentColor: "#32CD32",
            backgroundHint: "warm community gathering"
        )
    ]
}

// MARK: - Eid al-Fitr Personal Touch Messages
struct EidAlFitrPersonalTouch: Identifiable, Codable {
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
        case blessed = "Blessed"
        case grateful = "Grateful"
        case family = "Family"
        case spiritual = "Spiritual"

        var color: Color {
            switch self {
            case .peaceful: return Color(hex: "#4169E1")
            case .joyful: return Color(hex: "#FFD700")
            case .blessed: return Color(hex: "#228B22")
            case .grateful: return Color(hex: "#DAA520")
            case .family: return Color(hex: "#FF6347")
            case .spiritual: return Color(hex: "#9370DB")
            }
        }
    }
}

// MARK: - Eid al-Fitr Personal Touch Collection
extension EidAlFitrPersonalTouch {
    static let optionalMessages: [EidAlFitrPersonalTouch] = [
        EidAlFitrPersonalTouch(
            message: "Eid Mubarak! May this blessed day bring peace to your heart",
            tone: .peaceful
        ),
        EidAlFitrPersonalTouch(
            message: "May your Eid be filled with joy and celebration",
            tone: .joyful
        ),
        EidAlFitrPersonalTouch(
            message: "Blessed Eid wishes for you and your family",
            tone: .blessed
        ),
        EidAlFitrPersonalTouch(
            message: "Grateful for friendship on this sacred day",
            tone: .grateful
        ),
        EidAlFitrPersonalTouch(
            message: "May Allah bless you and your family this Eid",
            tone: .family
        ),
        EidAlFitrPersonalTouch(
            message: "May this Eid bring spiritual renewal and growth",
            tone: .spiritual
        )
    ]

    static let personalMessagePlaceholder = "Add your own personal Eid al-Fitr message here..."
    static let maxPersonalMessageLength = 200
}

