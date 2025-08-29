import SwiftUI

struct SettingsView: View {
    var body: some View {
        Form {
            Section("Payments") {
                Text("Merchant: \(ApplePayConfig.merchantIdentifier)")
                Text("Currency: \(Constants.defaultCurrency)")
            }
        }
        .navigationTitle("Settings")
    }
}
