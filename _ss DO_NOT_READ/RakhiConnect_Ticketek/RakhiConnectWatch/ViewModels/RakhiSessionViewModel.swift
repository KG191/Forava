import Foundation

final class RakhiSessionViewModel: ObservableObject {
    @Published var activeRakhi: Rakhi?
    @Published var amountMinor: Int64 = Constants.defaultAmountPresetsMinor.first ?? 1000
    @Published var kind: GiftKind = .cash
    @Published var statusMessage: String = ""

    func loadSample() {
        let now = Date()
        activeRakhi = Rakhi(
            id: UUID(),
            senderUserId: "sister_123",
            receiverUserId: "brother_456",
            sentAt: now,
            expiresAt: Calendar.current.date(byAdding: .month, value: 12, to: now)!,
            message: "With love and protection ✨",
            designId: "classic_kalp"
        )
    }

    func sendGiftRequest() {
        guard let r = activeRakhi else { return }
        WatchSessionManager_Watch.shared.sendGiftRequest(
            rakhi: r, amountMinor: amountMinor, currency: Constants.defaultCurrency, kind: kind
        ) { success in
            DispatchQueue.main.async {
                self.statusMessage = success ? "Sent to iPhone…" : "Failed to send."
            }
        }
    }
}
