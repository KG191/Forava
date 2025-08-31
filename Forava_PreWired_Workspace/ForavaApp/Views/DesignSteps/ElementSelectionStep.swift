import SwiftUI

struct ElementSelectionStep: View {
    @Binding var designSpec: RakhiDesignSpec
    @State private var selectedCategory: ElementCategory = .thread

    private var filteredElements: [DesignElement] {
        // Mock implementation - return empty array for now
        return []
    }

    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Text("Design Elements")
                    .font(.system(.title3, design: .rounded).weight(.bold))
                    .foregroundStyle(.primary)

                Text("Choose elements that reflect your relationship")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            // Category Selector
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(ElementCategory.allCases, id: \.self) { category in
                        ElementCategoryPill(
                            category: category,
                            isSelected: selectedCategory == category
                        ) {
                            withAnimation(.spring(response: 0.3)) {
                                selectedCategory = category
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
            }
            .padding(.horizontal, -24)

            // Elements Grid
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                    ForEach(filteredElements, id: \.id) { element in
                        ElementCard(
                            element: element,
                            isSelected: designSpec.elements.contains { $0.id == element.id }
                        ) {
                            toggleElement(element)
                        }
                    }
                }
            }
            .frame(maxHeight: 400)

            // Selected Elements Summary
            if !designSpec.elements.isEmpty {
                SelectedElementsSummary(elements: designSpec.elements)
            }
        }
    }

    private func toggleElement(_ element: DesignElement) {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            if let index = designSpec.elements.firstIndex(where: { $0.id == element.id }) {
                designSpec.elements.remove(at: index)
            } else {
                // Limit to 6 elements maximum
                if designSpec.elements.count < 6 {
                    designSpec.elements.append(element)
                }
            }
        }
    }
}

struct ElementCategoryPill: View {
    let category: ElementCategory
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.system(.footnote, weight: .medium))

                Text(category.rawValue)
                    .font(.system(.footnote, design: .rounded).weight(.medium))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? .orange : Color(.systemGray5))
            )
            .foregroundStyle(isSelected ? .white : .primary)
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? .clear : .orange.opacity(0.3), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }
}

struct ElementCard: View {
    let element: DesignElement
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                // Element Icon/Image
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? Color.orange.opacity(0.1) : Color(.systemGray5))
                        .frame(height: 80)

                    VStack(spacing: 4) {
                        Image(systemName: getElementIcon())
                            .font(.system(size: 24))
                            .foregroundStyle(isSelected ? .orange : .primary)

                        Text(element.category.rawValue)
                            .font(.system(.caption2, design: .rounded).weight(.medium))
                            .foregroundStyle(.secondary)
                    }
                }

                // Element Details
                VStack(alignment: .leading, spacing: 6) {
                    Text(element.displayName)
                        .font(.system(.subheadline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    // Cultural Significance Indicator
                    HStack(spacing: 4) {
                        ForEach(0..<5) { index in
                            Circle()
                                .fill(index < Int(element.culturalSignificance * 5) ? .orange : .gray.opacity(0.3))
                                .frame(width: 6, height: 6)
                        }

                        Spacer()

                        if isSelected {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(.caption))
                                .foregroundStyle(.orange)
                        }
                    }
                }
            }
            .padding(12)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? .orange : .clear, lineWidth: 2)
            }
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .shadow(
                color: isSelected ? .orange.opacity(0.3) : .black.opacity(0.05),
                radius: isSelected ? 8 : 4,
                y: isSelected ? 4 : 2
            )
        }
        .buttonStyle(.plain)
    }

    private func getElementIcon() -> String {
        switch element.id {
        case "red_thread", "silk_thread":
            return "line.3.horizontal"
        case "gold_beads", "pearl_beads", "rudraksha_beads":
            return "circle.grid.2x2.fill"
        case "om_symbol":
            return "character.magnify"
        case "lotus_motif":
            return "leaf.circle.fill"
        case "geometric_center":
            return "square.grid.3x3.fill"
        case "tassels":
            return "line.3.horizontal.decrease"
        case "mirrors":
            return "diamond.fill"
        case "peacock_motif":
            return "bird.fill"
        default:
            return element.category.icon
        }
    }
}

struct SelectedElementsSummary: View {
    let elements: [DesignElement]

    var culturalScore: Double {
        let total = elements.map { $0.culturalSignificance }.reduce(0, +)
        return elements.isEmpty ? 0 : total / Double(elements.count)
    }

    var body: some View {
        VStack(spacing: 16) {
            Rectangle()
                .fill(.orange.opacity(0.3))
                .frame(height: 1)

            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundStyle(.orange)

                    Text("Selected Elements (\(elements.count))")
                        .font(.system(.subheadline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)

                    Spacer()

                    // Cultural Score
                    HStack(spacing: 4) {
                        Text("Cultural:")
                            .font(.system(.caption, design: .rounded).weight(.medium))
                            .foregroundStyle(.secondary)

                        ForEach(0..<5) { index in
                            Circle()
                                .fill(index < Int(culturalScore * 5) ? .orange : .gray.opacity(0.3))
                                .frame(width: 8, height: 8)
                        }
                    }
                }

                // Element chips
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                    ForEach(elements, id: \.id) { element in
                        HStack(spacing: 6) {
                            Text(element.displayName)
                                .font(.system(.caption, design: .rounded).weight(.medium))

                            Image(systemName: "xmark.circle.fill")
                                .font(.system(.caption2))
                                .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(.orange.opacity(0.1))
                        )
                        .overlay {
                            Capsule()
                                .stroke(.orange.opacity(0.3), lineWidth: 1)
                        }
                        .foregroundStyle(.orange)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(.orange.opacity(0.05), in: RoundedRectangle(cornerRadius: 12))
        }
    }
}

#Preview {
    ElementSelectionStep(designSpec: .constant(RakhiDesignSpec(genre: .traditional)))
        .padding()
        .background(Color(.systemGroupedBackground))
}
