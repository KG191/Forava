import WatchConnectivity
import Foundation
import SwiftUI

@MainActor
class WatchSyncManager: NSObject, ObservableObject {
    static let shared = WatchSyncManager()

    @Published var syncStatus: SyncStatus = .disconnected
    @Published var lastSyncTime: Date?
    @Published var pendingSyncItems: [SyncItem] = []
    @Published var culturalGifts: [WatchCulturalGift] = []
    @Published var paymentUpdates: [PaymentUpdate] = []

    private var session: WCSession?
    private let hapticManager = WatchHapticManager.shared
    private let displayService = EnhancedRakhiWatchDisplayService.shared

    enum SyncStatus {
        case disconnected
        case connecting
        case connected
        case syncing
        case error(String)
    }

    enum SyncItem {
        case culturalGift(WatchCulturalGift)
        case paymentUpdate(PaymentUpdate)
        case userPreference(String, Any)
        case displaySettings(WatchDisplaySettings)
    }

    struct PaymentUpdate {
        let id: UUID
        let giftId: UUID
        let status: PaymentStatus
        let amount: Decimal?
        let timestamp: Date
        let gratitudeMessage: String?

        enum PaymentStatus {
            case initiated
            case processing
            case completed
            case failed
            case cancelled
        }
    }

    private override init() {
        super.init()
        setupWatchConnectivity()
        loadStoredData()
    }

    // MARK: - Setup

    private func setupWatchConnectivity() {
        guard WCSession.isSupported() else {
            syncStatus = .error("WatchConnectivity not supported")
            return
        }

        session = WCSession.default
        session?.delegate = self
        session?.activate()

        updateConnectionStatus()
    }

    private func updateConnectionStatus() {
        guard let session = session else {
            syncStatus = .disconnected
            return
        }

        if session.isReachable {
            syncStatus = .connected
        } else if session.isPaired {
            syncStatus = .connecting
        } else {
            syncStatus = .disconnected
        }
    }

    // MARK: - Sync Operations

    func requestFullSync() async {
        guard syncStatus == .connected else { return }

        syncStatus = .syncing

        let syncRequest: [String: Any] = [
            "action": "full_sync_request",
            "last_sync": lastSyncTime?.timeIntervalSince1970 ?? 0,
            "watch_capabilities": getWatchCapabilities(),
            "timestamp": Date().timeIntervalSince1970
        ]

        do {
            let response = try await sendMessage(syncRequest)
            await handleSyncResponse(response)
            lastSyncTime = Date()
            syncStatus = .connected
        } catch {
            syncStatus = .error(error.localizedDescription)
        }
    }

    func syncCulturalGift(_ gift: WatchCulturalGift) {
        let giftData: [String: Any] = [
            "action": "sync_cultural_gift",
            "gift_id": gift.id.uuidString,
            "cultural_context": gift.culturalContext,
            "occasion": gift.occasion,
            "cultural_score": gift.culturalScore,
            "sender_name": gift.senderName,
            "recipient_name": gift.recipientName,
            "created_at": gift.createdAt.timeIntervalSince1970,
            "primary_colors": gift.primaryColors.map { colorToDict($0) },
            "cultural_elements": gift.culturalElements.map { elementToDict($0) }
        ]

        sendMessageAsync(giftData)
        addToPendingSync(.culturalGift(gift))
    }

    func syncPaymentUpdate(_ update: PaymentUpdate) {
        let updateData: [String: Any] = [
            "action": "sync_payment_update",
            "update_id": update.id.uuidString,
            "gift_id": update.giftId.uuidString,
            "status": paymentStatusToString(update.status),
            "amount": update.amount.map { NSDecimalNumber(decimal: $0).doubleValue },
            "timestamp": update.timestamp.timeIntervalSince1970,
            "gratitude_message": update.gratitudeMessage
        ].compactMapValues { $0 }

        sendMessageAsync(updateData)
        addToPendingSync(.paymentUpdate(update))

        // Update local payment updates
        paymentUpdates.append(update)
        savePaymentUpdates()
    }

    func syncUserPreferences() {
        let preferences: [String: Any] = [
            "action": "sync_user_preferences",
            "display_mode": displayService.displayMode.rawValue,
            "battery_optimization": displayService.batteryOptimizationEnabled,
            "animations_enabled": displayService.watchDisplaySettings.animationsEnabled,
            "haptic_enabled": true, // Haptics are always enabled on watch
            "timestamp": Date().timeIntervalSince1970
        ]

        sendMessageAsync(preferences)
    }

    // MARK: - Message Handling

