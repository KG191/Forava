import Foundation
import UIKit

final class TicketekCoordinator {
    static let shared = TicketekCoordinator()
    private init() {}

    func fulfillTicketekVoucher(rakhiId: UUID, amountMinor: Int64) async throws -> TicketekGift {
        try await APIClient.shared.ticketekCreateVoucher(rakhiId: rakhiId, amountMinor: amountMinor)
    }

    func openTicketekDeepLink(_ url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
