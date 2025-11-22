import SwiftUI
import StoreKit

/// Subscription management view accessible from Settings
/// Shows tier comparison, current status, and purchase options
struct SubscriptionView: View {
    @ObservedObject var paymentService: ComprehensivePaymentService
    @Environment(\.dismiss) var dismiss

    @State private var selectedTier: SubscriptionTier = .annual
    @State private var isLoading = false
    @State private var showingPurchaseAlert = false
    @State private var purchaseAlertMessage = ""
    @State private var showingPrivacyPolicy = false
    @State private var showingTermsOfService = false

    var body: some View {
        NavigationView {
            ZStack {
                // Dark background gradient (matches Settings)
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color(hex: "#1a1a1a"), location: 0.0),
                        .init(color: Color(hex: "#2d2d2d"), location: 1.0)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // Current Status Section
                        currentStatusSection

                        // Subscription Tiers
                        VStack(spacing: 16) {
                            Text("Choose Your Plan")
                                .font(.system(.title2, design: .rounded).weight(.bold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 20)

                            // Free Tier
                            TierCard(
                                tier: .free,
                                isCurrentTier: paymentService.getSubscriptionTier() == .free,
                                isSelected: selectedTier == .free,
                                onSelect: {
                                    selectedTier = .free
                                }
                            )
                            .padding(.horizontal, 20)

                            // Monthly Tier
                            TierCard(
                                tier: .monthly,
                                isCurrentTier: paymentService.getSubscriptionTier() == .monthly,
                                isSelected: selectedTier == .monthly,
                                onSelect: {
                                    selectedTier = .monthly
                                }
                            )
                            .padding(.horizontal, 20)

                            // Annual Tier
                            TierCard(
                                tier: .annual,
                                isCurrentTier: paymentService.getSubscriptionTier() == .annual,
                                isSelected: selectedTier == .annual,
                                onSelect: {
                                    selectedTier = .annual
                                }
                            )
                            .padding(.horizontal, 20)
                        }

                        // Subscribe Button (only show if not already subscribed)
                        if !paymentService.isSubscribed && selectedTier != .free {
                            subscribeButton
                                .padding(.horizontal, 20)
                                .padding(.top, 8)
                        }

                        // Manage Subscription (only show if subscribed)
                        if paymentService.isSubscribed {
                            manageSubscriptionButton
                                .padding(.horizontal, 20)
                        }

                        // Credits Section
                        creditsSection
                            .padding(.horizontal, 20)

                        // Restore Purchases
                        restoreButton
                            .padding(.horizontal, 20)

                        // Footer
                        footerSection
                            .padding(.horizontal, 20)
                            .padding(.bottom, 40)
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Subscription")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.system(.body, design: .rounded).weight(.medium))
                }
            }
            .alert("Subscription", isPresented: $showingPurchaseAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(purchaseAlertMessage)
            }
            .overlay {
                if isLoading {
                    LoadingOverlay()
                }
            }
            .scrollContentBackground(.hidden)
            .preferredColorScheme(.dark)
            .sheet(isPresented: $showingPrivacyPolicy) {
                PrivacyPolicyView()
            }
            .sheet(isPresented: $showingTermsOfService) {
                TermsOfServiceView()
            }
        }
    }

    // MARK: - Current Status Section
    @ViewBuilder
    private var currentStatusSection: some View {
        VStack(spacing: 12) {
            // Status Badge
            HStack(spacing: 8) {
                Image(systemName: paymentService.isSubscribed ? "crown.fill" : "sparkles")
                    .font(.title2)
                    .foregroundStyle(
                        paymentService.isSubscribed ? Color(hex: "#FFD700") : Color(hex: "#FF8A00")
                    )

                Text(paymentService.getSubscriptionTier().displayName)
                    .font(.system(.title2, design: .rounded).weight(.bold))
                    .foregroundStyle(.white)
            }

            // Status Details
            if paymentService.isSubscribed {
                if let expirationDate = paymentService.subscriptionStatus.expirationDate {
                    Text("Renews \(formattedDate(expirationDate))")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(.white.opacity(0.7))
                } else {
                    Text("Active Subscription")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(.white.opacity(0.7))
                }
            } else {
                Text("Free Plan • 3 generations lifetime")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.white.opacity(0.7))
            }

            // Credits Count
            HStack(spacing: 6) {
                Image(systemName: "sparkles")
                    .font(.caption)
                    .foregroundStyle(Color(hex: "#FF8A00"))

                Text("\(paymentService.getAvailableCreditsCount()) regeneration credits")
                    .font(.system(.caption, design: .rounded).weight(.medium))
                    .foregroundStyle(.white.opacity(0.7))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Color(hex: "#FF8A00").opacity(0.1))
            )
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
        .padding(.horizontal, 20)
    }

    // MARK: - Subscribe Button
    @ViewBuilder
    private var subscribeButton: some View {
        Button {
            subscribe()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "crown.fill")
                    .font(.headline)

                Text("Subscribe to \(selectedTier.displayName)")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [Color(hex: "#FF8A00"), Color(hex: "#E05A00")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(14)
            .shadow(color: Color(hex: "#FF8A00").opacity(0.3), radius: 12, y: 6)
        }
        .disabled(isLoading)
    }

    // MARK: - Manage Subscription Button
    @ViewBuilder
    private var manageSubscriptionButton: some View {
        Button {
            openSubscriptionManagement()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "gearshape.fill")
                    .font(.subheadline)

                Text("Manage Subscription")
                    .font(.system(.subheadline, design: .rounded).weight(.medium))
            }
            .foregroundStyle(Color(hex: "#FF8A00"))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: "#FF8A00").opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(hex: "#FF8A00"), lineWidth: 1)
                    )
            )
        }
    }

    // MARK: - Credits Section
    @ViewBuilder
    private var creditsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Need More Credits?")
                .font(.system(.headline, design: .rounded).weight(.semibold))
                .foregroundStyle(.white)

            Text("Purchase credit packs for image regeneration. Credits never expire.")
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(.white.opacity(0.7))

            // Credit packs grid
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                MiniCreditPackCard(product: .credits10, paymentService: paymentService)
                MiniCreditPackCard(product: .credits25, paymentService: paymentService)
                MiniCreditPackCard(product: .credits50, paymentService: paymentService)
                MiniCreditPackCard(product: .credits100, paymentService: paymentService)
            }
            .padding(.top, 8)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
    }

    // MARK: - Restore Button
    @ViewBuilder
    private var restoreButton: some View {
        Button {
            restore()
        } label: {
            Text("Restore Purchases")
                .font(.system(.subheadline, design: .rounded).weight(.medium))
                .foregroundStyle(Color(hex: "#FF8A00"))
        }
        .disabled(isLoading)
    }

    // MARK: - Footer
    @ViewBuilder
    private var footerSection: some View {
        VStack(spacing: 8) {
            Text("All subscriptions include unlimited AI generations, no watermarks, and priority support.")
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)

            HStack(spacing: 16) {
                Button("Terms of Service") {
                    showingTermsOfService = true
                }
                .font(.system(.caption2, design: .rounded))
                .foregroundStyle(.white.opacity(0.7))

                Button("Privacy Policy") {
                    showingPrivacyPolicy = true
                }
                .font(.system(.caption2, design: .rounded))
                .foregroundStyle(.white.opacity(0.7))
            }
        }
    }

    // MARK: - Actions
    private func subscribe() {
        guard selectedTier != .free else { return }

        isLoading = true

        Task {
            let product: IAPProduct = selectedTier == .monthly ? .monthlySubscription : .annualSubscription
            let success = await paymentService.subscribe(product)

            await MainActor.run {
                isLoading = false
                if success {
                    purchaseAlertMessage = "Successfully subscribed to \(selectedTier.displayName)!"
                    showingPurchaseAlert = true
                } else if let error = paymentService.errorMessage {
                    purchaseAlertMessage = error
                    showingPurchaseAlert = true
                }
            }
        }
    }

    private func openSubscriptionManagement() {
        // Deep link to iOS Settings > Subscriptions
        if let url = URL(string: "https://apps.apple.com/account/subscriptions") {
            UIApplication.shared.open(url)
        }
    }

    private func restore() {
        isLoading = true

        Task {
            let success = await paymentService.restorePurchases()

            await MainActor.run {
                isLoading = false
                if success {
                    purchaseAlertMessage = "Purchases restored successfully!"
                    showingPurchaseAlert = true
                } else {
                    purchaseAlertMessage = "No previous purchases found"
                    showingPurchaseAlert = true
                }
            }
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

// MARK: - Supporting Views

struct TierCard: View {
    let tier: SubscriptionTier
    let isCurrentTier: Bool
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button {
            if !isCurrentTier {
                onSelect()
            }
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 8) {
                            Text(tier.displayName)
                                .font(.system(.title3, design: .rounded).weight(.bold))
                                .foregroundStyle(.white)

                            if let badge = tier.badge {
                                Text(badge)
                                    .font(.system(.caption2, design: .rounded).weight(.bold))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(Capsule().fill(tier.primaryColor))
                            }

                            if isCurrentTier {
                                Text("CURRENT")
                                    .font(.system(.caption2, design: .rounded).weight(.bold))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(Capsule().fill(.green))
                            }
                        }

                        // Price
                        HStack(spacing: 4) {
                            if tier == .annual, let annualPrice = tier.annualPrice {
                                Text("$\(String(format: "%.2f", annualPrice))/year")
                                    .font(.system(.headline, design: .rounded).weight(.semibold))
                                    .foregroundStyle(Color(hex: "#FF8A00"))

                                Text("($\(String(format: "%.2f", tier.monthlyPrice))/month)")
                                    .font(.caption)
                                    .foregroundStyle(.white.opacity(0.7))
                            } else if tier == .monthly {
                                Text("$\(String(format: "%.2f", tier.monthlyPrice))/month")
                                    .font(.system(.headline, design: .rounded).weight(.semibold))
                                    .foregroundStyle(Color(hex: "#FF8A00"))
                            } else {
                                Text("Free")
                                    .font(.system(.headline, design: .rounded).weight(.semibold))
                                    .foregroundStyle(.white.opacity(0.7))
                            }
                        }
                    }

                    Spacer()

                    // Selection indicator
                    if isSelected && !isCurrentTier {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(Color(hex: "#FF8A00"))
                            .font(.title2)
                    }
                }

                Divider()

                // Features
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(tier.features, id: \.self) { feature in
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.caption)
                                .foregroundStyle(tier == .free ? .gray : .green)

                            Text(feature)
                                .font(.system(.caption, design: .rounded))
                                .foregroundStyle(.white.opacity(0.7))
                        }
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(
                                isCurrentTier ? .green :
                                isSelected ? Color(hex: "#FF8A00") :
                                Color.white.opacity(0.2),
                                lineWidth: isCurrentTier || isSelected ? 2 : 1
                            )
                    )
            )
        }
        .disabled(isCurrentTier)
    }
}

