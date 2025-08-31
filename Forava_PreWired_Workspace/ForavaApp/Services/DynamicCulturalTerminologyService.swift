import Foundation
import SwiftUI

// MARK: - Phase 5: Dynamic Cultural Terminology System
// Transforms hardcoded "Rakhi" references to contextual cultural terms

@MainActor
class DynamicCulturalTerminologyService: ObservableObject {
    static let shared = DynamicCulturalTerminologyService()

    @Published var selectedOccasion: String = "raksha_bandhan"
    @Published var culturalContext: String = "rakhi_indian"

    private init() {
        // Load from UserDefaults if previously saved
        if let savedOccasion = UserDefaults.standard.string(forKey: "selected_cultural_occasion") {
            selectedOccasion = savedOccasion
        }
        if let savedContext = UserDefaults.standard.string(forKey: "selected_cultural_context") {
            culturalContext = savedContext
        }
    }

    // MARK: - Cultural Occasion Management

    func updateCulturalSettings(occasion: String, context: String) {
        selectedOccasion = occasion
        culturalContext = context

        // Persist to UserDefaults
        UserDefaults.standard.set(occasion, forKey: "selected_cultural_occasion")
        UserDefaults.standard.set(context, forKey: "selected_cultural_context")

        // Notify UI to update
        objectWillChange.send()

        print("🌍 Updated cultural settings - Occasion: \(occasion), Context: \(context)")
    }

    // PHASE 5: Simplified update method
    func updateTerminology() {
        objectWillChange.send()
        print("🔄 Refreshed terminology for occasion: \(selectedOccasion)")
    }

    // MARK: - Dynamic Terminology Generation

    /// Primary gift term (e.g., "Rakhi" → "Digital Diwali Gift")
    var digitalGiftTerm: String {
        let occasionName = getOccasionDisplayName(selectedOccasion)
        return "Digital \(occasionName) Gift"
    }

    /// Shortened gift term (e.g., "Rakhi" → "Diwali Gift")
    var shortGiftTerm: String {
        let occasionName = getOccasionDisplayName(selectedOccasion)
        return "\(occasionName) Gift"
    }

    /// Creation action term (e.g., "Create a Rakhi" → "Create a Digital Christmas Gift")
    var createActionTerm: String {
        return "Create a \(digitalGiftTerm)"
    }

    /// Send action term (e.g., "Send Rakhi" → "Send Digital New Year Gift")
    var sendActionTerm: String {
        return "Send \(digitalGiftTerm)"
    }

    /// Gift ready message (e.g., "Your Rakhi is Ready!" → "Your Digital Easter Gift is Ready!")
    var giftReadyMessage: String {
        return "Your \(digitalGiftTerm) is Ready!"
    }

    /// Gift history term (e.g., "Rakhi History" → "Diwali Gift History")
    var giftHistoryTerm: String {
        let occasionName = getOccasionDisplayName(selectedOccasion)
        return "\(occasionName) Gift History"
    }

    /// Cultural blessing/greeting (e.g., for notifications)
    var culturalBlessing: String {
        return getCulturalBlessing(for: selectedOccasion)
    }

    /// Cultural symbol/emoji
    var culturalSymbol: String {
        return getCulturalSymbol(for: selectedOccasion)
    }

    // PHASE 5: Additional dynamic terminology properties

    /// Notification title (e.g., "Rakhi Ready!" → "Digital Christmas Gift Ready!")
    var notificationTitle: String {
        return "\(digitalGiftTerm) Ready!"
    }

    /// App title context (e.g., "Forava - Rakhi Gifts" → "Forava - Christmas Gifts")
    var appTitleContext: String {
        return "Forava - \(shortGiftTerm)s"
    }

    /// Share message (e.g., "Check out my Rakhi!" → "Check out my Digital Eid Gift!")
    var shareMessage: String {
        return "Check out my \(digitalGiftTerm)!"
    }

    /// Tab bar title (e.g., "Create Rakhi" → "Create Gift")
    var createTabTitle: String {
        return "Create Gift"
    }

