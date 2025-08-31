import SwiftUI

// MARK: - Cultural Context Picker
struct CulturalContextPicker: View {
    @ObservedObject private var culturalConfig = CulturalConfiguration.shared
    @ObservedObject private var contextManager = CulturalContextManager.shared
    @ObservedObject private var multiLanguageService = MultiLanguagePromptService.shared

    @State private var isExpanded = false
    @State private var searchText = ""
    @State private var selectedCategory: CulturalCategory = .all
    @State private var showingCulturalInfo = false

    var body: some View {
        VStack(spacing: 0) {
            // Current Context Display
            currentContextHeader

            // Context Picker (when expanded)
            if isExpanded {
                contextPickerContent
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .scale(scale: 0.95)),
                        removal: .opacity
                    ))
            }
        }
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isExpanded)
        .task {
            if !multiLanguageService.isInitialized {
                await multiLanguageService.initialize()
            }
        }
    }

    // MARK: - Current Context Header

    private var currentContextHeader: some View {
        Button(action: { withAnimation { isExpanded.toggle() } }) {
            HStack {
                // Current context info
                if let currentContext = contextManager.currentContext {
                    HStack(spacing: 12) {
                        // Cultural flag/icon
                        culturalIcon(for: currentContext)
                            .frame(width: 32, height: 32)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(currentContext.displayName)
                                .font(.system(.body, design: .rounded).weight(.semibold))
                                .foregroundStyle(.primary)

                            Text(currentContext.description)
                                .font(.system(.caption, design: .rounded))
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }

                        Spacer()

                        // Language indicator
                        languageIndicator(for: currentContext)

                        // Expand/collapse chevron
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.system(.caption, design: .rounded).weight(.medium))
                            .foregroundStyle(.secondary)
                    }
                } else {
                    HStack {
                        Image(systemName: "globe")
                            .frame(width: 32, height: 32)
                        Text("Select Culture")
                            .font(.system(.body, design: .rounded).weight(.semibold))
                        Spacer()
                        Image(systemName: "chevron.down")
                            .font(.system(.caption, design: .rounded))
                    }
                    .foregroundStyle(.secondary)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .padding(16)
    }

    // MARK: - Context Picker Content

    private var contextPickerContent: some View {
        VStack(spacing: 16) {
            Divider()

            // Search and Filter
            searchAndFilterSection

            // Available contexts
            contextGridSection

            // Cultural info button
            Button(action: { showingCulturalInfo = true }) {
                HStack {
                    Image(systemName: "info.circle.fill")
                    Text("Learn About Cultures")
                    Spacer()
                    Image(systemName: "arrow.up.right")
                }
                .font(.system(.caption, design: .rounded).weight(.medium))
                .foregroundStyle(.secondary)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
        }
        .sheet(isPresented: $showingCulturalInfo) {
            CulturalEducationView()
        }
    }

    private var searchAndFilterSection: some View {
        VStack(spacing: 12) {
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)

                TextField("Search cultures...", text: $searchText)
                    .font(.system(.body, design: .rounded))

                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))

            // Category filters
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(CulturalCategory.allCases, id: \.self) { category in
                        CategoryFilterChip(
                            category: category,
                            isSelected: selectedCategory == category
                        ) {
                            selectedCategory = category
                        }
                    }
                }
                .padding(.horizontal, 1)
            }
        }
        .padding(.horizontal, 16)
    }

    private var contextGridSection: some View {
        let availableContexts = getFilteredContexts()

        return ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                ForEach(availableContexts, id: \.identifier) { context in
                    CulturalContextCard(
                        context: context,
                        isSelected: contextManager.currentContext?.identifier == context.identifier
                    ) {
                        selectContext(context)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .frame(maxHeight: 300)
    }

    // MARK: - Helper Methods

    private func getFilteredContexts() -> [CulturalContext] {
        let allContextIds = culturalConfig.getAvailableContexts()
        let allContexts = allContextIds.compactMap { contextManager.getContext(for: $0) }

        var filteredContexts = allContexts

        // Apply search filter
        if !searchText.isEmpty {
            filteredContexts = filteredContexts.filter { context in
                context.displayName.localizedCaseInsensitiveContains(searchText) ||
                context.description.localizedCaseInsensitiveContains(searchText)
            }
        }

        // Apply category filter
        if selectedCategory != .all {
            filteredContexts = filteredContexts.filter { context in
                getCategoryForContext(context) == selectedCategory
            }
        }

        return filteredContexts.sorted { $0.displayName < $1.displayName }
    }

    private func getCategoryForContext(_ context: CulturalContext) -> CulturalCategory {
        switch context.identifier {
        case "christian_traditional", "jewish_traditional", "buddhist_traditional":
            return .religious
        case "chinese_traditional", "japanese_traditional", "middle_eastern_traditional":
            return .asian
        case "african_traditional":
            return .african
        case "latin_american_traditional":
            return .american
        case "rakhi_indian":
            return .asian
        default:
            return .other
        }
    }

    private func selectContext(_ context: CulturalContext) {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            culturalConfig.switchToCulturalContext(context.identifier)
            isExpanded = false
        }

        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
    }

    private func culturalIcon(for context: CulturalContext) -> some View {
        let iconName = getCulturalIconName(for: context.identifier)
        let colors = getCulturalColors(for: context)

        return ZStack {
            Circle()
                .fill(LinearGradient(
                    colors: colors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))

            Image(systemName: iconName)
                .font(.system(.body, design: .rounded).weight(.semibold))
                .foregroundStyle(.white)
        }
    }

    private func getCulturalIconName(for contextId: String) -> String {
        switch contextId {
        case "chinese_traditional": return "sparkles"
        case "japanese_traditional": return "leaf.fill"
        case "middle_eastern_traditional": return "star.and.crescent.fill"
        case "african_traditional": return "figure.2.and.child.holdinghands"
        case "latin_american_traditional": return "sun.max.fill"
        case "christian_traditional": return "star.fill"
        case "buddhist_traditional": return "brain.head.profile"
        case "jewish_traditional": return "star.fill"
        case "rakhi_indian": return "heart.fill"
        default: return "globe"
        }
    }

    private func getCulturalColors(for context: CulturalContext) -> [Color] {
        if let primaryPalette = context.colorPalettes.first {
            let swiftUIColors = primaryPalette.colors.prefix(2).map { $0.color }
            return Array(swiftUIColors)
        }
        return [.blue, .purple] // Default fallback
    }

    private func languageIndicator(for context: CulturalContext) -> some View {
        let shortCode = context.primaryLanguage.uppercased()

        return Text(shortCode)
            .font(.system(.caption2, design: .rounded).weight(.bold))
            .foregroundStyle(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(.secondary.opacity(0.8), in: Capsule())
    }
}

// MARK: - Cultural Context Card
struct CulturalContextCard: View {
    let context: CulturalContext
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                // Cultural icon with gradient
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(culturalGradient)
                        .frame(height: 60)

                    Image(systemName: getCulturalIconName())
                        .font(.system(.title2, design: .rounded).weight(.semibold))
                        .foregroundStyle(.white)
                }

                VStack(spacing: 4) {
                    Text(context.displayName)
                        .font(.system(.caption, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)

                    Text("\(context.genres.count) styles")
                        .font(.system(.caption2, design: .rounded))
                        .foregroundStyle(.secondary)
                }
            }
            .padding(12)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? AnyShapeStyle(culturalGradient) : AnyShapeStyle(.clear), lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }

    private var culturalGradient: LinearGradient {
        if let primaryPalette = context.colorPalettes.first {
            let colors = primaryPalette.colors.prefix(2).map { $0.color }
            return LinearGradient(
                colors: Array(colors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        return LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    private func getCulturalIconName() -> String {
        switch context.identifier {
        case "chinese_traditional": return "sparkles"
        case "japanese_traditional": return "leaf.fill"
        case "middle_eastern_traditional": return "star.and.crescent.fill"
        case "african_traditional": return "figure.2.and.child.holdinghands"
        case "latin_american_traditional": return "sun.max.fill"
        case "christian_traditional": return "star.fill"
        case "buddhist_traditional": return "brain.head.profile"
        case "jewish_traditional": return "star.fill"
        case "rakhi_indian": return "heart.fill"
        default: return "globe"
        }
    }
}

// MARK: - Category Filter Chip
struct CategoryFilterChip: View {
    let category: CulturalCategory
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(category.displayName)
                .font(.system(.caption, design: .rounded).weight(.medium))
                .foregroundStyle(isSelected ? .white : .primary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    isSelected ? AnyShapeStyle(.accent) : AnyShapeStyle(.regularMaterial),
                    in: Capsule()
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Cultural Categories
enum CulturalCategory: String, CaseIterable {
    case all = "all"
    case religious = "religious"
    case asian = "asian"
    case african = "african"
    case american = "american"
    case other = "other"

    var displayName: String {
        switch self {
        case .all: return "All"
        case .religious: return "Religious"
        case .asian: return "Asian"
        case .african: return "African"
        case .american: return "American"
        case .other: return "Other"
        }
    }
}

// MARK: - Cultural Education View
struct CulturalEducationView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var contextManager = CulturalContextManager.shared

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(getAvailableContexts(), id: \.identifier) { context in
                        CulturalEducationCard(context: context)
                    }
                }
                .padding()
            }
            .navigationTitle("Cultural Education")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private func getAvailableContexts() -> [CulturalContext] {
        let allContextIds = CulturalConfiguration.shared.getAvailableContexts()
        return allContextIds.compactMap { contextManager.getContext(for: $0) }
            .sorted { $0.displayName < $1.displayName }
    }
}

// MARK: - Cultural Education Card
struct CulturalEducationCard: View {
    let context: CulturalContext

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Image(systemName: getCulturalIconName())
                    .font(.system(.title3))
                    .foregroundStyle(.accent)

                Text(context.displayName)
                    .font(.system(.headline, design: .rounded).weight(.semibold))

                Spacer()

                Text("\(context.supportedLanguages.count) languages")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.regularMaterial, in: Capsule())
            }

            // Description
            Text(context.description)
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.primary)

            // Cultural highlights
            VStack(alignment: .leading, spacing: 8) {
                Text("Cultural Elements:")
                    .font(.system(.caption, design: .rounded).weight(.semibold))
                    .foregroundStyle(.secondary)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(context.designElements.prefix(5), id: \.id) { element in
                            Text(element.displayName)
                                .font(.system(.caption2, design: .rounded))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(.regularMaterial, in: Capsule())
                        }
                    }
                    .padding(.horizontal, 1)
                }
            }
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private func getCulturalIconName() -> String {
        switch context.identifier {
        case "chinese_traditional": return "sparkles"
        case "japanese_traditional": return "leaf.fill"
        case "middle_eastern_traditional": return "star.and.crescent.fill"
        case "african_traditional": return "figure.2.and.child.holdinghands"
        case "latin_american_traditional": return "sun.max.fill"
        case "christian_traditional": return "star.fill"
        case "buddhist_traditional": return "brain.head.profile"
        case "jewish_traditional": return "star.fill"
        case "rakhi_indian": return "heart.fill"
        default: return "globe"
        }
    }
}

// NOTE: CulturalColor.color is now defined in CulturalFramework.swift