    private func sendMessage(_ message: [String: Any]) async throws -> [String: Any] {
        guard let session = session, session.isReachable else {
            throw SyncError.notReachable
        }

        return try await withCheckedThrowingContinuation { continuation in
            session.sendMessage(message) { response in
                continuation.resume(returning: response)
            } errorHandler: { error in
                continuation.resume(throwing: error)
            }
        }
    }

    private func sendMessageAsync(_ message: [String: Any]) {
        guard let session = session, session.isReachable else {
            addToPendingSync(.userPreference("message", message))
            return
        }

        session.sendMessage(message, replyHandler: { response in
            Task { @MainActor in
                await self.handleAsyncResponse(response)
            }
        }) { error in
            print("❌ Watch sync error: \(error.localizedDescription)")
        }
    }

    private func handleSyncResponse(_ response: [String: Any]) async {
        guard let action = response["action"] as? String else { return }

        switch action {
        case "sync_data":
            await processSyncData(response)
        case "payment_status_update":
            await processPaymentStatusUpdate(response)
        case "cultural_gifts_update":
            await processCulturalGiftsUpdate(response)
        default:
            print("Unknown sync response action: \(action)")
        }
    }

    private func handleAsyncResponse(_ response: [String: Any]) async {
        await handleSyncResponse(response)

        // Mark corresponding pending sync item as completed
        if let messageId = response["message_id"] as? String {
            removePendingSyncItem(withId: messageId)
        }
    }

    // MARK: - Data Processing

    private func processSyncData(_ data: [String: Any]) async {
        // Process cultural gifts
        if let giftsData = data["cultural_gifts"] as? [[String: Any]] {
            let newGifts = giftsData.compactMap { dictToWatchCulturalGift($0) }
            culturalGifts = newGifts
            saveCulturalGifts()

            // Update display service with new gifts
            for gift in newGifts {
                let watchDisplay = convertToWatchRakhiDisplay(gift)
                await displayService.addRakhiToWatch(convertToGeneratedRakhi(watchDisplay))
            }

            hapticManager.playHaptic(.success)
        }

        // Process payment updates
        if let paymentsData = data["payment_updates"] as? [[String: Any]] {
            let newPayments = paymentsData.compactMap { dictToPaymentUpdate($0) }

            for payment in newPayments {
                if !paymentUpdates.contains(where: { $0.id == payment.id }) {
                    paymentUpdates.append(payment)

                    // Notify payment manager of update
                    await WatchPaymentManager.shared.handlePaymentResponse([
                        "success": payment.status == .completed,
                        "transaction_id": payment.id.uuidString,
                        "error": payment.status == .failed ? "Payment failed" : nil,
                        "amount": payment.amount.map { NSDecimalNumber(decimal: $0).doubleValue }
                    ].compactMapValues { $0 })

                    if payment.status == .completed {
                        hapticManager.playPaymentCompleted()
                    }
                }
            }

            savePaymentUpdates()
        }

        // Clear completed pending sync items
        clearCompletedPendingItems()
    }

    private func processPaymentStatusUpdate(_ data: [String: Any]) async {
        guard let updateDict = data["payment_update"] as? [String: Any],
              let update = dictToPaymentUpdate(updateDict) else { return }

        // Update or add payment update
        if let index = paymentUpdates.firstIndex(where: { $0.id == update.id }) {
            paymentUpdates[index] = update
        } else {
            paymentUpdates.append(update)
        }

        savePaymentUpdates()

        // Provide haptic feedback
        switch update.status {
        case .completed:
            hapticManager.playPaymentCompleted()
        case .failed:
            hapticManager.playHaptic(.failure)
        case .processing:
            hapticManager.playHaptic(.start)
        default:
            hapticManager.playHaptic(.selection)
        }
    }

    private func processCulturalGiftsUpdate(_ data: [String: Any]) async {
        guard let newGiftDict = data["cultural_gift"] as? [String: Any],
              let newGift = dictToWatchCulturalGift(newGiftDict) else { return }

        // Add or update cultural gift
        if let index = culturalGifts.firstIndex(where: { $0.id == newGift.id }) {
            culturalGifts[index] = newGift
        } else {
            culturalGifts.append(newGift)
            hapticManager.playRakhiReceived()
        }

        saveCulturalGifts()

        // Update display service
        let watchDisplay = convertToWatchRakhiDisplay(newGift)
        await displayService.addRakhiToWatch(convertToGeneratedRakhi(watchDisplay))
    }

    // MARK: - Offline Support

    func enableOfflineMode() {
        // Save current state for offline access
        saveCulturalGifts()
        savePaymentUpdates()
        saveDisplaySettings()

        // Mark as offline
        syncStatus = .disconnected
    }

