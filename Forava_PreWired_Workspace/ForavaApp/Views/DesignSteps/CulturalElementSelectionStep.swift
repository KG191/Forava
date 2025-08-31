import SwiftUI

// MARK: - Cultural Element Selection Step
struct CulturalElementSelectionStep: View {
    @Binding var designSpec: CulturalDesignSpec
    @ObservedObject private var contextManager = CulturalContextManager.shared

    @State private var selectedCategory: CulturalElementCategory = .decorative

    private var availableElements: [CulturalDesignElement] {
        guard let context = contextManager.currentContext else { return [] }
        return context.designElements.filter { element in
            element.category == selectedCategory &&
            element.culturalContext == designSpec.culturalContext
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Text("Choose Design Elements")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.primary)

                Text("Select elements that represent your cultural tradition")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            // Category Selector
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(CulturalElementCategory.allCases, id: \.self) { category in
                        CategoryPill(
                            category: category,
                            isSelected: selectedCategory == category
                        ) {
                            withAnimation(.spring(response: 0.3)) {
                                selectedCategory = category
                            }
                        }
                    }
                }
                .padding(.horizontal, 4)
            }

            // Elements Grid
            if availableElements.isEmpty {
                // Fallback content when cultural elements aren't loaded
                VStack(spacing: 16) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 40))
                        .foregroundStyle(.secondary)

                    Text("Cultural elements loading...")
                        .font(.body)
                        .foregroundStyle(.secondary)

                    // Mock elements for immediate functionality
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                        ForEach(getMockElements(), id: \.id) { element in
                            CulturalElementCard(
                                element: element,
                                isSelected: designSpec.elements.contains { $0.id == element.id }
                            ) {
                                toggleElement(element)
                            }
                        }
                    }
                }
            } else {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                    ForEach(availableElements, id: \.id) { element in
                        CulturalElementCard(
                            element: element,
                            isSelected: designSpec.elements.contains { $0.id == element.id }
                        ) {
                            toggleElement(element)
                        }
                    }
                }
            }

            // Selected Elements Summary
            if !designSpec.elements.isEmpty {
                selectedElementsSummary
            }
        }
    }

    private var selectedElementsSummary: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Selected Elements (\(designSpec.elements.count))")
                .font(.headline.weight(.medium))
                .foregroundStyle(.primary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(designSpec.elements, id: \.id) { element in
                        Text(element.displayName)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.orange.opacity(0.2), in: Capsule())
                            .foregroundStyle(.orange)
                    }
                }
                .padding(.horizontal, 1)
            }
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }

    private func toggleElement(_ element: CulturalDesignElement) {
        withAnimation(.spring(response: 0.3)) {
            if let index = designSpec.elements.firstIndex(where: { $0.id == element.id }) {
                designSpec.elements.remove(at: index)
            } else {
                // Limit to 5 elements
                if designSpec.elements.count < 5 {
                    designSpec.elements.append(element)
                }
            }
        }
    }

    private func getMockElements() -> [CulturalDesignElement] {
        // Provide immediate mock elements based on cultural context
        switch designSpec.culturalContext {
        case "rakhi_indian":
            return [
                CulturalDesignElement(id: "lotus", displayName: "Lotus Flower", category: .decorative, weight: 0.8, culturalSignificance: 0.9, ageAppropriate: [], compatibleGenreIds: [], promptTokens: ["lotus", "sacred flower"], culturalContext: "rakhi_indian", description: "Sacred lotus symbolizing purity"),
                CulturalDesignElement(id: "om", displayName: "Om Symbol", category: .sacred, weight: 0.9, culturalSignificance: 1.0, ageAppropriate: [], compatibleGenreIds: [], promptTokens: ["om", "sacred symbol"], culturalContext: "rakhi_indian", description: "Sacred Hindu symbol"),
                CulturalDesignElement(id: "peacock", displayName: "Peacock Feathers", category: .decorative, weight: 0.7, culturalSignificance: 0.8, ageAppropriate: [], compatibleGenreIds: [], promptTokens: ["peacock", "feathers"], culturalContext: "rakhi_indian", description: "Beautiful peacock feathers"),
                CulturalDesignElement(id: "rangoli", displayName: "Rangoli Pattern", category: .pattern, weight: 0.6, culturalSignificance: 0.8, ageAppropriate: [], compatibleGenreIds: [], promptTokens: ["rangoli", "pattern"], culturalContext: "rakhi_indian", description: "Traditional floor art patterns")
            ]
        case "chinese":
            return [
                CulturalDesignElement(id: "dragon", displayName: "Dragon", category: .decorative, weight: 0.9, culturalSignificance: 0.95, ageAppropriate: [], compatibleGenreIds: [], promptTokens: ["dragon", "chinese dragon"], culturalContext: "chinese", description: "Powerful Chinese dragon symbol"),
                CulturalDesignElement(id: "bamboo", displayName: "Bamboo", category: .natural, weight: 0.7, culturalSignificance: 0.8, ageAppropriate: [], compatibleGenreIds: [], promptTokens: ["bamboo"], culturalContext: "chinese", description: "Symbol of resilience and growth"),
                CulturalDesignElement(id: "peony", displayName: "Peony Flowers", category: .decorative, weight: 0.6, culturalSignificance: 0.7, ageAppropriate: [], compatibleGenreIds: [], promptTokens: ["peony", "flowers"], culturalContext: "chinese", description: "Symbol of honor and wealth"),
                CulturalDesignElement(id: "lantern", displayName: "Red Lanterns", category: .decorative, weight: 0.8, culturalSignificance: 0.9, ageAppropriate: [], compatibleGenreIds: [], promptTokens: ["lantern", "red lantern"], culturalContext: "chinese", description: "Traditional Chinese lanterns")
            ]
        default:
            return [
                CulturalDesignElement(id: "star", displayName: "Stars", category: .decorative, weight: 0.5, culturalSignificance: 0.6, ageAppropriate: [], compatibleGenreIds: [], promptTokens: ["star", "stars"], culturalContext: designSpec.culturalContext, description: "Celestial stars"),
                CulturalDesignElement(id: "heart", displayName: "Hearts", category: .decorative, weight: 0.7, culturalSignificance: 0.7, ageAppropriate: [], compatibleGenreIds: [], promptTokens: ["heart", "love"], culturalContext: designSpec.culturalContext, description: "Symbol of love and care"),
                CulturalDesignElement(id: "flower", displayName: "Flowers", category: .natural, weight: 0.6, culturalSignificance: 0.6, ageAppropriate: [], compatibleGenreIds: [], promptTokens: ["flower", "floral"], culturalContext: designSpec.culturalContext, description: "Beautiful flowers"),
                CulturalDesignElement(id: "geometric", displayName: "Geometric Patterns", category: .pattern, weight: 0.5, culturalSignificance: 0.5, ageAppropriate: [], compatibleGenreIds: [], promptTokens: ["geometric", "pattern"], culturalContext: designSpec.culturalContext, description: "Modern geometric designs")
            ]
        }
    }
}

