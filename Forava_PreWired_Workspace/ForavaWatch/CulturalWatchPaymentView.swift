import SwiftUI
import WatchKit

struct CulturalWatchPaymentView: View {
    let culturalGift: WatchCulturalGift
    let senderName: String
    let relationship: String
    let occasion: String

    @StateObject private var paymentManager = WatchPaymentManager.shared
    @StateObject private var hapticManager = WatchHapticManager.shared
    @Environment(\.dismiss) private var dismiss

    @State private var selectedAmount: Decimal = 51
    @State private var showingAmountPicker = false
    @State private var showingGratitudeAnimation = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Cultural Header
                    culturalHeaderView

                    // Amount Selection
                    amountSelectionView

                    // Cultural Context
                    culturalContextView

                    // Payment Action
                    paymentActionView

                    // Status Display
                    if paymentManager.paymentStatus != .idle {
                        paymentStatusView
                    }
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 16)
            }
            .navigationTitle("Cultural Gift")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") {
                        hapticManager.playHaptic(.selection)
                        dismiss()
                    }
                    .font(.caption)
                }
            }
        }
        .sheet(isPresented: $showingAmountPicker) {
            CulturalAmountPickerView(
                selectedAmount: $selectedAmount,
                relationship: relationship,
                occasion: occasion,
                culturalContext: culturalGift.culturalContext
            )
        }
        .onChange(of: paymentManager.paymentStatus) { _, newStatus in
            handlePaymentStatusChange(newStatus)
        }
        .onAppear {
            setupInitialAmount()
        }
    }

    // MARK: - Cultural Header

    private var culturalHeaderView: some View {
        VStack(spacing: 8) {
            // Cultural symbol
            Text(getCulturalSymbol(for: occasion))
                .font(.system(size: 32))

            VStack(spacing: 4) {
                Text("Gift for")
                    .font(.caption2)
                    .foregroundStyle(.secondary)

                Text(senderName)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)

                Text(getOccasionDisplayName(occasion))
                    .font(.caption)
                    .foregroundStyle(.orange)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(.orange.opacity(0.2), in: Capsule())
            }
        }
        .padding(.top, 8)
    }

    // MARK: - Amount Selection

    private var amountSelectionView: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Select Amount")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.primary)

                Spacer()

                Button {
                    hapticManager.playHaptic(.selection)
                    showingAmountPicker = true
                } label: {
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.caption2)
                        .foregroundStyle(.orange)
                }
            }

            // Quick amounts grid
            let quickAmounts = getQuickAmounts(for: relationship, occasion: occasion)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 6) {
                ForEach(quickAmounts, id: \.amount) { option in
                    quickAmountButton(option)
                }
            }
        }
    }

    private func quickAmountButton(_ option: QuickAmountOption) -> some View {
        Button {
            selectedAmount = option.amount
            hapticManager.playHaptic(.selection)
        } label: {
            VStack(spacing: 3) {
                HStack(spacing: 2) {
                    Text("$\(NSDecimalNumber(decimal: option.amount))")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(selectedAmount == option.amount ? .white : .primary)

                    if option.isRecommended {
                        Text("✨")
                            .font(.system(size: 8))
                    }
                }

                if !option.culturalSignificance.isEmpty {
                    Text(option.culturalSignificance)
                        .font(.system(size: 6))
                        .foregroundStyle(selectedAmount == option.amount ? .white.opacity(0.8) : .secondary)
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(selectedAmount == option.amount ? .orange : Color(.systemGray6))
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Cultural Context

    private var culturalContextView: some View {
        VStack(spacing: 8) {
            Text(getCulturalBlessing(for: occasion, relationship: relationship))
                .font(.caption)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))

            // Cultural note about the amount
            if let culturalNote = getCulturalAmountNote(selectedAmount, for: relationship) {
                Text(culturalNote)
                    .font(.caption2)
                    .foregroundStyle(.orange)
                    .multilineTextAlignment(.center)
            }
        }
    }

    // MARK: - Payment Action

    private var paymentActionView: some View {
        VStack(spacing: 8) {
            Button {
                initiatePayment()
            } label: {
                HStack(spacing: 6) {
                    if paymentManager.paymentStatus == .processing || paymentManager.paymentStatus == .authenticating {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.7)
                    } else {
                        Image(systemName: "gift.fill")
                            .font(.caption)
                    }

                    Text(paymentButtonText)
                        .font(.caption.weight(.semibold))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(paymentButtonColor)
                )
            }
            .disabled(paymentManager.paymentStatus == .processing || paymentManager.paymentStatus == .authenticating)

            Text(getPaymentProcessNote())
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Payment Status

    private var paymentStatusView: some View {
        VStack(spacing: 8) {
            switch paymentManager.paymentStatus {
            case .processing:
                statusIndicator("Preparing payment...", systemImage: "clock", color: .orange)

            case .authenticating:
                statusIndicator("Processing on iPhone...", systemImage: "applewatch", color: .blue)

            case .completed:
                if let result = paymentManager.lastPaymentResult, result.success {
                    statusIndicator(result.gratitudeMessage ?? "Payment completed!", systemImage: "checkmark.circle.fill", color: .green)
                }

            case .failed:
                if let result = paymentManager.lastPaymentResult, !result.success {
                    statusIndicator(result.errorMessage ?? "Payment failed", systemImage: "exclamationmark.circle.fill", color: .red)
                }

            case .cancelled:
                statusIndicator("Payment cancelled", systemImage: "xmark.circle.fill", color: .gray)

            case .idle:
                EmptyView()
            }
        }
        .padding(.top, 8)
    }

    private func statusIndicator(_ text: String, systemImage: String, color: Color) -> some View {
        HStack(spacing: 6) {
            Image(systemName: systemImage)
                .font(.caption)
                .foregroundStyle(color)

            Text(text)
                .font(.caption2)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(.regularMaterial, in: Capsule())
    }

    // MARK: - Helper Methods

    private func setupInitialAmount() {
        let quickAmounts = getQuickAmounts(for: relationship, occasion: occasion)
        if let recommended = quickAmounts.first(where: { $0.isRecommended }) {
            selectedAmount = recommended.amount
        } else if let first = quickAmounts.first {
            selectedAmount = first.amount
        }
    }

    private func initiatePayment() {
        Task {
            await paymentManager.initiatePayment(
                for: convertToWatchRakhiDisplay(culturalGift),
                amount: selectedAmount,
                relationship: relationship
            )
        }
    }

    private func handlePaymentStatusChange(_ status: WatchPaymentManager.PaymentStatus) {
        switch status {
        case .completed:
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                dismiss()
            }
        case .failed, .cancelled:
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                paymentManager.paymentStatus = .idle
            }
        default:
            break
        }
    }

    // MARK: - Cultural Context Helpers

    private func getCulturalSymbol(for occasion: String) -> String {
        switch occasion.lowercased() {
        case "raksha_bandhan", "rakhi": return "🎊"
        case "diwali": return "🪔"
        case "chinese_new_year": return "🧧"
        case "christmas": return "🎄"
        case "eid": return "🌙"
        case "vesak": return "🪷"
        case "rosh_hashanah": return "🍎"
        case "hanukkah": return "🕎"
        case "holi": return "🌈"
        case "mid_autumn_festival": return "🥮"
        case "easter": return "🐰"
        case "birthday": return "🎂"
        default: return "🎁"
        }
    }

    private func getOccasionDisplayName(_ occasion: String) -> String {
        switch occasion.lowercased() {
        case "raksha_bandhan", "rakhi": return "Raksha Bandhan"
        case "chinese_new_year": return "Chinese New Year"
        case "mid_autumn_festival": return "Mid-Autumn Festival"
        case "rosh_hashanah": return "Rosh Hashanah"
        case "vesak": return "Vesak Day"
        default: return occasion.capitalized
        }
    }

    private func getCulturalBlessing(for occasion: String, relationship: String) -> String {
        switch occasion.lowercased() {
        case "raksha_bandhan", "rakhi":
            return "May this sacred bond bring protection and blessings 🙏"
        case "diwali":
            return "May this festival of lights illuminate your path with joy ✨"
        case "chinese_new_year":
            return "Wishing you prosperity and good fortune in the new year 🐉"
        case "christmas":
            return "May the spirit of Christmas bring you peace and joy 🎄"
        case "eid":
            return "May this blessed celebration bring you spiritual fulfillment 🌙"
        default:
            return "Sharing love and blessings on this special occasion 💝"
        }
    }

    private func getQuickAmounts(for relationship: String, occasion: String) -> [QuickAmountOption] {
        return paymentManager.getQuickAmountSuggestions(for: relationship)
    }

    private func getCulturalAmountNote(_ amount: Decimal, for relationship: String) -> String? {
        let amountDouble = NSDecimalNumber(decimal: amount).doubleValue

        if amountDouble.truncatingRemainder(dividingBy: 10) == 1 {
            return "Auspicious amount ending in 1 🌟"
        } else if [11, 21, 51, 101, 251, 501, 1001].contains(Int(amountDouble)) {
            return "Traditional gift amount ✨"
        }
        return nil
    }

    private var paymentButtonText: String {
        switch paymentManager.paymentStatus {
        case .idle:
            return "Send $\(NSDecimalNumber(decimal: selectedAmount))"
        case .processing:
            return "Processing..."
        case .authenticating:
            return "Authenticating..."
        default:
            return "Send Gift"
        }
    }

    private var paymentButtonColor: Color {
        switch paymentManager.paymentStatus {
        case .processing, .authenticating:
            return .gray
        case .completed:
            return .green
        case .failed:
            return .red
        default:
            return .orange
        }
    }

    private func getPaymentProcessNote() -> String {
        switch paymentManager.paymentStatus {
        case .idle:
            return "Payment will be processed on your iPhone using Apple Pay"
        case .processing:
            return "Sending payment request to iPhone..."
        case .authenticating:
            return "Complete payment authentication on iPhone"
        default:
            return ""
        }
    }

    private func convertToWatchRakhiDisplay(_ culturalGift: WatchCulturalGift) -> WatchRakhiDisplay {
        // Convert cultural gift to watch rakhi display format
        return WatchRakhiDisplay(
            id: culturalGift.id,
            title: "\(culturalGift.culturalContext) • \(culturalGift.occasion)",
            optimizedImage: WatchOptimizedImage(
                thumbnailData: Data(),
                displaySize: CGSize(width: 40, height: 40),
                compressionQuality: 0.8,
                optimizedForBattery: true
            ),
            culturalScore: culturalGift.culturalScore,
            colors: culturalGift.primaryColors,
            culturalElements: culturalGift.culturalElements,
            createdAt: culturalGift.createdAt,
            animation: nil,
            watchOptimized: true
        )
    }
}

// MARK: - Supporting Types

struct WatchCulturalGift: Identifiable {
    let id: UUID
    let culturalContext: String
    let occasion: String
    let culturalScore: Double
    let primaryColors: [Color]
    let culturalElements: [WatchCulturalElement]
    let createdAt: Date
    let senderName: String
    let recipientName: String
}

// MARK: - Amount Picker Sheet

struct CulturalAmountPickerView: View {
    @Binding var selectedAmount: Decimal
    let relationship: String
    let occasion: String
    let culturalContext: String

    @Environment(\.dismiss) private var dismiss
    @StateObject private var hapticManager = WatchHapticManager.shared

    private let allAmounts: [Decimal] = [11, 21, 51, 101, 151, 201, 251, 301, 501, 751, 1001]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                    ForEach(allAmounts, id: \.self) { amount in
                        Button {
                            selectedAmount = amount
                            hapticManager.playHaptic(.selection)
                            dismiss()
                        } label: {
                            VStack(spacing: 4) {
                                Text("$\(NSDecimalNumber(decimal: amount))")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(selectedAmount == amount ? .white : .primary)

                                if isAuspicious(amount) {
                                    Text("✨")
                                        .font(.system(size: 8))
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(selectedAmount == amount ? .orange : Color(.systemGray6))
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 8)
            }
            .navigationTitle("Amount")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(.caption)
                }
            }
        }
    }

    private func isAuspicious(_ amount: Decimal) -> Bool {
        let amountDouble = NSDecimalNumber(decimal: amount).doubleValue
        return amountDouble.truncatingRemainder(dividingBy: 10) == 1
    }
}

#Preview {
    CulturalWatchPaymentView(
        culturalGift: WatchCulturalGift(
            id: UUID(),
            culturalContext: "rakhi_indian",
            occasion: "raksha_bandhan",
            culturalScore: 8.5,
            primaryColors: [.orange, .red, .gold],
            culturalElements: [],
            createdAt: Date(),
            senderName: "Priya",
            recipientName: "Brother"
        ),
        senderName: "Sister Priya",
        relationship: "sister",
        occasion: "raksha_bandhan"
    )
}
