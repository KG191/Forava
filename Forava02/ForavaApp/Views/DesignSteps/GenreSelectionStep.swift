import SwiftUI

struct GenreSelectionStep: View {
    @Binding var designSpec: RakhiDesignSpec

    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Text("Choose Your Style")
                    .font(.system(.title3, design: .rounded).weight(.bold))
                    .foregroundStyle(.primary)

                Text("What feeling would you like to convey?")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            // Genre Options
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                ForEach(RakhiGenre.allCases.filter { $0 != .unknown }, id: \.self) { genre in
                    GenreCard(
                        genre: genre,
                        isSelected: designSpec.genre == genre
                    ) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            designSpec.genre = genre
                            // Auto-select compatible elements
                            updateElementsForGenre(genre)
                        }
                    }
                }
            }

            // Selected Genre Description
            if designSpec.genre != .unknown {
                SelectedGenreDescription(genre: designSpec.genre)
            }
        }
    }

    private func updateElementsForGenre(_ genre: RakhiGenre) {
        let database = DesignElementsDatabase.shared
        let suggestedElementIds = genre.suggestedElements

        var newElements: [DesignElement] = []

        for elementId in suggestedElementIds.prefix(3) { // Limit to 3 suggested elements
            if let element = database.getElement(by: elementId) {
                newElements.append(element)
            }
        }

        designSpec.elements = newElements

        // Set appropriate color palette
        switch genre {
        case .traditional:
            designSpec.colorPalette = .traditional
        case .modern:
            designSpec.colorPalette = .vibrant
        case .elegant:
            designSpec.colorPalette = .metallic
        case .spiritual:
            designSpec.colorPalette = .traditional
        case .unknown:
            break
        }
    }
}

struct GenreCard: View {
    let genre: RakhiGenre
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 16) {
                // Icon
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: isSelected ? [.orange, .red.opacity(0.8)] : [.gray.opacity(0.2), .gray.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)

                    Image(systemName: genre.icon)
                        .font(.system(size: 36))
                        .foregroundStyle(isSelected ? .white : .primary)
                }

                // Text
                VStack(spacing: 6) {
                    Text(genre.displayName)
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)

                    Text(genreDescription(for: genre))
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .padding(.horizontal, 16)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? .orange : .clear, lineWidth: 2)
            }
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .shadow(
                color: isSelected ? .orange.opacity(0.3) : .black.opacity(0.05),
                radius: isSelected ? 12 : 6,
                y: isSelected ? 8 : 3
            )
        }
        .buttonStyle(.plain)
    }

    private func genreDescription(for genre: RakhiGenre) -> String {
        switch genre {
        case .traditional:
            return "Classic designs with sacred red threads and gold elements"
        case .modern:
            return "Contemporary styles with innovative materials and patterns"
        case .elegant:
            return "Sophisticated designs with refined details and premium materials"
        case .spiritual:
            return "Sacred symbols and divine essence for spiritual connection"
        case .unknown:
            return ""
        }
    }
}

struct SelectedGenreDescription: View {
    let genre: RakhiGenre

    var body: some View {
        VStack(spacing: 16) {
            Rectangle()
                .fill(.orange.opacity(0.3))
                .frame(height: 1)

            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "lightbulb.fill")
                        .foregroundStyle(.orange)

                    Text("About \(genre.displayName) Style")
                        .font(.system(.subheadline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)

                    Spacer()
                }

                Text(getDetailedDescription(for: genre))
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(.orange.opacity(0.05), in: RoundedRectangle(cornerRadius: 12))
        }
    }

    private func getDetailedDescription(for genre: RakhiGenre) -> String {
        switch genre {
        case .traditional:
            return "Traditional Rakhis honor centuries-old customs with sacred red threads (mauli), gold beads, and time-honored symbols. Perfect for celebrating the classic brother-sister bond with authenticity and cultural significance."
        case .modern:
            return "Modern Rakhis blend contemporary aesthetics with traditional meaning. Featuring innovative materials, geometric patterns, and fresh color combinations while maintaining the essence of Raksha Bandhan."
        case .elegant:
            return "Elegant Rakhis showcase sophisticated craftsmanship with premium materials like pearls, crystals, and refined metalwork. Ideal for expressing appreciation through tasteful luxury and refined beauty."
        case .spiritual:
            return "Spiritual Rakhis incorporate sacred symbols like Om, lotus, and rudraksha beads to create a deeper connection with divine blessings. Perfect for honoring the spiritual aspects of the festival."
        case .unknown:
            return ""
        }
    }
}

#Preview {
    GenreSelectionStep(designSpec: .constant(RakhiDesignSpec()))
        .padding()
        .background(Color(.systemGroupedBackground))
}
