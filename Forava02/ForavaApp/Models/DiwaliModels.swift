import Foundation
import SwiftUI

// MARK: - Diwali Theme Structure
enum DiwaliTheme: String, Codable, CaseIterable {
    case traditional = "Traditional"
    case modern = "Modern"
    case familyCelebration = "Family Celebration"
    case prosperity = "Prosperity"

    var description: String {
        switch self {
        case .traditional:
            return "Classic Diwali with authentic diyas and traditional rangoli patterns, sacred religious elements, timeless festive atmosphere, heritage visualization, traditional पारंपरिक aesthetics"
        case .modern:
            return "Contemporary Diwali with sleek modern aesthetics, minimalist design patterns, sophisticated urban festival vibe, clean contemporary lines, stylish आधुनिक elegance, innovative cultural fusion"
        case .familyCelebration:
            return "Warm family togetherness celebration with reunion imagery, generational bonding symbols, cozy family gathering atmosphere, heartwarming unity patterns, पारिवारिक उत्सव warmth, connected family energy"
        case .prosperity:
            return "Wealth and fortune celebration with Lakshmi blessings, prosperity symbols, abundant gold coins, divine blessing imagery, success visualization, समृद्धि energy, lucky abundance patterns"
        }
    }

    var hindiName: String {
        switch self {
        case .traditional: return "पारंपरिक"
        case .modern: return "आधुनिक"
        case .familyCelebration: return "पारिवारिक उत्सव"
        case .prosperity: return "समृद्धि"
        }
    }

    var primaryColor: Color {
        switch self {
        case .traditional:
            return Color(hex: "#FF6B35") // Festival Orange
        case .modern:
            return Color(hex: "#FFD700") // Gold
        case .familyCelebration:
            return Color(hex: "#FF9933") // Saffron
        case .prosperity:
            return Color(hex: "#673AB7") // Deep Purple
        }
    }
}

// MARK: - Diwali Design Elements
struct DiwaliElement: Identifiable, Codable {
    let id: UUID
    let name: String
    let hindiName: String
    let weight: Double // SDXL emphasis weight (2.0-2.5 for centerpiece presence)
    let aiPromptModifier: String

    init(name: String, hindiName: String, weight: Double, aiPromptModifier: String) {
        self.id = UUID()
        self.name = name
        self.hindiName = hindiName
        self.weight = weight
        self.aiPromptModifier = aiPromptModifier
    }
}

// MARK: - Diwali Elements Collection
extension DiwaliElement {
    static let allElements: [DiwaliElement] = [
        // All elements are centerpieces - user selects exactly ONE
        DiwaliElement(
            name: "Diya",
            hindiName: "दीया",
            weight: 2.5,
            aiPromptModifier: "(beautiful traditional diya oil lamp:2.5), glowing sacred flame, warm candlelight, festival of lights centerpiece, earthen lamp with wick"
        ),
        DiwaliElement(
            name: "Rangoli",
            hindiName: "रंगोली",
            weight: 2.3,
            aiPromptModifier: "(intricate rangoli floor art:2.3), colorful geometric patterns, traditional Indian floor design, vibrant symmetrical mandala, festive decoration"
        ),
        DiwaliElement(
            name: "Lotus",
            hindiName: "कमल",
            weight: 2.2,
            aiPromptModifier: "(sacred lotus flower:2.2), divine purity symbol, elegant pink lotus blooms, spiritual centerpiece, prosperity and enlightenment"
        ),
        DiwaliElement(
            name: "Lakshmi",
            hindiName: "लक्ष्मी",
            weight: 2.4,
            aiPromptModifier: "(Goddess Lakshmi:2.4), divine feminine deity of wealth and prosperity, golden throne, lotus flowers, blessing gestures, radiant divine presence"
        ),
        DiwaliElement(
            name: "Fireworks",
            hindiName: "पटाखे",
            weight: 2.2,
            aiPromptModifier: "(spectacular fireworks display:2.2), colorful celebration lights in night sky, festive sparklers, joyous Diwali celebration atmosphere"
        )
    ]
}

