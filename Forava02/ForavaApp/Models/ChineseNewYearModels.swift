import Foundation
import SwiftUI

// MARK: - Chinese New Year Theme Structure
enum ChineseNewYearTheme: String, Codable, CaseIterable {
    case traditional = "Traditional"
    case modern = "Modern"
    case familyReunion = "Family Reunion"
    case prosperity = "Prosperity"

    var description: String {
        switch self {
        case .traditional:
            return "Classic celebration with traditional red and gold patterns, ancient lanterns, authentic cultural symbols, timeless festive atmosphere, heritage visualization, traditional 传统 aesthetics"
        case .modern:
            return "Contemporary celebration with sleek modern aesthetics, minimalist design patterns, sophisticated urban festival vibe, clean contemporary lines, stylish 现代 elegance, innovative cultural fusion"
        case .familyReunion:
            return "Warm family togetherness celebration with reunion imagery, generational bonding symbols, cozy family gathering atmosphere, heartwarming unity patterns, 团圆 warmth, connected family energy"
        case .prosperity:
            return "Wealth and fortune celebration with prosperity symbols, abundant gold ingots, fortune coins, blessing imagery, success visualization, 招财 energy, lucky abundance patterns"
        }
    }

    var chineseName: String {
        switch self {
        case .traditional: return "传统"
        case .modern: return "现代"
        case .familyReunion: return "团圆"
        case .prosperity: return "招财"
        }
    }

    var primaryColor: Color {
        switch self {
        case .traditional:
            return Color(hex: "#DC143C") // Crimson Red
        case .modern:
            return Color(hex: "#FF6B6B") // Modern Red
        case .familyReunion:
            return Color(hex: "#FF4444") // Warm Red
        case .prosperity:
            return Color(hex: "#FFD700") // Gold
        }
    }
}

// MARK: - Chinese New Year Design Elements
struct ChineseNewYearElement: Identifiable, Codable {
    let id: UUID
    let name: String
    let chineseName: String
    let weight: Double // SDXL emphasis weight (2.0-2.5 for centerpiece presence)
    let aiPromptModifier: String

    init(name: String, chineseName: String, weight: Double, aiPromptModifier: String) {
        self.id = UUID()
        self.name = name
        self.chineseName = chineseName
        self.weight = weight
        self.aiPromptModifier = aiPromptModifier
    }

    init(id: UUID, name: String, chineseName: String, weight: Double, aiPromptModifier: String) {
        self.id = id
        self.name = name
        self.chineseName = chineseName
        self.weight = weight
        self.aiPromptModifier = aiPromptModifier
    }
}

// MARK: - Chinese Zodiac Calculator
struct ChineseZodiacCalculator {

    enum ZodiacAnimal: String, CaseIterable {
        case rat, ox, tiger, rabbit, dragon, snake
        case horse, goat, monkey, rooster, dog, pig

        var displayName: String { rawValue.capitalized }

        var chineseCharacter: String {
            switch self {
            case .rat: return "鼠"
            case .ox: return "牛"
            case .tiger: return "虎"
            case .rabbit: return "兔"
            case .dragon: return "龙"
            case .snake: return "蛇"
            case .horse: return "马"
            case .goat: return "羊"
            case .monkey: return "猴"
            case .rooster: return "鸡"
            case .dog: return "狗"
            case .pig: return "猪"
            }
        }

        var sfSymbol: String {
            switch self {
            case .rat: return "hare.fill"
            case .ox: return "tortoise.fill"
            case .tiger: return "cat.fill"
            case .rabbit: return "hare.fill"
            case .dragon: return "sparkles"
            case .snake: return "waveform.path"
            case .horse: return "figure.equestrian.sports"
            case .goat: return "leaf.fill"
            case .monkey: return "face.smiling"
            case .rooster: return "bird.fill"
            case .dog: return "dog.fill"
            case .pig: return "hare.fill"
            }
        }
    }

    enum ZodiacElement: String, CaseIterable {
        case wood, fire, earth, metal, water

        var displayName: String { rawValue.capitalized }

        var chineseCharacter: String {
            switch self {
            case .wood: return "木"
            case .fire: return "火"
            case .earth: return "土"
            case .metal: return "金"
            case .water: return "水"
            }
        }
    }

