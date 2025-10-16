import Foundation
import Combine

@MainActor
class UsageTrackingService: ObservableObject {
    static let shared = UsageTrackingService()

    @Published var currentUsage: UsageMetrics
    @Published var dailyUsage: [DailyUsage] = []
    @Published var monthlyReport: MonthlyReport?
    @Published var generationHistory: [GenerationRecord] = []

    private let subscriptionManager = SubscriptionManager.shared
    private let maxHistoryDays = 30

    private init() {
        let userId = "current_user_id" // In production, get from auth
        self.currentUsage = UsageMetrics.current(for: userId)
        loadStoredData()

        // Listen to subscription changes
        Task {
            await subscriptionManager.$subscriptionStatus
                .sink { [weak self] _ in
                    Task { @MainActor in
                        self?.updateUsageAfterSubscriptionChange()
                    }
                }
                .store(in: &cancellables)
        }
    }

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Generation Tracking
    func recordGeneration(
        culturalContext: CulturalCategory,
        pack: PremiumCulturalPack? = nil,
        giftType: CulturalGiftCategory,
        wasRegeneration: Bool = false
    ) {
        let record = GenerationRecord(
            id: UUID(),
            timestamp: Date(),
            culturalContext: culturalContext,
            premiumPack: pack,
            giftCategory: giftType,
            wasRegeneration: wasRegeneration,
            cost: wasRegeneration ? subscriptionManager.subscriptionStatus.tier.regenerationCost : 0.0
        )

        // Add to generation history
        generationHistory.insert(record, at: 0)

        // Keep only last 100 generations
        if generationHistory.count > 100 {
            generationHistory = Array(generationHistory.prefix(100))
        }

        // Update current usage
        updateCurrentUsage(with: record)

        // Update daily usage
        updateDailyUsage(with: record)

        // Save data
        saveData()

        // Notify subscription manager
        subscriptionManager.recordGeneration(culture: culturalContext, pack: pack)
    }

    func canGenerate() -> GenerationPermission {
        let subscription = subscriptionManager.subscriptionStatus

        // Check if user has remaining generations
        if subscription.generationsRemaining > 0 {
            return .allowed
        }

        // Suggest regeneration purchase
        let cost = subscription.tier.regenerationCost
        return .requiresPayment(cost: cost)
    }

    func canAccessCulture(_ culture: CulturalCategory) -> CultureAccessPermission {
        let subscription = subscriptionManager.subscriptionStatus

        if subscription.canAccessCulture(culture) {
            return .allowed
        }

        // Determine required tier
        let requiredTier: SubscriptionTier = culture == .hindu ? .free : .basic
        return .requiresUpgrade(requiredTier: requiredTier)
    }

    func canAccessPremiumPack(_ pack: PremiumCulturalPack) -> PackAccessPermission {
        let subscription = subscriptionManager.subscriptionStatus

        if subscription.canAccessPremiumPack(pack) {
            return .allowed
        }

        if subscription.tier.rawValue >= pack.requiresSubscription.rawValue {
            return .requiresPurchase(cost: pack.price)
        }

        return .requiresUpgrade(requiredTier: pack.requiresSubscription)
    }

    // MARK: - Usage Analytics
    func getUsageAnalytics(for period: AnalyticsPeriod) -> UsageAnalytics {
        let calendar = Calendar.current
        let now = Date()

        let startDate: Date
        switch period {
        case .week:
            startDate = calendar.date(byAdding: .day, value: -7, to: now) ?? now
        case .month:
            startDate = calendar.date(byAdding: .month, value: -1, to: now) ?? now
        case .threeMonths:
            startDate = calendar.date(byAdding: .month, value: -3, to: now) ?? now
        case .year:
            startDate = calendar.date(byAdding: .year, value: -1, to: now) ?? now
        }

        let filteredHistory = generationHistory.filter { $0.timestamp >= startDate }

        let totalGenerations = filteredHistory.count
        let totalRegenrations = filteredHistory.filter { $0.wasRegeneration }.count
        let totalCost = filteredHistory.reduce(0) { $0 + $1.cost }

        let cultureCounts = Dictionary(grouping: filteredHistory) { $0.culturalContext }
            .mapValues { $0.count }

        let packCounts = Dictionary(grouping: filteredHistory.compactMap { $0.premiumPack }) { $0 }
            .mapValues { $0.count }

        let favoriteContext = cultureCounts.max { $0.value < $1.value }?.key ?? .hindu
        let mostUsedPack = packCounts.max { $0.value < $1.value }?.key

        return UsageAnalytics(
            period: period,
            totalGenerations: totalGenerations,
            totalRegenerations: totalRegenrations,
            totalSpent: totalCost,
            cultureBreakdown: cultureCounts,
            packUsage: packCounts,
            favoriteContext: favoriteContext,
            mostUsedPack: mostUsedPack,
            averageGenerationsPerDay: Double(totalGenerations) / Double(period.days)
        )
    }

