import Foundation
import SwiftUI

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
        case .hindu: return "sun.max.fill"
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

// MARK: - Cultural Event (Main definition is in CulturalEvent.swift)

// MARK: - Gift Status
enum GiftStatus: String, Codable, CaseIterable {
    case sent = "sent"
    case delivered = "delivered"
    case viewed = "viewed"
    case failed = "failed"
    case pending = "pending"
}