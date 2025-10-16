import Foundation
import SwiftUI
import Combine
import WatchConnectivity

// MARK: - Subscription Tiers
enum SubscriptionTier: String, Codable, CaseIterable {
    case free = "free"
    case basic = "basic"
    case premium = "premium"
    case family = "family"

    var displayName: String {
        switch self {
        case .free: return "Free"
        case .basic: return "Basic"
        case .premium: return "Premium"
        case .family: return "Family"
        }
    }

    var monthlyPrice: Double {
        switch self {
        case .free: return 0.00
        case .basic: return 2.99
        case .premium: return 4.99
        case .family: return 7.99
        }
    }

    var annualPrice: Double {
        return monthlyPrice * 10 // 2 months free
    }

    var culturalContextsAllowed: Int {
        switch self {
        case .free: return 1 // Hindu only
        case .basic: return 3
        case .premium: return 7 // All contexts
        case .family: return 7 // All contexts
        }
    }

    var monthlyGenerationsIncluded: Int {
        switch self {
        case .free: return 3
        case .basic: return 10
        case .premium: return 25
        case .family: return 50
        }
    }

    var regenerationCost: Double {
        switch self {
        case .free: return 2.99
        case .basic: return 1.99
        case .premium: return 0.99
        case .family: return 0.49
        }
    }

    var premiumCulturalPacks: Bool {
        switch self {
        case .free, .basic: return false
        case .premium, .family: return true
        }
    }

    var priorityProcessing: Bool {
        switch self {
        case .free, .basic: return false
        case .premium, .family: return true
        }
    }

    var familyMembers: Int {
        switch self {
        case .free, .basic, .premium: return 1
        case .family: return 6
        }
    }

    var features: [String] {
        var features: [String] = []

        if culturalContextsAllowed > 1 {
            features.append("\(culturalContextsAllowed) cultural contexts")
        } else {
            features.append("Hindu context only")
        }

        features.append("\(monthlyGenerationsIncluded) AI generations/month")
        features.append("$\(String(format: "%.2f", regenerationCost)) per additional generation")

        if premiumCulturalPacks {
            features.append("Premium cultural design packs")
        }

        if priorityProcessing {
            features.append("Priority AI processing")
        }

        if familyMembers > 1 {
            features.append("Up to \(familyMembers) family members")
        }

        return features
    }

    var primaryColor: Color {
        switch self {
        case .free: return .gray
        case .basic: return .blue
        case .premium: return .purple
        case .family: return Color(red: 1.0, green: 0.84, blue: 0.0)
        }
    }
}

// MARK: - Premium Cultural Design Packs
enum PremiumCulturalPack: String, Codable, CaseIterable {
    case limitedEdition = "limited_edition"
    case seasonalSpecial = "seasonal_special"
    case artisticMasterpiece = "artistic_masterpiece"
    case culturalHeritage = "cultural_heritage"
    case modernFusion = "modern_fusion"
    case royalCollection = "royal_collection"

    var displayName: String {
        switch self {
        case .limitedEdition: return "Limited Edition"
        case .seasonalSpecial: return "Seasonal Special"
        case .artisticMasterpiece: return "Artistic Masterpiece"
        case .culturalHeritage: return "Cultural Heritage"
        case .modernFusion: return "Modern Fusion"
        case .royalCollection: return "Royal Collection"
        }
    }

    var price: Double {
        switch self {
        case .limitedEdition: return 4.99
        case .seasonalSpecial: return 3.99
        case .artisticMasterpiece: return 6.99
        case .culturalHeritage: return 5.99
        case .modernFusion: return 4.99
        case .royalCollection: return 9.99
        }
    }

    var culturalWeight: Double {
        switch self {
        case .limitedEdition: return 0.95
        case .seasonalSpecial: return 0.85
        case .artisticMasterpiece: return 1.0
        case .culturalHeritage: return 1.0
        case .modernFusion: return 0.8
        case .royalCollection: return 1.0
        }
    }

