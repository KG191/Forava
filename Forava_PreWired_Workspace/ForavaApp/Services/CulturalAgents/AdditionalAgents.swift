import Foundation
import SwiftUI

// MARK: - Additional Cultural Agents
// Collection of additional cultural agents for various occasions

// MARK: - Raksha Bandhan Agent
class RakshaBandhanAgent: CulturalAgent {
    let culturalContext = "rakhi_indian"
    let primaryColors: [Color] = [.orange, .red, .yellow, Color(red: 212/255, green: 175/255, blue: 55/255)]
    let culturalElements = ["rakhis", "threads", "sweets", "prayers"]
    let culturalSymbols = ["🎊", "🧵", "🍬"]
    let designPrinciples = ["traditional_indian", "brother_sister_bond", "protective_threads"]

    func generateDesign(relationship: String, personalMessage: String?) -> CulturalDesignSpec {
        return CulturalDesignSpec(
            culturalContext: culturalContext,
            primaryColors: primaryColors,
            secondaryColors: [.pink, .purple],
            elements: [
                CulturalElement(name: "rakhis", significance: "Protective thread", visualDescription: "Traditional rakhi threads", culturalImportance: .essential)
            ],
            symbols: [
                CulturalSymbol(symbol: "🎊", meaning: "Celebration", culturalSignificance: "Raksha Bandhan joy", appropriateUsage: "Festive decoration")
            ],
            typography: .traditional,
            layout: LayoutPrinciples(symmetry: true, centerFocused: true, verticalFlow: false, gridBased: false, organicFlow: true),
            culturalMessage: "May this sacred bond bring protection and blessings",
            aiPrompt: getCulturalPrompt(relationship: relationship, personalMessage: personalMessage),
            relationship: relationship,
            personalMessage: personalMessage
        )
    }

    func validateDesign(_ designSpec: CulturalDesignSpec) -> CulturalValidationResult {
        return CulturalValidationResult(
            isValid: true,
            accuracy: 0.9,
            culturalAuthenticity: 0.9,
            appropriateness: 0.9,
            issues: [],
            suggestions: []
        )
    }

    func getCulturalPrompt(relationship: String, personalMessage: String?) -> String {
        return "Create a traditional Raksha Bandhan design with orange and red colors, featuring protective threads and brother-sister bond symbolism."
    }
}

// MARK: - Holi Agent
class HoliAgent: CulturalAgent {
    let culturalContext = "holi_indian"
    let primaryColors: [Color] = [.red, .yellow, .blue, .green, .pink, .purple]
    let culturalElements = ["colors", "gulal", "water_balloons", "spring_flowers"]
    let culturalSymbols = ["🌈", "🎨", "💐"]
    let designPrinciples = ["vibrant_colors", "festival_of_colors", "spring_celebration"]

    func generateDesign(relationship: String, personalMessage: String?) -> CulturalDesignSpec {
        return CulturalDesignSpec(
            culturalContext: culturalContext,
            primaryColors: primaryColors,
            secondaryColors: [.orange, .cyan],
            elements: [
                CulturalElement(name: "colors", significance: "Joy and celebration", visualDescription: "Vibrant color powders", culturalImportance: .essential)
            ],
            symbols: [
                CulturalSymbol(symbol: "🌈", meaning: "Rainbow of colors", culturalSignificance: "Holi celebration", appropriateUsage: "Central design element")
            ],
            typography: .modern,
            layout: LayoutPrinciples(symmetry: false, centerFocused: true, verticalFlow: false, gridBased: false, organicFlow: true),
            culturalMessage: "May this festival of colors paint your life with joy",
            aiPrompt: getCulturalPrompt(relationship: relationship, personalMessage: personalMessage),
            relationship: relationship,
            personalMessage: personalMessage
        )
    }

    func validateDesign(_ designSpec: CulturalDesignSpec) -> CulturalValidationResult {
        return CulturalValidationResult(
            isValid: true,
            accuracy: 0.85,
            culturalAuthenticity: 0.9,
            appropriateness: 0.9,
            issues: [],
            suggestions: []
        )
    }

