import SwiftUI
import StoreKit

// MARK: - Phase 4: Subscription Management View
// Complete subscription purchase and management interface per best practices

struct SubscriptionManagementView: View {
    @EnvironmentObject private var subscriptionManager: SubscriptionManager
    @Environment(\.dismiss) private var dismiss

    @State private var selectedTier: SubscriptionTier = .monthlyPremium
    @State private var showingRestoreConfirmation = false
    @State private var showingCancellationAlert = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    currentPlanSection
                    subscriptionTiersSection
                    featuresComparisonSection
                    usageStatsSection
                    if subscriptionManager.isPremiumSubscriber {
                        managementSection
                    }
                }
                .padding()
            }
            .navigationTitle("Subscription")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(.secondary)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Restore") {
                        restorePurchases()
                    }
                    .foregroundStyle(.blue)
                    .disabled(subscriptionManager.isLoading)
                }
            }
        }
        .alert("Purchases Restored", isPresented: $showingRestoreConfirmation) {
            Button("OK") { }
        } message: {
            Text("Your previous purchases have been restored successfully.")
        }
        .alert("Cancel Subscription", isPresented: $showingCancellationAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Manage Subscriptions") {
                openSubscriptionManagement()
            }
        } message: {
            Text("To cancel your subscription, you'll need to manage it through your App Store account settings.")
        }
    }

    // MARK: - Header Section

    private var headerSection: some View {
        VStack(spacing: 16) {
            Image(systemName: subscriptionManager.isPremiumSubscriber ? "crown.fill" : "sparkles")
                .font(.system(size: 40))
                .foregroundStyle(subscriptionManager.isPremiumSubscriber ? .yellow : .orange)

            Text(subscriptionManager.isPremiumSubscriber ? "Premium Active" : "Upgrade to Premium")
                .font(.title2.weight(.bold))

            Text(subscriptionManager.isPremiumSubscriber ?
                 "You have unlimited access to all cultural occasions and features." :
                 "Unlock unlimited generations and premium cultural experiences.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
        )
    }

    // MARK: - Current Plan Section

    private var currentPlanSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Current Plan")
                    .font(.headline)
                Spacer()
                if subscriptionManager.isPremiumSubscriber {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundStyle(.green)
                }
            }

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(subscriptionManager.currentSubscription.displayName)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(subscriptionManager.isPremiumSubscriber ? .green : .primary)

                    Text(subscriptionManager.currentSubscription.price)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if subscriptionManager.isPremiumSubscriber {
                    Button("Manage") {
                        showingCancellationAlert = true
                    }
                    .font(.caption.weight(.medium))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.orange.opacity(0.2), in: Capsule())
                    .foregroundStyle(.orange)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(subscriptionManager.isPremiumSubscriber ? .green : .gray.opacity(0.3))
        )
    }

    // MARK: - Subscription Tiers Section

    private var subscriptionTiersSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Choose Your Plan")
                .font(.headline)

            VStack(spacing: 12) {
                ForEach([SubscriptionTier.monthlyPremium, .annualPremium], id: \.self) { tier in
                    subscriptionTierCard(tier)
                }
            }
        }
    }

    private func subscriptionTierCard(_ tier: SubscriptionTier) -> some View {
        let isSelected = selectedTier == tier
        let isCurrentPlan = subscriptionManager.currentSubscription == tier
        let isAnnual = tier == .annualPremium

        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(tier.displayName)
                            .font(.title3.weight(.semibold))

                        if isAnnual {
                            Text("SAVE 33%")
                                .font(.caption2.weight(.bold))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(.green, in: Capsule())
                                .foregroundStyle(.white)
                        }
                    }

                    Text(tier.price)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.primary)

                    if isAnnual {
                        Text("$3.33 per month billed annually")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                if isCurrentPlan {
                    Text("CURRENT")
                        .font(.caption.weight(.bold))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.green, in: Capsule())
                        .foregroundStyle(.white)
                } else if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.orange)
                        .font(.title2)
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                ForEach(tier.benefits, id: \.self) { benefit in
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.green)
                            .font(.caption)

                        Text(benefit)
                            .font(.subheadline)
                            .foregroundStyle(.primary)

                        Spacer()
                    }
                }
            }

            if !isCurrentPlan && !subscriptionManager.isPremiumSubscriber {
                Button {
                    selectedTier = tier
                    purchaseSubscription(tier)
                } label: {
                    HStack {
                        if subscriptionManager.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        }

                        Text(subscriptionManager.isLoading ? "Processing..." : "Subscribe")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.orange, in: RoundedRectangle(cornerRadius: 12))
                    .foregroundStyle(.white)
                }
                .disabled(subscriptionManager.isLoading)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(isSelected ? .orange.opacity(0.05) : Color(.systemGray6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isCurrentPlan ? .green : (isSelected ? .orange : .clear), lineWidth: 2)
        )
        .onTapGesture {
            if !isCurrentPlan {
                selectedTier = tier
            }
        }
    }

    // MARK: - Features Comparison Section

    private var featuresComparisonSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Feature Comparison")
                .font(.headline)

            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Feature")
                        .font(.subheadline.weight(.medium))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("Free")
                        .font(.subheadline.weight(.medium))
                        .frame(width: 60)

                    Text("Premium")
                        .font(.subheadline.weight(.medium))
                        .frame(width: 60)
                }
                .padding()
                .background(Color(.systemGray5))

                // Features
                ForEach(comparisonFeatures, id: \.name) { feature in
                    HStack {
                        Text(feature.name)
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        featureIcon(feature.freeVersion)
                            .frame(width: 60)

                        featureIcon(feature.premiumVersion)
                            .frame(width: 60)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.gray.opacity(0.3))
            )
        }
    }

    private func featureIcon(_ available: FeatureAvailability) -> some View {
        switch available {
        case .yes:
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
        case .no:
            Image(systemName: "xmark.circle.fill")
                .foregroundStyle(.red.opacity(0.6))
        case .limited(let text):
            Text(text)
                .font(.caption2)
                .foregroundStyle(.orange)
        }
    }

    // MARK: - Usage Stats Section

    private var usageStatsSection: some View {
        let stats = subscriptionManager.getUsageStats()

        return VStack(alignment: .leading, spacing: 16) {
            Text("Your Usage")
                .font(.headline)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
                usageStatCard("This Month", "\(stats.generationsThisMonth)", .blue)
                usageStatCard("All Time", "\(stats.totalGenerations)", .green)
                usageStatCard("Credits", "\(stats.creditsRemaining)", .orange)
            }
        }
    }

    private func usageStatCard(_ title: String, _ value: String, _ color: Color) -> some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title2.weight(.bold))
                .foregroundStyle(color)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Management Section

    private var managementSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Subscription Management")
                .font(.headline)

            VStack(spacing: 12) {
                managementButton("Manage Subscription", "gear", openSubscriptionManagement)
                managementButton("Download Receipt", "doc.text", downloadReceipt)
                managementButton("Contact Support", "questionmark.circle", contactSupport)
            }
        }
    }

    private func managementButton(_ title: String, _ icon: String, _ action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(.blue)
                    .frame(width: 20)

                Text(title)
                    .font(.body)
                    .foregroundStyle(.primary)

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
            .padding()
            .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Actions

    private func purchaseSubscription(_ tier: SubscriptionTier) {
        Task {
            await subscriptionManager.purchaseSubscription(tier: tier)
        }
    }

    private func restorePurchases() {
        Task {
            await subscriptionManager.restorePurchases()
            showingRestoreConfirmation = true
        }
    }

    private func openSubscriptionManagement() {
        if let url = URL(string: "https://apps.apple.com/account/subscriptions") {
            UIApplication.shared.open(url)
        }
    }

    private func downloadReceipt() {
        // Implement receipt download functionality
        print("Download receipt requested")
    }

    private func contactSupport() {
        // Implement support contact functionality
        print("Contact support requested")
    }

    // MARK: - Data

    private let comparisonFeatures: [ComparisonFeature] = [
        ComparisonFeature(name: "Monthly Generations", freeVersion: .limited("1"), premiumVersion: .yes),
        ComparisonFeature(name: "Cultural Occasions", freeVersion: .limited("3"), premiumVersion: .yes),
        ComparisonFeature(name: "Premium Agents", freeVersion: .no, premiumVersion: .yes),
        ComparisonFeature(name: "Advanced Validation", freeVersion: .no, premiumVersion: .yes),
        ComparisonFeature(name: "Priority Support", freeVersion: .no, premiumVersion: .yes),
        ComparisonFeature(name: "Early Access", freeVersion: .no, premiumVersion: .yes)
    ]
}

// MARK: - Supporting Models

struct ComparisonFeature {
    let name: String
    let freeVersion: FeatureAvailability
    let premiumVersion: FeatureAvailability
}

enum FeatureAvailability {
    case yes
    case no
    case limited(String)
}

#Preview {
    NavigationStack {
        SubscriptionManagementView()
            .environmentObject(SubscriptionManager.shared)
    }
}