    /// History tab title (e.g., "Rakhi History" → "History")
    var historyTabTitle: String {
        return "History"
    }

    // MARK: - Supported Cultural Occasions

    static let supportedOccasions: [CulturalOccasion] = [
        CulturalOccasion(
            id: "raksha_bandhan",
            displayName: "Raksha Bandhan",
            culturalContext: "rakhi_indian",
            symbol: "🎊",
            colors: [.orange, .red, .yellow]
        ),
        CulturalOccasion(
            id: "diwali",
            displayName: "Diwali",
            culturalContext: "diwali_indian",
            symbol: "🪔",
            colors: [.orange, .yellow, .purple]
        ),
        CulturalOccasion(
            id: "chinese_new_year",
            displayName: "Chinese New Year",
            culturalContext: "cny_chinese",
            symbol: "🧧",
            colors: [.red, Color(red: 212/255, green: 175/255, blue: 55/255)]
        ),
        CulturalOccasion(
            id: "christmas",
            displayName: "Christmas",
            culturalContext: "christmas_christian",
            symbol: "🎄",
            colors: [.red, .green, Color(red: 212/255, green: 175/255, blue: 55/255)]
        ),
        CulturalOccasion(
            id: "eid",
            displayName: "Eid",
            culturalContext: "eid_islamic",
            symbol: "🌙",
            colors: [.green, Color(red: 212/255, green: 175/255, blue: 55/255), .white]
        ),
        CulturalOccasion(
            id: "vesak",
            displayName: "Vesak Day",
            culturalContext: "vesak_buddhist",
            symbol: "🪷",
            colors: [.blue, .white, .yellow]
        ),
        CulturalOccasion(
            id: "rosh_hashanah",
            displayName: "Rosh Hashanah",
            culturalContext: "rosh_hashanah_jewish",
            symbol: "🍎",
            colors: [.blue, .white, Color(red: 192/255, green: 192/255, blue: 192/255)]
        ),
        CulturalOccasion(
            id: "hanukkah",
            displayName: "Hanukkah",
            culturalContext: "hanukkah_jewish",
            symbol: "🕎",
            colors: [.blue, .white, Color(red: 192/255, green: 192/255, blue: 192/255)]
        ),
        CulturalOccasion(
            id: "holi",
            displayName: "Holi",
            culturalContext: "holi_indian",
            symbol: "🌈",
            colors: [.red, .yellow, .blue, .green]
        ),
        CulturalOccasion(
            id: "mid_autumn_festival",
            displayName: "Mid-Autumn Festival",
            culturalContext: "mid_autumn_chinese",
            symbol: "🥮",
            colors: [.orange, .yellow, .red]
        ),
        CulturalOccasion(
            id: "easter",
            displayName: "Easter",
            culturalContext: "easter_christian",
            symbol: "🐰",
            colors: [.pink, .yellow, .green]
        ),
        CulturalOccasion(
            id: "birthday",
            displayName: "Birthday",
            culturalContext: "birthday_universal",
            symbol: "🎂",
            colors: [.pink, .blue, .yellow]
        )
    ]

    // MARK: - Helper Methods

    private func getOccasionDisplayName(_ occasion: String) -> String {
        return Self.supportedOccasions.first { $0.id == occasion }?.displayName ?? "Special"
    }

    private func getCulturalSymbol(for occasion: String) -> String {
        return Self.supportedOccasions.first { $0.id == occasion }?.symbol ?? "🎁"
    }

    private func getCulturalBlessing(for occasion: String) -> String {
        switch occasion.lowercased() {
        case "raksha_bandhan":
            return "May this sacred bond bring protection and blessings"
        case "diwali":
            return "May this festival of lights illuminate your path with joy"
        case "chinese_new_year":
            return "Wishing you prosperity and good fortune"
        case "christmas":
            return "May the spirit of Christmas bring you peace and joy"
        case "eid":
            return "May this blessed celebration bring spiritual fulfillment"
        case "vesak":
            return "May the teachings of Buddha bring inner peace"
        case "rosh_hashanah":
            return "May this new year bring health and happiness"
        case "hanukkah":
            return "May the Festival of Lights illuminate your path"
        case "holi":
            return "May this festival of colors paint your life with joy"
        case "mid_autumn_festival":
            return "May the full moon bring reunion and harmony"
        case "easter":
            return "May this celebration bring hope and new beginnings"
        case "birthday":
            return "Wishing you joy, happiness, and wonderful memories"
        default:
            return "May this special occasion bring you joy and happiness"
        }
    }

