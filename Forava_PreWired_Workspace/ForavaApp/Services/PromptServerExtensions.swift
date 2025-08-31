import Foundation

// MARK: - Server Communication Extension
extension PromptMapper {
    func loadServerMappings() async {
        // In production, this would fetch updated mappings from the server
        guard let url = URL(string: "https://api.forava.ai/v1/prompt-mappings") else {
            print("Invalid server URL for prompt mappings")
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse,
                  200...299 ~= httpResponse.statusCode else {
                print("Failed to fetch server mappings: Invalid response")
                return
            }

            let serverMappings = try JSONDecoder().decode([String: [PromptToken]].self, from: data)

            // Merge server mappings with embedded ones (server takes priority)
            for (key, value) in serverMappings {
                promptMappings[key] = value
            }

            print("Successfully loaded \(serverMappings.count) prompt mappings from server")

        } catch {
            print("Failed to load server mappings: \(error.localizedDescription)")
        }
    }
}

// MARK: - Utility Methods Extension
extension PromptMapper {
    func getAllMappedElements() -> [String] {
        return Array(promptMappings.keys).sorted()
    }

    func getCulturalPrompts() -> [String: CulturalPromptSet] {
        return culturalPrompts
    }

    func getAvailableLoRAs() -> [String: LoRAModel] {
        return loraModels
    }

    func debugPromptGeneration(for designSpec: RakhiDesignSpec) async -> DebugPromptInfo {
        let cultural = await buildCulturalContext(designSpec)
        let elements = await buildElementPrompts(designSpec.elements)
        let style = await buildStylePrompts(designSpec.genre, colorPalette: designSpec.colorPalette)
        let age = await buildAgeAppropriatePrompts(designSpec.targetAgeGroup)
        let personalized = await buildPersonalizedPrompts(designSpec.personalMessage)
        let loras = await selectOptimalLoRAs(for: designSpec)

        return DebugPromptInfo(
            cultural: cultural,
            elements: elements,
            style: style,
            age: age,
            personalized: personalized,
            selectedLoRAs: loras,
            culturalWeight: calculateCulturalWeight(designSpec)
        )
    }
}
