import Foundation
import SwiftUI

// MARK: - Raksha Bandhan Theme Structure
enum RakshaBandhanTheme: String, Codable, CaseIterable {
    case traditional = "Traditional"
    case brotherSisterBond = "Brother-Sister Bond"
    case modern = "Modern"
    case protectionPromise = "Protection Promise"

    var description: String {
        switch self {
        case .traditional:
            return "Classic Raksha Bandhan with authentic cultural elements"
        case .brotherSisterBond:
            return "Celebrating the unique bond between siblings"
        case .modern:
            return "Contemporary Raksha Bandhan with modern elements"
        case .protectionPromise:
            return "Beautiful promise of care and protection"
        }
    }

    var hindiName: String {
        switch self {
        case .traditional:
            return "पारंपरिक" // Traditional
        case .brotherSisterBond:
            return "भाई-बहन का प्यार" // Brother-Sister Love
        case .modern:
            return "आधुनिक" // Modern
        case .protectionPromise:
            return "रक्षा का वादा" // Promise of Protection
        }
    }

    var giftOptions: [String] {
        switch self {
        case .traditional:
            return [
                "Traditional Thread Ceremony",
                "Classic Rakhi Tying",
                "Brother Sister Celebration",
                "Festive Rakhi Scene",
                "Traditional Sweets Plate",
                "Cultural Tilaka Design",
                "Traditional Rakhi Card",
                "Classical Bond Celebration"
            ]
        case .brotherSisterBond:
            return [
                "Beautiful Protection Thread",
                "Elegant Om Rakhi",
                "Sibling Bond Card",
                "Joyful Protection Design",
                "Loving Sibling Celebration",
                "Beautiful Knot Design",
                "Cultural Protection Art",
                "Happy Rakhi Scene"
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
        case .protectionPromise:
            return [
                "Joyful Rakhi Celebration",
                "Multiple Siblings Scene",
                "Beautiful Family Bond",
                "Generational Rakhi",
                "Family Unity Card",
                "Festive Rakhi Exchange",
                "Family Gathering Scene",
                "Complete Family Festival"
            ]
        }
    }

    var primaryColor: Color {
        switch self {
        case .traditional:
            return Color(hex: "#FF6B35") // Festival Orange
        case .brotherSisterBond:
            return Color(hex: "#FFD700") // Gold
        case .modern:
            return Color(hex: "#FF69B4") // Modern Pink
        case .protectionPromise:
            return Color(hex: "#DC143C") // Crimson Red
        }
    }
}

// MARK: - Raksha Bandhan Design Elements
struct RakshaBandhanElement: Identifiable, Codable {
    let id: UUID
    let name: String
    let sfSymbol: String
    let weight: Double // For AI generation emphasis (0.0-1.0)
    let aiPromptModifier: String