    // MARK: - Dynamic String Replacement

    /// Replaces "Rakhi" with appropriate cultural term in any string
    func culturalize(_ text: String) -> String {
        var result = text

        // Replace various forms of "Rakhi" with appropriate terms
        let replacements: [(String, String)] = [
            ("Rakhi gifts", "\(shortGiftTerm)s"),
            ("Rakhi gift", shortGiftTerm),
            ("Rakhi notifications", "\(shortGiftTerm) notifications"),
            ("Rakhi", shortGiftTerm),
            ("rakhi", shortGiftTerm.lowercased()),
            ("RAKHI", shortGiftTerm.uppercased())
        ]

        for (original, replacement) in replacements {
            result = result.replacingOccurrences(of: original, with: replacement)
        }

        return result
    }

    // MARK: - Cultural Settings Validation

    func validateCulturalSettings() -> Bool {
        return Self.supportedOccasions.contains { $0.id == selectedOccasion }
    }

    func getCurrentOccasion() -> CulturalOccasion? {
        return Self.supportedOccasions.first { $0.id == selectedOccasion }
    }
}

// MARK: - Supporting Types

struct CulturalOccasion: Identifiable, Hashable {
    let id: String
    let displayName: String
    let culturalContext: String
    let symbol: String
    let colors: [Color]

    var primaryColor: Color {
        return colors.first ?? .orange
    }

    var secondaryColor: Color {
        return colors.count > 1 ? colors[1] : .blue
    }

    // PHASE 5: Additional properties for UI integration
    var shortName: String {
        // Extract shorter names for compact UI
        switch id {
        case "raksha_bandhan": return "Rakhi"
        case "chinese_new_year": return "CNY"
        case "mid_autumn_festival": return "Mid-Autumn"
        case "rosh_hashanah": return "Rosh"
        default: return displayName
        }
    }

    var icon: String {
        // Map symbols to SF Symbol names for consistency
        switch id {
        case "raksha_bandhan": return "heart.fill"
        case "diwali": return "flame.fill"
        case "chinese_new_year": return "sparkles"
        case "christmas": return "gift.fill"
        case "eid": return "moon.stars.fill"
        case "vesak": return "leaf.fill"
        case "rosh_hashanah": return "star.fill"
        case "hanukkah": return "menorah.fill"
        case "holi": return "paintpalette.fill"
        case "mid_autumn_festival": return "moon.fill"
        case "easter": return "sun.max.fill"
        case "birthday": return "gift.circle.fill"
        default: return "gift.fill"
        }
    }
}

// MARK: - SwiftUI Integration Extensions

extension View {
    /// Modifier to automatically apply cultural terminology to text
    func culturalized() -> some View {
        self.environmentObject(DynamicCulturalTerminologyService.shared)
    }
}

// MARK: - String Extensions for Cultural Terminology

extension String {
    /// Automatically applies cultural terminology transformation
    var culturalized: String {
        return DynamicCulturalTerminologyService.shared.culturalize(self)
    }
}

// MARK: - UserDefaults Extensions

extension UserDefaults {
    func setCulturalOccasion(_ occasion: String) {
        set(occasion, forKey: "selected_cultural_occasion")
    }

    func getCulturalOccasion() -> String {
        return string(forKey: "selected_cultural_occasion") ?? "raksha_bandhan"
    }

    func setCulturalContext(_ context: String) {
        set(context, forKey: "selected_cultural_context")
    }

    func getCulturalContext() -> String {
        return string(forKey: "selected_cultural_context") ?? "rakhi_indian"
    }
}
