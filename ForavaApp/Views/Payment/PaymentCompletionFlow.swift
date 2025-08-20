import SwiftUI
import PassKit
import Combine

// MARK: - Payment Completion Flow Coordinator

struct PaymentCompletionFlow: View {
    let rakhi: GeneratedRakhi
    let selectedAmount: Decimal
    let recipient: PaymentRecipient
    let onCompletion: (PaymentResult?) -> Void
    
    @StateObject private var paymentService = ComprehensivePaymentService.shared
    @StateObject private var transferService = WatchToiPhoneTransferService.shared
    @State private var currentStep: PaymentStep = .preparation
    @State private var paymentResult: PaymentResult?
    @State private var errorMessage: String?
    @State private var showingError = false
    @State private var showingSuccess = false
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [.orange.opacity(0.1), .pink.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Progress indicator
                    PaymentProgressIndicator(currentStep: currentStep)
                        .padding(.top, 20)
                    
                    // Main content
                    ScrollView {
                        VStack(spacing: 24) {
                            switch currentStep {
                            case .preparation:
                                PaymentPreparationView(
                                    rakhi: rakhi,
                                    amount: selectedAmount,
                                    recipient: recipient
                                )
                                
                            case .processing:
                                PaymentProcessingView()
                                
                            case .success:
                                PaymentSuccessView(
                                    result: paymentResult,
                                    rakhi: rakhi,
                                    recipient: recipient
                                )
                                
                            case .failed:
                                PaymentFailedView(
                                    errorMessage: errorMessage ?? "Unknown error occurred"
                                )
                            }
                        }
                        .padding(20)
                    }
                    
                    // Action buttons
                    PaymentActionButtons(
                        currentStep: currentStep,
                        onProceed: processPayment,
                        onRetry: retryPayment,
                        onCancel: cancelPayment,
                        onDone: completeFlow
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .navigationBarHidden(true)
        }
        .alert("Payment Error", isPresented: $showingError) {
            Button("Retry") { retryPayment() }
            Button("Cancel", role: .cancel) { cancelPayment() }
        } message: {
            Text(errorMessage ?? "An error occurred during payment processing.")
        }
    }
    
    // MARK: - Payment Processing
    
    private func processPayment() {
        currentStep = .processing
        
        Task {
            do {
                let context = CulturalPaymentContext(
                    festival: getCurrentFestival(),
                    relationship: recipient.relationship,
                    regionPreference: SimpleLocalizationService.shared.currentLanguage == .hindi ? .indian : .global,
                    auspiciousTiming: isAuspiciousTime()
                )
                
                let result = try await paymentService.processRakhiPayment(
                    amount: selectedAmount,
                    recipient: recipient,
                    rakhi: rakhi,
                    culturalContext: context
                )
                
                await MainActor.run {
                    self.paymentResult = result
                    self.currentStep = .success
                    
                    // Haptic feedback for success
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                    
                    // Schedule celebration animation
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showingSuccess = true
                    }
                }
                
                // Transfer to watch if available
                await transferToWatchIfNeeded()
                
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.currentStep = .failed
                    
                    // Haptic feedback for error
                    let notificationFeedback = UINotificationFeedbackGenerator()
                    notificationFeedback.notificationOccurred(.error)
                }
            }
        }
    }
    
    private func transferToWatchIfNeeded() async {
        // Check if watch is connected and available
        guard transferService.connectionStatus.canTransfer else { return }
        
        // Create watch-optimized display
        let watchDisplay = createWatchRakhiDisplay(from: rakhi)
        
        do {
            try await transferService.transferRakhiToiPhone(watchDisplay)
        } catch {
            // Log error but don't fail the payment flow
            print("Failed to transfer to watch: \(error)")
        }
    }
    
    private func createWatchRakhiDisplay(from rakhi: GeneratedRakhi) -> WatchRakhiDisplay {
        return WatchRakhiDisplay(
            id: rakhi.id,
            title: "\(rakhi.designSpec.genre.displayName) • Gift Sent",
            optimizedImage: WatchOptimizedImage(
                thumbnailData: Data(),
                displaySize: CGSize(width: 44, height: 44),
                compressionQuality: 0.8,
                optimizedForBattery: false
            ),
            culturalScore: rakhi.culturalScore,
            colors: rakhi.designSpec.colorPalette.colors.prefix(3).map { $0 },
            culturalElements: [],
            createdAt: rakhi.createdAt,
            animation: nil,
            watchOptimized: true
        )
    }
    
    private func retryPayment() {
        currentStep = .preparation
        errorMessage = nil
        showingError = false
    }
    
    private func cancelPayment() {
        onCompletion(nil)
        dismiss()
    }
    
    private func completeFlow() {
        onCompletion(paymentResult)
        dismiss()
    }
    
    private func getCurrentFestival() -> Festival? {
        let calendar = Calendar.current
        let now = Date()
        let month = calendar.component(.month, from: now)
        let day = calendar.component(.day, from: now)
        
        if month == 8 && day >= 10 && day <= 25 {
            return .rakshaBandhan
        }
        return nil
    }
    
    private func isAuspiciousTime() -> Bool {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date())
        return (hour >= 6 && hour <= 10) || (hour >= 16 && hour <= 19)
    }
}

