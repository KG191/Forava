import SwiftUI
import Combine

// MARK: - Intelligent Gift Amount Selection View

struct IntelligentGiftAmountView: View {
    @StateObject private var paymentService = ComprehensivePaymentService.shared
    @StateObject private var localization = SimpleLocalizationService.shared
    @State private var selectedAmount: Decimal = 251
    @State private var customAmount: String = ""
    @State private var showingCustomInput = false
    @State private var showingPaymentTips = false
    @State private var selectedSuggestion: PaymentSuggestion?
    @State private var animateSelection = false

    let recipient: PaymentRecipient
    let rakhi: GeneratedRakhi
    let onAmountSelected: (Decimal) -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header Section
                    HeaderSection(recipient: recipient, rakhi: rakhi)

                    // Cultural Amount Suggestions
                    CulturalSuggestionsSection(
                        suggestions: paymentService.suggestedAmounts,
                        selectedAmount: $selectedAmount,
                        selectedSuggestion: $selectedSuggestion,
                        animateSelection: $animateSelection
                    )

                    // Relationship-Based Suggestions
                    RelationshipSuggestionsSection(
                        relationship: recipient.relationship,
                        selectedAmount: $selectedAmount,
                        selectedSuggestion: $selectedSuggestion
                    )

                    // Custom Amount Section
CustomAmountSection(
    amount: selectedAmount,
    onAmountChange: { amount in
        selectedAmount = amount
        validateAndSetCustomAmount(String(describing: amount))
    }
)                    // Cultural Validation
                    if selectedAmount > 0 {
                        CulturalValidationSection(
                            amount: selectedAmount,
                            recipient: recipient
                        )
                    }

                    // Payment Tips
                    CulturalPaymentTipsSection(
                        showingPaymentTips: $showingPaymentTips
                    )
                }
                .padding(16)
            }
            .navigationTitle("Gift Amount")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.secondary)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Continue") {
                        onAmountSelected(selectedAmount)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(selectedAmount <= 0)
                }
            }
        }
        .onAppear {
            loadInitialSuggestions()
        }
    }

    private func loadInitialSuggestions() {
        // Set default based on relationship
        selectedAmount = recipient.relationship.traditionalAmount

        // Load relationship-specific suggestions
        let relationshipSuggestions = paymentService.getAuspiciousAmountForRelationship(recipient.relationship)
        if let firstSuggestion = relationshipSuggestions.first {
            selectedSuggestion = firstSuggestion
        }
    }

    private func validateAndSetCustomAmount(_ amountText: String) {
        guard let amount = Decimal(string: amountText), amount > 0 else {
            selectedAmount = 0
            return
        }
        selectedAmount = amount
        selectedSuggestion = nil
    }
    
    private func hideKeyboard() {
        // Use a safer approach to dismiss keyboard
        DispatchQueue.main.async {
            UIApplication.shared.windows.first?.endEditing(true)
        }
    }
}

// MARK: - Header Section

struct HeaderSection: View {
    let recipient: PaymentRecipient
    let rakhi: GeneratedRakhi

    var body: some View {
        VStack(spacing: 16) {
            // Rakhi Preview
            RakhiPreviewCard(rakhi: rakhi, isSmall: true)

            // Recipient Info
            VStack(spacing: 8) {
                Text("Gift for \(recipient.name)")
                    .font(.title2.weight(.semibold))
                    .foregroundColor(.primary)

                Text(recipient.relationship.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(.orange.opacity(0.1), in: Capsule())
            }
        }
    }
}

typealias RakhiPreviewCard = CommonViews.RakhiPreviewCard

// MARK: - Cultural Suggestions Section

struct CulturalSuggestionsSection: View {
    let suggestions: [PaymentSuggestion]
    @Binding var selectedAmount: Decimal
    @Binding var selectedSuggestion: PaymentSuggestion?
    @Binding var animateSelection: Bool

    private var culturalSuggestions: [PaymentSuggestion] {
        suggestions.filter { $0.category != .personalized }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(
                title: "Cultural Suggestions",
                subtitle: "Traditional auspicious amounts",
                icon: "star.circle.fill",
                color: .orange
            )

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(culturalSuggestions) { suggestion in
                    SuggestionCard(
                        suggestion: suggestion,
                        isSelected: selectedSuggestion?.id == suggestion.id,
                        onSelect: {
                            selectSuggestion(suggestion)
                        }
                    )
                }
            }
        }
    }

    private func selectSuggestion(_ suggestion: PaymentSuggestion) {
        selectedAmount = suggestion.amount
        selectedSuggestion = suggestion

        // Animate selection
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            animateSelection.toggle()
        }
    }
}

// MARK: - Relationship Suggestions Section

struct RelationshipSuggestionsSection: View {
    let relationship: FamilyRelationship
    @Binding var selectedAmount: Decimal
    @Binding var selectedSuggestion: PaymentSuggestion?
    @StateObject private var paymentService = ComprehensivePaymentService.shared

    private var relationshipSuggestions: [PaymentSuggestion] {
        paymentService.getAuspiciousAmountForRelationship(relationship)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(
                title: "For \(relationship.rawValue)",
                subtitle: "Traditionally appropriate amounts",
                icon: "heart.circle.fill",
                color: .pink
            )

            VStack(spacing: 8) {
                ForEach(relationshipSuggestions) { suggestion in
                    RelationshipSuggestionRow(
                        suggestion: suggestion,
                        isSelected: selectedSuggestion?.id == suggestion.id,
                        onSelect: {
                            selectedAmount = suggestion.amount
                            selectedSuggestion = suggestion
                        }
                    )
                }
            }
        }
    }
}