    // Reference: 1924 was Year of the Rat (consistent with CulturalCalendarService)
    // Reference: 1984 was Year of the Wood Rat (start of 60-year cycle for element calculation)
    private static let animalReferenceYear = 1924
    private static let elementReferenceYear = 1984

    // Known CNY dates for accurate year boundary
    private static let knownCNYDates: [Int: (month: Int, day: Int)] = [
        2024: (2, 10), 2025: (1, 29), 2026: (2, 17),
        2027: (2, 6), 2028: (1, 26), 2029: (2, 13), 2030: (2, 3)
    ]

    static func getZodiacYear(for date: Date = Date()) -> (animal: ZodiacAnimal, element: ZodiacElement) {
        let chineseYear = getChineseYear(for: date)

        // Animal: 12-year cycle from 1924 (Rat year)
        let animalIndex = (chineseYear - animalReferenceYear) % 12
        let normalizedAnimalIndex = animalIndex >= 0 ? animalIndex : animalIndex + 12
        let animal = ZodiacAnimal.allCases[normalizedAnimalIndex]

        // Element: 10-year cycle (each element governs 2 years)
        let elementCycle = (chineseYear - elementReferenceYear) % 10
        let normalizedElementCycle = elementCycle >= 0 ? elementCycle : elementCycle + 10
        let elementIndex = normalizedElementCycle / 2
        let element = ZodiacElement.allCases[elementIndex]

        return (animal, element)
    }

    static func getChineseYear(for date: Date) -> Int {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)

        if let cnyDate = knownCNYDates[year] {
            if month < cnyDate.month || (month == cnyDate.month && day < cnyDate.day) {
                return year - 1
            }
        } else if month < 2 || (month == 2 && day < 4) {
            return year - 1  // Fallback: Feb 4 approximation
        }
        return year
    }
}

// MARK: - Chinese New Year Elements Collection
extension ChineseNewYearElement {

    /// Creates dynamic zodiac year element based on current date
    static func currentZodiacYearElement(for date: Date = Date()) -> ChineseNewYearElement {
        let chineseYear = ChineseZodiacCalculator.getChineseYear(for: date)
        let (animal, element) = ChineseZodiacCalculator.getZodiacYear(for: date)

        let displayName = "Year of the \(element.displayName) \(animal.displayName)"
        let chineseName = "\(element.chineseCharacter)\(animal.chineseCharacter)年"

        let aiPrompt = "(\(animal.displayName.lowercased()) zodiac symbol:2.6), " +
            "Chinese zodiac \(animal.displayName), " +
            "\(element.displayName.lowercased()) element energy, " +
            "traditional Chinese zodiac art, celebration of the year, NOT cartoon"

        // Create deterministic UUID based on the Chinese year for stable identity
        let stableID = UUID(uuidString: "00000000-0000-0000-0000-\(String(format: "%012d", chineseYear))")
            ?? UUID()

        return ChineseNewYearElement(
            id: stableID,
            name: displayName,
            chineseName: chineseName,
            weight: 2.6,  // Highest weight for zodiac prominence
            aiPromptModifier: aiPrompt
        )
    }

    /// Dynamic elements list with zodiac year FIRST
    static var allElements: [ChineseNewYearElement] {
        var elements = [currentZodiacYearElement()]
        elements.append(contentsOf: staticElements)
        return elements
    }

    /// Static elements (non-dynamic)
    private static let staticElements: [ChineseNewYearElement] = [
        // All elements are centerpieces - user selects exactly ONE
        ChineseNewYearElement(
            name: "Dragon",
            chineseName: "龙",
            weight: 2.5,
            aiPromptModifier: "(majestic Chinese dragon:2.5), powerful mythical dragon with scales, auspicious dragon symbolism, fortune and power, NOT cartoon, traditional Chinese dragon art"
        ),
        ChineseNewYearElement(
            name: "Lantern",
            chineseName: "灯笼",
            weight: 2.2,
            aiPromptModifier: "(traditional red Chinese lanterns:2.2), festive hanging lanterns, glowing paper lanterns, celebration atmosphere"
        ),
        ChineseNewYearElement(
            name: "Firecrackers",
            chineseName: "鞭炮",
            weight: 2.2,
            aiPromptModifier: "(red firecrackers strings:2.2), traditional celebration firecrackers, festive firecracker display, luck and prosperity symbols"
        ),
        ChineseNewYearElement(
            name: "Peony",
            chineseName: "牡丹",
            weight: 2.3,
            aiPromptModifier: "(blooming peony flowers:2.3), elegant Chinese peony blooms, prosperity and beauty symbols, rich floral elegance"
        ),
        ChineseNewYearElement(
            name: "Gold Ingots",
            chineseName: "金元宝",
            weight: 2.4,
            aiPromptModifier: "(golden ingots yuanbao:2.4), traditional Chinese gold ingots, wealth symbols, prosperity and fortune, sycee gold bars"
        )
    ]
}