    var availableFor: [CulturalCategory] {
        switch self {
        case .limitedEdition: return CulturalCategory.allCases
        case .seasonalSpecial: return [.hindu, .chinese, .christian, .jewish]
        case .artisticMasterpiece: return CulturalCategory.allCases
        case .culturalHeritage: return [.hindu, .chinese, .islamic, .buddhist, .jewish]
        case .modernFusion: return [.universal, .chinese, .hindu]
        case .royalCollection: return [.hindu, .chinese, .christian]
        }
    }

    var requiresSubscription: SubscriptionTier {
        switch self {
        case .limitedEdition, .seasonalSpecial: return .basic
        case .artisticMasterpiece, .culturalHeritage, .modernFusion: return .premium
        case .royalCollection: return .premium
        }
    }

    var icon: String {
        switch self {
        case .limitedEdition: return "star.circle.fill"
        case .seasonalSpecial: return "snowflake"
        case .artisticMasterpiece: return "paintbrush.pointed.fill"
        case .culturalHeritage: return "building.columns.fill"
        case .modernFusion: return "wand.and.stars"
        case .royalCollection: return "crown.fill"
        }
    }
}

// MARK: - Subscription Status
struct SubscriptionStatus: Codable {
    let tier: SubscriptionTier
    let isActive: Bool
    let startDate: Date
    let renewalDate: Date
    let generationsUsedThisMonth: Int
    let familyMemberIds: [String]
    let purchasedPacks: [PremiumCulturalPack]
    let totalSpent: Double

    var generationsRemaining: Int {
        return max(0, tier.monthlyGenerationsIncluded - generationsUsedThisMonth)
    }

    func canAccessCulture(_ culture: CulturalCategory) -> Bool {
        if culture == .hindu { return true } // Always available

        let allowedCultures = tier.culturalContextsAllowed
        return allowedCultures >= 3 || (allowedCultures >= 7 && culture != .hindu)
    }

    func canAccessPremiumPack(_ pack: PremiumCulturalPack) -> Bool {
        guard tier.rawValue >= pack.requiresSubscription.rawValue else { return false }
        return purchasedPacks.contains(pack) || tier.premiumCulturalPacks
    }

    init(tier: SubscriptionTier = .free) {
        self.tier = tier
        self.isActive = tier != .free
        self.startDate = Date()
        self.renewalDate = Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? Date()
        self.generationsUsedThisMonth = 0
        self.familyMemberIds = []
        self.purchasedPacks = []
        self.totalSpent = 0.0
    }
}

// MARK: - Usage Tracking
struct UsageMetrics: Codable {
    let userId: String
    let month: Int
    let year: Int
    let generationsUsed: Int
    let culturesAccessed: [CulturalCategory]
    let packsUsed: [PremiumCulturalPack]
    let totalSpent: Double
    let regenerationsPurchased: Int

    static func current(for userId: String) -> UsageMetrics {
        let now = Date()
        let calendar = Calendar.current

        return UsageMetrics(
            userId: userId,
            month: calendar.component(.month, from: now),
            year: calendar.component(.year, from: now),
            generationsUsed: 0,
            culturesAccessed: [],
            packsUsed: [],
            totalSpent: 0.0,
            regenerationsPurchased: 0
        )
    }
}

// MARK: - Cultural Content Restrictions
struct CulturalContentAccess {
    let subscription: SubscriptionStatus

    func canAccessCulture(_ culture: CulturalCategory) -> Bool {
        return subscription.canAccessCulture(culture)
    }

    func canGenerateWithPack(_ pack: PremiumCulturalPack) -> Bool {
        return subscription.canAccessPremiumPack(pack)
    }

    func canGenerate() -> (allowed: Bool, reason: String?) {
        if subscription.generationsRemaining > 0 {
            return (true, nil)
        }

        let cost = subscription.tier.regenerationCost
        return (false, "Additional generation costs $\(String(format: "%.2f", cost))")
    }