struct RelationshipSuggestionRow: View {
    let suggestion: PaymentSuggestion
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("$\(suggestion.amount as NSDecimalNumber)")
                            .font(.headline.weight(.semibold))
                            .foregroundColor(.primary)

                        Spacer()

                        CulturalSignificanceBadge(significance: suggestion.culturalSignificance)
                    }

                    Text(suggestion.reasoning)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title3)
                }
            }
            .padding(12)
            .background(
                isSelected ? .green.opacity(0.1) : .regularMaterial,
                in: RoundedRectangle(cornerRadius: 12)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? .green : .clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Custom Amount Section

typealias CustomAmountSection = CommonViews.CustomAmountSection

// MARK: - Cultural Validation Section

struct CulturalValidationSection: View {
    let amount: Decimal
    let recipient: PaymentRecipient
    @StateObject private var paymentService = ComprehensivePaymentService.shared

    private var culturalContext: CulturalPaymentContext {
        CulturalPaymentContext(
            festival: getCurrentFestival(),
            relationship: recipient.relationship,
            regionPreference: SimpleLocalizationService.shared.currentLanguage == .hindi ? .indian : .global,
            auspiciousTiming: isAuspiciousTime()
        )
    }

    private var validation: CulturalValidation {
        paymentService.validateCulturalAmountAppropriatenesss(amount, context: culturalContext)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(
                title: "Cultural Analysis",
                subtitle: "Traditional appropriateness",
                icon: validation.isAppropriate ? "checkmark.seal.fill" : "exclamationmark.triangle.fill",
                color: validation.isAppropriate ? .green : .orange
            )

            // Cultural Score
            HStack {
                Text("Cultural Score")
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.primary)

                Spacer()

                Text("\(validation.culturalScore, specifier: "%.1f")/1.0")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(scoreColor(validation.culturalScore))
            }
            .padding(12)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))

            // Warnings
            if !validation.warnings.isEmpty {
                ForEach(validation.warnings, id: \.self) { warning in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                            .font(.caption)

                        Text(warning)
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(.orange.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
                }
            }

            // Suggestions
            if !validation.suggestions.isEmpty {
                ForEach(validation.suggestions, id: \.self) { suggestion in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(.blue)
                            .font(.caption)

                        Text(suggestion)
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
                }
            }
        }
    }

    private func scoreColor(_ score: Double) -> Color {
        if score >= 0.8 { return .green }
        if score >= 0.6 { return .orange }
        return .red
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

// MARK: - Cultural Payment Tips Section

struct CulturalPaymentTipsSection: View {
    @Binding var showingPaymentTips: Bool
    @StateObject private var paymentService = ComprehensivePaymentService.shared

    private var paymentTips: [CulturalPaymentTip] {
        paymentService.getCulturalPaymentTips()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Button {
                withAnimation(.spring()) {
                    showingPaymentTips.toggle()
                }
            } label: {
                SectionHeader(
                    title: "Cultural Guidelines",
                    subtitle: showingPaymentTips ? "Tap to hide" : "Tap to learn more",
                    icon: showingPaymentTips ? "chevron.up.circle.fill" : "info.circle.fill",
                    color: .purple
                )
            }
            .buttonStyle(.plain)

            if showingPaymentTips {
                VStack(spacing: 12) {
                    ForEach(paymentTips, id: \.title) { tip in
                        PaymentTipCard(tip: tip)
                    }
                }
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .slide),
                    removal: .opacity
                ))
            }
        }
    }
}

struct PaymentTipCard: View {
    let tip: CulturalPaymentTip

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: tip.icon)
                .foregroundColor(.purple)
                .font(.title3)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 4) {
                Text(tip.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.primary)

                Text(tip.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
        .padding(12)
        .background(.purple.opacity(0.05), in: RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Supporting Views

typealias SectionHeader = CommonViews.SectionHeader

struct SuggestionCard: View {
    let suggestion: PaymentSuggestion
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            VStack(spacing: 8) {
                Text("$\(suggestion.amount as NSDecimalNumber)")
                    .font(.title2.weight(.bold))
                    .foregroundColor(.primary)

                CulturalSignificanceBadge(significance: suggestion.culturalSignificance)

                Text(suggestion.reasoning)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .padding(12)
            .frame(minHeight: 100)
            .background(
                isSelected ? .green.opacity(0.1) : .regularMaterial,
                in: RoundedRectangle(cornerRadius: 12)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? .green : .clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

struct CulturalSignificanceBadge: View {
    let significance: CulturalSignificance

    private var badgeColor: Color {
        switch significance {
        case .highest: return .green
        case .high: return .orange
        case .medium: return .blue
        case .low: return .gray
        }
    }

    private var badgeText: String {
        switch significance {
        case .highest: return "Most Auspicious"
        case .high: return "Highly Auspicious"
        case .medium: return "Auspicious"
        case .low: return "Appropriate"
        }
    }

    var body: some View {
        Text(badgeText)
            .font(.caption2.weight(.medium))
            .foregroundColor(badgeColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(badgeColor.opacity(0.15), in: Capsule())
    }
}

#Preview {
    IntelligentGiftAmountView(
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
        rakhi: GeneratedRakhi(
            id: UUID(),
            designSpec: RakhiDesignSpec(
                genre: .traditional,
                elements: [],
                colorPalette: .traditional
            ),
            mainImage: AIImageResult(imageData: Data(), timestamp: Date()),
            prompt: AIPrompt(positive: "Traditional rakhi design"),
            createdAt: Date(),
            culturalScore: 0.85
        ),
        onAmountSelected: { _ in }
    )
}
