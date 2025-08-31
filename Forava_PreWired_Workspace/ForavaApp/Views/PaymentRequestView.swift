import SwiftUI

struct PaymentRequestView: View {
    let rakhiId: String
    let senderName: String
    let recipientName: String
    let suggestedAmount: Double
    let culturalSignificance: String

    @Environment(\.dismiss) private var dismiss
    @State private var selectedAmount: Double
    @State private var customAmount: String = ""
    @State private var showingCustomInput = false
    @State private var isProcessingPayment = false
    @State private var paymentCompleted = false
    @State private var showingPaymentResult = false
    @State private var paymentError: String?

    private let auspiciousAmounts: [Double] = [21, 51, 101, 201, 501, 1001]

    init(rakhiId: String, senderName: String, recipientName: String, suggestedAmount: Double, culturalSignificance: String) {
        self.rakhiId = rakhiId
        self.senderName = senderName
        self.recipientName = recipientName
        self.suggestedAmount = suggestedAmount
        self.culturalSignificance = culturalSignificance
        self._selectedAmount = State(initialValue: suggestedAmount)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 16) {
                        Image(systemName: "heart.circle.fill")
                            .font(.system(size: 64))
                            .foregroundStyle(.orange)

                        VStack(spacing: 8) {
                            Text("Gift Request from")
                                .font(.system(.title3, design: .rounded).weight(.medium))
                                .foregroundStyle(.secondary)

                            Text(senderName)
                                .font(.system(.title, design: .rounded).weight(.bold))
                                .foregroundStyle(.orange)
                        }

                        Text("🎊 Thank you for the beautiful Rakhi!")
                            .font(.system(.body, design: .rounded))
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 32)

                    // Cultural Context
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: "leaf.circle.fill")
                                .foregroundStyle(.green)
                            Text("Cultural Significance")
                                .font(.system(.headline, design: .rounded).weight(.semibold))
                                .foregroundStyle(.primary)
                            Spacer()
                        }

                        Text("In the tradition of Raksha Bandhan, gifts ending in '1' bring divine blessings and prosperity to both giver and receiver.")
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 8)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(.green.opacity(0.05), in: RoundedRectangle(cornerRadius: 16))

                    // Amount Selection
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "dollarsign.circle.fill")
                                .foregroundStyle(.blue)
                            Text("Select Gift Amount")
                                .font(.system(.headline, design: .rounded).weight(.semibold))
                                .foregroundStyle(.primary)
                            Spacer()
                        }

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                            ForEach(auspiciousAmounts, id: \.self) { amount in
                                AmountButton(
                                    amount: amount,
                                    isSelected: selectedAmount == amount,
                                    isSuggested: amount == suggestedAmount,
                                    onSelect: { selectedAmount = amount }
                                )
                            }
                        }

                        // Custom Amount
                        if showingCustomInput {
                            HStack {
                                Text("$")
                                    .font(.title2.weight(.medium))
                                    .foregroundStyle(.secondary)

                                TextField("Enter amount", text: $customAmount)
                                    .font(.title2.weight(.medium))
                                    .keyboardType(.decimalPad)
                                    .onChange(of: customAmount) { _, newValue in
                                        if let amount = Double(newValue), amount > 0 {
                                            selectedAmount = amount
                                        }
                                    }

                                Button("Done") {
                                    showingCustomInput = false
                                    hideKeyboard()
                                }
                                .font(.caption.weight(.medium))
                                .foregroundStyle(.blue)
                            }
                            .padding(16)
                            .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 12))
                        } else {
                            Button {
                                showingCustomInput = true
                            } label: {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundStyle(.blue)

                                    Text("Enter Custom Amount")
                                        .font(.subheadline.weight(.medium))
                                        .foregroundStyle(.blue)

                                    Spacer()
                                }
                                .padding(16)
                                .background(.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    // Send Gift Button
                    Button {
                        processPayment()
                    } label: {
                        HStack(spacing: 12) {
                            if isProcessingPayment {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            } else {
                                Image(systemName: "gift.fill")
                            }
                            Text(isProcessingPayment ? "Processing..." : "Send Gift - $\(Int(selectedAmount))")
                        }
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(isProcessingPayment ? .gray : .orange)
                        )
                        .shadow(color: .orange.opacity(0.3), radius: 8, y: 4)
                    }
                    .disabled(isProcessingPayment || selectedAmount <= 0)

                    Text("Secure payment processed via Apple Pay")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Gift Request")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(.secondary)
                }
            }
        }
        .alert("Gift Sent! 🎉", isPresented: $showingPaymentResult) {
            Button("Done") {
                dismiss()
            }
        } message: {
            if paymentCompleted {
                Text("Your gift of $\(Int(selectedAmount)) has been sent to \(senderName). May this gesture bring joy and strengthen your bond! 🙏")
            } else if let error = paymentError {
                Text("Payment failed: \(error)")
            }
        }
    }

    private func processPayment() {
        isProcessingPayment = true

        // Present Apple Pay
        PaymentCoordinator.shared.presentApplePay(
            amountMinor: Int64(selectedAmount * 100), // Convert to cents
            currencyCode: "USD"
        ) { [self] result in
            DispatchQueue.main.async {
                self.isProcessingPayment = false

                switch result {
                case .success:
                    // Process the gift payment
                    self.paymentCompleted = true

                    // Send confirmation to the original sender
                    Task {
                        await self.sendGiftConfirmation()
                    }

                case .failure(let error):
                    self.paymentError = error.localizedDescription
                }

                self.showingPaymentResult = true
            }
        }
    }

    private func sendGiftConfirmation() async {
        // Create gift receipt
        let giftReceipt = GiftReceipt(
            id: UUID(),
            tokenId: UUID(uuidString: rakhiId) ?? UUID(),
            senderName: recipientName, // The gift recipient becomes the sender of money
            receiverName: senderName,  // The rakhi sender becomes the receiver of money
            amountMinor: Int64(selectedAmount * 100),
            currency: "USD",
            status: .completed,
            timestamp: Date(),
            transactionId: UUID().uuidString,
            culturalContext: [
                "occasion": "raksha_bandhan",
                "significance": culturalSignificance,
                "blessing": "May this gift bring prosperity and joy to both giver and receiver"
            ]
        )

        // In a real app, this would send to backend
        print("Gift confirmation sent: \(giftReceipt)")

        // Could also send notification to original sender via push notification or in-app message
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct AmountButton: View {
    let amount: Double
    let isSelected: Bool
    let isSuggested: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            VStack(spacing: 8) {
                Text("$\(Int(amount))")
                    .font(.system(.title3, design: .rounded).weight(.bold))
                    .foregroundStyle(.primary)

                if isSuggested {
                    Text("Suggested")
                        .font(.system(.caption2, design: .rounded).weight(.medium))
                        .foregroundStyle(.orange)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.orange.opacity(0.15), in: Capsule())
                } else if amount % 10 == 1 {
                    Text("Auspicious")
                        .font(.system(.caption2, design: .rounded).weight(.medium))
                        .foregroundStyle(.green)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.green.opacity(0.15), in: Capsule())
                }
            }
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? .orange.opacity(0.1) : Color(.systemGray6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? .orange : .clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    PaymentRequestView(
        rakhiId: UUID().uuidString,
        senderName: "Priya Sharma",
        recipientName: "Kiran Gokal",
        suggestedAmount: 101,
        culturalSignificance: "raksha_bandhan"
    )
}
