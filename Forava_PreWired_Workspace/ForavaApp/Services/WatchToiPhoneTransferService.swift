import Foundation
import WatchConnectivity

class WatchToiPhoneTransferService: NSObject, ObservableObject {
    static let shared = WatchToiPhoneTransferService()
    
    @Published var isReady = false
    @Published var transferInProgress = false
    private var session: WCSession?
    
    override init() {
        super.init()
        setupWatchConnectivity()
    }
    
    private func setupWatchConnectivity() {
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
    
    func sendRakhi(_ rakhi: WatchRakhiDisplay) async throws {
        guard let session = session, session.isReachable else {
            throw TransferError.watchNotReachable
        }
        
        transferInProgress = true
        
        do {
            let data = try JSONEncoder().encode(rakhi)
            let transfer = WatchToiPhoneTransfer(
                id: rakhi.id,
                timestamp: Date(),
                transferType: .rakhi,
                data: data,
                metadata: [:]
            )
            
            try await session.sendMessageData(data, replyHandler: nil)
            transferInProgress = false
        } catch {
            transferInProgress = false
            throw TransferError.transferFailed(error)
        }
    }
    
    enum TransferError: Error {
        case watchNotReachable
        case transferFailed(Error)
        case invalidData
    }
}

extension WatchToiPhoneTransferService: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            self.isReady = activationState == .activated
        }
    }
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    #endif
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        do {
            let transfer = try JSONDecoder().decode(WatchToiPhoneTransfer.self, from: messageData)
            handleTransfer(transfer)
        } catch {
            print("Failed to decode transfer: \(error)")
        }
    }
    
    private func handleTransfer(_ transfer: WatchToiPhoneTransfer) {
        switch transfer.transferType {
        case .rakhi:
            handleRakhiTransfer(transfer)
        case .payment:
            handlePaymentTransfer(transfer)
        case .animation:
            handleAnimationTransfer(transfer)
        case .other:
            break
        }
    }
    
    private func handleRakhiTransfer(_ transfer: WatchToiPhoneTransfer) {
        do {
            let rakhi = try JSONDecoder().decode(WatchRakhiDisplay.self, from: transfer.data)
            // Handle the received rakhi display
            print("Received rakhi display: \(rakhi.id)")
        } catch {
            print("Failed to decode rakhi: \(error)")
        }
    }
    
    private func handlePaymentTransfer(_ transfer: WatchToiPhoneTransfer) {
        // Handle payment transfer
    }
    
    private func handleAnimationTransfer(_ transfer: WatchToiPhoneTransfer) {
        // Handle animation transfer
    }
}
