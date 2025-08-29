import SwiftUI

struct OnboardingView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Set up Apple Pay").font(.title2).bold()
            Text("Use Apple Pay to send local cash gifts or Ticketek digital gifts securely.")
                .multilineTextAlignment(.center)
            Button("Verify Apple Pay Availability") {
                PaymentCoordinator.shared.checkAvailability()
            }.buttonStyle(.borderedProminent)
        }.padding()
    }
}
