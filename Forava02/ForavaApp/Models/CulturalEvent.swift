import Foundation
import SwiftUI

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

// Note: CulturalCategory is now defined in CoreTypes.swift
// This file imports and extends the cultural functionality

// MARK: - Cultural Event
struct CulturalEvent: Identifiable, Codable {
    let id: UUID
    let name: String
    let imageName: String
    let description: String
    let category: CulturalCategory
    let colors: [String]
    let culturalContext: String
    let isComingSoon: Bool

    init(
        name: String,
        imageName: String,
        description: String,
        category: CulturalCategory,
        colors: [String],
        culturalContext: String,
        isComingSoon: Bool = false
    ) {
        self.id = UUID()
        self.name = name
        self.imageName = imageName
        self.description = description
        self.category = category
        self.colors = colors
        self.culturalContext = culturalContext
        self.isComingSoon = isComingSoon
    }

    var selectionTitle: String {
        switch name {
        case "Raksha Bandhan":
            return "Choose a Rakhi Style"
        case "Diwali":
            return "Choose a Diya Design Style"
        case "Holi":
            return "Choose a Color Palette Style"
        case "Chinese New Year":
            return "Choose a Red Envelope Design Style"
        case "Mid-Autumn Festival":
            return "Choose a Mooncake Style"
        case "Christmas":
            return "Choose a Christmas Card Style"
        case "Easter":
            return "Choose an Easter Design Style"
        case "Eid al-Fitr":
            return "Choose an Eid Greeting Style"
        case "Eid al-Adha":
            return "Choose an Eid Design Style"
        case "Hanukkah":
            return "Choose a Menorah Design Style"
        case "Rosh Hashanah":
            return "Choose a New Year Blessing Style"
        case "Vesak Day":
            return "Choose a Lotus Design Style"
        case "Birthdays":
            return "Choose a Birthday Design Style"
        case "Anniversary":
            return "Choose an Anniversary Design Style"
        default:
            // This should never happen with our defined events, but Swift requires exhaustiveness
            return "Choose a \(name) Design Style"
        }
    }
}

// Sample events extension
extension CulturalEvent {
    // Anniversary-only build - single cultural event
    static let allEvents = [
        CulturalEvent(
            name: "Anniversary",
            imageName: "Anniversaries",
            description: "Commemorating special relationships and milestones",
            category: .universal,
            colors: ["#DC143C", "#FFD700", "#FF69B4"],
            culturalContext: "Universal celebration of lasting bonds and cherished memories"
        )
    ]
}

// MARK: - Gift Status (Definition is in CoreTypes.swift)
