import SwiftUI
import StoreKit

/// Hard paywall shown after free tier exhausted
struct PaywallView: View {
    @ObservedObject var paymentService: ComprehensivePaymentService
    @ObservedObject var quotaManager: GenerationQuotaManager
    @Environment(\.dismiss) var dismiss

    @State private var selectedTab: PaywallTab = .credits
    @State private var selectedCreditPack: IAPProduct = .credits25
    @State private var selectedSubscription: IAPProduct = .annualSubscription
    @State private var isLoading = false
    @State private var showingRestoreAlert = false
    @State private var restoreMessage = ""

    enum PaywallTab: String, CaseIterable {
        case credits = "Credit Packs"
        case subscription = "Subscription"
    }

    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color(hex: "#FF8A00").opacity(0.1), .white],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        headerSection

                        // Tab selector
                        tabSelector

                        // Content based on selected tab
                        if selectedTab == .credits {
                            creditPacksSection
                        } else {
                            subscriptionSection
                        }

                        // Purchase button
                        purchaseButton

                        // Restore purchases
                        restoreButton

                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Unlock Forava")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // No dismiss button - hard paywall
            }
            .alert("Restore Purchases", isPresented: $showingRestoreAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(restoreMessage)
            }
            .overlay {
                if isLoading {
                    LoadingOverlay()
                }
            }
        }
    }

    // MARK: - Header
    @ViewBuilder
    private var headerSection: some View {
        VStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color(hex: "#FF8A00").opacity(0.2))
                    .frame(width: 100, height: 100)

                Image(systemName: "sparkles")
                    .font(.system(size: 50, weight: .semibold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "#FF8A00"), Color(hex: "#E05A00")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }

            // Title
            Text("You've Used All Free Generations")
                .font(.system(.title2, design: .rounded).weight(.bold))
                .multilineTextAlignment(.center)

            // Subtitle
            Text("Continue celebrating with unlimited cultural gifts")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            // Stats
            HStack(spacing: 30) {
                StatBadge(icon: "calendar", title: "12", subtitle: "Cultural Events")
                StatBadge(icon: "wand.and.stars", title: "AI", subtitle: "Personalized")
                StatBadge(icon: "heart.fill", title: "100K+", subtitle: "Users")
            }
            .padding(.top, 8)
        }
    }

    // MARK: - Tab Selector
    @ViewBuilder
    private var tabSelector: some View {
        HStack(spacing: 0) {
            ForEach(PaywallTab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        selectedTab = tab
                    }
                } label: {
                    VStack(spacing: 8) {
                        Text(tab.rawValue)
                            .font(.system(.subheadline, design: .rounded).weight(.semibold))
                            .foregroundStyle(selectedTab == tab ? Color(hex: "#FF8A00") : .secondary)

                        // Indicator
                        Rectangle()
                            .fill(selectedTab == tab ? Color(hex: "#FF8A00") : Color.clear)
                            .frame(height: 3)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.thinMaterial)
        )
    }

    // MARK: - Credit Packs Section
    @ViewBuilder
    private var creditPacksSection: some View {
        VStack(spacing: 12) {
            Text("Pay once, use anytime")
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            ForEach([IAPProduct.credits10, .credits25, .credits50, .credits100], id: \.self) { pack in
                CreditPackCard(
                    product: pack,
                    isSelected: selectedCreditPack == pack,
                    onSelect: {
                        selectedCreditPack = pack
                    }
                )
            }
        }
    }

    // MARK: - Subscription Section
    @ViewBuilder
    private var subscriptionSection: some View {
        VStack(spacing: 12) {
            Text("Unlimited generations, cancel anytime")
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            SubscriptionCard(
                product: .monthlySubscription,
                tier: .monthly,
                isSelected: selectedSubscription == .monthlySubscription,
                onSelect: {
                    selectedSubscription = .monthlySubscription
                }
            )

            SubscriptionCard(
                product: .annualSubscription,
                tier: .annual,
                isSelected: selectedSubscription == .annualSubscription,
                onSelect: {
                    selectedSubscription = .annualSubscription
                }
            )
        }
    }

    // MARK: - Purchase Button
    @ViewBuilder
    private var purchaseButton: some View {
        Button {
            purchase()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "cart.fill")
                    .font(.headline)

                if selectedTab == .credits {
                    Text("Buy \(selectedCreditPack.displayName)")
                } else {
                    Text("Subscribe Now")
                }
            }
            .font(.system(.headline, design: .rounded).weight(.semibold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
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

    // MARK: - Actions
    private func purchase() {
        isLoading = true

        Task {
            let success: Bool
            if selectedTab == .credits {
                // Purchase credit pack
                success = await purchaseCreditPack(selectedCreditPack)
            } else {
                // Subscribe
                success = await subscribe(selectedSubscription)
            }

            await MainActor.run {
                isLoading = false
                if success {
                    dismiss()
                }
            }
        }
    }

    private func purchaseCreditPack(_ product: IAPProduct) async -> Bool {
        // Implementation will use RegenerationIAPManager
        // For now, placeholder
        print("💳 Purchase credit pack: \(product.rawValue)")
        return await paymentService.purchaseCreditPack(product)
    }

    private func subscribe(_ product: IAPProduct) async -> Bool {
        // Implementation will use SubscriptionManager
        print("💳 Subscribe: \(product.rawValue)")
        return await paymentService.subscribe(product)
    }

    private func restore() {
        isLoading = true

        Task {
            let success = await paymentService.restorePurchases()

            await MainActor.run {
                isLoading = false
                if success {
                    restoreMessage = "Purchases restored successfully!"
                    showingRestoreAlert = true
                    // Check if user now has access
                    if paymentService.isSubscribed || paymentService.hasRegenerationCredits() {
                        dismiss()
                    }
                } else {
                    restoreMessage = "No previous purchases found"
                    showingRestoreAlert = true
                }
            }
        }
    }
}

// MARK: - Supporting Views

struct StatBadge: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(.title3, design: .rounded))
                .foregroundStyle(Color(hex: "#FF8A00"))

            Text(title)
                .font(.system(.headline, design: .rounded).weight(.bold))

            Text(subtitle)
                .font(.system(.caption2, design: .rounded))
                .foregroundStyle(.secondary)
        }
    }
}