    func getCulturalPrompt(relationship: String, personalMessage: String?) -> String {
        return "Create a vibrant Holi festival design with rainbow colors, color powders, and joyful spring celebration elements."
    }
}

// MARK: - Mid-Autumn Festival Agent
class MidAutumnAgent: CulturalAgent {
    let culturalContext = "mid_autumn_chinese"
    let primaryColors: [Color] = [.orange, .yellow, .red, Color(red: 212/255, green: 175/255, blue: 55/255)]
    let culturalElements = ["mooncakes", "lanterns", "full_moon", "osmanthus_flowers"]
    let culturalSymbols = ["🥮", "🏮", "🌕", "🌸"]
    let designPrinciples = ["lunar_celebration", "family_reunion", "harvest_moon"]

    func generateDesign(relationship: String, personalMessage: String?) -> CulturalDesignSpec {
        return CulturalDesignSpec(
            culturalContext: culturalContext,
            primaryColors: primaryColors,
            secondaryColors: [.silver, .white],
            elements: [
                CulturalElement(name: "mooncakes", significance: "Family reunion", visualDescription: "Traditional round mooncakes", culturalImportance: .essential)
            ],
            symbols: [
                CulturalSymbol(symbol: "🥮", meaning: "Mooncake", culturalSignificance: "Mid-Autumn Festival", appropriateUsage: "Central symbol")
            ],
            typography: .traditional,
            layout: LayoutPrinciples(symmetry: true, centerFocused: true, verticalFlow: false, gridBased: false, organicFlow: true),
            culturalMessage: "May the full moon bring reunion and harmony",
            aiPrompt: getCulturalPrompt(relationship: relationship, personalMessage: personalMessage),
            relationship: relationship,
            personalMessage: personalMessage
        )
    }

    func validateDesign(_ designSpec: CulturalDesignSpec) -> CulturalValidationResult {
        return CulturalValidationResult(
            isValid: true,
            accuracy: 0.9,
            culturalAuthenticity: 0.85,
            appropriateness: 0.9,
            issues: [],
            suggestions: []
        )
    }

    func getCulturalPrompt(relationship: String, personalMessage: String?) -> String {
        return "Create a Mid-Autumn Festival design featuring mooncakes, lanterns, full moon, and warm reunion themes with traditional Chinese aesthetics."
    }
}

// MARK: - Easter Agent
class EasterAgent: CulturalAgent {
    let culturalContext = "easter_christian"
    let primaryColors: [Color] = [.pink, .yellow, .green, .white]
    let culturalElements = ["easter_eggs", "bunnies", "flowers", "crosses", "spring_elements"]
    let culturalSymbols = ["🐰", "🥚", "🌸", "✝️", "🌷"]
    let designPrinciples = ["spring_renewal", "resurrection_theme", "pastel_colors"]

    func generateDesign(relationship: String, personalMessage: String?) -> CulturalDesignSpec {
        return CulturalDesignSpec(
            culturalContext: culturalContext,
            primaryColors: primaryColors,
            secondaryColors: [.lavender, .mint],
            elements: [
                CulturalElement(name: "easter_eggs", significance: "New life and resurrection", visualDescription: "Colorful decorated eggs", culturalImportance: .essential)
            ],
            symbols: [
                CulturalSymbol(symbol: "🐰", meaning: "Easter bunny", culturalSignificance: "Easter celebration", appropriateUsage: "Playful element")
            ],
            typography: .serif,
            layout: LayoutPrinciples(symmetry: true, centerFocused: true, verticalFlow: true, gridBased: false, organicFlow: false),
            culturalMessage: "May this celebration bring hope and new beginnings",
            aiPrompt: getCulturalPrompt(relationship: relationship, personalMessage: personalMessage),
            relationship: relationship,
            personalMessage: personalMessage
        )
    }

    func validateDesign(_ designSpec: CulturalDesignSpec) -> CulturalValidationResult {
        return CulturalValidationResult(
            isValid: true,
            accuracy: 0.85,
            culturalAuthenticity: 0.8,
            appropriateness: 0.9,
            issues: [],
            suggestions: []
        )
    }

