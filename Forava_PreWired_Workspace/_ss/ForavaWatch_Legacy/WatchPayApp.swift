import SwiftUI

@main
struct WatchPayApp: App {
    @StateObject private var applePayManager = ApplePayManager()

    var body: some Scene {
        WindowGroup {
            PayPosterView()
                .environmentObject(applePayManager)
                .onOpenURL { url in
                    print("[WATCH APP] Received URL: \(url)")
                    ApplePayDeepLinkRouter.handle(url: url, manager: applePayManager)
                }
                .onAppear {
                    print("[WATCH APP] Forava Watch app launched")
                }
        }
    }
}

// MARK: - Watch App Extensions
extension WatchPayApp {
    /// Handle notification-based payment requests
    func handlePaymentNotification(_ userInfo: [String: Any]) {
        guard let amountString = userInfo["amount"] as? String,
              let amount = Decimal(string: amountString),
              let description = userInfo["description"] as? String else {
            return
        }

        applePayManager.presentApplePay(amount: amount, description: description)
    }

    /// Handle background app refresh with payment context
    func handleBackgroundRefresh() {
        // Could be used to update payment contexts or cached data
        print("[WATCH APP] Background refresh triggered")
    }
}