// MARK: - Payment Steps

enum PaymentStep {
    case preparation
    case processing
    case success
    case failed
    
    var title: String {
        switch self {
        case .preparation: return "Review Payment"
        case .processing: return "Processing..."
        case .success: return "Payment Successful"
        case .failed: return "Payment Failed"
        }
    }
    
    var progress: Float {
        switch self {
        case .preparation: return 0.25
        case .processing: return 0.75
        case .success: return 1.0
        case .failed: return 0.0
        }
    }
}

// MARK: - Progress Indicator

struct PaymentProgressIndicator: View {
    let currentStep: PaymentStep
    
    var body: some View {
        VStack(spacing: 12) {
            Text(currentStep.title)
                .font(.title2.weight(.semibold))
                .foregroundColor(.primary)
            
            ProgressView(value: currentStep.progress)
                .progressViewStyle(LinearProgressViewStyle(tint: .orange))
                .frame(maxWidth: 200)
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Payment Preparation View

struct PaymentPreparationView: View {
    let rakhi: GeneratedRakhi
    let amount: Decimal
    let recipient: PaymentRecipient
    
    var body: some View {
        VStack(spacing: 24) {
            // Rakhi summary
            RakhiPaymentSummaryCard(rakhi: rakhi)
            
            // Payment details
            PaymentDetailsCard(amount: amount, recipient: recipient)
            
            // Cultural blessing
            CulturalBlessingCard()
            
            // Terms and privacy
            PaymentTermsSection()
        }
    }
}

struct RakhiPaymentSummaryCard: View {
    let rakhi: GeneratedRakhi
    
    var body: some View {
        VStack(spacing: 16) {
            // Rakhi visualization
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: rakhi.designSpec.colorPalette.colors + [rakhi.designSpec.colorPalette.colors.first?.opacity(0.3) ?? .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 120)
                
                VStack(spacing: 8) {
                    Image(systemName: "gift.circle.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 2)
                    
                    Text("🎊")
                        .font(.title)
                }
            }
            
            VStack(spacing: 8) {
                Text(rakhi.designSpec.genre.displayName)
                    .font(.title3.weight(.semibold))
                    .foregroundColor(.primary)
                
                HStack(spacing: 16) {
                    Label("⭐ \(rakhi.culturalScore, specifier: "%.1f")", systemImage: "")
                        .font(.caption.weight(.medium))
                        .foregroundColor(.orange)
                    
                    Label(rakhi.createdAt, style: .relative)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(20)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
    }
}

struct PaymentDetailsCard: View {
    let amount: Decimal
    let recipient: PaymentRecipient
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Payment Details")
                    .font(.headline.weight(.semibold))
                    .foregroundColor(.primary)
                Spacer()
            }
            
            VStack(spacing: 12) {
                PaymentDetailRow(label: "Recipient", value: recipient.name)
                PaymentDetailRow(label: "Relationship", value: recipient.relationship.rawValue)
                PaymentDetailRow(label: "Amount", value: "₹\(amount as NSDecimalNumber)", isAmount: true)
                
                if let address = recipient.address {
                    PaymentDetailRow(label: "Delivery", value: "\(address.city), \(address.state)")
                }
            }
        }
        .padding(20)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

struct PaymentDetailRow: View {
    let label: String
    let value: String
    var isAmount: Bool = false
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(isAmount ? .headline.weight(.semibold) : .subheadline.weight(.medium))
                .foregroundColor(isAmount ? .orange : .primary)
        }
    }
}

struct CulturalBlessingCard: View {
    @StateObject private var localization = SimpleLocalizationService.shared
    
    private var blessing: String {
        if localization.currentLanguage == .hindi {
            return "आपका प्रेम और आशीर्वाद हमेशा साथ रहे 🙏"
        } else {
            return "May your love and blessings always be with them 🙏"
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "heart.circle.fill")
                .font(.system(size: 24))
                .foregroundColor(.pink)
            
            Text(blessing)
                .font(.subheadline.italic())
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
        }
        .padding(16)
        .background(.pink.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
    }
}

struct PaymentTermsSection: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("By proceeding, you agree to our Terms of Service and Privacy Policy. Your payment will be processed securely through Apple Pay.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 16) {
                Image(systemName: "lock.shield.fill")
                    .foregroundColor(.green)
                
                Text("Secure Payment")
                    .font(.caption.weight(.medium))
                    .foregroundColor(.green)
                
                Image(systemName: "applelogo")
                    .foregroundColor(.primary)
                
                Text("Apple Pay")
                    .font(.caption.weight(.medium))
                    .foregroundColor(.primary)
            }
        }
    }
}