    init(name: String, sfSymbol: String, weight: Double, aiPromptModifier: String) {
        self.id = UUID()
        self.name = name
        self.sfSymbol = sfSymbol
        self.weight = weight
        self.aiPromptModifier = aiPromptModifier
    }
}

// MARK: - Raksha Bandhan Elements Collection
extension RakshaBandhanElement {
    static let allElements: [RakshaBandhanElement] = [
        RakshaBandhanElement(
            name: "Rakhi Thread",
            sfSymbol: "line.3.crossed.swirl.circle",
            weight: 1.0,
            aiPromptModifier: "beautiful rakhi thread as central focal point, traditional protection bond"
        ),
        RakshaBandhanElement(
            name: "Sweets Thali",
            sfSymbol: "birthday.cake",
            weight: 0.9,
            aiPromptModifier: "traditional Indian sweets plate (thali) with festive treats"
        ),
        RakshaBandhanElement(
            name: "Diya",
            sfSymbol: "light.beacon.max",
            weight: 0.8,
            aiPromptModifier: "traditional oil lamp (diya) with warm celebratory glow"
        ),
        RakshaBandhanElement(
            name: "Marigold",
            sfSymbol: "leaf.fill",
            weight: 0.7,
            aiPromptModifier: "beautiful orange marigold flowers, festive cultural decoration"
        ),
        RakshaBandhanElement(
            name: "Gift Box",
            sfSymbol: "gift.fill",
            weight: 0.75,
            aiPromptModifier: "elegant gift box with traditional wrapping, sibling love"
        ),
        RakshaBandhanElement(
            name: "Tilak Plate",
            sfSymbol: "circlebadge.fill",
            weight: 0.65,
            aiPromptModifier: "traditional tilak plate with kumkum and rice grains"
        ),
        RakshaBandhanElement(
            name: "Aarti Thali",
            sfSymbol: "circle.circle",
            weight: 0.6,
            aiPromptModifier: "traditional aarti plate with cultural celebration items"
        ),
        RakshaBandhanElement(
            name: "Brother Sister",
            sfSymbol: "person.2.fill",
            weight: 0.85,
            aiPromptModifier: "brother and sister celebrating together, joyful sibling bond"
        )
    ]
}

// MARK: - Raksha Bandhan Color Palettes
struct RakshaBandhanColorPalette: Identifiable, Codable {
    let id: UUID
    let name: String
    let hindiName: String
    let description: String
    let primaryHex: String
    let secondaryHex: String
    let accentHex: String
    let backgroundHex: String
    let aiColorHint: String

    init(name: String, hindiName: String, description: String,
         primaryHex: String, secondaryHex: String, accentHex: String, backgroundHex: String,
         aiColorHint: String) {
        self.id = UUID()
        self.name = name
        self.hindiName = hindiName
        self.description = description
        self.primaryHex = primaryHex
        self.secondaryHex = secondaryHex
        self.accentHex = accentHex
        self.backgroundHex = backgroundHex
        self.aiColorHint = aiColorHint
    }

    var primaryColor: Color { Color(hex: primaryHex) }
    var secondaryColor: Color { Color(hex: secondaryHex) }
    var accentColor: Color { Color(hex: accentHex) }
    var backgroundColor: Color { Color(hex: backgroundHex) }
}

// MARK: - Raksha Bandhan Color Palettes Collection
extension RakshaBandhanColorPalette {
    static let allPalettes: [RakshaBandhanColorPalette] = [
        RakshaBandhanColorPalette(
            name: "Traditional Rakhi",
            hindiName: "पारंपरिक राखी",
            description: "Saffron orange, red, and gold",
            primaryHex: "#FF6B35",
            secondaryHex: "#DC143C",
            accentHex: "#FFD700",
            backgroundHex: "#FFF8F0",
            aiColorHint: "traditional Raksha Bandhan festival atmosphere with saffron orange, crimson red, and golden yellow tones"
        ),
        RakshaBandhanColorPalette(
            name: "Golden Thread",
            hindiName: "सुनहरा धागा",
            description: "Gold, crimson, and white",
            primaryHex: "#FFD700",
            secondaryHex: "#DC143C",
            accentHex: "#FFFFFF",
            backgroundHex: "#FFFACD",
            aiColorHint: "elegant golden thread with crimson and pure white accents, beautiful festive glow"
        ),
        RakshaBandhanColorPalette(
            name: "Festival Bright",
            hindiName: "त्योहार की रंगत",
            description: "Red, pink, orange, and gold",
            primaryHex: "#DC143C",
            secondaryHex: "#FF69B4",
            accentHex: "#FFD700",
            backgroundHex: "#FFF0F5",
            aiColorHint: "bright festive celebration with crimson red, hot pink, and golden accents"
        ),
        RakshaBandhanColorPalette(
            name: "Royal Protection",
            hindiName: "शाही रक्षा",
            description: "Deep red, gold, and maroon",
            primaryHex: "#8B0000",
            secondaryHex: "#FFD700",
            accentHex: "#800000",
            backgroundHex: "#FFF5EE",
            aiColorHint: "elegant protection atmosphere with deep burgundy red, royal gold, and rich maroon tones"
        ),
        RakshaBandhanColorPalette(
            name: "Modern Elegance",
            hindiName: "आधुनिक सुंदरता",
            description: "Rose gold, coral, and cream",
            primaryHex: "#E6C2A6",
            secondaryHex: "#FF7F50",
            accentHex: "#FFF8DC",
            backgroundHex: "#FAF0E6",
            aiColorHint: "modern elegant setting with rose gold, coral pink, and creamy beige tones"
        ),
        RakshaBandhanColorPalette(
            name: "Brother Sister Bond",
            hindiName: "भाई-बहन का बंधन",
            description: "Blue, pink, and gold",
            primaryHex: "#4169E1",
            secondaryHex: "#FF69B4",
            accentHex: "#FFD700",
            backgroundHex: "#F0F8FF",
            aiColorHint: "joyful sibling bond harmony with royal blue, vibrant pink, and golden accents"
        ),
        RakshaBandhanColorPalette(
            name: "Classic Cultural",
            hindiName: "शास्त्रीय सांस्कृतिक",
            description: "Saffron, red, and yellow",
            primaryHex: "#FF9933",
            secondaryHex: "#DC143C",
            accentHex: "#FFFF00",
            backgroundHex: "#FFFAF0",
            aiColorHint: "classic cultural tradition with saffron orange, crimson red, and bright yellow"
        ),
        RakshaBandhanColorPalette(
            name: "Warm Family",
            hindiName: "गर्म परिवार",
            description: "Orange, gold, and beige",
            primaryHex: "#FF8C00",
            secondaryHex: "#FFD700",
            accentHex: "#F5F5DC",
            backgroundHex: "#FFF8DC",
            aiColorHint: "warm family gathering with dark orange, golden yellow, and soft beige tones"
        )
    ]
}

// MARK: - Raksha Bandhan Personal Touch Messages
struct RakshaBandhanPersonalTouch: Identifiable, Codable {
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
        case traditional = "Traditional"
        case joyful = "Joyful"
        case protective = "Protective"
        case loving = "Loving"
        case celebratory = "Celebratory"
        case heartfelt = "Heartfelt"

