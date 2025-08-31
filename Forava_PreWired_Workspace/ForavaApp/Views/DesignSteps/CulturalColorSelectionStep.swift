import SwiftUI

// MARK: - Cultural Color Selection Step
struct CulturalColorSelectionStep: View {
    @Binding var designSpec: CulturalDesignSpec
    @ObservedObject private var contextManager = CulturalContextManager.shared
    @ObservedObject private var terminologyService = DynamicCulturalTerminologyService.shared

    private var availableColorPalettes: [CulturalColorPalette] {
        return getCulturalColorPalettes(for: designSpec.culturalContext)
    }

    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Text("Choose Color Palette")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.primary)

                Text("Select colors that reflect your cultural tradition")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            // Cultural Color Information
            if let currentOccasion = terminologyService.getCurrentOccasion() {
                culturalColorInfo(for: currentOccasion)
            }

            // Color Palettes
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                ForEach(availableColorPalettes, id: \.id) { palette in
                    CulturalColorPaletteCard(
                        palette: palette,
                        isSelected: designSpec.colorPalette.id == palette.id
                    ) {
                        selectColorPalette(palette)
                    }
                }
            }

            // Selected Palette Preview
            if !designSpec.colorPalette.id.isEmpty {
                selectedPalettePreview
            }
        }
    }

    private func culturalColorInfo(for occasion: CulturalOccasion) -> some View {
        VStack(spacing: 12) {
            HStack {
                Text(occasion.symbol)
                    .font(.title2)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Traditional \(occasion.displayName) Colors")
                        .font(.headline.weight(.medium))
                        .foregroundStyle(.primary)

                    Text("Colors that carry cultural significance")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }

            // Traditional colors for this culture
            HStack(spacing: 8) {
                ForEach(Array(occasion.colors.enumerated()), id: \.offset) { _, color in
                    Circle()
                        .fill(color)
                        .frame(width: 24, height: 24)
                        .overlay(
                            Circle()
                                .stroke(.white, lineWidth: 2)
                        )
                        .shadow(radius: 2)
                }

                Spacer()
            }
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }

    private var selectedPalettePreview: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Selected: \(designSpec.colorPalette.displayName)")
                .font(.headline.weight(.medium))
                .foregroundStyle(.primary)

            HStack(spacing: 8) {
                ForEach(designSpec.colorPalette.colors, id: \.id) { colorInfo in
                    VStack(spacing: 4) {
                        Circle()
                            .fill(colorInfo.color)
                            .frame(width: 32, height: 32)
                            .overlay(
                                Circle()
                                    .stroke(.white, lineWidth: 2)
                            )
                            .shadow(radius: 2)

                        Text(colorInfo.name)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }

                Spacer()
            }

            if let meaning = designSpec.colorPalette.culturalMeaning {
                Text(meaning)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .italic()
            }
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }

    private func selectColorPalette(_ palette: CulturalColorPalette) {
        withAnimation(.spring(response: 0.4)) {
            designSpec.colorPalette = palette
        }
    }

    private func getCulturalColorPalettes(for context: String) -> [CulturalColorPalette] {
        switch context {
        case "rakhi_indian":
            return [
                CulturalColorPalette(
                    id: "traditional_rakhi",
                    displayName: "Traditional Rakhi",
                    colors: [
                        CulturalColorInfo(id: "orange", name: "Sacred Orange", color: .orange, significance: 0.9),
                        CulturalColorInfo(id: "red", name: "Blessed Red", color: .red, significance: 0.95),
                        CulturalColorInfo(id: "gold", name: "Golden", color: .yellow, significance: 0.8)
                    ],
                    culturalContext: "rakhi_indian",
                    culturalMeaning: "Colors of protection, devotion, and prosperity"
                ),
                CulturalColorPalette(
                    id: "festive_rakhi",
                    displayName: "Festive Celebration",
                    colors: [
                        CulturalColorInfo(id: "magenta", name: "Festival Pink", color: Color(red: 1.0, green: 0.0, blue: 0.5), significance: 0.8),
                        CulturalColorInfo(id: "orange", name: "Joyful Orange", color: .orange, significance: 0.9),
                        CulturalColorInfo(id: "yellow", name: "Bright Yellow", color: .yellow, significance: 0.7)
                    ],
                    culturalContext: "rakhi_indian",
                    culturalMeaning: "Bright colors of celebration and joy"
                ),
                CulturalColorPalette(
                    id: "royal_rakhi",
                    displayName: "Royal Elegance",
                    colors: [
                        CulturalColorInfo(id: "purple", name: "Royal Purple", color: .purple, significance: 0.8),
                        CulturalColorInfo(id: "gold", name: "Royal Gold", color: Color(red: 1.0, green: 0.84, blue: 0.0), significance: 0.9),
                        CulturalColorInfo(id: "maroon", name: "Deep Maroon", color: Color(red: 0.5, green: 0.0, blue: 0.0), significance: 0.7)
                    ],
                    culturalContext: "rakhi_indian",
                    culturalMeaning: "Colors of nobility and grandeur"
                )
            ]

        case "chinese":
            return [
                CulturalColorPalette(
                    id: "traditional_chinese",
                    displayName: "Traditional Chinese",
                    colors: [
                        CulturalColorInfo(id: "red", name: "Lucky Red", color: .red, significance: 1.0),
                        CulturalColorInfo(id: "gold", name: "Prosperity Gold", color: Color(red: 1.0, green: 0.84, blue: 0.0), significance: 0.95),
                        CulturalColorInfo(id: "black", name: "Elegant Black", color: .black, significance: 0.7)
                    ],
                    culturalContext: "chinese",
                    culturalMeaning: "Colors of luck, prosperity, and elegance"
                ),
                CulturalColorPalette(
                    id: "spring_festival",
                    displayName: "Spring Festival",
                    colors: [
                        CulturalColorInfo(id: "crimson", name: "Crimson Red", color: Color(red: 0.86, green: 0.08, blue: 0.24), significance: 0.95),
                        CulturalColorInfo(id: "gold", name: "Festival Gold", color: .yellow, significance: 0.9),
                        CulturalColorInfo(id: "orange", name: "Mandarin Orange", color: .orange, significance: 0.8)
                    ],
                    culturalContext: "chinese",
                    culturalMeaning: "Vibrant colors of new beginnings"
                )
            ]

        case "christmas_christian":
            return [
                CulturalColorPalette(
                    id: "traditional_christmas",
                    displayName: "Traditional Christmas",
                    colors: [
                        CulturalColorInfo(id: "christmas_red", name: "Christmas Red", color: Color(red: 0.77, green: 0.12, blue: 0.23), significance: 0.9),
                        CulturalColorInfo(id: "forest_green", name: "Forest Green", color: Color(red: 0.13, green: 0.55, blue: 0.13), significance: 0.9),
                        CulturalColorInfo(id: "gold", name: "Heavenly Gold", color: .yellow, significance: 0.8)
                    ],
                    culturalContext: "christmas_christian",
                    culturalMeaning: "Colors of love, life, and divine light"
                )
            ]

        default:
            return [
                CulturalColorPalette(
                    id: "warm_celebration",
                    displayName: "Warm Celebration",
                    colors: [
                        CulturalColorInfo(id: "orange", name: "Warm Orange", color: .orange, significance: 0.7),
                        CulturalColorInfo(id: "yellow", name: "Joyful Yellow", color: .yellow, significance: 0.6),
                        CulturalColorInfo(id: "red", name: "Vibrant Red", color: .red, significance: 0.8)
                    ],
                    culturalContext: context,
                    culturalMeaning: "Warm colors of celebration"
                ),
                CulturalColorPalette(
                    id: "elegant_modern",
                    displayName: "Elegant Modern",
                    colors: [
                        CulturalColorInfo(id: "blue", name: "Deep Blue", color: .blue, significance: 0.6),
                        CulturalColorInfo(id: "purple", name: "Royal Purple", color: .purple, significance: 0.7),
                        CulturalColorInfo(id: "silver", name: "Silver", color: .gray, significance: 0.5)
                    ],
                    culturalContext: context,
                    culturalMeaning: "Modern elegant colors"
                )
            ]
        }
    }
}