    func getMonthlyReport(for date: Date = Date()) -> MonthlyReport {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)

        let monthlyGenerations = generationHistory.filter { record in
            let recordMonth = calendar.component(.month, from: record.timestamp)
            let recordYear = calendar.component(.year, from: record.timestamp)
            return recordMonth == month && recordYear == year
        }

        let totalGenerations = monthlyGenerations.count
        let totalSpent = monthlyGenerations.reduce(0) { $0 + $1.cost }
        let subscription = subscriptionManager.subscriptionStatus

        let savings = calculateMonthlySavings(generations: totalGenerations, tier: subscription.tier)

        return MonthlyReport(
            month: month,
            year: year,
            totalGenerations: totalGenerations,
            includedGenerations: subscription.tier.monthlyGenerationsIncluded,
            additionalGenerations: max(0, totalGenerations - subscription.tier.monthlyGenerationsIncluded),
            totalSpent: totalSpent,
            estimatedSavings: savings,
            topCultures: getTopCultures(from: monthlyGenerations),
            topPacks: getTopPacks(from: monthlyGenerations)
        )
    }

    // MARK: - Private Methods
    private func updateCurrentUsage(with record: GenerationRecord) {
        let calendar = Calendar.current
        let now = Date()
        let currentMonth = calendar.component(.month, from: now)
        let currentYear = calendar.component(.year, from: now)

        var cultures = Set(currentUsage.culturesAccessed)
        cultures.insert(record.culturalContext)

        var packs = Set(currentUsage.packsUsed)
        if let pack = record.premiumPack {
            packs.insert(pack)
        }

        currentUsage = UsageMetrics(
            userId: currentUsage.userId,
            month: currentMonth,
            year: currentYear,
            generationsUsed: currentUsage.generationsUsed + 1,
            culturesAccessed: Array(cultures),
            packsUsed: Array(packs),
            totalSpent: currentUsage.totalSpent + record.cost,
            regenerationsPurchased: currentUsage.regenerationsPurchased + (record.wasRegeneration ? 1 : 0)
        )
    }

    private func updateDailyUsage(with record: GenerationRecord) {
        let calendar = Calendar.current
        let recordDay = calendar.startOfDay(for: record.timestamp)

        if let index = dailyUsage.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: recordDay) }) {
            var dayUsage = dailyUsage[index]
            dayUsage.generationsCount += 1
            dayUsage.totalSpent += record.cost

            if record.wasRegeneration {
                dayUsage.regenerationsCount += 1
            }

            dailyUsage[index] = dayUsage
        } else {
            let newDayUsage = DailyUsage(
                date: recordDay,
                generationsCount: 1,
                regenerationsCount: record.wasRegeneration ? 1 : 0,
                totalSpent: record.cost
            )

            dailyUsage.insert(newDayUsage, at: 0)
        }

        // Keep only last 30 days
        if dailyUsage.count > maxHistoryDays {
            dailyUsage = Array(dailyUsage.prefix(maxHistoryDays))
        }
    }

    private func updateUsageAfterSubscriptionChange() {
        // Reset monthly usage if subscription changed
        let calendar = Calendar.current
        let now = Date()
        let currentMonth = calendar.component(.month, from: now)
        let currentYear = calendar.component(.year, from: now)

        if currentUsage.month != currentMonth || currentUsage.year != currentYear {
            currentUsage = UsageMetrics.current(for: currentUsage.userId)
            saveData()
        }
    }

    private func calculateMonthlySavings(generations: Int, tier: SubscriptionTier) -> Double {
        let freeGenCost = SubscriptionTier.free.regenerationCost
        let tierGenCost = tier.regenerationCost

        let excessGenerations = max(0, generations - tier.monthlyGenerationsIncluded)
        let savingsPerGeneration = freeGenCost - tierGenCost

        return Double(excessGenerations) * savingsPerGeneration
    }

    private func getTopCultures(from generations: [GenerationRecord]) -> [CulturalCategory] {
        let counts = Dictionary(grouping: generations) { $0.culturalContext }
            .mapValues { $0.count }

        return counts.sorted { $0.value > $1.value }
            .prefix(3)
            .map { $0.key }
    }

    private func getTopPacks(from generations: [GenerationRecord]) -> [PremiumCulturalPack] {
        let packGenerations = generations.compactMap { $0.premiumPack }
        let counts = Dictionary(grouping: packGenerations) { $0 }
            .mapValues { $0.count }

        return counts.sorted { $0.value > $1.value }
            .prefix(3)
            .map { $0.key }
    }

    private func loadStoredData() {
        // Load usage metrics
        if let data = UserDefaults.standard.data(forKey: "currentUsage"),
           let usage = try? JSONDecoder().decode(UsageMetrics.self, from: data) {
            currentUsage = usage
        }

        // Load generation history
        if let data = UserDefaults.standard.data(forKey: "generationHistory"),
           let history = try? JSONDecoder().decode([GenerationRecord].self, from: data) {
            generationHistory = history
        }

        // Load daily usage
        if let data = UserDefaults.standard.data(forKey: "dailyUsage"),
           let daily = try? JSONDecoder().decode([DailyUsage].self, from: data) {
            dailyUsage = daily
        }
    }

    private func saveData() {
        // Save usage metrics
        if let data = try? JSONEncoder().encode(currentUsage) {
            UserDefaults.standard.set(data, forKey: "currentUsage")
        }

        // Save generation history
        if let data = try? JSONEncoder().encode(generationHistory) {
            UserDefaults.standard.set(data, forKey: "generationHistory")
        }

        // Save daily usage
        if let data = try? JSONEncoder().encode(dailyUsage) {
            UserDefaults.standard.set(data, forKey: "dailyUsage")
        }
    }
}

