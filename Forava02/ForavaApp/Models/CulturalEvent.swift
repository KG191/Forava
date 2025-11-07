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
    // Landing page events (alphabetically ordered)
    static let allEvents = [
        CulturalEvent(
            name: "Anniversary",
            imageName: "Anniversaries",
            description: "Commemorating special relationships and milestones",
            category: .universal,
            colors: ["#DC143C", "#FFD700", "#FF69B4"],
            culturalContext: "Universal celebration of lasting bonds and cherished memories"
        ),
        CulturalEvent(
            name: "Chinese New Year",
            imageName: "ChineseNewYear",
            description: "Lunar New Year celebration with family traditions",
            category: .chinese,
            colors: ["#DC143C", "#FFD700", "#B71C1C"],
            culturalContext: "Traditional Chinese festival marking the beginning of the lunar calendar"
        ),
        CulturalEvent(
            name: "Christmas",
            imageName: "Christmas",
            description: "Christian celebration of love, joy, and giving",
            category: .christian,
            colors: ["#C41E3A", "#228B22", "#FFD700"],
            culturalContext: "Christian festival celebrating the birth of Jesus Christ"
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
            name: "Easter",
            imageName: "Easter",
            description: "Christian celebration of resurrection and new life",
            category: .christian,
            colors: ["#FFB6C1", "#98FB98", "#FFD700"],
            culturalContext: "Christian festival celebrating the resurrection of Jesus Christ"
        ),
        CulturalEvent(
            name: "Eid al-Adha",
            imageName: "Eid al-Adha",
            description: "Islamic festival of sacrifice and devotion",
            category: .islamic,
            colors: ["#4682B4", "#FFD700", "#20B2AA"],
            culturalContext: "Islamic festival commemorating Ibrahim's willingness to sacrifice"
        ),
        CulturalEvent(
            name: "Hanukkah",
            imageName: "Hanukkah",
            description: "Jewish Festival of Lights celebrating religious freedom",
            category: .jewish,
            colors: ["#0047AB", "#FFD700", "#FFFFFF"],
            culturalContext: "Jewish festival commemorating the rededication of the Second Temple"
        ),
        CulturalEvent(
            name: "Holi",
            imageName: "Holi",
            description: "Festival of colors, spring, and new beginnings",
            category: .hindu,
            colors: ["#FF69B4", "#00CED1", "#FFD700"],
            culturalContext: "Hindu festival celebrating the arrival of spring with vibrant colors"
        ),
        CulturalEvent(
            name: "Mid-Autumn Festival",
            imageName: "Mid-Autumn Festival",
            description: "Chinese festival celebrating family unity and harvest",
            category: .chinese,
            colors: ["#FFD700", "#FF4500", "#8B0000"],
            culturalContext: "Traditional Chinese festival celebrating the full moon and family reunion"
        ),
        CulturalEvent(
            name: "Raksha Bandhan",
            imageName: "RakshaBandan",
            description: "Festival celebrating the bond between brothers and sisters",
            category: .hindu,
            colors: ["#FF6B35", "#FFD700", "#C41E3A"],
            culturalContext: "Hindu festival where sisters tie protective threads on brothers' wrists"
        ),
        CulturalEvent(
            name: "Rosh Hashanah",
            imageName: "Rosh Hashanah",
            description: "Jewish New Year celebration of renewal and reflection",
            category: .jewish,
            colors: ["#4169E1", "#FFD700", "#FFFFFF"],
            culturalContext: "Jewish festival marking the beginning of the High Holy Days"
        ),
        CulturalEvent(
            name: "Vesak Day",
            imageName: "Vesak Day",
            description: "Buddhist celebration of Buddha's birth, enlightenment, and death",
            category: .buddhist,
            colors: ["#9370DB", "#FFD700", "#FFA500"],
            culturalContext: "Buddhist festival honoring the life and teachings of Buddha"
        )
    ]
}

// MARK: - Gift Status (Definition is in CoreTypes.swift)