// MARK: - Payment Processing View

struct PaymentProcessingView: View {
    @State private var animationPhase = 0
    
    var body: some View {
        VStack(spacing: 32) {
            // Animated processing indicator
            ZStack {
                ForEach(0..<3) { index in
                    Circle()
                        .stroke(.orange.opacity(0.3), lineWidth: 2)
                        .frame(width: 80 + CGFloat(index * 20), height: 80 + CGFloat(index * 20))
                        .scaleEffect(animationPhase == index ? 1.2 : 1.0)
                        .opacity(animationPhase == index ? 0.3 : 0.8)
                }
                
                Image(systemName: "creditcard.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.orange)
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 1.0).repeatForever()) {
                    animationPhase = 2
                }
            }
            
            VStack(spacing: 16) {
                Text("Processing Your Payment")
                    .font(.title2.weight(.semibold))
                    .foregroundColor(.primary)
                
                Text("Securing your transaction and preparing your Rakhi gift...")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                VStack(spacing: 8) {
                    ProcessingStep(text: "Validating payment details", isActive: true)
                    ProcessingStep(text: "Processing secure transaction", isActive: true)
                    ProcessingStep(text: "Applying cultural blessings", isActive: false)
                    ProcessingStep(text: "Finalizing gift delivery", isActive: false)
                }
            }
        }
        .padding(32)
    }
}

