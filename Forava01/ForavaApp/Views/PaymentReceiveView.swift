import SwiftUI
import PassKit

struct PaymentReceiveView: View {
    let rakhi: Rakhi
    let sender: String
    @State private var showingApplePay = false
    @State private var paymentSuccess = false
    @State private var isProcessing = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()
                
                // Rakhi Display
                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.orange.opacity(0.2), .red.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 140, height: 140)
                        
                        Image(systemName: "gift.fill")
                            .font(.system(size: 70))
                            .foregroundStyle(.orange)
                    }
                    
                    VStack(spacing: 12) {
                        Text("You received a Rakhi!")
                            .font(.system(.title2, design: .rounded).weight(.bold))
                            .foregroundStyle(.primary)
                        
                        Text("from \(sender)")
                            .font(.system(.title3, design: .rounded).weight(.medium))
                            .foregroundStyle(.orange)
                        
                        Text(rakhi.name)
                            .font(.system(.body, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                    .multilineTextAlignment(.center)
                }
                
                if paymentSuccess {
                    // Success State
                    VStack(spacing: 16) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(.green)
                        
                        VStack(spacing: 8) {
                            Text("Payment Sent!")
                                .font(.system(.headline, design: .rounded).weight(.bold))
                                .foregroundStyle(.primary)
                            
                            Text("Your Rakhi watch face is now active")
                                .font(.system(.subheadline, design: .rounded))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .transition(.scale.combined(with: .opacity))
                } else {
                    // Payment Options
                    VStack(spacing: 20) {
                        Text("Show your appreciation")
                            .font(.system(.headline, design: .rounded).weight(.semibold))
                            .foregroundStyle(.primary)
                        
                        VStack(spacing: 16) {
                            // Apple Pay Option
                            Button {
                                initiateApplePayPayment()
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: "creditcard.fill")
                                        .font(.title2)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Apple Pay")
                                            .font(.system(.body, design: .rounded).weight(.semibold))
                                        
                                        Text("$\(rakhi.price, specifier: "%.2f")")
                                            .font(.system(.subheadline, design: .rounded))
                                            .foregroundStyle(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    if isProcessing {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                            .scaleEffect(0.8)
                                    } else {
                                        Image(systemName: "chevron.right")
                                            .font(.system(.footnote, weight: .semibold))
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .buttonStyle(ApplePayButtonStyle())
                            .disabled(isProcessing)
                            
                            // Digital Gift Option (Future)
                            Button {
                                // Future implementation
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: "gift.fill")
                                        .font(.title2)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Digital Gift")
                                            .font(.system(.body, design: .rounded).weight(.semibold))
                                        
                                        Text("Coming Soon")
                                            .font(.system(.subheadline, design: .rounded))
                                            .foregroundStyle(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(.footnote, weight: .semibold))
                                        .foregroundStyle(.secondary)
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .buttonStyle(DigitalGiftButtonStyle())
                            .disabled(true)
                        }
                    }
                }
                
                Spacer()
                
                // Skip Option
                if !paymentSuccess {
                    Button("Maybe Later") {
                        activateWatchFace()
                    }
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundStyle(.orange)
                }
            }
        }
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: paymentSuccess)
    }
    
    private func initiateApplePayPayment() {
        guard PKPaymentAuthorizationViewController.canMakePayments() else {
            // Show alert that Apple Pay is not available
            return
        }
        
        isProcessing = true
        
        // Create payment request
        let request = PKPaymentRequest()
        request.merchantIdentifier = "merchant.com.forava.app"
        request.supportedNetworks = [.visa, .masterCard, .amex, .discover]
        request.merchantCapabilities = [.threeDSecure, .credit, .debit]
        request.countryCode = "US"
        request.currencyCode = "USD"
        
        // Payment items
        let rakhiItem = PKPaymentSummaryItem(
            label: "Rakhi: \(rakhi.name)",
            amount: NSDecimalNumber(value: rakhi.price)
        )
        let totalItem = PKPaymentSummaryItem(
            label: "Forava",
            amount: NSDecimalNumber(value: rakhi.price)
        )
        request.paymentSummaryItems = [rakhiItem, totalItem]
        
        // Simulate payment process for demo
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isProcessing = false
                paymentSuccess = true
            }
            
            // Activate watch face after successful payment
            activateWatchFace()
        }
    }
    
    private func activateWatchFace() {
        // Here you would integrate with WatchConnectivity
        // to activate the Rakhi watch face on the user's Apple Watch
        
        // For now, we'll simulate this process
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Send message to watch app to activate face
            WatchConnectivityManager.shared.sendRakhiWatchFace(rakhi: rakhi)
        }
    }
}

// MARK: - Button Styles

struct ApplePayButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.white)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.black)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
            .animation(.spring(response: 0.3), value: configuration.isPressed)
    }
}

struct DigitalGiftButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.secondary)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.regularMaterial)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.secondary.opacity(0.3), lineWidth: 1)
            }
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.3), value: configuration.isPressed)
    }
}

#Preview {
    PaymentReceiveView(
        rakhi: Rakhi.sampleRakhis[0],
        sender: "Arjun Kumar"
    )
}