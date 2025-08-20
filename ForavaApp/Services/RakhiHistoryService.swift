import Foundation
import SwiftUI
import Combine
import CoreData

// MARK: - Rakhi History & Favorites Management Service

@MainActor
class RakhiHistoryService: ObservableObject {
    static let shared = RakhiHistoryService()
    
    // MARK: - Published Properties
    @Published var rakhiHistory: [GeneratedRakhi] = []
    @Published var favoriteRakhis: [GeneratedRakhi] = []
    @Published var collections: [RakhiCollection] = []
    @Published var searchResults: [GeneratedRakhi] = []
    @Published var isLoading = false
    @Published var sortOption: HistorySortOption = .dateCreated
    @Published var filterOptions: HistoryFilterOptions = HistoryFilterOptions()
    
    // MARK: - Statistics
    @Published var statistics: RakhiStatistics = RakhiStatistics()
    
    private var cancellables = Set<AnyCancellable>()
    private let maxHistoryItems = 500 // Prevent excessive memory usage
    
    private init() {
        loadHistoryData()
        setupDataObservers()
        calculateStatistics()
    }
    
    // MARK: - History Management
    
    func addToHistory(_ rakhi: GeneratedRakhi) {
        // Remove if already exists to avoid duplicates
        rakhiHistory.removeAll { $0.id == rakhi.id }
        
        // Add to beginning of history
        rakhiHistory.insert(rakhi, at: 0)
        
        // Limit history size
        if rakhiHistory.count > maxHistoryItems {
            rakhiHistory = Array(rakhiHistory.prefix(maxHistoryItems))
        }
        
        saveHistoryData()
        calculateStatistics()
    }
    
    func removeFromHistory(_ rakhi: GeneratedRakhi) {
        rakhiHistory.removeAll { $0.id == rakhi.id }
        saveHistoryData()
        calculateStatistics()
    }
    
    func clearHistory() {
        rakhiHistory.removeAll()
        saveHistoryData()
        calculateStatistics()
    }
    
    // MARK: - Favorites Management
    
    func addToFavorites(_ rakhi: GeneratedRakhi) {
        guard !favoriteRakhis.contains(where: { $0.id == rakhi.id }) else { return }
        
        favoriteRakhis.insert(rakhi, at: 0)
        saveHistoryData()
        calculateStatistics()
    }
    
    func removeFromFavorites(_ rakhi: GeneratedRakhi) {
        favoriteRakhis.removeAll { $0.id == rakhi.id }
        saveHistoryData()
        calculateStatistics()
    }
    
    func isFavorite(_ rakhi: GeneratedRakhi) -> Bool {
        return favoriteRakhis.contains { $0.id == rakhi.id }
    }
    
    func toggleFavorite(_ rakhi: GeneratedRakhi) {
        if isFavorite(rakhi) {
            removeFromFavorites(rakhi)
        } else {
            addToFavorites(rakhi)
        }
    }
    
    // MARK: - Collections Management
    
    func createCollection(name: String, description: String? = nil) -> RakhiCollection {
        let collection = RakhiCollection(
            id: UUID(),
            name: name,
            description: description,
            rakhis: [],
            createdAt: Date(),
            culturalTheme: nil
        )
        
        collections.append(collection)
        saveHistoryData()
        return collection
    }
    
    func addToCollection(_ rakhi: GeneratedRakhi, collection: RakhiCollection) {
        guard let index = collections.firstIndex(where: { $0.id == collection.id }) else { return }
        
        var updatedCollection = collections[index]
        if !updatedCollection.rakhis.contains(where: { $0.id == rakhi.id }) {
            updatedCollection.rakhis.append(rakhi)
            collections[index] = updatedCollection
            saveHistoryData()
        }
    }
    
    func removeFromCollection(_ rakhi: GeneratedRakhi, collection: RakhiCollection) {
        guard let index = collections.firstIndex(where: { $0.id == collection.id }) else { return }
        
        var updatedCollection = collections[index]
        updatedCollection.rakhis.removeAll { $0.id == rakhi.id }
        collections[index] = updatedCollection
        saveHistoryData()
    }
    