struct CategoryPill: View {
    let category: CulturalElementCategory
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(category.displayName)
                .font(.caption.weight(.medium))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(isSelected ? .orange : Color(.systemGray6))
                )
                .foregroundStyle(isSelected ? .white : .primary)
        }
    }
}

struct CulturalElementCard: View {
    let element: CulturalDesignElement
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                // Element icon/preview
                Image(systemName: getElementIcon())
                    .font(.title2)
                    .foregroundStyle(isSelected ? .white : .orange)

                // Element name
                Text(element.displayName)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(isSelected ? .white : .primary)
                    .multilineTextAlignment(.center)

                // Cultural significance indicator
                HStack(spacing: 2) {
                    ForEach(0..<5) { index in
                        Circle()
                            .fill(isSelected ? .white.opacity(0.7) : .yellow)
                            .frame(width: 3, height: 3)
                            .opacity(Double(index) < element.culturalSignificance * 5 ? 1.0 : 0.3)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? .orange : Color(.systemGray6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? .clear : .secondary.opacity(0.3), lineWidth: 1)
            )
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }

    private func getElementIcon() -> String {
        switch element.id {
        case "lotus": return "leaf.fill"
        case "om": return "om"
        case "peacock": return "bird.fill"
        case "rangoli": return "grid.circle.fill"
        case "dragon": return "dragon.fill"
        case "bamboo": return "tree.fill"
        case "peony": return "flower.fill"
        case "lantern": return "lamp.ceiling.fill"
        case "star": return "star.fill"
        case "heart": return "heart.fill"
        case "flower": return "flower"
        case "geometric": return "square.grid.3x3"
        default: return "sparkles"
        }
    }
}

// MARK: - Supporting Enums
// Note: CulturalElementCategory is now defined in CulturalFramework.swift

#Preview {
    CulturalElementSelectionStep(
        designSpec: .constant(CulturalDesignSpec(
            culturalContext: "rakhi_indian",
            genre: CulturalGenre(id: "traditional", displayName: "Traditional", icon: "star", basePrompt: "traditional", culturalContext: "rakhi_indian"),
            colorPalette: CulturalColorPalette(id: "traditional", displayName: "Traditional", colors: [], culturalContext: "rakhi_indian"),
            targetAgeGroup: CulturalAgeGroup(id: "any", displayName: "Any", ageRange: "All", culturalContext: "rakhi_indian")
        ))
    )
}