// MARK: - Chinese New Year Color Palettes
struct ChineseNewYearColorPalette: Identifiable, Codable {
    let id: UUID
    let name: String
    let chineseName: String
    let description: String
    let primaryColor: String        // Hex code (e.g., "#DC143C")
    let secondaryColor: String      // Hex code
    let accentColor: String         // Hex code
    let primaryColorName: String    // Descriptive name for AI (e.g., "lucky crimson red")
    let secondaryColorName: String  // Descriptive name for AI
    let accentColorName: String     // Descriptive name for AI
    let primaryColorSimple: String  // SDXL-weighted prompt syntax (e.g., "(vibrant red:2.0)")
    let secondaryColorSimple: String // SDXL-weighted prompt syntax (e.g., "(brilliant gold:1.8)")
    let accentColorSimple: String   // SDXL-weighted prompt syntax (e.g., "(jade green:1.6)")
    let primaryColorBase: String    // Base color name for exclusion logic (e.g., "red")
    let secondaryColorBase: String  // Base color name for exclusion logic (e.g., "gold")
    let accentColorBase: String     // Base color name for exclusion logic (e.g., "green")
    let backgroundHint: String

    // swiftlint:disable:next line_length
    init(name: String, chineseName: String, description: String, primaryColor: String, secondaryColor: String, accentColor: String, primaryColorName: String, secondaryColorName: String, accentColorName: String, primaryColorSimple: String, secondaryColorSimple: String, accentColorSimple: String, primaryColorBase: String, secondaryColorBase: String, accentColorBase: String, backgroundHint: String) {
        self.id = UUID()
        self.name = name
        self.chineseName = chineseName
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

// MARK: - Chinese New Year Color Palettes Collection
extension ChineseNewYearColorPalette {
    static let allPalettes: [ChineseNewYearColorPalette] = [
        ChineseNewYearColorPalette(
            name: "Lucky Red & Gold",
            chineseName: "鸿运金红",
            description: "Traditional lucky red with brilliant gold",
            primaryColor: "#DC143C",
            secondaryColor: "#FFD700",
            accentColor: "#8B0000",
            primaryColorName: "lucky crimson red",
            secondaryColorName: "brilliant fortune gold",
            accentColorName: "deep auspicious red",
            primaryColorSimple: "(vibrant red:2.0)",
            secondaryColorSimple: "(brilliant gold:1.8)",
            accentColorSimple: "(deep red:1.6)",
            primaryColorBase: "red",
            secondaryColorBase: "gold",
            accentColorBase: "red",
            backgroundHint: "festive celebration atmosphere with warm radiant energy"
        ),
        ChineseNewYearColorPalette(
            name: "Imperial Elegance",
            chineseName: "皇室华贵",
            description: "Regal imperial colors with golden accents",
            primaryColor: "#B71C1C",
            secondaryColor: "#FFC107",
            accentColor: "#212121",
            primaryColorName: "imperial deep red",
            secondaryColorName: "royal golden yellow",
            accentColorName: "elegant black",
            primaryColorSimple: "(imperial red:2.0)",
            secondaryColorSimple: "(royal gold:1.8)",
            accentColorSimple: "(elegant black:1.6)",
            primaryColorBase: "red",
            secondaryColorBase: "gold",
            accentColorBase: "black",
            backgroundHint: "sophisticated imperial atmosphere with regal elegance"
        ),
        ChineseNewYearColorPalette(
            name: "Prosperity Glow",
            chineseName: "财运旺盛",
            description: "Warm prosperity colors with golden glow",
            primaryColor: "#FF5722",
            secondaryColor: "#FFAB00",
            accentColor: "#FFE0B2",
            primaryColorName: "prosperity orange-red",
            secondaryColorName: "fortune golden amber",
            accentColorName: "warm golden cream",
            primaryColorSimple: "(prosperity red:2.0)",
            secondaryColorSimple: "(golden amber:1.8)",
            accentColorSimple: "(golden cream:1.6)",
            primaryColorBase: "red",
            secondaryColorBase: "gold",
            accentColorBase: "cream",
            backgroundHint: "warm prosperous atmosphere with glowing golden radiance"
        ),
        ChineseNewYearColorPalette(
            name: "Traditional Harmony",
            chineseName: "传统和谐",
            description: "Classic red, gold, and jade harmony",
            primaryColor: "#DC143C",
            secondaryColor: "#FFD700",
            accentColor: "#00A86B",
            primaryColorName: "classic celebration red",
            secondaryColorName: "traditional fortune gold",
            accentColorName: "harmonious jade green",
            primaryColorSimple: "(celebration red:2.0)",
            secondaryColorSimple: "(fortune gold:1.8)",
            accentColorSimple: "(jade green:1.6)",
            primaryColorBase: "red",
            secondaryColorBase: "gold",
            accentColorBase: "green",
            backgroundHint: "harmonious traditional atmosphere with balanced cultural energy"
        )
    ]
}

// MARK: - Chinese New Year Personal Touch Messages
struct ChineseNewYearPersonalTouch: Identifiable, Codable {
    let id: UUID
    let message: String
    let chineseMessage: String
    let tone: MessageTone

    init(message: String, chineseMessage: String, tone: MessageTone) {
        self.id = UUID()
        self.message = message
        self.chineseMessage = chineseMessage
        self.tone = tone
    }

    enum MessageTone: String, Codable, CaseIterable {
        case fortuneWishing = "Fortune Wishing"
        case prosperityBlessing = "Prosperity Blessing"
        case happinessJoy = "Happiness & Joy"
        case familyTogetherness = "Family Togetherness"
        case healthLongevity = "Health & Longevity"
        case successAchievement = "Success & Achievement"

        var color: Color {
            switch self {
            case .fortuneWishing: return Color(hex: "#FFD700")
            case .prosperityBlessing: return Color(hex: "#DC143C")
            case .happinessJoy: return Color(hex: "#FF6B6B")
            case .familyTogetherness: return Color(hex: "#FF4444")
            case .healthLongevity: return Color(hex: "#00A86B")
            case .successAchievement: return Color(hex: "#FFC107")
            }
        }
    }
}

// MARK: - Chinese New Year Personal Touch Collection
extension ChineseNewYearPersonalTouch {
    static let optionalMessages: [ChineseNewYearPersonalTouch] = [
        ChineseNewYearPersonalTouch(
            message: "Wishing you prosperity and good fortune in the new year",
            chineseMessage: "恭喜发财",
            tone: .fortuneWishing
        ),
        ChineseNewYearPersonalTouch(
            message: "Happy Chinese New Year! May it bring happiness and success",
            chineseMessage: "新年快乐",
            tone: .happinessJoy
        ),
        ChineseNewYearPersonalTouch(
            message: "May all your wishes come true this year",
            chineseMessage: "万事如意",
            tone: .prosperityBlessing
        ),
        ChineseNewYearPersonalTouch(
            message: "Wishing you and your family reunion and happiness",
            chineseMessage: "阖家欢乐",
            tone: .familyTogetherness
        ),
        ChineseNewYearPersonalTouch(
            message: "May you have good health and longevity",
            chineseMessage: "身体健康",
            tone: .healthLongevity
        ),
        ChineseNewYearPersonalTouch(
            message: "Wishing you success in all endeavors",
            chineseMessage: "事业有成",
            tone: .successAchievement
        ),
        ChineseNewYearPersonalTouch(
            message: "May the Year of the Dragon bring you strength and fortune",
            chineseMessage: "龙年大吉",
            tone: .fortuneWishing
        ),
        ChineseNewYearPersonalTouch(
            message: "Overflowing with wealth and prosperity",
            chineseMessage: "财源广进",
            tone: .prosperityBlessing
        )
    ]

    static let personalMessagePlaceholder = "Add your own Chinese New Year greeting..."
    static let maxPersonalMessageLength = 200
}

