import SwiftUI
import Foundation

struct HanukkahElementsSelectionView: View {
    @Binding var selectedElements: [HanukkahElement]
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

                    Text("Select one central element that will be the visual focus of your design")
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
                            ForEach(HanukkahElement.allElements) { element in
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
        element: HanukkahElement,
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
    private func toggleElementSelection(_ element: HanukkahElement) {
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
        case "menorah":
            return "flame.fill"
        case "dreidel":
            return "cube.fill"
        case "star of david":
            return "star.fill"
        case "hanukkah candles":
            return "candybarphone"
        case "oil jug":
            return "light.beacon.max.fill"
        case "gelt coins":
            return "dollarsign.circle.fill"
        case "hebrew letters":
            return "character.textbox"
        case "blue & white ribbons":
            return "ribbonlocation.fill"
        default:
            return "star.fill"
        }
    }
}

#Preview {
    HanukkahElementsSelectionView(
        selectedElements: .constant([HanukkahElement.allElements[0]]),
        culturalColor: Color(hex: "#0047AB")
    )
}
