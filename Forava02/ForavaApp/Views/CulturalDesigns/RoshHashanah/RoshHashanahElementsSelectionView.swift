import SwiftUI
import Foundation

struct RoshHashanahElementsSelectionView: View {
    @Binding var selectedElements: [RoshHashanahElement]
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
                    Text("Choose Your Centerpiece Element")
                        .font(.system(.title2, design: .rounded).weight(.bold))
                        .foregroundStyle(.primary)

                    Text("Select one central Jewish symbol that will be the visual focus of your design")
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)

                // Glass Morphism Content Container
                VStack(spacing: 24) {
                    // All Elements (Single Selection)
                    VStack(spacing: 16) {
                        // Elements Grid
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(RoshHashanahElement.allElements) { element in
                                elementCard(
                                    element: element,
                                    isSelected: selectedElements.contains { $0.id == element.id }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 8)
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
    private func elementCard(
        element: RoshHashanahElement,
        isSelected: Bool
    ) -> some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                toggleElementSelection(element)
            }
        } label: {
            VStack(spacing: 12) {
                // Element Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? culturalColor.gradient : culturalColor.opacity(0.10).gradient)
                        .frame(height: 80)

                    Image(systemName: elementIcon(for: element.name))
                        .font(.system(.largeTitle, design: .rounded))
                        .foregroundStyle(isSelected ? .white : .primary)
                }

                // Element Name
                VStack(spacing: 4) {
                    Text(element.name)
                        .font(.system(.subheadline, design: .rounded).weight(.semibold))
                        .foregroundStyle(isSelected ? culturalColor : .primary)
                        .multilineTextAlignment(.center)

                    // Category badge
                    Text(element.category.rawValue)
                        .font(.system(.caption2, design: .rounded))
                        .foregroundStyle(.secondary)
                }

                // Selection Indicator
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundStyle(culturalColor)
                }
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: - Helper Functions
    private func toggleElementSelection(_ element: RoshHashanahElement) {
        if let index = selectedElements.firstIndex(where: { $0.id == element.id }) {
            // Deselect if clicking the same element
            selectedElements.remove(at: index)
        } else {
            // Single selection only - clear all and select this one
            selectedElements.removeAll()
            selectedElements.append(element)
        }
    }

    private func elementIcon(for elementName: String) -> String {
        switch elementName.lowercased() {
        case "shofar":
            return "speaker.wave.3.fill"
        case "apples & honey":
            return "leaf.fill"
        case "star of david":
            return "star.fill"
        case "torah scroll":
            return "text.book.closed.fill"
        case "pomegranates":
            return "circle.hexagongrid.fill"
        case "challah bread":
            return "basket.fill"
        case "hebrew calligraphy":
            return "character.textbox"
        case "new year symbols":
            return "sparkles"
        default:
            return "star.fill"
        }
    }
}

#Preview {
    RoshHashanahElementsSelectionView(
        selectedElements: .constant([RoshHashanahElement.allElements[0]]),
        culturalColor: Color(hex: "#4169E1")
    )
}