struct CulturalColorPaletteCard: View {
    let palette: CulturalColorPalette
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                // Color circles
                HStack(spacing: 6) {
                    ForEach(palette.colors.prefix(3), id: \.id) { colorInfo in
                        Circle()
                            .fill(colorInfo.color)
                            .frame(width: 28, height: 28)
                            .overlay(
                                Circle()
                                    .stroke(isSelected ? .white : .clear, lineWidth: 2)
                            )
                            .shadow(radius: 2)
                    }
                }

                // Palette name
                Text(palette.displayName)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(isSelected ? .white : .primary)
                    .multilineTextAlignment(.center)

                // Cultural significance
                if !palette.colors.isEmpty {
                    let avgSignificance = palette.colors.map { $0.significance }.reduce(0, +) / Double(palette.colors.count)
                    HStack(spacing: 2) {
                        ForEach(0..<5) { index in
                            Circle()
                                .fill(isSelected ? .white.opacity(0.7) : .yellow)
                                .frame(width: 3, height: 3)
                                .opacity(Double(index) < avgSignificance * 5 ? 1.0 : 0.3)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? .orange : Color(.systemGray6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? .clear : .secondary.opacity(0.3), lineWidth: 1)
            )
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

// MARK: - Supporting Types

struct CulturalColorInfo: Identifiable, Codable {
    let id: String
    let name: String
    let color: Color
    let significance: Double // 0.0 to 1.0, how culturally significant this color is

    enum CodingKeys: String, CodingKey {
        case id, name, significance
        case colorComponents = "color"
    }

    init(id: String, name: String, color: Color, significance: Double) {
        self.id = id
        self.name = name
        self.color = color
        self.significance = significance
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        significance = try container.decode(Double.self, forKey: .significance)

        // For now, default to orange for decoded colors
        color = .orange
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(significance, forKey: .significance)
    }
}

struct CulturalColorPalette: Identifiable, Codable {
    let id: String
    let displayName: String
    let colors: [CulturalColorInfo]
    let culturalContext: String
    let culturalMeaning: String?

    init(id: String, displayName: String, colors: [CulturalColorInfo], culturalContext: String, culturalMeaning: String? = nil) {
        self.id = id
        self.displayName = displayName
        self.colors = colors
        self.culturalContext = culturalContext
        self.culturalMeaning = culturalMeaning
    }
}

#Preview {
    CulturalColorSelectionStep(
        designSpec: .constant(CulturalDesignSpec(
            culturalContext: "rakhi_indian",
            genre: CulturalGenre(id: "traditional", displayName: "Traditional", icon: "star", basePrompt: "traditional", culturalContext: "rakhi_indian"),
            colorPalette: CulturalColorPalette(id: "", displayName: "", colors: [], culturalContext: "rakhi_indian"),
            targetAgeGroup: CulturalAgeGroup(id: "any", displayName: "Any", ageRange: "All", culturalContext: "rakhi_indian")
        ))
    )
}