struct ProcessingStep: View {
    let text: String
    let isActive: Bool
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: 12) {
            if isActive {
                ProgressView()
                    .scaleEffect(0.8)
            } else {
                Image(systemName: "circle")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
            
            Text(text)
                .font(.caption)
                .foregroundColor(isActive ? .primary : .secondary)
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Payment Success View

struct PaymentSuccessView: View {
    let result: PaymentResult?
    let rakhi: GeneratedRakhi
    let recipient: PaymentRecipient
    @State private var showingCelebration = false
    
    var body: some View {
        VStack(spacing: 32) {
            // Success animation
            ZStack {
                if showingCelebration {
                    CelebrationParticles()
                }
                
                ZStack {
                    Circle()
                        .fill(.green.opacity(0.2))
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 64))
                        .foregroundColor(.green)
                }
                .scaleEffect(showingCelebration ? 1.1 : 1.0)
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showingCelebration)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showingCelebration = true
                }
            }
            
            VStack(spacing: 16) {
                Text("Payment Successful! 🎉")
                    .font(.title.weight(.bold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                Text("Your Rakhi gift has been sent to \(recipient.name)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            if let result = result {
                PaymentSuccessDetails(result: result)
            }
            
            // Cultural message
            VStack(spacing: 8) {
                Text("🙏")
                    .font(.title)
                
                Text("May this sacred thread strengthen your bond and bring endless joy")
                    .font(.subheadline.italic())
                    .foregroundColor(.orange)
                    .multilineTextAlignment(.center)
            }
            .padding(16)
            .background(.orange.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
        }
        .padding(24)
    }
}

struct PaymentSuccessDetails: View {
    let result: PaymentResult
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Transaction Details")
                    .font(.headline.weight(.medium))
                    .foregroundColor(.primary)
                Spacer()
            }
            
            VStack(spacing: 8) {
                PaymentDetailRow(label: "Transaction ID", value: result.transactionId)
                PaymentDetailRow(label: "Amount", value: "₹\(result.processedAmount as NSDecimalNumber)", isAmount: true)
                PaymentDetailRow(label: "Time", value: DateFormatter.localizedString(from: result.timestamp, dateStyle: .none, timeStyle: .medium))
                PaymentDetailRow(label: "Status", value: result.status.rawValue)
            }
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

struct CelebrationParticles: View {
    @State private var animateParticles = false
    
    var body: some View {
        ZStack {
            ForEach(0..<20) { index in
                Text(["🎊", "✨", "🎉", "⭐", "💫"].randomElement() ?? "✨")
                    .font(.title2)
                    .offset(
                        x: animateParticles ? CGFloat.random(in: -100...100) : 0,
                        y: animateParticles ? CGFloat.random(in: -100...100) : 0
                    )
                    .opacity(animateParticles ? 0 : 1)
                    .scaleEffect(animateParticles ? 0.1 : 1.0)
                    .animation(
                        .easeOut(duration: 2.0).delay(Double(index) * 0.1),
                        value: animateParticles
                    )
            }
        }
        .onAppear {
            animateParticles = true
        }
    }
}

// MARK: - Payment Failed View

struct PaymentFailedView: View {
    let errorMessage: String
    
    var body: some View {
        VStack(spacing: 32) {
            // Error indicator
            ZStack {
                Circle()
                    .fill(.red.opacity(0.2))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 64))
                    .foregroundColor(.red)
            }
            
            VStack(spacing: 16) {
                Text("Payment Failed")
                    .font(.title.weight(.bold))
                    .foregroundColor(.primary)
                
                Text(errorMessage)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // Support information
            VStack(spacing: 12) {
                Text("Need Help?")
                    .font(.headline.weight(.medium))
                    .foregroundColor(.primary)
                
                VStack(spacing: 8) {
                    Text("• Check your payment method")
                    Text("• Ensure sufficient funds")
                    Text("• Verify network connection")
                    Text("• Contact support if issue persists")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            .padding(16)
            .background(.red.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
        }
        .padding(24)
    }
}

// MARK: - Action Buttons

struct PaymentActionButtons: View {
    let currentStep: PaymentStep
    let onProceed: () -> Void
    let onRetry: () -> Void
    let onCancel: () -> Void
    let onDone: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            switch currentStep {
            case .preparation:
                HStack(spacing: 16) {
                    Button("Cancel", action: onCancel)
                        .buttonStyle(SecondaryButtonStyle())
                    
                    Button("Pay with Apple Pay", action: onProceed)
                        .buttonStyle(PrimaryButtonStyle())
                }
                
            case .processing:
                Button("Cancel", action: onCancel)
                    .buttonStyle(SecondaryButtonStyle())
                    .disabled(true)
                
            case .success:
                Button("Done", action: onDone)
                    .buttonStyle(PrimaryButtonStyle())
                
            case .failed:
                HStack(spacing: 16) {
                    Button("Cancel", action: onCancel)
                        .buttonStyle(SecondaryButtonStyle())
                    
                    Button("Retry Payment", action: onRetry)
                        .buttonStyle(PrimaryButtonStyle())
                }
            }
        }
    }
}

// MARK: - Button Styles

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.weight(.semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(.orange, in: RoundedRectangle(cornerRadius: 12))
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.weight(.medium))
            .foregroundColor(.orange)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(.orange.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.orange.opacity(0.3), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    PaymentCompletionFlow(
        rakhi: GeneratedRakhi(
            id: UUID(),
            designSpec: RakhiDesignSpec(
                genre: .traditional,
                colorPalette: ColorPalette(colors: [.orange, .red, .gold]),
                elements: [],
                culturalTheme: .traditional
            ),
            mainImage: AIImageResult(imageData: Data(), timestamp: Date()),
            culturalScore: 0.85,
            createdAt: Date()
        ),
        selectedAmount: 251,
        recipient: PaymentRecipient(
            name: "Priya",
            relationship: .sister,
            address: nil,
            preferences: RecipientPreferences(
                preferredCurrency: "INR",
                culturalConsiderations: [],
                deliveryPreference: .standard
            )
        ),
        onCompletion: { _ in }
    )
}