// MARK: - Supporting Types
struct GenerationRecord: Identifiable, Codable {
    let id: UUID
    let timestamp: Date
    let culturalContext: CulturalCategory
    let premiumPack: PremiumCulturalPack?
    let giftCategory: CulturalGiftCategory
    let wasRegeneration: Bool
    let cost: Double
}

struct DailyUsage: Identifiable, Codable {
    let id = UUID()
    let date: Date
    var generationsCount: Int
    var regenerationsCount: Int
    var totalSpent: Double
}

struct MonthlyReport: Codable {
    let month: Int
    let year: Int
    let totalGenerations: Int
    let includedGenerations: Int
    let additionalGenerations: Int
    let totalSpent: Double
    let estimatedSavings: Double
    let topCultures: [CulturalCategory]
    let topPacks: [PremiumCulturalPack]
}

struct UsageAnalytics {
    let period: AnalyticsPeriod
    let totalGenerations: Int
    let totalRegenerations: Int
    let totalSpent: Double
    let cultureBreakdown: [CulturalCategory: Int]
    let packUsage: [PremiumCulturalPack: Int]
    let favoriteContext: CulturalCategory
    let mostUsedPack: PremiumCulturalPack?
    let averageGenerationsPerDay: Double
}

enum AnalyticsPeriod: String, CaseIterable {
    case week = "week"
    case month = "month"
    case threeMonths = "3months"
    case year = "year"

    var displayName: String {
        switch self {
        case .week: return "This Week"
        case .month: return "This Month"
        case .threeMonths: return "Last 3 Months"
        case .year: return "This Year"
        }
    }

    var days: Int {
        switch self {
        case .week: return 7
        case .month: return 30
        case .threeMonths: return 90
        case .year: return 365
        }
    }
}

enum GenerationPermission {
    case allowed
    case requiresPayment(cost: Double)

    var isAllowed: Bool {
        switch self {
        case .allowed: return true
        case .requiresPayment: return false
        }
    }

    var paymentRequired: Double? {
        switch self {
        case .allowed: return nil
        case .requiresPayment(let cost): return cost
        }
    }
}

enum CultureAccessPermission {
    case allowed
    case requiresUpgrade(requiredTier: SubscriptionTier)

    var isAllowed: Bool {
        switch self {
        case .allowed: return true
        case .requiresUpgrade: return false
        }
    }
}

enum PackAccessPermission {
    case allowed
    case requiresPurchase(cost: Double)
    case requiresUpgrade(requiredTier: SubscriptionTier)

    var isAllowed: Bool {
        switch self {
        case .allowed: return true
        case .requiresPurchase, .requiresUpgrade: return false
        }
    }
}
