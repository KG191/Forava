import Foundation
import SwiftUI

// MARK: - Cultural Context Framework

enum CulturalContext: String, CaseIterable, Codable {
    case rakhi = "rakhi"
    case chineseNewYear = "chinese_new_year"
    case christmas = "christmas"
    case diwali = "diwali"
    case eid = "eid"
    case hanukkah = "hanukkah"
    case vesak = "vesak"
    
    var displayName: String {
        switch self {
        case .rakhi: return "Raksha Bandhan"
        case .chineseNewYear: return "Chinese New Year"
        case .christmas: return "Christmas"
        case .diwali: return "Diwali"
        case .eid: return "Eid"
        case .hanukkah: return "Hanukkah"
        case .vesak: return "Vesak Day"
        }
    }
    
    var primaryColor: Color {
        switch self {
        case .rakhi: return Color("RakhiRed", bundle: nil) ?? .red
        case .chineseNewYear: return Color.red
        case .christmas: return Color.red
        case .diwali: return Color.orange
        case .eid: return Color.green
        case .hanukkah: return Color.blue
        case .vesak: return Color.yellow
        }
    }
    
    var secondaryColor: Color {
        switch self {
        case .rakhi: return Color.yellow
        case .chineseNewYear: return Color.yellow
        case .christmas: return Color.green
        case .diwali: return Color.purple
        case .eid: return Color.yellow
        case .hanukkah: return Color.white
        case .vesak: return Color.orange
        }
    }
    
    var accentColor: Color {
        switch self {
        case .rakhi: return Color.gold
        case .chineseNewYear: return Color.gold
        case .christmas: return Color.gold
        case .diwali: return Color.gold
        case .eid: return Color.gold
        case .hanukkah: return Color.gold
        case .vesak: return Color.white
        }
    }
    
    var symbolIcon: String {
        switch self {
        case .rakhi: return "heart.circle.fill"
        case .chineseNewYear: return "flame.fill"
        case .christmas: return "star.fill"
        case .diwali: return "sparkles"
        case .eid: return "moon.stars.fill"
        case .hanukkah: return "flame.fill"
        case .vesak: return "leaf.fill"
        }
    }
}

// MARK: - Universal Cultural Gift Model

struct CulturalGift: Identifiable, Codable {
    let id: UUID
    let culturalContext: CulturalContext
    let name: String
    let imageName: String
    let description: String
    let price: Double
    let category: GiftCategory
    let colors: [String]
    let culturalScore: Double
    
    init(culturalContext: CulturalContext, name: String, imageName: String, description: String, price: Double, category: GiftCategory, colors: [String], culturalScore: Double = 0.95) {
        self.id = UUID()
        self.culturalContext = culturalContext
        self.name = name
        self.imageName = imageName
        self.description = description
        self.price = price
        self.category = category
        self.colors = colors
        self.culturalScore = culturalScore
    }
    
    // Backward compatibility with Rakhi model
    static func fromRakhi(_ rakhi: Rakhi) -> CulturalGift {
        let giftCategory: GiftCategory
        switch rakhi.category {
        case .traditional: giftCategory = .traditional
        case .modern: giftCategory = .modern
        case .elegant: giftCategory = .elegant
        case .spiritual: giftCategory = .spiritual
        }
        
        return CulturalGift(
            culturalContext: .rakhi,
            name: rakhi.name,
            imageName: rakhi.imageName,
            description: rakhi.description,
            price: rakhi.price,
            category: giftCategory,
            colors: rakhi.colors,
            culturalScore: 0.95
        )
    }
    
    // Convert to Rakhi for backward compatibility
    func toRakhi() -> Rakhi {
        let rakhiCategory: RakhiCategory
        switch category {
        case .traditional: rakhiCategory = .traditional
        case .modern: rakhiCategory = .modern
        case .elegant: rakhiCategory = .elegant
        case .spiritual: rakhiCategory = .spiritual
        case .festive: rakhiCategory = .traditional
        case .symbolic: rakhiCategory = .spiritual
        }
        
        return Rakhi(
            name: name,
            imageName: imageName,
            description: description,
            price: price,
            category: rakhiCategory,
            colors: colors
        )
    }
}

// MARK: - Universal Gift Categories

enum GiftCategory: String, CaseIterable, Codable {
    case traditional = "Traditional"
    case modern = "Modern"
    case elegant = "Elegant"
    case spiritual = "Spiritual"
    case festive = "Festive"
    case symbolic = "Symbolic"
    
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
        case .symbolic: return "seal.fill"
        }
    }
}

// MARK: - Cultural Gift Transaction

struct CulturalGiftTransaction: Identifiable, Codable {
    let id: UUID
    let gift: CulturalGift
    let sender: String
    let recipient: String
    let sentDate: Date
    let status: GiftStatus
    let paymentAmount: Double?
    let message: String?
    let culturalContext: CulturalContext
    
    init(gift: CulturalGift, sender: String, recipient: String, sentDate: Date, status: GiftStatus, paymentAmount: Double? = nil, message: String? = nil) {
        self.id = UUID()
        self.gift = gift
        self.sender = sender
        self.recipient = recipient
        self.sentDate = sentDate
        self.status = status
        self.paymentAmount = paymentAmount
        self.message = message
        self.culturalContext = gift.culturalContext
    }
    
    // Backward compatibility with RakhiGift
    static func fromRakhiGift(_ rakhiGift: RakhiGift) -> CulturalGiftTransaction {
        let culturalGift = CulturalGift.fromRakhi(rakhiGift.rakhi)
        return CulturalGiftTransaction(
            gift: culturalGift,
            sender: rakhiGift.sender,
            recipient: rakhiGift.recipient,
            sentDate: rakhiGift.sentDate,
            status: rakhiGift.status,
            paymentAmount: rakhiGift.paymentAmount,
            message: rakhiGift.message
        )
    }
}

// MARK: - Sample Cultural Gifts

extension CulturalGift {
    static let sampleChineseNewYearGifts = [
        CulturalGift(
            culturalContext: .chineseNewYear,
            name: "Golden Dragon Card",
            imageName: "chinese_dragon_gold",
            description: "Majestic golden dragon bringing prosperity and good fortune",
            price: 30.00,
            category: .traditional,
            colors: ["Gold", "Red", "Crimson"],
            culturalScore: 0.98
        ),
        CulturalGift(
            culturalContext: .chineseNewYear,
            name: "Phoenix Prosperity",
            imageName: "chinese_phoenix_red",
            description: "Elegant phoenix design symbolizing rebirth and renewal",
            price: 35.00,
            category: .elegant,
            colors: ["Red", "Gold", "Orange"],
            culturalScore: 0.97
        ),
        CulturalGift(
            culturalContext: .chineseNewYear,
            name: "Lucky Bamboo",
            imageName: "chinese_bamboo_luck",
            description: "Traditional bamboo motif for growth and fortune",
            price: 25.00,
            category: .traditional,
            colors: ["Green", "Gold", "Yellow"],
            culturalScore: 0.96
        )
    ]
}

// MARK: - Color Extensions for Cultural Themes

extension Color {
    static let gold = Color.yellow.opacity(0.8)
    static let crimson = Color(red: 0.86, green: 0.08, blue: 0.24)
}