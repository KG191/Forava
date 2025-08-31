import Foundation
import WatchConnectivity
import Combine

// MARK: - Watch to iPhone Rakhi Transfer Service

@MainActor
class WatchToiPhoneTransferService: NSObject, ObservableObject {
    static let shared = WatchToiPhoneTransferService()

    // MARK: - Published Properties
    @Published var isTransferring = false
    @Published var transferProgress: Float = 0.0
    @Published var connectionStatus: ConnectionStatus = .unknown
    @Published var transferHistory: [TransferRecord] = []
    @Published var pendingTransfers: [PendingTransfer] = []

    // MARK: - Private Properties
    private let session = WCSession.default
    private var cancellables = Set<AnyCancellable>()
    private let transferTimeout: TimeInterval = 30.0

    override init() {
        super.init()
        setupWatchConnectivity()
        loadTransferHistory()
    }

    // MARK: - Watch Connectivity Setup

    private func setupWatchConnectivity() {
        guard WCSession.isSupported() else {
            connectionStatus = .notSupported
            return
        }

        session.delegate = self
        session.activate()
    }

    // MARK: - Transfer Operations

    func transferRakhiToiPhone(_ rakhi: WatchRakhiDisplay) async throws {
        guard connectionStatus == .connected else {
            throw TransferError.notConnected
        }

        guard !isTransferring else {
            throw TransferError.transferInProgress
        }

        isTransferring = true
        transferProgress = 0.0

        defer {
            isTransferring = false
            transferProgress = 0.0
        }

        do {
            // Step 1: Prepare transfer data
            transferProgress = 0.2
            let transferData = try await prepareTransferData(for: rakhi)

            // Step 2: Create transfer request
            transferProgress = 0.4
            let transferRequest = createTransferRequest(rakhi: rakhi, data: transferData)

            // Step 3: Add to pending transfers
            transferProgress = 0.6
            let pendingTransfer = PendingTransfer(
                id: UUID(),
                rakhiId: rakhi.id,
                rakhiTitle: rakhi.title,
                startTime: Date(),
                status: .preparing
            )
            pendingTransfers.append(pendingTransfer)

            // Step 4: Send via Watch Connectivity
            transferProgress = 0.8
            try await sendTransferRequest(transferRequest)

            // Step 5: Update status
            transferProgress = 1.0
            updateTransferStatus(pendingTransfer.id, status: .sent)

            // Record successful transfer
            recordTransfer(rakhi: rakhi, success: true)

        } catch {
            // Record failed transfer
            recordTransfer(rakhi: rakhi, success: false, error: error)
            throw error
        }
    }

    func transferMultipleRakhis(_ rakhis: [WatchRakhiDisplay]) async throws {
        guard connectionStatus == .connected else {
            throw TransferError.notConnected
        }

        isTransferring = true
        transferProgress = 0.0

        defer {
            isTransferring = false
            transferProgress = 0.0
        }

        let totalRakhis = rakhis.count
        var successCount = 0
        var errors: [Error] = []

        for (index, rakhi) in rakhis.enumerated() {
            do {
                let transferData = try await prepareTransferData(for: rakhi)
                let transferRequest = createTransferRequest(rakhi: rakhi, data: transferData)

                try await sendTransferRequest(transferRequest)

                successCount += 1
                recordTransfer(rakhi: rakhi, success: true)

            } catch {
                errors.append(error)
                recordTransfer(rakhi: rakhi, success: false, error: error)
            }

            // Update progress
            transferProgress = Float(index + 1) / Float(totalRakhis)
        }

        if !errors.isEmpty && successCount == 0 {
            throw TransferError.allTransfersFailed(errors)
        } else if !errors.isEmpty {
            throw TransferError.partialTransferFailure(successCount, errors)
        }
    }

    // MARK: - Transfer Data Preparation