    func deleteCollection(_ collection: RakhiCollection) {
        collections.removeAll { $0.id == collection.id }
        saveHistoryData()
    }
    
    // MARK: - Search & Filter
    
    func searchRakhis(query: String) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        
        let lowercaseQuery = query.lowercased()
        let allRakhis = rakhiHistory + favoriteRakhis
        
        searchResults = allRakhis.filter { rakhi in
            // Search in design elements
            let elementMatches = rakhi.designSpec.elements.contains { element in
                element.displayName.lowercased().contains(lowercaseQuery) ||
                element.promptTokens.contains { $0.lowercased().contains(lowercaseQuery) }
            }
            
            // Search in genre
            let genreMatches = rakhi.designSpec.genre.displayName.lowercased().contains(lowercaseQuery)
            
            // Search in color palette
            let colorMatches = rakhi.designSpec.colorPalette.rawValue.lowercased().contains(lowercaseQuery)
            
            // Search in personal message
            let messageMatches = rakhi.designSpec.personalMessage?.lowercased().contains(lowercaseQuery) ?? false
            
            return elementMatches || genreMatches || colorMatches || messageMatches
        }
        
        // Remove duplicates
        searchResults = Array(Set(searchResults))
    }
    
    func getFilteredHistory() -> [GeneratedRakhi] {
        var filteredHistory = rakhiHistory
        
        // Apply genre filter
        if !filterOptions.selectedGenres.isEmpty {
            filteredHistory = filteredHistory.filter { rakhi in
                filterOptions.selectedGenres.contains(rakhi.designSpec.genre)
            }
        }
        
        // Apply color palette filter
        if !filterOptions.selectedColorPalettes.isEmpty {
            filteredHistory = filteredHistory.filter { rakhi in
                filterOptions.selectedColorPalettes.contains(rakhi.designSpec.colorPalette)
            }
        }
        
        // Apply cultural score filter
        filteredHistory = filteredHistory.filter { rakhi in
            rakhi.culturalScore >= filterOptions.minimumCulturalScore
        }
        
        // Apply quality score filter
        filteredHistory = filteredHistory.filter { rakhi in
            rakhi.qualityScore >= filterOptions.minimumQualityScore
        }
        
        // Apply date range filter
        if let startDate = filterOptions.dateRange?.start,
           let endDate = filterOptions.dateRange?.end {
            filteredHistory = filteredHistory.filter { rakhi in
                rakhi.createdAt >= startDate && rakhi.createdAt <= endDate
            }
        }
        
        // Apply sorting
        switch sortOption {
        case .dateCreated:
            filteredHistory.sort { $0.createdAt > $1.createdAt }
        case .culturalScore:
            filteredHistory.sort { $0.culturalScore > $1.culturalScore }
        case .qualityScore:
            filteredHistory.sort { $0.qualityScore > $1.qualityScore }
        case .genre:
            filteredHistory.sort { $0.designSpec.genre.rawValue < $1.designSpec.genre.rawValue }
        case .alphabetical:
            filteredHistory.sort { ($0.designSpec.personalMessage ?? "") < ($1.designSpec.personalMessage ?? "") }
        }
        
        return filteredHistory
    }
    
    // MARK: - Smart Collections
    
    func createSmartCollections() {
        var smartCollections: [RakhiCollection] = []
        
        // High Cultural Score Collection
        let highCulturalRakhis = rakhiHistory.filter { $0.culturalScore >= 0.8 }
        if !highCulturalRakhis.isEmpty {
            smartCollections.append(
                RakhiCollection(
                    id: UUID(),
                    name: "Culturally Authentic",
                    description: "Rakhis with high cultural authenticity",
                    rakhis: highCulturalRakhis,
                    createdAt: Date(),
                    culturalTheme: .traditional,
                    isSmartCollection: true
                )
            )
        }
        
        // Recent Favorites
        let recentFavorites = favoriteRakhis.prefix(10)
        if !recentFavorites.isEmpty {
            smartCollections.append(
                RakhiCollection(
                    id: UUID(),
                    name: "Recent Favorites",
                    description: "Your most recently favorited Rakhis",
                    rakhis: Array(recentFavorites),
                    createdAt: Date(),
                    culturalTheme: nil,
                    isSmartCollection: true
                )
            )
        }
        
        // Traditional Collection
        let traditionalRakhis = rakhiHistory.filter { $0.designSpec.genre == .traditional }
        if !traditionalRakhis.isEmpty {
            smartCollections.append(
                RakhiCollection(
                    id: UUID(),
                    name: "Traditional Designs",
                    description: "Classic traditional Rakhi designs",
                    rakhis: traditionalRakhis,
                    createdAt: Date(),
                    culturalTheme: .traditional,
                    isSmartCollection: true
                )
            )
        }
        
        // Spiritual Collection
        let spiritualRakhis = rakhiHistory.filter { $0.designSpec.genre == .spiritual }
        if !spiritualRakhis.isEmpty {
            smartCollections.append(
                RakhiCollection(
                    id: UUID(),
                    name: "Spiritual Blessings",
                    description: "Rakhis with spiritual significance",
                    rakhis: spiritualRakhis,
                    createdAt: Date(),
                    culturalTheme: .spiritual,
                    isSmartCollection: true
                )
            )
        }
        
        // Add smart collections to regular collections
        collections.removeAll { $0.isSmartCollection }
        collections.append(contentsOf: smartCollections)
    }
    
    // MARK: - Statistics & Analytics
    
    private func calculateStatistics() {
        let totalRakhis = rakhiHistory.count
        let totalFavorites = favoriteRakhis.count
        let totalCollections = collections.filter { !$0.isSmartCollection }.count
        
        // Calculate averages
        let avgCulturalScore = rakhiHistory.isEmpty ? 0.0 : rakhiHistory.map { $0.culturalScore }.reduce(0, +) / Double(rakhiHistory.count)
        let avgQualityScore = rakhiHistory.isEmpty ? 0.0 : rakhiHistory.map { $0.qualityScore }.reduce(0, +) / Double(rakhiHistory.count)
        
        // Genre distribution
        let genreDistribution = Dictionary(grouping: rakhiHistory, by: { $0.designSpec.genre })
            .mapValues { $0.count }
        
        // Color palette distribution
        let colorDistribution = Dictionary(grouping: rakhiHistory, by: { $0.designSpec.colorPalette })
            .mapValues { $0.count }
        
        // Monthly creation stats
        let monthlyStats = calculateMonthlyStatistics()
        
        // Most used elements
        let elementUsage = calculateElementUsageStatistics()
        
        statistics = RakhiStatistics(
            totalCreated: totalRakhis,
            totalFavorites: totalFavorites,
            totalCollections: totalCollections,
            averageCulturalScore: avgCulturalScore,
            averageQualityScore: avgQualityScore,
            genreDistribution: genreDistribution,
            colorDistribution: colorDistribution,
            monthlyCreationStats: monthlyStats,
            mostUsedElements: elementUsage,
            creationStreak: calculateCreationStreak(),
            lastCreated: rakhiHistory.first?.createdAt
        )
    }
    
    private func calculateMonthlyStatistics() -> [MonthlyStats] {
        let calendar = Calendar.current
        var monthlyData: [String: Int] = [:]
        
        for rakhi in rakhiHistory {
            let monthYear = calendar.dateInterval(of: .month, for: rakhi.createdAt)
            let key = DateFormatter().string(from: monthYear?.start ?? rakhi.createdAt)
            monthlyData[key, default: 0] += 1
        }
        
        return monthlyData.map { MonthlyStats(month: $0.key, count: $0.value) }
            .sorted { $0.month < $1.month }
    }
    
    private func calculateElementUsageStatistics() -> [ElementUsageStats] {
        var elementCounts: [String: Int] = [:]
        
        for rakhi in rakhiHistory {
            for element in rakhi.designSpec.elements {
                elementCounts[element.displayName, default: 0] += 1
            }
        }
        
        return elementCounts.map { ElementUsageStats(elementName: $0.key, usageCount: $0.value) }
            .sorted { $0.usageCount > $1.usageCount }
            .prefix(10)
            .map { $0 }
    }
    
    private func calculateCreationStreak() -> Int {
        let calendar = Calendar.current
        var streak = 0
        var currentDate = Date()
        
        while true {
            let dayRakhis = rakhiHistory.filter { rakhi in
                calendar.isDate(rakhi.createdAt, inSameDayAs: currentDate)
            }
            
            if dayRakhis.isEmpty {
                break
            }
            
            streak += 1
            currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
        }
        
        return streak
    }
    
    // MARK: - Data Persistence
    
    private func loadHistoryData() {
        isLoading = true
        
        // Load from UserDefaults for now - in production would use Core Data
        if let historyData = UserDefaults.standard.data(forKey: "rakhi_history"),
           let decodedHistory = try? JSONDecoder().decode([GeneratedRakhi].self, from: historyData) {
            rakhiHistory = decodedHistory
        }
        
        if let favoritesData = UserDefaults.standard.data(forKey: "rakhi_favorites"),
           let decodedFavorites = try? JSONDecoder().decode([GeneratedRakhi].self, from: favoritesData) {
            favoriteRakhis = decodedFavorites
        }
        
        if let collectionsData = UserDefaults.standard.data(forKey: "rakhi_collections"),
           let decodedCollections = try? JSONDecoder().decode([RakhiCollection].self, from: collectionsData) {
            collections = decodedCollections
        }
        
        createSmartCollections()
        isLoading = false
    }
    
    private func saveHistoryData() {
        // Save to UserDefaults for now - in production would use Core Data
        if let historyData = try? JSONEncoder().encode(rakhiHistory) {
            UserDefaults.standard.set(historyData, forKey: "rakhi_history")
        }
        
        if let favoritesData = try? JSONEncoder().encode(favoriteRakhis) {
            UserDefaults.standard.set(favoritesData, forKey: "rakhi_favorites")
        }
        
        // Don't save smart collections
        let regularCollections = collections.filter { !$0.isSmartCollection }
        if let collectionsData = try? JSONEncoder().encode(regularCollections) {
            UserDefaults.standard.set(collectionsData, forKey: "rakhi_collections")
        }
    }
    
    private func setupDataObservers() {
        // Observe changes and update smart collections
        $rakhiHistory
            .combineLatest($favoriteRakhis)
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] _, _ in
                self?.createSmartCollections()
                self?.calculateStatistics()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Export & Import
    
    func exportHistory() async throws -> URL {
        let exportData = HistoryExportData(
            rakhis: rakhiHistory,
            favorites: favoriteRakhis,
            collections: collections.filter { !$0.isSmartCollection },
            statistics: statistics,
            exportDate: Date()
        )
        
        let jsonData = try JSONEncoder().encode(exportData)
        
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let exportURL = documentsPath.appendingPathComponent("forava_rakhi_export_\(Date().timeIntervalSince1970).json")
        
        try jsonData.write(to: exportURL)
        return exportURL
    }
    
    func importHistory(from url: URL) async throws {
        let jsonData = try Data(contentsOf: url)
        let importData = try JSONDecoder().decode(HistoryExportData.self, from: jsonData)
        
        // Merge imported data with existing data
        let existingIds = Set(rakhiHistory.map { $0.id })
        let newRakhis = importData.rakhis.filter { !existingIds.contains($0.id) }
        
        rakhiHistory.append(contentsOf: newRakhis)
        
        // Import favorites
        let existingFavoriteIds = Set(favoriteRakhis.map { $0.id })
        let newFavorites = importData.favorites.filter { !existingFavoriteIds.contains($0.id) }
        favoriteRakhis.append(contentsOf: newFavorites)
        
        // Import collections
        collections.append(contentsOf: importData.collections)
        
        saveHistoryData()
        createSmartCollections()
        calculateStatistics()
    }
}

