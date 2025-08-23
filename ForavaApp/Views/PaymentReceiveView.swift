import SwiftUI
import PassKit

struct PaymentReceiveView: View {
    let generatedRakhi: GeneratedRakhi
    let sender: String
    @State private var showingGiftAmountPopup = false
    @State private var paymentSuccess = false
    @State private var isProcessing = false
    @State private var rakhiDisplayed = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if !rakhiDisplayed {
                    // Initial notification state
                    VStack(spacing: 32) {
                        Spacer()
                        
                        // Notification Display
                        VStack(spacing: 20) {
                            Image(systemName: "heart.circle.fill")
                                .font(.system(size: 80))
                                .foregroundStyle(.orange)
                                .symbolEffect(.bounce, value: true)
                            
                            VStack(spacing: 12) {
                                Text("💝 You received a Rakhi!")
                                    .font(.system(.title2, design: .rounded).weight(.bold))
                                    .foregroundStyle(.primary)
                                
                                Text("from \(sender)")
                                    .font(.system(.title3, design: .rounded).weight(.medium))
                                    .foregroundStyle(.orange)
                                
                                Text("A beautiful AI-generated Rakhi created just for you")
                                    .font(.system(.body, design: .rounded))
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        
                        Spacer()
                        
                        // View Rakhi Button
                        Button {
                            viewRakhi()
                        } label: {
                            Text("View Rakhi")
                                .font(.system(.title3, design: .rounded).weight(.semibold))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .fill(.orange)
                                )
                                .shadow(color: .orange.opacity(0.3), radius: 12, y: 6)
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 32)
                    }
                } else {
                    // Rakhi display state
                    ScrollView {
                        VStack(spacing: 24) {
                            // Header
                            VStack(spacing: 16) {
                                HStack {
                                    Image(systemName: "heart.fill")
                                        .foregroundStyle(.orange)
                                    Text("Rakhi from \(sender)")
                                        .font(.system(.headline, design: .rounded).weight(.semibold))
                                        .foregroundStyle(.primary)
                                    Spacer()
                                }
                                
                                Text("This beautiful Rakhi was created with love just for you")
                                    .font(.system(.subheadline, design: .rounded))
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 16)
                            
                            // Generated Rakhi Display
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color(.systemGray6))
                                    .frame(height: 280)
                                
                                if let imageData = generatedRakhi.mainImage.imageData,
                                   let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxHeight: 280)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                        .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
                                } else {
                                    VStack(spacing: 12) {
                                        Image(systemName: "photo")
                                            .font(.system(size: 48))
                                            .foregroundStyle(.secondary)
                                        Text("Beautiful Rakhi")
                                            .font(.system(.body, design: .rounded))
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 24)
                            .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 24))
                            .padding(.horizontal, 24)
                            
                            // Apple Watch Setup Notice
                            VStack(spacing: 12) {
                                HStack {
                                    Image(systemName: "applewatch")
                                        .foregroundStyle(.blue)
                                    Text("Perfect for Apple Watch")
                                        .font(.system(.headline, design: .rounded).weight(.semibold))
                                        .foregroundStyle(.primary)
                                    Spacer()
                                }
                                
                                Text("This Rakhi has been optimized as a functional clock face for your Apple Watch.")
                                    .font(.system(.subheadline, design: .rounded))
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .background(.blue.opacity(0.05), in: RoundedRectangle(cornerRadius: 16))
                            .overlay {
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.blue.opacity(0.3), lineWidth: 1)
                            }
                            .padding(.horizontal, 24)
                        }
                    }
                    
                    Spacer()
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
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                    .transition(.scale.combined(with: .opacity))
                }
            }
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
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: rakhiDisplayed)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: paymentSuccess)
        .onAppear {
            activateWatchFace()
        }
        .overlay {
            // Gift Amount Popup (appears 3 seconds after viewing Rakhi)
            if showingGiftAmountPopup && rakhiDisplayed && !paymentSuccess {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showingGiftAmountPopup = false
                    }
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    GiftAmountPopupView(
                        generatedRakhi: generatedRakhi,
                        sender: sender,
                        onAcceptAndSend: { amount in
                            acceptRakhiAndSendGift(amount: amount)
                        },
                        onDismiss: {
                            showingGiftAmountPopup = false
                        }
                    )
                    .padding(.horizontal, 24)
                    .padding(.bottom, 100)
                    
                    Spacer()
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
    }
    
    // MARK: - Functions
    
    private func viewRakhi() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            rakhiDisplayed = true
        }
        
        // Show gift amount popup after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                showingGiftAmountPopup = true
            }
        }
    }
    
    private func acceptRakhiAndSendGift(amount: Decimal) {
        showingGiftAmountPopup = false
        isProcessing = true
        
        // Simulate Apple Pay payment
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isProcessing = false
                paymentSuccess = true
            }
        }
    }
    
    private func activateWatchFace() {
        // Activate the Rakhi as a watch face on Apple Watch
        WatchSessionManager_iOS.shared.sendGeneratedRakhiToWatch(generatedRakhi, recipient: "You")
        print("[INFO] Rakhi watch face activated")
    }
}

