import SwiftUI
import Charts

struct RakhiHistoryView: View {
    @StateObject private var historyService = RakhiHistoryService.shared
    @State private var selectedTab: HistoryTab = .history
    @State private var searchText = ""
    @State private var showingFilters = false
    @State private var showingStatistics = false
    @State private var showingExportOptions = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Tab Selector
                HistoryTabSelector(selectedTab: $selectedTab)

                // Search Bar
                SearchBar(text: $searchText, onSearchChanged: handleSearch)

                // Content
                TabView(selection: $selectedTab) {
                    HistoryContentView(
                        rakhis: searchText.isEmpty ? historyService.getFilteredHistory() : historyService.searchResults,
                        emptyMessage: "No Rakhis created yet",
                        emptyDescription: "Start creating beautiful AI-powered Rakhis to see them here"
                    )
                    .tag(HistoryTab.history)

                    FavoritesContentView(
                        favorites: searchText.isEmpty ? historyService.favoriteRakhis : historyService.searchResults.filter { historyService.isFavorite($0) }
                    )
                    .tag(HistoryTab.favorites)

                    CollectionsContentView(
                        collections: historyService.collections
                    )
                    .tag(HistoryTab.collections)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .navigationTitle(selectedTab.title)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingStatistics = true
                    } label: {
                        Image(systemName: "chart.bar.fill")
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            showingFilters = true
                        } label: {
                            Label("Filters", systemImage: "line.3.horizontal.decrease.circle")
                        }

                        Button {
                            showingExportOptions = true
                        } label: {
                            Label("Export", systemImage: "square.and.arrow.up")
                        }

                        if selectedTab == .history {
                            Divider()

                            Button(role: .destructive) {
                                clearHistory()
                            } label: {
                                Label("Clear History", systemImage: "trash")
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .sheet(isPresented: $showingFilters) {
                HistoryFiltersView(filterOptions: $historyService.filterOptions)
            }
            .sheet(isPresented: $showingStatistics) {
                StatisticsView(statistics: historyService.statistics)
            }
            .sheet(isPresented: $showingExportOptions) {
                ExportOptionsView()
            }
        }
    }

    private func handleSearch(_ query: String) {
        historyService.searchRakhis(query: query)
    }

    private func clearHistory() {
        historyService.clearHistory()
    }
}

// MARK: - Tab Selector

enum HistoryTab: CaseIterable {
    case history
    case favorites
    case collections

    var title: String {
        switch self {
        case .history: return "History"
        case .favorites: return "Favorites"
        case .collections: return "Collections"
        }
    }

    var icon: String {
        switch self {
        case .history: return "clock.arrow.circlepath"
        case .favorites: return "heart.fill"
        case .collections: return "folder.fill"
        }
    }
}

struct HistoryTabSelector: View {
    @Binding var selectedTab: HistoryTab