    func processOfflineQueue() async {
        guard syncStatus == .connected else { return }

        // Process all pending sync items
        for item in pendingSyncItems {
            await processPendingSyncItem(item)
        }

        pendingSyncItems.removeAll()
        savePendingSyncItems()
    }

    private func processPendingSyncItem(_ item: SyncItem) async {
        switch item {
        case .culturalGift(let gift):
            syncCulturalGift(gift)
        case .paymentUpdate(let update):
            syncPaymentUpdate(update)
        case .userPreference(let key, let value):
            syncUserPreferences()
        case .displaySettings:
            syncUserPreferences()
        }
    }

    // MARK: - Data Persistence

    private func loadStoredData() {
        loadCulturalGifts()
        loadPaymentUpdates()
        loadPendingSyncItems()
        loadLastSyncTime()
    }

    private func saveCulturalGifts() {
        if let data = try? JSONEncoder().encode(culturalGifts) {
            UserDefaults.standard.set(data, forKey: "cultural_gifts")
        }
    }

    private func loadCulturalGifts() {
        if let data = UserDefaults.standard.data(forKey: "cultural_gifts"),
           let gifts = try? JSONDecoder().decode([WatchCulturalGift].self, from: data) {
            culturalGifts = gifts
        }
    }

    private func savePaymentUpdates() {
        if let data = try? JSONEncoder().encode(paymentUpdates) {
            UserDefaults.standard.set(data, forKey: "payment_updates")
        }
    }

    private func loadPaymentUpdates() {
        if let data = UserDefaults.standard.data(forKey: "payment_updates"),
           let updates = try? JSONDecoder().decode([PaymentUpdate].self, from: data) {
            paymentUpdates = updates
        }
    }

