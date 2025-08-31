import Foundation
import SwiftUI

// MARK: - Universal Cultural Gift Model
struct CulturalGift: Identifiable, Codable {
    let id: UUID
    let name: String
    let imageName: String
    let description: String
    let price: Double
    let category: CulturalGiftCategory
    let culturalContext: CulturalCategory
    let colors: [String]
    let culturalSignificance: Double
    let ageAppropriate: [AgeGroup]

    init(
        name: String,
        imageName: String,
        description: String,
        price: Double,
        category: CulturalGiftCategory,
        culturalContext: CulturalCategory,
        colors: [String],
        culturalSignificance: Double = 0.8,
        ageAppropriate: [AgeGroup] = [.any]
    ) {
        self.id = UUID()
        self.name = name
        self.imageName = imageName
        self.description = description
        self.price = price
        self.category = category
        self.culturalContext = culturalContext
        self.colors = colors
        self.culturalSignificance = culturalSignificance
        self.ageAppropriate = ageAppropriate
    }

    // Static method to create a CulturalGift from existing Rakhi
    static func from(rakhi: Rakhi, culturalContext: CulturalCategory = .hindu) -> CulturalGift {
        return CulturalGift(
            name: rakhi.name,
            imageName: rakhi.imageName,
            description: rakhi.description,
            price: rakhi.price,
            category: .traditional, // Map from RakhiCategory to CulturalGiftCategory
            culturalContext: culturalContext,
            colors: rakhi.colors,
            culturalSignificance: 0.9,
            ageAppropriate: [.any]
        )
    }