    var body: some View {
        HStack(spacing: 0) {
            ForEach(HistoryTab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        selectedTab = tab
                    }
                } label: {
                    VStack(spacing: 6) {
                        Image(systemName: tab.icon)
                            .font(.system(.title3))
                            .foregroundStyle(selectedTab == tab ? .orange : .secondary)

                        Text(tab.title)
                            .font(.system(.caption, design: .rounded).weight(.medium))
                            .foregroundStyle(selectedTab == tab ? .orange : .secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        selectedTab == tab ? .orange.opacity(0.1) : .clear,
                        in: RoundedRectangle(cornerRadius: 8)
                    )
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }
}

// MARK: - Search Bar

struct SearchBar: View {
    @Binding var text: String
    let onSearchChanged: (String) -> Void

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)

            TextField("Search Rakhis...", text: $text)
                .textFieldStyle(.plain)
                .onChange(of: text) { _, newValue in
                    onSearchChanged(newValue)
                }

            if !text.isEmpty {
                Button {
                    text = ""
                    onSearchChanged("")
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }
}

// MARK: - History Content

struct HistoryContentView: View {
    let rakhis: [GeneratedRakhi]
    let emptyMessage: String
    let emptyDescription: String

    @StateObject private var historyService = RakhiHistoryService.shared

    var body: some View {
        Group {
            if rakhis.isEmpty {
                HistoryEmptyState(
                    message: emptyMessage,
                    description: emptyDescription
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(rakhis) { rakhi in
                            RakhiHistoryCard(
                                rakhi: rakhi,
                                isFavorite: historyService.isFavorite(rakhi),
                                onFavoriteToggle: {
                                    historyService.toggleFavorite(rakhi)
                                },
                                onRemove: {
                                    historyService.removeFromHistory(rakhi)
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 100)
                }
            }
        }
    }
}

// MARK: - Favorites Content

struct FavoritesContentView: View {
    let favorites: [GeneratedRakhi]

    @StateObject private var historyService = RakhiHistoryService.shared

    var body: some View {
        Group {
            if favorites.isEmpty {
                HistoryEmptyState(
                    message: "No favorites yet",
                    description: "Tap the heart icon on any Rakhi to add it to your favorites"
                )
            } else {
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                        ForEach(favorites) { rakhi in
                            FavoriteRakhiCard(
                                rakhi: rakhi,
                                onRemove: {
                                    historyService.removeFromFavorites(rakhi)
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 100)
                }
            }
        }
    }
}

// MARK: - Collections Content

struct CollectionsContentView: View {
    let collections: [RakhiCollection]

    @StateObject private var historyService = RakhiHistoryService.shared
    @State private var showingCreateCollection = false

    var body: some View {
        Group {
            if collections.isEmpty {
                VStack(spacing: 20) {
                    HistoryEmptyState(
                        message: "No collections yet",
                        description: "Create collections to organize your Rakhis by theme or occasion"
                    )

                    Button("Create Collection") {
                        showingCreateCollection = true
                    }
                    .font(.system(.body, design: .rounded).weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(.orange, in: RoundedRectangle(cornerRadius: 12))
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        // Quick actions
                        QuickActionsSection(onCreateCollection: {
                            showingCreateCollection = true
                        })

                        // Collections grid
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                            ForEach(collections) { collection in
                                CollectionCard(
                                    collection: collection,
                                    onDelete: {
                                        historyService.deleteCollection(collection)
                                    }
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 100)
                }
            }
        }
        .sheet(isPresented: $showingCreateCollection) {
            CreateCollectionView()
        }
    }
}

// MARK: - Card Components

struct RakhiHistoryCard: View {
    let rakhi: GeneratedRakhi
    let isFavorite: Bool
    let onFavoriteToggle: () -> Void
    let onRemove: () -> Void

    @State private var showingDetails = false

    var body: some View {
        HStack(spacing: 16) {
            // Rakhi Image
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.regularMaterial)
                    .frame(width: 80, height: 80)

                Image(systemName: "gift.circle.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.orange, .red],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }

            // Rakhi Details
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(rakhi.designSpec.genre.displayName)
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)

                    Spacer()

                    // Favorite button
                    Button {
                        onFavoriteToggle()
                    } label: {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .font(.system(.title3))
                            .foregroundStyle(isFavorite ? .red : .secondary)
                    }
                }

                HStack(spacing: 12) {
                    ScoreBadge(
                        label: "Cultural",
                        score: rakhi.culturalScore,
                        color: .green
                    )

                    ScoreBadge(
                        label: "Quality",
                        score: rakhi.qualityScore,
                        color: .blue
                    )
                }

                HStack {
                    Text(rakhi.createdAt, style: .relative)
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)

                    Spacer()

                    Menu {
                        Button("View Details") {
                            showingDetails = true
                        }

                        Button("Share") {
                            // Share action
                        }

                        Divider()

                        Button("Remove", role: .destructive) {
                            onRemove()
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(.subheadline))
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
        .onTapGesture {
            showingDetails = true
        }
        .sheet(isPresented: $showingDetails) {
            RakhiDetailView(rakhi: rakhi)
        }
    }
}

struct ScoreBadge: View {
    let label: String
    let score: Double
    let color: Color

    var body: some View {
        HStack(spacing: 4) {
            Text(label)
                .font(.system(.caption2, design: .rounded))
                .foregroundStyle(.secondary)

            Text("\(score, specifier: "%.1f")")
                .font(.system(.caption, design: .rounded).weight(.semibold))
                .foregroundStyle(color)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(color.opacity(0.1), in: Capsule())
    }
}

struct FavoriteRakhiCard: View {
    let rakhi: GeneratedRakhi
    let onRemove: () -> Void

    @State private var showingDetails = false

    var body: some View {
        VStack(spacing: 12) {
            // Rakhi Image
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.regularMaterial)
                    .frame(height: 120)

                Image(systemName: "gift.circle.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.orange, .red],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                // Favorite indicator
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "heart.fill")
                            .font(.system(.caption))
                            .foregroundStyle(.red)
                            .padding(6)
                            .background(.regularMaterial, in: Circle())
                    }
                    Spacer()
                }
                .padding(8)
            }

            // Details
            VStack(alignment: .leading, spacing: 4) {
                Text(rakhi.designSpec.genre.displayName)
                    .font(.system(.subheadline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                Text(rakhi.createdAt, style: .relative)
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)

                HStack {
                    Text("✨ \(rakhi.culturalScore, specifier: "%.1f")")
                        .font(.system(.caption2, design: .rounded))
                        .foregroundStyle(.green)

                    Spacer()

                    Button {
                        onRemove()
                    } label: {
                        Image(systemName: "heart.slash")
                            .font(.system(.caption))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
        .onTapGesture {
            showingDetails = true
        }
        .sheet(isPresented: $showingDetails) {
            RakhiDetailView(rakhi: rakhi)
        }
    }
}

struct CollectionCard: View {
    let collection: RakhiCollection
    let onDelete: () -> Void

    @State private var showingDetails = false

    var body: some View {
        VStack(spacing: 12) {
            // Collection Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    if let theme = collection.culturalTheme {
                        Image(systemName: theme.icon)
                            .font(.system(.title2))
                            .foregroundStyle(theme.color)
                    } else {
                        Image(systemName: "folder.fill")
                            .font(.system(.title2))
                            .foregroundStyle(.orange)
                    }

                    Text("\(collection.rakhiCount) Rakhis")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if collection.isSmartCollection {
                    Image(systemName: "wand.and.stars")
                        .font(.system(.caption))
                        .foregroundStyle(.purple)
                        .padding(4)
                        .background(.purple.opacity(0.1), in: Circle())
                }
            }

            // Collection Info
            VStack(alignment: .leading, spacing: 6) {
                Text(collection.name)
                    .font(.system(.subheadline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(2)

                if let description = collection.description {
                    Text(description)
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                if collection.rakhiCount > 0 {
                    HStack {
                        Text("Avg Cultural: \(collection.averageCulturalScore, specifier: "%.1f")")
                            .font(.system(.caption2, design: .rounded))
                            .foregroundStyle(.green)

                        Spacer()
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()
        }
        .padding(16)
        .frame(height: 140)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(alignment: .topTrailing) {
            if !collection.isSmartCollection {
                Menu {
                    Button("View Details") {
                        showingDetails = true
                    }

                    Button("Delete", role: .destructive) {
                        onDelete()
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(.caption))
                        .foregroundStyle(.secondary)
                        .padding(8)
                }
            }
        }
        .onTapGesture {
            showingDetails = true
        }
        .sheet(isPresented: $showingDetails) {
            CollectionDetailView(collection: collection)
        }
    }
}

// MARK: - Empty State

struct HistoryEmptyState: View {
    let message: String
    let description: String

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)

            VStack(spacing: 8) {
                Text(message)
                    .font(.system(.title2, design: .rounded).weight(.bold))
                    .foregroundStyle(.primary)

                Text(description)
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Quick Actions

struct QuickActionsSection: View {
    let onCreateCollection: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Quick Actions")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                Spacer()
            }

            HStack(spacing: 12) {
                QuickActionButton(
                    title: "New Collection",
                    icon: "folder.badge.plus",
                    color: .orange,
                    action: onCreateCollection
                )

                QuickActionButton(
                    title: "Smart Collections",
                    icon: "wand.and.stars",
                    color: .purple
                ) {
                    RakhiHistoryService.shared.createSmartCollections()
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(.subheadline))

                Text(title)
                    .font(.system(.subheadline, design: .rounded).weight(.medium))
            }
            .foregroundStyle(color)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(color.opacity(0.1), in: RoundedRectangle(cornerRadius: 10))
        }
    }
}

// MARK: - Detail Views (Placeholders)

struct RakhiDetailView: View {
    let rakhi: GeneratedRakhi
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Rakhi Details")
                        .font(.title)
                    Text("Genre: \(rakhi.designSpec.genre.displayName)")
                    Text("Cultural Score: \(rakhi.culturalScore, specifier: "%.2f")")
                    Text("Created: \(rakhi.createdAt, style: .date)")
                }
                .padding()
            }
            .navigationTitle("Rakhi Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct CollectionDetailView: View {
    let collection: RakhiCollection
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Collection Details")
                        .font(.title)
                    Text("Name: \(collection.name)")
                    Text("Rakhis: \(collection.rakhiCount)")
                    if let description = collection.description {
                        Text("Description: \(description)")
                    }
                }
                .padding()
            }
            .navigationTitle(collection.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct CreateCollectionView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var description = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Collection Name", text: $name)
                TextField("Description (Optional)", text: $description, axis: .vertical)
                    .lineLimit(3)
            }
            .navigationTitle("New Collection")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create") {
                        RakhiHistoryService.shared.createCollection(name: name, description: description.isEmpty ? nil : description)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}

// MARK: - Filter and Statistics Views (Placeholders)

struct HistoryFiltersView: View {
    @Binding var filterOptions: HistoryFilterOptions
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Text("Filters View")
                .navigationTitle("Filters")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") { dismiss() }
                    }
                }
        }
    }
}

struct StatisticsView: View {
    let statistics: RakhiStatistics
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Text("Statistics View")
                .navigationTitle("Statistics")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") { dismiss() }
                    }
                }
        }
    }
}

struct ExportOptionsView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Text("Export Options")
                .navigationTitle("Export")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") { dismiss() }
                    }
                }
        }
    }
}

#Preview {
    RakhiHistoryView()
}