    func getCulturalPrompt(relationship: String, personalMessage: String?) -> String {
        return "Create an Easter design with pastel colors, Easter eggs, bunnies, spring flowers, and themes of renewal and hope."
    }
}

// MARK: - Birthday Agent
class BirthdayAgent: CulturalAgent {
    let culturalContext = "birthday_universal"
    let primaryColors: [Color] = [.pink, .blue, .yellow, .purple]
    let culturalElements = ["birthday_cakes", "balloons", "candles", "confetti", "gifts"]
    let culturalSymbols = ["🎂", "🎈", "🎁", "🎉", "🕯️"]
    let designPrinciples = ["celebration", "joy", "personal_milestones", "universal_appeal"]

    func generateDesign(relationship: String, personalMessage: String?) -> CulturalDesignSpec {
        return CulturalDesignSpec(
            culturalContext: culturalContext,
            primaryColors: primaryColors,
            secondaryColors: [.orange, .green],
            elements: [
                CulturalElement(name: "birthday_cakes", significance: "Celebration of life", visualDescription: "Festive birthday cake with candles", culturalImportance: .essential)
            ],
            symbols: [
                CulturalSymbol(symbol: "🎂", meaning: "Birthday cake", culturalSignificance: "Birthday celebration", appropriateUsage: "Central celebration symbol")
            ],
            typography: .modern,
            layout: LayoutPrinciples(symmetry: false, centerFocused: true, verticalFlow: false, gridBased: false, organicFlow: true),
            culturalMessage: "Wishing you joy, happiness, and wonderful memories",
            aiPrompt: getCulturalPrompt(relationship: relationship, personalMessage: personalMessage),
            relationship: relationship,
            personalMessage: personalMessage
        )
    }

    func validateDesign(_ designSpec: CulturalDesignSpec) -> CulturalValidationResult {
        return CulturalValidationResult(
            isValid: true,
            accuracy: 0.9,
            culturalAuthenticity: 0.7,
            appropriateness: 0.95,
            issues: [],
            suggestions: []
        )
    }

    func getCulturalPrompt(relationship: String, personalMessage: String?) -> String {
        return "Create a festive birthday design with colorful elements, birthday cake, balloons, and joyful celebration themes suitable for any age or culture."
    }
}

// MARK: - Generic Agent (Fallback)
class GenericAgent: CulturalAgent {
    let culturalContext = "generic_universal"
    let primaryColors: [Color] = [.blue, .green, .orange]
    let culturalElements = ["general_celebration", "universal_symbols"]
    let culturalSymbols = ["🎁", "⭐", "🌟"]
    let designPrinciples = ["universal_appeal", "respectful_design", "inclusive_elements"]

    func generateDesign(relationship: String, personalMessage: String?) -> CulturalDesignSpec {
        return CulturalDesignSpec(
            culturalContext: culturalContext,
            primaryColors: primaryColors,
            secondaryColors: [.purple, .yellow],
            elements: [
                CulturalElement(name: "general_celebration", significance: "Universal joy", visualDescription: "Generic celebratory elements", culturalImportance: .important)
            ],
            symbols: [
                CulturalSymbol(symbol: "🎁", meaning: "Gift", culturalSignificance: "Universal giving", appropriateUsage: "General celebration")
            ],
            typography: .modern,
            layout: LayoutPrinciples(symmetry: true, centerFocused: true, verticalFlow: false, gridBased: true, organicFlow: false),
            culturalMessage: "May this special occasion bring you joy and happiness",
            aiPrompt: getCulturalPrompt(relationship: relationship, personalMessage: personalMessage),
            relationship: relationship,
            personalMessage: personalMessage
        )
    }

    func validateDesign(_ designSpec: CulturalDesignSpec) -> CulturalValidationResult {
        return CulturalValidationResult(
            isValid: true,
            accuracy: 0.7,
            culturalAuthenticity: 0.5,
            appropriateness: 0.9,
            issues: [],
            suggestions: []
        )
    }

    func getCulturalPrompt(relationship: String, personalMessage: String?) -> String {
        return "Create a universal, culturally-neutral design suitable for general celebrations and gift-giving occasions."
    }
}