    // Sample gifts for all cultures
    static let allCulturalGifts: [CulturalGift] = [
        // HINDU GIFTS (Rakhi, Diwali, Holi)
        CulturalGift(
            name: "Traditional Gold Thread Rakhi",
            imageName: "rakhi_gold_traditional",
            description: "Classic golden thread rakhi with intricate patterns",
            price: 25.00,
            category: .traditional,
            culturalContext: .hindu,
            colors: ["Gold", "Red"],
            culturalSignificance: 1.0,
            ageAppropriate: [.any]
        ),
        CulturalGift(
            name: "Sacred Om Rakhi",
            imageName: "rakhi_spiritual_om",
            description: "Sacred Om symbol with traditional threads",
            price: 20.00,
            category: .spiritual,
            culturalContext: .hindu,
            colors: ["Saffron", "Red", "Gold"],
            culturalSignificance: 1.0,
            ageAppropriate: [.adult, .elder]
        ),
        // Diwali Collection - Festival of Lights
        CulturalGift(
            name: "Diwali Light Celebration",
            imageName: "diwali_lights",
            description: "Beautiful diya lamps illuminating the path to prosperity",
            price: 35.00,
            category: .festive,
            culturalContext: .hindu,
            colors: ["Orange", "Gold", "Red"],
            culturalSignificance: 1.0,
            ageAppropriate: [.any]
        ),
        CulturalGift(
            name: "Lakshmi Prosperity Blessing",
            imageName: "diwali_lakshmi",
            description: "Goddess Lakshmi bringing wealth and fortune",
            price: 42.00,
            category: .spiritual,
            culturalContext: .hindu,
            colors: ["Gold", "Red", "Pink"],
            culturalSignificance: 1.0,
            ageAppropriate: [.any]
        ),
        CulturalGift(
            name: "Rangoli Art Masterpiece",
            imageName: "diwali_rangoli",
            description: "Intricate rangoli patterns welcoming good fortune",
            price: 28.00,
            category: .artistic,
            culturalContext: .hindu,
            colors: ["Orange", "Yellow", "Pink", "Green"],
            culturalSignificance: 0.95,
            ageAppropriate: [.any]
        ),
        CulturalGift(
            name: "Golden Diya Symphony",
            imageName: "diwali_golden_diya",
            description: "Elegant golden oil lamps dispelling darkness",
            price: 32.00,
            category: .traditional,
            culturalContext: .hindu,
            colors: ["Gold", "Orange", "Red"],
            culturalSignificance: 1.0,
            ageAppropriate: [.any]
        ),
        CulturalGift(
            name: "Fireworks Joy Celebration",
            imageName: "diwali_fireworks",
            description: "Sparkling fireworks lighting up the night sky",
            price: 38.00,
            category: .celebratory,
            culturalContext: .hindu,
            colors: ["Gold", "Orange", "Blue", "Pink"],
            culturalSignificance: 0.9,
            ageAppropriate: [.any]
        ),
        CulturalGift(
            name: "Sweet Treats Box",
            imageName: "diwali_sweets",
            description: "Traditional mithai sweets sharing joy and sweetness",
            price: 30.00,
            category: .culinary,
            culturalContext: .hindu,
            colors: ["Gold", "Orange", "Brown"],
            culturalSignificance: 0.85,
            ageAppropriate: [.any]
        ),
        CulturalGift(
            name: "Ganesh Blessing Light",
            imageName: "diwali_ganesh",
            description: "Lord Ganesh removing obstacles for new beginnings",
            price: 40.00,
            category: .spiritual,
            culturalContext: .hindu,
            colors: ["Orange", "Gold", "Red"],
            culturalSignificance: 1.0,
            ageAppropriate: [.any]
        ),
        
        // Holi Collection - Festival of Colors
        CulturalGift(
            name: "Holi Color Splash",
            imageName: "holi_colors",
            description: "Vibrant colors celebrating spring festival of love and joy",
            price: 30.00,
            category: .festive,
            culturalContext: .hindu,
            colors: ["Pink", "Blue", "Yellow", "Green"],
            culturalSignificance: 0.95,
            ageAppropriate: [.any]
        ),
        CulturalGift(
            name: "Radha Krishna Love Celebration",
            imageName: "holi_radha_krishna",
            description: "Divine love of Radha and Krishna in colorful splendor",
            price: 38.00,
            category: .spiritual,
            culturalContext: .hindu,
            colors: ["Pink", "Blue", "Gold"],
            culturalSignificance: 1.0,
            ageAppropriate: [.any]
        ),
        CulturalGift(
            name: "Gulal Powder Blessing",
            imageName: "holi_gulal",
            description: "Sacred colored powder spreading happiness and unity",
            price: 25.00,
            category: .traditional,
            culturalContext: .hindu,
            colors: ["Pink", "Yellow", "Green", "Orange"],
            culturalSignificance: 0.9,
            ageAppropriate: [.any]
        ),
        CulturalGift(
            name: "Holika Dahan Victory",
            imageName: "holi_bonfire",
            description: "Sacred bonfire celebrating triumph of good over evil",
            price: 35.00,
            category: .spiritual,
            culturalContext: .hindu,
            colors: ["Orange", "Red", "Gold"],
            culturalSignificance: 1.0,
            ageAppropriate: [.any]
        ),
        CulturalGift(
            name: "Spring Flowers Garland",
            imageName: "holi_flowers",
            description: "Fresh spring flowers welcoming new beginnings",
            price: 28.00,
            category: .artistic,
            culturalContext: .hindu,
            colors: ["Pink", "Yellow", "White", "Green"],
            culturalSignificance: 0.85,
            ageAppropriate: [.any]
        ),
        CulturalGift(
            name: "Pichkari Water Joy",
            imageName: "holi_pichkari",
            description: "Colorful water guns spreading playful happiness",
            price: 22.00,
            category: .celebratory,
            culturalContext: .hindu,
            colors: ["Blue", "Pink", "Yellow"],
            culturalSignificance: 0.8,
            ageAppropriate: [.any]
        ),
        CulturalGift(
            name: "Gujiya Sweet Delight",
            imageName: "holi_gujiya",
            description: "Traditional sweet dumplings sharing festive joy",
            price: 26.00,
            category: .culinary,
            culturalContext: .hindu,
            colors: ["Golden", "Brown", "White"],
            culturalSignificance: 0.9,
            ageAppropriate: [.any]
        ),
        CulturalGift(
            name: "Unity Dance Celebration",
            imageName: "holi_dance",
            description: "Joyful dancing bringing communities together in color",
            price: 32.00,
            category: .celebratory,
            culturalContext: .hindu,
            colors: ["Rainbow", "Pink", "Blue", "Yellow"],
            culturalSignificance: 0.85,
            ageAppropriate: [.any]
        ),

        // CHINESE GIFTS
        CulturalGift(
            name: "Golden Dragon Blessing",
            imageName: "chinese_dragon_gold",
            description: "Majestic golden dragon for prosperity",
            price: 40.00,
            category: .traditional,
            culturalContext: .chinese,
            colors: ["Gold", "Red", "Black"],
            culturalSignificance: 1.0,
            ageAppropriate: [.any]
        ),
        CulturalGift(
            name: "Lucky Red Envelope",
            imageName: "chinese_red_envelope",
            description: "Traditional hongbao with gold accents",
            price: 25.00,
            category: .traditional,
            culturalContext: .chinese,
            colors: ["Red", "Gold"],
            culturalSignificance: 0.95,
            ageAppropriate: [.any]
        ),
        CulturalGift(
            name: "Phoenix Prosperity",
            imageName: "chinese_phoenix",
            description: "Elegant phoenix design for good fortune",
            price: 45.00,
            category: .elegant,
            culturalContext: .chinese,
            colors: ["Red", "Gold", "Pink"],
            culturalSignificance: 0.9,
            ageAppropriate: [.adult, .elder]
        ),

        // CHRISTIAN GIFTS
        // Christmas Collection
        CulturalGift(
            name: "Christmas Angel",
            imageName: "christmas_angel",
            description: "Beautiful angel with golden wings spreading Christmas joy",
            price: 35.00,
            category: .spiritual,
            culturalContext: .christian,
            colors: ["White", "Gold", "Blue"],
            culturalSignificance: 0.95,
            ageAppropriate: [.any]
        ),
        CulturalGift(
            name: "Festive Holly Wreath",
            imageName: "christmas_holly",
            description: "Classic holly wreath with red berries and Christmas spirit",
            price: 30.00,
            category: .traditional,
            culturalContext: .christian,
            colors: ["Green", "Red", "Gold"],
            culturalSignificance: 0.9,
            ageAppropriate: [.any]
        ),
        CulturalGift(
            name: "Christmas Tree Celebration",
            imageName: "christmas_tree",
            description: "Magnificent Christmas tree with twinkling lights and ornaments",
            price: 45.00,
            category: .festive,
            culturalContext: .christian,
            colors: ["Green", "Gold", "Red"],
            culturalSignificance: 1.0,
            ageAppropriate: [.any]
        ),
        CulturalGift(
            name: "Santa's Gift Blessing",
            imageName: "santa_gift",
            description: "Jolly Santa with a sack full of Christmas presents",
            price: 40.00,
            category: .celebratory,
            culturalContext: .christian,
            colors: ["Red", "White", "Gold"],
            culturalSignificance: 0.8,
            ageAppropriate: [.any]
        ),
        CulturalGift(
            name: "Christmas Star Wonder",
            imageName: "christmas_star",
            description: "Brilliant Christmas star guiding the way to joy and peace",
            price: 32.00,
            category: .spiritual,
            culturalContext: .christian,
            colors: ["Gold", "White", "Silver"],
            culturalSignificance: 1.0,
            ageAppropriate: [.any]
        ),
        CulturalGift(
            name: "Candy Cane Delight",
            imageName: "candy_cane",
            description: "Sweet striped candy canes bringing Christmas sweetness",
            price: 20.00,
            category: .celebratory,
            culturalContext: .christian,
            colors: ["Red", "White"],
            culturalSignificance: 0.7,
            ageAppropriate: [.any]
        ),
        CulturalGift(
            name: "Christmas Bells Harmony",
            imageName: "christmas_bells",
            description: "Golden bells ringing with Christmas melodies and blessings",
            price: 28.00,
            category: .traditional,
            culturalContext: .christian,
            colors: ["Gold", "Red", "Green"],
            culturalSignificance: 0.85,
            ageAppropriate: [.any]
        ),
        
        // Easter Collection
        CulturalGift(
            name: "Easter Blessing",
            imageName: "easter_cross",
            description: "Elegant cross with spring flowers celebrating resurrection",
            price: 25.00,
            category: .spiritual,
            culturalContext: .christian,
            colors: ["White", "Pink", "Green"],
            culturalSignificance: 0.95,
            ageAppropriate: [.any]
        ),

        // ISLAMIC GIFTS
        CulturalGift(
            name: "Crescent Moon Blessing",
            imageName: "islamic_crescent",
            description: "Beautiful crescent moon with stars",
            price: 30.00,
            category: .spiritual,
            culturalContext: .islamic,
            colors: ["Green", "Gold", "White"],
            culturalSignificance: 1.0,
            ageAppropriate: [.any]
        ),
        CulturalGift(
            name: "Eid Celebration",
            imageName: "eid_celebration",
            description: "Joyful Eid greeting with traditional patterns",
            price: 35.00,
            category: .festive,
            culturalContext: .islamic,
            colors: ["Green", "Gold", "White"],
            culturalSignificance: 0.95,
            ageAppropriate: [.any]
        ),

        // JEWISH GIFTS
        CulturalGift(
            name: "Star of David",
            imageName: "jewish_star",
            description: "Traditional Star of David in blue and silver",
            price: 28.00,
            category: .spiritual,
            culturalContext: .jewish,
            colors: ["Blue", "Silver", "White"],
            culturalSignificance: 1.0,
            ageAppropriate: [.any]
        ),
        CulturalGift(
            name: "Hanukkah Menorah",
            imageName: "hanukkah_menorah",
            description: "Festival of lights celebration",
            price: 40.00,
            category: .festive,
            culturalContext: .jewish,
            colors: ["Blue", "Gold", "White"],
            culturalSignificance: 1.0,
            ageAppropriate: [.any]
        ),

        // BUDDHIST GIFTS
        CulturalGift(
            name: "Lotus Enlightenment",
            imageName: "buddhist_lotus",
            description: "Sacred lotus flower for peace",
            price: 32.00,
            category: .spiritual,
            culturalContext: .buddhist,
            colors: ["Pink", "Gold", "White"],
            culturalSignificance: 1.0,
            ageAppropriate: [.any]
        ),
        CulturalGift(
            name: "Buddha Blessing",
            imageName: "buddhist_buddha",
            description: "Peaceful Buddha for Vesak Day",
            price: 38.00,
            category: .spiritual,
            culturalContext: .buddhist,
            colors: ["Orange", "Gold", "Brown"],
            culturalSignificance: 1.0,
            ageAppropriate: [.adult, .elder]
        ),

        // UNIVERSAL GIFTS
        CulturalGift(
            name: "Birthday Celebration",
            imageName: "birthday_cake",
            description: "Joyful birthday cake with candles",
            price: 25.00,
            category: .celebratory,
            culturalContext: .universal,
            colors: ["Pink", "Blue", "Yellow"],
            culturalSignificance: 0.7,
            ageAppropriate: [.any]
        ),
        CulturalGift(
            name: "Anniversary Hearts",
            imageName: "anniversary_hearts",
            description: "Romantic hearts for special moments",
            price: 30.00,
            category: .romantic,
            culturalContext: .universal,
            colors: ["Red", "Pink", "Gold"],
            culturalSignificance: 0.7,
            ageAppropriate: [.adult, .elder]
        )
    ]

