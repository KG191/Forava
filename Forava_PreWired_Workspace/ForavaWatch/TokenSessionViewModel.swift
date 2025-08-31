import Foundation
import WatchConnectivity

final class TokenSessionViewModel: ObservableObject {
    @Published var activeToken: RitualToken?
    @Published var amountMinor: Int64 = Constants.defaultAmountPresetsMinor.first ?? 1000
    @Published var kind: GiftKind = .cash
    @Published var statusMessage: String = ""

    init() {
        WatchSessionManagerWatch.shared.activate()
    }

    func loadSample() {
        let now = Date()
        activeToken = RitualToken(
            id: UUID(),
            senderUserId: "sender_123",
            receiverUserId: "receiver_456",
            sentAt: now,
            expiresAt: Calendar.current.date(byAdding: .month, value: 12, to: now)!,
            message: "Always with you ✨",
            designId: "ever_loop"
        )
    }

    func sendGiftRequest() {
        guard let token = activeToken else { return }
        WatchSessionManagerWatch.shared.sendGiftRequest(
            token: token, amountMinor: amountMinor, currency: Constants.defaultCurrency, kind: kind
        ) { success in
            DispatchQueue.main.async {
                self.statusMessage = success ? "Sent to iPhone…" : "Failed to send."
            }
        }
    }
}