    private func prepareTransferData(for rakhi: WatchRakhiDisplay) async throws -> TransferData {
        // Prepare comprehensive data for iPhone
        let rakhiData = RakhiTransferPayload(
            id: rakhi.id,
            title: rakhi.title,
            culturalScore: rakhi.culturalScore,
            colors: rakhi.colors,
            culturalElements: rakhi.culturalElements,
            createdAt: rakhi.createdAt,
            transferredFromWatch: true,
            watchOptimized: rakhi.watchOptimized
        )

        // Include metadata
        let metadata = TransferMetadata(
            sourceDevice: .appleWatch,
            transferTime: Date(),
            watchCapabilities: EnhancedRakhiWatchDisplayService.shared.watchCapabilities,
            compressionUsed: true,
            version: "1.0"
        )

        // Include image data if available
        let imageData: Data?
        if let optimizedImage = try? await processRakhiImage(rakhi) {
            imageData = optimizedImage
        } else {
            imageData = nil
        }

        return TransferData(
            rakhi: rakhiData,
            metadata: metadata,
            imageData: imageData,
            checksum: calculateChecksum(rakhiData)
        )
    }

    private func processRakhiImage(_ rakhi: WatchRakhiDisplay) async throws -> Data? {
        // In production, this would process the actual image data
        // For now, return placeholder compressed data
        return rakhi.optimizedImage.thumbnailData.isEmpty ? nil : rakhi.optimizedImage.thumbnailData
    }

    private func calculateChecksum(_ payload: RakhiTransferPayload) -> String {
        // Simple checksum for data integrity
        let dataString = "\(payload.id.uuidString)\(payload.title)\(payload.culturalScore)"
        return String(dataString.hashValue)
    }

    private func createTransferRequest(rakhi: WatchRakhiDisplay, data: TransferData) -> TransferRequest {
        return TransferRequest(
            id: UUID(),
            type: .rakhiTransfer,
            payload: data,
            priority: .normal,
            requiresResponse: true,
            timeout: transferTimeout
        )
    }

    // MARK: - Communication with iPhone

    private func sendTransferRequest(_ request: TransferRequest) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            guard session.isReachable else {
                continuation.resume(throwing: TransferError.iPhoneNotReachable)
                return
            }