    // Helper methods to filter gifts
    static func gifts(for culturalContext: CulturalCategory) -> [CulturalGift] {
        return allCulturalGifts.filter { $0.culturalContext == culturalContext }
    }

    static func gifts(for category: CulturalGiftCategory) -> [CulturalGift] {
        return allCulturalGifts.filter { $0.category == category }
    }

    static func gifts(for culturalContext: CulturalCategory, category: CulturalGiftCategory) -> [CulturalGift] {
        return allCulturalGifts.filter {
            $0.culturalContext == culturalContext && $0.category == category
        }
    }
}

// MARK: - Cultural Gift Categories
enum CulturalGiftCategory: String, CaseIterable, Codable {
    case traditional = "Traditional"
    case modern = "Modern"
    case elegant = "Elegant"
    case spiritual = "Spiritual"
    case festive = "Festive"
    case celebratory = "Celebratory"
    case romantic = "Romantic"
    case artistic = "Artistic"
    case culinary = "Culinary"

    var displayName: String {
        return self.rawValue
    }

    var icon: String {
        switch self {
        case .traditional: return "star.circle.fill"
        case .modern: return "circle.hexagongrid.fill"
        case .elegant: return "sparkles"
        case .spiritual: return "heart.circle.fill"
        case .festive: return "party.popper.fill"
        case .celebratory: return "balloon.2.fill"
        case .romantic: return "heart.fill"
        case .artistic: return "paintbrush.fill"
        case .culinary: return "fork.knife"
        }
    }

