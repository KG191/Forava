import SwiftUI

struct EnhancedPaymentOptionsView: View {
    let context: CulturalPaymentContext
    @State private var selectedOption: PaymentOption?
    @State private var showingCustomAmount = false
    @State private var customAmount: String = ""

    var body: some View {
        VStack(spacing: 16) {
            // Header with cultural context
            CulturalContextHeader(context: context)

            // Payment Options Grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                ForEach(context.paymentOptions) { option in
                    PaymentOptionCard(
                        option: option,
                        isSelected: selectedOption?.id == option.id
                    ) {
                        selectedOption = option
                    }
                }
            }

            // Custom amount option
            CustomAmountSection(
                isShowing: $showingCustomAmount,
                customAmount: $customAmount
            )

            // Cultural significance explanation
            if let selected = selectedOption {
                CulturalSignificanceView(
                    amount: selected.amount,
                    justification: selected.culturalJustification
                )
            }

            // Action buttons
            ActionButtonsView(
                selectedOption: selectedOption,
                onProceed: handlePaymentProceed
            )
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
        .onAppear {
            // Pre-select the recommended option
            selectedOption = context.paymentOptions.first { $0.priority == .primary }
        }
    }

    private func handlePaymentProceed() {
        guard let option = selectedOption else { return }

        // In production, this would integrate with Apple Pay
        print("Processing payment of ₹\(option.amount) for \(context.relationshipContext.displayName)")
    }
}

// Duplicate CulturalContextHeader removed - using the main definition elsewhere

struct PaymentOptionCard: View {
    let option: PaymentOption
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                // Amount and priority
                VStack(spacing: 4) {
                    HStack {
                        Image(systemName: option.icon)
                            .font(.system(.title2))
                            .foregroundStyle(option.priority.color)

                        Spacer()

                        if option.priority == .primary {
                            Text("RECOMMENDED")
                                .font(.system(.caption2, design: .rounded).weight(.bold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(.orange, in: Capsule())
                        }
                    }

                    Text("₹\(option.amount)")
                        .font(.system(.title, design: .rounded).weight(.bold))
                        .foregroundStyle(.primary)

                    Text(option.priority.displayName)
                        .font(.system(.caption, design: .rounded).weight(.medium))
                        .foregroundStyle(option.priority.color)
                }

                // Cultural justification
                Text(option.culturalJustification)
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)

                // Benefits (if any)
                if !option.benefits.isEmpty {
                    VStack(alignment: .leading, spacing: 2) {
                        ForEach(Array(option.benefits.prefix(2)), id: \.self) { benefit in
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(.green)
                                    .frame(width: 4, height: 4)

                                Text(benefit)
                                    .font(.system(.caption2, design: .rounded))
                                    .foregroundStyle(.green)

                                Spacer()
                            }
                        }
                    }
                }
            }
            .padding(16)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? option.priority.color : .clear, lineWidth: 2)
            }
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.spring(response: 0.3), value: isSelected)
        }
        .buttonStyle(.plain)
    }
}

struct CustomAmountSection: View {
    @Binding var isShowing: Bool
    @Binding var customAmount: String

    var body: some View {
        VStack(spacing: 12) {
            Button(action: { isShowing.toggle() }) {
                HStack {
                    Image(systemName: "plus.circle")
                        .font(.system(.subheadline))
                        .foregroundStyle(.orange)

                    Text("Enter Custom Amount")
                        .font(.system(.subheadline, design: .rounded).weight(.medium))
                        .foregroundStyle(.orange)

                    Spacer()

                    Image(systemName: isShowing ? "chevron.up" : "chevron.down")
                        .font(.system(.caption))
                        .foregroundStyle(.orange)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(.orange.opacity(0.1), in: RoundedRectangle(cornerRadius: 10))
            }

            if isShowing {
                VStack(spacing: 12) {
                    HStack(spacing: 8) {
                        Text("₹")
                            .font(.system(.title2, design: .rounded).weight(.bold))
                            .foregroundStyle(.primary)

                        TextField("Enter amount", text: $customAmount)
                            .font(.system(.title2, design: .rounded).weight(.semibold))
                            .keyboardType(.numberPad)
                            .textFieldStyle(.plain)

                        Button("Set") {
                            setCustomAmount()
                        }
                        .font(.system(.subheadline, design: .rounded).weight(.medium))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.orange, in: Capsule())
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 10))

                    // Auspicious number suggestions
                    AuspiciousNumberSuggestions { amount in
                        customAmount = "\(amount)"
                    }
                }
                .transition(.slide.combined(with: .opacity))
            }
        }
    }

    private func setCustomAmount() {
        // Validate and process custom amount
        guard let amount = Int(customAmount), amount > 0 else { return }

        // Round to nearest auspicious number (ending in 1)
        let auspiciousAmount = ((amount + 9) / 10) * 10 + 1
        customAmount = "\(auspiciousAmount)"

        withAnimation {
            isShowing = false
        }
    }
}

