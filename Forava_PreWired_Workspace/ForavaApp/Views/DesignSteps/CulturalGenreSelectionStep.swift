import SwiftUI

// MARK: - Cultural Genre Selection Step
struct CulturalGenreSelectionStep: View {
    @Binding var designSpec: CulturalDesignSpec
    @ObservedObject private var culturalConfig = CulturalConfiguration.shared
    @ObservedObject private var contextManager = CulturalContextManager.shared

    var body: some View {
        VStack(spacing: 20) {
            // Cultural Context Header
            CulturalContextHeader()

            // Genre Selection Header
            VStack(spacing: 8) {
                Text(headerTitle)
                    .font(.system(.title3, design: .rounded).weight(.bold))
                    .foregroundStyle(.primary)

                Text(headerSubtitle)
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            // Genre Options (Cultural)
            if let context = contextManager.currentContext {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                    ForEach(context.genres, id: \.id) { genre in
                        CulturalGenreCard(
                            genre: genre,
                            isSelected: designSpec.genre.id == genre.id,
                            culturalContext: context
                        ) {
                            selectGenre(genre, in: context)
                        }
                    }
                }

                // Selected Genre Description
                if !designSpec.genre.id.isEmpty {
                    CulturalGenreDescription(genre: designSpec.genre, context: context)
                }
            } else {
                // Loading or no context state
                VStack(spacing: 16) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())

                    Text("Loading cultural context...")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                }
            }
        }
        .task {
            // Ensure cultural framework is initialized
            if !culturalConfig.isInitialized {
                await culturalConfig.initialize()
            }
        }
    }

    // MARK: - Computed Properties

    private var headerTitle: String {
        guard let context = contextManager.currentContext else {
            return "Choose Your Style"
        }

        switch context.identifier {
        case "rakhi_indian":
            return "Choose Your Rakhi Style"
        default:
            return "Choose Your \(context.displayName) Style"
        }
    }

    private var headerSubtitle: String {
        guard let context = contextManager.currentContext else {
            return "What feeling would you like to convey?"
        }

        switch context.identifier {
        case "rakhi_indian":
            return "What blessing would you like to express?"
        default:
            return "What feeling would you like to convey with your \(context.displayName)?"
        }
    }

    // MARK: - Actions

    private func selectGenre(_ genre: CulturalGenre, in context: CulturalContext) {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            designSpec.genre = genre
            // Auto-select compatible elements from the cultural context
            updateElementsForGenre(genre, in: context)
        }
    }

    private func updateElementsForGenre(_ genre: CulturalGenre, in context: CulturalContext) {
        let suggestedElements = contextManager.getCompatibleElements(for: genre)
        let ageAppropriateElements = contextManager.getAgeAppropriateElements(for: designSpec.targetAgeGroup)

        // Find elements that are both suggested for this genre and age-appropriate
        let compatibleElements = suggestedElements.filter { suggested in
            ageAppropriateElements.contains { ageAppropriate in
                suggested.id == ageAppropriate.id
            }
        }

        // Select up to 3 suggested elements
        designSpec.elements = Array(compatibleElements.prefix(3))

        print("[CulturalGenre] Updated elements for genre '\(genre.displayName)': \(designSpec.elements.map { $0.displayName })")
    }
}

// MARK: - Cultural Context Header
struct CulturalContextHeader: View {
    @ObservedObject private var contextManager = CulturalContextManager.shared