// MARK: - Supporting Types

struct RakhiCollection: Identifiable, Codable {
    let id: UUID
    var name: String
    var description: String?
    var rakhis: [GeneratedRakhi]
    let createdAt: Date
    var culturalTheme: CulturalTheme?
    var isSmartCollection: Bool = false
    
    var rakhiCount: Int {
        rakhis.count
    }
    
    var averageCulturalScore: Double {
        guard !rakhis.isEmpty else { return 0.0 }
        return rakhis.map { $0.culturalScore }.reduce(0, +) / Double(rakhis.count)
    }
}

enum CulturalTheme: String, CaseIterable, Codable {
    case traditional = "Traditional"
    case spiritual = "Spiritual"
    case modern = "Modern"
    case festive = "Festive"
    
    var icon: String {
        switch self {
        case .traditional: return "star.circle.fill"
        case .spiritual: return "leaf.fill"
        case .modern: return "sparkles"
        case .festive: return "party.popper.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .traditional: return .orange
        case .spiritual: return .green
        case .modern: return .blue
        case .festive: return .pink
        }
    }
}

enum HistorySortOption: String, CaseIterable {
    case dateCreated = "Date Created"
    case culturalScore = "Cultural Score"
    case qualityScore = "Quality Score"
    case genre = "Genre"
    case alphabetical = "A-Z"
}

