import SwiftUI
import Foundation

// MARK: - Gift Design Tab Navigation
enum GiftDesignTab: String, CaseIterable {
    case style = "Style"
    case elements = "Elements"
    case colour = "Colour"
    case touch = "Touch"
    case create = "Create"
    case check = "Check"
    case send = "Send"

    var icon: String {
        switch self {
        case .style: return "paintbrush.fill"
        case .elements: return "square.stack.3d.up.fill"
        case .colour: return "paintpalette.fill"
        case .touch: return "hand.tap.fill"
        case .create: return "wand.and.stars"
        case .check: return "checkmark.circle.fill"
        case .send: return "paperplane.fill"
        }
    }

    var tabNumber: Int {
        switch self {
        case .style: return 1
        case .elements: return 2
        case .colour: return 3
        case .touch: return 4
        case .create: return 5
        case .check: return 6
        case .send: return 7
        }
    }
}

// MARK: - Cultural Selection State Protocol
protocol CulturalSelectionState {
    var isComplete: Bool { get }
    var summary: String { get }
}