            do {
                let requestData = try JSONEncoder().encode(request)
                let message = ["transfer_request": requestData]

                session.sendMessage(message, replyHandler: { response in
                    if let success = response["success"] as? Bool, success {
                        continuation.resume()
                    } else {
                        let errorMessage = response["error"] as? String ?? "Unknown error"
                        continuation.resume(throwing: TransferError.transferFailed(errorMessage))
                    }
                }, errorHandler: { error in
                    continuation.resume(throwing: TransferError.communicationFailed(error))
                })

                // Set timeout
                DispatchQueue.main.asyncAfter(deadline: .now() + transferTimeout) {
                    continuation.resume(throwing: TransferError.timeout)
                }

            } catch {
                continuation.resume(throwing: TransferError.encodingFailed(error))
            }
        }
    }

    func requestiPhoneConnection() async throws {
        guard WCSession.isSupported() else {
            throw TransferError.notSupported
        }

        return try await withCheckedThrowingContinuation { continuation in
            let message = ["action": "ping", "timestamp": Date().timeIntervalSince1970] as [String: Any]

            session.sendMessage(message, replyHandler: { response in
                if response["pong"] != nil {
                    continuation.resume()
                } else {
                    continuation.resume(throwing: TransferError.connectionFailed)
                }
            }, errorHandler: { error in
                continuation.resume(throwing: TransferError.communicationFailed(error))
            })
        }
    }

    // MARK: - Transfer Status Management

    private func updateTransferStatus(_ transferId: UUID, status: TransferStatus) {
        if let index = pendingTransfers.firstIndex(where: { $0.id == transferId }) {
            pendingTransfers[index].status = status

            // Remove completed transfers after delay
            if status == .completed || status == .failed {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    self.pendingTransfers.removeAll { $0.id == transferId }
                }
            }
        }
    }

    private func recordTransfer(rakhi: WatchRakhiDisplay, success: Bool, error: Error? = nil) {
        let record = TransferRecord(
            id: UUID(),
            rakhiId: rakhi.id,
            rakhiTitle: rakhi.title,
            success: success,
            timestamp: Date(),
            errorMessage: error?.localizedDescription,
            transferSize: estimateTransferSize(rakhi),
            duration: 0.0 // Would be calculated in real implementation
        )

        transferHistory.append(record)
        saveTransferHistory()

        // Limit history size
        if transferHistory.count > 50 {
            transferHistory = Array(transferHistory.suffix(50))
        }
    }

    private func estimateTransferSize(_ rakhi: WatchRakhiDisplay) -> Int {
        // Estimate transfer size in bytes
        var size = 1024 // Base rakhi data
        size += rakhi.optimizedImage.thumbnailData.count
        size += rakhi.culturalElements.count * 100
        return size
    }

    // MARK: - Transfer Queue Management

    func cancelTransfer(_ transferId: UUID) {
        updateTransferStatus(transferId, status: .cancelled)
    }

    func retryFailedTransfer(_ transferId: UUID) async throws {
        guard let transfer = pendingTransfers.first(where: { $0.id == transferId && $0.status == .failed }),
              let rakhi = EnhancedRakhiWatchDisplayService.shared.displayedRakhis.first(where: { $0.id == transfer.rakhiId }) else {
            throw TransferError.transferNotFound
        }

        // Remove the failed transfer
        pendingTransfers.removeAll { $0.id == transferId }

        // Retry the transfer
        try await transferRakhiToiPhone(rakhi)
    }

    func clearTransferHistory() {
        transferHistory.removeAll()
        saveTransferHistory()
    }

    // MARK: - Smart Transfer Features

    func getTransferRecommendations() -> [TransferRecommendation] {
        var recommendations: [TransferRecommendation] = []

        let displayedRakhis = EnhancedRakhiWatchDisplayService.shared.displayedRakhis
        let recentlyTransferred = Set(transferHistory.filter {
            Date().timeIntervalSince($0.timestamp) < 3600 // Last hour
        }.map { $0.rakhiId })

        // Recommend high-scoring rakhis not recently transferred
        let highScoringRakhis = displayedRakhis.filter { rakhi in
            rakhi.culturalScore > 0.8 && !recentlyTransferred.contains(rakhi.id)
        }

        for rakhi in highScoringRakhis {
            recommendations.append(TransferRecommendation(
                rakhi: rakhi,
                reason: .highCulturalScore,
                priority: .high
            ))
        }

        // Recommend favorites
        let favoriteRakhis = displayedRakhis.filter { rakhi in
            !recentlyTransferred.contains(rakhi.id)
            // Would check if rakhi is marked as favorite
        }

        for rakhi in favoriteRakhis {
            recommendations.append(TransferRecommendation(
                rakhi: rakhi,
                reason: .favorite,
                priority: .medium
            ))
        }

        return recommendations.sorted { $0.priority.rawValue > $1.priority.rawValue }
    }

    func scheduleAutomaticTransfer(_ rakhi: WatchRakhiDisplay, delay: TimeInterval = 60.0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            Task {
                try? await self.transferRakhiToiPhone(rakhi)
            }
        }
    }

    // MARK: - Data Persistence

    private func loadTransferHistory() {
        if let data = UserDefaults.standard.data(forKey: "transfer_history"),
           let history = try? JSONDecoder().decode([TransferRecord].self, from: data) {
            transferHistory = history
        }
    }

    private func saveTransferHistory() {
        if let data = try? JSONEncoder().encode(transferHistory) {
            UserDefaults.standard.set(data, forKey: "transfer_history")
        }
    }
}

// MARK: - WCSessionDelegate

extension WatchToiPhoneTransferService: WCSessionDelegate {
    nonisolated func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            switch activationState {
            case .activated:
                if session.isReachable {
                    self.connectionStatus = .connected
                } else {
                    self.connectionStatus = .paired
                }
            case .notActivated:
                self.connectionStatus = .notActivated
            case .inactive:
                self.connectionStatus = .inactive
            @unknown default:
                self.connectionStatus = .unknown
            }
        }
    }

    nonisolated func sessionReachabilityDidChange(_ session: WCSession) {
        DispatchQueue.main.async {
            self.connectionStatus = session.isReachable ? .connected : .paired
        }
    }

    nonisolated func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        // Handle messages from iPhone
        DispatchQueue.main.async {
            self.handleiPhoneMessage(message, replyHandler: replyHandler)
        }
    }

    private func handleiPhoneMessage(_ message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        if message["action"] as? String == "ping" {
            replyHandler(["pong": true, "timestamp": Date().timeIntervalSince1970])
        }

        // Handle other message types as needed
    }
}

// MARK: - Supporting Types

enum ConnectionStatus {
    case unknown
    case notSupported
    case notActivated
    case inactive
    case paired
    case connected

    var displayName: String {
        switch self {
        case .unknown: return "Unknown"
        case .notSupported: return "Not Supported"
        case .notActivated: return "Not Activated"
        case .inactive: return "Inactive"
        case .paired: return "Paired"
        case .connected: return "Connected"
        }
    }