    var culturalWeight: Double {
        switch self {
        case .traditional: return 1.0
        case .spiritual: return 0.95
        case .festive: return 0.9
        case .elegant: return 0.8
        case .celebratory: return 0.7
        case .romantic: return 0.7
        case .modern: return 0.6
        case .artistic: return 0.85
        case .culinary: return 0.8
        }
    }
}

// MARK: - Cultural Gift Transaction
struct CulturalGiftTransaction: Identifiable, Codable {
    let id: UUID
    let gift: CulturalGift
    let sender: String
    let recipient: Contact
    let sentDate: Date
    let status: GiftStatus
    let paymentAmount: Double?
    let message: String?
    let culturalEvent: CulturalEvent

    init(
        gift: CulturalGift,
        sender: String,
        recipient: Contact,
        culturalEvent: CulturalEvent,
        sentDate: Date = Date(),
        status: GiftStatus = .sent,
        paymentAmount: Double? = nil,
        message: String? = nil
    ) {
        self.id = UUID()
        self.gift = gift
        self.sender = sender
        self.recipient = recipient
        self.culturalEvent = culturalEvent
        self.sentDate = sentDate
        self.status = status
        self.paymentAmount = paymentAmount
        self.message = message
    }
}

// MARK: - Extension to support backward compatibility with Rakhi
extension Rakhi {
    func toCulturalGift() -> CulturalGift {
        let giftCategory: CulturalGiftCategory = {
            switch self.category {
            case .traditional: return .traditional
            case .modern: return .modern
            case .elegant: return .elegant
            case .spiritual: return .spiritual
            }
        }()

        return CulturalGift(
            name: self.name,
            imageName: self.imageName,
            description: self.description,
            price: self.price,
            category: giftCategory,
            culturalContext: .hindu,
            colors: self.colors,
            culturalSignificance: 0.9,
            ageAppropriate: [.any]
        )
    }
}