struct AuspiciousNumberSuggestions: View {
    let onAmountSelected: (Int) -> Void

    private let suggestedAmounts = [11, 21, 31, 51, 71, 101, 111, 151, 201, 251]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Auspicious Amounts")
                .font(.system(.caption, design: .rounded).weight(.medium))
                .foregroundStyle(.secondary)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 6) {
                ForEach(suggestedAmounts, id: \.self) { amount in
                    Button("₹\(amount)") {
                        onAmountSelected(amount)
                    }
                    .font(.system(.caption, design: .rounded).weight(.medium))
                    .foregroundStyle(.orange)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.orange.opacity(0.1), in: Capsule())
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(12)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
    }
}

struct CulturalSignificanceView: View {
    let amount: Int
    let justification: String

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "star.circle.fill")
                    .font(.system(.subheadline))
                    .foregroundStyle(.gold)

                Text("Cultural Significance")
                    .font(.system(.subheadline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                Spacer()
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(justification)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.primary)

                Text("Ending in 1 ensures divine blessings and good fortune according to Indian tradition")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .background(.gold.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(.gold.opacity(0.3), lineWidth: 1)
        }
    }
}

struct ActionButtonsView: View {
    let selectedOption: PaymentOption?
    let onProceed: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            if let option = selectedOption {
                Button(action: onProceed) {
                    HStack {
                        Image(systemName: "creditcard.fill")
                            .font(.system(.subheadline))

                        Text("Pay ₹\(option.amount) with Apple Pay")
                            .font(.system(.body, design: .rounded).weight(.semibold))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(.orange, in: RoundedRectangle(cornerRadius: 12))
                }

                // Alternative payment methods
                HStack(spacing: 12) {
                    Button("UPI") {
                        // UPI payment
                    }
                    .font(.system(.subheadline, design: .rounded).weight(.medium))
                    .foregroundStyle(.blue)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))

                    Button("Card") {
                        // Card payment
                    }
                    .font(.system(.subheadline, design: .rounded).weight(.medium))
                    .foregroundStyle(.green)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(.green.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))

                    Button("Wallet") {
                        // Digital wallet
                    }
                    .font(.system(.subheadline, design: .rounded).weight(.medium))
                    .foregroundStyle(.purple)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(.purple.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
                }

            } else {
                Text("Select a payment option to continue")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color(.systemGray5), in: RoundedRectangle(cornerRadius: 12))
            }
        }
    }
}

#Preview {
    EnhancedPaymentOptionsView(
        context: CulturalPaymentContext(
            recommendedAmount: 51,
            alternativeAmounts: [101, 201, 501],
            paymentOptions: [
                PaymentOption(
                    amount: 51,
                    priority: .primary,
                    culturalJustification: "Classic auspicious amount, perfect for sibling relationships",
                    benefits: ["Personalized message", "Basic animation"],
                    icon: "heart.circle.fill"
                ),
                PaymentOption(
                    amount: 101,
                    priority: .secondary,
                    culturalJustification: "Premium blessing amount with extra spiritual significance",
                    benefits: ["Premium animations", "High-quality generation", "Extended storage"],
                    icon: "star.circle.fill"
                ),
                PaymentOption(
                    amount: 201,
                    priority: .alternative,
                    culturalJustification: "Generous amount showing deep affection and respect",
                    benefits: ["Multiple animations", "Priority processing", "Lifetime storage"],
                    icon: "crown.fill"
                ),
                PaymentOption(
                    amount: 501,
                    priority: .alternative,
                    culturalJustification: "Grand gesture amount for special relationships",
                    benefits: ["Exclusive elements", "All features", "Premium support"],
                    icon: "sparkles"
                )
            ],
            culturalSignificance: "51 is considered highly auspicious, representing the 51 Shakti Peethas in Hindu tradition",
            relationshipContext: .brother,
            complexityJustification: "Rich design with high cultural authenticity"
        )
    )
    .padding()
    .background(Color(.systemGroupedBackground))
}
