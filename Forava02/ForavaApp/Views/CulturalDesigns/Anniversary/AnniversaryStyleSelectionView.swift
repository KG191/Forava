import SwiftUI
import Foundation

struct AnniversaryStyleSelectionView: View {
    @Binding var selectedTheme: AnniversaryTheme?
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
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(culturalColor.opacity(0.3), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 16)

                Spacer(minLength: 100)
            }
        }
        .background(Color(.systemGroupedBackground))
    }

    @ViewBuilder
    private func giftOptionsPreview(for theme: AnniversaryTheme) -> some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "gift.fill")
                    .foregroundStyle(theme.primaryColor)
                Text("Gift Options for \(theme.rawValue)")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                Spacer()
            }
            .padding(.horizontal, 20)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(Array(theme.giftOptions.enumerated()), id: \.offset) { index, option in
                    VStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(theme.primaryColor.opacity(0.1))
                            .frame(height: 60)
                            .overlay(
                                HStack {
                                    Image(systemName: giftOptionIcon(for: option))
                                        .font(.title2)
                                        .foregroundStyle(theme.primaryColor)

                                    Spacer()

                                    Text("\(index + 1)")
                                        .font(.caption.weight(.bold))
                                        .foregroundStyle(theme.primaryColor.opacity(0.7))
                                }
                                .padding(.horizontal, 12)
                            )

                        Text(option)
                            .font(.system(.caption, design: .rounded).weight(.medium))
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
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
        culturalColor: Color(hex: "#DC143C")
    )
}