    private func saveDisplaySettings() {
        let settings = displayService.watchDisplaySettings
        if let data = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(data, forKey: "display_settings")
        }
    }

    private func savePendingSyncItems() {
        // Save simplified version of pending items
        UserDefaults.standard.set(pendingSyncItems.count, forKey: "pending_sync_count")
    }

    private func loadPendingSyncItems() {
        let count = UserDefaults.standard.integer(forKey: "pending_sync_count")
        // In a real implementation, we'd restore the actual pending items
        print("📱 Loaded \(count) pending sync items")
    }

    private func loadLastSyncTime() {
        let timestamp = UserDefaults.standard.double(forKey: "last_sync_time")
        if timestamp > 0 {
            lastSyncTime = Date(timeIntervalSince1970: timestamp)
        }
    }

    private func saveLastSyncTime() {
        if let syncTime = lastSyncTime {
            UserDefaults.standard.set(syncTime.timeIntervalSince1970, forKey: "last_sync_time")
        }
    }

    // MARK: - Helper Methods

    private func addToPendingSync(_ item: SyncItem) {
        pendingSyncItems.append(item)
        savePendingSyncItems()
    }

    private func removePendingSyncItem(withId id: String) {
        // In a real implementation, we'd match items by ID
        if !pendingSyncItems.isEmpty {
            pendingSyncItems.removeFirst()
            savePendingSyncItems()
        }
    }

    private func clearCompletedPendingItems() {
        pendingSyncItems.removeAll()
        savePendingSyncItems()
    }

    private func getWatchCapabilities() -> [String: Any] {
        let capabilities = WatchCapabilities.current
        return [
            "screen_size": ["width": capabilities.screenSize.width, "height": capabilities.screenSize.height],
            "supports_complications": capabilities.supportsComplications,
            "supports_always_on": capabilities.supportsAlwaysOn,
            "battery_capacity": capabilities.batteryCapacity == .large ? "large" : "standard",
            "processing_power": capabilities.processingPower == .high ? "high" : "standard"
        ]
    }

    // MARK: - Conversion Helpers

    private func colorToDict(_ color: Color) -> [String: Double] {
        // Simplified color conversion
        return ["r": 0.5, "g": 0.5, "b": 0.5, "a": 1.0]
    }

    private func elementToDict(_ element: WatchCulturalElement) -> [String: Any] {
        return [
            "name": element.name,
            "significance": element.significance,
            "category": element.category.rawValue
        ]
    }

    private func paymentStatusToString(_ status: PaymentUpdate.PaymentStatus) -> String {
        switch status {
        case .initiated: return "initiated"
        case .processing: return "processing"
        case .completed: return "completed"
        case .failed: return "failed"
        case .cancelled: return "cancelled"
        }
    }

    private func dictToWatchCulturalGift(_ dict: [String: Any]) -> WatchCulturalGift? {
        guard let idString = dict["gift_id"] as? String,
              let id = UUID(uuidString: idString),
              let culturalContext = dict["cultural_context"] as? String,
              let occasion = dict["occasion"] as? String,
              let culturalScore = dict["cultural_score"] as? Double,
              let senderName = dict["sender_name"] as? String,
              let recipientName = dict["recipient_name"] as? String,
              let createdAtTimestamp = dict["created_at"] as? TimeInterval else {
            return nil
        }

        return WatchCulturalGift(
            id: id,
            culturalContext: culturalContext,
            occasion: occasion,
            culturalScore: culturalScore,
            primaryColors: [.orange, .red], // Simplified
            culturalElements: [],
            createdAt: Date(timeIntervalSince1970: createdAtTimestamp),
            senderName: senderName,
            recipientName: recipientName
        )
    }

    private func dictToPaymentUpdate(_ dict: [String: Any]) -> PaymentUpdate? {
        guard let idString = dict["update_id"] as? String,
              let id = UUID(uuidString: idString),
              let giftIdString = dict["gift_id"] as? String,
              let giftId = UUID(uuidString: giftIdString),
              let statusString = dict["status"] as? String,
              let timestamp = dict["timestamp"] as? TimeInterval else {
            return nil
        }

        let status: PaymentUpdate.PaymentStatus
        switch statusString {
        case "initiated": status = .initiated
        case "processing": status = .processing
        case "completed": status = .completed
        case "failed": status = .failed
        case "cancelled": status = .cancelled
        default: status = .failed
        }

        let amount = dict["amount"] as? Double
        let gratitudeMessage = dict["gratitude_message"] as? String

        return PaymentUpdate(
            id: id,
            giftId: giftId,
            status: status,
            amount: amount.map { Decimal($0) },
            timestamp: Date(timeIntervalSince1970: timestamp),
            gratitudeMessage: gratitudeMessage
        )
    }

    private func convertToWatchRakhiDisplay(_ gift: WatchCulturalGift) -> WatchRakhiDisplay {
        return WatchRakhiDisplay(
            id: gift.id,
            title: "\(gift.occasion) • from \(gift.senderName)",
            optimizedImage: WatchOptimizedImage(
                thumbnailData: Data(),
                displaySize: CGSize(width: 40, height: 40),
                compressionQuality: 0.8,
                optimizedForBattery: true
            ),
            culturalScore: gift.culturalScore,
            colors: gift.primaryColors,
            culturalElements: gift.culturalElements,
            createdAt: gift.createdAt,
            animation: nil,
            watchOptimized: true
        )
    }

    private func convertToGeneratedRakhi(_ display: WatchRakhiDisplay) -> GeneratedRakhi {
        // This is a placeholder conversion - in reality this would be more complex
        // For now, return a mock GeneratedRakhi that satisfies the EnhancedRakhiWatchDisplayService requirement
        return GeneratedRakhi(
            id: display.id,
            designSpec: RakhiDesignSpec(
                genre: .traditional,
                colorPalette: ColorPalette(name: "Default", colors: display.colors, isDefault: true),
                elements: [],
                culturalElements: [],
                personalization: RakhiPersonalization(message: "", occasion: "", recipientAge: .adult)
            ),
            mainImage: AIImageResult(
                imageData: Data(),
                prompt: "Traditional Rakhi",
                quality: 0.8,
                culturalScore: display.culturalScore,
                generatedAt: display.createdAt
            ),
            culturalScore: display.culturalScore,
            qualityScore: 8.0,
            createdAt: display.createdAt,
            variations: []
        )
    }
}

// MARK: - WCSessionDelegate

extension WatchSyncManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            if let error = error {
                self.syncStatus = .error(error.localizedDescription)
            } else {
                self.updateConnectionStatus()
                // Request initial sync
                Task {
                    await self.requestFullSync()
                }
            }
        }
    }

    func sessionReachabilityDidChange(_ session: WCSession) {
        DispatchQueue.main.async {
            self.updateConnectionStatus()

            if session.isReachable {
                // Process offline queue
                Task {
                    await self.processOfflineQueue()
                }
            }
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        Task { @MainActor in
            await handleSyncResponse(message)
            replyHandler(["status": "received"])
        }
    }

    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any]) {
        Task { @MainActor in
            await handleSyncResponse(userInfo)
        }
    }
}

// MARK: - Codable Extensions

extension WatchCulturalGift: Codable {
    // Custom coding keys to handle Color encoding
}

extension WatchSyncManager.PaymentUpdate: Codable {
    // Custom coding to handle Decimal encoding
}

enum SyncError: Error {
    case notReachable
    case invalidData
    case syncFailed(String)
}

// Color.Codable extension is already defined in EnhancedRakhiWatchDisplayService