        var color: Color {
            switch self {
            case .traditional: return Color(hex: "#FF6B35")
            case .joyful: return Color(hex: "#FFD700")
            case .protective: return Color(hex: "#DC143C")
            case .loving: return Color(hex: "#FF69B4")
            case .celebratory: return Color(hex: "#228B22")
            case .heartfelt: return Color(hex: "#9370DB")
            }
        }
    }
}

// MARK: - Raksha Bandhan Personal Touch Collection
extension RakshaBandhanPersonalTouch {
    static let optionalMessages: [RakshaBandhanPersonalTouch] = [
        RakshaBandhanPersonalTouch(
            message: "Happy Raksha Bandhan!",
            hindiMessage: "रक्षा बंधन की शुभकामनाएं!",
            tone: .traditional
        ),
        RakshaBandhanPersonalTouch(
            message: "Celebrating the beautiful bond between us",
            hindiMessage: "हमारे बीच के सुंदर बंधन का जश्न",
            tone: .joyful
        ),
        RakshaBandhanPersonalTouch(
            message: "The thread that connects our hearts forever",
            hindiMessage: "वह धागा जो हमारे दिलों को हमेशा जोड़ता है",
            tone: .protective
        ),
        RakshaBandhanPersonalTouch(
            message: "Wishing you happiness and joy always",
            hindiMessage: "आपको हमेशा खुशी और आनंद की कामना",
            tone: .loving
        ),
        RakshaBandhanPersonalTouch(
            message: "Here's to the special bond we share",
            hindiMessage: "हम जो विशेष रिश्ता साझा करते हैं",
            tone: .celebratory
        ),
        RakshaBandhanPersonalTouch(
            message: "May our bond grow stronger with each passing year",
            hindiMessage: "हर गुजरते साल के साथ हमारा रिश्ता मजबूत हो",
            tone: .heartfelt
        )
    ]

    static let personalMessagePlaceholder = "Add your own personal Raksha Bandhan message here..."
    static let maxPersonalMessageLength = 200
}