struct HistoryFilterOptions {
    var selectedGenres: Set<RakhiGenre> = []
    var selectedColorPalettes: Set<ColorPalette> = []
    var minimumCulturalScore: Double = 0.0
    var minimumQualityScore: Double = 0.0
    var dateRange: DateRange?
    
    var hasActiveFilters: Bool {
        return !selectedGenres.isEmpty ||
               !selectedColorPalettes.isEmpty ||
               minimumCulturalScore > 0.0 ||
               minimumQualityScore > 0.0 ||
               dateRange != nil
    }
}

struct DateRange {
    let start: Date
    let end: Date
}

struct RakhiStatistics: Codable {
    let totalCreated: Int
    let totalFavorites: Int
    let totalCollections: Int
    let averageCulturalScore: Double
    let averageQualityScore: Double
    let genreDistribution: [RakhiGenre: Int]
    let colorDistribution: [ColorPalette: Int]
    let monthlyCreationStats: [MonthlyStats]
    let mostUsedElements: [ElementUsageStats]
    let creationStreak: Int
    let lastCreated: Date?
    
    init() {
        self.totalCreated = 0
        self.totalFavorites = 0
        self.totalCollections = 0
        self.averageCulturalScore = 0.0
        self.averageQualityScore = 0.0
        self.genreDistribution = [:]
        self.colorDistribution = [:]
        self.monthlyCreationStats = []
        self.mostUsedElements = []
        self.creationStreak = 0
        self.lastCreated = nil
    }
    
