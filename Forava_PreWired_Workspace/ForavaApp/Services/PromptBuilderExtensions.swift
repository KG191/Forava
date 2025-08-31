import Foundation

// MARK: - Prompt Builder Extensions
extension PromptMapper {

    // MARK: - Advanced Prompt Building

    internal func buildCulturalContext(_ designSpec: RakhiDesignSpec) async -> String {
        // Only add minimal cultural context to preserve user selections
        var context = "Indian rakhi, "

        switch designSpec.genre {
        case .traditional:
            context += "traditional style, "
        case .spiritual:
            context += "spiritual design, "
        case .elegant:
            context += "elegant craftsmanship, "
        case .modern:
            context += "modern contemporary design, "
        case .unknown:
            context += "cultural design, "
        }

        // Minimal festival context
        context += "Raksha Bandhan festival, "

        return context
    }

    internal func buildElementPrompts(_ elements: [DesignElement]) async -> String {
        guard !elements.isEmpty else {
            return "minimal design, clean appearance"
        }

        var elementPrompts: [String] = []

        for element in elements {
            // Use VERY high weight for user-selected elements to ensure dominance
            let elementWeight = max(1.5, element.culturalSignificance + 0.6)

            if let culturalPrompts = culturalPrompts[element.id] {
                let weightedPrompt = "(\(culturalPrompts.primaryPrompt):\(String(format: "%.1f", elementWeight)))"
                elementPrompts.append(weightedPrompt)

                // Only add one secondary prompt to avoid overwhelming
                if let firstSecondary = culturalPrompts.secondaryPrompts.first {
                    elementPrompts.append("(\(firstSecondary):1.2)")
                }
            } else {
                // Fallback for elements without cultural prompts
                let weightedPrompt = "(\(element.displayName.lowercased()):\(String(format: "%.1f", elementWeight)))"
                elementPrompts.append(weightedPrompt)
            }
        }

        // Add VERY strong emphasis on ONLY selected elements
        elementPrompts.append("(ONLY these specific elements:1.6)")
        elementPrompts.append("(no additional elements:1.5)")
        elementPrompts.append("(minimal other decoration:0.2)")
        elementPrompts.append("(exclude unspecified elements:1.4)")

        return elementPrompts.joined(separator: ", ")
    }

    internal func buildStylePrompts(_ genre: RakhiGenre, colorPalette: ColorPalette) async -> String {
        var stylePrompts: [String] = []

        // Genre-specific style prompts - reduced to avoid overwhelming user selections
        switch genre {
        case .traditional:
            stylePrompts.append("(traditional style:1.1)")
        case .spiritual:
            stylePrompts.append("(spiritual design:1.1)")
        case .elegant:
            stylePrompts.append("(elegant style:1.1)")
        case .modern:
            stylePrompts.append("(modern contemporary:1.2)")
            stylePrompts.append("(sleek design:1.1)")
        case .unknown:
            break
        }

        // Color palette prompts with specific color emphasis
        switch colorPalette {
        case .traditional:
            stylePrompts.append("(vibrant red and gold:1.4)")
            stylePrompts.append("(traditional saffron orange:1.3)")
            stylePrompts.append("(red orange yellow gold colors:1.2)")
        case .modern:
            stylePrompts.append("(blue indigo cyan colors:1.4)")
            stylePrompts.append("(contemporary blue palette:1.3)")
            stylePrompts.append("(modern sleek blue tones:1.2)")
            stylePrompts.append("(no red no orange no yellow:1.1)")
        case .vibrant:
            stylePrompts.append("(bright pink purple blue green:1.4)")
            stylePrompts.append("(vibrant festive colors:1.3)")
        case .pastel:
            stylePrompts.append("(soft light pink blue yellow:1.3)")
            stylePrompts.append("(pastel gentle tones:1.2)")
        case .earthy:
            stylePrompts.append("(brown tan beige natural:1.3)")
            stylePrompts.append("(earth tone colors:1.2)")
        case .metallic:
            stylePrompts.append("(metallic gold silver:1.4)")
            stylePrompts.append("(lustrous finish:1.2)")
        case .monochrome:
            stylePrompts.append("(single color design:1.3)")
            stylePrompts.append("(monochrome elegant:1.2)")
        }

        return stylePrompts.joined(separator: ", ")
    }

    internal func buildAgeAppropriatePrompts(_ ageGroup: AgeGroup) async -> String {
        switch ageGroup {
        case .young:
            return "(child-friendly design:1.2), (playful elements:1.1), (bright and cheerful:1.1)"
        case .adult:
            return "(mature sophisticated design:1.2), (balanced aesthetics:1.1)"
        case .elder:
            return "(respectful traditional design:1.3), (dignified appearance:1.2), (classic elements:1.1)"
        case .any:
            return "(universally appealing:1.1)"
        }
    }

    internal func buildPersonalizedPrompts(_ message: String?) async -> String {
        guard let message = message, !message.isEmpty else {
            return ""
        }

        // Analyze message sentiment and add appropriate visual prompts
        if message.lowercased().contains("love") {
            return ", (loving warmth:1.2), (heartfelt emotion:1.1)"
        } else if message.lowercased().contains("protection") {
            return ", (protective strength:1.2), (guardian blessing:1.1)"
        } else {
            return ", (personal touch:1.1)"
        }
    }

    internal func combinePromptComponents(
        cultural: String,
        elements: String,
        style: String,
        age: String,
        personalized: String
    ) -> String {
        var components: [String] = []

        if !cultural.isEmpty {
            components.append(cultural)
        }
        if !elements.isEmpty {
            components.append(elements)
        }
        if !style.isEmpty {
            components.append(style)
        }
        if !age.isEmpty {
            components.append(age)
        }
        if !personalized.isEmpty {
            components.append(personalized)
        }

        return components.joined(separator: ", ")
    }
}
