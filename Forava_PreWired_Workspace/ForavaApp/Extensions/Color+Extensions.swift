import SwiftUI

extension Color {
    static let gold = Color(red: 212/255, green: 175/255, blue: 55/255)
    static let silver = Color(red: 192/255, green: 192/255, blue: 192/255)
    static let lavender = Color(red: 230/255, green: 230/255, blue: 250/255)
    static let mint = Color(red: 152/255, green: 251/255, blue: 152/255)
    
    static var sacredCenter: Color {
        Color(red: 255/255, green: 223/255, blue: 0)
    }
    
    static var protectionThread: Color {
        Color(red: 255/255, green: 140/255, blue: 0)
    }
    
    // Cultural colors
    static var auspicious: Color {
        Color(red: 220/255, green: 51/255, blue: 69/255)
    }
    
    static var blessing: Color {
        Color(red: 250/255, green: 217/255, blue: 95/255)
    }
    
    static var sacred: Color {
        Color(red: 220/255, green: 51/255, blue: 69/255)
    }
    
    // Gradient helpers
    static func culturalGradient(_ colors: [Color]) -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: colors),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    static var accentGradient: LinearGradient {
        culturalGradient([.gold, .orange, .red])
    }
}

// MARK: - ShapeStyle Extensions
extension ShapeStyle where Self == Color {
    static var accentColor: Color {
        Color.accentColor
    }
    
    static var clear: Color {
        Color.clear
    }
}
