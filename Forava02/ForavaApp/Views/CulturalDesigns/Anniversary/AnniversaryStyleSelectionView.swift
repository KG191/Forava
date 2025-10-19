import SwiftUI
import Foundation

struct AnniversaryStyleSelectionView: View {
    @Binding var selectedTheme: AnniversaryTheme?
    @Binding var selectedGiftOption: String?
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
                    Text("Choose Your Anniversary Style")
                        .font(.system(.title2, design: .rounded).weight(.bold))
                        .foregroundStyle(.primary)

                    Text("Select a style that reflects the nature of your anniversary celebration")
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)

                // Glass Morphism Content Container
                VStack(spacing: 20) {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(AnniversaryTheme.allCases, id: \.self) { theme in
                            StyleCard(
                                theme: theme,
                                description: theme.description,
                                primaryColor: theme.primaryColor,
                                isSelected: selectedTheme == theme
                            ) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedTheme = theme
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)

                    // Gift Options Preview for Selected Theme
                    if let selectedTheme = selectedTheme {
                        giftOptionsPreview(for: selectedTheme)
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
    private func giftOptionsPreview(for theme: AnniversaryTheme) -> some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "sparkles")
                        .foregroundStyle(theme.primaryColor.opacity(0.6))
                    Text("Example Designs for \(theme.rawValue)")
                        .font(.system(.subheadline, design: .rounded).weight(.semibold))
                    Spacer()
                }

                Text("Preview of AI-generated design options")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 20)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(Array(theme.giftOptions.enumerated()), id: \.offset) { index, option in
                    let isSelected = selectedGiftOption == option

                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedGiftOption = option
                        }
                        #if os(iOS)
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred()
                        #endif
                    } label: {
                        VStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(isSelected ? theme.primaryColor.opacity(0.75) : theme.primaryColor.opacity(0.05))  // Stronger background for visibility
                                .frame(height: 60)
                                .overlay(
                                    HStack {
                                        Image(systemName: giftOptionIcon(for: option))
                                            .font(.title3)
                                            .foregroundStyle(isSelected ? .white : theme.primaryColor.opacity(0.7))  // WCAG 3:1 contrast - Apple HIG compliant
                                            .shadow(color: .black.opacity(isSelected ? 0.3 : 0), radius: 1, x: 0, y: 1)

                                        Spacer()

                                        if isSelected {
                                            Image(systemName: "checkmark.circle.fill")
                                                .font(.title3)
                                                .foregroundStyle(.white)  // White checkmark when selected
                                                .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
                                        }
                                        // Removed index numbers as user found them confusing
                                    }
                                    .padding(.horizontal, 12)
                                )
                                .overlay(
                                    VStack {
                                        HStack {
                                            Spacer()
                                            Text("Preview")
                                                .font(.system(.caption2, design: .rounded).weight(.medium))
                                                .foregroundStyle(isSelected ? .white : theme.primaryColor.opacity(0.6))
                                                .padding(.horizontal, 6)
                                                .padding(.vertical, 2)
                                                .background(isSelected ? .white.opacity(0.2) : theme.primaryColor.opacity(0.1))
                                                .cornerRadius(4)
                                        }
                                        Spacer()
                                    }
                                    .padding(6)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(isSelected ? .white.opacity(0.5) : Color.clear, lineWidth: 2)  // White border when selected
                                )

                            Text(option)
                                .font(.system(.caption, design: .rounded))
                                .foregroundStyle(isSelected ? .primary : .secondary)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(theme.primaryColor.opacity(0.05))
        )
        .padding(.horizontal, 20)
    }

    private func giftOptionIcon(for option: String) -> String {
        let iconMappings: [(keywords: [String], icon: String)] = [
            (["love", "heart"], "heart.fill"),
            (["card"], "doc.text.fill"),
            (["scene", "garden"], "leaf.fill"),
            (["couple", "silhouette"], "person.2.fill"),
            (["constellation", "star"], "star.fill"),
            (["vintage", "classic"], "calendar"),
            (["modern", "typography"], "textformat"),
            (["sunset", "together"], "sun.max.fill"),
            (["timeline", "story"], "timeline.selection"),
            (["golden", "years"], "crown.fill"),
            (["milestone", "number"], "number.circle.fill"),
            (["achievement", "trophy"], "trophy.fill"),
            (["memory", "collage"], "photo.stack.fill"),
            (["journey", "progress"], "map.fill"),
            (["celebration", "fireworks"], "sparkles"),
            (["family", "tree"], "tree.fill"),
            (["legacy", "generational"], "person.3.fill"),
            (["home", "hearts"], "house.fill"),
            (["heritage", "crest"], "shield.fill"),
            (["unity", "circle"], "circle.hexagongrid.fill"),
            (["career", "professional"], "briefcase.fill"),
            (["educational"], "graduationcap.fill"),
            (["growth", "personal"], "chart.line.uptrend.xyaxis"),
            (["success"], "checkmark.seal.fill"),
            (["recognition"], "medal.fill"),
            (["goal"], "target"),
            (["excellence"], "rosette")
        ]

        let lowercased = option.lowercased()
        for mapping in iconMappings where mapping.keywords.contains(where: { lowercased.contains($0) }) {
            return mapping.icon
        }
        return "gift.fill"
    }
}

#Preview {
    AnniversaryStyleSelectionView(
        selectedTheme: .constant(.romantic),
        selectedGiftOption: .constant("Classic Love Letter Card"),
        culturalColor: Color(hex: "#DC143C")
    )
}