    var body: some View {
        if let context = contextManager.currentContext {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(context.displayName)
                        .font(.system(.caption, design: .rounded).weight(.medium))
                        .foregroundStyle(.primary)

                    Text(context.description)
                        .font(.system(.caption2, design: .rounded))
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                Spacer()

                // Context switch button (if multiple contexts available)
                if CulturalConfiguration.shared.getAvailableContexts().count > 1 {
                    Menu {
                        ForEach(CulturalConfiguration.shared.getAvailableContexts(), id: \.self) { contextId in
                            Button(getContextDisplayName(contextId)) {
                                CulturalConfiguration.shared.switchToCulturalContext(contextId)
                            }
                        }
                    } label: {
                        Image(systemName: "globe")
                            .font(.system(.body, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
        }
    }

    private func getContextDisplayName(_ contextId: String) -> String {
        if let context = contextManager.getContext(for: contextId) {
            return context.displayName
        }
        return contextId.capitalized
    }
}

// MARK: - Cultural Genre Card
struct CulturalGenreCard: View {
    let genre: CulturalGenre
    let isSelected: Bool
    let culturalContext: CulturalContext
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                // Genre Icon
                Image(systemName: genre.icon)
                    .font(.system(.title2, design: .rounded))
                    .foregroundStyle(isSelected ? .white : .primary)

                // Genre Name
                Text(genre.displayName)
                    .font(.system(.body, design: .rounded).weight(.medium))
                    .foregroundStyle(isSelected ? .white : .primary)
                    .multilineTextAlignment(.center)

                // Cultural Weight Indicator
                HStack(spacing: 2) {
                    ForEach(0..<5) { index in
                        Circle()
                            .fill(isSelected ? .white.opacity(0.7) : .secondary.opacity(0.3))
                            .frame(width: 4, height: 4)
                            .opacity(Double(index) < genre.culturalWeight * 5 ? 1.0 : 0.3)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? culturalBackgroundGradient : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? .clear : .secondary.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }

    private var culturalBackgroundGradient: LinearGradient {
        let colors = culturalContext.colorPalettes.first?.colors ?? []

        if colors.count >= 2 {
            return LinearGradient(
                colors: [colors[0].color, colors[1].color],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            // Fallback gradient
            return LinearGradient(
                colors: [.blue, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}

// MARK: - Cultural Genre Description
struct CulturalGenreDescription: View {
    let genre: CulturalGenre
    let context: CulturalContext

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: genre.icon)
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.secondary)

                Text(genre.displayName)
                    .font(.system(.body, design: .rounded).weight(.medium))
                    .foregroundStyle(.primary)

                Spacer()

                // Cultural authenticity indicator
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.yellow)

                    Text(String(format: "%.0f%%", genre.culturalWeight * 100))
                        .font(.system(.caption, design: .rounded).weight(.medium))
                        .foregroundStyle(.secondary)
                }
            }

            Text(genre.basePrompt)
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

            // Suggested elements preview
            if !genre.suggestedElementIds.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(genre.suggestedElementIds.prefix(5), id: \.self) { elementId in
                            if let element = context.designElements.first(where: { $0.id == elementId }) {
                                Text(element.displayName)
                                    .font(.system(.caption2, design: .rounded))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(.regularMaterial, in: Capsule())
                            }
                        }
                    }
                    .padding(.horizontal, 1)
                }
            }
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Legacy Compatibility Bridge
extension CulturalGenreSelectionStep {
    init(legacyDesignSpec: Binding<RakhiDesignSpec>) {
        // Convert legacy binding to cultural binding
        let culturalBinding = Binding<CulturalDesignSpec>(
            get: {
                // Convert legacy spec to cultural spec
                return LegacyRakhiBridge.shared.convertLegacySpec(legacyDesignSpec.wrappedValue) ??
                       CulturalDesignSpec(
                           culturalContext: "rakhi_indian",
                           genre: CulturalGenre(
                               id: "traditional",
                               displayName: "Traditional",
                               icon: "star.circle.fill",
                               basePrompt: "traditional design",
                               culturalContext: "rakhi_indian"
                           ),
                           colorPalette: CulturalColorPalette(
                               id: "traditional",
                               displayName: "Traditional",
                               colors: [],
                               culturalContext: "rakhi_indian"
                           ),
                           targetAgeGroup: CulturalAgeGroup(
                               id: "any",
                               displayName: "Any Age",
                               ageRange: "All ages",
                               culturalContext: "rakhi_indian"
                           )
                       )
            },
            set: { culturalSpec in
                // Convert back to legacy spec for compatibility
                if let legacySpec = LegacyRakhiBridge.shared.convertToLegacySpec(culturalSpec) {
                    legacyDesignSpec.wrappedValue = legacySpec
                }
            }
        )

        self._designSpec = culturalBinding
    }
}
