import Foundation
import SwiftUI

// MARK: - Core Contact Model
struct Contact: Identifiable, Codable {
    let id: UUID
    let name: String
    let phoneNumber: String
    let email: String?
    let relationship: String?

    init(name: String, phoneNumber: String = "", email: String? = nil, relationship: String? = nil) {
        self.id = UUID()
        self.name = name
        self.phoneNumber = phoneNumber
        self.email = email
        self.relationship = relationship
    }
}

// Sample contacts extension
extension Contact {
    static let sampleContacts = [
        Contact(name: "Arjun Kumar", phoneNumber: "+1-555-0123", relationship: "Brother"),
        Contact(name: "Priya Sharma", phoneNumber: "+1-555-0456", relationship: "Sister"),
        Contact(name: "Rahul Patel", phoneNumber: "+1-555-0789", relationship: "Cousin"),
        Contact(name: "Anita Gupta", phoneNumber: "+1-555-0321", relationship: "Friend"),
        Contact(name: "Vikram Singh", phoneNumber: "+1-555-0654", relationship: "Brother")
    ]
}

// MARK: - Cultural Category
enum CulturalCategory: String, Codable, CaseIterable {
    case hindu = "Hindu"
    case chinese = "Chinese"
    case christian = "Christian"
    case islamic = "Islamic"
    case buddhist = "Buddhist"
    case jewish = "Jewish"
    case universal = "Universal"
    
    var displayName: String {
        return rawValue
    }
    
    var icon: String {
        switch self {
        case .hindu: return "om.fill"
        case .chinese: return "sun.max.fill"
        case .christian: return "cross.fill"
        case .islamic: return "moon.stars.fill"
        case .buddhist: return "leaf.fill"
        case .jewish: return "star.fill"
        case .universal: return "globe.americas.fill"
        }
    }
    
    var primaryColor: Color {
        switch self {
        case .hindu: return .orange
        case .chinese: return .red
        case .christian: return .green
        case .islamic: return .teal
        case .buddhist: return .purple
        case .jewish: return .blue
        case .universal: return .gray
        }
    }
}

// MARK: - Cultural Event
struct CulturalEvent: Identifiable, Codable {
    let id: UUID
    let name: String
    let imageName: String
    let description: String
    let category: CulturalCategory
    let colors: [String]
    let culturalContext: String
    
    init(name: String, imageName: String, description: String, category: CulturalCategory, colors: [String], culturalContext: String) {
        self.id = UUID()
        self.name = name
        self.imageName = imageName
        self.description = description
        self.category = category
        self.colors = colors
        self.culturalContext = culturalContext
    }
}

// Sample events extension
extension CulturalEvent {
    static let allEvents = [
        CulturalEvent(
            name: "Raksha Bandhan",
            imageName: "Rakhi",
            description: "Festival celebrating the bond between brothers and sisters",
            category: .hindu,
            colors: ["#FF6B35", "#FFD700", "#C41E3A"],
            culturalContext: "Hindu festival where sisters tie protective threads on brothers' wrists"
        ),
        CulturalEvent(
            name: "Diwali",
            imageName: "Diwali",
            description: "Festival of lights, prosperity, and new beginnings",
            category: .hindu,
            colors: ["#FF6B35", "#673AB7", "#FFD700"],
            culturalContext: "Hindu festival celebrating the victory of light over darkness"
        ),
        CulturalEvent(
            name: "Chinese New Year",
            imageName: "ChineseNewYear",
            description: "Lunar New Year celebration with family traditions",
            category: .chinese,
            colors: ["#DC143C", "#FFD700", "#B71C1C"],
            culturalContext: "Traditional Chinese festival marking the beginning of the lunar calendar"
        )
    ]
}

// MARK: - Gift Status
enum GiftStatus: String, Codable, CaseIterable {
    case sent = "sent"
    case delivered = "delivered"
    case viewed = "viewed"
    case failed = "failed"
    case pending = "pending"
}