// MARK: - Diwali Color Palettes
struct DiwaliColorPalette: Identifiable, Codable {
    let id: UUID
    let name: String
    let hindiName: String
    let description: String
    let primaryColor: String        // Hex code (e.g., "#FF6B35")
    let secondaryColor: String      // Hex code
    let accentColor: String         // Hex code
    let primaryColorName: String    // Descriptive name for AI (e.g., "festival orange")
    let secondaryColorName: String  // Descriptive name for AI
    let accentColorName: String     // Descriptive name for AI
    let primaryColorSimple: String  // SDXL-weighted prompt syntax (e.g., "(vibrant orange:2.0)")
    let secondaryColorSimple: String // SDXL-weighted prompt syntax (e.g., "(brilliant gold:1.8)")
    let accentColorSimple: String   // SDXL-weighted prompt syntax (e.g., "(deep purple:1.6)")
    let primaryColorBase: String    // Base color name for exclusion logic (e.g., "orange")
    let secondaryColorBase: String  // Base color name for exclusion logic (e.g., "gold")
    let accentColorBase: String     // Base color name for exclusion logic (e.g., "purple")
    let backgroundHint: String

    // swiftlint:disable:next line_length
    init(name: String, hindiName: String, description: String, primaryColor: String, secondaryColor: String, accentColor: String, primaryColorName: String, secondaryColorName: String, accentColorName: String, primaryColorSimple: String, secondaryColorSimple: String, accentColorSimple: String, primaryColorBase: String, secondaryColorBase: String, accentColorBase: String, backgroundHint: String) {
        self.id = UUID()
        self.name = name
        self.hindiName = hindiName
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

// MARK: - Diwali Color Palettes Collection
extension DiwaliColorPalette {
    static let allPalettes: [DiwaliColorPalette] = [
        DiwaliColorPalette(
            name: "Classic Diwali",
            hindiName: "क्लासिक दीवाली",
            description: "Festival orange with brilliant gold and deep purple",
            primaryColor: "#FF6B35",
            secondaryColor: "#FFD700",
            accentColor: "#673AB7",
            primaryColorName: "festival orange",
            secondaryColorName: "brilliant fortune gold",
            accentColorName: "deep divine purple",
            primaryColorSimple: "(festival orange:2.0)",
            secondaryColorSimple: "(brilliant gold:1.8)",
            accentColorSimple: "(deep purple:1.6)",
            primaryColorBase: "orange",
            secondaryColorBase: "gold",
            accentColorBase: "purple",
            backgroundHint: "warm festive diya glow with radiant celebration energy"
        ),
        DiwaliColorPalette(
            name: "Golden Prosperity",
            hindiName: "स्वर्णिम समृद्धि",
            description: "Luxurious gold with orange and dark gold accents",
            primaryColor: "#FFD700",
            secondaryColor: "#FFA500",
            accentColor: "#B8860B",
            primaryColorName: "luxurious fortune gold",
            secondaryColorName: "vibrant prosperity orange",
            accentColorName: "rich dark gold",
            primaryColorSimple: "(luxurious gold:2.0)",
            secondaryColorSimple: "(vibrant orange:1.8)",
            accentColorSimple: "(dark gold:1.6)",
            primaryColorBase: "gold",
            secondaryColorBase: "orange",
            accentColorBase: "gold",
            backgroundHint: "opulent golden prosperity with divine wealth energy"
        ),
        DiwaliColorPalette(
            name: "Lakshmi Blessings",
            hindiName: "लक्ष्मी आशीर्वाद",
            description: "Divine purple with gold and deep pink blessings",
            primaryColor: "#673AB7",
            secondaryColor: "#FFD700",
            accentColor: "#C2185B",
            primaryColorName: "divine royal purple",
            secondaryColorName: "blessed fortune gold",
            accentColorName: "sacred deep pink",
            primaryColorSimple: "(divine purple:2.0)",
            secondaryColorSimple: "(blessed gold:1.8)",
            accentColorSimple: "(sacred pink:1.6)",
            primaryColorBase: "purple",
            secondaryColorBase: "gold",
            accentColorBase: "pink",
            backgroundHint: "divine goddess blessing atmosphere with sacred radiance"
        ),
        DiwaliColorPalette(
            name: "Traditional Festival",
            hindiName: "पारंपरिक उत्सव",
            description: "Saffron, crimson red, and traditional gold",
            primaryColor: "#FF9933",
            secondaryColor: "#DC143C",
            accentColor: "#FFD700",
            primaryColorName: "traditional saffron orange",
            secondaryColorName: "auspicious crimson red",
            accentColorName: "pure fortune gold",
            primaryColorSimple: "(saffron orange:2.0)",
            secondaryColorSimple: "(crimson red:1.8)",
            accentColorSimple: "(fortune gold:1.6)",
            primaryColorBase: "orange",
            secondaryColorBase: "red",
            accentColorBase: "gold",
            backgroundHint: "authentic traditional celebration with sacred festival energy"
        )
    ]
}

// MARK: - Diwali Personal Touch Messages
struct DiwaliPersonalTouch: Identifiable, Codable {
    let id: UUID
    let message: String
    let hindiMessage: String
    let tone: MessageTone

    init(message: String, hindiMessage: String, tone: MessageTone) {
        self.id = UUID()
        self.message = message
        self.hindiMessage = hindiMessage
        self.tone = tone
    }

    enum MessageTone: String, Codable, CaseIterable {
        case lightBlessing = "Light Blessing"
        case prosperityWish = "Prosperity Wish"
        case joyfulCelebration = "Joyful Celebration"
        case familyTogether = "Family Together"
        case divineBlessing = "Divine Blessing"
        case successWish = "Success Wish"

        var color: Color {
            switch self {
            case .lightBlessing: return Color(hex: "#FF6B35")
            case .prosperityWish: return Color(hex: "#FFD700")
            case .joyfulCelebration: return Color(hex: "#FF9933")
            case .familyTogether: return Color(hex: "#DC143C")
            case .divineBlessing: return Color(hex: "#673AB7")
            case .successWish: return Color(hex: "#FFA500")
            }
        }
    }
}

// MARK: - Diwali Personal Touch Collection
extension DiwaliPersonalTouch {
    static let optionalMessages: [DiwaliPersonalTouch] = [
        DiwaliPersonalTouch(
            message: "May the festival of lights brighten your life",
            hindiMessage: "दीपावली की हार्दिक शुभकामनाएं",
            tone: .lightBlessing
        ),
        DiwaliPersonalTouch(
            message: "Wishing you prosperity and success",
            hindiMessage: "समृद्धि और सफलता की कामना",
            tone: .prosperityWish
        ),
        DiwaliPersonalTouch(
            message: "Happy Diwali! May joy fill your heart",
            hindiMessage: "शुभ दीपावली! खुशियों से भर जाए आपका जीवन",
            tone: .joyfulCelebration
        ),
        DiwaliPersonalTouch(
            message: "Celebrating with family and love",
            hindiMessage: "परिवार और प्यार के साथ दीवाली मनाएं",
            tone: .familyTogether
        ),
        DiwaliPersonalTouch(
            message: "May Goddess Lakshmi bless you always",
            hindiMessage: "माँ लक्ष्मी की कृपा सदा बनी रहे",
            tone: .divineBlessing
        ),
        DiwaliPersonalTouch(
            message: "Light, love, and laughter this Diwali",
            hindiMessage: "रोशनी, प्यार और खुशियाँ",
            tone: .joyfulCelebration
        ),
        DiwaliPersonalTouch(
            message: "Wishing you a year of achievements",
            hindiMessage: "उपलब्धियों से भरा वर्ष हो",
            tone: .successWish
        ),
        DiwaliPersonalTouch(
            message: "May diyas illuminate your path to success",
            hindiMessage: "दीपक रोशन करें सफलता का मार्ग",
            tone: .lightBlessing
        )
    ]

    static let personalMessagePlaceholder = "Add your own personal Diwali message here..."
    static let maxPersonalMessageLength = 200
}