    var canTransfer: Bool {
        return self == .connected
    }
}

struct TransferData: Codable {
    let rakhi: RakhiTransferPayload
    let metadata: TransferMetadata
    let imageData: Data?
    let checksum: String
}

struct RakhiTransferPayload: Codable {
    let id: UUID
    let title: String
    let culturalScore: Double
    let colors: [Color]
    let culturalElements: [WatchCulturalElement]
    let createdAt: Date
    let transferredFromWatch: Bool
    let watchOptimized: Bool
}

struct TransferMetadata: Codable {
    let sourceDevice: SourceDevice
    let transferTime: Date
    let watchCapabilities: WatchCapabilities
    let compressionUsed: Bool
    let version: String

    enum SourceDevice: String, Codable {
        case appleWatch = "Apple Watch"
        case iPhone = "iPhone"
    }
}

struct TransferRequest: Codable {
    let id: UUID
    let type: RequestType
    let payload: TransferData
    let priority: Priority
    let requiresResponse: Bool
    let timeout: TimeInterval

    enum RequestType: String, Codable {
        case rakhiTransfer = "rakhi_transfer"
        case statusUpdate = "status_update"
        case bulkTransfer = "bulk_transfer"
    }

    enum Priority: Int, Codable {
        case low = 1
        case normal = 2
        case high = 3
        case urgent = 4
    }
}

struct PendingTransfer: Identifiable {
    let id: UUID
    let rakhiId: UUID
    let rakhiTitle: String
    let startTime: Date
    var status: TransferStatus
}

enum TransferStatus {
    case preparing
    case sending
    case sent
    case completed
    case failed
    case cancelled

    var displayName: String {
        switch self {
        case .preparing: return "Preparing"
        case .sending: return "Sending"
        case .sent: return "Sent"
        case .completed: return "Completed"
        case .failed: return "Failed"
        case .cancelled: return "Cancelled"
        }
    }
}

struct TransferRecord: Identifiable, Codable {
    let id: UUID
    let rakhiId: UUID
    let rakhiTitle: String
    let success: Bool
    let timestamp: Date
    let errorMessage: String?
    let transferSize: Int
    let duration: TimeInterval
}

struct TransferRecommendation: Identifiable {
    let id = UUID()
    let rakhi: WatchRakhiDisplay
    let reason: RecommendationReason
    let priority: RecommendationPriority

    enum RecommendationReason {
        case highCulturalScore
        case favorite
        case recentlyCreated
        case notTransferred

        var displayText: String {
            switch self {
            case .highCulturalScore: return "High cultural score"
            case .favorite: return "Marked as favorite"
            case .recentlyCreated: return "Recently created"
            case .notTransferred: return "Not yet transferred"
            }
        }
    }

    enum RecommendationPriority: Int {
        case low = 1
        case medium = 2
        case high = 3
    }
}

enum TransferError: LocalizedError {
    case notSupported
    case notConnected
    case iPhoneNotReachable
    case transferInProgress
    case transferNotFound
    case connectionFailed
    case communicationFailed(Error)
    case encodingFailed(Error)
    case transferFailed(String)
    case timeout
    case allTransfersFailed([Error])
    case partialTransferFailure(Int, [Error])

    var errorDescription: String? {
        switch self {
        case .notSupported:
            return "Watch Connectivity not supported on this device"
        case .notConnected:
            return "iPhone not connected. Please ensure your iPhone is nearby."
        case .iPhoneNotReachable:
            return "iPhone is not reachable. Check connection and try again."
        case .transferInProgress:
            return "Another transfer is already in progress"
        case .transferNotFound:
            return "Transfer not found"
        case .connectionFailed:
            return "Failed to establish connection with iPhone"
        case .communicationFailed(let error):
            return "Communication failed: \(error.localizedDescription)"
        case .encodingFailed(let error):
            return "Data encoding failed: \(error.localizedDescription)"
        case .transferFailed(let message):
            return "Transfer failed: \(message)"
        case .timeout:
            return "Transfer timed out. Please try again."
        case .allTransfersFailed:
            return "All transfers failed"
        case .partialTransferFailure(let successCount, _):
            return "Partial transfer failure. \(successCount) items transferred successfully."
        }
    }
}