    func culturalGiftsForTier() -> [CulturalGift] {
        let allowedCultures = CulturalCategory.allCases.filter { subscription.canAccessCulture($0) }

        return CulturalGift.allCulturalGifts.filter { gift in
            return allowedCultures.contains(gift.culturalContext)
        }
    }
}

// MARK: - Analytics Period Enum
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

// MARK: - Monthly Report
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

// MARK: - Generation Record
struct GenerationRecord: Identifiable, Codable {
    let id: UUID
    let timestamp: Date
    let culturalContext: CulturalCategory
    let premiumPack: PremiumCulturalPack?
    let giftCategory: CulturalGiftCategory
    let wasRegeneration: Bool
    let cost: Double
}

// MARK: - Daily Usage
struct DailyUsage: Identifiable, Codable {
    var id = UUID()
    let date: Date
    var generationsCount: Int
    var regenerationsCount: Int
    var totalSpent: Double
}

// MARK: - Usage Analytics
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

// MARK: - Permission Types
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

// MARK: - Usage Tracking Service
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

// MARK: - Watch Connectivity Manager
class WatchConnectivityManager: NSObject, ObservableObject {
    static let shared = WatchConnectivityManager()

    @Published var isConnected = false
    @Published var receivedRakhis: [RakhiGiftDelivery] = []

