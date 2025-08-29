import Foundation
import SwiftUI

struct Rakhi: Identifiable, Codable {
    let id: UUID
    let name: String
    let imageName: String
    let description: String
    let price: Double
    let category: RakhiCategory
    let colors: [String]
    
    init(name: String, imageName: String, description: String, price: Double, category: RakhiCategory, colors: [String]) {
        self.id = UUID()
        self.name = name
        self.imageName = imageName
        self.description = description
        self.price = price
        self.category = category
        self.colors = colors
    }
    
    static let sampleRakhis = [
        Rakhi(
            name: "Traditional Gold Thread",
            imageName: "rakhi_gold_traditional",
            description: "Classic golden thread rakhi with intricate patterns",
            price: 25.00,
            category: .traditional,
            colors: ["Gold", "Red"]
        ),
        Rakhi(
            name: "Silver Beaded Elegance",
            imageName: "rakhi_silver_beaded",
            description: "Elegant silver beads with crystal accents",
            price: 35.00,
            category: .elegant,
            colors: ["Silver", "White", "Blue"]
        ),
        Rakhi(
            name: "Modern Geometric",
            imageName: "rakhi_modern_geometric",
            description: "Contemporary design with geometric patterns",
            price: 30.00,
            category: .modern,
            colors: ["Orange", "Black", "Gold"]
        ),
        Rakhi(
            name: "Spiritual Om",
            imageName: "rakhi_spiritual_om",
            description: "Sacred Om symbol with traditional threads",
            price: 20.00,
            category: .spiritual,
            colors: ["Saffron", "Red", "Gold"]
        ),
        Rakhi(
            name: "Pearl Princess",
            imageName: "rakhi_pearl_princess",
            description: "Delicate pearls with silk threads",
            price: 45.00,
            category: .elegant,
            colors: ["White", "Pearl", "Pink"]
        ),
        Rakhi(
            name: "Brother Bond",
            imageName: "rakhi_brother_bond",
            description: "Strong bond symbol in traditional style",
            price: 28.00,
            category: .traditional,
            colors: ["Red", "Yellow", "Gold"]
        )
    ]
}

enum RakhiCategory: String, CaseIterable, Codable {
    case traditional = "Traditional"
    case modern = "Modern"
    case elegant = "Elegant"
    case spiritual = "Spiritual"
    
    var displayName: String {
        return self.rawValue
    }
    
    var icon: String {
        switch self {
        case .traditional: return "star.circle.fill"
        case .modern: return "circle.hexagongrid.fill"
        case .elegant: return "sparkles"
        case .spiritual: return "heart.circle.fill"
        }
    }
}

struct Contact: Identifiable {
    let id: UUID
    let name: String
    let phoneNumber: String
    let relationship: String
    
    init(name: String, phoneNumber: String, relationship: String) {
        self.id = UUID()
        self.name = name
        self.phoneNumber = phoneNumber
        self.relationship = relationship
    }
    
    static let sampleContacts = [
        Contact(name: "Arjun Kumar", phoneNumber: "+1-555-0123", relationship: "Brother"),
        Contact(name: "Priya Sharma", phoneNumber: "+1-555-0456", relationship: "Sister"),
        Contact(name: "Rahul Patel", phoneNumber: "+1-555-0789", relationship: "Cousin"),
        Contact(name: "Anita Gupta", phoneNumber: "+1-555-0321", relationship: "Friend"),
        Contact(name: "Vikram Singh", phoneNumber: "+1-555-0654", relationship: "Brother")
    ]
}

struct RakhiGift: Identifiable, Codable {
    let id: UUID
    let rakhi: Rakhi
    let sender: String
    let recipient: String
    let sentDate: Date
    let status: GiftStatus
    let paymentAmount: Double?
    let message: String?
    
    init(rakhi: Rakhi, sender: String, recipient: String, sentDate: Date, status: GiftStatus, paymentAmount: Double? = nil, message: String? = nil) {
        self.id = UUID()
        self.rakhi = rakhi
        self.sender = sender
        self.recipient = recipient
        self.sentDate = sentDate
        self.status = status
        self.paymentAmount = paymentAmount
        self.message = message
    }
}

enum GiftStatus: String, CaseIterable, Codable {
    case sent = "Sent"
    case received = "Received"
    case paid = "Paid"
    case completed = "Completed"
}