// MARK: - Gift Amount Popup View
struct GiftAmountPopupView: View {
    let generatedRakhi: GeneratedRakhi
    let sender: String
    let onAcceptAndSend: (Decimal) -> Void
    let onDismiss: () -> Void
    
    @State private var selectedAmount: Decimal = 101
    @State private var showingCustomAmount = false
    @State private var customAmountText = ""
    
    private var suggestedAmounts: [Decimal] {
        [21, 51, 101, 251, 501, 1001]
    }
    
    private var suggestedAmount: Decimal {
        let baseAmount = 51.0
        let complexityMultiplier = 1.0 + (Double(generatedRakhi.designSpec.elements.count) * 0.1)
        let culturalMultiplier = generatedRakhi.culturalScore
        
        let suggested = baseAmount * complexityMultiplier * culturalMultiplier
        let rounded = round(suggested / 10) * 10 + 1
        return Decimal(min(max(rounded, 21), 501))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 12) {
                Image(systemName: "gift.circle.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(.green)
                
                VStack(spacing: 6) {
                    Text("Gift Amount Suggestion")
                        .font(.system(.title3, design: .rounded).weight(.bold))
                        .foregroundStyle(.primary)
                    
                    Text("Show your appreciation to \(sender)")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            
            // Suggested Amount Display
            VStack(spacing: 12) {
                HStack {
                    Text("AI Suggested:")
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text("$\(suggestedAmount as NSDecimalNumber)")
                        .font(.system(.title3, design: .rounded).weight(.bold))
                        .foregroundStyle(.green)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(.green.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
                
                Text("Based on Rakhi complexity and cultural significance")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // Amount Selection
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                ForEach(suggestedAmounts, id: \.self) { amount in
                    Button {
                        selectedAmount = amount
                    } label: {
                        VStack(spacing: 4) {
                            Text("$\(amount as NSDecimalNumber)")
                                .font(.system(.body, design: .rounded).weight(.semibold))
                                .foregroundStyle(selectedAmount == amount ? .white : .primary)
                            
                            if amount == suggestedAmount {
                                Text("AI Pick")
                                    .font(.system(.caption2, design: .rounded).weight(.medium))
                                    .foregroundStyle(selectedAmount == amount ? .white.opacity(0.8) : .green)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(selectedAmount == amount ? .green : Color(.systemGray6))
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            
            // Accept and Send Button
            VStack(spacing: 12) {
                Button {
                    onAcceptAndSend(selectedAmount)
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "heart.fill")
                        Text("Accept Rakhi & Send Gift")
                    }
                    .font(.system(.body, design: .rounded).weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(.green)
                    )
                    .shadow(color: .green.opacity(0.3), radius: 8, y: 4)
                }
                
                Button("Maybe Later") {
                    onDismiss()
                }
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.secondary)
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 20, y: 10)
        )
        .onAppear {
            selectedAmount = suggestedAmount
        }
    }
}

#Preview {
    PaymentReceiveView(
        generatedRakhi: GeneratedRakhi(
            id: UUID(),
            designSpec: RakhiDesignSpec(),
            mainImage: AIImageResult(
                imageData: Data(),
                timestamp: Date()
            ),
            animationFrames: [],
            prompt: AIPrompt(
                positive: "Beautiful traditional Rakhi",
                negative: "",
                cfg_scale: 7.5,
                steps: 20,
                seed: 12345,
                width: 512,
                height: 512
            ),
            createdAt: Date(),
            culturalScore: 0.8,
            qualityScore: 0.9
        ),
        sender: "Priya"
    )
}