import SwiftUI
import WatchKit

struct PaymentRequestWatchView: View {
    let senderName: String
    let suggestedAmount: Double
    let rakhiId: String
    
    @State private var selectedAmount: Double
    @State private var isProcessingPayment = false
    @Environment(\.dismiss) private var dismiss
    
    private let quickAmounts: [Double] = [21, 51, 101, 201, 501]
    
    init(senderName: String, suggestedAmount: Double, rakhiId: String) {
        self.senderName = senderName
        self.suggestedAmount = suggestedAmount
        self.rakhiId = rakhiId
        self._selectedAmount = State(initialValue: suggestedAmount)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Header
                VStack(spacing: 8) {
                    Text("🎊")
                        .font(.largeTitle)
                    
                    Text("Gift for")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text(senderName)
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.orange)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 8)
                
                // Amount Selection
                VStack(spacing: 12) {
                    Text("Select Amount")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.primary)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                        ForEach(quickAmounts, id: \.self) { amount in
                            Button {
                                selectedAmount = amount
                                WKInterfaceDevice.current().play(.click)
                            } label: {
                                VStack(spacing: 4) {
                                    Text("$\(Int(amount))")
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(selectedAmount == amount ? .white : .primary)
                                    
                                    if amount == suggestedAmount {
                                        Text("✨")
                                            .font(.caption2)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(selectedAmount == amount ? .orange : Color(.systemGray6))
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                
                // Send Button
                Button {
                    sendGift()
                } label: {
                    HStack(spacing: 6) {
                        if isProcessingPayment {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "gift.fill")
                                .font(.caption)
                        }
                        Text(isProcessingPayment ? "Sending..." : "Send $\(Int(selectedAmount))")
                            .font(.subheadline.weight(.semibold))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(isProcessingPayment ? .gray : .orange)
                    )
                }
                .disabled(isProcessingPayment)
                .padding(.top, 8)
                
                Text("Blessed gift ✨")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .navigationTitle("Gift Request")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func sendGift() {
        isProcessingPayment = true
        WKInterfaceDevice.current().play(.start)
        
        // Create gift request to send to iPhone for Apple Pay processing
        let giftRequest = GiftIntent(
            amountMinor: Int64(selectedAmount * 100),
            currency: "USD",
            kind: .cash,
            tokenId: UUID(uuidString: rakhiId) ?? UUID(),
            culturalContext: [
                "occasion": "raksha_bandhan",
                "blessing": "reciprocal_gift",
                "sender": senderName
            ]
        )
        
        // Send to iPhone via WatchSessionManager
        WatchSessionManager_Watch.shared.sendGiftRequest(
            token: RitualToken(
                id: UUID(uuidString: rakhiId) ?? UUID(),
                senderName: senderName,
                receiverName: "Gift Recipient",
                validUntil: Date().addingTimeInterval(365 * 24 * 60 * 60),
                isActivated: true,
                culturalElements: [],
                blessings: []
            ),
            amountMinor: giftRequest.amountMinor,
            currency: giftRequest.currency,
            kind: giftRequest.kind
        ) { [self] success in
            DispatchQueue.main.async {
                self.isProcessingPayment = false
                
                if success {
                    WKInterfaceDevice.current().play(.success)
                    
                    // Show success and dismiss after a moment
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.dismiss()
                    }
                } else {
                    WKInterfaceDevice.current().play(.failure)
                }
            }
        }
    }
}

// Extension to handle payment request URLs on Watch
extension WatchConnectivityManager {
    func handlePaymentURL(_ url: URL) {
        guard url.host == "forava.app",
              url.path == "/pay" else { return }
        
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        guard let queryItems = components?.queryItems else { return }
        
        var recipient: String?
        var rakhiId: String?
        var suggestedAmount: Double = 101
        var sender: String = "Unknown"
        
        for item in queryItems {
            switch item.name {
            case "recipient":
                recipient = item.value
            case "rakhi_id":
                rakhiId = item.value
            case "suggested_amount":
                if let value = item.value, let amount = Double(value) {
                    suggestedAmount = amount
                }
            case "sender":
                sender = item.value ?? "Unknown"
            default:
                break
            }
        }
        
        guard let rakhiId = rakhiId else { return }
        
        // Trigger payment request view
        // This would need to be handled by the main Watch app navigation
        NotificationCenter.default.post(
            name: NSNotification.Name("ShowPaymentRequest"),
            object: nil,
            userInfo: [
                "sender": sender,
                "suggestedAmount": suggestedAmount,
                "rakhiId": rakhiId
            ]
        )
    }
}

#Preview {
    PaymentRequestWatchView(
        senderName: "Priya Sharma",
        suggestedAmount: 101,
        rakhiId: UUID().uuidString
    )
}