    init(
        totalCreated: Int,
        totalFavorites: Int,
        totalCollections: Int,
        averageCulturalScore: Double,
        averageQualityScore: Double,
        genreDistribution: [RakhiGenre: Int],
        colorDistribution: [ColorPalette: Int],
        monthlyCreationStats: [MonthlyStats],
        mostUsedElements: [ElementUsageStats],
        creationStreak: Int,
        lastCreated: Date?
    ) {
        self.totalCreated = totalCreated
        self.totalFavorites = totalFavorites
        self.totalCollections = totalCollections
        self.averageCulturalScore = averageCulturalScore
        self.averageQualityScore = averageQualityScore
        self.genreDistribution = genreDistribution
        self.colorDistribution = colorDistribution
        self.monthlyCreationStats = monthlyCreationStats
        self.mostUsedElements = mostUsedElements
        self.creationStreak = creationStreak
        self.lastCreated = lastCreated
    }
}

struct MonthlyStats: Codable, Identifiable {
    let id = UUID()
    let month: String
    let count: Int
}

struct ElementUsageStats: Codable, Identifiable {
    let id = UUID()
    let elementName: String
    let usageCount: Int
}

struct HistoryExportData: Codable {
    let rakhis: [GeneratedRakhi]
    let favorites: [GeneratedRakhi]
    let collections: [RakhiCollection]
    let statistics: RakhiStatistics
    let exportDate: Date
}