struct CreditPackCard: View {
    let product: IAPProduct
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button {
            onSelect()
        } label: {
            HStack(spacing: 16) {
                // Icon + Credits
                VStack(spacing: 4) {
                    Image(systemName: "sparkles")
                        .font(.title2)
                        .foregroundStyle(Color(hex: "#FF8A00"))

                    Text("\(product.creditCount ?? 0)")
                        .font(.system(.title3, design: .rounded).weight(.bold))
                        .foregroundStyle(.primary)

                    Text("credits")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                .frame(width: 70)

                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(product.displayName)
                            .font(.system(.headline, design: .rounded).weight(.semibold))
                            .foregroundStyle(.primary)

                        if product.isPopular {
                            Text("POPULAR")
                                .font(.system(.caption2, design: .rounded).weight(.bold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Capsule().fill(Color(hex: "#FF8A00")))
                        }
                    }

                    Text("$\(String(format: "%.2f", NSDecimalNumber(decimal: product.perCreditCost ?? 0).doubleValue))/credit")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    if product.discountPercentage > 0 {
                        Text("Save \(product.discountPercentage)%")
                            .font(.caption)
                            .foregroundStyle(.green)
                    }
                }

                Spacer()

                // Price
                Text("$\(String(format: "%.2f", NSDecimalNumber(decimal: product.basePrice).doubleValue))")
                    .font(.system(.title3, design: .rounded).weight(.bold))
                    .foregroundStyle(Color(hex: "#FF8A00"))

                // Selection indicator
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(Color(hex: "#FF8A00"))
                        .font(.title2)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isSelected ? Color(hex: "#FF8A00").opacity(0.1) : Color(.systemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(isSelected ? Color(hex: "#FF8A00") : Color.gray.opacity(0.3), lineWidth: isSelected ? 2 : 1)
                    )
            )
        }
    }
}

struct SubscriptionCard: View {
    let product: IAPProduct
    let tier: SubscriptionTier
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button {
            onSelect()
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(tier.displayName)
                        .font(.system(.title3, design: .rounded).weight(.bold))
                        .foregroundStyle(.primary)

                    if let badge = tier.badge {
                        Text(badge)
                            .font(.system(.caption2, design: .rounded).weight(.bold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Capsule().fill(tier.primaryColor))
                    }

                    Spacer()

                    // Price
                    VStack(alignment: .trailing, spacing: 2) {
                        if tier == .annual {
                            Text("$\(String(format: "%.2f", tier.annualPrice ?? 0))/year")
                                .font(.system(.title3, design: .rounded).weight(.bold))
                                .foregroundStyle(Color(hex: "#FF8A00"))

                            Text("$4.99/month")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        } else {
                            Text("$\(String(format: "%.2f", tier.monthlyPrice))/month")
                                .font(.system(.title3, design: .rounded).weight(.bold))
                                .foregroundStyle(Color(hex: "#FF8A00"))
                        }
                    }

                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(Color(hex: "#FF8A00"))
                            .font(.title2)
                    }
                }

                // Features
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(tier.features, id: \.self) { feature in
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark")
                                .font(.caption)
                                .foregroundStyle(.green)

                            Text(feature)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(.top, 4)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isSelected ? Color(hex: "#FF8A00").opacity(0.1) : Color(.systemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(isSelected ? Color(hex: "#FF8A00") : Color.gray.opacity(0.3), lineWidth: isSelected ? 2 : 1)
                    )
            )
        }
    }
}

struct LoadingOverlay: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.white)

                Text("Processing...")
                    .font(.system(.subheadline, design: .rounded).weight(.medium))
                    .foregroundStyle(.white)
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
            )
        }
    }
}

#Preview {
    PaywallView(
        paymentService: ComprehensivePaymentService.shared,
        quotaManager: GenerationQuotaManager.shared
    )
}
