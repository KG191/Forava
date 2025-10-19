import SwiftUI
import Foundation

struct AnniversaryElementsSelectionView: View {
    @Binding var selectedElements: [AnniversaryElement]
    let culturalColor: Color

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header Section
                VStack(spacing: 12) {
                    Text("Choose Design Elements")
                        .font(.system(.title2, design: .rounded).weight(.bold))
                        .foregroundStyle(.primary)

                    Text("Select elements that will make your anniversary gift unique and personal")
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)

                // Glass Morphism Content Container
                VStack(spacing: 24) {
                    // Centre Pieces Section
                    elementCategorySection(
                        title: "Centre Pieces",
                        subtitle: "Choose your main focal element",
                        elements: AnniversaryElement.centrePieces,
                        categoryColor: culturalColor,
                        allowMultiple: false
                    )

                    Divider()
                        .padding(.horizontal, 20)

                    // Supporting Elements Section
                    elementCategorySection(
                        title: "Supporting Elements",
                        subtitle: "Add complementary decorative elements",
                        elements: AnniversaryElement.supportingElements,
                        categoryColor: culturalColor.opacity(0.7),
                        allowMultiple: true
                    )

                    // Selection Summary
                    if !selectedElements.isEmpty {
                        selectionSummary()
                    }
                }
                .padding(.vertical, 24)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.thinMaterial)
                        .background(RoundedRectangle(cornerRadius: 20).fill(culturalColor.opacity(0.03)))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(culturalColor.opacity(0.3), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 16)

                Spacer(minLength: 100)
            }
        }
        .background(
            LinearGradient(
                colors: [culturalColor.opacity(0.08), .white],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }

    @ViewBuilder
    private func elementCategorySection(
        title: String,
        subtitle: String,
        elements: [AnniversaryElement],
        categoryColor: Color,
        allowMultiple: Bool
    ) -> some View {
        VStack(spacing: 16) {
            // Category Header
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: categoryIcon(for: title))
                        .foregroundStyle(categoryColor)
                        .font(.title2)

                    Text(title)
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)

                    Spacer()

                    if !allowMultiple {
                        Text("Choose 1")
                            .font(.system(.caption, design: .rounded).weight(.medium))
                            .foregroundStyle(categoryColor)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(categoryColor.opacity(0.1))
                            .cornerRadius(8)
                    } else {
                        Text("Choose Multiple")
                            .font(.system(.caption, design: .rounded).weight(.medium))
                            .foregroundStyle(categoryColor)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(categoryColor.opacity(0.1))
                            .cornerRadius(8)
                    }
                }

                HStack {
                    Text(subtitle)
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(.secondary)
                    Spacer()
                }
            }
            .padding(.horizontal, 20)

            // Elements Grid
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(elements) { element in
                    elementCard(
                        element: element,
                        isSelected: selectedElements.contains { $0.id == element.id },
                        categoryColor: categoryColor,
                        allowMultiple: allowMultiple
                    )
                }
            }
            .padding(.horizontal, 20)
        }
    }

    @ViewBuilder
    private func elementCard(
        element: AnniversaryElement,
        isSelected: Bool,
        categoryColor: Color,
        allowMultiple: Bool
    ) -> some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                toggleElementSelection(element, allowMultiple: allowMultiple)
            }
        } label: {
            VStack(spacing: 12) {
                // Element Icon and Priority
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? categoryColor.gradient : culturalColor.opacity(0.10).gradient)
                        .frame(height: 80)

                    VStack(spacing: 8) {
                        Image(systemName: elementIcon(for: element.name))
                            .font(.system(.title, design: .rounded))
                            .foregroundStyle(isSelected ? .white : .primary)

                        // Priority Badge
                        HStack(spacing: 4) {
                            ForEach(0..<priorityStars(element.priority), id: \.self) { _ in
                                Image(systemName: "star.fill")
                                    .font(.caption2)
                                    .foregroundStyle(isSelected ? .white.opacity(0.8) : categoryColor)
                            }
                        }
                    }
                }

                // Element Name
                Text(element.name)
                    .font(.system(.caption, design: .rounded).weight(.semibold))
                    .foregroundStyle(isSelected ? categoryColor : .primary)
                    .multilineTextAlignment(.center)

                // Selection Indicator
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundStyle(categoryColor)
                }
            }
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func selectionSummary() -> some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(culturalColor)
                Text("Selected Elements")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                Spacer()
            }

            VStack(spacing: 8) {
                ForEach(selectedElements) { element in
                    HStack {
                        Image(systemName: elementIcon(for: element.name))
                            .foregroundStyle(culturalColor)
                            .font(.subheadline)

                        Text(element.name)
                            .font(.system(.subheadline, design: .rounded))

                        Spacer()

                        Text(element.category.rawValue)
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(.secondary)

                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedElements.removeAll { $0.id == element.id }
                            }
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.secondary)
                                .font(.caption)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(culturalColor.opacity(0.1))
                    .cornerRadius(8)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(culturalColor.opacity(0.05))
        )
        .padding(.horizontal, 20)
    }

    // MARK: - Helper Functions
    private func toggleElementSelection(_ element: AnniversaryElement, allowMultiple: Bool) {
        if let index = selectedElements.firstIndex(where: { $0.id == element.id }) {
            selectedElements.remove(at: index)
        } else {
            if !allowMultiple && element.category == .centrePiece {
                // Remove any existing centre piece
                selectedElements.removeAll { $0.category == .centrePiece }
            }
            selectedElements.append(element)
        }
    }

    private func categoryIcon(for category: String) -> String {
        switch category.lowercased() {
        case "centre pieces":
            return "star.circle.fill"
        case "supporting elements":
            return "sparkles"
        default:
            return "square.stack.3d.up.fill"
        }
    }

    private func elementIcon(for elementName: String) -> String {
        switch elementName.lowercased() {
        case "hearts":
            return "heart.fill"
        case "rings":
            return "circle.circle.fill"
        case "calendar":
            return "calendar"
        case "trophy":
            return "trophy.fill"
        case "flowers":
            return "leaf.fill"
        case "champagne":
            return "wineglass.fill"
        case "confetti":
            return "sparkles"
        case "ribbon":
            return "gift.fill"
        default:
            return "star.fill"
        }
    }

    private func priorityStars(_ priority: Int) -> Int {
        switch priority {
        case 90...100:
            return 3
        case 70...89:
            return 2
        default:
            return 1
        }
    }
}

#Preview {
    AnniversaryElementsSelectionView(
        selectedElements: .constant([AnniversaryElement.allElements[0]]),
        culturalColor: Color(hex: "#DC143C")
    )
}
