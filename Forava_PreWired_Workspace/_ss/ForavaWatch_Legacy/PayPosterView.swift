import SwiftUI
import WatchKit

struct PayPosterView: View {
    @EnvironmentObject private var payManager: ApplePayManager
    @State private var showingPaymentResult = false
    @State private var lastPaymentInfo: PaymentInfo?

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background with Forava branding
                backgroundView(geometry: geometry)

                // Payment interface overlay
                if payManager.isProcessing {
                    processingOverlay
                } else {
                    paymentInterface(geometry: geometry)
                }
            }
        }
        .accessibilityLabel("Forava Rakhi Gift Payment")
        .accessibilityAddTraits(.isButton)
        .alert("Payment Result", isPresented: $showingPaymentResult) {
            Button("OK") {
                showingPaymentResult = false
            }
        } message: {
            if let result = payManager.lastPaymentResult {
                Text(paymentResultMessage(result))
            }
        }
        .onChange(of: payManager.lastPaymentResult) { _, newResult in
            if newResult != nil {
                showingPaymentResult = true
            }
        }
    }

    private func backgroundView(geometry: GeometryProxy) -> some View {
        Group {
            // Try to load custom watch poster, fallback to gradient
            if let posterImage = UIImage(named: "watchPoster") {
                Image(uiImage: posterImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
            } else {
                // Fallback gradient with Forava colors
                LinearGradient(
                    colors: [
                        Color(.systemOrange),
                        Color(.systemRed),
                        Color(.systemPink)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        }
        .overlay {
            // Semi-transparent overlay for better text readability
            Color.black.opacity(0.3)
        }
    }

    private func paymentInterface(geometry: GeometryProxy) -> some View {
        VStack(spacing: 8) {
            Spacer()

            // Forava branding
            VStack(spacing: 4) {
                Text("🎊")
                    .font(.title)

                Text("Forava")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)

                Text("Send Rakhi Gift")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.8))
            }

            Spacer()

            // Payment button
            Button {
                payManager.presentApplePay()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "gift.fill")
                        .font(.caption.weight(.semibold))
                    Text("Send Gift")
                        .font(.caption.weight(.semibold))
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(.black.opacity(0.6))
                )
            }
            .buttonStyle(PlainButtonStyle())

            Text("Tap anywhere to pay")
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.6))
                .padding(.bottom, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            WKInterfaceDevice.current().play(.click)
            payManager.presentApplePay()
        }
    }

    private var processingOverlay: some View {
        VStack(spacing: 12) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.2)

            Text("Processing...")
                .font(.caption.weight(.medium))
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black.opacity(0.7))
    }

    private func paymentResultMessage(_ result: ApplePayManager.PaymentResult) -> String {
        switch result {
        case .success(let amount, let description):
            return "Gift of \(AppConfig.currencyCode) \(amount) sent successfully!\n\n\(description)"
        case .failure(let error):
            return "Payment failed: \(error)"
        case .cancelled:
            return "Payment was cancelled."
        }
    }
}

// MARK: - Watch-specific Extensions
extension PayPosterView {
    /// Creates a quick payment view optimized for Apple Watch interaction
    static func quickPayView(amount: Decimal, description: String) -> some View {
        VStack(spacing: 8) {
            Text("🎊")
                .font(.title2)

            Text(description)
                .font(.caption)
                .multilineTextAlignment(.center)
                .lineLimit(2)

            Text("\(AppConfig.currencyCode) \(amount)")
                .font(.title3.weight(.bold))
                .foregroundStyle(.orange)
        }
        .padding()
    }
}

#Preview {
    PayPosterView()
        .environmentObject(ApplePayManager())
}