struct MiniCreditPackCard: View {
    let product: IAPProduct
    @ObservedObject var paymentService: ComprehensivePaymentService

    @State private var isPurchasing = false

    var body: some View {
        Button {
            Task {
                isPurchasing = true
                let success = await paymentService.purchaseCreditPack(product)
                isPurchasing = false

                if success {
                    print("✅ Credit pack purchased successfully")
                } else {
                    print("❌ Credit pack purchase failed")
                }
            }
        } label: {
            VStack(spacing: 8) {
                // Credits count
                Text("\(product.creditCount ?? 0)")
                    .font(.system(.title2, design: .rounded).weight(.bold))
                    .foregroundStyle(Color(hex: "#FF8A00"))

                Text("credits")
                    .font(.system(.caption2, design: .rounded))
                    .foregroundStyle(.white.opacity(0.7))

                // Price
                Text("$\(String(format: "%.2f", NSDecimalNumber(decimal: product.basePrice).doubleValue))")
                    .font(.system(.subheadline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.white)

                // Savings badge
                if product.discountPercentage > 0 {
                    Text("Save \(product.discountPercentage)%")
                        .font(.system(.caption2, design: .rounded).weight(.bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(.green))
                }

                // Loading indicator
                if isPurchasing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .disabled(isPurchasing)
    }
}

#Preview {
    SubscriptionView(paymentService: ComprehensivePaymentService.shared)
}