    private override init() {
        super.init()

        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    func sendRakhiToWatch(rakhi: Rakhi, to contact: Contact) {
        guard WCSession.default.isReachable else {
            print("Watch is not reachable")
            return
        }

        let rakhiData: [String: Any] = [
            "type": "rakhi_received",
            "rakhi": [
                "id": rakhi.id.uuidString,
                "name": rakhi.name,
                "imageName": rakhi.imageName,
                "description": rakhi.description,
                "price": rakhi.price,
                "category": rakhi.category.rawValue,
                "colors": rakhi.colors
            ],
            "sender": "You", // This would be the current user's name
            "recipient": contact.name,
            "timestamp": Date().timeIntervalSince1970
        ]

        WCSession.default.sendMessage(rakhiData, replyHandler: { reply in
            print("Rakhi sent successfully: \(reply)")
        }, errorHandler: { error in
            print("Failed to send rakhi: \(error.localizedDescription)")
        })
    }

    func sendRakhiWatchFace(rakhi: Rakhi) {
        guard WCSession.default.isReachable else {
            print("Watch is not reachable")
            return
        }

        let watchFaceData: [String: Any] = [
            "type": "activate_watch_face",
            "rakhi": [
                "id": rakhi.id.uuidString,
                "name": rakhi.name,
                "imageName": rakhi.imageName,
                "colors": rakhi.colors
            ],
            "timestamp": Date().timeIntervalSince1970
        ]

        WCSession.default.sendMessage(watchFaceData, replyHandler: { reply in
            print("Watch face activated: \(reply)")
        }, errorHandler: { error in
            print("Failed to activate watch face: \(error.localizedDescription)")
        })
    }

    func requestPayment(for rakhi: Rakhi, from sender: String) {
        guard WCSession.default.isReachable else {
            print("Watch is not reachable")
            return
        }

        let paymentRequest: [String: Any] = [
            "type": "payment_request",
            "rakhi": [
                "id": rakhi.id.uuidString,
                "name": rakhi.name,
                "price": rakhi.price
            ],
            "sender": sender,
            "timestamp": Date().timeIntervalSince1970
        ]

        WCSession.default.sendMessage(paymentRequest, replyHandler: { reply in
            print("Payment request sent: \(reply)")
        }, errorHandler: { error in
            print("Failed to send payment request: \(error.localizedDescription)")
        })
    }
}

// MARK: - WCSessionDelegate
extension WatchConnectivityManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            self.isConnected = activationState == .activated
        }

        if let error = error {
            print("WC Session activation failed: \(error.localizedDescription)")
        } else {
            print("WC Session activated with state: \(activationState.rawValue)")
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isConnected = false
        }
        print("WC Session became inactive")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isConnected = false
        }
        print("WC Session deactivated")
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        print("Received message from watch: \(message)")

        guard let type = message["type"] as? String else {
            replyHandler(["success": false, "error": "Invalid message type"])
            return
        }

        switch type {
        case "rakhi_tap":
            handleRakhiTap(message: message, replyHandler: replyHandler)
        case "payment_completed":
            handlePaymentCompleted(message: message, replyHandler: replyHandler)
        case "watch_status":
            replyHandler(["success": true, "connected": true])
        default:
            replyHandler(["success": false, "error": "Unknown message type"])
        }
    }

    private func handleRakhiTap(message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        // Handle when user taps on rakhi watch face
        // This would trigger the payment flow

        guard let rakhiData = message["rakhi"] as? [String: Any],
              let rakhiId = rakhiData["id"] as? String,
              let _ = message["sender"] as? String else {
            replyHandler(["success": false, "error": "Invalid rakhi data"])
            return
        }

        // Find the rakhi and trigger payment flow
        if Rakhi.sampleRakhis.first(where: { $0.id.uuidString == rakhiId }) != nil {
            DispatchQueue.main.async {
                // You would present the PaymentReceiveView here
                // For now, we'll just acknowledge
                replyHandler(["success": true, "action": "payment_flow_initiated"])
            }
        } else {
            replyHandler(["success": false, "error": "Rakhi not found"])
        }
    }

    private func handlePaymentCompleted(message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        // Handle payment completion from watch

        guard let paymentData = message["payment"] as? [String: Any],
              let amount = paymentData["amount"] as? Double,
              let rakhiId = paymentData["rakhi_id"] as? String else {
            replyHandler(["success": false, "error": "Invalid payment data"])
            return
        }

        DispatchQueue.main.async {
            // Update UI to reflect payment completion
            // Activate watch face
            print("Payment completed: $\(amount) for rakhi \(rakhiId)")
            replyHandler(["success": true, "watch_face_activated": true])
        }
    }

    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        print("Received application context: \(applicationContext)")

        DispatchQueue.main.async {
            // Handle persistent data updates
            if let rakhisData = applicationContext["received_rakhis"] as? [[String: Any]] {
                // Update received rakhis list
                self.updateReceivedRakhis(from: rakhisData)
            }
        }
    }

    private func updateReceivedRakhis(from data: [[String: Any]]) {
        // Convert received data to RakhiGiftDelivery objects
        // This would be used to sync rakhi gifts between devices
    }
}

// MARK: - Watch Connectivity Helper Extensions
extension WatchConnectivityManager {
    var isWatchAppInstalled: Bool {
        return WCSession.default.isWatchAppInstalled
    }

    var isWatchReachable: Bool {
        return WCSession.default.isReachable
    }

    func sendApplicationContext(_ context: [String: Any]) {
        do {
            try WCSession.default.updateApplicationContext(context)
        } catch {
            print("Failed to send application context: \(error.localizedDescription)")
        }
    }
}

// MARK: - Rakhi Gift Model (for Watch connectivity)
struct RakhiGiftDelivery: Identifiable, Codable {
    let id: UUID
    let rakhiId: UUID
    let senderName: String
    let recipientName: String
    let message: String?
    let timestamp: Date
    let isViewed: Bool
    let paymentAmount: Double?

    init(rakhi: Rakhi, sender: String, recipient: String, message: String? = nil, paymentAmount: Double? = nil) {
        self.id = UUID()
        self.rakhiId = rakhi.id
        self.senderName = sender
        self.recipientName = recipient
        self.message = message
        self.timestamp = Date()
        self.isViewed = false
        self.paymentAmount = paymentAmount
    }
}
